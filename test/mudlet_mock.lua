--[[
================================================================================
                    MUDLET MOCK ENVIRONMENT FOR EMERGE TESTING
================================================================================
-- Description: Complete Mudlet API mocking for unit and integration testing
-- Version: 1.0.0
-- Compatible: Lua 5.1
-- 
-- This module provides a comprehensive mock of Mudlet's Lua environment,
-- allowing EMERGE modules to be tested outside of the Mudlet client using
-- standard Lua interpreters.
================================================================================
--]]

local MudletMock = {}

-- Mock state tracking
local mock_state = {
    output = {},           -- Captured cecho/echo output
    aliases = {},          -- Created aliases
    timers = {},          -- Created timers  
    events = {},          -- Raised events
    gmcp_data = {},       -- GMCP data simulation
    profile_path = "/tmp/emerge_test"
}

-- Helper function to capture and format output
local function capture_output(text, color_mode)
    local clean_text = text or ""
    -- Remove Mudlet color tags for testing
    clean_text = clean_text:gsub("<[^>]*>", "")
    table.insert(mock_state.output, clean_text)
    return clean_text
end

-- === MUDLET OUTPUT FUNCTIONS ===

function echo(text)
    return capture_output(text, "plain")
end

function cecho(text)
    return capture_output(text, "color")
end

function decho(text)
    return capture_output(text, "decimal")
end

function hecho(text)
    return capture_output(text, "hex")
end

function display(obj)
    local str = "display: " .. tostring(obj)
    if type(obj) == "table" then
        str = "display: table[" .. #obj .. " items]"
    end
    return capture_output(str, "plain")
end

-- === MUDLET ALIAS FUNCTIONS ===

function tempAlias(pattern, code)
    local alias_id = "alias_" .. (#mock_state.aliases + 1)
    mock_state.aliases[alias_id] = {
        pattern = pattern,
        code = code,
        enabled = true
    }
    return alias_id
end

function killAlias(alias_id)
    if mock_state.aliases[alias_id] then
        mock_state.aliases[alias_id] = nil
        return true
    end
    return false
end

function exists(name, item_type)
    if item_type == "alias" then
        return mock_state.aliases[name] and 1 or 0
    elseif item_type == "timer" then
        return mock_state.timers[name] and 1 or 0
    end
    return 0
end

-- === MUDLET TIMER FUNCTIONS ===

function tempTimer(delay, code, repeating)
    local timer_id = "timer_" .. (#mock_state.timers + 1)
    mock_state.timers[timer_id] = {
        delay = delay,
        code = code,
        repeating = repeating or false,
        enabled = true
    }
    
    -- For testing, we don't actually execute timers
    -- but we track that they were created
    return timer_id
end

function killTimer(timer_id)
    if mock_state.timers[timer_id] then
        mock_state.timers[timer_id] = nil
        return true
    end
    return false
end

function killAllTimers()
    mock_state.timers = {}
end

-- === MUDLET EVENT FUNCTIONS ===

function raiseEvent(event_name, ...)
    table.insert(mock_state.events, {
        name = event_name,
        args = {...}
    })
end

function registerAnonymousEventHandler(event_name, callback)
    local handler_id = "handler_" .. (#mock_state.events + 1)
    -- In real testing, we might want to track handlers
    return handler_id
end

function killAnonymousEventHandler(handler_id)
    -- Mock implementation
    return true
end

-- === MUDLET SYSTEM FUNCTIONS ===

function getMudletHomeDir()
    return mock_state.profile_path
end

function send(command, echo_command)
    table.insert(mock_state.output, "SEND: " .. command)
end

function sendAll(commands)
    for _, cmd in ipairs(commands) do
        send(cmd)
    end
end

-- === GMCP SIMULATION ===

gmcp = {}

function setGMCPModules(modules)
    -- Mock GMCP module registration
    mock_state.gmcp_modules = modules
end

-- === IO FUNCTIONS ===

local original_io = io
io = {}
for k, v in pairs(original_io) do
    io[k] = v
end

function io.exists(filepath)
    local f = io.open(filepath, "r")
    if f then
        f:close()
        return true
    end
    return false
end

-- === TABLE FUNCTIONS ===

table = table or {}

function table.save(filepath, data)
    -- Mock table save - in real tests we might write to temp files
    mock_state.saved_tables = mock_state.saved_tables or {}
    mock_state.saved_tables[filepath] = data
    return true
end

function table.load(filepath)
    mock_state.saved_tables = mock_state.saved_tables or {}
    return mock_state.saved_tables[filepath]
end

-- === MOCK CONTROL FUNCTIONS ===

function MudletMock.reset()
    mock_state = {
        output = {},
        aliases = {},
        timers = {},
        events = {},
        gmcp_data = {},
        profile_path = "/tmp/emerge_test"
    }
end

function MudletMock.get_output()
    return mock_state.output
end

function MudletMock.get_last_output()
    return mock_state.output[#mock_state.output] or ""
end

function MudletMock.get_aliases()
    return mock_state.aliases
end

function MudletMock.get_timers()
    return mock_state.timers
end

function MudletMock.get_events()
    return mock_state.events
end

function MudletMock.simulate_gmcp(module, data)
    gmcp[module] = data
    raiseEvent("gmcp." .. module)
end

function MudletMock.assert_output_contains(expected_text)
    local all_output = table.concat(mock_state.output, " ")
    if not all_output:find(expected_text, 1, true) then
        error("Expected output to contain: '" .. expected_text .. "'\nActual output: '" .. all_output .. "'")
    end
    return true
end

function MudletMock.assert_event_raised(event_name)
    for _, event in ipairs(mock_state.events) do
        if event.name == event_name then
            return true
        end
    end
    error("Expected event '" .. event_name .. "' to be raised, but it wasn't")
end

function MudletMock.get_alias_count()
    local count = 0
    for _ in pairs(mock_state.aliases) do
        count = count + 1
    end
    return count
end

-- Initialize mock environment
MudletMock.reset()

return MudletMock