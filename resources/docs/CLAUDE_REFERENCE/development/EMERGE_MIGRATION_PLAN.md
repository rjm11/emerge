# EMERGE System Migration Plan

## Executive Summary

We are building a NEW EMERGE combat system using a modular, event-driven architecture. The `emerge/emerge-manager.lua` serves as our foundation for dynamic module loading, and all combat functionality will be built as separate modules that communicate exclusively through events.

## Current State

### What We Have:
- **emerge/emerge-manager.lua** - Module loading system with GitHub integration
- **emerge/emerge-test-module.lua** - Working example showing proper event patterns
- **Documentation** - CLAUDE.md describes the OLD vision (needs updating)
- **Resources** - Reference implementations (RIME, SVOF, Legacy)

### What We DON'T Have:
- No legacy code to migrate (starting fresh)
- No core/modules/init.lua structure (described in old docs)
- No existing combat modules

## Architecture Decision

**We are using the manager-based approach with these key principles:**

1. **Module Manager as Foundation** - emerge-manager.lua loads all modules
2. **Event-Driven Communication** - Modules use `raiseEvent()` (Mudlet native)
3. **Golden Rule Enforcement** - NO direct module calls, only events
4. **Dynamic Loading** - Modules can be loaded/unloaded at runtime
5. **GitHub Integration** - Modules can be distributed and updated via GitHub

## Migration Strategy

### Phase 1: Foundation (Week 1)
**Goal:** Establish core infrastructure

1. **Clean Directory Structure:**
   ```
   emerge/
   ├── emerge-manager.lua (keep as-is)
   ├── modules/
   │   ├── core/
   │   │   ├── emerge-core-events.lua
   │   │   ├── emerge-core-state.lua
   │   │   └── emerge-core-config.lua
   │   └── test/
   │       └── emerge-test-module.lua (move here)
   ```

2. **Create Core Event Module:**
   - Enhanced event system built on raiseEvent()
   - Event history and debugging
   - Event namespacing and validation
   - Performance monitoring

3. **Create State Management Module:**
   - Centralized state with event notifications
   - Persistent storage via JSON
   - State watching and subscriptions

4. **Create Configuration Module:**
   - User settings management
   - Module configuration
   - Integration with state module

### Phase 2: Combat Foundation (Week 2)
**Goal:** Basic combat infrastructure

1. **GMCP Module:**
   - Convert GMCP data to events
   - Track vitals, afflictions, balances
   - Room and inventory updates

2. **Combat State Module:**
   - Track combat status (in/out of combat)
   - Enemy tracking
   - Combat statistics

3. **Affliction Tracking Module:**
   - Track player afflictions
   - Priority system
   - Cure tracking

### Phase 3: Combat Systems (Week 3-4)
**Goal:** Core combat functionality

1. **Curing Module:**
   - Priority-based curing
   - Herb/salve/elixir management
   - Cure balance tracking

2. **Defense Module:**
   - Defense management
   - Auto-defense raising
   - Defense stripping detection

3. **Targeting Module:**
   - Target selection and prioritization
   - Target affliction tracking
   - Kill tracking

### Phase 4: Offense Systems (Week 5-6)
**Goal:** Attack automation

1. **Attack Queue Module:**
   - Command queuing
   - Balance management
   - Attack chaining

2. **Class Modules:**
   - Class-specific attack patterns
   - Skill management
   - Kill strategies

### Phase 5: Advanced Features (Week 7+)
**Goal:** Enhanced functionality

1. **Bashing Module:**
   - PvE automation
   - Area navigation
   - Loot management

2. **UI Module:**
   - Status displays
   - Combat timers
   - Visual feedback

## Implementation Order

### Immediate Actions (Today):

1. **Update Documentation:**
   ```bash
   # Update CLAUDE.md to reflect new architecture
   # Archive old documentation
   mkdir -p docs/archive
   mv CLAUDE.md docs/archive/CLAUDE_OLD.md
   ```

2. **Organize Files:**
   ```bash
   # Create module structure
   mkdir -p emerge/modules/core
   mkdir -p emerge/modules/combat
   mkdir -p emerge/modules/test
   
   # Move test module
   mv emerge/emerge-test-module.lua emerge/modules/test/
   ```

3. **Create First Core Module:**
   - Start with emerge-core-events.lua
   - Follow pattern from test module
   - Add enhanced event features

## Module Template

All modules should follow this pattern:

```lua
local MODULE_NAME = "emerge-module-name"
local MODULE_VERSION = "1.0.0"

local Module = {
    name = "Module Display Name",
    version = MODULE_VERSION,
    description = "Module description",
    
    enabled = true,
    triggers = {},
    aliases = {},
    timers = {},
    handlers = {}
}

function Module:init()
    -- Register event handlers
    self.handlers.example = registerAnonymousEventHandler("event.name", 
        function(event, ...) self:handleEvent(...) end)
    
    -- Emit module loaded event
    raiseEvent("emerge.module.loaded", MODULE_NAME, MODULE_VERSION)
end

function Module:unload()
    -- Clean up resources
    for _, id in pairs(self.handlers) do
        killAnonymousEventHandler(id)
    end
    
    raiseEvent("emerge.module.unloaded", MODULE_NAME)
end

-- Module functions here

-- Register with manager
if EMERGE then
    EMERGE:registerModule(MODULE_NAME, Module)
    Module:init()
end

return Module
```

## Testing Strategy

1. **Unit Tests:** Each module gets a test file
2. **Integration Tests:** Test module interactions via events
3. **Performance Tests:** Ensure <1ms event handling
4. **Combat Simulations:** Test combat scenarios

## Success Metrics

- ✅ All modules follow golden rule (no direct calls)
- ✅ Event handling <1ms latency
- ✅ Modules can be loaded/unloaded without breaking system
- ✅ Clear documentation for each module
- ✅ 80%+ test coverage

## Next Steps

1. Review and approve this plan
2. Create emerge-core-events.lua module
3. Update CLAUDE.md documentation
4. Begin implementing Phase 1

## Notes

- The emerge-manager.lua works well for loading - keep it
- Use raiseEvent() for all inter-module communication
- Follow the test module's patterns - they work perfectly
- Focus on loose coupling for emergent behavior