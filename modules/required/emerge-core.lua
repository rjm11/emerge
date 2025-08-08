--[[
================================================================================
                EMERGE SYSTEM - CORE EVENT ENGINE MODULE
================================================================================
-- Description: Foundational event system that all EMERGE modules depend on
-- Author: EMERGE-Coder Agent  
-- Version: 1.0.0
--
-- Key Features:
--   - Enhanced event system wrapping Mudlet's raiseEvent()
--   - Request/response patterns for module queries
--   - Event batching for high-frequency updates
--   - Error boundaries preventing handler failures
--   - Performance monitoring and debugging
--   - Event history tracking (circular buffer)
--   - Subscription system for live updates
--
-- Events Emitted:
--   - emerge.system.core.ready: Core event system initialized
--   - emerge.system.performance.warning: Performance threshold exceeded
--   - emerge.system.error.handler: Event handler failed
--   - emerge.response.*: All query responses
--
-- Events Consumed:
--   - emerge.query.*: Module queries requiring responses
--   - emerge.subscribe.*: Subscription requests
--   - emerge.unsubscribe.*: Unsubscription requests
================================================================================
--]]

-- Module constants
local MODULE_NAME = "emerge-core"
local MODULE_VERSION = "1.0.0"
local MODULE_AUTHOR = "EMERGE-Coder Agent"
local MODULE_DESCRIPTION = "Core event system for EMERGE framework"

-- Performance thresholds
local PERFORMANCE = {
    MAX_HANDLER_TIME = 0.001, -- 1ms warning threshold
    MAX_BATCH_SIZE = 100,     -- Maximum events per batch
    MAX_HISTORY = 100,        -- Circular buffer size
    BATCH_TIMEOUT = 0.1       -- Batch processing delay in seconds
}

-- Core module table
local Core = {
    name = MODULE_NAME,
    version = MODULE_VERSION,
    author = MODULE_AUTHOR,
    description = MODULE_DESCRIPTION,
    
    enabled = true,
    debug = false,
    
    -- Component tracking
    aliases = {},
    timers = {},
    handlers = {},
    
    -- Event system state
    history = {},
    history_index = 1,
    performance_stats = {
        events_processed = 0,
        handlers_executed = 0,
        errors_caught = 0,
        average_handler_time = 0,
        peak_handler_time = 0
    },
    
    -- Batching system
    batch_queue = {},
    batch_timer = nil,
    
    -- Subscription tracking
    subscriptions = {},
    
    -- Request/response tracking
    pending_requests = {},
    request_timeout = 5.0, -- Default timeout in seconds
    
    -- Error boundaries
    error_recovery = true,

    -- Capabilities registry
    capabilities = {
        provided = {}, -- name -> { version=string, module=string }
    },

    -- Config registry and values
    config = {
        schemas = {},   -- namespace -> schema table
        values = {},    -- key -> value
        secrets = {},   -- key -> redacted storage
    },

    -- Debounce state
    _debounce = {}     -- handler_id -> { timer, last_args }
}

-- Private helper functions
local function log_debug(message, ...)
    if Core.debug then
        cecho(string.format("<DimGrey>[CORE-DEBUG] %s<reset>\n", 
            string.format(message, ...)))
    end
end

local function log_error(message, ...)
    cecho(string.format("<IndianRed>[CORE-ERROR] %s<reset>\n", 
        string.format(message, ...)))
end

local function log_warning(message, ...)
    cecho(string.format("<orange>[CORE-WARN] %s<reset>\n", 
        string.format(message, ...)))
end

local function get_time_ms()
    -- High precision timing for performance monitoring
    return (socket and socket.gettime() or os.clock()) * 1000
end

local function add_to_history(event_name, args, handler_count, processing_time)
    local entry = {
        timestamp = os.time(),
        event = event_name,
        args = args and table.deepcopy(args) or {},
        handler_count = handler_count or 0,
        processing_time = processing_time or 0,
        ms_timestamp = get_time_ms()
    }
    
    -- Circular buffer implementation
    Core.history[Core.history_index] = entry
    Core.history_index = (Core.history_index % PERFORMANCE.MAX_HISTORY) + 1
    
    log_debug("History: %s (handlers: %d, time: %.3fms)", 
        event_name, handler_count, processing_time)
end

local function update_performance_stats(processing_time)
    local stats = Core.performance_stats
    stats.events_processed = stats.events_processed + 1
    stats.handlers_executed = stats.handlers_executed + 1
    
    -- Update timing statistics
    local total_time = stats.average_handler_time * (stats.handlers_executed - 1) + processing_time
    stats.average_handler_time = total_time / stats.handlers_executed
    
    if processing_time > stats.peak_handler_time then
        stats.peak_handler_time = processing_time
    end
    
    -- Performance warning
    if processing_time > PERFORMANCE.MAX_HANDLER_TIME then
        log_warning("Handler exceeded performance threshold: %.3fms > %.3fms", 
            processing_time, PERFORMANCE.MAX_HANDLER_TIME)
        Core:emit("emerge.system.performance.warning", {
            processing_time = processing_time,
            threshold = PERFORMANCE.MAX_HANDLER_TIME,
            timestamp = os.time()
        })
    end
end

local function generate_request_id()
    return "req_" .. os.time() .. "_" .. math.random(1000, 9999)
end

-- Core event system implementation

function Core:emit(event_name, ...)
    if not event_name then
        log_error("emit() called with nil event name")
        return false
    end
    
    local start_time = get_time_ms()
    local args = {...}
    local handler_count = 0
    
    log_debug("Emitting: %s", event_name)
    
    -- Wrap Mudlet's raiseEvent with error boundary
    local success, result = pcall(function()
        -- Check for subscriptions first
        for pattern, subscribers in pairs(Core.subscriptions) do
            if event_name:match(pattern) then
                for module_name, callback in pairs(subscribers) do
                    handler_count = handler_count + 1
                    if type(callback) == "function" then
                        local callback_success, callback_error = pcall(callback, event_name, ...)
                        if not callback_success and Core.error_recovery then
                            log_error("Subscription callback failed for %s: %s", 
                                module_name, callback_error)
                            Core:emit("emerge.system.error.handler", {
                                module = module_name,
                                event = event_name,
                                error = callback_error,
                                timestamp = os.time()
                            })
                        end
                    end
                end
            end
        end
        
        -- Emit to Mudlet's event system
        raiseEvent(event_name, ...)
        return true
    end)
    
    if not success and Core.error_recovery then
        log_error("Event emission failed for %s: %s", event_name, result)
        Core.performance_stats.errors_caught = Core.performance_stats.errors_caught + 1
    end
    
    local processing_time = get_time_ms() - start_time
    
    -- Update statistics and history
    add_to_history(event_name, args, handler_count, processing_time)
    update_performance_stats(processing_time)
    
    return success
end

function Core:on(event_name, callback, priority)
    if not event_name or not callback then
        log_error("on() called with invalid parameters")
        return nil
    end
    
    priority = priority or 0
    
    -- Use Mudlet's registerAnonymousEventHandler with error boundary
    local handler_id = registerAnonymousEventHandler(event_name, function(...)
        local start_time = get_time_ms()
        local success, result = pcall(callback, ...)
        
        if not success and Core.error_recovery then
            log_error("Event handler failed for %s: %s", event_name, result)
            Core.performance_stats.errors_caught = Core.performance_stats.errors_caught + 1
            Core:emit("emerge.system.error.handler", {
                event = event_name,
                error = result,
                timestamp = os.time()
            })
        end
        
        local processing_time = get_time_ms() - start_time
        update_performance_stats(processing_time)
    end)
    
    log_debug("Registered handler for: %s (ID: %s)", event_name, handler_id)
    return handler_id
end

function Core:once(event_name, callback)
    if not event_name or not callback then
        log_error("once() called with invalid parameters")
        return nil
    end
    
    local handler_id = nil
    handler_id = self:on(event_name, function(...)
        callback(...)
        if handler_id then
            killAnonymousEventHandler(handler_id)
        end
    end)
    
    return handler_id
end

function Core:off(event_name, handler_id)
    if handler_id then
        killAnonymousEventHandler(handler_id)
        log_debug("Removed handler %s for event: %s", handler_id, event_name)
        return true
    end
    return false
end

-- Debounced handler registration (milliseconds)
function Core:debounce(event_name, callback, ms)
    if not event_name or not callback or not ms then
        log_error("debounce() called with invalid parameters")
        return nil
    end
    local handler_id
    handler_id = self:on(event_name, function(...)
        local entry = Core._debounce[handler_id] or {}
        entry.last_args = { ... }
        -- Cancel previous timer
        if entry.timer then
            pcall(killTimer, entry.timer)
        end
        -- Create new timer
        entry.timer = tempTimer((ms / 1000), function()
            local args = entry.last_args or {}
            local ok, err = pcall(function()
                callback(unpack(args))
            end)
            if not ok then
                log_error("Debounced handler failed for %s: %s", event_name, err)
                Core:emit("emerge.module.error", {
                    module = MODULE_NAME,
                    event = event_name,
                    error = tostring(err)
                })
            end
        end)
        Core._debounce[handler_id] = entry
    end)
    return handler_id
end

-- Simple semver parsing for capabilities
local function parse_semver(v)
    if not v then return {0,0,0} end
    local a,b,c = tostring(v):match("^(%d+)%.?(%d*)%.?(%d*)$")
    return { tonumber(a) or 0, tonumber(b) or 0, tonumber(c) or 0 }
end

local function cmp_semver(v1, v2)
    local a1,a2,a3 = table.unpack(parse_semver(v1))
    local b1,b2,b3 = table.unpack(parse_semver(v2))
    if a1 ~= b1 then return a1 > b1 and 1 or -1 end
    if a2 ~= b2 then return a2 > b2 and 1 or -1 end
    if a3 ~= b3 then return a3 > b3 and 1 or -1 end
    return 0
end

-- Capabilities API
function Core:cap_provide(name, info)
    if not name or type(info) ~= 'table' then return false end
    Core.capabilities.provided[name] = {
        version = info.version or "1.0.0",
        module = info.module or MODULE_NAME
    }
    return true
end

function Core:cap_has(name, range)
    local p = Core.capabilities.provided[name]
    if not p then return false end
    if not range or range == "" then return true end
    -- Support ">=x.y.z" only for now, or exact match
    local ge = tostring(range):match("^>=([%d%.]+)$")
    if ge then return cmp_semver(p.version, ge) >= 0 end
    return cmp_semver(p.version, range) == 0
end

function Core:cap_require(name, range)
    local ok = self:cap_has(name, range)
    if not ok then
        local msg = string.format("Missing capability %s (need %s)", name, tostring(range or "any"))
        log_warning(msg)
        Core:emit("emerge.module.error", {
            module = MODULE_NAME,
            event = "capability.missing",
            error = msg
        })
    end
    return ok
end

-- Config API
local function redact(value)
    if value == nil then return nil end
    return "••••"
end

local function validate_value(rule, value)
    if not rule then return true, nil end
    local t = rule.type
    if t == 'string' then
        if type(value) ~= 'string' then return false, 'expected string' end
        if rule.enum then
            local ok = false
            for _, v in ipairs(rule.enum) do if v == value then ok = true break end end
            if not ok then return false, 'invalid enum' end
        end
    elseif t == 'number' or t == 'integer' then
        if type(value) ~= 'number' then return false, 'expected number' end
        if t == 'integer' and math.floor(value) ~= value then return false, 'expected integer' end
        if rule.min and value < rule.min then return false, 'below min' end
        if rule.max and value > rule.max then return false, 'above max' end
    elseif t == 'boolean' then
        if type(value) ~= 'boolean' then return false, 'expected boolean' end
    elseif t == 'secret' then
        if type(value) ~= 'string' then return false, 'expected string (secret)' end
    end
    return true, nil
end

function Core:config_register(namespace, spec)
    if not namespace or type(spec) ~= 'table' then return false end
    Core.config.schemas[namespace] = spec.schema or {}
    -- Initialize defaults
    for key, rule in pairs(Core.config.schemas[namespace]) do
        local full = namespace .. "." .. key
        if rule.default ~= nil and Core.config.values[full] == nil then
            if rule.type == 'secret' then
                Core.config.secrets[full] = tostring(rule.default)
            else
                Core.config.values[full] = rule.default
            end
        end
    end
    return true
end

function Core:config_get(key, default)
    if Core.config.values[key] ~= nil then return Core.config.values[key] end
    if Core.config.secrets[key] ~= nil then return Core.config.secrets[key] end
    return default
end

function Core:config_set(key, value)
    if type(key) ~= 'string' then return false, 'invalid key' end
    local ns, k = key:match("^([%w%._%-]+)/?([%w%._%-]*)$")
    -- Accept keys like 'ns.key' or 'ns/sub.key'; normalize to dot
    key = key:gsub('/', '.')
    ns = key:match("^([%w%._%-]+)%.")
    if not ns then return false, 'key must be namespaced (ns.key)' end
    local schema = Core.config.schemas[ns]
    local leaf = key:match("%.(.+)$")
    local rule = schema and schema[leaf] or nil
    local ok, err = validate_value(rule, value)
    if not ok then return false, err end
    local old
    if rule and rule.type == 'secret' then
        old = Core.config.secrets[key]
        Core.config.secrets[key] = tostring(value)
    else
        old = Core.config.values[key]
        Core.config.values[key] = value
    end
    Core:emit('emerge.config.changed', {
        key = key,
        old = (rule and rule.type == 'secret') and redact(old) or old,
        new = (rule and rule.type == 'secret') and redact(value) or value
    })
    return true
end

-- Request/Response pattern implementation

function Core:request(query_pattern, data, callback, timeout)
    if not query_pattern or not callback then
        log_error("request() called with invalid parameters")
        return nil
    end
    
    timeout = timeout or Core.request_timeout
    local request_id = generate_request_id()
    
    -- Set up response handler
    local response_pattern = query_pattern:gsub("^emerge%.query%.", "emerge.response.")
    local response_handler = self:once(response_pattern, function(event_name, req_id, ...)
        if req_id == request_id then
            -- Clear timeout timer
            if Core.pending_requests[request_id] then
                if Core.pending_requests[request_id].timeout_timer then
                    killTimer(Core.pending_requests[request_id].timeout_timer)
                end
                Core.pending_requests[request_id] = nil
            end
            
            callback(...)
        end
    end)
    
    -- Set up timeout
    local timeout_timer = tempTimer(timeout, function()
        if Core.pending_requests[request_id] then
            Core.pending_requests[request_id] = nil
            if response_handler then
                killAnonymousEventHandler(response_handler)
            end
            log_warning("Request timeout: %s", query_pattern)
            callback(nil, "timeout")
        end
    end)
    
    -- Track the request
    Core.pending_requests[request_id] = {
        pattern = query_pattern,
        callback = callback,
        timeout_timer = timeout_timer,
        timestamp = os.time()
    }
    
    -- Emit the query
    self:emit(query_pattern, request_id, data)
    
    log_debug("Request sent: %s (ID: %s)", query_pattern, request_id)
    return request_id
end

function Core:respond(query_pattern, handler)
    if not query_pattern or not handler then
        log_error("respond() called with invalid parameters")
        return nil
    end
    
    local response_pattern = query_pattern:gsub("^emerge%.query%.", "emerge.response.")
    
    return self:on(query_pattern, function(event_name, request_id, data)
        local success, result = pcall(handler, data)
        if success then
            self:emit(response_pattern, request_id, result)
        else
            log_error("Response handler failed for %s: %s", query_pattern, result)
            self:emit(response_pattern, request_id, nil, "handler_error")
        end
    end)
end

-- Subscription system implementation

function Core:subscribe(pattern, module_name, callback)
    if not pattern or not module_name or not callback then
        log_error("subscribe() called with invalid parameters")
        return false
    end
    
    if not Core.subscriptions[pattern] then
        Core.subscriptions[pattern] = {}
    end
    
    Core.subscriptions[pattern][module_name] = callback
    log_debug("Subscription added: %s -> %s", pattern, module_name)
    
    return true
end

function Core:unsubscribe(pattern, module_name)
    if not pattern or not module_name then
        log_error("unsubscribe() called with invalid parameters")
        return false
    end
    
    if Core.subscriptions[pattern] and Core.subscriptions[pattern][module_name] then
        Core.subscriptions[pattern][module_name] = nil
        
        -- Clean up empty pattern
        if not next(Core.subscriptions[pattern]) then
            Core.subscriptions[pattern] = nil
        end
        
        log_debug("Subscription removed: %s -> %s", pattern, module_name)
        return true
    end
    
    return false
end

-- Event batching system

function Core:batch_emit(events)
    if not events or type(events) ~= "table" then
        log_error("batch_emit() called with invalid events table")
        return false
    end
    
    if #events > PERFORMANCE.MAX_BATCH_SIZE then
        log_warning("Batch size exceeds maximum: %d > %d", 
            #events, PERFORMANCE.MAX_BATCH_SIZE)
    end
    
    local start_time = get_time_ms()
    local processed = 0
    
    for _, event_data in ipairs(events) do
        if type(event_data) == "table" and event_data.event then
            self:emit(event_data.event, unpack(event_data.args or {}))
            processed = processed + 1
        end
    end
    
    local total_time = get_time_ms() - start_time
    log_debug("Batch processed: %d events in %.3fms", processed, total_time)
    
    return processed
end

function Core:queue_batch_event(event_name, ...)
    if not event_name then
        return false
    end
    
    table.insert(Core.batch_queue, {
        event = event_name,
        args = {...},
        timestamp = get_time_ms()
    })
    
    -- Set up batch timer if not already running
    if not Core.batch_timer then
        Core.batch_timer = tempTimer(PERFORMANCE.BATCH_TIMEOUT, function()
            if #Core.batch_queue > 0 then
                Core:batch_emit(Core.batch_queue)
                Core.batch_queue = {}
            end
            Core.batch_timer = nil
        end)
    end
    
    return true
end

-- Debug and monitoring functions

function Core:history(count)
    count = math.min(count or 10, PERFORMANCE.MAX_HISTORY)
    local results = {}
    
    -- Get recent history (circular buffer aware)
    local start_index = math.max(1, Core.history_index - count)
    for i = start_index, Core.history_index - 1 do
        local index = ((i - 1) % PERFORMANCE.MAX_HISTORY) + 1
        if Core.history[index] then
            table.insert(results, Core.history[index])
        end
    end
    
    return results
end

function Core:stats()
    return table.deepcopy(Core.performance_stats)
end

function Core:debug(enabled)
    Core.debug = enabled
    log_debug("Debug mode %s", enabled and "enabled" or "disabled")
end

function Core:clear_history()
    Core.history = {}
    Core.history_index = 1
    log_debug("Event history cleared")
end

function Core:reset_stats()
    Core.performance_stats = {
        events_processed = 0,
        handlers_executed = 0,
        errors_caught = 0,
        average_handler_time = 0,
        peak_handler_time = 0
    }
    log_debug("Performance statistics reset")
end

-- Validation and health check functions

function Core:validate_event_name(event_name)
    if not event_name or type(event_name) ~= "string" then
        return false, "Event name must be a non-empty string"
    end
    
    if not event_name:match("^emerge%.[%w_]+%.[%w_]+") then
        return false, "Event name must follow pattern: emerge.module.action"
    end
    
    return true
end

function Core:health_check()
    local health = {
        status = "healthy",
        issues = {},
        metrics = {
            uptime = os.time() - (Core.start_time or os.time()),
            events_processed = Core.performance_stats.events_processed,
            error_rate = 0,
            average_handler_time = Core.performance_stats.average_handler_time,
            peak_handler_time = Core.performance_stats.peak_handler_time,
            pending_requests = table.size(Core.pending_requests),
            active_subscriptions = table.size(Core.subscriptions),
            batch_queue_size = #Core.batch_queue
        }
    }
    
    -- Calculate error rate
    if Core.performance_stats.handlers_executed > 0 then
        health.metrics.error_rate = 
            (Core.performance_stats.errors_caught / Core.performance_stats.handlers_executed) * 100
    end
    
    -- Check for issues
    if health.metrics.error_rate > 5.0 then
        table.insert(health.issues, "High error rate: " .. string.format("%.1f%%", health.metrics.error_rate))
    end
    
    if health.metrics.average_handler_time > PERFORMANCE.MAX_HANDLER_TIME then
        table.insert(health.issues, "Average handler time exceeds threshold")
    end
    
    if health.metrics.pending_requests > 50 then
        table.insert(health.issues, "High number of pending requests")
    end
    
    if #health.issues > 0 then
        health.status = "degraded"
    end
    
    return health
end

-- Module lifecycle functions

function Core:init()
    Core.start_time = os.time()
    
    -- Set up core system event handlers
    Core.handlers.query_stats = Core:on("emerge.query.system.stats", function(event, request_id)
        local stats = Core:stats()
        Core:emit("emerge.response.system.stats", request_id, stats)
    end)
    
    Core.handlers.query_health = Core:on("emerge.query.system.health", function(event, request_id)
        local health = Core:health_check()
        Core:emit("emerge.response.system.health", request_id, health)
    end)
    
    Core.handlers.query_history = Core:on("emerge.query.system.history", function(event, request_id, count)
        local history = Core:history(count)
        Core:emit("emerge.response.system.history", request_id, history)
    end)
    
    -- System management handlers
    Core.handlers.debug_toggle = Core:on("emerge.system.debug.toggle", function(event, enabled)
        Core:debug(enabled)
    end)
    
    Core.handlers.stats_reset = Core:on("emerge.system.stats.reset", function()
        Core:reset_stats()
    end)
    
    Core.handlers.history_clear = Core:on("emerge.system.history.clear", function()
        Core:clear_history()
    end)
    
    log_debug("Core event system initialized")
    
    -- Emit ready signal
    tempTimer(0.1, function()
        Core:emit("emerge.system.core.ready", {
            version = MODULE_VERSION,
            timestamp = os.time(),
            features = {
                "event_system",
                "request_response",
                "subscriptions", 
                "batching",
                "performance_monitoring",
                "error_boundaries",
                "event_history"
            }
        })
    end)
end

function Core:unload()
    -- Clear all handlers
    for _, handler_id in pairs(Core.handlers) do
        if handler_id then
            killAnonymousEventHandler(handler_id)
        end
    end
    
    -- Clear any running timers
    if Core.batch_timer then
        killTimer(Core.batch_timer)
        Core.batch_timer = nil
    end
    
    -- Clear pending request timeouts
    for request_id, request_data in pairs(Core.pending_requests) do
        if request_data.timeout_timer then
            killTimer(request_data.timeout_timer)
        end
    end
    
    -- Clear aliases
    for _, alias_id in pairs(Core.aliases) do
        if exists(alias_id, "alias") > 0 then
            killAlias(alias_id)
        end
    end
    
    -- Reset state
    Core.handlers = {}
    Core.aliases = {}
    Core.timers = {}
    Core.subscriptions = {}
    Core.pending_requests = {}
    Core.batch_queue = {}
    Core.history = {}
    Core.history_index = 1
    
    log_debug("Core event system unloaded")
end

-- Create debug aliases for testing
function Core:create_aliases()
    Core.aliases.debug_toggle = tempAlias("^emerge debug (on|off|true|false)$", [[
        local enabled = matches[2] == "on" or matches[2] == "true"
        emerge.core:debug(enabled)
    ]])
    
    Core.aliases.stats = tempAlias("^emerge stats$", [[
        local stats = emerge.core:stats()
        display(stats)
    ]])
    
    Core.aliases.history = tempAlias("^emerge history( %d+)?$", [[
        local count = matches[2] and tonumber(matches[2]) or 10
        local history = emerge.core:history(count)
        display(history)
    ]])
    
    Core.aliases.health = tempAlias("^emerge health$", [[
        local health = emerge.core:health_check()
        display(health)
    ]])
    
    Core.aliases.test_event = tempAlias("^emerge test event (.+)$", [[
        emerge.core:emit("emerge.test.event", matches[2])
        cecho("<green>Test event emitted: " .. matches[2] .. "<reset>\n")
    ]])
end

-- Integration with EMERGE module system
if EMERGE then
    -- Check if already loaded
    if EMERGE.modules[MODULE_NAME] then
        if EMERGE.modules[MODULE_NAME].unload then
            EMERGE.modules[MODULE_NAME]:unload()
        end
        EMERGE:unregister(MODULE_NAME)
    end
    
    -- Initialize the module
    Core:init()
    Core:create_aliases()
    
    -- Register with EMERGE manager
    EMERGE:register(MODULE_NAME, Core)
    
    -- Make available in global namespace for other modules
    emerge = emerge or {}
    emerge.core = Core
    emerge.events = {
        emit = function(...) return Core:emit(...) end,
        on = function(...) return Core:on(...) end,
        once = function(...) return Core:once(...) end,
        off = function(...) return Core:off(...) end,
        request = function(...) return Core:request(...) end,
        respond = function(...) return Core:respond(...) end,
        subscribe = function(...) return Core:subscribe(...) end,
        unsubscribe = function(...) return Core:unsubscribe(...) end,
        batch_emit = function(...) return Core:batch_emit(...) end,
        queue_batch_event = function(...) return Core:queue_batch_event(...) end,
        history = function(...) return Core:history(...) end,
        stats = function(...) return Core:stats(...) end,
        debug = function(...) return Core:debug(...) end,
        debounce = function(...) return Core:debounce(...) end
    }
    
    -- Expose capabilities and config APIs
    emerge.capabilities = {
        provide = function(...) return Core:cap_provide(...) end,
        require = function(...) return Core:cap_require(...) end,
        has = function(...) return Core:cap_has(...) end,
    }
    emerge.config = {
        register = function(...) return Core:config_register(...) end,
        get = function(...) return Core:config_get(...) end,
        set = function(...) return Core:config_set(...) end,
    }
    
    cecho(string.format("<LightSteelBlue>[%s] Core event system loaded v%s<reset>\n", 
        MODULE_NAME, MODULE_VERSION))
    cecho("<DimGrey>Available commands: emerge debug, emerge stats, emerge history, emerge health<reset>\n")
    
else
    cecho("<IndianRed>EMERGE system not found. Please install EMERGE manager first.<reset>\n")
    return nil
end

return Core
