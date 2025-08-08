if not rime.saved then return end
if not rime.saved.revblade1 then rime.saved.revblade1 = "longsword" end
if not rime.saved.revblade2 then rime.saved.revblade2 = "longsword.2" end
if not rime.saved.revblunt1 then rime.saved.revblunt1 = "1" end
if not rime.saved.revblunt2 then rime.saved.revblunt2 = "2" end
if not rime.saved.rev2handblade then rime.saved.rev2handblade = "1" end
if not rime.saved.rev2handblunt then rime.saved.rev2handblunt = "2" end
rime.pvp.Revenant.routes = {

    ["black"] = {
        ["blurb"] = {"Brute Cull"},
        ["weapon"] = "1handblades",
        ["chirography"] = {
            "atdum",
            "aneda",
        },
        ["eq_use"] = {
            "discord",
        },
        ["attack"] = {
            "extirpate",
            "cull",
            "gouge",
            "deceive",
            "duplicity",
        },
        ["venoms"] = {
            "mortalterror",
            "asthma",
            "outdoor_stupidity",
            "paresis",
            "clumsiness",
            "disfigurement",
            "physical_disruption",
            "mental_disruption",
            "slickness",
            "anorexia",
            "crippled",
            "crippled_body",
            "weariness",
            "left_arm_broken",
            "right_arm_broken",
            "left_leg_broken",
            "right_leg_broken",
            "vomiting",
            "haemophilia",
            "dizziness",
            "no_deaf",
            "sensitivity",
        },

    },

    ["group"] = {
        ["blurb"] = {"Group route for when they call \"affs\""},
        ["weapon"] = "1handblades",
        ["chirography"] = {
            "double_lawid",
        },
        ["eq_use"] = {
            "disperse",
            "aegis_barrier",
            "discord",
            "group_web",
        },
        ["attack"] = {
            "extirpate",
            "cull",
            "juxtapose_ally",
            "grouptranspierce",
            "gouge",
            "deceive",
            "duplicity",
        },
        ["venoms"] = {
            "push_anorexia",
            "push_stupidity",
            "asthma",
            "paresis",
            "slickness",
            "anorexia",
            "left_leg_broken",
            "right_leg_broken",
            "sensitivity",
            "left_arm_broken",
            "right_arm_broken",
            "haemophilia",
            "no_deaf",
            "damage",
        },
    },
}

rev = rev or {}

rev.attacks = rev.attacks or {}
rev.slashes = rev.slashes or {}
rev.can = rev.can or {}

rev.need_circle = false

rev.slashes = {

    ["outdoor_stupidity"] = {
        "aconite",
        "stupidity",
        can = function()
            if rime.pvp.room.indoors then
                return false
            elseif rime.pvp.has_aff("epilepsy") then
                return true 
            elseif (rev.aneda_left_scribed or rev.aneda_right_scribed) then
                return true
            end
            return false
        end,
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
    ["mortalterror"] = {
        "bimre",
        "mortalterror",
        can = function()
        if rime.pvp.has_aff("mortalterror", rime.target) then
            return false
        else
            return true
        end
    end,
    },
    ["mental_disruption"] = {
        "dirne",
        "mental_disruption",
        can = function()
            local targ = rime.target 
            if rev.terror then
                if rime.pvp.has_aff("physical_disruption", targ) or rev.ven1 == "diRne" or rev.atdumslash == "diRne" then
                    return true
                else
                    return false 
                end
            end
            return false
        end,
    },
    ["physical_disruption"] = {
        "diRne",
        "physical_disruption",
        can = function()
            return true
        end,
    },
    ["crippled"] = {
        "aZu",
        "crippled",
        can = function()
            if rime.pvp.has_aff("crippled_body", rime.target) then
                return false
            end
            return true
        end,
    },
    ["crippled_body"] = {
        "azu",
        "crippled_body",
        can = function()
            return true
        end,
    },
    ["flared"] = {
        "livfa",
        "flared",
        can = function()
            return true
        end,
    },
    ["rend"] = {
        "",
        "rend",
        can = function()
            local targ = rime.target
            if rev.eq_use() then
                return true
            end
            return false
        end,
    },
    ["stun"] = {
        "adil",
        "stun",
        can = function()
            return true
        end,
    },
    ["damage"] = {
        "wilave",
        "damage",
        can = function()
            return true
        end,
    },
    ["lura"] = {
        "lura",
        "limbdamage",
        can = function()
            return true
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
            return true
        end
    },
    ["clumsiness"] = {
        "xentio",
        "clumsiness",
        can = function()
            if rev.target_locked() then return false end
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
            return true
        end
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
    ["squelched"] = {
        "selarnia",
        "squelched",
        can = function()
            return true
        end
    },
    ["deadening"] = {
        "vardrax",
        "deadening",
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
        "preFarar",
        "sensitivity",
        can = function()
            return true
        end
    },
    ["no_deaf"] = {
        "prefarar",
        "no_deaf",
        can = function()
            return true
        end
    },
    ["blurry_vision"] = {
        "oCulus",
        "blurry_vision",
        can = function()
            return true
        end
    },
    ["no_blind"] = {
        "oculus",
        "no_blind",
        can = function()
            return true
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
    ["strongWeariness"] = {
        "vernalius",
        "weariness",
        can = function()
            local targ = rime.target 
            local focusbal = rime.getTimeLeft("focus", target)
            if focusbal >= 2.5 or rime.pvp.has_aff("stupidity", targ) or rime.pvp.has_aff("epilepsy", targ) or rime.pvp.has_aff("mental_disruption", targ) then
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
            return true
        end
    },
    ["disfigurement"] = {
        "monkshood",
        "disfigurement",
        can = function()
            local targ = rime.target
            local pet_classes = {"sentinel", "carnifex", "praenomen", "teradrim", "indorani", "luminary"}
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
        "epSeth",
        "right_leg_broken",
        can = function()
            return true
        end
    },
    ["left_leg_broken"] = {
        "epseth",
        "left_leg_broken",
        can = function()
            return false
        end
    },
    ["right_arm_broken"] = {
        "epTeth",
        "right_arm_broken",
        can = function()
            return true
        end
    },
    ["left_arm_broken"] = {
        "epteth",
        "left_arm_broken",
        can = function()
            return false
        end
    },
}

--This is a table that lists all of your possible eq attacks for Revenant
rev.eq_attacks = {

    ["discord"] = {
        "phantasm discord target confusion",
        can = function()
            rev.discordVenom = "none"
            if not rev.can1Swing() then return false end -- short circuit fail case
            local targ = rime.target
            if rime.pvp.has_def("shielded", targ) then return false end

            -- they're locked but not locked locked, lets do it the quick way, --don't care about blade charge (faster overall balance)
            if rev.target_locked() and not rime.pvp.has_aff("stupidity", targ) then 
                rev.eq_attacks.discord[1] = "phantasm discord target stupidity"..rime.saved.separator
                rev.discordVenom = "aconite"
                return true
            elseif rev.target_locked() and not (rime.pvp.has_aff("paralysis", targ) or rime.pvp.has_aff("paresis", targ)) then
                rev.eq_attacks.discord[1] = "phantasm discord target paresis"..rime.saved.separator
                rev.discordVenom = "curare"
                return true
            end
            return false
        end,
    },


    -- want confusion
    ["confusion"] = {
        "phantasm discord target confusion",
        can = function()
            local targ = rime.target
            if rev.can1Swing() and not rime.pvp.has_aff("confusion", targ) then
               return true
            end 

            return false
        end,
    },

    ["aegis_barrier"] = {
        "phantasm discord target confusion",
        can = function()
            local targ = rime.target
            if rime.pvp.has_def("aegis", targ) or rime.pvp.has_def("barrier", targ) then
                if not rime.pvp.has_aff("paresis", targ) and not rime.pvp.has_aff("paralysis", targ) then
                    rev.eq_attacks.aegis_barrier[1] = "phantasm discord target paresis"..rime.saved.separator
                    rev.discordVenom = "curare"
                    return true
                elseif not rime.pvp.has_aff("stupidity", targ) then
                    rev.eq_attacks.aegis_barrier[1] = "phantasm discord target stupidity"..rime.saved.separator
                    rev.discordVenom = "aconite"
                    return true
                elseif not rime.pvp.has_aff("confusion", targ) then
                    rev.eq_attacks.aegis_barrier[1] = "phantasm discord target confusion"..rime.saved.separator
                    rev.discordVenom = "none"
                    return true
                elseif not rime.pvp.has_aff("withering", targ) then
                    rev.eq_attacks.aegis_barrier[1] = "phantasm parasite target"..rime.saved.separator
                    return true
                end
                return false
            end 

            return false
        end,
    },

    ["withering"] = {
        "phantasm parasite target",
        can = function()
            local targ = rime.target
            if rime.pvp.has_def("shielded", targ) then return false end
            if rime.pvp.has_aff("withering", targ) then return false end
            if rime.pvp.has_aff("asthma", targ) and (rime.pvp.has_aff("clumsiness", targ) or rime.pvp.has_aff("weariness", targ)) and rime.pvp.count_affs("physical") >= 5 then
                return true
            end
            return false
        end,
    },

    ["writhe_web"] = {
        "touch web target"..rime.saved.separator,
        can = function()
            if rime.saved.webspray then rev.eq_attacks.writhe_web[1] = "webspray target"..rime.saved.separator end
            local targ = rime.target
            if rime.targets[targ].webevasion then return false end
            if rime.pvp.has_def("shielded", targ) then return false end
            if rime.pvp.has_aff("physical_disruption", targ) and rime.pvp.count_affs("physical") >= 5 and not rime.pvp.has_aff("writhe_web", target) then
                return true
            else 
                return false
            end
        end
    },

    ["group_web"] = {
        "touch web target"..rime.saved.separator,
        can = function()
            if rime.saved.webspray then rev.eq_attacks.writhe_web[1] = "webspray target"..rime.saved.separator end
            local targ = rime.target
            if rime.pvp.has_def("shielded", targ) then return false end
            if rime.targets[targ].webevasion then return false end
            if rime.pvp.has_aff("writhe_impaled", targ) then return false end
            if not rime.pvp.has_aff("writhe_web", target) then
                return true
            else 
                return false
            end
        end
    },

    ["disperse"] = {
        "disperse ally"..rime.saved.separator,
        can = function()
            rime.pvp.ally = rime.pvp.ally or rime.saved.allies[1]
            local foundOne = false
            for k,v in ipairs(rime.saved.allies) do
                if foundOne then return true else
                    if rime.targets[v] == nil then add_target(v) end
                    for a,b in ipairs(rime.curing.affsByType.writhe) do
                        if rime.pvp.has_aff(b, v) and v ~= rime.target then
                            rime.pvp.ally = v
                            foundOne = true
                            break
                        end
                    end
                end
            end
            if foundOne then return true end
            return false
        end
    },

}

rev.attacks = {
    ["juxtapose_ally"] = {
        "juxtapose ally",
        can = function()
            rime.pvp.ally = rime.pvp.ally or rime.saved.allies[1]
            for k,v in ipairs(rime.saved.allies) do
               if tonumber(rime.targets[v].aggro) > tonumber(rime.targets[rime.pvp.ally].aggro) and not rime.targets[v].defending and rime.targets[v].defences.defended == false then
                    rime.pvp.ally = v
                end
            end

            if tonumber(rime.targets[rime.pvp.ally].aggro) >= 7 and not rime.targets[rime.pvp.ally].defences.defended and not rime.targets[rime.pvp.ally].defending and rime.pvp.ally ~= rime.target then
                if (rime.affTally > 5 or rime.vitals.percent_health < 40) or has_def("defending") then
                    return false 
                else
                    return true
                end
            end
            return false
        end,
    },

    ["rend"] = {
        "gouge target",
        can = function()
            return true
        end,
    },

    ["cull"] = {
        "cull target",
        can = function()
            if #rime.missingAff("mental_disruption/physical_disruption/crippled_body/paralysis", "/") == 0 then
                return true
            else
                return false
            end
        end
    },

    ["deceive"] = {
        "deceive target",
        can = function()
            local targ = rime.target
            if rev.can2Swing() and (rime.targets[targ].defences.rebounding or rime.targets[targ].defences.shielded) then
                if (rime.pvp.route_choice == "mace" or rime.pvp.route_choice == "bat") and not rime.targets[targ].defences.shielded then
                    if rev.chirography.wasiatdum.can() then
                        return false
                    else
                        return true
                    end
                else
                    return true
                end
            end
            return false
        end,
    },

    ["hemoclysm"] = {
        "hemoclysm target pick1",
        can = function()
        local affs = rime.targets[rime.target].afflictions
        local bruises = {
                    "right_arm_bruised_critical",
                    "left_arm_bruised_critical",
                    "right_leg_bruised_critical",
                    "left_leg_bruised_critical",
                    "torso_bruised_critical",
                    "right_arm_bruised_moderate",
                    "left_arm_bruised_moderate",
                    "right_leg_bruised_moderate",
                    "left_leg_bruised_moderate",
                    "torso_bruised_moderate",
                }
            local bruisecount = 0
            local left_charged = rime.vitals.left_charge
            local right_charged = rime.vitals.right_charge
            if not rev.can2Swing() then return false end
            for k,v in ipairs(bruises) do
                if rime.pvp.has_aff(v, rime.target) then
                    bruisecount = bruisecount+1
                    if string.find(v, "critical") then
                        if string.find(v, "torso") or string.find(v, "head") then
                            rev.attacks.hemoclysm[1] = "lurk target"..rime.saved.separator.."hemoclysm target "..v:gsub("(%a+)_bruised_%a+", "%1")
                        else
                            rev.attacks.hemoclysm[1] = "lurk target"..rime.saved.separator.."hemoclysm target "..v:gsub("(%a+)_(%a+)_bruised_%a+", "%1 %2")
                        end
                        return true
                    elseif rev.bongoBonanza then --Bonus Round activated!
                        if string.find(v, "torso") or string.find(v, "head") then
                            rev.attacks.hemoclysm[1] = "lurk target"..rime.saved.separator.."hemoclysm target "..v:gsub("(%a+)_bruised_%a+", "%1")
                        else
                            rev.attacks.hemoclysm[1] = "lurk target"..rime.saved.separator.."hemoclysm target "..v:gsub("(%a+)_(%a+)_bruised_%a+", "%1 %2")
                        end
                        return true
                    else
                        rev.bongoBonanza = false
                        return false
                    end
                end
                rev.bongoBonanza = false
            end
            return false
        end
    },
    ["breakCheck"] = {
     "dpl target pick1 pick2",
     can = function()
        if rev.canBreak("left_leg") and not rime.pvp.canParry() and not rime.pvp.has_aff("right_leg_broken", rime.target) and not rev.canDoubleBreak("legs") and not rime.pvp.has_aff("prone", rime.target) then
            rev.attacks.breakCheck[1] = "dpl target left leg right leg lura baludu"
            return true
        elseif rev.canBreak("right_leg") and not rime.pvp.canParry() and not rime.pvp.has_aff("left_leg_broken", rime,target) and not rev.canDoubleBreak("legs") and not rime.pvp.has_aff("prone", rime.target) then
            rev.attacks.breakCheck[1] = "dpl target right leg left leg lura baludu"
            return true
        else
            rev.attacks.breakCheck[1] = "dpl target "..rev.breakCheck()
            return true
        end
     end
    },
    ["fellBreakCheck"] = {
     "fell target pick1 pick2",
     can = function()
        if rev.canBreak("left_leg") and not rime.pvp.canParry() and not rime.pvp.has_aff("right_leg_broken", rime.target) and not rev.canDoubleBreak("legs") and not rime.pvp.has_aff("prone", rime.target) then
            rev.attacks.fellBreakCheck[1] = "fell target left leg right leg lura baludu"
            return true
        elseif rev.canBreak("right_leg") and not rime.pvp.canParry() and not rime.pvp.has_aff("left_leg_broken", rime,target) and not rev.canDoubleBreak("legs") and not rime.pvp.has_aff("prone", rime.target) then
            rev.attacks.fellBreakCheck[1] = "fell target right leg left leg lura baludu"
            return true
        else
            rev.attacks.fellBreakCheck[1] = "fell target "..rev.breakCheck()
            return true
        end
     end
    },
    ["wilaveee"] = {
     "dpl target nothing nothing wilave wilave",
     can = function()
        if rev.wilaveee then
            return true
        end
        return false
     end
    },
    ["limbPicker"] = {
        "dpl target pick1 pick2",
        can = function()
            local target_limbs = table.copy(rime.targets[rime.target].limbs)
            local sort_limbs = sortedKeys(target_limbs)
            local sorted_limbs = {}
            local mode = rime.pvp.prediction_mode
            local last_parried = rime.targets[rime.target].parry
  
            for _, key in ipairs(sort_limbs) do
                table.insert(sorted_limbs, key)
            end
  
            table.remove(sorted_limbs, table.index_of(sorted_limbs, "head"))
            table.remove(sorted_limbs, table.index_of(sorted_limbs, "right_arm"))
  
            if rime.pvp.canParry() and table.contains(sorted_limbs, last_parried) then
                table.remove(sorted_limbs, table.index_of(sorted_limbs, last_parried))
            end
            if lastLimbHit ~= "none" then
                table.remove(sorted_limbs, table.index_of(sorted_limbs, lastLimbHit:gsub(" ", "_")))
            end

            if #sorted_limbs > 1 then
                rev.attacks.limbPicker[1] = "dpl target "..sorted_limbs[1]:gsub("_", " ").." "..sorted_limbs[2]:gsub("_", " ")
                return true
            else
                rev.attacks.limbPicker[1] = "dpl target "..sorted_limbs[1]:gsub("_", " ").." "..sorted_limbs[1]:gsub("_", " ")
                return true
            end
        end,

    },

    ["dupPicker"] = {
        "dpl target pick1 pick2",
        can = function()
            local target_limbs = table.copy(rime.targets[rime.target].limbs)
            local sort_limbs = sortedKeys(target_limbs)
            local sorted_limbs = {}
            local mode = rime.pvp.prediction_mode
            local last_parried = rime.targets[rime.target].parry
  
            for _, key in ipairs(sort_limbs) do
                table.insert(sorted_limbs, key)
            end
  
            table.remove(sorted_limbs, table.index_of(sorted_limbs, "head"))
            table.remove(sorted_limbs, table.index_of(sorted_limbs, "right_arm"))
  
            if rime.pvp.canParry() and table.contains(sorted_limbs, last_parried) then
                table.remove(sorted_limbs, table.index_of(sorted_limbs, last_parried))
            end
            if lastLimbHit ~= "none" then
                table.remove(sorted_limbs, table.index_of(sorted_limbs, lastLimbHit:gsub(" ", "_")))
            end

            if #sorted_limbs > 1 then
                rev.attacks.dupPicker[1] = "dpl target "..sorted_limbs[1]:gsub("_", " ").." "..sorted_limbs[2]:gsub("_", " ")
                return true
            else
                rev.attacks.dupPicker[1] = "dpl target "..sorted_limbs[1]:gsub("_", " ").." "..sorted_limbs[1]:gsub("_", " ")
                return true
            end
        end,

    },

    ["duplicity"] = {
        "dpl target",
        can = function()
            if rev.can2Swing() then
                return true
            end
            return false
        end,
    },

    ["gouge"] = {
        "gouge target",
        can = function()
            if rev.can1Swing() and rev.eq_use() then
                return true
            end
            return false
        end,
    },

    ["locktranspierce"] = {
        "transpierce target",
        can = function()
            local targ = rime.target
            if (rime.pvp.has_aff("prone", targ) or rime.pvp.has_aff("frozen", targ) or rime.pvp.has_aff("indifference", targ) or rime.pvp.has_aff("paralysis", targ)
            or rime.pvp.has_aff("writhe_transfix", targ) or rime.pvp.has_aff("writhe_web", targ)) and (rev.target_locked() and rime.pvp.has_aff("sensitivity", targ) and rime.pvp.has_aff("stupidity", targ)) then
                return true
            else 
                return false
            end
        end
    },
    ["transpierce"] = {
        "transpierce target",
        can = function()
            local targ = rime.target
            if (rime.pvp.has_aff("prone", targ) or rime.pvp.has_aff("frozen", targ) or rime.pvp.has_aff("indifference", targ)
            or rime.pvp.has_aff("writhe_transfix", targ) or rime.pvp.has_aff("writhe_web", targ)) 
            or rev.chirography.stunatdum.can() then
                if rime.pvp.has_aff("writhe_impaled", targ) then
                    return false
                elseif rev.canlurk and rime.pvp.count_affs("physical") >= 5 then
                    rev.attacks.transpierce[1] = "lurk target"..rime.saved.separator.."transpierce target"
                    return true
                elseif rime.pvp.count_affs("physical") >= 5 then
                    rev.attacks.transpierce[1] = "transpierce target"
                    return true
                end
            end 
            return false
        end
    },
    ["limbtranspierce"] = {
        "quickwield both "..rime.saved.revblade1.." "..rime.saved.revblade2..rime.saved.separator.."lurk target"..rime.saved.separator.."transpierce target",
        can = function()
            local targ = rime.target
            if (rime.pvp.has_aff("prone", targ) or rime.pvp.has_aff("frozen", targ) or rime.pvp.has_aff("indifference", targ) or rime.pvp.has_aff("paralysis", targ)
            or rime.pvp.has_aff("writhe_transfix", targ) or rime.pvp.has_aff("writhe_web", targ)) 
            or rev.chirography.limbatdum.can() then
                if rime.pvp.has_aff("writhe_impaled", targ) then
                    return false
                elseif rev.canlurk then
                    rev.attacks.transpierce[1] = "quickwield both "..rime.saved.revblade1.." "..rime.saved.revblade2..rime.saved.separator.."lurk target"..rime.saved.separator.."transpierce target"
                else
                    rev.attacks.transpierce[1] = "quickwield both "..rime.saved.revblade1.." "..rime.saved.revblade2..rime.saved.separator.."transpierce target"
                end
                if rime.pvp.has_aff("torso_damaged", targ) or rime.pvp.has_aff("torso_mangled", targ) then
                    return true
                elseif rime.pvp.has_aff("right_leg_mangled", targ) and rime.pvp.has_aff("left_leg_damaged", targ) then
                    return true
                elseif rime.pvp.has_aff("left_leg_mangled", targ) and rime.pvp.has_aff("right_leg_damaged", targ) then
                    return true
                end
            end 
            return false
        end
    },
    ["grouptranspierce"] = {
        "lurk target"..rime.saved.separator.."transpierce target",
        can = function()
            local targ = rime.target
            if (rime.pvp.has_aff("prone", targ) or rime.pvp.has_aff("frozen", targ) or rime.pvp.has_aff("indifference", targ) or rime.pvp.has_aff("paralysis", targ)
                or rime.pvp.has_aff("writhe_transfix", targ) or rime.pvp.has_aff("writhe_web", targ) or rime.pvp.target_tumbling or rev.chirography.stunatdum.can()) and not rime.pvp.has_aff("writhe_impaled", target) then
                return true
            else 
                return false
            end
        end
    },

    ["tumblestop"] = {
        "transpierce target",
        can = function()
            local targ = rime.target
            if rime.pvp.target_tumbling then
                return true
            else
                return false
            end
        end
    },
    ["extirpate"] = {
        "extirpate"..rime.saved.separator.."anguish target",
        can = function()
            local targ = rime.target
            if targetImpaled then
                return true
            else
                return false
            end
        end
    },

}

rev.chirography = {

    ["atdum"] = {
        "blade scribe left atdum venom",
        can = function()
            local targ = rime.target
            local charged = math.min(rime.vitals.right_charge, rime.vitals.left_charge)
            rev.atdumslash = "wilave"
            if rev.can1Swing() and charged >= 140 then
                local atdumChoice
                for k,v in ipairs(rime.pvp.route.venoms) do
                    if not rime.pvp.has_aff(rev.slashes[v][2], targ) and rev.slashes[v][1] ~= rev.ven1 and rev.slashes[v][1] ~= rev.ven2 and rev.slashes[v][1] ~= rev.discordVenom and rev.slashes[v].can() then
                        atdumChoice = rev.slashes[v][1]
                        break
                    end
                end
                rev.atdumslash = atdumChoice
                rev.chirography.atdum[1] = "blade scribe left atdum " ..rev.atdumslash
                return true
            else
                return false
            end
        end
    },

    ["iyedlo"] = {
        "blade scribe left iyedlo",
        can = function()
            local targ = rime.target 
            local charged = math.min(rime.vitals.right_charge, rime.vitals.left_charge)
            if charged >= 80 and not has_def("iyedlo") then
                return true
            end
            return false 
        end,
    },

    ["stunatdum"] = {
        "blade scribe left atdum adil",
        can = function()
            local targ = rime.target
            local charged = math.min(rime.vitals.right_charge, rime.vitals.left_charge)
            rev.atdumslash = "adil"
            if rev.can2Swing() and charged >= 140 and rime.pvp.count_affs("physical") >= 5  then
                return true
            end
            return false
        end
    },

    ["limbatdum"] = {
        "blade scribe left atdum adil",
        can = function()
            local targ = rime.target
            local charged = math.min(rime.vitals.right_charge, rime.vitals.left_charge)
            rev.atdumslash = "adil"
            if rev.can2Swing() and charged >= 140 and rime.pvp.has_aff("torso_damaged", targ) then
                return true
            else
                return false
            end
        end
    },
    ["wasiatdum"] = {
        "blade scribe left atdum wasi",
        can = function()
            local targ = rime.target
            local charged = math.min(rime.vitals.right_charge, rime.vitals.left_charge)
            rev.atdumslash = "wasi"
            if rev.can2Swing() and charged >= 140 and rime.pvp.has_def("rebounding", rime.target) and not rev.attacks.limbtranspierce.can() then
                return true
            else
                return false
            end
        end
    },

    ["aneda_left"] = {
        "blade scribe left aneda",
        can = function()
            local target = rime.target
            local charged = rime.vitals.left_charge
            if rev.can2Swing() and charged >= 90 and not rev.aneda_left_scribed and not rev.aneda_right_scribed and not rime.pvp.room.indoors and not rime.pvp.has_aff("epilepsy", target) then
                return true
            else
                return false
            end
        end,
    },

    ["aneda_right"] = {
        "blade scribe right aneda",
        can = function()
            local target = rime.target
            local charged = rime.vitals.right_charge
            if rev.can2Swing() and charged >= 90 and not rev.aneda_right_scribed and not rev.aneda_left_scribed and not rime.pvp.room.indoors and not rime.pvp.has_aff("epilepsy", target) then
                return true
            else
                return false
            end
        end,
    },

    ["aneda"] = {
        "blade scribe right aneda",
        can = function()
            if rime.pvp.room.indoors then return false end
            local target = rime.target
            local charged = math.max(rime.vitals.right_charge, rime.vitals.left_charge)
            if charged <= 90 then return false end
            local right_charged = rime.vitals.right_charge
            local left_charged = rime.vitals.left_charge
            if not rev.aneda_right_scribed and not rev.aneda_left_scribed and not rime.pvp.has_aff("epilepsy", target) then
                if right_charged > left_charged then
                    rev.chirography.aneda[1] = "blade scribe right aneda"
                else
                    rev.chirography.aneda[1] = "blade scribe left aneda"
                end
                return true
            end
            if (rev.aneda_right_scribed or rev.aneda_left_scribed) and not (rev.aneda_right_scribed and rev.aneda_left_scribed) and not rime.pvp.has_aff("epilepsy", target) then
                if right_charged > left_charged then
                    rev.chirography.aneda[1] = "blade scribe right aneda"
                else
                    rev.chirography.aneda[1] = "blade scribe left aneda"
                end
                return true
            end
            return false
        end,
    },

    ["2handlawid"] = {
        "blade scribe left lawid",
        can = function()
            local targ = rime.target
            if rime.pvp.has_aff("torso_damaged", targ) then return false end
            local charged = rime.vitals.left_charge
            if rev.can2Swing() and charged >= 100 then
                return true
            else
                return false
            end
        end
    },

    ["lawid_left"] = {
        "blade scribe left lawid",
        can = function()
            local targ = rime.target
            local charged = rime.vitals.left_charge
            if rev.can2Swing() and charged >= 40 then
                return true
            else
                return false
            end
        end
    },
    
    ["lawid_right"] = {
        "blade scribe right lawid",
        can = function()
            local targ = rime.target
            local charged = rime.vitals.right_charge
            if rev.can2Swing() and charged >= 40 then
                return true
            else
                return false
            end
        end
    },

    ["double_lawid"] = {
        "blade scribe left lawid".. rime.saved.separator .."blade scribe right lawid",
        can = function()
            local targ = rime.target
            local left_charged = rime.vitals.left_charge
            local right_charged = rime.vitals.right_charge
            if rev.can2Swing() and left_charged >= 40 and right_charged >= 40 then
                return true
            else
                return false
            end
        end
    },

    ["wilaveeespam"] = {
        "blade scribe left lawid".. rime.saved.separator .."blade scribe right lawid",
        can = function()
            local targ = rime.target
            local left_charged = rime.vitals.left_charge
            local right_charged = rime.vitals.right_charge
            if rev.can2Swing() and left_charged >= 40 and right_charged >= 40 and rev.wilaveee then
                return true
            else
                return false
            end
        end
    },

    ["limb_lawid"] = {
        "blade scribe left lawid".. rime.saved.separator .."blade scribe right lawid",
        can = function()
            local affs = rime.targets[rime.target].afflictions
            local bruises = {
                    "right_arm_bruised_critical",
                    "left_arm_bruised_critical",
                    "right_leg_bruised_critical",
                    "left_leg_bruised_critical",
                    "torso_bruised_critical",
                    "right_arm_bruised_moderate",
                    "left_arm_bruised_moderate",
                    "right_leg_bruised_moderate",
                    "left_leg_bruised_moderate",
                    "torso_bruised_moderate",
                }
            local targ = rime.target
            local left_charged = rime.vitals.left_charge
            local right_charged = rime.vitals.right_charge
            if rev.can2Swing() and left_charged >= 40 then
            for k,v in ipairs(bruises) do
                if rime.pvp.has_aff(v, rime.target) then
                    if string.find(v, "critical") then
                        return true
                    else
                        return false
                    end
                end
            end
            end
        end
    },

    ["double_telvi"] = {
        "blade scribe left telvi".. rime.saved.separator .."blade scribe right telvi",
        can = function()
            local targ = rime.target
            local left_charged = rime.vitals.left_charge
            local right_charged = rime.vitals.right_charge
            if rime.pvp.route.weapon:find("1hand") then 
                if rev.can2Swing() and left_charged >= 100 and right_charged >= 100 and not rime.pvp.has_aff("shivering", targ) then
                    return true
                end
            else
                if rev.can2Swing() and (left_charged >= 100 or right_charged >= 100) and not rime.pvp.has_aff("frozen", targ) then
                    return true
                end
            end
            return false
        end
    },

    ["telvi"] = {
        "blade scribe left telvi",
        can = function()
            local targ = rime.target
            local charged = math.max(rime.vitals.left_charge,rime.vitals.right_charge)
            if rev.can2Swing() and charged >= 100 then
                local right_charged = rime.vitals.right_charge
                local left_charged = rime.vitals.left_charge
                if not rime.pvp.has_aff("frozen", targ) then
                    if right_charged > left_charged then
                        rev.chirography.telvi[1] = "blade scribe right telvi"
                    else
                        rev.chirography.telvi[1] = "blade scribe left telvi"
                    end
                    return true
                else
                    return false
                end
            end
            return false
        end
    },
}

rev.atdumslash = "wilave"
rev.discordVenom = "none"
rev.aneda_left_scribed = false
rev.aneda_right_scribed = false
rev.canlurk = true
rev.bongoBonanza = false
rev.wilaveee = false
rev.phantasm = "none"
rev.chimerized = {}

function rev.can2Swing()

    local target = rime.target

    if rime.has_aff("left_arm_broken") or rime.has_aff("right_arm_broken") or rime.has_aff("paralysis") then
        return false
    end
    for k,v in pairs(rime.curing.affsByType.writhe) do
        if rime.has_aff(v) then return false end
    end

    return true

end

function rev.can1Swing()

    local target = rime.target

    if (rime.has_aff("left_arm_broken") and rime.has_aff("right_arm_broken")) or rime.has_aff("paralysis") then
        return false
    end
    for k,v in pairs(rime.curing.affsByType.writhe) do
        if rime.has_aff(v) then return false end
    end

    return true

end

function rev.chiro()

    for k,v in ipairs(rime.pvp.route.chirography) do
        if rev.chirography[v].can() then
            return rev.chirography[v][1]:gsub("target", rime.target):gsub("ally", rime.pvp.ally)
        end
    end

    return false

end

function rev.eq_use()

    local targ = rime.target

    for k,v in ipairs(rime.pvp.route.eq_use) do
        if not rime.pvp.has_aff(v, targ) and rev.eq_attacks[v].can() then
            return rev.eq_attacks[v][1]:gsub("target", targ):gsub("ally", rime.pvp.ally)
        end
    end

    return false

end

function rev.atk()

    local targ = rime.target

    for k,v in ipairs(rime.pvp.route.attack) do
        if not rime.pvp.has_aff(v, targ) and rev.attacks[v].can() then
            return rev.attacks[v][1]:gsub("target", targ):gsub("ally", rime.pvp.ally)
        end
    end

    return false

end

function rev.venoms()

    rev.ven1 = false
    rev.ven2 = false
    local targ = rime.target
--    local doubleups = {"epseth", "epteth", "azu", "dirne", "prefarar", "oculus"}
--there is a way to deliver double doses I swear it >:T
    for k,v in ipairs(rime.pvp.route.venoms) do
        if rev.ven1 ~= false then
            if not rime.pvp.has_aff(rev.slashes[v][2], targ) and rev.slashes[v].can() then
                if rev.slashes[v][1] ~= rev.ven1 and rev.slashes[v][1] ~= rev.atdumslash and rev.slashes[v][1] ~= rev.discordVenom then
                    rev.ven2 = rev.slashes[v][1]
                    break
                end
            end
        elseif not rime.pvp.has_aff(rev.slashes[v][2], targ) and rev.slashes[v].can() then
            if rev.eq_use() and rime.targets[targ].defences.rebounding then
                rev.ven1 = "wasi"
            elseif rev.slashes[v][1] ~= rev.atdumslash and rev.slashes[v][1] ~= rev.discordVenom then
                rev.ven1 = rev.slashes[v][1]
            end
        end
    end

    local bluntweapons = {"club", "flail", "mace", "morningstar", "greatmaul", "warhammer", "cudgel",}
    for k,v in pairs(bluntweapons) do
        if gmcp.Char.Vitals.wield_left:find(v) then
            if not rev.ven1 then rev.ven1 = "lura" end
            if not rev.ven2 then rev.ven2 = "lura" end
--            if rime.pvp.has_def("rebounding", targ) then rev.ven2 = "wasi" end
        end
    end

    if not rev.ven1 then rev.ven1 = "wilave" end
    if not rev.ven2 then rev.ven2 = "wilave" end

end

function rev.lock_swing()
    local missing = rime.missingAff("asthma/slickness/anorexia", "/")
    --check for two affs + 1 = venomlock
    if #missing == 1 and (rev.slashes[missing[1]][2] == rev.ven1 or rev.slashes[missing[1]][1] == rev.ven2) then
        return true
    elseif #missing == 2 and (rev.slashes[missing[1]][1] == rev.ven1 or rev.slashes[missing[1]][1] == rev.ven2) and (rev.slashes[missing[2]][1] == rev.ven1 or rev.slashes[missing[2]][1] == rev.ven2) then
        return true
    else
        return false
    end
end

function rev.target_locked()
    local targ = rime.target
    if rime.pvp.has_aff("asthma", targ) and rime.pvp.has_aff("slickness", targ) and (rime.pvp.has_aff("anorexia", targ) or (rime.pvp.has_aff("left_arm_broken", targ) and rime.pvp.has_aff("right_arm_broken", targ))) then
        return true
    else
        return false
    end
end

function rev.weapon_check()
    local left,right = "",""
    if rime.pvp.route.weapon == "1handblunts" then 
        left = rime.saved.revblunt1
        right = rime.saved.revblunt2
        if right ~= string.match(gmcp.Char.Vitals.wield_right, "%d+") or left ~= string.match(gmcp.Char.Vitals.wield_right, "%d+") then
            if left == string.match(gmcp.Char.Vitals.wield_left, "%d+") then
                left = false
            end
            if right == string.match(gmcp.Char.Vitals.wield_right, "%d+") then
                right = false
            end
        end
        if left ~= false and right ~= false then
            return "quickwield both "..left.." "..right
        elseif left == false and right ~= false then
            return "quickwield right "..right
        elseif left ~= false and right == false then
            return "quickwield left "..left
        end
    elseif rime.pvp.route.weapon == "2handblunt" then 
        left = rime.saved.rev2handblunt
        if left ~= string.match(gmcp.Char.Vitals.wield_left, "%d+") then
            return "quickwield both "..left.." "..right
        end
    elseif rime.pvp.route.weapon == "2handblade" then 
        left = rime.saved.rev2handblade
        if left ~= string.match(gmcp.Char.Vitals.wield_left, "%d+") then
            return "quickwield both "..left.." "..right
        end
    else
        left = rime.saved.revblade1
        right = rime.saved.revblade2
            if right ~= string.match(gmcp.Char.Vitals.wield_right, "%d+") or left ~= string.match(gmcp.Char.Vitals.wield_right, "%d+") then
            if left == string.match(gmcp.Char.Vitals.wield_left, "%d+") then
                left = false
            end
            if right == string.match(gmcp.Char.Vitals.wield_right, "%d+") then
                right = false
            end
        end
        if left ~= false and right ~= false then
            return "quickwield both "..left.." "..right
        elseif left == false and right ~= false then
            return "quickwield right "..right
        elseif left ~= false and right == false then
            return "quickwield left "..left
        end
    end
    return false
end

function rev.offense()
    --Meat and potatoes attack picking and command sending done here
    local target = rime.target
    local sep = rime.saved.separator
    local manifest_attack = rev.eq_use()
    rev.venoms() --this sets rev.ven1 and rev.ven2
    local riving_attack = rev.atk() or ""
    local venom_call = ""
    local command = ""

    if rev.chiro() then command =  rev.chiro() end

    if rev.weapon_check() then command = command..sep..rev.weapon_check() end

    if not riving_attack:find("transpierce") and not riving_attack:find("cull") and not riving_attack:find("juxtapose") then
        if manifest_attack then command = command .. sep .. manifest_attack end
    end

    if riving_attack:find("dpl") or riving_attack:find("fell") then
        if riving_attack:find("epseth epseth") then
            command = command.. sep .. riving_attack
            venom_call = "epseth/epseth"
        else
            command =  command .. sep .. riving_attack .. " " .. rev.ven2 .. " " .. rev.ven1
            venom_call = rev.ven2.."/"..rev.ven1
        end
        
    elseif riving_attack:find("deceive") or riving_attack:find("gouge") then

        if riving_attack:find("gouge") then
            riving_attack = "wipe left"..sep..riving_attack
            if rev.ven1 ~= false then
                command  =  command .. sep .. "target nothing"..sep..riving_attack .. " " .. rev.ven1
                venom_call = rev.ven1
            else
                command  =  command .. sep .. "target nothing"..sep..riving_attack
            end
        else
            command  =  command .. sep .. "target nothing"..sep..riving_attack .. " " .. rev.ven1
            venom_call = rev.ven1
        end

    else
        command =  command.. sep .. riving_attack
    end

    if not has_def("circling") then
        command = command .. sep .. "circle "..rime.target
    end

    if rime.pvp.targetThere and rime.pvp.web_aff_calling and (riving_attack:find("dpl") or riving_attack:find("deceive") or riving_attack:find("gouge")) then

        local web_call = rime.pvp.omniCall(venom_call)
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

end
