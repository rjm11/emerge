--Authors: Mjoll, Rijetta, Almol, Kurak, Bulrok
rime.pvp.Ascended.routes = {
	 ["black"] = {
		  ["blurb"] = {"Why are you dueling in this class????"},
		  ["attacks"] = {
			   "portal",
			   "self_heal",
			   "shielded",
			   "nuke",
			   "purify_ally",
			   "smoulder",
			   "shards",
			   "avatar",
		  },
		  ["riot"] = {
			   "impatience",
			   "sensitivity",
			   "asthma",
			   "stupidity",
			   "anorexia",
			   "recklessness",
		  },
		  ["venoms"] = {
			   "stupidity",
			   "paresis",
			   "asthma",
			   "slickness",
			   "sensitivity",
			   "anorexia",
			   "left_leg_broken",
			   "right_leg_broken",               
		  },
	 },

	 ["group"] = {
		  ["blurb"] = {"Aff support"},
		  ["attacks"] = {
			   "portal",
			   "nuke",
			   "purify_ally",
			   "self_heal",
			   "avatar",
			   "shards",
			   "smoulder",
		  },
		  ["riot"] = {
			   "impatience",
			   "asthma",
			   "anorexia",
			   "sensitivity",
			   "stupidity",
			   "recklessness",
		  },
		  ["venoms"] = {
			   "paresis",
			   "asthma",
			   "slickness",
			   "anorexia",
			   "left_leg_broken",
			   "right_leg_broken",  
		  },
	 },

	 ["groups"] = {
		  ["blurb"] = {"Aff support"},
		  ["attacks"] = {
			   "portal",
			   "embrace",
			   "nuke",
			   "purify_ally",
			   "wither_resists",
			   "shards",
			   "smoulder",
			   "avatar",
		  },
		  ["riot"] = {
			   "impatience",
			   "asthma",
			   "anorexia",
			   "sensitivity",
			   "stupidity",
			   "recklessness",
		  },
		  ["venoms"] = {
			   "paresis",
			   "asthma",
			   "slickness",
			   "anorexia",
			   "left_leg_broken",
			   "right_leg_broken",  
		  },
	 },


	 ["aoe"] = {
		  ["blurb"] = {"Does it blend 🤔"},
		  ["attacks"] = {
			   "portal",
			   "self_heal",
			   "nuke",
			   "blend_physical",
		  },
		  ["riot"] = {
			   "sensitivity",
			   "impatience",
			   "asthma",
			   "anorexia",
			   "stupidity",
			   "recklessness",
		  },
		  ["venoms"] = {
		  	 "paresis",
		  	 "asthma",
		  	 "slickness",
		  	 "anorexia",

		  },
	 },

}

ascended = ascended or {}
ascended.mortalfire = true
ascended.secondary = true
ascended.resource = ascended.resource or {}
ascended.resource.Strife = ascended.resource.Strife or 0
ascended.resource.Tyranny = ascended.resource.Tyranny or 0
ascended.resource.Corruption = ascended.resource.Corruption or 0
ascended.resource.Memory = ascended.resource.Memory or 0
ascended.resource.Titan = ascended.resource.Titan or 0
ascended.resource.Aetherial = ascended.resource.Aetherial or 0
ascended.portal = true

ascended.attacks = {

	["purify_ally"] = {
		Strife = "adherent purify ally",
		Tyranny = "adherent purify ally",
		Corruption = "adherent purify ally",
		Memory = "adherent purify ally",
		Titan = "titan defy ally",
		can = function()
			--rime.pvp.ally = rime.pvp.ally or rime.saved.allies[1]
			local ally = rime.pvp.pick_ally("aggro")
			if rime.targets[ally].aggro <= 3 then return false end
			return true
		end,
		choice = function()
			local class = rime.saved.ascended_class
			return ascended.attacks.purify_ally[class]
		end,
		},

	["shielded"] = {
		All = "touch hammer target",
		can = function()
			local targ = rime.target
				if rime.pvp.has_def("shielded", targ) then return true end
				return false
			end,
		choice = function()
			return ascended.attacks.shielded.all
		end,
	},

	 ["shards"] = {
		  Strife = "adherent shards target",
		  Tyranny = "adherent oppress target",
		  Corruption = "adherent spiral target",
		  Memory = "adherent shend target",
		  Titan = "titan fissure target",
		  can = function()
			   if #rime.missingAff("paresis/clumsiness/vomiting/weariness/asthma/haemophilia","/") > 0 then
					return true
			   end
			   return false
		  end,
		  choice = function()
		  	local class = rime.saved.ascended_class
		  	return ascended.attacks.shards[class]
		  end,
	 },

	["avatar"] = {
		Strife = "adherent avatar target",
		Tyranny = "adherent avatar target",
		Corruption = "adherent avatar target",
		Memory = "adherent avatar target",
		Titan = "titan spear target",
		can = function()
			if not ascended.get_venom() then  
				return false
			end
			return true
		end,
		choice = function()
			local class = rime.saved.ascended_class
			return ascended.attacks.avatar[class]
		end,
	 },

	["smoulder"] = {
		Strife = "adherent smoulder target",
		Tyranny = "adherent pillage target",
		Corruption = "adherent coldflame target",
		Memory = "adherent recalesce target",
		Titan = "titan sicken target",
		can = function()
			if #rime.missingAff("stupidity/indifference/recklessness/confusion/anorexia/dementia","/") > 0 then
				return true
			end
			return false
		end,

		choice = function()
		 	local class = rime.saved.ascended_class
		 	return ascended.attacks.smoulder[class]
		end
	},

	["portal"] = {
		Strife = "adherent legion target",
		Tyranny = "adherent enslave target",
		Corruption = "adherent gifts target",
		Memory = "adherent sovenance target",
		Titan = "titan eldcall target",
		can = function()
			if ascended.portal then
				return true
			end
			return false
		end,
		choice = function()
			local class = rime.saved.ascended_class
			return ascended.attacks.portal[class]
		end,
	},

	["magic_weakness"] = {
		Strife = "adherent wither target",
		Tyranny = "adherent quell target",
		Corruption = "adherent decay target",
		Memory = "adherent unwind target",
		Titan = "titan staredown target",
			can = function()
			   if ascended.resource[rime.saved.ascended_class] < 1 then return false end
			   local target = rime.target
			   if not rime.pvp.has_aff("magic_weakness", target) then 
					return true
			   end
			   return false
		  end,
		choice = function()
			local class = rime.saved.ascended_class
			return ascended.attacks.magic_weakness[class]
		end,
	 },

	["slickness"] = {
		Strife = "adherent wither target",
		Tyranny = "adherent quell target",
		Corruption = "adherent decay target",
		Memory = "adherent unwind target",
		Titan = "titan staredown target",
		can = function()
			if ascended.resource[rime.saved.ascended_class] < 1 then return false end
			local target = rime.target
			if not rime.pvp.has_aff("magic_weakness", target) then 
				return true
			elseif not rime.pvp.has_aff("slickness", target) then 
				return true
			end
			return false
		end,
		choice = function()
			local class = rime.saved.ascended_class
			return ascended.attacks.slickness[class]
		end,
	},

	["self_heal"] = {
		Strife = "adherent embrace",
		Tyranny = "adherent despot",
		Corruption = "adherent descent",
		Memory = "adherent spite",
		Titan = "titan energize",
		can = function()
			local class = rime.saved.ascended_class
			if ascended.resource[class] < 2 then return false end
			if rime.vitals.percent_health < 50 or rime.vitals.percent_mana < 50 or rime.affTally > 5 then
				return true
			elseif ascended.resource[rime.saved.ascended_class] == 5 then
				return true
			end
				return false
		end,
		choice = function()
			local class = rime.saved.ascended_class
			return ascended.attacks.self_heal[class]
		end
	},

	["nuke"] = {
		Strife = "adherent catastrophe target",
		Tyranny = "adherent conquer target",
		Corruption = "adherent might target",
		Memory = "adherent temerate target",
		Titan = "titan crush target",
		can = function()
			if ascended.resource[rime.saved.ascended_class] < 3 then return false end
			return true
		end,
		choice = function()
			local class = rime.saved.ascended_class
			return ascended.attacks.nuke[class]
		end
	},

	["sensitivity_nuke"] = {
		Strife = "adherent catastrophe target",
		Tyranny = "adherent conquer target",
		Corruption = "adherent might target",
		Memory = "adherent temerate target",
		Titan = "titan crush target",
		can = function()
			local target = rime.target
			if ascended.resource[rime.saved.ascended_class] >= 3 and rime.pvp.has_aff("sensitivity", target) then
				return true
			end
				return false
		end,
		choice = function()
			local class = rime.saved.ascended_class
			return ascended.attacks.sensitivity_nuke[class]
		end,
	},

	["blend_physical"] = {
		Strife = "adherent vortex shards",
		Tyranny = "adherent vortex oppress",
		Corruption = "adherent vortex spiral",
		Memory = "adherent vortex shend",
		Titan = "titan onslaught fissure",
		can = function()
			return true
		end,
		choice = function()
			local class = rime.saved.ascended_class
			return ascended.attacks.blend_physical[class]
		end,
	 },

}

function ascended.doARiot()

	 local target = rime.target
	 local class = rime.saved.ascended_class
	 local attack = {
	 	["Strife"] = "adherent riot "..target,
	 	["Tyranny"] = "adherent besiege "..target,
	 	["Corruption"] = "adherent duskywing "..target,
	 	["Memory"] = "adherent senesce "..target,
	 	["Titan"] = "titan corrode "..target,
	 }

	 if rime.pvp.has_def("shielded", target) then 
		  return attack[class] .. " shield"
	 end

	 local aff_prio = rime.pvp.route.riot 
	 if #rime.missingAff("stupidity/anorexia/impatience/asthma/sensitivity/recklessness","/") == 0 then 
		  return attack[class] .. " impatience"
	 else
		  for k,v in pairs(aff_prio) do
			   if not rime.pvp.has_aff(v, target) then
					return attack[class] .. " " .. v
			   end
		  end
	 end

end

function ascended.get_attack()

	local targ = rime.target

	 for k,v in ipairs(rime.pvp.route.attacks) do
		  --rime.echo(v)
		  if ascended.attacks[v].can() then
			   return ascended.attacks[v].choice():gsub("target", rime.target):gsub("ally", rime.pvp.pick_ally("aggro"))
		  end
	 end

	return false

end

function ascended.get_venom()
	local venom_library = {
		clumsiness = "xentio",
		stuttering = "jalk",
		blindness = "oleander",
		recklessness = "eurypteria",
		asthma = "kalmia",
		shyness = "digitalis",
		allergies = "darkshade",
		paresis = "curare",
		no_blind = "oculus",
		no_deaf = "prefarar",
		sensitivity = "prefarar",
		blurry_vision = "oculus",
		disfigurement = "monkshood",
		vomiting = "euphorbia",
		weariness = "vernalius",
		dizziness = "larkspur",
		anorexia = "slike",
		voyria = "voyria",
		peace = "ouabain",
		stupidity = "aconite",
		slickness = "gecko",
		haemophilia = "hepafarin",
		thin_blood = "scytherus",
		asleep = "delphinium",
		left_arm_broken = "epteth",
		right_arm_broken = "epteth",
		left_leg_broken = "epseth",
		right_leg_broken = "epseth",
		squelched = "selarnia",
		deadening = "vardrax",
	}

	 for k,v in ipairs(rime.pvp.route.venoms) do
		  if not rime.pvp.has_aff(v, targ) and v ~= rime.convert_venom(ascended.doubleHitVenomDeluxeOnlyAtTacoBell) then
			   return venom_library[v]
		  end
	 end
	 return false

end

function ascended.offense()

	 local command = ascended.get_attack()
	 local sep = rime.saved.separator
	 local venom = ascended.get_venom() or ""

	if rime.pvp.targetThere and rime.pvp.web_aff_calling then
		if command:find("avatar") or ascended.sync or command:find("spear") then
			if ascended.sync then
				if command:find("avatar") or command:find("spear") then 
					local web_call = rime.pvp.omniCall(venom:lower().."/"..ascended.doubleHitVenomDeluxeOnlyAtTacoBell:lower())
					command = rime.pvp.queue_handle() .. sep .. web_call .. sep .. command .." ".. venom
				else
					local web_call = rime.pvp.omniCall(ascended.doubleHitVenomDeluxeOnlyAtTacoBell:lower())
					command = rime.pvp.queue_handle() .. sep .. web_call .. sep .. command
				end
			else
				if command:find("avatar") or command:find("spear") then 
					local web_call = rime.pvp.omniCall(venom:lower())
					command = rime.pvp.queue_handle() .. sep .. web_call .. sep .. command .." ".. venom
				else
					local web_call = rime.pvp.omniCall(venom:lower())
					command = rime.pvp.queue_handle() .. sep .. web_call .. sep .. command
				end
			end
		elseif command:find("embrace") or command:find("energize") then
			command = rime.pvp.queue_handle() .. sep .. command .. sep .. ascended.doARiot()
		else
			command = rime.pvp.queue_handle() .. sep .. command
		end
	else
		if command:find("avatar") or command:find("spear") then
			command = rime.pvp.queue_handle() .. sep .. command .. " ".. venom
		elseif command:find("embrace") or command:find("energize") then 
			command = rime.pvp.queue_handle() .. sep .. command..sep..ascended.doARiot()
		else
			command = rime.pvp.queue_handle() .. sep .. command
		end 
	end

	command = command:gsub(sep .. sep .. "+", sep)
	command = command .. rime.pvp.post_queue()

	if command ~= rime.balance_queue and command ~= rime.balance_queue_attempted then
		act(command)
		rime.balance_queue_attempted = command
	end

	if ascended.secondary then
		if rime.pvp.targetThere then
			act(ascended.doARiot())
		end
	end

end

