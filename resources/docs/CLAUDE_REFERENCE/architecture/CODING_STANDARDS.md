# EMERGE System: Official Coding Standards

This document provides the official documentation, development, and quality standards for all code within the EMERGE system. Adherence to these standards is mandatory to ensure the long-term maintainability, stability, and quality of the project.

## 1. Documentation Standards

Comprehensive documentation is critical for a modular, event-driven system. All modules, public functions, and events must be documented according to the following standards.

### 1.1. Module Header

Every `.lua` file representing a module must begin with a standard header block. This header provides an at-a-glance overview of the module's purpose and architecture.

**Format:**

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
--   - Feature 2: Brief description.
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

### 1.2. Function & Event Documentation (`help_data`)

All public functions and emitted events **MUST** be documented in a `help_data` table within their respective module. This table is used by the `ehelp` system to automatically discover and display documentation.

Modules must register this data using `emerge.help.register("module_name", help_data)` or by emitting a `help.register` event.

**`help_data` Structure:**

```lua
local help_data = {
    -- General module description
    description = "This module handles all combat targeting.",

    -- Documentation for all public functions
    functions = {
        {
            name = "set_target",
            signature = "emerge.targeting.set_target(name)",
            description = "Sets the primary combat target.",
            parameters = {
                {name = "name", type = "string", description = "The name of the target to set."},
            },
            returns = "boolean - True if the target was valid, false otherwise.",
            example = "emerge.targeting.set_target(\"a goblin\")"
        },
        -- ... other functions
    },

    -- Documentation for all events emitted by this module
    events = {
        {
            name = "target.changed",
            description = "Fired when the primary combat target changes.",
            data = "{ old_target = (string), new_target = (string) }",
            example = "events.on('target.changed', function(data) print('Target changed from '..data.old_target) end)"
        },
        -- ... other events
    }
}
```

## 2. Development & Quality Standards

These standards ensure that the development process is consistent and the resulting code is robust and performant.

### 2.1. Module Development Workflow

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

### 2.2. Performance Standards

Performance is critical for a responsive system.

*   **Event-Driven Architecture:** Do NOT use polling (e.g., rapid timers) to check for state changes. Use `state.watch()` to react to data changes efficiently.
*   **Avoid Event Spam:** For multiple, rapid state changes, use `state.batch()` or `events.batch()` to consolidate notifications into a single update.
*   **Efficient Handlers:** Event handlers must be lightweight. For long-running tasks, the handler should queue the work to be processed outside of the immediate event loop.
*   **Data Structures:** Use efficient data structures. Pre-allocate tables where the size is known, and reuse objects/tables where possible to reduce garbage collection pressure.

### 2.3. Error Handling

System stability is paramount.

*   **Event Handlers:** All event handlers are automatically executed within a protected call (`pcall`) by the event system. You **DO NOT** need to wrap your event handler functions in `pcall`. The system will catch and log any errors without crashing.
*   **External Interactions:** Any function that interacts with an external resource (e.g., file system, network) where failures are possible **MUST** be wrapped in `pcall`. This prevents unexpected `nil` values or errors from propagating and crashing the system.

