-- EMERGE AI Module v0.5.1
-- Multi-provider AI assistant with conversation and roleplay capabilities
-- Supports Ollama, Groq, and OpenAI providers with complete alias-based interface

-- EMERGE module initialization
emerge = emerge or {}
emerge.ai = emerge.ai or {}
local module = emerge.ai

-- Module metadata
module.name = "emerge.ai"
module.version = "0.5.1"
module.description = "AI assistant module with multi-provider support"

-- Help data for EMERGE help system integration
module.help_data = {
    description = "Multi-provider AI assistant with conversation and roleplay capabilities",
    version = module.version,
    commands = {
        ["ait <message>"] = "Chat with AI assistant",
        ["aic <question>"] = "Ask AI about recent game context",
        ["arpt <mood>"] = "Generate roleplay emote with mood/action",
        ["arptc"] = "Copy last 150 lines to clipboard for roleplay context",
        ["ai recap"] = "Get a summary of recent activity",
        ["ai provider <name>"] = "Switch AI provider (ollama/groq/openai)",
        ["ai list"] = "List available AI models",
        ["ai use <model>"] = "Switch to specific AI model",
        ["ai apikey groq <key>"] = "Set Groq API key",
        ["ai apikey openai <key>"] = "Set OpenAI API key",
        ["ai apikey clear <provider>"] = "Clear API key for provider",
        ["ai reset"] = "Clear conversation memory",
        ["ai status"] = "Show current AI configuration",
        ["ai buffer <n>"] = "Set context buffer size (10-2000 lines)",
        ["ai debug on/off"] = "Toggle debug messages",
        ["ai prompt on/off"] = "Toggle prompt display after responses",
        ["ai help"] = "Display all AI commands",
        ["ai unload"] = "Completely unload the AI module"
    },
    events = {
        emitted = {
            ["emerge.ai.response.received"] = "Fired when AI assistant responds",
            ["emerge.ai.provider.error"] = "Fired when AI provider error occurs",
            ["emerge.ai.roleplay.generated"] = "Fired when roleplay emote is generated",
            ["system.module.loaded"] = "Fired when module loads successfully",
            ["system.module.unloaded"] = "Fired when module unloads"
        },
        consumed = {
            ["emerge.ai.command.quick_talk"] = "Quick AI chat command",
            ["emerge.ai.command.context_prompt"] = "Context-aware AI query",
            ["emerge.ai.command.roleplay"] = "Roleplay emote generation",
            ["emerge.ai.command.change_provider"] = "Provider switching",
            ["emerge.ai.command.set_api_key"] = "API key configuration",
            ["emerge.ai.command.*"] = "All AI command events from aliases"
        }
    }
}

-- Private state
local private = {
    aliases = {},
    handlers = {},
    active_requests = {},
    -- Request rate limiting
    rate_limit = {
        max_per_minute = 30,
        current_count = 0,
        window_start = os.time(),
        last_request = 0
    }
}

-- Provider configurations
local providers = {
    ollama = {
        name = "Ollama",
        api_base = "http://localhost:11434",
        default_model = "gpt-oss:20b",
        
        formatRequest = function(self, prompt, context, model)
            return {
                url = self.api_base .. "/api/generate",
                payload = {
                    model = model or self.default_model,
                    prompt = prompt,
                    stream = false,
                    context = context,
                    options = {
                        temperature = emerge.config.get("ai.temperature", 0.7),
                        num_predict = emerge.config.get("ai.max_tokens", 2048)
                    }
                }
            }
        end,
        
        parseResponse = function(self, data)
            if data.response then
                return data.response, data.context
            end
            return nil, nil
        end,
        
        listModels = function(self)
            return self.api_base .. "/api/tags"
        end,
        
        parseModels = function(self, data)
            if data and data.models then
                local models = {}
                for _, model in ipairs(data.models) do
                    table.insert(models, model.name)
                end
                return models
            end
            return {}
        end
    },
    
    groq = {
        name = "Groq",
        api_base = "https://api.groq.com/openai/v1",
        default_model = "llama-3.3-70b-versatile",
        
        formatRequest = function(self, prompt, context, model)
            local api_key = emerge.config.get("ai.api_keys.groq")
            if not api_key then
                error("Groq API key not configured. Use: ai apikey groq <your_key>")
            end
            
            local messages = {}
            
            -- Add system message if configured
            local system_prompt = emerge.config.get("ai.system_prompt")
            if system_prompt then
                table.insert(messages, {
                    role = "system",
                    content = system_prompt
                })
            end
            
            -- Add conversation history
            local history = emerge.state.get("ai.conversation_history", {})
            if #history > 0 then
                for i = math.max(1, #history - 5), #history do
                    local exchange = history[i]
                    if exchange.user_message then
                        table.insert(messages, {
                            role = "user",
                            content = exchange.user_message
                        })
                    end
                    if exchange.assistant_response then
                        table.insert(messages, {
                            role = "assistant", 
                            content = exchange.assistant_response
                        })
                    end
                end
            end
            
            -- Add current user message
            table.insert(messages, {
                role = "user",
                content = prompt
            })
            
            return {
                url = self.api_base .. "/chat/completions",
                headers = {
                    ["Authorization"] = "Bearer " .. api_key,
                    ["Content-Type"] = "application/json"
                },
                payload = {
                    model = model or self.default_model,
                    messages = messages,
                    temperature = emerge.config.get("ai.temperature", 0.7),
                    max_tokens = emerge.config.get("ai.max_tokens", 2048)
                }
            }
        end,
        
        parseResponse = function(self, data)
            if data.choices and data.choices[1] and data.choices[1].message then
                return data.choices[1].message.content, nil
            end
            return nil, nil
        end,
        
        listModels = function(self)
            return nil -- Static list
        end,
        
        parseModels = function(self, data)
            return {
                "llama-3.3-70b-versatile",
                "llama-3.1-70b-versatile", 
                "mixtral-8x7b-32768",
                "llama3-groq-70b-8192-tool-use-preview",
                "llama3-groq-8b-8192-tool-use-preview"
            }
        end
    },
    
    openai = {
        name = "OpenAI",
        api_base = "https://api.openai.com/v1", 
        default_model = "gpt-4o-mini",
        
        formatRequest = function(self, prompt, context, model)
            local api_key = emerge.config.get("ai.api_keys.openai")
            if not api_key then
                error("OpenAI API key not configured. Use: ai apikey openai <your_key>")
            end
            
            local messages = {}
            
            local system_prompt = emerge.config.get("ai.system_prompt")
            if system_prompt then
                table.insert(messages, {
                    role = "system",
                    content = system_prompt
                })
            end
            
            local history = emerge.state.get("ai.conversation_history", {})
            if #history > 0 then
                for i = math.max(1, #history - 5), #history do
                    local exchange = history[i]
                    if exchange.user_message then
                        table.insert(messages, {
                            role = "user",
                            content = exchange.user_message
                        })
                    end
                    if exchange.assistant_response then
                        table.insert(messages, {
                            role = "assistant",
                            content = exchange.assistant_response
                        })
                    end
                end
            end
            
            table.insert(messages, {
                role = "user",
                content = prompt
            })
            
            return {
                url = self.api_base .. "/chat/completions",
                headers = {
                    ["Authorization"] = "Bearer " .. api_key,
                    ["Content-Type"] = "application/json"
                },
                payload = {
                    model = model or self.default_model,
                    messages = messages,
                    temperature = emerge.config.get("ai.temperature", 0.7),
                    max_tokens = emerge.config.get("ai.max_tokens", 2048)
                }
            }
        end,
        
        parseResponse = function(self, data)
            if data.choices and data.choices[1] and data.choices[1].message then
                return data.choices[1].message.content, nil
            end
            return nil, nil
        end,
        
        listModels = function(self)
            local api_key = emerge.config.get("ai.api_keys.openai")
            if not api_key then
                return nil
            end
            return self.api_base .. "/models"
        end,
        
        parseModels = function(self, data)
            if data and data.data then
                local models = {}
                for _, model in ipairs(data.data) do
                    if model.id:match("^gpt") or model.id:match("^o3") then
                        table.insert(models, model.id)
                    end
                end
                return models
            end
            return {
                "gpt-4o-mini",
                "gpt-4o",
                "gpt-4-turbo", 
                "gpt-3.5-turbo",
                "o3-mini"
            }
        end
    }
}

-- Helper functions
local function log_debug(message)
    if emerge.config.get("ai.debug", false) then
        cecho(string.format("<dim>[AI Debug] %s<reset>\n", message))
    end
end

local function generate_request_id()
    return "ai_" .. os.time() .. "_" .. math.random(1000, 9999)
end

local function get_current_provider()
    local provider_name = emerge.config.get("ai.provider", "ollama")
    return providers[provider_name]
end

local function capture_buffer(lines)
    lines = lines or emerge.config.get("ai.buffer_lines", 200)
    
    local buffer = getLines(1, getLineCount())
    local start_line = math.max(1, #buffer - lines + 1)
    local recent_lines = {}
    
    for i = start_line, #buffer do
        local line = buffer[i]
        if line and line ~= "" then
            -- Strip ANSI codes for cleaner context
            line = string.gsub(line, "\27%[%d*;?%d*;?%d*;?%d*;?%d*m", "")
            table.insert(recent_lines, line)
        end
    end
    
    return table.concat(recent_lines, "\n")
end

local function manage_conversation_history(prompt, response)
    local history = emerge.state.get("ai.conversation_history", {})
    
    table.insert(history, {
        user_message = prompt,
        assistant_response = response,
        timestamp = os.time()
    })
    
    local max_history = emerge.config.get("ai.max_history_items", 15)
    if #history > max_history then
        local new_history = {}
        local start_index = #history - max_history + 1
        
        for i = start_index, #history do
            table.insert(new_history, history[i])
        end
        
        history = new_history
        log_debug("Trimmed conversation history to " .. max_history .. " items")
    end
    
    emerge.state.set("ai.conversation_history", history)
end

local function format_output(message, is_emote)
    local provider = get_current_provider()
    if is_emote then
        cecho("<magenta>(RP) " .. provider.name .. " says: EMOTE " .. message .. "<reset>\n")
    else
        cecho("<cyan>(AI) " .. provider.name .. " says, \"<reset>" .. message .. "<cyan>\"<reset>\n")
    end
    
    if emerge.config.get("ai.show_prompt", true) then
        tempTimer(0.1, function()
            send(" ", false)
        end)
    end
end

-- HTTP request handling
local function make_http_request(url, callback, options)
    options = options or {}
    local method = options.method or "GET"
    local headers = options.headers or {}
    local body = options.body or ""
    
    -- Check rate limiting
    local now = os.time()
    local rate_limit = private.rate_limit
    
    -- Reset window if a minute has passed
    if now - rate_limit.window_start >= 60 then
        rate_limit.window_start = now
        rate_limit.current_count = 0
    end
    
    -- Check if we've exceeded rate limit
    if rate_limit.current_count >= rate_limit.max_per_minute then
        local wait_time = 60 - (now - rate_limit.window_start)
        cecho(string.format("<yellow>(AI) Rate limit reached. Please wait %d seconds.<reset>\n", wait_time))
        emerge.events:emit("emerge.ai.provider.error", {
            type = "rate_limit",
            message = "Too many requests, please wait",
            wait_seconds = wait_time
        })
        if callback then
            callback(false, "Rate limit exceeded")
        end
        return
    end
    
    -- Update rate limit counters
    rate_limit.current_count = rate_limit.current_count + 1
    rate_limit.last_request = now
    
    local request_id = generate_request_id()
    private.active_requests[request_id] = {
        url = url,
        callback = callback,
        timestamp = os.time()
    }
    
    log_debug("Making " .. method .. " request to: " .. url)
    
    if method == "POST" then
        postHTTP(body, url, headers)
    else
        getHTTP(url, headers)
    end
    
    -- Clean up old requests after 60 seconds
    tempTimer(60, function()
        if private.active_requests[request_id] then
            private.active_requests[request_id] = nil
            log_debug("Cleaned up timed out request: " .. request_id)
        end
    end)
end

-- Event handlers
local function handle_http_success(event, url, response_body)
    log_debug("HTTP success for URL: " .. url)
    log_debug("Response body length: " .. #response_body)
    
    local request_data = nil
    for id, data in pairs(private.active_requests) do
        if data.url == url then
            request_data = data
            private.active_requests[id] = nil
            break
        end
    end
    
    if request_data and request_data.callback then
        request_data.callback(true, response_body)
    end
end

local function handle_http_error(event, response, url)
    log_debug("HTTP error for URL: " .. url)
    log_debug("Error: " .. tostring(response))
    
    local request_data = nil
    for id, data in pairs(private.active_requests) do
        if data.url == url then
            request_data = data
            private.active_requests[id] = nil
            break
        end
    end
    
    if request_data and request_data.callback then
        request_data.callback(false, response)
    end
end

-- Core AI functionality
local function send_prompt(prompt_text, is_context, original_prompt)
    local provider = get_current_provider()
    if not provider then
        emerge.events:emit("emerge.ai.provider.error", "Invalid provider configured")
        return
    end
    
    local model = emerge.config.get("ai.model")
    local context = emerge.state.get("ai.ollama_context", {})
    
    local ok, request_data = pcall(provider.formatRequest, provider, prompt_text, context, model)
    if not ok then
        emerge.events:emit("emerge.ai.provider.error", tostring(request_data))
        return
    end
    
    -- Encode request body
    local body
    ok, body = pcall(yajl.to_string, request_data.payload)
    if not ok then
        ok, body = pcall(json.encode, request_data.payload)
        if not ok then
            emerge.events:emit("emerge.ai.provider.error", "Failed to encode request")
            return
        end
    end
    
    -- Show thinking message for context commands
    if is_context then
        cecho("<yellow>(AI) " .. provider.name .. " analyzes the recent events...<reset>\n")
    end
    
    local headers = request_data.headers or { ["Content-Type"] = "application/json" }
    
    make_http_request(request_data.url, function(success, response_body)
        if not success then
            emerge.events:emit("emerge.ai.provider.error", tostring(response_body))
            return
        end
        
        -- Parse response
        local ok, data = pcall(yajl.to_value, response_body)
        if not ok then
            ok, data = pcall(json.decode, response_body)
            if not ok then
                emerge.events:emit("emerge.ai.provider.error", "Failed to decode response")
                return
            end
        end
        
        if data.error then
            emerge.events:emit("emerge.ai.provider.error", data.error)
            return
        end
        
        -- Parse provider-specific response
        local response, new_context = provider:parseResponse(data)
        
        if response then
            local expecting_emote = emerge.state.get("ai.expecting_emote", false)
            format_output(response, expecting_emote)
            
            -- Manage conversation history
            manage_conversation_history(original_prompt or prompt_text, response)
            
            -- Update Ollama-style context if provided
            if new_context then
                emerge.state.set("ai.ollama_context", new_context)
            end
            
            emerge.state.set("ai.last_prompt", prompt_text)
            emerge.state.set("ai.last_response", response)
            emerge.state.set("ai.expecting_emote", false)
            
            emerge.events:emit("emerge.ai.response.received", {
                prompt = original_prompt or prompt_text,
                response = response,
                provider = provider.name
            })
        else
            emerge.events:emit("emerge.ai.provider.error", "No response from AI")
        end
    end, {
        method = "POST",
        headers = headers,
        body = body
    })
end

-- Command handlers
local function handle_quick_talk(event, data)
    local message = data.message or data
    cecho("<white>(AI) Nyxalei says, \"" .. message .. "\"<reset>\n")
    if emerge.config.get("ai.show_prompt", true) then
        tempTimer(0.1, function() send(" ", false) end)
    end
    send_prompt(message, false, message)
end

local function handle_context_prompt(event, data)
    local question = data.question or data
    local context = capture_buffer()
    
    local full_prompt = string.format(
        "Here is the recent game output:\n\n%s\n\nBased on this context, %s\n\nBe helpful and conversational. Summarize relevant information naturally. If you truly can't find the answer, just say you didn't see that information. Keep responses concise.",
        context,
        question
    )
    
    cecho("<white>(AI) Nyxalei says, \"" .. question .. "\"<reset>\n")
    if emerge.config.get("ai.show_prompt", true) then
        tempTimer(0.1, function() send(" ", false) end)
    end
    send_prompt(full_prompt, true, question)
end

local function handle_roleplay_talk(event, data)
    local message = data.message or data
    local context = capture_buffer(emerge.config.get("ai.rp_buffer_lines", 15))
    
    -- Try to detect player names in context
    local detected_names = {}
    for name in context:gmatch("([A-Z][a-z]+)") do
        if #name > 2 and not name:match("^The$") and not name:match("^You$") then
            detected_names[name:lower()] = true
        end
    end
    
    -- Add detected names hint
    local name_hint = ""
    if next(detected_names) then
        local names = {}
        for name, _ in pairs(detected_names) do
            table.insert(names, "$" .. name)
        end
        name_hint = "\nCharacters present: " .. table.concat(names, ", ") .. " (use these exact formats in emote)"
    end
    
    local emote_context = emerge.config.get("ai.emote_context", [[Create ONE Achaea emote for Nyxalei, a mystical Sylvan fayad. 

RULES:
- (Parentheses) for preparatory actions are OPTIONAL but preferred ~70% of the time
- When no parentheses, start directly with lowercase action
- Can include "spoken words" in the emote
- NEVER use first person (I, me, my) - third person only
- Use actual player names from scene (e.g., $grulk not $playername)
- Vary the format for natural variety
- NEVER use hyphens (- or –), use commas instead
- After (parentheses), text flows naturally when "Nyxalei" is inserted
- Speech should be whimsical, poetic, nature-focused

TONE: Mystical, calm, intelligent, reverent. Scholar of nature's patterns. Moves like nature—never rushed, always deliberate. Introspective and poetic, using natural metaphors.

IMAGERY: moss, bark, stormlight, vines, mist, roots, wind, water, earth, forest cycles

Generate only the emote text, nothing else.]])
    
    local full_prompt = string.format(
        "%s\n\nSCENE:\n%s%s\n\nMOOD: %s",
        emote_context,
        context,
        name_hint,
        message
    )
    
    cecho("<magenta>(RP) Nyxalei: " .. message .. "<reset>\n")
    if emerge.config.get("ai.show_prompt", true) then
        tempTimer(0.1, function() send(" ", false) end)
    end
    
    -- Set roleplay-specific system prompt temporarily
    local original_system_prompt = emerge.config.get("ai.system_prompt")
    emerge.config.set("ai.system_prompt", "Output ONLY the emote text in third person. Never use I/me/my. Describe what others would see Nyxalei doing.")
    emerge.state.set("ai.expecting_emote", true)
    
    send_prompt(full_prompt, false, message)
    
    -- Restore original system prompt
    tempTimer(0.1, function()
        emerge.config.set("ai.system_prompt", original_system_prompt)
    end)
end

local function handle_change_provider(event, data)
    local provider_name = data.provider or data
    if not providers[provider_name] then
        cecho("<red>(AI) Unknown provider: " .. provider_name .. "<reset>\n")
        cecho("Available providers: ollama, groq, openai\n")
        return
    end
    
    emerge.config.set("ai.provider", provider_name)
    emerge.config.set("ai.model", nil) -- Reset to provider default
    
    -- Auto-adjust buffer size based on provider
    if provider_name == "ollama" then
        emerge.config.set("ai.buffer_lines", 200)
        cecho("<yellow>(AI) Context buffer set to 200 lines for local processing<reset>\n")
    else
        emerge.config.set("ai.buffer_lines", 2000)
        cecho("<yellow>(AI) Context buffer increased to 2000 lines for cloud processing<reset>\n")
    end
    
    -- Clear conversation history
    emerge.state.set("ai.conversation_history", {})
    emerge.state.set("ai.ollama_context", {})
    
    cecho(string.format("<green>(AI) Now using provider: %s<reset>\n", providers[provider_name].name))
end

local function handle_recap(event, data)
    handle_context_prompt("emerge.ai.context.query", "please provide a brief summary of what just happened and what I should do next")
end

local function handle_list_models(event, data)
    local provider = get_current_provider()
    
    -- For providers with static model lists
    if not provider:listModels() then
        local models = provider:parseModels()
        cecho("<green>Available " .. provider.name .. " Models:<reset>\n")
        for _, model in ipairs(models) do
            local current_model = emerge.config.get("ai.model") or provider.default_model
            local current = model == current_model and " <yellow>(active)<reset>" or ""
            cecho(string.format("  <cyan>%s<reset>%s\n", model, current))
        end
        return
    end
    
    -- For providers with API endpoints
    make_http_request(provider:listModels(), function(success, response_body)
        if not success then
            cecho("<red>(AI) Error: Cannot connect to " .. provider.name .. "<reset>\n")
            return
        end
        
        local ok, data = pcall(yajl.to_value, response_body)
        if not ok then
            ok, data = pcall(json.decode, response_body)
        end
        
        local models = provider:parseModels(data)
        cecho("<green>Available " .. provider.name .. " Models:<reset>\n")
        if #models > 0 then
            for _, model in ipairs(models) do
                local current_model = emerge.config.get("ai.model") or provider.default_model
                local current = model == current_model and " <yellow>(active)<reset>" or ""
                cecho(string.format("  <cyan>%s<reset>%s\n", model, current))
            end
        else
            cecho("  <yellow>No models found<reset>\n")
        end
    end, {
        headers = provider.api_key and {
            ["Authorization"] = "Bearer " .. (emerge.config.get("ai.api_keys." .. emerge.config.get("ai.provider", "ollama")) or "")
        } or nil
    })
end

local function handle_set_model(event, data)
    local model_name = data.model or data
    emerge.config.set("ai.model", model_name)
    -- Clear conversation history when changing models
    emerge.state.set("ai.conversation_history", {})
    emerge.state.set("ai.ollama_context", {})
    cecho(string.format("<green>(AI) Now using model: %s<reset>\n", model_name))
end

local function handle_reset_conversation(event, data)
    emerge.state.set("ai.conversation_history", {})
    emerge.state.set("ai.ollama_context", {})
    emerge.state.set("ai.last_prompt", nil)
    emerge.state.set("ai.last_response", nil)
    cecho("<green>(AI) Conversation memory cleared<reset>\n")
end

local function handle_status_check(event, data)
    local provider = get_current_provider()
    cecho(string.format("<green>(AI) Provider: %s<reset>\n", provider.name))
    local current_model = emerge.config.get("ai.model") or provider.default_model
    cecho(string.format("  Model: <cyan>%s<reset>\n", current_model))
    cecho(string.format("  Buffer capture: %d lines\n", emerge.config.get("ai.buffer_lines", 200)))
    
    -- Quick connectivity test for Ollama
    if emerge.config.get("ai.provider") == "ollama" then
        local url = provider.api_base .. "/api/tags"
        make_http_request(url, function(success, response_body)
            if success then
                cecho("<green>  Status: Online<reset>\n")
            else
                cecho("<red>  Status: Offline<reset>\n")
            end
        end)
    else
        cecho("<green>  Status: Configured<reset>\n")
    end
end

local function handle_set_api_key(event, data)
    local provider_name = data.provider
    local key = data.key
    
    if not provider_name or not key then
        cecho("<red>(AI) Usage: ai apikey <provider> <key><reset>\n")
        cecho("Example: ai apikey groq your_api_key_here\n")
        return
    end
    
    if not providers[provider_name] then
        cecho("<red>(AI) Unknown provider: " .. provider_name .. "<reset>\n")
        cecho("Available providers: groq, openai\n")
        return
    end
    
    if provider_name == "ollama" then
        cecho("<yellow>(AI) Ollama doesn't require an API key<reset>\n")
        return
    end
    
    emerge.config.set("ai.api_keys." .. provider_name, key)
    cecho(string.format("<green>(AI) API key set for %s<reset>\n", providers[provider_name].name))
end

local function handle_clear_api_key(event, data)
    local provider_name = data.provider or data
    
    if not provider_name then
        cecho("<red>(AI) Usage: ai apikey clear <provider><reset>\n")
        return
    end
    
    if not providers[provider_name] then
        cecho("<red>(AI) Unknown provider: " .. provider_name .. "<reset>\n")
        cecho("Available providers: groq, openai\n")
        return
    end
    
    if provider_name == "ollama" then
        cecho("<yellow>(AI) Ollama doesn't use API keys<reset>\n")
        return
    end
    
    emerge.config.set("ai.api_keys." .. provider_name, nil)
    cecho(string.format("<green>(AI) API key cleared for %s<reset>\n", providers[provider_name].name))
end

local function handle_show_help(event, data)
    cecho(string.format("<green>EMERGE AI Assistant v%s<reset>\n", module.version))
    cecho(string.format("<dim>%s<reset>\n\n", module.help_data.description))
    
    -- Group commands by category
    local categories = {
        ["Chat Commands"] = {
            "ait <message>",
            "aic <question>",
            "arpt <mood>",
            "arptc",
            "ai recap"
        },
        ["Configuration"] = {
            "ai provider <name>",
            "ai list",
            "ai use <model>",
            "ai status"
        },
        ["API Keys"] = {
            "ai apikey groq <key>",
            "ai apikey openai <key>",
            "ai apikey clear <provider>"
        },
        ["Settings"] = {
            "ai buffer <n>",
            "ai debug on/off",
            "ai prompt on/off",
            "ai reset",
            "ai help",
            "ai unload"
        }
    }
    
    -- Display commands by category
    for category, commands in pairs(categories) do
        cecho(string.format("<cyan>%s:<reset>\n", category))
        for _, cmd in ipairs(commands) do
            local description = module.help_data.commands[cmd]
            if description then
                cecho(string.format("  <yellow>%-25s<reset> - %s\n", cmd, description))
            end
        end
        cecho("\n")
    end
    
    -- Show current status
    local provider = get_current_provider()
    cecho(string.format("<dim>Current Provider: %s | Model: %s<reset>\n", 
        provider.name, 
        emerge.config.get("ai.model") or provider.default_model))
    
    -- Show rate limit status
    local rate_limit = private.rate_limit
    local now = os.time()
    local window_remaining = 60 - (now - rate_limit.window_start)
    local requests_remaining = rate_limit.max_per_minute - rate_limit.current_count
    
    if window_remaining > 0 and requests_remaining > 0 then
        cecho(string.format("<dim>Rate Limit: %d/%d requests remaining (resets in %ds)<reset>\n",
            requests_remaining, rate_limit.max_per_minute, window_remaining))
    end
end

local function handle_unload_module(event, data)
    cecho("<yellow>(AI) Unloading AI module completely...<reset>\n")
    
    -- Call shutdown to clean up properly
    module.shutdown()
    
    -- Additional cleanup for complete removal
    emerge.ai = nil
    
    -- Clear from package if it exists
    if package and package.loaded then
        package.loaded["emerge.ai"] = nil
        package.loaded["ai"] = nil
    end
    
    cecho("<green>(AI) AI module completely unloaded. Use 'lua dofile(getMudletHomeDir()..\"/emerge/modules/optional/ai/ai.lua\")' to reload.<reset>\n")
end

local function handle_roleplay_context_copy(event, data)
    local context = capture_buffer(150)
    setClipboardText(context)
    cecho("<green>(AI) Last 150 lines copied to clipboard for roleplay context<reset>\n")
    log_debug("Context copied: " .. #context .. " characters")
end

-- Create aliases for user commands
local function create_alias(name, pattern, handler_event, data_extractor)
    if private.aliases[name] and exists(private.aliases[name], "alias") then
        killAlias(private.aliases[name])
    end
    
    private.aliases[name] = tempAlias(pattern, function()
        local data = data_extractor and data_extractor(matches) or matches[2]
        emerge.events:emit(handler_event, data)
    end)
    
    return private.aliases[name]
end

-- Initialize the module
function module.init()
    log_debug("Initializing AI module v" .. module.version)
    
    -- Initialize configuration with defaults
    emerge.config.register("ai", {
        provider = "ollama",
        model = nil,
        temperature = 0.7,
        max_tokens = 2048,
        system_prompt = nil,
        buffer_lines = 200,
        rp_buffer_lines = 15,
        show_prompt = true,
        max_history_items = 15,
        debug = false,
        emote_context = [[Create ONE Achaea emote for Nyxalei, a mystical Sylvan fayad. 

RULES:
- (Parentheses) for preparatory actions are OPTIONAL but preferred ~70% of the time
- When no parentheses, start directly with lowercase action
- Can include "spoken words" in the emote
- NEVER use first person (I, me, my) - third person only
- Use actual player names from scene (e.g., $grulk not $playername)
- Vary the format for natural variety
- NEVER use hyphens (- or –), use commas instead
- After (parentheses), text flows naturally when "Nyxalei" is inserted
- Speech should be whimsical, poetic, nature-focused

TONE: Mystical, calm, intelligent, reverent. Scholar of nature's patterns. Moves like nature—never rushed, always deliberate. Introspective and poetic, using natural metaphors.

IMAGERY: moss, bark, stormlight, vines, mist, roots, wind, water, earth, forest cycles

Generate only the emote text, nothing else.]],
        api_keys = {}
    })
    
    -- Initialize state
    emerge.state.ensure("ai", {
        conversation_history = {},
        ollama_context = {},
        active_requests = {},
        last_prompt = nil,
        last_response = nil,
        expecting_emote = false
    })
    
    -- Register event handlers
    emerge.events:on("emerge.ai.command.quick_talk", handle_quick_talk)
    emerge.events:on("emerge.ai.command.context_prompt", handle_context_prompt)
    emerge.events:on("emerge.ai.command.roleplay", handle_roleplay_talk)
    emerge.events:on("emerge.ai.command.change_provider", handle_change_provider)
    emerge.events:on("emerge.ai.command.recap", handle_recap)
    emerge.events:on("emerge.ai.command.list_models", handle_list_models)
    emerge.events:on("emerge.ai.command.set_model", handle_set_model)
    emerge.events:on("emerge.ai.command.reset_conversation", handle_reset_conversation)
    emerge.events:on("emerge.ai.command.status_check", handle_status_check)
    emerge.events:on("emerge.ai.command.set_api_key", handle_set_api_key)
    emerge.events:on("emerge.ai.command.clear_api_key", handle_clear_api_key)
    emerge.events:on("emerge.ai.command.show_help", handle_show_help)
    emerge.events:on("emerge.ai.command.unload_module", handle_unload_module)
    emerge.events:on("emerge.ai.command.roleplay_context_copy", handle_roleplay_context_copy)
    
    -- Register HTTP event handlers
    private.handlers.post_success = registerAnonymousEventHandler("sysPostHttpDone", handle_http_success)
    private.handlers.post_error = registerAnonymousEventHandler("sysPostHttpError", handle_http_error)
    private.handlers.get_success = registerAnonymousEventHandler("sysGetHttpDone", handle_http_success)
    private.handlers.get_error = registerAnonymousEventHandler("sysGetHttpError", handle_http_error)
    
    -- Create user aliases
    create_alias("quick_talk", "^ait (.+)$", "emerge.ai.command.quick_talk")
    create_alias("roleplay_talk", "^arpt (.+)$", "emerge.ai.command.roleplay")
    create_alias("roleplay_context_copy", "^arptc$", "emerge.ai.command.roleplay_context_copy")
    create_alias("context", "^aic (.+)$", "emerge.ai.command.context_prompt")
    create_alias("recap", "^ai recap$", "emerge.ai.command.recap")
    create_alias("provider", "^ai provider ([^ ]+)$", "emerge.ai.command.change_provider")
    create_alias("list", "^ai list$", "emerge.ai.command.list_models")
    create_alias("use", "^ai use (.+)$", "emerge.ai.command.set_model")
    create_alias("reset", "^ai reset$", "emerge.ai.command.reset_conversation")
    create_alias("status", "^ai status$", "emerge.ai.command.status_check")
    create_alias("help", "^ai help$", "emerge.ai.command.show_help")
    create_alias("unload", "^ai unload$", "emerge.ai.command.unload_module")
    
    -- API key management aliases
    create_alias("apikey_set_groq", "^ai apikey groq (.+)$", "emerge.ai.command.set_api_key", function(matches)
        return { provider = "groq", key = matches[2] }
    end)
    create_alias("apikey_set_openai", "^ai apikey openai (.+)$", "emerge.ai.command.set_api_key", function(matches)
        return { provider = "openai", key = matches[2] }
    end)
    create_alias("apikey_clear_groq", "^ai apikey clear groq$", "emerge.ai.command.clear_api_key", function(matches)
        return { provider = "groq" }
    end)
    create_alias("apikey_clear_openai", "^ai apikey clear openai$", "emerge.ai.command.clear_api_key", function(matches)
        return { provider = "openai" }
    end)
    
    -- Settings aliases
    create_alias("buffer", "^ai buffer (%d+)$", "emerge.ai.command.set_buffer", function(matches)
        return { buffer_lines = tonumber(matches[2]) }
    end)
    create_alias("debug", "^ai debug (on|off)$", "emerge.ai.command.set_debug", function(matches)
        return { debug = matches[2] == "on" }
    end)
    create_alias("prompt", "^ai prompt (on|off)$", "emerge.ai.command.set_prompt", function(matches)
        return { show_prompt = matches[2] == "on" }
    end)
    
    -- Additional command handlers
    emerge.events:on("emerge.ai.command.set_buffer", function(event, data)
        local size = tonumber(data.buffer_lines)
        if not size or size < 10 or size > 2000 then
            cecho("<red>(AI) Buffer size must be between 10 and 2000 lines<reset>\n")
            return
        end
        emerge.config.set("ai.buffer_lines", size)
        cecho(string.format("<green>(AI) Context buffer set to %d lines<reset>\n", size))
    end)
    
    emerge.events:on("emerge.ai.command.set_debug", function(event, data)
        emerge.config.set("ai.debug", data.debug)
        cecho(string.format("<green>(AI) Debug mode %s<reset>\n", data.debug and "enabled" or "disabled"))
    end)
    
    emerge.events:on("emerge.ai.command.set_prompt", function(event, data)
        emerge.config.set("ai.show_prompt", data.show_prompt)
        cecho(string.format("<green>(AI) Prompt display %s<reset>\n", data.show_prompt and "enabled" or "disabled"))
    end)
    
    -- Show initialization message
    cecho(string.format("<green>(AI) AI assistant v%s ready<reset>\n", module.version))
    cecho("Type <cyan>ait hello<reset> to chat, <cyan>ai help<reset> for commands, or <cyan>ai status<reset> for configuration\n")
    
    local provider = get_current_provider()
    cecho(string.format("Current provider: <yellow>%s<reset>\n", provider.name))
    
    -- Emit module loaded event
    emerge.events:emit("system.module.loaded", {
        name = module.name,
        version = module.version
    })
    
    log_debug("AI module initialized successfully")
end

-- Shutdown the module
function module.shutdown()
    log_debug("Shutting down AI module")
    
    -- Clean up aliases
    for name, id in pairs(private.aliases) do
        if exists(id, "alias") then
            killAlias(id)
        end
    end
    private.aliases = {}
    
    -- Clean up event handlers
    for name, id in pairs(private.handlers) do
        if id then
            killAnonymousEventHandler(id)
        end
    end
    private.handlers = {}
    
    -- Clear active requests
    private.active_requests = {}
    
    -- Remove all event listeners - use proper event cleanup
    local events_to_clear = {
        "emerge.ai.command.quick_talk",
        "emerge.ai.command.context_prompt", 
        "emerge.ai.command.roleplay",
        "emerge.ai.command.change_provider",
        "emerge.ai.command.recap",
        "emerge.ai.command.list_models",
        "emerge.ai.command.set_model",
        "emerge.ai.command.reset_conversation",
        "emerge.ai.command.status_check",
        "emerge.ai.command.set_api_key",
        "emerge.ai.command.clear_api_key",
        "emerge.ai.command.show_help",
        "emerge.ai.command.unload_module",
        "emerge.ai.command.roleplay_context_copy",
        "emerge.ai.command.set_buffer",
        "emerge.ai.command.set_debug",
        "emerge.ai.command.set_prompt"
    }
    
    for _, event in ipairs(events_to_clear) do
        emerge.events:clear(event)
    end
    
    cecho("<yellow>(AI) AI module unloaded<reset>\n")
    
    -- Emit module unloaded event
    emerge.events:emit("system.module.unloaded", {
        name = module.name,
        version = module.version
    })
    
    log_debug("AI module shutdown complete")
end

-- Public API functions for compatibility
function module.quick_talk(message)
    emerge.events:emit("emerge.ai.command.quick_talk", message)
end

function module.context_prompt(question) 
    emerge.events:emit("emerge.ai.command.context_prompt", question)
end

function module.roleplay_talk(message)
    emerge.events:emit("emerge.ai.command.roleplay", message)
end

function module.change_provider(provider_name)
    emerge.events:emit("emerge.ai.command.change_provider", provider_name)
end

function module.list_models()
    emerge.events:emit("emerge.ai.command.list_models")
end

function module.reset_conversation()
    emerge.events:emit("emerge.ai.command.reset_conversation")
end

function module.check_status()
    emerge.events:emit("emerge.ai.command.status_check")
end

return module