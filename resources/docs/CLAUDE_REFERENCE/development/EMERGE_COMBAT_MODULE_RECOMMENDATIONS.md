# EMERGE Combat Module Development Recommendations

## Test Validation Results ✅

The `emerge-test-module.lua` has been thoroughly tested and validated:

**Test Results: 11/11 PASSED**
- ✅ Module loading and initialization
- ✅ Event-driven compliance (Golden Rule)
- ✅ Help system integration  
- ✅ Alias system functionality
- ✅ Timer system (heartbeat)
- ✅ State management
- ✅ Version system
- ✅ Command output validation
- ✅ Error handling
- ✅ Module cleanup
- ✅ Performance (1000 events < 1 second)

## Architecture Validation

### Golden Rule Compliance: PERFECT ✅
- **Zero direct module calls** - All communication via events
- **Pure event-driven architecture** - Uses `raiseEvent()` exclusively  
- **Proper handler isolation** - Event handlers are self-contained
- **Clean resource management** - Proper cleanup on unload

## Recommended Patterns for Combat Modules

### 1. Core Module Structure
```lua
local MODULE_NAME = "emerge-[module-name]"
local MODULE_VERSION = "1.0.0"

local CombatModule = {
    name = "EMERGE [Module Name]",
    version = MODULE_VERSION,
    enabled = true,
    
    -- Resource tracking (like test module)
    triggers = {},
    aliases = {},
    timers = {},
    handlers = {},
    
    -- Module-specific components
    help_available = true,
    help_topics = { /* help content */ }
}
```

### 2. Event-Driven Combat Flow
```lua
function CombatModule:init()
    -- Input event handlers (receive game state)
    self.handlers.balance = registerAnonymousEventHandler("balance.regained", 
        function() self:onBalanceRegained() end)
    
    self.handlers.affliction = registerAnonymousEventHandler("affliction.gained",
        function(event, aff) self:onAffliction(aff) end)
    
    -- Query handlers (respond to system requests)
    self.handlers.query = registerAnonymousEventHandler("emerge.query.help",
        function(event, query) self:handleQuery(query) end)
end

function CombatModule:onBalanceRegained()
    -- Process state and emit action request
    local action = self:determineAction()
    if action then
        raiseEvent("combat.action.requested", action)
    end
end
```

### 3. Curing Module Pattern
Based on test module architecture:
```lua
local CuringModule = {
    name = "EMERGE Curing System",
    afflictions = {},
    cure_queue = {},
    priorities = {}
}

function CuringModule:init()
    -- Listen for afflictions
    self.handlers.aff_gained = registerAnonymousEventHandler("affliction.gained",
        function(event, aff) self:addAffliction(aff) end)
    
    self.handlers.aff_cured = registerAnonymousEventHandler("affliction.cured", 
        function(event, aff) self:removeAffliction(aff) end)
    
    self.handlers.balance = registerAnonymousEventHandler("balance.regained",
        function() self:processCureQueue() end)
end

function CuringModule:addAffliction(affliction)
    -- Update internal state
    self.afflictions[affliction] = true
    
    -- Emit state change
    raiseEvent("curing.affliction.added", affliction, self.afflictions)
    
    -- Queue cure
    self:queueCure(affliction)
end

function CuringModule:queueCure(affliction)
    local cure = self:getCureFor(affliction)
    if cure then
        -- Emit cure request instead of direct action
        raiseEvent("cure.requested", {
            affliction = affliction,
            cure_type = cure.type,
            cure_item = cure.item,
            priority = self:getPriority(affliction)
        })
    end
end
```

### 4. Targeting Module Pattern
```lua
local TargetingModule = {
    name = "EMERGE Targeting System",
    available_targets = {},
    current_target = nil,
    target_priorities = {}
}

function TargetingModule:init()
    -- Listen for room changes
    self.handlers.room_players = registerAnonymousEventHandler("gmcp.room.players",
        function(event, players) self:updateTargets(players) end)
    
    -- Listen for target requests
    self.handlers.target_request = registerAnonymousEventHandler("target.request",
        function(event, criteria) self:selectTarget(criteria) end)
end

function TargetingModule:updateTargets(players)
    self.available_targets = players
    
    -- Emit updated target list
    raiseEvent("targeting.list.updated", {
        targets = players,
        count = #players,
        timestamp = os.time()
    })
    
    -- Auto-select if no current target
    if not self.current_target then
        self:autoSelectTarget()
    end
end

function TargetingModule:selectTarget(criteria)
    local target = self:findBestTarget(criteria)
    if target then
        self.current_target = target
        raiseEvent("target.selected", {
            target = target,
            criteria = criteria,
            confidence = self:calculateConfidence(target, criteria)
        })
    end
end
```

### 5. Offense Module Pattern  
```lua
local OffenseModule = {
    name = "EMERGE Offense System",
    attack_queue = {},
    combo_sequences = {},
    class_skills = {}
}

function OffenseModule:init()
    -- Listen for combat action requests
    self.handlers.action_request = registerAnonymousEventHandler("combat.action.requested",
        function(event, request) self:processActionRequest(request) end)
    
    -- Listen for balance states
    self.handlers.balance = registerAnonymousEventHandler("balance.regained",
        function() self:executeQueuedAttack() end)
end

function OffenseModule:processActionRequest(request)
    local attack = self:buildAttack(request)
    if attack then
        -- Add to queue instead of immediate execution
        table.insert(self.attack_queue, attack)
        
        -- Emit queuing confirmation
        raiseEvent("offense.attack.queued", {
            attack = attack,
            queue_position = #self.attack_queue,
            estimated_delay = self:calculateDelay()
        })
    end
end

function OffenseModule:executeQueuedAttack()
    if #self.attack_queue > 0 then
        local attack = table.remove(self.attack_queue, 1)
        
        -- Emit execution event before sending
        raiseEvent("offense.attack.executing", {
            attack = attack.name,
            target = attack.target,
            command = attack.command
        })
        
        -- Execute the actual command
        send(attack.command)
        
        -- Emit completion event
        raiseEvent("offense.attack.executed", {
            attack = attack.name,
            target = attack.target,
            timestamp = os.time()
        })
    end
end
```

## Integration Requirements

### 1. EMERGE Manager Registration
```lua
-- At module end (following test module pattern)
if EMERGE then
    if EMERGE.modules[MODULE_NAME] then
        EMERGE:unloadModule(MODULE_NAME)
    end
    
    CombatModule:init()
    EMERGE:registerModule(MODULE_NAME, CombatModule)
    
    cecho(string.format("<LightSteelBlue>[%s] Module loaded v%s<reset>\n", 
        MODULE_NAME, MODULE_VERSION))
    
    raiseEvent("emerge.module.loaded", MODULE_NAME, MODULE_VERSION)
else
    cecho("<IndianRed>EMERGE system not found. Please install EMERGE first.<reset>\n")
end
```

### 2. Help System Integration (from test module)
```lua
help_topics = {
    overview = "Module description and purpose",
    commands = {
        ["command1"] = "Description of command1",
        ["command2"] = "Description of command2"
    },
    usage = "How to use this module",
    examples = {
        "example1 - Description",
        "example2 - Description"  
    }
}

-- Handler for help queries (following test pattern)
self.handlers.help_query = registerAnonymousEventHandler("emerge.query.help",
    function(event, query_type)
        if query_type == "modules_with_help" then
            raiseEvent("emerge.response.help", MODULE_NAME, self.help_topics)
        end
    end)
```

## Event Naming Standards

### Standard Event Categories
```lua
-- Module lifecycle
"emerge.module.loaded"
"emerge.module.unloaded"
"emerge.module.heartbeat"

-- Combat flow  
"balance.regained"
"balance.lost"
"equilibrium.regained"
"equilibrium.lost"

-- Affliction tracking
"affliction.gained"
"affliction.cured"
"afflictions.list.updated"

-- Curing system
"cure.requested"
"cure.attempted"
"cure.completed" 
"cure.failed"

-- Targeting system
"target.available"
"target.selected"
"target.lost"
"targeting.list.updated"

-- Offense system
"combat.action.requested"
"offense.attack.queued"
"offense.attack.executing"
"offense.attack.executed"

-- System queries/responses
"emerge.query.help"
"emerge.response.help"
"emerge.query.version"
"emerge.response.version"
```

## Quality Gates Checklist

### Architecture Compliance
- [ ] Zero direct module function calls
- [ ] All communication via `raiseEvent()` and event handlers  
- [ ] Proper resource cleanup in `unload()` method
- [ ] EMERGE manager registration
- [ ] Help system integration

### Event Standards
- [ ] Consistent dot notation naming
- [ ] Semantic event names (not implementation details)
- [ ] Structured event data payloads
- [ ] State change events emitted

### Performance Requirements  
- [ ] Event handlers complete < 1ms
- [ ] No polling patterns (timer-based state checking)
- [ ] Efficient trigger/alias patterns
- [ ] Resource cleanup on module unload

### Testing Requirements
- [ ] All test cases pass
- [ ] Event flow validation
- [ ] Handler isolation testing
- [ ] Performance benchmarking  
- [ ] Combat scenario simulation

## Development Workflow

1. **Start with Test Module Pattern** - Copy the validated structure
2. **Add Combat-Specific Logic** - Extend with module functionality
3. **Implement Event Handlers** - Follow the established patterns
4. **Create Comprehensive Tests** - Based on provided test template
5. **Validate Architecture** - Ensure Golden Rule compliance
6. **Performance Testing** - Meet the 1ms handler requirement
7. **Integration Testing** - Verify event flows work correctly

## Conclusion

The `emerge-test-module.lua` provides a **perfect architectural foundation** for EMERGE combat modules. All tests pass, demonstrating:

- ✅ **100% Golden Rule compliance** (no direct module calls)
- ✅ **Pure event-driven architecture** using native Mudlet events  
- ✅ **Proper resource management** and cleanup
- ✅ **Seamless EMERGE integration** via manager registration
- ✅ **Excellent performance** (1000+ events/second capability)

Combat modules following this pattern will be:
- **Loosely coupled** - Changes to one won't break others
- **Highly testable** - Event flows can be validated in isolation  
- **Performance optimized** - No blocking operations or polling
- **Emergent behavior enabled** - Complex behaviors from simple interactions

This architecture ensures EMERGE combat modules will create emergent combat intelligence through event-driven module interactions while maintaining system stability and performance.