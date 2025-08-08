# EMERGE Combat Condition Checking Design

## The Problem

Traditional MUD combat systems check all conditions every balance:
```lua
-- Rime/Legacy approach (inefficient)
on_balance_recovery:
    if has_paralysis_lock() then
        execute_lock_sequence()
    elseif has_damage_kill() then
        execute_damage_sequence()
    elseif has_momentum_setup() then
        continue_momentum()
    -- ... hundreds more checks
```

This approach is inefficient and doesn't scale well.

## EMERGE's Solution: Reactive Condition Checking

Instead of polling, we check conditions when relevant state changes occur:

### 1. State Change Detection

```lua
-- When afflictions change, check for locks
emerge.events:on("affliction.gained", function(target, affliction)
    -- Only check locks when key afflictions are gained
    if LOCK_AFFLICTIONS[affliction] then
        check_lock_conditions(target)
    end
    
    -- Only check momentum when stack changes
    if MOMENTUM_AFFLICTIONS[affliction] then
        update_momentum_state(target)
    end
end)

-- When limb damage changes, check for breaks
emerge.events:on("limb.damaged", function(target, limb, damage)
    -- Only check when crossing break thresholds
    if damage >= BREAK_THRESHOLD then
        check_limb_setup(target)
    end
end)
```

### 2. Condition Registry Pattern

```lua
-- modules/conditions.lua
emerge.conditions = {}
local module = emerge.conditions

-- Registry of all combat conditions
local conditions = {}
local active_checks = {}

-- Register a combat condition
function module.register(name, config)
    conditions[name] = {
        name = name,
        priority = config.priority or 50,
        prerequisites = config.prerequisites or {},
        check = config.check,
        action = config.action,
        events = config.events or {}
    }
    
    -- Subscribe to relevant events
    for _, event in ipairs(config.events) do
        emerge.events:on(event, function(...)
            module.evaluate(name, ...)
        end)
    end
end

-- Example: Paralysis Lock
module.register("paralysis_lock", {
    priority = 100,
    events = {"affliction.gained", "affliction.lost"},
    prerequisites = {"has_balance", "target_present"},
    check = function(target)
        local affs = emerge.afflictions.get(target)
        return affs.paralysis and affs.asthma and 
               (affs.impatience or affs.slickness)
    end,
    action = function(target)
        emerge.events:emit("condition.met", "paralysis_lock", target)
    end
})

-- Example: Limb Setup
module.register("two_leg_break", {
    priority = 90,
    events = {"limb.damaged", "limb.healed"},
    prerequisites = {"has_balance"},
    check = function(target)
        local limbs = emerge.limbs.get(target)
        return limbs.left_leg.broken and limbs.right_leg.broken
    end,
    action = function(target)
        emerge.events:emit("condition.met", "two_leg_break", target)
    end
})
```

### 3. Smart Evaluation

Only evaluate conditions when their dependencies change:

```lua
-- Dependency tracking
local dependency_map = {
    afflictions = {
        paralysis = {"paralysis_lock", "soft_lock", "momentum_3"},
        asthma = {"paralysis_lock", "soft_lock", "kelp_stack"},
        impatience = {"paralysis_lock", "focus_lock", "herb_lock"},
        -- ... etc
    },
    limbs = {
        left_leg = {"two_leg_break", "prone_setup", "vivisect_ready"},
        right_leg = {"two_leg_break", "prone_setup", "vivisect_ready"},
        -- ... etc
    }
}

-- Only check relevant conditions
function module.evaluate_smart(change_type, change_data)
    local affected_conditions = dependency_map[change_type][change_data]
    if not affected_conditions then return end
    
    for _, condition_name in ipairs(affected_conditions) do
        local condition = conditions[condition_name]
        if condition and condition.check(emerge.target.current) then
            condition.action(emerge.target.current)
        end
    end
end
```

### 4. Priority-Based Decision Making

When balance is recovered, check conditions by priority:

```lua
emerge.events:on("balance.recovered", function()
    if not emerge.balance.all() then return end
    
    -- Get all active conditions sorted by priority
    local active = module.get_active_conditions()
    
    -- Execute highest priority action
    for _, condition in ipairs(active) do
        if module.can_execute(condition) then
            emerge.events:emit("combat.execute", condition.name)
            break
        end
    end
end)
```

### 5. Caching and Optimization

Cache expensive calculations:

```lua
-- Cache affliction combinations
local cache = {
    locks = {},
    stacks = {},
    last_update = 0
}

function check_paralysis_lock(target)
    local cache_key = get_affliction_hash(target)
    
    -- Use cached result if recent
    if cache.locks[cache_key] and 
       getEpoch() - cache.last_update < 0.1 then
        return cache.locks[cache_key]
    end
    
    -- Calculate and cache
    local result = calculate_lock(target)
    cache.locks[cache_key] = result
    cache.last_update = getEpoch()
    return result
end
```

## Practical Examples

### 1. Sentinel Petrify Setup

```lua
emerge.conditions.register("petrify_ready", {
    priority = 95,
    events = {"affliction.gained", "limb.damaged"},
    check = function(target)
        local affs = emerge.afflictions.get(target)
        local limbs = emerge.limbs.get(target)
        
        -- Need: 2 broken limbs + key afflictions
        local broken_count = 0
        for _, limb in pairs(limbs) do
            if limb.broken then broken_count = broken_count + 1 end
        end
        
        return broken_count >= 2 and 
               affs.paralysis and 
               (affs.stupidity or affs.confusion)
    end,
    action = function(target)
        emerge.queue.add("petrify", {priority = 100})
    end
})
```

### 2. Momentum Tracking

```lua
-- Track momentum without checking every balance
local momentum = {
    current = 0,
    last_action = 0,
    decay_timer = nil
}

emerge.events:on("affliction.gained", function(target, aff)
    if MOMENTUM_AFFLICTIONS[aff] then
        momentum.current = momentum.current + 1
        momentum.last_action = getEpoch()
        
        -- Reset decay timer
        if momentum.decay_timer then
            killTimer(momentum.decay_timer)
        end
        
        momentum.decay_timer = tempTimer(4, function()
            momentum.current = math.max(0, momentum.current - 1)
            emerge.events:emit("momentum.changed", momentum.current)
        end)
        
        -- Check momentum conditions
        if momentum.current >= 3 then
            emerge.events:emit("condition.met", "momentum_3")
        end
    end
end)
```

### 3. Dynamic Lock Detection

```lua
-- Flexible lock detection system
local lock_definitions = {
    soft_lock = {
        required = {"paralysis", "asthma"},
        one_of = {"impatience", "slickness", "anorexia"}
    },
    hard_lock = {
        required = {"paralysis", "asthma", "slickness", "anorexia", "impatience"},
        blocks_tree = true
    },
    focus_lock = {
        required = {"impatience", "anorexia", "stupidity"},
        one_of = {"epilepsy", "confusion"}
    }
}

function check_locks(target)
    local affs = emerge.afflictions.get(target)
    local met_conditions = {}
    
    for lock_name, requirements in pairs(lock_definitions) do
        local has_lock = true
        
        -- Check required afflictions
        for _, aff in ipairs(requirements.required or {}) do
            if not affs[aff] then
                has_lock = false
                break
            end
        end
        
        -- Check one-of requirements
        if has_lock and requirements.one_of then
            local has_one = false
            for _, aff in ipairs(requirements.one_of) do
                if affs[aff] then
                    has_one = true
                    break
                end
            end
            has_lock = has_lock and has_one
        end
        
        if has_lock then
            table.insert(met_conditions, {
                name = lock_name,
                priority = requirements.blocks_tree and 100 or 90
            })
        end
    end
    
    return met_conditions
end
```

## Performance Benefits

### 1. Event-Driven Efficiency
- Only check conditions when state changes
- No wasted cycles on unchanged state
- O(1) event dispatch vs O(n) condition checking

### 2. Smart Caching
- Cache expensive calculations
- Invalidate only on relevant changes
- Reuse results within same tick

### 3. Priority Pruning
- Stop checking once highest priority found
- Skip conditions with unmet prerequisites
- Batch related checks together

## Integration with Balance Module

```lua
-- The balance module emits events we listen to
emerge.events:on("balance.recovered", function()
    -- This is our trigger to make decisions
    if not emerge.balance.all() then return end
    
    -- Get current conditions
    local conditions = emerge.conditions.get_active()
    
    -- Execute highest priority
    emerge.combat.execute(conditions[1])
end)

-- But we evaluate conditions on state change
emerge.events:on("target.afflictions.changed", function(target)
    -- Re-evaluate relevant conditions
    emerge.conditions.evaluate_for_target(target)
end)
```

## Summary

EMERGE's reactive condition checking:
1. **Evaluates on state change** not on balance recovery
2. **Caches results** to avoid redundant calculations  
3. **Uses dependency tracking** to minimize checks
4. **Prioritizes conditions** for optimal decision making
5. **Scales efficiently** with complexity

This approach means that when balance is recovered, we already know what conditions are met and can act immediately, rather than spending time checking hundreds of conditions.