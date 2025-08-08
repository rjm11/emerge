# EMERGE Repository Structure

## Repository Organization

EMERGE uses multiple GitHub repositories for different module types:

### 1. Public Repository (`emerge`)
**URL**: https://github.com/rjm11/emerge
**Contents**:
```
emerge/
├── manager/
│   └── emerge-manager.lua    # Core module manager
└── manifest.json             # Module registry
```

### 2. Private Repository (`emerge-private`)
**URL**: https://github.com/rjm11/emerge-private
**Contents**:
```
emerge-private/
├── required/                 # Core required modules
│   ├── emerge-core.lua      # Event system
│   ├── emerge-gmcp.lua      # GMCP handler (future)
│   └── emerge-help.lua      # Help system (future)
├── optional/                 # Optional modules
│   ├── emerge-test-module.lua
│   └── emerge-translator.lua (future)
└── manifest.json            # Module registry
```

### 3. Development Repository (`emerge-dev`)
**URL**: https://github.com/rjm11/emerge-dev
**Contents**: Work-in-progress modules and experimental features

## Manifest Structure

Each repository contains a `manifest.json` file:

```json
{
  "repository": "emerge-private",
  "updated": "2025-01-07T00:00:00Z",
  "description": "Repository description",
  "modules": {
    "module-id": {
      "version": "1.0.0",
      "path": "required/module.lua",
      "type": "required|optional",
      "description": "Module description",
      "author": "Author name",
      "dependencies": ["emerge-core"],
      "changelog": "What's new"
    }
  }
}
```

## Module Discovery Flow

1. **Manager loads** from public repo
2. **Manager discovers** modules via manifest.json from each repo
3. **User sees** all available modules with `emodule list`
4. **User loads** specific modules with `emodule load <module>`
5. **Manager downloads** module from appropriate repo
6. **Module registers** with manager and initializes

## Commands

### Discovery Commands
- `emodule refresh` - Refresh module cache from all repos
- `emodule repos` - List configured repositories
- `emodule list` - Show all available and loaded modules
- `emodule search <term>` - Search for modules
- `emodule info <module>` - Show detailed module info

### Module Management
- `emodule load <module>` - Download and load a module
- `emodule unload <module>` - Unload a module
- `emodule update` - Check for updates
- `emodule upgrade <module>` - Update a specific module

## Setup Instructions

### 1. Install Manager
```lua
-- Download manager from public repo
downloadFile(
  getMudletHomeDir().."/manager/emerge-manager.lua",
  "https://raw.githubusercontent.com/rjm11/emerge/main/manager/emerge-manager.lua"
)

-- Load it
dofile(getMudletHomeDir().."/manager/emerge-manager.lua")
```

### 2. Configure GitHub Token (for private repos)
```lua
-- Get token from: https://github.com/settings/tokens
emodule token ghp_YOUR_TOKEN_HERE
```

### 3. Discover Modules
```lua
-- Refresh cache to discover all modules
emodule refresh

-- List all available modules
emodule list
```

### 4. Load Modules
```lua
-- Load core module
emodule load emerge-core

-- Load optional modules
emodule load emerge-test-module
```

## Testing

Run the discovery test suite:
```lua
-- Edit token in test file first
dofile(getMudletHomeDir().."/test_discovery.lua")
```

## Local Development Structure

For local development before pushing to GitHub:

```
EMERGE Research/
├── manager/
│   └── emerge-manager.lua
├── private-repo/
│   ├── required/
│   │   └── emerge-core.lua
│   ├── optional/
│   │   └── emerge-test-module.lua
│   └── manifest.json
├── manifest.json
└── test_discovery.lua
```

## Version Management

- Modules use semantic versioning (MAJOR.MINOR.PATCH)
- Manager compares versions and alerts to updates
- Never auto-updates without user permission
- Use `emodule update` to check for updates
- Use `emodule upgrade <module>` to update specific module

## Cache Management

- Discovery cache expires after 1 hour
- Use `emodule refresh` to force update
- Cache stored in `emerge-cache/` folder
- Reduces GitHub API calls

## Troubleshooting

### Module not found
1. Run `emodule refresh` to update cache
2. Check `emodule repos` to verify repository access
3. Verify GitHub token with `emodule token`

### Private repo access denied
1. Ensure GitHub token is set
2. Token needs `repo` scope for private repos
3. Test with `emodule repos` command

### Discovery not working
1. Check internet connection
2. Verify manifest.json exists in repo
3. Check GitHub API rate limits
4. Try `emodule refresh` to force update