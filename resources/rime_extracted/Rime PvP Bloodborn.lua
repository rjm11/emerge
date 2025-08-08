--Authors: Rijetta, Almol
rime.bloodborn = rime.bloodborn or {}
rime.bloodborn.prowess = rime.bloodborn.prowess or false
rime.bloodborn.aspect = rime.vitals.aspect
rime.bloodborn.imbrue = rime.bloodborn.imbrue or false
rime.bloodborn.suffocate = rime.bloodborn.suffocate or false
rime.bloodborn.profane = rime.bloodborn.profane or false
rime.bloodborn.triplicate = rime.bloodborn.triplicate or true
rime.bloodborn.contaminate = rime.bloodborn.contaminate or true
rime.bloodborn.triplicate_toggle = rime.bloodborn.triplicate_toggle or false
rime.bloodborn.geminate_charge = rime.bloodborn.geminate_charge or 3

rime.pvp.Bloodborn.routes = {


	["group"] = {
		["blurb"] = {"Basic group route placeholder"},
		["humours"] = {
			"proscribe",
			"shielded",
			"stupor",
			"sensitivity",
			"befoul_clumsiness",
			"synapse_paresis",
			"befoul_dizziness",
			"flense_paresis",
			"both_legs",
			"both_arms",
			"brainfreeze_recklessness",
			"asthma",
			"slickness",
			"revulsion_anorexia",
			"damage",
		},
		["hematurgy"] = {
			"palpitate",
			"suffocate",
		},
		["arrhythmia"] = {
			"tumult",
			"torso_damaged",
			"left_leg_damaged",
			"right_leg_damaged",
			"head_damaged",
		},
	},

	["blue"] = {
		["blurb"] = {"Group limb route placeholder"},
		["humours"] = {
			"shielded",
			"obliterate",
			"perforate",
			"plunge_frozen",
			"both_legs",
			"left_leg_damaged",
			"right_leg_damaged",
			"torso_damaged",
			"ablaze",
			"head_damaged",
			"both_arms",
			"left_arm_damaged",
			"right_arm_damaged",
			"damage",
		},
		["hematurgy"] = {
			"palpitate",
			"imbrue",
		},
		["arrhythmia"] = {
			"tumult",
			"torso_damaged",
			"left_leg_damaged",
			"right_leg_damaged",
			"head_damaged",
		},
	},

	["black"] = {
		["blurb"] = {"Basic duel route placeholder"},
		["humours"] = {
			"shielded",
			"damage",
		},
		["hematurgy"] = {
			"palpitate",
			"imbrue",
		},
		["arrhythmia"] = {
			"dissemble",
			"torso_damaged",
			"left_leg_damaged",
			"right_leg_damaged",
			"head_damaged",
		},
	},
}

rime.bloodborn.humours = {


	["damage"] = {
		attack = "disgorge target torso",
		choice = function()
			return rime.bloodborn.humours.damage.attack
		end,
		can = function()
			return true
		end,
		combo = true,
		delay = 3,
	},

	["dissemble"] = {
		attack = "dissemble",
		choice = function()
			return rime.bloodborn.humours.dissemble.attack
		end,
		can = function()
			if rime.pvp.room.phenomena ~= "none" then return false end
			return true
		end,
		combo = true,
		delay = 3,
	},

	["proscribe"] = {
        "unleash proscribe here",
        choice = function()
            return rime.bloodborn.humours.proscribe.attack
        end,
        can = function()
            if rime.pvp.room.mirage then
                return true
            else
                return false
            end
        end,
        combo = false,
		delay = false,
    },

	["tumult"] = {
		attack = "tumult",
		choice = function()
			return rime.bloodborn.humours.tumult.attack
		end,
		can = function()
			if rime.pvp.room.phenomena ~= "none" then return false end
			return true
		end,
		combo = true,
		delay = 3,
	},

	["overflow"] = {
		attack = "overflow",
		choice = function()
			return rime.bloodborn.humours.overflow.attack
		end,
		can = function()
			local water_room = false
			local room_details = gmcp.Room.Info.details
			water_room = table.contains(room_details, "water")
			if rime.pvp.room.flooded then return false end
			if water_room then return false end
			return true
		end,
		combo = true,
		delay = 3,
	},

	["befoul_clumsiness"] = {
		attack = "befoul target",
		choice = function()
			return rime.bloodborn.humours.befoul_clumsiness.attack
		end,
		can = function()
			if rime.vitals.aspect ~= "black" then return false end
			if rime.pvp.has_aff("clumsiness", rime.target) then return false end
			return true
		end,
		combo = true,
		delay = 3,
	},

	["befoul_dizziness"] = {
		attack = "befoul target",
		choice = function()
			return rime.bloodborn.humours.befoul_dizziness.attack
		end,
		can = function()
			if rime.vitals.aspect ~= "black" then return false end
			if rime.pvp.has_aff("dizziness", rime.target) then return false end
			if not rime.pvp.has_aff("clumsiness", rime.target) then return false end
			return true
		end,
		combo = true,
		delay = 3,
	},

	["befoul_dissonance"] = {
		attack = "befoul target",
		choice = function()
			return rime.bloodborn.humours.befoul_dissonance.attack
		end,
		can = function()
			if rime.vitals.aspect ~= "black" then return false end
			if rime.pvp.has_aff("dissonance", rime.target) then return false end
			return true
		end,
		combo = true,
		delay = 3,
	},

	["befoul_prone"] = {
		attack = "befoul target",
		choice = function()
			return rime.bloodborn.humours.befoul_prone.attack
		end,
		can = function()
			return true
		end,
		combo = true,
		delay = 3,
	},

	["frostbite"] = {
		attack = "frostbite target",
		choice = function()
			return rime.bloodborn.humours.frostbite.attack
		end,
		can = function()
			if rime.pvp.has_aff("frostbite", rime.target) then return false end
			if rime.pvp.has_def("insulation", rime.target) then return false end
			return true
		end,
		combo = true,
		delay = 5,
	},

	["obliterate"] = {
		attack = "obliteration",
		choice = function()
			return rime.bloodborn.humours.obliterate.attack
		end,
		can = function()
			if not rime.pvp.has_aff("frozen", rime.target) then return false end
			if not (#rime.missingAff("left_leg_damaged/right_leg_damaged/left_arm_damaged/right_arm_damaged","/") <= 2) then return false end
			if not rime.pvp.has_aff("writhe_impaled", rime.target) then return false end
			if rime.targets[rime.target].perforated ~= "You" then return false end
			return true
		end,
		aff = "obliterate",
		combo = true,
		delay = 3,
	},

	["perforate"] = {
		attack = "perforate target",
		choice = function()
			return rime.bloodborn.humours.perforate.attack
		end,
		can = function()
			if not rime.pvp.has_aff("frozen", rime.target) then return false end
			if not (#rime.missingAff("left_leg_damaged/right_leg_damaged/left_arm_damaged/right_arm_damaged","/") <= 2) then return false end
			return true
		end,
		aff = "perforate",
		combo = true,
		delay = 3,
	},

	["revulsion_anorexia"] = {
		attack = "revulsion target decongestant",
		choice = function()
			return rime.bloodborn.humours.revulsion_anorexia.attack
		end,
		can = function()
			if rime.pvp.has_aff("anorexia", rime.target) then return false end
			if rime.vitals.aspect ~= "yellow" then return false end
		end,
		combo = true,
		delay = 3,
	},

	["brainfreeze_recklessness"] = {
		attack = "brainfreeze target",
		choice = function()
			return rime.bloodborn.humours.brainfreeze_recklessness.attack
		end,
		can = function()
			if rime.pvp.has_aff("recklessness", rime.target) then return false end
			if rime.vitals.aspect ~= "yellow" then return false end
		end,
		combo = true,
		delay = 3,
	},

	["brainfreeze_masochism"] = {
		attack = "brainfreeze target",
		choice = function()
			return rime.bloodborn.humours.brainfreeze_masochism.attack
		end,
		can = function()
			if rime.pvp.has_aff("masochism", rime.target) then return false end
			if rime.vitals.aspect ~= "black" then return false end
			return true
		end,
		combo = true,
		delay = 5,
	},

	["equilibrium_vertigo"] = {
		attack = "equilibrium target",
		choice = function()
			return rime.bloodborn.humours.equilibrium_vertigo.attack
		end,
		can = function()
			if rime.pvp.has_aff("vertigo", rime.target) then return false end
			return true
		end,
		combo = true,
		delay = 5,
	},

	["equilibrium_confusion"] = {
		attack = "equilibrium target",
		choice = function()
			return rime.bloodborn.humours.equilibrium_confusion.attack
		end,
		can = function()
			if not rime.pvp.has_aff("vertigo", rime.target) then return false end
			return true
		end,
		combo = true,
		delay = 5,
	},

	["equilibrium_weariness"] = {
		attack = "equilibrium target",
		choice = function()
			return rime.bloodborn.humours.equilibrium_weariness.attack
		end,
		can = function()
			if rime.pvp.has_aff("weariness", rime.target) then return false end
			if rime.vitals.aspect ~= "phlegm" then return false end
			return true
		end,
		combo = true,
		delay = 5,
	},

	["equilibrium_clumsiness"] = {
		attack = "equilibrium target",
		choice = function()
			return rime.bloodborn.humours.equilibrium_clumsiness.attack
		end,
		can = function()
			if rime.pvp.has_aff("clumsiness", rime.target) then return false end
			if rime.vitals.aspect ~= "yellow" then return false end
			return true
		end,
		combo = true,
		delay = 5,
	},

	["plunge_frozen"] = {
		attack = "plunge target",
		choice = function()
			return rime.bloodborn.humours.plunge_frozen.attack
		end,
		can = function()
			if rime.pvp.has_aff("frozen", rime.target) then return false end
			if rime.vitals.aspect == "phlegm" then
				if not rime.pvp.has_def("insulation", rime.target) then
					return true
				end
			else
				if rime.pvp.has_aff("shivering", rime.target) then
					return true
				end
			end
			return false
		end,
		combo = true,
		delay = 3,
	},

	["swathe_frozen"] = {
		attack = "swathe target",
		choice = function()
			return rime.bloodborn.humours.swathe_frozen.attack
		end,
		can = function()
			if rime.pvp.has_aff("frozen", rime.target) then return false end
			if rime.vitals.aspect ~= "black" then return false end
			if not rime.pvp.has_aff("shivering", rime.target) then return false end
			return true
		end,
		combo = true,
		delay = 3,
	},

	["smother"] = {
		attack = "smother target",
		choice = function()
			return rime.bloodborn.humours.smother.attack
		end,
		can = function()
			local found_one = false
			local target = rime.target
			for k,v in ipairs(rime.targets[target].limbs) do
			  if v > 1000 then
			    found_one = true
			    break
			  end
			end
			if rime.pvp.has_aff("excess_choleric", rime.target) then return false end
			if not rime.pvp.has_aff("ablaze", rime.target) then return false end
			if not found_one then return false end
			return true
		end,
		combo = true,
		delay = 3,
	},

	["both_arms"] = {
		attack = "broil target arms",
		choice = function()
			return rime.bloodborn.humours.both_arms.attack
		end,
		can = function()
			if rime.pvp.has_aff("left_arm_broken", rime.target) and rime.pvp.has_aff("right_arm_broken", rime.target) then return false end
			if not rime.pvp.has_aff("ablaze", rime.target) or rime.pvp.has_aff("excess_choleric", rime.target) then return false end
			return true
		end,
		combo = true,
		delay = 3,
	},

	["both_legs"] = {
		attack = "broil target legs",
		choice = function()
			return rime.bloodborn.humours.both_legs.attack
		end,
		can = function()
			if rime.pvp.has_aff("left_leg_broken", rime.target) and rime.pvp.has_aff("right_leg_broken", rime.target) then return false end
			if not rime.pvp.has_aff("ablaze", rime.target) or rime.pvp.has_aff("excess_choleric", rime.target) then return false end
			return true
		end,
		combo = true,
		delay = 3,
	},

	["left_leg_damaged"] = {
		attack = "disgorge target left leg",
		choice = function()
			return rime.bloodborn.humours.left_leg_damaged.attack
		end,
		can = function()
			if rime.limit[rime.target.."_left_leg_restore"] then return false end
			if rime.pvp.canParry() and rime.pvp.is_parrying("left_leg", rime.target) then return false end
			if rime.pvp.has_aff("left_leg_damaged", rime.target) then return false end
			return true
		end,
		combo = true,
		delay = 3,
	},

	["right_leg_damaged"] = {
		attack = "disgorge target right leg",
		choice = function()
			return rime.bloodborn.humours.right_leg_damaged.attack
		end,
		can = function()
			if rime.limit[rime.target.."_right_leg_restore"] then return false end
			if rime.pvp.canParry() and rime.pvp.is_parrying("right_leg", rime.target) then return false end
			if rime.pvp.has_aff("right_leg_damaged", rime.target) then return false end
			return true
		end,
		combo = true,
		delay = 3,
	},

	["right_arm_damaged"] = {
		attack = "disgorge target right arm",
		choice = function()
			return rime.bloodborn.humours.right_arm_damaged.attack
		end,
		can = function()
			if rime.limit[rime.target.."_right_arm_restore"] then return false end
			if rime.pvp.canParry() and rime.pvp.is_parrying("right_arm", rime.target) then return false end
			if rime.pvp.has_aff("right_arm_damaged", rime.target) then return false end
			return true
		end,
		combo = true,
		delay = 3,
	},

	["left_arm_damaged"] = {
		attack = "disgorge target left arm",
		choice = function()
			return rime.bloodborn.humours.left_arm_damaged.attack
		end,
		can = function()
			if rime.limit[rime.target.."_left_arm_restore"] then return false end
			if rime.pvp.canParry() and rime.pvp.is_parrying("left_arm", rime.target) then return false end
			if rime.pvp.has_aff("left_arm_damaged", rime.target) then return false end
			return true
		end,
		combo = true,
		delay = 3,
	},

	["torso_damaged"] = {
		attack = "disgorge target torso",
		choice = function()
			return rime.bloodborn.humours.torso_damaged.attack
		end,
		can = function()
			if rime.limit[rime.target.."_torso_restore"] then return false end
			if rime.pvp.canParry() and rime.pvp.is_parrying("torso", rime.target) then return false end
			if rime.pvp.has_aff("torso_damaged", rime.target) then return false end
			return true
		end,
		combo = true,
		delay = 3,
	},

	["head_damaged"] = {
		attack = "disgorge target head",
		choice = function()
			return rime.bloodborn.humours.head_damaged.attack
		end,
		can = function()
			if rime.limit[rime.target.."_head_restore"] then return false end
			if rime.pvp.canParry() and rime.pvp.is_parrying("head", rime.target) then return false end
			if rime.pvp.has_aff("head_damaged", rime.target) then return false end
			return true
		end,
		combo = true,
		delay = 3,
	},

	["shielded"] = {
		attack = "befoul target",
		choice = function()
			return rime.bloodborn.humours.shielded.attack
		end,
		can = function()
			if rime.pvp.has_def("shielded", rime.target) then
				return true
			else
				return false
			end
		end,
		combo = true,
		delay = 3,
	},

	["sensitivity"] = {
		attack = "plunge target",
		choice = function()
			return rime.bloodborn.humours.sensitivity.attack
		end,
		can = function()
			if rime.vitals.aspect ~= "yellow" then return false end
			if rime.pvp.has_aff("sensitivity", rime.target) then return false end
			return true
		end,
		combo = true,
		delay = 3,
	},

	["flense_paresis"] = {
		attack = "flense target curare",
		choice = function()
			return rime.bloodborn.humours.flense_paresis.attack
		end,
		can = function()
			if rime.pvp.has_aff("paresis", rime.target) then return false end
			if rime.pvp.has_aff("paralysis", rime.target) then return false end
			if rime.vitals.aspect ~= "phlegm" then return false end
			return true
		end,
		combo = true,
		delay = 3,
	},

	["flense_anorexia"] = {
		attack = "flense target slike",
		choice = function()
			return rime.bloodborn.humours.flense_anorexia.attack
		end,
		can = function()
			local target = rime.target
			local poulticeBalance = rime.getTimeLeft("poultice", target)
			local focusBalance = rime.getTimeLeft("focus", target)
			if poulticeBalance > 2 then return false end
			if focusBalance > 2 then return false end
			if rime.pvp.has_aff("anorexia", target) then return false end
			return true
		end,
		combo = true,
		delay = 5,
	},

	["flense_epseth"] = {
		attack = "flense target epseth",
		choice = function()
			return rime.bloodborn.humours.flense_epseth.attack
		end,
		can = function()
			local poulticeBalance = rime.targets[rime.target].time.poulticeBalance
			if poulticeBalance > 2 then return false end
			if rime.pvp.has_aff("left_leg_broken", rime.target) and rime.pvp.has_aff("right_leg_broken", rime.target) then return false end
			if not rime.pvp.has_aff("left_leg_damaged", rime.target) and not rime.pvp.has_aff("right_leg_damaged", rime.target) then return false end
			return true
		end,
		combo = true,
		delay = 5,
	},

	["flense_epteth"] = {
		attack = "flense target epteth",
		choice = function()
			return rime.bloodborn.humours.flense_epteth.attack
		end,
		can = function()
			local poulticeBalance = rime.targets[rime.target].time.poulticeBalance
			if poulticeBalance > 2 then return false end
			if rime.pvp.has_aff("left_arm_broken", rime.target) and rime.pvp.has_aff("right_arm_broken", rime.target) then return false end
			if not rime.pvp.has_aff("left_arm_damaged", rime.target) and not rime.pvp.has_aff("right_arm_damaged", rime.target) then return false end
			return true
		end,
		combo = true,
		delay = 5,
	},

	["synapse_paresis"] = {
		attack = "synapse target",
		choice = function()
			return rime.bloodborn.humours.synapse_paresis.attack
		end,
		can = function()
			if rime.vitals.aspect == "yellow" then
				if rime.pvp.has_aff("vertigo", rime.target) then return false end
				return true
			elseif rime.vitals.aspect == "phlegm" then
				if rime.pvp.has_aff("epilepsy", rime.target) then return false end
				return true
			end
			return false
		end,
		combo = true,
		delay = 3,
	},

	["synapse_vertigo"] = {
		attack = "synapse target",
		choice = function()
			return rime.bloodborn.humours.synapse_vertigo.attack
		end,
		can = function()
			if rime.pvp.has_aff("vertigo", rime.target) then return false end
			if rime.vitals.aspect ~= "yellow" then return false end
			return true
		end,
		combo = true,
		delay = 3,
	},

    ["traumatise"] = {
        attack = "traumatise target",
        choice = function()
            return rime.bloodborn.humours.traumatise.attack
        end,
        can = function()
            if rime.targets[rime.target].mana > 50 then return false end
            if not rime.pvp.has_aff("muddled", rime.target) then return false end
            return true
        end,
        aff = "unconscious",
        call = "nothing",
        delay = 3
    },

    ["permeate"] = {
        attack = "permeate target",
        choice = function()
            return rime.bloodborn.humours.permeate.attack
        end,
        can = function()
            if rime.targets[rime.target].mana > 50 then return false end
            if not rime.pvp.has_aff("prone", rime.target) then return false end
            if rime.pvp.has_aff("excess_phlegm") and rime.vitals.aspect == "phlegm" then return true end
            if rime.pvp.has_aff("excess_choleric") and rime.vitals.aspect == "yellow" then return true end
            if rime.pvp.has_aff("excess_melancholic") and rime.vitals.aspect == "black" then return true end
            return false
        end,
        aff = "dead",
        call = "nothing",
        delay = 3,
    },

	["traumatise"] = {
		attack = "traumatise target",
		choice = function()
			return rime.bloodborn.humours.traumatise.attack
		end,
		can = function()
			if not rime.pvp.has_aff("muddled", rime.target) then return false end
			return true
		end,
		combo = false,
		delay = false,
	},

	["ablaze"] = {
		attack = "boil target",
		choice = function()
			return rime.bloodborn.humours.ablaze.attack
		end,
		can = function()
			if rime.pvp.has_aff("ablaze", rime.target) then return false end
			return true
		end,
		combo = true,
		delay = 3,
	},

	["blisters"] = {
		attack = "boil target",
		choice = function()
			return rime.bloodborn.humours.blisters.attack
		end,
		can = function()
			if rime.pvp.has_aff("blisters", rime.target) then return false end
			if rime.vitals.aspect ~= "phlegm" then return false end
			return true
		end,
		combo = true,
		delay = 3,
	},

	["slickness"] = {
		attack = "broil target legs",
		choice = function()
			return rime.bloodborn.humours.slickness.attack
		end,
		can = function()
			if rime.pvp.has_aff("slickness", rime.target) then return false end
			if rime.vitals.aspect ~= "phlegm" then return false end
			return true
		end,
		combo = true,
		delay = 3,
	},

	["asthma"] = {
		attack = "broil target legs",
		choice = function()
			return rime.bloodborn.humours.asthma.attack
		end,
		can = function()
			if rime.pvp.has_aff("asthma", rime.target) then return false end
			if rime.vitals.aspect ~= "black" then return false end
			return true
		end,
		combo = true,
		delay = 3,
	},

	["swathe_dizziness"] = {
		attack = "swathe target",
		choice = function()
			return rime.bloodborn.humours.swathe_dizziness.attack
		end,
		can = function()
			if rime.pvp.has_aff("dizziness", rime.target) then return false end
			if rime.vitals.aspect == "black" then return false end
			return true
		end,
		combo = true,
		delay = 3,
	},

	["brainfreeze_stupidity"] = {
		attack = "brainfreeze target",
		choice = function()
			return rime.bloodborn.humours.brainfreeze_stupidity.attack
		end,
		can = function()
			if rime.pvp.has_aff("stupidity", rime.target) then return false end
			return true
		end,
		combo = true,
		delay = 3,
	},

	["swathe_lethargy"] = {
		attack = "swathe target",
		choice = function()
			return rime.bloodborn.humours.swathe_lethargy.attack
		end,
		can = function()
			if rime.pvp.has_aff("lethargy", rime.target) then return false end
			if rime.vitals.aspect ~= "black" then return false end
			return true
		end,
		combo = true,
		delay = 5,
	},

	["swathe_confusion"] = {
		attack = "swathe target",
		choice = function()
			return rime.bloodborn.humours.swathe_confusion.attack
		end,
		can = function()
			if rime.pvp.has_aff("confusion", rime.target) then return false end
			if rime.vitals.aspect ~= "black" then return false end
			if not rime.pvp.has_aff("prone", rime.target) then return false end
			return true
		end,
		combo = true,
		delay = 5,
	},



	["stupor"] = {
		attack = "stupor target",
		choice = function()
			return rime.bloodborn.humours.stupor.attack
		end,
		can = function()
			if rime.pvp.has_aff("stupidity", rime.target) then return false end
			if rime.pvp.has_aff("dizziness", rime.target) then return false end
			return true
		end,
		combo = true,
		delay = 3,
	},


}

rime.bloodborn.hematurgy = {

	["suffocate"] = {
		attack = "suffocate",
		choice = function()
			return rime.bloodborn.hematurgy.suffocate.attack
		end,
		can = function()
			if rime.bloodborn.imbrue then return false end
			if rime.bloodborn.profane then return false end
			if rime.bloodborn.suffocate then return false end
			if not rime.balances.ability then return false end
			return true
		end,
		aff = "suffocate",
	},

	["imbrue"] = {
		attack = "imbrue",
		choice = function()
			return rime.bloodborn.hematurgy.imbrue.attack
		end,
		can = function()
			if rime.bloodborn.imbrue then return false end
			if rime.bloodborn.profane then return false end
			if rime.bloodborn.suffocate then return false end
			if not rime.balances.ability then return false end
			return true
		end,
		aff = "imbrue",
	},

	["profane"] = {
		attack = "profane",
		choice = function()
			return rime.bloodborn.hematurgy.profane.attack
		end,
		can = function()
			if rime.bloodborn.imbrue then return false end
			if rime.bloodborn.profane then return false end
			if rime.bloodborn.suffocate then return false end
			if not rime.balances.ability then return false end
			return true
		end,
		aff = "profane",
	},

	["palpitate"] = {
		attack = "palpitate target",
		choice = function()
			return rime.bloodborn.hematurgy.palpitate.attack
		end,
		can = function()
			if not rime.balances.ability then return false end
			if rime.bloodborn.suffocate then return true end
			if rime.bloodborn.imbrue then return true end
			if rime.bloodborn.profane then return true end
			return false
		end,
		aff = "palpitate",
	},


}

function rime.bloodborn.hematurgy_attack()

    for k,v in ipairs(rime.pvp.route.hematurgy) do
        if rime.bloodborn.hematurgy[v] and rime.bloodborn.hematurgy[v].can() then
            return "well "..rime.bloodborn.hematurgy[v].choice():gsub("target", rime.target):gsub("hit", "target")
        end
    end

end

function rime.bloodborn.arrhythmia()
	local num = 3
	local targ = rime.target
	local string = ''
	for k,v in ipairs(rime.pvp.route.arrhythmia) do
		if not rime.pvp.has_aff(v, targ) and rime.bloodborn.humours[v].can() then
			if rime.bloodborn.humours[v].choice ~= nil then
				string = rime.bloodborn.humours[v].choice()
				num = rime.bloodborn.humours[v].delay
				string = "well arrhythmia " .. num .. " " .. string
				string = string:gsub("target", rime.target)
				return string
			else
				string = rime.bloodborn.humours[v][1]
				num = rime.bloodborn.humours[v].delay
				string = "well arrhythmia " .. num .. " " .. string
				string = string:gsub("target", rime.target)
				return string
			end
		end
	end
end

function rime.bloodborn.init()

	local targ = rime.target
	local sep = rime.saved.separator

	for k,v in ipairs(rime.pvp.route.humours) do
		if not rime.pvp.has_aff(v, targ) and rime.bloodborn.humours[v].can() then
			if rime.bloodborn.humours[v].choice ~= nil then
				return rime.bloodborn.humours[v].choice():gsub("target", rime.target):gsub("hit", "target")
			else
				return rime.bloodborn.humours[v][1]:gsub("target", rime.target):gsub("hit", "target")
			end
		end
	end
end

function rime.bloodborn.offense()
	local command = ""
	local humour = rime.bloodborn.init()
	local sep = rime.saved.separator
	local arrhythmia = rime.bloodborn.arrhythmia()
	local hematurgy = rime.bloodborn.hematurgy_attack()
	local trip_routes = {"group", "blue"}

	if hematurgy and hematurgy:find("palpitate") then
		act('qs ' .. rime.bloodborn.hematurgy_attack())
		rime.secondary_queue_attempted = rime.bloodborn.hematurgy_attack()
	end
	if not has_def("arrhythmia") and arrhythmia and (rime.bloodborn.imbrue or rime.bloodborn.profane or rime.bloodborn.suffocate) and not table.contains(trip_routes, rime.pvp.route_choice) then
		if hematurgy and not hematurgy:find("palpitate") then
			command = rime.pvp.queue_handle() .. sep .. "contemplate " .. rime.target .. sep .. "order cholerisk kill " .. rime.target .. sep .. hematurgy .. sep .. arrhythmia
		else
			command = rime.pvp.queue_handle() .. sep .. "contemplate " .. rime.target .. sep .. "order cholerisk kill " .. rime.target .. sep .. arrhythmia
		end
	else
		if hematurgy and not hematurgy:find("palpitate") then
			if rime.bloodborn.triplicate and rime.bloodborn.triplicate_toggle and table.contains(trip_routes, rime.pvp.route_choice) then
				command = rime.pvp.queue_handle() .. sep .. "contemplate " .. rime.target .. sep .. "order cholerisk kill " .. rime.target .. sep .. hematurgy .. sep .. "unleash triplicate " .. humour
			else
				command = rime.pvp.queue_handle() .. sep .. "contemplate " .. rime.target .. sep .. "order cholerisk kill " .. rime.target .. sep .. hematurgy .. sep .. "humour " .. humour
			end
		else
			if rime.bloodborn.triplicate and rime.bloodborn.triplicate_toggle and table.contains(trip_routes, rime.pvp.route_choice) then
				command = rime.pvp.queue_handle() .. sep .. "contemplate " .. rime.target .. sep .. "order cholerisk kill " .. rime.target .. sep .. "unleash triplicate " .. humour
			else
				command = rime.pvp.queue_handle() .. sep .. "contemplate " .. rime.target .. sep .. "order cholerisk kill " .. rime.target .. sep .. "humour " .. humour
			end
		end
	end

	

	if command ~= rime.balance_queue and command ~= rime.balance_queue_attempted then
		act(command)
		rime.balance_queue_attempted = command
	end
end