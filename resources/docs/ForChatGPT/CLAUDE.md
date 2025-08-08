# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 🚨 CRITICAL DEVELOPMENT RULES 🚨

1. **ALWAYS USE EMERGE AGENTS** - Never write EMERGE module code directly. Use `emerge-orchestrator` for ALL EMERGE development tasks.

2. **FOLLOW SEMANTIC VERSIONING** - We are at version 0.5.0 (beta). Use proper semver:
   - Bug fixes → 0.5.1 (PATCH)
   - New features → 0.6.0 (MINOR)
   - Breaking changes → Wait (we're not ready for 1.0.0)

3. **EVENT-DRIVEN ONLY** - Modules must NEVER call each other directly. All communication through events.

4. **100-CHARACTER WIDTH** - All displays use 100-character width for consistency.

## Project Overview

EMERGE (Emergent Modular Engagement & Response Generation Engine) is a Mudlet-based combat system for the MUD game Achaea. It uses an event-driven architecture where modules communicate through events rather than direct function calls, allowing for emergent behavior from simple module interactions.

The system has three namespace aliases for backward compatibility:
- `emerge` (primary)
- `nexus` (legacy alias)
- `achaea` (compatibility alias)

## Architecture

### Event-Driven Design
All modules communicate exclusively through events. Never have modules directly call each other's functions:
```lua
-- WRONG: Direct coupling
achaea.curing.add_affliction("paralysis")

-- CORRECT: Event-based
achaea.events:emit("affliction.gained", "paralysis")
```

### Module Load Order (Critical)
Modules must load in this specific order (defined in init.lua:18-36):
1. **Core modules** (foundation - MUST load first):
   - `core/events` - Event system (MUST be first)
   - `core/state` - State management
   - `core/utils` - Utility functions
   - `core/config` - Configuration management
   - `core/help` - Help system with auto-discovery

2. **System modules** (infrastructure):
   - `modules/gmcp` - GMCP handler (converts game data to events)
   - `modules/targeting` - Target tracking (not yet implemented)
   - `modules/curing` - Affliction curing (not yet implemented)
   - `modules/defense` - Defense management (not yet implemented)
   - `modules/offense` - Attack automation (not yet implemented)
   - `modules/bashing` - PvE automation (not yet implemented)

3. **Class modules** - Loaded dynamically based on current class

## Key Commands

### Development & Testing
```lua
-- Load/reload system
lua dofile(getMudletHomeDir().."/achaea/init.lua")

-- Check system status
lua achaea.status()
lua emerge.status()  -- Same command, different namespace

-- Enable debug mode for verbose logging
lua achaea.debug(true)

-- Run event system tests
lua dofile(getMudletHomeDir().."/achaea/tests/test_events.lua").run()

-- Test event system manually
lua achaea.events:on("test", function(msg) echo("Received: " .. msg .. "\n") end)
lua achaea.events:emit("test", "Hello World!")

-- Reload specific module
lua achaea.reload("modules/gmcp")

-- Reload all modules
lua achaea.reload_all()

-- Run basic system test
lua achaea.test()
```

### Help System
```lua
-- Access help (aliases available)
ehelp          -- Main help
ehelp search combat  -- Search for topics
eh             -- Quick access alias
```

## Version Management & Semantic Versioning

### CRITICAL: Always Use Proper Semantic Versioning
EMERGE is currently at version **0.5.0** (pre-production beta). We use strict semantic versioning:

**Version Format: MAJOR.MINOR.PATCH**
- **PATCH** (0.5.X): Bug fixes, typos, formatting changes, documentation updates
- **MINOR** (0.X.0): New features that are backward compatible
- **MAJOR** (X.0.0): Breaking changes or reaching production readiness

**Current Status: Beta Software (0.X.X)**
- We are NOT production ready yet
- Expect breaking changes before 1.0.0
- Version 1.0.0 will indicate production readiness

### Version Update Rules
When modifying ANY module or file:

1. **Bug fixes, formatting, typos** → Increment PATCH (0.5.0 → 0.5.1)
2. **New features (backward compatible)** → Increment MINOR (0.5.0 → 0.6.0)
3. **Breaking changes** → Increment MAJOR (0.5.0 → 1.0.0, but we're not ready for 1.0 yet)

### ALWAYS Update These Files Together:
1. **Module file header** - Update version comment
2. **CURRENT_VERSION constant** - Update the version string
3. **manifest.json** - Update module version
4. **CHANGELOG.md** - Document the changes with proper version

### Changelog Organization
Each directory should have its own CHANGELOG.md:
- `/` - For manager updates (emerge-manager.lua)
- `/required/` - For core/required modules
- `/optional/` - For optional modules

### Changelog Format
```markdown
## [0.5.1] - 2025-08-07
### Fixed
- Bug fix description (this is a PATCH)

## [0.6.0] - 2025-08-07  
### Added
- New feature description (this is a MINOR version)

## [1.0.0] - Future
### Changed
- Breaking change or production release (this is a MAJOR version)
```

## Module Structure Pattern

All modules follow this standardized pattern:
```lua
achaea = achaea or {}
achaea.modulename = achaea.modulename or {}
local module = achaea.modulename

-- Private state
local private_data = {}

-- Initialize
function module.init()
    -- Register event handlers
    achaea.events:on("relevant.event", handle_event)
end

-- Shutdown
function module.shutdown()
    -- Cleanup
end

-- Public API
function module.public_function() end

return module
```

## Event Naming Conventions

Use dot notation for event namespacing:
- `system.*` - System events (loaded, shutdown)
- `gmcp.*` - GMCP data events
- `combat.*` - Combat events
- `curing.*` - Curing events
- `target.*` - Target tracking
- `module.*` - Module lifecycle

## Core Module APIs

### Event System (core/events.lua)
```lua
achaea.events:on(event, callback, priority)  -- Register handler
achaea.events:once(event, callback)          -- One-time handler
achaea.events:emit(event, ...)               -- Trigger event
achaea.events:off(event, ref)                -- Remove handler
achaea.events:clear(event)                   -- Remove all handlers
achaea.events.debug(true/false)              -- Enable debug logging
achaea.events.getHistory(count)              -- Get event history
achaea.events.getHandlers(event)             -- Get handlers for event
```

### State Management (core/state.lua)
```lua
achaea.state.set(path, value, persistent)    -- Set state (persistent=true by default)
achaea.state.get(path, default)              -- Get state value
achaea.state.watch(path, callback)           -- Watch for changes
achaea.state.save()                          -- Manual save to disk
achaea.state.load()                          -- Manual load from disk
```

### Configuration (core/config.lua)
```lua
achaea.config.get(path, default)             -- Get config value
achaea.config.set(path, value)               -- Set config value
achaea.config.reset(path)                    -- Reset to default
achaea.config.toggle(path)                   -- Toggle boolean
achaea.config.show()                         -- Display all config
```

### GMCP Handler (modules/gmcp.lua)
Automatically converts GMCP data to events:
- `gmcp.vitals.changed` - Any vital change
- `gmcp.health.changed` - Health change (current, max, percent)
- `gmcp.mana.changed` - Mana change
- `gmcp.balance.changed` - Balance state change
- `gmcp.afflictions.added` - New affliction
- `gmcp.afflictions.removed` - Cured affliction
- `gmcp.room.changed` - Room movement

## Testing

### Unit Tests Location
Tests are in `tests/` directory. Run with:
```lua
lua dofile(getMudletHomeDir().."/achaea/tests/test_events.lua").run()
```

### Debug Commands
```lua
-- Enable all debug output
lua achaea.debug(true)

-- Check event flow
lua achaea.events.debug(true)
lua display(achaea.events.getHistory(20))

-- Check module loading
lua achaea.status()

-- Monitor state changes
lua achaea.state.watch("*", function(path, new_val, old_val)
    echo(string.format("State: %s = %s\n", path, tostring(new_val)))
end)
```

## Important Notes

1. **Event-Driven ONLY**: Never have modules directly call each other. All communication through events.

2. **Namespace Compatibility**: The system supports three namespaces (`emerge`, `nexus`, `achaea`) for backward compatibility. All are aliases to the same system.

3. **Module Dependencies**: Core modules must load before system modules. The event system (core/events) MUST load first.

4. **State Persistence**: Use `achaea.state.set()` with persistent=true (default) for data that should survive restarts.

5. **Error Isolation**: Event handlers are isolated - one handler error won't break others.

6. **Performance**: Events are processed synchronously in priority order. Don't block in event handlers.

7. **GMCP Integration**: The GMCP module automatically registers for all Achaea GMCP modules and converts data changes to events.

## Development Tools & Resources

### AI Development Agents
When developing for EMERGE, utilize specialized AI agents for different tasks:

**Core Development Agents:**
- `lua-expert` - For Lua code optimization, patterns, and best practices
- `mudlet-lua-generator` - For generating Mudlet-specific Lua modules
- `mud-pattern-matcher` - For creating regex patterns for MUD triggers
- `module-architecture-designer` - For designing module structure and API
- `workflow-agent` - Multi-agent orchestrator for complex tasks
- `general-purpose` - For researching complex questions and multi-step tasks

**Project Management Agents:**
- `tech-lead-orchestrator` - Analyzes projects and provides strategic recommendations
- `team-configurator` - Sets up AI development team for the project
- `project-analyst` - Analyzes codebases to detect frameworks and architecture
- `context-manager` - Manages complex multi-agent workflows and long-running tasks
- `agent-architect` - Creates specialized agents tailored to project needs

**Backend Development Agents:**
- `backend-developer` - General backend development across any language/stack
- `rails-backend-expert` - Rails backend development specialist
- `rails-api-developer` - Rails API and GraphQL specialist
- `rails-activerecord-expert` - Rails database optimization expert
- `laravel-eloquent-expert` - Laravel ORM and database specialist
- `laravel-backend-expert` - Laravel backend architecture specialist
- `django-orm-expert` - Django ORM optimization specialist
- `django-backend-expert` - Django backend development specialist
- `django-api-developer` - Django REST Framework and GraphQL specialist

**Frontend Development Agents:**
- `frontend-developer` - Responsive, accessible UI development
- `react-component-architect` - React patterns and component design
- `react-nextjs-expert` - Next.js SSR/SSG specialist
- `vue-component-architect` - Vue 3 Composition API specialist
- `vue-nuxt-expert` - Nuxt.js framework specialist
- `tailwind-frontend-expert` - Tailwind CSS styling specialist

**Code Quality Agents:**
- `code-reviewer` - Security-aware code review specialist
- `code-archaeologist` - Legacy/complex codebase exploration
- `performance-optimizer` - System optimization specialist
- `documentation-specialist` - Project documentation expert
- `reference-builder` - Comprehensive technical documentation

**API & Architecture Agents:**
- `api-architect` - Universal API design specialist

### MCP Servers
Available MCP servers for enhanced functionality:
- `context7` - Retrieve up-to-date documentation for any library
- `claude-context` - Index and search codebases semantically
- `gemini-cli` - Advanced code analysis and brainstorming
- `playwright` - Browser automation for web-based resources

### Reference Documents
Key reference documents in the project:
- `MODULE_ARCHITECTURE_DIAGRAMS.md` - Visual module interaction diagrams
- `DEVELOPMENT_WORKFLOW.md` - Development process and guidelines
- `resources/wiki-repo/` - Achaea game mechanics documentation

### Reference Implementations
**Primary Inspiration:**
- **RIME** - Our main architectural inspiration. When implementing features, study RIME's approach first for design patterns and implementation strategies.

**Achaea-Specific References:**
- **SVOF** - Reference for Achaea-specific mechanics and curing logic
- **Legacy** - Additional Achaea codebase reference for game mechanics

Always prioritize RIME's architectural patterns and design philosophy when creating new modules or features, while using SVOF and Legacy for Achaea-specific game mechanics and content.

### Using Resources Effectively
1. **For Lua Development**: Always consult the `lua-expert` agent for optimal patterns
2. **For Module Creation**: Use `mudlet-lua-generator` with the event-driven architecture
3. **For Trigger Patterns**: Use `mud-pattern-matcher` for reliable regex patterns
4. **For Documentation**: Use `reference-builder` to create exhaustive references
5. **For Game Mechanics**: Search `resources/wiki-repo/` for Achaea-specific information

## Core API Reference

### Shared Utility Functions

All EMERGE modules and agents can rely on these core utility functions:

#### Module Source Access
```lua
-- Get the source code of a module as a table of lines
function emerge.get_module_source(module_name)
    -- Returns: table of strings (lines of code)
    -- Returns nil if module not found
end
```

#### State Management Extensions
```lua
emerge.state.get_all()                           -- Get entire state tree
emerge.state.reset()                             -- Reset to defaults
emerge.state.batch(function)                     -- Batch state updates
```

#### Validation Utilities
```lua
-- Check for direct module calls in source code
function emerge.validate.has_direct_calls(source_lines)
    -- Returns: {found = boolean, violations = table}
    local violations = {}
    for line_num, line in ipairs(source_lines) do
        if line:match("emerge%.%w+%.%w+%(") and 
           not line:match("emerge%.events") and
           not line:match("emerge%.state") and
           not line:match("emerge%.config") then
            table.insert(violations, {line = line_num, code = line})
        end
    end
    return {found = #violations > 0, violations = violations}
end

-- Validate event name follows conventions
function emerge.validate.event_name(event_name)
    -- Pattern: module.subject.action
    local pattern = "^[%w_]+%.[%w_]+%.[%w_]+$"
    return event_name:match(pattern) ~= nil
end

-- Check module structure
function emerge.validate.module_structure(module)
    local required = {"init"}
    local missing = {}
    for _, func in ipairs(required) do
        if not module[func] then
            table.insert(missing, func)
        end
    end
    return {valid = #missing == 0, missing = missing}
end
```

### Mudlet-Specific Functions
```lua
tempTimer(delay, callback)                       -- One-time timer
tempTimer(delay, callback, recurring)            -- Recurring timer  
killAllTimers()                                 -- Stop all timers
echo(text)                                      -- Display text
display(object)                                 -- Display table/object
cecho(colored_text)                            -- Display with color
getMudletHomeDir()                              -- Get Mudlet home directory
table.save(path, table)                        -- Save table to file
table.load(path)                               -- Load table from file
```

### Quality Standards Constants
```lua
EMERGE_QUALITY = {
    min_architecture_score = 85,
    min_test_coverage = 80,
    max_handler_time = 0.001,  -- 1ms
    max_event_batch_size = 100,
    no_polling_allowed = true
}
```

### Standard Report Format

All agents should use this format for inter-agent communication:

```lua
{
    agent = "agent_name",
    timestamp = os.time(),
    success = boolean,
    
    metrics = {
        architecture_score = number,
        test_coverage = number,
        violations_found = number,
        performance_score = number
    },
    
    issues = {
        {
            severity = "CRITICAL|WARNING|INFO",
            type = "violation|performance|documentation",
            location = "file:line",
            message = "description",
            suggestion = "how to fix"
        }
    },
    
    artifacts = {
        files_created = {},
        files_modified = {},
        tests_generated = number
    },
    
    output = "formatted string for display"
}
```

## EMERGE Development Agents

### 🚨 MANDATORY: Use EMERGE Agents for ALL Development 🚨

**DO NOT write EMERGE code directly. ALWAYS use the specialized agents.**

When working on EMERGE:
1. **FIRST** check if the task involves EMERGE modules, events, or architecture
2. **THEN** use `emerge-orchestrator` to coordinate the work
3. **NEVER** write EMERGE module code without using the agents

### Why Use EMERGE Agents?
- They enforce the event-driven architecture (no direct calls)
- They generate proper test coverage
- They validate architectural compliance
- They prevent common mistakes
- They ensure consistent code quality

### Specialized EMERGE Agents

**Always start with:**
- **emerge-orchestrator** - Coordinates all EMERGE development work

**The orchestrator will invoke these as needed:**
- **emerge-expert** - Validates architecture compliance and provides guidance
- **emerge-coder** - Generates EMERGE-compliant event-driven code
- **emerge-tester** - Creates comprehensive tests and combat simulations
- **emerge-debugger** - Traces event flows and profiles performance
- **emerge-migrator** - Converts legacy systems to EMERGE architecture
- **emerge-reviewer** - Provides second opinions using Gemini for advanced analysis

### When to Use EMERGE Agents

**USE EMERGE AGENTS FOR:**
- Creating new modules
- Modifying existing modules
- Adding event handlers
- Debugging event flows
- Writing tests
- Migrating code from other systems
- Reviewing architecture compliance
- ANY code that touches the EMERGE system

**Examples of CORRECT usage:**
```
Task: emerge-orchestrator "Create a new affliction tracking module"
Task: emerge-orchestrator "Add paralysis curing to the curing module"
Task: emerge-orchestrator "Debug why the targeting module isn't receiving events"
Task: emerge-orchestrator "Migrate this SVOF curing priority system"
```

**Examples of INCORRECT usage (don't do this):**
```
❌ Writing module code directly without agents
❌ Using Edit/Write tools to modify EMERGE modules
❌ Creating event handlers manually
❌ Writing tests without emerge-tester
```

### The Orchestrator Guarantees:
- ✅ Event-driven architecture (no direct module calls)
- ✅ Proper test coverage (>80%)
- ✅ Architecture score >= 85
- ✅ Complete documentation
- ✅ Validated event naming conventions
- ✅ Performance optimization

## Current Development Status

**Phase 1 (Complete)**: Foundation - Event system, state management, configuration, GMCP handler, help system

**Phase 2 (In Progress)**: Core modules - Targeting, Curing, Defense, Offense, Bashing

**Phase 3 (Planned)**: Class modules - Class-specific combat logic

**Phase 4 (Planned)**: Intelligence - Emergent behavior patterns