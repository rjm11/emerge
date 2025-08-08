--deffed true if the defence is up keeup true if you want it to fire with queue
rime.defences = {
    ["auto"] = false,
    ["dodge"] = "nothing",
    ["diverting"] = "nothing",
    ["general"] = setmetatable({
        ["flair"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["lifesense"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["lyre"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["hypersight"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["telesense"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["manipulation_aegis"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["nimbleness"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["bolstered"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["returning"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["selfishness"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["mindseye"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["waterwalking"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["gripping"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["deathsight"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["nightsight"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["miasma"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["safeguard"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["ward"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["warmth"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["shielded"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["antivenin"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["temperance"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["speed"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["levitation"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["detection"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["clarity"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["fangbarrier"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["cloak"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["thirdeye"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["divine_speed"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["rebounding"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["density"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["blindness"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["deafness"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["dodging"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["diverting"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["mounted"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["instawake"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["insomnia"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["insulation"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["vigor"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["mist_red"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["mist_blue"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["mist_yellow"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["mist_white"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["mist_green"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["heatsight"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["waterbreathing"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["chameleon"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["moss"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["boar"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["owl"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["mountain"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["moon"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["parry"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["starburst"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["water_infused"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["fire_infused"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["shieldbrace"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["flame"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["roused"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["skywatch"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["treewatch"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["barrier"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["firefly"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["lifevision"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["overwatch"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["insight"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["lipreading"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["chrysalis"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["phylactery"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["manipulation_wisdom"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["manipulation_wealth"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["manipulation_critical_field"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["manipulation_iridescence_field"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["manipulation_returning"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["overdrive"] =  {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["vitality"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["nodesense"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["reflection"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
    }, {__index = function(t, k) return false end}),

    ["Bard"] = {
        ["destiny"] = {deffed = false, keepup = false, need = true, takesBal = true, needsBal = true},
        ["charisma"] = {deffed = false, keepup = false, need = true, takesBal = false, needsBal = true},
        ["sheath"] = {deffed = false, keepup = false, need = true, takesBal = true, needsBal = true},
        ["aurora"] = {deffed = false, keepup = false, need = true, takesBal = true, needsBal = true},
        ["discordance"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["euphonia"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["halfbeat"] = {deffed = false, keepup = false, need = true, takesBal = true, needsBal = true},
        ["stretching"] = {deffed = false, keepup = false, need = true, takesBal = true, needsBal = true},
        ["tolerance"] = {deffed = false, keepup = false, need = true, takesBal = true, needsBal = true},
        ["equipoise"] = {deffed = false, keepup = false, need = true, takesBal = true, needsBal = true},
        ["reprisal"] = {deffed = false, keepup = false, need = true, takesBal = true, needsBal = true},
    },

    ["Infiltrator"] = {
        ["hiding"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["lipreading"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["phased"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["shadowsight"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["ghosted"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["shroud"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["warding"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["finesse"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["weaving"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
    },

    ["Adherent"] = {
        ["adherent_form"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["adherent_barrier"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["adherent_presence"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["adherent_turmoil"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["adherent_mortalfire"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["adherent_mortalfire_stored"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["adherent_synchroneity"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
    },

    ["Seraph"] = {
        ["seraph_form"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["seraph_halo"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["seraph_presence"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["seraph_radiate"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["seraph_corona"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["seraph_corona_stored"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["seraph_parhelion"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["seraph_store"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
    },

    ["Nocturn"] = {
        ["nocturn_form"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["nocturn_bloodcoat"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["nocturn_presence"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["nocturn_haze"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["nocturn_shadow"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["nocturn_shadow_stored"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["nocturn_double"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["nocturn_store"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
    },

    ["Bloodborn"] = {
        ["forestall"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["panoply"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["victimise"] = {deffed = false, keepup = false, need = false, takesbal = true, needsBal = true},
        ["empowered_moon"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["fettered"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["arrhythmia"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
    },

    ["Praenomen"] = {
        ["elusion"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["lifevision"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["hiding"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["stalking"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["arrow_catching"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["fortify"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["celerity"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["lifescent"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["corpus_warding"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["potence_strength"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["potence_constitution"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["potence_intelligence"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = trie},
        ["potence_dexterity"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["concentrate"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["affinity"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["bloodtrack"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["trepidation"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["shadowblow"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["blurred"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["deluge"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["deathlink"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["bloodwisp"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["deathlink"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["bloodrage"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
    },

    ["Akkari"] = {
        ["transience"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Elusion
        ["lifevision"] = {deffed = false, keepup = false, need = true, takesBal = true, needsBal = true}, --Duh
        ["hiding"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Hiding
        ["ascetic"] = {deffed = false, keepup = false, need = true, takesBal = false, needsBal = true}, --Concentrate
        ["relentless"] = {deffed = false, keepup = false, need = true, takesBal = true, needsBal = true}, --Fortify
        ["resolved"] = {deffed = false, keepup = false, need = true, takesBal = true, needsBal = true}, --Warding
        ["acuity"] = {deffed = false, keepup = false, need = true, takesBal = true, needsBal = true}, --Lifescent
        ["celerity"] = {deffed = false, keepup = false, need = true, takesBal = true, needsBal = true}, --Duh
        ["suppressed"] = {deffed = false, keepup = false, need = true, takesBal = true, needsBal = true}, --Blurred
        ["retaliation"] = {deffed = false, keepup = false, need = true, takesBal = true, needsBal = true}, --Shadow
        ["ardour_constitution"] = {deffed = false, keepup = true, need = true, takesBal = true, needsBal = true}, --Potence
        ["ardour_strength"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Potence
        ["ardour_intelligence"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Potence
        ["ardour_dexterity"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Potence
        ["transcend"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Enrage
        ["perceive"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Bloodtrack
        ["holylight"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Trepidation
        ["entrench"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Deathlink
    },

    ["Shapeshifter"] = {
        ["weathering"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["bodyheat"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["metabolism"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["celerity"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["thickhide"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["fury"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["salivating"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["hardening"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["cornering"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["boneshaking"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["berserk"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
    },

    ["Teradrim"] = {
        ["surefooted"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["stonebind"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["earth_resonance"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["entwine"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["earthenform"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["twinsoul"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["ricochet"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["stonefury"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["sand_conceal"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["rune_mark"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["rune_mark_pve"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["rune_mark_pvp"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["rune_mark_group"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["imbue_erosion"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["imbue_stonefury"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["imbue_will"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["sand_swelter"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
    },

    ["Sentinel"] = {
        ["concealed"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["hardiness"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["hiding"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["barkskin"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["foreststride"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["refreshed"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["lifesap"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["vitality"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
    },

    ["Executor"] = {
        ["concealed"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["stoicism"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["hiding"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["girded"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["bounding"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["inspirited"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["bloodlust"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["vitality"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["efficiency"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["limberness"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["somersault"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
    },

    ["Carnifex"] = {
        ["gripping"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["cruelty"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["soul_fortify"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["fearless"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["reveling"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["reckless"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["soulharvest"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["soul_fracture"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["soulthirst"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["bruteforce"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["soul_substitute"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["herculeanrage"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["furor"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["soulbind"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["charging"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["shroud"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["enfrost"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["flanking"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["hound_opening"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
    },

    ["Strife"] = {
        ["adherent_form"] = { deffed = false, keepup = false, need = false, takesBal = true, needsBal = true },
        ["adherent_barrier"] = { deffed = false, keepup = false, need = false, takesBal = true, needsBal = true },
        ["adherent_presence"] = { deffed = false, keepup = false, need = false, takesBal = true, needsBal = true },
        ["adherent_indomitable"] = { deffed = false, keepup = false, need = false, takesBal = true, needsBal = true },
        ["adherent_mortalfire"] = { deffed = false, keepup = false, need = false, takesBal = true, needsBal = true },
        ["adherent_mortalfire_stored"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true,},
        ["adherent_synchroneity"] = { deffed = false, keepup = false, need = false, takesBal = true, needsBal = true },
    },

    ["Tyranny"] = {
        ["adherent_form"] = { deffed = false, keepup = false, need = false, takesBal = true, needsBal = true },
        ["adherent_barrier"] = { deffed = false, keepup = false, need = false, takesBal = true, needsBal = true },
        ["adherent_presence"] = { deffed = false, keepup = false, need = false, takesBal = true, needsBal = true },
        ["adherent_indomitable"] = { deffed = false, keepup = false, need = false, takesBal = true, needsBal = true },
        ["adherent_mortalfire"] = { deffed = false, keepup = false, need = false, takesBal = true, needsBal = true },
        ["adherent_mortalfire_stored"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true,},
        ["adherent_synchroneity"] = { deffed = false, keepup = false, need = false, takesBal = true, needsBal = true },
    },

    ["Corruption"] = {
        ["adherent_form"] = { deffed = false, keepup = false, need = false, takesBal = true, needsBal = true },
        ["adherent_barrier"] = { deffed = false, keepup = false, need = false, takesBal = true, needsBal = true },
        ["adherent_presence"] = { deffed = false, keepup = false, need = false, takesBal = true, needsBal = true },
        ["adherent_acid"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["adherent_mortalfire"] = { deffed = false, keepup = false, need = false, takesBal = true, needsBal = true },
        ["adherent_mortalfire_stored"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true,},
        ["adherent_synchroneity"] = { deffed = false, keepup = false, need = false, takesBal = true, needsBal = true },
    },

    ["Memory"] = {
        ["adherent_form"] = { deffed = false, keepup = false, need = false, takesBal = true, needsBal = true },
        ["adherent_barrier"] = { deffed = false, keepup = false, need = false, takesBal = true, needsBal = true },
        ["adherent_presence"] = { deffed = false, keepup = false, need = false, takesBal = true, needsBal = true },
        ["adherent_ruination"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["adherent_mortalfire"] = { deffed = false, keepup = false, need = false, takesBal = true, needsBal = true },
        ["adherent_mortalfire_stored"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true,},
        ["adherent_synchroneity"] = { deffed = false, keepup = false, need = false, takesBal = true, needsBal = true },
    },

    ["Titan"] = {
        ["titan_form"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["titan_irradiance"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["titan_presence"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["titan_disruption"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["titan_store"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["titan_multicore"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["titan_remnant_stored"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["titan_remnant"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
    },

    ["Indorani"] = {
        ["chariot"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["hierophant"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["eclipse"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["devilpact"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["shroud"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["lifevision"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["morisensus"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["soulmask"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["putrefaction"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["deathaura"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["gravechill"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["vengeance"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["soulcage"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
    },

    ["Archivist"] = {
        ["spheres"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["oneness"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["veiled"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["sublimation"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["dilation"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["linked"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["conjoin"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["ameliorate"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["catabolism"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
    },

    ["Sciomancer"] = {
        ["featherstep"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["shadow_mantle"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["shadow_engulf"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["rigor"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["spectre"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["empowered_moon"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["blurring"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["countercurrent"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["spellguard"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
    },

    ["Monk"] = {
        ["weathering"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["regeneration"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["toughness"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["resistance"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["consciousness"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["boosted_regen"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["vitality"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["split_mind"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["standfirm"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["constitution"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["kaido_immunity"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["mind_cloak"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["mindnet"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["kai_recursion"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["mindlink"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
    },

    ["Wayfarer"] = {
        ["axe_avert"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["axe_obstruct"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["axe_repel"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["weathering"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["ironskin"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["bloodtrails"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["fleetfoot"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["tracking"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["brutality"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["dauntless"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["battlechant"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["anthem"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["axe_rampage"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
    },

    ["Templar"] = {
        ["gripping"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["maingauche"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["standfirm"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["defend"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["anchored"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["aura_concentrate"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["aura_accuracy"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["aura_protection"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["aura_healing"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["aura_purity"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["aura_justice"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["aura_pestilence"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["aura_latency"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["aura_spellbane"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["aura_cleansing"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["aura_meditation"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["aura_redemption"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["blessing_accuracy"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["blessing_protection"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["blessing_healing"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["blessing_purity"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["blessing_justice"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["blessing_pestilence"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["blessing_spellbane"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["blessing_cleansing"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["blessing_meditation"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["blessing_redemption"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},

    },

    ["Ravager"] = {
        ["velocity"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["predation"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["exhilarate"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["contempt"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["reflexes"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["vinculum"] = {deffed = false, keepup = false, need = true, takesBal = true, needsBal = true},
        ["hood"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["ruthlessness"] = {deffed = false, keepup = false, need = true, takesBal = true, needsBal = true},
        ["impenetrable"] = {deffed = false, keepup = false, need = true, takesBal = true, needsBal = true},
        ["criticality"] = {deffed = false, keepup = false, need = true, takesBal = true, needsBal = true},
        ["unfinished"] = {deffed = false, keepup = false, need = true, takesBal = true, needsBal = true},
        ["inflated"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["untouchable"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["ravage"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["delirium"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["humiliate"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["bait"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
    },

    ["Revenant"] = {
        ["gripping"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["maingauche"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["standfirm"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["defending"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["anchored"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["aura_concentrate"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["phantasm_influence"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["phantasm_congeal"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["phantasm_leech"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["phantasm_claw"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["phantasm_mire"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["phantasm_choke"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["phantasm_tether"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["phantasm_wail"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["phantasm_absorb"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["phantasm_siphon"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["phantasm_symbiosis"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["chimera_influence"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["chimera_congeal"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["chimera_leech"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["chimera_claw"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["chimera_mire"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["chimera_choke"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["chimera_tether"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["chimera_wail"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["chimera_absorb"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["chimera_siphon"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["chimera_symbiosis"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = false},
        ["circling"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["ingather"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["iyedlo"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
    },

    ["Earthcaller"] = {
        ["battlehymn_intelligence"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["battlehymn_strength"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["battlehymn_dexterity"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["battlehymn_constitution"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["geor_rune"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["meath_rune"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["ragh_rune"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["baen_rune"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["zhop_rune"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["euphoria"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["anchored"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["constitution"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["smothering"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["heatshield"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["seismicity"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
        ["reformation"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = false},
    },

    ["Luminary"] = {},

    ["Alchemist"] = {
        ["discipline_fieldstudies"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Forestwalker
        ["discipline_research"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Elder Shaman
        ["discipline_compounding"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Nature's Blade
        ["discipline_biology"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Tranquility
        ["discipline_experimentation"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Primeval
        ["discipline_pnp"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Rhythm
        ["discipline_chemistry"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Durdalis
        ["obfuscation"] = {deffed = false, keepup = false, need = true, takesBal = true, needsBal = true}, --Protection
        ["conduit_crutch"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Shaman Warding
        ["cognisance"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},--Shaman Spiritsight
        ["preservation"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Tethering
        ["interposition"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Spiritbond
        ["resuscitation"] = {deffed = false, keepup = false, need = true, takesBal = true, needsBal = true}, --Lifebloom
        ["blightbringer"] = {deffed = false, keepup = false, need = true, takesBal = true, needsBal = true}, --Greenfoot
        ["distractions"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Whispers
        ["quills"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Thorncoat
        ["accelerant"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},  --Quicken   
        ["catalyst"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true}, --Boosting
    },

    ["Shaman"] = {
        ["oath_forestwalker"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Field Studies
        ["oath_shaman"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Research
        ["oath_blade"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Compounding
        ["oath_tranquility"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Biology
        ["oath_primeval"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Experimentation
        ["oath_rhythm"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Pnp
        ["oath_durdalis"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Chemistry
        ["protection"] = {deffed = false, keepup = false, need = true, takesBal = true, needsBal = true}, --Obfuscation
        ["shaman_warding"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Conduit Crutch
        ["shaman_spiritsight"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true}, --Cognisance
        ["tethering"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Preservation
        ["spiritbond"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Interposition
        ["lifebloom"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Resuscitation
        ["greenfoot"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Blightbringer
        ["whispers"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Distractions
        ["thorncoat"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Quills
        ["quicken"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Accelerant
        ["boosting"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true}, --Catalyst
        
    },

    ["Predator"] = {
        ["secondwind"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["whitesight"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["regeneration"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["masked"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
        ["windwalking"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["preserval"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["aversion"] = {deffed = false, keepup = false, need = false, takesBal = true, needBal = true},
        ["defang"] = {deffed = false, keepup = false, need = false, takesBal = true, needsBal = true},
        ["culmination"] = {deffed = false, keepup = false, need = false, takesBal = false, needsBal = true},
    },
}



function addDef(defence)

    deleteLine()

    local class = rime.status.class

    if defence == "insulation" then
        rime.silent_remAff("insulation")
        rime.silent_remAff("shivering")
        rime.silent_remAff("frozen")
    end

    limitStart(defence)

    if defence == "instawake" then rime.silent_remAff("instawake") end
    if defence == "rebounding" then rime.silent_remAff("rebounding") end
    if defence == "density" then rime.silent_remAff("density") end
    if defence == "waterbreathing" then rime.silent_remAff("waterbreathing") end
    if defence == "antivenin" then rime.silent_remAff("antivenin") end
    if defence == "levitation" then rime.silent_remAff("levitation") end
    if defence == "speed" then rime.silent_remAff("speed") end
    if defence == "deafness" then rime.silent_remAff("deaf") end
    if defence == "blindness" then rime.silent_remAff("blind") end
    if defence == "barrier" then send("firstaid off"..rime.saved.separator.."queue clear") end

    if table.contains(rime.defences[class], defence) then
        if defence == "rune_mark" then
            rime.echo("<CornflowerBlue>"..string.title(defence).."<LawnGreen> active. <white>\("..class_color()..class.."<white>\) <"..rime.pvp.runemark_major.."> Major: "..rime.pvp.runemark_major.." <"..rime.pvp.runemark_minor..">Minor: "..rime.pvp.runemark_minor, "def")
        else
            rime.echo("<CornflowerBlue>"..string.title(defence).."<LawnGreen> active. <white>\("..class_color()..class.."<white>\)", "def")
        end
        rime.defences[class][(defence)].deffed = true
        rime.defences[class][(defence)].need = false
    elseif table.contains(rime.defences.general, defence) then
        rime.echo("<MediumPurple>"..string.title(defence).."<LawnGreen> active.", "def")
        rime.defences.general[(defence)].deffed = true
        rime.defences.general[(defence)].need = false
    else
        rime.echo("Not tracking: <red>"..defence.."<white>.", "def")
    end

end

function remDef(defence)

    deleteLine()

    local class = rime.status.class

    if defence == "defending" then act("wt I'm no longer defending.") end
    if defence == "insulation" then rime.silent_addAff("insulation") end
    if defence == "instawake" then rime.silent_addAff("instawake") end
    if defence == "rebounding" then rime.silent_addAff("rebounding") end
    if defence == "density" and not rime.saved.stability then rime.silent_addAff("density") end
    if defence == "waterbreathing" then rime.silent_addAff("waterbreathing") end
    if defence == "antivenin" then rime.silent_addAff("antivenin") end
    if defence == "levitation" then rime.silent_addAff("levitation") end
    if defence == "speed" then rime.silent_addAff("speed") end
    if defence == "deafness" then rime.silent_addAff("deaf") end
    if defence == "blindness" then rime.silent_addAff("blind") end
    if defence == "insomnia" and rime.has_possible_aff("asleep") then
        rime.add_aff("asleep", "discovered")
        if rime.has_aff("asleep") then rime.silent_remAff("asleep") end
    end
    if defence == "barrier" then send("firstaid on") end
    if defence == "houndmark" then rime.pvp.remove_aff("houndmark", rime.target) end
    if defence == "defending" then
        rime.targets[defending].defences.defended = false
        defending = false
    end
    if defence == "nodesense" then
        if rime.pve.leySearch.searching then
            rime.echo("You need to put nodesense back up if you want to continue hunting minors!!!", "pve")
        end
    end
    if defence == "delirium" then
        rime.ravager.delirium = false 
    end

    if table.contains(rime.defences[class], defence) then
        rime.echo("<CornflowerBlue>"..string.title(defence).."<red> inactive<white>. \("..class_color()..class.."<white>\)", "def")
        rime.defences[class][(defence)].deffed = false
        if rime.defences[class][(defence)].keepup then rime.defences[class][(defence)].need = true end
    elseif table.contains(rime.defences.general, defence) then
        rime.echo("<MediumPurple>"..string.title(defence).."<red> inactive<white>.", "def")
        rime.defences.general[(defence)].deffed = false
        if rime.defences.general[(defence)].keepup then rime.defences.general[(defence)].need = true end
    else
        rime.echo("Not tracking: <red>"..defence.."<white>.", "def")
    end

end

function resDefs()

    rime.silent_addAff("insulation")
    rime.silent_addAff("deaf")
    rime.silent_addAff("blind")
    rime.silent_addAff("rebounding")
    if not rime.saved.stability then rime.silent_addAff("density") end
    rime.silent_addAff("waterbreathing")
    rime.silent_addAff("instawake")
    rime.silent_addAff("levitation")
    rime.silent_addAff("speed")
    rime.silent_addAff("antivenin")

    local class = rime.status.class

    for k,v in pairs(rime.defences.general) do

        rime.defences.general[k].deffed = false

    end

    for k,v in pairs(rime.defences[class]) do

        rime.defences[class][k].deffed = false

    end

end

function has_def(defence)
    if gmcp.Char.Status == nil then return end
    local class = rime.status.class

    if table.contains(rime.defences[class], defence) then

        return rime.defences[class][defence].deffed

    end

    if table.contains(rime.defences.general, defence) then

        return rime.defences.general[defence].deffed

    end

end

function rime.pausedef(def, no_echo)
    local class = rime.status.class

    if table.contains(rime.defences[class], def) then
        rime.defences[class][def].need = false
        rime.defences[class][def].keepup = false
        if not no_echo then rime.echo("Paused "..def, "def") end
    end

    if table.contains(rime.defences.general, def) then
        rime.defences.general[def].need = false
        rime.defences.general[def].keepup = false
        if not no_echo then rime.echo("Paused "..def, "def") end
    end

end

function rime.unpausedef(def, no_echo)
    local class = rime.status.class

    if table.contains(rime.defences[class], def) then
        if rime.defences[class][def].deffed == false then
            rime.defences[class][def].need = true
        end
        if not no_echo then rime.echo("Unpaused "..def, "def") end
    end

    if table.contains(rime.defences.general, def) then
        if rime.defences.general[def].deffed == false then
            rime.defences.general[def].need = true
        end
        if not no_echo then rime.echo("Unpaused "..def, "def") end
    end

end

function rime.keepdef(def, no_echo)
    local class = rime.status.class

    if table.contains(rime.defences[class], def) then
        rime.defences[class][def].keepup = true
        if rime.defences[class][def].deffed == false then
            rime.defences[class][def].need = true
        end
        if not no_echo then rime.echo("Keeping "..def.." up", "def") end
    end

    if table.contains(rime.defences.general, def) then
        rime.defences.general[def].keepup = true
        if rime.defences.general[def].deffed == false then
            rime.defences.general[def].need = true
        end
        if not no_echo then rime.echo("Keeping "..def.." up", "def") end
    end

end

function rime.unkeepdef(def, no_echo)
    local class = rime.status.class

    if table.contains(rime.defences[class], def) then
        rime.defences[class][def].keepup = false
        if not no_echo then rime.echo("Not keeping "..def.." up", "def") end
    end

    if table.contains(rime.defences.general, def) then
        rime.defences.general[def].keepup = false
        if not no_echo then rime.echo("Not keeping "..def.." up", "def") end
    end

end

function rime.fuck_phantasms()

    local class = rime.status.class
    local manifestation_defs = {"influence", "congeal", "leech", "claw", "mire", "choke", "wail", "absorb", "siphon", "symbiosis"}
    local shit_to_axe = {}
    local sep = rime.saved.separator
    for k,v in ipairs(manifestation_defs) do
        if rime.defences[class]["phantasm_"..v].deffed and not rime.defences[class]["phantasm_"..v].need  then
            table.insert(shit_to_axe, "phantasm quell "..v)
        end
        if rime.defences[class]["chimera_"..v].deffed and not rime.defences[class]["chimera_"..v].need then
            table.insert(shit_to_axe, "phantasm quell chimerized "..v)
        end
    end

    local axe_command = table.concat(shit_to_axe, sep)

    act(axe_command)

end

function rime.fuck_manifestation()

    local manifestation_defs = {"influence", "congeal", "leech", "claw", "mire", "choke", "wail", "absorb", "siphon", "symbiosis"}
    for k,v in ipairs(manifestation_defs) do
        rime.pausedef("phantasm_"..v, "no")
        rime.pausedef("chimera_"..v, "no")
    end

end

function rime.fuck_disciplines()

    local class = rime.status.class
    local disciplines = {"research", "compounding", "biology", "pnp", "chemistry", "fieldstudies"}
    local oaths = {"forestwalker", "shaman", "blade", "tranquility", "primeval", "rhythm", "durdalis"}
    local shit_to_axe = {}
    local sep = rime.saved.separator
    if class == "Alchemist" then
        for k,v in ipairs(disciplines) do
            if rime.defences[class]["discipline_"..v].deffed and not rime.defences[class]["discipline_"..v].need then
                table.insert(shit_to_axe, "discipline "..v.." dismiss")
                rime.pausedef("disicpline_"..v, "no")
            end
        end
    elseif class == "Shaman" then
        for k,v in ipairs(oaths) do
            if rime.defences[class]["oath_"..v].deffed and not rime.defences[class]["oath_"..v].need then
                table.insert(shit_to_axe, "oath "..v.." disable")
                rime.pausedef("oath_"..v, "no")
            end
        end
    end

    local axe_command = table.concat(shit_to_axe, sep)

    act(axe_command)

end



function free_defs()
    local race = gmcp.Char.Status.race
    local class = rime.status.class
    local command = {}

    if not has_def("thirdeye") and not rime.limit.thirdeye and rime.defences.general.thirdeye.need then
        if rime.saved.goggles > 1 then
            table.insert(command, "goggle toggle thirdeye")
            limitStart("thirdeye")
        elseif hasSkill("Thirdeye") then
            table.insert(command, "thirdeye")
            limitStart("thirdeye")
        else
            table.insert(command, "eat acuity")
            limitStart("thirdeye")
        end
    end

    if rime.saved.vitality and not has_def("vitality") and rime.defences.general.vitality.need and rime.vitals.current_health == rime.vitals.max_health and rime.vitals.current_mana == rime.vitals.max_mana and not rime.limit.vitality then
        table.insert(command, "vitality")
        limitStart("vitality")
    end

    if not has_def("mist_blue") and not rime.limit.mist_blue and rime.defences.general.mist_blue.need then 
        table.insert(command, "activate blueorb")
        limitStart("mist_blue", .5)
    end
    if not has_def("mist_red") and not rime.limit.mist_red and rime.defences.general.mist_red.need then 
        table.insert(command, "activate redorb")
        limitStart("mist_red", .5)
    end
    if not has_def("mist_green") and not rime.limit.mist_green and rime.defences.general.mist_green.need then 
        table.insert(command, "activate greenorb")
        limitStart("mist_green", .5)
    end
    if not has_def("mist_yellow") and not rime.limit.mist_yellow and rime.defences.general.mist_yellow.need then 
        table.insert(command, "activate yelloworb")
        limitStart("mist_yellow", .5)
    end
    if not has_def("mist_white") and not rime.limit.mist_white and rime.defences.general.mist_white.need then 
        table.insert(command, "activate whiteorb")
        limitStart("mist_white", .5)
    end

    if not has_def("telesense") and not rime.limit.telesense and rime.defences.general.telesense.need then
        table.insert(command, "telesense on")
        limitStart("telesense")
    end

    if rime.saved.lifesense and not has_def("lifesense") and not rime.limit.lifesense and rime.defences.general.lifesense.need then
        table.insert(command, "lifesense")
        limitStart("lifesense")
    end

    if not has_def("density") and not rime.limit.density and rime.defences.general.density.need and rime.saved.stability then
        table.insert(command, "stability")
        limitStart("density")
    end

    if not has_def("mindseye") and not rime.limit.mindseye and rime.defences.general.mindseye.need then
        if rime.saved.goggles > 1 then
            table.insert(command, "goggle toggle mindseye")
            limitStart("mindseye")
        else
            table.insert(command, "touch allsight")
            table.insert(command, "touch mindseye")
            limitStart("mindseye")
        end
    end

    if not has_def("waterwalking") and not rime.limit.waterwalking and rime.defences.general.waterwalking.need then
        if not rime.saved.zephyr then
            table.insert(command, "touch waterwalking")
        else
            table.insert(command, "embrace zephyr")
        end
        limitStart("waterwalking")
    end

    if not has_def("nightsight") and not rime.limit.nightsight and rime.defences.general.nightsight.need then
        if rime.saved.goggles > 0 then
            table.insert(command, "goggle toggle nightsight")
            limitStart("nightsight")
        elseif hasSkill("Nightsight") then
            table.insert(command, "nightsight")
            limitStart("nightsight")
        end
    end

    if not rime.has_aff("slickness") and not has_def("fangbarrier") and not rime.limit.fangbarrier and rime.defences.general.fangbarrier.need then
        table.insert(command, "outc paste")
        table.insert(command, "apply paste")
    end

    if not has_def("insomnia") and not rime.limit.insomnia and rime.defences.general.insomnia.need and not rime.has_aff("hypersomnia") then
        if hasSkill("Insomnia") then
            table.insert(command, "insomnia")
            limitStart("insomnia")
        else
            table.insert(command, "eat kawhe")
            limitStart("insomnia")
        end
    end

    if not has_def("deathsight") and not rime.limit.deathsight and rime.defences.general.deathsight.need then
        table.insert(command, "eat thanatonin")
        limitStart("deathsight")
    end

    if not has_def("speed") and not rime.limit.speed and rime.defences.general.speed.need then
        table.insert(command, "sip speed")
        limitStart("speed", 7)
    end

    if not has_def("temperance") and not rime.limit.temperance and rime.defences.general.temperance.need then
        table.insert(command, "sip frost")
        limitStart("temperance")
    end

    if not has_def("concentrate") and hasSkill("Concentration", "Sanguis") and class == "Praenomen" and not rime.limit.concentrate and rime.defences.Praenomen.concentrate.need then
        table.insert(command, "blood concentrate")
        limitStart("concentrate")
    end

    if not has_def("manipulation_wisdom") and rime.defences.general.manipulation_wisdom.need then
        if wisdomTransmute then
            table.insert(command, "manipulate pylon for wisdom transmute")
        else
            table.insert(command, "manipulate pylon for wisdom")
        end
    end

    if not table.is_empty(command)  then
        command = table.concat(command, rime.saved.separator)
    else
        command = {}
    end

    if type(command) == "string" then
        act(command)
    end

    command = {}

    if not has_def("overwatch") and rime.saved.goggles > 4 and not rime.limit.overwatch and rime.defences.general.overwatch.need then
        table.insert(command, "goggle toggle overwatch")
        limitStart("overwatch")
    end

    if not has_def("insight") and rime.saved.goggles > 7 and not rime.limit.insight and rime.defences.general.insight.need then
        table.insert(command, "goggle toggle insight")
        limitStart("insight")
    end

    if not has_def("lifevision") and rime.saved.goggles > 8 and not rime.limit.lifevision and rime.defences.general.lifevision.need then
        table.insert(command, "goggle toggle lifevision")
        limitStart("lifevision")
    end

    if not has_def("lipreading") and rime.saved.goggles > 16 and not rime.limit.lipreading and rime.defences.general.lipreading.need then
        table.insert(command, "goggle toggle lipreading")
        limitStart("lipreading")
    end

    if rime.saved.hood and not has_def("chameleon") then
        local good_boy = {"Wedric", "Kikon", "Kylan", "Winger", "Strung", "Knick", "Faith", "Gracie", "Milvushina", "Searoth", "Draiman", "Mahakala"}
        local reward = math.random(1, #good_boy)
        table.insert(command, "chameleon " ..good_boy[reward])
        limitStart("chameleon")
    end

    if not table.is_empty(command)  then
        command = table.concat(command, rime.saved.separator)
    else
        command = {}
    end

    if type(command) == "string" then
        act(command)
    end

    command = {}

    if class == "Monk" then

        if not has_def("weathering") and hasSkill("Weathering") and not rime.limit.weathering and rime.defences[class].weathering.need then
            table.insert(command, "weathering")
            limitStart("weathering")
        end

        if not has_def("regeneration") and hasSkill("Regeneration") and not rime.limit.regeneration and rime.defences[class].regeneration.need then
            table.insert(command, "regeneration on")
            limitStart("regeneration")
        end

        if not has_def("toughness") and hasSkill("Toughness") and not rime.limit.toughness and rime.defences[class].toughness.need then
            table.insert(command, "toughness")
            limitStart("toughness")
        end

        if not has_def("resistance") and hasSkill("Resistance") and not rime.limit.resistance and rime.defences[class].resistance.need then
            table.insert(command, "resistance")
            limitStart("resistance")
        end

        if not has_def("consciousness") and hasSkill("Consciousness") and not rime.limit.consciousness and rime.defences[class].consciousness.need then
            table.insert(command, "consciousness on")
            limitStart("consciousness")
        end

        if not has_def("boosted_regen") and hasSkill("Boosting") and not rime.limit.boosted_regen and rime.defences[class].boosted_regen.need then
            table.insert(command, "boost regeneration")
            limitStart("boosted_regen")
        end

    elseif class == "Carnifex" then

        if not has_def("soulharvest") and hasSkill("Harvest") and not rime.limit.soulharvest and rime.defences[class].soulharvest.need then
            table.insert(command, "soul harvest on")
            limitStart("soulharvest")
        end

    elseif class == "Bard" then

        if not has_def("charisma") and hasSkill("Charisma") and not rime.limit.charisma and rime.defences[class].charisma.need then
            --table.insert(command, "charisma")
            --limitStart("charisma")
        end

    end

    if not table.is_empty(command)  then
        command = table.concat(command, rime.saved.separator)
    else
        command = {}
    end

    if type(command) == "string" then
        act(command)
    end

end

function def_up(queue)

    local race = gmcp.Char.Status.race
    local class = rime.status.class
    local balance_command = {}
    local command = {}  
    local sep = rime.saved.separator

    --balance defs, global
    if race:find("Azudim") and not (has_def("miasma") or has_def("safeguard") or has_def("warmth") or has_def("ward")) and not rime.limit.miasma and rime.defences.general.miasma.need then
        table.insert(balance_command, "miasma")
        limitStart("miasma")
    end
    if race == "Idreth" and not (has_def("miasma") or has_def("safeguard") or has_def("warmth") or has_def("ward")) and not rime.limit.miasma and rime.defences.general.safeguard.need then
        table.insert(balance_command, "safeguard")
        limitStart("miasma")
    end
    if race == "Yeleni" and not (has_def("miasma") or has_def("safeguard") or has_def("warmth") or has_def("ward")) and not rime.limit.miasma and rime.defences.general.warmth.need then
        table.insert(balance_command, "warmth")
        limitStart("miasma")
    end
    if race == "Titan" and not (has_def("miasma") or has_def("safeguard") or has_def("warmth") or has_def("ward")) and not rime.limit.miasma and rime.defences.general.safeguard.need then
        table.insert(balance_command, "safeguard")
        limitStart("miasma")
    end

    if race == "Seraph" and not (has_def("miasma") or has_def("safeguard") or has_def("warmth") or has_def("ward")) and not rime.limit.miasma and rime.defences.general.warmth.need then
        table.insert(balance_command, "warmth")
        limitStart("miasma")
    end

     if race == "Nocturn" and not (has_def("miasma") or has_def("safeguard") or has_def("warmth") or has_def("ward")) and not rime.limit.miasma and rime.defences.general.miasma.need then
        table.insert(balance_command, "miasma")
        limitStart("miasma")
    end

    if class == "Carnifex" then
        if not has_def("gripping") and rime.defences.Carnifex.gripping.need and hasSkill("Gripping") and not rime.limit.gripping and rime.defences[class].gripping.need then
            table.insert(balance_command, "grip")
            limitStart("gripping")
        end
        if not has_def("enfrost") and rime.defences.Carnifex.enfrost.need and hasSkill("Enfrost") and not rime.limit.enfrost and rime.defences[class].enfrost.need then
            table.insert(balance_command, "soul enfrost warhammer")
            limitStart("enfrost")
        end
    end

    if class == "Praenomen" then
        if not has_def("concentrate") and rime.defences.Praenomen.concentrate.need and hasSkill("Concentration", "Sanguis") and not rime.limit.concentration then
            table.insert(balance_command, "blood concentrate")
            limitStart("concentration")
        end
    end

    if class == "Bard" then
        if not has_def("charisma") and rime.defences.Bard.charisma.need and hasSkill("Charisma") and not rime.limit.charisma then
            table.insert(balance_command, "charisma")
            limitStart("charisma")
        end
    end

    if class == "Akkari" then
        if not has_def("ascetic") and rime.defences.Akkari.ascetic.need and hasSkill("Ascetic") and not rime.limit.ascetic then
            table.insert(balance_command, "spirit ascetic")
            limitStart("ascetic")
        end
    end

    if class == "Ravager" then 
        if not has_def("velocity") and rime.defences.Ravager.velocity.need and hasSkill("Velocity") and not rime.limit.velocity and rime.defences[class].velocity.need then
            table.insert(balance_command, "velocity")
            limitStart("velocity")
        end
    end

    if class == "Templar" then
        if not has_def("gripping") and rime.defences.Templar.gripping.need and hasSkill("Gripping") and not rime.limit.gripping and rime.defences[class].gripping.need then
            table.insert(balance_command, "grip")
            limitStart("gripping")
        end
    end

    if class == "Revenant" then
      if not has_def("gripping") and rime.defences.Revenant.gripping.need and hasSkill("Gripping") and not rime.limit.gripping and rime.defences[class].gripping.need then
          table.insert(balance_command, "grip")
          limitStart("gripping")
      end
    end

    if class == "Wayfarer" then
        if not has_def("axe_avert") and rime.defences.Wayfarer.axe_avert.need and hasSkill("Avert") and not rime.limit.avert then
            table.insert(balance_command, "axe avert on")
            limitStart("avert")
        end
        if not has_def("axe_obstruct") and rime.defences.Wayfarer.axe_obstruct.need and hasSkill("Obstruct") and not rime.limit.obstruct then
            table.insert(balance_command, "axe obstruct on")
            limitStart("obstruct")
        end
        if not has_def("axe_repel") and rime.defences.Wayfarer.axe_repel.need and hasSkill("Repel") and not rime.limit.repel then
            table.insert(balance_command, "axe repel on")
            limitStart("repel")
        end
        if not has_def("weathering") and rime.defences.Wayfarer.weathering.need and hasSkill("Weathering") and not rime.limit.weathering then
            table.insert(balance_command, "weathering")
            limitStart("weathering")
        end
        if not has_def("ironskin") and rime.defences.Wayfarer.ironskin.need and hasSkill("Ironskin") and not rime.limit.ironskin then
            table.insert(balance_command, "wayfare ironskin")
            limitStart("ironskin")
        end
        if not has_def("bloodtrails") and rime.defences.Wayfarer.bloodtrails.need and hasSkill("Bloodtrails") and not rime.limit.bloodtrails then
            table.insert(balance_command, "wayfare bloodtrails on")
            limitStart("bloodtrails")
        end
    end

    if not has_def("dodging") and rime.defences.general.dodging.need then
        table.insert(balance_command, "dodge melee")
    end

    if not has_def("cloak") and rime.defences.general.cloak.need then
        table.insert(balance_command, "touch cloak")
    elseif not has_def("clarity") and rime.defences.general.clarity.need and hasSkill("Clarity") then
        table.insert(balance_command, "clarity")
    elseif not has_def("hypersight") and rime.defences.general.hypersight.need then
        table.insert(balance_command, "hypersight on")
    elseif not has_def("divine_speed") and rime.defences.general.divine_speed.need then
        table.insert(balance_command, "grace")
    elseif not has_def("selfishness") and hasSkill("Selfishness") and rime.defences.general.selfishness.need then
        table.insert(balance_command, "selfishness")
    elseif not has_def("flame") and rime.defences.general.flame.need then
        table.insert(balance_command, "touch flame")
    elseif not has_def("lifevision") and rime.saved.lifevision and rime.defences.general.lifevision.need then
        table.insert(balance_command, "lifevision")
    elseif not has_def("manipulation_critical_field") and rime.defences.general.manipulation_critical_field.need then 
        table.insert(balance_command, "manipulate pylon for critical")
    elseif not has_def("manipulation_iridescence_field") and rime.defences.general.manipulation_iridescence_field.need then 
        table.insert(balance_command, "manipulate pylon for iridescence")
    elseif not has_def("manipulation_wealth") and rime.defences.general.manipulation_wealth.need then 
        table.insert(balance_command, "manipulate pylon for wealth")

        --class defs

    elseif class == "Strife" then
        if not has_def("adherent_barrier") and rime.defences.Strife.adherent_barrier.need then
            table.insert(balance_command, "adherent barrier")
        elseif not has_def("adherent_presence") and rime.defences.Strife.adherent_presence.need then
            table.insert(balance_command, "adherent presence on")
        elseif not has_def("adherent_turmoil") and rime.defences.Strife.adherent_turmoil.need then
            table.insert(balance_command, "adherent turmoil on")
        elseif not has_def("adherent_synchroneity") and rime.defences.Strife.adherent_synchroneity.need then
            table.insert(balance_command, "adherent synchroneity on")
        elseif not has_def("adherent_mortalfire") and rime.defences.Strife.adherent_mortalfire.need then
            table.insert(balance_command, "adherent mortalfire")
        end

    elseif class == "Tyranny" then
        if not has_def("adherent_barrier") and rime.defences.Tyranny.adherent_barrier.need then
            table.insert(balance_command, "adherent barrier")
        elseif not has_def("adherent_presence") and rime.defences.Tyranny.adherent_presence.need then
            table.insert(balance_command, "adherent presence on")
        elseif not has_def("adherent_indomitable") and rime.defences.Tyranny.adherent_indomitable.need then
            table.insert(balance_command, "adherent indomitable on")
        elseif not has_def("adherent_synchroneity") and rime.defences.Tyranny.adherent_synchroneity.need then
            table.insert(balance_command, "adherent synchroneity on")
        elseif not has_def("adherent_mortalfire") and rime.defences.Tyranny.adherent_mortalfire.need and not has_def("adherent_mortalfire_stored") then
            table.insert(balance_command, "adherent mortalfire")
        elseif not has_def("adherent_mortalfire_stored") and rime.defences.Tyranny.adherent_mortalfire_stored.need and not has_def("adherent_mortalfire") then
            table.insert(balance_command, "adherent mortalfire store")
        end

    elseif class == "Corruption" then
        if not has_def("adherent_barrier") and rime.defences.Corruption.adherent_barrier.need then
            table.insert(balance_command, "adherent barrier")
        elseif not has_def("adherent_presence") and rime.defences.Corruption.adherent_presence.need then
            table.insert(balance_command, "adherent presence on")
        elseif not has_def("adherent_acid") and rime.defences.Corruption.adherent_acid.need then
            table.insert(balance_command, "adherent acid on")
        elseif not has_def("adherent_synchroneity") and rime.defences.Corruption.adherent_synchroneity.need then
            table.insert(balance_command, "adherent synchroneity on")
        elseif not has_def("adherent_mortalfire") and rime.defences.Corruption.adherent_mortalfire.need then
            table.insert(balance_command, "adherent mortalfire")
        end

    elseif class == "Seraph" then
        if not has_def("seraph_halo") and rime.defences.Seraph.seraph_halo.need then
            table.insert(balance_command, "seraph halo")
        elseif not has_def("seraph_presence") and rime.defences.Seraph.seraph_presence.need then
            table.insert(balance_command, "seraph presence on")
        elseif not has_def("seraph_radiate") and rime.defences.Seraph.seraph_radiate.need then
            table.insert(balance_command, "seraph radiate on")
        elseif not has_def("seraph_parhelion") and rime.defences.Seraph.seraph_parhelion.need then
            table.insert(balance_command, "seraph parhelion on")
        elseif not has_def("seraph_corona_stored") and rime.defences.Seraph.seraph_corona_stored.need then
            table.insert(balance_command, "seraph corona store")
        end

    elseif class == "Nocturn" then
        if not has_def("nocturn_bloodcoat") and rime.defences.Nocturn.nocturn_bloodcoat.need then
            table.insert(balance_command, "nocturn bloodcoat")
        elseif not has_def("nocturn_presence") and rime.defences.Nocturn.nocturn_presence.need then
            table.insert(balance_command, "nocturn presence on")
        elseif not has_def("nocturn_haze") and rime.defences.Nocturn.nocturn_haze.need then
            table.insert(balance_command, "nocturn haze on")
        elseif not has_def("nocturn_double") and rime.defences.Nocturn.nocturn_double.need then
            table.insert(balance_command, "nocturn double on")
        elseif not has_def("nocturn_shadow_stored") and rime.defences.Nocturn.nocturn_shadow_stored.need then
            table.insert(balance_command, "nocturn shadow store")
        end

    elseif class == "Memory" then
        if not has_def("adherent_barrier") and rime.defences.Memory.adherent_barrier.need then
            table.insert(balance_command, "adherent barrier")
        elseif not has_def("adherent_presence") and rime.defences.Memory.adherent_presence.need then
            table.insert(balance_command, "adherent presence on")
        elseif not has_def("adherent_ruination") and rime.defences.Memory.adherent_ruination.need then 
            table.insert(balance_command, "adherent ruination on")
        elseif not has_def("adherent_synchroneity") and rime.defences.Memory.adherent_synchroneity.need then
            table.insert(balance_command, "adherent synchroneity on")
        elseif not has_def("adherent_mortalfire_stored") and rime.defences.Memory.adherent_mortalfire_stored.need then
            table.insert(balance_command, "adherent mortalfire store")
        end

    elseif class == "Titan" then
        if not has_def("titan_irradiance") and rime.defences["Titan"].titan_irradiance.need then
            table.insert(balance_command, "titan irradiance")
        elseif not has_def("titan_presence") and rime.defences["Titan"].titan_presence.need then
            table.insert(balance_command, "titan presence on")
        elseif not has_def("titan_disruption") and rime.defences["Titan"].titan_disruption.need then
            table.insert(balance_command, "titan disruption on")
        elseif not has_def("titan_multicore") and rime.defences["Titan"].titan_multicore.need then
            table.insert(balance_command, "titan multicore on")
        elseif not has_def("titan_remnant_stored") and rime.defences["Titan"].titan_remnant_stored.need then
            table.insert(balance_command, "titan remnant store")
        elseif not has_def("titan_remnant") and rime.defences["Titan"].titan_remnant.need then
            table.insert(balance_command, "titan_remnant")
    end

    elseif class == "Bloodborn" then
        if not has_def("forestall") and rime.defences.Bloodborn.forestall.need and hasSkill("Forestall") then
            table.insert(balance_command, "unleash forestall")
        elseif not has_def("panoply") and rime.defences.Bloodborn.panoply.need and hasSkill("Panoply") then
            table.insert(balance_command, "unleash panoply")
        elseif not has_def("empowered_moon") and rime.defences.Bloodborn.empowered_moon.need and hasSkill("Acumen") then
            table.insert(balance_command, "unleash acumen")
        elseif not has_def("victimise") and rime.defences.Bloodborn.victimise.need and hasSkill("Victimise") then
            table.insert(balance_command, "unleash victimise")
        elseif not has_def("fettered") and rime.defences.Bloodborn.fettered.need and hasSkill("Fettered") then
            table.insert(balance_command, "well fetter on")
        end

    elseif class == "Alchemist" then

        if not has_def("conduit_crutch") and hasSkill("Crutch") and rime.defences.Alchemist.conduit_crutch.need then
            table.insert(balance_command, "derive crutch")
        elseif not has_def("resuscitation") and hasSkill("Resuscitation") and rime.defences.Alchemist.resuscitation.need and not alchemist.resuscitation_cooldown then
            table.insert(balance_command, "alchemy resuscitation")
        elseif not has_def("blightbringer") and hasSkill("Blightbringer") and rime.defences.Alchemist.blightbringer.need then
            table.insert(balance_command, "botany blightbringer on")
        elseif not has_def("obfuscation") and hasSkill("Obfuscation") and rime.defences.Alchemist.obfuscation.need then
            table.insert(balance_command, "derive obfuscation")
        elseif not has_def("discipline_fieldstudies") and hasSkill("Disciplines") and rime.defences.Alchemist.discipline_fieldstudies.need then
            table.insert(balance_command, "discipline field studies recall")
        elseif not has_def("discipline_research") and hasSkill("Disciplines") and rime.defences.Alchemist.discipline_research.need then
            table.insert(balance_command, "discipline research recall")
        elseif not has_def("discipline_compounding") and hasSkill("Disciplines") and rime.defences.Alchemist.discipline_compounding.need then
            table.insert(balance_command, "discipline compounding recall")
        elseif not has_def("discipline_biology") and hasSkill("Disciplines") and rime.defences.Alchemist.discipline_biology.need then
            table.insert(balance_command, "discipline biology recall")
        elseif not has_def("discipline_experimentation") and hasSkill("Disciplines") and rime.defences.Alchemist.discipline_experimentation.need then
            table.insert(balance_command, "discipline experimentation recall")
        elseif not has_def("discipline_pnp") and hasSkill("Disciplines") and rime.defences.Alchemist.discipline_pnp.need then
            table.insert(balance_command, "discipline procedure protocol recall")
        elseif not has_def("discipline_chemistry") and hasSkill("Disciplines") and rime.defences.Alchemist.discipline_chemistry.need then
            table.insert(balance_command, "discipline chemistry recall")
        end

    elseif class == "Shaman" then

        if not has_def("shaman_warding") and hasSkill("Warding") and rime.defences.Shaman.shaman_warding.need then
            table.insert(balance_command, "shamanism warding on")
        elseif not has_def("lifebloom") and hasSkill("Lifebloom") and rime.defences.Shaman.lifebloom.need and not alchemist.resuscitation_cooldown then
            table.insert(balance_command, "commune lifebloom")
        elseif not has_def("greenfoot") and hasSkill("Greenfoot") and rime.defences.Shaman.greenfoot.need then
            table.insert(balance_command, "nature greenfoot on")
        elseif not has_def("protection") and hasSkill("Protection") and rime.defences.Shaman.protection.need then
            table.insert(balance_command, "shaman protection")
        elseif not has_def("oath_forestwalker") and hasSkill("Oaths") and rime.defences.Shaman.oath_forestwalker.need then
            table.insert(balance_command, "oath forestwalker activate")
        elseif not has_def("oath_shaman") and hasSkill("Oaths") and rime.defences.Shaman.oath_shaman.need then
            table.insert(balance_command, "oath eldershaman activate")
        elseif not has_def("oath_blade") and hasSkill("Oaths") and rime.defences.Shaman.oath_blade.need then
            table.insert(balance_command, "oath naturesblade activate")
        elseif not has_def("oath_tranquility") and hasSkill("Oaths") and rime.defences.Shaman.oath_tranquility.need then
            table.insert(balance_command, "oath tranquility activate")
        elseif not has_def("oath_primeval") and hasSkill("Oaths") and rime.defences.Shaman.oath_primeval.need then
            table.insert(balance_command, "oath primeval activate")
        elseif not has_def("oath_durdalis") and hasSkill("Oaths") and rime.defences.Shaman.oath_durdalis.need then
            table.insert(balance_command, "oath durdalis activate")
        end

    elseif class == "Bard" then

        if not has_def("halfbeat") and hasSkill("Halfbeat") and rime.defences.Bard.halfbeat.need then
            table.insert(balance_command, "halfbeat on")
        elseif not has_def("destiny") and hasSkill("Destiny") and rime.defences.Bard.destiny.need and not rime.bard.singing then
            table.insert(balance_command, "sing song of destiny")
        elseif not has_def("sheath") and hasSkill("Sheath") and rime.defences.Bard.sheath.need and rime.vitals.dithering < 1 then
            table.insert(balance_command, "weave sheath")
        elseif not has_def("aurora") and hasSkill("Aurora") and rime.defences.Bard.aurora.need and rime.vitals.dithering < 1 then
            table.insert(balance_command, "weave aurora")
        elseif not has_def("discordance") and hasSkill("Discordance") and rime.defences.Bard.discordance.need then
            table.insert(balance_command, "discordance")
        elseif not has_def("euphonia") and hasSkill("Euphonia") and rime.defences.Bard.euphonia.need then
            table.insert(balance_command, "euphonia")
        elseif not has_def("stretching") and hasSkill("Stretching") and rime.defences.Bard.stretching.need then
            table.insert(balance_command, "stretching on")
        elseif not has_def("tolerance") and hasSkill("Tolerance") and rime.defences.Bard.tolerance.need then
            table.insert(balance_command, "tolerance")
        end

    elseif class == "Monk" then

        if not has_def("vitality") and rime.defences.Monk.vitality.need and hasSkill("Vitality") then
            table.insert(balance_command, "vitality")
        elseif not has_def("split_mind") and rime.defences.Monk.split_mind.need and hasSkill("Splitting") then
            table.insert(balance_command, "split mind")
        end

    elseif class == "Sciomancer" then

        if not has_def("shadow_mantle") and rime.defences.Sciomancer.shadow_mantle.need and hasSkill("Mantle") then
            table.insert(balance_command, "cast mantle")
        elseif not has_def("blurring") and rime.defences.Sciomancer.blurring.need   and hasSkill("Blurring") then
            table.insert(balance_command, "cast blurring")
        elseif not has_def("shadow_engulf") and rime.defences.Sciomancer.shadow_engulf.need and hasSkill("Engulf") then
            table.insert(balance_command, "cast engulf on")
        elseif not has_def("empowered_moon") and rime.defences.Sciomancer.empowered_moon.need   and hasSkill("Sagacity") then
            table.insert(balance_command, "cast sagacity")
        elseif not has_def("featherstep") and rime.defences.Sciomancer.featherstep.need and hasSkill("Featherstep") then
            table.insert(balance_command, "gravity featherstep")
        elseif not has_def("rigor") and rime.defences.Sciomancer.rigor.need and hasSkill("Rigor") then
            table.insert(balance_command, "cast rigor on")
        end

    elseif class == "Shapeshifter" then

        if not has_def("celerity") and rime.defences.Shapeshifter.celerity.need and hasSkill("Endurance") then
            table.insert(balance_command, "endurance")
        elseif not has_def("hardening") and rime.defences.Shapeshifter.hardening.need   and hasSkill("Hardening") then
            table.insert(balance_command, "harden bones")
        elseif not has_def("thickhide") and rime.defences.Shapeshifter.thickhide.need   and hasSkill("Thickhide") then
            table.insert(balance_command, "thickhide")
        elseif not has_def("metabolism") and rime.defences.Shapeshifter.metabolism.need and hasSkill("Metabolize") then
            table.insert(balance_command, "metabolize on")
        elseif not has_def("bodyheat") and rime.defences.Shapeshifter.bodyheat.need and hasSkill("Bodyheat") then
            table.insert(balance_command, "bodyheat")
        elseif not has_def("cornering") and rime.defences.Shapeshifter.cornering.need   and hasSkill("Cornering") then
            table.insert(balance_command, "corner on")
        elseif not has_def("boneshaking") and rime.defences.Shapeshifter.boneshaking.need   and hasSkill("Boneshaking") then
            table.insert(balance_command, "boneshaking on")
        elseif not has_def("berserk") and rime.defences.Shapeshifter.berserk.need   and hasSkill("Berserk") then
            table.insert(balance_command, "berserk")
        end

  elseif class == "Teradrim" then

        if not has_def("stonebind") and rime.defences.Teradrim.stonebind.need   and hasSkill("Stonebind") then
            table.insert(balance_command, "earth stonebind")
        elseif not has_def("surefooted") and rime.defences.Teradrim.surefooted.need and hasSkill("Surefooted") then
            table.insert(balance_command, "earth surefooted")
        elseif not has_def("twinsoul") and rime.defences.Teradrim.twinsoul.need and hasSkill("Twinsoul") then
            table.insert(balance_command, "golem twinsoul on")
        elseif not has_def("rune_mark_pvp") and rime.defences.Teradrim.rune_mark_pvp.need and hasSkill("Runemark") then
            table.insert(balance_command, "outc 2 red")
            table.insert(balance_command, "outc 1 purple")
            table.insert(balance_command, "earth inscribe purple upon red")
        elseif not has_def("rune_mark_pve") and rime.defences.Teradrim.rune_mark_pve.need and hasSkill("Runemark") then
            table.insert(balance_command, "outc 2 blue")
            table.insert(balance_command, "outc 1 red")
            table.insert(balance_command, "earth inscribe red upon blue")
        elseif not has_def("rune_mark_group") and rime.defences.Teradrim.rune_mark_group.need and hasSkill("Runemark") then
            table.insert(balance_command, "outc 3 green")
            table.insert(balance_command, "earth inscribe green upon green")
        elseif not has_def("earth_resonance") and rime.defences.Teradrim.earth_resonance.need and hasSkill("Resonance") then
            table.insert(balance_command, "earth resonance")
        elseif not has_def("entwine") and rime.defences.Teradrim.entwine.need   and hasSkill("Entwine") then
            table.insert(balance_command, "earth entwine")
        elseif not has_def("ricochet") and rime.defences.Teradrim.ricochet.need and hasSkill("Ricochet") then
            table.insert(balance_command, "earth ricochet")
        elseif not has_def("sand_conceal") and rime.defences.Teradrim.sand_conceal.need and hasSkill("Concealment") then
            table.insert(balance_command, "sand conceal on")
        elseif not has_def("imbue_erosion") and rime.defences.Teradrim.imbue_erosion.need   and hasSkill("Erosion") then
            table.insert(balance_command, "earth imbue erosion")
        elseif not has_def("imbue_stonefury") and rime.defences.Teradrim.imbue_stonefury.need   and hasSkill("Stonefury") then
            table.insert(balance_command, "earth imbue stonefury")
        elseif not has_def("earthenform") and rime.defences.Teradrim.earthenform.need   and hasSkill("Earthenform") then
            table.insert(balance_command, "earthenform embrace")
        end

    elseif class == "Infiltrator" then

        if not has_def("warding") and rime.defences.Infiltrator.warding.need and hasSkill("Warding") then
            table.insert(balance_command, "warding")
        elseif not has_def("finesse") and rime.defences.Infiltrator.finesse.need and hasSkill("Finesse") then
            table.insert(balance_command, "finesse")
        elseif not has_def("hiding") and rime.defences.Infiltrator.hiding.need   and hasSkill("Hide") and not has_def("phased") and rime.defences.Infiltrator.phased.need then
            table.insert(balance_command, "hide")
        elseif not has_def("ghosted") and rime.defences.Infiltrator.ghosted.need and hasSkill("Ghost") then
            table.insert(balance_command, "conjure ghost")
        elseif not has_def("shroud") and rime.defences.Infiltrator.shroud.need   and hasSkill("Cloak") then
            table.insert(balance_command, "conjure cloak")
        elseif not has_def("lipreading") and rime.defences.Infiltrator.lipreading.need   and hasSkill("Lipread") then
            table.insert(balance_command, "lipread")
        elseif not has_def("shadowsight") and rime.defences.Infiltrator.shadowsight.need and hasSkill("Shadowsight") then
            table.insert(balance_command, "shadowsight")
        end

    elseif class == "Praenomen" then
        if not has_def("fortify") and rime.defences.Praenomen.fortify.need  and hasSkill("Fortify") then
            table.insert(balance_command, "fortify")
        elseif not has_def("corpus_warding") and rime.defences.Praenomen.corpus_warding.need and hasSkill("Warding") then
            table.insert(balance_command, "ward")
        elseif not has_def("lifescent") and rime.defences.Praenomen.lifescent.need  and hasSkill("Lifescent") then
            table.insert(balance_command, "lifescent")
        elseif not has_def("celerity") and rime.defences.Praenomen.celerity.need    and hasSkill("Celerity") then
            table.insert(balance_command, "celerity")
        elseif not has_def("blurred") and rime.defences.Praenomen.blurred.need  and hasSkill("Blur") then
            table.insert(balance_command, "blood blur")
        elseif not has_def("trepidation") and rime.defences.Praenomen.trepidation.need  and hasSkill("Trepidation") then
            table.insert(balance_command, "blood trepidation")
        elseif not has_def("shadowblow") and rime.defences.Praenomen.shadowblow.need    and hasSkill("Shadow") then
            table.insert(balance_command, "blood shadow")
        elseif not has_def("potence_strength") and rime.defences.Praenomen.potence_strength.need and hasSkill("Potence") then
            table.insert(balance_command, "potence strength")
        elseif not has_def("potence_constitution") and rime.defences.Praenomen.potence_constitution.need and hasSkill("Potence") then
            table.insert(balance_command, "potence constitution")
        elseif not has_def("bloodtrack") and rime.defences.Praenomen.bloodtrack.need    and hasSkill("Track") then
            table.insert(balance_command, "blood track")
        elseif not has_def("lifevision") and rime.defences.Praenomen.lifevision.need    and hasSkill("Lifevision") then
            table.insert(balance_command, "lifevision")
        elseif not has_def("elusion") and rime.defences.Praenomen.elusion.need  and hasSkill("Elusion") then
            table.insert(balance_command, "elusion on")
        elseif not has_def("bloodrage") and rime.defences.Praenomen.bloodrage.need and hasSkill("Enrage") then
            table.insert(balance_command, "blood enrage")
        end

    elseif class == "Akkari" then

        if not has_def("relentless") and rime.defences.Akkari.relentless.need and hasSkill("Relentless") then
            table.insert(balance_command, "relentless")
        elseif not has_def("resolved") and rime.defences.Akkari.resolved.need and hasSkill("Resolve") then
            table.insert(balance_command, "resolve")
        elseif not has_def("acuity") and rime.defences.Akkari.acuity.need and hasSkill("Acuity", "Ascendance") then
            table.insert(balance_command, "acuity")
        elseif not has_def("celerity") and rime.defences.Akkari.celerity.need and hasSkill("Celerity") then
            table.insert(balance_command, "celerity")
        elseif not has_def("suppressed") and rime.defences.Akkari.suppressed.need and hasSkill("Suppress") then
            table.insert(balance_command, "spirit suppress")
        elseif not has_def("holylight") and rime.defences.Akkari.holylight.need and hasSkill("Light", "Discipline") then
            table.insert(balance_command, "spirit light")
        elseif not has_def("retaliation") and rime.defences.Akkari.retaliation.need and hasSkill("Retaliation") then
            table.insert(balance_command, "spirit retaliation")
        elseif not has_def("ardour_strength") and rime.defences.Akkari.ardour_strength.need and hasSkill("Ardour") then
            table.insert(balance_command, "ardour strength")
        elseif not has_def("ardour_constitution") and rime.defences.Akkari.ardour_constitution.need and hasSkill("Ardour") then
            table.insert(balance_command, "ardour constitution")
        elseif not has_def("perceive") and rime.defences.Akkari.perceive.need and hasSkill("Perceive", "Discipline") then
            table.insert(balance_command, "spirit perceive")
        elseif not has_def("lifevision") and rime.defences.Akkari.lifevision.need and hasSkill("Lifevision") then
            table.insert(balance_command, "lifevision")
        elseif not has_def("transience") and rime.defences.Akkari.transience.need and hasSkill("Transience") then
            table.insert(balance_command, "transience")
        end

    elseif class == "Executor" then

        if not has_def("vitality") and rime.defences.Executor.vitality.need and hasSkill("Vitality") and rime.vitals.current_health == rime.vitals.max_health and rime.vitals.current_mana == rime.vitals.max_mana and not execute.cooldowns.vitality then
            table.insert(balance_command, "vitality")
        elseif not has_def("girded") and rime.defences.Executor.girded.need and hasSkill("Gird") then
            table.insert(balance_command, "gird")
        elseif not has_def("stoicism") and rime.defences.Executor.stoicism.need and hasSkill("Stoicism") then
            table.insert(balance_command, "stoicism")
        elseif not has_def("inspirited") and rime.defences.Executor.inspirited.need and hasSkill("Inspirit") and not execute.cooldowns.inspirit then
            table.insert(balance_command, "inspirit")
        elseif not has_def("bounding") and rime.defences.Executor.bounding.need and hasSkill("Bounding") then
            table.insert(balance_command, "bounding")
        elseif not has_def("concealed") and rime.defences.Executor.concealed.need and hasSkill("Conceal") then
            table.insert(balance_command, "conceal")
        elseif not has_def("bloodlust") and rime.defences.Executor.bloodlust.need and hasSkill("Bloodlust") then
            table.insert(balance_command, "bloodlust")
        elseif not has_def("efficiency") and rime.defences.Executor.efficiency.need and hasSkill("Efficiency") then
            table.insert(balance_command, "efficiency")
        elseif not has_def("limberness") and rime.defences.Executor.limberness.need and hasSkill("Limberness") then
            table.insert(balance_command, "limberness")
        end


    elseif class == "Sentinel" then

        if not has_def("vitality") and rime.defences.Sentinel.vitality.need and hasSkill("Vitality") and rime.vitals.current_health == rime.vitals.max_health and rime.vitals.current_mana == rime.vitals.max_mana then
            table.insert(balance_command, "vitality")
        elseif not has_def("barkskin") and rime.defences.Sentinel.barkskin.need and hasSkill("Barkskin") then
            table.insert(balance_command, "barkskin")
        elseif not has_def("hardiness") and rime.defences.Sentinel.hardiness.need and hasSkill("Hardiness") then
            table.insert(balance_command, "hardiness")
        elseif not has_def("refreshed") and rime.defences.Sentinel.refreshed.need and hasSkill("Refresh") then
            table.insert(balance_command, "refresh body")
        elseif not has_def("foreststride") and rime.defences.Sentinel.foreststride.need and hasSkill("Foreststriding") then
            table.insert(balance_command, "foreststride")
        elseif not has_def("concealed") and rime.defences.Sentinel.concealed.need and hasSkill("Conceal") then
            table.insert(balance_command, "conceal")
        elseif not has_def("lifesap") and rime.defences.Sentinel.lifesap.need and hasSkill("Lifesap") then
            table.insert(balance_command, "lifesap")
        end

    elseif class == "Carnifex" then
        if not has_def("soul_fortify") and rime.defences.Carnifex.soul_fortify.need and hasSkill("Fortify") then
            table.insert(balance_command, "soul fortify")
        elseif not has_def("soul_fracture") and rime.defences.Carnifex.soul_fracture.need   and hasSkill("Fracture") then
            table.insert(balance_command, "soul fracture")
        elseif not has_def("soulthirst") and rime.defences.Carnifex.soulthirst.need and hasSkill("Soulthirst") then
            table.insert(balance_command, "soul thirst")
        elseif not has_def("soulbind") and rime.defences.Carnifex.soulbind.need and hasSkill("Soulbind") then
            table.insert(balance_command, "soul bind")
        elseif not has_def("cruelty") and rime.defences.Carnifex.cruelty.need   and hasSkill("Cruelty") then
            table.insert(balance_command, "cruelty")
        elseif not has_def("reckless") and rime.defences.Carnifex.reckless.need and hasSkill("Reckless") then
            table.insert(balance_command, "recklessness on")
        elseif not has_def("soul_substitute") and rime.defences.Carnifex.soul_substitute.need and hasSkill("Substitute") then
            table.insert(balance_command, "soul substitute")
        elseif not has_def("herculeanrage") and rime.defences.Carnifex.herculeanrage.need and hasSkill("HerculeanRage") then
            table.insert(balance_command, "hammer rage on")
        elseif not has_def("reveling") and rime.defences.Carnifex.reveling.need and hasSkill("Reveling") then
            table.insert(balance_command, "reveling on")
        end
        if not has_def("fearless") and rime.defences.Carnifex.fearless.need and hasSkill("Fearless") then
            table.insert(command, "fearless")
        end

    elseif class == "Indorani" then
        if not has_def("lifevision") and rime.defences.Indorani.lifevision.need and hasSkill("Lifevision") then
            table.insert(balance_command, "lifevision")
        elseif not has_def("chariot") and rime.defences.Indorani.chariot.need   and hasSkill("Chariot") then
            table.insert(balance_command, "fling chariot at ground")
        elseif not has_def("devilpact") and rime.defences.Indorani.devilpact.need   and hasSkill("Devil") then
            table.insert(balance_command, "fling devil at ground")
        elseif not has_def("eclipse") and rime.defences.Indorani.eclipse.need   and hasSkill("Eclipse") then
            table.insert(balance_command, "fling eclipse at me")
        elseif not has_def("hierophant") and rime.defences.Indorani.hierophant.need and hasSkill("Hierophant") then
            table.insert(balance_command, "fling hierophant at me")
        elseif not has_def("gravechill") and rime.defences.Indorani.gravechill.need and hasSkill("Gravechill") then
            table.insert(balance_command, "gravechill")
        elseif not has_def("shroud") and rime.defences.Indorani.shroud.need and hasSkill("Shroud") then
            table.insert(balance_command, "shroud")
        elseif not has_def("morisensus") and rime.defences.Indorani.morisensus.need and hasSkill("Morisensus") then 
            table.insert(balance_command, "morisensus")
        elseif not has_def("soulcage") and rime.defences.Indorani.soulcage.need and hasSkill("Soulcage") then
            table.insert(balance_command, "soulcage")
        elseif not has_def("vengeance") and rime.defences.Indorani.vengeance.need and hasSkill("Vengeance") then
            table.insert(balance_command, "vengeance")
        elseif not has_def("putrefaction") and rime.defences.Indorani.putrefaction.need and rime.defences.Indorani.putrefaction.keepup and hasSkill("Putrefaction") then
            table.insert(balance_command, "putrefaction")
        elseif not has_def("deathaura") and rime.defences.Indorani.deathaura.need and rime.defences.Indorani.deathaura.keepup and hasSkill("Deathaura") then
            table.insert(balance_command, "deathaura on")
        end

    elseif class == "Archivist" then
        if not has_def("spheres") and rime.defences.Archivist.spheres.need  and hasSkill("Spheres") then
            table.insert(balance_command, "contemplate spheres")
        elseif not has_def("dilation") and rime.defences.Archivist.dilation.need    and hasSkill("Dilation") then
            table.insert(balance_command, "elicit dilation")
        elseif not has_def("sublimation") and rime.defences.Archivist.sublimation.need  and hasSkill("Sublimation") then
            table.insert(balance_command, "elicit sublimation")
        elseif not has_def("linked") and rime.defences.Archivist.linked.need    and hasSkill("Link") then
            table.insert(balance_command, "elicit link 50")
        elseif not has_def("ameliorate") and rime.defences.Archivist.ameliorate.need    and hasSkill("Ameliorate") then
            table.insert(balance_command, "bio ameliorate")
        elseif not has_def("catabolism") and rime.defences.Archivist.catabolism.need    and hasSkill("Catabolism") then
            table.insert(balance_command, "bio catabolism")
        end

      elseif class == "Revenant" then
        if not has_def("maingauche") and rime.defences.Revenant.maingauche.need and hasSkill("MainGauche") then
            table.insert(balance_command, "maingauche")
        elseif not has_def("chimera_influence") and rime.defences.Revenant.chimera_influence.need and hasSkill("Influence") then
            table.insert(balance_command, "phantasm devour influence")
        elseif not has_def("chimera_congeal") and rime.defences.Revenant.chimera_congeal.need and hasSkill("Congeal") then
          table.insert(balance_command, "phantasm devour congeal")
        elseif not has_def("chimera_leech") and rime.defences.Revenant.chimera_leech.need and hasSkill("Leech") then
          table.insert(balance_command, "phantasm devour leech")
        elseif not has_def("chimera_absorb") and rime.defences.Revenant.chimera_absorb.need and hasSkill("Absorb") then
          table.insert(balance_command, "phantasm devour absorb")
        elseif not has_def("chimera_mire") and rime.defences.Revenant.chimera_mire.need and hasSkill("Mire") then
          table.insert(balance_command, "phantasm devour mire")
        elseif not has_def("chimera_choke") and rime.defences.Revenant.chimera_choke.need and hasSkill("Choke") then
          table.insert(balance_command, "phantasm devour choke")
        elseif not has_def("chimera_wail") and rime.defences.Revenant.chimera_wail.need and hasSkill("Wail") then
          table.insert(balance_command, "phantasm devour wail")
        elseif not has_def("chimera_claw") and rime.defences.Revenant.chimera_claw.need and hasSkill("Claw") then
          table.insert(balance_command, "phantasm devour claw")
        elseif not has_def("chimera_siphon") and rime.defences.Revenant.chimera_siphon.need and hasSkill("Siphon") then
          table.insert(balance_command, "phantasm devour siphon")
        elseif not has_def("chimera_symbiosis") and rime.defences.Revenant.chimera_symbiosis.need and hasSkill("Symbiosis") then
          table.insert(balance_command, "phantasm devour symbiosis")
        elseif not has_def("phantasm_influence") and rime.defences.Revenant.phantasm_influence.need and hasSkill("Influence") then
          table.insert(balance_command, "phantasm influence")
        elseif not has_def("phantasm_congeal") and rime.defences.Revenant.phantasm_congeal.need and hasSkill("Congeal") then
          table.insert(balance_command, "phantasm congeal")
        elseif not has_def("phantasm_leech") and rime.defences.Revenant.phantasm_leech.need and hasSkill("Leech") then
          table.insert(balance_command, "phantasm leech")
        elseif not has_def("phantasm_absorb") and rime.defences.Revenant.phantasm_absorb.need and hasSkill("Absorb") then
          table.insert(balance_command, "phantasm absorb")
        elseif not has_def("phantasm_mire") and rime.defences.Revenant.phantasm_mire.need and hasSkill("Mire") then
          table.insert(balance_command, "phantasm mire")
        elseif not has_def("phantasm_choke") and rime.defences.Revenant.phantasm_choke.need and hasSkill("Choke") then
          table.insert(balance_command, "phantasm choke")
        elseif not has_def("phantasm_wail") and rime.defences.Revenant.phantasm_wail.need and hasSkill("Wail") then
          table.insert(balance_command, "phantasm wail")
        elseif not has_def("phantasm_claw") and rime.defences.Revenant.phantasm_claw.need and hasSkill("Claw") then
          table.insert(balance_command, "phantasm claw")
        elseif not has_def("phantasm_siphon") and rime.defences.Revenant.phantasm_siphon.need and hasSkill("Siphon") then
          table.insert(balance_command, "phantasm siphon")
        elseif not has_def("phantasm_symbiosis") and rime.defences.Revenant.phantasm_symbiosis.need and hasSkill("Symbiosis") then
          table.insert(balance_command, "phantasm symbiosis")
        elseif not has_def("ingather") and rime.defences.Revenant.ingather.need and hasSkill("Ingather") then
          table.insert(balance_command, "ingather on")
        elseif not has_def("aura_concentrate") and rime.defences.Revenant.aura_concentrate.need and hasSkill("Embolden") then
          table.insert(balance_command, "phantasm embolden")
        end

    elseif class == "Templar" then
        if not has_def("maingauche") and rime.defences.Templar.maingauche.need and hasSkill("Maingauche") then
            table.insert(balance_command, "maingauche")
        elseif not has_def("blessing_accuracy") and rime.defences.Templar.blessing_accuracy.need and  hasSkill("Accuracy") then
            table.insert(balance_command, "aura blessing accuracy")
        elseif not has_def("blessing_protection") and rime.defences.Templar.blessing_protection.need and  hasSkill("Protection") then
            table.insert(balance_command, "aura blessing protection")
        elseif not has_def("blessing_healing") and rime.defences.Templar.blessing_healing.need and  hasSkill("Pealing") then
            table.insert(balance_command, "aura blessing healing")
        elseif not has_def("blessing_purity") and rime.defences.Templar.blessing_purity.need and  hasSkill("Purity") then
            table.insert(balance_command, "aura blessing purity")
        elseif not has_def("blessing_justice") and rime.defences.Templar.blessing_justice.need and  hasSkill("Justice") then
            table.insert(balance_command, "aura blessing justice")
        elseif not has_def("blessing_pestilence") and rime.defences.Templar.blessing_pestilence.need and  hasSkill("Pestilence") then
            table.insert(balance_command, "aura blessing pestilence")
        elseif not has_def("blessing_spellbane") and rime.defences.Templar.blessing_spellbane.need and  hasSkill("Spellbane") then
            table.insert(balance_command, "aura blessing spellbane")
        elseif not has_def("blessing_cleansing") and rime.defences.Templar.blessing_cleansing.need and  hasSkill("Cleansing") then
            table.insert(balance_command, "aura blessing cleansing")
        elseif not has_def("blessing_meditation") and rime.defences.Templar.blessing_meditation.need and  hasSkill("Meditation") then
            table.insert(balance_command, "aura blessing meditation")
        elseif not has_def("blessing_redemption") and rime.defences.Templar.blessing_redemption.need and  hasSkill("Redemption") then
            table.insert(balance_command, "aura blessing redemption")
        elseif not has_def("aura_protection") and rime.defences.Templar.aura_protection.need and hasSkill("Protection") then
            table.insert(balance_command, "aura protection")
        elseif not has_def("aura_accuracy") and rime.defences.Templar.aura_accuracy.need and hasSkill("Accuracy") then
            table.insert(balance_command, "aura accuracy")
        elseif not has_def("aura_healing") and rime.defences.Templar.aura_healing.need and hasSkill("Healing") then
            table.insert(balance_command, "aura healing")
        elseif not has_def("aura_purity") and rime.defences.Templar.aura_purity.need and hasSkill("Purity") then
            table.insert(balance_command, "aura purity")
        elseif not has_def("aura_justice") and rime.defences.Templar.aura_justice.need and hasSkill("Justice") then
            table.insert(balance_command, "aura justice")
        elseif not has_def("aura_pestilence") and rime.defences.Templar.aura_pestilence.need and hasSkill("Pestilence") then
            table.insert(balance_command, "aura pestilence")
        elseif not has_def("aura_cleansing") and rime.defences.Templar.aura_cleansing.need and hasSkill("Cleansing") then
            table.insert(balance_command, "aura cleansing")
        elseif not has_def("aura_meditation") and rime.defences.Templar.aura_meditation.need and hasSkill("Meditation") then
            table.insert(balance_command, "aura meditation")
        elseif not has_def("aura_redemption") and rime.defences.Templar.aura_redemption.need and hasSkill("Redemption") then
            table.insert(balance_command, "aura redemption")
        elseif not has_def("aura_spellbane") and rime.defences.Templar.aura_redemption.need and hasSkill("Spellbane") then
            table.insert(balance_command, "aura spellbane")
        end

    elseif class == "Earthcaller" then 
        if not has_def("battlehymn_intelligence") and rime.defences.Earthcaller.battlehymn_intelligence.need and hasSkill("Battlehymn") then 
            table.insert(balance_command, "dirge battlehymn intelligence")
        elseif not has_def("battlehymn_strength") and rime.defences.Earthcaller.battlehymn_strength.need and hasSkill("Battlehymn") then 
            table.insert(balance_command, "dirge battlehymn strength")
        elseif not has_def("battlehymn_constitution") and rime.defences.Earthcaller.battlehymn_constitution.need and hasSkill("Battlehymn") then 
            table.insert(balance_command, "dirge battlehymn constitution")
        elseif not has_def("battlehymn_dexterity") and rime.defences.Earthcaller.battlehymn_dexterity.need and hasSkill("Battlehymn") then 
            table.insert(balance_command, "dirge battlehymn dexterity")
        elseif not has_def("geor_rune") and rime.defences.Earthcaller.geor_rune.need and hasSkill("Anointing") then 
            table.insert(balance_command, "outc goldink"..rime.saved.separator.."outc redink"..rime.saved.separator.."anoint rune of geor")
        elseif not has_def("meath_rune") and rime.defences.Earthcaller.meath_rune.need and hasSkill("Anointing") then 
            table.insert(balance_command, "outc goldink"..rime.saved.separator.."outc yellowink"..rime.saved.separator.."anoint rune of meath")
        elseif not has_def("ragh_rune") and rime.defences.Earthcaller.ragh_rune.need and hasSkill("Anointing") then 
            table.insert(balance_command, "outc goldink"..rime.saved.separator.."outc purpleink"..rime.saved.separator.."anoint rune of ragh")
        elseif not has_def("baen_rune") and rime.defences.Earthcaller.baen_rune.need and hasSkill("Anointing") then 
            table.insert(balance_command, "outc goldink"..rime.saved.separator.."outc greenink"..rime.saved.separator.."anoint rune of baen")
        elseif not has_def("zhop_rune") and rime.defences.Earthcaller.zhop_rune.need and hasSkill("Anointing") then 
            table.insert(balance_command, "outc goldink"..rime.saved.separator.."outc blueink"..rime.saved.separator.."anoint rune of zhop")
        elseif not has_def("constitution") and rime.defences.Earthcaller.constitution.need and hasSkill("Constitution") then 
            table.insert(balance_command, "dirge constitution")
        elseif not has_def("smothering") and rime.defences.Earthcaller.smothering.need and hasSkill("Smothering") then 
            table.insert(balance_command, "tectonic smothering")
        elseif not has_def("heatshield") and rime.defences.Earthcaller.heatshield.need and hasSkill("Heatshield") then 
            table.insert(balance_command, "tectonic heatshield")
        elseif not has_def("seismicity") and rime.defences.Earthcaller.seismicity.need and hasSkill("Seismicity") then 
            table.insert(balance_command, "tectonic seismicity")
        elseif not has_def("reformation") and rime.defences.Earthcaller.reformation.need and hasSkill("Reformation") then 
            table.insert(balance_command, "tectonic reformation")
        end

    elseif class == "Adherent" then 
        if not has_def("adherent_barrier") and rime.defences.Adherent.adherent_barrier.need then 
            table.insert(balance_command, "adherent barrier")
        elseif not has_def("adherent_presence") and rime.defences.Adherent.adherent_presence.need then 
            table.insert(balance_command, "adherent presence on")
        elseif not has_def("adherent_turmoil") and rime.defences.Adherent.adherent_turmoil.need then 
            table.insert(balance_command, "adherent turmoil on")
        elseif not has_def("adherent_synchroneity") and rime.defences.Adherent.adherent_synchroneity.need then 
            table.insert(balance_command, "adherent synchroneity on")
        elseif not has_def("adherent_mortalfire") and rime.defences.Adherent.adherent_mortalfire.need then 
            table.insert(balance_command, "adherent mortalfire")
        end

    elseif class == "Ravager" then
        if not has_def("contempt") and rime.defences.Ravager.contempt.need and hasSkill("Contempt") then
            table.insert(balance_command, "contempt")
        elseif not has_def("vinculum") and rime.defences.Ravager.vinculum.need and hasSkill("Vinculum") then
            table.insert(balance_command, "invoke vinculum")
        elseif not has_def("ruthlessness") and rime.defences.Ravager.ruthlessness.need and hasSkill("Ruthlessness") then
            table.insert(balance_command, "invoke ruthlessness")
        elseif not has_def("impenetrable") and rime.defences.Ravager.impenetrable.need and hasSkill("Impenetrable") then
            table.insert(balance_command, "invoke impenetrable")
        elseif not has_def("criticality") and rime.defences.Ravager.criticality.need and hasSkill("Criticality") then
            table.insert(balance_command, "invoke criticality")
        elseif not has_def("unfinished") and rime.defences.Ravager.unfinished.need and hasSkill("Unfinished") then
            table.insert(balance_command, "invoke unfinished")
        elseif not has_def("inflated") and rime.defences.Ravager.inflated.need and hasSkill("Inflate") then
            table.insert(balance_command, "ego inflate")
        elseif not has_def("exhilarate") and rime.defences.Ravager.exhilarate.need and hasSkill("Exhilarate") then
            table.insert(balance_command, "exhilarate")
        elseif not has_def("reflexes") and rime.defences.Ravager.reflexes.need and hasSkill("Reflexes") then
            table.insert(balance_command, "reflexes")
        end

    elseif class == "Wayfarer" then
        if not has_def("fleetfoot") and rime.defences.Wayfarer.fleetfoot.need and hasSkill("Fleetfoot") then
            table.insert(balance_command, "wayfare fleetfoot on")
        elseif not has_def("brutality") and rime.defences.Wayfarer.brutality.need and hasSkill("Brutality") then
            table.insert(balance_command, "fury brutality on")
        elseif not has_def("battlechant") and rime.defences.Wayfarer.battlechant.need and hasSkill("Battlechant") then
            table.insert(balance_command, "fury battlechant anthem")
        end

    end


    if not table.is_empty(command)  then
        command = table.concat(command, rime.saved.separator)
    else
        command = ""
    end
    if not table.is_empty(balance_command) then
        balance_command = "qeb "..table.concat(balance_command, rime.saved.separator)
    else
        balance_command = ""
    end

    if not queue then
        if type(balance_command) == "string" then
            act(balance_command)
        end
        if type(command) == "string" then
            act(command)
        end
    else
        local defReturn = balance_command .. sep .. command
        defReturn = defReturn:gsub("qeb ", "")
        return defReturn
    end

end

rime.defences.profileLoaded = false
function defup()
    if rime.defences.profileLoaded then return end
    local race = gmcp.Char.Status.race
    local class = rime.status.class
    rime.keepdef("antivenin", "noecho")
    rime.keepdef("thirdeye", "noecho")
    rime.keepdef("mindseye", "noecho")
    rime.keepdef("nightsight", "noecho")
    rime.keepdef("fangbarrier", "noecho")
    rime.keepdef("levitation", "noecho")
    rime.keepdef("insomnia", "noecho")
    rime.keepdef("deathsight", "noecho")
    rime.keepdef("speed", "noecho")
    rime.keepdef("temperance", "noecho")
    rime.keepdef("instawake", "noecho")
    rime.keepdef("insulation", "noecho")
    rime.keepdef("waterbreathing", "noecho")
    if not has_def("concentrate") and class == "Praenomen" then rime.defences.Praenomen.concentrate.need = true end
    if not has_def("overwatch") and rime.saved.goggles > 4 then rime.defences.general.overwatch.need = true end
    if not has_def("insight") and (class == "Monk" or rime.saved.goggles > 7) then rime.defences.general.insight.need = true end
    if not has_def("lifevision") and (rime.saved.goggles > 8 or rime.saved.lifevision or hasSkill("Lifevision")) then rime.defences.general.lifevision.need = true end
    if not has_def("lipreading") and hasSkill("Lipread") then rime.defences.Infiltrator.lipreading.need = true end
    if not has_def("lipreading") and rime.saved.goggles > 16 then rime.defences.general.lipreading.need = true end
    if not has_def("weathering") and hasSkill("Weathering") then rime.defences.Monk.weathering.need = true end
    if not has_def("regeneration") and gmcp.Char.Status.class == "Monk" then rime.defences.Monk.regeneration.need = true end
    if not has_def("toughness") and gmcp.Char.Status.class == "Monk" then rime.defences.Monk.toughness.need = true end
    if not has_def("resistance") and gmcp.Char.Status.class == "Monk" then rime.defences.Monk.resistance.need = true end
    if not has_def("consciousness") and gmcp.Char.Status.class == "Monk" then rime.defences.Monk.consciousness.need = true end
    if not has_def("boosted_regen") and gmcp.Char.Status.class == "Monk" then rime.defences.Monk.boosted_regen.need = true end
    if not has_def("soulharvest") and gmcp.Char.Status.class == "Carnifex" then rime.defences.Carnifex.soulharvest.need = true end

    if race:find("Azudim") and not (has_def("miasma") or has_def("safeguard") or has_def("warmth") or has_def("ward")) then
        rime.defences.general.miasma.need = true
    end
    if race == "Idreth" and not (has_def("miasma") or has_def("safeguard") or has_def("warmth") or has_def("ward")) then
        rime.defences.general.safeguard.need = true
    end
    if race == "Yeleni" and not (has_def("miasma") or has_def("safeguard") or has_def("warmth") or has_def("ward")) then
        rime.defences.general.warmth.need = true
    end

    if race == "Seraph" and not (has_def("miasma") or has_def("safeguard") or has_def("warmth") or has_def("ward")) then
        rime.defences.general.warmth.need = true
    end

    if race == "Nocturn" and not (has_def("miasma") or has_def("safeguard") or has_def("warmth") or has_def("ward")) then
        rime.defences.general.miasma.need = true
    end

    if not has_def("dodging") then
        rime.defences.general.dodging.need = true
    end

    if not has_def("cloak") then
        rime.defences.general.cloak.need = true
    end
    if not has_def("clarity") and hasSkill("Clarity") then
        rime.defences.general.clarity.need = true
    end

    --class defs

    if class == "Monk" then

        if not has_def("vitality") and hasSkill("Vitality") then
            rime.defences.Monk.vitality.need = true
        end
        if not has_def("split_mind") and hasSkill("Splitting") then
            rime.defences.Monk.split_mind.need = true
        end
    end

    if class == "Bloodborn" then
        if not has_def("forestall") and hasSkill("Forestall") then
            rime.defences.Bloodborn.forestall.need = true
        end
        if not has_def("panoply") and hasSkill("Panoply") then
            rime.defences.Bloodborn.panoply.need = true
        end
        if not has_def("empowered_moon") and hasSkill("Acumen") then
            rime.defences.Bloodborn.empowered_moon.need = true
        end
    end

    if class == "Sciomancer" then

        if not has_def("shadow_mantle") and hasSkill("Mantle") then
            rime.defences.Sciomancer.shadow_mantle.need = true
        end
        if not has_def("blurring") and hasSkill("Blurring") then
            rime.defences.Sciomancer.blurring.need = true
        end
        if not has_def("shadow_engulf") and hasSkill("Engulf") then
            rime.defences.Sciomancer.shadow_engulf.need = true
        end
        if not has_def("empowered_moon") and hasSkill("Sagacity") then
            rime.defences.Sciomancer.empowered_moon.need = true
        end
        if not has_def("featherstep") and hasSkill("Featherstep") then
            rime.defences.Sciomancer.featherstep.need = true
        end
        if not has_def("rigor") and hasSkill("Rigor") then
            rime.defences.Sciomancer.rigor.need = true
        end
    end

    if class == "Shapeshifter" then

        if not has_def("celerity") and hasSkill("Endurance") then
            rime.defences.Shapeshifter.celerity.need = true
        end
        if not has_def("hardening") and hasSkill("Hardening") then
            rime.defences.Shapeshifter.hardening.need = true
        end
        if not has_def("thickhide") and hasSkill("Thickhide") then
            rime.defences.Shapeshifter.thickhide.need = true
        end
        if not has_def("metabolism") and hasSkill("Metabolize") then
            rime.defences.Shapeshifter.metabolism.need = true
        end
        if not has_def("bodyheat") and hasSkill("Bodyheat") then
            rime.defences.Shapeshifter.bodyheat.need = true
        end
        if not has_def("cornering") and hasSkill("Cornering") then
            rime.defences.Shapeshifter.cornering.need = true
        end
        if not has_def("boneshaking") and hasSkill("Boneshaking") then
            rime.defences.Shapeshifter.boneshaking.need = true
        end
    end

    if class == "Strife" then
        if not has_def("adherent_barrier") then
            rime.defences.Strife.adherent_barrier.need = true
        elseif not has_def("adherent_presence") then
            rime.defences.Strife.adherent_presence.need = true
        elseif not has_def("adherent_turmoil") then
            rime.defences.Strife.adherent_turmoil.need = true
        elseif not has_def("adherent_synchroneity") then
            rime.defences.Strife.adherent_synchroneity.need = true
        elseif not has_def("adherent_mortalfire") then
            rime.defences.Strife.adherent_mortalfire.need = true
        end
    end

    if class == "Tyranny" then
        if not has_def("adherent_barrier") then
            rime.defences.Tyranny.adherent_barrier.need = true
        elseif not has_def("adherent_presence") then
            rime.defences.Tyranny.adherent_presence.need = true
        elseif not has_def("adherent_indomitable") then
            rime.defences.Tyranny.adherent_indomitable.need = true
        elseif not has_def("adherent_synchroneity") then
            rime.defences.Tyranny.adherent_synchroneity.need = true
        elseif not has_def("adherent_mortalfire") then
            rime.defences.Tyranny.adherent_mortalfire_stored.need = true
        end
    end

    if class == "Corruption" then
        if not has_def("adherent_barrier") then
            rime.defences.Corruption.adherent_barrier.need = true
        elseif not has_def("adherent_presence") then
            rime.defences.Corruption.adherent_presence.need = true
        elseif not has_def("adherent_acid") then
            rime.defences.Corruption.adherent_acid.need = true
        elseif not has_def("adherent_synchroneity") then
            rime.defences.Corruption.adherent_synchroneity.need = true
        elseif not has_def("adherent_mortalfire") then
            rime.defences.Corruption.adherent_mortalfire.need = true
        end
    end

    if class == "Seraph" then
        if not has_def("seraph_halo") then
            rime.defences.Seraph.seraph_halo.need = true
        elseif not has_def("seraph_presence") then
            rime.defences.Seraph.seraph_presence.need = true
        elseif not has_def("seraph_radiate") then
            rime.defences.Seraph.seraph_radiate.need = true
        elseif not has_def("seraph_parhelion") then
            rime.defences.Seraph.seraph_parhelion.need = true
        elseif not has_def("seraph_corona_stored") then
            rime.defences.Seraph.seraph_corona_stored.need = true
        end
    end

    if class == "Nocturn" then
        if not has_def("nocturn_bloodcoat") then
            rime.defences.Nocturn.nocturn_bloodcoat.need = true
        elseif not has_def("nocturn_presence") then
            rime.defences.Nocturn.nocturn_presence.need = true
        elseif not has_def("nocturn_haze") then
            rime.defences.Nocturn.nocturn_radiate.need = true
        elseif not has_def("nocturn_double") then
            rime.defences.Nocturn.nocturn_parhelion.need = true
        elseif not has_def("nocturn_shadow_stored") then
            rime.defences.Nocturn.nocturn_shadow_stored.need = true
        end
    end

    if class == "Memory" then
        if not has_def("adherent_barrier") then
            rime.defences.Memory.adherent_barrier.need = true
        elseif not has_def("adherent_presence") then
            rime.defences.Memory.adherent_presence.need = true
        elseif not has_def("adherent_ruination") then
            rime.defences.Memory.adherent_ruination.need = true
        elseif not has_def("adherent_synchroneity") then
            rime.defences.Memory.adherent_synchroneity.need = true
        elseif not has_def("adherent_mortalfire_stored") then
            rime.defences.Memory.adherent_mortalfire_stored.need = true
        end
    end

    if class == "Titan" then
        if not has_def("titan_irradiance") then
            rime.defences["Titan"].titan_irradiance.need = true
        end
        if not has_def("titan_presence") then
            rime.defences["Titan"].titan_presence.need = true
        end
        if not has_def("titan_disruption") then
            rime.defences["Titan"].titan_disruption.need = true
        end
        if not has_def("titan_multicore") then
            rime.defences["Titan"].titan_multicore.need = true
        end
    end

    if class == "Teradrim" then

        if not has_def("stonebind") and hasSkill("Stonebind") then
            rime.defences.Teradrim.stonebind.need = true
        end
        if not has_def("surefooted") and hasSkill("Surefooted") then
            rime.defences.Teradrim.surefooted.need = true
        end
        if not has_def("rune_mark_pve") and hasSkill("Runemark") then
            rime.defences.Teradrim.rune_mark_pve.need = true
        end
        if not has_def("rune_mark_pvp") and hasSkill("Runemark") then
            rime.defences.Teradrim.rune_mark_pvp.need = true
        end
        if not has_def("earth_resonance") and hasSkill("Resonance") then
            rime.defences.Teradrim.earth_resonance.need = true
        end
        if not has_def("entwine") and hasSkill("Entwine") then
            rime.defences.Teradrim.entwine.need = true
        end
        if not has_def("twinsoul") and hasSkill("Twinsoul") then
            rime.defences.Teradrim.twinsoul.need = true
        end
        if not has_def("ricochet") and hasSkill("Ricochet") then
            rime.defences.Teradrim.ricochet.need = true
        end
        if not has_def("sand_conceal") and hasSkill("Concealment") then
            rime.defences.Teradrim.sand_conceal.need = true
        end
        if not has_def("imbue_erosion") and hasSkill("Erosion") then
            rime.defences.Teradrim.imbue_erosion.need = true
        end
        if not has_def("imbue_stonefury") and hasSkill("Stonefury") then
            rime.defences.Teradrim.imbue_stonefury.need = true
        end
        if not has_def("earthenform") and hasSkill("Earthenform") then
            rime.defences.Teradrim.earthenform.need = true
        end
    end

    if class == "Infiltrator" then

        if not has_def("warding") and hasSkill("Warding") then
            rime.defences.Infiltrator.warding.need = true
        end
        if not has_def("finesse") and hasSkill("Finesse") then
            rime.defences.Infiltrator.finesse.need = true
        end
        if not has_def("hiding") then
            rime.defences.Infiltrator.hiding.need = true
        end
        if not has_def("ghosted") and hasSkill("Ghost") then
            rime.defences.Infiltrator.ghosted.need = true
        end
        if not has_def("shroud") and hasSkill("Cloak") then
            rime.defences.Infiltrator.shroud.need = true
        end
        if not has_def("lipreading") and hasSkill("Lipread") then
            rime.defences.Infiltrator.lipreading.need = true
        end
        if not has_def("shadowsight") and hasSkill("Shadowsight") then
            rime.defences.Infiltrator.shadowsight.need = true
        end
    end

    if class == "Praenomen" then
        if not has_def("fortify") and hasSkill("Fortify") then
            rime.defences.Praenomen.fortify.need = true
        end
        if not has_def("corpus_warding") and hasSkill("Warding") then
            rime.defences.Praenomen.corpus_warding.need = true
        end
        if not has_def("lifescent") and hasSkill("Lifescent") then
            rime.defences.Praenomen.lifescent.need = true
        end
        if not has_def("celerity") and hasSkill("Celerity") then
            rime.defences.Praenomen.celerity.need = true
        end
        if not has_def("blurred") and hasSkill("Blur") then
            rime.defences.Praenomen.blurred.need = true
        end
        if not has_def("trepidation") and hasSkill("Trepidation") then
            rime.defences.Praenomen.trepidation.need = true
        end
        if not has_def("shadowblow") and hasSkill("Shadow") then
            rime.defences.Praenomen.shadowblow.need = true
        end
        if not has_def("bloodtrack") and hasSkill("Track") then
            rime.defences.Praenomen.bloodtrack.need = true
        end
        if not has_def("lifevision") and hasSkill("Lifevision") then
            rime.defences.Praenomen.lifevision.need = true
        end
        if not has_def("elusion") and hasSkill("Elusion") then
            rime.defences.Praenomen.elusion.need = true
        end
    end

    if class == "Sentinel" then

        if not has_def("vitality") and hasSkill("Vitality") then
            rime.defences.Sentinel.vitality.need = true
        end
        if not has_def("barkskin") and hasSkill("Barkskin") then
            rime.defences.Sentinel.barkskin.need = true
        end
        if not has_def("hardiness") and hasSkill("Hardiness") then
            rime.defences.Sentinel.hardiness.need = true
        end
        if not has_def("foreststride") and hasSkill("Foreststriding") then
            rime.defences.Sentinel.foreststride.need = true
        end
        if not has_def("concealed") and hasSkill("Conceal") then
            rime.defences.Sentinel.concealed.need = true
        end
        if not has_def("lifesap") and hasSkill("Lifesap") then
            rime.defences.Sentinel.lifesap.need = true
        end
    end

    if class == "Executor" then

        if not has_def("vitality") and hasSkill("Vitality") then
            rime.defences.Executor.vitality.need = true
        end
        if not has_def("bloodlust") and hasSkill("Bloodlust") then
            rime.defences.Executor.bloodlust.need = true
        end
        if not has_def("inspirited") and hasSkill("Inspirit") then
            rime.defences.Executor.inspirited.need = true
        end
        if not has_def("bounding") and hasSkill("Bounding") then
            rime.defences.Executor.bounding.need = true
        end
        if not has_def("girded") and hasSkill("Gird") then
            rime.defences.Executor.girded.need = true
        end
        if not has_def("stoicism") and hasSkill("Stoicism") then
            rime.defences.Executor.stoicism.need = true
        end
        if not has_def("concealed") and hasSkill("Conceal") then
            rime.defences.Executor.concealed.need = true
        end

    end

    if class == "Carnifex" then
        if not has_def("gripping") then
            rime.defences.Carnifex.gripping.need = true
        end
        if not has_def("enfrost") then
            rime.defences.Carnifex.enfrost.need = true
        end
        if not has_def("soul_fortify") and hasSkill("Fortify") then
            rime.defences.Carnifex.soul_fortify.need = true
        end
        if not has_def("soul_fracture") and hasSkill("Fracture") then
            rime.defences.Carnifex.soul_fracture.need = true
        end
        if not has_def("soulthirst") and hasSkill("Soulthirst") then
            rime.defences.Carnifex.soulthirst.need = true
        end
        if not has_def("soulbind") and hasSkill("Soulbind") then
            rime.defences.Carnifex.soulbind.need = true
        end
        if not has_def("cruelty") and hasSkill("Cruelty") then
            rime.defences.Carnifex.cruelty.need = true
        end
        if not has_def("reckless") and hasSkill("Reckless") then
            rime.defences.Carnifex.reckless.need = true
        end
        if not has_def("soul_substitute") and hasSkill("Substitute") then
            rime.defences.Carnifex.soul_substitute.need = true
        end
        if not has_def("herculeanrage") and hasSkill("HerculeanRage") then
            rime.defences.Carnifex.herculeanrage.need = true
        end
        if not has_def("fearless") and hasSkill("Fearless") then
            rime.defences.Carnifex.fearless.need = true
        end
    end

    if class == "Indorani" then
        if not has_def("lifevision") and hasSkill("Lifevision") then
            rime.defences.Indorani.lifevision.need = true
        end
        if not has_def("chariot") and hasSkill("Chariot") then
            rime.defences.Indorani.chariot.need = true
        end
        if not has_def("devilpact") and hasSkill("Devil") then
            rime.defences.Indorani.devilpact.need = true
        end
        if not has_def("eclipse") and hasSkill("Eclipse") then
            rime.defences.Indorani.eclipse.need = true
        end
        if not has_def("shroud") and hasSkill("Shroud") then
            rime.defences.Indorani.shroud.need = true
        end
        if not has_def("hierophant") and hasSkill("Hierophant") then
            rime.defences.Indorani.hierophant.need = true
        end
    end

    if class == "Archivist" then
        if not has_def("spheres") and hasSkill("Spheres") then
            rime.defences.Archivist.spheres.need = true
        end
        if not has_def("dilation") and hasSkill("Dilation") then
            rime.defences.Archivist.dilation.need = true
        end
        if not has_def("sublimation") and hasSkill("Sublimation") then
            rime.defences.Archivist.sublimation.need = true
        end
        if not has_def("linked") and hasSkill("Link") then
            rime.defences.Archivist.linked.need = true
        end
        if not has_def("ameliorate") and hasSkill("Ameliorate") then
            rime.defences.Archivist.ameliorate.need = true
        end
        if not has_def("catabolism") and hasSkill("Catabolism") then
            rime.defences.Archivist.catabolism.need = true
        end
    end

    if class == "Templar" then
        if not has_def("gripping") and hasSkill("Gripping") then
            rime.defences.Templar.gripping.need = true
        end
        if not has_def("maingauche") and  hasSkill("Maingauche") then
            rime.defences.Templar.maingauche.need = true
        end
    end

    if class == "Revenant" then
        if not has_def("gripping") and hasSkill("Gripping") then
            rime.defences.Revenant.gripping.need = true
        end
        if not has_def("maingauche") and  hasSkill("Maingauche") then
            rime.defences.Revenant.maingauche.need = true
        end
    end

    if class == "Earthcaller" then 
        if not has_def("battlehymn_constitution") and hasSkill("Battlehymn") then 
            rime.defences.Earthcaller.constitution.need = true 
        end
        if not has_def("geor_rune") and hasSkill("Anointing") then 
            rime.defences.Earthcaller.geor_rune.need = true 
        end
        if not has_def("constitution") and hasSkill("Constitution") then 
            rime.defences.Earthcaller.constitution.need = true 
        end
        if not has_def("smothering") and hasSkill("Smothering") then 
            rime.defences.Earthcaller.smothering.need = true 
        end
        if not has_def("heatshield") and hasSkill("Heatshield") then 
            rime.defences.Earthcaller.heatshield.need = true 
        end
        if not has_def("reformation") and hasSkill("Reformation") then 
            rime.defences.Earthcaller.reformation.need = true 
        end
    end

    if class == "Adherent" then 
        if not has_def("adherent_barrier") then 
            rime.defences.Adherent.adherent_barrier.need = true
        elseif not has_def("adherent_presence") then 
            rime.defences.Adherent.adherent_presence.need = true
        elseif not has_def("adherent_turmoil") then 
            rime.defences.Adherent.adherent_turmoil.need = true
        elseif not has_def("adherent_synchroneity") then 
            rime.defences.Adherent.adherent_synchroneity.need = true
        elseif not has_def("adherent_mortalfire") then 
            rime.defences.Adherent.adherent_mortalfire.need = true
        end
    end

    if class == "Bard" then
        if not has_def("halfbeat") and hasSkill("Halfbeat") then
            rime.defences.Bard.halfbeat.need = true
        elseif not has_def("destiny") and hasSkill("Destiny") then
            rime.defences.Bard.destiny.need = true
        elseif not has_def("sheath") and hasSkill("Sheath") then
            rime.defences.Bard.sheath.need = true
        elseif not has_def("aurora") and hasSkill("Aurora") then
            rime.defences.Bard.aurora.need = true
        elseif not has_def("stretching") and hasSkill("Stretching") then
            rime.defences.Bard.stretching.need = true
        elseif not has_def("tolerance") and hasSkill("Tolerance") then
            rime.defences.Bard.tolerance.need = true
        end
    end

    if class == "Ravager" then
        if not has_def("contempt") then
            rime.defences.Ravager.contempt.need = true
        end
        if not has_def("vinculum") then
            rime.defences.Ravager.vinculum.need = true
        end
        if not has_def("ruthlessness") then
            rime.defences.Ravager.ruthlessness.need = true
        end
        if not has_def("impenetrable") then
            rime.defences.Ravager.impenetrable.need = true
        end
        if not has_def("criticality") then
            rime.defences.Ravager.criticality.need = true
        end
        if not has_def("unfinished") then
            rime.defences.Ravager.unfinished.need = true
        end
    end

end