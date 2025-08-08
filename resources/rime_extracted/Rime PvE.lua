rime.pve.support = rime.pve.support or false
rime.pve.over_driving = false
rime.pve.need_climb = false
rime.pve.auto_fishing = false
rime.pve.line_cast = false
rime.pve.fish_str = 100
rime.pve.need_discern = true
rime.pve.area = "nowhere"
rime.pve.can_fish = false
rime.pve.fish_hooked = false
rime.pve.auto_walk_fish = false
rime.pve.fish_moving = false
rime.pve.bashing_paused = false
rime.pve.corpse_turn_in = false
rime.pve.fishing = rime.pve.fishing or {}
rime.pve.hack_check = false
debugMode = false
rime.pve.bashing = rime.pve.bashing or false
rime.pve.botMode = rime.pve.botMode or false
rime.pve.autowalking = rime.pve.autowalking or false
rime.pve.walking = rime.pve.walking or 1
rime.pve.autowalk = rime.pve.autowalk or false
rime.pve.everburning = rime.pve.everburning or false
rime.pve.leading = rime.pve.leading or false
rime.pve.top = rime.pve.top or false
rime.pve.follow = rime.pve.follow or false
rime.pve.next_area = false
rime.pve.group = rime.pve.group or {}
rime.pve.waiting_on = {}
rime.pve.triplicate = rime.pve.triplicate or false
gh = gh or {}
gh.reporting = false

function rime.pve.bash_attack()

	local class = rime.status.class
	local sep = rime.saved.separator
	local que = rime.pvp.queue_handle()
	local pre = ""
	local action = ""
	local mount = false
	local name = gmcp.Char.Status.name
	local agroCount = 0
	local people = swarm.room
	local ally = swarm.room[1] or "Bulrok"
	local health = rime.vitals.percent_health
	local area = gmcp.Room.Info.area
	local circuit = rime.pve.circuit
	local defenseAction = false
	if not rime.defences.general.manipulation_wisdom.deffed and rime.defences.general.manipulation_wisdom.need then
		if tonumber(gmcp.Char.Vitals.residual) < 31 then
			que = que .. sep .. "drain gauntlet" .. sep .."drain receptacle" .. sep .. "manipulate pylon for wisdom transmute"
		else
			que = que .. sep .. "manipulate pylon for wisdom transmute"
		end
	end
	if rime.pve.need_climb then
		que = que .. sep .. "climb ladder"
	end
	if rime.pve.top then
		que = que .. sep .. "follow "..rime.pve.top
	end
	if not rime.pve.follow and rime.pve.circuits[circuit] and rime.pve.circuits[circuit].torch then
		if rime.pve.circuits[circuit].torch == area and not rime.pve.everburning then
			que = que .. sep .. "get "..rime.saved.everburning_torch.." from pack" .. sep .. "light "..rime.saved.everburning_torch
		end
	end
	for k,v in ipairs(people) do
		if rime.targets[v].aggro > rime.targets[ally].aggro then
			ally = v
		end
	end
	for k,v in pairs(rime.pve.mobs) do
		if v.icon == "face-angry-horns" or string.find(v.name, "slaver") then
			agroCount = agroCount+1
		end
		if v.name == "a foul spiderling" then
			agroCount = agroCount-1
		end
		if v.name == "a vast ochre ooze" then
			agroCount = agroCount+4
		end
		if string.find(v.name, "eld") then agroCount=agroCount-1 end
	end
	
	if gmcp.Room.Info.area:gsub("an unstable section of ","") == "the Bloodwood" then pre = "get essence" end
	if gmcp.Room.Info.area:gsub("an unstable section of ","") == "Xaanhal" then pre = "get fragment" end
	if gmcp.Room.Info.area:gsub("an unstable section of ","") == "the Shattered Vortex" then pre = "get piece" end
	if not has_def("vigor") then pre = "drink vigor" .. sep .. pre end
	local hornBlow = rime.saved.hunter_horn or false
    if hornBlow == true then
        hornBlow = "blow horn"..sep
    else
        hornBlow = ""
    end
	--if agroCount >= 4 then pre = pre .. sep .. "blow horn" end
	if string.len(pre) > 3 then action = pre end

	if rime.pve.support then
		if health < 80 and (has_def("reflection") or has_def("shielded")) then
			action = que .. sep .. class_heal
		elseif class == "Bard" then
			if not rime.bard.playing then
    			action = "inspire" .. sep .. "play song of youth"
  			elseif not rime.bard.singing then
    			action = "inspire" .. sep ..  "sing song of youth"
  			elseif rime.vitals.dithering < 1 then
    			action = "inspire" .. sep ..  "secure " .. rime.saved.bard_bashing .. sep .."weave patchwork "..ally
  			else
    			action = "inspire" .. sep ..  "quickwield right " .. rime.saved.bard_bashing .. sep .. "tempo "..rime.target
  			end
		elseif class == "Alchemist" then
			if not rime.targets[ally].quills and alchemist.can_quills and rime.targets[ally].aggro >= 3 then
    			action = "botany quills "..ally
  			elseif rime.targets[ally].aggro >= 1 then
    			action = "alchemy rousing "..ally --this will kill people not actually on your allies list probably
  			else
   				action = "alchemy static "..rime.target
  			end
		elseif class == "Earthcaller" then
			if rime.targets[ally].aggro >= 1 then
    			action = "dirge reinforce "..ally
  			else
    			action = "quash "..rime.target
  			end
		elseif class == "Indorani" then
			if rime.targets[ally].aggro >=1 then
    			action = "fling priestess at "..ally
  			else
    			action = "flick bonedagger at "..rime.target
  			end
  		end
  	elseif ati.mode then
		if not ati.engaged then
    		if ati.percent_hp < 100 then
    			action = "ati restore"
    		else
     			action = "ati engage "..rime.target..sep.."ati consume"
			end
		elseif ati.percent_hp < 80 then
			action = "ati restore"
		else
    		action = "ati consume"
  		end
	elseif not rime.pve.support then
		if rime.pve.counter then
			action = "soul shield"
		elseif class == "Praenomen" then
			action = "frenzy "..rime.target
		elseif class == "Akkari" then
			action = "denounce "..rime.target
		elseif class == "Infiltrator" then
			if has_def("hiding") or has_def("phased") then
				action = "quickwield right dirk" .. sep .. "backstab "..rime.target
			elseif rime.saved.infiltrator_bash then
				if rime.saved.infiltrator_bash == "garrote" then
					action = "quickwield right whip" .. sep .. "garrote "..rime.target
				elseif rime.saved.infiltrator_bash == "bite" then
					action = "bite "..rime.target.." camus"
				end
			else
				action = "quickwield right whip" .. sep .. "garrote "..rime.target
			end
    	elseif class == "Teradrim" then
    	    if rime.vitals.percent_health <= 50 then
    	        local defenseAction = hornBlow..sep.."sand shield"
    	      if has_def("shielded") then
    	        defenseAction = hornBlow.."golem recover"
    	      end
    	      if rime.vitals.percent_health <= 30 then
    	        defenseAction = hornBlow.."touch crystal"..sep..defenseAction
    	      end
    	      if rime.vitals.current_health < rime.vitals.current_mana and rime.vitals.current_mana > 4500 and (gmcp.Char.Status.race == "Azudim" or gmcp.Char.Status.race == "Idreth" or gmcp.Char.Status.race == "Yeleni") then
    	        action = hornBlow.."shift"
    	      else
    	        action = defenseAction
    	      end
    	    else
    	        if rime.teradrim.can_momentum then
    	            action = "earth momentum" .. sep .. "earth batter "..rime.target
    	        else
    	            if rime.teradrim.is_momentum then
    	                action = "earth batter " ..rime.target
    	            else
    	                action = "earth batter "..rime.target .. sep .. "golem recover"
    	            end
    	        end
    	    end
		elseif class == "Shapeshifter" then
			if has_def("mounted") then
				action = "quickdismount" .. sep .. "combo "..rime.target.." slash slash"
			else
				action = "combo "..rime.target.." slash slash"
			end
		elseif class == "Sentinel" then
			action = "dhuriv combo "..rime.target.." crosscut thrust"
		elseif class == "Executor" then
			action = "ringblade dance "..rime.target.." phlebotomise inveigle"
		elseif class == "Alchemist" then
			local types = {"toxic", "immolative"}
			local alch_attack = false
			local alch_decompose = false
			local morph = false
			if alchemist.can_reconfigure then
				if alchemist.pet ~= "immolative" then
					morph = "experiment reconfigure immolative" .. sep .. "order loyals follow me"
				else
					morph = "experiment reconfigure toxic" .. sep .. "order loyals follow me"
				end
			end
			if alchemist.can_decompose and rime.vitals.volatility <= 2 and has_def("blightbringer") then
				alch_decompose = "botany decompose"
			end
			if rime.vitals.volatility >= 3 or alchemist.can_decompose then
				alch_attack = "alchemy catalyze" .. sep .. "alchemy static " .. rime.target
			else
				alch_attack = "alchemy static "..rime.target
			end
			if alch_decompose then
				alch_attack = alch_decompose .. sep .. alch_attack
			end
			if morph then
				action = morph .. sep .. alch_attack
			else
				action = alch_attack
			end
		elseif class == "Shaman" then
			local types = {"cougar", "bear"}
			local alch_attack = false
			local alch_decompose = false
			local morph = false
			if alchemist.can_reconfigure then
				if alchemist.pet ~= "bear" then
					morph = "familiar morph bear" .. sep .. "order loyals follow me"
				else
					morph = "familiar morph cougar" .. sep .. "order loyals follow me"
				end
			end
			if alchemist.can_decompose and rime.vitals.volatility <= 2 and has_def("greenfoot") then
				alch_decompose = "nature consumption"
			end
			if rime.vitals.volatility >= 3 or (alchemist.can_decompose and has_def("greenfoot")) then
				alch_attack = "commune boost" .. sep .. "commune lightning " .. rime.target
			else
				alch_attack = "commune lightning "..rime.target
			end
			if alch_decompose then
				alch_attack = alch_decompose .. sep .. alch_attack
			end
			if morph then
				action = morph .. sep .. alch_attack
			else
				action = alch_attack
			end
        elseif class == "Tyranny" or class == "Memory" or class == "Corruption" or class == "Strife" then
            if rime.vitals.percent_health <= 60 then
                local defenseAction = "blow horn".. sep .. "touch shield"
                local defense = {
                	["Tyranny"] = "adherent despot",
                	["Corruption"] = "adherent descent",
                	["Memory"] = "adherent spite",
                	["Strife"] = "adherent embrace",
                }
                --[[if adherent.mortalfire then
                    defenseAction = "blow horn".. sep .. "adherent mortalfire"
                end]]
                if gmcp.Room.Info.area == "the forgotten depths of Mount Helba"
                    or gmcp.Room.Info.area == "Kkirrrr'shi Hive"
                then
                    if ascended.resource[class] >= 2 then
                        defenseAction = "blow horn".. sep .. defense[class]
                    else
                        defenseAction = "blow horn" .. sep .. "adherent purify"
                    end
                end
                if rime.vitals.percent_health <= 60 then
                    if ascended.resource[class] >= 2 then
                        defenseAction = "blow horn".. sep .. defense[class]
                    else
                        defenseAction = "blow horn".. sep .. "adherent purify"
                    end
                end
                if rime.vitals.percent_health <= 30 then
                    defenseAction = "blow horn".. sep .. "touch crystal" .. sep .. defenseAction
                end
                if rime.vitals.current_health < rime.vitals.current_mana and rime.vitals.current_mana > 4000 then
                    action = "blow horn"..sep.."shift"
                end
                action = defenseAction
            else
        		local attacks = {
        			["Tyranny"] = {"oppress", "avatar", "pillage"},
        			["Corruption"] = { "coldflame", "spiral", "avatar" },
        			["Memory"] = { "shend", "avatar", "recalesce" },
        			["Strife"] = { "avatar", "riot", "smoulder" },
        		}
        		local pick = math.random(1, 3)
        		action = "adherent " .. attacks[class][pick] .. " " .. rime.target
            end
    elseif class == "Ravager" then
        if rime.vitals.percent_health <= 50 then
            local defenseAction = "blow horn"..sep.."touch shield"
            if gmcp.Room.Info.area == "the forgotten depths of Mount Helba" then
                defenseAction = "blow horn"..sep.."seethe"
            end
            if has_def("shielded") then
                defenseAction = "blow horn"..sep.."seethe"
            end
            if rime.vitals.percent_health <= 30 then
                defenseAction = "blow horn"..sep.."touch crystal"..sep..defenseAction
            end
            if rime.vitals.current_health < rime.vitals.current_mana and rime.vitals.current_mana > 4000 then
                action = "blow horn"..sep.."shift"
            else
                action = defenseAction
            end
        else
            action = "quickdismount"..sep.."onslaught "..rime.target.." bully bully"
        end
		elseif class == "Carnifex" then
			if rime.vitals.percent_health <= 50 then
				local defenseAction = "blow horn"..sep.."soul shield"
				if gmcp.Room.Info.area == "the forgotten depths of Mount Helba" then
					defenseAction = "blow horn"..sep.."soul consume for health"
				end
				if has_def("shielded") then
					defenseAction = "blow horn"..sep.."soul consume for health"
				end
				if rime.vitals.percent_health <= 30 then
					defenseAction = "blow horn"..sep.."touch crystal"..sep..defenseAction
				end
				if rime.vitals.current_health < rime.vitals.current_mana and rime.vitals.current_mana > 4500 and (gmcp.Char.Status.race == "Azudim" or gmcp.Char.Status.race == "Idreth" or gmcp.Char.Status.race == "Yeleni") then
					action = "blow horn"..sep.."shift"
				else
					action = defenseAction
				end
			elseif rime.pve.need_ents then
				action = "hound whistle all"
			elseif not rime.pve.openings and hasSkill("Openings") then
				action = "hound openings"
			else
				action = "pole spinslash "..rime.target
			end
		elseif class == "Bloodborn" then
            local aspect = rime.vitals.aspect
            if aspect == "" then aspect = "none" end
            local aspect_conversion = {
                ["yellow"] = "befoul",
                ["phlegm"] = "disgorge",
                ["black"] = "flense",
                ["none"] = "disgorge",
            }
            local triplicate_areas = {
            	["the Forgotten Dome"] = 3,
            	["Luzith's Lair"] = 3,
            	["Yuzurai village"] = 0,
            	["the Teshen Caldera"] = 10,
            	["the Squal"] = 3,
            }
            local triplicate_count = triplicate_areas[area] or 4
            if rime.vitals.percent_health <= 60 then
            	if not has_def("reflection") and rime.bloodborn.geminate_charge > 0 then
            		action = "unleash geminate"
            	elseif not has_def("shielded") then
            		action = "touch shield"
            	elseif rime.vitals.current_health < rime.vitals.current_mana and rime.vitals.percent_mana >= 50 then
            		action = "shift"
            	else
            		action = "touch crystal"..sep.."touch worrystone"
            	end
            elseif rime.pve.triplicate and #rime.pve.mobs < triplicate_count and #rime.pve.mobs > 1 then
                action = "unleash triplicate " .. aspect_conversion[aspect] .. " " .. rime.target
            else
                action = "humour " .. aspect_conversion[aspect] .. " " .. rime.target
            end

		elseif class == "Indorani" then
			if rime.vitals.percent_health <= 50 then
				local defenseAction = "touch shield"
				if gmcp.Room.Info.area == "the forgotten depths of Mount Helba" then
					defenseAction = "fling priestess at me"
				end
				if has_def("shielded") then
					defenseAction = "fling priestess at me"
				end
				if rime.vitals.percent_health <= 30 then
					defenseAction = "touch crystal"..sep..defenseAction
				end
				if gmcp.Char.Status.race == "Azudim" or gmcp.Char.Status.race == "Idreth" or gmcp.Char.Status.race == "Yeleni" then
					if rime.vitals.current_health < rime.vitals.current_mana and rime.vitals.current_mana > 4500 then
						action = "shift"
					else
						action = defenseAction
					end
				end
			else
				action = "flick bonedagger at "..rime.target
			end
		elseif class == "Bard" then
			if not rime.bard.singing and rime.vitals.percent_health <= 50 then
				action = "sing song of youth"
			elseif rime.vitals.dithering > 0 then
				action = "quickwield "..rime.bard.weapon_hand.." "..rime.saved.bard_bashing..sep.."tempo "..rime.target
			else
				action = "secure "..rime.bard.weapon_hand..sep.."weave tearing "..rime.target
			end
		elseif class == "Archivist" then
			action = "incite crux "..rime.target
		elseif class == "Sciomancer" then
            if rime.vitals.percent_health <= 50 then
            	if not has_def("reflection") and rime.sciomancer.reflection_charge > 0 then
            		action = "cast reflection"
            	elseif not has_def("shielded") then
            		action = "touch shield"
            	elseif rime.vitals.current_health < rime.vitals.current_mana and rime.vitals.percent_mana >= 50 then
            		action = "shift"
            	else
            		action = "touch crystal"..sep.."touch worrystone"
            	end
            elseif rime.pve.triplicate and #rime.pve.mobs < 4 and #rime.pve.mobs > 1 and area ~= "Yuzurai village" then
            	if not has_def("spectre") then
            		action = "cast spectre"..sep.."shadowprice gloom "..rime.target..sep.."cast blast "..rime.target
            	else
            		action = "shadowprice gloom "..rime.target..sep.."cast blast "..rime.target
            	end
            elseif has_def("spectre") then
            	action = "cast spectre off"..sep.."shadowprice gloom "..rime.target..sep.."cast fever "..rime.target
            else
                action = "shadowprice gloom "..rime.target..sep.."cast fever "..rime.target
            end
	
		elseif class == "Monk" then
			action = "quickdismount" .. sep .. "sdk " .. rime.target .. sep .. "ucp " .. rime.target .. sep .. "ucp " .. rime.target
	
		elseif class == "Templar" then
			action = "strike " .. rime.target .. " sacrifice"
		elseif class == "Revenant" then
			local attack = "dpl"
			local weapon_verbs = {
				["fell"] = {"bardiche", "bastard", "falx", "glaive", "greatspear", "halberd", "scythe", "Yozati"},
				["dpl"] = {"battleaxe", "broadsword", "falchion", "flyssa", "gladius", "longsword", "rapier", "sarissa", "scimitar",
							"shortsword", "spear"}
			}
			local attack_found = false
			local wielded = rime.vitals.wielded_left:gsub('%d','')
			for k,v in pairs(weapon_verbs) do
				if table.contains(weapon_verbs[k], wielded) and not attack_found then
					attack = k
					attack_found = true
				end
			end
			if rime.vitals.percent_health <= 50 then
				local defenseAction = "blow horn"..sep.."touch shield"
				if gmcp.Room.Info.area == "the forgotten depths of Mount Helba" then
					defenseAction = "blow horn"..sep.." "..attack.." ".. rime.target.." duskosa duskosa"..sep.."phantasm metabolize"
				end
				if has_def("shielded") then
					defenseAction = "blow horn"..sep.." "..attack.." ".. rime.target.." duskosa duskosa"..sep.."phantasm metabolize"
				end
				if rime.vitals.percent_health <= 30 then
					defenseAction = "blow horn"..sep.."touch crystal"..sep..defenseAction
				end
				if rime.vitals.current_health < rime.vitals.current_mana and rime.vitals.current_mana > 4500 and (gmcp.Char.Status.race == "Azudim" or gmcp.Char.Status.race == "Idreth" or gmcp.Char.Status.race == "Yeleni") then
					action = "blow horn"..sep.."shift"
				else
					action = defenseAction
				end
			else
				action = attack.." ".. rime.target.." duskosa duskosa"
			end
    	elseif class == "Earthcaller" then
    	    if rime.vitals.percent_health <= 50 then
    	        local defenseAction = hornBlow.."osso ribcage"
    	        if gmcp.Room.Info.area == "the forgotten depths of Mount Helba" then
    	            defenseAction = hornBlow.."osso ossification"
    	        end
    	        if has_def("shielded") then
    	            defenseAction = hornBlow.."osso ossification"
    	        end
    	        if rime.vitals.percent_health <= 30 then
    	            defenseAction = hornBlow.."touch crystal"..sep..defenseAction
    	        end
    	        if rime.vitals.current_health < rime.vitals.current_mana and rime.vitals.percent_mana > 90 and (gmcp.Char.Status.race == "Azudim" or gmcp.Char.Status.race == "Idreth" or gmcp.Char.Status.race == "Yeleni") then
    	            action = hornBlow.."shift"
    	        else
    	            action = defenseAction
    	        end
    	    else
    	        action = "tectonic ashfall " .. rime.target
    	    end
		else
			action = "kill "..rime.target
		end

	end

	if rime.has_aff("shock") then
    	if not rime.pve.over_driving then
            action = 'overdrive' .. sep .. action
        end
    end

    if rime.target == "Shadow" and rime.vitals.wielded_right:find("caduceus") then
    	action = "point caduceus at shadow"
    end

	if rime.saved.gauntlet >= 2 then
		action = que .. sep .. pre .. sep .. action .. sep .. "absorb ylem"
	else
		action = que .. sep .. "absorb ylem" .. sep .. pre .. sep .. action
	end
		--action = que .. sep .. pre .. sep .. action

	action = action:gsub(sep..sep, sep)
	if action ~= rime.balance_queue and action ~= rime.balance_queue_attempted then
		act(action)
		rime.balance_queue_attempted = action
	end
	--act(action)

end

rime.pve.bash = {

	["attack"] = {
		Alchemist = function()
			local target = rime.target
			return "alchemy static " .. target
		end,

		Archivist = function()
			local target = rime.target
			return "elicit crux " .. target
		end,

		Ascended = function()
        	local attacks = {
        		["Tyranny"] = {"oppress", "avatar", "pillage"},
        		["Corruption"] = { "coldflame", "spiral", "avatar" },
        		["Memory"] = { "shend", "avatar", "recalesce" },
        		["Strife"] = { "avatar", "riot", "smoulder" },
        	}
        	local target = rime.target
        	local class = rime.status.class
        	local pick = math.random(1, 3)
        	return "adherent " .. attacks[class][pick] .. " " .. target
        end,

        Bard = function()
        	local target = rime.target
        	if rime.vitals.dithering > 0 then
        		return "tempo " .. target
        	else
        		return "weave tearing " .. target
        	end
        end,

        Bloodborn = function()
        	local target = rime.target
        	local aspect = rime.vitals.aspect
			if aspect == "" then aspect = "none" end
			local aspect_conversion = {
				["yellow"] = "befoul",
				["phlegm"] = "disgorge",
				["black"] = "flense",
				["none"] = "disgorge",
			}
			return "humour " .. aspect_conversion[aspect] .. " " .. target
		end,
	}
}

   --[[ table.load(dir.."/Rime PvP Alchemist.lua")
    table.load(dir.."/Rime PvP Archivist.lua")
    table.load(dir.."/Rime PvP Ascended.lua")
    table.load(dir.."/Rime PvP Bard.lua")
    table.load(dir.."/Rime PvP Bloodborn.lua")
    table.load(dir.."/Rime PvP Carnifex.lua")
    table.load(dir.."/Rime PvP Earthcaller.lua")
    table.load(dir.."/Rime PvP Indorani.lua")
    table.load(dir.."/Rime PvP Praenomen.lua")
    table.load(dir.."/Rime PvP Ravager.lua")
    table.load(dir.."/Rime PvP Revenant.lua")
    table.load(dir.."/Rime PvP Sciomancer.lua")
    table.load(dir.."/Rime PvP Shapeshifter.lua")
    table.load(dir.."/Rime PvP Syssin.lua")
    table.load(dir.."/Rime PvP Teradrim.lua")]]

function gh.add(player, score)

	score = tonumber(score)

	if not gh[player] then

		gh[player] = {
			["previous_score"] = 0,
			["current_score"] = score,
			["average_score"] = 0,
			["start_score"] = score,
			["start_time"] = os.time()
		}

	end

	local endTime = os.time()
	local duration = endTime - gh[player].start_time

	gh[player].previous_score = gh[player].current_score
	gh[player].current_score = score
	local score_change = score-gh[player].start_score
	gh[player].average_score = math.floor(score_change/(duration/60/60))

	if gh.reporting then
		if string.title(player) == string.title(gh.reporting) then
			gh.report()
		end
	end

end

function gh.report()

	if not gh.reporting then return end

	local player = string.title(gh.reporting)

	if gh[player] then

		send("wt "..player.." is at "..gh[player].current_score.." and averaging "..gh[player].average_score.." points per hour.")

		if player == "Valorie" then
			send("valorie //ur at "..gh[player].average_score)
		end

	end

	gh.reporting = false

end

--200 tracking??


rime.saved.exptracking = rime.saved.exptracking or {}

function rime.pve.expUpdate(amount)
    local where = gmcp.Room.Info
    local when = os.time()

    local expLog = {
        ["where"] = {
            ["roomNum"] = where.num,
            ["area"] = where.area,
        },
        ["when"] = when,
        ["amount"] = amount,
    }

    table.insert(rime.saved.exptracking, expLog)

end

function rime.pve.expCheck()

    local total = 0
    local startTime = nil
    local endTime = nil
    local thisArea = gmcp.Room.Info.area
    local thisRoom = gmcp.Room.Info.num
    local areaExp = 0
    local roomExp = 0
    for _, log in ipairs(rime.saved.exptracking) do
        if not startTime or log.when < startTime then
            startTime = log.when
        end
        if not endTime or log.when > endTime then
            endTime = log.when
        end
        if log.where.area == thisArea then
            areaExp = areaExp + log.amount
        end
        if log.where.roomNum == thisRoom then
            roomExp = roomExp + log.amount
        end
        total = total + log.amount
    end

    if not (endTime or startTime) then return end

    local duration = endTime - startTime

    local days = math.floor(duration/60/60/24)
    local hours = math.floor((duration - (days*60*60*24))/60/60)
    local minutes = math.floor((duration - (hours*60*60) - (days*60*60*24))/60)
    local seconds = math.floor((duration - (minutes*60) - (hours*60*60) - (days*60*60*24)))

    local timeString = (days >= 1 and tostring(days).." days " or "")..(hours >= 1 and tostring(hours).." hours " or "")..
(minutes >= 1 and tostring(minutes).." minutes " or "")..(seconds >= 1 and tostring(seconds).." seconds" or "")

    local xps = total / duration
    local xph = total / (duration/60/60)

    local xpToLevel = tonumber(gmcp.Char.Vitals.maxxp) - tonumber(gmcp.Char.Vitals.xp)
    local xpPercentGained = (total*100)/tonumber(gmcp.Char.Vitals.maxxp)
    local timeToLevel = xpToLevel / xph
    
   
    local readable_total = format_int(total)
    local readable_xph = format_int(xph)
    local readable_xps = format_int(xps)


    --cecho("\n<cyan>Exp in "..thisArea.." is: "..(areaExp<1 and "<red>" or "<green>")..format_int(areaExp))
    --cecho("\n<cyan>Exp at v"..thisRoom.." is: "..(roomExp<1 and "<red>" or "<green>")..format_int(roomExp))
    cecho("\n<ansiLightRed>\(<DeepPink>200<ansiLightRed>\)<white> Exp change is: "..(total<=0 and "<red>" or "<DeepPink>")..tostring(readable_total).."<DeepPink> -- <white>over <green>"..timeString)
    --cecho("\n<ansiLightRed>\(<DeepPink>\)<white>Exp Per Second is: "..(xps<=0 and "<red>" or "<green>")..readable_xps)
    cecho("\n<ansiLightRed>\(<DeepPink>200<ansiLightRed>\)<white> Exp Per Hour is: "..(xph<=0 and "<red>" or "<DeepPink>")..readable_xph)


end

rime.pve.dps = rime.pve.dps or {}

rime.pve.dps = {
	["Executor"] = {
		["base_damage"] = {},
		["base_balance"] = {},
	},
	["Carnifex"] = {
		["base_damage"] = {},
		["base_balance"] = {},
	},
	["Revenant"] = {
		["base_damage"] = {},
		["base_balance"] = {},
	},
	["Praenomen"] = {
		["base_damage"] = {},
		["base_balance"] = {},
	},
	["Indorani"] = {
		["base_damage"] = {},
		["base_balance"] = {},
	},
	["Bard"] = {
		["base_damage"] = {},
		["base_balance"] = {},
	},
	["Alchemist"] = {
		["base_damage"] = {},
		["base_balance"] = {},
	},
	["Shapeshifter"] = {
		["base_damage"] = {},
		["base_balance"] = {},
	},
	["Sciomancer"] = {
		["base_damage"] = {},
		["base_balance"] = {},
	},
	["Ravager"] = {
		["base_damage"] = {},
		["base_balance"] = {},
	},
	["Titan"] = {
		["base_damage"] = {},
		["base_balance"] = {},
	},
	["Archivist"] = {
		["base_damage"] = {},
		["base_balance"] = {},
	},
	["Akkari"] = {
		["base_damage"] = {},
		["base_balance"] = {},
	},
	["Shaman"] = {
		["base_damage"] = {},
		["base_balance"] = {},
	},
	["Teradrim"] = {
		["base_damage"] = {},
		["base_balance"] = {},
	},
	["Tidesage"] = {
		["base_damage"] = {},
		["base_balance"] = {},
	},
	["Tyranny"] = {
		["base_damage"] = {},
		["base_balance"] = {},
	},
	["Memory"] = {
		["base_damage"] = {},
		["base_balance"] = {},
	},
	["Corruption"] = {
		["base_damage"] = {},
		["base_balance"] = {},
	},
	["Strife"] = {
		["base_damage"] = {},
		["base_balance"] = {},
	},
	["Bloodborn"] = {
		["base_damage"] = {},
		["base_balance"] = {},
	},
	["Sentinel"] = {
		["base_damage"] = {},
		["base_balance"] = {},
	},
	["Earthcaller"] = {
		["base_damage"] = {},
		["base_balance"] = {},
	},
	["Infiltrator"] = {
		["base_damage"] = {},
		["base_balance"] = {},
	},
	["Seraph"] = {
		["base_damage"] = {},
		["base_balance"] = {},
	},
	["Nocturn"] = {
		["base_damage"] = {},
		["base_balance"] = {},
	},
	damage_done = 0,

}

function rime.pve.dps.balance_add(bal)

	bal = tonumber(bal)
	local class = rime.status.class
	table.insert(rime.pve.dps[class].base_balance, bal)

end


function rime.pve.dps.damage_add(damage)

	local damage = rime.pve.dps.damage_done

	local class = rime.status.class

	table.insert(rime.pve.dps[class].base_damage, damage)

	rime.pve.dps.damage_done = 0

end

function getAverage(t)

	local sum = 0
	for _,v in pairs(t) do -- Get the sum of all numbers in t
		sum = sum + tonumber(v)
	end
	return sum / #t

end

function rime.pve.dps.calculate()

	local class = rime.status.class
	local dps = getAverage(rime.pve.dps[class].base_damage)/getAverage(rime.pve.dps[class].base_balance)

	rime.echo("Your dps over <green>"..#rime.pve.dps[class].base_balance.."<white> attacks as "..class_color()..class.."<white> is <red>"..math.floor(dps), "pve")

end

rime.pve.crit_scheme = {

Chakrasul = {"dark_green", "ansi_green", "LimeGreen", "ansi_light_green", "chartreuse", "pale_green", "aquamarine"},
Bamathis = {"chat_bg", "DimGrey", "ansi_light_black", "gray", "light_gray", "white_smoke", "ivory"},
Ivoln = {"DarkGoldenrod", "peru", "goldenrod", "burlywood", "NavajoWhite", "moccasin", "bisque"},
Iosyne = {"dim_gray", "DimGrey", "ansi_light_black", "ansiRed", "ansi_light_red", "red", "firebrick"},
Lexadhra = {"MediumPurple", "slate_blue", "MediumSlateBlue", "blue_violet", "DarkViolet", "MediumOrchid"},
Tanixalthas = {"navy_blue", "NavyBlue", "a_darkblue", "dodger_blue", "LightCyan", "dodger_blue", "NavyBlue"},
Damariel = {"light_yellow", "lemon_chiffon", "pale_goldenrod", "khaki", "Light_goldenrod", "goldenrod", "gold"},
Dhar = {"slate_gray", "light_slate_grey", "grey", "light_grey", "linen", "white_smoke", "white"},
Ethne = {"light_coral", "coral", "orange", "DarkOrange", "OrangeRed", "red", "firebrick"},
Haern = {"sea_green", "forest_green", "ansiGreen", "DarkGreen", "OliveDrab", "YellowGreen", "GreenYellow"},
Omei = {"royal_blue", "light_slate_blue", "MediumPurple", "purple", "DarkOrchid", "DeepPink", "maroon"},
Severn = {"DarkSlateGrey", "SlateGrey", "LightSlateGray", "LightSteelBlue", "DimGray", "ansiLightBlack", "grey"},
Slyphe = {"cyan", "DarkTurquoise", "cadet_blue", "LightSeaGreen", "MediumSeaGreen", "SeaGreen", "ansi_cyan"},

}

rime.pve.experience = {
	["statpack"] = false,
	["membership"] = false,
	["favour"] = false,
	["artifact"] = false,
	["book"] = false,
	["enhancements"] = false,
	["research"] = false,
	["yellowmist"] = false,
	["compendium"] = false,
	["endgame"] = false,
	["promo"] = false,
	["chalice"] = false,
	["mint"] = false,
	["satiated"] = false,
	["wisdom"] = false,
	["milestone"] = false,
	["antiquated"] = false,
	["experience_field"] = false,
}

rime.pve.compendium = rime.pve.compendium or {}
rime.pve.compendium.check = false

function rime.pve.compendium.add_chapter(chapter)

	if not rime.saved.compendium then
		rime.saved.compendium = {}
		rime.echo("No Compendium tracking was detected, so we created a table in your personal save file!", "pve")
	end

	if not rime.saved.compendium[chapter] then
		rime.saved.compendium[chapter] = {
			pages_collected = 0,
			pages_dedicated = 0,
			Teleport = false,
			Lifeforces = false,
			Deathsense = false,
			Movement = false,
			Experience = false,
			Health = false,
			Mana = false,
			Regenhealth = false,
			Regenmana = false,
			Fortitude = false,
			Damage = false,
			Criticals = false,
			Resistance = false,
			deaths = 0,
		}
		rime.echo("No Compendium tracking was detected for "..chapter..", so we added that!", "pve")
	end

end

function rime.pve.auto_fish()

	local action = ""
	local sep = rime.saved.separator

	if rime.pve.fish_moving then return end

	if rime.pve.auto_fishing then

		if rime.pve.need_discern then

			action = "fishing discern"

		elseif rime.pve.can_fish then

			if rime.pve.line_cast and rime.pve.fish_hooked then
				if rime.pve.fish_str < 50 then
					action = "fishing reel"
				else
					action = "fishing lead"
				end
			elseif not rime.pve.line_cast then
				action = "fishing cast"
			end

		elseif rime.pve.auto_walk_fish then

			rime.pve.fish_moving = true
			rime.pve.auto_walker_fishing()

		end

	elseif not rime.pve.auto_fishing and rime.pve.line_cast then

		action = "fishing cut"

	end

	act("qeb "..action)


end

function rime.pve.auto_walker_fishing()

	local current_room = tostring(gmcp.Room.Info.num)
	local index_count = 0

	for k,v in pairs(rime.pve.fishing.fishing_holes) do

		if v == current_room then

			index_count = k+1

			expandAlias("goto "..rime.pve.fishing.fishing_holes[index_count])
			rime.pve.need_discern = true
			break

		end

	end

end


rime.pve.quests = rime.pve.quests or {}

function rime.pve.get_quests()

	for k,v in ipairs(gmcp.IRE.Tasks.List) do
		if v.type == "quests" and not rime.pve.quests[v.name] then
			rime.pve.quests[v.name] = {
				id = v.id,
				group = v.group,
				status = v.status,
				desc = v.desc,
                }
			rime.echo("New quest \(<green>"..v.name.."<white>\) added!", "pve")
		end
	end
end

function rime.pve.existing_quest(quest)

	if table.is_empty(rime.pve.quest) then return false end

	for k,v in ipairs(rime.pve.quest) do
		if v.name == quest then
			return true
		else
			return false
		end
	end

end

function rime.pve.addMob_event()
	if gmcp.Char.Items.Add.location ~= "room" then return end
	if not gmcp.Char.Items.Add.item.attrib then return end
	if string.find(gmcp.Char.Items.Add.item.attrib, "x") then return end

	rime.pve.mobs = rime.pve.mobs or {}
	
	if gmcp.Char.Items.Add.location == "room" then
		if gmcp.Char.Items.Add.item.attrib ~= nil and not string.find(gmcp.Char.Items.Add.item.attrib, "x") and string.find(gmcp.Char.Items.Add.item.attrib, "m") then
			table.insert(rime.pve.mobs, gmcp.Char.Items.Add.item)
		end
		if gmcp.Room.Info.area:gsub("an unstable section of ","") == "Dovan Hollow" and string.find(gmcp.Char.Items.Add.item.name, "chain") then
			table.insert(rime.pve.mobs, gmcp.Char.Items.Add.item)
		end
	end
	if rime.pve.bashing and rime.target:lower() == "nothing" then
		rime.pve.autoBash("addMob")
	end
end

function rime.pve.removeMob_event()
	if gmcp.Char.Items.Remove.location ~= "room" then return end

	if gmcp.Char.Items.Remove.location == "room" and rime.pve.bashing then
		local removeIndex
		rime.pve.mobs = rime.pve.mobs or {}
		for k,v in pairs(rime.pve.mobs) do
			if gmcp.Char.Items.Remove.item.id == v.id then
				removeIndex = tonumber(k)
			end
		end
		table.remove(rime.pve.mobs, removeIndex)
		if rime.pve.bashing and gmcp.Char.Items.Remove.item.id == rime.target then
			rime.target = "Nothing"
			local agroFound = false
			if rime.pve.area_targets == nil and gmcp.Room.Info.area ~= "Bloodloch" then rime.pve.area_targets = {"eld", "hoplite258845"} end
			for k,v in ipairs(rime.pve.area_targets) do
				for kMob, vMob in ipairs(rime.pve.mobs) do
					if vMob.icon == "face-angry-horns" then
						rime.pve.target(vMob)
						agroFound = true
					end
				end
				if agroFound then
					break
				end
				for kMob, vMob in ipairs(rime.pve.mobs) do
					if string.find(vMob.name, v) and not string.find(vMob.name, "corpse") and not string.find(vMob.name, "A dead%, purple-hued swordfish") and vMob.icon ~= "pet" then
						rime.pve.target(vMob)
						break
					end
				end
			end
		end

		if rime.pve.bashing then rime.pve.autoBash("removeMob") end
	end
end

function rime.pve.getRoom_event()

	if gmcp.Char.Items.List == nil then rime.echo("nil?") return end
	if gmcp.Char.Items.List.location ~= "room" then return end
	
	rime.pve.setArea()
	rime.pve.mobs = {}

	for k,v in ipairs(gmcp.Char.Items.List.items) do
		if v.attrib ~= nil and not string.find(v.attrib, "x") and string.find(v.attrib, "m") then
			table.insert(rime.pve.mobs, v)
		end
		if gmcp.Room.Info.area:gsub("an unstable section of ","") == "Dovan Hollow" and string.find(v.name, "chain") then
			table.insert(rime.pve.mobs, v)
		end
	end
	if rime.pve.bashing then
		rime.target = "Nothing"
		local agroFound = false
		if rime.pve.area_targets == nil then rime.pve.area_targets = {"eld"} end
		for k,v in ipairs(rime.pve.area_targets) do
			for kMob, vMob in ipairs(rime.pve.mobs) do
				if vMob.icon == "face-angry-horns" then
					rime.pve.target(vMob)
					agroFound = true
				end
			end
			if agroFound then break end
			for kMob, vMob in ipairs(rime.pve.mobs) do
				if string.find(vMob.name, v) and not string.find(vMob.name, "corpse") and vMob.icon ~= "pet" and vMob.icon ~= "skull" then
					rime.pve.target(vMob)
					break
				end
			end
		end

		rime.pve.autoBash("getRoom")

	end

	if rime.pve.auto_fishing then

		rime.pve.auto_fish()

	end

end

function rime.pve.autoBash(where)

	if where and debugMode then rime.echo(where) end

	local class = gmcp.Char.Status.class
	local sep = rime.saved.separator

	local pre = ""
			
	if gmcp.Room.Info.area:gsub("an unstable section of ","") == "the Bloodwood" then pre = "get essence" end
	if gmcp.Room.Info.area:gsub("an unstable section of ","") == "Xaanhal" then pre = "get fragment" end
	if gmcp.Room.Info.area:gsub("an unstable section of ","") == "the Shattered Vortex" then pre = "get piece" end
	--[[if string.len(pre) > 1 then
		pre = "absorb ylem" .. sep .. pre
	else
		pre = "absorb ylem"
	end]]

	if rime.pve.bashing then
		if room_skip() and not rime.pve.autowalking then
			--room_walker("room_skip")
			rime.pve.circuit_loop()
		elseif lastRoom() and string.title(rime.target) == "Nothing" then
			if rime.vitals.current_mana < math.floor(rime.vitals.max_mana*.7) then
				if class == "Carnifex" then
					act("qeb soul consume for mana")
				elseif class == "Revenant" then 
					act("qeb phantasm metabolize")
				elseif class == "Adherent" and adherent.strife > 1 then 
					act("adherent embrace")
				else
					act("qeb touch worrystone")
				end
			elseif rime.vitals.current_health < math.floor(rime.vitals.max_health*.6) then
				if class == "Carnifex" then
					act("qeb soul consume for health")
				elseif class == "Revenant" then 
					act("qeb phantasm metabolize")
				elseif class == "Adherent" then 
					if adherent.strife > 1 then  
						act("adherent embrace")
					else
						act("adherent purify")
					end
				else
					act("qeb touch worrystone")
				end
			elseif class == "Carnifex" and not has_def("flanking") then
				act("qeb hound flank")
			else
				local sending_this =  pre .. sep .. def_up("queue"):gsub(sep..sep, sep)
				if sending_this == sep..sep then sending_this = false end
				if sending_this then 
					act("qeb "..sending_this)
				end
				--room_walker("lastRoom")
				rime.pve.circuit_loop()
			end
		elseif rime.target == "nothing" or string.title(rime.target) == "Nothing" then
			if rime.vitals.current_mana < math.floor(rime.vitals.max_mana*.7) then
				if class == "Carnifex" then
					act("qeb soul consume for mana")
				elseif class == "Revenant" then 
					act("qeb phantasm metabolize")
				elseif class == "Adherent" and adherent.strife > 1 then 
					act("adherent embrace")
				else
					act("qeb touch worrystone")
				end
			elseif rime.vitals.current_health < math.floor(rime.vitals.max_health*.6) then
				if class == "Carnifex" then
					act("qeb soul consume for health")
				elseif class == "Revenant" then 
					act("qeb phantasm metabolize")
				elseif class == "Adherent" then 
					if adherent.strife > 1 then  
						act("adherent embrace")
					else
						act("adherent purify")
					end
				else
					act("qeb touch worrystone")
				end
			elseif class == "Carnifex" and not has_def("flanking") then
				act("qeb hound flank")
			else
				local sending_this =  pre .. sep .. def_up("queue"):gsub(sep..sep, sep)
				if sending_this == sep..sep then sending_this = false end
				if sending_this then 
					act("qeb "..sending_this)
				end
				--room_walker("lastRoom")
				rime.pve.circuit_loop()
			end
		else
			rime.pve.bash_attack()
		end
	end

end

function rime.pve.target(mobTable)
    local mobName = mobTable.name
    local mobID = mobTable.id
    for k,v in ipairs(rime.pve.area_targets) do
		if string.findPattern(mobName, v) and mobID ~= "162498" and not string.find(mobName, "Lena") then
			rime.target = mobID
			if id then killTrigger(id) end
			if id2 then killTrigger(id2) end
   			id2 = tempTrigger(v, [[selectString("]] .. v .. [[", 1) fg("red") resetFormat()]])
 		end		
	end
end

function rime.pve.setArea()
	if not rime.pve.next_area and rime.pve.walking > 1 then return end
	local circuit = rime.pve.circuit
	local area = gmcp.Room.Info.area
	if not rime.pve.follow and rime.pve.bashing and not table.contains(rime.pve.circuits[circuit].areas, area) then return end
    if rime.pve.target_list[gmcp.Room.Info.area:gsub("an unstable section of ", "")] == nil and not table.contains(rime.pve.circuits[circuit], gmcp.Room.Info.area) then
        rime.pve.area_targets = {}
        return
    end

    if rime.pve.next_area and gmcp.Room.Info.area ~= rime.pve.next_area then return end

    rime.pve.next_area = false
   	if rime.pve.circuits[circuit] and rime.pve.circuits[circuit].targets then
   		if rime.pve.area_targets ~= rime.pve.circuits[circuit].targets then
    		rime.pve.area_targets = rime.pve.circuits[circuit].targets
    		rime.pve.area = rime.pve.directions_mapper[gmcp.Room.Info.area:gsub("an unstable section of ", "")]
        	rime.pve.area_name = gmcp.Room.Info.area:gsub("an unstable section of ", "")
        	rime.pve.walking = 1
        	rime.echo(
        	    "[1] Entered <cyan>"
        	        .. gmcp.Room.Info.area:gsub("an unstable section of ", "")
        	        .. "<white>. Changing Target List.",
        	    "pve"
        	)
        	rime.echo("Walking directions updated.", "pve")
        end
    elseif rime.pve.area_targets ~= rime.pve.target_list[gmcp.Room.Info.area:gsub("an unstable section of ", "")] then
        rime.pve.area_targets = rime.pve.target_list[gmcp.Room.Info.area:gsub("an unstable section of ", "")]
        if not table.contains(rime.pve.area_targets, rime.pve.target_list.global_targets[1]) then
            for k, v in pairs(rime.pve.target_list.global_targets) do
                table.insert(rime.pve.area_targets, v)
            end
        end
        rime.pve.area = rime.pve.directions_mapper[gmcp.Room.Info.area:gsub("an unstable section of ", "")]
        rime.pve.area_name = gmcp.Room.Info.area:gsub("an unstable section of ", "")
        rime.pve.walking = 1
        rime.echo(
            "[2] Entered <cyan>"
                .. gmcp.Room.Info.area:gsub("an unstable section of ", "")
                .. "<white>. Changing Target List.",
            "pve"
        )
        rime.echo("Walking directions updated.", "pve")
    end

end


rime.pve.circuits = rime.pve.circuits or {}
rime.pve.circuit = rime.pve.circuit or "nothing"
rime.pve.circuits = {
	["200"] = {
		["blurb"] = "Route meant for End Game Experience.",
		["areas"] = {"the Underbelly", "the Maestral Shoals", "Clawhook Range", "the Bakal Chasm", "the Maul", "a basilisk lair", "Dovan Hollow", "the Dramedo Warrens",
					"the forgotten depths of Mount Helba", "the Dyisen-Ashtan Memoryscape", "Eftehl Island", "Luzith's Lair", "Mejev Nider Nesve wo Ti, Matati wo Eja sota Aran wo Aransa",
					"the Squal", "the Forgotten Dome"},
		["torch"] = "Eftehl Island",
		},

	["leveling"] = {
		["blurb"] = "Route meant for gaining Experience while leveling.",
		["areas"] = {"Riparium", "the Centipede Cave", "Rebels' Ridge", "the Maghuir Fissure",}
		},

	["apothecary"] = {
		["blurb"] = "Hunts down mobs for Apothecary purposes",
		["areas"] = {"the Isle of Ollin", "the Aureliana Forest"},
		["targets"] = {"a dark%-furred, rabid boar", "sounder", "wild boar",},
		["the Aureliana Forest"] = {"4808","4816", "4817", "4825"}
		},

	["horns"] = {
 		["blurb"] = "Hunts down stags for horns",
 		["areas"] = {"the Dolbodi Campsite", "Eastern Ithmia", "the Western Ithmia", "the Northern Ithmia"},
 		["targets"] = {"a great white stag", "a herd of ten white stags"},
		},

	["gold"] = {
		["blurb"] = "Make some money",
		["areas"] = {"Drakuum", "the Teshen Caldera", "the Ayhesa Cliffs", "the Forgotten Dome", "the Three Rock Outpost", "Yuzurai village", "the Salma Settlement",},
	},

	["low level"] = {
	    ["blurb"] = "Route meant for gaining Experience while leveling (31-50).",
	    ["areas"] = {"Rotfang Warren", "Riparium", "Rebels' Ridge", "the Maghuir Fissure","the Ilhavon Forest","Raim Vale","the Centipede Cave", --[["the lost city of Iviofiyiedu","Catacombs beneath Djeir","the Isle of Polyargos"]]}
	--areas that might be too hard for this window depending on class or are a pain in the ass to travel to are commented out at the end
	    },

	["mid level"] = {
	    ["blurb"] = "Route meant for gaining Experience while leveling (50-75).",
	    ["areas"] = {"the Three Rock Outpost", "the Centipede Cave", "Rebels' Ridge", "the Maghuir Fissure","Three Widows","the lost city of Iviofiyiedu",--[["the Ruins of Farsai","Catacombs beneath Djeir"]]}
		--commented out areas that may be too hard depending on class/level, can be added in after testing/someone dies a lot.
	    },

	["high level"] = {
	    ["blurb"] = "Route meant for gaining Experience while leveling (75-100).",
	    ["areas"] = {"the Teshen Caldera","the Temple of Sonn", "Dun Fortress", "the Ruins of Farsai", "Court of the Consortium", "the Arurer Haven","Mount Heylai","the Torturers' Caverns","the Caverns of Mor","the Salma Settlement",--[["a snake pit","Raugol Fissure","the Sparklight Rift","the Fengard Keep","the Eresh Mines","Yuzurai village"]]}
	--this level window has a big gap of skill/deathability, so I commented out some areas that might get some classes killed and put them at the end
	    },

}

function rime.pve.select_circuit(circuit, secondary)

	if secondary then

		if secondary == "leader" or secondary == "lead" then

			rime.pve.leading = true

			rime.echo("Rime's basher will now pause on known exits that cause the group to split, and wait for the follower to catch up!", "pve")

		elseif secondary == "level" then

			circuit = circuit .. " " .. secondary

		end

	end

	if rime.pve.circuits[circuit] then

		rime.echo("You will now start bashing along the "..circuit.." circuit.\n\n"..rime.pve.circuits[circuit].blurb.."\n", "pve")

		rime.pve.circuit = circuit
		rime.pve.bashing = true
		rime.pve.autowalk = true
		rime.cure_set = "default"

	elseif circuit == "list" then

		local circuit_list = {}

		for k,v in pairs(rime.pve.circuits) do
			table.insert(circuit_list, "Bash circuit name: <mustard>"..k.."\n<RoyalBlue>"..rime.pve.circuits[k].blurb.."<white>\n\n")
		end

		rime.echo("List of known bashing circuits:\n\n"..table.concat(circuit_list), "pve")

		if rime.pve.circuit ~= "nothing" then

			rime.echo("Your current selected circuit is <mustard>"..rime.pve.circuit, "pve")

		end

	elseif circuit == "zone" then

		local area = gmcp.Room.Info.area

		if not rime.pve.circuits[area] then
			rime.pve.circuits[area] = {}
			rime.pve.circuits[area].areas = {area}
			rime.pve.circuits[area].blurb = "Temporary zone bashing for "..area
			rime.pve.circuit = area
			rime.echo("Created a temporary zone for "..area)
			rime.pve.bashing = true
			rime.pve.autowalk = true
			rime.pve.autowalking = false
			rime.cure_set = "default"
			act("ql")
		else
			rime.echo("Temporary zone for "..area.." already created")
			rime.pve.bashing = true
			rime.pve.autowalk = true
			rime.pve.autowalking = false
			rime.pve.circuit = area
			rime.cure_set = "default"
		end

	elseif circuit == "follow" then

		rime.pve.follow = true
		rime.pve.bashing = true
		rime.pve.autowalk = false
		rime.pve.walking = 1
		rime.pve.circuit = "follow"
		rime.echo("Following bashing has been started! You will attack targets in any area Rime has a list of targets for and attempt to follow your top through known special exits.", "pve")
		if not rime.pve.top then
			rime.echo("YOU NEED TO SET A TOP, THERE CURRENTLY IS NOT ONE SELECTED. USE THE ALIAS <red>top<white>\<person\>")
		elseif rime.pve.top then
			rime.echo("You are currently bottoming for "..rime.pve.top)
		end

	elseif circuit == "waiting" then

		rime.pve.leader_pause = false
		rime.pve.waiting_on = {}
		rime.pve.autowalking = false
		rime.echo("Cleared waiting list and resuming bashing.")

	elseif circuit == "off" then

		rime.pve.bashing = false
		rime.pve.autowalk = false
		rime.pve.top = false
		rime.pve.leading = false
		rime.pve.follow = false
		rime.pve.support = false
		rime.pve.autowalking = false
		rime.pve.walking = 0
		rime.pve.next_area = false
		rime.pve.circuit = "nothing"
		rime.echo("Bashing has been turned off! Top, Leading, Follow, and Support settings have all been reset.", "pve")
		expandAlias("mstop")
		act("qeb")

	else

		rime.echo("We found no circuit by that name.", "pve")

	end

end

function rime.pve.circuit_loop()

	if rime.pve.autowalking then rime.echo("not moving because of rime.pve.autowalking", "pve") return end

	if rime.pve.follow then rime.echo("Not moving because we're following "..rime.pve.top) return end

	if rime.pve.leader_pause then rime.echo("Waiting on follower.", "pve") return end

	if rime.pve.circuit == "nothing" then

		return rime.echo("You currently have no circuit selected.", "pve")

	end

	local circuit = rime.pve.circuit
	local circuit_areas = rime.pve.circuits[circuit].areas
	local area = gmcp.Room.Info.area
	local gps = rime.pve.directions_mapper

	if not table.contains(circuit_areas, area) and not rime.pve.autowalking and not rime.pve.next_area then

		rime.echo("You're not currently in an area on this circuit! We'll move you to the first area", "pve")

		rime.pve.autowalking = true
        local firstarea = circuit_areas[1]
        return expandAlias("goto "..    rime.pve.directions_mapper[firstarea][1])

	elseif rime.pve.next_area and not rime.pve.autowalking then

		rime.echo("[1] Next area is "..rime.pve.next_area)
		rime.pve.autowalking = true
		if rime.pve.circuits[circuit][rime.pve.next_area] then
			gps = rime.pve.circuits[circuit][rime.pve.next_area]
		end
		local gps_mode = rime.pve.circuits[circuit][rime.pve.next_area] or rime.pve.directions_mapper[rime.pve.next_area]

		return expandAlias("goto "..gps_mode[1])

	end

	local path = rime.pve.circuits[circuit][area] or rime.pve.directions_mapper[area]
	local last_room = path[#path]
	local vnum = gmcp.Room.Info.num

	--if tostring(last_room) == tostring(vnum) then
	if rime.pve.walking >= #path then
		local place = table.index_of(circuit_areas, area)
		if place == #circuit_areas then place = 0 end
		local next_place = place+1
		rime.pve.autowalking = true
		if rime.saved.everburning and rime.pve.everburning == circuit_areas[next_place] then
			rime.pve.next_area = circuit_areas[next_place]
			return act("qeb get "..rime.saved.everburning_torch.." from pack", "wave "..rime.saved.everburning_torch)
		else
			rime.pve.next_area = circuit_areas[next_place]
			rime.echo("Next area is "..rime.pve.next_area)
			rime.echo("circuit is "..circuit.." and next_place is "..next_place)
			local gps_mode = rime.pve.circuits[circuit][rime.pve.next_area] or rime.pve.directions_mapper[rime.pve.next_area]
			rime.pve.walking = 1
			return expandAlias("goto "..gps_mode[1])
		end
	end

	if rime.target == "nothing" or rime.target == "Nothing" or room_skip() then
		if not rime.pve.walking then rime.pve.walking = 1 end
		rime.pve.walking = rime.pve.walking+1
		if path == nil then rime.echo("path is nil?!!!") end
		expandAlias("goto "..path[rime.pve.walking])
		if not rime.pve.bashing_paused then rime.pve.autowalking = true end
		return
	end

end

function rime.pve.fix_basher()

	if not rime.pve.bashing then return end

	local vnum = gmcp.Room.Info.num
	local area = gmcp.Room.Info.area
	local circuit = rime.pve.circuit
	local path =  rime.pve.circuits[circuit][area] or rime.pve.directions_mapper[area]

	if path[rime.pve.walking] == tostring(vnum) then
		rime.pve.autowalking = false
		--act("ql")
	end

end

function rime.pve.create_bash_circuit(name)

	if not rime.saved.bashing_circuit then
		rime.saved.bashing_circuit = {}
	end

	if not rime.saved.bashing_circuit[name] then
		rime.saved.bashing_circuit[name] = {
			["blurb"] = {},
			["areas"] = {},
		},
		rime.echo("Created a new bashing circuit named "..name.."<white>!", "pve")
	else
		rime.echo("That route name \(<dark_olive_green>"..name.."<white>\) is already taken! Add to it with <red>rime bashing circuit \<name\> \<area to add\><white>!", "pve")
	end

end

function rime.pve.add_bash_circuit(name, area, priority)

	if priority then
		table.insert(rime.saved.bashing_circuit[name].areas, area, tonumber(priority))
		rime.echo("Added "..area.." into "..name.." bashing route at priority #"..priority, "pve")
	else
		table.insert(rime.saved.bashing_circuit[name].areas, area)
		rime.echo("Added "..area.." into "..name.." bashing route at the bottom priority!", "pve")
	end

end

function rime.pve.add_bash_blurb(name, info)

	if not rime.saved.bashing_circuit[name] then
		rime.echo("No bashing circuit detected by that name!", "pve")
	else
		rime.saved.bashing_circuit[name].blurb = info
		rime.echo("Route <red>"..name.."<white>'s blurb updated! The blurb is now\: <ansi_green>"..info, "pve")
	end

end

function room_walker(where)

	if where and debugMode then rime.echo(where) end
	if underbelly_pause then rime.echo("Not moving because of underbelly_pause") return end
	if not rime.pve.autowalk then rime.echo ("not moving because of rime.pve.autowalk") return end	
	if rime.pve.autowalking then rime.echo("not moving because of rime.pve.autowalking") return end
	local name = gmcp.Char.Status.name
	local sep = rime.saved.separator

	if 	lastRoom() then 
		rime.echo("Area cleared.", "pve")
		local sep = rime.saved.separator
		local mount = rime.saved.mount
		if tonumber(gmcp.Char.Vitals.mounted) == 0 then
			act("qeb recall " .. mount .. sep .. "recall mount" .. sep .. "quickmount "..mount)
		end
		if rime.pve.area ~= nil and rime.pve.botMode and #rime.pve.area == rime.pve.walking then
			rime.pve.autowalking = true
			if rime.pve.area_name == "the Underbelly" and not rime.pve.bashing_paused then
				expandAlias("goto maestral shoals")
			elseif rime.pve.area_name == "the Maestral Shoals" and not rime.pve.bashing_paused then
				act("sac corpses")
				expandAlias("goto clawhook")
			elseif rime.pve.area_name == "Clawhook Range" and not rime.pve.bashing_paused then
				expandAlias("goto bakal")
			elseif rime.pve.area_name == "the Bakal Chasm" and not rime.pve.bashing_paused then
				expandAlias("goto Maul")
			elseif rime.pve.area_name == "the Maul" and not rime.pve.bashing_paused then
				expandAlias("goto a basilisk lair")
			elseif rime.pve.area_name == "a basilisk lair" and not rime.pve.bashing_paused then
				act("qeb give 50 basilisk to Kyri"..sep.."give 50 basilisk to Kyri"..sep.."give 50 basilisk to Kyri")
				expandAlias("goto dovan")
			elseif rime.pve.area_name == "Dovan Hollow" and not rime.pve.bashing_paused then
				act("qeb sac corpses")
				expandAlias("goto dramedo warrens")
			elseif rime.pve.area_name == "the Dramedo Warrens" and not rime.pve.bashing_paused then
				act("qeb sac corpses")
				expandAlias("goto forgotten depths of Mount Helba")
			elseif rime.pve.area_name == "the forgotten depths of Mount Helba" and not rime.pve.bashing_paused then
				act("qeb sac corpses")
				expandAlias("goto Memoryscape")
			elseif rime.pve.area_name == "the Dyisen-Ashtan Memoryscape" and not rime.pve.bashing_paused then
				act("qeb sac corpses")
				expandAlias("goto eftehl")
				act("qeb wave torch")
			elseif rime.pve.area_name == "Eftehl Island" and not rime.pve.bashing_paused then
				act("qeb sac corpses")
				expandAlias("ut")
				expandAlias("goto luzith")
			elseif rime.pve.area_name == "Luzith's Lair" and not rime.pve.bashing_paused then
				act("qeb sac corpses")
			--[[	expandAlias("goto the Mannaseh Swamp")
			elseif rime.pve.area_name == "the Mannaseh Swamp" then
				act("qeb sac corpses")]]
				expandAlias("goto Mejev")
			elseif rime.pve.area_name == "Mejev Nider Nesve wo Ti, Matati wo Eja sota Aran wo Aransa" and not rime.pve.bashing_paused then
				act("qeb sac corpses")
				expandAlias("goto squal")
			elseif rime.pve.area_name == "the Squal" and not rime.pve.bashing_paused then
				act("qeb give 50 keeper to Sutra"..sep.."give 50 keeper to Sutra"..sep.."give 50 keeper to Sutra")
				expandAlias("goto forgotten dome")
			elseif rime.pve.area_name == "the Forgotten Dome" and not rime.pve.bashing_paused then
				rime.pve.bashing = false
				rime.pve.autowalk = false
				rime.pve.botMode = false
				rime.pve.bashing_paused = true
				rime.pve.corpse_turn_in = true
				expandAlias("goto 56106")
			elseif rime.pve.area_name == "the Forgotten Dome" and rime.pve.bashing_paused then
				rime.pve.bashing_paused = false
				expandAlias("goto underbelly")
			end
		end
		return
	end



	if not rime.pve.bashing then rime.echo("not doing shit because of this check") return end
	if rime.target == "nothing" or rime.target == "Nothing" or room_skip() then
		if not rime.pve.walking then rime.pve.walking = 1 end
		rime.pve.walking = rime.pve.walking+1
		expandAlias("goto "..rime.pve.area[rime.pve.walking])
		if not rime.pve.bashing_paused then rime.pve.autowalking = true end
		return
	end

end

function lastRoom()
	if rime.pve.area == nil then return true end
	if rime.pve.area[#rime.pve.area] == nil then return true end

	return #rime.pve.area == rime.pve.walking

end

function room_skip()

	local players = gmcp.Room.Players
	
	if #players > 0 then
		for k,v in pairs(players) do
			if not table.contains(rime.pve.group, v.name) then
				rime.echo("You're not alone", "pve")
				return true
			end
		end
	end
	return false

end

function rime.pve.bash_reset()

	local class = rime.status.class

	rime.pve.bashing =  false
	rime.pve.autowalking =  false
	rime.pve.walking = 1
	rime.pve.autowalk = false
	rime.echo("Bashing Reset", "pve")
	rime.pve.goldTracking = {}
	rime.pve.MistTracking = {}
	km.expTracking = {}
	rime.pve.dps[class].base_damage = {}
	rime.pve.dps[class].base_balance = {}
end

rime.pve.goldTracking = rime.pve.goldTracking or {}
rime.pve.MistTracking = rime.pve.MistTracking or {}

function rime.pve.goldUpdate(amount)
	local where = gmcp.Room.Info
	local when = os.time()

	local goldLog = {
		["where"] = {
			["roomNum"] = where.num,
			["area"] = where.area,
		},
		["when"] = when,
		["amount"] = amount,
	}

	table.insert(rime.pve.goldTracking, goldLog)

end

function rime.pve.MistUpdate(amount)
	local where = gmcp.Room.Info
	local when = os.time()

	local MistLog = {
		["where"] = {
			["roomNum"] = where.num,
			["area"] = where.area,
		},
		["when"] = when,
		["amount"] = amount,
	}

	table.insert(rime.pve.MistTracking, MistLog)

end

function rime.pve.goldCheck()

	local total = 0
	local startTime = nil
	local endTime = nil
	local thisArea = gmcp.Room.Info.area:gsub("an unstable section of ","")
	local thisRoom = gmcp.Room.Info.num
	local areaGold = 0
	local roomGold = 0
	for _, log in ipairs(rime.pve.goldTracking) do
		if not startTime or log.when < startTime then
			startTime = log.when
		end
		if not endTime or log.when > endTime then
			endTime = log.when
		end
		if log.where.area == thisArea then
			areaGold = areaGold + log.amount
		end
		if log.where.roomNum == thisRoom then
			roomGold = roomGold + log.amount
		end
		total = total + log.amount
	end

	if not (endTime or startTime) then return end

	local duration = endTime - startTime

	local days = math.floor(duration/60/60/24)
	local hours = math.floor((duration - (days*60*60*24))/60/60)
	local minutes = math.floor((duration - (hours*60*60) - (days*60*60*24))/60)
	local seconds = math.floor((duration - (minutes*60) - (hours*60*60) - (days*60*60*24)))

	local timeString = (days and tostring(days).." days ")..(hours and tostring(hours).." hours ")..
(minutes and tostring(minutes).." minutes ")..(seconds and tostring(seconds).." seconds")

	local gps = total / duration
	local gph = total / (duration/60/60)

	cecho("\n<yellow>Gold in "..thisArea.." is: "..(areaGold<1 and "<red>" or "<green>")..tostring(areaGold))
	cecho("\n<yellow>Gold at v"..thisRoom.." is: "..(roomGold<1 and "<red>" or "<green>")..tostring(roomGold))
	cecho("\n<yellow>Gold change is: "..(total<=0 and "<red>" or "<green>")..tostring(total).."<yellow> over "..timeString)
	cecho("\n<yellow>Gold Per Second is: "..(gps<=0 and "<red>" or "<green>")..string.format("%.2f",gps))
	cecho("<yellow> Gold Per Hour is: "..(gph<=0 and "<red>" or "<green>")..string.format("%.2f",gph))


end

function rime.pve.MistCheck()

	local total = 0
	local startTime = nil
	local endTime = nil
	local thisArea = gmcp.Room.Info.area:gsub("an unstable section of ","")
	local thisRoom = gmcp.Room.Info.num
	local areaMist = 0
	local roomMist = 0
	for _, log in ipairs(rime.pve.MistTracking) do
		if not startTime or log.when < startTime then
			startTime = log.when
		end
		if not endTime or log.when > endTime then
			endTime = log.when
		end
		if log.where.area == thisArea then
			areaMist = areaMist + log.amount
		end
		if log.where.roomNum == thisRoom then
			roomMist = roomMist + log.amount
		end
		total = total + log.amount
	end

	if not (endTime or startTime) then return end

	local duration = endTime - startTime

	local days = math.floor(duration/60/60/24)
	local hours = math.floor((duration - (days*60*60*24))/60/60)
	local minutes = math.floor((duration - (hours*60*60) - (days*60*60*24))/60)
	local seconds = math.floor((duration - (minutes*60) - (hours*60*60) - (days*60*60*24)))

	local timeString = (days and tostring(days).." days ")..(hours and tostring(hours).." hours ")..
(minutes and tostring(minutes).." minutes ")..(seconds and tostring(seconds).." seconds")

	local gps = total / duration
	local gph = total / (duration/60/60)

	cecho("\n<yellow>Mist in "..thisArea.." is: "..(areaMist<1 and "<red>" or "<green>")..tostring(areaMist))
	cecho("\n<yellow>Mist at v"..thisRoom.." is: "..(roomMist<1 and "<red>" or "<green>")..tostring(roomMist))
	cecho("\n<yellow>Mist change is: "..(total<=0 and "<red>" or "<green>")..tostring(total).."<yellow> over "..timeString)
	cecho("\n<yellow>Mist Per Second is: "..(gps<=0 and "<red>" or "<green>")..string.format("%.2f",gps))
	cecho("<yellow> Mist Per Hour is: "..(gph<=0 and "<red>" or "<green>")..string.format("%.2f",gph))


end



rime.pve.fishing.fishing_holes = {
	"23915", "2781", "1041", "57566", "36264", "14469", "787", "23899", "23892", "1590", "1603", "9704", "16540", "989", "60034",
	"13114", "8109", "58866", "3005", "42876", "3416", "32909",
}

rime.pve.exploration = rime.pve.exploration or {}

rime.pve.exploration.area = rime.pve.exploration.area or "none"
rime.pve.exploration.area_rooms = rime.pve.exploration.area_rooms or "none"
rime.pve.exploration.auto_exploring = rime.pve.exploration.auto_exploring or false
rime.pve.exploration.room_count = rime.pve.exploration.room_count or 0
rime.pve.exploration.percent_explored = 0

function rime.pve.exploration.area_set(area)

	if area == "beneath Stormcaller Crag" then area = "Stormcaller Crag" end


	if #rime.pve.exploration.area_rooms ~= #getAreaRooms(mmp.findAreaID(area, "exact")) then

		rime.pve.exploration.area_rooms = getAreaRooms(mmp.findAreaID(area, "exact"))
		rime.pve.exploration.area = area
		rime.pve.exploration.room_count = 0
		rime.echo("Exploration area set to <green>"..area.."<white>. Thank you for travelling with Rime Exploration LLC.", "explorer")

	end

end

function rime.pve.exploration.auto_explore()


	if tonumber(rime.pve.exploration.percent_explored) < 100 and rime.pve.exploration.auto_exploring and rime.pve.exploration.room_count <= #rime.pve.exploration.area_rooms then

		mmp.gotoRoom(rime.pve.exploration.area_rooms[rime.pve.exploration.room_count])

	elseif rime.pve.exploration.auto_exploring then

		rime.pve.exploration.auto_exploring = false
		rime.pve.exploration.room_count = 0

		rime.echo("Explored 100% of the area! Or as much of it as you can", "explorer")

	end

end


---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by kentmccullough.
--- DateTime: 6/2/22 2:18 AM
---
rime.pve = rime.pve or {}
rime.pve.leySearch = rime.pve.leySearch or {}
rime.pve.leySearch.currentIndex = rime.pve.leySearch.currentIndex or 1
rime.pve.leySearch.searching = rime.pve.leySearch.searching or false
rime.pve.leySearch.minorCount = rime.pve.leySearch.minorCount or 0
rime.pve.leySearch.runCount = rime.pve.leySearch.runCount or 0
rime.pve.leySearch.roomList = {
    1682, -- Raphaelan Highway
    20389, -- Raim Vale
    13253, -- Isle of Mostyn
    26690, -- Ilhavon Forest
    26668, -- village Dennel
    1180, -- Prelatorian Highway
    1422, -- Prelatorian Highway
    11326, -- Central Wilderness
    11312, -- Attica
    4354, -- Siroccian Mountains
    36865, -- Arget Massai
    26820, -- Siroccian Tunnels
    38090, -- Nal'jin Depths
    26994, -- Court of the Consortium
    32237, -- Tarissa's archaeological dig site
    28511, -- Putoran Hills
    35217, -- volcano
    60845, -- Sparklight Rift
    35117, -- Putoran Caverns
    26920, -- Chapel Garden
    46341, -- Mournhold
    32189, -- Berhain
    45483, -- Shastaan Warrens
    14696, -- Arbothia
    1644, -- Pash valley
    56942, -- a snake pit
    62798, -- Jaru
    1602, -- Peshwar Delta
    19344, -- Caverns of Mor
    1434, -- Shamtota Hills
    36677, -- Xaanhal
    17612, -- Village of Torston
    62102,  -- Saliltul Swamp
    71074, -- Ruins of Masilia
    31599, -- The Shamtota Caverns
    1262, -- Mhojave desert
    19854, -- Drakuum
    60142, -- El'Jazira
    20835, -- Festering Wastes
    23202, -- Torturers' Caverns
    21286, -- Village of Kornar
    73619, -- Villimo Fields
    76762, -- Lich Scriptorium
    10086, -- Village of Saluria
    16584, -- Eastern Itzatl Rainforest
    60726, -- Itzatl Morass
    15344, -- Eresh Mines
    17069, -- Ruins of Farsai
    16706, -- Temple of Sonn
    9885, -- Western Itzatl Rainforest
    59609, -- Yuzurai village
    74766, -- the Forgotten Stretch
    9852, -- Vashnar mountains
    74705, -- the Vashnar Divide
    13201, -- Isle of Despair
    57548, -- twisted expanse of the Bloodwood
    4964, -- Bastion of Illdon
    38896, -- Tiyen Esityi
    16274, -- Feral Caves
    19320, -- Aurer Haven
    5027, -- Barony of Dun Valley
    6, -- Moghedu
    55276, -- Teshen Caldera
    18439, -- village of Xoral
    56278, -- lost city of Iviofiyiedu
    25408, -- Khauskin Mines
    11412, -- Akhenades
    1774, -- Azdun dungeon
    3106, -- Siha Dylis
    11634, -- Black Keep
    11962, -- Perilaus
    11994, -- City of Djeir
    13098, -- Catacombs beneath Djeir
    1010, -- Mannaseh Swamp
    1009, -- Liruma Scrubland
    36271, -- Spiral of the Corrupt
    1042, -- Aureliana Forest
    49749, -- Raugol Fissure
    1037, -- Morgun Forest
    64353, -- the Western Liriuma Scrubland
    64405, -- the Ophidian Empire
    64479, -- the sunken ruins of the Nesynesfe vakh Khatafin
    60176, -- town of Mitrine
    276, -- the Old Road
    16425, -- Western Wilderness
    10811, -- Scidve
    34760, -- Scidve Cove
    1299, -- Prelatorian Highway
    56647, -- The village of Bihrkaen
    18243, -- the North Strand
    47147, -- Huanazedha
    72008, -- Isle of Ollin
    4059, -- the Northern Road
    888, -- Western Ithmia
    25721, -- the Ranger's Trail
    19602, -- Salma Settlement
    5675, -- Eastern Wilderness
    5598, -- Riparium
    32908, -- The Riparium Abyss
    5692, -- Eastern Ithmia
    5700, -- The Oaken Grove
    31552, -- The Myesis River
    21001, -- The Maghuir Fissure
    19323, -- Dolbodi Campsite
    42831, -- Vintal Glade
    805, -- The Northern Ithmia
    71853, -- the village of Abelaas
    19810, -- The Kalydian Forest
    71554, -- Cantor's Copse
    9494, -- the Gilded Rose Inn
    19987, -- The Ayhesa cliffs
    64288, -- the village of Tasur'ke
    55101, -- the Forgotten Dome
    9931, -- The Dry Planes
    18462, -- Rebel's Ridge
    20281, -- Three Rock Outpost
    20932, -- Caverns of Telfinne
    4163, -- The Northern Plains
    73516, -- Bravestarr homestead
    3273, -- The Fengard Keep
    70916, -- Rimewatch
    8854, -- the Mamashi Grasslands
    20855, -- Mamashi Tunnels
    63730, -- Kald
    14418, -- Village of Mrenadh
    14410, -- Kentorakro
    8797, -- the Tarea Mountains
    58675, -- Three Widows
    22702, -- Cathedral of Gloaming
    58682, -- Western Ocean
    16282, -- Luzith's Lair
    54482, -- Mount Heylai
    22824, -- Centipede Cave
    23791, -- The Augerweald
    23128, -- Mount Humgurd
    13425, -- Mount Hubride
    16976, -- The Southern Tundra
    18082, -- The Western Tundra
    51167, -- the Northern Tundra
    44816, -- Stormcaller Crag
    48216, -- beneath Stormcaller Crag
    25969, -- Ankyrean Containment Laboratory
    --49875, -- ancient barrow
    18601, -- the village of Nuunva
 --   22567, -- the Tarean Ice Caverns
    22477, -- Alaqsii Inlet
  --  53660, -- the Tsinkin Municipality
    21908, -- Halls of Tornos
    --	58789, -- Mandre's Tower
    --24548, -- The Aerie
--    5724, -- Garden of the Dryads
}
function rime.pve.leySearch.start()
    rime.pve.leySearch.currentIndex = 1
    rime.pve.leySearch.searching = true
    if not has_def("nodesense") then
    	if tonumber(gmcp.Char.Vitals.residual) >= 20 then
    		act("qeb nodesense")
    	else
    		rime.echo("You don't have enough reserves to activate Nodesense! Go do your mines!")
    	end
    end
    rime.pve.leySearch.next()
end

function rime.pve.leySearch.next()
    if not rime.pve.leySearch.searching then return end

    local currentLey = rime.pve.leySearch.roomList[rime.pve.leySearch.currentIndex]
    rime.pve.leySearch.currentIndex = rime.pve.leySearch.currentIndex + 1
    if not currentLey then
        rime.pve.leySearch.searching = false
    end
    if currentLey ~= nil then
    	expandAlias("goto " .. currentLey)
    else
    	rime.echo("All done!", "pve")
    	rime.echo("Your total minor count for this run was: "..rime.pve.leySearch.minorCount, "pve")
    end
end

function rime.pve.leySearch.stop()
    rime.pve.leySearch.searching = false
    rime.pve.leySearch.currentIndex = #rime.pve.leySearch.roomList
    act("path stop")
end

function rime.pve.leySearch.findMinor()
    local sep = rime.saved.separator
    act("path find minor"..sep.."path go")
end

function rime.pve.leySearch.finishedPathFind()
    if not rime.pve.leySearch.searching then return end
    act("extraction")
end

function rime.pve.leySearch.reset_count()
	rime.pve.leySearch.runCount = 0
	rime.echo("Reset the count!")
end

rime.makeAlias({
    ["name"] = "^leystart$",
    ["func"] = [[rime.pve.leySearch.start() rime.pve.leySearch.reset_count()]]
})
rime.makeAlias({
    ["name"] = "^leygo$",
    ["func"] = [[rime.pve.leySearch.next()]]
})
rime.makeAlias({
    ["name"] = "^leystop$",
    ["func"] = [[rime.pve.leySearch.stop()]]
})


--rime.makeEvent({
   -- ["name"] = "mmapper arrived",
   -- ["func"] = [[rime.pve.leySearch.findMinor()]]
--})

rime.makeTrigger({
    ["type"] = tempRegexTrigger,
    ["pattern"] = "^There are no minor nodes in the area\.",
    ["action"] = [[rime.pve.leySearch.next()]],
})

rime.makeTrigger({
    ["type"] = tempExactMatchTrigger,
    ["pattern"] = "You have reached your destination.",
    ["action"] = [[rime.pve.leySearch.finishedPathFind()]],
})

rime.makeTrigger({
    ["type"] = tempExactMatchTrigger,
    ["pattern"] = "Latent energies flare around the focus, crackling ominously with power before winking out with a hushed whisper. Motes of pale light drift upwards from the dying leyline's focus, smoldering like a dying ember into the firmament as the focal point collapses into the ether.",
    ["action"] = [[rime.pve.leySearch.findMinor()]]
})

rime.makeTrigger({
	["type"] = tempExactMatchTrigger,
	["pattern"] = "You are already there.",
	["action"] = [[rime.pve.leySearch.finishedPathFind()]],
})

rime.makeTrigger({
    ["type"] = tempRegexTrigger,
    ["pattern"] = "^Latent energies flare around the focus, crackling ominously with power before winking out with.*\.",
    ["action"] = [[rime.pve.leySearch.minorCount = rime.pve.leySearch.minorCount + 1]],
})

rime.pve.target_list = {
	--["Tak-re"] = { "a vicious, mutated shark", "a hundred%-strings jellyfish", "a horrifically deformed woodpecker", "a warped squirrel", "a mutated deer"},
	["Rotfang Warren"] = {
		"rat",
		"villager",
		"cavehopper",
		"priest",
		"bat",
		"alpha",
		"children",
	},

	["the desert village of El'Jazira"] = {},
	["the Central Wilderness"] = {"a mottled green bullfrog"},
	["global_targets"] = {"hobgobbler"},
	["Kkirrrr'shi Hive"] = { "a feral Hokkali soldier", "a twisted Hokkali hunter", "a freshly spawned Hokkali ambusher","a rabid Hokkali drone",},
	["Difohr Passage"] = {"a skittering onyx eld","a fragmented eld of shadowy onyx","a shattered eld monstrosity"},
	["Myesian Run"] = {"a skittering verdant eld"},
	["Cinderbreach Mine"] = {"a fiery crimson fragmented eld", "a shattered eld monstrosity", "a skittering crimson eld"},
	["Radial Dig Shaft #15"] = {"a shattered eld monstrosity", "an icy azure fragmented eld", "a skittering azure eld"},
	["Trapped within a mirror"] = {"a fragment of living glass"},
	["the Dyisen-Ashtan Memoryscape"] = {"a phantasmal mystic",  "a spectral Balaton shark","a fragmented, spectral memory","an ethereal guardsman","a ghastly beggar","an incorporeal townsmen","an incorporeal townsman","a spectral merchant","an eidolic, Seam%-bound pilgrim","a disembodied soldier","a ghostly seagull", },
	["Eftehl Island"] =  {"a vibrantly pink flamingo", "a large sea turtle", "a steel%-grey barracuda", "a sleek hammerhead shark", "a lumbering ogre ghost", "a ghost of a castle guard","a ghost of a castle kitchen worker","a ghost of a castle servant"},
	["the Holy Impire of Sehal"] = {"a soulless pixie", "a stern Imp warrior", "a boisterous Imp boy", "a charming Imp girl", "a fluffy white sheep", "a fuzzy grey rabbit"},
	["the Valley of Lodi"] = {"a cave bat", "a sheep", "a white hen", "a juvenile wildcat", "an adult wildcat"},
	["the Village of Gorshire"] = {"a guard pig", "a portly gnome sentry", "a gnome man", "a gnome woman", "a little gnome boy", "a gnome sentry", "a little gnome girl", "a skinny gnome sentry", "a deputy constable", "a lithe weasel", "a large grey goose", "a large gray goose"},
	["the Tarean Caverns"] = {"a small%, black bat", "an unkempt Trog", "a chubby Trog woman", "a rambunctious young Trog", "a hulking Trog man", "a rotting rattlesnake", "an irritable, rabid zebra", "a blood%-spattered leopard", "a frothing%, manic buffalo", "a gigantic cave bear"},
	["the Crags"] = {"a light grey stone worm", "a dark grey stone worm", "an infant%-like cragling", "a steady cragling", "a vile snatcher", "a hulking snatcher"},
	["the village of Rahveir"] = {"a disgustingly warped missionary", "a malevolent poltergeist", "a corrupted spirit"},
	["Forsaken Evlasu"] = {"an unnaturally lithe%, shadowy aberration", "a hideous winged aberration", "a grotesque%, warped aberration", "a corrupted cultist"},
	["Yohanan Village"] = {"a fleshless skeleton", "a female villager", "a villager", "an old guard", "a small girl", "a young village guard", "a mangy rat", "a cave bat"},
	["Raim Vale"] = {"a cleansed villager", "a wild dog", "Midolo Raim"},
	--["Raim Vale"] = {"a mutilated creature","a disfigured woman","a rabid dog","a deformed man","a diseased man","Midolo Raim%, the failed experiment","a misshapen woman"},
	["the Centipede Cave"] = {"a large centipede", "a skittering centipede", "a chitinous centipede", "a venomous centipede", "a juvenile centipede", "a massive centipede queen"},
	--["Riparium"] = {"a large red crab", "a moray eel", "a mantaglow fish", "a large%, deepwater salmon", "an angler fish"},
	["Riparium"] = { "a giant octopus", "a spectral stag", "a large red crab", "a gelatinous polyp", "a merman guard", "a fearsome tiger shark", "a man-eating shark", "a moray eel", "a large, deepwater salmon", "a hauntingly beautiful siren", "a translucent ghost", "a powerful-looking swordfish", "Xahlen, the city guard", "a voluptuous mermaid", "a skinny merchild", "Fyanthis, merman warrior", "a muscular merman", "a jet%-black manta", "Gortani the Smith", "a striped sea krait", "Nissandar, King of Riparium", "Prince Nishir of Riparium", "Queen Takliea of Riparium" },
	["the Siroccian Mountains"] = {"a vicious wolverine", "a powerful wolverine"},
	["the Festering Wastes"] = {"a darkly patterned sand viper", "a gray%, spotted bobcat", "a ragged brown coyote", "a tiny black scorpion", "a deep green lizard", "a shivering jackrabbit", "a small yellow rattlesnake"},
	["Halls of Tornos"] = {"a speckled tinyok", "a snowy armadilleon", "a malformed beast", "a botched phase%-hound", "a rabid blood%-fiend", "a crazed blood%-fiend", "a mutated blood%-fiend"},
	--["Rebels' Ridge"] = {"a tenacious tough", "a rebellious rancher", "a former farmer", "a naive neo%-Ankyrean", "a seditious scholar", "a dingy dog", "a gamey goat", "a chittering chicken"},
	["Rebels' Ridge"] = { "a tenacious tough", "a chittering chicken", "a dingy dog", "a gamey goat", "a seditious scholar", "a naive neo%-Ankyrean", "a beaver", "a family of fifteen beavers", "Creinne the contemptible cabalist", "Semiastin the subversive syssin", "a rebellious rancher", "Tynn the top tough", "a former farmer", "Roise the recidivist rancher", "Frank the frustrated farmer" },
--	["Scidve"] = {"a large gray and black dugger", "a rock devil", "a Drakt guard"},
	["the Vilimo Fields"] = {"a field monitor", "a field harvester", "a decaying donkey", "a semi%-conscious elderly man", "a semi%-conscious elderly woman", "a semi%-conscious child"},
	["the Central Wilderness"] = {"a gnat", "a mottled green bullfrog", "a dragonfly"},
	["the Cathedral of Gloaming"] = {"a Dwarven priest", "a vengeful spirit"},
	--["Mount Humgurd"] = {"a black%-spotted cow"},
	["Mount Humgurd"] =   { "a troll villager", "a bright-eyed kestrel", "Jinjin", "Duerig", "a ruffled grouse", "a black-spotted cow", "a troll farmer", "a troll hunter", "Senwe", "Mulgroid", "a dwarf warrior", "a dwarf miner" },
	["the Western Itzatl Rainforest"] = {"an orange, black%-striped tiger","an iridescent tizapez","a menacing black rojalli","a colorful toucan","a crooked%-beaked jicocte","a beautiful quetzal bird","a swarm of tsetse flies","an enormous anaconda","a rojalli cub","a razor nahuac","an ecru axolotl","a xenosaurus lizard","a furry coatimundi","a playful oniro","an ocelot","a shadow bat","a white stone oyster","a firemouth cichlid","a lithe black panther","a poisonous purple lora","a frilled lizard","a cricket"},
	["the Village of Torston"] = { "an irritated crow", "a wary Xorani guard", "a stalwart Horkvali guard", "a plump white grub", "a tall Horkvali woman", "Estok, the guard captain", "a cloth training dummy", "a wooden training dummy", "a dusky-skinned Grook man", "the Torstonite chef, Melthur", "a dark-skinned Grook woman", "a carefree Grook boy", "a little Grook girl", "Adiria, the Grook soothsayer", "a mottled brown frog", "an enormous blue-green crocodile", "a moth", "a vicious snapping turtle", "a bask of fifteen crocodiles", "Axel, an enormous crocodile", "a venomous water snake", "a fierce crocodile", "a frail Xorani man", "a large brown grub" },
	--["the Village of Torston"] = {"an enormous blue%-green crocodile","a frail Xorani man","a dark%-skinned Grook woman","a dusky%-skinned Grook man","a tall Horkvali woman","the Torstonite chef","a stalwart Horkvali guard","a wary Xorani guard","a carefree Grook boy","a mottled brown frog","a little Grook girl",},
	["the Azdun dungeon"] = {"a huge pulsating spider", "medium pulsating spider", "a large pulsating spider"},
	--["the Temple of Sonn"] = {"a choke creeper","a giant mosquito","a giant fly","a giant moth","a glossy black silk%-spinner","Urrith%, a sea wyvern",},
	["the Temple of Sonn"] = { "an elongated black serpent", "a giant fly", "a shadowdrop", "a giant mosquito", "a giant moth", "a choke creeper", "Teicuih", "an unctuous creepling", "a darkling", "Tzocot", "Zurv", "a glossy black silk-spinner", "a large sea wyvern", "Zabeel, a huge silk-spinner" },
	["the Dolbodi Campsite"] = {"a brawny hunter", "a slender forager", "a burly lumberjack", "a grizzly foreman", "a lithe buckawn"},
	["Three Widows"] = {"a white%-coated chinchilla","a short%-horned chamois",},
	["Dun Fortress"] = {"an orc guard","a demonic screamer","an ogre bowman","a slime%-encrusted spitter","an orc soldier","a large catfish","a dangerous water snake","an ogre knight","a prisoner","an orc sergeant","an orc archer","an ogre sentry", "an orc cook","an orc captain","an ogre captain",},
	["the Arurer Haven"] = {"an aged priest","a young celestial angel","a striking supernal angel","a youthful priest","a budding priestess","a savvy priestess","a young celestial angel","Tisian%, a young priest","Father Garron%, the priest"},
	["a snake pit"] = {"a venenigol snake", "an andragil snake", "a tiny hatchling", "a large sertag snake", "a grassel snake","a muselon snake",},
	["the Ruins of Farsai"] = {"an unctuous creepling", "a shadowdrop", "a darkling"},
	["Asper"] = {"a fearsome icewyrm", "a malevolent spectre", "a failed experiment", "an animated golem of flesh", "a wild bobcat", "a snowshoe hare"},
	["the Khauskin Mines"] = { "a powerful Dwarven warrior", "a stocky Dwarven woman", "a stout Dwarven man", "a Dwarven boy", "a Dwarven girl", "Khuldar, the bartender", "a statuesque Dwarven guard", "Gordak, Leader of Khauskin", "Khabarak, the jeweler", "a soft-shelled klikkin", "a grotesque fangtooth", "Belina Warender", "Thelvoro Stonefist", "Belok, the mining chief", "a burly Dwarven miner" },
	--["the Khauskin Mines"] = {"a statuesque Dwarven guard", "a burly Dwarven miner", "a Dwarven girl", "a Dwarven boy", "a stocky Dwarven woman", "a stout Dwarven man", "a powerful Dwarven warrior", "a soft%-shelled klikkin", "a grotesque fangtooth"},
	["City of Djeir"] = {"a gargantuan spider"},
	["the Three Rock Outpost"] = {"a huge%, scarred wildcat","a beautiful wild horse","a mountain wildcat","a wildcat kitten", "a long%-haired buffalo", "an enormous Troll bandit","a shifty bandit", "the cave bear%, White Ghost"},
	["the village of Bihrkaen"] = { "a mire hound", "a bog hound", "a mire pup", "a grotesque snapping turtle", "a speckled, brown turtle", "an alpha male hound", "an alpha female hound", "a slender mud adder", "a bihrkaen huntress", "a glowing will-o-wisp", "a thin bihrkaen", "a bihrkaen ambusher", "a mutated carrion crow", "a horrifying bihrkaen", "a hulking bihrkaen protector", "Ilumn Mist", "Unlok Houndclaw", "a mossy hound", "a sickly carrion crow", "Sammuel of the Mire", "Hulin Mirefist", "a weary laborer" },
	--["the village of Bihrkaen"] = {"a grotesque snapping turtle", "a mire hound", "a bog hound", "a mire pup", "an alpha female hound", "a slender mud adder", "a speckled%, brown turtle", "an alpha male hound"},
	["the Augerweald"] = { "a large, snowy fox", "an agitated direwolf", "a large bhfaol", "a tortoiseshell cat", "a sleek black cat", "silver%-feathered orel", "a tall, white elk", "a gargantuan Augerweald rabbit", "a speckled tinyok", "a tabby tomcat", "a silvery pink salmon", "a colossal silver bear", "a brown bear", "a small kitten", "Tayanatra, a wizened woman", "Archi, Guardian of the Weald" },
	--["the Augerweald"] = {"an agitated direwolf", "a large bhfaol", "silver%-feathered orel", "a gargantuan Augerweald rabbit", "a tall%, white elk", "a large%, snowy fox"},
	["the Teshen Caldera"] = {"a Teshen raider", "a Teshen scout", "a Teshen reaver", "a Teshen worker"},
	["the Fractal Bloom"] = {"a towering crystalline entity", "a slender crystalline entity", "a radiant crystalline entity", "a squat crystalline entity", "a fractured crystalline entity", "a faceted crystalline entity"}, 
	["the Kalydian Forest"] = { "a ravenous squirrel", "a gaunt elk", "a magnificent elk", "an alert deer", "a fuzzy white and brown rabbit", "a fuzzy white and black rabbit", "a small black grub", "a monstrous gloch", "a crab", "an alluring dryad", "a fuzzy white rabbit", "a vicious nemling", "Tetzel, the scholar", "Nyseis, the dryad", "Scyllus, the scholar", "a fuzzy white and gray rabbit" },
	--["the Kalydian Forest"] = {"a gaunt elk",  "a rabid rabbit", "a ravenous squirrel"},
	["the Maghuir Fissure"] = {"an amorphous black umbra","a darkly robed priest"},
	["the Torturers' Caverns"] = { "a flesh golem sentry", "a vampiric overseer", "a maggot-ridden skeleton", "a rank ghoul", "Tellimerius, the Deep Dweller", "Sentinel Rozhirr", "a vile inquisitor", "Squire Annaria Loflin", "a blood construct", "a miniature fire elemental", 	"Kerr'ach, the Lich", "a hulking ghast", "a voracious blind-fish", "Tuera, the torturer", "a scheming terramancer", "Argaius, the Terramancer", "Mellias, an elegant Tsol'aa consanguine" },
	--["the Torturers' Caverns"] = {"Mellias%, an elegant Tsol'aa consanguine", "Tuera%, the torturer", "Sentinel Rozhirr", "a rank ghoul", "a vampiric overseer", "a maggot%-ridden skeleton", "a flesh golem sentry", "a vile inquisitor", "a hulking ghast", "a scheming terramancer"},
	["the Salma Settlement"] = {"a Salmati warrior","a Salmati guard","an unclean miner","a common man","an ordinary woman","an engrossed scholar","a busy mage","a hooded scholar","Dima%, Captain of the Salmati Guard","a robust blacksmith","an energetic child",},
	["the Caverns of Mor"] = {"a ravenous%, shadowy ghast", "a robed%, skeletal lich", "a stench%-ridden ghoul", "a skeletal warrior", "a vampiric warrior", "a vampiric sentry"},
	["the Sparklight Rift"] = { "a churning fire elemental", "an oversized efreeti", "a greater fire elemental", "a fire elemental minion", "a colossal elemental" },
	--["the Sparklight Rift"] = {"an oversized efreeti","a churning fire elemental","a fire elemental minion","a greater fire elemental","a colossal elemental"},
	["the Mamashi Tunnels"] = { "a Mit'olk bladesman", "a Mit'olk axeman", "a Mit'olk illusionist", "a bound Githani", "a Githani inscriber", "a Githani grappler", "a Githani master"},
	--["the Mamashi Tunnels"] = {"a greater nalas", "a young nalas", "a mature nalas","a Mit'olk bladesman", "a Mit'olk axeman", "a Mit'olk illusionist","a Githani master","a Githani grappler","a Githani inscriber",},
	["the Lich Gardens"] = {"a dissected child", "a commanding lich scientist", "a dark Cabalist scholar", "a monstrous Carnifex guard", "a mindless experiment", "a guardian wraith", "a tattered Bahkatu experiment", "a student of the lich"},
	["Raugol Fissure"] = { "a stonescale ravager", "a scything skitterer", "a stonescale mephit", "a splintering earthrager" },
	["the Isle of Ollin"] = {"a ferocious Alpha Syll","a giant%, rabid Syll", "a massive%, verdant%-furred Syll", "a young Syll cub", "a blackened%, ravenous shark", "a massive black crab", "a dark%-furred%, rabid boar", "a towering Nazetu guard", "a stinking Nazetu soldier", "a rotting Nazetu ghoul", "a Nazetu comfort woman", "a boisterous Nazetu child", "a sharp%-clawed Boru prowler", "a fiendish%, tainted Syll", "a diligent Boru harvester"},
	--["the Itzatl Morass"] = { "a capybara", "a poisonous water moccasin", "a vicious snapping turtle", "a silent reed cat", "a green slime toad", "a family of fifteen beavers", "a long%-toothed beaver" }
	["the Itzatl Morass"] = {"an oversized fly", "an oversized earthworm", "a capybara", "a poisonous water moccasin", "a green slime toad", "a silent reed cat", "a vicious snapping turtle", "a long%-toothed beaver"},
	["Saliltul Swamp"] = {"a rabid direwolf", "a mutilated humanoid", "a red%-eyed water snake"},
	["the Iernian Fracture"] = {"an unstable white eld", "a colossal crystalline eld", "a churning%, unstable eld", "an enormous%, three%-cored eld", "an effulgent platinum eld", "a discordant%, buzzing eld", "a cacophonous cluster of eld", "a shrieking mass of eld", "a flickering green eld", "a coruscating swarm of eld"},
	["Drakuum"] = {"a savage shade", "a blackened darkwalker", "a hideous lich",  "a misty apparition","a gnarled spirit"}, 
	--["the Ia'shal Barrow"] = { "a foul spiderling", "a ravenous cave spider", "a bulbous cave spider", "an egg%-laden spider", "an egg-laden spider",},
	["Arbothia"] = {"an enraged female servant", "an enraged male servant", "an enraged female villager", "an enraged male villager"},
	["the Eresh Mines"] = {"a slimy brown salamander", "an angry vampire bat", "a blind wolf spider", "a swarm of black beetles"},
	["the Fengard Keep"] = {"a massive argobole", "a fiery phenkyre", "an ogre berserker", "a horrid basilwyrm", "a shrieking grimshrill", "a vicious horned garwhol", "a brawny glaive knight", "a tall chempala", "a radiant lumore", "a pious invoker", "a pungent lichosphere", "an ethereal construct"},
	["the Ayhesa Cliffs"] = {"a Spellshaper Archon", "a Spellshaper Master", "a Spellshaper Adept"},
	["Yuzurai village"] = {"a massive rojalli matriarch", "a sleek black rojalli", "a savage rojalli"},
	["the Dramedo Warrens"] = {"a vast ochre ooze", "a winged fungal horror","a shambling fungal abomination", "a gigantic fungal strider","a cloud of fungal spores"}, 
	["the Isle of Despair"] = {"a darkened soul", "a severed male head"},
	["the Shattered Vortex"] = {"a petrified treant", "Sentinel Voiel", "a solemn luminary", "a chimera", "a pathfinder", "a sharp%-toothed gremlin", "a minion of chaos", "a chaos orb", "a bloodleech", "a bubonis", "a humbug", "a chaos hound", "a green slime", "an ethereal firelord", "a simpering Sycophant", "a soulmaster", "a dervish", "a withered crone", "a chaos storm", "a warped turtle", "a warrior of the Demonsbane", "a reinforcement warrior of the demonsbane", "a fetish%-decorated shaman", "a guardian angel", "a nimble sentinel", "a stalwart templar", "an agile Sentaari monk", "a battle%-worn Ascendril", "an Ascendril mage"},
	["Tiyen Esityi"] = {"a massive, sacred serpent", "a tangible malevolence", "Commander Marakhi", "Tirahl the Necromancer", "Lieutenant Gharvoi", "a ball of chitinous legs", "insubstantial whispers", "Quartermaster Kuius", "Lieutenant Chiakhi", "a crazed Nazetu cutter", "a mutated Nazetu intercessor", "a Nazetu cook", "a Nazetu halberdier", "a Nazetu provost", "a deformed Nazetu priest", "a Nazetu crossbowman", "a bound shade", "a Nazetu corrupter", "a Nazetu necromancer", "a supply officer", "a victimised intruder", "a Nazetu captain",},
	["the Nal'jin Depths"] = {"an enormous spinelash fish", "a sinewy Nal'jin eel", "a shadow ray", "a serpentine jawsnapper"},
	["the Forgotten Dome"] = {"a gibbering kelki reaver", "a deformed kelki ravener", "a mutated kelki ravager", "a vile kelki prowler"},
	["Luzith's Lair"] = {"a mass of deadly trap spiders", "a deadly trap spider", "a monstrous arachnid", "a vicious little spider", "a large%, crystalline spider","a large, crystalline spider", "a flying spider", "a sentinel spider", "a slender%, female arachnoid","a slender, female arachnoid",},
	["the Bastion of Illdon"] = {"a rabid plant", "a rabid hound", "a nightmare shadow", "a shadowy%, mindless demon","a shadowy, mindless demon", "a mutated experiment"},
	["Spiral of the Corrupt"] = {"an ethereal%, scarred jellyfish", "a rot%-infested swordfish", "a five%-tentacled octopus of jade", "a taint%-infested shark", "a miasma%-wreathed electric eel"},
	["the Shastaan Warrens"] = {"Migyar, the high cultist", "an aberrant, obscenely deformed Kelki","an aberrant%, obscenely deformed Kelki", "a wild%-eyed Kelki cultist", "a ragged Kelki cultist", "a wild-eyed Kelki cultist"},
	["the Bloodwood"] = {"a distressed spirit", "a wailing spirit", "a lingering spirit"},
	["Dovan Hollow"] = {"a haughty Caentoi slaver", "a hulking Ursal brute", "a grim Aslinn slaver", "a gaunt Aslinn slaver", "a scarred Aslinn slaver", "a sinewy Aslinn slaver",},
	["the Feral Caves"] = {"a small green blob", "a slimy green blob", "a massive green blob", "a gigantic green blob"},
	["The Forgotten Mausoleum"] = {"a reanimated Dwarf woman", "a rotting Dwarf archer", "a decomposing Dwarf", "a robed reanimated Dwarf"},
	["Tcanna Island"] = {"a brown and tan python", "a dark green alligator", "a blue crab", "a box jellyfish", "a large capybara", "a small ocelot", "a spotted leopard", "a howler monkey", "a striped tiger", "a water buffalo", "an enormous elephant", "a vicious copperhead snake", "an oversized tortoise", "a diseased raccoon", "a white%-tailed deer","a white-tailed deer", "a lithe cougar", "a black bear", "a black and white badger","a great white stag", "a spotted jaguar","a long billed toucan", "a scarlet macaw", "a bald eagle", "a gray wolf", "a ragged coyote", "a Troll guard", "a Troll cook","a white goose", "a Nazetu officer"},
	["Xaanhal"] = {"a bejeweled Xorani harem girl", "an arrogant Xorani master at arms", "a suspicious Xorani patrol", "a wiry Xorani guard", "a cautious Xorani guard", "a merciless Xorani warrior", "a willowy nest guardian"},
	["the Maul"] = {"a lithe Aslinn houndmaster", "a cruel Aslinn guard", "a menacing Aslinn gladiator", "a scarred Aslinn gladiator", "vakmut","a lithe Aslinn houndmaster","a wary Aslinn slaver","a gaunt Aslinn guard","an Aslinn slave catcher","a wretched Aslinn slaver", "a snarling vakmut warhound", },
	["the forgotten depths of Mount Helba"] = {"a towering fungal abomination", "a withered fungal abomination",},
	["the Bakal Chasm"] = {"an agitated basilisk", "a spiked basilisk", "a blinded basilisk", "a grey and brown basilisk", "an oversized, grey basilisk", "a juvenile basilisk", "an armored, brown basilisk"},
	["Clawhook Range"] = {"an Ursal swordsman", "a Golba brute", "a Tarpen bombardier", "a Caentoi rogue", "a prowling barbed abosvi", "a deadly abosvi", "an Utari warrior","a sabre%-toothed abosvi","a sabre-toothed abosvi", "an oversized, grey basilisk", "an armored, brown basilisk", "a grey and brown basilisk", "a spiked basilisk", "a spine%-necked arrex","a spine-necked arrex", },
	["the Welto Trench"] = {"a storm-wing harpy", "a menacing torvok", "a scarred tiger shark", "a scarred welto shark", "a scarred bull shark", "a scarred hunter shark", "a great white welto shark", "a great white tiger shark", "a black tiger shark", "a spotted bull shark", "a grey welto shark", "a scarred bull shark", "a bronze bull shark", "a striped tiger shark", "a scarred hunter shark", "a grey welto shark", "a striped welto shark", "a great white hunter shark", "a bronze welto shark", "a black hunter shark", "a black bull shark", "a brown hunter shark", "a bronze tiger shark", "a spotted welto shark", "a striped bull shark", "a brown tiger shark", "a black welto shark", "a black bull shark", "a grey hunter shark", "a brown bull shark", "a spotted hunter shark", "a great white bull shark", "a striped hunter shark", "a blacktip shark", "a stone crab", "a giant manta ray", "a box jellyfish", "a deep water serpent"},
	["a basilisk lair"] = {"a cave basilisk","a blindfolded Utari",},
	["Mount Helba"] = {},
	["the Welto Trench"] = {"a storm-wing harpy", "a menacing torvok", "a scarred tiger shark", "a scarred welto shark", "a scarred bull shark", "a scarred hunter shark", "a great white welto shark", "a great white tiger shark", "a black tiger shark", "a spotted bull shark", "a grey welto shark", "a scarred bull shark", "a bronze bull shark", "a striped tiger shark", "a scarred hunter shark", "a grey welto shark", "a striped welto shark", "a great white hunter shark", "a bronze welto shark", "a black hunter shark", "a black bull shark", "a brown hunter shark", "a bronze tiger shark", "a spotted welto shark", "a striped bull shark", "a brown tiger shark", "a black welto shark", "a black bull shark", "a grey hunter shark", "a brown bull shark", "a spotted hunter shark", "a great white bull shark", "a striped hunter shark", "a blacktip shark", "a stone crab", "a giant manta ray", "a box jellyfish", "a deep water serpent"},
	["Oblivion's Portent"] = {"a hungering voidwalker", "a writhing mass of voidspawn", "a singularly%-focused defiler", "an otherworldly%-shaped, gliding devourer", "a many%-legged, skittering aberration"},
	["the Squal"] = {"a sly Keeper tamer", "a camouflaged Keeper guerrilla", "a thuggish Keeper brute"},
	["Radial Dig Shaft #15"] = {"a shattered eld monstrosity", "an icy azure fragmented eld", "a skittering azure eld"},
	["the Royal Vaults of Glandor"] = {"a Royal Glandorian guard", "a Royal Glandorian Captain", "a Royal Glandorian magician", "a fearsome hydra head eying your legs", "a fearsome hydra head chomping at the air", "a fearsome hydra head waiting to strike", "a fearsome hydra head emitting gaseous fumes", "a fearsome hydra head ready to smash into you", "a fearsome hydra head baring its teeth", "a fearsome hydra head eying your arms", "a monstrous hydra body", "Ilelathash"},
	["the Primal Eye of Czjetija"] = {"a massive tenebrous horror", "a many%-winged shadowghast", "a spider%-like shadowspinner", "a sinuous umbral creeper", "a tendriled shadowwisp", "a monstrous shadow beast"},
	["within a deep mine"] = { "a thin, half%-crazed mage","a writhing horsehair worm","a bulbous, black spider","a ylem%-sick mole","a massive volcanic tortoise","a razor%-finned eel","a bulbous direant bomber", "a massive ice worm", "a chirping beetle","a pale, eyeless amphibian", "a skeletal Hlugna warrior", "a sleek direant scout", "a chitinous direant soldier", "an agile direant worker", "a grimy bandit", "a bandit leader", "a dark%-haired mole", "a stalagmite rat", "a massive, tunneling cave worm", "a many%-eyed marionette slime", "a behemoth pit beast", "a floating cave manta", "a spotted cave salamander", "a fuzzy brown bat", "a rime%-covered bear", "a long%-jawed cave spider"},
	["the Underbelly"] = {
        "a pale skrell whelp",
        "a desiccated Utari zombie",
        "a massive grey rat",
        "a dire, plagued rat",
        "an erratic Tarpen cultist",
        "a mangy Caentoi cultist",
        "an Utari cultist with grim facial markings",
        "a glazed%-eye zombie Aslinn",
        "a ravenous skrell",
        "a venomous skrell whelp",
        "a feral vakmut",
        "a malnourished vakmut",
        "a snarling vakmut hound",
        "a grey%-skinned skrell whelp",
        "a drooling zombie Tarpen",
        "a massive, tan%-shelled whelk",
        "a gigantic black rat",
        "a jagged Golban ghast",
        "a gigantic white rat",
        "a hunched, bone%-fisted Golban zombie",
        "a hulking Ursal ghast",
        "a slavering vakmut",
        "a crawling, ravenous Aslinn ghast",
    },
 	["a volcanic island"] = {
		"a many-legged cinder crawler", 
		"a sinuous elemental of acerbic smoke", 
		"a capricious astral feline", 
		"an enraged hyriamah", 
		"a firebound terror", 
		"a cumbrous magma beast", 
		"a fierce, lithely limbed firedancer",
	},

	["a deep underground cavern"] = {
		"a Chaos-warped Chiav guard",
		"a Chaos-warped gargantuan carrier centipede",
		"a demonic Chaos-warped spider",
		"a Chaos-warped egg-laying spider" ,
	},

	["the Bonro Sands"] = {
		"a red-brown burrowing owl", 
		"a horned viper", 
		"A scarlet kestrel", 
		"a black-tailed viper", 
		"a Bonro spitting cobra", 
		"a banded lark", 
		"an immense desert condor", 
		"a crowned gouse", 
		"a sun-spotted harrier", 
		"an ostrich with wispy two-tone feathers",
	},

	["a bandit encampment in the Bonro Sands"] = {
		"a sly Caentoi vagabond",
		"a wiry Caentoi bandit",
		"a grizzled Caentoi highwayman",
		"a grinning Caentoi cutthroat",
		"a Caentoi bushwhacker",
		"a Caentoi blackguard",
		"a burly Caentoi raider",
		"a Caentoi marauder",
	},

	["Beggar's Barrow"] = {
		"a bedraggled Caentoi outcast",
		"a scrawny Aslinn mercenary",
		"a lithe Caentoi cutthroat",
		"a wiry Aslinn cutthroat",
		"an indolent Golban mercenary",
		"a one-legged Aslinn beggar",
		"a morose Golban outcast",
		"a one-legged Aslinn beggar",
		"a mangy Caentoi beggar",
	},

	["the Vault of Domor"] = {
		"an imposing high cultist",
		"an emaciated cultist",
		"a darkly clad cultist",
		"a flayed cultist",
		"a spiked corpse worm",
		"a revolting skeleton",
		"a large-headed grave worm",
	},


	["offspring"] = { "a pudgy water badger", "a flat-snouted scaled sheep", "a chromatic aquatic dragonfly", "a muscular freshwater hound", "a long-tailed bullfrog", "an amphibious, ebon-winged hawk", "a predatory river canine"},
	["a dimly lit subterranean river"] = { "a shimmering piscine elemental", "a tempestuous wave elemental", "an iridescent bubble of elemental energies" , "a long-finned, cerulean amphibian", "a spiny many-armed water elemental", "a billowing cloud of shifting luminescence"},
    ["the Mannaseh Swamp"] = { "a savage mutant pumpkin", "an ichorous miscreation", "an amphibious malformation", "a skittering miscreation", "a hulking miscreation", "a malformed stalker", "a miscreated avian"},
	["the Maestral Shoals"] = {"a tattered skrell", "a leathery skrell", "an emaciated skrell",  "sinewy skrell lurker", "a drooling skrell", "a small sovereign crab", "a large, ill%-tempered crab", "a glossy red crab", "a mottled crab"},
	["Maestral's Barrier Reef"] = {"a skrell hatchling", "a savage, scarred skrell", "a pot%-bellied seahorse", "a school of neon tetra fish", "a school of long fin reef minnows", "an Albedian codfish", "a hulking skrell matriarch", "a sharp%-toothed skrell", "a bottom%-feeding flatfish", "a puffer fish", "a bony Delvian boxfish"},
	["Mejev Nider Nesve wo Ti, Matati wo Eja sota Aran wo Aransa"] = {"a swift vukon", "a four%-winged ayvarin", "a predatory kashnalda", "a riled%-up protester", "the protest organizer",},
	["a deep underground cavern"] = {"a demonic Chaos%-warped spider", "a Chaos%-warped egg%-laying spider", "a Chaos%-warped gargantuan carrier centipede", "a Chaos%-warped Chiav guard"},
	["Alaqsii Inlet"] = { "an arctic wolf", "a rotund, white ptarmigan", "a hunter clad in furs", "a small, ruddy turnstone", "a white gyrfalcon", "an apex wolf", "a white-collared lemming", "a dull brown lamprey" },
	["Tainhelm"] = {"a stout Dwarven guard", "a female Dwarf", "an elderly female Dwarf", "an elderly Dwarven man", "a tanned Dwarven farmer", "a Dwarven boy", "Baruin, the Dwarven mason", "Gwenil, the Dwarven blacksmith", "Nolid, the Dwarven fisherman", "Tohrul, the Dwarven supervisor", "a calm Dwarven woman", "a Dwarven girl", "an elderly dwarf", "a male Dwarf", "an elderly Dwarven gardener", "a speckled fawn", "a Dwarven craftsman", "the Dwarven alemaster", "Rognik, a young Dwarven librarian", "a Dwarven miner", "an ugly-looking togue fish", "a golden sunfish", "a rainbow trout", "the Dwarven miller", "Mayor Thurgil Redstein", "a liveried Dwarf servant" },
	["the Caverns of Telfinne"] = { "a slimy aryeim", "a fanged lugore", "a tentacled morbol", "a cave-dwelling avisme", "a draconic zogura", "a slender synicant" },
	["the lost city of Iviofiyiedu"] = { "a ghost of a Mhun soldier", "General Abeshentesh", "Ethashe, a mhun soldier", "a ghost of a male Mhun", "a ghost of a Mhun guard", "a ghost of a young Mhun", "a ghost of a female Mhun", "the ghost of Thaya, a mhun instructor", "Chedori, Priestess of Iviofiyiedu", "Dashentesh, a mhun scribe", "Cook Ghedha", "Fathientesh, a mhun crafter", "Blacksmith Udhomentesh", "Dhemosh, a mhun miner", "Odhem, a young miner" },
    ["the Tarean Ice Caverns"] = { "an icy elemental guard", "a skilled Indyuk warrior", "a reanimated ice wolf", "an ornery frost gremlin", "a gigantic mother icewyrm", "a ravenous ice fly", "a baby icewyrm" },
	["the Hlugnic Labyrinth"] = { "a rune-covered lodestone golem", "an enormous spinelash fish", "an ancient multi-headed woderhund", "a Hlugnic runeguard", "a warden of the Hlugnic clans", "Bardin 'Gruff-Eyes' Barinfind", "Deorkaan, the Hlugna smithy", "a boisterous Hlugna man", "a burly, stone-fisted laborer", "Foreman Grummosh" },
	["the Siroccian Tunnels"] = { "a lurking shadow", "a massive striped worm", "a spatial anomaly", "a crystal-encrusted golem", "a lava fiend", "a disembodied soul", "a voracious blind-fish" },
	["Court of the Consortium"] = { "a disembodied soul", "a spatial anomaly", "a shambling skeleton", "a crystal-encrusted golem", "a lava fiend" },
	["Mount Heylai"] = { "a dwarf geared up for battle", "an armored dwarf", "Thoraim", "Yimar, the Heylai Weaver", "Raad", "Ira", "Valgar", "Bernar", "a dwarven warrior", "Elder Elerl of Heylai", "a dwarven miner", "a female dwarven villager", "a dwarven girl", "a dwarven boy" },
	["Morgun Forest"] = { "a maple sapling", "a sinuous willow tree", "an oak sapling", "a young beech tree", "an Elder pine tree", "a prickly raspberry bush", "a young maple tree", "a great horned owl", "a mosquito", "an Elder maple", "a handsome nayar", "a silvery beech", "a poisonous hemlock bush", "a willow sapling", "a strong pine", "a honey bee", "a sturdy oak", "an enchanting meayan", "a young pine tree", "a blazing maple", "a large brown grub", "a young willow tree", "a fluffy jambaali", "a dwarf boa", "a pine sapling", "a young brown grub", "a tiny white grub", "a slimy gruktuk", "a beech sapling", "the Broad oakling", "a wild boar", "a mischievous elefitka", "a young oak", "a rattlesnake", "Namal, a fading nayar", "an insignificant lime caterpillar", "an Elder beech tree", "a sounder of ten boars", "an Elder willow" },
}