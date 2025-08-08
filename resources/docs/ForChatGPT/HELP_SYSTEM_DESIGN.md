# EMERGE Help System Design

## Overview

The help system needs to be a core module that all other modules can register with automatically. It should be searchable, categorized, and provide both quick help and detailed documentation.

## Architecture

### Module: emerge-core-help

**Load Order**: After emerge-core-events, before all other modules

**Purpose**: Centralized, searchable help system that auto-discovers module documentation

## How It Works

### 1. Module Registration

When any module loads, it registers its help information:

```lua
-- In each module's init()
local help_data = {
    name = "EMERGE Curing",
    version = "1.0.0",
    description = "Automated affliction curing system",
    category = "combat",  -- combat/utility/ui/system/optional
    
    aliases = {
        {
            pattern = "cure on|off",
            description = "Enable or disable curing",
            examples = {"cure on", "cure off"}
        },
        {
            pattern = "cure prio <affliction> <number>",
            description = "Set affliction priority",
            examples = {"cure prio paralysis 1", "cure prio stupidity 25"}
        }
    },
    
    events = {
        emits = {
            "emerge.curing.started",
            "emerge.curing.stopped",
            "emerge.affliction.cured"
        },
        handles = {
            "emerge.gmcp.affliction.added",
            "emerge.gmcp.affliction.removed"
        }
    },
    
    topics = {
        "priorities" = "Curing priorities determine the order...",
        "modes" = "Curing modes allow you to switch between...",
        "customization" = "You can customize curing by..."
    }
}

-- Register with help system
raiseEvent("emerge.help.register", "emerge-curing", help_data)
```

### 2. Help Aliases

Core help aliases that always exist:

```lua
ehelp                    -- Main help menu
ehelp <module>          -- Help for specific module
ehelp search <term>     -- Search all help
ehelp category <cat>    -- List modules by category
ehelp aliases           -- List all aliases
ehelp aliases <module>  -- List module's aliases
ehelp events            -- Show event flow diagram
```

### 3. Smart Search

The help system searches across:
- Module names
- Alias patterns
- Descriptions
- Category tags
- Help topics
- Examples

```lua
ehelp search cure
-- Returns:
-- Modules: emerge-curing, emerge-defenses
-- Aliases: cure on|off, cure prio, def up
-- Topics: curing priorities, curing modes
```

### 4. Auto-Generated Documentation

The help system can generate:
- Module dependency graphs
- Event flow diagrams
- Alias quick reference cards
- PDF/HTML documentation

### 5. Interactive Help

```lua
ehelp interactive
-- Starts interactive mode:
-- "What would you like help with?"
-- > curing
-- "Here are curing-related topics:"
-- 1. Enable/disable curing (cure on|off)
-- 2. Set priorities (cure prio)
-- 3. View current afflictions (affs)
-- "Select a number or type 'back':"
```

## Implementation Details

### Data Structure

```lua
emerge.help = {
    modules = {},      -- Registered module help
    aliases = {},      -- Quick alias lookup
    categories = {},   -- Categorized modules
    search_index = {}, -- Full-text search index
    history = {},      -- Recent help queries
    favorites = {}     -- User's bookmarked topics
}
```

### Events

```lua
-- Registration
"emerge.help.register"    -- Module registers its help
"emerge.help.unregister"  -- Module unloading

-- Queries  
"emerge.help.query"       -- Request help on topic
"emerge.help.search"      -- Search for term
"emerge.help.list"        -- List available topics

-- Responses
"emerge.help.found"       -- Help content found
"emerge.help.not_found"   -- No matching help
"emerge.help.suggestions" -- Did you mean...?
```

### Display Formatting

```lua
function emerge.help.format(data)
    -- Beautiful formatted output
    -- ╔══════════════════════════════════════╗
    -- ║  EMERGE Curing System v1.0.0         ║
    -- ╠══════════════════════════════════════╣
    -- ║  Automated affliction curing system   ║
    -- ╟──────────────────────────────────────╢
    -- ║  ALIASES:                            ║
    -- ║    cure on|off    Enable curing      ║
    -- ║    cure prio      Set priorities     ║
    -- ╟──────────────────────────────────────╢
    -- ║  Type 'ehelp curing <topic>' for:    ║
    -- ║    priorities, modes, customization  ║
    -- ╚══════════════════════════════════════╝
end
```

## Module Categories

Standard categories all modules should use:

- **combat** - Combat automation (curing, offense, defense)
- **utility** - Helper functions (mapping, highlighting)
- **ui** - User interface elements
- **system** - Core system modules
- **optional** - Nice-to-have features
- **class** - Class-specific modules
- **trade** - Trade skills and commerce
- **social** - Communication and social features

## Help Content Standards

Every module MUST provide:
1. Module name and version
2. One-line description
3. Category classification
4. List of aliases with descriptions
5. At least one example per alias

Every module SHOULD provide:
1. Detailed topic documentation
2. Configuration options
3. Event documentation
4. Troubleshooting guide
5. Performance impact notes

## Integration with emerge-core-events

The help system uses the enhanced event system:

```lua
-- Module asks for help
raiseEvent("emerge.help.query", "curing")

-- Help system responds
raiseEvent("emerge.help.found", "curing", help_content)

-- Subscribe to help updates
raiseEvent("emerge.subscribe", "emerge.help.updated", "my_module")
```

## Search Algorithm

1. Exact module name match
2. Exact alias match
3. Fuzzy module name match
4. Alias pattern match
5. Description keyword match
6. Topic content match
7. Example match

Results weighted by:
- Relevance score
- Module priority (core > optional)
- Usage frequency
- User favorites

## Accessibility Features

- **Verbose mode**: Detailed explanations
- **Compact mode**: Just the commands
- **Screen reader friendly**: Clean text output
- **Color coding**: Visual category indicators
- **Breadcrumbs**: Show help navigation path

## Example Help Flow

```
> ehelp
═══════════════════════════════════════════════════
  EMERGE - Emergent Modular Engagement & Response
═══════════════════════════════════════════════════
  
  Loaded Modules: 12
  Available Aliases: 47
  
  QUICK HELP:
    ehelp <module>     - Module-specific help
    ehelp search       - Search all documentation  
    ehelp aliases      - List all commands
    ehelp category     - Browse by category
    
  RECENT:
    curing, targeting, gmcp
    
  Type 'ehelp tutorial' for getting started guide
═══════════════════════════════════════════════════

> ehelp search cure
Found 3 matches for 'cure':

  MODULES:
    emerge-curing - Automated affliction curing
    
  ALIASES:
    cure on|off - Enable/disable curing
    cure prio <aff> <num> - Set priority
    
  TOPICS:
    Curing Priorities (in emerge-curing)
    Pre-caching Cures (in emerge-inventory)
    
Type 'ehelp <item>' for details

> ehelp cure prio
═══════════════════════════════════════════════════
  Command: cure prio <affliction> <number>
  Module: emerge-curing
  Category: combat
═══════════════════════════════════════════════════
  
  Sets the curing priority for an affliction.
  Lower numbers = higher priority (cured first)
  
  SYNTAX:
    cure prio <affliction> <number>
    
  EXAMPLES:
    cure prio paralysis 1      -- Highest priority
    cure prio stupidity 25     -- Lower priority
    cure prio recklessness 10  -- Medium priority
    
  RELATED:
    cure list prios - Show current priorities
    cure reset prios - Reset to defaults
    cure import <name> - Import priority set
═══════════════════════════════════════════════════
```

## Performance Considerations

- Lazy load help content (don't load until needed)
- Cache search results
- Index on module load, not on search
- Async search for large datasets
- Limit search results to prevent spam

## Testing Requirements

- Module registration works
- Search returns relevant results
- Categories filter correctly
- Aliases are discoverable
- Events flow properly
- Performance under load (50+ modules)
- Help content formatting
- Error handling for missing help

## Success Metrics

✅ Every module has help
✅ Search returns results in <100ms
✅ 90% of queries find relevant help
✅ Help is accessible without leaving game
✅ New users can learn system via help
✅ Power users can quick-reference commands

## Implementation Priority

The help system should be part of our core modules:

1. **emerge-core-events** (Week 1)
2. **emerge-core-help** (Week 1 - Days 3-4)
3. **emerge-gmcp** (Week 2)

Building help early means every subsequent module can integrate with it from day one.

---

*The help system is how users learn EMERGE. Make it amazing.*