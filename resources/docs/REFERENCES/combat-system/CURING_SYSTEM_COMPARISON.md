# Comprehensive Curing System Comparison: SVOF vs Legacy vs Rime

## Overview

This document compares the default curing priorities and behaviors of the three most popular Achaea curing systems. Understanding these differences allows EMERGE to adapt its offense to exploit each system's unique weaknesses.

## Key Differences Summary

| Feature | SVOF | Legacy | Rime |
|---------|------|--------|------|
| **Herb Order** | Different defaults | Standard serverside | Customizable |
| **Ignored Affs** | None by default | Blind/deaf/insomnia | Configurable |
| **Tree Usage** | Smart timing | Immediate | Conditional |
| **Priority System** | Numbered priorities | Named groups | Dynamic weights |
| **Adaptation** | Static | Static | Learning capable |

## Detailed Herb Curing Priorities

### Kelp Curing Order

**SVOF Default:**
```lua
-- From lowest number (highest priority) to highest number
lethargy (110)
clumsiness (112)
asthma (checkasthma at 84, actual at 293)
sensitivity (201)
hypochondria (210)
weariness (not explicitly listed in kelp section)
```

**Legacy Default:**
```lua
-- Priority order
asthma
sensitivity  
clumsiness
weariness
hypochondria
healthleech
parasite
```

**Rime Pattern:**
```lua
-- Weighted system
kelp_weights = {
    asthma = 100,      -- Always first
    sensitivity = 80,   -- Damage threat
    clumsiness = 60,    -- Combat hindrance
    weariness = 40,     -- Defense reduction
    hypochondria = 20   -- Minor annoyance
}
```

### Goldenseal Curing Order

**SVOF Default:**
```lua
stupidity (118)
epilepsy (124)
dizziness (136)
shyness (128)
impatience (150)
depression (146)
```

**Legacy Default:**
```lua
stupidity
epilepsy
impatience
shyness
dizziness
depression
shadowmadness
```

**Rime Pattern:**
```lua
-- Adaptive based on class
vs_mentals = {
    stupidity = 90,     -- Disrupts offense
    impatience = 85,    -- Lock component
    epilepsy = 80,      -- Balance loss
    dizziness = 50,     -- Focus bait
    shyness = 30        -- Minor effect
}
```

### Ash Curing Order (Critical for Sylvan!)

**SVOF Default:**
```lua
hallucinations (120/182 split priority)
dementia (132/194 split)
paranoia (142/204 split)
confusion (138/200 split)
hypersomnia (126)
```

**Legacy Default:**
```lua
confusion
dementia
hallucinations
hypersomnia
paranoia
```

**Rime Pattern:**
```lua
-- Context-aware
ash_priority = function(state)
    if state.has_heartseed then
        return {"confusion", "hallucinations", "dementia"}
    else
        return {"dementia", "confusion", "hallucinations"}
    end
end
```

## Exploitation Strategies by System

### Against SVOF Users

1. **No Ignored Afflictions**
   - They cure everything, wasting balances
   - Load them with "useless" afflictions
   - Force herb balance consumption

2. **Split Priority Numbers**
   ```lua
   -- SVOF has different priorities in different modes
   -- hallucinations: 120 (normal) vs 182 (slowcuring)
   -- Exploit mode detection delays
   ```

3. **Static Priorities**
   - Never adapts to your patterns
   - Predictable cure sequence every time
   - Easy to manipulate cure order

### Against Legacy Users

1. **Ignored Afflictions Exploit**
   ```lua
   -- They don't cure these by default
   LEGACY_IGNORED = {"blindness", "deafness", "insomnia"}
   
   -- Abuse blindness for hidden attacks
   -- Use deafness to mask audio cues
   -- Insomnia prevents sleep strategies
   ```

2. **Immediate Tree Usage**
   - Touch tree as soon as available
   - No strategic timing
   - Predictable 10-second windows

3. **Simple Stack Detection**
   - Only counts afflictions
   - Doesn't weight importance
   - Easy to manipulate with mixed stacks

### Against Rime Users

1. **Adaptive System Confusion**
   ```lua
   -- Rime learns patterns
   -- Counter: Change patterns frequently
   function confuse_rime_learning()
       -- Random strategy every 30 seconds
       -- Prevent pattern establishment
   end
   ```

2. **Resource Tracking**
   - Rime tracks your resources
   - Hide arcane power usage
   - Fake resource exhaustion

3. **Conditional Logic Exploitation**
   - Complex rules can backfire
   - Force edge cases
   - Create impossible decisions

## Class-Specific Exploits

### Sylvan vs Each System

**Against SVOF:**
```lua
-- SVOF cures ash in different order than Legacy
-- confusion is lower priority (138)
-- Abuse by stacking dementia/hallucinations first
ASH_STACK_VS_SVOF = {
    "dementia",      -- Priority 132
    "hallucinations", -- Priority 120  
    "confusion"      -- Priority 138 (cured last!)
}
```

**Against Legacy:**
```lua
-- Legacy cures confusion first
-- Stack the others
ASH_STACK_VS_LEGACY = {
    "hallucinations",
    "dementia",
    "paranoia",
    "confusion"  -- They cure this, others stick
}
```

**Against Rime:**
```lua
-- Rime adapts, so randomize
ASH_STACK_VS_RIME = function()
    local affs = {"confusion", "dementia", "hallucinations"}
    -- Shuffle randomly
    return shuffle(affs)
end
```

## Timing Differences

### Balance Timings

| System | Herb | Focus | Tree | Salve |
|--------|------|-------|------|-------|
| **SVOF** | 1.5s | 2.5s | Variable | 1.0s |
| **Legacy** | 1.5s | 2.5s | 10.0s | 1.0s |
| **Rime** | Tracked | Tracked | Tracked | Tracked |

### Exploitation Windows

**SVOF Windows:**
- Predictable timings
- No latency compensation
- Fixed intervals

**Legacy Windows:**
- Simple boolean tracking
- No variance calculation  
- Immediate usage patterns

**Rime Windows:**
- Accurate tracking
- Variance calculation
- Harder to exploit

## Advanced Exploitation Techniques

### 1. Cross-System Confusion

```lua
-- Detect system and use opposite strategy
function cross_system_exploit(target)
    if target.system == "svof" then
        -- Use Legacy patterns
        return LEGACY_PRIORITIES
    elseif target.system == "legacy" then
        -- Use SVOF patterns
        return SVOF_PRIORITIES
    else
        -- Rime: use random
        return randomize_priorities()
    end
end
```

### 2. Priority Detection

```lua
-- Watch first 5-10 cures to identify system
function detect_curing_system(cure_log)
    local patterns = {
        svof = 0,
        legacy = 0,
        rime = 0
    }
    
    for i, cure in ipairs(cure_log) do
        if matches_svof_pattern(cure) then
            patterns.svof = patterns.svof + 1
        end
        -- etc
    end
    
    return get_highest(patterns)
end
```

### 3. Mode Switching Detection

```lua
-- SVOF has different modes
function detect_svof_mode(target)
    -- Check cure speeds
    if last_cure_time > 2.0 then
        return "slowcuring"  -- Different priorities!
    else
        return "normal"
    end
end
```

## Implementation Priority for EMERGE

### High Priority Exploits
1. **Ignored Affliction Tracking** (Legacy)
2. **Ash Priority Differences** (All systems)  
3. **Tree Timing Patterns** (SVOF/Legacy)
4. **Static Priority Exploitation** (SVOF/Legacy)

### Medium Priority Exploits
1. **Mode Detection** (SVOF)
2. **Stack Manipulation** (All)
3. **Focus Exhaustion** (All)
4. **Resource Hiding** (Rime)

### Low Priority Exploits
1. **Learning Confusion** (Rime)
2. **Edge Case Forcing** (Rime)
3. **Cross-System Strategies** (All)

## System-Specific Weaknesses Summary

### SVOF Weaknesses
- Static priorities
- No adaptation
- Cures everything (wastes balances)
- Mode switching delays
- Predictable patterns

### Legacy Weaknesses  
- Ignores key afflictions
- Immediate tree usage
- Simple tracking
- Default priorities
- No learning

### Rime Weaknesses
- Complex logic exploitable
- Resource tracking can be fooled
- Learning can be confused
- Over-optimization sometimes

## Conclusion

By understanding these differences, EMERGE can:
1. Quickly identify which system the target uses
2. Switch to optimal exploitation strategy
3. Adapt when they change priorities
4. Maintain pressure through system-specific weaknesses

The key is not just knowing the defaults, but understanding the *philosophy* behind each system:
- **SVOF**: Completionist (cure everything)
- **Legacy**: Minimalist (cure important only)  
- **Rime**: Adaptive (learn and optimize)

EMERGE exploits each philosophy's inherent weaknesses.