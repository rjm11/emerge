--Author: Bulrok

alchemist = alchemist or {}

alchemist.resuscitation_cooldown = false --lifebloom
alchemist.boosted_infiltrate = false --infest
alchemist.boosted_pathogen = false --blight
alchemist.can_quills = true --thorncoat
alchemist.prepared = false --naturaltide
alchemist.pet = false --familiar
alchemist.can_reconfigure = alchemist.can_reconfigure or true --morph
alchemist.can_decompose = alchemist.can_decompose or true  --consumption

rime.pvp.Alchemist.routes = {

	["black"] = {

		["blurb"] = {"Kill them"},

		["attacks"] = {
			"shielded",
			"fuckin_bye",
			"discorporate",
			"channel_interrupt",
			"currents",
			"blackout",
			"push_sensitivity",
			"infested",
			"blighted",
			"impatience",
			"regular_currents",
			"shyness",
			"dread",
			"virulent_stupidity",
			"superstition",
			"paranoia",
			"agoraphobia",
			"claustrophobia",
			"vertigo",
			"loneliness",
			--"impatience",
			"paresis",
			"stupidity",
			"vitalbane",
			"virulent",
			"dizziness",
			"weariness",
			"haemophilia",
			"vomiting",
			"allergies",
			"clumsiness",
			"recklessness",
			"dizziness",
		},
	},

	["group"] = {

		["blurb"] = {"Standardized Group Route"},

		["attacks"] = {
			"quills_ally",
			"effigy_damage",
			"shielded",
			"group_impatience",
			"rousing_sensitivity",
			"damage",
			"blackout",
			"shyness",
			"virulent",
			"allergies",
			"haemophilia",
			"vomiting",
		},
	},

	["disco"] = {
		["blurb"] = {"TIME TO TAKE THIS MOTHER FUCKER TO THE DISCO-RPORATE"},

		["attacks"] = {
			"discorporate",
			--"quills_ally",
			--"rousing",
			"blackout",
			"impatience",
			"push_dread",
			"shyness",
			"claustrophobia",
			"superstition",
			"agoraphobia",
			"vertigo",
			"loneliness",
			"paranoia",
			"virulent",
			"stupidity",
			"asthma",
			"dizziness",
			"allergies",
		},
	},
}

alchemist.attacks = {

	["stupidity"] = {
		--This is a standard entry in the attack 'library' for giving stupidity as Alchemist/Shaman
		Alchemist = "alchemy electroshock target",
			--This is the Alchemist syntax for this ability. Due to the way this table is created on system load
			--we can't use a variable in the syntax entry. Instead we use the word 'target' and later on in the offense
			--we will swap that word for our actual targets name.
		Shaman = "commune overload target",
			--This is the Shaman syntax for this ability
		can = function()
			--can will be referenced by another function that calls alchemist.attacks.stupidity.can(). The purpose of this function is to
			--iterate through a series of conditions in which we either do or do not want to use this ability
			local target = rime.target 
				--setting our target so we know which person to compare against
			local volatility = tonumber(gmcp.Char.Vitals.volatility) or tonumber(gmcp.Char.Vitals.energy)
				--Making volatility easier to check. I'm already invested into doing this on each attack but realistically this should be
				--made into a global variable with how often we're going to reference it.
			if rime.vitals.volatility <= 3 then return false end
				--This is a check saying we don't want to use this attack if we have 3 or less energy
			if not alchemist.can("alchemy") then return false end 
				--alchemist.can() will return false if we are not in a state to attack, stopping us from using this skill
			if not hasSkill("Electroshock") and not hasSkill("Overload") then return false end 
				--If we have neither of those skills it will return false and stop us from trying to use this skill
			if rime.pvp.has_aff("stupidity", target) then return false end 
				--if our current target has stupidity, we won't use this skill
			if rime.pvp.has_aff("paresis", target) then return false end 
				--if our current target has paresis, we won't use this skill
			if rime.pvp.has_aff("paralysis", target) then return false end 
				--if our current target has paralysis, we won't use this skill
			return true 
				--we passed all of the above conditionals and have decided that we can use this skill
		end,
		choice = function()
			--choice will be referenced by another function that calls alchemist.attacks.stupidity.choice(). The purpose of this function is to
			--filter through the syntaxes provided at the start of this entry and select the right one depending on which class is being played.
			local class = gmcp.Char.Status.class 
				--Just shortens the variable that tracks our class in gmcp, and makes it easier to reference
			return alchemist.attacks.stupidity[class] 
				--This will make sure the offense picks the right syntax to use depending on what class is using the offense
		end,
		catalyze = true,
			--This is a field we can manipulate to let the offense  know if we want to catalyze/boost this ability before use. If it can't 
			--boost it then it can still use the ability, it will just use the non boosted version. This is going to be a field in every entry
			--even if the ability can't be catalyzed/boosted. If the skill can't be catalyzed/boosted, like because it's a Botany/Naturalism ability
			--just set the field to false by default.
		call = false,
			--This is used for later on in the offense for reporting your calls over webs. If the attack has a clearly trackable third person message
			--then we set this field to false.
	},

	["quills_ally"] = {
		Alchemist = "botany quills ally",
		Shaman = "nature thorncoat ally",
		can = function()
			if not alchemist.can_quills then return false end
			rime.pvp.ally = rime.pvp.ally or rime.saved.allies[1]
            for k,v in ipairs(rime.saved.allies) do
               if tonumber(rime.targets[v].aggro) > tonumber(rime.targets[rime.pvp.ally].aggro) and rime.targets[v].defences.quills == false then
                    rime.pvp.ally = v
                end
            end
            if tonumber(rime.targets[rime.pvp.ally].aggro) >= 3 and table.contains(swarm.room, v) then
            	return true
            else
               return false
            end
        end,
        choice = function()
        	local class = gmcp.Char.Status.class
        	return alchemist.attacks.quills_ally[class]
        end,
        catalyze = false,
        call = false,
	},

	["effigy_damage"] = {
		Alchemist = "alchemy static effigy",
		Shaman = "commune lightning effigy",
		can = function()
			local targets = rime.target
			if not rime.targets[target].effigy then return false end
			if not rime.targets[target].defenses.dome then return false end
			if not hasSkill("Static") and not hasSkill("Lightning") then return false end
			return true
		end,
		choice = function()
			local class = rime.status.class
			return alchemist.attacks.effigy_damage[class]
		end,
		catalyse = true,
		call = false,
	},

	["rousing"] = {
		Alchemist = "alchemy rousing ally",
		Shaman = "commune equivalence ally",
		can = function()
			rime.pvp.ally = rime.pvp.ally or rime.saved.allies[1]
            for k,v in ipairs(rime.saved.allies) do
               if tonumber(rime.targets[v].aggro) > tonumber(rime.targets[rime.pvp.ally].aggro) then
                    rime.pvp.ally = v
                end
            end
            if tonumber(rime.targets[rime.pvp.ally].aggro) >= 2 then
            	return true
            else
               	return false
            end
        end,
        choice = function()
        	local class = gmcp.Char.Status.class
        	return alchemist.attacks.rousing[class]
        end,
        catalyze = true,
        call = false,
	},

	["paresis"] = {
		Alchemist = "alchemy electroshock target",
		Shaman = "commune overload target",
		can = function()
			local target = rime.target
			if not alchemist.can("alchemy") then return false end
			if not hasSkill("Electroshock") and not hasSkill("Overload") then return false end
			if rime.vitals.volatility <= 3 then return false end
			if rime.pvp.has_aff("stupidity", target) then return false end
			if rime.pvp.has_aff("paresis", target) then return false end
			if rime.pvp.has_aff("paralysis", target) then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return alchemist.attacks.paresis[class]
		end,
		catalyze = true,
		call = false,
	},

	["regular_currents"] = {
		Alchemist = "alchemy currents target",
		Shaman = "commune staticburst target",
		can = function()
			local target = rime.target
			local volatility = tonumber(gmcp.Char.Vitals.volatility) or tonumber(gmcp.Char.Vitals.energy)
			if not alchemist.can("alchemy") then return false end
			if not hasSkill("Currents") and not hasSkill("Staticburst") then return false end
			if not rime.pvp.has_aff("blackout", target) then return false end
			if rime.targets[target].currents > 0 then return false end
				--this is checking a field that all targets have to see if they're currently under the effects
				--of Currents/Staticburst. If a person is already under the effects of it, you can't hit them with
				--it again until it's over
			if rime.pvp.count_affs("mental", target) > 3 then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return alchemist.attacks.regular_currents[class]
		end,
		catalyze = false,
		call = false,
	},

	["currents"] = {
		Alchemist = "alchemy currents target",
		Shaman = "commune staticburst target",
		can = function()
			local target = rime.target
			local volatility = tonumber(gmcp.Char.Vitals.volatility) or tonumber(gmcp.Char.Vitals.energy)
			if not alchemist.can("alchemy") then return false end
			if not hasSkill("Currents") and not hasSkill("Staticburst") then return false end
			if volatility <= 3 then return false end
			if rime.targets[target].currents > 0 then return false end
				--this is checking a field that all targets have to see if they're currently under the effects
				--of Currents/Staticburst. If a person is already under the effects of it, you can't hit them with
				--it again until it's over
			if rime.pvp.count_affs("mental", target) > 3 then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return alchemist.attacks.currents[class]
		end,
		catalyze = true,
		call = false,
	},

	["lifebane"] = {
		Alchemist = "alchemy intrusive target",
		Shaman = "commune vitiate target",
		can = function()
			local target = rime.target
			if not alchemist.can("alchemy") then return false end
			if not hasSkill("Intrusive") and not hasSkill("Vitiate") then return false end
			if rime.pvp.has_aff("lifebane", target) then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return alchemist.attacks.lifebane[class]
		end,
		catalyze = false,
		call = false,
	},

	["vitalbane"] = {
		Alchemist = "alchemy malignant target",
		Shaman = "commune scourge target",
		can = function()
			local target = rime.target
			if not alchemist.can("alchemy") then return false end
			if not hasSkill("Malignant") and not hasSkill("Scourge") then return false end
			if rime.pvp.has_aff("vitalbane", target) then return false end
			if rime.vitals.volatility < 2 then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return alchemist.attacks.vitalbane[class]
		end,
		catalyze = false,
		call = false,
	},

	["thunderstorm"] = {
		Alchemist = "alchemy fulmination target",
		Shaman = "commune stormbolt target",
		can = function()
			local target = rime.target
			local volatility = tonumber(gmcp.Char.Vitals.volatility) or tonumber(gmcp.Char.Vitals.energy)
			if not alchemist.can("alchemy") then return false end
			if volatility < 1 then return false end
			if not hasSkill("Fulmination") and not hasSkill("Stormbolt") then return false end
			if rime.pvp.has_aff("thunderstorm", target) then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return alchemist.attacks.thunderstorm[class]
		end,
		catalyze = true,
		call = false,
	},

	["impatience"] = {
		Alchemist = "alchemy neurotic target",
		Shaman = "commune sporulation target",
		can = function()
			local target = rime.target
			if not alchemist.can("alchemy") then return false end
			if not hasSkill("Neurotic") and not hasSkill("Sporulation") then return false end
			if rime.vitals.volatility <= 3 then return false end
			if not rime.targets[target].intoxicant then return false end
			if rime.pvp.has_aff("impatience", target) then return false end
			if rime.pvp.has_aff("confusion", target) then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return alchemist.attacks.impatience[class]
		end,
		catalyze = true,
		call = false,
	},

	["group_impatience"] = {
		Alchemist = "alchemy neurotic target",
		Shaman = "commune sporulation target",
		can = function()
			local target = rime.target
			if not alchemist.can("alchemy") then return false end
			if not hasSkill("Neurotic") and not hasSkill("Sporulation") then return false end
			if rime.pvp.has_aff("impatience", target) then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return alchemist.attacks.group_impatience[class]
		end,
		catalyze = false,
		call = false,
	},


	["confusion"] = {
		Alchemist = "alchemy neurotic target",
		Shaman = "commune sporulation target",
		can = function()
			local target = rime.target
			if not alchemist.can("alchemy") then return false end
			if not hasSkill("Neurotic") and not hasSkill("Sporulation") then return false end
			if rime.pvp.has_aff("impatience", target) then return false end
			if rime.pvp.has_aff("confusion", target) then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return alchemist.attacks.confusion[class]
		end,
		call = false,
	},

	["hallucinations"] = {
		Alchemist = "alchemy neurotic target",
		Shaman = "commune sporulation target",
		can = function()
			local target = rime.target
			local volatility = tonumber(gmcp.Char.Vitals.volatility) or tonumber(gmcp.Char.Vitals.energy)
			if not alchemist.can("alchemy") then return false end
			if not hasSkill("Neurotic") and not hasSkill("Sporulation") then return false end
			if rime.pvp.has_aff("impatience", target) then return false end
			if rime.pvp.has_aff("confusion", target) then return false end
			if rime.pvp.has_aff("hallucinations", target) then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return alchemist.attacks.hallucinations[class]
		end,
		catalyze = false,
		call = false,
	},

	["justice"] = {
		Alchemist = "alchemy parity target",
		Shaman = "commune equivalence target",
		can = function()
			local target = rime.target
			local volatility = tonumber(gmcp.Char.Vitals.volatility) or tonumber(gmcp.Char.Vitals.energy)
			if not alchemist.can("alchemy") then return false end
			if not hasSkill("Parity") and not hasSkill("Equivalence") then return false end
			if rime.pvp.has_aff("justice", target) then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return alchemist.attacks.justice[class]
		end,
		catalyze = false,
		call = false,
	},

	["infested"] = {
		Alchemist = "alchemy infiltrative target",
		Shaman = "commune infest target",
		can = function()
			local target = rime.target
			if not alchemist.can("alchemy") then return false end
			if not hasSkill("Infiltrative") and not hasSkill("Infest") then return false end
			if rime.pvp.has_aff("infested", target) then return false end
			if not rime.pvp.has_aff("dread", target) then return false end
			local euphoriant_affs = 0
			for k,v in ipairs(rime.curing.affsByCure.euphoriant) do
				if rime.pvp.has_aff(v, target) then
					euphoriant_affs = euphoriant_affs+1
				end
			end
			if euphoriant_affs < 2 then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return alchemist.attacks.infested[class]
		end,
		catalyze = false,
		call = false,
	},

	["blighted"] = {
		Alchemist = "alchemy pathogen target",
		Shaman = "commune spines target",
		can = function()
			local target = rime.target
			if not alchemist.can("alchemy") then return false end
			if not hasSkill("Pathogen") and not hasSkill("Spines") then return false end
			if rime.pvp.has_aff("blighted", target) then return false end
			if not rime.pvp.has_aff("dread", target) then return false end
			local antipsychotic_affs = 0
			for k,v in ipairs(rime.curing.affsByCure.antipsychotic) do
				if rime.pvp.has_aff(v, targ) then
					antipsychotic_affs = antipsychotic_affs+1
				end
			end
			if antipsychotic_affs < 2 then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return alchemist.attacks.blighted[class]
		end,
		catalyze = false,
		call = false,
	},

	["dread"] = {
		Alchemist = "derive prognosis target",
		Shaman = "shaman premonition target",
		can = function()
			local target = rime.target
			if not alchemist.can("experimentation") then return false end
			if not hasSkill("Prognosis") and not hasSkill("Premonition") then return false end
			if rime.pvp.has_aff("dread", target) then return false end
			if rime.pvp.count_affs("mental", target) < 2 then return false end
			if not rime.pvp.has_aff("blackout", target) then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return alchemist.attacks.dread[class]
		end,
		catalyze = false,
		call = false,
	},

	["push_dread"] = {
		Alchemist = "derive prognosis target",
		Shaman = "shaman premonition target",
		can = function()
			local target = rime.target
			if not alchemist.can("experimentation") then return false end
			if not hasSkill("Prognosis") and not hasSkill("Premonition") then return false end
			if rime.pvp.has_aff("dread", target) then return false end
			if rime.pvp.count_affs("mental", target) < 2 then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return alchemist.attacks.push_dread[class]
		end,
		catalyze = false,
		call = false,
	},

	["agoraphobia"] = {
		Alchemist = "derive hallucinogen target agoraphobia",
		Shaman = "shaman divulgence target agoraphobia",
		can = function()
			local target = rime.target
			if not alchemist.can("experimentation") then return false end
			if not hasSkill("Hallucinogen") and not hasSkill("Divulgence") then return false end
			if rime.pvp.has_aff("agoraphobia", target) then return false end
			if not rime.pvp.has_aff("impatience", target) then return false end
			if rime.pvp.count_affs("mental", target) < 3 then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return alchemist.attacks.agoraphobia[class]
		end,
		catalyze = false,
		call = "agoraphobia",
	},

	["claustrophobia"] = {
		Alchemist = "derive hallucinogen target claustrophobia",
		Shaman = "shaman divulgence target claustrophobia",
		can = function()
			local target = rime.target
			if not alchemist.can("experimentation") then return false end
			if not hasSkill("Hallucinogen") and not hasSkill("Divulgence") then return false end
			if rime.pvp.has_aff("claustrophobia", target) then return false end
			if not rime.pvp.has_aff("impatience", target) then return false end
			if rime.pvp.count_affs("mental", target) < 3 then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return alchemist.attacks.claustrophobia[class]
		end,
		catalyze = false,
		call = "claustrophobia",
	},

	["vertigo"] = {
		Alchemist = "derive hallucinogen target vertigo",
		Shaman = "shaman divulgence target vertigo",
		can = function()
			local target = rime.target
			if not alchemist.can("experimentation") then return false end
			if not hasSkill("Hallucinogen") and not hasSkill("Divulgence") then return false end
			if rime.pvp.has_aff("vertigo", target) then return false end
			if not rime.pvp.has_aff("impatience", target) then return false end
			if rime.pvp.count_affs("mental", target) < 3 then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return alchemist.attacks.vertigo[class]
		end,
		catalyze = false,
		call = "vertigo",
	},

	["loneliness"] = {
		Alchemist = "derive hallucinogen target loneliness",
		Shaman = "shaman divulgence target loneliness",
		can = function()
			local target = rime.target
			if not alchemist.can("experimentation") then return false end
			if not hasSkill("Hallucinogen") and not hasSkill("Divulgence") then return false end
			if rime.pvp.has_aff("loneliness", target) then return false end
			if not rime.pvp.has_aff("impatience", target) then return false end
			if rime.pvp.count_affs("mental", target) < 3 then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return alchemist.attacks.loneliness[class]
		end,
		catalyze = false,
		call = "loneliness",
	},

	["shyness"] = {
	 	Alchemist = "derive hallucinogen target shyness",
	 	Shaman = "shaman divulgence target shyness",
	 	can = function()
	 		local target = rime.target
	 		if not alchemist.can("experimentation") then return false end
	 		if not hasSkill("Hallucinogen") and not hasSkill("Divulgence") then return false end
	 		if rime.pvp.has_aff("shyness", target) then return false end
	 		if not rime.pvp.has_aff("impatience", target) then return false end
	 		if rime.pvp.count_affs("mental", target) < 3 then return false end
	 		return true
	 	end,
	 	choice = function()
	 		local class = gmcp.Char.Status.class
	 		return alchemist.attacks.shyness[class]
	 	end,
	 	catalyze = false,
	 	call = "shyness",
	 },

	["paranoia"] = {
	 	Alchemist = "derive hallucinogen target paranoia",
	 	Shaman = "shaman divulgence target paranoia",
	 	can = function()
	 		local target = rime.target
	 		if not alchemist.can("experimentation") then return false end
	 		if not hasSkill("Hallucinogen") and not hasSkill("Divulgence") then return false end
	 		if rime.pvp.has_aff("paranoia", target) then return false end
	 		if not rime.pvp.has_aff("impatience", target) then return false end
	 		if rime.pvp.count_affs("mental", target) < 3 then return false end
	 		return true
	 	end,
	 	choice = function()
	 		local class = gmcp.Char.Status.class
	 		return alchemist.attacks.paranoia[class]
	 	end,
	 	catalyze = false,
	 	call = "paranoia",
	 },

	["superstition"] = {
	 	Alchemist = "derive hallucinogen target superstition",
	 	Shaman = "shaman divulgence target superstition",
	 	can = function()
	 		local target = rime.target
	 		if not alchemist.can("experimentation") then return false end
	 		if not hasSkill("Hallucinogen") and not hasSkill("Divulgence") then return false end
	 		if rime.pvp.has_aff("superstition", target) then return false end
	 		if not rime.pvp.has_aff("impatience", target) then return false end
	 		if rime.pvp.count_affs("mental", target) < 3 then return false end
	 		return true
	 	end,
	 	choice = function()
	 		local class = gmcp.Char.Status.class
	 		return alchemist.attacks.superstition[class]
	 	end,
	 	catalyze = false,
	 	call = "superstition",
	 },

	["fuckin_bye"] = {
		Alchemist = "derive causality target in 6",
	 	Shaman = "shaman omen target in 6",
	 	can = function()
	 		local target = rime.target
	 		if not alchemist.can("experimentation") then return false end
	 		if not hasSkill("Causality") and not hasSkill("Omen") then return false end
	 		if not rime.pvp.has_aff("infested", target) then return false end
	 		if not rime.pvp.has_aff("blighted", target) then return false end
	 		if not rime.pvp.has_aff("stormtouched", target) then return false end
	 		if not rime.pvp.has_aff("paranoia", target) then return false end
	 		if rime.targets[target].causality then return false end
	 		return true
	 	end,
	 	choice = function()
	 		local class = gmcp.Char.Status.class
	 		return alchemist.attacks.fuckin_bye[class]
	 	end,
	 	catalyze = false,
	 	call = false,
	 },

	["virulent_loki"] = {
	 	Alchemist = "alchemy virulent target",
	 	Shaman = "commune vinelash target",
	 	can = function()
	 		local target = rime.target
	 		if not alchemist.can("alchemy") then return false end
	 		if not hasSkill("Virulent") and not hasSkill("Vinelash") then return false end
	 		return true
	 	end,
	 	choice = function()
	 		local class = gmcp.Char.Status.class
	 		return alchemist.attacks.virulent_loki[class]
	 	end,
	 	catalyze = false,
	 	call = false,
	 },

	 ["virulent_stupidity"] = {
	 	Alchemist = "alchemy virulent target aconite",
	 	Shaman = "commune vinelash target aconite",
	 	can = function()
	 		local target = rime.target
	 		if not alchemist.can("alchemy") then return false end
	 		if not hasSkill("Virulent") and not hasSkill("Vinelash") then return false end
	 		if not rime.pvp.has_aff("impatience") then return false end
	 		if rime.pvp.has_aff("stupidity", target) then return false end
	 		if not rime.targets[target].intoxicant then return false end
	 		return true
	 	end,
	 	choice = function()
	 		local class = gmcp.Char.Status.class
	 		return alchemist.attacks.virulent_stupidity[class]
	 	end,
	 	catalyze = false,
	 	call = "aconite",
	 },

	["blackout"] = {
	 	Alchemist = "alchemy electroshock target",
	 	Shaman = "commune overload target",
	 	can = function()
			local target = rime.target
			if not alchemist.can("alchemy") then return false end
			if not hasSkill("Electroshock") and not hasSkill("Overload") then return false end
			if rime.targets[target].channel then return true end
			if rime.vitals.volatility <= 1 then return false end
			if rime.pvp.has_aff("stupidity", target) then return false end
			if rime.pvp.has_aff("paresis", target) then return false end
			if rime.pvp.has_aff("paralysis", target) then return false end
			if not rime.pvp.has_aff("impatience", target) then return false end
			return true
		end,
		choice = function()
			local class = gmcp.Char.Status.class
			return alchemist.attacks.blackout[class]
		end,
		catalyze = true,
		call = false,
	 },

	["discorporate"] = {
        Alchemist = "alchemy discorporate target",
        Shaman = "commune reclamation target",
        can = function()
            local target = rime.target
            local phobia = {"fear", "agoraphobia", "claustrophobia", "vertigo","loneliness","shyness","paranoia","superstition"}
            local phobia_count = 0
            for k,v in ipairs(phobia) do
                if rime.pvp.has_aff(v, target) then
                	phobia_count = phobia_count+1
                end
            end
            if tonumber(phobia_count) > 4 and rime.pvp.has_aff("dread", target) then
                return true
            else
                return false
            end
        end,
        choice = function()
            local class = gmcp.Char.Status.class
            return alchemist.attacks.discorporate[class]
        end,
        catalyze = false,
        call = false,
    },

    ["damage"] = {
    	Alchemist = "alchemy static target",
    	Shaman = "commune lightning target",
    	can = function()
    		local target = rime.target
    		if rime.pvp.has_aff("locked", target) or (rime.pvp.has_aff("stormtouched", target) and rime.pvp.has_aff("sensitivity", target)) then 
    			return true
    		else
    			return false
    		end
    	end,
    	choice = function()
    		local class = gmcp.Char.Status.class
    		return alchemist.attacks.damage[class]
    	end,
    	catalyze = true,
    	call = false,
    },

    ["rousing_sensitivity"] = {
    	Alchemist = "alchemy rousing target",
    	Shaman = "commune effusion target",
    	can = function()
    		local target = rime.target
    		if rime.pvp.has_aff("sensitivity", target) then return false end
    		if rime.vitals.volatility < 2 then return false end
    	end,
    	choice = function()
    		local class = gmcp.Char.Status.class
    		return alchemist.attacks.rousing_sensitivity[class]
    	end,
    	catalyze = true,
    	call = false,
    },

    ["push_sensitivity"] = {
    	Alchemist = "alchemy rousing target",
    	Shaman = "commune effusion target",
    	can = function()
    		local target = rime.target
    		if rime.pvp.has_aff("sensitivity", target) then return false end
    		if not rime.targets[target].causality then return false end
    		return true
    	end,
    	choice = function()
    		local class = gmcp.Char.Status.class
    		return alchemist.attacks.push_sensitivity[class]
    	end,
    	catalyze = true,
    	call = false,
    },

    ["virulent"] = {
    	Alchemist = "alchemy virulent target venom",
    	Shaman = "commune vinelash target venom",
    	can = function()
    		return true
    	end,
    	choice = function()
    		local class = gmcp.Char.Status.class
    		return alchemist.attacks.virulent[class]
    	end,
    	catalyze = false,
    	call = "venom",
    },

   ["channel_interrupt"] = {
   	Alchemist = "alchemy virulent target delphinium",
   	Shaman = "commune vinelash target delphinium",
   	can = function()
   		local target = rime.target
   		if not alchemist.can("alchemy") then return false end
   		if not hasSkill("Virulent") and not hasSkill("Vinelash") then return false end
   		if not rime.targets[target].channel then return false end
   		return true
   	end,
   	choice = function()
   		local class = gmcp.Char.Status.class
   		return alchemist.attacks.channel_interrupt[class]
   	end,
   	catalyze = false,
   	call = "delphinium",
   },

    ["shielded"] = {
    	Alchemist = "alchemy corrosive target",
    	Shaman = "commune leafstorm target",
    	can = function()
    		local target = rime.target
    		if rime.pvp.has_def("shielded", target) then return true end
    		return false
    	end,
    	choice = function()
    		local class = gmcp.Char.Status.class
    		return alchemist.attacks.shielded[class]
    	end,
    	catalyze = false,
    	call = false,
    },

}

function alchemist.venom_filter()

	local target = rime.target

	local usable_venoms = {"haemophilia", "vomiting", "allergies", "clumsiness", "sensitivity", "recklessness", "dizziness", "weariness"}

	for k,v in ipairs(rime.pvp.route.attacks) do
		if rime.convert_affliction(v) and not rime.pvp.has_aff(v, target) and table.contains(usable_venoms, v) then
			return rime.convert_affliction(v)
		end
	end

end

function alchemist.can(skillset)

	return true

end

function alchemist.get_attack()

	for k,v in ipairs(rime.pvp.route.attacks) do
		if alchemist.attacks[v].can() then
			return alchemist.attacks[v].choice(), alchemist.attacks[v].catalyze, alchemist.attacks[v].call
		end
	end

end

function alchemist.offense()

	local target = rime.target
	local queue = rime.pvp.queue_handle()
	local attack, catalyze, call = alchemist.get_attack()
	local sep = rime.saved.separator
	local class = gmcp.Char.Status.class
	local class_cata = {
		Alchemist = "alchemy catalyse",
		Shaman = "commune boost",
	}
	local ally = "Bulrok"
	for k,v in ipairs(rime.saved.allies) do
		if rime.targets[v].aggro > rime.targets[ally].aggro and table.contains(swarm.room, v) then
			ally = v
		end
	end

	if not has_def("cognisance") and class == "Alchemist" then
		queue = queue .. sep .. "derive cognisance on"
	end

	if not has_def("shaman_spiritsight") and class == "Shaman" then
		queue = queue .. sep .. "shaman spiritsight on"
	end

	if alchemist.exposed_target ~= rime.target then
		expose_command_list = {
			Shaman = "fetish attune",
			Alchemist = "compound expose"
		}
		queue = queue .. sep .. expose_command_list[class] .. " "..target
	end

	if catalyze then
		attack = class_cata[class] .. sep .. attack
	end

	if attack:find("venom") then
		attack = attack:gsub("venom", alchemist.venom_filter())
	end

	if rime.pvp.web_aff_calling and call then

		if call:find("venom") then
			call = call:gsub("venom", alchemist.venom_filter())
		end

		call = rime.pvp.omniCall(call)

		attack = call .. sep .. attack

	end

	if attack:find("target") then
		attack = attack:gsub("target", target)
	elseif attack:find("ally") then
		attack = attack:gsub("ally", ally)
	end

	act(queue .. sep .. attack)

end