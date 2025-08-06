-- EMERGE: Emergent Modular Engagement & Response Generation Engine
-- Self-updating module system with external configuration
-- Version: 1.0.3

local CURRENT_VERSION = "1.0.3"
local MANAGER_ID = "EMERGE"

-- Check if already loaded and handle version updates
if EMERGE and EMERGE.loaded then
  if EMERGE.version ~= CURRENT_VERSION then
    cecho(string.format("<yellow>[EMERGE] Version update: %s -> %s<reset>\n", 
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
    cecho("<yellow>[EMERGE] Already loaded.<reset>\n")
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
  cecho(string.format("<green>[EMERGE] Registered: %s v%s<reset>\n", 
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
  cecho(string.format("<green>[EMERGE] Added custom module: %s<reset>\n", module_id))
end

-- Add module from GitHub URL
function ModuleManager:addGitHub(github_url)
  -- Parse GitHub URL formats:
  -- https://github.com/owner/repo
  -- https://github.com/owner/repo.git
  -- owner/repo
  
  local owner, repo = github_url:match("github%.com/([^/]+)/([^/%.]+)")
  if not owner then
    owner, repo = github_url:match("^([^/]+)/([^/]+)$")
  end
  
  if not owner or not repo then
    cecho("<red>[EMERGE] Invalid GitHub URL format<reset>\n")
    cecho("<yellow>Expected: owner/repo or https://github.com/owner/repo<reset>\n")
    return
  end
  
  -- Clean up repo name (remove .git if present)
  repo = repo:gsub("%.git$", "")
  
  -- Generate module ID from repo name
  local module_id = repo:gsub("^mudlet%-", ""):gsub("%-module$", "")
  
  cecho(string.format("<yellow>[EMERGE] Checking GitHub repository: %s/%s<reset>\n", owner, repo))
  
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
      cecho("<red>[EMERGE] Could not find module file in repository<reset>\n")
      cecho("<yellow>You can manually add it with: module add " .. module_id .. " {json}<reset>\n")
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
            cecho(string.format("<green>[EMERGE] Successfully added module '%s' from %s/%s<reset>\n",
              module_id, owner, repo))
            cecho(string.format("<cyan>Use 'module load %s' to load it<reset>\n", module_id))
            
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
  -- Check if it's a custom module
  if not self.custom_modules[module_id] then
    -- Check if it exists in default registry
    if self.default_registry[module_id] then
      cecho("<red>[EMERGE] Cannot remove default module. You can disable it instead.<reset>\n")
    else
      cecho("<red>[EMERGE] Module not found: " .. module_id .. "<reset>\n")
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
  
  cecho(string.format("<yellow>[EMERGE] Removed module: %s<reset>\n", module_id))
end

-- Enable/disable a module
function ModuleManager:toggleModule(module_id, enabled)
  local modules = self:getModuleList()
  local module = modules[module_id]
  
  if not module then
    cecho("<red>[EMERGE] Module not found: " .. module_id .. "<reset>\n")
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
  
  cecho(string.format("<green>[EMERGE] Module '%s' %s<reset>\n", 
    module_id, enabled and "enabled" or "disabled"))
  
  -- If disabling and currently loaded, unload it
  if not enabled and self.modules[module_id] then
    self:unloadModule(module_id)
  end
end

-- Load a module from GitHub
function ModuleManager:loadModule(module_id)
  local module_info = self:getModuleList()[module_id]
  if not module_info then
    cecho(string.format("<red>[EMERGE] Unknown module: %s<reset>\n", module_id))
    return
  end
  
  if not module_info.github then
    cecho(string.format("<red>[EMERGE] No GitHub info for module: %s<reset>\n", module_id))
    return
  end
  
  local url = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s",
    module_info.github.owner,
    module_info.github.repo,
    module_info.github.branch or "main",
    module_info.github.file)
  
  cecho(string.format("<yellow>[EMERGE] Downloading %s...<reset>\n", module_id))
  
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
      cecho(string.format("<green>[EMERGE] Downloaded %s<reset>\n", module_id))
      
      -- Load the module
      local ok, err = loadfile(filename)
      if ok then
        ok, err = pcall(ok)
        if not ok then
          cecho(string.format("<red>[EMERGE] Failed to load %s: %s<reset>\n", module_id, err))
        end
      else
        cecho(string.format("<red>[EMERGE] Failed to parse %s: %s<reset>\n", module_id, err))
      end
      
      killAnonymousEventHandler(self.handlers.download)
      self.handlers.download = nil
    end
  end)
end

-- Unload a module
function ModuleManager:unloadModule(module_id)
  -- Special handling for unloading the manager itself
  if module_id == "manager" or module_id == "emerge" then
    cecho("<yellow>[EMERGE] Unloading module manager...<reset>\n")
    cecho("<red>WARNING: This will remove EMERGE from Mudlet!<reset>\n")
    cecho("<yellow>To reinstall, use the one-line installer from GitHub<reset>\n")
    
    -- Remove persistent loader
    if exists("EMERGE_Loader", "script") then
      killScript("EMERGE_Loader")
      cecho("<yellow>[EMERGE] Removed persistent loader<reset>\n")
    end
    
    -- Remove saved manager file
    local manager_file = getMudletHomeDir() .. "/emerge-manager.lua"
    if io.exists(manager_file) then
      os.remove(manager_file)
      cecho("<yellow>[EMERGE] Removed saved manager file<reset>\n")
    end
    
    -- Unload self
    tempTimer(0.5, function()
      if EMERGE and EMERGE.unload then
        EMERGE:unload()
      end
      EMERGE = nil
      ModuleManager = nil
      cecho("<red>[EMERGE] Module manager unloaded. Goodbye!<reset>\n")
    end)
    return
  end
  
  local module = self.modules[module_id]
  if module then
    if module.unload then
      module:unload()
    end
    self.modules[module_id] = nil
    cecho(string.format("<yellow>[EMERGE] Unloaded: %s<reset>\n", module_id))
  else
    cecho(string.format("<red>[EMERGE] Module not loaded: %s<reset>\n", module_id))
  end
end

-- Check all modules for updates
function ModuleManager:checkAllUpdates()
  cecho("<yellow>[EMERGE] Checking all modules for updates...<reset>\n")
  
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
          cecho(string.format("<yellow>[EMERGE] Update available: v%s -> v%s<reset>\n",
            self.version, remote_version))
          cecho("<cyan>Run 'module upgrade manager' to update<reset>\n")
          
          self.pending_update = {
            version = remote_version,
            content = content
          }
        elseif remote_version == self.version then
          if not self.silent_check then
            cecho("<green>[EMERGE] You have the latest version<reset>\n")
          end
        end
      end
    end
  end, true) -- one-time handler
end

-- Update ModuleManager
function ModuleManager:upgradeSelf()
  if not self.pending_update then
    cecho("<yellow>[EMERGE] No update available<reset>\n")
    return
  end
  
  local temp_file = getMudletHomeDir() .. "/module-manager-update.lua"
  local file = io.open(temp_file, "w")
  if file then
    file:write(self.pending_update.content)
    file:close()
    
    cecho(string.format("<yellow>[EMERGE] Upgrading to v%s...<reset>\n", 
      self.pending_update.version))
    
    -- Load the new version
    local ok, err = loadfile(temp_file)
    if ok then
      ok, err = pcall(ok)
      if ok then
        cecho("<green>[EMERGE] Upgrade successful!<reset>\n")
        os.remove(temp_file)
      else
        cecho(string.format("<red>[EMERGE] Upgrade failed: %s<reset>\n", err))
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
          cecho("<green>[EMERGE] Module registry updated<reset>\n")
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
    cecho("<red>[EMERGE] Invalid token<reset>\n")
    return
  end
  
  self.config.github_token = token
  self:saveConfig()
  
  cecho("<green>[EMERGE] GitHub token saved<reset>\n")
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
  self.aliases.unload = tempAlias("^emodule unload (.+)$", [[EMERGE:unloadModule(matches[2])]])
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
  self.aliases.intro = tempAlias("^emodule intro$", [[EMERGE:showIntroduction()]])
  self.aliases.help = tempAlias("^emodule help$", [[EMERGE:showHelp()]])
  self.aliases.help_short = tempAlias("^emodule$", [[EMERGE:showHelp()]])
end

-- List modules command
function ModuleManager:listModules()
  cecho("<green>==== EMERGE Module System ====<reset>\n\n")
  
  -- Show loaded modules
  cecho("<yellow>Loaded Modules:<reset>\n")
  if next(self.modules) then
    for id, module in pairs(self.modules) do
      cecho(string.format("  <cyan>%s<reset> v%s - %s\n", 
        id, module.version or "?", module.name or "Unknown"))
    end
  else
    cecho("  <DimGrey>None<reset>\n")
  end
  
  cecho("\n<yellow>Available Modules:<reset>\n")
  local available = self:getModuleList()
  local has_available = false
  
  -- Separate default and custom modules
  cecho("  <DimGrey>Default:<reset>\n")
  for id, info in pairs(available) do
    if not self.modules[id] and not info.added_by then
      has_available = true
      local status = info.enabled and "<green>[enabled]<reset>" or "<red>[disabled]<reset>"
      local flags = ""
      if info.required then
        flags = " <red>[REQUIRED]<reset>"
      elseif info.recommended then
        flags = " <yellow>[RECOMMENDED]<reset>"
      end
      cecho(string.format("    <cyan>%s<reset> - %s %s%s\n", id, info.name, status, flags))
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
      local status = info.enabled and "<green>[enabled]<reset>" or "<red>[disabled]<reset>"
      local source = string.format("<DimGrey>(%s/%s)<reset>", info.github.owner, info.github.repo)
      cecho(string.format("    <cyan>%s<reset> - %s %s %s\n", id, info.name, status, source))
    end
  end
  
  if not has_available then
    cecho("  <DimGrey>None available<reset>\n")
  end
  
  cecho("\n<DimGrey>Type 'module help' for commands<reset>\n")
end

-- Show configuration
function ModuleManager:showConfig()
  cecho("<green>==== Module Manager Configuration ====<reset>\n\n")
  cecho(string.format("Auto-update: %s\n", self.config.auto_update and "<green>ON<reset>" or "<red>OFF<reset>"))
  cecho(string.format("Auto-load modules: %s\n", self.config.auto_load_modules and "<green>ON<reset>" or "<red>OFF<reset>"))
  cecho(string.format("Update interval: %d seconds\n", self.config.update_interval))
  cecho(string.format("Debug mode: %s\n", self.config.debug and "<yellow>ON<reset>" or "OFF"))
  cecho(string.format("\nCustom modules: %d\n", table.size(self.custom_modules)))
  cecho(string.format("Config location: %s\n", self.paths.config))
end

-- Show help
function ModuleManager:showHelp()
  cecho([[
<green>==== EMERGE Module System ====<reset>
<DimGrey>Emergent Modular Engagement & Response Generation Engine<reset>

<yellow>Core Commands:<reset>
  <cyan>emodule list<reset>             List all modules (loaded & available)
  <cyan>emodule load <id><reset>        Download and load a module
  <cyan>emodule unload <id><reset>      Unload a loaded module
  <cyan>emodule enable <id><reset>      Enable a module for auto-loading
  <cyan>emodule disable <id><reset>     Disable a module
  
<yellow>GitHub Integration:<reset>
  <cyan>emodule github <url><reset>     Add module from GitHub repository
  <cyan>emodule remove <id><reset>      Remove a custom module
  <cyan>emodule token <token><reset>    Set GitHub token for private repos
  
<yellow>Update Commands:<reset>
  <cyan>emodule update<reset>           Check all modules for updates
  <cyan>emodule upgrade<reset>          Upgrade EMERGE manager itself
  <cyan>emodule update registry<reset>  Update the module registry
  
<yellow>Other Commands:<reset>
  <cyan>emodule config<reset>           Show current configuration
  <cyan>emodule help<reset>             Show this help (or just 'emodule')

<yellow>Examples:<reset>
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
  local ok, module_info = pcall(yajl.to_value, json_str)
  if ok and module_info then
    self:addModule(id, module_info)
  else
    cecho("<red>[EMERGE] Invalid JSON format<reset>\n")
  end
end

-- Show bootup sequence
function ModuleManager:showBootup()
  -- Clear some space
  echo("\n\n")
  
  -- EMERGE ASCII art
  cecho([[<green>
    ███████╗███╗   ███╗███████╗██████╗  ██████╗ ███████╗
    ██╔════╝████╗ ████║██╔════╝██╔══██╗██╔════╝ ██╔════╝
    █████╗  ██╔████╔██║█████╗  ██████╔╝██║  ███╗█████╗  
    ██╔══╝  ██║╚██╔╝██║██╔══╝  ██╔══██╗██║   ██║██╔══╝  
    ███████╗██║ ╚═╝ ██║███████╗██║  ██║╚██████╔╝███████╗
    ╚══════╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝<reset>
]])
  
  cecho("<yellow>    Emergent Modular Engagement & Response Generation Engine<reset>\n")
  cecho(string.format("<DimGrey>    Version %s | Event-Driven Architecture<reset>\n\n", self.version))
  
  -- Bootup sequence
  local steps = {
    {delay = 0.2, msg = "<DimGrey>[BOOT]<reset> Initializing EMERGE framework..."}, 
    {delay = 0.4, msg = "<DimGrey>[BOOT]<reset> Loading configuration from " .. self.paths.config:match("/([^/]+)$")},
    {delay = 0.6, msg = "<DimGrey>[BOOT]<reset> Verifying module registry..."},
    {delay = 0.8, msg = "<DimGrey>[BOOT]<reset> Establishing event system..."},
    {delay = 1.0, msg = "<green>[BOOT] System ready<reset>"},
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
  cecho([[

<green>==== Welcome to EMERGE ====<reset>

EMERGE is a revolutionary module system for Mudlet that follows these principles:

<yellow>1. Event-Driven Architecture<reset>
   Modules communicate through events, not direct calls
   This ensures modules remain independent and flexible

<yellow>2. Modular Design<reset>
   Each module provides specific functionality
   Load only what you need for your playstyle

<yellow>3. Easy Management<reset>
   GitHub integration for simple module installation
   Automatic updates keep your system current

<cyan>Getting Started:<reset>
]])
  
  tempTimer(2, function()
    cecho([[
<yellow>STEP 1: Check Core Modules<reset>
The system will now check for required modules...

]])
    self:checkCoreModules()
    
    -- Mark first run as complete
    self.config.first_run = false
    self:saveConfig()
  end)
end

-- Check and prompt for core modules
function ModuleManager:checkCoreModules()
  local core_missing = not self.modules["core"]
  local gmcp_missing = not self.modules["gmcp"]
  
  if core_missing or gmcp_missing then
    cecho("<yellow>==== Module Setup Required ====<reset>\n\n")
    
    -- Check if token is set
    if not self.config.github_token then
      cecho("<red>IMPORTANT: GitHub Token Required<reset>\n")
      cecho("The EMERGE modules are hosted in a private repository.\n")
      cecho("You need a GitHub personal access token to download them.\n\n")
      
      cecho("<yellow>Step 1: Create a GitHub Token<reset>\n")
      cecho("  1. Go to https://github.com/settings/tokens\n")
      cecho("  2. Click 'Generate new token (classic)'\n")
      cecho("  3. Give it a name (e.g., 'Mudlet EMERGE')\n")
      cecho("  4. Select the 'repo' scope\n")
      cecho("  5. Click 'Generate token' and copy it\n\n")
      
      cecho("<yellow>Step 2: Set Your Token<reset>\n")
      cecho("  <cyan>emodule token YOUR_TOKEN_HERE<reset>\n\n")
      
      cecho("<yellow>Step 3: Load Core Modules<reset>\n")
      cecho("  <cyan>emodule load core<reset> - Required event system\n")
      cecho("  <cyan>emodule load gmcp<reset> - Game data handler\n\n")
      
      cecho("<DimGrey>Need help? Visit: https://github.com/rjm11/emerge/wiki<reset>\n")
    else
      -- Token is set, show regular missing module messages
      if core_missing then
        cecho("<red>MISSING: EMERGE Core Module (REQUIRED)<reset>\n")
        cecho("The core module provides the event system that all other modules depend on.\n")
        cecho("<cyan>To install: emodule load core<reset>\n\n")
      end
      
      if gmcp_missing then
        cecho("<yellow>MISSING: GMCP Handler Module (Highly Recommended)<reset>\n")
        cecho("GMCP provides vital game data that most modules need to function properly.\n")
        cecho("<cyan>To install: emodule load gmcp<reset>\n\n")
      end
      
      cecho("<DimGrey>After installing core modules, run 'emodule list' to see available modules<reset>\n")
      cecho("<DimGrey>Visit the wiki for more information: https://github.com/rjm11/emerge/wiki<reset>\n")
    end
  else
    cecho("<green>✓ Core modules loaded successfully<reset>\n\n")
    cecho("<cyan>Quick Commands:<reset>\n")
    cecho("  emodule list    - See all available modules\n")
    cecho("  emodule help    - View all commands\n")
    cecho("  emodule github  - Add modules from GitHub\n\n")
    cecho("<DimGrey>Visit the wiki: https://github.com/rjm11/emerge/wiki<reset>\n")
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
    return
  end
  
  -- Create a simple loader script
  permScript("EMERGE_Loader", "EMERGE Module Loader", [[
-- EMERGE Persistent Loader
-- This script ensures EMERGE loads on every Mudlet startup

local emerge_file = getMudletHomeDir() .. "/emerge-manager.lua"
if io.exists(emerge_file) then
  dofile(emerge_file)
else
  cecho("<yellow>[EMERGE] Manager file not found. Please reinstall EMERGE.<reset>\n")
end
]])
  
  enableScript("EMERGE_Loader")
  
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
        cecho("<green>[EMERGE] Created persistent copy of manager<reset>\n")
      end
    end
  end
end

-- Auto-initialize
ModuleManager:init()
ModuleManager:createPersistentLoader()