--Author: Bulrok
indo = indo or {}
indo.attacks = indo.attacks or {}

indo.can_aeon = true
indo.can_chimera = true
indo.can_soulmaster = false
indo.can_envelop = true
indo.can_wheel = true
indo.wheel_toggle = false
indo.adder_ready = false
indo.adder_toggle = false
indo.despair_toggle = false
indo.soulmaster_toggle = false
indo.deform_count = 14
indo.lust_check = false
indo.need_empress = false
indo.wheeled_affs = {}
indo.need_diag = false
indo.can_creator = true
indo.eclipse = 0
indo.eclipse_throwing = true
indo.aeon_used = false
indo.pacts = {
	["minion"] = false,
	["bloodleech"] = false,
	["bubonis"] = false,
	["firelord"] = false,
	["chimera"] = false,
	["sycophant"] = false,
}

indo.pacts_priority = {
	"minion",
	"bubonis",
	"chimera",
	"sycophant",
	"bloodleech",
	"firelord",
}

rime.pvp.Indorani.routes = {

	["black"] = {

		["blurb"] = {"Most efficient kill route."},

		["attacks"] = {
			"vivisex",
			"deform",
			"decay",
			"fool",
			"shielded",
			"impatience",
			"perplexed",
			"stupidity",
			"epilepsy",
			"aeon",
			"clumsiness",
			"asthma",
			"speed_strip",
			"superstition",
			"hypersomnia",
			"confusion",
			"berserking",
			"weariness",
			"recklessness",
			"vomiting",
			"justice",
			"lovers_effect",
			"haemophilia",
		},

		["venoms"] = {
			"slickness",
			"paresis",
			"dizziness",
			"allergies",
			"shyness",
			"dizziness",
			"voyria",
		},

		["chimera"] = {
			"damage",
			"no_deaf",
			"stun",
		},

		["soulmaster"] = {
			"dodge_off",
		}
	},

	["group"] = {

		["attacks"] = {
			"effigy_damage",
			"damage_decay",
			"aeon",
			"asthma",
			"superstition",
			"justice",
			"clumsiness",
			"sensitivity",
			"impatience",
			"berserking",
			"stupidity",
			"epilepsy",
			"hypersomnia",
			"confusion",
			"weariness",
			"recklessness",
			"vomiting",
			"lovers_effect",

		},

		["venoms"] = {
			"slickness",
			"paresis",
			"dizziness",
			"allergies",
			"shyness",
			"dizziness",
			"voyria",
		},

		["chimera"] = {
			"damage",
			"no_deaf",
			"stun",
		},

		["soulmaster"] = {
			"dodge_off",
		}
	},

	["sex"] = {

		["attacks"] = {
			"vivisex",
			"shrivel_legs",
			"shrivel_arms",
		},
		
		["venoms"] = {
			"dizziness",
			"allergies",
			"shyness",
			"dizziness",
			"voyria",
		},

		["chimera"] = {
			"damage",
			"no_deaf",
			"stun",
		},

		["soulmaster"] = {
			"scraped",
		}

	},

}

indo.attacks = {

	["effigy_damage"] = {
		Indorani = "taint target",
		Oneiromancer = "nightmare target",
		can = function()
			local target = rime.target
			if not rime.pvp.has_def("dome", target) then return false end
			if not rime.targets[target].effigy then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.effigy_damage[class]
		end,
		card = false,
		call = false,
		eclipse = 0,
	},

	["shielded"] = {
		Indorani = "touch hammer target",
		Oneiromancer = "touch hammer target",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("shielded", target) then return true end
			return false
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.shielded[class]
		end,
		card = false,
		call = false,
		eclipse = 0,
	},

	["speed_strip"] = {
		Indorani = "aeon",
		Oneiromancer = "hourglass",
		can = function()
			local target = rime.target
			if not rime.pvp.has_def("speed", target) then return false end
			if not indo.can_aeon then return false end
			return true
		end,
		card = "aeon",
		call = false,
		eclipse = 0,
	},

	["aeon"] = {
		Indorani = "aeon",
		Oneiromancer = "hourglass",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("speed", target) then return false end
			if not indo.can_aeon then return false end
			return true
		end,
		card = "aeon",
		call = false,
		eclipse = 0,
	},

	["dreamscape"] = {
		Indorani = "fling creator dreamscape at ground",
		Oneiromancer = "unfurl bowl dreamscape at ground",
		can = function()
			return indo.can_creator
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.dreamscape[class]
		end,
		card = false,
		call = false,
		eclipse = 0,
	},

	["fool"] = {
		Indorani = "fling fool at me",
		Oneiromancer = "unfurl fire at me",
		can = function()
			if rime.has_aff("paresis") then return false end
			if rime.has_aff("paralysis") then return false end
			if not rime.curing.class then return false end
			if rime.has_aff("left_arm_crippled") and rime.has_aff("right_arm_crippled") then return false end
			local aff_count = 0
			for k,v in ipairs(rime.curing.affsByType.renew) do
				if rime.has_aff(v) then
					aff_count = aff_count+1
				end
			end
			if aff_count >= 2 then return true end
		end,
		choice = function()
			class = rime.status.class
			return indo.attacks.fool[class]
		end,
		call = false,
		card = "fool",
		eclipse = 0,
	},

	["deform"] = {
		Indorani = "deform target",
		Oneiromancer = "disjunct target",
		can = function()
			local target = rime.target
			local aff_total = 0
			if not rime.pvp.has_aff("leeched_aura", target) then return false end
			if rime.pvp.has_aff("deform", target) then return false end
			for k,v in pairs(rime.targets[target].afflictions) do
                if rime.pvp.has_aff(k, target) and not ignore_aff(k) then
                    aff_total = aff_total+1
                end
            end
			if aff_total >= tonumber(indo.deform_count) then
				return true
			else
				return false
			end
		end,
		choice = function()
			class = rime.status.class
			return indo.attacks.deform[class]
		end,
		call = false,
		card = false,
		eclipse = 0,
	},

	["damage_decay"] = {
		Indorani = "decay target",
		Oneiromancer = "starlight target",
		can = function()
			local target = rime.target
			return rime.pvp.has_aff("locked", target)
		end,
		choice = function()
			class = rime.status.class
			return indo.attacks.damage_decay[class]
		end,
		call = false,
		card = false,
		eclipse = 0,
	},

	["decay"] = {
		Indorani = "decay target",
		Oneiromancer = "starlight target",
		can = function()
			local target = rime.target
			return rime.pvp.has_aff("deform", target)
		end,
		choice = function()
			class = rime.status.class
			return indo.attacks.decay[class]
		end,
		call = false,
		card = false,
		eclipse = 0,
	},

	["deform_bonedagger"] = {
		Indorani = "flick bonedagger at target voyria",
		Oneiromancer = "impel athame at target voyria",
		can = function()
			local target = rime.target
			if not rime.pvp.has_aff("deform", target) then return false end
			if rime.pvp.has_aff("voyria", target) then return false end
		end,
		choice = function()
			class = rime.status.class
			return indo.attacks.deform_bonedagger[class]
		end,
		call = false,
		card = false,
		eclipse = 0,
	},

	["vivisex"] = {
		Indorani = "vivisect target",
		Oneiromancer = "vanguish target",
		can = function()
			local target = rime.target
			if not rime.pvp.has_aff("left_arm_crippled", target) then return false end
			if not rime.pvp.has_aff("right_arm_crippled", target) then return false end
			if not rime.pvp.has_aff("left_leg_crippled", target) then return false end
			if not rime.pvp.has_aff("right_leg_crippled", target) then return false end
			if not rime.pvp.has_aff("leeched_aura", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.vivisex[class]
		end,
		call = false,
		card = false,
		eclipse = 0,
	},

	["writhe_ropes"] = {
		Indorani = "fling hangedman at target",
		Oneiromancer = "unfurl wreath at target",
		can = function()
			local target = rime.target
			if not rime.pvp.has_aff("no_deaf") then return false end
			if not indo.can_chimera then return false end
			if rime.affTally < 5 then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.writhe_ropes[class]
		end,
		call = false,
		card = false,
		eclipse = 0,
	},

	["shrivel_arms"] = {
		Indorani = "shrivel target arms",
		Oneiromancer = "misfortune target arms",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("left_arm_crippled", target) and rime.pvp.has_aff("right_arm_crippled", target) then return false end
			return true
		end,
		choice = function()
			class = rime.status.class
			return indo.attacks.shrivel_arms[class]
		end,
		call = false,
		card = false,
		eclipse = 0,
	},

	["shrivel_legs"] = {
		Indorani = "shrivel target legs",
		Oneiromancer = "misfortune target legs",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("left_leg_crippled", target) and rime.pvp.has_aff("right_leg_crippled", target) then return false end
			return true
		end,
		choice = function()
			class = rime.status.class
			return indo.attacks.shrivel_legs[class]
		end,
		call = false,
		card = false,
		eclipse = 0,
	},

	["shrivel_left_arm"] = {
		Indorani = "shrivel target left arm",
		Oneiromancer = "misfortune target left arm",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("left_arm_crippled", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.shrivel_left_arm[class]
		end,
		call = false,
		card = false,
		eclipse = 0,
	},

	["shrivel_right_arm"] = {
		Indorani = "shrivel target right arm",
		Oneiromancer = "misfortune target right arm",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("right_arm_crippled", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.shrivel_right_arm[class]
		end,
		call = false,
		card = false,
		eclipse = 0,
	},

	["shrivel_left_leg"] = {
		Indorani = "shrivel target left leg",
		Oneiromancer = "misfortune target left leg",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("left_leg_crippled", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.shrivel_left_leg[class]
		end,
		call = false,
		card = false,
		eclipse = 0,
	},

	["shrivel_right_leg"] = {
		Indorani = "shrivel target right leg",
		Oneiromancer = "misfortune target right leg",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("right_leg_crippled", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.shrivel_right_leg[class]
		end,
		call = false,
		card = false,
		eclipse = 0,
	},

	["clumsiness"] = {
		Indorani = "sun clumsiness",
		Oneiromancer = "sphere clumsiness",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("clumsiness", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.clumsiness[class]
		end,
		call = "clumsiness",
		card = "sun",
		eclipse = 1
	},

	["asthma"] = {
		Indorani = "sun asthma",
		Oneiromancer = "sphere asthma",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("asthma", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.asthma[class]
		end,
		call = "asthma",
		card = "sun",
		eclipse = 1,
	},

	["vomiting"] = {
		Indorani = "sun vomiting",
		Oneiromancer = "sphere vomiting",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("vomiting", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.vomiting[class]
		end,
		call = "vomiting",
		card = "sun",
		eclipse = 1,
	},

	["lethargy"] = {
		Indorani = "sun lethargy",
		Oneiromancer = "sphere lethargy",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("lethargy", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.lethargy[class]
		end,
		call = "lethargy",
		card = "sun",
		eclipse = 1,
	},

	["perplexed"] = {
		Indorani = "sun perplexed",
		Oneiromancer = "sphere perplexed",
		can = function(eclipse)
			local target = rime.target
			if not eclipse then return false end
			if rime.pvp.has_aff("perplexed", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.perplexed[class]
		end,
		call = "perplexed",
		card = "sun",
		eclipse = 1,
	},

	["sensitivity"] = {
		Indorani = "sun sensitivity",
		Oneiromancer = "sphere sensitivity",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("sensitivity", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.sensitivity[class]
		end,
		call = "sensitivity",
		card = "sun",
		eclipse = 1,
	},

	["superstition"] = {
		Indorani = "sun superstition",
		Oneiromancer = "sphere superstition",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("superstition", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.superstition[class]
		end,
		call = "superstition",
		card = "sun",
		eclipse = 1,
	},

	["hypersomnia"] = {
		Indorani = "sun hypersomnia",
		Oneiromancer = "sphere hypersomnia",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("hypersomnia", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.hypersomnia[class]
		end,
		call = "hypersomnia",
		card = "sun",
		eclipse = 1,
	},

	["stupidity"] = {
		Indorani = "moon stupidity",
		Oneiromancer = "hypercube stupidity",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("stupidity", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.stupidity[class]
		end,
		call = "stupidity",
		card = "moon",
		eclipse = 1,
	},

	["confusion"] = {
		Indorani = "moon confusion",
		Oneiromancer = "hypercube confusion",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("confusion", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.confusion[class]
		end,
		call = "stupidity",
		card = "moon",
		eclipse = 1,
	},

	["recklessness"] = {
		Indorani = "moon recklessness",
		Oneiromancer = "hypercube recklessness",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("recklessness", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.recklessness[class]
		end,
		call = "recklessness",
		card = "moon",
		eclipse = 1,
	},

	["impatience"] = {
		Indorani = "moon impatience",
		Oneiromancer = "hypercube impatience",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("impatience", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.impatience[class]
		end,
		call = "impatience",
		card = "moon",
		eclipse = 1,
	},

	["epilepsy"] = {
		Indorani = "moon epilepsy",
		Oneiromancer = "hypercube epilepsy",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("epilepsy", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.epilepsy[class]
		end,
		call = "epilepsy",
		card = "moon",
		eclipse = 1,
	},

	["berserking"] = {
		Indorani = "moon berserking",
		Oneiromancer = "hypercube berserking",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("berserking", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.berserking[class]
		end,
		call = "berserking",
		card = "moon",
		eclipse = 1,
	},

	["weariness"] = {
		Indorani = "moon weariness",
		Oneiromancer = "hypercube weariness",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("weariness", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.weariness[class]
		end,
		call = "weariness",
		card = "moon",
		eclipse = 1,
	},

	["adder_anorexia"] = {
		Indorani = "moon anorexia",
		Oneiromancer = "hypercube anorexia",
		can = function()
			local target = rime.target
			if not indo.adder_ready then return false end
			if rime.targets[target].adder ~= "slickness" then return false end
			if not rime.pvp.has_aff("impatience", target) then return false end
			if rime.pvp.has_aff("anorexia", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.adder_anorexia[class]
		end,
		call = "anorexia",
		card = "moon",
		eclipse = 1,
	},

	["adder_asthma"] = {
		Indorani = "sun asthma",
		Oneiromancer = "sun asthma",
		can = function()
			local target = rime.target
			if not indo.adder_ready then return false end
			if rime.targets[target].adder ~= "slickness" then return false end
			if not rime.pvp.has_aff("impatience", target) then return false end
			if rime.pvp.has_aff("asthma", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.adder_asthma[class]
		end,
		call = "asthma",
		card = "sun",
		eclipse = 1,
	},

	["anorexia"] = {
		Indorani = "moon anorexia",
		Oneiromancer = "hypercube anorexia",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("anorexia", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.anorexia[class]
		end,
		call = "anorexia",
		card = "moon",
		eclipse = 1,
	},

	["justice"] = {
		Indorani = "justice",
		Oneiromancer = "knight",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("justice", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.justice[class]
		end,
		call = false,
		card = "justice",
		eclipse = 0,
	},

	["lovers_effect"] = {
		Indorani = "lovers",
		Oneiromancer = "heart",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("lovers_effect", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.lovers_effect[class]
		end,
		call = false,
		card = "lovers",
		eclipse = 0,
	},

	["asleep"] = {
		Indorani = "sandman",
		Oneiromancer = "poppy",
		can = function()
			local target = rime.target
			if rime.targets[target].adder ~= "asleep" then return false end
			if not indo.can_chimera then return false end
			if not rime.pvp.has_aff("hypersomnia", target) then return false end
			if rime.pvp.has_aff("asleep", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.asleep[class]
		end,
		call = false,
		card = "sandman",
		eclipse = 0,
	},

	["adder"] = {
		Indorani = "adder venom",
		Oneiromancer = "diamond venom",
		can = function()
			local target = rime.target
			if rime.targets[target].adder then return false end
			if rime.pvp.has_aff("haemophilia", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.adder[class]
		end,
		call = false,
		card = "adder",
		eclipse = 0,
	},

	["lust"] = {
		Indorani = "lust",
		Oneiromancer = "favor",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("lusted", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.lust[class]
		end,
		call = false,
		card = "lust",
		eclipse = 0,
	},

	["left_arm_broken"] = {
		Indorani = "warrior left arm",
		Oneiromancer = "hammer left arm",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("left_arm_broken", target) then return false end
			if rime.limit[target.."left_arm_restore"] then return false end
			if not rime.pvp.canParry() then return true end
			if rime.targets[target].parry == "right_arm" then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.left_arm_broken[class]
		end,
		call = false,
		card = "warrior",
		eclipse = 0,
	},

	["left_leg_broken"] = {
		Indorani = "warrior left leg",
		Oneiromancer = "hammer left leg",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("left_leg_broken", target) then return false end
			if rime.limit[target.."left_leg_restore"] then return false end
			if not rime.pvp.canParry() then return true end
			if rime.targets[target].parry == "right_leg" then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.left_leg_broken[class]
		end,
		call = false,
		card = "warrior",
		eclipse = 0,
	},

	["right_arm_broken"] = {
		Indorani = "warrior left leg",
		Oneiromancer = "hammer left leg",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("right_arm_broken", target) then return false end
			if rime.limit[target.."right_arm_restore"] then return false end
			if not rime.pvp.canParry() then return true end
			if rime.targets[target].parry == "right_arm" then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.right_arm_broken[class]
		end,
		call = false,
		card = "warrior",
		eclipse = 0,
	},

	["right_leg_broken"] = {
		Indorani = "warrior left leg",
		Oneiromancer = "hammer left leg",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("right_leg_broken", target) then return false end
			if rime.limit[target.."right_leg_restore"] then return false end
			if not rime.pvp.canParry() then return true end
			if rime.targets[target].parry == "right_leg" then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.right_leg_broken[class]
		end,
		call = false,
		card = "warrior",
		eclipse = 0,
	},

	["haemophilia"] = {
		Indorani = "adder venom",
		Oneiromancer = "diamond venom",
		can = function()
			local target = rime.target
			if rime.targets[target].adder then return false end
			if rime.pvp.has_aff("haemophilia", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return indo.attacks.haemophilia[class]
		end,
		call = false,
		card = "adder",
		eclipse = 0,
	},

}

function indo.venom_filter()

    local target = rime.target

    for k,v in ipairs(rime.pvp.route.venoms) do
        if rime.convert_affliction(v) and not rime.pvp.has_aff(v, target) then
            return rime.convert_affliction(v)
        end
    end
end



indo.domination = indo.domination or {}

indo.domination = {

	--not really domination but whatever, just no bal attacks really.

	["gas"] = {
		"order chimera gas",
		can = function()
			local target = rime.target
			if not indo.adder_ready then return false end
			if not indo.can_chimera then return false end
			if not rime.pvp.has_aff("hypersomnia", target) then return false end
			return true
		end,
	},

	["no_deaf"] = {
		"order chimera roar",
		can = function()
			if indo.can_chimera then
				return true
			else
				return false
			end 
		end,
	},

	["stun"] = {
		"order chimera roar",
		can = function()
			if indo.can_chimera then
				return true
			else
				return false
			end 
		end,
	},

	["envelop"] = {
		"order slime envelop",
		can = function()
			local target = rime.target
			if indo.can_envelop and (rime.pvp.has_aff("scraped", target) or rime.pvp.has_aff("locked", target)) then
				return true
			else
				return false
			end
		end,
	},

	["damage"] = {
		"order chimera headbutt",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("deform", target) and indo.can_chimera then
				return true
			else
				return false
			end
		end,
	},

	["no_insomnia"] = {
		"order chimera gas",
		can = function()
			local target = rime.target
			if rime.targets[target].defences.insomnia and indo.can_chimera then
				return true
			else
				return false
			end
		end,
	},

	["hallucinate"] = {
		"order target hallucinate Bulrok suddenly seizes up, his entire body locked by paralysis.",
		can = function()
			if indo.can_soulmaster then
				return true
			else
				return false
			end
		end,
	},

	["press"] = {
		"order target apply restoration to head",
		can = function()
			local target = rime.target
			if rime.cure_set == "carnifex" then return false end
			if indo.can_soulmaster and rime.pvp.balanceCheck("poultice", target) == 0 and rime.pvp.has_aff("impatience", target) then
				return true
			else
				return false
			end
		end,
	},

	["dodge_off"] = {
		"order target dodge none",
		can = function()
			if indo.can_soulmaster and indo.soulmaster_toggle then
				return true
			else
				return false
			end
		end,
	},

	["empty_health"] = {
		"order target empty health",
		can = function()
			if indo.can_soulmater then
				return true
			else
				return false
			end
		end,
	},
}

function ignore_aff(aff)
   if aff == "leeched_aura" then return true end
   if aff == "no_deaf" then return true end
   if aff == "no_blind" then return true end
   if aff == "prone" then return true end
   if aff == "infiltration" then return true end
   if aff == "aftershock" then return true end

   return false
end

function indo.solve_wheel(aff, target)
	aff_conversion = {
		["a crippled right arm"] = "right_arm_crippled",
		["a crippled left arm"] = "left_arm_crippled",
		["a crippled left leg"] = "left_leg_crippled",
		["a crippled right leg"] = "right_leg_crippled",
		["lovers effect"] = "lovers_effect",
	}

	aff = string.gsub(aff, "and ", ", ")
    aff = string.gsub(aff, "a crippled right leg", "right_leg_crippled")
    aff = string.gsub(aff, "a crippled right arm", "right_arm_crippled")
    aff = string.gsub(aff, "a crippled left leg", "left_leg_crippled")
    aff = string.gsub(aff, "a crippled left arm", "left_arm_crippled")
    aff = string.gsub(aff, "lovers effect", "lovers_effect")
    aff = string.gsub(aff, " ", ",")
    aff = string.split(aff, ",", "\n")

	for k,v in ipairs(aff) do
		if not rime.pvp.has_aff(v, target) then
			if rime.targets[target].afflictions[v] ~= nil then
				rime.pvp.add_aff(v, target)
			end
		end
	end

end

function indo.get_dom()

	local target = rime.target
	local commands = {}
	local sep = rime.saved.separator

	if indo.can_chimera then

		for k,v in ipairs(rime.pvp.route.chimera) do
			if not rime.pvp.has_aff(v, target) and indo.domination[v].can() then
				table.insert(commands, indo.domination[v][1])
				break
			end
		end

	end

	if indo.can_envelop then
		table.insert(commands, "order slime envelop")
	end

	if rime.pvp.has_def("flight", target) then
		table.insert(commands, "order dervish act")
	end

	if rime.pvp.has_aff("deform", target) then
		table.insert(commands, "order hound kill target")
	end

	return table.concat(commands, sep)


end

function indo.pick_attack()

	local target = rime.target
	local first = false
	local second = false
	local eclipse = indo.eclipse
	local attack = "nothing"
	local web_call = ""
	local sep = rime.saved.separator
	local class = rime.status.class
	local class_command = {
		["Indorani"] = "fling",
		["Oneiromancer"] = "unfurl",
	}
	local command = class_command[class]

	for k,v in ipairs(rime.pvp.route.attacks) do
		if indo.attacks[v].can(eclipse) then
			first = v
			break
		end
	end

	eclipse = eclipse+indo.attacks[first].eclipse

	if indo.attacks[first].card and first ~= "fool" then
		for k,v in ipairs(rime.pvp.route.attacks) do
			if indo.attacks[v].card ~= indo.attacks[first].card and indo.attacks[v].can(eclipse) and not  indo.attacks[v][class]:find("creator") then
				second = v
				break
			end
		end
	end

	if rime.pvp.web_aff_calling then
		if second and indo.attacks[second].call and indo.attacks[first].call then
			web_call = rime.pvp.omniCall(indo.attacks[first].call.."/"..indo.attacks[second].call)
		elseif second and indo.attacks[second].call then
			web_call = rime.pvp.omniCall(indo.attacks[second].call)
		elseif indo.attacks[first].call then
			web_call = rime.pvp.omniCall(indo.attacks[first].call)
		end
	end

	attack = web_call

	if second then

		attack = attack .. sep ..command .. " "..indo.attacks[first].choice().." and "..indo.attacks[second].choice().." at "..rime.target

	elseif indo.attacks[first].card and first ~= "fool" then

		attack = attack .. sep .. command .. "  "..indo.attacks[first].choice().." at "..rime.target

	else

		attack = attack .. sep .. indo.attacks[first].choice()
		attack = attack:gsub("target", rime.target)

	end

	if string.find(attack, "venom") then
		attack = attack:gsub("venom", indo.venom_filter())
	end

	return attack

end

function indo.adder()

	if not indo.adder_ready then return false end

	local target = rime.target
	local target_adder = rime.targets[target].adder

	if target_adder == "asleep" then
		if indo.can_chimera and rime.pvp.has_aff("hypersomnia", target) then
			return true
		else
			return false
		end
	elseif target_adder == "slickness" then
		if rime.pvp.has_aff("impatience", target) then
			return true
		else
			return false
		end
	else
		return true
	end


end


function indo.offense()

	local main_attack = indo.pick_attack()
	local sep = rime.saved.separator
	local target = rime.target
	local command = rime.pvp.queue_handle() .. sep .. indo.get_dom()

	if not rime.pvp.has_aff("leeched_aura", target) and not rime.targets[target].leeching and not rime.pvp.has_def("shielded", target) then
		command = command .. sep .. "leech "..rime.target
	end

	if indo.adder_ready and indo.adder() then
		command = command .. sep .. "activate adder " .. target
	end

	command = command .. sep .. main_attack

	if indo.can_soulmaster then
		for k,v in ipairs(rime.pvp.route.soulmaster) do
			if indo.domination[v].can() then
				command = command .. sep .. indo.domination[v][1]
				break
			end
		end
	end

	command = command:gsub("target", rime.target)

	if command ~= rime.balance_queue and command ~= rime.balance_queue_attempted then
        act(command)
        rime.balance_queue_attempted = command
	end


end