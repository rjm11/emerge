--Authors: Bulrok, Almol
rime.sciomancer = rime.sciomancer or {}

rime.sciomancer.needs = {
	repay = false,
	initiate = false,
	shadow_brand = false,
}
rime.sciomancer.can = {
	shadowsphere = true,
	complete = false,
	spellguard = true,
}

rime.sciomancer.orbit = {
	eyesigil = 0,

}

rime.sciomancer.reflection_charge = rime.sciomancer.reflection_charge or 3

rime.pvp.Sciomancer.routes = {

	["limbs"] = {
		["blurb"] = {"BREAK THEIR BODY"},
		["affs"] = {
			"eyesigil",
			"hew",
			"collapse",
			"consume",
			"imbue",
			"voidtrap",
			"spellguard",
			"gloom",
			"left_leg_broken",
			"right_leg_broken",
			"voidgaze",
			"rot_benign",
			"shivering",
			"paresis",
			"frozen",
			"nyctophobia",
			"clumsiness",
			"dementia",
			"paresis",	
			"left_arm_broken",
			"right_arm_broken",
			"frozen",
			"paresis",
			--"transfix",
		}
	},

	["red"] = {
		["blurb"] = {"RED WITH FEVER"},
		["affs"] = {
			"eyesigil",
			"hew",
			"consume",
			"collapse",
			"voidtrap",
			"voidgaze",
			"damage",
			"shadowbrand",
			"clumsiness",
			"vomiting",
			"paresis",
			"exhaustion",
			"confusion",
			--"transfix",
			"voidgaze",
			"confusion",
			"nyctophobia",
			"lethargy",
			"weariness",
			"dementia",
			"dizziness",
			"faintness",
		}
	},

	["white"] = {
		["blurb"] = {"FEEL THE WEIGHT OF THE WORLD COLLAPSE"},
		["affs"] = {
			"hew",
			"collapse",
			"voidtrap",
			"imbue",
			"haunt",
			"impede",
			"gloom",
			"voidgaze",
			"shadowsphere",
			"rot_benign",
			"dementia_falter",
			"clumsiness",
			"paresis",
			"vomiting",
			"dementia",
			"confusion",
			"weariness",
			"lethargy",
			"nyctophobia",

	}
},
	["blue"] = {
		["blurb"] = {"LIL GRIP HEAVY IT'S ALL GOOD"},
		["affs"] = {
			"hew",
			"consume",
			"collapse",
			"voidtrap",
			"imbue",
			"haunt",
			"impede",
			"rot_benign",
			"shadowsphere",
			"gloom",
			"voidgaze",
			"nyctophobia",
			"faintness",
			"clumsiness",
			"paresis",
			"shivering",
			"frozen",
			"confusion",
			"dizziness",
			"dissonance",
			"dementia",
			"left_leg_broken",
			"right_leg_broken",
			"weariness",
			"vomiting",
			"haemophilia",
			"exhaustion",
			"left_arm_broken",
			"right_arm_broken",
		}
	},
	
	["black"] = {
		["blurb"] = {"SHADOWS CONSUME YOU"},
		["affs"] = {
			"hew",
			"consume",
			"collapse",
			"voidtrap",
			"imbue",
			"haunt",
			"left_leg_broken",
			"right_leg_broken",
			"shadowbrand",
			"gloom",
			"voidgaze",
			"gravity",
			"shadowsphere",
			"rot_benign",
			"nyctophobia",
			"paresis",
			"confusion",
			"dizziness",
			"dementia",
			"faintness",
			"shivering",
			"frozen",
			"clumsiness",
			"weariness",
			"dizziness",
			"dementia",
			"paresis",
			"clumsiness",
			"weariness",
			"vomiting",
			"shivering",
			"haemophilia",
			"exhaustion",
		}
	}
}

scio = scio or {}

function scio.offense()


	local target = rime.target
	local sep = rime.saved.separator
	local command = rime.sciomancer.attack()
	local pre_command = rime.pvp.queue_handle()

	act(pre_command .. sep .. command)

end

function rime.sciomancer.leech()





end

function rime.sciomancer.attack()

	local attack1, cost1, aff1, attack2, cost2, aff2, attack3, cost3, aff3 = "", "", "", "", "", "", "", "", ""
		
	rime.sciomancer.debt_allowance = 4-rime.vitals.shadowprice
	
	if rime.sciomancer.can_repay() and rime.sciomancer.debt_allowance < 4 then
		rime.sciomancer.needs.repay = true
		rime.sciomancer.debt_allowance = rime.sciomancer.debt_allowance+1
	end
	
	local sep = rime.saved.separator
	local target = rime.target


	for k,v in ipairs(rime.pvp.route.affs) do
		if rime.sciomancer.attacks[v].can() and not rime.pvp.has_aff(v, target) then
			attack1, cost1, aff1 = rime.sciomancer.attacks[v].choice()
			rime.sciomancer.debt_allowance = rime.sciomancer.debt_allowance-rime.sciomancer.attacks[v].debt()
			break
		end
	end
	
	if cost1 == "free" then
	
		for k,v in ipairs(rime.pvp.route.affs) do
			if rime.sciomancer.attacks[v].can() and not rime.pvp.has_aff(v, target) and aff1 ~= v then
				attack2, cost2, aff2 = rime.sciomancer.attacks[v].choice()
				rime.sciomancer.debt_allowance = rime.sciomancer.debt_allowance-rime.sciomancer.attacks[v].debt()	
				break
			end
		end
		
	end
	
	if cost2 == "free" then
	
		for k,v in ipairs(rime.pvp.route.affs) do
			if rime.sciomancer.attacks[v].can() and not rime.pvp.has_aff(v, target) and aff1 ~= v and aff2 ~= v then
				attack3, cost3, aff3 = rime.sciomancer.attacks[v].choice()
				rime.sciomancer.debt_allowance = rime.sciomancer.debt_allowance-rime.sciomancer.attacks[v].debt()
				break
			end
		end
		
	end

	actual_attack = attack1 .. sep .. attack2 .. sep .. attack3
	actual_attack = actual_attack:gsub("target", rime.target)
	actual_attack = actual_attack:gsub(sep .. sep .. "+", sep)

	
	if rime.sciomancer.needs.repay and not string.find(actual_attack, "collapse") then
		return "order shadeling kill ".. rime.target .. sep .. "cast repay" .. sep .. actual_attack
	else
		return "order shadeling kill ".. rime.target .. sep .. actual_attack
	end

end

function rime.sciomancer.scourge_price()

	if rime.sciomancer.debt_allowance > 1 then return true end
	
	return false

end

function rime.sciomancer.ruin_check()

	local ruinAffs = {"lethargy", "clumsiness", "weariness"}
	local ruin_count = 0
	for k,v in ipairs(ruinAffs) do
		if rime.pvp.has_aff(v, rime.target) then
			ruin_count = ruin_count+1
		end
	end
	
	return ruin_count
	
end

function rime.sciomancer.can_repay()

	local hp = rime.vitals.percent_health
	
	if hp > tonumber(60) and not rime.limit.repay then
		return true
	else
		return false
	end

end

rime.sciomancer.singularity = rime.sciomancer.singularity or {}

rime.sciomancer.singularity = {
	location = "unkown",
	secured = false,
	absorb = false,
	weight = false,
	consumption = false,
	attunement = false,
	pulsar = false,
	overcharge = false,


}

rime.sciomancer.attacks = {

	["leech"] = {
		Sciomancer = "cast leech",
		Runecarver = "hex renewal",
		choice = function()
			local class = rime.status.class
			return rime.sciomancer.attacks.leech[class], "eq", "leech"
		end,
		can = function()
			local aff_count = 0
			for k,v in ipairs(rime.curing.affsByType.renew) do
				if rime.has_aff(v) then
					aff_count = aff_count+1
				end
			end
			if aff_count >= 2 then return true end
			return false
		end,
	},

	["dispel"] = {
		"cast dispel here",
		choice = function()
			return rime.sciomancer.attacks.dispel[1], "eq", "dispel"
		end,
		can = function()
			if rime.pvp.room.mirage then
				return true
			else
				return false
			end
		end,
		debt = function()
			return 0
		end,
	},

	["spellguard"] = {
		"cast spellguard",
		choice = function()
			return rime.sciomancer.attacks.spellguard[1], "eq", "spellguard"
		end,
		can = function()
			if has_def("spellguard") then return false end
			if rime.affTally >= 4 then
				return true
			else
				return false
			end
		end,
		debt = function()
			return 0
		end,
	},

	["eyesigil"] = {
		"gravity project eyesigil at ground",
		choice = function()
			return rime.sciomancer.attacks.eyesigil[1], "free", "eyesigil"
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_def("lightform", target) and rime.sciomancer.orbit.eyesigil > 0 then
				return true
			else
				return false
			end
		end,
		debt = function()
			return 0
		end,
	},

	["damage"] = {
		"cast falter target",
		"shadowprice falter target",
		choice = function()
			local target = rime.target
			if rime.pvp.has_aff("haemophilia", target) and rime.pvp.has_aff("nyctophobia", target) then
				return rime.sciomancer.attacks.damage[1], "eq", "damage"
			elseif rime.pvp.has_aff("haemophilia", target) and rime.pvp.has_aff("nyctophobia", target) and rime.sciomancer.debt_allowance > 0 or rime.sciomancer.can_repay() then
				return rime.sciomancer.attacks.damage[2], "eq", "damage"
			else
				return rime.sciomancer.attacks.damage[1], "eq", "damage"
			end
		end,
		can = function()
			return true
		end,		
		debt = function()
			if string.find(rime.sciomancer.attacks.damage.choice(), "shadowprice") then
				return 1
			else
				return 0
			end
		end
	},

	["transfix"] = {
		"cast transfix target",
		choice = function()
			return rime.sciomancer.attacks.transfix[1], "eq", "transfix"
		end,
		can = function()
			if rime.sciomancer.can.transfix then
				return true
			else
				return false
			end
		end,
		debt = function()
			return 0
		end,
	},

	["gravity"] = {
		"gravity grip target",
		choice = function()
			return rime.sciomancer.attacks.gravity[1], "eq", "paresis"
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("shadowbrand", target) and rime.pvp.has_stack("gravity", target) < 5 then
				return true
			else
				return false
			end
		end,
		debt = function()
			return 0
		end,
	},

	["shadowbrand"] = {
		"shadowprice brand target",
		choice = function()
			return rime.sciomancer.attacks.shadowbrand[1], "eq", "shadowbrand"
		end,
		can = function()
			local target = rime.target
			if rime.sciomancer.scourge_price() and rime.pvp.has_stack("gravity", target) == 5 then
				return true
			else
				return false
			end
		end,
		debt = function()
			return 1
		end
	},

	["consume"] = {
		"cast consume target",
		"shadowprice consume target",
		choice = function()
			local target = rime.target
			if rime.pvp.has_stack("gloom", target) < 2 then
				return rime.sciomancer.attacks.consume[2], "eq", "consume"
			else
				return rime.sciomancer.attacks.consume[1], "eq", "consume"
			end
		end,
		can = function()
			local target = rime.target
			if rime.vitals.shadowprice < 4 and rime.pvp.has_aff("nyctophobia", target) and rime.pvp.has_aff("prone", target) and rime.pvp.has_aff("left_leg_broken", target) and rime.pvp.has_aff("right_leg_broken", target)  then
				return true
			elseif rime.vitals.shadowprice < 4 and rime.pvp.has_aff("nyctophobia", target) and rime.pvp.has_aff("prone", target) and rime.pvp.has_aff("voidtrapped", target) then
				return true
			else
				return false
			end
		end,
		debt = function()
			if string.find(rime.sciomancer.attacks.consume.choice(), "shadowprice") then
				return 1
			else
				return 0
			end
		end
	},

	["hew"] = {
		"cast hew target",
		"shadowprice hew target",
		choice = function()
			if rime.vitals.shadowprice < 4 then
				return rime.sciomancer.attacks.hew[2], "free", "hew"
			else
				return rime.sciomancer.attacks.hew[1], "eq", "hew"
			end
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_def("shielded", target) then
				return true
			else
				return false
			end
		end,
		debt = function()
			if string.find(rime.sciomancer.attacks.hew.choice(), "shadowprice") then
				return 1
			else
				return 0
			end
		end
	},

	["collapse"] = {
		"gravity collapse initiate",
		"gravity collapse complete",
		choice = function()
			if rime.sciomancer.can.collapse then
				return rime.sciomancer.attacks.collapse[2], "eq", "killing_this_bitch"
			else
				return rime.sciomancer.attacks.collapse[1], "eq", "killing_this_bitch"
			end
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("voidtrapped", target) then
				return true
			else
				return false
			end
		end,
		debt = function()
			return 0
		end
	},

	["left_arm_13"] = {
		"gravity erupt target left arm",
		choice = function()
			return rime.sciomancer.attacks.left_arm_13[1], "eq", "left_arm_damaged"
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_stack("gravity", target) >= 3 and rime.targets[target].limbs["left_arm"] < 1300 then
				return true
			else
				return false
			end
		end,
		debt = function()
			return 0
		end
	},
	
	["right_arm_13"] = {
		"gravity erupt target right arm",
		choice = function()
			return rime.sciomancer.attacks.right_arm_13[1], "eq", "right_arm_damaged"
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_stack("gravity", target) >= 3 and rime.targets[target].limbs["right_arm"] < 1300 then
				return true
			else
				return false
			end
		end,
		debt = function()
			return 0
		end
	},
	
	["left_leg_13"] = {
		"gravity erupt target left leg",
		choice = function()
			return rime.sciomancer.attacks.left_leg_13[1], "eq", "left_leg_damaged"
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_stack("gravity", target) >= 3 and rime.targets[target].limbs["left_leg"] < 1300 then
				return true
			else
				return false
			end
		end,
		debt = function()
			return 0
		end
	},
	["right_leg_13"] = {
		"gravity erupt target right leg",
		choice = function()
			return rime.sciomancer.attacks.right_leg_13[1], "eq", "right_leg_damaged"
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_stack("gravity", target) >= 3 and rime.targets[target].limbs["right_leg"] < 1300 then
				return true
			else
				return false
			end
		end,
		debt = function()
			return 0
		end
	},

	["confusion"] = {
		"cast scourge target",
		"shadowprice scourge target",
		choice = function()
			if rime.sciomancer.scourge_price() then
				return rime.sciomancer.attacks.confusion[2], "eq", "confusion"
			else
				return rime.sciomancer.attacks.confusion[1], "eq", "confusion"
			end
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("gloom", target) or rime.pvp.has_aff("sphere", target) then
				return true
			else
				return false
			end
		end,
		debt = function()
			if string.find(rime.sciomancer.attacks.confusion.choice(), "shadowprice") then
				return 1
			else
				return 0
			end
		end
	},
	["dizziness"] = {
		"cast scourge target",
		"shadowprice scourge target",
		choice = function()
			if rime.sciomancer.scourge_price() then
				return rime.sciomancer.attacks.dizziness[2], "eq", "dizziness"
			else
				return rime.sciomancer.attacks.dizziness[1], "eq", "dizziness"
			end
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("gloom", target) or rime.pvp.has_aff("sphere", target) then
				return true
			else
				return false
			end
		end,
		debt = function()
			if string.find(rime.sciomancer.attacks.dizziness.choice(), "shadowprice") then
				return 1
			else
				return 0
			end
		end
	},

	["dementia_falter"] = {
		Sciomancer = "cast falter target",
		Runecarver = "hex anathemise target",
		choice = function()
			local class = rime.status.class
			return rime.sciomancer.attacks.dementia_falter[class], "eq", "dementia"
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("dementia", target) then return false end
			if not rime.pvp.has_aff("dizziness", target) then return false end
			return true
		end,
		debt = function()
			return 0
		end,
	},

	["dementia"] = {
		"cast scourge target",
		"shadowprice scourge target",
		choice = function()
			if rime.sciomancer.scourge_price() then
				return rime.sciomancer.attacks.dementia[2], "eq", "dementia"
			else
				return rime.sciomancer.attacks.dementia[1], "eq", "dementia"
			end
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("gloom", target) or rime.pvp.has_aff("sphere", target) then
				return true
			else
				return false
			end
		end,		
		debt = function()
			if string.find(rime.sciomancer.attacks.dementia.choice(), "shadowprice") then
				return 1
			else
				return 0
			end
		end
	},
	["faintness"] = {
		"cast scourge target",
		"shadowprice scourge target",
		choice = function()
			if rime.sciomancer.scourge_price() then
				return rime.sciomancer.attacks.faintness[2], "eq", "faintness"
			else
				return rime.sciomancer.attacks.faintness[1], "eq", "faintness"
			end
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("gloom", target) or rime.pvp.has_aff("sphere", target) then
				return true
			else
				return false
			end
		end,
		debt = function()
			if string.find(rime.sciomancer.attacks.dementia.choice(), "shadowprice") then
				return 1
			else
				return 0
			end
		end
	},
	["nyctophobia"] = {
		"cast scourge target",
		"shadowprice scourge target",
		"shadowprice sphere target",
		choice = function()
			local target = rime.target
			if not rime.pvp.has_aff("shadowsphere", target) and rime.sciomancer.can.shadowsphere and (rime.sciomancer.debt_allowance > 0 or rime.sciomancer.can_repay()) then
				return rime.sciomancer.attacks.nyctophobia[3], "eq", "nyctophobia"
			elseif rime.sciomancer.scourge_price() then
				return rime.sciomancer.attacks.nyctophobia[2], "eq", "nyctophobia"
			else
				return rime.sciomancer.attacks.nyctophobia[1], "eq", "nyctophobia"
			end
		end,
		can = function()
		local target = rime.target
		local attack, idk, idc = rime.sciomancer.attacks.nyctophobia.choice()
			if string.find(attack, "sphere") or (rime.pvp.has_aff("gloom", target) or rime.pvp.has_aff("shadowsphere", target)) then
				return true
			else
				return false
			end
		end,		
		debt = function()
			if string.find(rime.sciomancer.attacks.nyctophobia.choice(), "shadowprice") then
				return 1
			else
				return 0
			end
		end

	},
	["paresis"] = {
		"gravity grip target",
		"cast ruin target",
		"shadowprice ruin target",
		choice = function()
			local target = rime.target
			if rime.pvp.has_aff("clumsiness", target) and rime.pvp.has_aff("weariness", target) and rime.pvp.has_aff("lethargy", target) then
				return rime.sciomancer.attacks.paresis[2], "eq", "paresis"
			elseif rime.sciomancer.ruin_check == 2 and (rime.sciomancer.debt_allowance > 0 or (rime.sciomancer.debt_allowance > 0 and rime.sciomancer.can_repay())) and rime.pvp.has_stack("gravity", target) == 5 then
				return rime.sciomancer.attacks.paresis[3], "eq", "paresis"
			else
				return rime.sciomancer.attacks.paresis[1], "eq", "paresis"
			end
		end,
		can = function()
			return true
		end,		
		debt = function()
			if string.find(rime.sciomancer.attacks.paresis.choice(), "shadowprice") then
				return 1
			else
				return 0
			end
		end
	},
	["clumsiness"] = {
		"cast ruin target",
		"shadowprice ruin target",
		choice = function()
			if rime.sciomancer.can_repay() or rime.sciomancer.debt_allowance > 0 then
				return rime.sciomancer.attacks.clumsiness[2], "eq", "clumsiness"
			else
				return rime.sciomancer.attacks.clumsiness[1], "eq", "clumsiness"
			end
		end,
		can = function()
			return true
		end,		
		debt = function()
			if string.find(rime.sciomancer.attacks.clumsiness.choice(), "shadowprice") then
				return 1
			else
				return 0
			end
		end
	},
	["weariness"] = {
		"cast ruin target",
		"shadowprice ruin target",
		choice = function()
			if rime.sciomancer.can_repay() or rime.sciomancer.debt_allowance > 0 then
				return rime.sciomancer.attacks.weariness[2], "eq", "weariness"
			else
				return rime.sciomancer.attacks.weariness[1], "eq", "weariness"
			end
		end,
		can = function()
			return true
		end,		
		debt = function()
			if string.find(rime.sciomancer.attacks.weariness.choice(), "shadowprice") then
				return 1
			else
				return 0
			end
		end
	},
	["lethargy"] = {
		"cast ruin target",
		"shadowprice ruin target",
		choice = function()
			if rime.sciomancer.can_repay() or rime.sciomancer.debt_allowance > 0 then
				return rime.sciomancer.attacks.lethargy[2], "eq", "lethargy"
			else
				return rime.sciomancer.attacks.lethargy[1], "eq", "lethargy"
			end
		end,
		can = function()
			return true
		end,		
		debt = function()
			if string.find(rime.sciomancer.attacks.lethargy.choice(), "shadowprice") then
				return 1
			else
				return 0
			end
		end
	},
	["vomiting"] = {
		"cast fever target",
		"shadowprice fever target",
		choice = function()
			if rime.sciomancer.debt_allowance > 0 then
				return rime.sciomancer.attacks.vomiting[2], "eq", "vomiting"
			else
				return rime.sciomancer.attacks.vomiting[1], "eq", "vomiting"
			end
		end,
		can = function()
			return true
		end,		
		debt = function()
			if string.find(rime.sciomancer.attacks.vomiting.choice(), "shadowprice") then
				return 1
			else
				return 0
			end
		end
	},
	["haemophilia"] = {
		"cast fever target",
		"shadowprice fever target",
		choice = function()
			if rime.sciomancer.debt_allowance > 0 then
				return rime.sciomancer.attacks.haemophilia[2], "eq", "haemophilia"
			else
				return rime.sciomancer.attacks.haemophilia[1], "eq", "haemophilia"
			end
		end,
		can = function()
			return true
		end,		
		debt = function()
			if string.find(rime.sciomancer.attacks.haemophilia.choice(), "shadowprice") then
				return 1
			else
				return 0
			end
		end
	},
	["voidgaze"] = {
		"cast voidgaze target",
		"shadowprice voidgaze target",
        choice = function()
            local target = rime.target
            if (rime.sciomancer.debt_allowance > 0 or rime.sciomancer.can_repay()) and not rime.pvp.has_aff("no_blind", target) then
                return rime.sciomancer.attacks.voidgaze[2], "eq", "voidgaze"
            else
                return rime.sciomancer.attacks.voidgaze[1], "eq", "voidgaze"
            end
        end,
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("no_blind", target) then
				return true
			elseif not rime.pvp.has_aff("no_blind", target) and string.find(rime.sciomancer.attacks.voidgaze.choice(), "shadowprice") then
				return true
			else
				return false
			end
		end,		
		debt = function()
			if string.find(rime.sciomancer.attacks.voidgaze.choice(), "shadowprice") then
				return 1
			else
				return 0
			end
		end
	},

	["voidtrap"] = {
		"cast voidgaze target",
		"shadowprice voidgaze target",
        choice = function()
            local target = rime.target
            if (rime.sciomancer.debt_allowance > 0 or rime.sciomancer.can_repay()) and not rime.pvp.has_aff("no_blind", target) then
                return rime.sciomancer.attacks.voidgaze[2], "eq", "voidgaze"
            else
                return rime.sciomancer.attacks.voidgaze[1], "eq", "voidgaze"
            end
        end,
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("no_blind", target) and rime.pvp.has_aff("clumsiness", target) and rime.pvp.has_aff("weariness", target) and rime.pvp.has_aff("vomiting", target) and rime.pvp.has_aff("dementia", target) then
				return true
			elseif rime.pvp.has_aff("no_blind", target) and rime.pvp.has_aff("clumsiness", target) and rime.pvp.has_aff("weariness", target) and rime.pvp.has_aff("vomiting", target) and rime.pvp.has_aff("dementia", target) and string.find(rime.sciomancer.attacks.voidgaze.choice(), "shadowprice") then
				return true
			else
				return false
			end
		end,		
		debt = function()
			if string.find(rime.sciomancer.attacks.voidgaze.choice(), "shadowprice") then
				return 1
			else
				return 0
			end
		end
	},

	["rot_benign"] = {
		"cast rot target",
		"shadowprice rot target",
		choice = function()
			local target = rime.target
			if rime.pvp.has_aff("rot", target) then return false end
			if not rime.pvp.has_aff("sphere", target) and (rime.sciomancer.debt_allowance > 0 or rime.sciomancer.can_repay()) then
				return rime.sciomancer.attacks.rot_benign[2], "eq", "rot_benign"
			else
				return rime.sciomancer.attacks.rot_benign[1], "eq", "rot_benign"
			end
		end,
		can = function()
		local target = rime.target
			if not rime.pvp.has_aff("rot_benign", target) then return true else return false end
		end,		
		debt = function()
			if string.find(rime.sciomancer.attacks.rot_benign.choice(), "shadowprice") then
				return 1
			else
				return 0
			end
		end
	},
	["gloom"] = {
		"cast gloom target",
		"shadowprice gloom target",
		choice = function()
			if rime.sciomancer.debt_allowance > 0 or rime.sciomancer.can_repay() then
				return rime.sciomancer.attacks.gloom[2], "free", "gloom"
			else
				return rime.sciomancer.attacks.gloom[1], "eq", "gloom"
			end
		end,
		can = function()
			return true
		end,		
		debt = function()
			if string.find(rime.sciomancer.attacks.gloom.choice(), "shadowprice") then
				return 1
			else
				return 0
			end
		end
	},
	["imbue"] = {
		"gravity imbue target",
		choice = function()
			return rime.sciomancer.attacks.imbue[1], "free", "imbue"
		end,
		can = function()
			return true
		end,		
		debt = function()
			if string.find(rime.sciomancer.attacks.imbue.choice(), "shadowprice") then
				return 1
			else
				return 0
			end
		end
	},
	["haunt"] = {
		"cast haunt target",
		"shadowprice haunt target",
		choice = function()
			return rime.sciomancer.attacks.haunt[2], "eq", "haunt"
		end,
		can = function()
			if rime.sciomancer.scourge_price() then
				return true
			else
				return false
			end
		end,		
		debt = function()
			if string.find(rime.sciomancer.attacks.haunt.choice(), "shadowprice") then
				return 1
			else
				return 0
			end
		end
	},
	["shadowsphere"] = {
		"cast sphere target",
		"shadowprice sphere target",
		choice = function()
			local target = rime.target
			if rime.pvp.has_aff("nyctophobia", target) then
				return rime.sciomancer.attacks.shadowsphere[1], "eq", "shadowsphere"
			elseif rime.sciomancer.debt_allowance > 0 or rime.sciomancer.can_repay() then
				return rime.sciomancer.attacks.shadowsphere[2], "eq", "shadowsphere"
			else
				return rime.sciomancer.attacks.shadowsphere[1], "eq", "shadowsphere"
			end
		end,
		can = function()
			if rime.sciomancer.can.shadowsphere then
				return true
			else
				return false
			end
		end,		
		debt = function()
			if string.find(rime.sciomancer.attacks.shadowsphere.choice(), "shadowprice") then
				return 1
			else
				return 0
			end
		end
	},
	["exhaustion"] = {
		"cast falter target",
		"shadowprice falter target",
		choice = function()
			local target = rime.target
			if rime.pvp.has_aff("weariness", target) then
				return rime.sciomancer.attacks.exhaustion[1], "eq", "exhaustion"
			elseif rime.sciomancer.debt_allowance > 0 or rime.sciomancer.can_repay() then
				return rime.sciomancer.attacks.exhaustion[2], "eq", "exhaustion"
			else
				return rime.sciomancer.attacks.exhaustion[1], "eq", "exhaustion"
			end
		end,
		can = function()
			return true
		end,		
		debt = function()
			if string.find(rime.sciomancer.attacks.exhaustion.choice(), "shadowprice") then
				return 1
			else
				return 0
			end
		end
	},
	["dissonance"] = {
	"cast falter target",
		"shadowprice falter target",
		choice = function()
			local target = rime.target
			if rime.pvp.has_aff("dizziness", target) then
				return rime.sciomancer.attacks.dissonance[1], "eq", "dissonance"
			elseif rime.sciomancer.debt_allowance > 0 or rime.sciomancer.can_repay() then
				return rime.sciomancer.attacks.dissonance[2], "eq", "dissonance"
			else
				return rime.sciomancer.attacks.dissonance[1], "eq", "dissonance"
			end
		end,
		can = function()
			return true
		end,		
		debt = function()
			if string.find(rime.sciomancer.attacks.dissonance.choice(), "shadowprice") then
				return 1
			else
				return 0
			end
		end
	},
	["impede"] = {
		"gravity impede target",
		choice = function()
			return rime.sciomancer.attacks.impede[1], "free", "impede"
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_stack("gravity", target) > 2 then
				return true
			else
				return false
			end
		end,		
		debt = function()
			if string.find(rime.sciomancer.attacks.impede.choice(), "shadowprice") then
				return 1
			else
				return 0
			end
		end
	},
	["left_leg_broken"] = {
		"gravity erupt target left leg",
		choice = function()
			return rime.sciomancer.attacks.left_leg_broken[1]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_stack("gravity", target) == 5 and (rime.pvp.has_aff("shadowbrand", target) or rime.pvp.has_aff("right_leg_broken", target)) then
				return true
			elseif rime.pvp.has_stack("gravity", target) >= 2 and not rime.limit.left_leg_restore and not rime.pvp.has_aff("left_leg_broken") then
				return true
			else
				return false
			end
		end,
		debt = function()
			return 0
		end
	},
	["right_leg_broken"] = {
		"gravity erupt target right leg",
		choice = function()
			return rime.sciomancer.attacks.right_leg_broken[1]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_stack("gravity", target) == 5 and rime.pvp.has_aff("left_leg_broken", target) then
				return true
			elseif rime.pvp.has_stack("gravity", target) >= 2 and not rime.limit.right_leg_restore and not rime.pvp.has_aff("right_leg_broken") then
				return true
			else
				return false
			end
		end,
		debt = function()
			return 0
		end
	},
	["left_arm_broken"] = {
		"gravity erupt target left arm",
		choice = function()
			return rime.sciomancer.attacks.left_arm_broken[1]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_stack("gravity", target) == 5 and not (rime.pvp.has_aff("shadowbrand", target) or rime.pvp.has_aff("nyctophobia", target)) then
				return true
			else
				return false
			end
		end,
		debt = function()
			return 0
		end
	},
	["shivering"] = {
		"cast chill target",
		"shadowprice chill target",
		choice = function()
			local target = rime.target
			if rime.pvp.has_def("insulation", target) then
				return rime.sciomancer.attacks.shivering[2]
			else
				return rime.sciomancer.attacks.shivering[1]
			end
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("gloom", target) and rime.pvp.has_aff("voidgaze", target) then
				return true
			else
				return false
			end
		end,
		debt = function()
			if string.find(rime.sciomancer.attacks.shivering.choice(), "shadowprice") then
				return 1
			else
				return 0
			end
		end
	},
	["frozen"] = {
		"cast chill target",
		choice = function()
			return rime.sciomancer.attacks.frozen[1]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("shivering", target) and rime.pvp.has_aff("gloom", target) and rime.pvp.has_aff("voidgaze", target) then
				return true
			else
				return false
			end
		end,
		debt = function()
			return 0
		end
	},
}