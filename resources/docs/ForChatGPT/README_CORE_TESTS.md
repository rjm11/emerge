# EMERGE Core Event System Tests

## Overview

This directory contains comprehensive tests for the `emerge-core.lua` module, which is the foundational event system for the EMERGE combat framework. These tests ensure the reliability, performance, and correctness of the core event infrastructure.

## Test Coverage

### Basic Event System (7 tests)
- ✅ **Module Loading**: Verifies the module loads correctly and initializes all components
- ✅ **Basic Event Emission**: Tests simple event emission and reception
- ✅ **Handler Management**: Tests event handler registration and removal
- ✅ **Once Handler**: Tests single-fire event handlers
- ✅ **Event Name Validation**: Validates event naming conventions

### Request/Response Pattern (2 tests)
- ✅ **Request/Response**: Tests query-response communication pattern
- ✅ **Request Timeout**: Verifies timeout handling for unanswered queries

### Advanced Features (4 tests)
- ✅ **Subscription System**: Tests pattern-based event subscriptions
- ✅ **Event Batching**: Tests batch processing of multiple events
- ✅ **Batch Queue**: Tests queued batch processing with timeouts
- ✅ **Error Handling**: Tests error isolation and recovery

### Monitoring & Health (3 tests)
- ✅ **Performance Monitoring**: Tests handler timing and performance warnings
- ✅ **Event History**: Tests circular buffer event history tracking
- ✅ **Health Check**: Tests system health monitoring and metrics

### Module Lifecycle (1 test)
- ✅ **Module Lifecycle**: Tests initialization, cleanup, and reload functionality

### Combat Simulations (6 tests)
- ✅ **Rapid Afflictions**: Simulates high-frequency affliction tracking
- ✅ **GMCP Updates**: Simulates rapid game data updates
- ✅ **High-Frequency Combat**: Tests 1000+ events/second throughput
- ✅ **Memory Management**: Tests memory usage under load
- ✅ **Multiple Responders**: Tests multiple handlers for same query
- ✅ **Complex Event Flow**: Tests multi-step event sequences

## Running Tests

### In Mudlet Console

#### Run All Tests
```lua
lua dofile(getMudletHomeDir().."/achaea/run_core_tests.lua")
```

#### Run Quick Tests (development)
```lua
lua dofile(getMudletHomeDir().."/achaea/tests/test_emerge_core.lua").quick()
```

#### Run Full Test Suite
```lua
lua dofile(getMudletHomeDir().."/achaea/tests/test_emerge_core.lua").run_all()
```

#### Run Individual Test
```lua
local tests = dofile(getMudletHomeDir().."/achaea/tests/test_emerge_core.lua")
local success, result = pcall(tests.basic_event_emission)
echo(result)
```

### Command Line (if using Lua outside Mudlet)
```bash
lua run_core_tests.lua
lua run_core_tests.lua quick
```

## Test Configuration

Edit the configuration at the top of `test_emerge_core.lua`:

```lua
local config = {
    verbose = false,           -- Enable detailed output
    timeout = 5,               -- Test timeout in seconds
    performance_threshold = 0.001  -- Performance threshold (1ms)
}
```

## Performance Benchmarks

The tests validate these performance standards:

- **Event Throughput**: > 1,000 events/second
- **Handler Response**: < 1ms average (warning threshold)
- **Memory Growth**: < 5MB for 1,000 events
- **Error Recovery**: < 5% error rate acceptable
- **History Buffer**: Bounded to 100 entries

## Expected Output

### Successful Test Run
```
================================================================================
                     EMERGE CORE EVENT SYSTEM TEST SUITE
================================================================================

Running: module_loading...           PASS (0.001s)
Running: basic_event_emission...     PASS (0.002s)
Running: handler_management...       PASS (0.001s)
...
Running: complex_event_flow...       PASS (0.005s)

================================================================================
                            TEST RESULTS SUMMARY
================================================================================
Total Tests:     23
Passed:          23
Failed:          0
Success Rate:    100.0%
Total Time:      0.156 seconds

PERFORMANCE METRICS:
• Events Processed:   1500
• Handlers Executed:  2000
• Errors Caught:      5
• Avg Handler Time:   0.0003 ms
• Peak Handler Time:  0.0015 ms

🎉 ALL TESTS PASSED! 🎉
```

### Failed Test Example
```
Running: basic_event_emission...     FAIL (0.002s)
   └─ Event handler was not called

FAILED TESTS:
• basic_event_emission: Event handler was not called
```

## Troubleshooting

### Common Issues

**"Module not found"**
- Ensure `emerge-core.lua` is in `/modules/required/`
- Check that EMERGE system is initialized

**"Handler not called"**
- Mock functions may need adjustment for your Mudlet version
- Check debug output with `config.verbose = true`

**"Performance test failed"**
- System may be under load during testing
- Adjust `performance_threshold` if needed

**"Memory test failed"**
- Other scripts may be consuming memory
- Run tests in clean Mudlet session

### Debug Mode

Enable verbose output for detailed debugging:

```lua
local tests = dofile(getMudletHomeDir().."/achaea/tests/test_emerge_core.lua")
-- Edit config.verbose = true in the file, or:
tests.config = {verbose = true, timeout = 10}
tests.run_all()
```

## Test Development

### Adding New Tests

1. Add test function to `test` table:
```lua
function test.my_new_test()
    setup()
    
    -- Test logic here
    assert(condition, "Error message")
    
    teardown()
    return true, "Success message"
end
```

2. Add test name to `test_order` in `run_all()`

3. Follow the setup/teardown pattern for consistency

### Test Helper Functions

- `setup()` - Reset environment before test
- `teardown()` - Clean up after test  
- `capture_events(pattern, max)` - Capture emitted events
- `wait_for_condition(func, timeout)` - Wait for async conditions
- `mock_mudlet_functions()` - Mock Mudlet APIs for testing

## Integration with CI/CD

These tests can be integrated into automated workflows:

```lua
-- Exit code for automation
local results = dofile("tests/test_emerge_core.lua").run_all()
os.exit(results.failed == 0 and 0 or 1)
```

## Contributing

When modifying emerge-core.lua:

1. **Run tests first** - Ensure existing functionality works
2. **Add tests for new features** - Maintain test coverage
3. **Update performance baselines** - If adding overhead
4. **Test error conditions** - Ensure graceful failure
5. **Validate event contracts** - Check event name patterns

## Test Philosophy

These tests follow EMERGE principles:

- **Event-Driven Testing**: Tests communicate via events, not direct calls
- **Error Isolation**: Handler errors don't break other handlers  
- **Performance First**: Validate performance requirements
- **Real-World Scenarios**: Test actual combat situations
- **Architectural Compliance**: Ensure modules follow EMERGE patterns

The goal is to ensure the core event system is rock-solid, performant, and ready to support complex combat scenarios with confidence.