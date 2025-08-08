-- EMERGE Tsol'aa Translation Module
-- Version: 0.7.0
-- Architecture: Event-driven EMERGE compliant
-- Auto-translates Tsol'aa phrases in real-time communications

achaea = achaea or {}
emerge = emerge or achaea
nexus = nexus or achaea

-- Module namespace
achaea.tsolaa = achaea.tsolaa or {}
local module = achaea.tsolaa

-- Module metadata
module.name = "Tsol'aa Translator"
module.version = "0.7.0"
module.description = "Translates Tsol'aa phrases in real-time communications"

-- Private state
local dictionary = {}
local categories = {}
local handlers = {}
local config = {
    auto_translate = true,
    show_inline = true,
    case_sensitive = false,
    color_translations = true,
    show_pronunciation = false
}

-- Comprehensive dictionary (200+ entries)
local function load_dictionary()
    dictionary = {
        -- Greetings
        ["Lo-da'i"] = "Hello/I greet you",
        ["Len"] = "Hello/Goodbye",
        ["Lenhiema boora"] = "Good day/afternoon",
        ["Lenheima boora"] = "Good day/afternoon",
        ["Liekhhiema boora"] = "Good night",
        ["Len-asa-shuun boora"] = "Good morning",
        ["Len-asa-saara boora"] = "Good evening",
        ["Lo-da'i n-thi"] = "I greet you (formal)",
        
        -- Farewells
        ["Laiq tsuura"] = "Be strong",
        ["Laiq boora"] = "Be well",
        ["Moraia morain"] = "High heart",
        ["Moraia boora"] = "Good heart/Take care",
        ["Unu 'na'naitzin"] = "Until we meet",
        ["Asa-thi len"] = "The sun be with you",
        
        -- Questions & Responses
        ["Al-sa'a thi-mala"] = "How are you doing",
        ["Al-sa'a thi-laiq"] = "How are you",
        ["Al-sa'a thi-laia"] = "How are things",
        ["Al-sa'a thi"] = "How are you",
        ["Sa thi"] = "And you",
        ["Boora"] = "Good/Well",
        ["Lo-boora"] = "I am well",
        ["Ile-norokh"] = "Not bad",
        ["Tusun"] = "Awful",
        ["Hu-mala al-sa'a hu-mala"] = "It goes how it goes",
        ["Ile-len, ile-saiha'hiema"] = "So-so",
        
        -- Identity & Origin
        ["Thi-laiq Tsol"] = "Are you Tsol'aa",
        ["Thi Tsol'aa"] = "Are you Tsol'aa",
        ["Lo-Tsol"] = "I am Tsol'aa",
        ["At sha'a thi-sandu"] = "Where are you from",
        ["Shi-sa'a thi-laia"] = "Where do you live",
        ["Lo-laia shi-aa'len"] = "I live in the Aalen",
        ["Lo-laia shi-bashnar"] = "I live in the Vashnars",
        ["Lo-lamqa al-tsol'aa"] = "I speak Tsol'aa",
        ["Al-sa'a al-lamath thi-lamqa"] = "What language do you speak",
        
        -- Emergency & Safety
        ["Boina"] = "Help",
        ["I hailqa n-lo"] = "Do not kill me",
        ["Mala thiesekh"] = "Is that dangerous",
        ["Shala hailqas"] = "That is lethal",
        ["Lo-sandu asa-qamad"] = "I come in peace",
        
        -- Common phrases
        ["Mandad, andad"] = "To guard, to give",
        ["N-sa'a thi-dora"] = "What do you want",
        ["Ka'a thi"] = "Who are you",
        ["Sa'a thi-rim"] = "What is your name",
        
        -- People/Races
        ["Tsol'aa"] = "Forest people",
        ["Tsol'teth"] = "People of war",
        ["Tsol'dasi"] = "Ancient Tsol tribe",
        ["qui'silon"] = "human",
        ["qui'har'bain"] = "dwarf/earthman",
        ["qui-sumur"] = "Xoran/lizardman",
        ["qui'qaalar"] = "Faun/Satyr",
        ["ama'saara"] = "Siren/woman of the sea",
        ["ama'qaalar"] = "Dryad/woman of the trees",
        
        -- Nature/Places
        ["aa"] = "forest",
        ["aa'len"] = "Aalen/forest of the west",
        ["qaal"] = "tree",
        ["qaalar"] = "trees",
        ["tlaiaqaal"] = "redwood",
        ["tlaiaqaalar"] = "redwoods",
        ["tzanaqaal"] = "fir tree",
        ["ruzaqaal"] = "pine tree",
        ["saara"] = "sea",
        ["saiha"] = "water",
        ["hiema"] = "sky/heaven",
        ["len"] = "sun/west/sunset",
        ["liekha"] = "star",
        ["shuun"] = "snow",
        ["tasha"] = "fire",
        ["hiela"] = "wind",
        
        -- Common words
        ["qui"] = "man",
        ["ama"] = "woman",
        ["kai"] = "child",
        ["doma"] = "brother",
        ["lela"] = "father",
        ["maana"] = "mother",
        ["balan"] = "house",
        ["tannakh"] = "village",
        ["koro"] = "book",
        ["musa"] = "food",
        ["haim"] = "beer",
        ["lamath"] = "language/tongue",
        
        -- Adjectives
        ["boora"] = "good",
        ["norokh"] = "bad",
        ["morain"] = "high/tall",
        ["maara"] = "large",
        ["tsuura"] = "strong",
        ["falaq"] = "cold",
        ["miero"] = "sweet/gentle",
        ["ravaana"] = "beautiful",
        ["thiesekh"] = "dangerous",
        ["hailqas"] = "lethal",
        ["suremekh"] = "poisonous",
        
        -- Actions (Verbs)
        ["malad"] = "to walk",
        ["hailad"] = "to die",
        ["hailqad"] = "to kill",
        ["terrid"] = "to drink",
        ["trusad"] = "to hunt",
        ["naitzed"] = "to see",
        ["lamqad"] = "to speak",
        ["andad"] = "to give",
        ["mandad"] = "to guard",
        ["laiad"] = "to live",
        ["tsulad"] = "to read",
        ["tanad"] = "to know",
        ["alad"] = "to wash",
        ["aramad"] = "to sow",
        ["balad"] = "to build",
        ["boidad"] = "to bury",
        ["dorad"] = "want",
        ["elud"] = "to flow",
        ["eluid"] = "sing/recite poetry",
        ["kailqad"] = "to shield",
        ["mainad"] = "to sculpt",
        ["morud"] = "to raise",
        ["muinad"] = "to pile up",
        ["niegad"] = "to collapse",
        ["praiad"] = "to bite",
        ["rasdielad"] = "to behead",
        ["sandud"] = "to come/arrive",
        ["shaalad"] = "to lie",
        ["stra'ad"] = "to strike",
        ["taarad"] = "carry",
        ["troinad"] = "to pray",
        ["tuad"] = "to fall",
        ["tuqad"] = "to lay down",
        ["umad"] = "to till",
        ["uraiad"] = "to weave",
        
        -- Numbers
        ["iin"] = "one",
        ["a'in"] = "two",
        ["m'a"] = "five",
        ["sieda"] = "ten",
        ["tooros"] = "thousand",
        
        -- Extended vocabulary
        ["a'al"] = "under/down",
        ["a'altaara"] = "to cover up",
        ["agi"] = "blue",
        ["aim"] = "light",
        ["an"] = "weapon/arm",
        ["an'har"] = "behind/after",
        ["an'tzai"] = "next to",
        ["at"] = "out of/from",
        ["atin"] = "away",
        ["atmalad"] = "to leave/go out",
        ["atmalqad"] = "to leave someone/desert",
        ["bahar"] = "storm",
        ["bain"] = "field",
        ["bashan"] = "tooth (of saw/fork)/flint",
        ["boiad"] = "forget",
        ["boinad"] = "to help",
        ["da'id"] = "to greet",
        ["dalam"] = "memory",
        ["diela"] = "face",
        ["duun"] = "leg/foot",
        ["ele"] = "river",
        ["eluinad"] = "bard/artist",
        ["en'lier"] = "envy",
        ["fai"] = "now",
        ["fliennad"] = "to gleam/shimmer",
        ["foin"] = "tooth",
        ["gaiartha"] = "armour",
        ["giela"] = "heather",
        ["gielaraia"] = "heath/heathland",
        ["har'bain"] = "earth",
        ["huin"] = "he/she",
        ["i'il"] = "up/on top of",
        ["ile"] = "nothing",
        ["ileka'a"] = "no-one",
        ["isil"] = "eye",
        ["ithin"] = "element/particle",
        ["ka'a"] = "who",
        ["kaama"] = "sword",
        ["kail"] = "shield",
        ["kharan"] = "hand/arm",
        ["kharankail"] = "bracelet",
        ["laath"] = "leaf",
        ["laathkail"] = "canopy",
        ["laid"] = "to be",
        ["laimannad"] = "to wave",
        ["lanakh"] = "island",
        ["liekha"] = "star",
        ["lienad"] = "to cherish",
        ["lo"] = "I",
        ["lunalaath"] = "fern",
        ["maar"] = "even",
        ["maialad"] = "crown",
        ["mainaas"] = "sculptor",
        ["mala"] = "that",
        ["ma"] = "that",
        ["miesa"] = "brave/courageous",
        ["moraia"] = "demeanor/heart",
        ["naila"] = "pillow",
        ["nanakh"] = "murmur",
        ["n'ai"] = "in front of/before",
        ["niena"] = "spirit",
        ["noorala"] = "faraway/distant",
        ["pala'nakh"] = "shepherd",
        ["qa'ada"] = "stern",
        ["qamad"] = "peace",
        ["qui'anar"] = "warrior/man of arms",
        ["raia"] = "land/realm",
        ["rienhala"] = "spider-mount",
        ["rienha"] = "spider",
        ["rienha'len"] = "beach-spider/crayfish",
        ["rim"] = "name",
        ["roman"] = "some",
        ["ro"] = "some",
        ["rugan"] = "wheat/grain",
        ["ruganala"] = "granary/storage",
        ["ruganalakh"] = "merchant",
        ["sa"] = "and",
        ["sa'a"] = "what",
        ["saiha'hiema"] = "rain",
        ["saina"] = "flower",
        ["salaq"] = "quarterstaff",
        ["sennad"] = "will/shall",
        ["siliq"] = "soft",
        ["staisad"] = "to waver",
        ["sumur"] = "lizard",
        ["shala"] = "this",
        ["sha"] = "this",
        ["shurukh"] = "basilisk",
        ["tah'maal"] = "dark/grey/dirty",
        ["teth"] = "war",
        ["thi"] = "you",
        ["thir"] = "road",
        ["thur"] = "at/nearby",
        ["tlaia"] = "red",
        ["tlalaiad"] = "to lead",
        ["trasa"] = "thick/fat",
        ["tros"] = "trunk (of tree)",
        ["tuuran"] = "mountain",
        ["tsalaisa"] = "faithful",
        ["tselen'teth"] = "soldier/foot-soldier",
        ["tsoi"] = "around",
        ["tsol"] = "member of Tsol people",
        ["tzai"] = "ear",
        ["tzana"] = "needle",
        ["tzin"] = "feather",
        ["ukhia"] = "blood",
        ["umaas"] = "tiller/farmer",
        ["unu"] = "until"
    }
    
    -- Build categories
    categories = {
        greetings = {"Lo-da'i", "Len", "Lenhiema boora", "Lenheima boora", 
                     "Liekhhiema boora", "Len-asa-shuun boora", "Len-asa-saara boora"},
        farewells = {"Laiq tsuura", "Laiq boora", "Moraia morain", "Moraia boora",
                     "Unu 'na'naitzin", "Asa-thi len"},
        questions = {"Al-sa'a thi-mala", "Al-sa'a thi-laiq", "Al-sa'a thi",
                     "Sa thi", "Ka'a thi", "Sa'a thi-rim"},
        emergencies = {"Boina", "I hailqa n-lo", "Mala thiesekh", "Lo-sandu asa-qamad"},
        people = {"Tsol'aa", "Tsol'teth", "Tsol'dasi", "qui'silon", "qui'har'bain",
                  "qui-sumur", "qui'qaalar", "ama'saara", "ama'qaalar", "qui", "ama"},
        nature = {"aa", "aa'len", "qaal", "qaalar", "tlaiaqaal", "tlaiaqaalar",
                  "tzanaqaal", "ruzaqaal", "saara", "saiha", "hiema", "len"},
        family = {"kai", "doma", "lela", "maana"},
        actions = {"malad", "hailad", "hailqad", "terrid", "trusad", "naitzed",
                   "lamqad", "andad", "mandad", "laiad", "tsulad", "tanad"},
        numbers = {"iin", "a'in", "m'a", "sieda", "tooros"}
    }
end

-- Initialize module
function module.init()
    -- Load dictionary
    load_dictionary()
    
    -- Register event handlers for auto-translation
    
    -- Channel messages - highest priority for auto-translation
    handlers.channel = achaea.events:on("gmcp.communication.channel", function(data)
        if config.auto_translate then
            module.process_communication(data.message, "channel", data.channel)
        end
    end, 100)
    
    -- Says
    handlers.say = achaea.events:on("gmcp.communication.say", function(data)
        if config.auto_translate then
            module.process_communication(data.message, "say", data.speaker)
        end
    end, 100)
    
    -- Tells
    handlers.tell = achaea.events:on("gmcp.communication.tell", function(data)
        if config.auto_translate then
            module.process_communication(data.message, "tell", data.from or data.to)
        end
    end, 100)
    
    -- Generic communication event (fallback)
    handlers.comm = achaea.events:on("gmcp.communication", function(data)
        if config.auto_translate and data.text then
            module.process_communication(data.text, "generic")
        end
    end, 90)
    
    -- Configuration events
    handlers.config_set = achaea.events:on("config.tsolaa.set", function(data)
        if data.key and data.value ~= nil then
            config[data.key] = data.value
            achaea.state.set("tsolaa.config." .. data.key, data.value)
        end
    end)
    
    handlers.config_toggle = achaea.events:on("config.tsolaa.toggle", function(data)
        if data.key and type(config[data.key]) == "boolean" then
            config[data.key] = not config[data.key]
            achaea.state.set("tsolaa.config." .. data.key, config[data.key])
        end
    end)
    
    -- Command events
    handlers.search = achaea.events:on("command.tsolaa.search", function(data)
        module.search_phrases(data.term, data.type)
    end)
    
    handlers.category = achaea.events:on("command.tsolaa.category", function(data)
        module.show_category(data.category)
    end)
    
    handlers.help = achaea.events:on("command.tsolaa.help", function(data)
        module.show_help(data.topic)
    end)
    
    -- Load saved configuration
    local saved_config = achaea.state.get("tsolaa.config", {})
    for key, value in pairs(saved_config) do
        config[key] = value
    end
    
    -- Emit initialization event
    achaea.events:emit("module.tsolaa.initialized", {
        version = module.version,
        entries = table.size(dictionary),
        auto_translate = config.auto_translate
    })
end

-- Process communication for auto-translation
function module.process_communication(message, comm_type, source)
    if not message or message == "" then return end
    
    local translations = module.detect_phrases(message)
    
    if #translations > 0 then
        -- Build consolidated translation string
        local consolidated = module.build_consolidated_translation(message, translations)
        
        -- Display inline translation
        if config.show_inline then
            module.display_inline_translation(consolidated)
        end
        
        -- Also emit event for other modules
        achaea.events:emit("display.tsolaa.translations", {
            message = message,
            translations = translations,
            consolidated = consolidated,
            comm_type = comm_type,
            source = source,
            inline = config.show_inline,
            colored = config.color_translations
        })
    end
end

-- Build consolidated translation string
function module.build_consolidated_translation(original_message, translations)
    if #translations == 0 then return "" end
    
    -- Create a working copy of the message for replacement
    local translated_message = original_message
    
    -- Replace each Tsol'aa phrase with its English translation
    -- Process in reverse order by position to maintain string positions
    table.sort(translations, function(a, b) return a.position > b.position end)
    
    for _, trans in ipairs(translations) do
        -- Replace the Tsol'aa phrase with its translation
        local before = translated_message:sub(1, trans.position - 1)
        local after = translated_message:sub(trans.position + #trans.phrase)
        translated_message = before .. trans.translation .. after
    end
    
    return translated_message
end

-- Display inline translation
function module.display_inline_translation(translated_text)
    -- Move cursor to end of line
    moveCursorEnd()
    
    -- Display consolidated translation
    if config.color_translations then
        cecho(" <light_blue>(<yellow>Eng: " .. translated_text .. "<light_blue>)<reset>")
    else
        echo(" (Eng: " .. translated_text .. ")")
    end
end

-- Detect Tsol'aa phrases in text
function module.detect_phrases(text)
    local translations = {}
    local text_lower = text:lower()
    local processed = {}
    
    -- Sort phrases by length (longest first)
    local sorted_phrases = {}
    for phrase, _ in pairs(dictionary) do
        table.insert(sorted_phrases, phrase)
    end
    table.sort(sorted_phrases, function(a, b) return #a > #b end)
    
    -- Find all Tsol'aa phrases
    for _, phrase in ipairs(sorted_phrases) do
        local pattern = phrase:lower():gsub("([%-%+%*%?%[%]%(%)%.%%%^%$])", "%%%1")
        local pos = 1
        
        while pos <= #text_lower do
            local start, finish = text_lower:find(pattern, pos)
            if start then
                -- Check if already processed
                local already_processed = false
                for i = start, finish do
                    if processed[i] then
                        already_processed = true
                        break
                    end
                end
                
                if not already_processed then
                    -- Check word boundaries
                    local before_ok = start == 1 or text_lower:sub(start-1, start-1):match("[%s%p]")
                    local after_ok = finish == #text_lower or text_lower:sub(finish+1, finish+1):match("[%s%p]")
                    
                    if before_ok and after_ok then
                        -- Mark as processed
                        for i = start, finish do
                            processed[i] = true
                        end
                        
                        -- Add translation
                        local actual_text = text:sub(start, finish)
                        table.insert(translations, {
                            phrase = actual_text,
                            translation = dictionary[phrase],
                            position = start
                        })
                    end
                end
                pos = finish + 1
            else
                break
            end
        end
    end
    
    -- Sort by position
    table.sort(translations, function(a, b) return a.position < b.position end)
    
    return translations
end

-- Search functions
function module.search_phrases(term, search_type)
    local results = {}
    term = term:lower()
    
    if search_type == "english" then
        -- Search English translations
        for phrase, translation in pairs(dictionary) do
            if translation:lower():find(term) then
                table.insert(results, {phrase = phrase, translation = translation})
            end
        end
    else
        -- Search Tsol'aa phrases
        for phrase, translation in pairs(dictionary) do
            if phrase:lower():find(term) then
                table.insert(results, {phrase = phrase, translation = translation})
            end
        end
    end
    
    -- Emit results event
    achaea.events:emit("display.tsolaa.search_results", {
        term = term,
        type = search_type,
        results = results
    })
    
    return results
end

-- Show category
function module.show_category(category_name)
    local phrases = categories[category_name]
    if not phrases then
        achaea.events:emit("display.tsolaa.error", {
            message = "Category '" .. category_name .. "' not found"
        })
        return
    end
    
    local results = {}
    for _, phrase in ipairs(phrases) do
        if dictionary[phrase] then
            table.insert(results, {
                phrase = phrase,
                translation = dictionary[phrase]
            })
        end
    end
    
    achaea.events:emit("display.tsolaa.category", {
        category = category_name,
        phrases = results
    })
end

-- Show help
function module.show_help(topic)
    achaea.events:emit("display.tsolaa.help", {topic = topic or "general"})
end

-- Shutdown
function module.shutdown()
    -- Remove event handlers
    for _, handler in pairs(handlers) do
        if handler then
            achaea.events:off(nil, handler)
        end
    end
    handlers = {}
    
    -- Save configuration
    achaea.state.set("tsolaa.config", config)
    
    -- Emit shutdown event
    achaea.events:emit("module.tsolaa.shutdown", {})
end

-- Public API
module.get_dictionary = function() return dictionary end
module.get_config = function() return config end
module.get_categories = function() return categories end

-- Helper for table size
function table.size(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

return module