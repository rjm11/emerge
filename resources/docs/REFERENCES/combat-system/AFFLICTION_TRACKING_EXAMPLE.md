# Affliction Tracking in Action

## Scenario: Building to a Lock

Let's walk through a combat scenario to see how EMERGE tracks afflictions differently:

### Turn 1: Opening Attack
```
You: DSL TARGET CURARE KALMIA
Gives: paralysis (curare) + asthma (kalmia)
```

**Traditional System:**
```lua
target.paralysis = true
target.asthma = true
```

**EMERGE System:**
```lua
target.afflictions = {
    paralysis = {
        confidence = 0.95,
        given_at = time(),
        method = "dsl_curare",
        confirmed = false
    },
    asthma = {
        confidence = 0.95,
        given_at = time(),
        method = "dsl_kalmia",
        confirmed = false
    }
}
```

### Turn 2: They Eat Kelp
```
Target eats a piece of kelp.
Kelp cures: asthma, sensitivity, clumsiness, weariness
```

**Traditional System:**
```lua
-- Guess they cured asthma (might be wrong!)
target.asthma = false
```

**EMERGE System:**
```lua
-- We know they prioritize asthma 70% of the time
target.afflictions.asthma.confidence = 0.25  -- Probably cured
target.afflictions.sensitivity.confidence = 0.0  -- Didn't have it
target.afflictions.clumsiness.confidence = 0.0   -- Didn't have it

-- But we track what they MIGHT have cured
target.last_cure = {
    type = "kelp",
    possibilities = {"asthma", "sensitivity", "clumsiness", "weariness"},
    probability = {asthma = 0.7, sensitivity = 0.2, clumsiness = 0.1}
}
```

### Turn 3: Check for Symptoms
```
Target tries to move but fails (paralysis symptom)
```

**Traditional System:**
```lua
-- Already thought they had it, no change
```

**EMERGE System:**
```lua
target.afflictions.paralysis.confidence = 1.0  -- CONFIRMED!
target.afflictions.paralysis.confirmed = true
target.afflictions.paralysis.confirmed_at = time()
```

### Turn 4: Time Passes (Tree Window Opens)
```
10 seconds have passed - tree tattoo available
```

**Traditional System:**
```lua
-- No change, still think they have paralysis
```

**EMERGE System:**
```lua
-- Tree could cure paralysis
target.afflictions.paralysis.confidence = 0.65  -- Might be cured
target.cure_windows.tree.ready = true

-- System knows to re-apply paralysis or verify
next_action_priority = {
    paralysis = 45,     -- Medium priority, might need refresh
    impatience = 85,    -- High priority, lock piece
    slickness = 80      -- High priority, lock piece
}
```

### Turn 5: Smart Decision Making
```
What should we give next?
```

**Traditional System:**
```lua
if not target.impatience and not target.slickness then
    -- Give one of them
    attack = "dsl curare xentio"  -- Might waste paralysis!
end
```

**EMERGE System:**
```lua
function get_next_afflictions()
    local scores = {}
    
    -- Paralysis: 65% confidence they have it
    -- Score = base_priority * (1 - confidence)
    scores.paralysis = 60 * (1 - 0.65) = 21  -- Low, probably have it
    
    -- Impatience: 0% confidence (don't have)
    scores.impatience = 80 * (1 - 0) = 80    -- High, lock piece
    
    -- Slickness: 0% confidence
    scores.slickness = 80 * (1 - 0) = 80     -- High, lock piece
    
    -- Check venom availability and decide
    if can_deliver("gecko") and can_deliver("xentio") then
        return "dsl gecko/xentio"  -- Impatience + slickness
    end
end
```

## The Magic: Confidence Decay

Every second, confidence naturally decays:

```lua
-- Every 1 second
for aff, data in pairs(target.afflictions) do
    if data.confidence > 0 then
        -- Natural decay
        data.confidence = data.confidence - 0.01
        
        -- Faster decay if cure window open
        if can_cure(aff) then
            data.confidence = data.confidence - 0.02
        end
        
        -- Remove if too low
        if data.confidence < 0.1 then
            target.afflictions[aff] = nil
        end
    end
end
```

## Why This Matters

### Scenario: Hidden Tree Cure

**Traditional System:**
1. Give paralysis
2. Still think they have it 30 seconds later
3. Waste attacks on already-cured affliction
4. Wonder why your offense isn't working

**EMERGE System:**
1. Give paralysis (95% confidence)
2. Tree window opens (65% confidence)  
3. No confirmation seen (45% confidence)
4. System prioritizes re-giving paralysis
5. Offense stays on track

### Real Example: Kelp Stack Tracking

```lua
-- They have: asthma, clumsiness, sensitivity, weariness
-- Traditional: Track 4 booleans

-- EMERGE: Track with confidence
afflictions = {
    asthma = {confidence = 0.95},
    clumsiness = {confidence = 0.90},  -- Given earlier
    sensitivity = {confidence = 0.95},
    weariness = {confidence = 0.85}    -- Least recent
}

-- They eat kelp
-- Traditional: Guess asthma? Might be wrong!

-- EMERGE: Probability distribution
probable_cure = {
    asthma = 0.4,      -- Highest priority usually
    sensitivity = 0.3,  -- Damage increase
    weariness = 0.2,    -- Defense
    clumsiness = 0.1   -- Lowest priority
}

-- Adjust ALL confidences
afflictions.asthma.confidence *= 0.6      -- 57%
afflictions.sensitivity.confidence *= 0.7  -- 66%
afflictions.weariness.confidence *= 0.8   -- 68%
afflictions.clumsiness.confidence *= 0.9  -- 81%

-- Next attack prioritizes lowest confidence
next_venom = "kalmia"  -- Re-stick asthma
```

## Summary

The key differences:

1. **Confidence vs Boolean**: "75% sure" vs "definitely has it"
2. **Decay Over Time**: Confidence drops as cure windows open
3. **Smart Priorities**: Give what they probably DON'T have
4. **Pattern Learning**: Track their curing priorities
5. **Efficient Offense**: Don't waste attacks on cured afflictions

This creates an intelligent system that adapts to uncertainty and makes optimal decisions even with incomplete information.