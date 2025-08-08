rime = rime or {}
rime.version = 13.2
rime.targets = rime.targets or {}
ascended = ascended or {}
	if file_exists(getMudletHomeDir().."/rime.targets.lua") then
		table.load(getMudletHomeDir().."/rime.targets.lua", rime.targets)
	else
		table.save(getMudletHomeDir().."/rime.targets.lua", rime.targets)
	end
rime.saved = rime.saved or {}
	if file_exists(getMudletHomeDir().."/rime.saved.lua") then
		table.load(getMudletHomeDir().."/rime.saved.lua", rime.saved)
	else
		rime_initial_setup()
	end
rime.firstaid = false
rime.pve = rime.pve or {}
rime.pvp = rime.pvp or {}
rime.curing = rime.curing or {}
rime.defences = rime.defences or {}
rime.afflictions = rime.afflictions or {}
rime.hidden_afflictions = rime.hidden_afflictions or {}
rime.hidden_affs_total = 0
rime.vitals = rime.vitals or {}
rime.gmcp = rime.gmcp or {}
rime.balances = rime.balances or {}
rime.balances.nimbleness = rime.balances.nimbleness or true
rime.status = rime.status or {}
rime.vitals.dead = false
rime.death_check = false
rime.paused = false
rime.movement = rime.movement or {}
rime.movement.mode = "nothing"
rime.target = rime.target or "none"
rime.secondary_queue = "none"
rime.secondary_queue_attempted = "none"
sendGMCP('Core.Supports.Add ["IRE.Tasks 1"]')
sendGMCP('Core.Supports.Add ["Comm.Channel 1"]')

function rime.remove_value(t, value)
    for i = 1, #t do
        if t[i] == value then
            table.remove(t, i)
            return
        end
    end
end

function rime.item_selection(item, item_id)

	for k,v in pairs(rime.item_categories) do
		--if table.contains(v, item) then
		if v[item] then
			rime.item_categories[k].menu(item, item_id)
			break
		end
	end
	
end

function rime.class_armor()

	local armor = {
	["Alchemist"] = "ringmail",
	["Archivist"] = "chainmail",
	["Bard"] = "scalemail",
	["Carnifex"] = "fieldplate",
	["Earthcaller"] = "splintmail",
	["Indorani"] = "ringmail",
	["Praenomen"] = "scalemail",
	["Revenant"] = "fieldplate",
	["Sciomancer"] = "nothing",
	["Syssin"] = "scalemail",
	["Shapeshifter"] = "none",
	["Adherent"] = "none",
	["Bloodborn"] = "none",
	}

	local class = gmcp.Char.Status.class

	return armor[class]

end


rime.item_categories = {

	["weapons"] = {
		menu = function(item, item_id)
					setPopup("main", {[[send("wp " .. ]] .. item_id .. [[)]], [[send("wield " .. ]] .. item_id .. [[)]]}, {"Weaponprobe "..item..item_id, "Wield "..item..item_id})
				end,
		scythe = true,
		bonedagger = true,
		javelin = true,
		boomerang = true,
		warhammer = true,
		bardiche = true,
		halberd = true,
		greatmaul = true,
		scimitar = true,
		longsword = true,
		shortsword = true,
		morningstar = true,
		broadsword = true,
		
	},
	["miningcomms"] = {
		menu = function(item, item_id)
					setPopup("main", {[[send("mining retrieve " .. ]] .. item_id .. [[)]]}, {[[send("mining retreive " .. ]] .. item_id .. [[)]]})
				end,
		bituminous = true,
		lignite = true,
		ironore = true,
		silverore = true,
		goldore = true,
	},
}

rime.cooldowns = {
	deathknell = true,
	ruscitation = false,
}

rime.triggerList = rime.triggerList or {}
if rime.clearTriggers then rime.clearTriggers() end
rime.aliasList = rime.aliasList or {}
if rime.clearAliases then rime.clearAliases() end
rime.eventList = rime.eventList or {}
if rime.clearEvents then rime.clearEvents() end

function rime.makeTrigger(arg)
    local triggerId
    if type(arg.type) == "function" then
        triggerId = arg.type(arg.pattern, arg.action)
    elseif arg.type == "regex" then
        triggerId = tempRegexTrigger(arg.pattern, arg.action)
    elseif arg.type == "beginline" then
        triggerId = tempBeginOfLineTrigger(arg.pattern, arg.action)
    else
        triggerId = tempTrigger(arg.pattern, arg.action)
    end
    table.insert(rime.triggerList, triggerId)
end

function rime.clearTriggers()
    for _,trigger in pairs(rime.triggerList) do killTrigger(trigger) end
    rime.triggerList = {}
end

rime.aliasList = rime.aliasList or {}
if rime.clearAliases then rime.clearAliases() end

function rime.makeAlias(arg)
    local aliasId
    if arg.name and arg.func then
        aliasId = tempAlias(arg.name, arg.func)
        table.insert(rime.aliasList, aliasId)
    end
end

function rime.clearAliases()
    for _, aliasId in pairs(rime.aliasList) do
        killAlias(aliasId)
    end
    rime.aliasList = {}
end

rime.eventList = rime.eventList or {}
if rime.clearEvents then rime.clearEvents() end

function rime.makeEvent(arg)
    local eventId
    if arg.name and arg.func then
        eventId = registerAnonymousEventHandler(arg.name, arg.func)
        table.insert(rime.eventList, eventId)
    end
end

function rime.clearEvents()
    for _, eventId in pairs(rime.eventList) do
        killAnonymousEventHandler(eventId)
    end
    rime.eventList = {}
end


function rime.echo(msg, type)

    if not type then
    
        cecho("\n<DeepPink>\(<CornflowerBlue>Rime<DeepPink>\)<white> "..msg)
        
    elseif type == "pvp" then
    
        cecho("\n<"..rime.saved.echo_colors.pvp.parenthesis..">\(<"..rime.saved.echo_colors.pvp.title..">PvP<"..rime.saved.echo_colors.pvp.parenthesis..">\)<white> "..msg)
        
    elseif type == "pve" then
    
        cecho("\n<"..rime.saved.echo_colors.pve.parenthesis..">\(<"..rime.saved.echo_colors.pve.title..">PvE<"..rime.saved.echo_colors.pve.parenthesis..">\)<white> "..msg)
        
    elseif type == "def" then
    
        cecho("\n<"..rime.saved.echo_colors.def.parenthesis..">\(<"..rime.saved.echo_colors.def.title..">Defence<"..rime.saved.echo_colors.def.parenthesis..">\)<white> "..msg)
        
    elseif type == "curing" then
    
        cecho("\n<"..rime.saved.echo_colors.curing.parenthesis..">\(<"..rime.saved.echo_colors.curing.title..">Curing<"..rime.saved.echo_colors.curing.parenthesis..">\)<white> "..msg)

    elseif type == "order" then

        cecho("\n<"..rime.saved.echo_colors.order.parenthesis..">\(<"..rime.saved.echo_colors.order.title..">Chakrasul<"..rime.saved.echo_colors.order.parenthesis..">\)<white> "..msg)

    elseif type == "war" then

        cecho("\n<"..rime.saved.echo_colors.war.parenthesis..">\(<"..rime.saved.echo_colors.war.title..">War<"..rime.saved.echo_colors.war.parenthesis..">\)<white> "..msg)

    elseif type == "merchant" then

    	cecho("\n<"..rime.saved.echo_colors.merchant.parenthesis..">\(<"..rime.saved.echo_colors.merchant.title..">Merchant<"..rime.saved.echo_colors.merchant.parenthesis..">\)<white> " ..msg)

    elseif type == "debug" then

    	cecho("\n<red>\(<CornflowerBlue>Rime Bug:<red>\)<white> "..msg)

    end



end


function class_color()

	local class = rime.status.class
	
	if class == "Infiltrator" then
	
		return "<DarkSlateGrey>"

	elseif class == "Alchemist" then
		
		return "<purple>"
		
	elseif class == "Praenomen" then
	
		return "<red>"

	elseif class == "Teradrim" then

		return "<burlywood>"
		
	elseif class == "Shapeshifter" then

		return "<BlueViolet>"

	elseif class == "Sentinel" then

		return "<NavajoWhite>"

	elseif class == "Executor" then

		return "<a_darkgrey>"
		
	elseif class == "Carnifex" then
	
		return "<red>"

	elseif class == "Indorani" then

		return "<magenta>"

	elseif class == "Archivist" then

		return "<SeaGreen>"

	elseif class == "Sciomancer" then

		return "<DarkTurquoise>"

	elseif class == "Monk" then

		return "<khaki>"

	elseif class == "Templar" then

		return "<gold>"

	elseif class == "Wayfarer" then

		return "<SlateGrey>"

	elseif class == "Revenant" then

		return "<midnight_blue>"

	elseif class == "Shaman" then

		return "<forest_green>"

	elseif class == "Earthcaller" then

		return "<AntiqueWhite>"

	elseif class == "Luminary" then

		return "<light_goldenrod>"

	elseif class == "Bard" then

		return "<pale_turquoise>"

	elseif class == "Predator" then

		return "<tan>"

	elseif class == rime.saved.ascended_class then

		if rime.saved.ascended_class == "Strife" then

			return "<dim_grey>"

		elseif rime.saved.ascended_class == "Tyranny" then

			return "<a_darkred>"

		elseif rime.saved.ascended_class == "Corruption" then

			return "<dark_green>"

		elseif rime.saved.ascended_class == "Memory" then

			return "<medium_purple>"

		elseif rime.saved.ascended_class == "Titan" then

			return "<dark_goldenrod>"

		end

    elseif class == "Ravager" then
        
        return "<firebrick>"

    elseif class == "Akkari" then

    	return "<PaleGoldenrod>"

	elseif class == "Bloodborn" then

		return "<dark_olive_green>"

	end
	
end

--Custom send function. Send everything through this by default. Will expand upon it later for things like channels.


function act(...)
    local sep = rime.saved.separator
    local action = table.concat(arg, sep)
    if action == nil or action  == "" then return end
    if rime.vitals.dead or rime.paused or has_def("barrier") then return end
    if action == "qeb " .. sep .. sep then return end

    if rime.saved.gag_command then
        send(action, false)
    else
        send(action)
    end
end

function rime.target_track(name)

    if rime.target == name:lower() then return end
    rime.target = string.lower(name)
    if id2 then killTrigger(id2) end
        id2 = tempTrigger(rime.target, [[selectString("]] .. rime.target .. [[", 1) fg("]]..rime.saved.echo_colors.target.title..[[") resetFormat()]])
        rime.target = string.title(name)
    if id then killTrigger(id) end
        id = tempTrigger(rime.target, [[selectString("]] .. rime.target .. [[", 1) fg("]]..rime.saved.echo_colors.target.title..[[") resetFormat()]])
        rime.echo("Now targetting <DodgerBlue>"..rime.target)
        local class = gmcp.Char.Status.class
    if class == "Indorani" then
        act("leech release")
    elseif class == "Syssin" then
        syssin.suggests_added = {}
        syssin.sealed = false
    end

    if rime.checkTime("focus", name) == nil then rime.time("focus", name) end
	if rime.checkTime("tree", name) == nil then rime.time("tree", name) end
	if rime.checkTime("renew", name) == nil then rime.time("renew", name) end
    if rime.checkTime("lockbreaker", name) == nil then rime.time("lockbreaker", name) end

    if rime.pvp.calling and not targetCalled then send("wt Target: "..rime.target) end

    GUI.target_aff()

end

rime.last_hit = rime.last_hit or "nothing"

rime.timer = rime.timer or {}
rime.limit = rime.limit or {}

function limitStart(action, time, person)

	--if person then
		
	if not time then

		if rime.timer[action] then killTimer(rime.timer[action]) end
		rime.limit[action] = true
		rime.timer[action] = tempTimer(.4, [[limitEnd("]]..action..[[")]])
		
	else

		if string.find(action, "restore") and rime.pvp.has_aff("rot_body", rime.target) then
			time = tonumber(time)*2
		end
	
		if rime.timer[action] then killTimer(rime.timer[action]) end
		rime.limit[action] = true
		rime.timer[action] = tempTimer(time, [[limitEnd("]]..action..[[")]])
		
	end

end

function limitEnd(action, person)
	if rime.timer[action] then
		killTimer(rime.timer[action])
	end
	rime.limit[action] = false

	if action == "singing" then
		rime.limit.action = false
		killTimer(rime.timer[action])
		rime.bard.singing = false
		rime.echo("No longer singing")
	end

	if string.find(action, "muddled_") then
        rime.limit[action] = false
        killTimer(rime.timer[action])
        local shmuck = action:gsub("muddled_", "")
        rime.pvp.remove_aff("muddled", shmuck)
    end

	if action == "playing" then
		rime.limit.action = false
		killTimer(rime.timer[action])
		rime.bard.playing = false
		rime.echo("No longer playing")
	end

	if string.find(action, "fangbarrier_") then
		rime.limit.action = false
		killTimer(rime.timer[action])
		local shmuck = action:gsub("fangbarrier_", "")
		rime.pvp.addDef("fangbarrier", shmuck)
	end

	if string.find(action, "speed_") then
		rime.limit.action = false
		killTimer(rime.timer[action])
		local shmuck = action:gsub("speed_", "")
		rime.pvp.addDef("speed", shmuck)
	end

	if string.find(action, "rev_crippled") then
		rime.limit[action] = false
		killTimer(rime.timer[action])
		local shmuck = action:gsub("rev_crippled_", "")
		rime.pvp.remove_aff("crippled", shmuck)
	end

	if string.find(action, "resonance") then
		rime.limit[action] = false
		killTimer(rime.timer[action])
		local shmuck = action:gsub("resonance_", "")
		rime.pvp.remove_aff("resonance", shmuck)
	end

	if string.find(action, "infernal_shroud") then
		rime.limit[action] = false
		killTimer(rime.timer[action])
		local shmuck = action:gsub("infernal_shroud_", "")
		rime.pvp.remove_aff("infernal_shroud", shmuck)
	end

	if string.find(action, "infernal_seal") then
		rime.limit[action] = false
		killTimer(rime.timer[action])
		local shmuck = action:gsub("infernal_seal_", "")
		if not rime.pvp.has_aff("infernal_shroud", shmuck) then
			rime.pvp.remove_aff("infernal_seal", shmuck)
		else
			limitStart("infernal_seal_" .. shmuck, 30)
		end
	end

	if string.find(action, "rev_crippled_body") then
		rime.limit[action] = false
		killTimer(rime.timer[action])
		local shmuck = action:gsub("rev_crippled_body_", "")
		rime.pvp.remove_aff("crippled_body", shmuck)
	end

	if string.find(action, "_numbed_") then
		rime.limit[action] = false
		killTimer(rime.timer[action])
		local shmuck = action:gsub("%a+_%a+_numbed_", "")
		rime.pvp.remove_aff(action:gsub("_" .. shmuck, ""), shmuck)
	end

	if string.find(action, "flared_") then
		rime.limit[action] = false
		killTimer(rime.timer[action])
		local shmuck = action:gsub("flared_", "")
		rime.pvp.remove_aff("flared", shmuck)
	end

	if string.find(action, "weak_void") then
		action = action:gsub("weak_void_", "")
		rime.pvp.remove_aff("weak_void", action)
	end

	if string.find(action, "crushed_elbows") then
		action = action:gsub("crushed_elbows_", "")
		rime.pvp.remove_aff("crushed_elbows", action)
	end

	if action == "hypnosis" then
		if #syssin.suggests_added ~= 0 then
			syssin.suggests_added = {}
			syssin.sealed = false
			rime.echo("NEW HYPNOSIS CHAIN INCOMING", "pvp")
		end
	end

	if string.find(action, "stonevice") then
		rime.limit[action] = false
		killTimer(rime.timer[action])
		action = action:gsub("_stonevice", "")
		action = string.title(action)
		rime.pvp.remove_aff("stonevice", action)
	end

	if string.find(action, "feast") then
		rime.limit[action] = false
		killTimer(rime.timer[action])
		action = action:gsub("_feast", "")
		action = string.title(action)
		rime.pvp.remove_aff("blood_feast", action)
	end

	if string.find(action, "slough") then
		rime.limit[action] = false
		killTimer(rime.timer[action])
		action = action:gsub("_slough", "")
		action = string.title(action)
		rime.pvp.remove_aff("slough", action)
	end

	if string.find(action, "quicksand") then
		rime.limit[action] = false
		killTimer(rime.timer[action])
		action = action:gsub("_quicksand", "")
		action = string.title(action)
		rime.pvp.remove_aff("quicksand", action)
	end

	if action == "gloom_cure" then
		rime.limit[action] = false
		killTimer(rime.timer[action])
		if not rime.pvp.has_def("blind", rime.target) then
			rime.pvp.remove_aff("gloom", rime.target)
		end
	end

	if action == "soul_master" then
		rime.pvp.soul_master = true
		rime.echo("Need to lose the soulmaster!")
	end

	if string.find(action, "faulted") then
		rime.limit[action] = false
		killTimer(rime.timer[action])
		local shmuck = action:gsub("_faulted", "")
		rime.pvp.remove_aff("faulted", shmuck)
	end

	if string.find(action, "restore") then
		rime.limit[action] = false
		killTimer(rime.timer[action])
		local limb = string.match(action, "%w+_" .. "([a-z_]+)" .. "_restore")
		local shmuck = action:gsub("_" .. limb .. "_restore", "")
		if limb == "head" and rime.pvp.has_aff("mauled_face", shmuck) then
			rime.pvp.remove_aff("mauled_face", shmuck)
		elseif rime.pvp.has_aff(limb .. "_amputated", shmuck) then
			rime.pvp.remove_aff(limb .. "_amputated", shmuck)
		else
			if rime.pvp.has_aff(limb .. "_mangled", shmuck) then
				if rime.pvp.regenerate then
					rime.pvp.remove_limb(limb, 4500, shmuck)
					rime.pvp.regenerate = false
					if rime.targets[shmuck].limbs[limb] < 6600 then
						rime.pvp.remove_aff(limb .. "_mangled", shmuck)
					end
				else
					rime.pvp.remove_limb(limb, 3000, shmuck)
					if rime.targets[shmuck].limbs[limb] < 6600 then
						rime.pvp.remove_aff(limb .. "_mangled", shmuck)
					end
				end
			elseif rime.pvp.has_aff(limb .. "_broken", shmuck) then
				if rime.pvp.regenerate then
					rime.pvp.remove_limb(limb, 4000, shmuck)
					if rime.targets[shmuck].limbs[limb] < 3300 then
						rime.pvp.remove_aff(limb .. "_broken", shmuck)
						if limb == "torso" and rime.pvp.has_aff("soulpuncture", shmuck) then
							rime.pvp.remove_aff("soulpuncture", shmuck)
						end
					end
					rime.pvp.regenerate = false
				else
					rime.pvp.remove_limb(limb, 3000, shmuck)
					if rime.targets[shmuck].limbs[limb] < 3300 then
						rime.pvp.remove_aff(limb .. "_broken", shmuck)
						if limb == "torso" and rime.pvp.has_aff("soulpuncture", shmuck) then
							rime.pvp.remove_aff("soulpuncture", shmuck)
						end
					end
				end
			elseif limb == "torso" then
				if rime.pvp.has_aff("collapsed_lung", shmuck) then
					rime.pvp.remove_aff("collapsed_lung", shmuck)
				elseif rime.pvp.has_aff("burnt_skin", shmuck) then
					rime.pvp.remove_aff("burnt_skin", shmuck)
				elseif rime.pvp.has_aff("heatspear", shmuck) then
					rime.pvp.remove_aff("heatspear", rime.target)
				elseif rime.pvp.has_aff("deepwound", shmuck) then
					rime.pvp.remove_aff("deepwound", shmuck)
				else
					rime.pvp.remove_limb(limb, 3000, shmuck)
				end
			elseif limb == "head" then
				if rime.pvp.has_aff("smashed_throat", shmuck) then
					rime.pvp.remove_aff("smashed_throat", shmuck)
				elseif rime.pvp.has_aff("voidgaze", shmuck) then
					rime.pvp.remove_aff("voidgaze", shmuck)
				else
					rime.pvp.remove_limb(limb, 3000, shmuck)
				end
			elseif limb == "skin" then
				-- always all head afflictions and damage first
				if rime.pvp.has_aff("mauled_face", shmuck) then
					rime.pvp.remove_aff("mauled_face", shmuck)
				elseif rime.pvp.has_aff("head_mangled", shmuck) then
					if rime.pvp.regenerate then
						rime.pvp.remove_limb("head", 4500, shmuck)
						rime.pvp.regenerate = false
					else
						rime.pvp.remove_limb("head", 3000, shmuck)
					end
					if rime.targets[shmuck].limbs.head < 6600 then
						rime.pvp.remove_aff("head_mangled", shmuck)
					end
				elseif rime.pvp.has_aff("head_broken", shmuck) then
					if rime.pvp.regenerate then
						rime.pvp.remove_limb("head", 4000, shmuck)
						rime.pvp.regenerate = false
					else
						rime.pvp.remove_limb("head", 3000, shmuck)
					end
					if rime.targets[shmuck].limbs.head < 6600 then
						rime.pvp.remove_aff("head_broken", shmuck)
					end
				elseif rime.pvp.has_aff("smashed_throat", shmuck) then
					rime.pvp.remove_aff("smashed_throat", shmuck)
				elseif rime.pvp.has_aff("voidgaze", shmuck) then
					rime.pvp.remove_aff("voidgaze", shmuck)
				elseif rime.targets[shmuck].limbs.head > 0 then
					rime.pvp.remove_limb("head", 3000, shmuck)
				elseif rime.pvp.has_aff("collapsed_lung", shmuck) then
					rime.pvp.remove_aff("collapsed_lung", shmuck)
				elseif rime.pvp.has_aff("spinal_rip", shmuck) then
					rime.pvp.remove_aff("spinal_rip", shmuck)
				elseif rime.pvp.has_aff("burnt_skin", shmuck) then
					rime.pvp.remove_aff("burnt_skin", shmuck)
				elseif rime.pvp.has_aff("torso_mangled", shmuck) then
					if rime.pvp.regenerate then
						rime.pvp.remove_limb("torso", 4500, shmuck)
						rime.pvp.regenerate = false
					else
						rime.pvp.remove_limb("torso", 3000, shmuck)
					end
					if rime.targets[shmuck].limbs.torso < 6600 then
						rime.pvp.remove_aff("torso_mangled", shmuck)
					end
				elseif rime.pvp.has_aff("torso_broken", shmuck) then
					if rime.pvp.regenerate then
						rime.pvp.remove_limb("torso", 4000, shmuck)
						rime.pvp.regenerate = false
					else
						rime.pvp.remove_limb("torso", 3000, shmuck)
					end
					if rime.targets[shmuck].limbs.torso < 3300 then
						rime.pvp.remove_aff("torso_broken", shmuck)
						if rime.pvp.has_aff("soulpuncture", shmuck) then
							rime.pvp.remove_aff("soulpuncture", shmuck)
						end
					end
				elseif rime.pvp.has_aff("heatspear", shmuck) then
					rime.pvp.remove_aff("heatspear", shmuck)
				elseif rime.pvp.has_aff("deepwound", shmuck) then
					rime.pvp.remove_aff("deepwound", shmuck)
				elseif rime.targets[shmuck].limbs.torso > 0 then
					rime.pvp.remove_limb("torso", 3000, shmuck)
				elseif rime.pvp.has_aff("left_arm_amputated", shmuck) then
					rime.pvp.remove_aff("left_arm_amputated", shmuck)
				elseif rime.pvp.has_aff("left_arm_mangled", shmuck) then
					if rime.pvp.regenerate then
						rime.pvp.remove_limb("left_arm", 4500, shmuck)
						rime.pvp.regenerate = false
					else
						rime.pvp.remove_limb("left_arm", 3000, shmuck)
					end
					if rime.targets[shmuck].limbs.left_arm < 6600 then
						rime.pvp.remove_aff("left_arm_mangled", shmuck)
					end
				elseif rime.pvp.has_aff("left_arm_broken", shmuck) then
					if rime.pvp.regenerate then
						rime.pvp.remove_limb("left_arm", 4000, shmuck)
						rime.pvp.regenerate = false
					else
						rime.pvp.remove_limb("left_arm", 3000, shmuck)
					end
					if rime.targets[shmuck].limbs.left_arm < 3300 then
						rime.pvp.remove_aff("left_arm_broken", shmuck)
					end
				elseif rime.targets[shmuck].limbs.left_arm > 0 then
					rime.pvp.remove_limb("left_arm", 3000, shmuck)
				elseif rime.pvp.has_aff("right_arm_amputated", shmuck) then
					rime.pvp.remove_aff("right_arm_amputated", shmuck)
				elseif rime.pvp.has_aff("right_arm_mangled", shmuck) then
					if rime.pvp.regenerate then
						rime.pvp.remove_limb("right_arm", 4500, shmuck)
						rime.pvp.regenerate = false
					else
						rime.pvp.remove_limb("right_arm", 3000, shmuck)
					end
					if rime.targets[shmuck].limbs.right_arm < 6600 then
						rime.pvp.remove_aff("right_arm_mangled", shmuck)
					end
				elseif rime.pvp.has_aff("right_arm_broken", shmuck) then
					if rime.pvp.regenerate then
						rime.pvp.remove_limb("right_arm", 4000, shmuck)
						rime.pvp.regenerate = false
					else
						rime.pvp.remove_limb("right_arm", 3000, shmuck)
					end
					if rime.targets[shmuck].limbs.right_arm < 3300 then
						rime.pvp.remove_aff("right_arm_broken", shmuck)
					end
				elseif rime.targets[shmuck].limbs.right_arm > 0 then
					rime.pvp.remove_limb("right_arm", 3000, shmuck)
				elseif rime.pvp.has_aff("left_leg_amputated", shmuck) then
					rime.pvp.remove_aff("left_leg_amputated", shmuck)
				elseif rime.pvp.has_aff("left_leg_mangled", shmuck) then
					if rime.pvp.regenerate then
						rime.pvp.remove_limb("left_leg", 4500, shmuck)
						rime.pvp.regenerate = false
					else
						rime.pvp.remove_limb("left_leg", 3000, shmuck)
					end
					if rime.targets[shmuck].limbs.left_leg < 6600 then
						rime.pvp.remove_aff("left_leg_mangled", shmuck)
					end
				elseif rime.pvp.has_aff("left_leg_broken", shmuck) then
					if rime.pvp.regenerate then
						rime.pvp.remove_limb("left_leg", 4000, shmuck)
						rime.pvp.regenerate = false
					else
						rime.pvp.remove_limb("left_leg", 3000, shmuck)
					end
					if rime.targets[shmuck].limbs.left_leg < 3300 then
						rime.pvp.remove_aff("left_leg_broken", shmuck)
					end
				elseif rime.targets[shmuck].limbs.left_leg > 0 then
					rime.pvp.remove_limb("left_leg", 3000, shmuck)
				elseif rime.pvp.has_aff("right_leg_amputated", shmuck) then
					rime.pvp.remove_aff("right_leg_amputated", shmuck)
				elseif rime.pvp.has_aff("right_leg_mangled", shmuck) then
					if rime.pvp.regenerate then
						rime.pvp.remove_limb("right_leg", 4500, shmuck)
						rime.pvp.regenerate = false
					else
						rime.pvp.remove_limb("right_leg", 3000, shmuck)
					end
					if rime.targets[shmuck].limbs.right_leg < 6600 then
						rime.pvp.remove_aff("right_leg_mangled", shmuck)
					end
				elseif rime.pvp.has_aff("right_leg_broken", shmuck) then
					if rime.pvp.regenerate then
						rime.pvp.remove_limb("right_leg", 4000, shmuck)
						rime.pvp.regenerate = false
					else
						rime.pvp.remove_limb("right_leg", 3000, shmuck)
					end
					if rime.targets[shmuck].limbs.right_leg < 3300 then
						rime.pvp.remove_aff("right_leg_broken", shmuck)
					end
				elseif rime.targets[shmuck].limbs.right_leg > 0 then
					rime.pvp.remove_limb("right_leg", 3000, shmuck)
				end
			elseif limb == "arms" then
				if rime.pvp.has_aff("left_arm_amputated", shmuck) then
					rime.pvp.remove_aff("left_arm_amputated", shmuck)
				elseif rime.pvp.has_aff("left_arm_mangled", shmuck) then
					if rime.pvp.regenerate then
						rime.pvp.remove_limb("left_arm", 4500, shmuck)
						rime.pvp.regenerate = false
					else
						rime.pvp.remove_limb("left_arm", 3000, shmuck)
					end
					if rime.targets[shmuck].limbs.left_arm < 6600 then
						rime.pvp.remove_aff("left_arm_mangled", shmuck)
					end
				elseif rime.pvp.has_aff("left_arm_broken", shmuck) then
					if rime.pvp.regenerate then
						rime.pvp.remove_limb("left_arm", 4000, shmuck)
						rime.pvp.regenerate = false
					else
						rime.pvp.remove_limb("left_arm", 3000, shmuck)
					end
					if rime.targets[shmuck].limbs.left_arm < 3300 then
						rime.pvp.remove_aff("left_arm_broken", shmuck)
					end
				elseif rime.targets[shmuck].limbs.left_arm > 0 then
					rime.pvp.remove_limb("left_arm", 3000, shmuck)
				elseif rime.pvp.has_aff("right_arm_amputated", shmuck) then
					rime.pvp.remove_aff("right_arm_amputated", shmuck)
				elseif rime.pvp.has_aff("right_arm_mangled", shmuck) then
					if rime.pvp.regenerate then
						rime.pvp.remove_limb("right_arm", 4500, shmuck)
						rime.pvp.regenerate = false
					else
						rime.pvp.remove_limb("right_arm", 3000, shmuck)
					end
					if rime.targets[shmuck].limbs.right_arm < 6600 then
						rime.pvp.remove_aff("right_arm_mangled", shmuck)
					end
				elseif rime.pvp.has_aff("right_arm_broken", shmuck) then
					if rime.pvp.regenerate then
						rime.pvp.remove_limb("right_arm", 4000, shmuck)
						rime.pvp.regenerate = false
					else
						rime.pvp.remove_limb("right_arm", 3000, shmuck)
					end
					if rime.targets[shmuck].limbs.right_arm < 3300 then
						rime.pvp.remove_aff("right_arm_broken", shmuck)
					end
				elseif rime.targets[shmuck].limbs.right_arm > 0 then
					rime.pvp.remove_limb("right_arm", 3000, shmuck)
				end
			elseif limb == "legs" then
				if rime.pvp.has_aff("left_leg_amputated", shmuck) then
					rime.pvp.remove_aff("left_leg_amputated", shmuck)
				elseif rime.pvp.has_aff("left_leg_mangled", shmuck) then
					if rime.pvp.regenerate then
						rime.pvp.remove_limb("left_leg", 4500, shmuck)
						rime.pvp.regenerate = false
					else
						rime.pvp.remove_limb("left_leg", 3000, shmuck)
					end
					if rime.targets[shmuck].limbs.left_leg < 6600 then
						rime.pvp.remove_aff("left_leg_mangled", shmuck)
					end
				elseif rime.pvp.has_aff("left_leg_broken", shmuck) then
					if rime.pvp.regenerate then
						rime.pvp.remove_limb("left_leg", 4000, shmuck)
						rime.pvp.regenerate = false
					else
						rime.pvp.remove_limb("left_leg", 3000, shmuck)
					end
					if rime.targets[shmuck].limbs.left_leg < 3300 then
						rime.pvp.remove_aff("left_leg_broken", shmuck)
					end
				elseif rime.targets[shmuck].limbs.left_leg > 0 then
					rime.pvp.remove_limb("left_leg", 3000, shmuck)
				elseif rime.pvp.has_aff("right_leg_amputated", shmuck) then
					rime.pvp.remove_aff("right_leg_amputated", shmuck)
				elseif rime.pvp.has_aff("right_leg_mangled", shmuck) then
					if rime.pvp.regenerate then
						rime.pvp.remove_limb("right_leg", 4500, shmuck)
						rime.pvp.regenerate = false
					else
						rime.pvp.remove_limb("right_leg", 3000, shmuck)
					end
					if rime.targets[shmuck].limbs.right_leg < 6600 then
						rime.pvp.remove_aff("right_leg_mangled", shmuck)
					end
				elseif rime.pvp.has_aff("right_leg_broken", shmuck) then
					if rime.pvp.regenerate then
						rime.pvp.remove_limb("right_leg", 4000, shmuck)
						rime.pvp.regenerate = false
					else
						rime.pvp.remove_limb("right_leg", 3000, shmuck)
					end
					if rime.targets[shmuck].limbs.right_leg < 3300 then
						rime.pvp.remove_aff("right_leg_broken", shmuck)
					end
				elseif rime.targets[shmuck].limbs.right_leg > 0 then
					rime.pvp.remove_limb("right_leg", 3000, shmuck)
				end
			else
				rime.pvp.remove_limb(limb, 3000, shmuck)
			end
		end
	end
end

function add_target(target)

	target = string.title(target)

	if not rime.targets[target] then
			
		rime.targets[target] = {
			parry = "nothing",
			defending = false,
     		["mana"] = 100,
     		aggro = 0,
     		adder = false,
     		chilled_count = 0,
     		death_rub = 0,
     		armored = true,
     		prerestoredLimb = "none",
     		["deliverance"] = false,
			["cooldowns"] = {
				focus = false,
				tree = false,
				renew = false,
			},
			["time"] = {
			},
			["limbs"] = {
				head = 0,
				torso = 0,
				left_arm = 0,
				right_arm = 0,
				left_leg = 0,
				right_leg = 0,
			},
			["stacks"] = {
				gravity = 0,
				rot = 0,
				ablaze = 0,
				gloom = 0,
				stonevice = 0,
			},
            ["mori"] = {
                health = false,
                mana = true,
            },
            ["suggestions"] = {},
            sealed = false,
			["soul"] = 100,
			["bloodburstCount"] = 0,
			["afflictions"] = {
			},
			["defences"] = {
				blind = true,
				deaf = true,
				firefly = true,
				fangbarrier = true,
				cloak = true,
				speed = true,
				rebounding = true,
				shielded = false,
				prismatic = false,
				clarity = true,
				fitness = true,
				insulation = true,
				instawake = true,
				insomnia = true,
				metawake = false,
				venom_resistance = true,
				temperance = true,	
				lightform = false,
				quills = false,
				aegis = false,
				flight = false,
			},
			["emotions"] = {
				induced = "none",
				sadness = 0,
				happiness = 0,
				surprise = 0,
				anger = 0,
				stress = 0,
				fear = 0,
				disgust = 0,
			},
			ironcollar = false,
			globes = 0,
			bladestorm = 0,
			needle = false,
			geoHex = false,
			geoCrescent = false,
			currents = 0,
			causality = false,
			intoxicant = false,
			channel = false,
			deliverance = false,
			disabled = false,
			effigy = false,
			leeching = false,
		}
		
		rime.echo("<DeepPink>"..target.."<white> added to target list.")
		
	end

end

rime.stopwatch = rime.stopwatch or {}

function rime.time(thing, player, limit)
    local limit = limit or 0

    if player then
        player = string.title(player)
        if rime.targets[player] == nil then return end
        rime.targets[player].time[thing] = rime.targets[player].time[thing] or createStopWatch()
        resetStopWatch(rime.targets[player].time[thing])
        startStopWatch(rime.targets[player].time[thing])
        
        rime.targets[player].time_limit = rime.targets[player].time_limit or {}
        rime.targets[player].time_limit[thing] = limit 
    else
        rime.stopwatch[thing] = rime.stopwatch[thing] or createStopWatch()
        resetStopWatch(rime.stopwatch[thing])
        startStopWatch(rime.stopwatch[thing])

        rime.stopwatch_limit = rime.stopwatch_limit or {}
        rime.stopwatch_limit[thing] = limit
    end

end

function rime.getTime(thing, player)

    if player then

        player = string.title(player)
        if rime.targets[player].time[thing] == nil then return 0 end

        return tonumber(getStopWatchTime(rime.targets[player].time[thing]))

    else

        return tonumber(getStopWatchTime(rime.stopwatch[thing]))

    end

end


function rime.checkTime(thing, player)

	if player then

		player = string.title(player)

		if rime.targets[player] == nil then return 0 end

		if rime.targets[player].time[thing] == nil then rime.echo("Wasn't being timed!") rime.time(thing, player) end

		--rime.echo("Time on "..player.."'s "..thing.." is "..getStopWatchTime(rime.targets[player].time[thing]))

		if thing == "focus" then

			if rime.getTime("focus", player) > 4.9 then

				rime.targets[player].cooldowns.focus = false

			end

		end

	else

		rime.echo("Time on <SandyBrown>"..thing.."<white> is <SandyBrown>"..getStopWatchTime(rime.stopwatch[thing]))

	end

end

function rime.getTimeLeft(thing, player)
    local currentTime 
    local limitTime

    if player then
        player = string.title(player)
        if rime.targets[player].time[thing] == nil then return 0 end

        currentTime = getStopWatchTime(rime.targets[player].time[thing])
        limitTime = rime.targets[player].time_limit[thing] or 0
    else
    	if rime.stopwatch[thing] == nil then return 0 end
        currentTime = getStopWatchTime(rime.stopwatch[thing])
        limitTime = rime.stopwatch_limit[thing] or 0
    end

    if limitTime - currentTime > 0 then
        return (limitTime-currentTime)
    else
        return 0
    end
end

function rime.stopTime(thing, player)

	if player then

		player = string.title(player)

		resetStopWatch(rime.targets[player].time[thing])

		rime.echo("Time on "..player.."'s "..thing.." is "..getStopwatchTime(rime.targets[player].time[thing]))

	else

		resetStopWatch(rime.stopwatch[thing])

		rime.echo("Time on <SandyBrown>" .. thing .. "<white> is <SandyBrown>" .. getStopWatchTime(rime.stopwatch[thing]))

	end

end

GUI = {}

function GUI.target_aff()
	local enemyAffTable = {}
	local target = rime.target

	clearWindow("targetafflictionDisplay")

	if rime.targets[target] == nil then
		cecho("targetafflictionDisplay", "\n <DodgerBlue>Target cannot have afflictions.")
	else
    	for k,v in pairs(rime.targets[target].afflictions) do
        	if v then
        		if not rime.saved.affColors[k] then
        			table.insert(enemyAffTable, k)
        		else
        			table.insert(enemyAffTable, rime.saved.affColors[k])
        		end
        	end
    	end
	  	if #enemyAffTable >= 1 then
	    	for i=1, table.size(enemyAffTable), 1 do
	      		cecho("targetafflictionDisplay", enemyAffTable[i].."\n")
	    	end
	  	else
	    	cecho("targetafflictionDisplay", "\n <DodgerBlue>"..rime.target.." has no afflictions.")
	  	end
	end
  
end

function rime.movement.direction(dir)

    local sep = rime.saved.separator
    local monolith = "monolith"
    local cube = "cubesigil"
    if rime.saved.monolith then
        monolith = rime.saved.monolith
    end
    if rime.saved.cube then
        cube = rime.saved.cube
    end
    

    if rime.movement.mode == "sigil" then
        act("get " .. monolith .. sep .. "get " .. cube .. sep .. "get globe" .. sep .. dir .. sep .. "drop " .. monolith .. sep .. "drop " .. cube .. "get globe")
    elseif rime.movement.mode == "guard" then
        act('order guards move '..dir..sep..dir)
    else
        act(dir)
    end

end

function rime.starchart(primary, secondary)

	local class = rime.status.class
	local class_default = {
		Earthcaller = {"str", "wp"},
		Luminary = {"str", "wp"},
		Bard = {"dex", "wp"},
		Infiltrator = {"dex", "wp"},
		Carnifex = {"str", "wp"},
		Warden = {"str", "wp"},
		Revenant = {"str", "wp"},
		Templar = {"str", "wp"},
		Alchemist = {"int", "end"},
		Shaman = {"int", "end"},
		Bloodborn = {"int", "end"},
		Ascendril = {"int", "end"},
		Archivist = {"int", "end"},
		Archivistmirror = {"int", "end"},
		Sciomancer = {"int", "end"},
		Runecarver = {"int", "end"},
		Teradrim = {"str", "wp"},
		Tidesage = {"str", "wp"},
		Praenomen = {"str", "wp"},
		Akkari = {"str", "wp"},
		Sentinel = {"dex", "wp"},
		Sentinelmirror = {"dex", "wp"},
		Indorani = {"dex", "wp"},
		Oneiromancer = {"dex", "wp"},
		Shapeshifter = {"str", "wp"},
		Predator = {"dex", "wp"},
	}

	local star_primary = {
		dex = "shenebre",
		str = "treyes",
		int = "lyrana",
		con = "vayua",
	}

	local star_secondary = {
		["end"] = "svastusel",
		wp = "peripleko",
	}

	if not primary then primary = class_default[class][1] end
	if not secondary then secondary = class_default[class][2] end

	act("qeb starchart "..star_primary[primary].." "..star_secondary[secondary])

end

function rime.pair(person)
    person = string.title(person)

    if rime.saved.pairings[person] then
        act("qeb stand", "touch " .. rime.saved.pairings[person])
        return
    end
    for k, v in pairs(rime.saved.pairings) do
        if string.starts(k, person) then
            act("qeb stand", "touch " .. v)
            return
        end
    end
    rime.echo("Rime currently has no record of any paired items with " .. person .. "!")

end

function rime.artifact_toggle(arti, status)

  arti = arti:lower()
  if arti == "goggles" or arti == "gauntlet" then status = tonumber(status) else status = status:lower() end
  if status == "off" then status = "no" end
  if status == "on" then status = "yes" end
  if status == "true" then status = "on" end
  if status == "false" then status = "off" end
  local hit_one = false
  
  if arti == "pipes" or arti == "pipe" then
    hit_one = true
    if status == "yes" then
      rime.saved.arti_pipes = true
      rime.echo("Will no longer try to light pipes!")
      rime.echo("<red>ONLY USE THIS SETTING IF YOU HAVE THREE (3) ARTIFACT PIPES!")
    else
      rime.saved.arti_pipes = false
      rime.echo("Will now keep your pipes lit!")
    end
  end

  if arti == "web" or arti == "webspray" then
    hit_one = true
    if status == "yes" then
      rime.saved.webspray = true
      rime.echo("Will use webspray instead of web tattoo now!")
    else
      rime.saved.webspray = false
      rime.echo("Will now use the web tattoo!")
    end
  end
  
  if arti == "mass" or arti == "density" or arti == "stability" then
    hit_one = true
    if status == "yes" then
    	rime.saved.stability = true
    	rime.echo("Will use artifact stability!")
    else
    	rime.saved.stability = false
    	rime.echo("Will use mass salve!")
    end
  end
  
  if arti == "mana_boon" or arti == "manaboon" then
    hit_one = true
    if status == "yes" then
    	rime.saved.mana_boon = true
    	rime.echo("Enabled mana_boon costs for clot!")
    else
    	rime.saved.mana_boon = false
    	rime.echo("Disabled mana_boon costs for clot!")
    end
  end

  if arti == "lifevision" then
    hit_one = true
    if status == "yes" then
    	rime.saved.lifevision = true
    	rime.echo("Will use artifact lifevision!")
    else
    	rime.saved.lifevision = false
    	rime.echo("Will not use artifact lifevision!")
    end
  end
  
  if arti == "lifesense" then
    hit_one = true
    if status == "yes" then
    	rime.saved.lifesense = true
    	rime.echo("Enabled lifesense defense!")
    else
    	rime.saved.lifesense = false
    	rime.echo("Disabled lifesense defense!")
    end
  end

  if arti == "zephyr" then
    hit_one = true
    if status == "yes" then
    	rime.saved.zephyr = true
    	rime.echo("Enabled zephyr defense!")
    else
    	rime.saved.zephyr = false
    	rime.echo("Disabled zephyr defense!")
    end
  end
  
  if arti == "mindseye" then
    hit_one = true
    if status == "yes" then
    	rime.saved.mindseye = true
    	rime.echo("Will ignore mindseye defense!")
    else
    	rime.saved.mindseye = false
    	rime.echo("Will use allsight or mindseye!")
    end
  end
  
  if arti == "goggles" then
    hit_one = true
    if status == 0 then
    	rime.saved.goggles = 0
    	rime.echo("Removing salvage Goggles")
    else
    	rime.saved.goggles = status
    	rime.echo("Salvage Goggles set to level "..status)
    end
  end

  if arti == "gauntlet" then
  	hit_one = true
  	if status == 0 then
  		rime.saved.gauntlet = 0
  		rime.echo("Removing salvage Gauntlet")
  	else
  		rime.saved.gauntlet = status
  		rime.echo("Salvage Gauntlet set to level "..status)
  	end
  end

  if arti == "bracer" then
      hit_one = true
      if status == "yes" then
          rime.saved.bracer = true
          rime.echo("Rime now supports remote diagnose in its offenses!")
      else
          rime.saved.bracer = false
          rime.echo("Rime will now skip any remote diagnosing built into offenses!")
      end
  end

	if arti == "hunter_horn" or arti == "horn" then
		hit_one = true
		if status == "yes" then
           rime.saved.hunter_horn = true
           rime.echo("Rime now supports blowing your enemies.")
       else
           rime.saved.hunter_horn = false
           rime.echo("Rime will no longer toot its own horn.")
       end
	end

  if arti == "bow" then
  	hit_one = true
  	if status == "yes" then
  		rime.saved.arti_bow = true
  		rime.echo("Rime now supports using an artifact bow! Somehow! Someway!")
  	else
  		rime.saved.art_bow = false
  		rime.echo("Rime won't use all the billions of features build into it involving an arti bow.")
  	end
  end

  if arti == "fullbracer" then
  	hit_one = true
  	if status == "yes" then
  		rime.saved.fullbracer = true
  		rime.echo("Rime now supports utility provided with the full relic bracer!")
  	else
  		rime.saved.fullbracer = false
  		rime.echo("Rime will no longer use the bracer abilities automatically.")
  	end
  end

  if arti == "reflections" then
  	hit_one = true
  	if not string.find(status, "%d") and status ~= "no" then
  		rime.echo("Rime requires you to set the wand # (rime arti set wand1234) in order to set this artifact.")
  		return
  	end
  	if string.find(status, "%d") and status ~= "no" then
  		rime.saved.reflection_wand = status
  		rime.echo("Rime now supports utility provided by the wand of reflections!")
  	else
  		rime.saved.reflection_wand = false
  		rime.echo("Rime no longer supports wand of reflections.")
  	end
  end

  if arti == "illusion_staff" then
  	hit_one = true
  	if status == "yes" then
  		rime.saved.illusion_staff = true
  		rime.echo("Rime is now capable of weaving illusions into your offense!")
  	else
  		rime.echo("Rime will no longer attempt to use illusions in your offense.")
  	end
  end

  if arti == "crystal_illusion" then
  	hit_one = true
  	if status == "yes" then
  		rime.saved.crystal_illusion = true
  		rime.echo("Rime is now capable of weaving colored illusions into your offense!")
  	else
  		rime.echo("Rime will no longer attempt to use colored illusions in your offense.")
  	end
  end

  if arti == "tailstrike" then
  	hit_one = true
  	if status == "yes" then
  		rime.saved.tailstrike = true
  		rime.echo("Rime now supports tailstrike checks and be incorporated into your offense!")
  	else
  		rime.echo("Rime will no longer pass tailstrike checks in offenses.")
  	end
  end

  if arti == "torc" or arti == "vitality" then
    hit_one = true
    if status == "yes" then
        rime.saved.vitality = true
        rime.echo("Enabled vitality defense!")
    else
        rime.saved.vitality = false
        rime.echo("Disabled vitality defense!")
    end
   end

   if arti == "torch" or arti == "everburning" then
   	hit_one = true
   	if status == "yes" then
   		rime.saved.everburning = true
   		rime.echo("Rime Basher can now incorporate the <red>Everburning Torch<white> in movement!")
   	else
   		rime.saved.everburning = false
   		rime.echo("Rime Basher will no longer make use of the <red>Everburning Torch<white> while bashing.")
   	end
   end
  
  if not hit_one then 
    rime.echo("That artifact currently isn't supported by Rime! Maybe if Mjoll or Bulrok magically found one in their inventories, they'd be motivated to add it!")
  else
   table.save(getMudletHomeDir().."/rime.saved.lua", rime.saved)
  end 

end