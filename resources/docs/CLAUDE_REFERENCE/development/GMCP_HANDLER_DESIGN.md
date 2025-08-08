# GMCP Handler Module Design

## Overview

The GMCP handler is the critical bridge between Achaea's server data and EMERGE's event-driven architecture. It parses all GMCP messages, detects state changes, and emits granular events that other modules consume.

## Architecture Principles

1. **Zero Dependencies**: The GMCP handler depends only on the event system
2. **State Detection**: Compares previous and current states to detect changes
3. **Granular Events**: Emits specific events for each type of change
4. **Performance First**: Sub-5ms processing time for all GMCP messages
5. **Hot Reloadable**: Maintains state across reloads

## Data Flow Architecture

```mermaid
graph TB
    subgraph "Achaea Server"
        SERVER[GMCP Data Stream]
    end
    
    subgraph "Mudlet Client"
        MUDLET[GMCP Parser]
    end
    
    subgraph "GMCP Handler Module"
        HANDLER[GMCP Event Handler]
        CACHE[(State Cache)]
        PREV[(Previous State)]
        COMPARE[Change Detector]
        EMIT[Event Emitter]
    end
    
    subgraph "Event Bus"
        EVENTS[achaea.events]
    end
    
    subgraph "Consumer Modules"
        CURE[Curing Module]
        TARGET[Targeting Module]
        UI[UI Module]
        DEF[Defense Module]
    end
    
    SERVER -->|GMCP Messages| MUDLET
    MUDLET -->|gmcp.*| HANDLER
    HANDLER --> CACHE
    HANDLER --> PREV
    CACHE --> COMPARE
    PREV --> COMPARE
    COMPARE -->|Changes Detected| EMIT
    EMIT -->|Specific Events| EVENTS
    EVENTS -->|gmcp.vitals.*| UI
    EVENTS -->|gmcp.afflictions.*| CURE
    EVENTS -->|gmcp.target.*| TARGET
    EVENTS -->|gmcp.defences.*| DEF
```

## GMCP Module Mapping

```mermaid
graph LR
    subgraph "GMCP Modules"
        CV[Char.Vitals]
        CA[Char.Afflictions]
        CD[Char.Defences]
        CS[Char.Status]
        RI[Room.Info]
        IT[IRE.Target]
        CC[Comm.Channel]
        CI[Char.Items]
        CR[Char.Rift]
        CT[IRE.Time]
    end
    
    subgraph "Emitted Events"
        EV[gmcp.vitals.*]
        EA[gmcp.afflictions.*]
        ED[gmcp.defences.*]
        ES[gmcp.status.*]
        ER[gmcp.room.*]
        ET[gmcp.target.*]
        EC[gmcp.channel.*]
        EI[gmcp.items.*]
        ERF[gmcp.rift.*]
        ETM[gmcp.time.*]
    end
    
    CV -->|Parse & Compare| EV
    CA -->|Parse & Compare| EA
    CD -->|Parse & Compare| ED
    CS -->|Parse & Compare| ES
    RI -->|Parse & Compare| ER
    IT -->|Parse & Compare| ET
    CC -->|Parse & Compare| EC
    CI -->|Parse & Compare| EI
    CR -->|Parse & Compare| ERF
    CT -->|Parse & Compare| ETM
```

## Internal State Management

```mermaid
graph TD
    subgraph "Cache Structure"
        CACHE[Master Cache]
        V[Vitals]
        A[Afflictions]
        D[Defences]
        R[Room]
        S[Status]
        T[Target]
        I[Items]
        RF[Rift]
        SK[Skills]
        TM[Time]
        
        CACHE --> V
        CACHE --> A
        CACHE --> D
        CACHE --> R
        CACHE --> S
        CACHE --> T
        CACHE --> I
        CACHE --> RF
        CACHE --> SK
        CACHE --> TM
        
        V --> |health, mana, endurance| VD[Vital Data]
        A --> |name → cure, priority| AD[Affliction Map]
        D --> |name → description| DD[Defence Map]
        R --> |num, name, exits| RD[Room Data]
        S --> |class, level, city| SD[Status Data]
    end
```

## Event Processing Pipeline

```mermaid
sequenceDiagram
    participant S as Server
    participant M as Mudlet
    participant H as Handler
    participant C as Cache
    participant P as Previous
    participant D as Detector
    participant E as Event Bus
    participant CM as Consumer Module
    
    S->>M: GMCP Message
    M->>H: gmcp.Char.Vitals
    H->>C: Update Cache
    H->>P: Get Previous State
    P-->>H: Previous Vitals
    H->>D: Compare States
    D-->>H: Changes Detected
    H->>P: Update Previous
    H->>E: emit("gmcp.vitals.health", data)
    E->>CM: Notify Consumers
    CM-->>E: Handle Event
```

## Detailed Event Mappings

### Char.Vitals Events

```mermaid
graph LR
    subgraph "Char.Vitals Data"
        HP[health/maxhealth]
        MP[mana/maxmana]
        EP[endurance/maxendurance]
        WP[willpower/maxwillpower]
        BL[bleeding]
        EQ[equilibrium]
        BAL[balance]
        DEAF[deaf]
        BLIND[blind]
        RAGE[rage/maxrage]
        DEV[devotion/maxdevotion]
    end
    
    subgraph "Emitted Events"
        HE[gmcp.vitals.health]
        ME[gmcp.vitals.mana]
        EE[gmcp.vitals.endurance]
        WE[gmcp.vitals.willpower]
        BE[gmcp.vitals.bleeding]
        BG[gmcp.balance.gained]
        BL2[gmcp.balance.lost]
        RC[gmcp.resource.changed]
    end
    
    HP -->|change detected| HE
    MP -->|change detected| ME
    EP -->|change detected| EE
    WP -->|change detected| WE
    BL -->|change detected| BE
    EQ -->|1→0| BL2
    EQ -->|0→1| BG
    BAL -->|1→0| BL2
    BAL -->|0→1| BG
    RAGE -->|change detected| RC
    DEV -->|change detected| RC
```

### Affliction Processing

```mermaid
stateDiagram-v2
    [*] --> Waiting: Module Init
    Waiting --> Processing: GMCP Received
    
    state Processing {
        [*] --> ParseData: Char.Afflictions.*
        ParseData --> CheckType: Determine Type
        
        CheckType --> ListProcess: .List
        CheckType --> AddProcess: .Add
        CheckType --> RemoveProcess: .Remove
        
        ListProcess --> CompareAll: Compare with Cache
        CompareAll --> EmitList: Emit gmcp.afflictions.list
        CompareAll --> EmitAdded: For each new
        CompareAll --> EmitRemoved: For each missing
        
        AddProcess --> UpdateCache: Add to cache
        UpdateCache --> EmitAdd: Emit gmcp.afflictions.added
        
        RemoveProcess --> RemoveCache: Remove from cache
        RemoveCache --> EmitRemove: Emit gmcp.afflictions.removed
    }
    
    Processing --> Waiting: Complete
```

## Implementation Plan

### Phase 1: Core Structure
```lua
-- 1. Module skeleton with init/shutdown
-- 2. GMCP handler registration
-- 3. Basic cache structure
-- 4. Debug mode support
```

### Phase 2: Vital Processing
```lua
-- 1. Char.Vitals handler
-- 2. Change detection for all vitals
-- 3. Balance state tracking
-- 4. Resource tracking (rage, devotion, etc)
```

### Phase 3: Affliction System
```lua
-- 1. Affliction list/add/remove handlers
-- 2. Affliction cache with cure data
-- 3. Blackout/recklessness handling
-- 4. Affliction query API
```

### Phase 4: Defense System
```lua
-- 1. Defence list/add/remove handlers
-- 2. Defence cache management
-- 3. Defence query API
```

### Phase 5: Room & Movement
```lua
-- 1. Room.Info handler
-- 2. Room.Players handlers
-- 3. Movement detection
-- 4. Area tracking
```

### Phase 6: Extended GMCP
```lua
-- 1. IRE.Target handlers
-- 2. Comm.Channel handler
-- 3. Char.Items handlers
-- 4. Char.Rift handler
-- 5. IRE.Time handler
-- 6. Char.Skills handler
```

### Phase 7: Optimization
```lua
-- 1. Performance profiling
-- 2. Cache optimization
-- 3. Event batching
-- 4. Memory management
```

## Performance Optimization Strategies

```mermaid
graph TD
    subgraph "Optimization Techniques"
        SC[String Caching]
        LZ[Lazy Loading]
        EV[Event Batching]
        CP[Comparison Pruning]
        MT[Metatable Magic]
    end
    
    subgraph "Performance Goals"
        RT[<5ms Response Time]
        MU[<10MB Memory Usage]
        EC[1000+ Events/sec]
    end
    
    SC --> RT
    LZ --> MU
    EV --> EC
    CP --> RT
    MT --> MU
```

## Error Handling Strategy

```mermaid
flowchart TD
    GMCP[GMCP Data Received]
    VALID{Valid Data?}
    PARSE[Parse Data]
    ERROR[Log Error]
    EMIT_ERROR[Emit gmcp.error]
    FALLBACK[Use Previous State]
    PROCESS[Process Normally]
    
    GMCP --> VALID
    VALID -->|Yes| PARSE
    VALID -->|No| ERROR
    ERROR --> EMIT_ERROR
    EMIT_ERROR --> FALLBACK
    PARSE --> PROCESS
    PARSE -->|Exception| ERROR
```

## Testing Strategy

### Unit Tests
1. Test each GMCP handler in isolation
2. Test change detection logic
3. Test cache operations
4. Test error handling

### Integration Tests
1. Test full GMCP message flow
2. Test event emission accuracy
3. Test performance under load
4. Test hot-reload functionality

### Performance Tests
1. Measure handler execution time
2. Measure memory usage
3. Test with rapid GMCP updates
4. Profile bottlenecks

## Module Interface

```lua
-- Public API Summary
achaea.gmcp = {
    -- Lifecycle
    init = function() end,
    shutdown = function() end,
    
    -- Configuration
    debug = function(enabled) end,
    
    -- Vital Queries
    getVital = function(name) end,
    getVitals = function() end,
    
    -- Affliction Queries
    getAffliction = function(name) end,
    getAfflictions = function() end,
    hasAffliction = function(name) end,
    
    -- Defence Queries
    getDefence = function(name) end,
    getDefences = function() end,
    hasDefence = function(name) end,
    
    -- Room Queries
    getRoom = function() end,
    
    -- Status Queries
    getStatus = function() end,
    isBlackout = function() end,
    isReckless = function() end,
    
    -- Target Queries
    getTarget = function() end,
    
    -- Item Queries
    getRift = function() end,
    getItems = function() end,
    
    -- Time Queries
    getTime = function() end,
    
    -- Skill Queries
    getSkills = function() end
}
```

## Example Usage Patterns

### Curing Module Integration
```lua
-- Listen for afflictions
achaea.events:on("gmcp.afflictions.added", function(data)
    local affliction = data.affliction
    local cure = data.cure
    local priority = data.priority
    
    if not achaea.gmcp.isBlackout() then
        achaea.events:emit("curing.queue.add", affliction, {
            cure = cure,
            priority = priority
        })
    end
end)
```

### UI Module Integration
```lua
-- Update health gauge
achaea.events:on("gmcp.vitals.health", function(data)
    local percent = data.percent
    local current = data.current
    local max = data.max
    
    updateHealthGauge(current, max)
    
    if percent < 30 then
        flashHealthWarning()
    end
end)
```

### Defense Module Integration
```lua
-- Track important defenses
local critical_defenses = {"rebounding", "shield", "prismatic"}

achaea.events:on("gmcp.defences.removed", function(data)
    local defence = data.defence
    
    if table.contains(critical_defenses, defence) then
        achaea.events:emit("defense.critical.lost", defence)
    end
end)
```

## Conclusion

The GMCP handler serves as the foundational data layer for the entire EMERGE combat system. By converting raw GMCP data into granular, semantic events, it enables all other modules to operate independently while maintaining perfect synchronization with the game state.

The design prioritizes:
- Performance (sub-5ms processing)
- Modularity (zero dependencies)
- Completeness (all GMCP modules)
- Reliability (error handling)
- Maintainability (clear structure)

This architecture ensures that EMERGE can respond to game events with minimal latency while maintaining clean separation of concerns across all modules.