# EMERGE - Emergent Modular Engagement & Response Generation Engine

A next-generation combat system for Achaea built on event-driven architecture where complex behaviors emerge from simple module interactions.

## 🚀 Quick Start

1. Install the manager in Mudlet:
```lua
lua installModule("modules/required/emerge-manager.lua")
```

2. Load core modules:
```lua
emodule load emerge-core
emodule load emerge-core-state
emodule load emerge-core-config
```

3. Check system status:
```lua
emodule list
```

## 📁 Project Structure

```
EMERGE Research/
├── modules/                    # All EMERGE modules
│   ├── required/               # Core modules (must be loaded)
│   │   └── emerge-manager.lua  # Module loading system
│   └── optional/               # Optional combat modules
│       └── emerge-test-module.lua
├── tests/                      # Test suites
├── resources/                  # Reference implementations
├── CLAUDE REFERENCE/           # AI assistant documentation
│   ├── analysis/              # System analysis docs
│   ├── architecture/          # Architecture guidelines  
│   ├── development/           # Development guides
│   └── agents/                # AI agent configs
├── REFERENCES/                 # User documentation
│   ├── user-guides/           # User manuals
│   ├── combat-system/         # Combat mechanics
│   └── game-mechanics/        # Achaea game info
├── archive/                    # Old/deprecated files
└── CLAUDE.md                   # AI assistant instructions
```

## 🏗️ Architecture

EMERGE uses a pure event-driven architecture where modules communicate exclusively through events:

```lua
-- WRONG: Direct module calls
achaea.curing.add_affliction("paralysis")

-- CORRECT: Event-based communication  
raiseEvent("affliction.gained", "paralysis")
```

### Core Principles

1. **Golden Rule**: No direct module calls - all communication through events
2. **Emergent Behavior**: Complex combat patterns emerge from simple module interactions
3. **Dynamic Loading**: Modules can be loaded/unloaded at runtime
4. **Event-Driven**: Uses Mudlet's native `raiseEvent()` for all communication
5. **Modular Design**: Each module is self-contained and independent

## 📦 Module Categories

### Required Modules
- `emerge-manager` - Core module loading and management system
- `emerge-core-events` - Enhanced event system (coming soon)
- `emerge-core-state` - State management (coming soon)
- `emerge-core-config` - Configuration system (coming soon)

### Optional Modules
- `emerge-gmcp` - GMCP data handler
- `emerge-curing` - Affliction curing system
- `emerge-targeting` - Target management
- `emerge-offense` - Attack automation
- Class-specific modules

## 🔧 Development

### Creating a New Module

Use this template for all modules:

```lua
local MODULE_NAME = "emerge-module-name"
local MODULE_VERSION = "1.0.0"

local Module = {
    name = "Module Display Name",
    version = MODULE_VERSION,
    handlers = {}
}

function Module:init()
    -- Register event handlers
    self.handlers.example = registerAnonymousEventHandler("event.name", 
        function(event, ...) self:handleEvent(...) end)
    
    -- Announce module loaded
    raiseEvent("emerge.module.loaded", MODULE_NAME, MODULE_VERSION)
end

function Module:unload()
    -- Clean up
    for _, id in pairs(self.handlers) do
        killAnonymousEventHandler(id)
    end
end

-- Register with manager
if EMERGE then
    EMERGE:registerModule(MODULE_NAME, Module)
    Module:init()
end

return Module
```

### Event Naming & Lifecycle

Use dot notation for event namespacing:
- `emerge.*` - System events
- `combat.*` - Combat events  
- `curing.*` - Curing events
- `gmcp.*` - GMCP data events
- `module.*` - Module lifecycle

Lifecycle around load/unload:
- Manager emits `module.lifecycle.preload/load/postload` when loading a module and `module.lifecycle.preunload/unload` when unloading. Modules must remove timers/handlers/aliases in `preunload`.

Config & capabilities:
- Register config schemas via `emerge.config.register('<ns>', schema)` and access via `emerge.config.get/set`.
- Declare capabilities via `emerge.capabilities.provide(...)` and check with `require(...)`.

## 🧪 Testing

Run tests with:
```lua
lua dofile("tests/test_emerge_test_module.lua")
```

## 📝 Documentation

- **For Users**: Check `REFERENCES/` folder
- **For Developers**: Check `CLAUDE REFERENCE/` folder
- **AI Instructions**: See `CLAUDE.md`

## 🤝 Contributing

Development repository: https://github.com/rjm11/emerge-dev

1. Fork the repository
2. Create a feature branch
3. Follow the module template
4. Ensure golden rule compliance
5. Add tests for your module
6. Submit a pull request

## 📜 License

MIT License - See LICENSE file for details

## 🎯 Roadmap

### Phase 1: Foundation ✅
- [x] Module manager
- [x] Test module template
- [ ] Core event system
- [ ] State management
- [ ] Configuration system

### Phase 2: Combat Core
- [ ] GMCP handler
- [ ] Affliction tracking
- [ ] Curing system
- [ ] Defense management

### Phase 3: Offense
- [ ] Target management
- [ ] Attack queuing
- [ ] Class modules

### Phase 4: Advanced
- [ ] Bashing automation
- [ ] UI components
- [ ] Analytics

## 💬 Support

- GitHub Issues: https://github.com/rjm11/emerge-dev/issues
- Documentation: See `REFERENCES/` folder

---

*From simplicity, emerges victory.*
