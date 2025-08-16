-- EMERGE: Emergent Modular Engagement & Response Generation Engine
-- Self-updating module system with external configuration
-- Version: 0.7.4

local CURRENT_VERSION = "0.7.4"
local MANAGER_ID = "EMERGE"

-- Check if already loaded and handle version updates
if EMERGE and EMERGE.loaded then
  if EMERGE.version ~= CURRENT_VERSION then
    cecho(string.format("<DarkOrange>[EMERGE] Version update: %s -> %s<reset>\n",
      EMERGE.version, CURRENT_VERSION))

    -- Preserve important data
    local preserved = {
      modules = EMERGE.modules,
      config = EMERGE.config,
      custom_modules = EMERGE.custom_modules
    }

    -- Unload old version
    if EMERGE.unload then
      EMERGE:unload(true) -- true = updating, don't unload modules
    end

    -- Restore data after module recreation
    tempTimer(0.1, function()
      if EMERGE and preserved then
        EMERGE.modules = preserved.modules
        EMERGE.config = preserved.config
        EMERGE.custom_modules = preserved.custom_modules
      end
    end)
  else
    -- Already loaded - check if this is during initial setup
    if not (EMERGE.installing or EMERGE.creating_bootloader or EMERGE._force_reload) then
      cecho("<DarkOrange>[EMERGE] Already loaded.<reset>\n")
    end
    if not EMERGE._force_reload then
      return
    end
    -- continue with forced reload
  end
end

-- Create EMERGE Manager
EMERGE = EMERGE or {}
EMERGE.version = CURRENT_VERSION
-- Don't reset loaded flag if we're updating
if not EMERGE.loaded then
  EMERGE.loaded = false
end
EMERGE.modules = EMERGE.modules or {}
-- IMPORTANT: Don't reset aliases/handlers if they exist - we need to clean them up first!
EMERGE.aliases = EMERGE.aliases or {}
EMERGE.handlers = EMERGE.handlers or {}
EMERGE.overwrite_queue = {}
EMERGE.overwrite_in_progress = false
EMERGE.loading_modules = EMERGE.loading_modules or {}

-- For backward compatibility
ModuleManager = EMERGE

-- Utility function for counting table entries
local function tsize(t)
  if table and table.size then return table.size(t) end
  local count = 0
  for _ in pairs(t or {}) do count = count + 1 end
  return count
end

-- Configuration paths
ModuleManager.paths = {
  config = getMudletHomeDir() .. "/emerge-config.json",
  custom = getMudletHomeDir() .. "/emerge-custom-modules.json",
  cache = getMudletHomeDir() .. "/emerge-cache/"
}

-- Default module registry - empty until modules are actually created
-- Modules can be added via 'emodule github' command
ModuleManager.default_registry = {}

-- Multi-repository configuration
ModuleManager.repositories = {
  {
    name = "emerge", -- Main public repository
    owner = "rjm11",
    repo = "emerge",
    branch = "main",
    public = true,
    description = "Public manager and core system"
  },
  {
    name = "emerge-private", -- Private modules repository
    owner = "rjm11",
    repo = "emerge-private",
    branch = "main",
    public = false,
    description = "Private combat modules",
    requires_token = true -- Only attempt if token is set
  },
  {
    name = "emerge-dev", -- Developer modules repository
    owner = "rjm11",
    repo = "emerge-dev",
    branch = "main",
    public = false,
    description = "Untested developer modules",
    requires_token = true,
    dev_only = true
  }
}

-- GitHub configuration for self-updates (backward compatibility)
ModuleManager.github = {
  owner = "rjm11",
  repo = "emerge",
  branch = "main",
  files = {
    manager = "emerge-manager.lua",
    registry = "emerge-registry.json"
  },
  last_check = 0
}

-- Discovery cache
ModuleManager.discovery_cache = {
  last_refresh = 0,
  cache_duration = 3600, -- 1 hour
  manifests = {},        -- Cached manifest data per repo
  modules = {}           -- Flat list of all discovered modules
}

-- Load configuration from file
function ModuleManager:loadConfig()
  -- Create cache directory if it doesn't exist
  if not io.exists(self.paths.cache) then
    lfs.mkdir(self.paths.cache)
  end

  -- Load main config
  if io.exists(self.paths.config) then
    local file = io.open(self.paths.config, "r")
    if file then
      local content = file:read("*all")
      file:close()
      local ok, config = pcall(yajl.to_value, content)
      if ok and config then
        self.config = config
      end
    end
  else
    -- Create default config
    self.config = {
      auto_update = true,
      update_interval = 3600, -- 1 hour
      auto_load_modules = true,
      debug = false,
      show_dev_modules = false
    }
    self:saveConfig()
  end

  -- Load custom modules list
  if io.exists(self.paths.custom) then
    local file = io.open(self.paths.custom, "r")
    if file then
      local content = file:read("*all")
      file:close()
      local ok, custom = pcall(yajl.to_value, content)
      if ok and custom then
        self.custom_modules = custom
      end
    end
  else
    self.custom_modules = {}
  end
end

-- Save configuration
function ModuleManager:saveConfig()
  local file = io.open(self.paths.config, "w")
  if file then
    file:write(yajl.to_string(self.config))
    file:close()
  end
end

-- Save custom modules
function ModuleManager:saveCustomModules()
  local file = io.open(self.paths.custom, "w")
  if file then
    file:write(yajl.to_string(self.custom_modules))
    file:close()
  end
end

-- Get complete module list (default + custom + discovered)
function ModuleManager:getModuleList()
  local all_modules = {}

  -- Add default modules
  for id, module in pairs(self.default_registry) do
    all_modules[id] = table.deepcopy(module)
  end

  -- Add discovered modules from cache
  for id, module in pairs(self.discovery_cache.modules) do
    if not all_modules[id] then -- Don't override custom modules
      all_modules[id] = table.deepcopy(module)
    end
  end

  -- Add/override with custom modules
  for id, module in pairs(self.custom_modules) do
    all_modules[id] = table.deepcopy(module)
  end

  return all_modules
end

-- Register a loaded module
function ModuleManager:register(module_id, module_table)
  self.modules[module_id] = module_table
  cecho(string.format("<LightSteelBlue>[EMERGE] Registered: %s v%s<reset>\n",
    module_id, module_table.version or "unknown"))
end

-- Register a module (API alias for compatibility)
function ModuleManager:registerModule(module_id, module_obj)
  if not module_id then
    cecho("<IndianRed>[EMERGE] Error: registerModule requires module_id<reset>\n")
    return false
  end

  if not module_obj then
    cecho("<IndianRed>[EMERGE] Error: registerModule requires module_obj<reset>\n")
    return false
  end

  -- Check if module is already registered
  if self.modules[module_id] then
    cecho(string.format("<yellow>[EMERGE] Warning: Overwriting existing module: %s<reset>\n", module_id))
  end

  -- Store the actual module object (not just boolean)
  self.modules[module_id] = module_obj

  -- Debug output
  local version = "unknown"
  if type(module_obj) == "table" and module_obj.version then
    version = tostring(module_obj.version)
  end

  cecho(string.format("<LightSteelBlue>[EMERGE] Registered module: %s v%s<reset>\n",
    module_id, version))

  -- Emit event for system integration (if event system is available)
  if emerge and emerge.events then
    emerge.events:emit("module.installed", module_id)
  end

  return true
end

-- Compatibility alias for emerge-core and other legacy modules
-- (removed duplicate register alias)
-- (migrated to primary register implementation)
--

-- Unregister a module
function ModuleManager:unregister(module_id)
  self.modules[module_id] = nil
end

-- Add custom module
function ModuleManager:addModule(module_id, module_info)
  self.custom_modules[module_id] = module_info
  self:saveCustomModules()
  cecho(string.format("<LightSteelBlue>[EMERGE] Added custom module: %s<reset>\n", module_id))
end

-- Add module from GitHub URL
function ModuleManager:addGitHub(github_url)
  if not github_url or github_url == "" then
    cecho("<IndianRed>[EMERGE] Usage: emodule github <owner/repo or github.com/owner/repo><reset>\n")
    return
  end

  -- Parse GitHub URL formats:
  -- https://github.com/owner/repo
  -- https://github.com/owner/repo.git
  -- owner/repo

  local owner, repo = github_url:match("github%.com/([^/]+)/([^/%.]+)")
  if not owner then
    owner, repo = github_url:match("^([^/]+)/([^/]+)$")
  end

  if not owner or not repo then
    cecho("<IndianRed>[EMERGE] Invalid GitHub URL format<reset>\n")
    cecho("<LightSteelBlue>Expected: owner/repo or https://github.com/owner/repo<reset>\n")
    return
  end

  -- Clean up repo name (remove .git if present)
  repo = repo:gsub("%.git$", "")

  -- Generate module ID from repo name
  local module_id = repo:gsub("^mudlet%-", ""):gsub("%-module$", "")

  cecho(string.format("<DarkOrange>[EMERGE] Checking GitHub repository: %s/%s<reset>\n", owner, repo))

  -- Try common module file names
  local possible_files = {
    module_id .. "-module.lua",
    module_id .. ".lua",
    "module.lua",
    repo .. ".lua",
    "init.lua",
    "main.lua"
  }

  -- Function to try each possible file
  local try_next_file
  local file_index = 1

  try_next_file = function()
    if file_index > #possible_files then
      cecho("<IndianRed>[EMERGE] Could not find module file in repository<reset>\n")
      cecho("<LightSteelBlue>You can manually add it with: module add " .. module_id .. " {json}<reset>\n")
      return
    end

    local file = possible_files[file_index]
    local check_url = string.format("https://api.github.com/repos/%s/%s/contents/%s",
      owner, repo, file)

    -- Use GitHub API to check if file exists
    local headers = {}
    if self.config.github_token then
      headers["Authorization"] = "token " .. self.config.github_token
      headers["Accept"] = "application/vnd.github.v3.raw"
    end

    downloadFile(self.paths.cache .. "github-check.json", check_url)

    registerAnonymousEventHandler("sysDownloadDone", function(_, filename)
      if filename:find("github%-check%.json$") then
        local f = io.open(filename, "r")
        if f then
          local content = f:read("*all")
          f:close()

          -- Check if we got a valid response
          if content:find('"name"') and content:find('"download_url"') then
            -- File exists! Add the module
            local module_info = {
              name = repo:gsub("%-", " "):gsub("^%l", string.upper),
              description = string.format("Module from %s/%s", owner, repo),
              github = {
                owner = owner,
                repo = repo,
                file = file
              },
              enabled = true,
              auto_load = false,
              added_by = "user",
              added_date = os.date("%Y-%m-%d %H:%M:%S")
            }

            self:addModule(module_id, module_info)
            cecho(string.format(
              "<LightSteelBlue>[EMERGE] Successfully added module '%s' from %s/%s<reset>\n",
              module_id, owner, repo))
            cecho(string.format("<SteelBlue>Use 'module load %s' to load it<reset>\n", module_id))

            os.remove(filename)
          else
            -- Try next file
            file_index = file_index + 1
            tempTimer(0.1, try_next_file)
          end
        end
      end
    end, true)
  end

  -- Start checking files
  try_next_file()
end

-- Remove custom module
function ModuleManager:removeModule(module_id)
  if not module_id or module_id == "" then
    cecho("<IndianRed>[EMERGE] Usage: emodule remove <module_id><reset>\n")
    return
  end

  -- Check if it's a custom module
  if not self.custom_modules[module_id] then
    -- Check if it exists in default registry
    if self.default_registry[module_id] then
      cecho("<IndianRed>[EMERGE] Cannot remove default module. You can disable it instead.<reset>\n")
    else
      cecho("<IndianRed>[EMERGE] Module not found: " .. module_id .. "<reset>\n")
    end
    return
  end

  -- Unload if currently loaded
  if self.modules[module_id] then
    self:unloadModule(module_id)
  end

  -- Remove from custom modules
  self.custom_modules[module_id] = nil
  self:saveCustomModules()

  -- Remove cached file if exists
  local cache_file = self.paths.cache .. module_id .. ".lua"
  if io.exists(cache_file) then
    os.remove(cache_file)
  end

  cecho(string.format("<DarkOrange>[EMERGE] Removed module: %s<reset>\n", module_id))
end

-- Enable/disable a module
function ModuleManager:toggleModule(module_id, enabled)
  if not module_id or module_id == "" then
    local cmd = enabled and "enable" or "disable"
    cecho(string.format("<IndianRed>[EMERGE] Usage: emodule %s <module_id><reset>\n", cmd))
    return
  end

  local modules = self:getModuleList()
  local module = modules[module_id]

  if not module then
    cecho("<IndianRed>[EMERGE] Module not found: " .. module_id .. "<reset>\n")
    return
  end

  -- Update the appropriate registry
  if self.custom_modules[module_id] then
    self.custom_modules[module_id].enabled = enabled
    self:saveCustomModules()
  elseif self.default_registry[module_id] then
    -- For default modules, save override in custom
    if not self.custom_modules[module_id] then
      self.custom_modules[module_id] = table.deepcopy(self.default_registry[module_id])
    end
    self.custom_modules[module_id].enabled = enabled
    self:saveCustomModules()
  end

  cecho(string.format("<LightSteelBlue>[EMERGE] Module '%s' %s<reset>\n",
    module_id, enabled and "enabled" or "disabled"))

  -- If disabling and currently loaded, unload it
  if not enabled and self.modules[module_id] then
    self:unloadModule(module_id)
  end
end

-- Load all required modules
function ModuleManager:loadRequiredModules()
  cecho("<DarkOrange>[EMERGE] Loading all required modules...<reset>\n")

  -- Always attempt to load the core stack first: core -> help -> gmcp
  local core_stack = { "emerge-core", "emerge-help", "emerge-gmcp" }
  -- Track what we explicitly attempted here to avoid double-loading later in this function
  local attempted = {}
  for _, mid in ipairs(core_stack) do
    if not self.modules[mid] then
      -- if present in module list, load it explicitly before discovery
      local module_info = self:getModuleList()[mid]
      if module_info then
        cecho(string.format("<DimGrey>[core-stack] Loading %s...<reset>\n", mid))
        attempted[mid] = true
        self:loadModule(mid)
      else
        cecho(string.format(
          "<yellow>[core-stack] %s not found in module list; will be picked up if discovered.<reset>\n", mid))
      end
    end
  end

  local all_modules = self:getModuleList()
  local required_modules = {}

  -- Find all required modules
  for id, info in pairs(all_modules) do
    -- Skip if already loaded, already attempted above, or is the manager itself
    if not self.modules[id] and not attempted[id] and id ~= "emerge-manager" then
      local is_required = false
      if info.required == true or info.type == "required" or info.type == "core" or info.category == "required" then
        is_required = true
      elseif id:match("^emerge%-core") or id:match("^core%-") then
        is_required = true
      end

      if is_required then
        table.insert(required_modules, { id = id, info = info, order = info.load_order or 50 })
      end
    end
  end

  -- Sort by load order
  table.sort(required_modules, function(a, b) return a.order < b.order end)

  if #required_modules == 0 then
    cecho("<LightSteelBlue>[EMERGE] All required modules are already loaded<reset>\n")
    return
  end

  cecho(string.format("<LightSteelBlue>[EMERGE] Found %d required modules to load<reset>\n", #required_modules))

  -- Load each module with a small delay
  for i, module in ipairs(required_modules) do
    tempTimer(i * 0.5, function()
      cecho(string.format("<DimGrey>[%d/%d] Loading %s...<reset>\n", i, #required_modules, module.id))
      self:loadModule(module.id)
    end)
  end
end

-- Repo-specific module lookup helper
function ModuleManager:_getModuleFromRepo(repo_name, module_id)
  if not repo_name or not module_id then return nil end
  local manifests = self.discovery_cache and self.discovery_cache.manifests
  local manifest = manifests and manifests[repo_name]
  if not (manifest and manifest.modules) then return nil end

  -- keyed lookup
  local src = manifest.modules[module_id]
  if src then
    local info = {}
    for k, v in pairs(src) do info[k] = v end
    info.repository = repo_name
    if info.path and not info.manifest_path then info.manifest_path = info.path end
    return info
  end

  -- array-ish scan
  for k, m in pairs(manifest.modules) do
    local id = (m and (m.id or m.name)) or k
    if id == module_id and type(m) == "table" then
      local info = {}
      for k2, v2 in pairs(m) do info[k2] = v2 end
      info.repository = repo_name
      if info.path and not info.manifest_path then info.manifest_path = info.path end
      return info
    end
  end

  return nil
end

-- Load a module from GitHub
function ModuleManager:loadModule(module_id, custom_branch)
  if not module_id or module_id == "" then
    cecho("<IndianRed>[EMERGE] Usage: emodule load <module_id><reset>\n")
    cecho("<DimGrey>Or: emodule load <branch> <module_id><reset>\n")
    return
  end

  -- Prevent duplicate concurrent loads
  self.loading_modules = self.loading_modules or {}
  if self.loading_modules[module_id] then
    cecho(string.format("<DimGrey>[EMERGE] Already loading %s, skipping duplicate request.<reset>\n", module_id))
    return
  end

  if self.modules[module_id] and not self.pending_overwrite then
    if self.overwrite_in_progress then
      table.insert(self.overwrite_queue, { module_id = module_id, custom_branch = custom_branch })
      cecho(string.format("<yellow>[EMERGE] Another overwrite is in progress. Queuing '%s'.<reset>\n", module_id))
      return
    end

    cecho(string.format("<yellow>[EMERGE] Module '%s' is already loaded. Overwrite? (yes/no)<reset>\n", module_id))

    self.overwrite_in_progress = true
    self.pending_overwrite = { module_id = module_id, custom_branch = custom_branch }

    local confirm_alias = "emerge_overwrite_confirm"
    local cancel_alias = "emerge_overwrite_cancel"

    if self.aliases[confirm_alias] then killAlias(self.aliases[confirm_alias]) end
    if self.aliases[cancel_alias] then killAlias(self.aliases[cancel_alias]) end

    self.aliases[confirm_alias] = tempAlias("^(yes)$", [[
      local pending = EMERGE.pending_overwrite
      if pending then
        cecho(string.format("<LightSteelBlue>[EMERGE] Overwriting module '%s'...<reset>\n", pending.module_id))
        EMERGE.loading_modules = EMERGE.loading_modules or {}
        EMERGE.loading_modules[pending.module_id] = true
        EMERGE:_executeLoadModule(pending.module_id, pending.custom_branch)
        EMERGE.pending_overwrite = nil
      end
      killAlias(EMERGE.aliases.emerge_overwrite_confirm)
      killAlias(EMERGE.aliases.emerge_overwrite_cancel)
      EMERGE.aliases.emerge_overwrite_confirm = nil
      EMERGE.aliases.emerge_overwrite_cancel = nil
      EMERGE.overwrite_in_progress = false
      EMERGE:_processOverwriteQueue()
    ]])

    self.aliases[cancel_alias] = tempAlias("^(.*)$", [[
      if matches[2] ~= "yes" then
        local pending = EMERGE.pending_overwrite
        if pending then
          cecho(string.format("<IndianRed>[EMERGE] Aborted overwriting module '%s'.<reset>\n", pending.module_id))
          EMERGE.pending_overwrite = nil
        end
        killAlias(EMERGE.aliases.emerge_overwrite_confirm)
        killAlias(EMERGE.aliases.emerge_overwrite_cancel)
        EMERGE.aliases.emerge_overwrite_confirm = nil
        EMERGE.aliases.emerge_overwrite_cancel = nil
        EMERGE.overwrite_in_progress = false
        EMERGE:_processOverwriteQueue()
      end
    ]])

    return
  end

  self.loading_modules = self.loading_modules or {}
  self.loading_modules[module_id] = true
  self:_executeLoadModule(module_id, custom_branch)
end

function ModuleManager:_executeLoadModule(module_id, custom_branch)
  -- Parse repo-aware forms from alias or direct call
  local source_repo, effective_module_id, effective_branch

  -- 1) "branch repo/module"
  local b, r, m = tostring(module_id):match("^([%w%-_%.]+)%s+([%w%-_%.]+)/([%w%-_%.]+)$")
  if b and r and m then
    effective_branch, source_repo, effective_module_id = b, r, m
  else
    -- 2) "repo/module"
    local r2, m2 = tostring(module_id):match("^([%w%-_%.]+)/([%w%-_%.]+)$")
    if r2 and m2 then
      source_repo, effective_module_id = r2, m2
    else
      effective_module_id = module_id
    end
  end

  -- prefer parsed branch if provided
  if effective_branch and not custom_branch then custom_branch = effective_branch end

  -- resolve module info (repo-specific if provided)
  local module_info
  if source_repo then
    module_info = self:_getModuleFromRepo(source_repo, effective_module_id)
  else
    module_info = self:getModuleList()[effective_module_id]
  end

  -- unify id for subsequent logic and messages
  module_id = effective_module_id or module_id

  if not module_info then
    cecho(string.format("<IndianRed>[EMERGE] Unknown module: %s<reset>\n", module_id))
    cecho("<DimGrey>Try 'emodule list' to see available modules<reset>\n")
    cecho("<DimGrey>Or 'emodule refresh' to update module list<reset>\n")
    return
  end

  -- Check and load dependencies first
  if module_info.dependencies and type(module_info.dependencies) == "table" then
    for _, dependency in ipairs(module_info.dependencies) do
      if not self.modules[dependency] then
        cecho(string.format("<DarkOrange>[EMERGE] Loading dependency: %s<reset>\n", dependency))
        self:loadModule(dependency, custom_branch)

        tempTimer(0.5, function()
          if not self.modules[dependency] then
            cecho(string.format("<IndianRed>[EMERGE] Failed to load dependency: %s<reset>\n", dependency))
            cecho(string.format("<IndianRed>[EMERGE] Cannot load %s without its dependency<reset>\n",
              module_id))
            return
          end
        end)
      else
        if self.config.debug then
          cecho(string.format("<DimGrey>[DEBUG] Dependency already loaded: %s<reset>\n", dependency))
        end
      end
    end
  end

  if not module_info.github then
    cecho(string.format("<IndianRed>[EMERGE] No GitHub info for module: %s<reset>\n", module_id))
    if self.config.debug then
      cecho("<DimGrey>[DEBUG] Module info:<reset>\n")
      display(module_info)
    end
    return
  end

  if not module_info.manifest_path and not module_info.github.file then
    cecho(string.format("<IndianRed>[EMERGE] No file path for module: %s<reset>\n", module_id))
    if self.config.debug then
      cecho("<DimGrey>[DEBUG] Missing manifest_path or github.file<reset>\n")
      display(module_info)
    end
    return
  end

  local branch = custom_branch or module_info.github.branch or "main"

  if custom_branch then
    cecho(string.format("<yellow>[EMERGE] Using branch: %s<reset>\n", custom_branch))
  end

  local file_path = module_info.manifest_path or module_info.path or module_info.github.file

  -- FIX: Remove 'modules/' prefix for emerge-private repository
  if module_info.github.repo == "emerge-private" and file_path:match("^modules/") then
    file_path = file_path:gsub("^modules/", "")
    if self.config.debug then
      cecho(string.format("<DimGrey>[DEBUG] Fixed path for emerge-private: %s<reset>\n", file_path))
    end
  end

  local url = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s",
    module_info.github.owner,
    module_info.github.repo,
    branch,
    file_path)

  if self.config.debug then
    cecho(string.format("<DimGrey>[DEBUG] Download URL: %s<reset>\n", url))
  end

  cecho(string.format("<DarkOrange>[EMERGE] Downloading %s...<reset>\n", module_id))

  local headers = {}
  if self.config.github_token then
    -- Handle different token formats
    if self.config.github_token:match("^ghp_") then
      -- Classic personal access token
      headers["Authorization"] = "token " .. self.config.github_token
    elseif self.config.github_token:match("^github_pat_") then
      -- Fine-grained personal access token (needs Bearer)
      headers["Authorization"] = "Bearer " .. self.config.github_token
    else
      -- Default to token format
      headers["Authorization"] = "token " .. self.config.github_token
    end
  end

  if self.handlers.download_success ~= nil then
    killAnonymousEventHandler(self.handlers.download_success)
  end
  if self.handlers.download_error ~= nil then
    killAnonymousEventHandler(self.handlers.download_error)
  end

  self.handlers.download_success = registerAnonymousEventHandler("sysGetHttpDone",
    function(_, responseUrl, responseBody)
      if responseUrl == url then
        if self.handlers.download_success ~= nil then killAnonymousEventHandler(self.handlers.download_success) end
        if self.handlers.download_error ~= nil then killAnonymousEventHandler(self.handlers.download_error) end

        cecho(string.format("<LightSteelBlue>[EMERGE] Downloaded %s<reset>\n", module_id))

        local cache_file = self.paths.cache .. module_id .. ".lua"
        local file = io.open(cache_file, "w")
        if file then
          file:write(responseBody)
          file:close()

          if self.config.debug then
            cecho(string.format("<DimGrey>[DEBUG] Module saved to: %s<reset>\n", cache_file))
            cecho(string.format("<DimGrey>[DEBUG] File size: %d bytes<reset>\n", #responseBody))
          end

          if not io.exists(cache_file) then
            cecho(string.format(
              "<IndianRed>[EMERGE] Failed to save %s - file not found after write<reset>\n", module_id))
            return
          end

          cecho(string.format("<DarkOrange>[EMERGE] Loading %s...<reset>\n", module_id))
          self:_installResourceWrappers()
          EMERGE._current_loading_module = module_id
          local chunk, load_err = loadfile(cache_file)
          if type(chunk) == "function" then
            local ok, err = pcall(chunk)
            EMERGE._current_loading_module = nil
            if ok then
              cecho(string.format("<green>[EMERGE] Successfully loaded %s<reset>\n", module_id))
              self.modules[module_id] = module_info
              self:saveConfig()
              if self.loading_modules then self.loading_modules[module_id] = nil end

              -- Also save to emerge directory for persistence
              if self.paths.modules then
                local emerge_file = self.paths.modules .. module_id .. ".lua"
                local emerge_copy = io.open(emerge_file, "w")
                if emerge_copy then
                  emerge_copy:write(responseBody)
                  emerge_copy:close()
                  if self.config.debug then
                    cecho(string.format("<DimGrey>[DEBUG] Saved to emerge directory: %s<reset>\n",
                      emerge_file))
                  end
                end
              end
              if emerge and emerge.events then
                emerge.events:emit("module.installed", module_id)
              end
            else
              cecho(string.format("<IndianRed>[EMERGE] Failed to execute %s<reset>\n", module_id))
              if self.loading_modules then self.loading_modules[module_id] = nil end
              cecho(string.format("<DimGrey>Error: %s<reset>\n", tostring(err)))
              cecho(string.format("<DimGrey>File: %s<reset>\n", cache_file))
            end
          else
            cecho(string.format("<IndianRed>[EMERGE] Failed to parse %s<reset>\n", module_id))
            if self.loading_modules then self.loading_modules[module_id] = nil end
            cecho(string.format("<DimGrey>Parse error: %s<reset>\n", tostring(load_err)))
            cecho(string.format("<DimGrey>File: %s<reset>\n", cache_file))
            cecho(string.format("<DimGrey>Check syntax and ensure file is valid Lua<reset>\n"))
          end
        else
          cecho(string.format("<IndianRed>[EMERGE] Failed to open cache file for writing<reset>\n"))
          if self.loading_modules then self.loading_modules[module_id] = nil end
          cecho(string.format("<DimGrey>Attempted path: %s<reset>\n", cache_file))
          cecho(string.format("<DimGrey>Check permissions and disk space<reset>\n"))
        end
      end
    end)

  self.handlers.download_error = registerAnonymousEventHandler("sysGetHttpError", function(_, responseUrl, errorMsg)
    if responseUrl == url then
      if self.handlers.download_success ~= nil then killAnonymousEventHandler(self.handlers.download_success) end
      if self.handlers.download_error ~= nil then killAnonymousEventHandler(self.handlers.download_error) end

      cecho(string.format("<IndianRed>[EMERGE] Failed to download %s: %s<reset>\n", module_id,
        errorMsg or "unknown error"))
      if self.loading_modules then self.loading_modules[module_id] = nil end
    end
  end)

  getHTTP(url, headers)
end

function ModuleManager:_processOverwriteQueue()
  if #self.overwrite_queue > 0 then
    local next_load = table.remove(self.overwrite_queue, 1)
    tempTimer(0.5, function()
      EMERGE:loadModule(next_load.module_id, next_load.custom_branch)
    end)
  end
end

-- Unload a module
function ModuleManager:unloadModule(module_id, confirm)
  local _killScript = rawget(_G, "killScript") or function(...) end
  if not module_id or module_id == "" then
    cecho("<IndianRed>[EMERGE] Usage: emodule unload <module_id><reset>\n")
    cecho("<DimGrey>To unload EMERGE itself: emodule unload manager confirm<reset>\n")
    return
  end

  -- Special handling for unloading the manager itself
  if module_id == "manager" or module_id == "emerge" then
    -- Check for confirmation
    if confirm ~= "confirm" then
      cecho("<IndianRed>WARNING: This will completely remove EMERGE from Mudlet!<reset>\n")
      cecho("<DarkOrange>You will need to reinstall using the one-line installer.<reset>\n")
      cecho("<LightSteelBlue>To confirm, type: emodule unload manager confirm<reset>\n")
      return
    end

    cecho("<DarkOrange>[EMERGE] Unloading module manager...<reset>\n")

    -- Remove persistent loader and group
    if exists("EMERGE Module Bootloader", "script") then
      disableScript("EMERGE Module Bootloader")
      _killScript("EMERGE Module Bootloader")
      cecho("<DarkOrange>[EMERGE] Removed persistent bootloader<reset>\n")
    end

    -- Try to remove the group as well
    if exists("EMERGE", "script") then
      _killScript("EMERGE")
      cecho("<DarkOrange>[EMERGE] Removed EMERGE script group<reset>\n")
    end

    -- Save profile to persist the removal
    saveProfile()
    cecho("<DarkOrange>[EMERGE] Profile saved - removal is permanent<reset>\n")

    -- Remove saved manager file
    local manager_file = getMudletHomeDir() .. "/emerge-manager.lua"
    if io.exists(manager_file) then
      os.remove(manager_file)
      cecho("<DarkOrange>[EMERGE] Removed saved manager file<reset>\n")
    end

    -- Also remove the downloaded file if it exists
    local dl_file = getMudletHomeDir() .. "/emerge-dl.lua"
    if io.exists(dl_file) then
      os.remove(dl_file)
      cecho("<DarkOrange>[EMERGE] Removed download file<reset>\n")
    end

    -- Unload self
    tempTimer(0.5, function()
      if EMERGE and EMERGE.unload then
        EMERGE:unload()
      end
      EMERGE = nil
      ModuleManager = nil
      cecho("<IndianRed>[EMERGE] Module manager unloaded. Goodbye!<reset>\n")
    end)
    return
  end

  local module = self.modules[module_id]
  if module then
    if module.unload then
      module:unload()
    end
    -- Cleanup any tracked resources created by this module
    pcall(function() self:_cleanupResources(module_id) end)
    self.modules[module_id] = nil
    cecho(string.format("<DarkOrange>[EMERGE] Unloaded: %s<reset>\n", module_id))
  else
    cecho(string.format("<IndianRed>[EMERGE] Module not loaded: %s<reset>\n", module_id))
  end
end

-- Install wrappers to track module-created resources (aliases, timers, handlers, triggers)
function ModuleManager:_installResourceWrappers()
  if EMERGE and EMERGE._wrappers_installed then return end
  EMERGE = EMERGE or {}
  EMERGE._wrappers_installed = true

  EMERGE._orig = EMERGE._orig or {}
  local orig = EMERGE._orig

  -- Preserve originals
  orig.tempAlias = orig.tempAlias or tempAlias
  orig.tempTimer = orig.tempTimer or tempTimer
  orig.registerAnonymousEventHandler = orig.registerAnonymousEventHandler or registerAnonymousEventHandler
  if _G.tempTrigger then
    orig.tempTrigger = orig.tempTrigger or tempTrigger
  end

  EMERGE._resource_registry = EMERGE._resource_registry or {
    alias = {},
    timer = {},
    handler = {},
    trigger = {},
  }

  function EMERGE:_track(kind, id)
    local mid = EMERGE._current_loading_module
    if not mid or not id then return end
    local bucket = EMERGE._resource_registry[kind]
    if not bucket[mid] then bucket[mid] = {} end
    table.insert(bucket[mid], id)
  end

  _G.tempAlias = function(pattern, code)
    local id = orig.tempAlias(pattern, code)
    EMERGE:_track("alias", id)
    return id
  end

  _G.tempTimer = function(time, funcOrCode)
    local id = orig.tempTimer(time, funcOrCode)
    EMERGE:_track("timer", id)
    return id
  end

  _G.registerAnonymousEventHandler = function(event, func, oneshot)
    local id = orig.registerAnonymousEventHandler(event, func, oneshot)
    EMERGE:_track("handler", id)
    return id
  end

  if orig.tempTrigger then
    _G.tempTrigger = function(a, b, c, d, e, f, g)
      local id = orig.tempTrigger(a, b, c, d, e, f, g)
      EMERGE:_track("trigger", id)
      return id
    end
  end
end

-- Cleanup any tracked resources created by a module
function ModuleManager:_cleanupResources(module_id)
  if not EMERGE or not EMERGE._resource_registry then return end
  local reg = EMERGE._resource_registry

  local list = reg.alias[module_id] or {}
  for _, id in ipairs(list) do pcall(function() killAlias(id) end) end
  reg.alias[module_id] = nil

  list = reg.trigger[module_id] or {}
  for _, id in ipairs(list) do pcall(function() killTrigger(id) end) end
  reg.trigger[module_id] = nil

  list = reg.timer[module_id] or {}
  for _, id in ipairs(list) do pcall(function() killTimer(id) end) end
  reg.timer[module_id] = nil

  list = reg.handler[module_id] or {}
  for _, id in ipairs(list) do pcall(function() killAnonymousEventHandler(id) end) end
  reg.handler[module_id] = nil
end

-- Check all modules for updates (with proper async coordination)
function ModuleManager:checkAllUpdates()
  cecho("<DarkOrange>[EMERGE] Checking manager and all modules for updates...<reset>\n")

  -- Store original silent mode
  local was_silent = self.silent_check
  self.silent_check = true

  -- Track completion state
  local completion_state = {
    manager_check_done = false,
    cache_refresh_done = false,
    timeout_reached = false
  }

  -- Reset pending update state
  self.pending_update = nil

  -- Force fresh cache for update checks (no stale data)
  cecho("<DimGrey>[EMERGE] Refreshing module cache...<reset>\n")
  self:refreshCache(true)
  completion_state.cache_refresh_done = true

  -- Check manager version with async coordination
  cecho("<DimGrey>[EMERGE] Checking manager version...<reset>\n")
  self:checkSelfUpdateAsync(function(update_available)
    completion_state.manager_check_done = true
    self:_evaluateUpdateResults(completion_state, was_silent)
  end)

  -- Timeout protection (fallback after 10 seconds)
  tempTimer(10, function()
    if not completion_state.manager_check_done then
      cecho("<yellow>[EMERGE] Manager check timed out - network issues?<reset>\n")
      completion_state.manager_check_done = true
      completion_state.timeout_reached = true
      self:_evaluateUpdateResults(completion_state, was_silent)
    end
  end)
end

-- Async version of checkSelfUpdate that uses callbacks
function ModuleManager:checkSelfUpdateAsync(callback)
  -- Use emerge-dev repo if dev mode is active, otherwise use main repo
  local github_config = self.github
  if self.config.show_dev_modules then
    github_config = {
      owner = "robertmassey",
      repo = "emerge-dev", 
      branch = "main",
      files = { manager = "emerge-manager.lua" }
    }
  end
  
  local url = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s",
    github_config.owner,
    github_config.repo,
    github_config.branch,
    github_config.files.manager)

  -- Add headers for private repos if token is available
  local headers = {}
  if self.config.github_token then
    -- Handle different token formats
    if self.config.github_token:match("^ghp_") then
      -- Classic personal access token
      headers["Authorization"] = "token " .. self.config.github_token
    elseif self.config.github_token:match("^github_pat_") then
      -- Fine-grained personal access token (needs Bearer)
      headers["Authorization"] = "Bearer " .. self.config.github_token
    else
      -- Default to token format
      headers["Authorization"] = "token " .. self.config.github_token
    end
  end

  -- Generate unique filename to avoid conflicts
  local check_file = self.paths.cache .. "module-manager-check-" .. os.time() .. ".txt"

  -- Download with event handler
  downloadFile(check_file, url)

  -- Set up one-time event handler for this specific download
  local downloadHandler
  downloadHandler = registerAnonymousEventHandler("sysDownloadDone", function(_, filename)
    if filename == check_file then
      -- Clean up this handler
      if downloadHandler ~= nil then killAnonymousEventHandler(downloadHandler) end

      local file = io.open(filename, "r")
      if file then
        local content = file:read("*all")
        file:close()

        -- Clean up temp file
        os.remove(filename)

        local remote_version = content:match('local CURRENT_VERSION = "([^"]+)"')
        if remote_version and self:compareVersions(remote_version, self.version) > 0 then
          if not self.silent_check then
            cecho(string.format("<DarkOrange>[EMERGE] Manager update available: v%s -> v%s<reset>\n",
              self.version, remote_version))
          end

          self.pending_update = {
            version = remote_version,
            content = content
          }
          callback(true)
        else
          if not self.silent_check and remote_version == self.version then
            cecho("<DimGrey>[EMERGE] Manager is up to date<reset>\n")
          end
          callback(false)
        end
      else
        cecho("<yellow>[EMERGE] Failed to check manager version<reset>\n")
        callback(false)
      end
    end
  end)

  -- Timeout protection for individual download
  tempTimer(8, function()
    if downloadHandler ~= nil then
      killAnonymousEventHandler(downloadHandler)
      cecho("<yellow>[EMERGE] Manager version check timed out<reset>\n")
      callback(false)
    end
  end)
end

-- Evaluate results once async operations complete
function ModuleManager:_evaluateUpdateResults(completion_state, was_silent)
  -- Only proceed if all operations are done
  if not (completion_state.manager_check_done and completion_state.cache_refresh_done) then
    return
  end

  cecho("<DimGrey>[EMERGE] Checking module versions...<reset>\n")
  local updates = self:checkForUpdates()

  local total_updates = #updates
  if self.pending_update then
    total_updates = total_updates + 1
  end

  if total_updates > 0 then
    cecho(string.format("\n<yellow>[EMERGE] %d update(s) available:<reset>\n", total_updates))

    -- Show manager update if available
    if self.pending_update then
      cecho(string.format("  <SteelBlue>emerge-manager<reset>: v%s → v%s\n",
        self.version, self.pending_update.version))
    end

    -- Show module updates
    for _, update in ipairs(updates) do
      cecho(string.format("  <SteelBlue>%s<reset>: v%s → v%s (%s)\n",
        update.id, update.current, update.available, update.repository))
    end

    cecho("\n<DimGrey>Commands:<reset>\n")
    cecho("<DimGrey>  emodule upgrade manager  # Update the manager<reset>\n")
    cecho("<DimGrey>  emodule upgrade <module> # Update a specific module<reset>\n")
    cecho("<DimGrey>  emodule upgrade all      # Update everything<reset>\n")
  else
    cecho("<LightSteelBlue>[EMERGE] All components are up to date<reset>\n")
  end

  -- Restore silent mode
  self.silent_check = was_silent

  -- Check each loaded module for custom update methods
  for id, module in pairs(self.modules) do
    if module.checkForUpdates then
      module:checkForUpdates(true)
    end
  end
end

-- Check for ModuleManager updates (legacy synchronous version)
function ModuleManager:checkSelfUpdate()
  -- Delegate to the new async version for consistency
  self:checkSelfUpdateAsync(function(update_available)
    if update_available then
      cecho("<SteelBlue>Run 'emodule upgrade manager' to update<reset>\n")
    end
  end)
end

-- Upgrade modules or manager
function ModuleManager:upgradeComponent(component, force)
  if not component or component == "" then
    cecho("<IndianRed>[EMERGE] Usage: emodule upgrade <manager|module|all><reset>\n")
    return
  end

  if component == "all" then
    -- Upgrade everything
    cecho("<DarkOrange>[EMERGE] Upgrading all components...<reset>\n")

    -- First upgrade manager if needed
    if self.pending_update then
      self:upgradeSelf(force)
      tempTimer(2, function()
        -- Then upgrade modules
        self:upgradeAllModules()
      end)
    else
      -- Just upgrade modules
      self:upgradeAllModules()
    end
  elseif component == "manager" then
    self:upgradeSelf(force)
  else
    -- Try to upgrade specific module
    self:upgradeModule(component, force)
  end
end

-- Upgrade all modules that have updates
function ModuleManager:upgradeAllModules()
  local updates = self:checkForUpdates()

  if #updates == 0 then
    cecho("<LightSteelBlue>[EMERGE] No module updates available<reset>\n")
    return
  end

  cecho(string.format("<DarkOrange>[EMERGE] Upgrading %d module(s)...<reset>\n", #updates))

  for i, update in ipairs(updates) do
    tempTimer(i * 1, function()
      cecho(string.format("<DimGrey>[%d/%d] Upgrading %s...<reset>\n", i, #updates, update.id))
      self:loadModule(update.id) -- loadModule will download the latest version
    end)
  end
end

-- Upgrade a specific module
function ModuleManager:upgradeModule(module_id, force)
  if not module_id or module_id == "" then
    cecho("<IndianRed>[EMERGE] Usage: emodule upgrade <module><reset>\n")
    return
  end

  local all_modules = self:getModuleList()
  local module_info = all_modules[module_id]

  if not module_info then
    cecho(string.format("<IndianRed>[EMERGE] Unknown module: %s<reset>\n", module_id))
    return
  end

  if not force then
    -- Check if update is actually needed
    local loaded_module = self.modules[module_id]
    if loaded_module and loaded_module.version == module_info.version then
      cecho(string.format("<LightSteelBlue>[EMERGE] %s is already up to date (v%s)<reset>\n",
        module_id, module_info.version))
      return
    end
  end

  cecho(string.format("<DarkOrange>[EMERGE] Upgrading %s to v%s...<reset>\n",
    module_id, module_info.version))

  -- Use loadModule to get the latest version
  self:loadModule(module_id)
end

-- Update ModuleManager
function ModuleManager:upgradeSelf(force)
  -- Skip version check if force is specified
  if force then
    cecho("<DarkOrange>[EMERGE] Force upgrade requested - downloading latest version...<reset>\n")
    self.pending_update = {
      version = "latest",
      current = self.version
    }
    self:performUpgrade()
    return
  end

  -- Check for updates first if we don't have a pending update
  if not self.pending_update then
    cecho("<DimGrey>[EMERGE] Checking for updates...<reset>\n")
    
    -- Use emerge-dev repo if dev mode is active, otherwise use main repo
    local github_config = self.github
    if self.config.show_dev_modules then
      github_config = {
        owner = "robertmassey",
        repo = "emerge-dev", 
        branch = "main",
        files = { manager = "emerge-manager.lua" }
      }
      cecho("<DimGrey>[EMERGE] Dev mode active - checking emerge-dev repository...<reset>\n")
    end

    -- Add timestamp to bypass GitHub's cache
    local url = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s?t=%d",
      github_config.owner,
      github_config.repo,
      github_config.branch,
      github_config.files.manager,
      os.time())

    -- Add headers for private repos if token is available
    local headers = {}
    if self.config.github_token then
      headers["Authorization"] = "token " .. self.config.github_token
    end

    -- Ensure cache directory exists
    if not io.exists(self.paths.cache) then
      lfs.mkdir(self.paths.cache)
    end

    local check_file = self.paths.cache .. "manager-update-check.txt"

    -- Store handlers to ensure they can be killed
    local downloadHandler, errorHandler, timeoutHandler

    -- Set up timeout
    timeoutHandler = tempTimer(10, function()
      cecho("<IndianRed>[EMERGE] Update check timed out. Please try again.<reset>\n")
      if downloadHandler ~= nil then killAnonymousEventHandler(downloadHandler) end
      if errorHandler ~= nil then killAnonymousEventHandler(errorHandler) end
    end)

    downloadHandler = registerAnonymousEventHandler("sysDownloadDone", function(_, filename)
      if filename == check_file then
        -- Cancel timeout
        if timeoutHandler then killTimer(timeoutHandler) end
        if errorHandler then killAnonymousEventHandler(errorHandler) end

        local file = io.open(filename, "r")
        if file then
          local content = file:read("*all")
          file:close()

          -- Look for version in the file
          local remote_version = content:match('local CURRENT_VERSION = "([^"]+)"')
          if not remote_version then
            -- Try alternate format
            remote_version = content:match('CURRENT_VERSION = "([^"]+)"')
          end
          if not remote_version then
            -- Try another format
            remote_version = content:match('version = "([^"]+)"')
          end

          if remote_version then
            cecho(string.format("<DimGrey>[EMERGE] Current version: v%s | Remote version: v%s<reset>\n",
              self.version, remote_version))

            if self:compareVersions(remote_version, self.version) > 0 then
              cecho(string.format("<DarkOrange>[EMERGE] Update available: v%s -> v%s<reset>\n",
                self.version, remote_version))

              self.pending_update = {
                version = remote_version,
                content = content
              }

              -- Now do the upgrade
              self:doUpgrade()
            else
              cecho("<LightSteelBlue>[EMERGE] You already have the latest version<reset>\n")
            end
          else
            cecho("<IndianRed>[EMERGE] Could not determine remote version from downloaded file<reset>\n")
            cecho("<DimGrey>Debug: File size = " .. #content .. " bytes<reset>\n")
            cecho("<DimGrey>Debug: Current local version = v" .. self.version .. "<reset>\n")
          end

          os.remove(filename)
        else
          cecho("<IndianRed>[EMERGE] Could not read downloaded file<reset>\n")
        end
      end
    end, true)

    errorHandler = registerAnonymousEventHandler("sysDownloadError", function(_, filename, errorMsg)
      if filename == check_file then
        -- Cancel timeout
        if timeoutHandler then killTimer(timeoutHandler) end
        if downloadHandler ~= nil then killAnonymousEventHandler(downloadHandler) end

        cecho("<IndianRed>[EMERGE] Failed to download update: " .. (errorMsg or "unknown error") .. "<reset>\n")
        cecho("<DimGrey>URL: " .. url .. "<reset>\n")
      end
    end, true)

    -- Initiate the download
    downloadFile(check_file, url)

    return
  end

  -- If we already have a pending update, do the upgrade
  self:doUpgrade()
end

-- Actually perform the upgrade
function ModuleManager:doUpgrade()
  if not self.pending_update then
    return
  end

  local temp_file = getMudletHomeDir() .. "/module-manager-update.lua"
  local file = io.open(temp_file, "w")
  if file then
    file:write(self.pending_update.content)
    file:close()

    cecho(string.format("<DarkOrange>[EMERGE] Upgrading to v%s...<reset>\n",
      self.pending_update.version))

    -- Load the new version
    local chunk, load_err = loadfile(temp_file)
    if type(chunk) == "function" then
      local ok, err = pcall(chunk)
      if ok then
        cecho("<LightSteelBlue>[EMERGE] Upgrade successful!<reset>\n")
        os.remove(temp_file)
        self.pending_update = nil
      else
        cecho(string.format("<IndianRed>[EMERGE] Upgrade failed: %s<reset>\n", err))
      end
    else
      cecho(string.format("<IndianRed>[EMERGE] Failed to load new version: %s<reset>\n", tostring(load_err)))
    end
  end
end

-- Discover repositories and cache modules
function ModuleManager:discoverRepositories()
  local pending_downloads = 0
  local completed_downloads = 0
  local discovered_modules = {}

  cecho("<DarkOrange>[EMERGE] Discovering modules from repositories...<reset>\n")

  for _, repo_config in ipairs(self.repositories) do
    -- Skip dev-only repos unless explicitly enabled
    if (repo_config.dev_only or repo_config.name == "emerge-dev") and not self.config.show_dev_modules then
      if self.config.debug then
        cecho(string.format("<DimGrey>[DEBUG] Skipping %s (dev-only hidden)<reset>\n", repo_config.name))
      end
      -- Skip private repos if no token is set
    elseif repo_config.requires_token and not self.config.github_token then
      if self.config.debug then
        cecho(string.format("<DimGrey>[DEBUG] Skipping %s (no token)<reset>\n", repo_config.name))
      end
    else
      pending_downloads = pending_downloads + 1

      self:downloadManifest(repo_config, function(success, modules)
        completed_downloads = completed_downloads + 1

        if success and modules then
          -- Add repository info to each module
          for idx, module_info in pairs(modules) do
            -- Normalize module id: prefer explicit id, then name, else basename of github.file
            local module_id = module_info and (module_info.id or module_info.name)
            if not module_id and module_info and module_info.github and module_info.github.file then
              module_id = tostring(module_info.github.file):match("([^/]+)%.lua$")
            end
            if module_id then
              module_info.repository = repo_config.name
              module_info.github = module_info.github or {
                owner = repo_config.owner,
                repo = repo_config.repo,
                branch = repo_config.branch
              }
              -- Convert manifest 'path' field to 'manifest_path' for consistency
              if module_info.path and not module_info.manifest_path then
                module_info.manifest_path = module_info.path
              end
              discovered_modules[module_id] = module_info
            elseif self.config.debug then
              cecho("<yellow>[DEBUG] Skipping manifest entry without usable id/name/file<reset>\n")
            end
          end

          cecho(string.format("<DimGrey>[EMERGE] Found %d modules in %s<reset>\n",
            tsize(modules), repo_config.name))
        else
          if self.config.debug then
            cecho(string.format(
              "<yellow>[EMERGE] Could not access %s repository (check manifest.json)<reset>\n",
              repo_config.name))
          else
            -- Only show warning for private repos if we have a token
            if repo_config.public or self.config.github_token then
              cecho(string.format("<yellow>[EMERGE] Could not access %s repository<reset>\n",
                repo_config.name))
            end
          end
        end

        -- Update cache when all downloads complete
        if completed_downloads >= pending_downloads then
          self.discovery_cache.modules = discovered_modules
          self.discovery_cache.last_refresh = os.time()

          local total_modules = tsize(discovered_modules)
          cecho(string.format("<LightSteelBlue>[EMERGE] Discovery complete: %d modules available<reset>\n",
            total_modules))
        end
      end)
    end -- End of else block (token check)
  end

  -- Handle timeout and force completion (only if we're actually downloading)
  if pending_downloads > 0 then
    tempTimer(10, function()
      if completed_downloads < pending_downloads then
        cecho("<yellow>[EMERGE] Some repositories timed out<reset>\n")
        -- Force completion with discovered modules so far
        self.discovery_cache.modules = discovered_modules
        self.discovery_cache.last_refresh = os.time()

        local total_modules = tsize(discovered_modules)
        if total_modules > 0 then
          cecho(string.format("<LightSteelBlue>[EMERGE] Discovery partial: %d modules available<reset>\n",
            total_modules))
        end
      end
    end)
  else
    -- No repositories to check (likely no token for private repos)
    self.discovery_cache.modules = discovered_modules
    self.discovery_cache.last_refresh = os.time()
    if not self.config.github_token then
      cecho("<DimGrey>[EMERGE] Set GitHub token to access private repositories<reset>\n")
    end
  end
end

-- Download manifest from a repository using getHTTP
function ModuleManager:downloadManifest(repo_config, callback)
  local manifest_url = string.format("https://raw.githubusercontent.com/%s/%s/%s/manifest.json",
    repo_config.owner, repo_config.repo, repo_config.branch)

  -- Debug output
  if self.config.debug then
    cecho(string.format("<DimGrey>[DEBUG] Fetching: %s<reset>\n", manifest_url))
  end

  -- Headers for private repos
  local headers = {}
  if not repo_config.public and self.config.github_token then
    -- Use different format based on token type
    if self.config.github_token:match("^ghp_") then
      -- Classic personal access token
      headers["Authorization"] = "token " .. self.config.github_token
    elseif self.config.github_token:match("^github_pat_") then
      -- Fine-grained personal access token
      headers["Authorization"] = "Bearer " .. self.config.github_token
    else
      -- Default to token format
      headers["Authorization"] = "token " .. self.config.github_token
    end
  end

  -- Register handlers for this specific request
  local success_handler, error_handler, timeout_handler
  local handler_id = "manifest_" .. repo_config.name .. "_" .. os.time()

  -- Success handler
  success_handler = registerAnonymousEventHandler("sysGetHttpDone", function(_, responseUrl, responseBody)
    if responseUrl == manifest_url then
      -- Clean up handlers
      if success_handler then killAnonymousEventHandler(success_handler) end
      if error_handler then killAnonymousEventHandler(error_handler) end
      if timeout_handler then killTimer(timeout_handler) end

      -- Parse the response
      local ok, manifest = pcall(yajl.to_value, responseBody)
      if ok and manifest and manifest.modules then
        -- Cache the manifest
        self.discovery_cache.manifests[repo_config.name] = manifest
        callback(true, manifest.modules)
      else
        -- Check if we got a 404 or other error page
        if responseBody:match("404") or responseBody:match("Not Found") then
          if self.config.debug then
            cecho(string.format("<yellow>[DEBUG] %s returned 404<reset>\n", repo_config.name))
          end
        end
        callback(false, nil)
      end
    end
  end)

  -- Error handler
  error_handler = registerAnonymousEventHandler("sysGetHttpError", function(_, responseUrl, errorMsg)
    if responseUrl == manifest_url then
      killAnonymousEventHandler(error_handler)
      if success_handler then killAnonymousEventHandler(success_handler) end
      if timeout_handler then killTimer(timeout_handler) end

      if self.config.debug then
        cecho(string.format("<red>[DEBUG] Error fetching %s: %s<reset>\n",
          repo_config.name, errorMsg or "unknown"))
      end
      callback(false, nil)
    end
  end)

  -- Timeout protection
  timeout_handler = tempTimer(5, function()
    if success_handler then killAnonymousEventHandler(success_handler) end
    if error_handler then killAnonymousEventHandler(error_handler) end
    if self.config.debug then
      cecho(string.format("<yellow>[DEBUG] Timeout fetching %s<reset>\n", repo_config.name))
    end
    callback(false, nil)
  end)

  -- Make the HTTP request using getHTTP
  getHTTP(manifest_url, headers)
end

-- Get cached modules
function ModuleManager:getCachedModules()
  return self.discovery_cache.modules
end

-- Refresh discovery cache
function ModuleManager:refreshCache(force)
  local cache_age = os.time() - self.discovery_cache.last_refresh

  if force or cache_age > self.discovery_cache.cache_duration then
    self:discoverRepositories()
  else
    local remaining = self.discovery_cache.cache_duration - cache_age
    cecho(string.format("<DimGrey>[EMERGE] Cache is fresh (expires in %d minutes)<reset>\n",
      math.ceil(remaining / 60)))
  end
end

-- Check for updates
function ModuleManager:checkForUpdates()
  local updates = {}

  for id, loaded_module in pairs(self.modules) do
    local available_module = self.discovery_cache.modules[id]

    if available_module and available_module.version and loaded_module.version then
      local comparison = self:compareVersions(available_module.version, loaded_module.version)
      if comparison > 0 then
        table.insert(updates, {
          id = id,
          current = loaded_module.version,
          available = available_module.version,
          repository = available_module.repository
        })
      end
    end
  end

  return updates
end

-- Parse version string into comparable format
function ModuleManager:parseVersion(version_string)
  if not version_string then return { major = 0, minor = 0, patch = 0 } end

  local major, minor, patch = version_string:match("(%d+)%.(%d+)%.(%d+)")
  if not major then
    -- Try simpler format
    major, minor = version_string:match("(%d+)%.(%d+)")
    patch = "0"
  end

  return {
    major = tonumber(major) or 0,
    minor = tonumber(minor) or 0,
    patch = tonumber(patch) or 0
  }
end

-- Compare two version strings
function ModuleManager:compareVersions(v1, v2)
  local version1 = self:parseVersion(v1)
  local version2 = self:parseVersion(v2)

  if version1.major ~= version2.major then
    return version1.major > version2.major and 1 or -1
  end

  if version1.minor ~= version2.minor then
    return version1.minor > version2.minor and 1 or -1
  end

  if version1.patch ~= version2.patch then
    return version1.patch > version2.patch and 1 or -1
  end

  return 0
end

-- List configured repositories
function ModuleManager:listRepositories()
  cecho(
    "\n<SlateGray>────────────────────────────────────────────────────────────────────────────────────────────────────<reset>\n")
  cecho("<LightSteelBlue>                                    Configured Repositories<reset>\n")
  cecho(
    "<SlateGray>────────────────────────────────────────────────────────────────────────────────────────────────────<reset>\n\n")

  for i, repo in ipairs(self.repositories) do
    local status_icon = repo.public and "<green>●<reset>" or "<yellow>●<reset>"
    local status_text = repo.public and "public" or "private"

    cecho(string.format("%s <SteelBlue>%s<reset> (%s)\n", status_icon, repo.name, status_text))
    cecho(string.format("   %s/%s @ %s\n", repo.owner, repo.repo, repo.branch))
    cecho(string.format("   %s\n\n", repo.description))
  end

  -- Show cache status
  local cached_count = tsize(self.discovery_cache.modules)
  if cached_count > 0 then
    local cache_age = os.time() - self.discovery_cache.last_refresh
    cecho(string.format("<DimGrey>Cached modules: %d (updated %d minutes ago)<reset>\n",
      cached_count, math.floor(cache_age / 60)))
  else
    cecho("<DimGrey>No cached modules. Run 'emodule refresh' to discover.<reset>\n")
  end
end

-- Search available modules
function ModuleManager:searchModules(search_term)
  if not search_term or search_term == "" then
    cecho("<IndianRed>[EMERGE] Usage: emodule search <term><reset>\n")
    return
  end

  -- Refresh cache if needed
  self:refreshCache(false)

  local all_modules = self:getModuleList()
  local matches = {}
  local term_lower = search_term:lower()

  for id, info in pairs(all_modules) do
    local match_score = 0

    -- Check ID
    if id:lower():find(term_lower) then
      match_score = match_score + 10
    end

    -- Check name
    if info.name and info.name:lower():find(term_lower) then
      match_score = match_score + 8
    end

    -- Check description
    if info.description and info.description:lower():find(term_lower) then
      match_score = match_score + 5
    end

    -- Check author
    if info.author and info.author:lower():find(term_lower) then
      match_score = match_score + 3
    end

    if match_score > 0 then
      table.insert(matches, { id = id, info = info, score = match_score })
    end
  end

  -- Sort by match score
  table.sort(matches, function(a, b) return a.score > b.score end)

  cecho(string.format("\n<LightSteelBlue>Search results for '%s':<reset>\n\n", search_term))

  if #matches == 0 then
    cecho("<DimGrey>No modules found matching your search.<reset>\n")
    return
  end

  for i, match in ipairs(matches) do
    if i > 10 then -- Limit results
      cecho(string.format("<DimGrey>... and %d more results<reset>\n", #matches - 10))
      break
    end

    local id = match.id
    local info = match.info
    local status = self.modules[id] and " <green>(loaded)<reset>" or ""

    cecho(string.format("<SteelBlue>%s<reset>%s\n", id, status))
    if info.version then
      cecho(string.format("  Version: %s\n", info.version))
    end
    if info.name then
      cecho(string.format("  Name: %s\n", info.name))
    end
    if info.description then
      cecho(string.format("  Description: %s\n", info.description))
    end
    if info.repository then
      cecho(string.format("  Repository: %s\n", info.repository))
    end
    cecho("\n")
  end
end

-- Search all repositories (including dev) regardless of visibility
function ModuleManager:searchModulesAll(search_term)
  if not search_term or search_term == "" then
    cecho("<IndianRed>[EMERGE] Usage: emodule searchall <term><reset>\n")
    return
  end

  -- Ensure we have up-to-date manifests
  self:refreshCache(false)

  -- Start with current list
  local combined = {}
  for id, info in pairs(self:getModuleList()) do combined[id] = info end

  -- Merge in dev manifest even if hidden
  local man = self.discovery_cache.manifests and self.discovery_cache.manifests["emerge-dev"]
  if man and man.modules then
    for idx, m in pairs(man.modules) do
      local id = (m.id or m.name) or (m.github and m.github.file and tostring(m.github.file):match("([^/]+)%.lua$"))
      if id and not combined[id] then
        m.repository = "emerge-dev"
        combined[id] = m
      end
    end
  end

  -- Search
  local matches = {}
  local term_lower = search_term:lower()
  for id, info in pairs(combined) do
    local score = 0
    if id:lower():find(term_lower) then score = score + 10 end
    if info.name and info.name:lower():find(term_lower) then score = score + 8 end
    if info.description and info.description:lower():find(term_lower) then score = score + 5 end
    if info.author and info.author:lower():find(term_lower) then score = score + 3 end
    if score > 0 then table.insert(matches, { id = id, info = info, score = score }) end
  end
  table.sort(matches, function(a, b) return a.score > b.score end)

  cecho(string.format("\n<LightSteelBlue>Search (all repos) for '%s':<reset>\n\n", search_term))
  if #matches == 0 then
    cecho("<DimGrey>No modules found matching your search.<reset>\n")
    return
  end

  for i, match in ipairs(matches) do
    if i > 10 then
      cecho(string.format("<DimGrey>... and %d more results<reset>\n", #matches - 10))
      break
    end
    local id = match.id
    local info = match.info
    local status = self.modules[id] and " <green>(loaded)<reset>" or ""
    cecho(string.format("<SteelBlue>%s<reset>%s\n", id, status))
    if info.version then cecho(string.format("  Version: %s\n", info.version)) end
    if info.name then cecho(string.format("  Name: %s\n", info.name)) end
    if info.description then cecho(string.format("  Description: %s\n", info.description)) end
    if info.repository then cecho(string.format("  Repository: %s\n", info.repository)) end
    cecho("\n")
  end
end

-- Show detailed module information
function ModuleManager:showModuleInfo(module_id)
  if not module_id or module_id == "" then
    cecho("<IndianRed>[EMERGE] Usage: emodule info <module_id><reset>\n")
    return
  end

  local all_modules = self:getModuleList()
  local info = all_modules[module_id]

  if not info then
    cecho(string.format("<IndianRed>[EMERGE] Module not found: %s<reset>\n", module_id))
    return
  end

  cecho(string.format("\n<SlateGray>──────────────────────────────────────<reset>\n"))
  cecho(string.format("<LightSteelBlue>Module: %s<reset>\n", module_id))
  cecho(string.format("<SlateGray>──────────────────────────────────────<reset>\n\n"))

  if info.name then
    cecho(string.format("<SteelBlue>Name:<reset> %s\n", info.name))
  end

  if info.version then
    cecho(string.format("<SteelBlue>Version:<reset> %s", info.version))

    -- Check if loaded and compare versions
    local loaded_module = self.modules[module_id]
    if loaded_module and loaded_module.version then
      if loaded_module.version == info.version then
        cecho(" <green>(current)<reset>")
      else
        local comparison = self:compareVersions(info.version, loaded_module.version)
        if comparison > 0 then
          cecho(string.format(" <yellow>(update available from %s)<reset>", loaded_module.version))
        else
          cecho(string.format(" <DimGrey>(loaded: %s)<reset>", loaded_module.version))
        end
      end
    end
    cecho("\n")
  end

  if info.description then
    cecho(string.format("<SteelBlue>Description:<reset> %s\n", info.description))
  end

  if info.author then
    cecho(string.format("<SteelBlue>Author:<reset> %s\n", info.author))
  end

  if info.repository then
    cecho(string.format("<SteelBlue>Repository:<reset> %s\n", info.repository))
  end

  if info.github then
    cecho(string.format("<SteelBlue>GitHub:<reset> %s/%s\n", info.github.owner, info.github.repo))
  end

  if info.type then
    cecho(string.format("<SteelBlue>Type:<reset> %s\n", info.type))
  end

  if info.dependencies and #info.dependencies > 0 then
    cecho(string.format("<SteelBlue>Dependencies:<reset> %s\n", table.concat(info.dependencies, ", ")))
  end

  -- Show load status
  if self.modules[module_id] then
    cecho(string.format("\n<green>Status: Loaded<reset>\n"))
  else
    cecho(string.format("\n<DimGrey>Status: Available (use 'emodule load %s')<reset>\n", module_id))
  end
end

-- Update module registry from GitHub (backward compatibility)
function ModuleManager:updateRegistry()
  cecho("<DarkOrange>[EMERGE] Updating module registry...<reset>\n")
  self:refreshCache(true)
end

-- Auto-load modules on startup
function ModuleManager:autoLoadModules()
  if not self.config.auto_load_modules then
    return
  end

  -- Don't auto-load if no token is set (modules are in private repo)
  if not self.config.github_token then
    return
  end

  local modules = self:getModuleList()
  local to_load = {}

  -- Collect modules that need loading
  for id, info in pairs(modules) do
    if info.enabled and info.auto_load and not self.modules[id] then
      -- Auto-detect module location to determine if required or optional
      local module_path = self.paths.cache .. id .. ".lua"
      local is_required = false

      -- Check if module exists in required folder locally
      local required_path = getMudletHomeDir() .. "/modules/required/" .. id .. ".lua"
      local optional_path = getMudletHomeDir() .. "/modules/optional/" .. id .. ".lua"

      if io.exists(required_path) then
        is_required = true
      end

      -- Also check module metadata for type hint
      if info.required == true or info.type == "required" or info.type == "core" then
        is_required = true
      elseif info.type == "optional" then
        is_required = false
      end

      -- Auto-assign priority: required modules get 1-100, optional get 100+
      local auto_order = info.load_order
      if not auto_order then
        if is_required then
          -- Core modules load first (1-50), other required modules next (51-99)
          if id:match("^emerge%-core") then
            auto_order = 10 -- Core modules always first
          else
            auto_order = 50 -- Other required modules
          end
        else
          auto_order = 100 -- Optional modules load last
        end
      end

      table.insert(to_load, {
        id = id,
        info = info,
        order = auto_order,
        is_required = is_required
      })
    end
  end

  -- Sort by load_order (required modules first, then by order number)
  table.sort(to_load, function(a, b)
    -- Required modules always come before optional
    if a.is_required ~= b.is_required then
      return a.is_required
    end
    -- Within same category, sort by order
    return a.order < b.order
  end)

  -- Load in order
  for _, module in ipairs(to_load) do
    cecho(string.format("<DimGrey>[EMERGE] Auto-loading %s...<reset>\n", module.id))
    self:loadModule(module.id)
  end
end

-- Set GitHub token for private repositories
function ModuleManager:setGitHubToken(token)
  if not token or token == "" then
    if self.config.github_token and self.config.github_token ~= "" then
      cecho("<LightSteelBlue>[EMERGE] GitHub token is set (masked).<reset>\n")
      cecho("<DimGrey>Use 'emodule token <new_token>' to replace, or 'emodule token clear' to remove.<reset>\n")
      return
    end
    cecho("<DarkOrange>[EMERGE] GitHub Token Setup<reset>\n\n")
    cecho("<LightSteelBlue>To create a GitHub personal access token:<reset>\n")
    cecho("  1. Go to ")
    cechoLink("https://github.com/settings/personal-access-tokens",
      [[openUrl("https://github.com/settings/personal-access-tokens")]], "Click to open in browser")
    echo("\n")
    cecho("  2. Click 'Fine-grained personal access tokens'\n")
    cecho("  3. Give it a name (e.g., 'Mudlet EMERGE')\n")
    cecho("  4. Set expiration (90 days recommended)\n")
    cecho("  5. Repository access: Select 'Selected repositories'\n")
    cecho("     - Click the 'Select repositories' dropdown\n")
    cecho("     - Search for and check: rjm11/emerge\n")
    cecho("     - Search for and check: rjm11/emerge-private\n")
    cecho("  6. Scroll down to 'Repository permissions'\n")
    cecho("     - Find 'Contents' row\n")
    cecho("     - Click dropdown and select 'Read'\n")
    cecho("  7. Scroll to bottom, click 'Generate token'\n")
    cecho("  8. Copy the token that starts with 'github_pat_'\n\n")
    cecho("<SteelBlue>Then run: emodule token YOUR_TOKEN_HERE<reset>\n")
    return
  end

  if token == "clear" then
    self.config.github_token = ""
    self:saveConfig()
    cecho("<LightSteelBlue>[EMERGE] GitHub token cleared<reset>\n")
    return
  end

  self.config.github_token = token
  self:saveConfig()

  cecho("<LightSteelBlue>[EMERGE] GitHub token saved<reset>\n")
  cecho("<DimGrey>Verifying access to repositories...<reset>\n")

  -- Force refresh to verify token works (silent)
  local old_debug = self.config.debug
  self.config.debug = false     -- Temporarily disable debug output
  self:refreshCache(true)
  self.config.debug = old_debug -- Restore debug setting

  -- After discovery completes, check if we found any private modules
  tempTimer(2, function()
    local private_modules_found = false
    for id, module in pairs(self.discovery_cache.modules or {}) do
      if module.repository == "emerge-private" then
        private_modules_found = true
        break
      end
    end

    if private_modules_found then
      cecho("<green>[EMERGE] ✓ Successfully connected to private repositories<reset>\n")
      cecho("<DimGrey>Use 'emodule list' to see available modules<reset>\n")
    else
      cecho("<yellow>[EMERGE] ⚠ Token saved but could not access private repositories<reset>\n")
      cecho("<DimGrey>Please verify your token has 'repo' scope permissions<reset>\n")
    end
  end)
end

-- Show developer module warning
function ModuleManager:showDevModuleWarning()
  cecho(
    "<yellow>WARNING: This command will pull and install untested developer modules from the emerge-dev repository.<reset>\n")
  cecho("<yellow>These modules may be unstable and could cause issues.<reset>\n")
  cecho("<LightSteelBlue>To proceed, type: edev confirm<reset>\n")
  cecho("<DimGrey>To hide developer modules again, type: edev off<reset>\n")
end

-- Hide developer modules
function ModuleManager:hideDevModules()
  self.config.show_dev_modules = false
  self:saveConfig()
  cecho("<LightSteelBlue>[EMERGE] Developer modules hidden<reset>\n")
  self:refreshCache(true)
end

-- Execute loading of developer modules
function ModuleManager:_executeLoadDevModules()
  cecho("<green>[EMERGE] Enabling developer modules...<reset>\n")

  local dev_repo
  for _, repo_config in ipairs(self.repositories) do
    if repo_config.name == "emerge-dev" then
      dev_repo = repo_config
      break
    end
  end

  if not dev_repo then
    cecho("<red>[EMERGE] emerge-dev repository not configured.<reset>\n")
    return
  end
  
  -- Enable dev modules flag
  self.config.show_dev_modules = true
  self:saveConfig()

  cecho(string.format("<DimGrey>[EMERGE] Fetching manifest from %s...<reset>\n", dev_repo.name))

  self:downloadManifest(dev_repo, function(success, modules)
    if success and modules then
      -- Update the discovery cache with the dev modules (do NOT auto-load)
      local added_count = 0
      for idx, module_info in pairs(modules) do
        -- Extract proper module ID from module info
        local module_id = module_info and (module_info.id or module_info.name)
        if not module_id and module_info and module_info.github and module_info.github.file then
          module_id = tostring(module_info.github.file):match("([^/]+)%.lua$")
        end
        
        if module_id then
          module_info.repository = dev_repo.name
          self.discovery_cache.modules[module_id] = module_info
          added_count = added_count + 1
        end
      end
      
      cecho(string.format("<LightSteelBlue>[EMERGE] Found %d developer modules in discovery cache.<reset>\n", added_count))
      cecho("<DimGrey>Use 'emodule list' to see available modules.<reset>\n")
      cecho("<DimGrey>Use 'emodule load <module>' to load specific modules.<reset>\n")
      
      -- Save the updated discovery cache
      self:saveDiscoveryCache()
    else
      cecho(string.format("<red>[EMERGE] Failed to download manifest from %s.<reset>\n", dev_repo.name))
    end
  end)
end

-- Create aliases
function ModuleManager:createAliases()
  -- Clean up old aliases
  for _, id in pairs(self.aliases) do
    if exists(id, "alias") then
      killAlias(id)
    end
  end
  self.aliases = {}

  -- Module management commands
  self.aliases.list = tempAlias("^emodule list$", [[EMERGE:listModules()]])
  self.aliases.load = tempAlias("^emodule load (.+)$", [[
    local args = matches[2]
    if args == "required" then
      EMERGE:loadRequiredModules()
    else
      -- Support: "<branch> <repo>/<module>"
      local b, r, m = args:match("^([%w%-_%.]+)%s+([%w%-_%.]+)/([%w%-_%.]+)$")
      if b and r and m then
        EMERGE:loadModule(r .. "/" .. m, b)
        return
      end

      -- Support: "<repo>/<module>"
      local r2, m2 = args:match("^([%w%-_%.]+)/([%w%-_%.]+)$")
      if r2 and m2 then
        EMERGE:loadModule(r2 .. "/" .. m2)
        return
      end

      -- Support: "<branch> <module>"
      local branch, module = args:match("^([%w%-_%.]+)%s+([%w%-_%.]+)$")
      if branch and module then
        EMERGE:loadModule(module, branch)
      else
        EMERGE:loadModule(args)
      end
    end
  ]])
  self.aliases.unload = tempAlias("^emodule unload ([^ ]+)$", [[EMERGE:unloadModule(matches[2])]])
  self.aliases.unload_confirm = tempAlias("^emodule unload ([^ ]+) (.+)$",
    [[EMERGE:unloadModule(matches[2], matches[3])]])
  self.aliases.github = tempAlias("^emodule github (.+)$", [[
    if matches[2] == "help" then
      EMERGE:showGitHubHelp()
    else
      EMERGE:addGitHub(matches[2])
    end
  ]])
  self.aliases.add = tempAlias("^emodule add ([^ ]+) (.+)$", [[EMERGE:addModuleCommand(matches[2], matches[3])]])
  self.aliases.remove = tempAlias("^emodule remove (.+)$", [[EMERGE:removeModule(matches[2])]])
  self.aliases.enable = tempAlias("^emodule enable (.+)$", [[EMERGE:toggleModule(matches[2], true)]])
  self.aliases.disable = tempAlias("^emodule disable (.+)$", [[EMERGE:toggleModule(matches[2], false)]])
  self.aliases.update = tempAlias("^emodule update$", [[EMERGE:checkAllUpdates()]])
  self.aliases.update_registry = tempAlias("^emodule update registry$", [[EMERGE:updateRegistry()]])
  self.aliases.upgrade = tempAlias("^emodule upgrade (.+)$", [[EMERGE:upgradeComponent(matches[2])]])
  self.aliases.upgrade_short = tempAlias("^emodule upgrade$", [[
    cecho("<IndianRed>[EMERGE] Usage: emodule upgrade <manager|module|all><reset>\n")
    cecho("<DimGrey>Examples:<reset>\n")
    cecho("<DimGrey>  emodule upgrade manager      # Update the manager only<reset>\n")
    cecho("<DimGrey>  emodule upgrade emerge-core  # Update a specific module<reset>\n")
    cecho("<DimGrey>  emodule upgrade all          # Update everything<reset>\n")
  ]])
  self.aliases.upgrade_force = tempAlias("^emodule upgrade (.+) force$", [[EMERGE:upgradeComponent(matches[2], true)]])
  self.aliases.config = tempAlias("^emodule config$", [[EMERGE:showConfig()]])
  self.aliases.token = tempAlias("^emodule token (.+)$", [[EMERGE:setGitHubToken(matches[2])]])
  self.aliases.token_help = tempAlias("^emodule token$", [[EMERGE:setGitHubToken()]])
  self.aliases.intro = tempAlias("^emodule intro$", [[EMERGE:showIntroduction()]])
  self.aliases.help = tempAlias("^emodule help$", [[EMERGE:showHelp()]])
  self.aliases.help_short = tempAlias("^emodule$", [[EMERGE:showHelp()]])
  self.aliases.install = tempAlias("^emodule install$", [[EMERGE:manualInstall()]])
  self.aliases.status = tempAlias("^emodule status$", [[EMERGE:checkStatus()]])
  self.aliases.reload = tempAlias("^emodule reload$", [[
    cecho("<DimGrey>[EMERGE] Reloading manager from disk...<reset>\n")
    -- Try project directory first, then fall back to profile directory
    local f = getMudletHomeDir() .. "/../Projects/emerge-dev/emerge-dev/emerge-manager.lua"
    if not io.exists(f) then
      f = getMudletHomeDir() .. "/emerge-manager.lua"
    end
    if io.exists(f) then
      -- Unload current manager instance (preserve loaded modules)
      if EMERGE and EMERGE.unload then
        EMERGE:unload(true)
      end
      EMERGE = EMERGE or {}
      EMERGE._force_reload = true
      -- Temporarily suppress "Already loaded" message
      local original_cecho = cecho
      cecho = function(msg)
        if not string.find(msg, "Already loaded") then
          original_cecho(msg)
        end
      end
      dofile(f)
      cecho = original_cecho  -- Restore original cecho
      EMERGE._force_reload = nil
      cecho("<LightSteelBlue>[EMERGE] Reloaded successfully<reset>\n")
    else
      cecho("<IndianRed>[EMERGE] Manager file not found<reset>\n")
    end
  ]])

  -- Developer commands
  self.aliases.edev = tempAlias("^edev$", [[EMERGE:showDevModuleWarning()]])
  self.aliases.edev_confirm = tempAlias("^edev confirm$", [[EMERGE:_executeLoadDevModules()]])
  self.aliases.edev_off = tempAlias("^edev off$", [[EMERGE:hideDevModules()]])

  -- New discovery commands
  self.aliases.refresh = tempAlias("^emodule refresh$", [[EMERGE:refreshCache(true)]])
  self.aliases.repos = tempAlias("^emodule repos$", [[EMERGE:listRepositories()]])
  self.aliases.search = tempAlias("^emodule search (.+)$", [[EMERGE:searchModules(matches[2])]])
  self.aliases.searchall = tempAlias("^emodule searchall (.+)$", [[EMERGE:searchModulesAll(matches[2])]])
  self.aliases.info = tempAlias("^emodule info (.+)$", [[EMERGE:showModuleInfo(matches[2])]])
  self.aliases.debug = tempAlias("^emodule debug$", [[EMERGE:toggleDebug()]])
end

-- Toggle debug mode
function ModuleManager:toggleDebug()
  self.config.debug = not self.config.debug
  self:saveConfig()
  if self.config.debug then
    cecho("<LightSteelBlue>[EMERGE] Debug mode enabled<reset>\n")
  else
    cecho("<LightSteelBlue>[EMERGE] Debug mode disabled<reset>\n")
  end
end

-- List modules command
function ModuleManager:listModules()
  -- Refresh cache if needed (silently)
  local cache_age = os.time() - self.discovery_cache.last_refresh
  if cache_age > self.discovery_cache.cache_duration then
    local old_debug = self.config.debug
    self.config.debug = false
    self:refreshCache(false)
    self.config.debug = old_debug
  end

  -- Using 100-character width for consistent formatting
  cecho(
    "\n<SlateGray>════════════════════════════════════════════════════════════════════════════════════════════════════<reset>\n")
  cecho("<LightSteelBlue>                                    🚀 EMERGE Module System<reset>\n")
  cecho(
    "<SlateGray>════════════════════════════════════════════════════════════════════════════════════════════════════<reset>\n\n")

  -- Show currently loaded modules
  cecho("<LightSteelBlue>● Currently Loaded Modules<reset>\n")
  cecho(
    "<SlateGray>────────────────────────────────────────────────────────────────────────────────────────────────────<reset>\n")
  
  -- Show emerge-manager first (always core system)
  cecho(string.format(
    "  <SteelBlue>emerge-manager<reset> <DimGrey>v%s<reset> <yellow>●<reset> <DimGrey>core system<reset>\n", self
    .version))

  if next(self.modules) then
    -- Group loaded modules by repository
    local loaded_by_repo = {}
    local all_modules = self:getModuleList()
    
    for id, module in pairs(self.modules) do
      local update_status = ""
      local cached_module = self.discovery_cache.modules[id]
      if cached_module and cached_module.version and module.version then
        local needs_update = self:compareVersions(cached_module.version, module.version) > 0
        if needs_update then
          update_status = " <yellow>(update available)<reset>"
        end
      end
      
      -- Get repository information from cache or all_modules
      local repo = "unknown"
      if cached_module and cached_module.repository then
        repo = cached_module.repository
      elseif all_modules[id] and all_modules[id].repository then
        repo = all_modules[id].repository
      end
      
      loaded_by_repo[repo] = loaded_by_repo[repo] or {}
      table.insert(loaded_by_repo[repo], {
        id = id,
        module = module,
        update_status = update_status
      })
    end
    
    -- Sort repositories for consistent display
    local repos = {}
    for repo in pairs(loaded_by_repo) do
      table.insert(repos, repo)
    end
    table.sort(repos)
    
    -- Display grouped by repository
    for _, repo in ipairs(repos) do
      local modules = loaded_by_repo[repo]
      if #modules > 0 then
        cecho(string.format("\n  <DimGrey>── %s ──<reset>\n", repo))
        
        -- Sort modules within repository
        table.sort(modules, function(a, b) return a.id < b.id end)
        
        for _, entry in ipairs(modules) do
          cecho(string.format("  <SteelBlue>%s<reset> v%s - %s%s\n",
            entry.id, entry.module.version or "?", entry.module.name or "Unknown", entry.update_status))
        end
      end
    end
  else
    cecho("  <DimGrey>No additional modules loaded<reset>\n")
  end

  -- Separate and organize modules by repository and type
  local all_modules = self:getModuleList()
  local required_by_repo = {}
  local optional_by_repo = {}

  for id, info in pairs(all_modules) do
    -- Skip if module is already loaded (including the manager itself)
    if not self.modules[id] and id ~= "emerge-manager" then
      -- Check if module is required or optional
      local is_required = false
      if info.required == true or info.type == "required" or info.type == "core" or info.category == "required" then
        is_required = true
      elseif id:match("^emerge%-core") or id:match("^core%-") then
        is_required = true
      end

      local repo = info.repository or "unknown"

      if is_required then
        required_by_repo[repo] = required_by_repo[repo] or {}
        table.insert(required_by_repo[repo], { id = id, info = info })
      else
        optional_by_repo[repo] = optional_by_repo[repo] or {}
        table.insert(optional_by_repo[repo], { id = id, info = info })
      end
    end
  end

  -- Sort modules within each repo
  for repo, modules in pairs(required_by_repo) do
    table.sort(modules, function(a, b) return a.id < b.id end)
  end
  for repo, modules in pairs(optional_by_repo) do
    table.sort(modules, function(a, b) return a.id < b.id end)
  end

  -- Count total required modules
  local total_required = 0
  for _, modules in pairs(required_by_repo) do
    total_required = total_required + #modules
  end

  -- Show required modules grouped by repository
  if total_required > 0 then
    cecho("\n<LightSteelBlue>● Required Modules<reset> <DimGrey>(essential for combat system)<reset>\n")
    cecho(
      "<SlateGray>────────────────────────────────────────────────────────────────────────────────────────────────────<reset>\n")

    -- Sort repositories for consistent display
    local repos = {}
    for repo in pairs(required_by_repo) do
      table.insert(repos, repo)
    end
    table.sort(repos)

    for _, repo in ipairs(repos) do
      local modules = required_by_repo[repo]
      if #modules > 0 then
        cecho(string.format("\n  <DimGrey>── %s ──<reset>\n", repo))
        for _, entry in ipairs(modules) do
          local id = entry.id
          local info = entry.info

          local version_info = ""
          if info.version then
            version_info = " v" .. info.version
          end

          local desc = info.name or info.description or "No description"

          cecho(string.format("    <green>◆<reset> <SteelBlue>%s<reset>%s - %s\n",
            id, version_info, desc))
        end
      end
    end

    cecho("\n  <SlateGray>💡 <LightBlue>Quick start: <SteelBlue>emodule load required<reset>\n")
  end

  -- Count total optional modules
  local total_optional = 0
  for _, modules in pairs(optional_by_repo) do
    total_optional = total_optional + #modules
  end

  -- Show optional modules grouped by repository
  if total_optional > 0 then
    cecho("\n<LightSteelBlue>● Optional Modules<reset> <DimGrey>(additional features)<reset>\n")
    cecho(
      "<SlateGray>────────────────────────────────────────────────────────────────────────────────────────────────────<reset>\n")

    -- Sort repositories for consistent display
    local repos = {}
    for repo in pairs(optional_by_repo) do
      table.insert(repos, repo)
    end
    table.sort(repos)

    for _, repo in ipairs(repos) do
      local modules = optional_by_repo[repo]
      if #modules > 0 then
        cecho(string.format("\n  <DimGrey>── %s ──<reset>\n", repo))
        for _, entry in ipairs(modules) do
          local id = entry.id
          local info = entry.info

          local version_info = ""
          if info.version then
            version_info = " v" .. info.version
          end

          local desc = info.name or info.description or "No description"

          cecho(string.format("    <yellow>◇<reset> <SteelBlue>%s<reset>%s - %s\n",
            id, version_info, desc))
        end
      end
    end
  end

  if total_required == 0 and total_optional == 0 then
    cecho("\n<DimGrey>No additional modules available<reset>\n")
    cecho("<DimGrey>Try 'emodule refresh' to update module list<reset>\n")
  end

  -- Show helpful footer
  cecho(
    "\n<SlateGray>════════════════════════════════════════════════════════════════════════════════════════════════════<reset>\n")
  cecho("<DimGrey>📋 Commands:<reset>\n")
  cecho("  <SteelBlue>emodule load <module><reset>\n")
  cecho("  <SteelBlue>emodule load <repo>/<module><reset>\n")
  cecho("  <SteelBlue>emodule load <branch> <repo>/<module><reset>\n")
  cecho("  <SteelBlue>emodule help<reset> <DimGrey>│<reset> <SteelBlue>emodule update<reset>\n")

  -- Show cache status
  local cache_age = os.time() - self.discovery_cache.last_refresh
  if self.discovery_cache.last_refresh > 0 then
    cecho(string.format(
      "<DimGrey>🕒 Last updated: %d minutes ago<reset> <DimGrey>│<reset> <yellow>⚠️  Beta v%s<reset>\n",
      math.floor(cache_age / 60), self.version))
  end
end

-- Show configuration
function ModuleManager:showConfig()
  cecho("<SlateGray>==== Module Manager Configuration ====<reset>\n\n")
  cecho(string.format("<LightSteelBlue>Version:<reset> %s\n", self.version))
  cecho(string.format("Auto-update: %s\n",
    self.config.auto_update and "<PaleGreen>ON<reset>" or "<IndianRed>OFF<reset>"))
  cecho(string.format("Auto-load modules: %s\n",
    self.config.auto_load_modules and "<PaleGreen>ON<reset>" or "<IndianRed>OFF<reset>"))
  cecho(string.format("Update interval: %d seconds\n", self.config.update_interval))
  cecho(string.format("Debug mode: %s\n", self.config.debug and "<LightSteelBlue>ON<reset>" or "OFF"))
  cecho(string.format("\nCustom modules: %d\n", tsize(self.custom_modules)))
  cecho(string.format("Config location: %s\n", self.paths.config))
end

-- Show GitHub setup help
function ModuleManager:showGitHubHelp()
  cecho([[
<SlateGray>==== GitHub Integration Setup Guide ====<reset>

<LightSteelBlue>Step 1: Create a GitHub Personal Access Token<reset>
  1. Go to: ]])
  cechoLink("github.com/settings/tokens", [[openUrl("https://github.com/settings/tokens")]], "Click to open")
  cecho([[

  2. Click <SteelBlue>"Generate new token"<reset> → <SteelBlue>"Fine-grained personal access tokens"<reset>
  3. Give it a name like <DimGrey>"Mudlet EMERGE Access"<reset>
  4. Set expiration (recommended: <SteelBlue>90 days<reset>)
  5. Repository access: Choose <SteelBlue>Selected repositories<reset>
     - Click <SteelBlue>"Select repositories"<reset> dropdown
     - Search and check: <DimGrey>rjm11/emerge<reset>
     - Search and check: <DimGrey>rjm11/emerge-private<reset>
  6. Scroll down to <SteelBlue>Repository permissions<reset>
     - Find <SteelBlue>Contents<reset> row
     - Click dropdown → Select <SteelBlue>Read<reset>
  7. Scroll to bottom and click <SteelBlue>"Generate token"<reset>
  8. <yellow>IMPORTANT: Copy the token NOW - you won't see it again!<reset>
     Token looks like: <DimGrey>github_pat_xxxxxxxxxxxxxxxxxxxx<reset>

<LightSteelBlue>Step 2: Add Token to EMERGE<reset>
  Run: <SteelBlue>emodule token <your_token_here><reset>
  Example: <DimGrey>emodule token github_pat_1234567890abcdef<reset>

<LightSteelBlue>Step 3: Add Modules<reset>
  Public repos:  <SteelBlue>emodule github owner/repository<reset>
  Private repos: <SteelBlue>emodule github owner/private-repo<reset>

<LightSteelBlue>Security Notes:<reset>
  • Your token is stored locally in: <DimGrey>emerge-config.json<reset>
  • Never share your token with others
  • Tokens can be revoked anytime on GitHub
  • Use separate tokens for different applications

<LightSteelBlue>Troubleshooting:<reset>
  • <DimGrey>"404 Not Found"<reset> - Check repo name or token permissions
  • <DimGrey>"401 Unauthorized"<reset> - Token may be expired or invalid
  • <DimGrey>"Rate limit"<reset> - Wait an hour or use a token (increases limits)

<DimGrey>Type 'emodule help' for all commands<reset>
]])
end

-- Show help
function ModuleManager:showHelp()
  -- Check if GitHub token is saved
  local token_status = ""
  if self.config.github_token and self.config.github_token ~= "" then
    token_status = " <DarkGreen>(token saved)<reset>"
  end

  cecho([[
<SlateGray>==== EMERGE Module System ====<reset>
<DimGrey>Emergent Modular Engagement & Response Generation Engine<reset>
<SlateGray>From simplicity, emerges victory<reset>

<LightSteelBlue>Core Commands:<reset>
  <SteelBlue>emodule list<reset>             List all modules (loaded & available)
  <SteelBlue>emodule load <id><reset>        Download and load a module
  <SteelBlue>emodule load <repo>/<id><reset> Load from a specific repository
  <SteelBlue>emodule load <branch> <id><reset>  Load module from specific branch
  <SteelBlue>emodule load <branch> <repo>/<id><reset>  Load from branch and repo
  <SteelBlue>emodule load required<reset>    Load all required modules
  <SteelBlue>emodule unload <id><reset>      Unload a loaded module
  <SteelBlue>emodule enable <id><reset>      Enable a module for auto-loading
  <SteelBlue>emodule disable <id><reset>     Disable a module

<LightSteelBlue>Discovery & Search:<reset>
  <SteelBlue>emodule refresh<reset>          Force refresh module discovery cache
  <SteelBlue>emodule repos<reset>            List configured repositories
  <SteelBlue>emodule search <term><reset>    Search available modules
  <SteelBlue>emodule info <id><reset>        Show detailed module information

<LightSteelBlue>System Management:<reset>
  <SteelBlue>emodule unload manager confirm<reset>  Completely remove EMERGE

<LightSteelBlue>GitHub Integration:<reset>]] .. token_status .. [[

  <SteelBlue>emodule github <url><reset>     Add module from GitHub repository
  <SteelBlue>emodule remove <id><reset>      Remove a custom module
  <SteelBlue>emodule token <token><reset>    Set GitHub token for private repos

<LightSteelBlue>Update Commands:<reset>
  <SteelBlue>emodule update<reset>           Check all components for updates
  <SteelBlue>emodule upgrade <target><reset> Upgrade manager/module/all

<LightSteelBlue>Other Commands:<reset>
  <SteelBlue>emodule config<reset>           Show current configuration
  <SteelBlue>emodule help<reset>             Show this help (or just 'emodule')

<LightSteelBlue>Developer Commands:<reset>
  <SteelBlue>edev<reset>                     Show warning and instructions for developer modules
  <SteelBlue>edev confirm<reset>             Enable developer modules for discovery (no auto-load)

<DimGrey>Configuration: ]] .. self.paths.config .. [[<reset>
]])
end

-- Add module via command
function ModuleManager:addModuleCommand(id, json_str)
  if not id or id == "" or not json_str or json_str == "" then
    cecho("<IndianRed>[EMERGE] Usage: emodule add <id> <json_config><reset>\n")
    return
  end

  local ok, module_info = pcall(yajl.to_value, json_str)
  if ok and module_info then
    self:addModule(id, module_info)
  else
    cecho("<IndianRed>[EMERGE] Invalid JSON format<reset>\n")
    cecho(
      "<DimGrey>Example: emodule add mymod {\"name\":\"My Module\",\"github\":{\"owner\":\"me\",\"repo\":\"my-mod\",\"file\":\"mod.lua\"}}<reset>\n")
  end
end

-- Show bootup sequence
function ModuleManager:showBootup()
  -- Clear some space
  echo("\n\n")

  -- EMERGE ASCII art with clean modern look
  cecho([[<SlateGray>
    ███████╗███╗   ███╗███████╗██████╗  ██████╗ ███████╗
    ██╔════╝████╗ ████║██╔════╝██╔══██╗██╔════╝ ██╔════╝
    █████╗  ██╔████╔██║█████╗  ██████╔╝██║  ███╗█████╗
    ██╔══╝  ██║╚██╔╝██║██╔══╝  ██╔══██╗██║   ██║██╔══╝
    ███████╗██║ ╚═╝ ██║███████╗██║  ██║╚██████╔╝███████╗
    ╚══════╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝<reset>
]])

  cecho("<LightSteelBlue>    Emergent Modular Engagement & Response Generation Engine<reset>\n")
  cecho(string.format("<DimGray>    Version %s | Event-Driven Architecture<reset>\n", self.version))
  cecho("<SlateGray>    From simplicity, emerges victory<reset>\n\n")

  -- Bootup sequence
  local steps = {
    { delay = 0.2, msg = "<DimGrey>[SYSTEM]<reset> Initializing core framework..." },
    { delay = 0.4, msg = "<DimGrey>[SYSTEM]<reset> Loading configuration..." },
    { delay = 0.6, msg = "<DimGrey>[SYSTEM]<reset> Verifying module registry..." },
    { delay = 0.8, msg = "<DimGrey>[SYSTEM]<reset> Establishing event handlers..." },
    { delay = 1.0, msg = "<green>[SYSTEM] Initialization complete<reset>" },
  }

  for i, step in ipairs(steps) do
    tempTimer(step.delay, function()
      cecho(step.msg .. "\n")

      -- After last step, check if first run
      if i == #steps then
        tempTimer(0.5, function()
          if self.config.first_run == nil or self.config.first_run then
            self:showIntroduction()
          else
            self:checkCoreModules()
          end
        end)
      end
    end)
  end
end

-- Show introduction for first-time users
function ModuleManager:showIntroduction()
  -- Skip the long intro, just check modules immediately
  self:checkCoreModules()

  -- Mark first run as complete
  self.config.first_run = false
  self:saveConfig()
end

-- Show welcome message
function ModuleManager:checkCoreModules()
  -- Since we don't have any fake modules anymore, just show the welcome
  cecho("\n<SlateGray>──────────────────────────────────────<reset>\n")
  cecho("<green>✓ System Ready<reset>\n")
  cecho("<SlateGray>──────────────────────────────────────<reset>\n\n")
  cecho("<LightSteelBlue>Quick Start:<reset>\n")
  cecho("  <SteelBlue>emodule help<reset>         - View all commands\n")
  cecho("  <SteelBlue>emodule list<reset>         - See available modules\n\n")

  -- Check if token is set
  if not self.config.github_token or self.config.github_token == "" then
    cecho("<yellow>First-time setup:<reset>\n")
    cecho("  <DimGrey>1. Get a GitHub token from: ")
    cechoLink("github.com/settings/tokens", [[openUrl("https://github.com/settings/tokens")]],
      "Click to open GitHub tokens page")
    cecho("<reset>\n")
    cecho("  <DimGrey>2. Set your token: <SteelBlue>emodule token <token><reset>\n")
    cecho("  <DimGrey>3. Need help? <SteelBlue>emodule github help<reset>\n\n")
    cecho("<DimGrey>Then add modules:<reset>\n")
  else
    cecho("<DimGrey>Add modules from GitHub:<reset>\n")
  end

  cecho("  <DimGrey>emodule github <url><reset>\n")
  cecho("  <DimGrey>emodule github <owner/repo><reset>\n\n")
  cecho("<DimGrey>Documentation: ")
  cechoLink("github.com/rjm11/emerge/wiki", [[openUrl("https://github.com/rjm11/emerge/wiki")]], "Click to open")
  cecho("<reset>\n")
end

-- Initialize
function ModuleManager:init()
  -- Load configuration
  self:loadConfig()

  -- Create aliases
  self:createAliases()
  -- Install wrappers to track resources created by modules
  self:_installResourceWrappers()

  -- Track init timers so we can cancel them on unload/reload
  self.init_timers = {}

  -- Schedule bootup sequence (5 seconds after game login)
  local t1 = tempTimer(5, function()
    if EMERGE and EMERGE.loaded then
      EMERGE:showBootup()
    end
  end)
  table.insert(self.init_timers, t1)

  -- Schedule discovery refresh (10 seconds after bootup)
  local t2 = tempTimer(10, function()
    if EMERGE and EMERGE.loaded then
      -- Only do discovery if we have a GitHub token for private repos
      if EMERGE.config.github_token and EMERGE.config.github_token ~= "" then
        EMERGE:refreshCache(false)
      else
        cecho("<DimGrey>[EMERGE] Set GitHub token to enable module discovery<reset>\n")
      end
    end
  end)
  table.insert(self.init_timers, t2)

  -- Schedule cache loading first (12 seconds after bootup)
  local t3 = tempTimer(12, function()
    if EMERGE and EMERGE.loaded then
      EMERGE:loadCachedModules()
    end
  end)
  table.insert(self.init_timers, t3)

  -- Schedule auto-load after discovery
  local t4 = tempTimer(15, function()
    if EMERGE and EMERGE.loaded then
      EMERGE:autoLoadModules()
    end
  end)
  table.insert(self.init_timers, t4)

  -- Schedule update check (DISABLED - only manual updates)
  -- Automatic updates disabled - use 'emodule update' for manual checking
  -- if self.config.auto_update then
  --   tempTimer(40, function()
  --     if EMERGE and EMERGE.loaded then
  --       EMERGE.silent_check = true
  --       EMERGE:checkAllUpdates()
  --     end
  --   end)
  -- end

  self.loaded = true
end

-- Unload
function ModuleManager:unload(updating)
  -- Clean up aliases
  for _, id in pairs(self.aliases) do
    if exists(id, "alias") then
      killAlias(id)
    end
  end
  
  -- Clean up all event handlers
  if self.handlers then
    for _, handler_id in pairs(self.handlers) do
      if handler_id then
        pcall(function() killAnonymousEventHandler(handler_id) end)
      end
    end
    self.handlers = {}
  end
  
  -- Clean up any tracked resources from modules
  if self.tracked_resources then
    for module_id, resources in pairs(self.tracked_resources) do
      if resources.handlers then
        for _, id in ipairs(resources.handlers) do
          pcall(function() killAnonymousEventHandler(id) end)
        end
      end
      if resources.timers then
        for _, id in ipairs(resources.timers) do
          pcall(function() killTimer(id) end)
        end
      end
      if resources.aliases then
        for _, id in ipairs(resources.aliases) do
          pcall(function() killAlias(id) end)
        end
      end
      if resources.triggers then
        for _, id in ipairs(resources.triggers) do
          pcall(function() killTrigger(id) end)
        end
      end
    end
    self.tracked_resources = {}
  end

  -- Don't unload modules if we're just updating the manager
  if not updating then
    for id, module in pairs(self.modules) do
      if module.unload then
        module:unload()
      end
    end
    self.modules = {}
  end

  -- Cancel any scheduled init timers to prevent duplicate initialization on reload
  if self.init_timers then
    for _, tid in ipairs(self.init_timers) do
      pcall(function() killTimer(tid) end)
    end
    self.init_timers = {}
  end

  self.loaded = false
end

-- Create persistent loader
function ModuleManager:createPersistentLoader(forceCreate)
  local _killScript = rawget(_G, "killScript") or function(...) end
  -- Set flag to prevent duplicate loading during installation
  EMERGE.creating_bootloader = true

  -- Check if both group and script already exist
  local groupExists = exists("EMERGE", "script") > 0
  local scriptExists = exists("EMERGE Module Bootloader", "script") > 0

  -- If both exist and we're not forcing, we're done
  if groupExists and scriptExists and not forceCreate then
    cecho("<DimGrey>• Persistence layer already exists<reset>\n")
    enableScript("EMERGE")
    enableScript("EMERGE Module Bootloader")
    EMERGE.creating_bootloader = false
    return
  end

  -- If forcing, try to clean up existing items first
  if forceCreate then
    if scriptExists then
      pcall(function()
        disableScript("EMERGE Module Bootloader")
        _killScript("EMERGE Module Bootloader")
      end)
    end
    if groupExists then
      pcall(function()
        disableScript("EMERGE")
        -- Note: Mudlet doesn't have killGroup, so we can't remove the group
        -- But at least we won't create duplicates
      end)
    end
  end

  cecho("<DimGrey>• Setting up persistence layer...<reset>\n")

  -- First, ensure the manager file exists at the expected location
  local manager_file = getMudletHomeDir() .. "/emerge-manager.lua"

  if not io.exists(manager_file) then
    -- Try to save ourselves to that location
    local current_script = [[-- This file is auto-generated by EMERGE installer
-- It will be replaced with the full manager on next update
downloadFile(getMudletHomeDir().."/emerge-manager.lua", "https://raw.githubusercontent.com/rjm11/emerge/main/emerge-manager.lua")
registerAnonymousEventHandler("sysDownloadDone", function(e,p)
  if p:find("emerge%-manager%.lua$") then
    dofile(p)
  end
end, true)
]]
    local f = io.open(manager_file, "w")
    if f then
      f:write(current_script)
      f:close()
    else
      cecho("<red>[EMERGE] Failed to create bootstrap file<reset>\n")
      return
    end
  end

  -- Only create the group if it doesn't exist
  if not groupExists then
    local group_id = permGroup("EMERGE", "script")
    if not group_id then
      cecho("<red>[EMERGE] Failed to create script group<reset>\n")
      EMERGE.creating_bootloader = false
      return
    end
    cecho("<DimGrey>• Created EMERGE group<reset>\n")
  else
    cecho("<DimGrey>• EMERGE group already exists<reset>\n")
  end

  -- Enable the group to ensure it's checked in Script Editor
  enableScript("EMERGE")

  -- Only create the script if it doesn't exist
  if not scriptExists then
    -- Create the loader script inside the EMERGE group
    local script_code = [[
-- EMERGE Module Bootloader
-- This script loads the EMERGE module system on Mudlet startup

-- Don't run if we're being created right now
if EMERGE and EMERGE.creating_bootloader then
  return
end

-- Set flag to indicate we're loading from the bootloader
EMERGE_BOOTLOADER_ACTIVE = true

local manager_file = getMudletHomeDir() .. "/emerge-manager.lua"
if io.exists(manager_file) then
  dofile(manager_file)
else
  cecho("<IndianRed>[EMERGE] Manager file not found. Please reinstall EMERGE.<reset>\n")
end
]]

    local script_id = permScript("EMERGE Module Bootloader", "EMERGE", script_code)
    cecho("<DimGrey>• Created bootloader script<reset>\n")
  else
    cecho("<DimGrey>• Bootloader script already exists<reset>\n")
    local script_id = true -- Set to true so the following if block still works
  end

  -- Only enable and save if we have a valid script
  local script_id = exists("EMERGE Module Bootloader", "script") > 0

  if script_id then
    -- Enable the script to ensure it's checked in Script Editor
    enableScript("EMERGE Module Bootloader")

    cecho("<DimGrey>• Persistence configured<reset>\n")

    -- Save the profile
    if saveProfile() then
      cecho("<DimGrey>• Profile saved<reset>\n")
    end
  else
    cecho("<IndianRed>✗ Failed to create bootloader<reset>\n")
    cecho("<yellow>Manual installation required:<reset>\n")
    cecho("<DimGrey>1. Open Script Editor (Alt+E)<reset>\n")
    cecho("<DimGrey>2. Create a script group called 'EMERGE'<reset>\n")
    cecho("<DimGrey>3. Add a script with: dofile(getMudletHomeDir()..'/emerge-manager.lua')<reset>\n")
    cecho("<DimGrey>4. Save your profile (Ctrl+S)<reset>\n")
  end

  -- Clear flag
  EMERGE.creating_bootloader = false
end

-- Add a manual install command
function ModuleManager:manualInstall()
  cecho("<yellow>[EMERGE] Starting manual installation process...<reset>\n")

  -- Force create even if it exists
  self:createPersistentLoader(true)

  -- Also provide alternative instructions
  cecho("\n<LightSteelBlue>If automatic installation failed, follow these steps:<reset>\n")
  cecho("<LightSteelBlue>1. Open the Script Editor (Alt+E or Tools → Editor)<reset>\n")
  cecho("<LightSteelBlue>2. Right-click 'Scripts' and select 'Add Group'<reset>\n")
  cecho("<LightSteelBlue>3. Name the group 'EMERGE'<reset>\n")
  cecho("<LightSteelBlue>4. Right-click the EMERGE group and select 'Add Item'<reset>\n")
  cecho("<LightSteelBlue>5. Name it 'EMERGE Bootloader'<reset>\n")
  cecho("<LightSteelBlue>6. In the script box, paste this line:<reset>\n")
  cecho("<green>dofile(getMudletHomeDir() .. '/emerge-manager.lua')<reset>\n")
  cecho("<LightSteelBlue>7. Click 'Save Item'<reset>\n")
  cecho("<LightSteelBlue>8. Save your profile (Ctrl+S or File → Save Profile)<reset>\n")
end

-- Check installation status
function ModuleManager:checkStatus()
  cecho("<SlateGray>==== EMERGE Installation Status ====<reset>\n\n")

  -- Check if manager file exists
  local manager_file = getMudletHomeDir() .. "/emerge-manager.lua"
  if io.exists(manager_file) then
    cecho("<green>✓ Manager file exists<reset>\n")
    cecho("  <DimGrey>Location: " .. manager_file .. "<reset>\n")
  else
    cecho("<red>✗ Manager file missing<reset>\n")
    cecho("  <DimGrey>Expected at: " .. manager_file .. "<reset>\n")
  end

  -- Check if bootloader exists
  if exists("EMERGE Module Bootloader", "script") then
    cecho("<yellow>⚠ Bootloader detected (may be temporary)<reset>\n")
    cecho("  <DimGrey>Check Script Editor (Alt+E) to verify it's saved<reset>\n")
  else
    cecho("<red>✗ Bootloader not found<reset>\n")
  end

  -- Check if EMERGE is loaded
  if EMERGE and EMERGE.loaded then
    cecho("<green>✓ EMERGE is currently loaded<reset>\n")
    cecho("  <DimGrey>Version: " .. (EMERGE.version or "unknown") .. "<reset>\n")
  else
    cecho("<red>✗ EMERGE not loaded<reset>\n")
  end

  cecho("\n<LightSteelBlue>To ensure persistence:<reset>\n")
  cecho("1. Type: <yellow>emodule install<reset>\n")
  cecho("2. Open Script Editor (Alt+E) and verify 'EMERGE' group exists\n")
  cecho("3. Save your profile (Ctrl+S)\n")
  cecho("4. Restart Mudlet to test persistence\n")
end

-- Load from cache if available
function ModuleManager:loadFromCache(module_id)
  local cache_file = self.paths.cache .. module_id .. ".lua"
  if not io.exists(cache_file) then
    return false
  end

  cecho(string.format("<DarkOrange>[EMERGE] Loading %s from cache...<reset>\n", module_id))

  self:_installResourceWrappers()
  EMERGE._current_loading_module = module_id
  local chunk, load_err = loadfile(cache_file)
  if type(chunk) == "function" then
    local ok, err = pcall(chunk)
    EMERGE._current_loading_module = nil
    if ok then
      cecho(string.format("<green>[EMERGE] Successfully loaded %s from cache<reset>\n", module_id))
      return true
    else
      cecho(string.format("<IndianRed>[EMERGE] Failed to execute cached %s: %s<reset>\n", module_id, tostring(err)))
    end
  else
    cecho(string.format("<IndianRed>[EMERGE] Failed to load cached %s: %s<reset>\n", module_id, tostring(load_err)))
  end

  return false
end

-- Load cached modules on startup
function ModuleManager:loadCachedModules()
  if not lfs then
    return -- Can't scan cache without lfs
  end

  local cache_dir = self.paths.cache
  if not io.exists(cache_dir) then
    return
  end

  cecho("<DimGrey>[EMERGE] Checking cache for previously loaded modules...<reset>\n")

  -- Scan cache directory
  for file in lfs.dir(cache_dir) do
    if file:match("%.lua$") and not file:match("^%.") and not file:match("^module%-manager%-check") and not file:match("^manager%-update%-check") then
      local module_id = file:gsub("%.lua$", "")
      if not self.modules[module_id] and module_id ~= "emerge-manager" then
        -- Try to load from cache
        if self:loadFromCache(module_id) then
          -- Mark as loaded but don't auto-load on future startups unless configured
          self.modules[module_id] = true
        end
      end
    end
  end
end

-- Auto-initialize
ModuleManager:init()

-- Check if we're being loaded from the bootloader or from a fresh install
if not EMERGE_BOOTLOADER_ACTIVE then
  -- Fresh install - set up persistence
  EMERGE.installing = true -- Set flag to suppress "already loaded" message

  local ok, err = pcall(function()
    ModuleManager:createPersistentLoader(false) -- Don't force - prevent duplicates
  end)

  EMERGE.installing = false -- Clear flag

  if not ok then
    cecho("<red>[EMERGE] Auto-install failed: " .. tostring(err) .. "<reset>\n")
    cecho("<yellow>[EMERGE] Type 'emodule install' for manual setup<reset>\n")
  end
else
  -- Clear the bootloader flag
  EMERGE_BOOTLOADER_ACTIVE = nil
end
