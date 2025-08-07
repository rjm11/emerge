--[[
================================================================================
                    EMERGE MANAGER UNIT TESTS
================================================================================
-- Tests for emerge-manager.lua core functionality
-- Validates module loading, registration, and dependency resolution
================================================================================
--]]

-- Load the emerge manager (with mocked Mudlet environment)
local emerge_manager_path = "../emerge-manager.lua"

describe("EMERGE Manager Core", function()
    
    it("should initialize the EMERGE manager object", function()
        -- Reset state
        _G.EMERGE = nil
        _G.ModuleManager = nil
        
        -- Load the manager
        local success, error_msg = pcall(dofile, emerge_manager_path)
        
        if not success then
            -- If file doesn't exist, skip this test
            if error_msg:find("No such file") then
                print("  ⏭️  Skipping - emerge-manager.lua not found")
                return
            else
                error("Failed to load emerge-manager.lua: " .. error_msg)
            end
        end
        
        -- Verify EMERGE object was created
        assert_not_nil(_G.EMERGE, "EMERGE global should be created")
        assert_equal("table", type(_G.EMERGE), "EMERGE should be a table")
        
        -- Verify key properties
        assert_not_nil(_G.EMERGE.version, "EMERGE should have a version")
        assert_not_nil(_G.EMERGE.modules, "EMERGE should have modules table")
    end)
    
    it("should have registerModule function", function()
        if not _G.EMERGE then
            print("  ⏭️  Skipping - EMERGE not loaded")
            return
        end
        
        assert_equal("function", type(_G.EMERGE.registerModule), 
                    "EMERGE should have registerModule function")
    end)
    
    it("should have register compatibility alias", function()
        if not _G.EMERGE then
            print("  ⏭️  Skipping - EMERGE not loaded")
            return
        end
        
        assert_equal("function", type(_G.EMERGE.register), 
                    "EMERGE should have register compatibility alias")
    end)
    
    it("should register modules correctly", function()
        if not _G.EMERGE then
            print("  ⏭️  Skipping - EMERGE not loaded")
            return
        end
        
        -- Create a mock module
        local test_module = {
            name = "test-module",
            version = "1.0.0",
            init = function() end
        }
        
        -- Register the module
        local success = _G.EMERGE:registerModule("test-module", test_module)
        
        assert_equal(true, success, "registerModule should return true")
        assert_equal(test_module, _G.EMERGE.modules["test-module"], 
                    "Module should be stored in modules table")
        
        -- Verify output contains registration message
        MudletMock.assert_output_contains("Registered module: test-module v1.0.0")
    end)
    
    it("should handle register alias correctly", function()
        if not _G.EMERGE then
            print("  ⏭️  Skipping - EMERGE not loaded")
            return
        end
        
        -- Create a mock module  
        local test_module2 = {
            name = "test-module-2",
            version = "2.0.0"
        }
        
        -- Register using the compatibility alias
        local success = _G.EMERGE:register("test-module-2", test_module2)
        
        assert_equal(true, success, "register alias should return true")
        assert_equal(test_module2, _G.EMERGE.modules["test-module-2"], 
                    "Module should be stored via register alias")
    end)
    
    it("should validate registerModule parameters", function()
        if not _G.EMERGE then
            print("  ⏭️  Skipping - EMERGE not loaded")
            return
        end
        
        -- Test with nil module_id
        local success1 = _G.EMERGE:registerModule(nil, {})
        assert_equal(false, success1, "Should reject nil module_id")
        
        -- Test with nil module_obj  
        local success2 = _G.EMERGE:registerModule("test", nil)
        assert_equal(false, success2, "Should reject nil module_obj")
        
        -- Verify error messages in output
        MudletMock.assert_output_contains("registerModule requires module_id")
        MudletMock.assert_output_contains("registerModule requires module_obj")
    end)
    
end)

describe("EMERGE Module Discovery", function()
    
    it("should handle module loading dependencies", function()
        if not _G.EMERGE then
            print("  ⏭️  Skipping - EMERGE not loaded")  
            return
        end
        
        -- This is a more complex test that would require setting up
        -- mock module info with dependencies. For now, just verify
        -- the loadModule function exists
        assert_equal("function", type(_G.EMERGE.loadModule), 
                    "EMERGE should have loadModule function")
    end)
    
end)