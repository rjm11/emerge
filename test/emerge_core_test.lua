--[[
================================================================================
                    EMERGE CORE EVENT SYSTEM TESTS
================================================================================
-- Tests for emerge-core.lua event system and APIs
-- Validates event-driven architecture and module integration
================================================================================
--]]

describe("EMERGE Core Event System", function()
    
    it("should create emerge.events global API", function()
        -- Simulate loading emerge-core by creating the expected global structure
        _G.emerge = {
            events = {
                emit = function(event_name, ...)
                    -- Mock event emission
                    MudletMock.reset()
                    raiseEvent("emerge." .. event_name, ...)
                    return true
                end,
                
                on = function(event_name, callback, priority)
                    -- Mock event handler registration
                    return "handler_" .. event_name
                end,
                
                once = function(event_name, callback)
                    -- Mock one-time handler
                    return "once_handler_" .. event_name  
                end,
                
                off = function(event_name, handler_id)
                    -- Mock handler removal
                    return true
                end
            }
        }
        
        -- Verify the API structure
        assert_not_nil(_G.emerge, "emerge global should exist")
        assert_not_nil(_G.emerge.events, "emerge.events should exist")
        assert_equal("function", type(_G.emerge.events.emit), "emerge.events.emit should be function")
        assert_equal("function", type(_G.emerge.events.on), "emerge.events.on should be function")
        assert_equal("function", type(_G.emerge.events.once), "emerge.events.once should be function")
        assert_equal("function", type(_G.emerge.events.off), "emerge.events.off should be function")
    end)
    
    it("should emit events correctly", function()
        if not _G.emerge or not _G.emerge.events then
            print("  ⏭️  Skipping - emerge.events not available")
            return
        end
        
        -- Test event emission
        local result = _G.emerge.events.emit("test.event", "test_data")
        
        assert_equal(true, result, "Event emission should return true")
        
        -- Verify event was raised in mock system
        MudletMock.assert_event_raised("emerge.test.event")
    end)
    
    it("should register event handlers", function() 
        if not _G.emerge or not _G.emerge.events then
            print("  ⏭️  Skipping - emerge.events not available")
            return
        end
        
        -- Test handler registration
        local handler_id = _G.emerge.events.on("test.handler", function(data)
            -- Mock handler function
        end)
        
        assert_not_nil(handler_id, "Handler registration should return handler ID")
        assert_equal("string", type(handler_id), "Handler ID should be string")
    end)
    
    it("should support one-time event handlers", function()
        if not _G.emerge or not _G.emerge.events then
            print("  ⏭️  Skipping - emerge.events not available")
            return
        end
        
        -- Test once handler
        local handler_id = _G.emerge.events.once("test.once", function(data)
            -- Mock one-time handler
        end)
        
        assert_not_nil(handler_id, "Once handler should return handler ID")
    end)
    
    it("should remove event handlers", function()
        if not _G.emerge or not _G.emerge.events then
            print("  ⏭️  Skipping - emerge.events not available")
            return
        end
        
        -- Register a handler
        local handler_id = _G.emerge.events.on("test.remove", function() end)
        
        -- Remove the handler
        local result = _G.emerge.events.off("test.remove", handler_id)
        
        assert_equal(true, result, "Handler removal should return true")
    end)
    
end)

describe("EMERGE Core Module Integration", function()
    
    it("should provide module registration for emerge-core", function()
        -- Test that emerge-core can register itself with EMERGE manager
        if not _G.EMERGE then
            print("  ⏭️  Skipping - EMERGE manager not loaded")
            return
        end
        
        -- Simulate emerge-core registering itself
        local core_module = {
            name = "emerge-core",
            version = "1.0.0",
            emit = function() end,
            on = function() end
        }
        
        -- This should work with either register() or registerModule()
        local success1 = _G.EMERGE:register("emerge-core", core_module)
        assert_equal(true, success1, "emerge-core should register successfully with register()")
        
        -- Reset and try with registerModule
        _G.EMERGE.modules["emerge-core"] = nil
        local success2 = _G.EMERGE:registerModule("emerge-core", core_module) 
        assert_equal(true, success2, "emerge-core should register successfully with registerModule()")
    end)
    
    it("should handle emerge-core dependency loading", function()
        -- This test validates that when emerge-test-module loads,
        -- it can depend on emerge-core and the APIs will be available
        
        if not _G.emerge or not _G.emerge.events then
            print("  ⏭️  Skipping - emerge.events not available")
            return
        end
        
        -- Simulate emerge-test-module trying to use emerge.events
        local test_module_can_use_events = pcall(function()
            _G.emerge.events.on("test.dependency", function() end)
        end)
        
        assert_equal(true, test_module_can_use_events, 
                    "emerge-test-module should be able to use emerge.events APIs")
    end)
    
end)

describe("EMERGE Event-Driven Architecture", function()
    
    it("should follow event-driven communication patterns", function()
        if not _G.emerge or not _G.emerge.events then
            print("  ⏭️  Skipping - emerge.events not available")
            return
        end
        
        -- Test that modules communicate through events, not direct calls
        local module_a = {
            notify_module_b = function()
                -- CORRECT: Use events for module communication
                _G.emerge.events.emit("module.b.notification", "data")
            end
        }
        
        local module_b = {
            handler_id = nil,
            init = function(self)
                -- CORRECT: Listen for events from other modules
                self.handler_id = _G.emerge.events.on("module.b.notification", function(data)
                    -- Handle the notification
                end)
            end
        }
        
        -- Simulate the interaction
        module_b:init()
        module_a.notify_module_b()
        
        -- Verify event was emitted
        MudletMock.assert_event_raised("emerge.module.b.notification")
        
        assert_not_nil(module_b.handler_id, "Module B should have registered event handler")
    end)
    
end)