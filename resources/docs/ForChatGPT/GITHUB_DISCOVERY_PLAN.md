# GitHub Module Discovery Implementation Plan

## Current Manager Capabilities ✅
- Downloads specific files from GitHub
- Supports private repos with tokens
- Checks if individual files exist

## Missing Capabilities ❌
- **Cannot list directory contents** from GitHub repos
- **Cannot discover modules** automatically
- **No multi-repo support** (hardcoded to single repo)

## Required GitHub API Integration

### 1. Directory Listing API
To discover modules, we need to use GitHub's Contents API:
```
GET https://api.github.com/repos/{owner}/{repo}/contents/{path}
```

Returns JSON array:
```json
[
  {
    "name": "emerge-core.lua",
    "path": "required/emerge-core.lua",
    "type": "file",
    "size": 15234,
    "download_url": "https://raw.githubusercontent.com/..."
  },
  ...
]
```

### 2. Module Discovery Flow

```lua
function ModuleManager:discoverModules(repo_config)
  -- repo_config = {owner = "rjm11", repo = "emerge-private", branch = "main"}
  
  -- 1. List contents of /required folder
  local required_url = string.format(
    "https://api.github.com/repos/%s/%s/contents/required",
    repo_config.owner, repo_config.repo
  )
  
  -- 2. List contents of /optional folder  
  local optional_url = string.format(
    "https://api.github.com/repos/%s/%s/contents/optional",
    repo_config.owner, repo_config.repo
  )
  
  -- 3. Download and parse directory listings
  -- 4. Extract module names from .lua files
  -- 5. Cache the module list
end
```

### 3. Version Checking

Each module needs a version. Options:

**Option A: Module Manifest (Recommended)**
```json
// emerge-private/manifest.json
{
  "modules": {
    "emerge-core": {
      "version": "1.0.0",
      "path": "required/emerge-core.lua",
      "type": "required",
      "description": "Core event system"
    },
    "emerge-test-module": {
      "version": "1.0.0", 
      "path": "optional/emerge-test-module.lua",
      "type": "optional"
    }
  }
}
```

**Option B: Parse Version from Files**
- Download first 50 lines of each module
- Extract MODULE_VERSION constant
- More API calls, slower

### 4. Multi-Repository Support

```lua
ModuleManager.repositories = {
  {
    name = "emerge-public",
    owner = "rjm11",
    repo = "emerge",
    branch = "main",
    public = true
  },
  {
    name = "emerge-private",
    owner = "rjm11", 
    repo = "emerge-private",
    branch = "main",
    public = false  -- Requires token
  },
  {
    name = "emerge-dev",
    owner = "rjm11",
    repo = "emerge-dev",
    branch = "main",
    public = false
  }
}
```

## Implementation Requirements

### Manager Updates Needed:

1. **Add Repository Discovery**
```lua
function ModuleManager:discoverRepoModules(owner, repo, branch)
  -- Use GitHub API to list directories
  -- Parse response for .lua files
  -- Return module list with metadata
end
```

2. **Update Module List Command**
```lua
function ModuleManager:listModules()
  -- Show LOCAL loaded modules
  -- Show AVAILABLE modules from all repos (cached)
  -- Indicate which need downloading
end
```

3. **Add Module Caching**
```lua
-- Cache discovered modules to reduce API calls
ModuleManager.discovered_modules = {
  last_check = 0,
  cache_duration = 3600, -- 1 hour
  modules = {}
}
```

4. **Version Management**
```lua
function ModuleManager:checkModuleUpdates()
  -- Compare local versions with repo versions
  -- Alert user to available updates
  -- Never auto-update without permission
end
```

## Directory Structure

### Public Repo (emerge)
```
emerge/
├── manager/
│   └── emerge-manager.lua
└── manifest.json
```

### Private Repo (emerge-private)
```
emerge-private/
├── required/
│   ├── emerge-core.lua
│   ├── emerge-gmcp.lua
│   └── emerge-help.lua
├── optional/
│   ├── emerge-test-module.lua
│   └── emerge-translator.lua
└── manifest.json
```

## Testing Plan

1. Move manager to `manager/` folder
2. Upload to public repo
3. Move core and test modules to private repo
4. Test discovery with token
5. Test listing without downloading
6. Test version checking

## API Rate Limits

GitHub API limits:
- **Without token**: 60 requests/hour
- **With token**: 5000 requests/hour

Need to cache aggressively to avoid limits.

## Will This Work?

**YES**, but requires manager updates:

### ✅ What Works Now:
- Downloading known modules
- Private repo access with token
- Basic GitHub integration

### ❌ What Needs Adding:
- Directory listing via GitHub API
- Module discovery and caching
- Multi-repo support
- Version comparison
- Manifest parsing

### Estimated Work:
- 200-300 lines of new code in manager
- Main challenge: Parsing GitHub API responses
- Solution: Use yajl.to_value() for JSON parsing

## Recommended Approach

1. **Start Simple**: Use manifest.json in each repo
2. **Single Discovery Call**: Download manifest, not individual files
3. **Cache Aggressively**: Reduce API calls
4. **Manual Refresh**: `emodule refresh` to update cache
5. **Show Everything**: List shows all, but indicates what's local vs available

## Quick Test

Before moving everything, test GitHub Contents API:
```lua
-- In Mudlet
downloadFile(
  getMudletHomeDir().."/github-test.json",
  "https://api.github.com/repos/rjm11/emerge-private/contents/",
  {["Authorization"] = "token YOUR_TOKEN"}
)

-- Check the response
local f = io.open(getMudletHomeDir().."/github-test.json", "r")
print(f:read("*all"))
f:close()
```

If this returns a JSON array of files/folders, discovery will work!