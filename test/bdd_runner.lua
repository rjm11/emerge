#!/usr/bin/env lua
--[[
================================================================================
                        EMERGE BDD TEST RUNNER
================================================================================
-- Description: Behavior-Driven Development test framework for EMERGE
-- Version: 1.0.0  
-- Compatible: Lua 5.1
--
-- Provides Jest/RSpec-style testing with describe() and it() functions.
-- Automatically discovers and runs *_test.lua files.
================================================================================
--]]

-- Load Mudlet mock environment
local script_dir = arg and arg[0] and arg[0]:match("(.*/)")
if script_dir then
    package.path = script_dir .. "?.lua;" .. package.path
else
    package.path = "./test/?.lua;" .. package.path
end

local MudletMock = require("mudlet_mock")

-- BDD Framework state
local framework = {
    current_describe = nil,
    tests = {},
    stats = {
        passed = 0,
        failed = 0,
        total = 0
    },
    output = {}
}

-- Colors for terminal output (if supported)
local colors = {
    red = "\27[31m",
    green = "\27[32m", 
    yellow = "\27[33m",
    blue = "\27[34m",
    magenta = "\27[35m",
    cyan = "\27[36m",
    white = "\27[37m",
    reset = "\27[0m",
    bold = "\27[1m"
}

-- Check if we're in a terminal that supports colors
local function supports_color()
    local term = os.getenv("TERM")
    return term and term ~= "dumb"
end

if not supports_color() then
    for k, _ in pairs(colors) do
        colors[k] = ""
    end
end

-- Utility functions
local function print_colored(color, text)
    print(color .. text .. colors.reset)
end

local function print_header()
    print_colored(colors.bold .. colors.cyan, "🧪 EMERGE Testing Framework v1.0.0")
    print_colored(colors.cyan, string.rep("=", 40))
    print("")
end

local function print_test_result(passed, test_name, error_msg)
    local icon = passed and "✅" or "❌"
    local color = passed and colors.green or colors.red
    local indent = "  "
    
    print_colored(color, indent .. icon .. " " .. test_name)
    
    if not passed and error_msg then
        print_colored(colors.red, indent .. "   " .. error_msg)
    end
end

local function print_summary()
    print("")
    print_colored(colors.bold .. colors.white, "📊 Test Results: " .. 
        framework.stats.passed .. " passed, " .. 
        framework.stats.failed .. " failed")
    
    if framework.stats.failed == 0 then
        print_colored(colors.bold .. colors.green, "✅ All tests passed!")
    else
        print_colored(colors.bold .. colors.red, "❌ Some tests failed!")
    end
end

-- BDD Functions
function describe(description, test_function)
    framework.current_describe = description
    print_colored(colors.bold .. colors.white, description)
    
    -- Reset mock state for each describe block
    MudletMock.reset()
    
    -- Execute the test function
    local success, error_msg = pcall(test_function)
    if not success then
        print_colored(colors.red, "Error in describe block: " .. error_msg)
    end
    
    framework.current_describe = nil
end

function it(description, test_function)
    framework.stats.total = framework.stats.total + 1
    
    -- Reset mock state before each test
    MudletMock.reset()
    
    -- Execute the test
    local success, error_msg = pcall(test_function)
    
    if success then
        framework.stats.passed = framework.stats.passed + 1
        print_test_result(true, description)
    else
        framework.stats.failed = framework.stats.failed + 1
        print_test_result(false, description, error_msg)
    end
end

-- Assertion functions
function assert(condition, message)
    if not condition then
        error(message or "Assertion failed", 2)
    end
end

function assert_equal(expected, actual, message)
    if expected ~= actual then
        local msg = message or string.format(
            "Expected: %s, but got: %s", 
            tostring(expected), 
            tostring(actual)
        )
        error(msg, 2)
    end
end

function assert_not_equal(expected, actual, message)
    if expected == actual then
        local msg = message or string.format(
            "Expected not to equal: %s", 
            tostring(expected)
        )
        error(msg, 2)
    end
end

function assert_type(expected_type, value, message)
    local actual_type = type(value)
    if actual_type ~= expected_type then
        local msg = message or string.format(
            "Expected type %s, but got %s", 
            expected_type, 
            actual_type
        )
        error(msg, 2)
    end
end

function assert_nil(value, message)
    if value ~= nil then
        local msg = message or "Expected nil, but got: " .. tostring(value)
        error(msg, 2)
    end
end

function assert_not_nil(value, message)
    if value == nil then
        local msg = message or "Expected non-nil value"
        error(msg, 2)
    end
end

-- File discovery and execution
local function find_test_files(directory)
    directory = directory or "test"
    local test_files = {}
    
    -- Simple glob for *_test.lua files
    local handle = io.popen("find " .. directory .. " -name '*_test.lua' 2>/dev/null")
    if handle then
        for file in handle:lines() do
            table.insert(test_files, file)
        end
        handle:close()
    end
    
    -- Fallback for systems without find command
    if #test_files == 0 then
        local common_test_files = {
            "test/emerge_core_test.lua",
            "test/emerge_manager_test.lua",
            "test/basic_test.lua"
        }
        
        for _, file in ipairs(common_test_files) do
            local f = io.open(file, "r")
            if f then
                f:close()
                table.insert(test_files, file)
            end
        end
    end
    
    return test_files
end

local function run_test_file(filepath)
    local success, error_msg = pcall(dofile, filepath)
    if not success then
        print_colored(colors.red, "Error loading test file " .. filepath .. ": " .. error_msg)
        return false
    end
    return true
end

-- Main execution function
local function run_tests()
    print_header()
    
    -- Make BDD functions and mocks globally available
    _G.describe = describe
    _G.it = it
    _G.assert = assert
    _G.assert_equal = assert_equal
    _G.assert_not_equal = assert_not_equal
    _G.assert_type = assert_type
    _G.assert_nil = assert_nil
    _G.assert_not_nil = assert_not_nil
    _G.MudletMock = MudletMock
    
    -- Find and run all test files
    local test_files = find_test_files()
    
    if #test_files == 0 then
        print_colored(colors.yellow, "⚠️  No test files found matching pattern *_test.lua")
        print_colored(colors.yellow, "Create test files in the test/ directory")
        return 1
    end
    
    print_colored(colors.blue, "📁 Running " .. #test_files .. " test file(s):")
    for _, file in ipairs(test_files) do
        print_colored(colors.blue, "  • " .. file)
    end
    print("")
    
    -- Execute all test files
    for _, file in ipairs(test_files) do
        run_test_file(file)
    end
    
    print_summary()
    
    -- Return exit code (0 = success, 1 = failure)
    return framework.stats.failed == 0 and 0 or 1
end

-- If this file is run directly, execute tests
if arg and arg[0] and arg[0]:match("bdd_runner%.lua$") then
    os.exit(run_tests())
end

-- Export framework for use by other modules
return {
    describe = describe,
    it = it,
    assert = assert,
    assert_equal = assert_equal,
    assert_not_equal = assert_not_equal,
    assert_type = assert_type,
    assert_nil = assert_nil,
    assert_not_nil = assert_not_nil,
    run_tests = run_tests,
    framework = framework
}