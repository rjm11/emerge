--Author: Bulrok
infiltrator = infiltrator or {}
infiltrator.first_venom = false
infiltrator.second_venom = false
infiltrator.sealed = false

rime.pvp.Infiltrator.routes = {

	["black"] = {

		["attack"] = {
			"bite",
			"shielded",
			"fangbarrier_mark",
			"numbness",
			"rebounding",
			"garrote",
			"dstab",
		},

		["venoms"] = {
			"thin_blood",
			"push_slickness",
			"push_anorexia",
			"paresis",
			"asthma",
			"clumsiness",
			"shyness",
			"allergies",
			"weariness",
			"slickness",
			"anorexia",
			"stupidity",
			"voyria",
			"sensitivity",
			"vomiting",
		},

		["hypnosis"] = {
			"hypochondria",
			"impatience",
			"hypochondria",
			"impatience",
			"epilepsy",
			"loneliness",
			"impatience",
			"agoraphobia",
			"impatience",
			"claustrophobia",
		},

		["sleights"] = {
			"void",
			"dissipate",
		},

	},

	["group"] = {

		["attack"] = {
			"shielded",
			"damage",
			"rebounding",
			"seal",
			"garrote",
			"dstab",
		},

		["venoms"] = {
			"paresis",
			"asthma",
			"sensitivity",
			"clumsiness",
			"slickness",
			"anorexia",
			"stupidity",
			"voyria",
			"allergies",
			"vomiting",
		},

		["hypnosis"] = {
			"impatience",
			"impatience",
			"confusion",
			"hallucinations",
			"impatience",
			"confusion",
			"epilepsy",
			"impatience",
			"loneliness",
			"agoraphobia",
			"claustrophobia",
			"impatience",
		},
	}
}

infiltrator.attacks = {

	["numbness"] = {
		"shadow mark numbness target",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("fangbarrier", target) then return false end
			if rime.pvp.has_aff("numbed_skin", target) then return false end
			return true
		end,
	},

	["garrote"] = {
		"garrote target",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("locked", target) and rime.pvp.has_aff("voyria", target) then
				return true
			elseif rime.pvp.has_aff("writhe_impaled", target) then
				return true
			else
				return false
			end
		end,
	},

	["seal"] = {
		"seal target 3",
		can = function()
			local priority = rime.pvp.route.hypnosis
			local suggested = infiltrator.suggests_added
			if #suggested >= #priority and not infiltrator.sealed then
				return true
			else
				return false
			end
		end,

	},

	["bedazzle"] = {
		"bedazzle target",
		can = function()
			if not infiltrator.can_dstab() then
				return true
			else
				return false
			end
		end,
	},

	["rebounding"] = {
		"flay target rebounding venom",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then
				return true
			else
				return false
			end
		end,
	},

	["fangbarrier_mark"] = {
		"flay target fangbarrier venom",
		can = function()
			local target = rime.target
			if not rime.pvp.has_def("fangbarrier", target) then return false end
			if rime.pvp.has_aff("numbed_skin", target) then return false end
			return true
		end,
	},

	["shielded"] = {
		"flay target shield venom",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("shielded", target) then
				return true
			else
				return false
			end
		end,
	},

	["fangbarrier"] = {
		"flay target fangbarrier",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("cloak", target) then
				return true
			else
				return false
			end
		end,
	},

	["dstab"] = {
		"dstab target",
		can = function()
			local target = rime.target
			if not rime.pvp.has_def("shielded", target) and not rime.pvp.has_def("rebounding", target) and infiltrator.can_dstab() then
				return true
			else
				return false
			end
		end,
	},

	["damage"] = {
		"garrote target",
		can = function()
			local target = rime.target
			if not rime.pvp.has_aff("locked", target) then return false end
			return true
		end,
	},

	["bite"] ={
		"bite target",
		can = function()
			local target = rime.target
			if not rime.pvp.has_def("fangbarrier", target) and rime.pvp.has_aff("locked", target) and not rime.pvp.has_aff("thin_blood", target) then
				return true
			else
				return false
			end
		end,
	},

}

infiltrator.venoms = {

	["thin_blood"] = {
		"scytherus",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("thin_blood", target) then return false end
			if rime.pvp.has_def("fangbarrier", target) then return false end
			if not rime.pvp.has_aff("locked", target) then return false end
			return true
		end,
	},

	["voyria"] = {
		"voyria",
		can = function()
			return true
		end,
	},

	["recklessness"] = {
		"eurypteria",
		can = function()
			return true
		end,
	},

	["sensitivity"] = {
		"prefarar",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("sensitivity", target) then return false end
			return true
		end,
	},

	["allergies"] = {
		"darkshade",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("allergies", target) then return false end
			return true
		end,
	},

	["vomiting"] = {
		"euphorbia",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("vomiting", target) then return false end
			return true
		end,
	},

	["paresis"] = {
		"curare",
		can = function()
			local target = rime.target
			if not rime.pvp.has_aff("paralysis", target) and not rime.pvp.has_aff("paresis", target) then
				return true
			else
				return false
			end
		end,
	},

	["asthma"] = {
		"kalmia",
		can = function()
			return true
		end,
	},

	["clumsiness"] = {
		"xentio",
		can = function()
			return true
		end,
	},

	["weariness"] = {
		"vernalius",
		can = function()
			return true
		end,
	},

	["shyness"] = {
		"digitalis",
		can = function()
			return true
		end,
	},

	["disfigurement"] = {
		"monkshood",
		can = function()
            local pet_classes = {"sentinel", "carnifex", "praenomen", "teradrim"}
            for i=1,#pet_classes do
				if rime.cure_set == pet_classes[i] then
                	return true
            	end
            end
            return false
        end
	},

	["slickness"] = {
		"gecko",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("slickness", target) then return false end
			return true
		end
	},

	["push_slickness"] = {
		"gecko",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("slickness", target) then return false end
			if rime.pvp.has_def("rebounding", target) then return false end
			if not rime.pvp.has_aff("asthma", target) then return false end
			if not rime.pvp.has_aff("impatience", target) then return false end
			return true
		end,
	},

	["push_anorexia"] = {
		"slike",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("anorexia", target) then return false end
			if rime.pvp.has_def("rebounding", target) then return false end
			if not rime.pvp.has_aff("asthma", target) then return false end
			if not rime.pvp.has_aff("impatience", target) then return false end
			return true
		end,
	},

	["anorexia"] = {
		"slike",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("anorexia", target) then return false end
			if not rime.pvp.has_aff("impatience", target) then return false end
			return true
		end,
	},

	["stupidity"] = {
		"aconite",
		can = function()
			return true
		end,
	}
}

infiltrator.marks = {

	["numbness"] = {
		"shadow mark numbness target",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("fangbarrier", target) then return false end
			if rime.pvp.has_aff("numbness", target) then return false end
			return true
		end,
	},
}

infiltrator.hypnosis = {

	["seal"] = {
		"seal target 3"
	},

	["impatience"] = {
		"suggest target impatience",
	},

	["hypochondria"] = {
		"suggest target hypochondria",
	},

	["loneliness"] = {
		"suggest target loneliness",
	},

	["claustrophobia"] = {
		"suggest target claustrophobia",
	},

	["agoraphobia"] = {
		"suggest target agoraphobia",
	},

	["berserking"] = {
		"suggest target berserking",
	},

	["hallucinations"] = {
		"suggest target hallucinations",
	},


}

function infiltrator.can_dstab()

	if rime.has_aff("left_arm_crippled") and rime.has_aff("right_arm_crippled") then
		return false
	end

	if rime.has_aff("paralysis") then
		return false
	end

	for k,v in ipairs(rime.curing.affsByType.writhe) do
		if rime.has_aff(v) then
			return false
		end
	end

	if rime.has_aff("prone") and rime.has_aff("left_leg_crippled") and rime.has_aff("right_leg_crippled") then
		return false
	end

	if rime.has_aff("prone") and not (rime.has_aff("frozen") or rime.has_aff("indifference")) then
		return false
	end

	return true

end

function infiltrator.get_attack()

	local sep = rime.saved.separator
	local target = rime.target

	for k,v in ipairs(rime.pvp.route.attack) do
		if infiltrator.attacks[v].can() then
			return infiltrator.attacks[v][1]
		end
	end

	rime.echo("Error on infiltrator.get_attack() function.")

end

function infiltrator.get_venoms()

	infiltrator.second_venom = false
	infiltrator.first_venom = false

	local attack = infiltrator.get_attack()
	local target = rime.target

	for k,v in ipairs(rime.pvp.route.venoms) do
		if not rime.pvp.has_aff(v, target) and infiltrator.venoms[v].can() and infiltrator.first_venom ~= false then
			infiltrator.second_venom = infiltrator.venoms[v][1]
			break
		elseif not rime.pvp.has_aff(v, target) and infiltrator.venoms[v].can() then
			infiltrator.first_venom = infiltrator.venoms[v][1]
		end
	end

	if string.find(attack, "bite") or string.find(attack, "flay") then
		return infiltrator.first_venom
	else
		return infiltrator.first_venom.."/"..infiltrator.second_venom
	end

end

infiltrator.suggests_added = {}

function infiltrator.suggests()

	local priority = rime.pvp.route.hypnosis
	local sep = rime.saved.separator
	local target = rime.target
	local suggests = rime.targets[target].suggestions

	if #suggests < #priority and not rime.targets[target].sealed then
		return "hypnotise "..rime.target..sep.."suggest "..rime.target.." "..priority[#suggests+1]
	else
		return ""
	end

end

function infiltrator.add_suggest()

	local priority = rime.pvp.route.hypnosis
	local target = rime.target
	local suggests = rime.targets[target].suggestions
	local last_aff = priority[#suggests+1]

	table.insert(rime.targets[target].suggestions, last_aff)
	rime.echo("Added "..class_color()..""..last_aff.."<white> to "..target.."'s suggestions.")

end

function infiltrator.remove_suggest(aff)

	--limitStart("hypnosis", 6)

	local target = rime.target

	table.remove(rime.targets[target].suggestions, 1)
	local suggests = rime.targets[target].suggestions


	--[[if table.contains(infiltrator.suggests_added, aff) then
		table.remove(infiltrator.suggests_added, table.index_of(infiltrator.suggests_added, aff))]]
		rime.echo(class_color()..string.title(aff).."<white> removed.", "pvp")
		rime.echo(class_color()..#suggests.."<white> suggestions left.", "pvp")
	--[[else
		rime.echo("Houston, we have a problem. No fucking idea what went wrong though.")
	end]]

	if #suggests == 0 then
		rime.targets[target].suggestions = {}
		rime.targets[target].sealed = false
		rime.echo("NEW HYPNOSIS CHAIN INCOMING", "pvp")
	end


end

function infiltrator.offense()

	local sep = rime.saved.separator
	local attack = infiltrator.get_attack()
	local wield = ""
	local venoms = infiltrator.get_venoms()
	local target = rime.target
	local queue = rime.pvp.queue_handle()
	local suggest = infiltrator.suggests()
	local web = ""

	if rime.pvp.web_aff_calling and not string.find(attack, "garrote") then 

		web = rime.pvp.omniCall(venoms)

	end

	venoms = venoms:gsub("/", " ")

	if string.find(attack, "flay") then

		wield = "quickwield right whip"

	elseif attack:find("garrote") then

		wield = "quickwield right whip"

	else

		wield = "quickwield right dirk"

	end

	command = queue .. sep .. web .. sep .. wield .. sep .. attack .. " " .. venoms .. sep .. suggest

	local priority = rime.pvp.route.hypnosis
	local suggested = rime.targets[target].suggestions

	if #suggested >= #priority and not rime.targets[target].sealed then
		command = command .. sep .. "seal " .. rime.target .. " 3" .. sep .. "snap "..rime.target
	end

	command = command:gsub("target", rime.target)

	act(command)

end