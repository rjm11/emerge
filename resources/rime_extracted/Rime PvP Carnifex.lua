--Author: Mjoll
rime.pvp.Carnifex.routes = {

    ["bull"] = {
        ["blurb"] = {"Hurt them."},
        ["attack"] = {
            "wrench",
            "pulverize",
            "charge",
            "lock_crush",
            "erode",
            "razehack",
            "hammerraze",
            "batter",
            "carve",
            "spinslash",
        },
        ["venoms"] = {
            "paresis",
            "clumsiness",
            "haemophilia",
            "asthma",
            "vomiting",
            "allergies",
            "no_deaf",
            "sensitivity",
            "stupidity",
            "weariness",
            "slickness",
            "anorexia",
        },
        ["deathlore"] = {
            "soul_disease",
            "wraith",
            "implant",
            "soul_poison",
            "bloodburst",
        },
        ["hounds"] = {
            "blisters",
            "limp_veins",
            "contagion", --loki lol
        },
    },

    ["black"] = {
        ["blurb"] = {"Lock 'em up, beat 'em down."},
        ["attack"] = {
            "wrench",
            "pulverize",
            "charge",
            "lock_crush",
            "erode",
            "razehack",
            "hammerraze",
            "spinslash",
        },
        ["venoms"] = {
            "shoveStupid", -- shoves aconite if they're locked
            "lockAsthma", -- shoves kalmia if they're 1 aff away from lock
            "lockSlickness",
            "lockAnorexia",
            "paresis",
            "shoveLBL",
            "shoveRBL",
            "shoveLBA",
            "shoveRBA",
            "clumsiness",
            "asthma",
            "weariness",
            "stupidity",
            "dizziness",
            "disfigurement", -- monkshood but only if asthma + (weariness or clumsiness)
            "dizziness",
            "anorexia",
            "peace",
            "left_leg_broken",
            "right_leg_broken",
            "no_deaf",
            "sensitivity",
            "haemophilia",
            "vomiting",
            "allergies",
            "left_arm_broken",
            "right_arm_broken",
            "recklessness",
            "peace",
            "bigShyness",
            "voyria",
            "sleep",
        },
        ["deathlore"] = {
            "soul_disease",
            "wraith",
            "implant",
            "soul_poison",
            "bloodburst",
        },
        ["hounds"] = {
            "impairment", --stare if berserking
            "mark", --mark
            "dizziness", --growl
            "crippled", --acidspit if weariness
            "shovingBerserk", --stare but only if they don't have impairment already
            "weariness", --acidspit
            "epilepsy", --shock
            "hallucinations", --shock if epilepsy
            "contagion", --loki lol
        },

    },
    ["white"] = {
        ["blurb"] = {"Let loose the hounds of war"},
        ["attack"] = {
            "wrench",
            "pulverize",
            "charge",
            "lock_crush",
            "erode",
            "razehack",
            "hammerraze",
            "spinslash",
        },
        ["venoms"] = {
            "shoveStupid", -- shoves aconite if they're locked
            "lockAsthma", -- shoves kalmia if they're 1 aff away from lock
            "lockSlickness",
            "lockAnorexia",
            "paresis",
            "shoveLBL",
            "shoveRBL",
            "shoveLBA",
            "shoveRBA",
            "weariness",
            "dizziness",
            "asthma",
            "clumsiness",
            "disfigurement", --only fires on pet classes if asthma + (clumsiness or weariness)
            "stupidity",
            "slickness",
            "left_arm_broken",
            "right_arm_broken",
            "anorexia",
            "peace",
            "vomiting",
            "allergies",
            "no_deaf",
            "sensitivity",
            "haemophilia",
            "left_leg_broken",
            "right_leg_broken",
            "recklessness",
            "shyness",
            "voyria",
            "no_blind",
            "blurry_vision",
            "sleep",
        },
        ["deathlore"] = {
            "soul_disease",
            "wraith",
            "implant",
            "soul_poison",
        },
        ["hounds"] = {
            "impairment", --stare if berserking
            "mark", -- mark
            "dizziness", --growl
            "weariness", --acidspit
            "shovingBerserk", --stare if they don't have impairment
            "crippled", --acidspit if weariness
            "epilepsy", --shock
            "berserking", --stare
            "hallucinations", --shock
            "recklessness", --growl
            "contagion", -- contagion
        },
    },

    ["mental"] = {
        ["blurb"] = {"Destroy their mind, the body will follow"},
        ["attack"] = {
            "wrench",
            "pulverize",
            "charge",
            "skewer",
            "erode",
            "razehack",
            "hammerraze",
            "batter",
            "spinslash",
        },
        ["venoms"] = {
            "peaceProc",
            "anorexiaSeal",
            "stupidity",
            "dizziness",
            "peace",
            "shyness",
            "weariness",
            "asthma",
            "buffSlickness",
            "no_deaf",
            "sensitivity",
            "vomiting",
            "allergies",
            "haemophilia",
            "paresis",
            "clumsiness",
            "left_leg_broken",
            "right_leg_broken",
            "left_arm_broken",
            "right_arm_broken",
            "voyria",
            "recklessness",
            "sleep",
        },
        ["deathlore"] = {
            "soul_disease",
            "wraith",
            "implant",
            "soul_poison",
        },
        ["hounds"] = {
            "mark",
            "impairment", --stare
            "dizziness", --growl
            "epilepsy", --shock
            "berserking", --stare
            "crippled", --acidspit
            "hallucinations", --shock
            "weariness", --acidspit
            "recklessness", --growl
            "contagion", --contagion
        },

    },

    ["phys"] = {
        ["blurb"] = {"Destroy their body, watch them bleed"},
        ["attack"] = {
            "wrench",
            "pulverize",
            "charge",
            "skewer",
            "erode",
            "razehack",
            "hammerraze",
            "batter",
            "spinslash",
        },
        ["venoms"] = {
            "paresis",
            "physStupid", -- fires if locked to keep them from focusing out
            "anorexiaSeal", --fires if asthma+slickness+(stupidity or off focus bal for at least 3 seconds)
            "clumsiness",
            "asthma",
            "vomiting",
            "allergies",
            "disfigurement", -- fires on pet classes if asthma + (clumsiness or weariness)
            "no_deaf", -- fires prefarar if no sensitivity and still has deafness
            "haemophilia",
            "sensitivity",
            "buffSlickness", -- fires slickness if asthma + (clumsiness or weariness)
            "right_arm_broken",
            "left_arm_broken",
            "dizziness",
            "left_leg_broken",
            "right_leg_broken",
            "stupidity",
            "weariness",
            "peace",
            "shyness",
            "voyria",
            "stuttering",
            "anorexia",
            "no_blind",
            "blurry_vision",
        },
        ["deathlore"] = {
            "bloodburst",
            "soul_disease",
            "wraith",
            "soul_poison",
            "implant",
        },
        ["hounds"] = {
            "impairment", --stare if berserk
            "limp_veins", --poisonclaw if blisters
            "blisters", --poisonclaw
            "crippled", --acidspit if weariness
            "mark", --mark
            "dizziness", --growl
            "weariness", --acidspit
            "berserking", --stare
            "epilepsy", --shock
            "blurry_vision", --ululate
            "contagion", -- contagion
        },

    },

    ["group"] = {
        ["blurb"] = {"Quick lock, crush when fallen"},
        ["attack"] = {
            "effigy_damage",
            "wrench",
            "erode",
            "pulverize",
            "groupcharge",
            "tumblestop",
            --"shield_ally",
            "razehack",
            "damage_crush",
            "spinslash",
            "batter",
        },
        ["venoms"] = {
            "asthma",
            "paresis",
            "slickness",
            "anorexia",
            "left_leg_broken",
            "right_leg_broken",
            "stupidity",
            "weariness",
            "no_blind",
            "left_arm_broken",
            "right_arm_broken",
        },  
        ["deathlore"] = {
            "wraith",
            "distortion",
            "soul_poison",
        },
        ["hounds"] = {
            "crippled",
            "weariness",
            "dizziness",
            "epilepsy",
            "impairment",
            "hallucinations",
            "berserking",
            "bite",
        },
    },
    ["tlock"] = {
        ["blurb"] = {"Pairs well with a sand cursing Teradrim"},
        ["attack"] = {
            "wrench",
            "erode",
            "pulverize",
            "groupskewer",
            "groupcharge",
            "tumblestop",
            "razehack",
            "damage_crush",
            "spinslash",
            "batter",
        },
        ["venoms"] = {
            "paresis",
            "stupidity",
            "anorexia",
            "asthma",
            "slickness",
            "left_leg_broken",
            "right_leg_broken",
            "left_arm_broken",
            "right_arm_broken",
            "stuttering",
            "voyria",
        },  
        ["deathlore"] = {
            "wraith",
            "soul_disease",
            "distortion",
            "soul_poison",
        },
        ["hounds"] = {
            "impairment",
            "crippled",
            "berserking",
            "weariness",
            "epilepsy",
            "contagion",
        },
    },

    ["hammer"] = {
        ["blurb"] = {"Wham, bam, thank you ma'am"},
        ["attack"] = {
            "wrench",
            "pulverize",
            "groupskewer",
            "limbProne",
            "wither",
            "crushed_chest",
            "charge",
            "cracked_ribs",
            "amputate",
            "soulpuncture",
            "hammerraze",
            "razehack",
            "damaged_legs",
            "shouldCheese",
            "should_batter",
            "torso_damaged",
            "ll_rl_doublebash",
            "right_arm_damaged",
            "left_leg_damaged",
            "la_ra_doublebash",
            "head_damaged",
        },
        ["venoms"] = {
            "left_leg_broken",
            "right_leg_broken",
            "left_arm_broken",
            "right_arm_broken",
            "anorexia",
            "stupidity",
        },
        ["deathlore"] = {"glasslimb", "bloodburst", "distortion", "wraith"},
        ["hounds"] = {"blurry_vision", "frozen", "bite",},
    },

    ["ghammer"] = {
        ["blurb"] = {"Legs and head, need nothing more"},
        ["attack"] = {
            "pulverize",
            "tumblestop",
            "eptraze",
            "damage_crush",
            "groupskewer",
            "groupcharge",
            "batter",
            "damaged_legs",
            "damaged_arms",
            "torso_damaged",
            "left_leg_damaged",
            "right_leg_damaged",
            "right_arm_damaged",
            "left_arm_damaged",
            "head_damaged",
        },
        ["venoms"] = {},
        ["deathlore"] = {"distortion", "wraith", "glasslimb", "eptimplant"},
        ["hounds"] = {"frozen", "bite",},
    },

    ["voidg"] = {
        ["blurb"] = {"Friendly Scios will love you to death"},
        ["attack"] = {
            "wrench",
            "erode",
            "pulverize",
            "tumblestop",
            "razehack",
            "hammerraze",
            "razehack",
            "damage_crush",
            "spinslash",
            "batter",
        },
        ["venoms"] = {
            "no_blind",
            "clumsiness",
            "paresis",
            "weariness",
            "stupidity",
            "vomiting",
            "allergies",
            "asthma",
            "slickness",
            "anorexia",
            "left_leg_broken",
            "right_leg_broken",
            "right_arm_broken",
            "left_arm_broken",
            "voyria",
            "sleep",
        },
        ["deathlore"] = {
            "wraith",
            "soul_disease",
            "soul_poison",
        },
        ["hounds"] = {
            "weariness",
            "crippled",
            "impairment",
            "epilepsy",
            "dizziness",
            "hallucinations",
            "berserking",
            "bite",
        }
    },
    ["limbs"] = {
        ["blurb"] = {"Indo and shifters love it when you do this"},
        ["attack"] = {
            "erode",
            "wrench",
            "pulverize",
            "tumblestop",
            "groupskewer",
            --"shield_ally",
            "hammerraze",
            "razehack",
            "damage_crush",
            "spinslash",
        },
        ["venoms"] = {
            "left_leg_broken",
            "left_leg_broken",
            "right_arm_broken",
            "right_arm_broken",
            "asthma",
            "slickness",
            "anorexia",
            "no_deaf",
            "sensitivity",
        },
        ["deathlore"] = {
            "wraith",
            "soul_disease",
            "distortion",
            "soul_poison",
        },
        ["hounds"] = {
            "frozen",
            "crippled",
            "impairment",
            "bite",
        }
    },


}

carn = carn or {}

carn.attacks = carn.attacks or {}
carn.slashes = carn.slashes or {}
carn.wantDeathlore = true
carn.can = carn.can or {}
carn.can = {
    distort = true,
    implant = true,
    poison = true,

}
carn.need_charge = false
lastLimbHit = "none"
prerestoredLimb = "none"
bloodburstCount = 0


carn.slashes = {
    ["peaceProc"] = {
        "curare",
        "paresis",
        can = function()
            local targ = rime.target
            if rime.pvp.has_aff("implant", targ) and implantTrigger == "curare" and not rime.pvp.has_aff(rime.convert_venom(implantVenom), targ) then 
                return true
            end
            return false
        end,
    },
    ["dumbImpair"] = {
        "aconite",
        "stupidity",
        can = function()
            local targ = rime.target
            if rime.pvp.has_aff("impairment", targ) then
                return false
            end
            return true
        end,
    },
    ["cripWeari"] = {
        "vernalius",
        "weariness",
        can = function()
            local targ = rime.target
            if rime.pvp.has_aff("crippled", targ) then
                return false
            end
            return true
        end,
    },
    ["anorexiaSeal"] = {
        "slike",
        "anorexia",
        can = function()
            local targ = rime.target
            local focusbal = rime.getTimeLeft("focus", rime.target)
            if rime.pvp.has_aff("asthma", targ) and rime.pvp.has_aff("slickness", targ) and (rime.pvp.has_aff("stupidity", targ) or focusbal >= 3) then
                return true
            end
            return false
        end,
    },
    ["lockAnorexia"] = {
        "slike",
        "anorexia",
        can = function()
            local targ = rime.target
            if not rime.pvp.has_def("rebounding", targ) then
                if #rime.missingAff("asthma/slickness", "/") < 2 then
                    if rime.pvp.has_aff("stupidity", targ) or rime.pvp.has_aff("impatience", targ) then
                        return true
                    elseif rime.getTimeLeft("focus", targ) > 2.3 then
                        return true
                    elseif #rime.missingAff("asthma/slickness", "/") < 1 and carn.slashes.shoveStupid.can() then
                        return true
                    end
                end
            else
                if #rime.missingAff("asthma/slickness", "/") < 1 then
                    if rime.pvp.has_aff("stupidity", targ) or rime.pvp.has_aff("impatiences", targ) then
                        return true
                    elseif rime.getTimeLeft("focus", targ) > 2.3 then
                        return true
                    end
                end
            end
            return false
        end,
    },
    ["lockSlickness"] = {
        "gecko",
        "slickness",
        can = function()
            local targ = rime.target
             if not rime.pvp.has_def("rebounding", targ) then
                if #rime.missingAff("asthma/anorexia", "/") < 2 or ((rime.pvp.route_choice == "white" or rime.pvp.route_choice == "black") and #rime.missingAff("asthma/implant", "/") < 2 and not rime.pvp.has_aff("slickness", rime.target)) then
                    if rime.pvp.has_aff("stupidity", targ) or rime.pvp.has_aff("impatience", targ) then
                        return true
                    elseif rime.getTimeLeft("focus", targ) > 2.4 then
                        return true
                    elseif (#rime.missingAff("asthma/anorexia", "/") < 1 or ((rime.pvp.route_choice == "white" or rime.pvp.route_choice == "black") and #rime.missingAff("asthma/implant", "/") < 1)) and carn.slashes.shoveStupid.can() then
                        return true
                    end
                end
            else
                if #rime.missingAff("asthma/anorexia", "/") < 1 or ((rime.pvp.route_choice == "white" or rime.pvp.route_choice == "black") and #rime.missingAff("asthma/implant", "/") < 1) then
                    if rime.pvp.has_aff("stupidity", targ) or rime.pvp.has_aff("impatience", targ) then
                        return true
                    elseif rime.getTimeLeft("focus", targ) > 2.4 then
                        return true
                    end
                end
            end
            return false
        end,
    },
    ["lockAsthma"] = {
        "kalmia",
        "asthma",
        can = function()
            local targ = rime.target
            if not rime.pvp.has_def("rebounding", targ) then
                if #rime.missingAff("slickness/anorexia", "/") < 2 then
                    return true
                elseif #rime.missingAff("slickness/implant", "/") < 2 then
                    return true
                end
            else
                if #rime.missingAff("slickness/anorexia", "/") < 1 then
                    return true
                elseif #rime.missingAff("slickness/implant", "/") < 1 then
                    return true
                end
            end
            return false
        end,
    },
    ["shoveStupid"] = {
        "aconite",
        "stupidity",
        can = function()
            local targ = rime.target
            if not rime.pvp.has_def("rebounding", targ) then
                if #rime.missingAff("asthma/slickness/anorexia", "/") < 2 or ((rime.pvp.route_choice == "white" or rime.pvp.route_choice == "black") and #rime.missingAff("asthma/slickness/implant", "/") < 2) then
                    return true
                end
            else
                if #rime.missingAff("asthma/slickness/anorexia", "/") < 1 then
                    return true
                end
            end
            return false
        end,
    },
    ["strongAsthma"] = {
        "kalmia",
        "asthma",
        can = function()
            local targ = rime.target
            if #rime.missingAff("weariness/clumsiness", "/") < 2 then
                return true
            end
            return false
        end,
    },
    ["physStupid"] = {
        "aconite",
        "stupidity",
        can = function()
            local targ = rime.target
            if not rime.pvp.has_def("rebounding", targ) then
                if #rime.missingAff("asthma/slickness/anorexia", "/") < 1  then
                    return true
                end
            end
            return false
        end,
    },
    ["shoveLBA"] = {
        "epteth",
        "left_arm_broken",
        can = function()
        local targ = rime.target
        if not rime.pvp.has_def("rebounding", targ) then
            if #rime.missingAff("asthma/slickness/anorexia/paresis", "/") < 2 then
                return true
            end
        else
            if rime.pvp.has_aff("locked", targ) then
                return true
            end
        end
        return false
    end,
    },
    ["shoveRBA"] = {
        "epteth",
        "right_arm_broken",
        can = function()
        local targ = rime.target
        if not rime.pvp.has_def("rebounding", targ) then
            if #rime.missingAff("asthma/slickness/anorexia/paresis", "/") < 2 then
                return true
            end
        else
            if rime.pvp.has_aff("locked", targ) then
                return true
            end
        end
        return false
    end,
    },
    ["shoveLBL"] = {
        "epseth",
        "left_leg_broken",
        can = function()
        local targ = rime.target
        if not rime.pvp.has_def("rebounding", targ) then
            if #rime.missingAff("asthma/slickness/anorexia/paresis", "/") < 2 then
                return true
            end
        else
            if rime.pvp.has_aff("locked", targ) then
                return true
            end
        end
        return false
    end,
    },
    ["shoveRBL"] = {
        "epseth",
        "right_leg_broken",
        can = function()
        local targ = rime.target
        if not rime.pvp.has_def("rebounding", targ) then
            if #rime.missingAff("asthma/slickness/anorexia/paresis", "/") < 2 then
                return true
            end
        else
            if rime.pvp.has_aff("locked", targ) then
                return true
            end
        end
        return false
    end,
    },
    ["paresis"] = {
        "curare",
        "paresis",
        can = function()
        if rime.pvp.has_aff("paralysis", rime.target) then
        	return false
        else
        		return true
        end
    end,
    },
    ["peace"] = {
        "ouabain",
        "peace",
        can = function()
            targ = rime.target
            if rime.pvp.has_aff("implant", targ) and implantVenom == "ouabain" then
                return false
            end
            return true
        end
    },
    ["clumsiness"] = {
        "xentio",
        "clumsiness",
        can = function()
            return true
        end
    },
    ["sleep"] = {
        "delphinium",
        "sleep",
        can = function()
            return true
        end
    },
    ["asthma"] = {
        "kalmia",
        "asthma",
        can = function()
            return true
        end
    },
    ["slickness"] = {
        "gecko",
        "slickness",
        can = function()
            if rime.pvp.has_aff("asthma", rime.target) then
                return true
            else
                return true
            end
        end
    },
    ["buffSlickness"] = {
        "gecko",
        "slickness",
        can = function()
            targ = rime.target
            if rime.pvp.has_aff("asthma", targ) and (rime.pvp.has_aff("clumsiness", targ) or rime.pvp.has_aff("weariness", targ)) then
                return true
            elseif rime.pvp.has_aff("implant", targ) and rime.pvp.has_aff("asthma", targ) and implantVenom == "slike" then
                return true
            end
            return false
        end
    },
    ["push_anorexia"] = {
        "slike",
        "anorexia",
        can = function()
            target = rime.target
            if not rime.pvp.has_aff("slough", target) then return false end
            return true
        end,
    },
    ["push_stupidity"] = {
        "aconite",
        "stupidity",
        can = function()
            target = rime.target
            if not rime.pvp.has_aff("slough", target) then return false end
            return true
        end,
    },
    ["anorexia"] = {
        "slike",
        "anorexia",
        can = function()
            return true
        end
    },
    ["vomiting"] = {
        "euphorbia",
        "vomiting",
        can = function()
            return true
        end
    },
    ["allergies"] = {
        "darkshade",
        "allergies",
        can = function()
            return true
        end
    },
    ["voyria"] = {
        "voyria",
        "voyria",
        can = function()
            return true
        end
    },
    ["sensitivity"] = {
        "prefarar",
        "sensitivity",
        can = function()
            return true
        end
    },
    ["no_deaf"] = {
        "preFarar",
        "no_deaf",
        can = function()
            if rime.pvp.has_aff("sensitivity", rime.target) then
                return false
            else
                return true
            end
        end
    },
    ["blurry_vision"] = {
        "oculus",
        "blurry_vision",
        can = function()
            if rime.pvp.has_aff("no_blind", rime.target) then
                return true
            end
            return false
        end
    },
    ["no_blind"] = {
        "oCulus",
        "no_blind",
        can = function()
            return true
        end
    },
    ["ho_blind"] = {
        "oCulus",
        "no_blind",
        can = function()
            if rime.pvp.has_aff("blurry_vision") then
                return false
            else
                return true
            end
        end
    },
    ["haemophilia"] = {
        "hepafarin",
        "haemophilia",
        can = function()
            return true
        end
    },
    ["stuttering"] = {
        "jalk",
        "stuttering",
        can = function()
            return true
        end
    },
    ["weariness"] = {
        "vernalius",
        "weariness",
        can = function()
            return true
        end
    },
    ["bigShyness"] = {
        "digitalis",
        "shyness",
        can = function()
            if rime.pvp.has_aff("crippled", rime.target) then
                return true
            elseif rime.pvp.has_aff("left_leg_broken", rime.target) or rime.pvp.has_aff("right_leg_broken", rime.target) then
                return true
            end
            return false
        end
    },
    ["shyness"] = {
        "digitalis",
        "shyness",
        can = function()
            return true
        end
    },
    ["dizziness"] = {
        "larkspur",
        "dizziness",
        can = function()
            return true
        end
    },
    ["stupidity"] = {
        "aconite",
        "stupidity",
        can = function()
            local targ = rime.target
            return true
        end
    },
    ["disfigurement"] = {
        "monkshood",
        "disfigurement",
        can = function()
            local targ = rime.target
            local pet_classes = {"sentinel", "carnifex", "praenomen", "teradrim", "indorani", "luminary",}
            if rime.pvp.has_aff("asthma", targ) and (rime.pvp.has_aff("clumsiness", targ) or rime.pvp.has_aff("weariness", targ)) and not rime.pvp.has_def("rebounding", targ) then
                for i=1,#pet_classes do
                    if rime.cure_set == pet_classes[i] then
                        return true
                    end
                end
            end
            return false
        end
    },
    ["right_leg_broken"] = {
        "epseth",
        "right_leg_broken",
        can = function()
            return true
        end
    },
    ["left_leg_broken"] = {
        "epSeth",
        "left_leg_broken",
        can = function()
            return true
        end
    },
    ["right_arm_broken"] = {
        "epteth",
        "right_arm_broken",
        can = function()
            return true
        end
    },
    ["left_arm_broken"] = {
        "epTeth",
        "left_arm_broken",
        can = function()
            return true
        end
    },
}

rime.saved.hound_atks = rime.saved.hound_atks or {["poisonclaw"] = "none",
    ["growl"] = "none",
    ["contagion"] = "none",
    ["stare"] = "none",
    ["acidspit"] = "none",
    ["shock"] = "none",
    ["tundralhowl"] = "none",
    ["ululate"] = "none",
    ["mark"] = "none",
    ["bite"] = "none",
    ["firebreath"] = "none"}
carn.hounds = {
    ["mark"] = {
        "hound mark target",
        can = function()
        if rime.pvp.has_aff("houndmark", rime.target) then
            return false
        else
            return true
        end
    end
    },

    ["contagion"] = {
        "hound contagion target",
        can = function()
        return true
    end,
    },

    ["frozen"] = {
        "hound tundralhowl target",
        can = function()
        if rime.pvp.has_aff("frozen", rime.target) then
            return false
        else
            return true
        end
    end
    },
    ["ablaze"] = {
        "hound firebreath target",
        can = function()
        if rime.pvp.has_aff("ablaze", rime.target) then
            return false
        else
            return true
        end
    end
    },
    ["ablaze2"] = {
        "hound firebreath target",
        can = function()
        if rime.pvp.has_aff("ablaze", rime.target) then
            return false
        elseif rime.pvp.has_aff("cracked_ribs", rime.target) then
            return true
        elseif rime.pvp.has_aff("crushed_chest", rime.target) then
            return true
        elseif rime.pvp.has_aff("prone", rime.target) and rime.pvp.has_aff("left_leg_broken", rime.target) and rime.pvp.has_aff("right_leg_broken", rime.target) and (rime.pvp.has_aff("left_leg_damaged", rime.target) or rime.pvp.has_aff("right_leg_damaged", rime.target)) then
            return true
        elseif rime.pvp.has_aff("prone", rime.target) and rime.pvp.has_aff("blackout", rime.target) then
            return true
        elseif rime.pvp.has_aff("prone", rime.target) and rime.pvp.has_aff("torso_damaged", rime.target) then
            return true
        else
            return false
        end
    end
    },
    ["blisters"] = {
        "hound poisonclaw target",
        can = function()
        if rime.pvp.has_aff("blisters", rime.target) then
            return false
        else
            return true
        end
    end
    },
    ["limp_veins"] = {
        "hound poisonclaw target",
        can = function()
        if rime.pvp.has_aff("limp_veins", rime.target) or not rime.pvp.has_aff("blisters", rime.target) then
            return false
        else
            return true
        end
    end
    },
    ["epilepsy"] = {
        "hound shock target",
        can = function()
        if rime.pvp.has_aff("epilepsy", rime.target) then
            return false
        else
            return true
        end
    end
    },
    ["hallucinations"] = {
        "hound shock target",
        can = function()
        if rime.pvp.has_aff("hallucinations", rime.target) or not rime.pvp.has_aff("epilepsy", rime.target) then
            return false
        else
            return true
        end
    end
    },
    ["weariness"] = {
        "hound acidspit target",
        can = function()
        if rime.pvp.has_aff("weariness", rime.target) then
            return false
        else
            return true
        end
    end
    },
    ["crippled"] = {
        "hound acidspit target",
        can = function()
        if rime.pvp.has_aff("crippled", rime.target) or not rime.pvp.has_aff("weariness", rime.target) then
            return false
        else
            return true
        end
    end
    },
    ["berserking"] = {
        "hound stare target",
        can = function()
        if rime.pvp.has_aff("berserking", rime.target) then
            return false
        else
            return true
        end
    end
    },
    ["shovingBerserk"] = {
        "hound stare target",
        can = function()
        if rime.pvp.has_aff("berserking", rime.target) then
            return false
        elseif rime.pvp.has_aff("impairment", rime.target) then
            return false
        else
            return true
        end
    end
    },
    ["impairment"] = {
        "hound stare target",
        can = function()
        if rime.pvp.has_aff("impairment", rime.target) or not rime.pvp.has_aff("berserking", rime.target) then
            return false
        else
            return true
        end
    end
    },
    ["dizziness"] = {
        "hound growl target",
        can = function()
        if rime.pvp.has_aff("dizziness", rime.target) then
            return false
        else
            return true
        end
    end
    },
    ["recklessness"] = {
        "hound growl target",
        can = function()
        if rime.pvp.has_aff("recklessness", rime.target) or not rime.pvp.has_aff("dizziness", rime.target) then
            return false
        else
            return true
        end
    end
    },
    ["blurry_vision"] = {
        "hound switch "..rime.saved.hound_atks.ululate ..rime.saved.separator.."hound ululate",
        can = function()
        if rime.pvp.has_aff("blurry_vision", rime.target) or ululateEcho then
            return false
        else
            return true
        end
    end
    },
    ["bite"] = {
        "hound switch "..rime.saved.hound_atks.bite ..rime.saved.separator.."hound bite target",
        can = function()
        return true
    end
    },
}
--This is a table that lists all of your possible attacks for Carnifex
carn.attacks = {

    ["effigy_damage"] = {
        "hammer batter effigy",
        can = function()
            local target = rime.target
            if not rime.pvp.has_def("dome", target) then return false end
            if not rime.targets[target].effigy then return false end
            return true
        end,
    },

	["shield_ally"] = {
        "soul shield ally",
        can = function()
            rime.pvp.ally = rime.pvp.ally or rime.saved.allies[1]
            for k,v in ipairs(rime.saved.allies) do
               if tonumber(rime.targets[v].aggro) > tonumber(rime.targets[rime.pvp.ally].aggro) and rime.targets[v].defences.shielded == false then
                    rime.pvp.ally = v
                end
            end

            if tonumber(rime.targets[rime.pvp.ally].aggro) > 10 and not rime.targets[rime.pvp.ally].defences.shielded and rime.pvp.ally ~= rime.target and not rime.targets[rime.pvp.ally].defences.defending then
                return true
            else
                return false
            end
        end,
    },

    ["breakCheck"] = {
     "hammer doublebash target pick1 pick2",
     can = function()
        if carn.canBreak("left_leg") and not rime.pvp.canParry() and rime.pvp.has_aff("right_leg_broken", rime.target) then
            carn.attacks.breakCheck[1] = "hammer doublebash target left leg right leg"
            return true
        elseif carn.canBreak("right_leg") and not rime.pvp.canParry() and rime.pvp.has_aff("left_leg_broken", rime,target) then
            carn.attacks.breakCheck[1] = "hammer doublebash target right leg left leg"
            return true
        else
            carn.attacks.breakCheck[1] = "hammer doublebash target "..carn.breakCheck()
            return true
        end
     end
    },
    ["erode"] = {
        "soul erode target",
        can = function()
            local targ = rime.target
            if carn.canSwing() and rime.targets[targ].defences.prismatic then
                return true
            elseif carn.canSwing() and rime.targets[targ].defences.rebounding and rime.targets[targ].defences.shielded then
                return true
            else
                return false
            end
        end
    },
    ["groupcharge"] = {
        "prepare to charge target",
        can = function()
            if carn.need_charge and not has_def("charging") then
                return true
            else
                return false
            end
        end
    },
    ["charge"] = {
        "prepare to charge target",
        can = function()
            if carn.need_charge and not has_def("charging") then
                return true
            else
                return false
            end
        end
    },
    ["pronem"] = {
        "pole hook target",
        can = function()
            if not rime.pvp.has_aff("prone", rime.target) then
                return true
            else
                return false
            end
        end
    },
    ["fuck_vampires"] = {
        "pole hook target",
        can = function()
            local target = rime.target
            local hook = 1.86
            local eq_difference = rime.getTimeLeft("eq", target) - rime.getTimeLeft("my_balance")
            local bal_difference = rime.getTimeLeft("balance", target) - rime.getTimeLeft("my_balance")
            if hook > eq_difference and hook > bal_difference then return false end
            return true
        end
    },
    ["limbProne"] = {
        "pole hook target",
        can = function()
            local targ = rime.target
            if rime.pvp.has_aff("prone", targ) then
                return false
            elseif rime.pvp.has_aff("left_leg_damaged", targ) and not rime.limit.left_leg_restore then
                return true
            elseif rime.pvp.has_aff("right_leg_damaged", targ) and not rime.limit.right_leg_restore then
                return true
            end
            return false
        end
    },  
    ["hammerraze"] = {
        "pole raze target",
        can = function()
            local targ = rime.target
            if carn.canSwing() and rime.targets[targ].defences.rebounding and rime.targets[targ].defences.shielded then
                return true
            end
            return false
        end,
    },
    ["razehack"] = {
        "pole razehack target",
        can = function()
            local targ = rime.target
            if carn.canSwing() and (rime.targets[targ].defences.rebounding or rime.targets[targ].defences.shielded) then
                return true
            else
                return false
            end
        end,
    },
    ["carve"] = {
        "pole carve target",
        can = function()
            local targ = rime.target
            if carn.canSwing() and rime.pvp.has_aff("haemophilia", targ) then
                return true
            end
            return false
        end,
    },
    ["amputate"] = {
        "pole dismember target side limb",
        can = function()
            local targ = rime.target
            if rime.pvp.has_aff("left_leg_mangled", targ) and not rime.pvp.has_aff("left_leg_amputated", targ) then
                carn.attacks.amputate[1] = "pole dismember target left leg"
                return true
            elseif rime.pvp.has_aff("right_leg_mangled", targ) and not rime.pvp.has_aff("right_leg_amputated", targ) then
                carn.attacks.amputate[1] = "pole dismember target right leg"
                return true
            elseif rime.pvp.has_aff("right_arm_mangled", targ) and not rime.pvp.has_aff("right_arm_amputated", targ) then
                carn.attacks.amputate[1] = "pole dismember target right arm"
                return true
            elseif rime.pvp.has_aff("left_arm_mangled", targ) and not rime.pvp.has_aff("left_arm_amputated", targ) then
                carn.attacks.amputate[1] = "pole dismember target left arm"
                return true
            end
            return false
        end,
    },
    ["limbPicker"] = {
        "hammer doublebash target pick1 pick2",
        can = function()
            local target_limbs = table.copy(rime.targets[rime.target].limbs)
            local sort_limbs = sortedKeys(target_limbs)
            local sorted_limbs = {}
            local mode = rime.pvp.prediction_mode
            local last_parried = rime.targets[rime.target].parry
  
            for _, key in ipairs(sort_limbs) do
                table.insert(sorted_limbs, key)
            end
            for k, v in ipairs(rime.targets[rime.target].limbs) do
                if rime.limit[v .. "_restore"] then
                    table.remove(sorted_limbs, table.index_of(sorted_limbs, v))
                end
            end
  
            table.remove(sorted_limbs, table.index_of(sorted_limbs, "left_arm"))
            table.remove(sorted_limbs, table.index_of(sorted_limbs, "right_arm"))
  
            if rime.pvp.canParry() and table.contains(sorted_limbs, last_parried) then
                table.remove(sorted_limbs, table.index_of(sorted_limbs, last_parried))
            end
            if lastLimbHit ~= "none" then
                table.remove(sorted_limbs, table.index_of(sorted_limbs, lastLimbHit:gsub(" ", "_")))
            end
            if prerestoredLimb ~= "none" then
                table.remove(sorted_limbs, table.index_of(sorted_limbs, prerestoredLimb:gsub(" ", "_")))
            end

            if #sorted_limbs > 1 then
                carn.attacks.limbPicker[1] = "hammer doublebash target "..sorted_limbs[1]:gsub("_", " ").." "..sorted_limbs[2]:gsub("_", " ")
                return true
            else
                carn.attacks.limbPicker[1] = "hammer doublebash target "..sorted_limbs[1]:gsub("_", " ").." "..sorted_limbs[1]:gsub("_", " ")
                return true
            end
        end,

    },
    ["ltorso"] = {
        "hammer doublebash target left leg torso",
        can = function()
            local targ = rime.target
            if (rime.targets[targ].parry ~= "left_leg" or not rime.pvp.canParry())
            and (rime.targets[targ].parry ~= "torso" or not rime.pvp.canParry())
            and lastLimbHit ~= "torso" and not rime.limit.torso_restore then
                return true
            elseif rime.pvp.has_aff("distortion", targ) then
                return true
            end
            return false
        end,
    },
    ["lrleg"] = {
        "hammer doublebash target left leg right leg",
        can = function()
            local targ = rime.target
            if (rime.targets[targ].parry ~= "left_leg" or not rime.pvp.canParry())
            and (rime.targets[targ].parry ~= "right_leg" or not rime.pvp.canParry())
            and lastLimbHit ~= "right leg" and not rime.limit.right_leg_restore then
                return true
            end
            return false
        end,
    },
    ["lrarm"] = {
        "hammer doublebash target left leg torso",
        can = function()
            local targ = rime.target
            if (rime.targets[targ].parry ~= "left_leg" or not rime.pvp.canParry())
            and (rime.targets[targ].parry ~= "right_arm" or not rime.pvp.canParry())
            and lastLimbHit ~= "right arm" and not rime.limit.right_arm_restore then
                return true
            end
            return false
        end,
    },
    ["eptraze"] = {
        "pole razehack target epteth nothing nothing",
        can = function()
            local targ = rime.target
            if carn.canSwing() and (rime.targets[targ].defences.rebounding or rime.targets[targ].defences.shielded) then
                return true
            else
                return false
            end
        end,
    },
    ["wither"] = {
        "soul wither target legs",
        can = function()
            local targ = rime.target
            local poulticeBalance = rime.getTimeLeft("poultice", rime.target)
            if rime.pvp.has_aff("implant", targ) then return false end
            if carn.canSwing() and rime.targets[targ].defences.rebounding then 
                if carn.canSwing() and poulticeBalance > 2 and rime.missingAff("right_leg_broken/left_leg_broken", "/") == 1 then
                    return true
                end
            end
            return false
        end,
    },
    ["spinslash"] = {
        "pole spinslash target",
        can = function()
            local targ = rime.target
            if carn.canSwing() then
                return true
            else
                return false
            end
        end,
    },
    ["batter"] = {
        "hammer batter target",
        can = function()
            local targ = rime.target
            local enemyAffTable = {}
            if rime.targets[targ] then
                for k,v in pairs(rime.targets[targ].afflictions) do
                    if v then table.insert(enemyAffTable, k) end
                end
            end
            if rime.pvp.route_choice == "ghammer" and (not rime.pvp.canParry() or rime.targets[targ].parry ~= "head") then
                return true
            elseif rime.pvp.has_aff("sensitivity", targ) and not rime.pvp.canParry() and not rime.pvp.has_aff("blackout", targ) then
                return true
            elseif rime.pvp.has_aff("soul_poison", targ) and #enemyAffTable > 6 and not rime.pvp.has_aff("blackout", targ) and not rime.pvp.canParry() then
                return true
            end
            return false
        end,
    },
    ["lockskewer"] = {
        "pole skewer target",
        can = function()
            local targ = rime.target
            if (rime.pvp.has_aff("prone", targ) or rime.pvp.has_aff("frozen", targ) or rime.pvp.has_aff("indifference", targ) or rime.pvp.has_aff("paralysis", targ)
                or rime.pvp.has_aff("writhe_transfix", targ) or rime.pvp.has_aff("writhe_web", targ)) and (carn.target_locked() and rime.pvp.has_aff("sensitivity", targ) and rime.pvp.has_aff("stupidity", targ)) then
                return true
            else 
                return false
            end
        end
    },
    ["skewer"] = {
        "pole skewer target",
        can = function()
            local targ = rime.target
            if (rime.pvp.has_aff("prone", targ) or rime.pvp.has_aff("frozen", targ) or rime.pvp.has_aff("indifference", targ) or rime.pvp.has_aff("paralysis", targ)
                or rime.pvp.has_aff("writhe_transfix", targ) or rime.pvp.has_aff("writhe_web", targ))
            and ((rime.pvp.has_aff("sensitivity", targ) and rime.pvp.has_aff("soul_poison", target))
                or (rime.targets[targ].bloodburstCount > 2)) then
                return true
            end 
            return false
        end
    },
    ["groupskewer"] = {
        "pole skewer target",
        can = function()
            local targ = rime.target
            if rime.pvp.has_aff("paralysis", targ) and rime.pvp.has_aff("anorexia", targ) and (rime.pvp.has_aff("stupidity", targ) or rime.pvp.has_aff("impatience", targ)) then
                return true
            elseif (rime.pvp.has_aff("prone", targ) or rime.pvp.has_aff("frozen", targ) or rime.pvp.has_aff("indifference", targ) or rime.pvp.has_aff("paralysis", targ)
                or rime.pvp.has_aff("writhe_transfix", targ) or rime.pvp.has_aff("writhe_web", targ)) and (carn.target_locked() or rime.pvp.has_aff("sensitivity", targ)) then
                return true
            elseif (rime.pvp.has_aff("prone", targ) or rime.pvp.has_aff("frozen", targ) or rime.pvp.has_aff("indifference", targ) or rime.pvp.has_aff("paralysis", targ)
                or rime.pvp.has_aff("writhe_transfix", targ) or rime.pvp.has_aff("writhe_web", targ)) and rime.targets[targ].bloodburstCount > 2 then
                return true
            else 
                return false
            end
        end
    },
    ["tumblestop"] = {
        "pole skewer target",
        can = function()
            local targ = rime.target
            if rime.pvp.target_tumbling then
                return true
            else
                return false
            end
        end
    },
    ["wrench"] = {
        "pole wrench",
        can = function()
            local targ = rime.target
            if carn.canSwing() and targetImpaled then
                return true
            else
                return false
            end
        end
    },
    ["shouldCheese"] = {
        "pole spinslash target epseth epseth nothing nothing",
        can = function()
            local target = rime.target
            local poulticeBalance = rime.getTimeLeft("poultice", rime.target)
            local treeBalance = rime.getTimeLeft("tree", rime.target)
            if not rime.targets[target].time.poultice then
                return false
            elseif not getStopWatchTime(rime.targets[target].time.poultice) then
                return false
            elseif carn.canSwing() and poulticeBalance >= 3 and not rime.pvp.has_aff("prone", rime.target) and not rime.pvp.has_aff("left_leg_broken", rime.target) and not rime.pvp.has_aff("right_leg_broken", rime.target) and not rime.targets[target].defences.rebounding then
                return true
            else
                return false
            end
        end,
    },
    ["gutcheckLegbreak"] = {
        "hammer gutcheck target", 
        can = function()
            local targ = rime.target
            if carn.canSwing() and ((rime.targets[targ].parry == "torso" and not rime.pvp.canParry()) or rime.targets[targ].parry ~= "torso") and ((rime.pvp.has_aff("left_leg_damaged", rime.target) and not rime.limit.left_leg_restore) or (rime.pvp.has_aff("right_leg_damaged", rime.target)) and not rime.limit.right_leg_restore) and rime.targets[targ].limbs.torso >= 1863 then
                return true
            elseif ((rime.targets[targ].parry == "torso" and not rime.pvp.canParry()) or rime.targets[targ].parry ~= "torso") and (rime.targets[targ].limbs.left_leg >= 2499 and not rime.pvp.has_aff("left_leg_damaged", rime.target) and not rime.limit.left_leg_restore) or (rime.targets[targ].limbs.right_leg >= 2499 and not rime.pvp.has_aff("right_leg_damaged", rime.target) and not rime.limit.right_leg_restore) then
                return true
            else
                return false
            end
        end,
    },
    ["cracked_ribs"] = {
        "hammer crush target chest",
        can = function()
            local targ = rime.target
            if rime.targets[targ].defences.rebounding and not rime.pvp.has_aff("distortion", targ) then
                return false
            end
            if carn.canSwing() and rime.pvp.has_aff("prone", rime.target) and rime.pvp.has_aff("torso_damaged", rime.target) and (rime.pvp.has_aff("left_leg_damaged", rime.target) or rime.pvp.has_aff("right_leg_damaged", rime.target)) then
                return true
    --        elseif carn.canSwing() and rime.pvp.has_aff("prone", rime.target) and rime.pvp.has_aff("blackout", rime.target) then
    --            return true
            elseif carn.canSwing() and rime.pvp.has_aff("prone", rime.target)
                and (rime.pvp.has_aff("left_leg_damaged", rime.target) and not rime.limit.left_leg_restore)
                and (rime.pvp.has_aff("right_leg_damaged", rime.target) and not rime.limit.right_leg_restore) then
                return true
            else
                return false
            end
        end
    },
    ["crushed_chest"] = {
        "hammer crush target chest",
        can = function()
            local targ = rime.target
            if rime.targets[targ].defences.rebounding and not rime.pvp.has_aff("distortion", targ) then
                return false
            end
            if carn.canSwing() and rime.pvp.has_aff("prone", targ) and rime.pvp.has_aff("cracked_ribs", targ) then
                return true
            else
                return false
            end
        end
    },
    ["damage_crush"] = {
        "hammer crush target chest",
        can = function()
            local targ = rime.target
            if rime.pvp.has_aff("prone", targ) then
                return true
            else
                return false
            end
        end
    },
    ["lock_crush"] = {
        "hammer crush target chest",
        can = function()
            local targ = rime.target
            if carn.canSwing() and rime.pvp.has_aff("locked", targ) and rime.pvp.has_aff("prone", targ) then
                return true
            elseif carn.canSwing() and carn.target_locked() and rime.pvp.has_aff("impairment", targ) and rime.pvp.has_aff("prone", targ) and (not rime.pvp.has_aff("stupidity", targ) and rime.getTime("poultice", targ) < 2.4) then
                return true
            elseif rime.pvp.has_aff("cracked_ribs", targ) and rime.pvp.has_aff("prone", targ) and carn.target_locked() then
            	return true
            else
                return false
            end
        end
    },
    ["crush_kneecaps"] = {
        "hammer crush target kneecaps",
        can = function()
            local targ = rime.target
            if carn.canSwing() and rime.pvp.has_aff("prone", targ) then
                return true
            else
                return false
            end
        end
    },
    ["crush_elbows"] = {
        "hammer crush target elbows",
        can = function()
            local targ = rime.target
            if carn.canSwing() and rime.pvp.has_aff("prone", targ) then
                return true
            else
                return false
            end
        end
    },
    ["pulverize"] = {
        "hammer pulverize target",
        can = function()
            local targ = rime.target
            if carn.canSwing() and rime.pvp.has_aff("prone", targ) and rime.pvp.has_aff("crushed_chest", targ) then
                return true
            else
                return false
            end
        end
    },
    ["damaged_arms"] = {
        "hammer doublebash target left arm right arm",
        can = function()
            local targ = rime.target
            if carn.canSwing() and (lastLimbHit ~= "left arm" and lastLimbHit ~= "right arm") and (not rime.limit.left_arm_restore and not rime.limit.right_arm_restore) then
                return true
            elseif carn.canSwing() and (rime.targets[targ].limbs.left_arm >= 2499 and rime.targets[targ].limbs.right_arm >= 2499) and not (rime.pvp.has_aff("left_arm_damaged", targ) and rime.pvp.has_aff("right_arm_damaged", targ)) then
                return true
            elseif carn.canSwing() and rime.pvp.has_aff("glasslimb", targ) and (rime.targets[targ].limbs.left_arm >= 1999 and rime.targets[targ].limbs.right_arm >= 1999) and not (rime.pvp.has_aff("left_arm_damaged", targ) and rime.pvp.has_aff("right_arm_damaged", targ)) then
                return true
            else
                return false
            end
        end
    },
    ["damaged_legs"] = {
        "hammer doublebash target left leg right leg",
        can = function()
            local targ = rime.target
            if rime.pvp.route_choice == "ghammer" then
                return true
            elseif rime.pvp.has_aff("distortion", targ) then
                return true
            elseif (rime.targets[targ].parry == "left_leg" or rime.targets[targ].parry == "right_leg") and rime.pvp.canParry() then
                return false
            elseif carn.canSwing() and (lastLimbHit ~= "left leg" and lastLimbHit ~= "right leg") and (not rime.limit.left_leg_restore and not rime.limit.right_leg_restore) then
                return true
            elseif carn.canSwing() and (rime.targets[targ].limbs.left_leg >= 2499 and rime.targets[targ].limbs.right_leg >= 2499) then
                return true
            elseif carn.canSwing() and rime.pvp.has_aff("glasslimb", targ) and (rime.targets[targ].limbs.left_leg >= 1999 and rime.targets[targ].limbs.right_leg >= 1999) then
                return true
            elseif carn.canSwing() and (rime.targets[targ].limbs.left_leg >= 2499 or rime.targets[targ].limbs.right_leg >= 2499) and gutcheckHit then
                return true
            else
                return false
            end
        end
    },
    ["damaged_left"] = {
        "hammer doublebash target left arm left leg",
        can = function()
            if carn.canSwing() and (lastLimbHit ~= "left arm" and lastLimbHit ~= "left leg") and (not rime.limit.left_arm_restore and not rime.limit.left_leg_restore) then
                return true
            else
                return false
            end
        end
    },
    ["damaged_right"] = {
        "hammer doublebash target right arm right leg",
        can = function()
            if carn.canSwing() and (lastLimbHit ~= "right arm" and lastLimbHit ~= "right leg") and (not rime.limit.right_arm_restore and not rime.limit.right_leg_restore) then
                return true
            else
                return false
            end
        end
    },
    ["damaged_bslash"] = {
        "hammer doublebash target right arm left leg",
        can = function()
            if carn.canSwing() and (lastLimbHit ~= "right arm" and lastLimbHit ~= "left leg") and (not rime.limit.right_arm_restore and not rime.limit.left_leg_restore) then
                return true
            else
                return false
            end
        end
    },
    ["damaged_fslash"] = {
        "hammer doublebash target left arm right leg",
        can = function()
            if carn.canSwing() and (lastLimbHit ~= "left arm" and lastLimbHit ~= "right leg") and (not rime.limit.left_arm_restore and not rime.limit.right_leg_restore) then
                return true
            else
                return false
            end
        end
    },
    ["left_leg_damaged"] = {
        "hammer doublebash target left leg left leg",
        can = function()
            local targ = rime.target
            if rime.limit.left_leg_restore then
                return false
            elseif rime.targets[targ].parry == "left_leg" and rime.pvp.canParry() then
                return false
            elseif lastLimbHit == "left leg" then
                return false
            end
            return true
        end
    },
    ["right_leg_damaged"] = {
        "hammer doublebash target right leg right leg",
        can = function()
            local targ = rime.target
            if rime.limit.right_leg_restore then
                return false
            elseif rime.targets[targ].parry == "right_leg" and rime.pvp.canParry() then
                return false
            elseif lastLimbHit == "right leg" then
                return false
            end
            return true
        end
    },
    ["left_arm_damaged"] = {
        "hammer doublebash target left arm left arm",
        can = function()
            local targ = rime.target
            if rime.limit.left_arm_restore then
                return false
            elseif rime.targets[targ].parry == "left_arm" and rime.pvp.canParry() then
                return false
            elseif lastLimbHit == "left arm" then
                return false
            end
            return true
        end
    },
    ["right_arm_damaged"] = {
        "hammer doublebash target right arm right arm",
        can = function()
            local targ = rime.target
            if rime.limit.right_arm_restore then
                return false
            elseif rime.targets[targ].parry == "right_arm" and rime.pvp.canParry() then
                return false
            elseif lastLimbHit == "right arm" then
                return false
            end
            return true
        end
    },
    ["head_damaged"] = {
        "hammer doublebash target head head",
        can = function()
            local targ = rime.target
            if rime.limit.head_restore then
                return false
            elseif rime.targets[targ].parry == "head" and rime.pvp.canParry() then
                return false
            elseif lastLimbHit == "head" then
                return false
            end
            return true
        end
    },
    ["damaged_batter"] = {
        "hammer batter target",
        can = function()
            local targ = rime.target
            if carn.canSwing() and rime.targets[targ].limbs.head >= 1864 and not rime.limit.head_restore and rime.targets[targ].limbs.head <= 3333 then
                return true
            else
                return false
            end
        end
    },
    ["should_batter"] = {
        "hammer batter target",
        can = function()
            local targ = rime.target
            if rime.pvp.canParry() then
                return false
            elseif rime.pvp.has_aff("blackout", rime.target) then
                return false
            elseif rime.getTimeLeft("focus", rime.target) > 3 and rime.pvp.has_aff("prone", rime.target) and not rime.pvp.has_aff("indifference", rime.target) then
                return true
            elseif rime.pvp.has_aff("prone", rime.target) and not rime.pvp.has_aff("indifference", rime.target) and not rime.pvp.has_aff("stuttering", rime.target) then
                return true
            elseif gutcheckHit then
                return true
            end
            return false
        end
    },
    ["torso_damaged"] = {
        "hammer gutcheck target",
        can = function()
            if carn.canSwing() and not rime.limit.torso_restore and lastLimbHit ~= "torso" then
                return true
            elseif carn.canSwing() and rime.pvp.has_aff("soulpuncture", rime.target) then
                return true
            end
            return false
        end
    },
    ["damageGutcheck"] = {
        "hammer gutcheck target",
        can = function()
            local targ = rime.target
            if carn.canSwing() and not rime.limit.torso_restore and rime.targets[targ].limbs.torso >= 1864 then
                return true
            end
            return false
        end
    },
    ["mangled_left_leg"] = {
        "hammer doublebash target left leg left leg",
        can = function()
            if carn.canSwing() and not rime.limit.left_leg_restore then
                return true
            else
                return false
            end
        end
    },
    ["mangled_right_leg"] = {
        "hammer doublebash target right leg right leg",
        can = function()
            if carn.canSwing() and not rime.limit.right_leg_restore then
                return true
            else
                return false
            end
        end
    },
    ["mangled_left_arm"] = {
        "hammer doublebash target left arm left arm",
        can = function()
            if carn.canSwing() and not rime.limit.left_arm_restore then
                return true
            else
                return false
            end
        end
    },
    ["mangled_right_arm"] = {
        "hammer doublebash target right arm right arm",
        can = function()
            if carn.canSwing() and not rime.limit.right_arm_restore then
                return true
            else
                return false
            end
        end
    },
    ["mangled_head"] = {
        "hammer doublebash target head head",
        can = function()
            if carn.canSwing() and not rime.limit.head_restore then
                return true
            else
                return false
            end
        end
    },
    ["torso_destruction"] = {
        "hammer doublebash target torso torso",
        can = function()
            local targ = rime.target
            if not rime.pvp.canParry() and not rime.pvp.has_def("rebounding", targ) then
                return true
            end
            return false
        end
    },
    ["torso_mangled"] = {
        "hammer doublebash target torso torso",
        can = function()
            local targ = rime.target
            if rime.targets[targ].parry == "torso" and rime.pvp.canParry() then
                return false
            elseif lastLimbHit == "torso" then
                return false
            elseif rime.limit.torso_restore then
                return false
            end
            return true
        end
    },
    ["torso_lleg"] = {
        "hammer doublebash target torso left leg",
        can = function()
            local targ = rime.target
            if carn.canSwing() and rime.pvp.has_aff("left_leg_mangled", targ) then
                return true
            elseif carn.canSwing() and rime.pvp.has_aff("left_leg_damaged", targ) then
                return true
            elseif carn.canSwing() and rime.targets[targ].limbs.left_leg >= 2490 then
                return true
            end
            return false
        end
    },
    ["torso_rleg"] = {
        "hammer doublebash target torso right leg",
        can = function()
            local targ = rime.target
            if carn.canSwing() and rime.pvp.has_aff("right_leg_mangled", targ) then
                return true
            elseif carn.canSwing() and rime.pvp.has_aff("right_leg_damaged", targ) then
                return true
            elseif carn.canSwing() and rime.targets[targ].limbs.right_leg >= 2490 then
                return true
            end
            return false
        end
    },
    ["ll_rl_distortbash"] = {
        "hammer doublebash target left leg right leg",
        can = function()
            local targ = rime.target
            if rime.pvp.has_aff("distortion", targ) and not rime.pvp.has_def("rebounding", rime.target) then
                --and not rime.limit.right_leg_restore and not rime.limit.left_leg_restore
                return true
            else
                return false
            end
        end
    },
    ["ll_rl_doublebash"] = {
        "hammer doublebash target left leg right leg",
        can = function()
            local targ = rime.target
            if carn.canSwing() and rime.pvp.has_aff("glasslimb", targ) and ((rime.targets[targ].limbs.left_leg >= 1999 and not rime.pvp.has_aff("left_leg_damaged")) or (rime.targets[targ].limbs.right_leg >= 1999 and not rime.pvp.has_aff("right_leg_damaged", targ))) then
                return true
            elseif carn.canSwing() and ((rime.targets[targ].limbs.left_leg >= 2499 and not rime.pvp.has_aff("left_leg_damaged", targ)) or (rime.targets[targ].limbs.right_leg >= 2499 and not rime.pvp.has_aff("right_leg_damaged", targ))) then
                return true
            else
                return false
            end
        end
    },
    ["la_ra_doublebash"] = {
        "hammer doublebash target left arm right arm",
        can = function()
            local targ = rime.target
            if carn.canSwing() and rime.pvp.has_aff("glasslimb", targ) and (rime.targets[targ].limbs.left_arm >= 1999 and rime.targets[targ].limbs.right_arm >= 1999) and (not rime.pvp.has_aff("left_arm_damaged", targ) and not rime.pvp.has_aff("right_arm_damaged", targ)) then
                return true
            elseif carn.canSwing() and (rime.targets[targ].limbs.left_arm >= 2499 and rime.targets[targ].limbs.right_arm >= 2499) and (not rime.pvp.has_aff("left_arm_damaged", targ) or not rime.pvp.has_aff("right_arm_damaged", targ)) then
                return true
            elseif carn.canSwing() and rime.pvp.has_aff("distortion", targ) and (not rime.pvp.has_aff("left_arm_damaged", targ) or not rime.pvp.has_aff("right_arm_damaged", targ)) then
                return true
            else
                return false
            end
        end
    },
    ["soulpuncture"] = {
        "soul puncture target",
        can = function()
            local targ = rime.target
            if carn.canSwing() and not rime.limit.torso_restore and rime.pvp.has_aff("torso_damaged", targ) and not rime.pvp.has_aff("soulpuncture") and rime.targets[targ].soul >= 50 then
                return true
            elseif carn.canSwing() and rime.pvp.has_aff("torso_mangled", targ) then
                return true
            else
                return false
            end
        end
    },
    ["soul_disease"] = {
        "soul disease target",
        can = function()
            local targ = rime.target
            if carn.canSwing() and rime.targets[targ].soul < 80 then
                return true
            else
                return false
            end
        end
    },
    ["wraith"] = {
        "soul wraith target",
        can = function()
            local targ = rime.target
            if carn.canSwing() and rime.targets[targ].soul < 92 then
                return true
            else
                return false
            end
        end
    },
    ["implant"] = {
        "soul implant target venom trigger",
        can = function()
            local targ = rime.target
            if rime.pvp.has_def("rebounding", targ) then
                if carn.canSwing() and carn.can.implant and rime.targets[targ].soul < 77 then
                    if rime.pvp.route_choice == "white" or rime.pvp.route_choice == "black" then
                        if rime.pvp.has_aff("locked", targ) then
                            return true
                        elseif #rime.missingAff("slickness/anorexia/asthma/paresis", "/") < 2 then
                            if rime.pvp.has_aff("stupidity", targ) or rime.pvp.has_aff("impatience", targ) or rime.getTimeLeft("focus", targ) > 2.4 then
                                return true
                            else
                                return false
                            end
                        end
                    else
                        return true
                    end
                end
            else
                if carn.canSwing() and carn.can.implant and rime.targets[targ].soul < 77 then
                    if (rime.pvp.route_choice == "white" or rime.pvp.route_choice == "black") then
                        if rime.pvp.has_aff("locked", targ) then
                            return true
                        elseif #rime.missingAff("slickness/anorexia/asthma", "/") <= 2 then
                            if rime.pvp.has_aff("stupidity", targ) or rime.pvp.has_aff("impatience", targ) or rime.getTimeLeft("focus", targ) > 2.4 then
                                return true
                            else
                                return false
                            end
                        end
                    else
                        return true
                    end
                end
            end
            return false
        end
    },
    ["eptimplant"] = {
        "soul implant target epseth epteth",
        can = function()
            local targ = rime.target
            if carn.canSwing() and carn.can.implant and rime.targets[targ].soul < 77 then
                return true
            else
                return false
            end
        end
    },
    ["soul_poison"] = {
        "soul poison target",
        can = function()
            local targ = rime.target
            local enemyAffTable = {}
            if rime.targets[targ] then
                for k,v in pairs(rime.targets[targ].afflictions) do
                    if v then table.insert(enemyAffTable, k) end
                end
            end
            if carn.canSwing() and rime.targets[targ].soul < 80 and #enemyAffTable > 5 and carn.can.poison then
                return true
            end
            return false
        end
    },
    ["distortion"] = {
        "soul distort target",
        can = function()
            local targ = rime.target
            if carn.canSwing() and rime.targets[targ].soul < 92 and carn.can.distort then
                return true
            else
                return false
            end
        end
    },
    ["glasslimb"] = {
        "soul frailty target",
        can = function()
            local targ = rime.target
            if carn.atk() and carn.atk():find("crush") then
                return false
            elseif rime.pvp.has_aff("soulpuncture", targ) and rime.targets[targ].soul < 50 then
                return true
            elseif carn.atk() and carn.can.distort then
                return false
            elseif rime.targets[targ].soul < 82 and not rime.pvp.has_aff("distortion", targ) then
                return true
            else
                return false
            end
        end
    },
    ["bloodburst"] = {
        "soul bloodburst target",
        can = function()
            local targ = rime.target
            if carn.atk() and carn.atk():find("crush") then
                return false
            elseif carn.canSwing() and rime.targets[targ].bloodburstCount == 0 and rime.targets[targ].soul < 50 then
                return true
            elseif carn.canSwing() and rime.targets[targ].bloodburstCount > 0 and rime.targets[targ].bloodburstCount < 3 and rime.targets[targ].soul < 82 then
                return true
            end
            return false
        end
    },
}

implantVenom = "none"
venomTrigger = "none"
function carn.canSwing()
    
    local target = rime.target

    if rime.pvp.class_lockBreak() then return false end

    if (rime.has_aff("left_arm_broken") and rime.has_aff("right_arm_broken")) or rime.has_aff("paralysis")
    or rime.has_aff("writhe_transfix") or rime.has_aff("writhe_impaled") or rime.has_aff("writhe_web") then
        return false
    end

    return true

end

function carn.atk() --use this to pick raze, razehack, spinslash, batter, doublebash, skewer, wrench etc.

    local targ = rime.target

    for k,v in ipairs(rime.pvp.route.attack) do
        if not rime.pvp.has_aff(v, targ) and carn.attacks[v].can() then
            return carn.attacks[v][1]:gsub("target", rime.target):gsub("ally", rime.pvp.ally)
        end
    end

    return false

end

function carn.venoms()
    carn.ven1 = false
    carn.ven2 = false
    local targ = rime.target
    if rime.pvp.route_choice == "nothing" then
        rime.pvp.route_choice = "group"
        rime.echo("HEY DUMMY PICK A ROUTE")
        rime.echo("HEY DUMMY PICK A ROUTE")
        rime.echo("HEY DUMMY PICK A ROUTE")
        rime.echo("HEY DUMMY PICK A ROUTE")
        rime.echo("HEY DUMMY PICK A ROUTE")
        rime.echo("HEY DUMMY PICK A ROUTE")
        rime.echo("HEY DUMMY PICK A ROUTE")
        rime.echo("HEY DUMMY PICK A ROUTE")
        rime.echo("HEY DUMMY PICK A ROUTE")
        rime.echo("HEY DUMMY PICK A ROUTE")
        rime.echo("HEY DUMMY PICK A ROUTE")
        rime.echo("HEY DUMMY PICK A ROUTE")
        rime.echo("HEY DUMMY PICK A ROUTE")
        rime.echo("HEY DUMMY PICK A ROUTE")
    end
    if string.find(rime.pvp.route_choice, "hammer") or rime.pvp.route_choice == "limbs" then 
        for k,v in ipairs(rime.pvp.route.venoms) do
            if carn.ven1 ~= false then
                if not rime.pvp.has_aff(carn.slashes[v][2], targ) and carn.slashes[v].can() then
                    carn.ven2 = carn.slashes[v][1]
                    break
                end
            elseif not rime.pvp.has_aff(carn.slashes[v][2], targ) and carn.slashes[v].can() then
                carn.ven1 = carn.slashes[v][1]
            end
        end

    else

        for k,v in ipairs(rime.pvp.route.venoms) do
            if carn.ven1 ~= false then
                if not rime.pvp.has_aff(carn.slashes[v][2], targ) and carn.slashes[v].can() then
                    if implantVenom == carn.slashes[v][1] then
                        if rime.pvp.has_aff(rime.convert_venom(venomTrigger), rime.target) and carn.slashes[v][2] ~= rime.convert_venom(carn.ven1) then
                            carn.ven2 = carn.slashes[v][1]
                            break
                        end
                    elseif carn.slashes[v][2] ~= rime.convert_venom(carn.ven1) then
                        carn.ven2 = carn.slashes[v][1]
                        break
                    end
                end
            elseif not rime.pvp.has_aff(carn.slashes[v][2], targ) and carn.slashes[v].can() then
                if implantVenom == carn.slashes[v][1] then
                    if rime.pvp.has_aff(rime.convert_venom(venomTrigger), rime.target) then
                        carn.ven1 = carn.slashes[v][1]
                    end
                else
                    carn.ven1 = carn.slashes[v][1]
                end
            end
        end
    end
    --default venoms
    if not carn.ven1 then carn.ven1 = "epseth" end
    if not carn.ven2 then carn.ven2 = "epseth" end

    --make the trigger venom the second slash
    if carn.ven1 == venomTrigger then
        local swap = carn.ven2
        carn.ven2 = carn.ven1
        carn.ven1 = swap
    end

end

function carn.lock_swing()
    local missing = rime.missingAff("asthma/slickness/anorexia", "/")
    --check for two affs + 1 = venomlock
    if #missing == 1 and (carn.slashes[missing[1]][2] == carn.ven1 or carn.slashes[missing[1]][1] == carn.ven2) then
        return true
    elseif #missing == 2 and (carn.slashes[missing[1]][1] == carn.ven1 or carn.slashes[missing[1]][1] == carn.ven2) and (carn.slashes[missing[2]][1] == carn.ven1 or carn.slashes[missing[2]][1] == carn.ven2) then
        return true
    else
        return false
    end
end

function carn.target_locked()
    local targ = rime.target
    if rime.pvp.has_aff("asthma", targ) and rime.pvp.has_aff("slickness", targ) and (rime.pvp.has_aff("anorexia", targ) or (rime.pvp.has_aff("left_arm_broken", targ) and rime.pvp.has_aff("right_arm_broken", targ))) then
        return true
    else
        return false
    end
end

function carn.soulAtk()
    --changing to an if block for more precise usage
    local targ = rime.target
    if carn.atk() then
        if carn.atk():find("crush") then return false end
    end

    for k,v in ipairs(rime.pvp.route.deathlore) do
        if not rime.pvp.has_aff(v, targ) and carn.attacks[v].can() then
            return carn.attacks[v][1]:gsub("target", rime.target)
        end
    end

    return false

end

function carn.handleHounds()
    active_hound = active_hound or nil
    local hounds = rime.saved.hound_atks
    local sep = rime.saved.separator
    local hound_aff = "none"
    local hound_string = ""
    if active_hound == nil then return end -- antispam for when we don't have hounds out(hopefully)

    for k,v in ipairs(rime.pvp.route.hounds) do
        if carn.hounds[v].can() then
            if hound_aff == "none" then
                hound_aff = v
                break
            end
        end

    end

    if hound_aff == "none" or hound_aff == nil then
        hound_aff = "contagion"
    end

    if hound_aff ~= "none" and rime.balances.ability and rime.balances.balance == false and not rime.limit.hounds then
        hound_string = carn.hounds[hound_aff][1]:gsub("target", rime.target)
        carn.lastHound = hound_string
        limitStart("hounds", .2)
        act(hound_string)
    end

end

carn.lastHound = carn.lastHound or ""

function carn.offense()
    --Meat and potatoes attack picking and command sending done here
    local target = rime.target
    local sep = rime.saved.separator
    local savagery_attack = carn.atk() or ""
    carn.venoms() --this sets carn.ven1 and carn.ven2
    local deathlore_attack = carn.soulAtk() or ""
    local venom_call = ""
    local command = ""

    if savagery_attack:find("spinslash") then
        if savagery_attack:find("epseth epseth") then
            command = savagery_attack
            venom_call = "epseth/epseth"
        else
            command = savagery_attack .. " " .. carn.ven1 .. " " .. carn.ven2
            venom_call = carn.ven1.."/"..carn.ven2
        end
    elseif savagery_attack:find("carve") then
        command = savagery_attack .. " " .. carn.ven1
        venom_call = carn.ven1
    elseif savagery_attack:find("razehack") then
        if savagery_attack:find("epteth") then
            command = "target nothing"..sep..savagery_attack
            venom_call = "epteth"
        else
            command  = "target nothing"..sep..savagery_attack .. " " .. carn.ven2
            venom_call = carn.ven2
        end
    else
        command = savagery_attack
    end

    if not has_def("soulthirst") then
        deathlore_attack = "soul thirst"
        command = command .. sep .. deathlore_attack
    elseif deathlore_attack ~= "" then
        if deathlore_attack:find("implant") ~= nil then
            if rime.pvp.route_choice == "mental" then
                if #rime.missingAff("paresis/stupidity/shyness/dizziness/epilepsy/vomiting/allergies/haemophilia/sensitivity", "/") <= 2 then
                    deathlore_attack = deathlore_attack:gsub("venom", "gecko")
                    deathlore_attack = deathlore_attack:gsub("trigger", "slike")
                else
                    deathlore_attack = deathlore_attack:gsub("venom", "ouabain")
                    deathlore_attack = deathlore_attack:gsub("trigger", "curare")
                end
            elseif (rime.pvp.route_choice == "white" or rime.pvp.route_choice == "black") then
                deathlore_attack = deathlore_attack:gsub("venom", "slike")
                deathlore_attack = deathlore_attack:gsub("trigger", "gecko")
            elseif rime.pvp.route_choice == "phys" then
                if rime.pvp.has_aff("locked", rime.target) then
                    deathlore_attack = deathlore_attack:gsub("venom", "slike")
                    deathlore_attack = deathlore_attack:gsub("trigger", "gecko")
                else
                    for k,v in ipairs(rime.pvp.route.venoms) do
                        if not rime.pvp.has_aff(carn.slashes[v][2], targ) and carn.slashes[v][1] ~= "xentio" and carn.slashes[v].can() then
                            deathlore_attack = deathlore_attack:gsub("venom", carn.slashes[v][1])
                            deathlore_attack = deathlore_attack:gsub("trigger", "xentio")
                            break
                        end
                    end
                end
            else
                for k,v in ipairs(rime.pvp.route.venoms) do
                    if not rime.pvp.has_aff(carn.slashes[v][2], targ) and carn.slashes[v][1] ~= "xentio" and carn.slashes[v].can() then
                        deathlore_attack = deathlore_attack:gsub("venom", carn.slashes[v][1])
                        deathlore_attack = deathlore_attack:gsub("trigger", "xentio")
                        break
                    end
                end
            end
        end
        if carn.wantDeathlore then
            command = command .. sep .. deathlore_attack
        end
    end

    if rime.pvp.targetThere and rime.pvp.web_aff_calling and (savagery_attack:find("spinslash") or savagery_attack:find("razehack")) then

        local web_call = rime.pvp.omniCall(venom_call:lower())
        command = rime.pvp.queue_handle() .. sep .. web_call .. sep .. command

    else

        command = rime.pvp.queue_handle() .. sep .. command

    end

    command = command:gsub(sep .. sep .. "+", sep)
    command = command .. rime.pvp.post_queue()

    if command ~= rime.balance_queue and command ~= rime.balance_queue_attempted then
        act(command)
        rime.balance_queue_attempted = command
    end

    carn.handleHounds()

end
