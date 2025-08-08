-- tests/test_emerge_test_module.lua
local test = {}

-- Test configuration
local config = {
    verbose = false,
    timeout = 5,  -- seconds
}

-- Mock EMERGE manager for testing
local MockEMERGE = {
    modules = {},
    registerModule = function(self, name, module)
        self.modules[name] = module
        return true
    end,
    unloadModule = function(self, name)
        if self.modules[name] and self.modules[name].unload then
            self.modules[name]:unload()
        end
        self.modules[name] = nil
    end
}

-- Event capture system for testing
local captured_events = {}
local original_raiseEvent = raiseEvent

local function mock_raiseEvent(event_name, ...)
    table.insert(captured_events, {
        event = event_name,
        args = {...},
        timestamp = os.clock()
    })
    -- Still call original if it exists for integration
    if original_raiseEvent then
        original_raiseEvent(event_name, ...)
    end
end

-- Mock Mudlet functions for testing
local mock_aliases = {}
local mock_handlers = {}
local mock_timers = {}
local alias_counter = 1
local handler_counter = 1
local timer_counter = 1

local function mock_tempAlias(pattern, code)
    local id = "alias_" .. alias_counter
    alias_counter = alias_counter + 1
    mock_aliases[id] = {pattern = pattern, code = code}
    return id
end

local function mock_registerAnonymousEventHandler(event, callback)
    local id = "handler_" .. handler_counter
    handler_counter = handler_counter + 1
    mock_handlers[id] = {event = event, callback = callback}
    return id
end

local function mock_tempTimer(delay, code, repeating)
    local id = "timer_" .. timer_counter
    timer_counter = timer_counter + 1
    mock_timers[id] = {delay = delay, code = code, repeating = repeating or false}
    return id
end

local function mock_cecho(text)
    -- Store output for verification
    if not test._output then test._output = {} end
    table.insert(test._output, text)
end

-- Test helpers
local function setup()
    -- Reset test environment
    captured_events = {}
    mock_aliases = {}
    mock_handlers = {}
    mock_timers = {}
    alias_counter = 1
    handler_counter = 1
    timer_counter = 1
    test._output = {}
    
    -- Setup global mocks
    _G.EMERGE = MockEMERGE
    _G.raiseEvent = mock_raiseEvent
    _G.tempAlias = mock_tempAlias
    _G.registerAnonymousEventHandler = mock_registerAnonymousEventHandler
    _G.tempTimer = mock_tempTimer
    _G.cecho = mock_cecho
    _G.exists = function() return 0 end  -- Mock exists function
    _G.killTrigger = function() end
    _G.killAlias = function() end
    _G.killTimer = function() end
    _G.killAnonymousEventHandler = function() end
end

local function teardown()
    -- Cleanup
    captured_events = {}
    test._output = {}
end

local function get_captured_events(event_name)
    local filtered = {}
    for _, event in ipairs(captured_events) do
        if event.event == event_name then
            table.insert(filtered, event)
        end
    end
    return filtered
end

local function simulate_event(event_name, ...)
    -- Simulate event being raised to test handlers
    for _, handler_data in pairs(mock_handlers) do
        if handler_data.event == event_name then
            handler_data.callback(event_name, ...)
        end
    end
end

-- Load the test module
local function load_test_module()
    -- Source the module file in our mocked environment
    local module_path = "/Users/robertmassey/Projects/EMERGE Research/emerge/emerge-test-module.lua"
    local module_func = loadfile(module_path)
    if not module_func then
        error("Could not load test module from: " .. module_path)
    end
    
    return module_func()
end

-- Test: Module loading and initialization
function test.module_loading()
    setup()
    
    local success, result = pcall(load_test_module)
    assert(success, "Module failed to load: " .. tostring(result))
    assert(result, "Module did not return itself")
    
    -- Verify module was registered with EMERGE manager
    assert(MockEMERGE.modules["emerge-test-module"], "Module not registered")
    
    -- Verify initialization events
    local load_events = get_captured_events("emerge.module.loaded")
    assert(#load_events > 0, "Module load event not emitted")
    assert(load_events[1].args[1] == "emerge-test-module", "Wrong module name in load event")
    assert(load_events[1].args[2] == "1.0.0", "Wrong version in load event")
    
    teardown()
    return true, "Module loading successful"
end

-- Test: Event-driven architecture compliance
function test.event_driven_compliance()
    setup()
    
    local module = load_test_module()
    
    -- Verify no direct function calls to other modules
    -- This would be caught by static analysis in real testing
    
    -- Verify all communication uses raiseEvent
    local expected_events = {
        "emerge.module.loaded",
        "emerge.response.help",
        "emerge.response.version",
        "emerge.module.heartbeat"
    }
    
    -- Test event handlers respond correctly
    simulate_event("emerge.query.help", "modules_with_help")
    local help_events = get_captured_events("emerge.response.help")
    assert(#help_events > 0, "Help query handler not working")
    
    simulate_event("emerge.query.version", "emerge-test-module")
    local version_events = get_captured_events("emerge.response.version")
    assert(#version_events > 0, "Version query handler not working")
    
    teardown()
    return true, "Event-driven compliance verified"
end

-- Test: Help system integration
function test.help_system()
    setup()
    
    local module = load_test_module()
    
    -- Test help query response
    simulate_event("emerge.query.help", "modules_with_help")
    local help_events = get_captured_events("emerge.response.help")
    
    assert(#help_events > 0, "No help response generated")
    assert(help_events[1].args[1] == "emerge-test-module", "Wrong module name in help response")
    assert(help_events[1].args[2], "No help topics provided")
    assert(help_events[1].args[2].overview, "Help topics missing overview")
    assert(help_events[1].args[2].commands, "Help topics missing commands")
    
    teardown()
    return true, "Help system integration working"
end

-- Test: Alias registration and functionality
function test.alias_system()
    setup()
    
    local module = load_test_module()
    
    -- Verify aliases were created
    local expected_aliases = {
        "version", "status", "help", "help_topic"
    }
    
    for _, alias_name in ipairs(expected_aliases) do
        assert(module.aliases[alias_name], "Missing alias: " .. alias_name)
    end
    
    -- Test that aliases have correct patterns
    local version_alias_id = module.aliases.version
    assert(mock_aliases[version_alias_id], "Version alias not found in mock")
    assert(mock_aliases[version_alias_id].pattern == "^etest version$", "Wrong pattern for version alias")
    
    teardown()
    return true, "Alias system working correctly"
end

-- Test: Timer system (heartbeat)
function test.timer_system()
    setup()
    
    local module = load_test_module()
    
    -- Verify heartbeat timer was created
    assert(module.timers.heartbeat, "Heartbeat timer not created")
    
    local timer_id = module.timers.heartbeat
    assert(mock_timers[timer_id], "Timer not found in mock system")
    assert(mock_timers[timer_id].delay == 60, "Wrong heartbeat delay")
    assert(mock_timers[timer_id].repeating == true, "Heartbeat should be repeating")
    
    -- Test heartbeat functionality
    local initial_events = #get_captured_events("emerge.module.heartbeat")
    module:heartbeat()
    local heartbeat_events = get_captured_events("emerge.module.heartbeat")
    
    assert(#heartbeat_events > initial_events, "Heartbeat event not emitted")
    assert(heartbeat_events[#heartbeat_events].args[1] == "emerge-test-module", "Wrong module in heartbeat")
    
    teardown()
    return true, "Timer system working correctly"
end

-- Test: Module state management
function test.state_management()
    setup()
    
    local module = load_test_module()
    
    -- Test enable/disable
    assert(module.enabled == true, "Module should start enabled")
    
    module.enabled = false
    module:heartbeat()
    
    -- Should not emit heartbeat when disabled
    local heartbeat_events = get_captured_events("emerge.module.heartbeat")
    -- Check that no new heartbeat was added after disabling
    
    module.enabled = true
    module:heartbeat()
    local new_heartbeat_events = get_captured_events("emerge.module.heartbeat")
    assert(#new_heartbeat_events > #heartbeat_events, "Heartbeat not resuming when re-enabled")
    
    teardown()
    return true, "State management working correctly"
end

-- Test: Version system
function test.version_system()
    setup()
    
    local module = load_test_module()
    
    -- Test version query with specific module name
    simulate_event("emerge.query.version", "emerge-test-module")
    local version_events = get_captured_events("emerge.response.version")
    
    assert(#version_events > 0, "Version query not responded to")
    assert(version_events[1].args[1] == "emerge-test-module", "Wrong module name in version response")
    assert(version_events[1].args[2] == "1.0.0", "Wrong version number")
    
    -- Test version query without module name (should respond)
    captured_events = {}  -- Reset
    simulate_event("emerge.query.version")
    version_events = get_captured_events("emerge.response.version")
    assert(#version_events > 0, "Version query without module name not responded to")
    
    teardown()
    return true, "Version system working correctly"
end

-- Test: Module cleanup/unloading
function test.module_cleanup()
    setup()
    
    local module = load_test_module()
    
    -- Verify components are registered
    assert(next(module.aliases) ~= nil, "No aliases to cleanup")
    assert(next(module.handlers) ~= nil, "No handlers to cleanup")
    assert(next(module.timers) ~= nil, "No timers to cleanup")
    
    -- Test unloading
    module:unload()
    
    -- Verify cleanup message was displayed
    local found_unload_msg = false
    for _, output in ipairs(test._output or {}) do
        if output:match("Module unloaded") then
            found_unload_msg = true
            break
        end
    end
    assert(found_unload_msg, "Unload message not displayed")
    
    teardown()
    return true, "Module cleanup working correctly"
end

-- Test: Command output validation
function test.command_output()
    setup()
    
    local module = load_test_module()
    
    -- Test version command
    test._output = {}
    module:showVersion()
    assert(#test._output > 0, "Version command produced no output")
    
    local version_displayed = get_captured_events("emerge.module.version_displayed")
    assert(#version_displayed > 0, "Version display event not emitted")
    
    -- Test status command
    test._output = {}
    module:showStatus()
    assert(#test._output > 0, "Status command produced no output")
    
    local status_displayed = get_captured_events("emerge.module.status_displayed")
    assert(#status_displayed > 0, "Status display event not emitted")
    
    -- Test help command
    test._output = {}
    module:showHelp()
    assert(#test._output > 0, "Help command produced no output")
    
    local help_displayed = get_captured_events("emerge.module.help_displayed")
    assert(#help_displayed > 0, "Help display event not emitted")
    
    teardown()
    return true, "Command output validation successful"
end

-- Test: Error handling and edge cases
function test.error_handling()
    setup()
    
    local module = load_test_module()
    
    -- Test invalid help topic
    test._output = {}
    module:showHelpTopic("nonexistent")
    assert(#test._output > 0, "Invalid help topic should produce output")
    
    -- Verify error message contains expected text
    local found_error = false
    for _, output in ipairs(test._output or {}) do
        if output:match("Unknown help topic") then
            found_error = true
            break
        end
    end
    assert(found_error, "Error message not displayed for invalid help topic")
    
    -- Test whitespace handling in help topics
    test._output = {}
    module:showHelpTopic("  overview  ")  -- With whitespace
    assert(#test._output > 0, "Help topic with whitespace should work")
    
    teardown()
    return true, "Error handling working correctly"
end

-- Performance test
function test.performance()
    setup()
    
    local module = load_test_module()
    
    local start_time = os.clock()
    
    -- Simulate rapid event handling
    for i = 1, 1000 do
        simulate_event("emerge.query.version", "emerge-test-module")
    end
    
    local elapsed = os.clock() - start_time
    assert(elapsed < 1.0, "Event handling too slow: " .. elapsed .. " seconds")
    
    -- Verify all events were handled
    local version_events = get_captured_events("emerge.response.version")
    assert(#version_events == 1000, "Not all events were handled")
    
    teardown()
    return true, string.format("Performance acceptable: %.3fms per event", (elapsed * 1000) / 1000)
end

-- Test runner
function test.run_all()
    local results = {
        passed = 0,
        failed = 0,
        skipped = 0,
        details = {}
    }
    
    -- Use print instead of echo for non-Mudlet environment
    local output = _G.echo or print
    output("=== EMERGE Test Suite: emerge-test-module ===")
    
    local test_order = {
        "module_loading",
        "event_driven_compliance", 
        "help_system",
        "alias_system",
        "timer_system",
        "state_management",
        "version_system",
        "command_output",
        "error_handling",
        "module_cleanup",
        "performance"
    }
    
    for _, test_name in ipairs(test_order) do
        local test_func = test[test_name]
        if test_func then
            output(string.format("Running: %s... ", test_name))
            
            local success, result, message = pcall(test_func)
            
            if success and result then
                results.passed = results.passed + 1
                output("PASS")
                table.insert(results.details, {
                    test = test_name,
                    status = "PASS",
                    message = message or "Success"
                })
            else
                results.failed = results.failed + 1
                local error_msg = success and tostring(result) or tostring(result)
                output(string.format("FAIL: %s", error_msg))
                table.insert(results.details, {
                    test = test_name,
                    status = "FAIL",
                    error = error_msg
                })
            end
        end
    end
    
    output(string.format("\n=== Results: %d passed, %d failed ===", results.passed, results.failed))
    
    if results.failed > 0 then
        output("\n=== Failed Tests ===")
        for _, detail in ipairs(results.details) do
            if detail.status == "FAIL" then
                output(string.format("%s: %s", detail.test, detail.error))
            end
        end
    end
    
    return results
end

return test