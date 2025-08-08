execute = execute or {}

rime.pvp.Executor.routes = {

	["black"] = {

		["blurb"] = {"SeNtInEl Is BaD"},

		["attacks"] = {
			"terminate",
			"grit",
			"destroyed_throat",
			"push_left_leg_crippled",
			"prone",
			"push_right_leg_crippled",
			"shielded_reave",
			"shield_rebounding",
			"hallucinatory_hot",
			"paralytic_cold",
			"confusion",
			"combust",
			"push_slickness",
			"push_anorexia",
			"smokescreen",
			"efficiency",
			"pester_balance",
			"paresis",
			"impatience",
			"lethargy_left",
			"heartflutter",
			"clumsiness",
			"slam",
			"asthma",
			"shyness",
			"hallucinatory_stupidity",
			"hallucinatory_dizziness",
			"weariness",
			"addiction",
			"stupidity",
			"recklessness",
			"rebounding",
		}
	},

	["arms"] = {
		["blurb"] = {"Route meant for group combat. Focused on arms limb pressure"},

		["attacks"] = {
			"terminate",
			"grit",
			"prone",
			"shielded_reave",
			"shield_rebounding",
			"rebounding",
			"timed_raze",
			"dissever_left_arm",
			"dissever_right_arm",
			"rampage",
			"frozen",
			"left_arm_crippled",
			"right_arm_crippled",
			"left_leg_crippled",
			"right_leg_crippled",
			"destroyed_throat",
		},
	},

	["group"] = {
		["blurb"] = {"Route meant for group combat. Focused on afflictions and Terminate"},

		["attacks"] = {
			"effigy_initial",
			"effigy_followup",
			"terminate",
			"grit",
			"left_leg_crippled",
			"right_leg_crippled",
			"prone",
			"shielded_reave",
			"shield_rebounding",
			"timed_raze",
			"confusion",
			"push_slickness",
			"push_anorexia",
			"paresis",
			"impatience",
			"heartflutter",
			"asthma",
			"anorexia",
			"slickness",
			"clumsiness",
			"impairment",
			"lethargy_left",
			"stupidity",
			"dizziness",
			"rebounding",
		},
	},
}

execute.pets = {
	wisp = false,
	weasel = false,
	nightingale = false,
	rook = false,
	direwolf = false,
	raccoon = false,
	elk = false,
	gyrfalcon = false,
	raloth = false,
	crocodile = false,
	icewyrm = false,
	cockatrice = false,
}

execute.cycles = {

	["flammable"] = 12, --executor
	["pyrolum"] = 12, --sentinel
	["coagulating"] = 8, --executor
	["corsin"] = 8, --sentinel
	["hallucinatory"] = 9, --executor
	["trientia"] = 9, --sentinel
	["adhesive"] = 14, --executor
	["harimel"] = 14, --sentinel
	["choking"] = 10, --executor
	["glauxe"] = 10, --sentinel
	["septic"] = 8, --executor
	["badulem"] = 8, --sentinel
	["paralytic"] = 6, --executor
	["lysirine"] = 6, --sentinel

}

execute.cooldowns = {
	inspirit = false,
	vitality = false,
}

execute.traps = {
	set = false,
	spike = false,
	darts = {},
}

function execute.count_pets()

	local count = 0
	local companions = {}

	for k,v in pairs(execute.pets) do
		if execute.pets[k] then
			count = count+1
			table.insert(companions, k)
		end
	end

	if count > 4 then
		rime.echo("lmao rime can't count")
	elseif count == 0 then
		rime.echo("You haven't summoned anything dummy")
	elseif count < 4 and count ~= 0 then
		local missing = 4-count
		rime.echo("You have "..count.." companions summoned. You can summon "..missing.." more. List: "..table.concat(companions, ", "))
	elseif count == 4 then
		rime.echo("You have the maximum amount of companions summoned. List: "..table.concat(companions, ", "))
	end

end

execute.initials = {

	["fuck_you"] = {
		Sentinel = "dhuriv slash target curare",
		can = function()
			local target = rime.target
			--we'll come back to this
		end,
	},

	["effigy_initial"] = {
		Executor = "ringblade phlebotomise effigy",
		Sentinel = "dhuriv crosscut effigy",
		can = function()
			local target = rime.target
			if not rime.pvp.has_def("dome", target) then return false end
			if not rime.targets[target].effigy then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.effigy_initial[class]
		end,
		combo = true,
		call = false,
		affliction = "none",
	},

	["rampage"] = {
		Executor = "order brutaliser rampage target",
		Sentinel = "order raloth trample target",
		can = function()
			local pets = {"brutaliser", "raloth"}
			local target = rime.target
			if not rime.pvp.has_aff("prone", target) then return false end
			local rampage_affs = {"left_leg_crippled", "right_leg_crippled", "left_arm_crippled", "right_arm_crippled", "cracked_ribs", "crippled_throat"}
			local rampage_count = 0
			local found_one = false
			for k,v in ipairs(pets) do
				if execute.pets[v] then
					found_one = true
					break
				end
			end
			for k,v in ipairs(rampage_affs) do
				if rime.pvp.has_aff(v, target) then
					rampage_count = rampage_count+1
				end
			end
			if rampage_count >= 4 then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.rampage[class]
		end,
		combo = false,
		call = false,
		affliction = "none",
	},

	["frozen"] = {
		Executor = "order rimestalker verglas target",
		Sentinel = "order icewyrm icebreath target",
		can = function()
			local pets = {"rimestalker", "icewyrm"}
			local target = rime.target
			if rime.pvp.has_aff("frozen", target) then return false end
			local found_one = false
			for k,v in ipairs(pets) do
				if execute.pets[v] then
					found_one = true
					break
				end
			end
			if not found_one then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.frozen[class]
		end,
		combo = true,
		call = false,
		affliction = "frozen",
	},

	["smokescreen"] = {
		Executor = "lay smokescreen here",
		Sentinel = "lay smokescreen here",
		can = function()
			if not has_def("efficiency") then return false end
			if execute.traps.set then return false end
			local smoke_classes = {"carnifex", "praenomen", "templar", "sentinel", "zealot", "monk", "infiltrator", "bard", "indorani", "luminary"}
			local found_one = false
			for k,v in ipairs(smoke_classes) do
				if rime.cure_set == v then
					found_one = true
					break
				end
			end
			if not found_one then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.smokescreen[class]
		end,
		combo = false,
		call = false,
		affliction = "none",
	},

	["spike"] = {
		Executor = "lay spike here",
		Sentinel = "lay spike here",
		can = function()
			if not has_def("efficiency") then return false end
			if execute.traps.set then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.spike[class]
		end,
		combo = false,
		call = false,
		affliction = "none",
	},

	["efficiency"] = {
		Executor = "efficiency",
		Sentinel = "alacrity",
		can = function()
			if has_def("alacrity") or has_def("efficiency") then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.efficiency[class]
		end,
		combo = false,
		call = false,
		affliction = "none",
	},

	["pester_balance"] = {
		Executor = "order murder pester target",
		Sentinel = "order rook swoop target",
		can = function()
			local pets = {"murder", "rook"}
			local found_one = false
			for k,v in ipairs(pets) do
				if execute.pets[v] then
					found_one = true
				end
			end
			if not found_one then return false end
			local aff_count = 0
			for k,v in ipairs(rime.curing.affsByType.renew) do
				if rime.has_aff(v) then
					aff_count = aff_count+1
				end
			end
			if aff_count <= 3 then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.pester_balance[class]
		end,
		combo = true,
		call = false,
		affliction = "none",
	},

	["prone"] = {
		Executor = "ringblade gambol target",
		Sentinel = "dhuriv trip target",
		can = function()
			local target = rime.target
			if not rime.pvp.has_aff("asthma", target) then return false end
			if not rime.pvp.has_aff("slickness", target) then return false end
			if not (rime.pvp.has_aff("anorexia", target) or rime.pvp.has_aff("destroyed_throat")) then return false end
			if rime.pvp.has_aff("prone", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.prone[class]
		end,
		combo = true,
		call = false,
		affliction = "sit down bitch, be humble",
	},

	["grit"] = {
		Executor = "grit",
		Sentinel = "might",
		can = function()
			if not rime.curing.class then return false end
			local aff_count = 0
			for k,v in ipairs(rime.curing.affsByType.renew) do
				if rime.has_aff(v) then
					aff_count = aff_count+1
				end
			end
			if aff_count >= 2 then return true end
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.grit[class]
		end,
		combo = false,
		call = false,
		affliction = "lmao",
	},

	["rebounding"] = {
		Executor = "ringblade shave target",
		Sentinel = "dhuriv reave target",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return true end
			return false
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.rebounding[class]
		end,
		combo = true,
		call = false,
		affliction = "raze",
	},

	["timed_raze"] = {
		Executor = "ringblade shave target",
		Sentinel = "dhuriv reave target",
		can = function()
			local target = rime.target
			local gate = rime.pvp.get_gate()
			local rebounding = rime.getTimeLeft("rebounding", target)
			local difference = rebounding-gate
			if rebounding == 0 then return false end
			if difference < 1 then return true end
			return false
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.timed_raze[class]
		end,
		combo = true,
		call = false,
		affliction = "raze",
	},

	["shielded_reave"] = {
		Executor = "ringblade shave target",
		Sentinel = "dhuriv reave target",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_def("shielded", target) then return true end
			return false
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.shielded_reave[class]
		end,
		combo = true,
		call = false,
		affliction = "raze",
	},

	["shield_rebounding"] = {
		Executor = "ringblade twinraze target",
		Sentinel = "dhuriv dualraze target",
		can = function()
			local target = rime.target
			if not rime.pvp.has_def("shielded", target) then return false end
			if not rime.pvp.has_def("rebounding", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.shield_rebounding[class]
		end,
		combo = false,
		call = false,
		affliction = "fuck you",
	},

	["destroyed_throat"] = {
		Executor = "ringblade stifle target",
		Sentinel = "dhuriv throatcrush target",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("destroyed_throat", target) then return false end
			local parry_stop = {"paresis", "paralysis", "frozen"}
			local found_one = false
			for k,v in ipairs(parry_stop) do
				if rime.pvp.has_aff(v, target) then
					found_one = true
					break
				end
			end
			if not found_one then return false end
			if not rime.pvp.has_aff("asthma", target) then return false end
			if not rime.pvp.has_aff("slickness", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.destroyed_throat[class]
		end,
		combo = false,
		call = false,
		affliction = "destroyed_throat",
	},

	["stun_stifle"] = {
		Executor = "ringblade stifle target",
		Sentinel = "dhuriv throatcrush target",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			local stun = rime.getTimeLeft("stun", target)
			if stun == 0 then return false end
			local gate = rime.pvp.get_gate()+1.86
			if stun < gate then return false end
			if rime.pvp.has_aff("destroyed_throat", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.stun_stifle[class]
		end,
		combo = false,
		call = false,
		affliction = "destroyed_throat",
	},

	["stun_asthma"] = {
		Executor = "ringblade contrive target kalmia",
		Sentinel = "dhuriv slash target kalmia",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if not rime.pvp.has_aff("destroyed_throat", target) then return false end
			local stun = rime.getTimeLeft("stun", target)
			if stun == 0 then return false end
			local gate = rime.pvp.get_gate()
			if stun < gate then return false end
			if rime.pvp.has_aff("asthma", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.stun_asthma[class]
		end,
		combo = true,
		call = "kalmia",
		affliction = "asthma",
	},

	["stun_slickness"] = {
		Executor = "ringblade contrive target gecko",
		Sentinel = "dhuriv slash target gecko",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if not rime.pvp.has_aff("destroyed_throat", target) then return false end
			local stun = rime.getTimeLeft("stun", target)
			if stun == 0 then return false end
			local gate = rime.pvp.get_gate()
			if stun < gate then return false end
			if rime.pvp.has_aff("slickness", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.stun_slickness[class]
		end,
		combo = true,
		call = "gecko",
		affliction = "slickness",
	},

	["push_destroyed_throat"] = {
		Executor = "ringblade stifle target",
		Sentinel = "dhuriv throatcrush target",
		can = function()
			local target = rime.target
			local gate = rime.pvp.get_gate()+1.86
			if rime.pvp.has_def("rebounding", target) then return false end
			local restoration = rime.getTimeLeft("restoration", target)
			if gate > restoration then return false end
			if rime.pvp.has_aff("destroyed_throat", target) then return false end
			if rime.pvp.canParry(target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.push_destroyed_throat[class]
		end,
		combo = false,
		call = false,
		affliction = "destroyed_throat",
	},

	["terminate"] = {
		Executor = "ringblade terminate target",
		Sentinel = "dhuriv spinecut target",
		can = function()
			local target = rime.target
			if not rime.pvp.has_aff("confusion", target) then return false end
			if not rime.pvp.has_aff("prone", target) then return false end
			if not rime.pvp.has_aff("heartflutter", target) then return false end
			if not rime.pvp.has_aff("left_leg_crippled", target) then return false end
			if not rime.pvp.has_aff("right_leg_crippled", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.terminate[class]
		end,
		combo = false,
		call = false,
		affliction = "mfker dead dude wdym affliction",
	},

	["incise_left_leg"] = {
		Executor = "ringblade incise target left",
		Sentinel = "dhuriv pierce target left",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("left_leg_broken", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.incise_left_leg[class]
		end,
		combo = false,
		call = false,
		affliction = "left_leg_broken",
	},

	["incise_right_leg"] = {
		Executor = "ringblade incise target right",
		Sentinel = "dhuriv pierce target right",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("right_leg_broken", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.incise_right_leg[class]
		end,
		combo = false,
		call = false,
		affliction = "right_leg_broken",
	},

	["dissever_left_arm"] = {
		Executor = "ringblade dissever target left",
		Sentinel = "dhuriv sever target left",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("left_arm_broken", target) then return false end
			if not rime.pvp.has_aff("left_arm_crippled", target) then return false end
			if not rime.pvp.has_aff("right_arm_crippled", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.dissever_left_arm[class]
		end,
		combo = false,
		call = false,
		affliction = "left_arm_broken",
	},

	["dissever_right_arm"] = {
		Executor = "ringblade dissever target right",
		Sentinel = "dhuriv sever target right",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("right_arm_damaged", target) then return false end
			if not rime.pvp.has_aff("right_arm_crippled", target) then return false end
			if not rime.pvp.has_aff("left_arm_crippled", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.dissever_right_arm[class]
		end,
		combo = false,
		call = false,
		affliction = "right_arm_broken",
	},

	["no_blind"] = {
		Executor = "ringblade ploy target",
		Sentinel = "dhuriv blind target",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("no_blind", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.no_blind[class]
		end,
		combo = true,
		call = false,
		affliction = "no_blind",
	},

	["blurry_vision"] = {
		Executor = "ringblade ploy target",
		Sentinel = "dhuriv blind target",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("blurry_vision", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.blurry_vision[class]
		end,
		combo = true,
		call = false,
		affliction = "blurry_vision",
	},

	["confusion"] = {
		Executor = "ringblade ruse target",
		Sentinel = "dhuriv twirl target",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("confusion", target) then return false end
			if not rime.pvp.has_aff("impatience", target) then return false end
			if not rime.pvp.has_aff("asthma", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.confusion[class]
		end,
		combo = true,
		call = false,
		affliction = "confusion",
	},

	["push_confusion"] = {
		Executor = "ringblade ruse target",
		Sentinel = "dhuriv twirl target",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("confusion", target) then return false end
			if not rime.pvp.has_aff("impatience", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.confusion[class]
		end,
		combo = true,
		call = false,
		affliction = "confusion",
	},

	["just_confusion"] = {
		Executor = "ringblade ruse target",
		Sentinel = "dhuriv twirl target",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("confusion", target) then return false end
			if rime.pvp.has_aff("left_leg_crippled", target) and
				rime.pvp.has_aff("right_leg_crippled", target) and
				rime.pvp.has_aff("slickness", target) and
				rime.pvp.has_aff("anorexia", target) and
				rime.pvp.has_aff("impatience", target) then return true end
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.just_confusion[class]
		end,
		combo = false,
		call = false,
		affliction = "confusion",
	},

	["impairment"] = {
		Executor = "ringblade phlebotomise target",
		Sentinel = "dhuriv crosscut target",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("impairment", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.impairment[class]
		end,
		combo = true,
		call = false,
		affliction = "impairment",
	},

	["addiction"] = {
		Executor = "ringblade phlebotomise target",
		Sentinel = "dhuriv crosscut target",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("addiction", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.addiction[class]
		end,
		combo = true,
		call = false,
		affliction = "addiction",
	},

	["lethargy_left"] = {
		Executor = "ringblade impair target left leg",
		Sentinel = "dhuriv weaken target left leg",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("lethargy", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.lethargy_left[class]
		end,
		combo = true,
		call = false,
		affliction = "lethargy",
	},

	["lethargy_right"] = {
		Executor = "ringblade impair target right leg",
		Sentinel = "dhuriv weaken target right leg",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("lethargy", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.lethargy_right[class]
		end,
		combo = true,
		call = false,
		affliction = "lethargy",
	},

	["fallen"] = {
		Executor = "ringblade gambol target",
		Sentinel = "dhuriv trip target",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("prone", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.fallen[class]
		end,
		combo = true,
		call = false,
		affliction = "prone",
	},

	["slam"] = {
		Executor = "ringblade perplex target",
		Sentinel = "dhuriv slam target",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("laxity", target) then return false end
			if rime.pvp.canParry(target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.slam[class]
		end,
		combo = true,
		call = false,
		affliction = "laxity",
	},

	["claustrophobia"] = {
		Executor = "order darkhound accost target",
		Sentinel = "order direwolf daunt target",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			local pets = {"direwolf", "darkhound"}
			local found_one = false
			for k,v in ipairs(pets) do
				if execute.pets[v] then
					found_one = true
				end
			end
			if not found_one then return false end
			if not rime.pvp.has_aff("impatience", target) then return false end
			if rime.pvp.has_aff("claustrophobia", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.claustrophobia[class]
		end,
		combo = true,
		call = false,
		affliction = "claustrophobia",
	},

	["agoraphobia"] = {
		Executor = "order brutaliser accost target",
		Sentinel = "order raloth daunt target",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			local pets = {"raloth", "brutaliser"}
			local found_one = false
			for k,v in ipairs(pets) do
				if execute.pets[v] then
					found_one = true
				end
			end
			if not found_one then return false end
			if not rime.pvp.has_aff("impatience", target) then return false end
			if rime.pvp.has_aff("agoraphobia", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.agoraphobia[class]
		end,
		combo = true,
		call = false,
		affliction = "agoraphobia",
	},

	["loneliness"] = {
		Executor = "order eviscerator accost target",
		Sentinel = "order crocodile daunt target",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			local pets = {"eviscerator", "crocodile"}
			local found_one = false
			for k,v in ipairs(pets) do
				if execute.pets[v] then
					found_one = true
				end
			end
			if not found_one then return false end
			if not rime.pvp.has_aff("impatience", target) then return false end
			if rime.pvp.has_aff("loneliness", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.loneliness[class]
		end,
		combo = true,
		call = false,
		affliction = "loneliness",
	},

	["berserking"] = {
		Executor = "order terrifier accost target",
		Sentinel = "order cockatrice daunt target",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			local pets = {"terrifier", "cockatrice"}
			local found_one = false
			for k,v in ipairs(pets) do
				if execute.pets[v] then
					found_one = true
				end
			end
			if not found_one then return false end
			if not rime.pvp.has_aff("impatience", target) then return false end
			if rime.pvp.has_aff("berserking", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.berserking[class]
		end,
		combo = true,
		call = false,
		affliction = "berserking",
	},

	["flammable_cold"] = {
		Executor = "toxin splatter flammable at target",
		Sentinel = "resin hurl pyrolum at target",
		can = function()
			local target = rime.target
			if rime.limit.resin then return false end
			if rime.targets[target].coldburn == "pyrolum" or rime.targets[target].coldburn == "flammable" then return false end
			if rime.targets[target].combusted then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.flammable_cold[class]
		end,
		combo = false,
		call = false,
		affliction = "coldburn",
	},

	["flammable_hot"] = {
		Executor = "toxin splatter flammable at target",
		Sentinel = "resin hurl pyrolum at target",
		can = function()
			local target = rime.target
			if rime.limit.resin then return false end
			if rime.targets[target].hotburn == "pyrolum" or rime.targets[target].hotburn == "flammable" then return false end
			if rime.targets[target].combusted then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.flammable_hot[class]
		end,
		combo = false,
		call = false,
		affliction = "coldburn",
	},

	["paralytic_cold"] = {
		Executor = "toxin splatter paralytic at target",
		Sentinel = "resin hurl lysirine at target",
		can = function()
			local target = rime.target
			if rime.limit.resin then return false end
			if rime.targets[target].coldburn == "lysirine" or rime.targets[target].coldburn == "paralytic" then return false end
			if rime.targets[target].combusted then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.paralytic_cold[class]
		end,
		combo = false,
		call = false,
		affliction = "coldburn",
	},

	["paralytic_hot"] = {
		Executor = "toxin splatter paralytic at target",
		Sentinel = "resin hurl lysirine at target",
		can = function()
			local target = rime.target
			if rime.limit.resin then return false end
			if rime.targets[target].hotburn == "lysirine" or rime.targets[target].hotburn == "paralytic" then return false end
			if rime.targets[target].combusted then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.lysirine_cold[class]
		end,
		combo = false,
		call = false,
		affliction = "coldburn",
	},

	["hallucinatory_hot"] = {
		Executor = "toxin splatter hallucinatory at target",
		Sentinel = "resin hurl trientia at target",
		can = function()
			local target = rime.target
			if rime.limit.resin then return false end
			if rime.targets[target].combusted then return false end
			if rime.targets[target].hotburn == "trientia" or rime.targets[target].hotburn == "hallucinatory" then return false end
			--if rime.targets[target].coldburn == "trientia" or rime.targets[target].coldburn == "hallucinatory" then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.hallucinatory_hot[class]
		end,
		combo = false,
		call = false,
		affliction = "hotburn",
	},

	["hallucinatory_cold"] = {
		Executor = "toxin splatter hallucinatory at target",
		Sentinel = "resin hurl trientia at target",
		can = function()
			local target = rime.target
			if rime.limit.resin then return false end
			if rime.targets[target].combusted then return false end
			--if rime.targets[target].hotburn == "trientia" or rime.targets[target].hotburn == "hallucinatory" then return false end
			if rime.targets[target].coldburn == "trientia" or rime.targets[target].coldburn == "hallucinatory" then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.hallucinatory_cold[class]
		end,
		combo = false,
		call = false,
		affliction = "hotburn",
	},

	["hallucinatory_kindle"] = {
		Executor = "toxin kindle target",
		Sentinel = "resin combust target",
		can = function()
			local target = rime.target
			if rime.targets[target].hotburn ~= "hallucinatory" and rime.targets[target].hotburn ~= "trientia" then return false end
			local coldburn = rime.targets[target].coldburn --shortern coldburn reference
			local cycles_left = execute.cycles[coldburn]-rime.targets[target].coldburn_cycle
			if cycles_left > 3 then return false end
			if cycles_left == 0 then return false end
			local gate = rime.pvp.get_gate() --time left on current attack
			local combo = 3.72 --time of combust and destroyed throat together - do I even need this??
			local toxin = rime.getTimeLeft("toxin_cycle", target) --time left until cycle ticks
			local euphoriant_found = 0
			local stun_multiplier = 1
			local euphoriant_affs = {"selfpity", "stupidity", "dizziness", "faintness", "shyness", "epilepsy", "impatience", "dissonance"}
			if rime.pvp.has_aff("impairment", target) then stun_multiplier = 1.5 end
			for k,v in ipairs(euphoriant_affs) do
  				if rime.pvp.has_aff(v, target) then
    				euphoriant_found = euphoriant_found+1
  				end
			end
			local stun_time = euphoriant_found*stun_multiplier
			if gate > toxin then return false end
			if stun_time < 3 then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.hallucinatory_kindle[class]
		end,
		combo = true,
		call = false,
		affliction = "kindle",
	},

	["combust"] = {
		Executor = "toxin kindle target",
		Sentinel = "resin combust target",
		can = function()
			local target = rime.target
			if not rime.targets[target].hotburn then return false end
			if not rime.targets[target].coldburn then return false end
			if rime.targets[target].combusted then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.combust[class]
		end,
		combo = "brandish",
		call = false,
		affliction = "combust",
	},

	["paresis"] = {
		Executor = "ringblade contrive target curare",
		Sentinel = "dhuriv slash target curare",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("paresis", target) then return false end
			if rime.pvp.has_aff("paralysis", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.paresis[class]
		end,
		combo = true,
		call = "curare",
		affliction = "paresis",
	},

	["clumsiness"] = {
		Executor = "ringblade contrive target xentio",
		Sentinel = "dhuriv slash target xentio",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("clumsiness", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.clumsiness[class]
		end,
		combo = true,
		call = "clumsiness",
		affliction = "clumsiness",
	},

	["asthma"] = {
		Executor = "ringblade contrive target kalmia",
		Sentinel = "dhuriv slash target kalmia",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("asthma", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.asthma[class]
		end,
		combo = true,
		call = "asthma",
		affliction = "asthma",
	},

	["weariness"] = {
		Executor = "ringblade contrive target vernalius",
		Sentinel = "dhuriv slash target vernalius",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("weariness", target) then return false end
			if not rime.pvp.has_aff("impatience", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.weariness[class]
		end,
		combo = true,
		call = "weariness",
		affliction = "weariness",
	},

	["allergies"] = {
		Executor = "ringblade contrive target darkshade",
		Sentinel = "dhuriv slash target darkshade",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("allergies", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.allergies[class]
		end,
		combo = true,
		call = "darkshade",
		affliction = "allergies",
	},

	["left_leg_crippled"] = {
		Executor = "ringblade contrive target epseth",
		Sentinel = "dhuriv slash target epseth",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("left_leg_crippled", target) then return false end
			if not rime.pvp.has_aff("slickness", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.left_leg_crippled[class]
		end,
		combo = true,
		call = "epseth",
		affliction = "left_leg_crippled",
	},

	["left_arm_crippled"] = {
		Executor = "ringblade contrive target epteth",
		Sentinel = "dhuriv slash target epteth",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("left_arm_crippled", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.left_arm_crippled[class]
		end,
		combo = true,
		call = "epteth",
		affliction = "left_arm_crippled",
	},

	["right_arm_crippled"] = {
		Executor = "ringblade contrive target epteth",
		Sentinel = "dhuriv slash target epteth",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("right_arm_crippled", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.right_arm_crippled[class]
		end,
		combo = true,
		call = "epteth",
		affliction = "right_arm_crippled",
	},

	["push_slickness"] = {
		Executor = "ringblade contrive target gecko",
		Sentinel = "dhuriv slash target gecko",
		can = function()
			local target = rime.target
			local tree = rime.getTimeLeft("tree", target)
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("slickness", target) then return false end
			if rime.pvp.has_aff("asthma", target) and rime.pvp.has_aff("impatience", target) then return true end
			return false
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.push_slickness[class]
		end,
		combo = true,
		call = "gecko",
		affliction = "push_slickness",
	},

	["slickness"] = {
		Executor = "ringblade contrive target gecko",
		Sentinel = "dhuriv slash target gecko",
		can = function()
			local target = rime.target
			local tree = rime.getTimeLeft("tree", target)
			if rime.pvp.has_aff("slickness", target) then return false end
			--if rime.pvp.has_aff("asthma", target) then return true end
			return false
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.slickness[class]
		end,
		combo = true,
		call = "gecko",
		affliction = "slickness",
	},

	["hallucinatory_stupidity"] = {
		Executor = "ringblade contrive target aconite",
		Sentinel = "dhuriv slash target aconite",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("stupidity", target) then return false end
			if not rime.targets[target].combusted then return false end
			if not rime.pvp.has_aff("impatience", target) then return false end
			if rime.targets[target].hotburn ~= "trientia" and rime.targets[target].hotburn ~= "hallucinatory" then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.hallucinatory_stupidity[class]
		end,
		combo = true,
		call = "aconite",
		affliction = "stupidity",
	},

	["hallucinatory_dizziness"] = {
		Executor = "ringblade contrive target larkspur",
		Sentinel = "dhuriv slash target larkspur",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("dizziness", target) then return false end
			if not rime.targets[target].combusted then return false end
			if not rime.pvp.has_aff("impatience", target) then return false end
			if rime.targets[target].hotburn ~= "trientia" and rime.targets[target].hotburn ~= "hallucinatory" then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.hallucinatory_dizziness[class]
		end,
		combo = true,
		call = "larkspur",
		affliction = "dizziness",
	},

	["shyness"] = {
		Executor = "ringblade contrive target digitalis",
		Sentinel = "dhuriv slash target digitalis",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("shyness", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.shyness[class]
		end,
		combo = true,
		call = "digitalis",
		affliction = "shyness",
	},

	["haemophilia"] = {
		Executor = "ringblade contrive target hepafarin",
		Sentinel = "dhuriv slash target hepafarin",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("haemophilia", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.haemophilia[class]
		end,
		combo = true,
		call = "hepafarin",
		affliction = "haemophilia",
	},

	["sensitivity"] = {
		Executor = "ringblade contrive target prefarar",
		Sentinel = "dhuriv slash target prefarar",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("sensitivity", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.initials.sensitivity[class]
		end,
		combo = true,
		call = "prefarar",
		affliction = "sensitivity",
	},


}

execute.followups = {

	["effigy_followup"] = {
		Executor = "ringblade inveigle effigy",
		Sentinel = "dhuriv thrust effigy",
		can = function()
			local target = rime.target
			if not rime.pvp.has_def("dome", target) then return false end
			if not rime.targets[target].effigy then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.followups.effigy_followup[class]
		end,
		call = false,
		affliction = "damage",
	},

	["stun_asthma"] = {
		Executor = "ringblade beguile target kalmia",
		Sentinel = "dhuriv stab target kalmia",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if not rime.pvp.has_aff("destroyed_throat", target) then return false end
			local stun = rime.getTimeLeft("stun", target)
			if stun == 0 then return false end
			local gate = rime.pvp.get_gate()
			if stun < gate then return false end
			if rime.pvp.has_aff("asthma", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.followups.stun_asthma[class]
		end,
		call = "kalmia",
		affliction = "asthma",
	},

	["stun_slickness"] = {
		Executor = "ringblade beguile target gecko",
		Sentinel = "dhuriv stab target gecko",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if not rime.pvp.has_aff("destroyed_throat", target) then return false end
			local stun = rime.getTimeLeft("stun", target)
			if stun == 0 then return false end
			local gate = rime.pvp.get_gate()
			if stun < gate then return false end
			if rime.pvp.has_aff("slickness", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.followups.stun_slickness[class]
		end,
		call = "gecko",
		affliction = "slickness",
	},

	["haemophilia"] = {
		Executor = "pickringblade target hepafarin",
		Sentinel = "dhuriv slash target hepafarin",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("haemophilia", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.followups.haemophilia[class]
		end,
		call = "hepafarin",
		affliction = "haemophilia",
	},

	["sensitivity"] = {
		Executor = "pickringblade target prefarar",
		Sentinel = "dhuriv slash target prefarar",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("sensitivity", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.followups.sensitivity[class]
		end,
		call = "prefarar",
		affliction = "sensitivity",
	},

	["impatience"] = {
		Executor = "ringblade muddle target",
		Sentinel = "dhuriv gouge target",
		can = function()
			local target = rime.target
			local gate = rime.pvp.get_gate()
			local dodge = rime.getTimeLeft("dodge", target)
			if dodge == 0 then return false end
			if gate > dodge then return false end
			if rime.pvp.has_aff("impatience", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.followups.impatience[class]
		end,
		call = false,
		affliction = "impatience",
	},

	["push_heartflutter"] = {
		Executor = "ringblade desolate target",
		Sentinel = "dhuriv heartbreaker target",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("heartflutter", target) then return false end
			if not rime.pvp.has_aff("destroyed_throat") then return false end
			if not rime.pvp.has_aff("asthma", target) then return false end
			if not rime.pvp.has_aff("slickness", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.followups.heartflutter[class]
		end,
		call = false,
		affliction  = "heartflutter",
	},


	["heartflutter"] = {
		Executor = "ringblade desolate target",
		Sentinel = "dhuriv heartbreaker target",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("heartflutter", target) then return false end
			local dodge = rime.getTimeLeft("dodge", target)
			if dodge == 0 then return false end
			if gate > dodge then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.followups.heartflutter[class]
		end,
		call = false,
		affliction  = "heartflutter",
	},

	["stupidity"] = {
		Executor = "pickringblade target aconite",
		Sentinel = "dhuriv thrust target aconite",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("stupidity", target) then return false end
			if not rime.pvp.has_aff("impatience", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.followups.stupidity[class]
		end,
		call = "aconite",
		affliction = "stupidity"
	},

	["clumsiness"] = {
		Executor = "pickringblade target xentio",
		Sentinel = "dhuriv thrust target xentio",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("clumsiness", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.followups.clumsiness[class]
		end,
		call = "xentio",
		affliction = "clumsiness",
	},

	["weariness"] = {
		Executor = "pickringblade target vernalius",
		Sentinel = "dhuriv thrust target vernalius",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("weariness", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.followups.weariness[class]
		end,
		call = "vernalius",
		affliction = "weariness",
	},

	["asthma"] = {
		Executor = "pickringblade target kalmia",
		Sentinel = "dhuriv thrust target kalmia",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("asthma", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.followups.asthma[class]
		end,
		call = "kalmia",
		affliction = "asthma",
	},

	["slickness"] = {
		Executor = "ringblade beguile target gecko",
		Sentinel = "dhuriv stab target gecko",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("slickness", target) then return false end
			if not rime.pvp.has_aff("asthma", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.followups.slickness[class]
		end,
		call = "gecko",
		affliction = "asthma",
	},

	["push_anorexia"] = {
		Executor = "ringblade beguile target slike",
		Sentinel = "dhuriv stab target slike",
		can = function()
			local target = rime.target
			local initial, combo, call, init_aff = execute.get_initial()
			if rime.pvp.has_aff("anorexia", target) then return false end
			if init_aff == "push_slickness" then return true end
			return false
		end,
		choice = function()
			local class = rime.status.class
			return execute.followups.anorexia[class]
		end,
		call = "slike",
		affliction = "anorexia",
	},

	["anorexia"] = {
		Executor = "ringblade beguile target slike",
		Sentinel = "dhuriv stab target slike",
		can = function()
			local target = rime.target
			local tree = rime.getTimeLeft("tree", target)
			if rime.pvp.has_aff("anorexia", target) then return false end
			--[[if rime.pvp.has_aff("asthma", target)
				and tree > 2
				and rime.pvp.has_aff("impatience", target) then return true end
			if not rime.pvp.has_aff("slickness", target) then return false end]]
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.followups.anorexia[class]
		end,
		call = "slike",
		affliction = "anorexia",
	},

	["push_right_leg_crippled"] = {
		Executor = "ringblade beguile target epseth",
		Sentinel = "dhuriv stab target epseth",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("right_leg_crippled", target) then return false end
			if not rime.pvp.has_aff("slickness", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.followups.push_right_leg_crippled[class]
		end,
		call = "epseth",
		affliction = "right_leg_crippled",
	},

	["push_left_leg_crippled"] = {
		Executor = "pickringblade target epseth",
		Sentinel = "dhuriv stab target epseth",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("left_leg_crippled", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.followups.push_left_leg_crippled[class]
		end,
		call = "epseth",
		affliction = "right_leg_crippled",
	},

	["right_leg_crippled"] = {
		Executor = "pickringblade target epseth",
		Sentinel = "dhuriv stab target epseth",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("right_leg_crippled", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.followups.right_leg_crippled[class]
		end,
		call = "epseth",
		affliction = "right_leg_crippled",
	},

	["left_leg_crippled"] = {
		Executor = "pickringblade target epseth",
		Sentinel = "dhuriv stab target epseth",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("left_leg_crippled", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.followups.left_leg_crippled[class]
		end,
		call = "epseth",
		affliction = "right_leg_crippled",
	},

	["left_arm_crippled"] = {
		Executor = "pickringblade target epteth",
		Sentinel = "dhuriv slash target epteth",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("left_arm_crippled", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.followups.left_arm_crippled[class]
		end,
		call = "epteth",
		affliction = "left_arm_crippled",
	},

	["right_arm_crippled"] = {
		Executor = "pickringblade target epteth",
		Sentinel = "dhuriv slash target epteth",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("right_arm_crippled", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.followups.right_arm_crippled[class]
		end,
		call = "epteth",
		affliction = "right_arm_crippled",
	},

	["paresis"] = {
		Executor = "pickringblade target curare",
		Sentinel = "dhuriv stab target curare",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("paresis", target) then return false end
			if rime.pvp.has_aff("paralysis", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.followups.paresis[class]
		end,
		call = "curare",
		affliction = "paresis",
	},

	["recklessness"] = {
		Executor = "pickringblade target eurypteria",
		Sentinel = "dhuriv stab target eurypteria",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("recklessness", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.followups.recklessness[class]
		end,
		call = "eurypteria",
		affliction = "recklessness"
	},

	["shyness"] = {
		Executor = "pickringblade target digitalis",
		Sentinel = "dhuriv thrust target digitalis",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("shyness", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return execute.followups.shyness[class]
		end,
		call = "digitalis",
		affliction = "shyness",
	}

}

function execute.pick_followup(target)

	if not target then target = rime.target end
	local initial, combo, call, init_aff = execute.get_initial()
	local dodge = rime.getTimeLeft("dodge", target)
	local gate = rime.pvp.get_gate()
	local found_one = false
	local brandish_finds = {"accost", "kindle", "pester", "verglas"}
	for k,v in ipairs(brandish_finds) do
		if string.find(initial, v) then
			found_one = true
			break
		end
	end

	if found_one then
		return "ringblade brandish"
	elseif rime.pvp.has_aff("heartflutter", target) and not rime.pvp.has_def("rebounding", target) and gate < dodge then
		return "ringblade inveigle"
	elseif rime.pvp.has_aff("haemophilia", target) and not rime.pvp.has_def("rebounding", target) and gate < dodge then
		return "ringblade wile"
	else
		return "ringblade beguile"
	end

end

function execute.get_initial()

	for k,v in ipairs(rime.pvp.route.attacks) do
		if execute.initials[v] and execute.initials[v].can() then
			return execute.initials[v].choice(), execute.initials[v].combo, execute.initials[v].call, execute.initials[v].affliction
		end
	end

end

function execute.get_followup()

	local initial, combo, call, init_aff = execute.get_initial()
	local attack_return = false

	for k,v in ipairs(rime.pvp.route.attacks) do
		if execute.followups[v] and execute.followups[v].can() and execute.followups[v].affliction ~= init_aff then
			attack_return = execute.followups[v].choice()
			if string.find(execute.followups[v].choice(), "pickringblade") then
				attack_return = execute.followups[v].choice():gsub("pickringblade", execute.pick_followup())
			end
			return attack_return, execute.followups[v].call
		end
	end

end

function execute.offense()

	local sep = rime.saved.separator
	local command = rime.pvp.queue_handle() .. sep .. "exploit"
	local target = rime.target
	local first, combo, first_call = execute.get_initial()
	local second = false
	local second_call = false
	local call = ""
	if first:find("rampage") or first:find("trample") then
		first = "quickdismount"..sep.."quickmount brutaliser"..sep..first
	end

	if combo then
		second, second_call = execute.get_followup()
	end

	if rime.pvp.targetThere and rime.pvp.web_aff_calling then
		if first_call and second_call then
			call = rime.pvp.omniCall(first_call.."/"..second_call)
		elseif first_call and not second_call then
			call = rime.pvp.omniCall(first_call)
		elseif not first_call and second_call then
			call = rime.pvp.omniCall(second_call)
		end
		command = command .. sep .. call
	end

	if combo then
		command = command .. sep .. first .. sep .. second
	else
		command = command .. sep .. first
	end

	command = command:gsub("target", target)

	act(command)

end