# EMERGE Balance Module User Guide

## Quick Start

The balance module is the core of EMERGE's combat system, tracking all balance states and predicting recovery times.

### Basic Usage

```lua
-- Check if you have equilibrium
if emerge.balance.has("equilibrium") then
    send("cast spell")
end

-- Check if you have both balance and equilibrium
if emerge.balance.all() then
    send("dsl target")
end

-- Check if you have any cure balance
if emerge.balance.any("herb", "salve") then
    -- Can cure something
end

-- Get time until balance returns
local recovery = emerge.balance.get_recovery_time("herb")
echo("Herb balance in: " .. recovery .. " seconds\n")
```

### Testing the Module

```lua
-- Run visual tests to see it working
emerge test balance

-- Enable debug mode to see all balance events
emerge.balance.debug(true)

-- Check current status
emerge.balance.show()
```

## Balance Types

The module tracks these balance types:
- **equilibrium** - Mental balance for most abilities
- **balance** - Physical balance for attacks
- **herb** - Herb eating (1.5s base)
- **salve** - Salve application (1.0s base)
- **pipe** - Pipe smoking (1.5s base)
- **elixir** - Elixir/tonic sipping (4.5s base)
- **tree** - Tree tattoo (10s base)
- **focus** - Focus ability (2.5s base)
- **writhe** - Writhing from entanglement (variable)
- **voice** - Voice balance (bard class)
- **class** - Class-specific balance

## Events

### Listening for Balance Changes

```lua
-- React when balance is lost
emerge.events:on("balance.lost", function(data)
    echo("Lost " .. data.balance .. " to " .. data.consumer .. "\n")
    echo("Recovery in " .. data.recovery_time .. " seconds\n")
end)

-- React when balance recovers
emerge.events:on("balance.recovered", function(data)
    echo(data.balance .. " recovered!\n")
    if emerge.balance.all() then
        echo("All balances restored - ready to act!\n")
    end
end)

-- React to modifiers
emerge.events:on("balance.modified", function(data)
    echo(data.modifier .. " is affecting " .. data.balance .. "\n")
end)
```

### Integrating with Combat Systems

```lua
-- Queue system integration
emerge.events:on("balance.lost", function(data)
    if data.balance == "equilibrium" or data.balance == "balance" then
        emerge.queue.pause()
    end
end)

emerge.events:on("balance.recovered", function(data)
    if emerge.balance.all() then
        emerge.queue.resume()
    end
end)

-- Curing integration
emerge.events:on("balance.recovered", function(data)
    if data.balance == "herb" then
        emerge.curing.eat()
    elseif data.balance == "salve" then
        emerge.curing.apply()
    end
end)
```

## Affliction Modifiers

The module automatically tracks afflictions that affect balance recovery:

| Affliction | Affected Balances | Modifier |
|------------|------------------|----------|
| Stupidity | Equilibrium | 1.33x slower |
| Lethargy | Equilibrium | 1.33x slower |
| Aeon | All balances | 2.0x slower |
| Retardation | Equilibrium, Balance | 1.5x slower |

## Advanced Features

### Recovery Prediction

```lua
-- Get detailed recovery info
local recovery_time = emerge.balance.get_recovery_time("equilibrium")
local modifiers = emerge.balance.get_modifiers("equilibrium")

if #modifiers > 0 then
    echo("Equilibrium recovery affected by:\n")
    for _, mod in ipairs(modifiers) do
        echo("  " .. mod.name .. " (" .. mod.multiplier .. "x)\n")
    end
end
```

### Historical Analysis

```lua
-- Get balance usage history
local history = emerge.balance.get_history("equilibrium", 10)
for _, entry in ipairs(history) do
    echo(string.format("%s: %s by %s\n", 
        os.date("%H:%M:%S", entry.timestamp),
        entry.event,
        entry.consumer or "unknown"
    ))
end

-- Get statistics
local stats = emerge.balance.get_stats("herb", 60) -- Last 60 seconds
echo("Herb balance used " .. stats.total_uses .. " times\n")
echo("Average recovery: " .. stats.average_recovery .. "s\n")
echo("Most common use: " .. stats.most_common_consumer .. "\n")
```

### Custom Balance Types

```lua
-- Register a custom balance (e.g., for a class ability)
emerge.balance.register_balance("rage", {
    base_time = 4.0,
    history_size = 50
})

-- Use it like any other balance
emerge.events:emit("ability.used", {
    name = "berserk",
    consumes = {"rage"},
    recovery = { rage = 4.0 }
})
```

## Debugging

### Debug Mode

```lua
-- Enable debug output
emerge.balance.debug(true)

-- This will show:
-- - All balance state changes
-- - Recovery predictions
-- - Modifier applications
-- - Event emissions
```

### Common Issues

**Balance not recovering:**
- Check if you have afflictions affecting recovery
- Verify GMCP is working: `lua display(gmcp.Char.Vitals)`
- Check for active modifiers: `lua display(emerge.balance.get_modifiers("equilibrium"))`

**Incorrect recovery times:**
- The system learns from actual recovery times
- Initial predictions improve over time
- Check prediction accuracy: `lua display(emerge.balance.get_accuracy("herb"))`

## Integration Examples

### Simple Attack Script

```lua
-- Attack when balanced
emerge.events:on("balance.recovered", function()
    if emerge.balance.all() and target then
        send("dsl " .. target)
    end
end)
```

### Smart Curing

```lua
-- Prioritize curing when balances return
emerge.events:on("balance.recovered", function(data)
    if data.balance == "herb" then
        local priority_cure = emerge.curing.get_priority_herb()
        if priority_cure then
            send("eat " .. priority_cure)
        end
    elseif data.balance == "tree" and emerge.afflictions.has("paralysis") then
        send("touch tree")
    end
end)
```

### Balance Display

```lua
-- Create a simple balance display
function show_balances()
    local balances = {"equilibrium", "balance", "herb", "salve", "elixir"}
    echo("\n--- Balance Status ---\n")
    
    for _, bal in ipairs(balances) do
        if emerge.balance.has(bal) then
            cecho("<green>✓ " .. bal .. "\n")
        else
            local recovery = emerge.balance.get_recovery_time(bal)
            cecho(string.format("<red>✗ %s (%.1fs)\n", bal, recovery))
        end
    end
end

-- Update on any balance change
emerge.events:on("balance.lost", show_balances)
emerge.events:on("balance.recovered", show_balances)
```

## Performance Tips

1. **Use event listeners instead of polling** - Don't check balance states in loops
2. **Cache recovery times** - Only call get_recovery_time when needed
3. **Batch operations** - Group related actions together
4. **Use appropriate events** - Listen to specific balance types when possible

## Troubleshooting

Run the diagnostic command to check system health:
```lua
emerge diagnose balance
```

This will show:
- Current balance states
- Active modifiers
- Recent events
- Performance metrics
- Configuration status

For more help, use:
```lua
ehelp balance
```