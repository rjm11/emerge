# EMERGE Core Modules Implementation Plan

## Executive Summary

We need two foundational modules that will be the bedrock of the entire EMERGE system. These modules must be lightweight, rock-solid, and maintain the golden rule while handling the unique challenge of GMCP data access.

## The Solution: Reactive State Pattern

I've solved the GMCP golden rule dilemma with a **Reactive State Pattern**:

```lua
-- Module asks for data (maintains golden rule)
raiseEvent("emerge.query", "gmcp.vitals")

-- GMCP responds with data
raiseEvent("emerge.response", "gmcp.vitals", {hp=1000, mp=500})

-- OR module subscribes once for live updates
raiseEvent("emerge.subscribe", "gmcp.vitals", "my_module")
-- Then receives automatic updates when data changes
```

This maintains architectural purity while providing the performance combat modules need.

## Module 1: emerge-core-events

**Purpose**: Enhanced event system that adds request/response patterns to Mudlet's raiseEvent()

### Key Features:
- **Request/Response Pattern**: Modules can query and receive data via events
- **Event History**: Track last N events for debugging
- **Performance Monitoring**: Track event timing and bottlenecks
- **Subscription System**: Modules can subscribe to specific event patterns
- **Event Batching**: Combine rapid events for performance
- **Error Boundaries**: Isolate handler errors

### Core API:
```lua
-- Basic events (wraps raiseEvent)
emerge.events.emit(event, ...)
emerge.events.on(event, handler)
emerge.events.off(event, handler)

-- Request/Response pattern
emerge.events.request(query, callback)
emerge.events.respond(query, handler)

-- Subscriptions
emerge.events.subscribe(pattern, handler)
emerge.events.unsubscribe(pattern, handler)

-- Debugging
emerge.events.history(count)
emerge.events.stats()
```

### Why This Module First:
- Everything else depends on it
- Establishes the communication patterns
- Enables golden rule compliance for all future modules
- Small, focused, testable

## Module 2: emerge-gmcp

**Purpose**: Handle all GMCP data and provide it to other modules via events

### Key Features:
- **Reactive State**: GMCP data stored in reactive state
- **Query System**: Modules request current data via events
- **Subscriptions**: Modules subscribe to specific GMCP paths
- **Smart Updates**: Only emit events when data actually changes
- **Data Validation**: Ensure GMCP data integrity
- **Performance Optimized**: Batch updates, minimize event spam

### Core API (via events only):
```lua
-- Query current data
raiseEvent("emerge.query", "gmcp.vitals.hp")
-- Receive: emerge.response, "gmcp.vitals.hp", 1000

-- Subscribe to changes
raiseEvent("emerge.subscribe", "gmcp.vitals", "my_module")
-- Receive: emerge.gmcp.vitals.changed, {hp=1000, mp=500}

-- Get all GMCP data
raiseEvent("emerge.query", "gmcp.*")
-- Receive: emerge.response, "gmcp.*", {entire_gmcp_table}
```

### GMCP Data Flow:
1. Mudlet receives GMCP data
2. emerge-gmcp validates and stores in reactive state
3. emerge-gmcp checks for actual changes
4. If changed, emit targeted events to subscribers
5. Modules receive only the updates they care about

## Module 3: emerge-core-state (Optional)

**Purpose**: Centralized state management with persistence

### Features:
- **Reactive State**: State changes trigger events
- **Persistence**: Save/load from JSON
- **State Queries**: Get state via events
- **Atomic Updates**: Ensure consistency
- **History Tracking**: Undo/redo capability

### Why Separate from GMCP:
- GMCP is read-only game data
- State is read/write module data
- Different persistence needs
- Different update patterns

## Implementation Order

### Week 1: emerge-core-events
1. Day 1-2: Core event system with request/response
2. Day 3-4: Subscription system and batching
3. Day 5: Testing and performance optimization

### Week 2: emerge-gmcp  
1. Day 1-2: GMCP handler and reactive state
2. Day 3-4: Query system and subscriptions
3. Day 5: Testing with real GMCP data

### Week 3: Integration
1. Update emerge-manager to use new events
2. Update test module to demonstrate patterns
3. Create combat module template
4. Performance testing under load

## Performance Targets

- Event emission: <0.1ms
- Event handling: <1ms per handler
- GMCP update to event: <2ms
- Query response: <1ms
- Memory overhead: <5MB for core modules
- Support 1000+ events/second

## Design Principles

1. **No Direct Calls**: Everything through events
2. **Fail Gracefully**: Errors don't crash system
3. **Observable**: All actions can be monitored
4. **Predictable**: Same input = same output
5. **Minimal Dependencies**: Core modules are self-contained

## Testing Strategy

Each module needs:
- Unit tests for all functions
- Integration tests for event flows
- Performance benchmarks
- Load testing (1000+ events/sec)
- Error handling validation
- Memory leak detection

## Golden Rule Compliance

The Reactive State Pattern ensures 100% golden rule compliance:

```lua
-- WRONG (Direct call - breaks golden rule)
local hp = emerge.gmcp.getVital("hp")

-- RIGHT (Event-based - maintains golden rule)
raiseEvent("emerge.query", "gmcp.vitals.hp")
-- Handler receives response via event
```

## Risk Mitigation

1. **Performance Risk**: Mitigated by batching and smart updates
2. **Complexity Risk**: Keep modules focused and single-purpose
3. **Integration Risk**: Extensive testing with real GMCP data
4. **Maintenance Risk**: Comprehensive documentation and examples

## Success Criteria

✅ Zero direct module calls
✅ All GMCP data accessible via events
✅ <5ms total latency for combat actions
✅ Handles 1000+ events/second
✅ Works with all Mudlet versions 4.10+
✅ Clear migration path from old systems

## Next Step: Build emerge-core-events

This is our foundation. Once we have the enhanced event system, everything else becomes much easier. The module should be ~500 lines of well-tested, documented code that we never need to touch again.

Ready to start building?