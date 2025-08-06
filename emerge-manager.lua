-- EMERGE: Emergent Modular Engagement & Response Generation Engine
-- Self-updating module system with external configuration
-- Version: 0.5.7

local CURRENT_VERSION = "0.5.7"
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
    if not (EMERGE.installing or EMERGE.creating_bootloader) then
      cecho("<DarkOrange>[EMERGE] Already loaded.<reset>\n")
    end
    return
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
EMERGE.aliases = {}
EMERGE.handlers = {}

-- For backward compatibility
ModuleManager = EMERGE

-- Configuration paths
ModuleManager.paths = {
  config = getMudletHomeDir() .. "/emerge-config.json",
  custom = getMudletHomeDir() .. "/emerge-custom-modules.json",
  cache = getMudletHomeDir() .. "/emerge-cache/"
}

-- Default module registry - empty until modules are actually created
-- Modules can be added via 'emodule github' command
ModuleManager.default_registry = {}

-- GitHub configuration for self-updates
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
      debug = false
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

-- Get complete module list (default + custom)
function ModuleManager:getModuleList()
  local all_modules = {}
  
  -- Add default modules
  for id, module in pairs(self.default_registry) do
    all_modules[id] = table.deepcopy(module)
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
    
    downloadFile(self.paths.cache .. "github-check.json", check_url, headers)
    
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
            cecho(string.format("<LightSteelBlue>[EMERGE] Successfully added module '%s' from %s/%s<reset>\n",
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

-- Load a module from GitHub
function ModuleManager:loadModule(module_id)
  if not module_id or module_id == "" then
    cecho("<IndianRed>[EMERGE] Usage: emodule load <module_id><reset>\n")
    return
  end
  
  local module_info = self:getModuleList()[module_id]
  if not module_info then
    cecho(string.format("<IndianRed>[EMERGE] Unknown module: %s<reset>\n", module_id))
    cecho("<DimGrey>Try 'emodule list' to see available modules<reset>\n")
    return
  end
  
  if not module_info.github then
    cecho(string.format("<IndianRed>[EMERGE] No GitHub info for module: %s<reset>\n", module_id))
    return
  end
  
  local url = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s",
    module_info.github.owner,
    module_info.github.repo,
    module_info.github.branch or "main",
    module_info.github.file)
  
  cecho(string.format("<DarkOrange>[EMERGE] Downloading %s...<reset>\n", module_id))
  
  -- Add headers for private repos if token is available
  local headers = {}
  if self.config.github_token then
    headers["Authorization"] = "token " .. self.config.github_token
  end
  
  downloadFile(self.paths.cache .. module_id .. ".lua", url, headers)
  
  -- Set up handler for download completion
  if self.handlers.download then
    killAnonymousEventHandler(self.handlers.download)
  end
  
  self.handlers.download = registerAnonymousEventHandler("sysDownloadDone", function(_, filename)
    if filename:find(module_id .. "%.lua$") then
      cecho(string.format("<LightSteelBlue>[EMERGE] Downloaded %s<reset>\n", module_id))
      
      -- Load the module
      local ok, err = loadfile(filename)
      if ok then
        ok, err = pcall(ok)
        if not ok then
          cecho(string.format("<IndianRed>[EMERGE] Failed to load %s: %s<reset>\n", module_id, err))
        end
      else
        cecho(string.format("<IndianRed>[EMERGE] Failed to parse %s: %s<reset>\n", module_id, err))
      end
      
      killAnonymousEventHandler(self.handlers.download)
      self.handlers.download = nil
    end
  end)
end

-- Unload a module  
function ModuleManager:unloadModule(module_id, confirm)
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
      killScript("EMERGE Module Bootloader")
      cecho("<DarkOrange>[EMERGE] Removed persistent bootloader<reset>\n")
    end
    
    -- Try to remove the group as well
    if exists("EMERGE", "script") then
      killScript("EMERGE")
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
    self.modules[module_id] = nil
    cecho(string.format("<DarkOrange>[EMERGE] Unloaded: %s<reset>\n", module_id))
  else
    cecho(string.format("<IndianRed>[EMERGE] Module not loaded: %s<reset>\n", module_id))
  end
end

-- Check all modules for updates
function ModuleManager:checkAllUpdates()
  cecho("<DarkOrange>[EMERGE] Checking all modules for updates...<reset>\n")
  
  -- Check self first
  self:checkSelfUpdate()
  
  -- Check each loaded module
  for id, module in pairs(self.modules) do
    if module.checkForUpdates then
      module:checkForUpdates(true)
    end
  end
end

-- Check for ModuleManager updates
function ModuleManager:checkSelfUpdate()
  local url = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s",
    self.github.owner,
    self.github.repo,
    self.github.branch,
    self.github.files.manager)
  
  -- Add headers for private repos if token is available
  local headers = {}
  if self.config.github_token then
    headers["Authorization"] = "token " .. self.config.github_token
  end
  
  downloadFile(self.paths.cache .. "module-manager-check.lua", url, headers)
  
  registerAnonymousEventHandler("sysDownloadDone", function(_, filename)
    if filename:find("module-manager-check%.lua$") then
      local file = io.open(filename, "r")
      if file then
        local content = file:read("*all")
        file:close()
        
        local remote_version = content:match('local CURRENT_VERSION = "([^"]+)"')
        if remote_version and remote_version ~= self.version then
          cecho(string.format("<DarkOrange>[EMERGE] Update available: v%s -> v%s<reset>\n",
            self.version, remote_version))
          cecho("<SteelBlue>Run 'module upgrade manager' to update<reset>\n")
          
          self.pending_update = {
            version = remote_version,
            content = content
          }
        elseif remote_version == self.version then
          if not self.silent_check then
            cecho("<LightSteelBlue>[EMERGE] You have the latest version<reset>\n")
          end
        end
      end
    end
  end, true) -- one-time handler
end

-- Update ModuleManager
function ModuleManager:upgradeSelf()
  -- Check for updates first if we don't have a pending update
  if not self.pending_update then
    cecho("<DimGrey>[EMERGE] Checking for updates...<reset>\n")
    
    -- Add timestamp to bypass GitHub's cache
    local url = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s?t=%d",
      self.github.owner,
      self.github.repo, 
      self.github.branch,
      self.github.files.manager,
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
    
    local check_file = self.paths.cache .. "manager-update-check.lua"
    
    -- Store handlers to ensure they can be killed
    local downloadHandler, errorHandler, timeoutHandler
    
    -- Set up timeout
    timeoutHandler = tempTimer(10, function()
      cecho("<IndianRed>[EMERGE] Update check timed out. Please try again.<reset>\n")
      if downloadHandler then killAnonymousEventHandler(downloadHandler) end
      if errorHandler then killAnonymousEventHandler(errorHandler) end
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
            
            if remote_version ~= self.version then
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
        if downloadHandler then killAnonymousEventHandler(downloadHandler) end
        
        cecho("<IndianRed>[EMERGE] Failed to download update: " .. (errorMsg or "unknown error") .. "<reset>\n")
        cecho("<DimGrey>URL: " .. url .. "<reset>\n")
      end
    end, true)
    
    -- Initiate the download
    downloadFile(check_file, url, headers)
    
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
    local ok, err = loadfile(temp_file)
    if ok then
      ok, err = pcall(ok)
      if ok then
        cecho("<LightSteelBlue>[EMERGE] Upgrade successful!<reset>\n")
        os.remove(temp_file)
        self.pending_update = nil
      else
        cecho(string.format("<IndianRed>[EMERGE] Upgrade failed: %s<reset>\n", err))
      end
    end
  end
end

-- Update module registry from GitHub
function ModuleManager:updateRegistry()
  local url = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s",
    self.github.owner,
    self.github.repo,
    self.github.branch,
    self.github.files.registry)
  
  -- Add headers for private repos if token is available
  local headers = {}
  if self.config.github_token then
    headers["Authorization"] = "token " .. self.config.github_token
  end
  
  downloadFile(self.paths.cache .. "module-registry.json", url, headers)
  
  registerAnonymousEventHandler("sysDownloadDone", function(_, filename)
    if filename:find("module-registry%.json$") then
      local file = io.open(filename, "r")
      if file then
        local content = file:read("*all")
        file:close()
        
        local ok, registry = pcall(yajl.to_value, content)
        if ok and registry then
          self.default_registry = registry
          cecho("<LightSteelBlue>[EMERGE] Module registry updated<reset>\n")
        end
      end
    end
  end, true)
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
      table.insert(to_load, {
        id = id,
        info = info,
        order = info.load_order or 999
      })
    end
  end
  
  -- Sort by load_order
  table.sort(to_load, function(a, b)
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
    cecho("<DarkOrange>[EMERGE] GitHub Token Setup<reset>\n\n")
    cecho("<LightSteelBlue>To create a GitHub personal access token:<reset>\n")
    cecho("  1. Go to ")
    cechoLink("https://github.com/settings/tokens", [[openUrl("https://github.com/settings/tokens")]], "Click to open in browser")
    echo("\n")
    cecho("  2. Click 'Generate new token (classic)'\n")
    cecho("  3. Give it a name (e.g., 'Mudlet EMERGE')\n")
    cecho("  4. Select the 'repo' scope checkbox\n")
    cecho("  5. Click 'Generate token' at the bottom\n")
    cecho("  6. Copy the token that starts with 'ghp_'\n\n")
    cecho("<SteelBlue>Then run: emodule token YOUR_TOKEN_HERE<reset>\n")
    return
  end
  
  self.config.github_token = token
  self:saveConfig()
  
  cecho("<LightSteelBlue>[EMERGE] GitHub token saved<reset>\n")
  cecho("<DimGrey>You can now access private repositories<reset>\n")
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
  self.aliases.load = tempAlias("^emodule load (.+)$", [[EMERGE:loadModule(matches[2])]])
  self.aliases.unload = tempAlias("^emodule unload ([^ ]+)$", [[EMERGE:unloadModule(matches[2])]])
  self.aliases.unload_confirm = tempAlias("^emodule unload ([^ ]+) (.+)$", [[EMERGE:unloadModule(matches[2], matches[3])]])
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
  self.aliases.upgrade = tempAlias("^emodule upgrade manager$", [[EMERGE:upgradeSelf()]])
  self.aliases.upgrade_short = tempAlias("^emodule upgrade$", [[EMERGE:upgradeSelf()]])
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
    local f = getMudletHomeDir() .. "/emerge-manager.lua"
    if io.exists(f) then
      dofile(f)
      cecho("<LightSteelBlue>[EMERGE] Reloaded successfully<reset>\n")
    else
      cecho("<IndianRed>[EMERGE] Manager file not found<reset>\n")
    end
  ]])
end

-- List modules command
function ModuleManager:listModules()
  cecho("\n<SlateGray>──────────────────────────────────────<reset>\n")
  cecho("<LightSteelBlue>EMERGE Module System<reset>\n")
  cecho("<SlateGray>──────────────────────────────────────<reset>\n\n")
  
  -- Show currently loaded modules
  cecho("<LightSteelBlue>Currently Loaded:<reset>\n")
  cecho(string.format("  <SteelBlue>• emerge-manager<reset> v%s <DimGrey>(core system)<reset>\n", self.version))
  
  if next(self.modules) then
    for id, module in pairs(self.modules) do
      cecho(string.format("  <SteelBlue>• %s<reset> v%s - %s\n", 
        id, module.version or "?", module.name or "Unknown"))
    end
  end
  
  -- Show available modules (from custom only, since default is now empty)
  local custom_count = 0
  for id, info in pairs(self.custom_modules) do
    if not self.modules[id] then
      custom_count = custom_count + 1
    end
  end
  
  if custom_count > 0 then
    cecho("\n<LightSteelBlue>Available to Load:<reset>\n")
    for id, info in pairs(self.custom_modules) do
      if not self.modules[id] then
        local source = string.format("<DimGrey>(%s/%s)<reset>", 
          info.github and info.github.owner or "local",
          info.github and info.github.repo or "unknown")
        cecho(string.format("  <SteelBlue>• %s<reset> - %s %s\n", 
          id, info.name or "Unknown", source))
      end
    end
  else
    cecho("\n<DimGrey>No additional modules available<reset>\n")
    cecho("<DimGrey>Add modules with: emodule github <owner/repo><reset>\n")
  end
  
  cecho("\n<DimGrey>Type 'emodule help' for all commands<reset>\n")
end

-- Show configuration
function ModuleManager:showConfig()
  cecho("<SlateGray>==== Module Manager Configuration ====<reset>\n\n")
  cecho(string.format("<LightSteelBlue>Version:<reset> %s\n", self.version))
  cecho(string.format("Auto-update: %s\n", self.config.auto_update and "<PaleGreen>ON<reset>" or "<IndianRed>OFF<reset>"))
  cecho(string.format("Auto-load modules: %s\n", self.config.auto_load_modules and "<PaleGreen>ON<reset>" or "<IndianRed>OFF<reset>"))
  cecho(string.format("Update interval: %d seconds\n", self.config.update_interval))
  cecho(string.format("Debug mode: %s\n", self.config.debug and "<LightSteelBlue>ON<reset>" or "OFF"))
  cecho(string.format("\nCustom modules: %d\n", table.size(self.custom_modules)))
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

  2. Click <SteelBlue>"Generate new token"<reset> → <SteelBlue>"Generate new token (classic)"<reset>
  3. Give it a name like <DimGrey>"Mudlet EMERGE Access"<reset>
  4. Set expiration (recommended: <SteelBlue>90 days<reset> or <SteelBlue>No expiration<reset>)
  5. Select scopes:
     ✓ <SteelBlue>repo<reset> (Full control of private repositories)
       - Needed to access private module repositories
  6. Click <SteelBlue>"Generate token"<reset> at the bottom
  7. <yellow>IMPORTANT: Copy the token NOW - you won't see it again!<reset>
     Token looks like: <DimGrey>ghp_xxxxxxxxxxxxxxxxxxxx<reset>

<LightSteelBlue>Step 2: Add Token to EMERGE<reset>
  Run: <SteelBlue>emodule token <your_token_here><reset>
  Example: <DimGrey>emodule token ghp_1234567890abcdef<reset>

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
  <SteelBlue>emodule unload <id><reset>      Unload a loaded module
  <SteelBlue>emodule enable <id><reset>      Enable a module for auto-loading
  <SteelBlue>emodule disable <id><reset>     Disable a module
  
<LightSteelBlue>System Management:<reset>
  <SteelBlue>emodule unload manager confirm<reset>  Completely remove EMERGE
  
<LightSteelBlue>GitHub Integration:<reset>]] .. token_status .. [[

  <SteelBlue>emodule github <url><reset>     Add module from GitHub repository
  <SteelBlue>emodule remove <id><reset>      Remove a custom module
  <SteelBlue>emodule token <token><reset>    Set GitHub token for private repos
  
<LightSteelBlue>Update Commands:<reset>
  <SteelBlue>emodule update<reset>           Check all modules for updates
  <SteelBlue>emodule upgrade<reset>          Upgrade EMERGE manager itself
  <SteelBlue>emodule update registry<reset>  Update the module registry
  
<LightSteelBlue>Other Commands:<reset>
  <SteelBlue>emodule config<reset>           Show current configuration
  <SteelBlue>emodule help<reset>             Show this help (or just 'emodule')

<LightSteelBlue>Examples:<reset>
  <DimGrey>Add from GitHub:<reset>
  emodule github rjm11/mudlet-combat-module
  emodule github https://github.com/user/repo
  
  <DimGrey>Manual add:<reset>
  emodule add mymod {"name":"My Module","github":{"owner":"me","repo":"my-mod","file":"mod.lua"}}
  
  <DimGrey>Private repos:<reset>
  emodule token ghp_your_github_personal_access_token

<DimGrey>Configuration saved to: ]] .. self.paths.config .. [[<reset>
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
    cecho("<DimGrey>Example: emodule add mymod {\"name\":\"My Module\",\"github\":{\"owner\":\"me\",\"repo\":\"my-mod\",\"file\":\"mod.lua\"}}<reset>\n")
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
    {delay = 0.2, msg = "<DimGrey>[SYSTEM]<reset> Initializing core framework..."}, 
    {delay = 0.4, msg = "<DimGrey>[SYSTEM]<reset> Loading configuration..."},
    {delay = 0.6, msg = "<DimGrey>[SYSTEM]<reset> Verifying module registry..."},
    {delay = 0.8, msg = "<DimGrey>[SYSTEM]<reset> Establishing event handlers..."},
    {delay = 1.0, msg = "<green>[SYSTEM] Initialization complete<reset>"},
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
    cechoLink("github.com/settings/tokens", [[openUrl("https://github.com/settings/tokens")]], "Click to open GitHub tokens page")
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
  
  -- Schedule bootup sequence (5 seconds after game login)
  tempTimer(5, function()
    if EMERGE and EMERGE.loaded then
      EMERGE:showBootup()
    end
  end)
  
  -- Schedule auto-load after bootup
  tempTimer(8, function()
    if EMERGE and EMERGE.loaded then
      EMERGE:autoLoadModules()
    end
  end)
  
  -- Schedule update check
  if self.config.auto_update then
    tempTimer(35, function()
      if EMERGE and EMERGE.loaded then
        EMERGE.silent_check = true
        EMERGE:checkAllUpdates()
      end
    end)
  end
  
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
  
  -- Don't unload modules if we're just updating the manager
  if not updating then
    for id, module in pairs(self.modules) do
      if module.unload then
        module:unload()
      end
    end
    self.modules = {}
  end
  
  self.loaded = false
end

-- Create persistent loader
function ModuleManager:createPersistentLoader(forceCreate)
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
        killScript("EMERGE Module Bootloader")
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
    local script_id = true  -- Set to true so the following if block still works
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

-- Auto-initialize
ModuleManager:init()

-- Check if we're being loaded from the bootloader or from a fresh install
if not EMERGE_BOOTLOADER_ACTIVE then
  -- Fresh install - set up persistence
  EMERGE.installing = true  -- Set flag to suppress "already loaded" message
  
  local ok, err = pcall(function()
    ModuleManager:createPersistentLoader(false)  -- Don't force - prevent duplicates
  end)
  
  EMERGE.installing = false  -- Clear flag
  
  if not ok then
    cecho("<red>[EMERGE] Auto-install failed: " .. tostring(err) .. "<reset>\n")
    cecho("<yellow>[EMERGE] Type 'emodule install' for manual setup<reset>\n")
  end
else
  -- Clear the bootloader flag
  EMERGE_BOOTLOADER_ACTIVE = nil
end