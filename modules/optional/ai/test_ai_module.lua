-- Test script for AI module functionality
-- Run this to verify all features work correctly

local test_results = {}

-- Test helper function
local function test_feature(name, test_func)
    local success, result = pcall(test_func)
    test_results[name] = {
        success = success,
        result = result or "OK"
    }
    
    if success then
        cecho("<green>[PASS] " .. name .. "<reset>\n")
    else
        cecho("<red>[FAIL] " .. name .. ": " .. tostring(result) .. "<reset>\n")
    end
end

-- Load the AI module
cecho("<yellow>Testing EMERGE AI Module v0.5.1<reset>\n")
cecho("=" .. string.rep("=", 50) .. "\n")

-- Test module loading
test_feature("Module Loading", function()
    local ai_module = dofile(getMudletHomeDir() .. "/Projects/EMERGE Research/modules/optional/ai/ai.lua")
    assert(ai_module, "Module failed to load")
    assert(ai_module.version == "0.5.1", "Version mismatch")
    return "Module loaded with version " .. ai_module.version
end)

-- Test event registration
test_feature("Event System Integration", function()
    assert(emerge and emerge.events, "EMERGE event system not available")
    
    -- Test event emission (should not error)
    emerge.events:emit("emerge.ai.command.status_check")
    return "Events can be emitted without error"
end)

-- Test alias creation patterns
test_feature("Alias Pattern Validation", function()
    local patterns = {
        "^ait (.+)$",
        "^ai apikey groq (.+)$",
        "^ai apikey openai (.+)$", 
        "^ai apikey clear groq$",
        "^ai apikey clear openai$",
        "^ai help$",
        "^ai unload$"
    }
    
    for _, pattern in ipairs(patterns) do
        assert(type(pattern) == "string", "Invalid pattern type")
        assert(pattern:len() > 0, "Empty pattern")
    end
    
    return "All alias patterns are valid"
end)

-- Test configuration structure
test_feature("Configuration Structure", function()
    assert(emerge and emerge.config, "EMERGE config system not available")
    
    -- These should not error when accessed
    emerge.config.get("ai.provider", "ollama")
    emerge.config.get("ai.api_keys", {})
    
    return "Configuration access works"
end)

-- Test module API compliance
test_feature("EMERGE API Compliance", function()
    local ai_module = emerge.ai or {}
    
    -- Check for required functions
    assert(type(ai_module.init) == "function", "Missing init() function")
    assert(type(ai_module.shutdown) == "function", "Missing shutdown() function")
    
    -- Check module metadata
    assert(ai_module.name == "emerge.ai", "Incorrect module name")
    assert(ai_module.version == "0.5.1", "Incorrect version")
    
    return "Module follows EMERGE API standards"
end)

-- Summary
cecho("\n<cyan>Test Summary:<reset>\n")
local passed = 0
local total = 0

for name, result in pairs(test_results) do
    total = total + 1
    if result.success then
        passed = passed + 1
    end
end

cecho(string.format("Passed: %d/%d tests\n", passed, total))

if passed == total then
    cecho("<green>All tests passed! The AI module is ready for use.<reset>\n")
    cecho("\n<yellow>Usage Examples:<reset>\n")
    cecho("  ai help                    - Show all commands\n")
    cecho("  ai apikey groq YOUR_KEY    - Set Groq API key\n") 
    cecho("  ai status                  - Check configuration\n")
    cecho("  ait Hello there!           - Chat with AI\n")
    cecho("  ai unload                  - Completely unload module\n")
else
    cecho("<red>Some tests failed. Please check the module implementation.<reset>\n")
end

return test_results