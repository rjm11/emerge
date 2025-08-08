--Utility scripts I've gathered up over the years. Some are useless, some are repetitve, who knows anymore! I just c/p them into every sytem.
bashingGroup = bashingGroup or {} --really need to fix this
function rime_display_config_colors()

    for k,v in pairs(rime.saved.echo_colors) do
        if rime.saved.echo_colors[k].parenthesis then
            cecho("\n<white>Your current display settings for <"..rime.saved.echo_colors[k].title..">"..k.."<white> are:")
            cecho("\n")
            cecho("\n<"..rime.saved.echo_colors[k].parenthesis..">\(<"..rime.saved.echo_colors[k].title..">Title<"..rime.saved.echo_colors[k].parenthesis..">\)<white> Message!")
            cecho("\n")
        else
            cecho("\n<white>Your current display settings for "..k.." are <"..rime.saved.echo_colors[k].title..">"..k)
            cecho("\n")
        end
    end

end

function rime_initial_setup()
    rime_save_create()
  cecho([[
<dodger_blue>Welcome to Rime!
  
<white>Running setup procedure now! Please hold.
  ]])
  
  tmpSep = tempTrigger("Your config separator will now be: '&&'.", function() rime.saved.separator = "&&" end, 1)
  tmpAdder = tempTrigger("FirstAid will no longer attempt to RIP CARD FROM BODY.", function() rime_help("help") end, 1)
  sendAll("config separator &&", "config echoqueue on", "config pagelength 150", "config wrapwidth 0", "config affliction_view full", "config simple_diag on", "config curemsgs default", "config combatmessages on", "config auto_outc on")
  rime.firstaid = false
  sendAll("config fishnumbers on","firstaid curing off","firstaid defence off","firstaid reporting off","firstaid heal health off","firstaid heal mana off","firstaid use anabiotic off","firstaid use tree off","firstaid use focus off","firstaid use clot off","firstaid adder 0")
  sendAll("config balance_taken on", "config mobdamage on")
end

function rime_save_create()
rime.saved = {
  mindseye = false,
  goggles = 0,
  gauntlet = 0,
  mount = "none",
  allies = {
    "Mjoll",
    "Mazzion",
    "Bulrok",
    "Rijetta",
    "Didi",
    "Kurak",
    "Whirran",
    "Elene",
    "Maeve",
    "Orhm",
    "Asaraii",
  },
  lifesense = false,
  mana_boon = false,
  affColors = {
    writhe_necklock = "<white>writhe_necklock",
    left_arm_missing = "<white>left_arm_missing",
    right_leg_numbed = "<white>right_leg_numbed",
    epilepsy = "<blue>epilepsy",
    writhe_impaled = "<white>writhe_impaled",
    left_leg_bruised_moderate = "<white>left_leg_bruised_moderate",
    weariness = "<red>weariness",
    sandrot = "<MediumPurple>sandrot",
    houndmark = "<gold>houndmark",
    right_arm_damaged = "<white>right_arm_damaged",
    shadowbrand = "<white>shadowbrand",
    commitment_fear = "<DodgerBlue>commitment_fear",
    mental_fatigue = "<white>mental_fatigue",
    forestbrand = "<white>forestbrand",
    head_mangled = "<white>head_mangled",
    blackout = "<white>blackout",
    slickness2 = "<white>slickness2",
    crippled_throat = "<white>crippled_throat",
    vitalbane = "<white>vitalbane",
    oiled = "<white>oiled",
    haemophilia = "<brown>haemophilia",
    blind = "<white>blind",
    writhe_ropes = "<white>writhe_ropes",
    burntskin = "<white>burntskin",
    merciful = "<DodgerBlue>merciful",
    addiction = "<light_coral>addiction",
    head_bruised = "<white>head_bruised",
    magnanimity = "<white>magnanimity",
    ripped_spleen = "<white>ripped_spleen",
    heartflutter = "<MediumPurple>heartflutter",
    paresis = "<MediumPurple>paresis",
    crushed_chest = "<white>crushed_chest",
    aeon = "<sea_green>aeon",
    writhe_transfix = "<white>writhe_transfix",
    hubris = "<goldenrod>hubris",
    broken_arms = "<white>broken_arms",
    penance = "<white>penance",
    berserking = "<DodgerBlue>berserking",
    left_leg_bruised = "<white>left_leg_bruised",
    lovers_effect = "<goldenrod>lovers_effect",
    claustrophobia = "<DodgerBlue>claustrophobia",
    left_arm_damaged = "<white>left_arm_damaged",
    numb_arms = "<white>numb_arms",
    pre_restore_torso = "<white>pre_restore_torso",
    left_arm_numbed = "<white>left_arm_numbed",
    mirroring = "<MediumPurple>mirroring",
    mindclamped = "<white>mindclamped",
    indifference = "<white>indifference",
    shyness = "<blue>shyness",
    blighted = "<light_coral>blighted",
    impairment = "<red>impairment",
    void = "<white>void",
    right_arm_dislocated = "<white>right_arm_dislocated",
    right_leg_bruised_moderate = "<white>right_leg_bruised_moderate",
    deaf = "<white>deaf",
    hypersomnia = "<light_coral>hypersomnia",
    generosity = "<goldenrod>generosity",
    hepafarin = "<white>hepafarin",
    stormtouched = "<white>stormtouched",
    confusion = "<light_coral>confusion",
    slickness = "<gold>slickness",
    vertigo = "<DodgerBlue>vertigo",
    superstition = "<goldenrod>superstition",
    body_odor = "<brown>body_odor",
    writhe_thighlock = "<white>writhe_thighlock",
    right_arm_amputated = "<white>right_arm_amputated",
    agony = "<goldenrod>agony",
    right_leg_amputated = "<white>right_leg_amputated",
    left_leg_missing = "<white>left_leg_missing",
    prone = "<red>PRONE",
    soul_disease = "<gold>disease",
    head_bruised_moderate = "<white>head_bruised_moderate",
    amnesia = "<white>amnesia",
    density = "<white>density",
    sadness = "<light_coral>sadness",
    pre_restore_head = "<white>pre_restore_head",
    right_arm_bruised_critical = "<white>right_arm_bruised_critical",
    phlegm = "<white>phlegm",
    burnt_eyes = "<white>burnt_eyes",
    shadowcoat = "<white>shadowcoat",
    speed = "<white>speed",
    disrupted = "<white>disrupted",
    left_leg_bruised_critical = "<white>left_leg_bruised_critical",
    deadening = "<sea_green>deadening",
    nyctophobia = "<DodgerBlue>nyctophobia",
    right_leg_bruised_critical = "<white>right_leg_bruised_critical",
    stiffness = "<white>stiffness",
    sore_ankle = "<white>sore_ankle",
    right_leg_missing = "<white>right_leg_missing",
    writhe_web = "<white>writhe_web",
    deepwound = "<white>deepwound",
    ringing_ears = "<red>ringing_ears",
    hypochondria = "<red>hypochondria",
    hallucinations = "<light_coral>hallucinations",
    left_leg_dislocated = "<white>left_leg_dislocated",
    torso_bruised_moderate = "<white>torso_bruised_moderate",
    justice = "<white>justice",
    disturb_sanity = "<white>disturb_sanity",
    muscle_spasms = "<white>muscle_spasms",
    anorexia = "<white>anorexia",
    no_deaf = "<white>no_deaf",
    petrified = "<white>petrified",
    whiplash = "<white>whiplash",
    premonition = "<white>premonition",
    fear = "<white>fear",
    spiritbrand = "<white>spiritbrand",
    selfpity = "<blue>selfpity",
    quicksand = "<white>quicksand",
    bloodlust = "<white>bloodlust",
    battle_hunger = "<white>battle_hunger",
    impatience = "<blue>impatience",
    pre_restore_right_leg = "<white>pre_restore_right_leg",
    right_leg_broken = "<white>right_leg_broken",
    wraith = "<gold>wraith",
    left_leg_damaged = "<white>left_leg_damaged",
    windbrand = "<white>windbrand",
    frozenfeet = "<white>frozenfeet",
    gorged = "<white>gorged",
    shaderot_body = "<deep_sky_blue>shaderot_body",
    levitation = "<white>levitation",
    writhe_vines = "<white>writhe_vines",
    shivering = "<white>shivering",
    left_leg_numbed = "<white>left_leg_numbed",
    attuned = "<white>attuned",
    dissonance = "<blue>dissonance",
    right_arm_mangled = "<white>right_arm_mangled",
    idiocy = "<cyan>idiocy",
    pre_restore_left_arm = "<white>pre_restore_left_arm",
    masochism = "<DodgerBlue>masochism",
    destroyed_throat = "<white>destroyed_throat",
    ripped_throat = "<white>ripped_throat",
    withering = "<gold>withering",
    peace = "<goldenrod>peace",
    stupidity = "<blue>stupidity",
    right_leg_damaged = "<white>right_leg_damaged",
    torso_elevation = "<white>torso_elevation",
    agoraphobia = "<DodgerBlue>agoraphobia",
    dementia = "<light_coral>dementia",
    paranoia = "<light_coral>paranoia",
    crippled = "<MediumPurple>crippled",
    broken_legs = "<white>broken_legs",
    right_arm_bruised = "<white>right_arm_bruised",
    right_arm_numbed = "<white>right_arm_numbed",
    blurry_vision = "<white>blurry_vision",
    lightwound = "<white>lightwound",
    wasting = "<white>wasting",
    spiritbane = "<white>spiritbane",
    troubledbreathing = "<white>troubledbreathing",
    instawake = "<white>instawake",
    right_leg_dislocated = "<white>right_leg_dislocated",
    asleep = "<white>asleep",
    mental_disruption = "<brown>mental_disruption",
    rebounding = "<firebrick>rebounding",
    disturb_confidence = "<white>disturb_confidence",
    chest = "<white>chest",
    pacifism = "<goldenrod>pacifism",
    blisters = "<MediumPurple>blisters",
    writhe_grappled = "<white>writhe_grappled",
    cracked_ribs = "<white>cracked_ribs",
    shaderot_benign = "<deep_sky_blue>shaderot_benign",
    recklessness = "<DodgerBlue>recklessness",
    emberbrand = "<white>emberbrand",
    heatspear = "<white>heatspear",
    blood = "<white>blood",
    infested = "<blue>infested",
    head_damaged = "<white>head_damaged",
    left_arm_bruised = "<white>left_arm_bruised",
    ablaze = "<white>ablaze",
    shaderot_wither = "<deep_sky_blue>shaderot_wither",
    writhe_bind = "<white>writhe_bind",
    stonevice = "<white>stonevice",
    right_arm_bruised_moderate = "<white>right_arm_bruised_moderate",
    venom_resistance = "<white>venom_resistance",
    resin_glauxe = "<white>resin_glauxe",
    left_arm_mangled = "<white>left_arm_mangled",
    exhausted = "<brown>exhausted",
    yellowbile = "<white>yellowbile",
    thin_blood = "<brown>thin_blood",
    left_arm_broken = "<white>left_arm_broken",
    left_arm_bruised_critical = "<white>left_arm_bruised_critical",
    right_arm_broken = "<white>right_arm_broken",
    collapsed_lung = "<white>collapsed_lung",
    left_leg_broken = "<white>left_leg_broken",
    writhe_armpitlock = "<white>writhe_armpitlock",
    head_bruised_critical = "<white>head_bruised_critical",
    faintness = "<blue>faintness",
    mistbrand = "<white>mistbrand",
    allergies = "<brown>allergies",
    voidgaze = "<white>voidgaze",
    hatred = "<light_coral>hatred",
    stonebrand = "<white>stonebrand",
    smashed_throat = "<white>smashed_throat",
    blood_curse = "<light_coral>blood_curse",
    selarnia = "<white>selarnia",
    shaderot_spirit = "<deep_sky_blue>shaderot_spirit",
    conviction = "<white>conviction",
    loneliness = "<DodgerBlue>loneliness",
    frozen = "<white>frozen",
    dizziness = "<blue>dizziness",
    physical_disruption = "<brown>physical_disruption",
    broken_any = "<white>broken_any",
    mauledface = "<white>mauledface",
    backstrain = "<white>backstrain",
    rend = "<brown>rend",
    plodding = "<cyan>plodding",
    weakvoid = "<white>weakvoid",
    insulation = "<white>insulation",
    soul_poison = "<gold>POISON",
    disturb_inhibition = "<white>disturb_inhibition",
    sensitivity = "<red>sensitivity",
    left_leg_mangled = "<white>left_leg_mangled",
    patterns = "<deep_sky_blue>patterns",
    laxity = "<goldenrod>laxity",
    resonance = "<blue>resonance",
    effused_blood = "<white>effused_blood",
    baldness = "<red>baldness",
    torso_bruised_critical = "<white>torso_bruised_critical",
    disfigurement = "<gold>disfigurement",
    crippled_body = "<MediumPurple>crippled_body",
    left_arm_amputated = "<white>left_arm_amputated",
    right_arm_missing = "<white>right_arm_missing",
    pre_restore_left_leg = "<white>pre_restore_left_leg",
    stun = "<white>stun",
    limp_veins = "<white>limp_veins",
    sore_wrist = "<white>sore_wrist",
    clumsiness = "<red>clumsiness",
    lethargy = "<brown>lethargy",
    torso_damaged = "<white>torso_damaged",
    omen = "<white>omen",
    ripped_groin = "<white>ripped_groin",
    hypothermia = "<white>hypothermia",
    waterbreathing = "<white>waterbreathing",
    spinal_rip = "<white>spinal_rip",
    hellsight = "<sea_green>hellsight",
    left_arm_bruised_moderate = "<white>left_arm_bruised_moderate",
    vinethorns = "<white>vinethorns",
    pre_restore_right_arm = "<white>pre_restore_right_arm",
    weak_grip = "<white>weak_grip",
    vomiting = "<brown>vomiting",
    lifebane = "<white>lifebane",
    accursed = "<goldenrod>accursed",
    shaderot_heat = "<deep_sky_blue>shaderot_heat",
    torso_bruised = "<white>torso_bruised",
    unconscious = "<white>unconscious",
    disturb_impulse = "<white>disturb_impulse",
    torso_mangled = "<white>torso_mangled",
    left_arm_dislocated = "<white>left_arm_dislocated",
    gloom = "<white>gloom",
    paralysis = "<MediumPurple>paralysis",
    thorns = "<white>thorns",
    right_leg_mangled = "<white>right_leg_mangled",
    mob_impaled = "<white>mob_impaled",
    voyria = "<white>voyria",
    fire_elevation = "<white>fire_elevation",
    right_leg_bruised = "<white>right_leg_bruised",
    blood_poison = "<red>blood_poison",
    muddled = "<white>muddled",
    squelched = "<gold>squelched",
    left_leg_amputated = "<white>left_leg_amputated",
    asthma = "<red>asthma",
    stuttering = "<white>stuttering",
    migraine = "<gold>migraine"
  },
  echo_colors = {
    ["pvp"] = {
        ["parenthesis"] = "RoyalBlue",
        ["title"] = "DeepSkyBlue",
    },
    ["pve"] = {
        ["parenthesis"] = "DeepPink",
        ["title"] = "LightSeaGreen",
    },
    ["def"] = {
        ["parenthesis"] = "MediumPurple",
        ["title"] = "LawnGreen",
    },
    ["curing"] = {
        ["parenthesis"] = "magenta",
        ["title"] = "SteelBlue",
    },
    ["order"] = {
        ["parenthesis"] = "DarkSlateGrey",
        ["title"] = "a_green",
    },
    ["war"] = {
        ["parenthesis"] = "NavyBlue",
        ["title"] = "a_darkmagenta",
    },
    ["tca"] = {
        --target cured aff color
        ["title"] = "DarkOrchid"
    },
    ["tga"] = {
        --target gained aff color
        ["title"] = "violet",
    },
    ["target"] = {
        --target color
        ["title"] = "DodgerBlue",
    },
    ["merchant"] = {
        ["parenthesis"] = "dark_green",
        ["title"] = "gold"
    }
  },
  separator = "&&",
  gag_command = true,
  stable = "bloodlochstable",
  stability = false,
  arti_pipes = false
}
table.save(getMudletHomeDir().."/rime.saved.lua", rime.saved)
end
function rime_echo_colors(type, position, color)

    --This if statement is just to force 'merchant' creation in the echo color scheme table. Will add it in by default

    if type == "merchant" and not rime.saved.echo_colors.merchant then
        rime.saved.echo_colors.merchant = {
            ["parenthesis"] = "dark_green",
            ["title"] = "gold",
        }
    end


    if rime.saved.echo_colors[type] then
        if rime.saved.echo_colors[type][position] then
            rime.saved.echo_colors[type][position] = color
            rime.echo("Color for "..type.."'s "..position.." changed to "..color)
        else
            rime.echo("This position \(<red>"..position.."<white>\) isn't a known setting!")
        end
    else
        rime.echo("This type \(<red>"..type.."<white>\) isn't a known setting!")
    end

end

function sortedKeys(t)
  local keys = {}
  for k,v in pairs(t) do
      table.insert(keys, k)
  end
  
  table.sort(keys, function(a,b)
   -- print(t[a])
    return t[a] < t[b]
  end)

  return keys
end

function returnPercent(amount, limit)
  amount = tonumber(amount)
  limit = tonumber(limit)
  return math.floor(amount / limit * 100)
end

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function additem(list, val, pos)

  if table.contains(list, val) then return end

    if pos then table.insert(list, pos, val) else table.insert(list, val) end

end

function delitem(array, val)
    for i, v in ipairs(array) do
        if v == val then
            table.remove(array, i)
        end
    end
end


function inTable(ctable, val)
    if not table then return false end
    return table.contains(ctable, val)
end

function mapSend(command)

    send(command)

end

function table.copy(t)
  local u = {}
  for k, v in pairs(t) do u[k] = v end
    return u
end

function removeVal(array, val)

    if not array then echo("error error error") echo("val is "..val) return end
    for i,v in ipairs(array) do
        if v == val then
            table.remove(array, i)
        end
    end
end

function table.icopy(source)
    if type(source) ~= "table" then return end
    local copy = {}

    for i, v in ipairs(source) do
        table.insert(copy, v)
    end

    return copy
end

function table.shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else --! number, string, boolean, etc
        copy = orig
    end
    return copy
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end


rime_color_table = {
        snow                  = {255, 250, 250},
        ghost_white           = {248, 248, 255},
        GhostWhite            = {248, 248, 255},
        white_smoke           = {245, 245, 245},
        WhiteSmoke            = {245, 245, 245},
        gainsboro             = {220, 220, 220},
        floral_white          = {255, 250, 240},
        FloralWhite           = {255, 250, 240},
        old_lace              = {253, 245, 230},
        OldLace               = {253, 245, 230},
        linen                 = {250, 240, 230},
        antique_white         = {250, 235, 215},
        AntiqueWhite          = {250, 235, 215},
        papaya_whip           = {255, 239, 213},
        PapayaWhip            = {255, 239, 213},
        blanched_almond       = {255, 235, 205},
        BlanchedAlmond        = {255, 235, 205},
        bisque                = {255, 228, 196},
        peach_puff            = {255, 218, 185},
        PeachPuff             = {255, 218, 185},
        navajo_white          = {255, 222, 173},
        NavajoWhite           = {255, 222, 173},
        moccasin              = {255, 228, 181},
        cornsilk              = {255, 248, 220},
        ivory                 = {255, 255, 240},
        lemon_chiffon         = {255, 250, 205},
        LemonChiffon          = {255, 250, 205},
        seashell              = {255, 245, 238},
        honeydew              = {240, 255, 240},
        mint_cream            = {245, 255, 250},
        MintCream             = {245, 255, 250},
        azure                 = {240, 255, 255},
        alice_blue            = {240, 248, 255},
        AliceBlue             = {240, 248, 255},
        lavender              = {230, 230, 250},
        lavender_blush        = {255, 240, 245},
        LavenderBlush         = {255, 240, 245},
        misty_rose            = {255, 228, 225},
        MistyRose             = {255, 228, 225},
        white                 = {255, 255, 255},
        black                 = {0, 0, 0},
        dark_slate_gray       = {47, 79, 79},
        DarkSlateGray         = {47, 79, 79},
        dark_slate_grey       = {47, 79, 79},
        DarkSlateGrey         = {47, 79, 79},
        dim_gray              = {105, 105, 105},
        DimGray               = {105, 105, 105},
        dim_grey              = {105, 105, 105},
        DimGrey               = {105, 105, 105},
        slate_gray            = {112, 128, 144},
        SlateGray             = {112, 128, 144},
        slate_grey            = {112, 128, 144},
        SlateGrey             = {112, 128, 144},
        light_slate_gray      = {119, 136, 153},
        LightSlateGray        = {119, 136, 153},
        light_slate_grey      = {119, 136, 153},
        LightSlateGrey        = {119, 136, 153},
        gray                  = {190, 190, 190},
        grey                  = {190, 190, 190},
        light_grey            = {211, 211, 211},
        LightGrey             = {211, 211, 211},
        light_gray            = {211, 211, 211},
        LightGray             = {211, 211, 211},
        midnight_blue         = {25, 25, 112},
        MidnightBlue          = {25, 25, 112},
        navy                  = {0, 0, 128},
        navy_blue             = {0, 0, 128},
        NavyBlue              = {0, 0, 128},
        cornflower_blue       = {100, 149, 237},
        donkeybrown           = {100, 78, 36},
        CornflowerBlue        = {100, 149, 237},
        dark_slate_blue       = {72, 61, 139},
        DarkSlateBlue         = {72, 61, 139},
        slate_blue            = {106, 90, 205},
        SlateBlue             = {106, 90, 205},
        medium_slate_blue     = {123, 104, 238},
        MediumSlateBlue       = {123, 104, 238},
        light_slate_blue      = {132, 112, 255},
        LightSlateBlue        = {132, 112, 255},
        medium_blue           = {0, 0, 205},
        MediumBlue            = {0, 0, 205},
        royal_blue            = {65, 105, 225},
        RoyalBlue             = {65, 105, 225},
        blue                  = {0, 0, 255},
        dodger_blue           = {30, 144, 255},
        DodgerBlue            = {30, 144, 255},
        deep_sky_blue         = {0, 191, 255},
        DeepSkyBlue           = {0, 191, 255},
        sky_blue              = {135, 206, 235},
        SkyBlue               = {135, 206, 235},
        light_sky_blue        = {135, 206, 250},
        LightSkyBlue          = {135, 206, 250},
        steel_blue            = {70, 130, 180},
        SteelBlue             = {70, 130, 180},
        light_steel_blue      = {176, 196, 222},
        LightSteelBlue        = {176, 196, 222},
        light_blue            = {173, 216, 230},
        LightBlue             = {173, 216, 230},
        powder_blue           = {176, 224, 230},
        PowderBlue            = {176, 224, 230},
        pale_turquoise        = {175, 238, 238},
        PaleTurquoise         = {175, 238, 238},
        dark_turquoise        = {0, 206, 209},
        DarkTurquoise         = {0, 206, 209},
        medium_turquoise      = {72, 209, 204},
        MediumTurquoise       = {72, 209, 204},
        turquoise             = {64, 224, 208},
        cyan                  = {0, 255, 255},
        light_cyan            = {224, 255, 255},
        LightCyan             = {224, 255, 255},
        cadet_blue            = {95, 158, 160},
        CadetBlue             = {95, 158, 160},
        medium_aquamarine     = {102, 205, 170},
        MediumAquamarine      = {102, 205, 170},
        aquamarine            = {127, 255, 212},
        dark_green            = {0, 100, 0},
        DarkGreen             = {0, 100, 0},
        dark_olive_green      = {85, 107, 47},
        DarkOliveGreen        = {85, 107, 47},
        dark_sea_green        = {143, 188, 143},
        DarkSeaGreen          = {143, 188, 143},
        sea_green             = {46, 139, 87},
        SeaGreen              = {46, 139, 87},
        medium_sea_green      = {60, 179, 113},
        MediumSeaGreen        = {60, 179, 113},
        light_sea_green       = {32, 178, 170},
        LightSeaGreen         = {32, 178, 170},
        pale_green            = {152, 251, 152},
        PaleGreen             = {152, 251, 152},
        spring_green          = {0, 255, 127},
        SpringGreen           = {0, 255, 127},
        lawn_green            = {124, 252, 0},
        LawnGreen             = {124, 252, 0},
        green                 = {0, 255, 0},
        chartreuse            = {127, 255, 0},
        medium_spring_green   = {0, 250, 154},
        MediumSpringGreen     = {0, 250, 154},
        green_yellow          = {173, 255, 47},
        GreenYellow           = {173, 255, 47},
        lime_green            = {50, 205, 50},
        LimeGreen             = {50, 205, 50},
        yellow_green          = {154, 205, 50},
        YellowGreen           = {154, 205, 50},
        forest_green          = {34, 139, 34},
        ForestGreen           = {34, 139, 34},
        olive_drab            = {107, 142, 35},
        OliveDrab             = {107, 142, 35},
        dark_khaki            = {189, 183, 107},
        DarkKhaki             = {189, 183, 107},
        khaki                 = {240, 230, 140},
        pale_goldenrod        = {238, 232, 170},
        PaleGoldenrod         = {238, 232, 170},
        light_goldenrod_yellow= {250, 250, 210},
        LightGoldenrodYellow  = {250, 250, 210},
        light_yellow          = {255, 255, 224},
        LightYellow           = {255, 255, 224},
        yellow                = {255, 255, 0},
        gold                  = {255, 215, 0},
        light_goldenrod       = {238, 221, 130},
        LightGoldenrod        = {238, 221, 130},
        goldenrod             = {218, 165, 32},
        dark_goldenrod        = {184, 134, 11},
        DarkGoldenrod         = {184, 134, 11},
        rosy_brown            = {188, 143, 143},
        RosyBrown             = {188, 143, 143},
        indian_red            = {205, 92, 92},
        IndianRed             = {205, 92, 92},
        saddle_brown          = {139, 69, 19},
        SaddleBrown           = {139, 69, 19},
        sienna                = {160, 82, 45},
        peru                  = {205, 133, 63},
        burlywood             = {222, 184, 135},
        beige                 = {245, 245, 220},
        wheat                 = {245, 222, 179},
        sandy_brown           = {244, 164, 96},
        SandyBrown            = {244, 164, 96},
        tan                   = {210, 180, 140},
        chocolate             = {210, 105, 30},
        firebrick             = {178, 34, 34},
        brown                 = {165, 42, 42},
        brightblue            = {34, 100, 220},
        dark_salmon           = {233, 150, 122},
        DarkSalmon            = {233, 150, 122},
        salmon                = {250, 128, 114},
        light_salmon          = {255, 160, 122},
        LightSalmon           = {255, 160, 122},
        orange                = {255, 165, 0},
        dark_orange           = {255, 140, 0},
        DarkOrange            = {255, 140, 0},
        coral                 = {255, 127, 80},
        light_coral           = {240, 128, 128},
        LightCoral            = {240, 128, 128},
        tomato                = {255, 99, 71},
        orange_red            = {255, 69, 0},
        OrangeRed             = {255, 69, 0},
        red                   = {255, 0, 0},
        hot_pink              = {255, 105, 180},
        HotPink               = {255, 105, 180},
        pale_red              = {255, 177, 177},
        lightred              = {255, 92, 92},
        deep_pink             = {255, 20, 147},
        DeepPink              = {255, 20, 147},
        pink                  = {255, 192, 203},
        mustard               = {255, 199, 92},
        light_pink            = {255, 182, 193},
        LightPink             = {255, 182, 193},
        pale_violet_red       = {219, 112, 147},
        PaleVioletRed         = {219, 112, 147},
        maroon                = {176, 48, 96},
        medium_violet_red     = {199, 21, 133},
        MediumVioletRed       = {199, 21, 133},
        violet_red            = {208, 32, 144},
        VioletRed             = {208, 32, 144},
        magenta               = {255, 0, 255},
        violet                = {238, 130, 238},
        plum                  = {221, 160, 221},
        orchid                = {218, 112, 214},
        medium_orchid         = {186, 85, 211},
        MediumOrchid          = {186, 85, 211},
        dark_orchid           = {153, 50, 204},
        DarkOrchid            = {153, 50, 204},
        dark_violet           = {148, 0, 211},
        DarkViolet            = {148, 0, 211},
        blue_violet           = {138, 43, 226},
        BlueViolet            = {138, 43, 226},
        purple                = {160, 32, 240},
        medium_purple         = {147, 112, 219},
        MediumPurple          = {147, 112, 219},
        thistle               = {216, 191, 216},

-- CHECK IT OUT! Aetolia colors!
        a_darkred             = {128, 0, 0},
        a_darkgreen           = {0, 179, 0},
        a_brown               = {128, 128, 0},
        a_darkblue            = {0, 0, 128},
        a_darkmagenta         = {128, 0, 128},
        a_darkcyan            = {0, 128, 128},
        a_grey                = {192, 192, 192},
        a_darkgrey            = {128, 128, 128},
        a_red                 = {255, 0, 0},
        a_green               = {0, 255, 0},
        a_yellow              = {255, 255, 0},
        a_blue                = {0, 85, 255},
        a_magenta             = {255, 0, 255},
        a_cyan                = {0, 255, 255},
        a_white               = {255, 255, 255},

        chat_bg                 = {25, 25, 25},
}

for k, v in pairs(rime_color_table) do
    if not color_table[k] then
        color_table[k] = v
    end
end

weHarvesting = false
tw = tw or {}

if file_exists(getMudletHomeDir() .. "\\shrines.lua") then
  table.load(getMudletHomeDir() .. "\\shrines.lua", tw)
else
  table.save(getMudletHomeDir() .. "\\shrines.lua", tw)
end

function shrine_capture()
  local divine =
    {
      "ethne",
      "damariel",
      "dhar",
      "chakrasul",
      "haern",
      "abhorash",
      "ivoln",
      "bamathis",
      "omei",
      "severn",
      "slyphe",
      "tanixalthas",
    }
  if gmcp.Char.Items.List.location ~= "room" then
    return false
  end
  local hasShrine = false
  local hasMonument = false
  local vnum = gmcp.Room.Info.num
  local room = gmcp.Room.Info.name
  local area = gmcp.Room.Info.area
  for i, v in ipairs(gmcp.Char.Items.List.items) do
    if v.name:find("shrine") then
      for _, god in ipairs(divine) do
        if v.name:lower():find(god) then
          hasShrine = god
          addShrine(god, vnum, room, area)
        end
      end
    end
    if v.name:find("unreal statue") or v.name:find("a monument of ") then
      for _, god in ipairs(divine) do
        if v.name:lower():find(god) then
          hasMonument = god
          addMonument(god, vnum, room, area)
        end
      end
    end
  end
  for god, gTable in pairs(tw.shrines) do
    tw.shrines[god].shrines = tw.shrines[god].shrines or {}
    tw.shrines[god].monuments = tw.shrines[god].monuments or {}
    if gTable.shrines[vnum] then
      if god ~= hasShrine then
        removeShrine(god, vnum)
        cecho("\nRemoved missing shrine at " .. vnum .. " for " .. god:title())
      end
    end
    if gTable.monuments[vnum] then
      if god ~= hasMonument then
        removeMonument(god, vnum)
        cecho("\nRemoved missing monument at " .. vnum .. " for " .. god:title())
      end
    end
  end
end

------------------------

function addShrine(god, vnum, room, area)
  tw.shrines = tw.shrines or {}
  tw.shrines[god] = tw.shrines[god] or {}
  tw.shrines[god].shrines = tw.shrines[god].shrines or {}
  tw.shrines[god].shrines[vnum] = {name = room, area = area:gsub("an unstable section of ", "")}
  table.save(getMudletHomeDir() .. "\\shrines.lua", tw)
end

------------------------

function removeShrine(god, vnum)
  tw.shrines = tw.shrines or {}
  tw.shrines[god] = tw.shrines[god] or {}
  tw.shrines[god].shrines = tw.shrines[god].shrines or {}
  tw.shrines[god].shrines[vnum] = nil
  table.save(getMudletHomeDir() .. "\\shrines.lua", tw)
end

-----------------------

function addMonument(god, vnum, room, area)
  tw.shrines = tw.shrines or {}
  tw.shrines[god] = tw.shrines[god] or {}
  tw.shrines[god].monuments = tw.shrines[god].monuments or {}
  tw.shrines[god].monuments[vnum] = {name = room, area = area:gsub("an unstable section of ", "")}
  table.save(getMudletHomeDir() .. "\\shrines.lua", tw)
end

------------------------

function removeMonument(god, vnum)
  tw.shrines = tw.shrines or {}
  tw.shrines[god] = tw.shrines[god] or {}
  tw.shrines[god].monuments = tw.shrines[god].monuments or {}
  tw.shrines[god].monuments[vnum] = nil
  table.save(getMudletHomeDir() .. "\\shrines.lua", tw)
end

local farming_seeds = {
  ["Artichoke"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Autumn"},
    ["weeks"] = 4,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Asparagus"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Autumn"},
    ["weeks"] = 6,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Barley"] = {
    ["family"] = "Grain",
    ["season"] = {"Spring"},
    ["weeks"] = 4,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Beet"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Autumn"},
    ["weeks"] = 3,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Blueberry"] = {
    ["family"] = "Field",
    ["season"] = {"Spring"},
    ["weeks"] = 6.5,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Cabbage"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Summer"},
    ["weeks"] = 4.5,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Cauliflower"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Spring"},
    ["weeks"] = 6,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Corn"] = {
    ["family"] = "Field",
    ["season"] = {"Summer"},
    ["weeks"] = 7,
    ["trellis"] = false,
    ["regrow"] = 2
  },
  ["Cotton"] = {
    ["family"] = "Field",
    ["season"] = {"Spring", "Summer"},
    ["weeks"] = 7,
    ["trellis"] = false,
    ["regrow"] = 2
  },
  ["Cranberry"] = {
    ["family"] = "Fruit",
    ["season"] = {"Autumn"},
    ["weeks"] = 3.5,
    ["trellis"] = true,
    ["regrow"] = 2.5
  },
  ["Cucumber"] = {
    ["family"] = "Fruit",
    ["season"] = {"Spring", "Summer"},
    ["weeks"] = 3.5,
    ["trellis"] = true,
    ["regrow"] = 2
  },
  ["Eggplant"] = {
    ["family"] = "Field",
    ["season"] = {"Autumn"},
    ["weeks"] = 2,5,
    ["trellis"] = false,
    ["regrow"] = 2.5
  },
  ["Garlic"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Spring"},
    ["weeks"] = 2,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Grape"] = {
    ["family"] = "Fruit",
    ["season"] = {"Autumn"},
    ["weeks"] = 5,
    ["trellis"] = true,
    ["regrow"] = 1.5
  },
  ["Grass"] = {
    ["family"] = "Field",
    ["season"] = {"Spring", "Summer", "Autumn"},
    ["weeks"] = 2,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Greenbean"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Spring"},
    ["weeks"] = 5,
    ["trellis"] = true,
    ["regrow"] = 1.5
  },
  ["Hemp"] = {
    ["family"] = "Field",
    ["season"] = {"Spring", "Summer", "Autumn"},
    ["weeks"] = 6.5,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Hop"] = {
    ["family"] = "Field",
    ["season"] = {"Summer"},
    ["weeks"] = 5.5,
    ["trellis"] = true,
    ["regrow"] = 1
  },
  ["Kale"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Spring"},
    ["weeks"] = 3,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Onion"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Spring"},
    ["weeks"] = 4.5,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Parsnip"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Spring"},
    ["weeks"] = 2,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Pepper"] = {
    ["family"] = "Field",
    ["season"] = {"Spring"},
    ["weeks"] = 2.5,
    ["trellis"] = false,
    ["regrow"] = 1.5
  },
  ["Pine"] = {
    ["family"] = "Tree",
    ["season"] = {"Spring", "Summer", "Autumn"},
    ["weeks"] = 9.5,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Potato"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Spring"},
    ["weeks"] = 3,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Pumpkin"] = {
    ["family"] = "Fruit",
    ["season"] = {"Autumn"},
    ["weeks"] = 6.5,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Radish"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Summer"},
    ["weeks"] = 3,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Rhubarb"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Spring"},
    ["weeks"] = 6.5,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Strawberry"] = {
    ["family"] = "Field",
    ["season"] = {"Spring"},
    ["weeks"] = 4,
    ["trellis"] = false,
    ["regrow"] = 2
  },
  ["Tomato"] = {
    ["family"] = "Fruit",
    ["season"] = {"Summer"},
    ["weeks"] = 5.5,
    ["trellis"] = true,
    ["regrow"] = 2
  },
  ["Watermelon"] = {
    ["family"] = "Fruit",
    ["season"] = {"Summer"},
    ["weeks"] = 6,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Wheat"] = {
    ["family"] = "Grain",
    ["season"] = {"Spring", "Summer", "Autumn"},
    ["weeks"] = 2,
    ["trellis"] = false,
    ["regrow"] = false
  },
  ["Yam"] = {
    ["family"] = "Vegetable",
    ["season"] = {"Autumn"},
    ["weeks"] = 5,
    ["trellis"] = false,
    ["regrow"] = false
  }
}

RimeFarm = RimeFarm or {}

function RimeFarm.search_seeds(...)
  arg.n = nil
  local queries = {}
  local seedlist = farming_seeds
  local result = {}
  for i in string.gmatch(arg[1], "%S+") do
    if #i == 1 then
      table.insert(queries, tonumber(i))
    else
      table.insert(queries, i)
    end
  end
  if arg ~= nil then
    for _, query in pairs(queries) do
      for seed, _ in spairs(seedlist) do
        if type(query) == "number" then
          if query - seedlist[seed]["weeks"] >= 0 then
            result[seed] = seedlist[seed]
          end
        end
        if string.lower(query) == string.lower(seed) then
          result[seed] = seedlist[seed]
        end
        if string.lower(query) == string.lower(seedlist[seed]["family"]) then
          result[seed] = seedlist[seed]
        end
        if string.lower(query) == "regrow" then
          if seedlist[seed]["regrow"] then
            result[seed] = seedlist[seed]
          end
        end
        if string.lower(query) == "trellis" then
          if seedlist[seed]["trellis"] then
            result[seed] = seedlist[seed]
          end
        end
        for _, season in pairs(seedlist[seed]["season"]) do
          if string.lower(season) == string.lower(query) then
            result[seed] = seedlist[seed]
          end
        end
      end
      seedlist = result
      result = {}
    end
  return seedlist
  else
    RimeFarm.print_seeds()
  end
end


function RimeFarm.print_seeds(seedlist)
  -- This function reads the farming_seeds database above,
  -- and prints out an easy to read table.
  if seedlist == nil then
    seedlist = farming_seeds
  end
  local string = ""
  cecho("<grey>Name           <ansi_blue>| <grey>Family       <ansi_blue>| <grey>Weeks <ansi_blue>| <grey>Regrow <ansi_blue>| <grey>Trellis <ansi_blue>| <grey>Season(s)\n")
  cecho("<ansi_blue>---------------+--------------+-------+--------+---------+----------\n")
  for seed, _ in spairs(seedlist) do
    -- We start by looping through farming_seeds, and defining
    -- the default string. Every seed has a name stored in 'seed',
    -- as well as a 'family', and how many 'weeks' until maturity.
    string = string.format("<DarkGreen> %-12s  <ansi_blue>|<grey>  %-10s  <ansi_blue>|  <orchid>%3.1f<grey>", seed, seedlist[seed]["family"], seedlist[seed]["weeks"])
    if seedlist[seed]["regrow"] then
      -- After, we check if the plant regrows. If it does, we format
      -- it as a single floating point integer, otherwise a string is
      -- used. Either way, the result is attached to the previous string.
      formatted = string.format("<cyan>%.1f", seedlist[seed]["regrow"])
      string = string.."  <ansi_blue>|   "..formatted.."<grey>"
    elseif not seedlist[seed]["regrow"] then
      string = string.."  <ansi_blue>|   <red>-<DarkSlateGrey>Re<grey>"
    end
    if seedlist[seed]["trellis"] then
      -- Same as regrow, we check if the plant requires a trellis,
      -- and adjust the string as appropriate.
      string = string.."  <ansi_blue>|    <green>+<yellow>Tr<grey>  <ansi_blue>|  "
    elseif not seedlist[seed]["trellis"] then
      string = string.."  <ansi_blue>|    <red>-<a_brown>Tr<grey>  <ansi_blue>|  "
    end
    for i, season in pairs(seedlist[seed]["season"]) do
      -- When we get to the 'season' list, we iterate through it
      -- and adjust its color.
      if season == "Spring" then
        season = "<LightGoldenrod>"..season
      elseif season == "Summer" then
        season = "<DeepSkyBlue>"..season
      elseif season == "Autumn" then
        season = "<OrangeRed>"..season
      end
      -- And attach it to the end of our string with the appropriate
      -- punctuation.
      if i == #seedlist[seed]["season"] then
        string = string..season.."<grey>."
      else
        string = string..season.."<grey>, "
      end
    end
    -- And lastly, a newline is attached to the end and the formatted
    -- string is output.
    string = string.."\n"
    cecho(string)
  end
  cecho("<ansi_blue>---------------+--------------+-------+--------+---------+----------\n")
end



