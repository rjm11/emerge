-- EMERGE: Emergent Modular Engagement & Response Generation Engine (Codex edition)
-- Mudlet module manager with improved private GitHub handling and small fixes
-- Version: 0.5.8-codex

local CURRENT_VERSION = "0.5.8-codex"
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
    if not (EMERGE.installing or EMERGE.creating_bootloader) then
      cecho("<DarkOrange>[EMERGE] Already loaded.<reset>\n")
    end
    return
  end
end

-- Create EMERGE Manager
EMERGE = EMERGE or {}
EMERGE.version = CURRENT_VERSION
if not EMERGE.loaded then EMERGE.loaded = false end
EMERGE.modules = EMERGE.modules or {}
EMERGE.aliases = {}
EMERGE.handlers = {}

-- For backward compatibility
ModuleManager = EMERGE

-- Utility function for counting table entries
if not table.size then
  function table.size(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
  end
end

-- Provide a deepcopy polyfill (Mudlet does not ship one by default)
if not table.deepcopy then
  function table.deepcopy(src, seen)
    if type(src) ~= "table" then return src end
    seen = seen or {}
    if seen[src] then return seen[src] end
    local dst = {}
    seen[src] = dst
    for k, v in pairs(src) do
      dst[table.deepcopy(k, seen)] = table.deepcopy(v, seen)
    end
    local mt = getmetatable(src)
    if mt then setmetatable(dst, mt) end
    return dst
  end
end

-- Configuration paths
ModuleManager.paths = {
  config = getMudletHomeDir() .. "/emerge-config.json",
  custom = getMudletHomeDir() .. "/emerge-custom-modules.json",
  cache = getMudletHomeDir() .. "/emerge-cache/"
}

-- Default module registry - empty until modules are actually created
ModuleManager.default_registry = {}

-- Multi-repository configuration (example defaults)
ModuleManager.repositories = {
  {
    name = "emerge-public",
    owner = "rjm11",
    repo = "emerge",
    branch = "main",
    public = true,
    description = "Public manager and core modules"
  },
  {
    name = "emerge-private",
    owner = "rjm11",
    repo = "emerge-private",
    branch = "main",
    public = false,
    description = "Private combat modules"
  },
}

-- GitHub configuration for self-updates (backward compatibility)
ModuleManager.github = {
  owner = "rjm11",
  repo = "emerge",
  branch = "main",
  files = {
    manager = "emerge-manager.lua",
  },
  public = true,
  last_check = 0
}

-- Discovery cache
ModuleManager.discovery_cache = {
  last_refresh = 0,
  cache_duration = 3600, -- 1 hour
  manifests = {},
  modules = {}
}

-- Internal helpers
function ModuleManager:_hasToken()
  return self.config and self.config.github_token and self.config.github_token ~= ""
end

-- Find repo config from info.github or info.repository
function ModuleManager:_findRepoConfig(info)
  if not info then return nil end
  local owner, repo, repoName
  if info.repository then repoName = info.repository end
  if info.github then owner, repo = info.github.owner, info.github.repo end

  for _, rc in ipairs(self.repositories) do
    if repoName and rc.name == repoName then return rc end
    if owner and repo and rc.owner == owner and rc.repo == repo then return rc end
  end
  return nil
end

-- Build a URL + headers to fetch raw file contents from GitHub.
-- Uses raw.githubusercontent for public; GitHub API + Accept: raw for private.
function ModuleManager:_buildGitHubRaw(owner, repo, branch, path, isPublic)
  local headers = {}
  if not isPublic and self:_hasToken() then
    headers["Authorization"] = "token " .. self.config.github_token
    headers["Accept"] = "application/vnd.github.v3.raw"
    local url = string.format("https://api.github.com/repos/%s/%s/contents/%s?ref=%s",
      owner, repo, path, branch or "main")
    return url, headers
  else
    -- public fallback
    local url = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s",
      owner, repo, branch or "main", path)
    return url, headers
  end
end

-- Load configuration from file
function ModuleManager:loadConfig()
  if not io.exists(self.paths.cache) then lfs.mkdir(self.paths.cache) end

  if io.exists(self.paths.config) then
    local f = io.open(self.paths.config, "r")
    if f then
      local content = f:read("*all"); f:close()
      local ok, cfg = pcall(yajl.to_value, content)
      if ok and cfg then self.config = cfg end
    end
  else
    self.config = {
      auto_update = true,
      update_interval = 3600,
      auto_load_modules = true,
      debug = false
    }
    self:saveConfig()
  end

  if io.exists(self.paths.custom) then
    local f = io.open(self.paths.custom, "r")
    if f then
      local content = f:read("*all"); f:close()
      local ok, custom = pcall(yajl.to_value, content)
      if ok and custom then self.custom_modules = custom end
    end
  else
    self.custom_modules = {}
  end
end

function ModuleManager:saveConfig()
  local f = io.open(self.paths.config, "w")
  if f then f:write(yajl.to_string(self.config)); f:close() end
end

function ModuleManager:saveCustomModules()
  local f = io.open(self.paths.custom, "w")
  if f then f:write(yajl.to_string(self.custom_modules)); f:close() end
end

-- Get complete module list (default + discovered + custom)
function ModuleManager:getModuleList()
  local all = {}
  for id, m in pairs(self.default_registry) do all[id] = table.deepcopy(m) end
  for id, m in pairs(self.discovery_cache.modules) do if not all[id] then all[id] = table.deepcopy(m) end end
  for id, m in pairs(self.custom_modules) do all[id] = table.deepcopy(m) end
  return all
end

-- Register/unregister loaded module
function ModuleManager:register(module_id, module_table)
  self.modules[module_id] = module_table
  cecho(string.format("<LightSteelBlue>[EMERGE] Registered: %s v%s<reset>\n", module_id, module_table.version or "unknown"))
end
function ModuleManager:unregister(module_id) self.modules[module_id] = nil end

-- Add module from GitHub URL (fix Accept header to JSON for API probing)
function ModuleManager:addGitHub(github_url)
  if not github_url or github_url == "" then
    cecho("<IndianRed>[EMERGE] Usage: emodule github <owner/repo or github.com/owner/repo><reset>\n")
    return
  end

  local owner, repo = github_url:match("github%.com/([^/]+)/([^/%.]+)")
  if not owner then owner, repo = github_url:match("^([^/]+)/([^/]+)$") end
  if not owner or not repo then
    cecho("<IndianRed>[EMERGE] Invalid GitHub URL format<reset>\n")
    cecho("<LightSteelBlue>Expected: owner/repo or https://github.com/owner/repo<reset>\n")
    return
  end
  repo = repo:gsub("%.git$", "")

  local module_id = repo:gsub("^mudlet%-", ""):gsub("%-module$", "")
  cecho(string.format("<DarkOrange>[EMERGE] Checking GitHub repository: %s/%s<reset>\n", owner, repo))

  local possible_files = {
    module_id .. "-module.lua",
    module_id .. ".lua",
    "module.lua",
    repo .. ".lua",
    "init.lua",
    "main.lua",
  }

  local idx = 1
  local function try_next()
    if idx > #possible_files then
      cecho("<IndianRed>[EMERGE] Could not find module file in repository<reset>\n")
      cecho("<LightSteelBlue>You can manually add it with: emodule add " .. module_id .. " {json}<reset>\n")
      return
    end

    local file = possible_files[idx]
    local check_url = string.format("https://api.github.com/repos/%s/%s/contents/%s", owner, repo, file)

    local headers = { ["Accept"] = "application/vnd.github.v3+json" }
    if self:_hasToken() then headers["Authorization"] = "token " .. self.config.github_token end

    local out = self.paths.cache .. "github-check.json"
    downloadFile(out, check_url, headers)

    registerAnonymousEventHandler("sysDownloadDone", function(_, filename)
      if filename == out then
        local f = io.open(filename, "r")
        if f then
          local content = f:read("*all"); f:close(); os.remove(filename)
          local ok, data = pcall(yajl.to_value, content)
          if ok and type(data) == "table" and data.name and (data.download_url or data.sha) then
            -- File exists
            local module_info = {
              name = repo:gsub("%-", " "):gsub("^%l", string.upper),
              description = string.format("Module from %s/%s", owner, repo),
              github = { owner = owner, repo = repo, file = file },
              enabled = true, auto_load = false,
              added_by = "user", added_date = os.date("%Y-%m-%d %H:%M:%S")
            }
            self:addModule(module_id, module_info)
            cecho(string.format("<LightSteelBlue>[EMERGE] Successfully added module '%s' from %s/%s<reset>\n", module_id, owner, repo))
            cecho(string.format("<SteelBlue>Use 'emodule load %s' to load it<reset>\n", module_id))
          else
            idx = idx + 1
            tempTimer(0.1, try_next)
          end
        end
      end
    end, true)
  end

  try_next()
end

-- Remove/enable/disable modules
function ModuleManager:removeModule(module_id)
  if not module_id or module_id == "" then
    cecho("<IndianRed>[EMERGE] Usage: emodule remove <module_id><reset>\n"); return
  end
  if not self.custom_modules[module_id] then
    if self.default_registry[module_id] then
      cecho("<IndianRed>[EMERGE] Cannot remove default module. You can disable it instead.<reset>\n")
    else
      cecho("<IndianRed>[EMERGE] Module not found: " .. module_id .. "<reset>\n")
    end
    return
  end
  if self.modules[module_id] then self:unloadModule(module_id) end
  self.custom_modules[module_id] = nil; self:saveCustomModules()
  local cache_file = self.paths.cache .. module_id .. ".lua"; if io.exists(cache_file) then os.remove(cache_file) end
  cecho(string.format("<DarkOrange>[EMERGE] Removed module: %s<reset>\n", module_id))
end

function ModuleManager:toggleModule(module_id, enabled)
  if not module_id or module_id == "" then
    local cmd = enabled and "enable" or "disable"
    cecho(string.format("<IndianRed>[EMERGE] Usage: emodule %s <module_id><reset>\n", cmd)); return
  end
  local modules = self:getModuleList(); local module = modules[module_id]
  if not module then cecho("<IndianRed>[EMERGE] Module not found: " .. module_id .. "<reset>\n"); return end

  if self.custom_modules[module_id] then
    self.custom_modules[module_id].enabled = enabled; self:saveCustomModules()
  elseif self.default_registry[module_id] then
    if not self.custom_modules[module_id] then
      self.custom_modules[module_id] = table.deepcopy(self.default_registry[module_id])
    end
    self.custom_modules[module_id].enabled = enabled; self:saveCustomModules()
  end

  cecho(string.format("<LightSteelBlue>[EMERGE] Module '%s' %s<reset>\n", module_id, enabled and "enabled" or "disabled"))
  if not enabled and self.modules[module_id] then self:unloadModule(module_id) end
end

-- Load a module from GitHub (uses API raw for private repos)
function ModuleManager:loadModule(module_id)
  if not module_id or module_id == "" then cecho("<IndianRed>[EMERGE] Usage: emodule load <module_id><reset>\n"); return end
  local info = self:getModuleList()[module_id]
  if not info then
    cecho(string.format("<IndianRed>[EMERGE] Unknown module: %s<reset>\n", module_id))
    cecho("<DimGrey>Try 'emodule list' or 'emodule refresh'<reset>\n"); return
  end
  if not info.github then cecho(string.format("<IndianRed>[EMERGE] No GitHub info for module: %s<reset>\n", module_id)); return end

  local path = info.manifest_path or info.github.file
  if not path then cecho("<IndianRed>[EMERGE] Module has no file path specified<reset>\n"); return end

  local rc = self:_findRepoConfig({ repository = info.repository, github = info.github })
  local isPublic = rc and rc.public or true
  local url, headers = self:_buildGitHubRaw(info.github.owner, info.github.repo, info.github.branch or "main", path, isPublic)

  cecho(string.format("<DarkOrange>[EMERGE] Downloading %s...<reset>\n", module_id))
  downloadFile(self.paths.cache .. module_id .. ".lua", url, headers)

  if self.handlers.download then killAnonymousEventHandler(self.handlers.download) end
  self.handlers.download = registerAnonymousEventHandler("sysDownloadDone", function(_, filename)
    if filename:find(module_id .. "%.lua$") then
      cecho(string.format("<LightSteelBlue>[EMERGE] Downloaded %s<reset>\n", module_id))
      local ok, chunk = pcall(loadfile, filename)
      if ok and chunk then
        local ok2, err = pcall(chunk)
        if not ok2 then cecho(string.format("<IndianRed>[EMERGE] Failed to load %s: %s<reset>\n", module_id, err)) end
      else
        cecho(string.format("<IndianRed>[EMERGE] Failed to parse %s: %s<reset>\n", module_id, tostring(chunk)))
      end
      killAnonymousEventHandler(self.handlers.download); self.handlers.download = nil
    end
  end)
end

-- Unload a module (manager self-unload unchanged)
function ModuleManager:unloadModule(module_id, confirm)
  if not module_id or module_id == "" then
    cecho("<IndianRed>[EMERGE] Usage: emodule unload <module_id><reset>\n")
    cecho("<DimGrey>To unload EMERGE itself: emodule unload manager confirm<reset>\n"); return
  end
  if module_id == "manager" or module_id == "emerge" then
    if confirm ~= "confirm" then
      cecho("<IndianRed>WARNING: This will completely remove EMERGE from Mudlet!<reset>\n")
      cecho("<DarkOrange>You will need to reinstall using the one-line installer.<reset>\n")
      cecho("<LightSteelBlue>To confirm, type: emodule unload manager confirm<reset>\n"); return
    end
    cecho("<DarkOrange>[EMERGE] Unloading module manager...<reset>\n")
    if exists("EMERGE Module Bootloader", "script") then
      disableScript("EMERGE Module Bootloader"); killScript("EMERGE Module Bootloader")
      cecho("<DarkOrange>[EMERGE] Removed persistent bootloader<reset>\n")
    end
    if exists("EMERGE", "script") then killScript("EMERGE"); cecho("<DarkOrange>[EMERGE] Removed EMERGE script group<reset>\n") end
    saveProfile(); cecho("<DarkOrange>[EMERGE] Profile saved - removal is permanent<reset>\n")
    local manager_file = getMudletHomeDir() .. "/emerge-manager.lua"; if io.exists(manager_file) then os.remove(manager_file); cecho("<DarkOrange>[EMERGE] Removed saved manager file<reset>\n") end
    local dl_file = getMudletHomeDir() .. "/emerge-dl.lua"; if io.exists(dl_file) then os.remove(dl_file); cecho("<DarkOrange>[EMERGE] Removed download file<reset>\n") end
    tempTimer(0.5, function()
      if EMERGE and EMERGE.unload then EMERGE:unload() end
      EMERGE = nil; ModuleManager = nil
      cecho("<IndianRed>[EMERGE] Module manager unloaded. Goodbye!<reset>\n")
    end)
    return
  end
  local module = self.modules[module_id]
  if module then
    if module.unload then module:unload() end
    self.modules[module_id] = nil
    cecho(string.format("<DarkOrange>[EMERGE] Unloaded: %s<reset>\n", module_id))
  else
    cecho(string.format("<IndianRed>[EMERGE] Module not loaded: %s<reset>\n", module_id))
  end
end

-- Update checks (self + modules)
function ModuleManager:checkAllUpdates()
  cecho("<DarkOrange>[EMERGE] Checking all modules for updates...<reset>\n")
  self:refreshCache(false)
  self:checkSelfUpdate()
  tempTimer(2, function()
    local updates = self:checkForUpdates()
    if #updates > 0 then
      cecho(string.format("\n<yellow>[EMERGE] %d module update(s) available:<reset>\n", #updates))
      for _, u in ipairs(updates) do
        cecho(string.format("  <SteelBlue>%s<reset>: v%s → v%s (%s)\n", u.id, u.current, u.available, u.repository))
      end
      cecho("\n<DimGrey>Use 'emodule load <module>' to update individual modules<reset>\n")
    else
      cecho("<LightSteelBlue>[EMERGE] All modules are up to date<reset>\n")
    end
    for id, m in pairs(self.modules) do if m.checkForUpdates then m:checkForUpdates(true) end end
  end)
end

-- Self update using raw builder (public by default)
function ModuleManager:checkSelfUpdate()
  local url, headers = self:_buildGitHubRaw(self.github.owner, self.github.repo, self.github.branch, self.github.files.manager, self.github.public ~= false)
  local out = self.paths.cache .. "module-manager-check.lua"
  downloadFile(out, url, headers)
  registerAnonymousEventHandler("sysDownloadDone", function(_, filename)
    if filename == out then
      local f = io.open(filename, "r"); if not f then return end
      local content = f:read("*all"); f:close()
      local remote_version = content:match('local CURRENT_VERSION = "([^"]+)"') or content:match('CURRENT_VERSION = "([^"]+)"') or content:match('version = "([^"]+)"')
      if remote_version and remote_version ~= self.version then
        cecho(string.format("<DarkOrange>[EMERGE] Update available: v%s -> v%s<reset>\n", self.version, remote_version))
        cecho("<SteelBlue>Run 'emodule upgrade' to update<reset>\n")
        self.pending_update = { version = remote_version, content = content }
      elseif remote_version == self.version then
        if not self.silent_check then cecho("<LightSteelBlue>[EMERGE] You have the latest version<reset>\n") end
      end
      os.remove(filename)
    end
  end, true)
end

function ModuleManager:upgradeSelf()
  if not self.pending_update then
    cecho("<DimGrey>[EMERGE] Checking for updates...<reset>\n")
    local url, headers = self:_buildGitHubRaw(self.github.owner, self.github.repo, self.github.branch, self.github.files.manager, self.github.public ~= false)
    local check_file = self.paths.cache .. "manager-update-check.lua"
    local downloadHandler, errorHandler, timeoutHandler
    timeoutHandler = tempTimer(10, function()
      cecho("<IndianRed>[EMERGE] Update check timed out. Please try again.<reset>\n")
      if downloadHandler then killAnonymousEventHandler(downloadHandler) end
      if errorHandler then killAnonymousEventHandler(errorHandler) end
    end)
    downloadHandler = registerAnonymousEventHandler("sysDownloadDone", function(_, filename)
      if filename == check_file then
        if timeoutHandler then killTimer(timeoutHandler) end
        if errorHandler then killAnonymousEventHandler(errorHandler) end
        local f = io.open(filename, "r")
        if f then
          local content = f:read("*all"); f:close(); os.remove(filename)
          local remote = content:match('local CURRENT_VERSION = "([^"]+)"') or content:match('CURRENT_VERSION = "([^"]+)"') or content:match('version = "([^"]+)"')
          if remote then
            cecho(string.format("<DimGrey>[EMERGE] Current version: v%s | Remote version: v%s<reset>\n", self.version, remote))
            if remote ~= self.version then
              cecho(string.format("<DarkOrange>[EMERGE] Update available: v%s -> v%s<reset>\n", self.version, remote))
              self.pending_update = { version = remote, content = content }
              self:doUpgrade()
            else
              cecho("<LightSteelBlue>[EMERGE] You already have the latest version<reset>\n")
            end
          else
            cecho("<IndianRed>[EMERGE] Could not determine remote version from downloaded file<reset>\n")
          end
        end
      end
    end, true)
    errorHandler = registerAnonymousEventHandler("sysDownloadError", function(_, filename, msg)
      if filename == check_file then
        if timeoutHandler then killTimer(timeoutHandler) end
        if downloadHandler then killAnonymousEventHandler(downloadHandler) end
        cecho("<IndianRed>[EMERGE] Failed to download update: " .. (msg or "unknown error") .. "<reset>\n")
      end
    end, true)
    downloadFile(check_file, url, headers)
    return
  end
  self:doUpgrade()
end

function ModuleManager:doUpgrade()
  if not self.pending_update then return end
  local temp_file = getMudletHomeDir() .. "/module-manager-update.lua"
  local f = io.open(temp_file, "w")
  if f then f:write(self.pending_update.content); f:close() end
  cecho(string.format("<DarkOrange>[EMERGE] Upgrading to v%s...<reset>\n", self.pending_update.version))
  local ok, chunk = pcall(loadfile, temp_file)
  if ok and chunk then
    local ok2, err = pcall(chunk)
    if ok2 then
      cecho("<LightSteelBlue>[EMERGE] Upgrade successful!<reset>\n")
      os.remove(temp_file); self.pending_update = nil
    else
      cecho(string.format("<IndianRed>[EMERGE] Upgrade failed: %s<reset>\n", err))
    end
  end
end

-- Discover repositories and cache modules; uses API raw for private repos
function ModuleManager:discoverRepositories()
  local pending, completed = 0, 0
  local discovered = {}
  cecho("<DarkOrange>[EMERGE] Discovering modules from repositories...<reset>\n")
  for _, rc in ipairs(self.repositories) do
    pending = pending + 1
    self:downloadManifest(rc, function(success, modules)
      completed = completed + 1
      if success and modules then
        for id, mi in pairs(modules) do
          mi.repository = rc.name
          mi.github = mi.github or { owner = rc.owner, repo = rc.repo, branch = rc.branch }
          discovered[id] = mi
        end
        cecho(string.format("<DimGrey>[EMERGE] Found %d modules in %s<reset>\n", table.size(modules), rc.name))
      else
        cecho(string.format("<yellow>[EMERGE] Could not access %s repository<reset>\n", rc.name))
      end
      if completed >= pending then
        self.discovery_cache.modules = discovered
        self.discovery_cache.last_refresh = os.time()
        cecho(string.format("<LightSteelBlue>[EMERGE] Discovery complete: %d modules available<reset>\n", table.size(discovered)))
      end
    end)
  end
  tempTimer(15, function()
    if completed < pending then cecho("<yellow>[EMERGE] Some repositories timed out<reset>\n") end
  end)
end

-- Download manifest from a repository (private via API; public via raw)
function ModuleManager:downloadManifest(rc, callback)
  local path = "manifest.json"
  local url, headers = self:_buildGitHubRaw(rc.owner, rc.repo, rc.branch, path, rc.public)
  local out = self.paths.cache .. "manifest-" .. rc.name .. ".json"
  downloadFile(out, url, headers)

  local d = registerAnonymousEventHandler("sysDownloadDone", function(_, filename)
    if filename == out then
      killAnonymousEventHandler(d)
      local f = io.open(filename, "r")
      if not f then callback(false, nil); return end
      local content = f:read("*all"); f:close(); os.remove(filename)
      local ok, manifest = pcall(yajl.to_value, content)
      if ok and manifest and manifest.modules then
        self.discovery_cache.manifests[rc.name] = manifest
        callback(true, manifest.modules)
      else
        callback(false, nil)
      end
    end
  end)
  local e = registerAnonymousEventHandler("sysDownloadError", function(_, filename)
    if filename == out then
      killAnonymousEventHandler(d); killAnonymousEventHandler(e)
      callback(false, nil)
    end
  end)
end

-- Cache freshness
function ModuleManager:getCachedModules() return self.discovery_cache.modules end
function ModuleManager:refreshCache(force)
  local age = os.time() - self.discovery_cache.last_refresh
  if force or age > self.discovery_cache.cache_duration then
    self:discoverRepositories()
  else
    local remaining = self.discovery_cache.cache_duration - age
    cecho(string.format("<DimGrey>[EMERGE] Cache is fresh (expires in %d minutes)<reset>\n", math.ceil(remaining/60)))
  end
end

-- Version utils
function ModuleManager:parseVersion(s)
  if not s then return {major=0,minor=0,patch=0} end
  local M,m,p = s:match("(%d+)%.(%d+)%.(%d+)")
  if not M then M,m,p = s:match("(%d+)%.(%d+)"), nil, nil end
  return { major = tonumber(M) or 0, minor = tonumber(m) or 0, patch = tonumber(p) or 0 }
end
function ModuleManager:compareVersions(v1, v2)
  local a,b = self:parseVersion(v1), self:parseVersion(v2)
  if a.major ~= b.major then return a.major > b.major and 1 or -1 end
  if a.minor ~= b.minor then return a.minor > b.minor and 1 or -1 end
  if a.patch ~= b.patch then return a.patch > b.patch and 1 or -1 end
  return 0
end

-- Update detection for loaded modules
function ModuleManager:checkForUpdates()
  local updates = {}
  for id, loaded in pairs(self.modules) do
    local available = self.discovery_cache.modules[id]
    if available and available.version and loaded.version then
      if self:compareVersions(available.version, loaded.version) > 0 then
        table.insert(updates, { id=id, current=loaded.version, available=available.version, repository=available.repository })
      end
    end
  end
  return updates
end

-- Aliases and CLI
function ModuleManager:createAliases()
  for _, id in pairs(self.aliases) do if exists(id, "alias") then killAlias(id) end end
  self.aliases = {}
  self.aliases.list = tempAlias("^emodule list$", [[EMERGE:listModules()]])
  self.aliases.load = tempAlias("^emodule load (.+)$", [[EMERGE:loadModule(matches[2])]])
  self.aliases.unload = tempAlias("^emodule unload ([^ ]+)$", [[EMERGE:unloadModule(matches[2])]])
  self.aliases.unload_confirm = tempAlias("^emodule unload ([^ ]+) (.+)$", [[EMERGE:unloadModule(matches[2], matches[3])]])
  self.aliases.github = tempAlias("^emodule github (.+)$", [[ if matches[2] == "help" then EMERGE:showGitHubHelp() else EMERGE:addGitHub(matches[2]) end ]])
  self.aliases.add = tempAlias("^emodule add ([^ ]+) (.+)$", [[EMERGE:addModuleCommand(matches[2], matches[3])]])
  self.aliases.remove = tempAlias("^emodule remove (.+)$", [[EMERGE:removeModule(matches[2])]])
  self.aliases.enable = tempAlias("^emodule enable (.+)$", [[EMERGE:toggleModule(matches[2], true)]])
  self.aliases.disable = tempAlias("^emodule disable (.+)$", [[EMERGE:toggleModule(matches[2], false)]])
  self.aliases.update = tempAlias("^emodule update$", [[EMERGE:checkAllUpdates()]])
  self.aliases.upgrade = tempAlias("^emodule upgrade$", [[EMERGE:upgradeSelf()]])
  self.aliases.config = tempAlias("^emodule config$", [[EMERGE:showConfig()]])
  self.aliases.token = tempAlias("^emodule token (.+)$", [[EMERGE:setGitHubToken(matches[2])]])
  self.aliases.token_help = tempAlias("^emodule token$", [[EMERGE:setGitHubToken()]])
  self.aliases.refresh = tempAlias("^emodule refresh$", [[EMERGE:refreshCache(true)]])
  self.aliases.repos = tempAlias("^emodule repos$", [[EMERGE:listRepositories()]])
  self.aliases.search = tempAlias("^emodule search (.+)$", [[EMERGE:searchModules(matches[2])]])
  self.aliases.info = tempAlias("^emodule info (.+)$", [[EMERGE:showModuleInfo(matches[2])]])
end

function ModuleManager:listModules()
  self:refreshCache(false)
  cecho("\n<SlateGray>──────────────────────────────────────<reset>\n")
  cecho("<LightSteelBlue>EMERGE Module System<reset>\n")
  cecho("<SlateGray>──────────────────────────────────────<reset>\n\n")
  cecho("<LightSteelBlue>Currently Loaded:<reset>\n")
  cecho(string.format("  <SteelBlue>• emerge-manager<reset> v%s <DimGrey>(core system)<reset>\n", self.version))
  for id, module in pairs(self.modules) do
    local update_status = ""
    local cached_module = self.discovery_cache.modules[id]
    if cached_module and cached_module.version and module.version then
      if self:compareVersions(cached_module.version, module.version) > 0 then update_status = " <yellow>(update available)<reset>" end
    end
    cecho(string.format("  <SteelBlue>• %s<reset> v%s - %s%s\n", id, module.version or "?", module.name or "Unknown", update_status))
  end

  local all = self:getModuleList()
  local available = {}
  for id, info in pairs(all) do if not self.modules[id] then table.insert(available, {id=id, info=info}) end end
  table.sort(available, function(a,b)
    local ra = a.info.repository or "custom"; local rb = b.info.repository or "custom"
    if ra ~= rb then return ra < rb end; return a.id < b.id
  end)
  if #available > 0 then
    cecho("\n<LightSteelBlue>Available to Load:<reset>\n")
    local cur = nil
    for _, entry in ipairs(available) do
      local id, info = entry.id, entry.info
      local repo_name = info.repository or "custom"
      if repo_name ~= cur then if cur then cecho("\n") end; cecho(string.format("  <DimGrey>%s:<reset>\n", repo_name)); cur = repo_name end
      local source = ""; if info.github then source = string.format("<DimGrey>(%s/%s)<reset>", info.github.owner, info.github.repo) end
      local v = info.version and (" v" .. info.version) or ""
      cecho(string.format("    <SteelBlue>• %s<reset>%s - %s %s\n", id, v, info.name or info.description or "Unknown", source))
    end
  else
    cecho("\n<DimGrey>No additional modules available<reset>\n"); cecho("<DimGrey>Try 'emodule refresh' to update module list<reset>\n")
  end

  if self.discovery_cache.last_refresh > 0 then
    local age = os.time() - self.discovery_cache.last_refresh
    cecho(string.format("\n<DimGrey>Cache last updated: %d minutes ago<reset>\n", math.floor(age / 60)))
  end
  cecho("\n<DimGrey>Type 'emodule help' for all commands<reset>\n")
end

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

function ModuleManager:showGitHubHelp()
  cecho([[<SlateGray>==== GitHub Integration Setup Guide ====<reset>

<LightSteelBlue>Step 1: Create a GitHub Personal Access Token<reset>
  1. Go to: ]]); cechoLink("github.com/settings/tokens", [[openUrl("https://github.com/settings/tokens")]], "Click to open"); cecho([[

  2. Generate Fine-grained token
  3. Give it a name like "Mudlet EMERGE Access"
  4. Set expiration (e.g., 90 days)
  5. Repository access: All or Selected repositories
  6. Repository permissions: Contents: Read
  7. Generate and copy the token (github_pat_...)

<LightSteelBlue>Step 2: Add Token to EMERGE<reset>
  Run: emodule token <your_token_here>

<LightSteelBlue>Step 3: Add Modules<reset>
  Public repos:  emodule github owner/repository
  Private repos: emodule github owner/private-repo

<LightSteelBlue>Security Notes:<reset>
  • Token is stored locally in emerge-config.json
  • Never share your token; revoke if compromised
]])
end

function ModuleManager:showHelp()
  local token_status = (self.config.github_token and self.config.github_token ~= "") and " <DarkGreen>(token saved)<reset>" or ""
  cecho([[<SlateGray>==== EMERGE Module System ====<reset>
<DimGrey>Emergent Modular Engagement & Response Generation Engine<reset>

<LightSteelBlue>Core Commands:<reset>
  emodule list                 List all modules (loaded & available)
  emodule load <id>            Download and load a module
  emodule unload <id>          Unload a loaded module
  emodule enable <id>          Enable a module for auto-loading
  emodule disable <id>         Disable a module

<LightSteelBlue>Discovery & Search:<reset>
  emodule refresh              Force refresh module discovery cache
  emodule repos                List configured repositories
  emodule search <term>        Search available modules
  emodule info <id>            Show detailed module information

<LightSteelBlue>System Management:<reset>
  emodule unload manager confirm    Completely remove EMERGE

<LightSteelBlue>GitHub Integration:<reset>]] .. token_status .. [[

  emodule github <url>         Add module from GitHub repository
  emodule remove <id>          Remove a custom module
  emodule token <token>        Set GitHub token for private repos

<LightSteelBlue>Update Commands:<reset>
  emodule update               Check all modules for updates
  emodule upgrade              Upgrade EMERGE manager itself

<LightSteelBlue>Other Commands:<reset>
  emodule config               Show current configuration
  emodule help                 Show this help (or just 'emodule')
]])
end

function ModuleManager:addModuleCommand(id, json_str)
  if not id or id == "" or not json_str or json_str == "" then
    cecho("<IndianRed>[EMERGE] Usage: emodule add <id> <json_config><reset>\n"); return
  end
  local ok, info = pcall(yajl.to_value, json_str)
  if ok and info then self:addModule(id, info) else cecho("<IndianRed>[EMERGE] Invalid JSON format<reset>\n") end
end

function ModuleManager:showBootup()
  echo("\n\n")
  cecho("<LightSteelBlue>EMERGE loaded (Codex edition) v" .. self.version .. "<reset>\n")
end

function ModuleManager:setGitHubToken(token)
  if not token or token == "" then
    cecho("<DarkOrange>[EMERGE] GitHub Token Setup<reset>\n")
    cecho("<SteelBlue>Run: emodule token YOUR_TOKEN_HERE<reset>\n"); return
  end
  self.config.github_token = token; self:saveConfig()
  cecho("<LightSteelBlue>[EMERGE] GitHub token saved<reset>\n")
end

function ModuleManager:init()
  self:loadConfig()
  self:createAliases()
  tempTimer(5, function() if EMERGE and EMERGE.loaded then EMERGE:showBootup() end end)
  tempTimer(10, function()
    if EMERGE and EMERGE.loaded then
      if EMERGE.config.github_token and EMERGE.config.github_token ~= "" then
        EMERGE:refreshCache(false)
      else
        cecho("<DimGrey>[EMERGE] Set GitHub token to enable module discovery<reset>\n")
      end
    end
  end)
  tempTimer(15, function() if EMERGE and EMERGE.loaded then EMERGE:autoLoadModules() end end)
  if self.config.auto_update then
    tempTimer(40, function()
      if EMERGE and EMERGE.loaded then EMERGE.silent_check = true; EMERGE:checkAllUpdates() end
    end)
  end
  self.loaded = true
end

function ModuleManager:autoLoadModules()
  if not self.config.auto_load_modules then return end
  if not self.config.github_token then return end
  local modules = self:getModuleList()
  local to_load = {}
  for id, info in pairs(modules) do
    if info.enabled and info.auto_load and not self.modules[id] then
      local is_required = (info.type == "required" or info.type == "core")
      local auto_order = info.load_order or (is_required and (id:match("^emerge%-core") and 10 or 50) or 100)
      table.insert(to_load, { id=id, info=info, order=auto_order, is_required=is_required })
    end
  end
  table.sort(to_load, function(a,b) if a.is_required ~= b.is_required then return a.is_required end; return a.order < b.order end)
  for _, m in ipairs(to_load) do cecho(string.format("<DimGrey>[EMERGE] Auto-loading %s...<reset>\n", m.id)); self:loadModule(m.id) end
end

function ModuleManager:listRepositories()
  cecho("\n<SlateGray>──────────────────────────────────────<reset>\n")
  cecho("<LightSteelBlue>Configured Repositories<reset>\n")
  cecho("<SlateGray>──────────────────────────────────────<reset>\n\n")
  for _, rc in ipairs(self.repositories) do
    local status_icon = rc.public and "<green>●<reset>" or "<yellow>●<reset>"
    local status_text = rc.public and "public" or "private"
    cecho(string.format("%s <SteelBlue>%s<reset> (%s)\n", status_icon, rc.name, status_text))
    cecho(string.format("   %s/%s @ %s\n", rc.owner, rc.repo, rc.branch))
    cecho(string.format("   %s\n\n", rc.description or ""))
  end
  local cached_count = table.size(self.discovery_cache.modules)
  if cached_count > 0 then
    local cache_age = os.time() - self.discovery_cache.last_refresh
    cecho(string.format("<DimGrey>Cached modules: %d (updated %d minutes ago)<reset>\n", cached_count, math.floor(cache_age/60)))
  else
    cecho("<DimGrey>No cached modules. Run 'emodule refresh' to discover.<reset>\n")
  end
end

function ModuleManager:searchModules(search_term)
  if not search_term or search_term == "" then cecho("<IndianRed>[EMERGE] Usage: emodule search <term><reset>\n"); return end
  self:refreshCache(false)
  local all = self:getModuleList(); local matches = {}; local term = search_term:lower()
  for id, info in pairs(all) do
    local score = 0
    if id:lower():find(term) then score = score + 10 end
    if info.name and info.name:lower():find(term) then score = score + 8 end
    if info.description and info.description:lower():find(term) then score = score + 5 end
    if info.author and info.author:lower():find(term) then score = score + 3 end
    if score > 0 then table.insert(matches, {id=id, info=info, score=score}) end
  end
  table.sort(matches, function(a,b) return a.score > b.score end)
  cecho(string.format("\n<LightSteelBlue>Search results for '%s':<reset>\n\n", search_term))
  if #matches == 0 then cecho("<DimGrey>No modules found matching your search.<reset>\n"); return end
  for i, m in ipairs(matches) do
    if i > 10 then cecho(string.format("<DimGrey>... and %d more results<reset>\n", #matches-10)); break end
    local id, info = m.id, m.info
    local status = self.modules[id] and " <green>(loaded)<reset>" or ""
    cecho(string.format("<SteelBlue>%s<reset>%s\n", id, status))
    if info.version then cecho(string.format("  Version: %s\n", info.version)) end
    if info.name then cecho(string.format("  Name: %s\n", info.name)) end
    if info.description then cecho(string.format("  Description: %s\n", info.description)) end
    if info.repository then cecho(string.format("  Repository: %s\n", info.repository)) end
    cecho("\n")
  end
end

function ModuleManager:showModuleInfo(module_id)
  if not module_id or module_id == "" then cecho("<IndianRed>[EMERGE] Usage: emodule info <module_id><reset>\n"); return end
  local all = self:getModuleList(); local info = all[module_id]
  if not info then cecho(string.format("<IndianRed>[EMERGE] Module not found: %s<reset>\n", module_id)); return end
  cecho("\n<SlateGray>──────────────────────────────────────<reset>\n"); cecho(string.format("<LightSteelBlue>Module: %s<reset>\n", module_id)); cecho("<SlateGray>──────────────────────────────────────<reset>\n\n")
  if info.name then cecho(string.format("<SteelBlue>Name:<reset> %s\n", info.name)) end
  if info.version then
    cecho(string.format("<SteelBlue>Version:<reset> %s", info.version))
    local loaded = self.modules[module_id]
    if loaded and loaded.version then
      if loaded.version == info.version then cecho(" <green>(current)<reset>")
      else
        local cmp = self:compareVersions(info.version, loaded.version)
        if cmp > 0 then cecho(string.format(" <yellow>(update available from %s)<reset>", loaded.version)) else cecho(string.format(" <DimGrey>(loaded: %s)<reset>", loaded.version)) end
      end
    end
    cecho("\n")
  end
  if info.description then cecho(string.format("<SteelBlue>Description:<reset> %s\n", info.description)) end
  if info.author then cecho(string.format("<SteelBlue>Author:<reset> %s\n", info.author)) end
  if info.repository then cecho(string.format("<SteelBlue>Repository:<reset> %s\n", info.repository)) end
  if info.github then cecho(string.format("<SteelBlue>GitHub:<reset> %s/%s\n", info.github.owner, info.github.repo)) end
  if info.type then cecho(string.format("<SteelBlue>Type:<reset> %s\n", info.type)) end
  if info.dependencies and #info.dependencies > 0 then cecho(string.format("<SteelBlue>Dependencies:<reset> %s\n", table.concat(info.dependencies, ", "))) end
  if self.modules[module_id] then cecho("\n<green>Status: Loaded<reset>\n") else cecho(string.format("\n<DimGrey>Status: Available (use 'emodule load %s')<reset>\n", module_id)) end
end

-- Basic intro/status routines (kept minimal for Codex edition)
function ModuleManager:manualInstall() cecho("<yellow>[EMERGE] Use the standard manager for auto-install bootloader if needed.<reset>\n") end
function ModuleManager:checkStatus() cecho("<LightSteelBlue>EMERGE Codex v" .. self.version .. " loaded<reset>\n") end

-- Initialize
ModuleManager:init()

