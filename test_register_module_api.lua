-- Test script for the registerModule API
-- This demonstrates how modules can register themselves using EMERGE:registerModule()

-- First, let's create a sample module object
local TestModule = {
    version = "1.0.0",
    name = "test-module",
    description = "A test module to verify registerModule API",
    
    init = function(self)
        print("TestModule initialized!")
    end,
    
    unload = function(self)
        print("TestModule unloaded!")
    end,
    
    doSomething = function(self, message)
        print("TestModule says: " .. tostring(message))
    end
}

-- Test the registerModule API
print("Testing EMERGE:registerModule() API...")

-- This would previously fail with "attempt to call method 'registerModule' (a nil value)"
-- Now it should work:
local success = EMERGE:registerModule("test-module", TestModule)

if success then
    print("✓ Module registered successfully!")
    
    -- Verify it's actually stored
    local stored_module = EMERGE.modules["test-module"]
    if stored_module then
        print("✓ Module found in EMERGE.modules")
        
        -- Test calling a method on the stored module
        stored_module:doSomething("Hello from registered module!")
        
        -- Test unloading
        print("Testing unload...")
        EMERGE:unloadModule("test-module")
        
        -- Verify it's removed
        if not EMERGE.modules["test-module"] then
            print("✓ Module successfully unloaded")
        else
            print("✗ Module still present after unload")
        end
    else
        print("✗ Module not found in EMERGE.modules")
    end
else
    print("✗ Failed to register module")
end

print("Test complete!")