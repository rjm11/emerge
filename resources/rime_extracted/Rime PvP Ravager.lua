rime.ravager = rime.ravager or {}
rime.ravager.strengthSap = rime.ravager.strengthSap or 0
rime.ravager.ravage = rime.ravager.ravage or true
rime.ravager.bedevil = rime.ravager.bedevil or true
rime.ravager.outlaw = rime.ravager.outlaw or  true
rime.ravager.delirium = rime.ravager.delirium or false
rime.ravager.predation = rime.ravager.predation or true
rime.ravager.rampage = rime.ravager.rampage or true
ravager = ravager or {}
ravager.hellfire = ravager.hellfire or false
ravager.contusion = ravager.contusion or "none"

rime.pvp.Ravager.routes = {

	["black"] = {
		["blurb"] = {"Here we go!"},
		["attacks"] = {
			"shielded",
			"extinguish",
			"tenderise_kill",
			"both_legs",
			"kneecap_left_knockdown",
			"kneecap_right_knockdown",
			"both_arms",
			"bedevil",
			"bedevil_reverse",
			"delirium",
			"hellfire",
			"lancing",
			"branding",
			"intensify",
			"torment",
			"clobber_punish",
			"fire_fists_right",
			"double_kneecap_left",
			"double_kneecap_right",
			"pressurepoint",
			"haymaker",
			"plexus",
			"overpower_right_leg",
			"double_plexus",
			"overpower_torso",
			"overpower_left_leg",
			"kneecap_left",
			"bully_left",
			"bustup_left",
			"kneecap_right",
			"bustup_right",
			"tenderise",
			"contusion_whiplash",
			"contusion_flog",
			"contusion_maim",
			"contusion_hobble",
			"slug",
			"whiplash",
			"bully_right",
			"maim",
			"flog",
		},
	},

    ["group"] = {
        ["blurb"] = {"I guess"},
        ["attacks"] = {
            "extinguish",
            "tenderise_kill",
            "kneecap_left_knockdown",
            "kneecap_right_knockdown",
            --"bedevil",
            --"bedevil_reverse",
            "inadequacy",
            "delirium",
            "hellfire",
            "lancing",
            --"branding",
            "intensify",
            "clobber_punish",
            "torment",
            "pressurepoint",
            --"overpower_torso",
            --"overpower_right_leg",
            "haymaker",
            "double_plexus",
            "concussion",
            --"overpower_left_leg",
            "bully_left",
            --"bustup_right",
            "kneecap_left",
            "kneecap_right",
            --"bustup_right",
            "slug",
            "bully_right",
            "tenderise",
            "maim",
            "plexus",
            "flog",
            "bustup_left",
            "bustup_right",
            "whiplash",
        },
    },

    ["rampage"] = {
        ["blurb"] = {"This class blends?!"},
        ["attacks"] = {
            "shielded",
            "extinguish",
            "tenderise_kill",
            "delirium",
            "hellfire",
            "lancing",
            "intensify",
            "torment",
            "rampage",
            "haymaker",
            "double_plexus",
            "plexus",
            "concussion",
            "kneecap_left",
            "kneecap_right",
            "bully_left",
            "bully_right",
            "slug",
            "tenderise",
            "maim",
            "flog",
            "whiplash",
        },
    },
}

ravager.attacks = {

    ["intensify"] =  {
        Zealot = "",
        Ravager = "invoke intensify target",
        choice = function()
            local class = gmcp.Char.Status.class
            return ravager.attacks.intensify[class]
        end,
        can = function()
            if has_def("delirium") then return false end
            local target = rime.target
            if rime.pvp.has_aff("ablaze", target) and rime.pvp.has_stack("ablaze", target) <= 9 then
                if rime.pvp.has_aff("heatspear", target) then
                    if rime.pvp.has_aff("torso_damaged", target) then
                        return true
                    end
                    if not rime.limit.torso_restore then
                        return true
                    end
                end
            end
            return false
        end,
        combo = false,
        opening = false,
        channel = false,
        type = "invoke",
    },

    ["torment"] =  {
        Zealot = "",
        Ravager = "invoke torment target",
        choice = function()
            local class = gmcp.Char.Status.class
            return ravager.attacks.torment[class]
        end,
        can = function()
            if has_def("delirium") then return false end
            local target = rime.target
            if rime.pvp.has_aff("ablaze", target) and rime.pvp.has_stack("ablaze", target) == 11 and not rime.balances.ability then return true end
            if rime.pvp.has_aff("ablaze", target) and rime.pvp.has_stack("ablaze", target) < 11 then return false end
            if not rime.pvp.has_aff("torso_damaged", target) then return end
            if rime.pvp.has_aff("prone", target) and rime.pvp.has_aff("left_leg_damaged", target) and not rime.limit.left_leg_restore then return true end
            if rime.pvp.has_aff("prone", target) and rime.pvp.has_aff("right_leg_damaged", target) and not rime.limit.right_leg_restore then return true end
            return false
        end,
        combo = false,
        opening = false,
        channel = false,
        type = "invoke",
    },

	["lancing"] =  {
		Zealot = "",
		Ravager = "invoke lance target",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.lancing[class]
		end,
		can = function()
			local target = rime.target
			local poulticeBalance = rime.getTimeLeft("poultice", rime.target)
			if has_def("delirium") then return false end
			if not rime.pvp.has_aff("heatspear", target) and rime.pvp.has_aff("ablaze", target) and poulticeBalance > 1 then
				return true
			end
			return false
		end,
		combo = false,
		opening = false,
		channel = false,
		type = "invoke",
	},

	["branding"] =  {
		Zealot = "",
		Ravager = "invoke branding target",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.branding[class]
		end,
		can = function()
			if has_def("delirium") then return false end
			local target = rime.target
			if not rime.pvp.has_aff("infernal_seal", target) and rime.pvp.has_aff("torso_damaged", target) then
				return true
			end
			return false
		end,
		combo = false,
		opening = false,
		channel = false,
		type = "invoke",
	},

	["inadequacy"] = {
		Zealot = "",
		Ravager = "ego inadequacy target",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.inadequacy[class]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("indifference", target) then return false end
			if rime.pvp.has_aff("prone", target) and (rime.pvp.has_aff("right_leg_damaged", target) and rime.pvp.has_aff("left_leg_damaged", target)) then
				return true
			end
			return false
		end,
		combo = false,
		opening = false,
		channel = false,
		type = "ego",
	},

	["bedevil"] = {
		Zealot = "evoke pendulum target",
		Ravager = "invoke bedevil target",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.bedevil[class]
		end,
		can = function()
			if rime.ravager.bedevil == false then return false end
			local target = rime.target
			if rime.pvp.has_aff("right_leg_damaged", target) and not rime.pvp.has_aff("left_leg_damaged", target) and rime.limit.right_leg_restore then
					return true
			end
			if rime.pvp.has_aff("right_arm_damaged", target) and rime.limit.right_arm_restore and not rime.pvp.has_aff("right_leg_damaged",target) then
				return true
			end
			return false
		end,
		combo = false,
		opening = false,
		channel = false,
		type = "invoke",
	},

	["bedevil_reverse"] = {
		Zealot = "evoke pendulum target",
		Ravager = "invoke bedevil target reverse",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.bedevil_reverse[class]
		end,
		can = function()
			if rime.ravager.bedevil == false then return false end
			local target = rime.target
			if rime.pvp.has_aff("left_leg_damaged", target) and not rime.pvp.has_aff("right_leg_damaged", target) and rime.limit.left_leg_restore
				and rime.targets[target].limbs.right_leg <= rime.targets[target].limbs.left_leg then
					return true
			end
			if rime.pvp.has_aff("left_arm_damaged", target) and rime.limit.left_arm_restore and not rime.pvp.has_aff("left_leg_damaged", target) then
				return true
			end
			return false
		end,
		combo = false,
		opening = false,
		channel = false,
		type = "invoke",
	},


	["tenderise_kill"] = {
		Zealot = "",
		Ravager = "assail target tenderise"..rime.saved.separator.."invoke extinguish target",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.tenderise_kill[class]
		end,
		can = function()
			local target = rime.target
			if not rime.balances.ability then return false end
			if rime.pvp.has_stack("ablaze", target) == 11 then
				return true
			end
			return false
		end,
		combo = false,
		opening = false,
		channel = false,
		type = "invoke",
	},

	["fire_fists_arms"] = {
		Zealot = "",
		Ravager = "onslaught target bully left bully right",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.fire_fists_arms[class]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.canParry() and (rime.targets[target].parry == "right_arm" or rime.targets[target].parry == "left_arm") then
				return false
			end
			if rime.pvp.has_aff("ablaze", target) then return false end
			if has_def("ravage") and has_def("delirium") then return true end
			return false
		end,
		combo = false,
		opening = true,
		channel = false,
		type = "fist",
	},

	["double_kneecap_left"] = {
		Zealot = "",
		Ravager = "onslaught target kneecap left kneecap left",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.double_kneecap_left[class]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.canParry() and rime.targets[target].parry == "left_leg" then
				return false
			end
			if rime.has_aff("left_leg_broken") or rime.has_aff("right_leg_broken") then return false end
			if rime.limit.left_leg_restore then return false end
			if rime.has_aff("left_leg_broken") or rime.has_aff("right_leg_broken") then return false end
			if rime.targets[target].limbs.left_leg >= 1600 and rime.targets[target].limbs.left_leg < 3300 then
				return true
			end
			return false
		end,
		combo = false,
		opening = true,
		channel = false,
		type = "kick",
	},

	["double_kneecap_right"] = {
		Zealot = "",
		Ravager = "onslaught target kneecap right kneecap right",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.double_kneecap_right[class]
		end,
		can = function()
			if rime.has_aff("left_leg_broken") or rime.has_aff("right_leg_broken") then return false end
			local target = rime.target
			if rime.pvp.canParry() and rime.targets[target].parry == "right_leg" then
				return false
			end
			if rime.has_aff("left_leg_broken") or rime.has_aff("right_leg_broken") then return false end
			if rime.limit.right_leg_restore then return false end
			if rime.targets[target].limbs.right_leg >= 1600 and rime.targets[target].limbs.right_leg < 3300 then
				return true
			end
			return false
		end,
		combo = false,
		opening = true,
		channel = false,
		type = "kick",
	},

	["both_legs"] = {
		Zealot = "",
		Ravager = "onslaught target kneecap left kneecap right",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.both_legs[class]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.canParry() and (rime.targets[target].parry == "left_leg" or rime.targets[target].parry == "right_leg") then
				return false
			end
			if rime.has_aff("left_leg_broken") or rime.has_aff("right_leg_broken") then return false end
			if rime.pvp.has_aff("left_leg_damaged", target) and rime.pvp.has_aff("right_leg_damaged", target) then return false end
			if rime.targets[target].limbs.left_leg >= 2400 and rime.targets[target].limbs.right_leg >= 2400 then
				return true
			end
			return false
		end,
		combo = false,
		opening = true,
		channel = false,
		type = "kick",
	},

	["both_arms"] = {
		Zealot = "",
		Ravager = "onslaught target bully left bully right",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.both_arms[class]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.canParry() and (rime.targets[target].parry == "left_arm" or rime.targets[target].parry == "right_arm") then
				return false
			end
			if rime.pvp.has_aff("left_arm_damaged", target) or rime.pvp.has_aff("right_arm_damaged", target) then return false end
			if rime.targets[target].limbs.left_arm >= 2400 and rime.targets[target].limbs.right_arm >= 2400 then
				return true
			end
			return false
		end,
		combo = false,
		opening = true,
		channel = false,
		type = "fist",
	},

	["fire_fists_right"] = {
		Zealot = "",
		Ravager = "onslaught target plexus bully right",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.fire_fists_right[class]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.canParry() and (rime.targets[target].parry == "right_arm" or rime.targets[target].parry == "torso") then
				return false
			end
			if rime.pvp.has_aff("ablaze", target) then return false end
			if has_def("ravage") and has_def("delirium") then return true end
			return false
		end,
		combo = false,
		opening = true,
		channel = false,
		type = "fist",
	},

	["fire_fists_left"] = {
		Zealot = "",
		Ravager = "onslaught target plexus bully left",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.fire_fists_left[class]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.canParry() and (rime.targets[target].parry == "left_arm" or rime.targets[target].parry == "torso") then
				return false
			end
			if rime.pvp.has_aff("ablaze", target) then return false end
			if has_def("ravage") and has_def("delirium") then return true end
			return false
		end,
		combo = false,
		opening = true,
		channel = false,
		type = "fist",
	},

	["kneecap_left_knockdown"] = {
		Zealot = "",
		Ravager = "onslaught target kneecap left clobber punish",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.kneecap_left_knockdown[class]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.canParry() and rime.targets[target].parry == "left_leg" then
				return false
			end
			if rime.limit.left_leg_restore then return false end
			if rime.pvp.has_aff("prone", target) then return false end
			if rime.targets[target].limbs.left_leg >= 2400 then
				return true
			end
			return false
		end,
		combo = false,
		opening = true,
		channel = true,
		type = "fist",
	},

	["kneecap_right_knockdown"] = {
		Zealot = "",
		Ravager = "onslaught target kneecap right clobber punish",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.kneecap_right_knockdown[class]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.canParry() and rime.targets[target].parry == "right_leg" then
				return false
			end
			if rime.limit.right_leg_restore then return false end
			if rime.pvp.has_aff("prone", target) then return false end
			if rime.targets[target].limbs.right_leg >= 2400 then
				return true
			end
			return false
		end,
		combo = false,
		opening = true,
		channel = true,
		type = "fist",
	},

	["delirium"] = {
		Zealot = "evoke zenith",
		Ravager = "invoke delirium",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.delirium[class]
		end,
		can = function()
			if not rime.ravager.delirium then
				return true
			end
			return false
		end,
		combo = false,
		opening = false,
		channel = false,
		type = "invoke",
	},

    ["shielded"] = {
        "touch hammer target",
        choice = function()
            return ravager.attacks.shielded[1], "eq", "shielded"
        end,
        can = function()
            local target = rime.target
            if rime.pvp.has_def("shielded", target) and not rime.has_aff("infernal_shroud", rime.target)then
                return true
            else
                return false
            end
        end,
    },

	["extinguish"] = {
		Zealot = "",
		Ravager = "invoke extinguish target",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.extinguish[class]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_stack("ablaze", target) >= 12 then
				return true
			end
			return false
		end,
		combo = false,
		opening = false,
		channel = false,
		type = "invoke",
	},


	["bully_left"] = {
		Zealot = "",
		Ravager = "bully left",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.bully_left[class]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.canParry() and rime.targets[target].parry == "left_arm" then
				return false
			end
			if rime.limit.left_arm_restore then return false end
			return true
		end,
		combo = true,
		opening = true,
		channel = false,
		type = "fist",
	},

	["bully_right"] = {
		Zealot = "",
		Ravager = "bully right",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.bully_right[class]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.canParry() and rime.targets[target].parry == "right_arm" then
				return false
			end
			if rime.limit.right_arm_restore then return false end
			return true
		end,
		combo = true,
		opening = true,
		channel = false,
		type = "fist",
	},

	["clobber"] = {
		Zealot = "",
		Ravager = "clobber",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.clobber[class]
		end,
		can = function()
			local target = target
			if rime.pvp.has_aff("prone", target) then
				return false
			end
			if rime.pvp.has_aff("left_leg_damaged", target) and not rime.limit.left_leg_restore then
				return true
			end
			if rime.pvp.has_aff("right_leg_damaged", target) and not rime.limit.right_leg_restore then
				return true
			end
			return false
		end,
		combo = true,
		opening = true,
		channel = false,
		type = "fist",
	},

	["clobber_punish"] = {
		Zealot = "",
		Ravager = "clobber punish",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.clobber_punish[class]
		end,
		can = function()
			local target = target
			if rime.pvp.has_aff("prone", target) then
				return false
			end
			if rime.pvp.has_aff("left_leg_damaged", target) and not rime.limit.left_leg_restore then
				return true
			end
			if rime.pvp.has_aff("right_leg_damaged", target) and not rime.limit.right_leg_restore then
				return true
			end
			return false
		end,
		combo = true,
		opening = true,
		channel = false,
		type = "fist",
	},

	["plexus"] = {
		Zealot = "",
		Ravager = "plexus",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.plexus[class]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.canParry() and rime.targets[target].parry == "torso" then
				return false
			end
			if not rime.pvp.has_aff("torso_damaged", target) then
				return false
			end
			return true
		end,
		combo = true,
		opening = true,
		channel = false,
		type = "fist",
	},

   ["double_plexus"] = {
        Zealot = "",
        Ravager = "onslaught target plexus plexus",
        choice = function()
            local class = gmcp.Char.Status.class
            return ravager.attacks.double_plexus[class]
        end,
        can = function()
            local target = rime.target
            if rime.pvp.canParry() and rime.targets[target].parry == "torso" then
                return false
            end
            if rime.limit[target.."_torso_restore"] then return false end
            return true
        end,
        combo = false,
        opening = true,
        channel = false,
        type = "fist",
    },

    ["rampage"] = {
        Zealot = "",
        Ravager = "rampage",
        choice = function()
            local class = gmcp.Char.Status.class
            return ravager.attacks.rampage[class]
        end,
        can = function()
            local target = rime.target
            if rime.ravager.rampage then return true end
            return false
        end,
        combo = false,
        opening = true,
        channel = false,
        type = "rampage",
    },

	["bustup_left"] = {
		Zealot = "",
		Ravager = "bustup left arm",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.bustup_left[class]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("left_arm_damaged", target) or rime.pvp.has_aff("left_arm_dislocated", target) then
				return false
			end
			return true
		end,
		combo = true,
		opening = true,
		channel = false,
		type = "fist",
	},

	["bustup_right"] = {
		Zealot = "",
		Ravager = "bustup right arm",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.bustup_right[class]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("right_arm_damaged", target) or rime.pvp.has_aff("right_arm_dislocated", target) then
				return false
			end
			return true
		end,
		combo = true,
		opening = true,
		channel = false,
		type = "fist",
	},

	["pressurepoint"] = {
		Zealot = "",
		Ravager = "pressure",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.pressurepoint[class]
		end,
		can = function()
			local target = rime.target 
			if rime.pvp.has_aff("muscle_spasms", target) then
				return false
			end
			return true
		end,
		combo = true,
		opening = true,
		channel = false,
		type = "press",
	},

	["haymaker"] = {
		Zealot = "",
		Ravager = "haymaker",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.haymaker[class]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.canParry() and rime.targets[target].parry == "torso" then
				return false
			end
			if rime.has_aff("paresis") or rime.has_aff("paralysis") then
                return false
            end
			if rime.pvp.has_aff("lightwound", target) then return false end
			return true
		end,
		combo = true,
		opening = false,
		channel = true,
		type = "fist",
	},

	["kneecap_left"] = {
		Zealot = "",
		Ravager = "kneecap left",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.kneecap_left[class]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.canParry() and rime.targets[target].parry == "left_leg" then
				return false
			end
			if rime.has_aff("left_leg_broken") or rime.has_aff("right_leg_broken") then return false end
			if rime.limit.left_leg_restore then return false end
			return true
		end,
		combo = true,
		opening = true,
		channel = false,
		type = "kick",
	},

	["kneecap_right"] = {
		Zealot = "",
		Ravager = "kneecap right",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.kneecap_right[class]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.canParry() and rime.targets[target].parry == "right_leg" then
				return false
			end
			if rime.has_aff("left_leg_broken") or rime.has_aff("right_leg_broken") then return false end
			if rime.limit.right_leg_restore then return false end
			return true
		end,
		combo = true,
		opening = true,
		channel = false,
		type = "kick",
	},

	["concussion"] = {
		Zealot = "",
		Ravager = "concuss",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.concussion[class]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.canParry() and rime.targets[target].parry == "head" then
				return false
			end
			if rime.has_aff("left_leg_broken") or rime.has_aff("right_leg_broken") then return false end
			return true
		end,
		combo = true,
		opening = true,
		channel = false,
		type = "kick",
	},

	["rebound"] = {
		Zealot = "",
		Ravager = "rebound",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.rebound[class]
		end,
		can = function()
			if gmcp.Char.Vitals.fallen == "0" then
				return false
			end
			if rime.has_aff("left_leg_broken") or rime.has_aff("right_leg_broken") then return false end
			return true
		end,
		combo = true,
		opening = true,
		channel = false,
		type = "kick",
	},

	["overpower_left_leg"] = {
		Zealot = "",
		Ravager = "overpower left leg",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.overpower_left_leg[class]
		end,
		can = function()
			local target = rime.target 
			if rime.pvp.has_aff("left_leg_damaged", target) then return false end
			if rime.pvp.has_aff("right_leg_damaged") and (not rime.limit.right_leg_restore or rime.ravager.bedevil) then return false end
			if rime.has_aff("paresis") or rime.has_aff("paralysis") then
                return false
            end
            if rime.has_aff("left_leg_broken") or rime.has_aff("right_leg_broken") then return false end
			if rime.pvp.has_aff("sore_wrist", target) then return true end
			if not rime.pvp.canParry() then return true end
			return false
		end,
		combo = true,
		opening = true,
		channel = true,
		type = "kick",
	},

	["overpower_right_leg"] = {
		Zealot = "",
		Ravager = "overpower right leg",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.overpower_right_leg[class]
		end,
		can = function()
			local target = rime.target 
			if rime.pvp.has_aff("right_leg_damaged", target) then return false end
			if rime.pvp.has_aff("left_leg_damaged") and (not rime.limit.left_leg_restore or rime.ravager.bedevil) then return false end
			if rime.has_aff("paresis") or rime.has_aff("paralysis") then
                return false
            end
            if rime.has_aff("left_leg_broken") or rime.has_aff("right_leg_broken") then return false end
			if rime.pvp.has_aff("sore_wrist", target) then return true end
			if not rime.pvp.canParry() then return true end
			return false
		end,
		combo = true,
		opening = true,
		channel = true,
		type = "kick",
	},

	["overpower_head"] = {
		Zealot = "",
		Ravager = "overpower head",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.overpower_head[class]
		end,
		can = function()
			local target = rime.target 
			if rime.has_aff("paresis") or rime.has_aff("paralysis") then
                return false
            end
            if rime.has_aff("left_leg_broken") or rime.has_aff("right_leg_broken") then return false end
			if rime.pvp.has_aff("sore_wrist", target) then return true end
			if not rime.pvp.canParry() then return true end
			return false
		end,
		combo = true,
		opening = true,
		channel = true,
		type = "kick",
	},

	["overpower_torso"] = {
		Zealot = "",
		Ravager = "overpower torso",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.overpower_torso[class]
		end,
		can = function()
			local target = rime.target
			if rime.has_aff("left_leg_broken") or rime.has_aff("right_leg_broken") then return false end
			if rime.pvp.has_aff("torso_mangled", target) then return false end
			if rime.has_aff("paresis") or rime.has_aff("paralysis") then
                return false
            end
			if rime.pvp.has_aff("sore_wrist", target) then return true end
			if not rime.pvp.canParry() then return true end
			return false
		end,
		combo = true,
		opening = true,
		channel = true,
		type = "kick",
	},

	["overpower_right_arm"] = {
		Zealot = "",
		Ravager = "overpower right arm",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.overpower_right_arm[class]
		end,
		can = function()
			local target = rime.target 
			if rime.has_aff("left_leg_broken") or rime.has_aff("right_leg_broken") then return false end
			if rime.pvp.has_aff("right_arm_damaged", target) then return false end
			if rime.has_aff("paresis") or rime.has_aff("paralysis") then
                return false
            end
			if rime.pvp.has_aff("sore_wrist", target) then return true end
			if not rime.pvp.canParry() then return true end
			return false
		end,
		combo = true,
		opening = true,
		channel = true,
		type = "kick",
	},

	["overpower_left_arm"] = {
		Zealot = "",
		Ravager = "overpower left arm",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.overpower_left_arm[class]
		end,
		can = function()
			local target = rime.target 
			if rime.has_aff("left_leg_broken") or rime.has_aff("right_leg_broken") then return false end
			if rime.pvp.has_aff("left_arm_damaged", target) then return false end
			if rime.has_aff("paresis") or rime.has_aff("paralysis") then
                return false
            end
			if rime.pvp.has_aff("sore_wrist", target) then return true end
			if not rime.pvp.canParry() then return true end
			return false
		end,
		combo = true,
		opening = true,
		channel = true,
		type = "kick",
	},

	["windpipe"] = {
		Zealot = "",
		Ravager = "windpipe",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.windpipe[class]
		end,
		can = function()
			if rime.has_aff("left_leg_broken") or rime.has_aff("right_leg_broken") then return false end
			local target = rime.target
			if rime.pvp.canParry() and rime.targets[target].parry == "head" then
				return false
			end
			return true
		end,
		combo = true,
		opening = true,
		channel = false,
		type = "kick",
	},

	["hobble"] = {
		Zealot = "",
		Ravager = "hobble",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.hobble[class]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("sore_ankle", target) then
				return false
			end
			return true
		end,
		combo = true,
		opening = true,
		channel = false,
		type = "chain",
	},

	["contusion_hobble"] = {
		Zealot = "",
		Ravager = "hobble",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.hobble[class]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("sore_ankle", target) then
				return false
			end
			if ravager.contusion == "legs" then
				return true
			end
			return false
		end,
		combo = true,
		opening = true,
		channel = false,
		type = "chain",
	},

	["slug"] = {
		Zealot = "",
		Ravager = "slug",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.slug[class]
		end,
		can = function()
			local target = rime.target 
			if rime.pvp.has_aff("blurry_vision", target) then 
				return false
			end
			return true
		end,
		combo = true,
		opening = true,
		channel = false,
		type = "chain",
	},

	["flog"] = {
		Zealot = "",
		Ravager = "flog",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.flog[class]
		end,
		can = function()
			local target = rime.target 
			if rime.pvp.has_aff("backstrain", target) then 
				return false
			end
			return true
		end,
		combo = true,
		opening = true,
		channel = false,
		type = "chain",
	},

	["contusion_flog"] = {
		Zealot = "",
		Ravager = "flog",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.flog[class]
		end,
		can = function()
			local target = rime.target 
			if rime.pvp.has_aff("backstrain", target) then 
				return false
			end
			if ravager.contusion == "torso" then
				return true
			end
			return false
		end,
		combo = true,
		opening = true,
		channel = false,
		type = "chain",
	},

	["maim"] = {
		Zealot = "",
		Ravager = "maim",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.maim[class]
		end,
		can = function()
			local target = rime.target 
			if rime.pvp.has_aff("sore_wrist", target) then 
				return false
			end
			return true
		end,
		combo = true,
		opening = true,
		channel = false,
		type = "chain",
	},

	["contusion_maim"] = {
		Zealot = "",
		Ravager = "maim",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.maim[class]
		end,
		can = function()
			local target = rime.target 
			if rime.pvp.has_aff("sore_wrist", target) then 
				return false
			end
			if ravager.contusion == "arms" then
				return true
			end
			return false
		end,
		combo = true,
		opening = true,
		channel = false,
		type = "chain",
	},

	["butcher"] = {
		Zealot = "",
		Ravager = "butcher",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.butcher[class]
		end,
		can = function()
			return true
		end,
		combo = true,
		opening = true,
		channel = false,
		type = "chain",
	},

	["whiplash"] = {
		Zealot = "",
		Ravager = "whiplash",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.whiplash[class]
		end,
		can = function()
			local target = rime.target 
			if rime.pvp.has_aff("whiplash", target) then 
				return false
			end
			return true
		end,
		combo = true,
		opening = true,
		channel = false,
		type = "chain",
	},

	["contusion_whiplash"] = {
		Zealot = "",
		Ravager = "whiplash",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.whiplash[class]
		end,
		can = function()
			local target = rime.target 
			if rime.pvp.has_aff("whiplash", target) then 
				return false
			end
			if ravager.contusion == "head" then
				return true
			end
			return false
		end,
		combo = true,
		opening = true,
		channel = false,
		type = "chain",
	},

	["tenderise"] = {
		Zealot = "",
		Ravager = "tenderise",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.attacks.tenderise[class]
		end,
		can = function()
			local target = rime.target 
			if not rime.pvp.has_aff("ablaze", target) then return false end
			if rime.pvp.has_stack("ablaze", target) < 3 then return false end
			return true
		end,
		combo = true,
		opening = true,
		channel = false,
		type = "chain",
	},

    ["trauma"] = {
        Zealot = "",
        Ravager = "ego trauma target",
        choice = function()
            local class = gmcp.Char.Status.class
            return ravager.attacks.trauma[class]
        end,
        can = function()
            local target = rime.target
            if rime.pvp.route_choice == "group" then
                return true
            end
            return false
        end,
        combo = false,
        opening = false,
        channel = false,
        type = "ego",
    },

}

ravager.delirium_attacks = {

    ["torment"] =  {
        Zealot = "",
        Ravager = "invoke torment target",
        choice = function()
            local class = gmcp.Char.Status.class
            return ravager.delirium_attacks.torment[class]
        end,
        can = function()
            local target = rime.target
            if rime.pvp.has_aff("ablaze", target) and rime.pvp.has_stack("ablaze", target) == 11 and not rime.balances.ability then return true end
            if rime.pvp.has_aff("ablaze", target) and rime.pvp.has_stack("ablaze", target) < 11 then
                return false
            end
            return true
        end,
    },

	["lancing"] =  {
		Zealot = "",
		Ravager = "invoke lance target",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.delirium_attacks.lancing[class]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("heatspear", target) then return false end
			if rime.pvp.has_aff("ablaze", target) then
				return true
			end
			if ravager.attacks.fire_fists_arms.can() or ravager.attacks.fire_fists_left.can() or ravager.attacks.fire_fists_right.can() then
				return true
			end
			return false
		end,
	},

	["branding"] =  {
		Zealot = "",
		Ravager = "invoke branding target",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.delirium_attacks.branding[class]
		end,
		can = function()
			local target = rime.target
			if not rime.pvp.has_aff("infernal_seal", target) and rime.pvp.has_aff("torso_damaged", target) then
				return true
			end
			return false
		end,
	},

    ["intensify"] =  {
        Zealot = "",
        Ravager = "invoke intensify target",
        choice = function()
            local class = gmcp.Char.Status.class
            return ravager.delirium_attacks.intensify[class]
        end,
        can = function()
            local target = rime.target
            if rime.pvp.has_aff("ablaze", target) and rime.pvp.has_stack("ablaze", target) <= 9 then
                return true
            end
            return false
        end,
    },

	["hellfire"] =  {
		Zealot = "",
		Ravager = "invoke hellfire",
		choice = function()
			local class = gmcp.Char.Status.class
			return ravager.delirium_attacks.hellfire[class]
		end,
		can = function()
			local target = rime.target
			if not ravager.hellfire then
				return true
			end
			return false
		end,
	},

}

function ravager.canBreakArm(limb)
    local dmg = 950
    if rime.targets[rime.target].limbs[limb] < 3333 and (rime.targets[rime.target].limbs[limb]+dmg) >= 3333 then
        return true
    end
    return false
end

function ravager.get_attack()

	local target = rime.target
	local sep = rime.saved.separator
	local attack, attack1, combo1, channel1, attack_type1, opening1, attack2, opening2, channel2, attack_type2

	for k,v in ipairs(rime.pvp.route.attacks) do
		if ravager.attacks[v] and ravager.attacks[v].can() and v ~= "tenderise" then
			attack1 = ravager.attacks[v].choice()
			combo1 = ravager.attacks[v].combo
			opening1 = ravager.attacks[v].opening
			attack_type1 = ravager.attacks[v].type
			channel1 = ravager.attacks[v].channel
			break
		end
	end

	if combo1 then
		for k,v in ipairs(rime.pvp.route.attacks) do
			if ravager.attacks[v] and ravager.attacks[v].can() and ravager.attacks[v].choice() ~= attack1 and v ~= "tenderise" then
				attack2 = ravager.attacks[v].choice()
				opening2 = ravager.attacks[v].opening
				attack_type2 = ravager.attacks[v].type
				channel2 = ravager.attacks[v].channel
				if channel1 and not channel2 then
					break
				end
				if channel2 and not channel1 then
					break 
				end
				if not channel1 and not channel2 then
					break
				end
			end
		end

		if opening1 then
			attack = "onslaught "..target.." "..attack1.." "..attack2
		else
			attack = "onslaught "..target.." "..attack2.." "..attack1
		end

		if attack2:find("bustup") then
			if attack1:find("bully") then
				attack = "onslaught "..target.." "..attack2.." "..attack1
			end
		end

	else

		attack = attack1:gsub("target", rime.target)

	end


	if has_def("delirium") and not channel1 and not channel2 and ravager.delirium_attack() then
		attack = attack .. sep .. ravager.delirium_attack():gsub("target", rime.target)
	end

	if rime.balances.ability then
		for k,v in ipairs(rime.pvp.route.attacks) do
			if ravager.attacks[v] and ravager.attacks[v].can() and ravager.attacks[v].choice() ~= attack1 
				and ravager.attacks[v].choice() ~= attack2 and ravager.attacks[v].type == "chain" 
				and not channel1 and not channel2 and not attack:find("delirium") then
				attack = attack .. sep .. "assail "..target.." "..ravager.attacks[v].choice()
				break
			end
		end
	end

	if rime.ravager.ravage and (attack_type1 == "fist" or attack_type2 == "fist") then attack = "invoke ravage"..sep..attack end

	if rime.pvp.route_choice == "group" then
		if rime.pvp.mental_count(rime.target) > 0 or attack:find("concuss") then
        	attack = attack .. sep .. "ego trauma "..rime.target
    	end
    end

	if rime.ravager.predation and not attack:find("delirium") and not rime.pvp.has_aff("indifference", rime.target) and not attack:find("inadequacy") then
		return "order impressment attack "..rime.target..sep.."predation"..sep..attack
	else
		return "order impressment attack "..rime.target..sep..attack
	end

end

function ravager.delirium_attack()

	for k,v in pairs(rime.pvp.route.attacks) do
		if ravager.delirium_attacks[v] and ravager.delirium_attacks[v].can() then
			return ravager.delirium_attacks[v].choice()
		end
	end

end

function ravager.assail_attack()
	for k,v in ipairs(rime.pvp.route.attacks) do
		if ravager.attacks[v] and ravager.attacks[v].can() and ravager.attacks[v].type == "chain" then
			return "qs assail "..rime.target.." "..ravager.attacks[v].choice()
		end
	end

end

function ravager.offense()

	local target = rime.target
	local sep = rime.saved.separator
	local command = ravager.get_attack()
	local queue = rime.pvp.queue_handle()

	command = command:gsub(sep .. sep .. "+", sep)
    --if rime.ravager.ravage and not command:find("delirium") then command = "invoke ravage"..sep..command end
    command = queue.. sep .. command .. rime.pvp.post_queue()


    if command ~= rime.balance_queue and command ~= rime.balance_queue_attempted then
        act(command)
        rime.balance_queue_attempted = command
    end

    if ravager.assail_attack() ~= rime.secondary_queue and ravager.assail_attack() ~= rime.secondary_queue_attempted then
    	act(ravager.assail_attack())
    	rime.secondary_queue_attempted = ravager.assail_attack()
    end

end