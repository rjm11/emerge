# Core System Interaction Rules

This document outlines the mandatory rules for interacting with the `core/events.lua` and `core/state.lua` modules. Adherence to these rules is critical for system stability, performance, and maintainability.

## 1. Event System Rules (`core/events.lua`)

The event system is the central nervous system of EMERGE. All inter-module communication MUST happen through events.

### 1.1. Event Naming Convention

All event names MUST follow the `module.subject.action` format. This structure provides clarity and helps prevent event name collisions.

-   **`module`**: The name of the module or logical system emitting the event (e.g., `gmcp`, `combat`, `curing`).
-   **`subject`**: The entity the event is about (e.g., `health`, `target`, `affliction`).
-   **`action`**: The specific action that occurred (e.g., `changed`, `gained`, `lost`, `selected`).

**Examples:**
-   `gmcp.health.changed`: Fired when the player's health changes via GMCP.
-   `combat.target.selected`: Fired when a new combat target is chosen.
-   `affliction.gained`: Fired when the player receives a new affliction.

### 1.2. Priority System Usage

The event system uses a numerical priority system (higher number = higher priority = runs first). Use priorities to control the execution order of handlers.

-   **CRITICAL (100+):** Reserved for core system functions that must run before anything else. Use for handlers that modify or cancel event data that subsequent handlers will use.
    -   *Example:* A defense module that needs to reduce incoming damage before other modules react to the `combat.damage.received` event.
-   **HIGH (75-99):** For important feature modules that need to react quickly.
    -   *Example:* An automated curing system reacting to an `affliction.gained` event.
-   **NORMAL (50):** The default priority. For most standard application logic.
    -   *Example:* Updating a UI element in response to a state change.
-   **LOW (1-49):** For non-essential tasks like logging, analytics, or debugging. These handlers should not affect the outcome of the event.
    -   *Example:* A logger that records every affliction gained.

### 1.3. Handler Management for Memory Safety

Improper handler management is a primary source of memory leaks.

-   **Use `events.onModule()` for Module Listeners:** When a module needs to listen for an event, it MUST use `events.onModule(eventName, callback, moduleName, priority)`. This tags the handler to the module.
-   **Automatic Cleanup:** The core system will automatically call `events.clearModule(moduleName)` when a module is unloaded or reloaded, using the tag from `onModule()` to remove all of its handlers. This is the primary mechanism for preventing memory leaks from abandoned listeners.
-   **Use `events.once()` for Single-Fire Events:** For handlers that should only ever run once, always use `events.once()`. This is safer and more efficient than manually calling `events.off()` inside the handler.
-   **Avoid Anonymous Functions for Removable Handlers:** If you need to manually remove a specific handler with `events.off()`, you MUST provide the original function reference. This is impossible with anonymous functions.

**Correct Lifecycle:**
```lua
-- in modules/my_module.lua
local module_name = "my_module"

function my_module.init()
    -- This handler is automatically cleaned up on reload/unload
    events.onModule("combat.target.changed", my_module.on_target_change, module_name)
end

function my_module.on_target_change(new_target)
    -- do something
end
```

## 2. State Management Guidelines (`core/state.lua`)

The state module provides a centralized and predictable way to manage data.

### 2.1. Persistent vs. Temporary State

The distinction between persistent and temporary state is crucial for performance and data integrity.

-   **Persistent State (`state.set(path, value, true)` or `state.set(path, value)`)**:
    -   **Use For:** Data that MUST be saved between game sessions.
    -   **Examples:** User settings (UI theme, disabled features), character-specific data that isn't sent by the MUD on login (custom aliases, triggers).
    -   **Criterion:** If the user would be annoyed to have to re-enter or re-configure this data after restarting Mudlet, it MUST be persistent.

-   **Temporary State (`state.set(path, value, false)`)**:
    -   **Use For:** Data that is only relevant for the current game session.
    -   **Examples:** Current combat target, active afflictions, player health/mana (data received from the MUD), temporary flags for short-lived logic.
    -   **Criterion:** If the data becomes stale or invalid once the user logs out, it MUST be temporary.

### 2.2. Path Notation

All state access MUST use dot notation for the `path` argument. This ensures a consistent and readable hierarchical data structure.

-   **Mandatory Format:** `state.get("toplevel.secondlevel.key")`
-   **Do not access the state tables directly.**

**Examples:**
-   `state.set("combat.target", "a goblin")`
-   `state.get("settings.ui.theme", "dark")`
-   `state.watch("player.vitals.hp", my_hp_watcher)`

### 2.3. Use Change Watching, Not Polling

To react to state changes, you MUST use `state.watch()` instead of repeatedly checking a value in a timer or loop (polling). Polling is inefficient and can lead to performance issues. `state.watch()` is event-driven and only executes your code when the data actually changes.

-   **Mandatory Usage:** To trigger logic when a specific piece of state changes, register a watcher.
-   **Watching Sub-trees:** To watch for any change within a larger data structure, use a wildcard: `state.watch("combat.*", my_combat_watcher)`

**Example:**

**INCORRECT - Polling:**
```lua
-- INEFFICIENT: Constantly checks the value in a loop
tempTimer(1, function()
    local target = state.get("combat.target")
    if target ~= last_target then
        -- do something
        last_target = target
    end
end)
```

**CORRECT - Watching:**
```lua
-- EFFICIENT: Function only runs when the value changes
state.watch("combat.target", function(new_target, old_target)
    -- do something with new_target
end)
```

## 3. Advanced Event System Rules

### 3.1. Error Isolation

The event system provides automatic error isolation. If one handler throws an error, other handlers for the same event will still execute.

-   **Handler Errors are Caught:** All handlers are executed in protected calls (`pcall`). Errors in one handler will not break other handlers.
-   **Errors are Logged:** Failed handlers will have their errors logged automatically, but the system continues to function.
-   **No Manual Error Handling Required:** You do not need to wrap your event handlers in `pcall` - the system does this for you.

### 3.2. Namespaced Event Emitters

For modules that emit many events, use the namespace feature to create a dedicated event emitter.

```lua
-- Create a namespaced emitter for the combat module
local combat_events = events.namespace("combat")

-- These are equivalent:
combat_events.emit("target.changed", new_target)  -- Emits "combat.target.changed"
events.emit("combat.target.changed", new_target)

-- Cleanup is also namespace-aware
combat_events.clear()  -- Clears only combat.* events
```

### 3.3. Batch Event Updates

When you need to emit multiple related events, use the batch system to improve performance by consolidating event notifications.

```lua
events.batch(function()
    events.emit("combat.mode.changed", "aggressive")
    events.emit("combat.stance.changed", "offensive")
    events.emit("combat.priority.changed", "damage")
end)
-- All watchers are notified after the batch completes
```

## 4. Advanced State Management Rules

### 4.1. Validation and Defaults

-   **Set Defaults First:** Always define default values before first use with `state.setDefault()` or `state.setDefaults()`.
-   **Use Validators for Critical Data:** For state that must meet certain criteria, register validators with `state.setValidator()`.
-   **Defaults vs. Initial Values:** Use defaults for configuration that should persist even if the state is reset. Use initial values in `init()` functions for data that should be recomputed on system startup.

```lua
-- Set defaults (these persist through resets)
state.setDefault("combat.mode", "defensive")

-- Set validator
state.setValidator("combat.mode", function(value)
    local valid = {"normal", "aggressive", "defensive"}
    for _, v in ipairs(valid) do
        if v == value then return true end
    end
    return false, "Invalid combat mode"
end)
```

### 4.2. Batch State Updates

When updating multiple related state values, use batch updates to prevent unnecessary event floods and improve performance.

```lua
state.batch(function()
    state.set("player.health", new_health)
    state.set("player.mana", new_mana) 
    state.set("player.endurance", new_endurance)
end)
-- Only one change notification is sent after all updates
```

### 4.3. State Snapshots and Recovery

-   **Create Snapshots Before Risky Operations:** Use `state.snapshot()` before making changes that might need to be undone.
-   **Use History for Debugging:** The state system keeps automatic history. Use `state.rollback()` to undo the last change.
-   **Backup Critical State:** For especially important state changes, consider creating manual snapshots.

```lua
-- Before experimental change
local backup = state.snapshot()

-- Make risky changes
state.set("critical.setting", experimental_value)

-- If something goes wrong
if something_went_wrong then
    state.restore(backup)
end
```

## 5. Performance Guidelines

### 5.1. Event System Performance

-   **Use Appropriate Priorities:** Higher priority handlers run first but also run more often. Only use high priorities when necessary.
-   **Keep Handlers Lightweight:** Event handlers should do minimal work. For heavy processing, queue the work to run later.
-   **Use `events.once()` for Single-Use Handlers:** It's more efficient than manually removing handlers.
-   **Monitor Performance:** Use `events.getPerformance()` to identify slow event handlers.

### 5.2. State System Performance

-   **Prefer Temporary State for Frequent Updates:** Data that changes often (like health/mana) should be temporary to avoid disk I/O.
-   **Use Batch Updates:** Multiple related changes should be batched to reduce event overhead.
-   **Watch Specific Paths:** Use specific paths like `"combat.target"` rather than broad patterns like `"*"` when possible.
-   **Enable Auto-Save Carefully:** Very short auto-save intervals can impact performance. The default (60 seconds) is usually appropriate.

## 6. Error Handling and Debugging

### 6.1. Debug Mode

Both systems have debug modes that provide detailed logging.

```lua
-- Enable detailed event logging
events.debug(true)

-- Enable detailed state logging
state.debug(true)
```

### 6.2. Introspection Functions

Both systems provide functions to inspect their current state:

```lua
-- Check event system status
local handlers = events.getHandlers()
local performance = events.getPerformance()

-- Check state system status
local stats = state.getStats()
local all_state = state.export(true)  -- Include temporary state
```

### 6.3. Cleanup and Memory Management

-   **Always Clean Up Handlers:** Use `events.onModule()` for automatic cleanup or manually remove handlers with `events.off()`.
-   **Clear Temporary State:** Use `state.clearTemporary()` when starting fresh (e.g., after character logout).
-   **Monitor Resource Usage:** Regularly check `events.getHandlerCount()` and `state.getStats()` to identify resource leaks.

