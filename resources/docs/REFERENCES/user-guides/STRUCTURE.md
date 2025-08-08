# EMERGE System - Directory Structure

## Simple 3-Directory Organization

```
achaea/                     # Root directory (in MudletHomeDir)
│
├── init.lua               # Main loader - starts everything
├── README.md              # User documentation
├── CLAUDE.md              # AI assistant reference
├── STRUCTURE.md           # This file
│
├── core/                  # Core system modules (foundation)
│   ├── events.lua        # Event system - how modules communicate
│   ├── state.lua         # State management - saves your settings
│   ├── config.lua        # Configuration - user preferences
│   ├── utils.lua         # Utility functions - helpers
│   └── help.lua          # Help system - documentation
│
├── modules/              # Feature modules (all self-contained)
│   ├── gmcp.lua         # GMCP handler - game data events
│   ├── test_demo.lua    # Test/demo module (optional)
│   └── [future modules] # targeting, curing, offense, etc.
│
├── misc/                 # Everything else
│   ├── tests/           # Test suites
│   │   ├── test_events.lua
│   │   └── test_phase1.lua
│   ├── aliases/         # Mudlet aliases
│   │   └── ehelp.lua
│   ├── docs/            # Additional documentation
│   ├── examples/        # Example code
│   └── [other files]    # Diagrams, installers, etc.
│
└── resources/           # Reference materials
    ├── wiki-repo/       # Mudlet API documentation
    └── rime_extracted/  # Rime system analysis (inspiration)
```

## Key Points

1. **Three Simple Directories**:
   - `core/` - Foundation modules that make the system work
   - `modules/` - Feature modules that do specific things
   - `misc/` - Everything else (tests, docs, examples, etc.)

2. **Each Module is Self-Contained**:
   - Every `.lua` file in `modules/` is a complete, independent module
   - Modules communicate only through events, never direct calls
   - Easy to add/remove modules without breaking anything

3. **Load Order**:
   - Core modules load first (in specific order)
   - Feature modules load after
   - See `init.lua` for the exact load order

4. **Adding New Modules**:
   - Create a new `.lua` file in `modules/`
   - Add it to the load order in `init.lua`
   - That's it!

## Usage

```lua
-- Load the system
lua dofile(getMudletHomeDir().."/achaea/init.lua")

-- Run tests
lua dofile(getMudletHomeDir().."/achaea/misc/tests/test_phase1.lua").run()

-- Get help
ehelp
```

This simplified structure makes the system easier to understand and maintain!