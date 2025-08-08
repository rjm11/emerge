# Adaptive Learning in Action: A Combat Example

## How EMERGE Learns and Exploits Individual Curing Patterns

### Initial Combat: No Data

```
=== FIGHT 1 vs Bob (0 observations) ===

EMERGE: No profile yet, using default strategy
- Gives: paralysis, asthma, sensitivity

Bob eats kelp → asthma cured
EMERGE records: When Bob had [asthma, sensitivity], he cured asthma

Bob eats kelp → sensitivity cured  
EMERGE records: When Bob had [sensitivity], he cured sensitivity

Learning Progress: 2 observations, building profile...
```

### After 10 Observations

```
=== FIGHT 1 vs Bob (10 observations) ===

EMERGE has learned Bob's kelp priorities:
1. asthma      (cured 8/8 times = 100%)
2. sensitivity (cured 1/4 times = 25%)  
3. clumsiness  (cured 0/3 times = 0%)
4. weariness   (cured 1/5 times = 20%)

EMERGE adapts strategy:
- Stacks clumsiness + weariness (low priority)
- Waits for Bob to waste kelp
- Then gives sensitivity (will stick!)
```

### After 30 Observations

```
=== FIGHT 2 vs Bob (30 observations) ===

EMERGE's learned profile (85% confidence):

KELP PRIORITIES:
1. asthma (score: 95/100)      ← Always cures first
2. weariness (score: 45/100)   ← Sometimes cures
3. sensitivity (score: 25/100)  ← Rarely cures
4. clumsiness (score: 15/100)  ← Almost never

GOLDENSEAL PRIORITIES:
1. stupidity (score: 88/100)    ← High priority
2. epilepsy (score: 72/100)     ← Medium priority  
3. impatience (score: 31/100)   ← Low priority!

EXPLOIT STRATEGY:
"Bob ignores impatience - perfect for locks!"
```

### Real-Time Adaptation Example

```lua
-- Round 1: Testing
EMERGE gives: asthma, clumsiness
Bob eats kelp → cures asthma (as predicted)
EMERGE: "Confirmed, proceeding with strategy"

-- Round 2: Stacking low priorities
EMERGE gives: clumsiness, weariness, sensitivity
Bob eats kelp → cures weariness (unusual!)
EMERGE: "Adjusting... Bob's priorities changed"

-- Round 3: Adapted strategy
EMERGE gives: weariness first (bait)
Bob eats kelp → cures weariness
EMERGE gives: sensitivity + clumsiness
Both afflictions stick during herb balance!

-- Round 4: Exploit window
EMERGE: "Bob has 2 low-priority kelps, going for damage"
Gives: paralysis (forces tree)
Bob touches tree
EMERGE: "10 second window, maximum pressure!"
```

### Learning Over Multiple Fights

```
=== COMBAT HISTORY vs Bob ===

Fight 1 (2 weeks ago):
- Observations: 35
- Learned: Basic priorities
- Win rate: 45%

Fight 2 (1 week ago):  
- Observations: 52 total
- Learned: Tree timing patterns
- Win rate: 62%

Fight 3 (today):
- Observations: 78 total
- Learned: Focus preferences, salve priorities
- Win rate: 78%

EMERGENCE COMPLETE PROFILE:
- Kelp: Ignores sensitivity (exploit for damage)
- Focus: Saves for stupidity (bait with epilepsy)
- Tree: Uses immediately on paralysis (10s windows)
- Salve: Prioritizes breaks over burns
- Custom: Switches priorities when low health
```

### The Advantage Compounds

```
MINUTE 1: EMERGE operates at 50% efficiency (learning)
- Testing priorities
- Building initial model
- Some wrong predictions

MINUTE 3: EMERGE operates at 75% efficiency
- Confident in herb priorities  
- Exploiting weak spots
- Predictions mostly correct

MINUTE 5: EMERGE operates at 90% efficiency
- Full priority model built
- Predicting cures accurately
- Optimal affliction selection

MINUTE 10: EMERGE operates at 95% efficiency
- Complete behavioral profile
- Exploiting all weaknesses
- Opponent can't adapt fast enough
```

### Example Code in Action

```lua
-- EMERGE's decision making with learned profile
function select_next_affliction(target)
    local profile = emerge.adaptive.get_learning_status(target)
    
    if profile.observations < 10 then
        -- Still learning, use probing strategy
        return probe_afflictions[math.random(#probe_afflictions)]
    
    elseif profile.confidence < 0.7 then
        -- Moderate confidence, test predictions
        local predicted = emerge.adaptive.predict_next_cure(target, "kelp")
        if predicted == "asthma" then
            -- Give low priorities to test
            return "clumsiness"  -- Should stick
        end
    
    else
        -- High confidence, full exploitation
        local priorities = emerge.adaptive.get_priorities(target, "kelp")
        
        -- Give their lowest priority afflictions
        for i = #priorities, 1, -1 do
            local aff = priorities[i].affliction
            if can_deliver(aff) then
                return aff  -- Will stick!
            end
        end
    end
end
```

### Psychological Impact

As the fight progresses, Bob realizes:
- His cures aren't working as well
- Afflictions he usually ignores are stacking
- EMERGE seems to predict his every move
- The fight gets harder, not easier

This creates pressure and forces mistakes, making EMERGE even more effective.

### Counter-Adaptation

Some fighters might try to change their priorities mid-fight:

```
Bob thinks: "They're exploiting my low sensitivity priority"
Bob manually: CURING PRIORITY KELP SENSITIVITY 1

EMERGE detects: Priority change detected!
EMERGE adapts: Switching exploitation target to clumsiness
```

But EMERGE adapts faster than humans can manually adjust priorities.

## Summary

The adaptive system means:
1. **Every fight makes EMERGE stronger** against that opponent
2. **Exploits become more precise** over time
3. **Opponents can't "hide" their patterns** - they emerge naturally
4. **The system works against ANY curing system** - even custom ones

This is why the adaptive profiler is so powerful - it doesn't need to know what system they use, it learns their actual behavior and exploits it dynamically.