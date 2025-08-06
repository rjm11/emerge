-- EMERGE: Emergent Modular Engagement & Response Generation Engine
-- Self-updating module system with external configuration
-- Version: 1.1.1

local CURRENT_VERSION = "1.1.1"
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
    cecho("<DarkOrange>[EMERGE] Already loaded.<reset>\n")
    return
  end
end

-- Create EMERGE Manager
EMERGE = EMERGE or {}
EMERGE.version = CURRENT_VERSION
EMERGE.loaded = false
EMERGE.modules = EMERGE.modules or {}
EMERGE.aliases = {}
EMERGE.handlers = {}

-- For backward compatibility
ModuleManager = EMERGE

-- Helper function for clickable links
function ModuleManager:mxpLink(url, text)
  text = text or url
  return string.format([[<send href="%s">%s</send>]], url, text)
end

-- Configuration paths
ModuleManager.paths = {
  config = getMudletHomeDir() .. "/emerge-config.json",
  custom = getMudletHomeDir() .. "/emerge-custom-modules.json",
  cache = getMudletHomeDir() .. "/emerge-cache/"
}

-- Default module registry (can be updated from GitHub)
ModuleManager.default_registry = {
  ["core"] = {
    name = "EMERGE Core",
    description = "Core event system and foundational functionality (REQUIRED)",
    github = {
      owner = "rjm11",
      repo = "emerge",
      file = "core/init.lua"
    },
    enabled = true,
    auto_load = true,
    required = true,
    load_order = 1
  },
  ["gmcp"] = {
    name = "GMCP Handler",
    description = "Generic MUD Communication Protocol handler (HIGHLY RECOMMENDED)",
    github = {
      owner = "rjm11",
      repo = "emerge",
      file = "modules/gmcp.lua"
    },
    enabled = true,
    auto_load = true,
    recommended = true,
    load_order = 2
  },
  ["ai"] = {
    name = "AI Assistant",
    description = "Multi-provider AI integration (Ollama, Groq, OpenAI)",
    github = {
      owner = "rjm11",
      repo = "mudlet-ai-module",
      file = "ai-module.lua"
    },
    enabled = true,
    auto_load = false,
    load_order = 10
  },
  ["combat"] = {
    name = "Combat System",
    description = "Advanced combat automation and tracking",
    github = {
      owner = "rjm11",
      repo = "mudlet-combat-module",
      file = "combat-module.lua"
    },
    enabled = false,
    auto_load = false,
    load_order = 11
  }
  -- More modules can be added here or loaded from GitHub
}

-- GitHub configuration for self-updates
ModuleManager.github = {
  owner = "rjm11",
  repo = "mudlet-emerge-manager",
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
    if exists("EMERGE_Loader", "script") then
      disableScript("EMERGE_Loader")
      -- Note: There's no killScript function, scripts must be removed manually
      cecho("<DarkOrange>[EMERGE] Disabled persistent loader<reset>\n")
      cecho("<LightSteelBlue>To fully remove, delete the EMERGE script group in the Script Editor<reset>\n")
    end
    
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
  if not self.pending_update then
    cecho("<DarkOrange>[EMERGE] No update available<reset>\n")
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
    cecho(string.format("  1. Go to %s\n", self:mxpLink("https://github.com/settings/tokens")))
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
  self.aliases.github = tempAlias("^emodule github (.+)$", [[EMERGE:addGitHub(matches[2])]])
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
end

-- List modules command
function ModuleManager:listModules()
  cecho("<SlateGray>==== EMERGE Module System ====<reset>\n\n")
  
  -- Show loaded modules
  cecho("<LightSteelBlue>Loaded Modules:<reset>\n")
  
  -- Always show the manager itself
  cecho(string.format("  <SteelBlue>manager<reset> v%s - EMERGE Module Manager <DimGrey>(this system)<reset>\n", self.version))
  
  if next(self.modules) then
    for id, module in pairs(self.modules) do
      cecho(string.format("  <SteelBlue>%s<reset> v%s - %s\n", 
        id, module.version or "?", module.name or "Unknown"))
    end
  else
    cecho("  <DimGrey>No additional modules loaded<reset>\n")
  end
  
  cecho("\n<LightSteelBlue>Available Modules:<reset>\n")
  local available = self:getModuleList()
  local has_available = false
  
  -- Separate default and custom modules
  cecho("  <DimGrey>Default:<reset>\n")
  for id, info in pairs(available) do
    if not self.modules[id] and not info.added_by then
      has_available = true
      local status = info.enabled and "<PaleGreen>[enabled]<reset>" or "<IndianRed>[disabled]<reset>"
      local flags = ""
      if info.required then
        flags = " <IndianRed>[REQUIRED]<reset>"
      elseif info.recommended then
        flags = " <LightSteelBlue>[RECOMMENDED]<reset>"
      end
      cecho(string.format("    <SteelBlue>%s<reset> - %s %s%s\n", id, info.name, status, flags))
    end
  end
  
  -- Show custom modules
  local has_custom = false
  for id, info in pairs(available) do
    if not self.modules[id] and info.added_by == "user" then
      if not has_custom then
        cecho("\n  <DimGrey>Custom:<reset>\n")
        has_custom = true
      end
      has_available = true
      local status = info.enabled and "<PaleGreen>[enabled]<reset>" or "<IndianRed>[disabled]<reset>"
      local source = string.format("<DimGrey>(%s/%s)<reset>", info.github.owner, info.github.repo)
      cecho(string.format("    <SteelBlue>%s<reset> - %s %s %s\n", id, info.name, status, source))
    end
  end
  
  if not has_available then
    cecho("  <DimGrey>None available<reset>\n")
  end
  
  cecho("\n<DimGrey>Type 'module help' for commands<reset>\n")
end

-- Show configuration
function ModuleManager:showConfig()
  cecho("<SlateGray>==== Module Manager Configuration ====<reset>\n\n")
  cecho(string.format("Auto-update: %s\n", self.config.auto_update and "<PaleGreen>ON<reset>" or "<IndianRed>OFF<reset>"))
  cecho(string.format("Auto-load modules: %s\n", self.config.auto_load_modules and "<PaleGreen>ON<reset>" or "<IndianRed>OFF<reset>"))
  cecho(string.format("Update interval: %d seconds\n", self.config.update_interval))
  cecho(string.format("Debug mode: %s\n", self.config.debug and "<LightSteelBlue>ON<reset>" or "OFF"))
  cecho(string.format("\nCustom modules: %d\n", table.size(self.custom_modules)))
  cecho(string.format("Config location: %s\n", self.paths.config))
end

-- Show help
function ModuleManager:showHelp()
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
  
<LightSteelBlue>GitHub Integration:<reset>
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
    {delay = 0.2, msg = "<DimGrey>[BOOT]<reset> Initializing EMERGE framework..."}, 
    {delay = 0.4, msg = "<DimGrey>[BOOT]<reset> Loading configuration from " .. self.paths.config:match("/([^/]+)$")},
    {delay = 0.6, msg = "<DimGrey>[BOOT]<reset> Verifying module registry..."},
    {delay = 0.8, msg = "<DimGrey>[BOOT]<reset> Establishing event system..."},
    {delay = 1.0, msg = "<LightSteelBlue>[BOOT] System ready<reset>"},
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
            cecho("\n<DimGrey>Type 'emodule intro' to see the introduction again<reset>\n")
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

-- Check and prompt for core modules
function ModuleManager:checkCoreModules()
  local core_missing = not self.modules["core"]
  local gmcp_missing = not self.modules["gmcp"]
  
  if core_missing or gmcp_missing then
    cecho("<DarkOrange>==== Module Setup Required ====<reset>\n\n")
    
    -- Check if token is set
    if not self.config.github_token then
      cecho("<IndianRed>IMPORTANT: GitHub Token Required<reset>\n")
      cecho("The EMERGE modules are hosted in a private repository.\n")
      cecho("You need a GitHub personal access token to download them.\n\n")
      
      cecho("<LightSteelBlue>Step 1: Create a GitHub Token<reset>\n")
      cecho(string.format("  1. Go to %s\n", self:mxpLink("https://github.com/settings/tokens")))
      cecho("  2. Click 'Generate new token (classic)'\n")
      cecho("  3. Give it a name (e.g., 'Mudlet EMERGE')\n")
      cecho("  4. Select the 'repo' scope\n")
      cecho("  5. Click 'Generate token' and copy it\n\n")
      
      cecho("<LightSteelBlue>Step 2: Set Your Token<reset>\n")
      cecho("  <SteelBlue>emodule token YOUR_TOKEN_HERE<reset>\n\n")
      
      cecho("<LightSteelBlue>Step 3: Load Core Modules<reset>\n")
      cecho("  <SteelBlue>emodule load core<reset> - Required event system\n")
      cecho("  <SteelBlue>emodule load gmcp<reset> - Game data handler\n\n")
      
      cecho(string.format("<DimGrey>Need help? Visit: %s<reset>\n", self:mxpLink("https://github.com/rjm11/emerge/wiki")))
    else
      -- Token is set, show regular missing module messages
      if core_missing then
        cecho("<IndianRed>MISSING: EMERGE Core Module (REQUIRED)<reset>\n")
        cecho("The core module provides the event system that all other modules depend on.\n")
        cecho("<SteelBlue>To install: emodule load core<reset>\n\n")
      end
      
      if gmcp_missing then
        cecho("<LightSteelBlue>MISSING: GMCP Handler Module (Highly Recommended)<reset>\n")
        cecho("GMCP provides vital game data that most modules need to function properly.\n")
        cecho("<SteelBlue>To install: emodule load gmcp<reset>\n\n")
      end
      
      cecho("<DimGrey>After installing core modules, run 'emodule list' to see available modules<reset>\n")
      cecho(string.format("<DimGrey>Visit the wiki for more information: %s<reset>\n", self:mxpLink("https://github.com/rjm11/emerge/wiki")))
    end
  else
    cecho("<LightSteelBlue>✓ Core modules loaded successfully<reset>\n\n")
    cecho("<SteelBlue>Quick Commands:<reset>\n")
    cecho("  emodule list    - See all available modules\n")
    cecho("  emodule help    - View all commands\n")
    cecho("  emodule github  - Add modules from GitHub\n\n")
    cecho(string.format("<DimGrey>Visit the wiki: %s<reset>\n", self:mxpLink("https://github.com/rjm11/emerge/wiki")))
  end
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
function ModuleManager:createPersistentLoader()
  -- Check if we already have a loader script
  if exists("EMERGE_Loader", "script") then
    -- Silently return if it already exists
    return
  end
  
  cecho("<DarkOrange>[EMERGE] Creating persistent loader...<reset>\n")
  
  -- Create a script group first
  local group_id = permScript("EMERGE", "", "")
  cecho("<LightSteelBlue>[EMERGE] Created script group (ID: " .. tostring(group_id) .. ")<reset>\n")
  
  -- Create the loader script inside the group
  local script_id = permScript("EMERGE_Loader", "EMERGE", [[
-- EMERGE Loader
dofile(getMudletHomeDir() .. "/emerge-manager.lua")
]])
  
  cecho("<LightSteelBlue>[EMERGE] Created loader script (ID: " .. tostring(script_id) .. ")<reset>\n")
  
  -- Enable the script
  enableScript("EMERGE_Loader")
  cecho("<LightSteelBlue>[EMERGE] Enabled loader script<reset>\n")
  
  cecho("<LightSteelBlue>[EMERGE] ✓ Persistent loader created successfully<reset>\n")
  cecho("<DimGrey>EMERGE will now load automatically on Mudlet startup<reset>\n")
  
  -- Also save the manager file to Mudlet home
  local current_file = debug.getinfo(1, "S").source:sub(2)
  local target_file = getMudletHomeDir() .. "/emerge-manager.lua"
  
  -- Copy current file to Mudlet home if not already there
  if current_file ~= target_file then
    local f = io.open(current_file, "r")
    if f then
      local content = f:read("*all")
      f:close()
      
      local out = io.open(target_file, "w")
      if out then
        out:write(content)
        out:close()
        cecho("<LightSteelBlue>[EMERGE] Created persistent copy of manager<reset>\n")
      end
    end
  end
end

-- Auto-initialize
ModuleManager:init()

-- Create persistent loader after a short delay to ensure Mudlet is ready
tempTimer(0.5, function()
  if ModuleManager then
    ModuleManager:createPersistentLoader()
  end
end)