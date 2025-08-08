-- Refactored to comply with CLAUDE.md architectural rules
-- - Namespace pattern (emerge.test_module)
-- - Event-driven via emerge.events (fallback to raiseEvent if legacy)
-- - Semantic version aligned with project (patch bump 0.5.1 for refactor)
-- - 100-character width formatting
-- - Standardized event names: module.test_module.*
-- - Deterministic command ordering, nil guards, unified cleanup

emerge = emerge or {}
emerge.test_module = emerge.test_module or {}
local module = emerge.test_module

-- Module metadata
module.NAME        = "test_module"
module.MODULE_NAME = "emerge-test-module"
module.VERSION     = "0.5.1"  -- Was 1.0.0 (incorrect relative to project 0.5.0); refactor → patch bump
module.AUTHOR      = "EMERGE Team"
module.DESCRIPTION = "Test module for EMERGE token functionality and help system"

-- Display formatting
local WIDTH = 100
local function line(char)
  char = char or "═"
  return string.rep(char, WIDTH)
end

-- Helper: safe table size
local function size(t)
  if type(t) ~= "table" then return 0 end
  local c = 0; for _ in pairs(t) do c = c + 1 end; return c
end

-- Runtime collections
module._handles = {
  aliases = {},
  timers  = {},
  events  = {},
}
module.enabled = true

-- Help topics
module.help = {
  overview = "This is a test module for EMERGE that demonstrates token functionality and help integration.",
  commands = {
    ["etest version"] = "Display the current version of the test module",
    ["etest status"]  = "Show the current status of the test module",
    ["etest help"]    = "Display available help topics"
  },
  usage = "Use 'etest <command>' to interact with the test module.",
  examples = {
    "etest version - Shows version " .. module.VERSION,
    "etest status - Reports module is loaded and operational"
  }
}

-- Event wrapper (new system) with legacy fallback
local emit
if emerge and emerge.events and emerge.events.emit then
  emit = function(ev, ...) emerge.events:emit(ev, ...) end
else
  emit = function(ev, ...) if type(raiseEvent) == 'function' then raiseEvent(ev, ...) end end
end

-- Registration wrapper (supports new + legacy)
local function on(event, cb)
  if emerge and emerge.events and emerge.events.on then
    return emerge.events:on(event, cb)
  elseif registerAnonymousEventHandler then
    return registerAnonymousEventHandler(event, function(_, ...) cb(...) end)
  end
end

-- Removal wrapper (best-effort)
local function off(event, handle)
  if emerge and emerge.events and emerge.events.off then
    emerge.events:off(event, handle)
  elseif type(killAnonymousEventHandler) == 'function' and handle then
    killAnonymousEventHandler(handle)
  end
end

-- Internal: build ordered command list
local function ordered_commands()
  local keys = {}
  for k in pairs(module.help.commands) do keys[#keys+1] = k end
  table.sort(keys)
  return keys
end

-- Output helpers
local function header(title)
  cecho(string.format("<LightSteelBlue>%s<reset>\n", line()))
  cecho(string.format("<LightSteelBlue>[EMERGE %s: %s]<reset>\n", module.NAME, title))
  cecho(string.format("<LightSteelBlue>%s<reset>\n", line()))
end

local function footer()
  cecho(string.format("<LightSteelBlue>%s<reset>\n", line()))
end

-- Public display functions
function module.show_version()
  cecho(string.format("<LightSteelBlue>[test_module]<reset> Version: <yellow>%s<reset>\n", module.VERSION))
  emit("module.test_module.version_shown", module.VERSION)
end

function module.show_status()
  header("Status")
  cecho(string.format("  <cyan>Version:<reset>     %s\n", module.VERSION))
  cecho(string.format("  <cyan>Author:<reset>      %s\n", module.AUTHOR))
  cecho(string.format("  <cyan>Status:<reset>      %s\n", module.enabled and "<green>Enabled<reset>" or "<red>Disabled<reset>"))
  cecho(string.format("  <cyan>Help:<reset>        %s\n", "<green>Available<reset>"))
  cecho("\n  <cyan>Components:<reset>\n")
  cecho(string.format("    Aliases:   %d loaded\n", size(module._handles.aliases)))
  cecho(string.format("    Timers:    %d loaded\n", size(module._handles.timers)))
  cecho(string.format("    Events:    %d handlers\n", size(module._handles.events)))
  footer()
  emit("module.test_module.status_shown")
end

function module.show_help()
  header("Help")
  cecho("<yellow>Overview:<reset>\n  " .. module.help.overview .. "\n\n")
  cecho("<yellow>Available Commands:<reset>\n")
  for _, k in ipairs(ordered_commands()) do
    cecho(string.format("  <cyan>%s<reset> - %s\n", k, module.help.commands[k]))
  end
  cecho("\n<yellow>Usage:<reset>\n  " .. module.help.usage .. "\n\n")
  cecho("<yellow>Examples:<reset>\n")
  for _, ex in ipairs(module.help.examples) do
    cecho("  " .. ex .. "\n")
  end
  cecho("\nType '<cyan>etest help <topic><reset>' for more information (overview | commands | usage | examples).\n")
  footer()
  emit("module.test_module.help_shown")
end

function module.show_help_topic(topic)
  if not topic or type(topic) ~= 'string' then
    cecho("<IndianRed>Missing help topic.<reset>\n")
    cecho("Available: overview, commands, usage, examples\n")
    return
  end
  topic = topic:lower():match("^%s*(.-)%s*$")
  local h = module.help
  if topic == "overview" then
    cecho(string.format("<LightSteelBlue>[Help: Overview]<reset>\n%s\n", h.overview))
  elseif topic == "commands" then
    cecho("<LightSteelBlue>[Help: Commands]<reset>\n")
    for _, k in ipairs(ordered_commands()) do
      cecho(string.format("  <cyan>%s<reset> - %s\n", k, h.commands[k]))
    end
  elseif topic == "usage" then
    cecho(string.format("<LightSteelBlue>[Help: Usage]<reset>\n%s\n", h.usage))
  elseif topic == "examples" then
    cecho("<LightSteelBlue>[Help: Examples]<reset>\n")
    for _, ex in ipairs(h.examples) do cecho("  " .. ex .. "\n") end
  else
    cecho(string.format("<IndianRed>Unknown help topic: %s<reset>\n", topic))
    cecho("Available: overview, commands, usage, examples\n")
  end
end

-- Heartbeat timer callback
function module._heartbeat()
  if module.enabled then
    emit("module.test_module.heartbeat", os.time())
  end
end

-- Initialization
function module.init()
  if module._initialized then return end

  -- Aliases
  module._handles.aliases.version = tempAlias("^etest version$", [[emerge.test_module.show_version()]])
  module._handles.aliases.status  = tempAlias("^etest status$",  [[emerge.test_module.show_status()]])
  module._handles.aliases.help    = tempAlias("^etest help$",    [[emerge.test_module.show_help()]])
  module._handles.aliases.help_t  = tempAlias("^etest help (.+)$", [[emerge.test_module.show_help_topic(matches[2])]])

  -- Heartbeat (60s recurring)
  module._handles.timers.heartbeat = tempTimer(60, [[emerge.test_module._heartbeat()]], true)

  -- Help discovery & version query events (respond via standardized events)
  module._handles.events.help_query = on("help.query.modules_with_help", function()
    emit("help.response.module_topics", module.MODULE_NAME, module.help)
  end)
  module._handles.events.version_query = on("version.query.module", function(requested)
    if not requested or requested == module.MODULE_NAME then
      emit("version.response.module", module.MODULE_NAME, module.VERSION)
    end
  end)

  module._initialized = true
  cecho(string.format("<LightSteelBlue>[test_module] Loaded v%s<reset>\n", module.VERSION))
  cecho("<LightSteelBlue>Type 'etest help' for available commands<reset>\n")
  emit("module.test_module.loaded", module.VERSION)
end

-- Shutdown / cleanup
function module.shutdown()
  if not module._initialized then return end
  for _, id in pairs(module._handles.aliases) do if exists(id, "alias") > 0 then killAlias(id) end end
  for _, id in pairs(module._handles.timers)  do if exists(id, "timer") > 0 then killTimer(id) end end
  for evt, handle in pairs(module._handles.events) do off(evt, handle) end
  module._handles.aliases = {}; module._handles.timers = {}; module._handles.events = {}
  module._initialized = false
  cecho("<IndianRed>[test_module] Unloaded<reset>\n")
  emit("module.test_module.unloaded")
end

-- Hot-reload support: if already initialized, cycle it
if module._initialized then
  module.shutdown()
end
module.init()

return module