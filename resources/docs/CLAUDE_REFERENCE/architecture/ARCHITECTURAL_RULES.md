# EMERGE System: Architectural and Structural Rules

## 1. The Golden Rule: Event-Driven Communication

**Modules MUST NOT call each other directly.** All communication between modules, including core and feature modules, MUST be conducted through the global event system (`emerge.events`). This ensures that modules are decoupled, can be loaded in any order (after the core), and can be added or removed without causing system errors.

**Example:**

**INCORRECT - Direct Call:**
```lua
-- INCORRECT: Curing module directly calls the targeting module.
emerge.targeting.set_new_target("a goblin")
```

**CORRECT - Event-Based Communication:**
```lua
-- CORRECT: Curing module emits an event that the targeting module (and any other module) can listen for.
emerge.events.emit("curing.target.new", "a goblin")
```

## 2. Namespace Priority

The system uses a single, unified codebase but can be accessed through three distinct global namespaces for backward compatibility and clarity.

- **`emerge`**: The primary and official namespace for the system. All new code should use and reference this namespace.
- **`nexus`**: A legacy namespace maintained for backward compatibility with older systems or user scripts. It is an alias for `emerge`.
- **`achaea`**: A compatibility layer, also an alias for `emerge`, to ensure that existing user setups continue to function without modification.

All three namespaces point to the same underlying system objects and functions. While function calls are interchangeable (e.g., `emerge.status()` is identical to `nexus.status()`), `emerge` is the preferred namespace for all development.

## 3. Directory Structure Mandate

The system's directory structure is strict to ensure predictability and ease of maintenance. The three primary directories are:

- **`core/`**: This directory contains the foundational modules of the EMERGE system. These are essential for the system to function and are loaded first. The `core/events.lua` module is the absolute first module to be loaded.
- **`modules/`**: This directory houses all feature modules. Each `.lua` file in this directory should be a self-contained module that provides a specific feature (e.g., curing, targeting, defense). Modules in this directory are loaded after the core modules.
- **`misc/`**: This directory is for all non-essential files that support the system but are not part of the core functionality. This includes tests, documentation, examples, and other supporting materials.

## 4. Module Lifecycle

Every module in the `modules/` directory must adhere to a specific lifecycle pattern, managed by `init.lua`. This ensures that modules are initialized and shut down cleanly.

- **`init()` (Required)**: Every module MUST export an `init()` function. This function is called by the system when the module is loaded. It is responsible for setting up event listeners, initializing the module's state, and performing any other setup tasks.
- **`shutdown()` (Optional)**: A module CAN export a `shutdown()` function. If it exists, this function will be called when the module is unloaded or when the system is shutting down. It should be used to clean up any resources, save state, and remove event listeners to prevent memory leaks.

**Example Module Structure:**
```lua
-- in modules/my_feature.lua
emerge.my_feature = emerge.my_feature or {}
local module = emerge.my_feature

function module.init()
    -- Setup event listeners, initialize state, etc.
    emerge.events.on("some.event", module.handle_event)
end

function module.shutdown()
    -- Clean up event listeners and other resources
    emerge.events.off("some.event", module.handle_event)
end

function module.handle_event(data)
    -- Do something with the event data
end

return module
```
