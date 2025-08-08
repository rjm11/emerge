# EMERGE System: Comprehensive Development Guide

This document is the single source of truth for all developers working on the EMERGE system. It outlines the architectural principles, coding standards, and development workflows that must be followed to ensure the project remains modular, maintainable, and high-quality.

## 1. Architecture & Design Principles

### 1.1. The Golden Rule: Event-Driven Communication

**Modules MUST NOT call each other directly.** All communication between modules, including core and feature modules, MUST be conducted through the global event system (`emerge.events`). This ensures that modules are decoupled, can be loaded in any order (after the core), and can be added or removed without causing system errors.

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

### 1.2. Namespace Priority

The system uses a single, unified codebase but can be accessed through three distinct global namespaces for backward compatibility and clarity.

- **`emerge`**: The primary and official namespace for the system. All new code should use and reference this namespace.
- **`nexus`**: A legacy namespace maintained for backward compatibility with older systems or user scripts. It is an alias for `emerge`.
- **`achaea`**: A compatibility layer, also an alias for `emerge`, to ensure that existing user setups continue to function without modification.

All three namespaces point to the same underlying system objects and functions. While function calls are interchangeable (e.g., `emerge.status()` is identical to `nexus.status()`), `emerge` is the preferred namespace for all development.

## 2. Code Structure & Organization

### 2.1. Directory Structure Mandate

The system's directory structure is strict to ensure predictability and ease of maintenance. The three primary directories are:

- **`core/`**: This directory contains the foundational modules of the EMERGE system. These are essential for the system to function and are loaded first. The `core/events.lua` module is the absolute first module to be loaded.
- **`modules/`**: This directory houses all feature modules. Each `.lua` file in this directory should be a self-contained module that provides a specific feature (e.g., curing, targeting, defense). Modules in this directory are loaded after the core modules.
- **`misc/`**: This directory is for all non-essential files that support the system but are not part of the core functionality. This includes tests, documentation, examples, and other supporting materials.

### 2.2. Module Lifecycle

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

## 3. Event System Rules

The event system is the central nervous system of EMERGE. All inter-module communication MUST happen through events.

### 3.1. Event Naming Convention

All event names MUST follow the `module.subject.action` format. This structure provides clarity and helps prevent event name collisions.

-   **`module`**: The name of the module or logical system emitting the event (e.g., `gmcp`, `combat`, `curing`).
-   **`subject`**: The entity the event is about (e.g., `health`, `target`, `affliction`).
-   **`action`**: The specific action that occurred (e.g., `changed`, `gained`, `lost`, `selected`).

**Examples:**
-   `gmcp.health.changed`: Fired when the player's health changes via GMCP.
-   `combat.target.selected`: Fired when a new combat target is chosen.
-   `affliction.gained`: Fired when the player receives a new affliction.

### 3.2. Priority System Usage

The event system uses a numerical priority system (higher number = higher priority = runs first). Use priorities to control the execution order of handlers.

-   **CRITICAL (100+):** Reserved for core system functions that must run before anything else.
-   **HIGH (75-99):** For important feature modules that need to react quickly.
-   **NORMAL (50):** The default priority. For most standard application logic.
-   **LOW (1-49):** For non-essential tasks like logging, analytics, or debugging.

### 3.3. Handler Management for Memory Safety

-   **Use `events.onModule()` for Module Listeners:** When a module needs to listen for an event, it MUST use `events.onModule(eventName, callback, moduleName, priority)`. This tags the handler to the module.
-   **Automatic Cleanup:** The core system will automatically call `events.clearModule(moduleName)` when a module is unloaded or reloaded.
-   **Use `events.once()` for Single-Fire Events:** For handlers that should only ever run once, always use `events.once()`.
-   **Avoid Anonymous Functions for Removable Handlers:** If you need to manually remove a specific handler with `events.off()`, you MUST provide the original function reference.

## 4. State Management Guidelines

The state module provides a centralized and predictable way to manage data.

### 4.1. Persistent vs. Temporary State

-   **Persistent State (`state.set(path, value, true)`):** Data that MUST be saved between game sessions (e.g., user settings).
-   **Temporary State (`state.set(path, value, false)`):** Data that is only relevant for the current game session (e.g., combat target, active afflictions).

### 4.2. Path Notation

All state access MUST use dot notation for the `path` argument.

-   **Mandatory Format:** `state.get("toplevel.secondlevel.key")`
-   **Do not access the state tables directly.**

### 4.3. Use Change Watching, Not Polling

To react to state changes, you MUST use `state.watch()` instead of repeatedly checking a value in a timer or loop (polling).

## 5. Documentation Standards

### 5.1. Module Header

Every `.lua` file representing a module must begin with a standard header block.

```lua
--[[
================================================================================
                EMERGE SYSTEM - [MODULE NAME] MODULE
================================================================================
-- Description:
-- A brief, one-sentence description of the module's primary responsibility.
--
-- Author: [Author Name/Team Name]
-- Version: [Semantic Version, e.g., 1.0.0]
--
-- Key Features:
--   - Feature 1: Brief description.
--
-- Events Emitted:
--   - module.subject.action: Description of when and why this event is fired.
--
-- Mermaid Diagram - Role/Flow:
-- ```mermaid
--   graph TD;
--       A[External System] --o B(Module);
--       B --Emits event---> C{events.system};
-- ```
================================================================================
--]]
```

### 5.2. Function & Event Documentation (`help_data`)

All public functions and emitted events **MUST** be documented in a `help_data` table within their respective module. This table is used by the `ehelp` system to automatically discover and display documentation.

## 6. Development Workflow

All new module development and significant refactoring **MUST** follow this four-step process:

1.  **Design (1 hour):**
    *   Define the module's purpose, scope, and public API.
    *   Design the event contracts (emitted and consumed).
    *   Plan the necessary state management structure (`core/state`).
    *   Identify integration points with other modules.
    *   Create a Mermaid diagram illustrating the module's internal flow or its role in the system.

2.  **Implement (2-3 hours):**
    *   Create the module file using the standard module pattern (`emerge.my_module = {}`).
    *   Implement the mandatory `init()` function for setup and event listener registration.
    *   Implement an optional `shutdown()` function for cleanup if necessary.
    *   Build the core functionality and public API functions.

3.  **Test (1 hour):**
    *   Write unit tests for core public functions.
    *   Write integration tests to verify event emission and consumption.
    *   Validate performance to ensure it meets system standards.
    *   Test edge cases and error conditions.

4.  **Document (30 minutes):**
    *   Complete the standard Module Header.
    *   Create and populate the `help_data` table for all public functions and events.
    *   Register the `help_data` with the `ehelp` system.
    *   Ensure inline comments are present for any complex logic.

## 7. Performance & Quality Standards

### 7.1. Performance

-   **Event-Driven Architecture:** Do NOT use polling. Use `state.watch()` to react to data changes efficiently.
-   **Avoid Event Spam:** For multiple, rapid state changes, use `state.batch()` or `events.batch()` to consolidate notifications into a single update.
-   **Efficient Handlers:** Event handlers must be lightweight. For long-running tasks, the handler should queue the work to be processed outside of the immediate event loop.
-   **Data Structures:** Use efficient data structures. Pre-allocate tables where the size is known, and reuse objects/tables where possible to reduce garbage collection pressure.

### 7.2. Error Handling

-   **Event Handlers:** All event handlers are automatically executed within a protected call (`pcall`) by the event system. You **DO NOT** need to wrap your event handler functions in `pcall`.
-   **External Interactions:** Any function that interacts with an external resource (e.g., file system, network) where failures are possible **MUST** be wrapped in `pcall`.

