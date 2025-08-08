# Critical Affliction Priority Analysis

## Overview

This document analyzes how each major curing system prioritizes critical afflictions that are key to various kill strategies. Understanding these patterns allows EMERGE to optimize affliction selection.

## Lock Afflictions

### Soft Lock Components
The classic soft lock requires: **impatience + anorexia + asthma**

**SVOF Priorities:**
```lua
impatience = 150    -- Very low herb priority!
anorexia = 22       -- Focus only (no herb cure)
asthma = 84         -- High priority (checkasthma)
```

**Legacy Priorities:**
```lua
impatience = "high"     -- Goldenseal group
anorexia = "critical"   -- Focus/salve
asthma = "critical"     -- Kelp group first
```

**Rime Priorities:**
```lua
-- Dynamic based on other afflictions
if has_aff("anorexia") then
    priority["impatience"] = 100  -- Maximum
end
```

**Exploitation:** SVOF is weakest to locks due to impatience's low priority (150).

### True Lock Addition
True lock adds: **slickness** (preventing tree tattoo)

**SVOF:** 
- slickness (herb) = 219 - Extremely low priority!
- slickness (smoke) = 83 - Higher smoke priority

**Legacy:** 
- Always high priority due to tree prevention

**Rime:** 
- Detects lock threat and reprioritizes

## Damage Amplification Afflictions

### Sensitivity
Increases damage taken by 33%

**SVOF:** Priority 201 - One of the lowest!
**Legacy:** Medium priority in kelp group
**Rime:** Increases with damage pressure

**Exploitation:** SVOF users take massive damage with sensitivity stuck.

### Nausea
Prevents healing elixirs

**SVOF:** Priority varies by cure type
**Legacy:** High priority when health critical
**Rime:** Dynamic based on health percentage

## Focus Afflictions

Critical for draining mana and preventing focus-based curing:

### High Mana Cost (250 mana each)
```lua
FOCUS_AFFLICTIONS = {
    -- SVOF priorities (focus number)
    stupidity = 23,
    anorexia = 22,
    epilepsy = 18,
    paranoia = 13,
    dementia = 11,
    hallucinations = 10,
}
```

**Exploitation Pattern:**
1. Give hallucinations first (lowest number = highest priority)
2. They focus immediately (-250 mana)
3. Give stupidity (they focus again)
4. Now low mana, can't focus impatience

## Paralysis and Hindrance

### Paralysis
The most important affliction in Achaea

**SVOF:** Immediate cure (no number, always first)
**Legacy:** Bloodroot first priority
**Rime:** Contextual (lower in retardation)

### Web/Bind/Transfix
Physical entanglement afflictions

**SVOF:** Writhe immediately
**Legacy:** Writhe unless prepping
**Rime:** Contextual based on threat

## Burst Window Afflictions

### Aeon/Retardation Effects
Slows all commands to 1 second

**SVOF:** Switches to slowcuring mode
**Legacy:** Smoke priority
**Rime:** Pre-programmed sequence

**Exploit:** 1-2 second window during SVOF mode switch

### Confusion
Prevents focus, disrupts commands

**SVOF:** Priority 138 (herb) / 17 (focus)
**Legacy:** First ash priority  
**Rime:** Depends on class

## Class-Specific Critical Afflictions

### Sylvan
```lua
SYLVAN_CRITICAL = {
    -- For heartseed
    paralysis = "critical",
    impatience = "critical", 
    confusion = "high",      -- Prevents focus
    
    -- SVOF priorities
    -- Confusion is 138 - relatively low!
}
```

### Serpent
```lua
SERPENT_CRITICAL = {
    -- For lock
    impatience = "critical",
    anorexia = "critical",
    asthma = "critical",
    slickness = "critical",
    
    -- SVOF priorities  
    -- Impatience is 150 - very low!
    -- Slickness is 219 - extremely low!
}
```

### Apostate
```lua
APOSTATE_CRITICAL = {
    -- For catharsis
    hellsight = "critical",
    epilepsy = "high",
    
    -- SVOF priorities
    -- Hellsight is smoke cure
    -- Epilepsy is 124
}
```

## Priority Patterns by Strategy

### For Damage Kills
```lua
DAMAGE_PRIORITY = {
    sensitivity = "critical",  -- SVOF: 201 (exploit!)
    nausea = "critical",       -- Stop sipping
    healthleech = "high",      -- Damage over time
    ablaze = "medium",         -- Damage tick
}
```

### For Lock Kills  
```lua
LOCK_PRIORITY = {
    asthma = "critical",       -- SVOF: 84
    anorexia = "critical",     -- SVOF: focus 22
    impatience = "critical",   -- SVOF: 150 (exploit!)
    slickness = "critical",    -- SVOF: 219 (major exploit!)
}
```

### For Timed Kills (Heartseed, etc)
```lua
TIMED_PRIORITY = {
    paralysis = "critical",    -- Stop curing
    confusion = "critical",    -- Stop focus
    impatience = "high",       -- Backup focus stop
    aeon = "medium",          -- Slow everything
}
```

## Optimization Algorithm

```lua
function select_optimal_affliction(target, strategy)
    local their_system = target.curing_system
    local available_affs = get_available_afflictions()
    
    -- Score each affliction
    local scores = {}
    for _, aff in ipairs(available_affs) do
        local score = 0
        
        -- Base strategic value
        score = score + STRATEGY_VALUE[strategy][aff]
        
        -- Modify by their priority
        if their_system == "svof" then
            -- Higher SVOF number = lower their priority = better for us
            score = score + (SVOF_PRIORITIES[aff] / 10)
        elseif their_system == "legacy" then
            -- Inverse Legacy priority
            score = score + (10 - LEGACY_PRIORITY_RANK[aff])
        end
        
        -- Consider current afflictions (synergy)
        score = score + calculate_synergy(target, aff)
        
        scores[aff] = score
    end
    
    -- Return highest scoring affliction
    return get_highest_score(scores)
end
```

## Critical Insights

### SVOF Weaknesses
1. **Impatience** at priority 150 makes locks easier
2. **Sensitivity** at 201 enables damage kills
3. **Slickness** at 219 makes true locks trivial
4. **Confusion** at 138 is low for such an important affliction

### Legacy Weaknesses
1. Predictable static priorities
2. Ignores blindness/deafness
3. Poor tree timing

### Rime Adaptations
1. Harder to exploit but patterns exist
2. Resource intensive adaptation
3. Can be confused by rapid strategy changes

## Summary Table: Critical Affliction Priorities

| Affliction | SVOF | Legacy | Rime | Best Against |
|------------|------|---------|------|--------------|
| Paralysis | Instant | First | Contextual | All |
| Asthma | 84 | First kelp | Dynamic | All |
| Impatience | 150 | High | Dynamic | SVOF |
| Anorexia | Focus 22 | Critical | Critical | All |
| Slickness | 219 | High | High | SVOF |
| Sensitivity | 201 | Medium | Dynamic | SVOF |
| Confusion | 138 | First ash | Class-based | SVOF |
| Stupidity | 118 | First gold | High | Legacy |

This analysis shows SVOF's default priorities create massive vulnerabilities for lock and damage strategies, while Legacy's predictable patterns and ignored afflictions create different opportunities.