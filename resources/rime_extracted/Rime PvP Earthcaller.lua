--Author: Bulrok
earthcaller = earthcaller or {}
earthcaller.infiltrate = "none"

earthcaller.verses = {
	["empowerment"] = false,
	["enervation"] = false,
	["eternity"] = false,
	["imprisonment"] = false,
}
earthcaller.verses_priority = {
	"empowerment",
	"enervation",
	"imprisonment",
	"eternity",
}

rime.pvp.Earthcaller.routes = {

	["black"] = {
		["blurb"] = {"Duelling Offense"},

		["spurs"] = {
			"impatience",
			"push_sensitivity",
			"push_migraine",
			"selfpity",
			"stupidity",
			"berserking",
			"vertigo",
			"sensitivity",
			"anorexia",
		},

		["attacks"] = {
			"fragmentation",
			"infiltrate",
			"aftershock",
			"face_fuck",
			"push_no_blind",
			"writhe_transfix",
			"shielded",
			"hellsight",
			"paresis",
			"weariness",
			"misery",
			"asthma",
			"berserking",
			"peace",
			"confusion",
			"rebounding",
			"weariness",
			"asthma",
			"peace",
			"no_blind",
		},

		["subdues"] = {
			"hypochondria",
			"masochism",
			"recklessness",
			"agony",
			"lethargy",
			"stupidity",
			"self_loathing",
			"masochism",
			"recklessness",
			"paranoia",
			"dementia",
			"anorexia",

		},
	},

	["group"] = {

		["blurb"] = {"Be useful in groups."},

		["spurs"] = {
			"stupidity",
			"migraine",
			"vertigo",
			"impatience",
			"anorexia",
		},

		["attacks"] = {
			"dome_ordain",
			"fuck_em_up",
			"reinforce",
			--"aegis_illusion",
			"reinforce",
			"rebounding",
			"shielded",
			"writhe_transfix",
			"no_blind",
			"paresis",
			"asthma",
			"weariness",
			"berserking",
			"hellsight",
		},

		["subdues"] = {
			"self_loathing",
			"recklessness",
			"paranoia",
			"masochism",
			"lethargy",
			"hypochondria",
			"agony",
			"dementia",
			"stupidity",
			"anorexia",
		},
	},

	["groups"] = {

		["blurb"] = {"Be useful in groups: The Seconding"},

		["spurs"] = {
			"impatience",
			"sensitivity",
			"vertigo",
			"impatience",
			"stupidity",
			"selfpity",
			"berserking",
			"migraine",
			"anorexia",
		},

		["attacks"] = {
			"dome_ordain",
			"fuck_em_up",
			"rebounding",
			"shielded",
			"paresis",
			"weariness",
			"writhe_transfix",
			"no_blind",
			"paresis",
			"hellsight",
		},

		["subdues"] = {
			"hypochondria",
			"self_loathing",
			"agony",
			"lethargy",
			"recklessness",
			"paranoia",
			"masochism",
			"dementia",
			"stupidity",
			"anorexia",
		},
	},

}


earthcaller.attacks = {

	["dome_ordain"] = {
		Earthcaller = "dirge ordain target punch "..gmcp.Char.Status.name,
		Luminary = "perform force target punch "..gmcp.Char.Status.name,
		can = function()
			local target = rime.target
			if not rime.pvp.has_def("dome", target) then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return earthcaller.attacks.dome_ordain[class]
		end,
	},

	["reinforce"] = {
        Earthcaller = "dirge reinforce ally",
        Luminary = "perform hands ally",
        can = function()
            local ally = rime.pick_ally("aggro")
            if not rime.targets[ally] then return false end
            if rime.targets[ally].aggro >= 2 then
                return true
            else
                return false
            end
        end,
        choice = function()
            local class = rime.status.class
            return earthcaller.attacks.reinforce[class]
        end,
    },

	["misery"] = {
		Earthcaller = "shield facesmash target",
		Luminary = "shield facesmash target",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("misery", target) then return false end
			if rime.pvp.has_aff("no_blind", target) then return false end
			if rime.pvp.has_def("rebounding", target) then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.attacks.misery[class]
		end,
	},

	["lobanberry"] = {
		Earthcaller = "outc pinkloban" .. rime.saved.separator .. "give pinkloban to target" .. rime.saved.separator .. "dirge ordain target eat pinkloban",
		Luminary = "",
		can = function()
			local target = rime.target
			if not rime.pvp.has_aff("lobanberry", target) then
				return true
			else
				return false
			end
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.attacks.lobanberry[class]
		end,
	},

	["fragmentation"] = {
        Earthcaller = "osso fragment target",
        Luminary = "angel absolve target",
        can = function()
            local target = rime.target
            if rime.targets[rime.target].mana < 44 then
                return true
            else
                return false
            end
        end,
        choice = function()
            local class = gmcp.Char.Status.class
            return earthcaller.attacks.fragmentation[class]
        end,
    },

	["aftershock"] = {
		Earthcaller = "tectonic aftershock target",
		Luminary = "evoke shadow target",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("aftershock", target) or rime.pvp.has_aff("shadowed", target) then
				return false
			else
				return true
			end
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.attacks.aftershock[class]
		end,
	},

	["infiltrate"] = {
		Earthcaller = "osso infiltrate target",
		Luminary = "angel spiritwrack target",
		can = function()
			local target = rime.target
			if earthcaller.infiltrate == target then
				return false
			else
				return true
			end
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.attacks.infiltrate[class]
		end,
	},

	["rebounding"] = {
		Earthcaller = "shield raze target",
		Luminary = "shield raze target",
		can = function()
			if not earthcaller.can_shield() then return false end
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then
				return true
			else
				return false
			end
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.attacks.rebounding[class]
		end,
		combo = true,
	},

	["shielded"] = {
		Earthcaller = "shield raze target",
		Luminary = "shield raze target",
		can = function()
			if not earthcaller.can_shield() then return false end
			local target = rime.target
			if rime.pvp.has_def("shielded", target) then
				return true
			else
				return false
			end
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.attacks.shielded[class]
		end,
		combo = true,
	},

	["face_fuck"] = {
		Earthcaller = "shield deface target",
		Luminary = "shield overwhelm target",
		can = function()
			if not earthcaller.can_shield() then return false end
			local target = rime.target
			local aff_total = 0
			local prone_time = rime.getTimeLeft("self_loathing_prone", target)
			local gate = rime.pvp.get_gate()
			local time_left = prone_time-gate
			for k,v in pairs(rime.targets[target].afflictions) do
                if rime.pvp.has_aff(k, target) and not ignore_aff(k) then
                    aff_total = aff_total+1
                end
            end
            if prone_time > 0 then
            	rime.echo("You have "..time_left.." seconds left to Deface.", "pvp")
            end
			if #rime.missingAff("prone/paralysis/writhe_web/writhe_transfix/writhe_bind/writhe_armpitlock/writhe_impaled/writhe_necklock/writhe_ropes/writhe_thighlock/writhe_vines/frozen","/") < 12 and aff_total >= 10 and rime.pvp.has_aff("aftershock", target) then
				return true
			elseif prone_time > gate and aff_total >= 5 then
				return true
			else
				return false
			end
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.attacks.face_fuck[class]
		end,
		combo = true,
	},

	["fuck_em_up"] = {
		Earthcaller = "shield deface target",
		Luminary = "shield overwhelm target",
		can = function()
			if not earthcaller.can_shield() then return false end
			local target = rime.target
			if #rime.missingAff("prone/paralysis/writhe_web/writhe_transfix/writhe_bind/writhe_armpitlock/writhe_impaled/writhe_necklock/writhe_ropes/writhe_thighlock/writhe_vines/frozen","/") < 12  then
				return true
			else
				return false
			end
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.attacks.fuck_em_up[class]
		end,
		combo = true,
	},

	["heal_ally"] = {
		Earthcaller = "dirge reinforce ally",
		Luminary = "perform hands ally",
		can = function()
            rime.pvp.ally = rime.pvp.ally or rime.saved.allies[1]
            for k,v in ipairs(rime.saved.allies) do
               if tonumber(rime.targets[v].aggro) > tonumber(rime.targets[rime.pvp.ally].aggro) and rime.targets[v].defences.shielded == false then
                    rime.pvp.ally = v
                end
            end

            if tonumber(rime.targets[rime.pvp.ally].aggro) > 3 and not rime.targets[rime.pvp.ally].defences.shielded then
                return true
            else
                return false
            end
        end,
        choice = function()
        	local class = gmcp.Char.Status.class
        	return earthcaller.attacks.heal_ally[class]
        end,
	},

	["hellsight"] = {
		Earthcaller = "dirge reckoning target",
		Luminary = "perform hellsight target",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("hellsight", target) then return false end
			if rime.pvp.has_aff("accursed", target) and rime.pvp.has_aff("peace", target) then
				return true
			elseif rime.pvp.has_aff("accursed", target) and (rime.pvp.has_aff("asthma", target) or rime.pvp.has_aff("self_loathing", target)) then
				return true
			elseif rime.pvp.has_aff("asthma", target) and (rime.pvp.has_aff("hypochondria", target) or rime.pvp.has_aff("weariness", target)) then
				return true
			else
				return false
			end
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.attacks.hellsight[class]
		end,
		combo = false,
	},

	["paresis"] = {
		Earthcaller = "shield strike target",
		Luminary = "shield strike target",
		can = function()
			if not earthcaller.can_shield() then return false end
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("paresis", target) then return false end
			if rime.pvp.has_aff("paralysis", target) then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.attacks.paresis[class]
		end,
		combo = true,
	},

	["no_blind"] = {
		Earthcaller = "shield horrify target",
		Luminary = "shield brilliance target",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("no_blind", target) then return false end
			if rime.pvp.has_def("rebounding", target) then return false end
			if not earthcaller.can_shield() then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.attacks.no_blind[class]
		end,
		combo = true,
	},

	["disrupted"] = {
		Earthcaller = "shield crash target",
		Luminary = "shield crash target",
		can = function()
			if not earthcaller.can_shield() then return false end
			local target = rime.target
			if not rime.pvp.has_aff("asthma", target) then return false end
			if not rime.pvp.has_aff("slickness", target) then return false end
			if not rime.pvp.has_aff("anorexia", target) then return false end
			if not rime.pvp.has_aff("confusion", target) then return false end
			if rime.pvp.has_aff("disrupted", target) then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.attacks.disrupted[class]
		end,
		combo = true,
	},

	["weariness"] = {
		Earthcaller = "shield punch target",
		Luminary = "shield punch target",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if not earthcaller.can_shield() then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.attacks.weariness[class]
		end,
		combo = true,
	},

	["asthma"] = {
		Earthcaller = "shield slam target",
		Luminary = "shield slam target",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if not earthcaller.can_shield() then return false end
			if rime.pvp.has_aff("asthma", target) then return false end
			if not rime.pvp.has_aff("haemophilia", target) then
				return true
			else
				return false
			end
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.attacks.asthma[class]
		end,
		combo = false,
	},

	["haemophilia"] = {
		Earthcaller = "shield slam target",
		Luminary = "shield slam target",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if not earthcaller.can_shield() then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.attacks.haemophilia[class]
		end,
		combo = false,
	},

	["allergies"] = {
		Earthcaller = "tectonic ashfall target",
		Luminary = "evoke lightning target",
		can = function()
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.attacks.allergies[class]
		end,
		combo = false,
	},

	["hallucinations"] = {
		Earthcaller = "tectonic vent target",
		Luminary = "evoke heatwave target",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("beserking", target) then return false end
			if rime.pvp.has_aff("hallucinations", target) then return false end
			if not rime.pvp.has_aff("impatience", target) then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.attacks.hallucinations[class]
		end,
		combo = false,
	},

	["berserking"] = {
		Earthcaller = "tectonic vent target",
		Luminary = "evoke heatwave target",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("beserking", target) then return false end
			if rime.pvp.has_aff("hallucinations", target) then return false end
			if not rime.pvp.has_aff("impatience", target) then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.attacks.berserking[class]
		end,
		combo = false,
	},

	["push_berserking"] = {
		Earthcaller = "tectonic vent target",
		Luminary = "evoke heatwave target",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("beserking", target) then return false end
			if rime.pvp.has_aff("hallucinations", target) then return false end
			if rime.pvp.has_aff("impatience", target) and rime.pvp.has_def("rebounding", target) then return true end
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.attacks.push_berserking[class]
		end,
		combo = false,
	},

	["push_confusion"] = {
		Earthcaller = "dirge hysteria target",
		Luminary = "perform dazzle target",
		can = function()
			local target = rime.target
			local confusion_classes = {"luminary", "praenomen", "archivist", "ascendril", "sciomancer", "shaman"}
			local found_one = false
			if rime.pvp.has_aff("confusion", target) then return false end
			if rime.pvp.has_aff("dizziness", target) then return false end
			for k,v in ipairs(confusion_classes) do
				if v == rime.cure_set then
					found_one = true
					break
				end
			end
			if not rime.pvp.has_aff("impatience", target) then return false end
			if not found_one then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return earthcaller.attacks.push_confusion[class]
		end,
	},

	["confusion"] = {
		Earthcaller = "dirge hysteria target",
		Luminary = "perform dazzle target",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("impatience", target) then
				return true
			else
				return false
			end
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.attacks.confusion[class]
		end,
		combo = false,
	},

	["dizziness"] = {
		Earthcaller = "dirge hysteria target",
		Luminary = "perform dazzle target",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("impatience", target) then
				return true
			else
				return false
			end
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.attacks.confusion[class]
		end,
		combo = false,
	},

	["writhe_transfix"] = {
		Earthcaller = "tectonic transfixion target",
		Luminary = "evoke transfixion target",
		can = function()
			local target = rime.target
			local aff_total = 0
			for k,v in pairs(rime.targets[target].afflictions) do
                if rime.pvp.has_aff(k, target) and not ignore_aff(k) then
                    aff_total = aff_total+1
                end
            end
			if rime.pvp.has_aff("no_blind", target) and rime.affTally >= 5 and not rime.curing.class then
				return true
			elseif rime.pvp.has_aff("no_blind", target) and aff_total >= 10 and rime.pvp.has_aff("aftershock", target) then
				return true
			elseif rime.pvp.route_choice == "group" or rime.pvp.route_choice == "groups" then
				return true
			else
				return false
			end
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.attacks.writhe_transfix[class]
		end,
		combo = false,
	},

	["peace"] = {
		Earthcaller = "dirge lull target",
		Luminary = "perform peace target",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("impatience", target) then
				return true
			else
				return false
			end
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.attacks.peace[class]
		end,
		combo = false,
	},

}

earthcaller.subdue = {

	["anorexia"] = {
		Earthcaller = "subdue target anorexia",
		Luminary = "chasten target anorexia",
		can = function()
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.subdue.anorexia[class]
		end,
		call = "anorexia",
		aff = "anorexia",
	},

	["dementia"] = {
		Earthcaller = "subdue target dementia",
		Luminary = "chasten target dementia",
		can = function()
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.subdue.dementia[class]
		end,
		call = "dementia",
		aff = "dementia",
	},

	["hypochondria"] = {
		Earthcaller = "subdue target hypochondria",
		Luminary = "chasten target hypochondria",
		can = function()
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.subdue.hypochondria[class]
		end,
		call = "hypochondria",
		aff = "hypochondria",
	},

	["lethargy"] = {
		Earthcaller = "subdue target lethargy",
		Luminary = "chasten target lethargy",
		can = function()
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.subdue.lethargy[class]
		end,
		call = "lethargy",
		aff = "lethargy",
	},

	["self_loathing"] = {
		Earthcaller = "subdue target self_loathing",
		Luminary = "chasten target self_loathing",
		can = function()
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.subdue.self_loathing[class]
		end,
		call = "self_loathing",
		aff = "self_loathing",
	},

	["masochism"] = {
		Earthcaller = "subdue target masochism",
		Luminary = "chasten target masochism",
		can = function()
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.subdue.masochism[class]
		end,
		call = "masochism",
		aff = "masochism",
	},

	["paranoia"] = {
		Earthcaller = "subdue target paranoia",
		Luminary = "chasten target paranoia",
		can = function()
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.subdue.paranoia[class]
		end,
		call = "paranoia",
		aff = "paranoia",
	},

	["recklessness"] = {
		Earthcaller = "subdue target recklessness",
		Luminary = "chasten target recklessness",
		can = function()
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.subdue.recklessness[class]
		end,
		call = "recklessness",
		aff = "recklessness",
	},

	["stupidity"] = {
		Earthcaller = "subdue target stupidity",
		Luminary = "chasten target stupidity",
		can = function()
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.subdue.stupidity[class]
		end,
		call = "stupidity",
		aff = "stupidity",
	},

	["agony"] = {
		Earthcaller = "subdue target agony",
		Luminary = "chasten target agony",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("accursed", target) then
				return false
			else
				return true
			end
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.subdue.agony[class]
		end,
		call = "agony",
		aff = "agony",
	},
}


earthcaller.spur = {

	["anorexia"] = {
		Earthcaller = "osso spur anorexia target",
		Luminary = "angel battle anorexia target",
		can = function()
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.spur.anorexia[class]
		end,
	},

	["stupidity"] = {
		Earthcaller = "osso spur stupidity target",
		Luminary = "angel battle stupidity target",
		can = function()
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.spur.stupidity[class]
		end,
	},

	["impatience"] = {
		Earthcaller = "osso spur impatience target",
		Luminary = "angel battle impatience target",
		can = function()
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.spur.impatience[class]
		end,
	},

	["vertigo"] = {
		Earthcaller = "osso spur vertigo target",
		Luminary = "angel battle vertigo target",
		can = function()
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.spur.vertigo[class]
		end,
	},

	["sensitivity"] = {
		Earthcaller = "osso spur sensitivity target",
		Luminary = "angel battle sensitivity target",
		can = function()
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.spur.sensitivity[class]
		end,
	},

	["no_deaf"] = {
		Earthcaller = "osso spur sensitivity target",
		Luminary = "angel battle sensitivity target",
		can = function()
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.spur.no_deaf[class]
		end,
	},

	["selfpity"] = {
		Earthcaller = "osso spur self-pity target",
		Luminary = "angel battle self-pity target",
		can = function()
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.spur.selfpity[class]
		end,
	},

	["berserking"] = {
		Earthcaller = "osso spur berserking target",
		Luminary = "angel battle berserking target",
		can = function()
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.spur.berserking[class]
		end,
	},

	["migraine"] = {
		Earthcaller = "osso spur migraine target",
		Luminary = "angel battle migraine target",
		can = function()
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return earthcaller.spur.migraine[class]
		end,
	},

}


function earthcaller.can_shield()

	if rime.has_aff("left_arm_broken") or rime.has_aff("right_arm_broken") then return false end

	return true

end

function earthcaller.get_spur()

	local target = rime.target

	for k,v in ipairs(rime.pvp.route.spurs) do
		if not rime.pvp.has_aff(v, target) and earthcaller.spur[v].can() then
			return earthcaller.spur[v].choice()
		end
	end

	return ""

end

function earthcaller.get_attack()

	local target = rime.target

	for k,v in ipairs(rime.pvp.route.attacks) do
		if not rime.pvp.has_aff(v, target) and earthcaller.attacks[v].can() then
			earthcaller.combo = earthcaller.attacks[v].combo
			return earthcaller.attacks[v].choice()
		end
	end

end

function earthcaller.get_subdue()

	local target = rime.target

	for k,v in ipairs(rime.pvp.route.subdues) do
		if not rime.pvp.has_aff(v, target) and earthcaller.subdue[v].can() then
			return earthcaller.subdue[v].choice(), earthcaller.subdue[v].call
		end
	end

end


function earthcaller.offense()

	local spur = earthcaller.get_spur()
	local attack = earthcaller.get_attack()
	local sep = rime.saved.separator
	local action = rime.pvp.queue_handle()
	local subdue, subdue_call = earthcaller.get_subdue()
	subdue_call = rime.pvp.omniCall(subdue_call)
	if not has_def("seismicity") then action = action..sep.."tectonic seismicity" end

	if rime.pvp.web_aff_calling and earthcaller.combo then

		action = action .. sep .. spur .. sep .. attack .. sep .. subdue_call .. sep .. subdue

	elseif earthcaller.combo then

		action = action .. sep .. spur .. sep .. attack .. sep .. subdue

	else

		action = action .. sep .. spur .. sep .. attack

	end

	action = action:gsub("target", rime.target)
	if string.find(action, "ally") and not string.find(action, "unally") then
		action = action:gsub("ally", rime.pvp.pick_ally("aggro"))
	end

    if action ~= rime.balance_queue and action ~= rime.balance_queue_attempted then
        act(action)
        rime.balance_queue_attempted = action
    end

end