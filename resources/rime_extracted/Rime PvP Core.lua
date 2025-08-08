rime.pvp.ai = false
rime.pvp.runemark_major = "nothing"
rime.pvp.runemark_minor = "nothing"
rime.pvp.bracer_proc = 0
rime.pvp.stonespike = "nothing"
rime.pvp.target_tumbling = false
rime.pvp.soul_master = false
rime.pvp.puppeteer = false
rime.pvp.ignore_rebounding = false
gutcheckHit = false
rime.pvp.ally = rime.pvp.ally or rime.saved.allies[1]
rime.pvp.whirlwind_order_set = false
rime.pvp.beyblade_order = {}
rime.pvp.beyblades = {}
rime.pvp.targetThere = rime.pvp.targetThere or true
rime.pvp.last_attack = "nothing"
rime.pvp.personal = rime.pvp.personal or {}
rime.need_enemy = false
rime.pvp.cooldowns = {
	["crystal"] = false,
}

rime.pvp.personal = {
	["timers"] = {
		["choke"] = 0,
		["crone"] = 0,
		["sycophant"] = 0,
		["absorb"] = 0,
	},
}

rime.pvp.room = {
	["deliverance"] = false,
    ["darkness"] = false,
    ["indoors"] = true,
    ["north_blocked"] = false,
    ["north_icewalled"] = false,
    ["north_firewalled"] = false,
    ["south_blocked"] = false,
    ["south_icewalled"] = false,
    ["south_firewalled"] = false,
    ["east_blocked"] = false,
    ["east_icewalled"] = false,
    ["east_firewalled"] = false,
    ["west_blocked"] = false,
    ["west_icewalled"] = false,
    ["west_firewalled"] = false,
    ["southeast_blocked"] = false,
    ["southeast_icewalled"] = false,
    ["southeast_firewalled"] = false,
    ["southwest_blocked"] = false,
    ["southwest_icewalled"] = false,
    ["southwest_firewalled"] = false,
    ["northwest_blocked"] = false,
    ["northwest_icewalled"] = false,
    ["northwest_firewalled"] = false,
    ["northeast_blocked"] = false,
    ["northeast_icewalled"] = false,
    ["northeast_firewalled"] = false,
    ["in_blocked"] = false,
    ["in_icewalled"] = false,
    ["in_firewalled"] = false,
    ["out_blocked"] = false,
    ["out_icewalled"] = false,
    ["out_firewalled"] = false,
    ["down_blocked"] = false,
    ["down_icewalled"] = false,
    ["down_firewalled"] = false,
    ["up_blocked"] = false,
    ["up_icewalled"] = false,
    ["up_firewalled"] = false,
    ["boundary"] = false,
    ["phenomena"] = "none",
    ["flooded"] = false,

}

function rime.pvp.target_select()

	local target = rime.target

	if not rime.targets[target].defences.defended then

		return target

	elseif rime.targets[target].defences.defended then

		for k,v in ipairs(swarm.room) do
			if rime.targets[v].defending == target then
				return v
			end
		end
	end

end

function rime.pvp.pick_ally(effect)

	local second_effect = false

	if effect == "defend" then
		second_effect = "defending"
	end


	if table.is_empty(swarm.room) then
		return rime.echo("swarm.room is a necessary table for this function to fire and is empty.", "debug")
	end

	local ally_aggro = "Bulrok"

	for k,v in ipairs(swarm.room) do
		if rime.targets[v].aggro > rime.targets[ally_aggro].aggro and table.contains(rime.saved.allies, v) then
			ally_aggro = v
		end
	end

	if effect == "aggro" then
		return ally_aggro
	end
		
	for k,v in ipairs(swarm.room) do
		if rime.targets[v].defences[effect] == nil and rime.targets[v][effect] == nil then
			return rime.echo(effect.." is not tracked as a defence or as a standalone field. Please send a copy of this echo to the Rime discord", "debug")
		end
	end

	for k,v in ipairs(swarm.room) do
		if rime.targets[v].defences[effect] ~= nil and not rime.targets[v].defences[effect] and table.contains(rime.saved.allies, v) and ally_aggro == v then
			return v
		elseif rime.targets[v][effect] ~= nil and not rime.targets[v][effect] and table.contains(rime.saved.allies, v) and ally_aggro == v then
			return v
		else
			return rime.echo("No allies met the requirements!")
		end
	end

end

function rime.pvp.get_gate()

	local my_balance = rime.getTimeLeft("my_balance")
	local my_eq = rime.getTimeLeft("my_eq")

	if my_balance > my_eq then
		return my_balance
	else
		return my_eq
	end

end

function rime.pvp.count_affs(affType, target)

	if not target then target = rime.target end

    if not affType then affType = "" end
    local enemyAffCount = 0

    affType = affType:lower()
    if affType == "mental" then
        return table.size(table.intersection(rime.targets[target].afflictions, rime.pvp.mental_aff_list))
    elseif affType == "physical" then
        return table.size(table.intersection(rime.targets[target].afflictions, rime.pvp.physical_aff_list))
    elseif rime.targets[target] then
        for k,v in pairs(rime.targets[target].afflictions) do
            if v then enemyAffCount = enemyAffCount+1 end
        end
        return enemyAffCount
    end

end

function rime.pvp.aggro(target, reset)

    if not target then rime.echo("um lol we fucked up somewhere?") return end

    if target == "you" or target == "You" or target == "himself" then return end

    target = string.title(target)

    if not reset then
        if not rime.targets[target] then
            add_target(target)
        end
        rime.last_hit = target
        rime.targets[target].aggro = rime.targets[target].aggro+1
        rime.echo(target.." aggro: <red>"..rime.targets[target].aggro, "pvp")
        if rime.targets[target].time.aggroReset then
            killTimer(rime.targets[target].time.aggroReset)
        end
        rime.targets[target].time.aggroReset = tempTimer(4, [[rime.pvp.aggro("]]..target..[[", true)]])
    else
        if not rime.targets[target] then
            add_target(target)
        end
        if rime.targets[target] ~= nil then
            rime.targets[target].aggro = 0
            rime.echo(target.."'s aggro reset.", "pvp")
        end

    end

end

function rime.pvp.aggro_count_down(target, amount)

    if target then
        rime.targets[target].aggro = rime.targets[target].aggro-amount
        return
    end


    for k,v in ipairs(rime.saved.allies) do
        if rime.targets[v] == nil then add_target(v) end
        if rime.targets[v].aggro > 0 then
            rime.targets[v].aggro = rime.targets[v].aggro-1
        end

    end

end

function rime.pvp.clear_target(tar)

	gutcheckHit = false
	rime.pvp.target_tumbling = false
	rev.bongoBonanza = false
	targetImpaled = false
	rev.wilaveee = false
	earthcaller.infiltrate = "none"

	if not tar then

		for k,v in pairs(rime.targets) do
			for x in pairs(rime.targets[k].afflictions) do
				rime.targets[k].afflictions[x] = false
			end
			rime.targets[k].defending = false
			rime.targets[k].parry = "head"
			rime.targets[k].baiting = "none"
			rime.targets[k].cooldowns = {
					focus = false,
					tree = false,
				}
			rime.targets[k].time = {
				}
			rime.targets[k].limbs = {
					head = 0,
					torso = 0,
					left_arm = 0,
					right_arm = 0,
					left_leg = 0,
					right_leg = 0,
				}
			rime.targets[k].stacks = {
					gravity = 0,
					rot = 0,
					ablaze = 0,
					gloom = 0,
					stonevice = 0,
				}
            rime.targets[k].mori = {
                health = false,
                mana = false,
            }
			rime.targets[k].suggestions = {}
			rime.targets[k].sealed = false
			rime.targets[k].soul = 100
			rime.targets[k].bloodburstCount = 0
	      	rime.targets[k].mana = 100
	      	rime.targets[k].adder = false
	      	rime.targets[k].chilled_count = 0
	      	rime.targets[k].death_rub = 0
	      	rime.targets[k].armored = true
	      	rime.targets[k].aggro = 0
	     	rime.targets[k].deliverance = false
	     	rime.targets[k].prerestoredLimb = "none"
			rime.targets[k].defences = {
					blind = true,
					deaf = true,
					firefly = true,
					fangbarrier = true,
					cloak = true,
					speed = true,
					rebounding = true,
					shielded = false,
					defended = false,
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
					nimbleness = false,
					dome = false,
					flight = false,
				}
			rime.targets[k].globes = 0
			rime.targets[k].bladestorm = 0
			rime.targets[k].needle = false
			rime.targets[k].ironcollar = false
			rime.targets[k].emotions = {
				induced = "none",
				sadness = 0,
				happiness = 0,
				surprise = 0,
				anger = 0,
				stress = 0,
				fear = 0,
				disgust = 0,
			}
			rime.targets[k].geoHex = false
			rime.targets[k].geoCrescent = false
			rime.targets[k].currents = 0
			rime.targets[k].causality = false
			rime.targets[k].intoxicant = false
			rime.targets[k].channel = false
			rime.targets[k].deliverance = false
			rime.targets[k].disabled = false
			rime.targets[k].effigy = false
			rime.targets[k].leeching = false
			rime.targets[k].perforated = "none"
            rime.targets[k].gorged = "none"
            rime.targets[k].corroded_limb = "none"
            rime.targets[k].coldburn = false
            rime.targets[k].hotburn = false
            rime.targets[k].coldburn_cycle = 0

		end

		rime.echo("AFFLICTIONS FOR EVERYONE RESET!")
		GUI.target_aff()

	else
		for x in pairs(rime.targets[tar].afflictions) do
			rime.targets[tar].afflictions[x] = false
		end
			rime.targets[tar].defending = false
			rime.targets[tar].parry = "head"
			rime.targets[tar].baiting = "none"
			rime.targets[tar].cooldowns = {
				focus = false,
			}
			rime.targets[tar].time = {
			}
			rime.targets[tar].limbs = {
				head = 0,
				torso = 0,
				left_arm = 0,
				right_arm = 0,
				left_leg = 0,
				right_leg = 0,
			}
			rime.targets[tar].stacks = {
				gravity = 0,
				rot = 0,
				ablaze = 0,
				gloom = 0,
				stonevice = 0,
			}
			rime.targets[tar].mori = {
                health = false,
                mana = false,
            }
			rime.targets[tar].suggestions = {}
			rime.targets[tar].sealed = false
			rime.targets[tar].soul = 100
			rime.targets[tar].bloodburstCount = 0
      		rime.targets[tar].mana = 100
      		rime.targets[tar].aggro = 0
      		rime.targets[tar].adder = false
      		rime.targets[tar].chilled_count = 0
      		rime.targets[tar].death_rub = 0
      		rime.targets[tar].armored = true
      		rime.targets[tar].prerestoredLimb = "none"
			rime.targets[tar].defences = {
				blind = true,
				deaf = true,
				firefly = true,
				fangbarrier = true,
				cloak = true,
				speed = true,
				rebounding = true,
				shielded = false,
				defended = false,
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
				leeching = false,
				dome = false,
				flight = false,
			}
			rime.targets[tar].globes = 0
			rime.targets[tar].bladestorm = 0
			rime.targets[tar].needle = false
			rime.targets[tar].ironcollar = false
			rime.targets[tar].emotions = {
				induced = "none",
				sadness = 0,
				happiness = 0,
				surprise = 0,
				anger = 0,
				stress = 0,
				fear = 0,
				disgust = 0,
			}
			rime.targets[tar].geoHex = false
			rime.targets[tar].geoCrescent = false
			rime.targets[tar].currents = 0
			rime.targets[tar].causality = false
			rime.targets[tar].intoxicant = false
			rime.targets[tar].channel = false
			rime.targets[tar].deliverance = false
			rime.targets[tar].disabled = false
			rime.targets[tar].effigy = false
			rime.targets[tar].leeching = false
            rime.targets[tar].perforated = "none"
            rime.targets[tar].gorged = "none"
            rime.targets[tar].corroded_limb = "none"
            rime.targets[tar].coldburn = false
            rime.targets[tar].hotburn = false
            rime.targets[tar].coldburn_cycle = 0

	rime.echo("Afflictions for "..tar.." reset!")
	GUI.target_aff()

	end

end

function rime.pvp.add_aff(affliction, target)

	if target == "you" or target == "You" then
		return
	end
	if affliction == "fake_aff" then return end
	if affliction == "sumac" then return end
	if affliction == "loki" then return end
	if affliction == "pacifism" then return end
	if affliction == "paresis" and rime.targets[target].afflictions["paralysis"] then return end

	local target = string.title(target)
	if not rime.targets[target] then return end
	local enemyAffTable = {}
	for k,v in pairs(rime.targets[target].afflictions) do
    	if v then
			table.insert(enemyAffTable, k)
    	end
	end

	if not rime.targets[target] then
		add_target(target)
	end

    if affliction == "crushed_elbows" then
        limitStart("crushed_elbows_"..target, 9)
    elseif affliction == "crushed_kneecaps" then
        limitStart("crushed_kneecaps"..target, 15)
    elseif affliction == "muddled" then
      if not rime.limit["muddled_"..target] then
        limitStart("muddled_"..target, 7.6)
      end
    end

	if affliction == "nothing" then
		return
	end
	
	local aff = false
	
		if rime.convert_venom(affliction) then
			aff = rime.convert_venom(affliction)
			if aff == "left_arm_crippled" then if rime.pvp.has_aff("left_arm_crippled", target) then aff = "right_arm_crippled" end
			elseif aff == "left_leg_crippled" then if rime.pvp.has_aff("left_leg_crippled", target) then aff = "right_leg_crippled" end
			elseif aff == "right_arm_crippled" then if rime.pvp.has_aff("right_arm_crippled", target) then aff = "left_arm_crippled" end
			elseif aff == "right_leg_crippled" then if rime.pvp.has_aff("right_leg_crippled", target) then aff = "left_leg_crippled" end
			elseif aff == "no_deaf" then if rime.pvp.has_aff("no_deaf", target) then aff = "sensitivity" end
			elseif aff == "no_blind" then if rime.pvp.has_aff("no_blind", target) then aff = "blurry_vision" end
			end
		else aff = affliction end

	if not aff then rime.echo("you walnut") return end


	if aff == "caloric" then
		if rime.pvp.has_def("insulation", target) then
			rime.targets[target].defences.insulation = false
			rime.echo("<"..rime.saved.echo_colors.target.title..">"..target.."<white> lost <"..rime.saved.echo_colors.tga.title..">insulation", "pvp")
		elseif not rime.pvp.has_aff("shivering", target) then
			rime.targets[target].afflictions.shivering = true
			rime.echo("<"..rime.saved.echo_colors.target.title..">"..target.." <white>gained <"..rime.saved.echo_colors.tga.title..">shivering", "pvp")
		elseif not rime.pvp.has_aff("frozen", target) then
			rime.targets[target].afflictions.frozen = true
			rime.echo("<"..rime.saved.echo_colors.target.title..">"..target.." <white>gained <"..rime.saved.echo_colors.tga.title..">frozen", "pvp")
		end

	elseif aff == "Circle" then

		local circle_affs = {"merciful", "masochism", "berserking", "recklessness"}

		for k,v in ipairs(circle_affs) do
			if not rime.pvp.has_aff(v, target) then
				rime.targets[target].afflictions[v] = true
				rime.echo("<"..rime.saved.echo_colors.target.title..">"..target.." <white>gained <"..rime.saved.echo_colors.tga.title..">"..v, "pvp")
				break
			end
		end

	elseif aff == "Triangle" then

		local triangle_affs = {"laxity", "lovers_effect", "peace", "magnanimity"}

		for k,v in ipairs(triangle_affs) do
			if not rime.pvp.has_aff(v, target) then
				rime.targets[target].afflictions[v] = true
				rime.echo("<"..rime.saved.echo_colors.target.title..">"..target.." <white>gained <"..rime.saved.echo_colors.tga.title..">"..v, "pvp")
				break
			end
		end

	elseif aff == "Square" then

		local square_affs = {"dizziness", "faintness", "epilepsy", "shyness"}

		for k,v in ipairs(square_affs) do
			if not rime.pvp.has_aff(v, target) then
				rime.targets[target].afflictions[v] = true
				rime.echo("<"..rime.saved.echo_colors.target.title..">"..target.." <white>gained <"..rime.saved.echo_colors.tga.title..">"..v, "pvp")
				break
			end
		end

	elseif aff == "rot" then

		local rot_affs = {"rot_benign", "rot_spirit", "rot_heat", "rot_wither", "rot_body"}

		for k,v in ipairs(rot_affs) do
			if not rime.pvp.has_aff(v, target) then
				rime.targets[target].afflictions[v] = true
				rime.echo("<"..rime.saved.echo_colors.target.title..">"..target.." <white>gained <"..rime.saved.echo_colors.tga.title..">"..v, "pvp")
				GUI.target_aff()
				break
			end
		end

	elseif aff == "asleep" then
		if rime.pvp.has_def("insomnia", target) then
			rime.targets[target].defences.insomnia = false
			rime.echo("<"..rime.saved.echo_colors.target.title..">"..target.." lost insomnia", "pvp")
		elseif not rime.pvp.has_aff("asleep", target) then
			rime.targets[target].afflictions.asleep = true
			rime.echo("<"..rime.saved.echo_colors.target.title..">"..target.." <white>went to <"..rime.saved.echo_colors.tga.title..">sleep", "pvp")
		elseif rime.pvp.has_def("instawake", target) then
			rime.targets[target].defences.instawake = false
			rime.echo("<"..rime.saved.echo_colors.target.title..">"..target.." lost instawake", "pvp")
		end

	elseif aff == "wasi" or aff == "blaze" then
		if rime.pvp.has_def("rebounding", target) then
			rime.targets[target].defences.rebounding = false
			rime.echo("<"..rime.saved.echo_colors.target.title..">"..target.." lost rebounding", "pvp")
		end

	elseif aff == "wilave" then 
		rime.echo("<"..rime.saved.echo_colors.target.title..">"..target.." is getting wilaved to death!", "pvp")

	elseif not rime.pvp.has_aff(aff, target) then
		if target == rime.target then
			rime.echo("<"..rime.saved.echo_colors.target.title..">"..target.." <white>gained <"..rime.saved.echo_colors.tga.title..">"..aff..":<brightblue> "..table.concat(enemyAffTable, ", "), "pvp")
			rime.targets[target].afflictions[aff] = true
			GUI.target_aff()
		else
			rime.targets[target].afflictions[aff] = true
		end
	end

	rime.pvp.last_affliction = aff

	if rime.pvp.has_aff("dead", target) and target == rime.target then
		local who = target:title()
		if who ~= rime.target then return end
		local count = 1
		if table.contains(swarm.targeting.list, who) then
  			local pos = table.index_of(swarm.targeting.list, who) or nil
  			for k, v in ipairs(swarm.targeting.list) do
    		if
      			table.contains(swarm.room, who) and
      			table.contains(swarm.room, v) and
      			k > table.index_of(swarm.targeting.list, who)
    		then
      			expandAlias("t " .. v)
      			--! NOTE: This must match your system's targeting alias
				break
				end
			end
		else
  			table.remove(swarm.room, table.index_of(swarm.room, who))
  			expandAlias("nt")
		end
	end

--	if rime.pvp.ai then rime.pvp.offense() end

end

function rime.pvp.add_stack(stack, target, amount)

	local target = string.title(target)

	local stack_limits = {
		rot = 5,
		gravity = 5,
		gloom = 6,
		stonevice = 3,
		ablaze = 100,
		}
	local amount = tonumber(amount) or 1
	local gloom_affs = {"nyctophobia", "loneliness", "vertigo", "claustrophobia", "agoraphobia", "commitment_fear"}

	if rime.targets[target].stacks[stack] < stack_limits[stack] then
		rime.targets[target].stacks[stack] = rime.targets[target].stacks[stack]+amount
		if target == rime.target then
			rime.echo(rime.target.." gained "..amount.." "..stack.."! Total: "..rime.targets[target].stacks[stack])
		end
		rime.pvp.stack_track = { ["target"] = target, ["stack"] = stack, ["amount"] = amount }
		if stack == "gloom" then rime.pvp.add_aff("gloom_aff", target) end
	else
		rime.echo("Something not working or you're over the stack threshold?")
	end

 GUI.target_aff()

end

function rime.pvp.remove_aff(aff, target)

	if rime.targets[target] == nil then return false end
	if rime.targets[target].afflictions[aff] == nil then return false end
	if target == "you" or target == "You" then return false end

	target = string.title(target)
	local enemyAffTable = {}

	if aff == "rot" then

		local rot_affs = {"rot_body", "rot_wither", "rot_heat", "rot_spirit", "rot_benign"}

		for k,v in ipairs(rot_affs) do
			if rime.pvp.has_aff(v, target) then
				rime.targets[target].afflictions[v] = false
				rime.echo("<"..rime.saved.echo_colors.target.title..">"..target.."<white> cured <"..rime.saved.echo_colors.tca.title..">"..v, "pvp")
				break
			end
		end

		if gmcp.Char.Vitals.singularity ~= "supermassive" or rime.has_aff("peace") then
			for k,v in ipairs(rot_affs) do
				if rime.pvp.has_aff(v, target) then
					rime.targets[target].afflictions[v] = false
					rime.echo("<"..rime.saved.echo_colors.target.title..">"..target.."<white> cured <"..rime.saved.echo_colors.tca.title..">"..v, "pvp")
					break
				end
			end
		end

	elseif rime.targets[target].afflictions[aff] then
		rime.targets[target].afflictions[aff] = false
		if target == rime.target then
			for k,v in pairs(rime.targets[target].afflictions) do
    			if v then
					table.insert(enemyAffTable, k)
    			end
			end
			rime.echo("<"..rime.saved.echo_colors.target.title..">"..target.."<white> cured <"..rime.saved.echo_colors.tca.title..">"..aff..":<orchid> "..table.concat(enemyAffTable, ", "), "pvp")
		else
			rime.echo("<"..rime.saved.echo_colors.target.title..">"..target.."<white> cured <"..rime.saved.echo_colors.tca.title..">"..aff, "pvp")
		end
		local not_pillar_affs = {"effused_blood", "no_deaf", "no_blind"}
		local aff_check = false
		for k,v in ipairs(not_pillar_affs) do
			if aff == v then
				aff_check = true
			end
		end

		if not aff_check then
			rime.targets[target].last_cured = aff
		end 
		rime.targets[target].last_cured = aff
	end
	if aff == "paralysis" then
		rime.targets[target].afflictions.paresis = false
	end
	if aff == "shivering" then 
		rime.targets[target].afflictions.frozen = false
	end
	if aff == "stonevice" then
		rime.targets[target].stacks.stonevice = 0
	end
	if aff == "ablaze" then
		rime.targets[target].stacks.ablaze = 0
	end
    if aff == "frozen" then
        rime.targets[target].afflictions.ice_encased = false
    end

--	if rime.pvp.ai then rime.pvp.offense() end

	if target == rime.target then GUI.target_aff() end

end

function rime.pvp.remove_stack(stack, target, amount)
    local stack_amount = amount or 1

	if stack == "rot" then
		if rime.pvp.has_aff("shadowsphere", target) then return end
		if not rime.pvp.room.darkness or rime.pvp.has_def("firefly", target) then
			stack_amount = 2
		end
	end

	if rime.targets[target].stacks[stack] > 0 then
		rime.targets[target].stacks[stack] = rime.targets[target].stacks[stack]-stack_amount
		if rime.targets[target].stacks[stack] < 0 then rime.targets[target].stacks[stack] = 0 end
		rime.echo("Removed a stack of <red>"..stack.."<white>. Current stack is at "..rime.targets[target].stacks[stack])
	end

	if stack == "gravity" and rime.targets[target].stacks.gravity == 0 and rime.pvp.has_aff("impede", target) then
		rime.pvp.remove_aff("impede", target)
	end

	if stack == "gloom" and rime.targets[target].stacks.gloom == 0 and rime.pvp.has_aff("gloom_aff", target) then
		rime.pvp.remove_aff("gloom_aff", target)
	end

	 GUI.target_aff()

end

function rime.pvp.has_stack(stack, target)

	target = string.title(target)

	if rime.targets[target].stacks[stack] == nil then rime.targets[target].stacks[stack] = 0 end
	return rime.targets[target].stacks[stack]

end

function rime.pvp.has_aff(aff, target)

	local target = target or rime.target
	if rime.targets[target] == nil then return false end
	
	target = string.title(target)

    if aff == "physical" then
        for k,v in pairs(rime.curing.affsByType.physical) do
            if rime.targets[target].afflictions[v] then
                return true
            end
        end
    end

    if aff == "prone" then
    	local prone_affs = {"frozen", "prone"}
    	local found_one = false
    	for k,v in ipairs(prone_affs) do
    		if rime.targets[target].afflictions[v] then
    			found_one = true
    			break
    		end
    	end

    	return found_one

    end

    if aff == "soft_locked" then
    	if (rime.targets[target].afflictions["anorexia"] or rime.targets[target].afflictions["destroyed_throat"]) and
    		rime.targets[target].afflictions["slickness"] and
    		rime.targets[target].afflictions["asthma"] then
    		return true
    	else
    		return false
    	end
    end

	if aff == "locked" then 
		if  (rime.targets[target].afflictions["paralysis"] or rime.targets[target].afflictions["paresis"]) and
			 rime.targets[target].afflictions["slickness"] and
			 rime.targets[target].afflictions["anorexia"] and
			 rime.targets[target].afflictions["asthma"] and
			(rime.targets[target].afflictions["stupidity"] or rime.targets[target].afflictions["impatience"]) then
				return true
			elseif rime.targets[target].afflictions["slough"] and (rime.targets[target].afflictions["stupidity"] or rime.targets[target].afflictions["impatience"]) then
				return true
			elseif
				rime.targets[target].afflictions["besilence"] and
				rime.targets[target].afflictions["asthma"] and
				rime.targets[target].afflictions["slickness"] and
				rime.targets[target].afflictions["anorexia"] then
					return true
			elseif
				rime.targets[target].afflictions["destroyed_throat"] and
				rime.targets[target].afflictions["asthma"] and
				rime.targets[target].afflictions["slickness"] then
					return true
			else
				return false
		end
	end

	if aff == "dead" then
		if (rime.targets[target].afflictions["paralysis"] or rime.targets[target].afflictions["paresis"]) and
			rime.targets[target].afflictions["slickness"] and
			(rime.targets[target].afflictions["anorexia"] or rime.targets[target].afflictions["destroyed_throat"]) and
			rime.targets[target].afflictions["asthma"] and
			rime.targets[target].afflictions["disrupted"] and
			rime.targets[target].afflictions["confusion"] and
			rime.targets[target].afflictions["voyria"] then
				return true
			else
				return false
		end
	end


	if rime.targets[target].afflictions[aff] then return true end

	return false

end

function rime.missingAff(list, separator)
	local separator = separator or "/"
    local list = string.split(list, separator)
    local tab = {}
    for k, v in pairs(list) do
        if v == "stupidity" then
            if not rime.pvp.has_aff(v, rime.target) and not rime.pvp.has_aff("impatience", rime.target) then
                table.insert(tab, v)
            end
        elseif v == "paresis" then
        	if not rime.pvp.has_aff(v, rime.target) and not rime.pvp.has_aff("paralysis", rime.target) then
                table.insert(tab, v)
            end
        elseif v == "deconblock" then
        	if not (rime.pvp.has_aff("clumsiness", rime.target) or rime.pvp.has_aff("weariness", rime.target) or rime.pvp.has_aff("hypochondria", rime.target)) then
        		table.insert(tab, v)
        	end
        elseif not rime.pvp.has_aff(v, rime.target) then
            table.insert(tab, v)
        end
    end
    return tab
end

function rime.pvp.room_set()

    rime.pvp.room.darkness = false
    rime.class_hitting = "none"
    bleeding_floor = 200
    local indoors = false
    execute.trap_set = false

    for k,v in pairs(rime.pvp.room) do
        rime.pvp.room[k] = false
    end

    for k,v in ipairs(gmcp.Room.Info.details) do
        if v == "darkness" then
            rime.pvp.room.darkness = true
        end
        if v == "indoors" then
            indoors = true
        end
    end

    if indoors then
        rime.pvp.room.indoors = true
    else
        rime.pvp.room.indoors = false
    end

    for k,v in pairs(ascended.resource) do
    	ascended.resource[k] = 0
    end


end

function rime.pvp.pill(pill, target)

	local target = string.title(target)

	if pill == "anabiotic" and not (rime.pvp.has_aff("plodding", target) or rime.pvp.has_aff("idiocy", target)) then
		rime.targets[target].mana = rime.targets[target].mana+10
		if rime.targets[target].mana > 100 then rime.targets[target].mana = 100 end
	end

	if pill =="anabiotic" and rime.pvp.has_aff("idiocy", target) then rime.pvp.remove_aff("idiocy", target) end

	rime.time("pill", target, 1.9)

	if pill == "kawhe" and not rime.pvp.has_aff("hypersomnia", target) then
		rime.pvp.addDef("insomnia", target)
	end

	if pill == "stimulant" and not rime.pvp.has_def("instawake", target) then
		rime.pvp.addDef("instawake", target)
	end

	for k, v in ipairs(rime.pvp.cures) do
		local aff = v["aff"]
		local cure = v["cure"]
		if rime.pvp.has_aff(aff, target) and cure == pill then
			if aff == "infested" and rime.pvp.has_aff("dread", target) then return end
			if aff == "blighted" and rime.pvp.has_aff("dread", target) then return end
			if aff == "rot" then
				rime.pvp.remove_stack("rot", target)
				if rime.targets[target].stacks["rot"] <= 0 then
					rime.pvp.remove_aff(aff, target)
					return
				end
			elseif aff == "gloom_aff" then
				rime.pvp.remove_stack("gloom", target)
			else
				rime.pvp.remove_aff(aff, target)
				if aff == "no_blind" then
					rime.pvp.addDef("blind", target)
				elseif aff == "no_deaf" then
					rime.pvp.addDef("deaf", target)
				end
				rime.targets[target].last_cured = aff
				return
			end
		end
	end

end

rime.pvp.lastLimb_hit = "nothing"
rime.pvp.lastLimb_damage = 0

function rime.pvp.add_limb(limb, target, amount, method)

	if limb == "nothing" then return end

	if target == "you" or target == "You" then return end

	local target = string.title(target)

	if method == "fracture" then

		if rime.pvp.has_aff(limb.."_bruised_critical", target) then

			if rime.pvp.runemark_major == "red" then

				amount = 2900

			else

				amount = 2400

			end

		elseif rime.pvp.has_aff(limb.."_bruised_moderate", target) then

			if rime.pvp.runemark_major == "red" then

				amount = 2500

			else

				amount = 2000

			end

		elseif rime.pvp.has_aff(limb.."_bruised", target) then

			if rime.pvp.runemark_major == "red" then

				amount = 2000

			else

				amount = 1600

			end

		elseif rime.pvp.runemark_major == "red" then

			amount = 1500

		else

			amount = 1200

		end

	elseif method == "slam" then

		if rime.pvp.runemark_major == "red" then

			amount = 1250

		else

			amount = 1000

		end

	end

	rime.pvp.lastLimb_hit = limb
	rime.pvp.lastLimb_damage = amount

	rime.targets[target].limbs[limb] = rime.targets[target].limbs[limb]+amount
	if rime.targets[target].limbs[limb] > 10000 then rime.targets[target].limbs[limb] = 10000 end

--	if rime.pvp.ai then rime.pvp.offense() end

	--rime.echo(target.."'s "..limb.." is at "..rime.targets[target].limbs[limb])
	if target == rime.target then
		local limbName = "<white>"
		local limbNumber = "<"..rime.saved.echo_colors.target.title..">"
		local limbcho = "\n"
		for lmb, dmg in pairs(rime.targets[rime.target].limbs) do
			dmg = dmg*.01
			if lmb == limb then limbName = "<orange>" limbNumber = "<white>" else limbName = "<"..rime.saved.echo_colors.target.title..">" limbNumber = "<DarkSlateGray>" end
			limbcho = limbcho..limbName..string.title(lmb:gsub("_", " ")).." "..limbNumber..dmg.."% <red>| "
		end
		cecho("\n<white>"..rime.target.."'s limbs: "..limbcho)
	end

end

function rime.pvp.remove_limb(limb, amount, target)

	local target = string.title(target)

	if amount == "nothing" then return end
	if limb == nil then return end
	
	--rime.echo("Limb we're removing limb damage from is "..limb..". The amount is "..amount..". The target is "..target)

	rime.targets[target].limbs[limb] = rime.targets[target].limbs[limb]-amount

	if rime.targets[target].limbs[limb] < 0 then rime.targets[target].limbs[limb] = 0 end

	rime.echo("<"..rime.saved.echo_colors.target.title..">"..target.."<white>: <DarkSlateGrey>"..(limb:gsub("_", " ")).." -"..(amount*.01).."%", "pvp")

	--rime.echo(target.."'s "..limb.." is now at "..(rime.targets[target].limbs[limb]*.01).."%")

--	if rime.pvp.ai then rime.pvp.offense() end

end

function rime.pvp.epidermal_cure(limb, target)


end

function rime.pvp.mending_cure(limb, target)

    target = string.title(target)

    if rime.pvp.has_aff("scraped", target) then
    	rime.pvp.remove_aff("scraped", target)
    end

    rime.time("poultice", target, 1.1)
    rime.targets[target].time.poulticeBalance = 1

    if rime.pvp.has_aff(limb.."_bruised_critical", target) then
        rime.pvp.remove_aff(limb.."_bruised_critical", target)
    elseif rime.pvp.has_aff(limb.."_crippled", target) and not rime.pvp.has_aff(limb.."_broken", target) then
        rime.pvp.remove_aff(limb.."_crippled", target)
    elseif rime.pvp.has_aff(limb.."_bruised_moderate", target) and not rime.pvp.has_aff(limb.."_broken", target) then
        rime.pvp.remove_aff(limb.."_bruised_moderate", target)
    elseif rime.pvp.has_aff(limb.."_bruised", target) and not rime.pvp.has_aff(limb.."_broken", target)then
        rime.pvp.remove_aff(limb.."_bruised", target)
    elseif rime.pvp.has_aff(limb.."_dislocated", target) and not rime.pvp.has_aff(limb.."_broken", target) then
        rime.pvp.remove_aff(limb.."_dislocated", target)
    end
    if limb == "torso" and rime.pvp.has_aff("lightwound", target) and not rime.pvp.has_aff("torso_broken", target) then
    	rime.pvp.remove_aff("lightwound", target)
    elseif limb == "torso" and rime.pvp.has_aff("ablaze", target) then
    	if not rime.pvp.has_aff("torso_broken", target) and not rime.pvp.has_aff("heatspear", target) then
        	rime.pvp.remove_aff("ablaze", target)
        end
    elseif limb == "torso" and rime.pvp.has_aff("cracked_ribs", target) and not rime.pvp.has_aff("torso_broken", target) then
        rime.pvp.remove_aff("cracked_ribs", target)
    elseif limb == "head" then
    	if rime.pvp.has_aff("destroyed_throat", target) then
    		rime.pvp.remove_aff("destroyed_throat", target)
    	elseif rime.pvp.has_aff("crippled_throat", target) then
    		rime.pvp.remove_aff("crippled_throat", target)
    	end
    elseif limb == "arms" then
		for k,v in ipairs(rime.curing.affsByCure.mendingarms) do
            if rime.pvp.has_aff(v, target) then
                rime.pvp.remove_aff(v, target)
                break
            end
        end
    elseif limb == "legs" then
		for k,v in ipairs(rime.curing.affsByCure.mendinglegs) do
            if rime.pvp.has_aff(v, target) then
                rime.pvp.remove_aff(v, target)
                break
            end
        end
    elseif limb == "skin" then
        local general_order = table.copy(rime.curing.affsByCure.mendingskin)
        for k,v in ipairs(general_order) do
            if rime.pvp.has_aff(v, target) then
            	if v == "lightwound" then
            		if not rime.pvp.has_aff("torso_broken", target) then
			    		rime.pvp.remove_aff("lightwound", target)
			    	end
			    elseif v == "ablaze" then
			    	if not rime.pvp.has_aff("torso_broken", target) and not rime.pvp.has_aff("heatspear", target) then
			        	rime.pvp.remove_aff("ablaze", target)
			        end
			    elseif v == "cracked_ribs" then
			    	if not rime.pvp.has_aff("torso_broken", target) then
			        	rime.pvp.remove_aff("cracked_ribs", target)
			        end
			    else
                	rime.pvp.remove_aff(v, target)
                end
                break
            end
        end
    end

end

function rime.pvp.restoration_cure(limb, target)

	target = string.title(target)
	local time = 4.2
	if rime.targets[target].stacks["rot"] == 5 then
		time = time*2
	end
	if rime.pvp.has_aff("blood_poison", target) then
		local poison = tostring(prae.poison_count(target))
		local conversion = {
			["1"] = .2,
			["2"] = .5,
			["3"] = .8
		}
		poison = tonumber(conversion[poison])
		time = time+poison
	end

	rime.time("poultice", target, time)
	rime.targets[target].time.poulticeBalance = 4
	rime.targets[target].prerestoredLimb = limb

	if rime.targets[target].stacks["rot"] == 5 then
		limitStart(target.."_"..limb.."_restore", time)
	else
		limitStart(target.."_"..limb.."_restore", time)
	end


end

function rime.pvp.caloric_cure(target)

	target = string.title(target)

	rime.time("poultice", target, 1.1)
	rime.targets[target].time.poulticeBalance = 1

	if rime.pvp.has_aff("hypothermia", target) then
		rime.pvp.remove_aff("hypothermia", target)
	elseif rime.pvp.has_aff("frozen", target) then
		rime.pvp.remove_aff("frozen", target)
	elseif rime.pvp.has_aff("shivering", target) then
		rime.pvp.remove_aff("shivering", target)
	elseif not rime.pvp.has_def("insulation", target) then
		rime.pvp.addDef("insulation", target)
	else
		rime.targets[target].last_cured = "nothing"
	end

	if rime.pvp.has_aff("weak_void", target) or rime.pvp.has_aff("void", target) then
        rime.targets[target].last_cured = "fake_aff"
    end

end


--Holbrook new function 20.05.22
--Not going to worry about figuring out which aff they cured since discernment will pick it up. (Sorry lowbies)
--Saving the tempTimer to set cooldown to false so that we can adjust the time for Archivist Syncopate (and hopefully other things too)
function rime.pvp.tree(target) 
	target = string.title(target)
	if rime.targets[target] == nil then
		rime.echo(target.." is not being tracked in rime.targets!\n","pvp")
		return
	end
	local treeTime = 10
	if rime.pvp.has_aff("laxity", target) then treeTime = treeTime + 2 end
	rime.time("tree", target, treeTime)
	if target == rime.target then cecho("<DodgerBlue> Tree down for "..treeTime.." seconds.") end
end


-- Holbrook update 20.05.22
-- Added laxity +2 seconds
--Saving the tempTimer to set cooldown to false so that we can adjust the time for Archivist Syncopate (and hopefully other things too)
function rime.pvp.focus(target)

	target = string.title(target)
	if rime.targets[target] == nil then
		rime.echo(target.." is not being tracked in rime.targets!\n","pvp")
		return
	end
	local focusTime = 4.9
	if rime.pvp.has_aff("mental_disruption", target) then focusTime = focusTime+5 end
	if rime.pvp.has_aff("laxity", target) then focusTime = focusTime + 2 end
	rime.targets[target].time.focusBalance = focusTime
	rime.time("focus", target, focusTime)
	rime.targets[target].cooldowns.focus = true
	rime.targets[target].time.focusCD = tempTimer(focusTime, function() rime.targets[target].cooldowns.focus = false end)
	if rime.pvp.has_aff("impatience", target) then
    	rime.pvp.remove_aff("impatience", target)
	end

	if target == rime.target then cecho("<DodgerBlue> Focus down for "..focusTime.." seconds.") end

	for k,v in ipairs(rime.pvp.focus_list) do
		if rime.pvp.has_aff(v, target) then
			if v == "nyctophobia" and rime.targets[target].stacks.gloom > 0 then
				rime.pvp.remove_stack("gloom", target)
			else
				rime.pvp.remove_aff(v, target)
			return end
		end
	end

end

function rime.pvp.fitness(target)
    target = string.title(target)
    if rime.targets[target] == nil then 
        rime.echo(target.." is not being tracked in rime.targets!\n","pvp")
        return        
    end
    local fitnessTime = 20
    if rime.pvp.has_aff("laxity", target) then fitnessTime = fitnessTime + 2 end
    rime.targets[target].time.fitnessBalance = fitnessTime
    rime.time("fitness", target, fitnessTime)
    rime.targets[target].cooldowns.fitness = true
    rime.targets[target].time.fitnessCD = tempTimer(fitnessTime, function() rime.targets[target].cooldowns.fitness = false end)
    if target == rime.target then cecho("<DodgerBlue> Fitness down for "..fitnessTime.." seconds.") end
end

function rime.pvp.balanceCheck(balance, targ)
	
	local target = targ or rime.target
	local time = 0

	if balance == "poultice" then time = rime.targets[target].time.poulticeBalance-rime.getTime("poultice", target) end
	if balance == "tree" then time = 10-rime.getTime("tree", target) end
	if balance == "focus" then time = rime.targets[target].time.focusBalance-rime.getTime("focus", target) end
	if balance == "lockbreaker" then time = 20-rime.getTime("lockbreaker", target) end
	if time < 0 then time = 0 end
	return time

end

function rime.pvp.noDef(defence, target)

	local target = string.title(target)

	if target == "All" then
		for k,v in pairs(rime.targets) do
			rime.targets[k].defences[defence] = false
		end

		rime.echo("Cleared all targets for the "..defence.." defence!")
		return
		
	elseif not rime.targets[target] then
		add_target(target)
	end
	if rime.targets[target].defences[defence] then
		rime.echo("<SteelBlue>"..target.."<white> lost <plum>"..defence.."<white>.")
	end
	rime.targets[target].defences[defence] = false

end

function rime.pvp.smoke(smoke, target)

	local target = string.title(target)

	if smoke == "reishi" then
		rime.time("rebounding", target, 6.5)
	end

	rime.pvp.remove_aff("asthma", target)

	--if smoke == "reishi" then return end

	for k, v in ipairs(rime.pvp.cures) do
		local aff = v["aff"]
		local cure = v["cure"]
		if rime.pvp.has_aff(aff, target) and cure == smoke then
			if aff == "hellsight" then
				if rime.pvp.has_aff("accursed", target) then
					return
				else
					if hellsightTimer then killTimer(hellsightTimer) end
				end
			end
			rime.pvp.remove_aff(aff, target)
			rime.targets[target].last_cured = aff
		return end
	end



end

function rime.pvp.addDef(defence, target)

	local target = string.title(target)

	if not rime.targets[target] then
		add_target(target)
	end

	rime.targets[target].defences[defence] = true
	rime.echo(target.." gained "..defence.."!", "pvp")



end

function rime.pvp.has_def(defence, target)

	local target = string.title(target)

	if rime.targets[target].defences[defence] == nil then rime.targets[target].defences[defence] = false end
	return rime.targets[target].defences[defence]

end

function rime.pvp.weapon_wield()

    local class = gmcp.Char.Status.class
    local spec = gmcp.Char.Status.spec

    if class == "Infiltrator" then
        act("qeb wear "..rime.saved.shield, "secure right", "wear bow", "secure left", "quickwield both "..rime.saved.shield.." dirk")
    elseif class == "Carnifex" then
        act("qeb wear "..rime.saved.shield, "secure right", "secure left", "quickwield both hammer")
    elseif class == "Indorani" then
        act("qeb wear "..rime.saved.shield, "secure right", "secure left", "quickwield both "..rime.saved.shield.." bonedagger")
    elseif class == "Praenomen" then
        if spec ==  "Rituos" or spec == "Phreneses" then
            act("qeb  wear "..rime.saved.shield, "secure right", "secure left", "quickwield both "..rime.saved.flavor_2h)
        elseif spec == "Insidiae" then
            act("qeb wear "..rime.saved.shield, "secure right", "secure left", "quickwield both "..rime.saved.shield.." "..rime.saved.flavor_1h)
        else
        	act("qeb wear "..rime.saved.shield, "secure right", "secure left", "quickwield both "..rime.saved.flavor_2h)
        end
    elseif class == "Akkari" then
    	act("qeb wear "..rime.saved.shield, "secure right", "secure left", "quickwield both "..rime.saved.flavor_2h)
    elseif class == "Revenant" then 
    	local left,right = "",""
		if rime.pvp.route.weapon == "1handblunts" then 
    		left = rime.saved.revblunt1
    		right = rime.saved.revblunt2
    	elseif rime.pvp.route.weapon == "2handblunt" then 
    		left = rime.saved.rev2handblunt
    	elseif rime.pvp.route.weapon == "2handblade" then 
    		left = rime.saved.rev2handblade
    	else
    		left = rime.saved.revblade1
    		right = rime.saved.revblade2
    	end
    	if left ~= nil then
    		act("qeb quickwield both "..left.." "..right)
    	else
    		rime.echo("No weapons defined for Revenant! Please search for the alias named \"Revenant Weapon (1H Blades)\" and its counterparts.")
    	end
    elseif class == "Earthcaller" then
    	act("qeb wear bow", "wear "..rime.saved.shield, "secure right", "secure left", "quickwield both "..rime.saved.shield.." crozier")
    elseif class == "Alchemist" then
    	act("qeb wear bow", "wear "..rime.saved.shield, "secure right", "secure left", "quickwield both "..rime.saved.alchemist_conduit)
    elseif class == "Bard" then
    	if rime.pvp.route.weapon == "instrument" then
    		if rime.vitals.wielded_left:find(rime.saved.bard_instrument) then
    			act("qeb secure right", "unwield right", "quickwield right "..rime.saved.bard_weapon)
    		else
		    	act("qeb wear bow", "wear "..rime.saved.shield, "secure right", "secure left", "quickwield both "..rime.saved.bard_instrument.." "..rime.saved.bard_weapon)
		    end
		else
    		act("qeb wear bow", "wear "..rime.saved.shield, "secure right", "secure left", "unwield left", "unwield right", "quickwield right "..rime.saved.bard_weapon)
    	end
    elseif class == "Sciomancer" then
    	act("qeb wear bow", "wear "..rime.saved.shield, "secure right", "secure left", "quickwield both "..rime.saved.shield.." "..rime.saved.sciomancer_focus)
    elseif class == "Archivist" then
    	act("qeb wear bow", "wear "..rime.saved.shield, "secure right", "secure left", "quickwield both "..rime.saved.shield.." " ..rime.saved.archivist_codex)
    elseif class == "Teradrim" then
        if rime.pve.bashing then
            act('qeb wear tower', 'wear buckler', 'secure left', 'secure right', 'wear bow', 'wear tower', 'quickwield both buckler '..rime.saved.pve_flail)
        else
            act('qeb wear tower', 'wear buckler', 'secure left', 'secure right', 'wear bow', 'wear tower', 'quickwield both buckler '..rime.saved.pvp_flail)
        end
       elseif class == "Bloodborn" then
       	act("qeb wear bow", "wear "..rime.saved.shield, "secure left", "secure right", "quickwield both "..rime.saved.shield.." "..rime.saved.bloodborn_weapon)
    elseif class == "Monk" then
    	act("qeb wear shield", "wear shield.2", "secure left", "secure right", "unwield left", "unwield right")
    elseif class == "Executor" then
    	act("qeb wear shield", "wear shield.2", "secure left", "secure right", "wear bow", "quickwield both ringblade")
    end

end

function rime.pvp.web_venoms()

	local target = rime.last_hit

	if rime.pvp.web_venom1 then
		rime.pvp.add_aff(rime.pvp.web_venom1:lower(), target)
		rime.pvp.web_venom1 = false
	elseif rime.pvp.web_venom2 then
		rime.pvp.add_aff(rime.pvp.web_venom2:lower(), target)
		rime.pvp.web_venom2 = false
	end



end

function rime.pvp.web_subdues()

    local target = rime.last_hit

    if rime.pvp.web_subdue then
        rime.pvp.add_aff(rime.pvp.web_subdue, target)
    end

end

function rime.pvp.web_venoms_noreb()

	local target = rime.last_hit

	if rime.pvp.web_venom1 then
		rime.pvp.add_aff(rime.pvp.web_venom1, target)
		rime.pvp.web_venom1 = false
	elseif rime.pvp.web_venom2 then
		rime.pvp.add_aff(rime.pvp.web_venom2, target)
		rime.pvp.web_venom2 = false
	end

end

function rime.pvp.whisper_affs(target)

	if rime.pvp.web_whisper1 then
		rime.pvp.add_aff(rime.pvp.web_whisper1, target)
	end
	if rime.pvp.web_whisper2 then
		rime.pvp.add_aff(rime.pvp.web_whisper2, target)
	end

end

rime.pvp.web_moon = false
rime.pvp.web_sun = false

function rime.pvp.indo_sort(aff)

if aff == "aeon" then return end

local moon = {"stupidity", "confusion", "recklessness", "impatience", "epilepsy", "berserking", "weariness", "anorexia"}
local sun = {"paresis", "clumsiness", "asthma", "vomiting", "lethargy", "sensitivity", "superstition", "hypersomnia", "perplexed"}

	if table.contains(moon, aff) then
		rime.pvp.web_moon = aff
	elseif table.contains(sun, aff) then
		rime.pvp.web_sun = aff
	else
		if aff ~= nil then 
			rime.echo("<red> ERROR FAILED TO PARSE Tarot: "..aff)
		else
			rime.echo("<red> ASSESS INDO CALLING AND TRACKING")
		end
	end

end

function rime.convert_affliction(thing)

    local affs = {
		{aff = "clumsiness", venom = "xentio"},
		{aff = "stuttering", venom = "jalk"},
		{aff = "blindness", venom = "oleander"},
		{aff = "recklessness", venom = "eurypteria"},
		{aff = "asthma", venom = "kalmia"},
		{aff = "shyness", venom = "digitalis"},
		{aff = "allergies", venom = "darkshade"},
		{aff = "paresis", venom = "curare"},
		{aff = "no_blind", venom = "oculus"},
		{aff = "no_deaf", venom = "prefarar"},
		{aff = "sensitivity", venom = "prefarar"},
		{aff = "blurry_vision", venom = "oculus"},
		{aff = "disfigurement", venom = "monkshood"},
		{aff = "vomiting", venom = "euphorbia"},
		{aff = "weariness", venom = "vernalius"},
		{aff = "dizziness", venom = "larkspur"},
		{aff = "anorexia", venom = "slike"},
		{aff = "voyria", venom = "voyria"},
		{aff = "peace", venom = "ouabain"},
		{aff = "stupidity", venom = "aconite"},
		{aff = "slickness", venom = "gecko"},
		{aff = "haemophilia", venom = "hepafarin"},
		{aff = "thin_blood", venom = "scytherus"},
		{aff = "asleep", venom = "delphinium"},
		{aff = "left_arm_crippled", venom = "epteth"},
		{aff = "right_arm_crippled", venom = "epteth"},
		{aff = "left_leg_crippled", venom = "epseth"},
		{aff = "right_leg_crippled", venom = "epseth"},
		{aff = "mortalterror", venom = "bimre"},
		{aff = "squelched", venom = "selarnia"},
		{aff = "deadening", venom = "vardrax"},
	}

	if table.contains(affs, thing) then 

		for k,v in ipairs(affs) do
			if v.aff == thing then
				return v.venom
			end
		end
		return false
	else

		return false

	end

end


function rime.convert_venom(thing)

    local affs = {
		{aff = "clumsiness", venom = "xentio"},
		{aff = "stuttering", venom = "jalk"},
		{aff = "blindness", venom = "oleander"},
		{aff = "recklessness", venom = "eurypteria"},
		{aff = "asthma", venom = "kalmia"},
		{aff = "shyness", venom = "digitalis"},
		{aff = "allergies", venom = "darkshade"},
		{aff = "paresis", venom = "curare"},
		{aff = "no_blind", venom = "oculus"},
		{aff = "no_deaf", venom = "prefarar"},
		{aff = "sensitivity", venom = "prefarar"},
		{aff = "blurry_vision", venom = "oculus"},
		{aff = "disfigurement", venom = "monkshood"},
		{aff = "vomiting", venom = "euphorbia"},
		{aff = "weariness", venom = "vernalius"},
		{aff = "dizziness", venom = "larkspur"},
		{aff = "anorexia", venom = "slike"},
		{aff = "voyria", venom = "voyria"},
		{aff = "peace", venom = "ouabain"},
		{aff = "stupidity", venom = "aconite"},
		{aff = "slickness", venom = "gecko"},
		{aff = "haemophilia", venom = "hepafarin"},
		{aff = "thin_blood", venom = "scytherus"},
		{aff = "asleep", venom = "delphinium"},
		{aff = "left_arm_crippled", venom = "epteth"},
		{aff = "right_arm_crippled", venom = "epteth"},
		{aff = "left_leg_crippled", venom = "epseth"},
		{aff = "right_leg_crippled", venom = "epseth"},
		{aff = "mortalterror", venom = "bimre"},
		{aff = "squelched", venom = "selarnia"},
		{aff = "deadening", venom = "vardrax"},
		{aff = "asleep", venom = "delphinium"},
	}
    
	if table.contains(affs, thing) then 

		for k,v in ipairs(affs) do
			if v.venom == thing then
				return v.aff
			end
		end
		return false
	else

		return false

	end

end

function rime.pvp.is_parrying(limb, target)
    if not target then
        target = rime.target
    end

    if rime.targets[target].parry == limb then
        return true
    end
    if rime.targets[target].baiting == limb then
        return true
    end

    return false
end

function rime.pvp.parry_pred(limb)

local target_limbs = rime.targets[rime.target].limbs
local sort_limbs = sortedKeys(target_limbs)
local sorted_limbs = {}
local mode = rime.pvp.prediction_mode
local last_parried = rime.targets[rime.target].parry

for _, key in ipairs(sort_limbs) do
	table.insert(sorted_limbs, key)
end

for k,v in ipairs(rime.targets[rime.target].limbs) do
	if rime.limit[v.."_restore"] then
		table.remove(sorted_limbs, table.index_of(sorted_limbs, v))
	end
end

--[[if last_parried ~= "nothing" and table.contains(sorted_limbs, last_parried) then
	table.remove(sorted_limbs, table.index_of(sorted_limbs, last_parried))
end]]--

	if not rime.pvp.canParry() then return false end

	if mode == "1" then
		if limb == sorted_limbs[2] or limb == last_parried then
			return true
		else
			return false
		end
	elseif mode == "2" then
		if limb == sorted_limbs[3] or limb == last_parried then
			return true
		else
			return false
		end
	elseif mode == "3" then
		if  limb == rime.pvp.lastLimb_hit or limb == last_parried or sorted_limbs[1] then
			return true
		else
			return false
		end
	end

end


rime.pvp.prediction_mode = rime.pvp.prediction_mode or "1"
rime.pvp.route = rime.pvp.route or {}
rime.pvp.route_choice = rime.pvp.route_choice or "nothing"
rime.pvp.Praenomen = rime.pvp.Praenomen or {}
rime.pvp.Carnifex = rime.pvp.Carnifex or {}
rime.pvp.Revenant = rime.pvp.Revenant or {}
rime.pvp.Teradrim = rime.pvp.Teradrim or {}
rime.pvp.Indorani = rime.pvp.Indorani or {}
rime.pvp.Earthcaller = rime.pvp.Earthcaller or {}
rime.pvp.Executor = rime.pvp.Executor or {}
rime.pvp.Infiltrator = rime.pvp.Infiltrator or {}
rime.pvp.Shapeshifter = rime.pvp.Shapeshifter or {}
rime.pvp.Monk = rime.pvp.Monk or {}
rime.pvp.Archivist = rime.pvp.Archivist or {}
rime.pvp.Sciomancer = rime.pvp.Sciomancer or {}
rime.pvp.Wayfarer = rime.pvp.Wayfarer or {}
rime.pvp.Alchemist = rime.pvp.Alchemist or {}
rime.pvp.Ravager = rime.pvp.Ravager or {}
rime.pvp.Ascended = rime.pvp.Ascended or {}
rime.pvp.Bard = rime.pvp.Bard or {}
rime.pvp.Bloodborn = rime.pvp.Bloodborn or {}
rime.pvp.Predator = rime.pvp.Predator or {}

rime.pvp.route = rime.pvp.route or {}

function routeSelect(rt)

	local class = rime.status.class

	local class_conversion = {
		["Shaman"] = "Alchemist",
		["Akkari"] = "Praenomen",
		["Oneiromancer"] = "Indorani",
		["Zealot"] = "Ravager",
		["Voidseeker"] = "Archivist",

	}

	if class_conversion[class] then

		class = class_conversion[class]

	end

	if class == rime.saved.ascended_class then
		class = "Ascended"
	end

	local spec = gmcp.Char.Status.spec

	if rime.pvp.route == rime.pvp[class].routes[rt] then rime.echo("Route already active. Nothing changed.", "pvp") return end

	if rime.pvp[class].routes[rt] then

		rime.pvp.route = rime.pvp[class].routes[rt]
		rime.pvp.route_choice = rt

		rime.echo("Route changed to <mustard>"..string.title(rt).."<white>.", "pvp")

		if rime.pvp.route.melody then
			if rime.pvp.route.melody == "euphonia" then
				expandAlias("kd "..rime.pvp.route.melody)
				expandAlias("no discordance")
				rime.echo("Melody switched to Euphonia", "pvp")
			else
				expandAlias("kd discordance")
				expandAlias("no euphonia")
				rime.echo("Melody switched to Discordance", "pvp")
			end
		end

	else

		rime.echo("<mustard>"..string.title(rt).."<white> route not detected for <purple>"..class.."<white>.", "pvp")

	end



end


function routeList()

	local class = rime.status.class

	if class == nil then rime.echo("Class is breaking") end

	rime.echo("Current class is "..class_color()..class.."<white>.")

	local class_conversion = {
		["Shaman"] = "Alchemist",
		["Akkari"] = "Praenomen",

	}

	if class_conversion[class] then

		class = class_conversion[class]

	end

	if class == rime.saved.ascended_class then
		class = "Ascended"
	end

	for k,v in pairs(rime.pvp[class].routes) do
		if v.blurb then
            rime.echo("<mustard>"..string.title(k).."<white> "..v.blurb[1]..".\n")
		else
			rime.echo("<mustard>"..string.title(k).."<white> route available.")
		end
	end

	rime.echo("Use \"<mustard>rs <white>\<<mustard>route<white>\><white>\" to select a new route.")
end


function rime.pvp.queue_handle()

	local sep = rime.saved.separator
	local que = {}
	local class = gmcp.Char.Status.class
	local mount = rime.saved.mount
	local mounted = gmcp.Char.Vitals.mounted
  
  	prae.can_deluge = prae.can_deluge or true 
  	prae.can_mend = prae.can_mend or true

	table.insert(que, "stand")

	local reverse_dir = {
		["n"] = "s",
		["ne"] = "sw",
		["e"] = "w",
		["se"] = "nw",
		["s"] = "n",
		["sw"] = "ne",
		["w"] = "e",
		["nw"] = "se",
	}

	if rime.pve.moved then
		table.insert(que, reverse_dir[rime.pve.moved])
	end

	if rime.need_enemy then
		table.insert(que, "unally "..rime.target)
		table.insert(que, "enemy "..rime.target)
	end
  
	for k,v in pairs(rime.curing.pipes) do
		if v == false and v ~= "last" then
			table.insert(que, "outc "..k)
			if rime.saved[k.."_pipe"] == nil then
				table.insert(que, "put "..k.." in emptypipe")
				table.insert(que, "pipelist")
            else
            	table.insert(que, "put "..k.." in "..rime.saved[k.."_pipe"])
            end
		end
	end

	if not rime.saved.arti_pipes then
		table.insert(que, "light pipes")
	end

	if rime.cure_set == "group" then
		table.insert(que, "get body")
		table.insert(que, "get dagger")
	end

	if rime.cure_set == "wayfarer" then
		table.insert(que, "get dagger")
	end

    local parryCommand = "parry "
    local hasAParry = false
    if class == "Monk" and hasSkill("Guarding") then
        parryCommand = "guard "
        hasAParry = true
    elseif class == "Zealot" and hasSkill("Fending") then
        parryCommand = "fend "
        hasAParry = true
    elseif class == "Ravager" and hasSkill("Oppose") then
        parryCommand = "oppose "
        hasAParry = true
    elseif hasSkill("Parrying") then
        parryCommand = "parry "
        hasAParry = true 
    end

    if rime.parry ~= rime.parried and hasAParry then
        table.insert(que, parryCommand ..rime.parry)
    end

	if class == "Praenomen" then
		if rime.vitals.percent_health < 40 and prae.can_deluge then
			table.insert(que, "blood deluge")
		end
	  
		if rime.vitals.percent_health < 60 and prae.can_mend then
			table.insert(que, "mend")
		end
	end

	if rime.has_possible_aff("impatience") then
		table.insert(que, "meditate")
	end

	if rime.has_possible_aff("indifference") or rime.cure_set == "zealot" or rime.cure_set == "group" then
		if tonumber(gmcp.Char.Vitals.mounted) < 1 and not gmcp.Char.Status.class == "Shapeshifter" then
			table.insert(que, "recall mount")
			table.insert(que, "quickmount "..mount)
		end
	end

	if class == "Praenomen" and not has_def("reflection") then
		table.insert(que, "order loyals kill "..rime.target)
	end

	if rime.pvp.need_order and not rime.has_aff("disfigurement") then
		table.insert(que, "order loyals passive")
		table.insert(que, "order loyals kill "..rime.target)
	end

	if rime.has_possible_aff("weariness") then
		table.insert(que, "Quickdismount")
	end

	if rime.has_possible_aff("peace") then
		table.insert(que, "enemy "..rime.target)
	end

	if rime.has_possible_aff("paranoia") then
		table.insert(que, "unenemy "..gmcp.Char.Status.name)
	end

	if (rime.affTally > 3 or rime.vitals.percent_health < 70) and rime.balances.nimbleness then
		table.insert(que, "nimbleness")
	end

	if (rime.affTally > 3 or rime.vitals.percent_health < 60) and has_def("defending") then
		table.insert(que, "undefend")
	end

	if rime.curing.embedIn:gsub(" ", "_") == rime.curing.restoring_limb and rime.curing.embedIn ~= "none" 
	   and not rime.has_aff(rime.curing.embedIn:gsub(" ", "_").."_broken") then
		table.insert(que, "pull axe from me")
	end

	if hasSkill("Contemplation") and not rime.pve.bashing and (class == "Praenomen" or class == "Earthcaller" or class == "Indorani") then
		table.insert(que, "contemplate " .. rime.target)
	end

	if rime.curing.vinethorns > 0 then
        table.insert(que, "pull thorns from body")
    end

	if rime.curing.needWounds and rime.pvp.ai then
		table.insert(que, "wounds")
	end

	if not rime.has_aff("hypochondria") and (rime.curing.need_howl_check or rime.hidden_affs_total >= 3) then
		table.insert(que, "diag")
	end

	local class_ents = {
		["Teradrim"] = true,
		["Praenomen"] = true,
		["Sciomancer"] = true,
		["Indorani"] = true,
		["Oneiromancer"] = true,
		["Tera_mirror"] = true,
		["Shaman"] = true,
		["Shaman_mirror"] = true,
		["Ravager"] = true,
		["Zealot"] = true,
	}

	if class_ents[gmcp.Char.Status.class] and rime.pvp.ai and rime.has_possible_aff("disfigurement") then
		table.insert(que, "order loyals kill "..rime.target)
	end

	if rime.curing.adder and (rime.vitals.bleeding < 600 or not has_def("speed")) then
		table.insert(que, "rip card from body")
	end

	if rime.curing.diamond and (rime.vitals.bleeding < 600 or not has_def("speed")) then
		table.insert(que, "rip shape from body")
	end

	local class_cures = {
	["Teradrim"] = "earth absorb",
	["Praenomen"] = "purify blood",
	["Carnifex"] = "soul purge",
	["Revenant"] = "rage",
	["Shapeshifter"] = "rage",
	["Indorani"] = "draw fool from deck" .. sep .. "fling fool at me",
	["Sciomancer"] = "cast leech",
	["Shaman"] = "nature panacea",
	["Earthcaller"] = "tectonic thermics",
	["Alchemist"] = "botany subvert",
	["Ravager"] = "ego boost",
	}

	local fitness_break =  "fitness"..sep..getCureAction(nextPipeAff())..sep..getCureAction(nextPoulticeAff())..sep..getCureAction(nextPillAff("asthma"))

    if rime.pvp.class_lockBreak() then table.insert(que, fitness_break) end
	if rime.pvp.class_cure() then
		table.insert(que, class_cures[class])
	end

	local writhes = {"writhe_transfix", "writhe_impaled", "writhe_web", "writhe_ropes", "writhe_vines", "writhe_grappled",}

	for k,v in ipairs(rime.saved.allies) do
		if rime.targets[v] == nil then add_target(v) end
		for a,b in ipairs(writhes) do
			if rime.pvp.has_aff(b, v) and v ~= rime.target then
				table.insert(que, "refining disperse "..v)
				break
			end
		end
	end

	local final_queue = {}

	for k,v in ipairs(que) do
		if #final_queue < 10  and not table.contains(final_queue, v) then
			table.insert(final_queue, v)
		end
	end

	return "qeb "..table.concat(final_queue, sep)

end

function rime.pvp.class_lockBreak()

    local class = rime.status.class
    local lock_break = "fitness"
--quick failure opt outs
    if not rime.curing.class_breaker then return false end
    if rime.has_aff("destroyed_throat") then return false end
--main logic
    if rime.has_aff("slickness") and rime.has_aff("asthma") then
        return true
    else
        if (rime.has_aff("clumsiness") or rime.has_aff("weariness") or rime.has_aff("hypochondria")) and rime.has_aff("asthma") and (rime.has_aff("aeon") or (not has_def("speed") and rime.has_aff("anorexia"))) then
            return true
        elseif (rime.has_aff("clumsiness") or rime.has_aff("weariness") or rime.has_aff("hypochondria")) and rime.has_aff("asthma") and rime.has_aff("disfigurement") then
            return true
        end
    end
--default return false 
    return false
end

function rime.pvp.post_queue()

    local post_queue = {}
    local sep = rime.saved.separator

    if #post_queue > 0 then
    	return sep..table.concat(post_queue, sep)
    else
    	return ""
    end

end


function rime.pvp.class_lockBreak()

	local class = gmcp.Char.Status.class
	local class_lock = {
		["Teradrim"] = "sand scour",
		["Carnifex"] = "fitness",
		["Shifter"] = "shed",
		["Monk"] = "fitness",
		["Revenant"] = "fitness",
		["Indorani"] = "fitness",
	}
--quick failure opt outs
	if not rime.curing.class_breaker then return false end
	if class_lock[class] == "fitness" and rime.has_aff("destroyed_throat") then return false end
--main logic
	if rime.has_aff("slickness") and rime.has_aff("asthma") then
		return true
	elseif class_lock[class] == "fitness" then
		if (rime.has_aff("clumsiness") or rime.has_aff("weariness") or rime.has_aff("hypochondria")) and rime.has_aff("asthma") and (rime.has_aff("aeon") or (not has_def("speed") and rime.has_aff("anorexia"))) then
			return true
		elseif (rime.has_aff("clumsiness") or rime.has_aff("weariness") or rime.has_aff("hypochondria")) and rime.has_aff("asthma") and rime.has_aff("disfigurement") then
			return true
		end
	end

--default return false 
	return false
end

function rime.pvp.class_cure()

	local class = rime.status.class
	local classAffs = table.copy(rime.afflictions)
	local affs = {}
	local needTree = false

	classAffs[rime.curing.tried.pill] = false
	classAffs[rime.curing.tried.poultice] = false
	classAffs[rime.curing.tried.pipe] = false
	classAffs[rime.curing.tried.focus] = false
	
	if rime.has_aff("right_arm_broken") then classAffs["right_arm_crippled"] = false end
	if rime.has_aff("left_arm_broken") then classAffs["left_arm_crippled"] = false end
	if rime.has_aff("right_leg_broken") then classAffs["right_leg_crippled"] = false end
	if rime.has_aff("left_leg_broken") then classAffs["left_leg_crippled"] = false end
	if rime.has_aff("heatspear") then classAffs["ablaze"] = false end

	if class == "Carnifex" then
		for k,v in pairs(rime.curing.affsByType.physical) do
			if classAffs[v] then
				additem(affs, v)
			end
		end
	elseif class == "Revenant" then
		for k,v in pairs(rime.curing.affsByCure.steroid) do
			if classAffs[v] then
				additem(affs, v)
			end
		end
	elseif class == "Earthcaller" then 
		for k,v in pairs(rime.curing.affsByType.physical) do
			if classAffs[v] then 
				additem(affs, v)
			end
		end
		for k,v in pairs(rime.curing.affsByType.mental) do
			if classAffs[v] then 
				additem(affs, v)
			end
		end
	elseif class == "Ravager" then 
		for k,v in pairs(rime.curing.affsByType.mental) do
			if classAffs[v] then 
				additem(affs, v)
			end
		end
	else
		for k,v in pairs(rime.curing.affsByType.renew) do
			if classAffs[v] then
				additem(affs, v)
			end
		end
	end
	
	if rime.curing.class then

		if class == "Teradrim" then
			if #affs > 2 and not (rime.has_aff("paresis") or rime.has_aff("paralysis")) then
				return true
			else
				return false
			end
		elseif class == "Praenomen" then
			if #affs > 2 or rime.hidden_affs_total > 2 then
				return true
			else
				return false
			end
		elseif class == "Carnifex" then
			if #affs > 2 and not (rime.has_aff("paralysis")) then
				return true
			else
				return false
			end
		elseif class == "Revenant" then
			if #affs > 0 then
				return true
			else
				return false
			end
		elseif class == "Sciomancer" then
			if #affs > 2 or rime.hidden_affs_total > 2 then
				return true
			else
				return false
			end
		elseif class == "Shaman" then
			if #affs > 2 or rime.hidden_affs_total > 2  then
				return true
			else
				return false
			end
		elseif class == "Alchemist" then
			if #affs >= 2 or rime.hidden_affs_total >= 2 then
				return true
			else
				return false
			end
		elseif class == "Indorani" then
			if #affs >= 2 or rime.hidden_affs_total > 2 then
				return true
			else
				return false
			end
		elseif class == "Earthcaller" then 
			if #affs > 3 or rime.hidden_affs_total > 2 then
				return true
			else
				return false
			end
		elseif class == "Ravager" then 
			if #affs > 2 then
				return true
			else
				return false
			end
		end

	end
	return false

end

function rime.pvp.ai_toggle()

	if rime.pvp.ai then
		rime.pvp.ai = false
		rime.echo("Offense turned off!", "pvp")
		act("target nothing"..rime.saved.separator.."target nothing with right")
		act("qb")
		act("qe")
		act("qs")
		act("qeb")
		rime.balance_queue_attempted = "nothing"
		rime.balance_queue = "nothing"
	else
		rime.pvp.ai = true
		rime.echo("Offense started, HERE WE GO", "pvp")
		rime.balance_queue_attempted = "nothing"
		rime.balance_queue = "nothing"
		rime.pvp.weapon_wield()
		rime.pvp.offense()
	end

end

rime.pvp.boss = {}
rime.pvp.web_follow = rime.pvp.web_follow or false
rime.pvp.web_aff_calling = rime.pvp.web_aff_calling or false

function rime.pvp.web_caller(bosshog)

	bosshog = string.title(bosshog)

	if not table.contains(rime.pvp.boss, bosshog) then
		table.insert(rime.pvp.boss, bosshog)
		rime.echo("Listening enabled for "..bosshog.."!")
		act("wt Web Listening enabled for "..bosshog)
	else
		rime.echo("Web listening already enabled for "..bosshog.."!")
	end
	rime.pvp.web_follow = true
	rime.echo("Currently listening to "..table.concat(rime.pvp.boss, ", "))

end

rime.pvp.calling = rime.pvp.calling or false

function rime.pvp.web_call()

	if rime.pvp.calling then
		rime.pvp.calling = false
		act("wt Target calling Disabled")
	else
		rime.pvp.calling = true
		act("wt Target Calling Enabled")

	end

end

function rime.pvp.web_target(bosshog, target)

	local bosshog = string.title(bosshog)
	local target = string.title(target)

	if #rime.pvp.boss > 1 and bosshog == "Yettave" then return end

	for k,v in pairs(rime.pvp.boss) do
		if v == bosshog and not table.contains(rime.saved.allies, target) then
			rime.target_track(target)
			break
		end
	end

end

function rime.pvp.webProcess(talker, stuff)
  talker = talker:lower()
  stuff = stuff:gsub("%(web%)%: ","")
  stuff = stuff:gsub(talker.." says, ","")
  stuff = stuff:gsub("you say, ","")
  stuff = stuff:gsub("%\"","")
  stuff = stuff:gsub("%b<>","")
  stuff = stuff:lower()

  if stuff:find("^unblock") then
    blockExit = nil
    send("unblock")
  end
  
  if string.find(stuff, "^target: ") then
    local newStuff = string.match(stuff, "target: (.+).")
    for k,v in ipairs(rime.saved.allies) do
	  if v == newStuff then
	   act("wt target: "..rime.target)
	   break
	  end
	end
    targetCalled = true
    rime.pvp.web_target(talker, newStuff)
    targetCalled = false
  end
  
end

function rime.pvp.offense()

    local class = rime.status.class

    if rime.pvp.route_choice == "nothing" then
        --class table:
        local classTab = {
            Archivist = "unravel",
            Ascendril = "black",
            Carnifex = "group",
            Indorani = "glock",
            Luminary = "group",
            Shapeshifter = "quarter",
            Monk = "group",
            Praenomen = "group",
            Revenant = "group",
            Sciomancer = "black",
            Sentinel = "black",
            Shaman = "strangle",
            Infiltrator = "black",
            Templar = "group",
            Teradrim = "legs",
            Warden = "group",
            Wayfarer = "black",
            Zealot = "legs",
            Earthcaller = "group",
            Ascended = "group",
            Ravager = "group",
            Bloodborn = "group",
            Executor = "group",
        }
        routeSelect(classTab[class] or "group")
    end

    if rime.targets[rime.target] == nil then return end

    if rime.has_aff("paralysis") and not rime.curing.class_breaker then
        return
    elseif rime.has_aff("left_leg_crippled") and rime.has_aff("right_leg_crippled") and not rime.curing.class_breaker then
        return
    elseif gmcp.Char.Vitals.writhing == "1" then
        return
    elseif class == "Praenomen" or class == "Akkari" then
        prae.offense()
    elseif class == "Carnifex" or class == "Warden" then
        carn.offense()
    elseif class == "Sciomancer" then
        scio.offense()
    elseif class == "Teradrim" or class == "Tidesage" then
        rime.teradrim.offense()
    elseif class == "Shapeshifter" then
        shifter.offense()
    elseif class == "Indorani" or class == "Oneiromancer" then
        indo.offense()
    elseif class == "Infiltrator" then
        infiltrator.offense()
    elseif class == "Monk" then
        monk.offense()
    elseif class == "Revenant" or class == "Templar" then
        rev.offense()
    elseif class == "Earthcaller" or class == "Luminary" then 
    	earthcaller.offense()
    elseif class == "Executor" or class == "Sentinel" then
    	execute.offense()
    elseif class == rime.saved.ascended_class then 
    	ascended.offense()
    elseif class == "Bard" then 
    	rime.bard.offense()
    elseif class == "Archivist" then
    	archivist.offense()
    elseif class == "Alchemist" or class == "Shaman" then
    	alchemist.offense()
    elseif class == "Ravager" or class == "Zealot" then
    	ravager.offense()
    elseif class == "Bloodborn" then
    	rime.bloodborn.offense()
    elseif class == "Predator" then
    	predator.offense()
    end


end

function rime.pvp.omniCall(affTab, type)
	--System uses your class to parse aff calls, and append it to the web call for easy tracking
	local class = rime.status.class
	--Place your target variable here, removing tizzy.target:
	local target = rime.target
	
	--Assumption: You pass attacks in the order that you are using them. If you do NOT do this,
	--the caller will do weird things. Please pass the VENOM when you are using venoms,
	--and the AFF NAME otherwise, adhering to AFFLICTION_LIST spelling.

	if affTab == nil then return "nothing" end
	if class == "Archivist" then
		--Archivists don't need affliction calling, this simply exists for completeness.
		return "wt Afflicting "..target..": "..affTab:gsub("/", ", ")
	elseif class == rime.saved.ascended_class then 
		return "wt afflicting "..target..": "..affTab:gsub("/", ", ")
	elseif class == "Carnifex" then
		return "wt Afflicting "..target..": "..affTab:gsub("/", ", ")
	elseif class == "Indorani" then
		return "wt [Indorani] Afflicting "..target..": "..affTab:gsub("/", ", ")
	elseif class == "Monk" then
		--Dagger monk may require further work
		return "wt Afflicting "..target..": "..affTab:gsub("/", ", ")
	elseif class == "Praenomen" then
		--Prae can miss on slash, not on whisper, so the calling is different:
		affTab = string.split(affTab, "/")
		local ven = affTab[1]
		table.remove(affTab, 1)
		local whisper = table.concat(affTab, ", ")
		if type == "whispers" then
			return "wt Afflicting "..target..": " .. whisper
		elseif type == "init" then
			return "wt Afflicting "..target..": "..ven
		else
			return "wt Afflicting "..target..": "..ven..". Whispering: "..whisper
		end
	elseif class == "Sciomancer" then
		--3p tracks, leaving this as a stub for rework
		return "wt Afflicting "..target..": "..affTab:gsub("/", ", ")
	elseif class == "Shapeshifter" then
		--Don't really aff call, 3p tracks
		return "wt Afflicting "..target..": "..affTab:gsub("/", ", ")
	elseif class == "Infiltrator" then
		return "wt Afflicting "..target..": "..affTab:gsub("/", ", ")
	elseif class == "Teradrim" then
		--3p tracking easier than this
		return "wt Afflicting "..target..": "..affTab:gsub("/", ", ")
	elseif class == "Wayfarer" then
		return "wt Afflicting "..target..": "..affTab:gsub("/", ", ")
	elseif class == "Revenant" then
		return "wt Afflicting "..target..": "..affTab:gsub("/", ", ")
    elseif class == "Earthcaller" then
        return "wt Subdue "..target..": "..affTab:gsub("/", "")
    elseif class == "Alchemist" then
    	return "wt Afflicting "..target..": "..affTab:gsub("/", ", ")
	elseif class == "Executor" then
		return "wt Afflicting "..target..": "..affTab:gsub("/", ", ")
	else
		echo("\nError! No known class formatting.")
	end
	
end

function rime.pvp.canParry(target)
	local can_parry = true
	local noparryaffs = {"frozen", "punished_arms", "indifference", "paresis", "paralysis"}
	if not target then target = rime.target end

	for _, aff in pairs(noparryaffs) do
		if rime.pvp.has_aff(aff, target) then
			can_parry = false
		end
	end

	if gmcp.Char.Status.class == "Carnifex" then 
		if rime.pvp.has_aff("distortion", target) and not rime.pvp.has_def("rebounding", target) then
			can_parry = false
		end
	end
	
	if gmcp.Char.Status.class == "Revenant" then
		if rev.chirography.limbatdum.can() and not rime.pvp.has_def("rebounding", target) then
			can_parry = false
		end
		if not rime.pvp.has_def("insulation", target) and rev.chirography.double_telvi.can() then
			can_parry = false 
		end
		if rime.pvp.has_aff("shivering", target) and rev.chirography.telvi.can() and not rev.chirography.wasiatdum.can() then 
			can_parry = false 
		end
	end

	if rime.pvp.has_aff("left_arm_crippled", target) and rime.pvp.has_aff("right_arm_crippled", target) then
		can_parry = false
	end

	if rime.pvp.has_aff("left_arm_crippled", target) and rime.pvp.has_aff("right_arm_numbed", target) then
		can_parry = false
	end

	if rime.pvp.has_aff("left_arm_numbed", target) and rime.pvp.has_aff("right_arm_crippled", target) then
		can_parry = false
	end

	return can_parry
end

function rime.pvp.mental_count(target)

    local aff_count = 0
    for k,v in ipairs(rime.pvp.focus_list) do
        if rime.pvp.has_aff(v, target) then
            aff_count = aff_count+1
        end
    end

    return aff_count

end

 --Holbrook new 20.05.22 but actually we probably don't need this. We can use rime.pvp.count_affs(affType)
function rime.pvp.physical_count(target)

    local aff_count = 0
    for k,v in pairs(rime.pvp.physical_aff_list) do
        if rime.pvp.has_aff(k, target) then
            aff_count = aff_count+1
        end
    end

    return aff_count

end

rime.pvp.weapon_verbs = {
  
	["bastardsword"] = "gash",
	["scythe"] = "gash",
	["glaive"] = "gash",
	["flyssa"] = "slash",
	["battleaxe"] = "slash",
	["whip"] = "scourge",
	["shortsword"] = "slash",
 	["rapier"] = "jab",
 	["broadsword"] = "slash",
 	["manta"] = "gash",
 	["falchion"] = "slash",
 	["yozati"] = "gash",
 	["Yozati"] = "gash",
 	["whirlwind"] = "throw at ground",

}


rime.pvp.focus_list = {
	"egocentric",
	"stupidity",
	"anorexia",
	"epilepsy",
	"mirroring",
	"mental_disruption",
	"peace",
	"paranoia",
	"hallucinations",
	"dizziness",
	"indifference",
	"berserking",
	"pacifism",
	"lovers_effect",
	"laxity",
	"hatred",
	"generosity",
	"claustrophobia",
	"vertigo",
	"faintness",
	"loneliness",
	"agoraphobia",
	"masochism",
	"recklessness",
	"weariness",
	"confusion",
	"dementia",
	"nyctophobia",
	"dread"
	}


rime.pvp.cures = {
{cure = "eucrasia", aff = "worrywart"},
{cure = "eucrasia", aff = "misery"},
{cure = "eucrasia", aff = "hollow"},
{cure = "eucrasia", aff = "narcolepsy"},
{cure = "eucrasia", aff = "perplexed"},
{cure = "eucrasia", aff = "self_loathing"},
{cure = "anabiotic", aff = "plodding"},
{cure = "anabiotic", aff = "idiocy"},
{cure = "ototoxin", aff = "no_deaf"},
{cure = "amaurosis", aff = "no_blind"},
{cure = "antipsychotic", aff = "sadness"}, 
{cure = "antipsychotic", aff = "confusion"},
{cure = "antipsychotic", aff = "dementia"},
{cure = "antipsychotic", aff = "hallucinations"},
{cure = "antipsychotic", aff = "paranoia"},
{cure = "antipsychotic", aff = "hypersomnia"},
{cure = "antipsychotic", aff = "hatred"},
{cure = "antipsychotic", aff = "addiction"},
{cure = "antipsychotic", aff = "blood_curse"},
{cure = "antipsychotic", aff = "blighted"},
{cure = "euphoriant", aff = "selfpity"},
{cure = "euphoriant", aff = "stupidity"},
{cure = "euphoriant", aff = "dizziness"},
{cure = "euphoriant", aff = "faintness"},
{cure = "euphoriant", aff = "shyness"},
{cure = "euphoriant", aff = "epilepsy"},
{cure = "euphoriant", aff = "impatience"},
{cure = "euphoriant", aff = "resonance"},
{cure = "euphoriant", aff = "dissonance"},
{cure = "euphoriant", aff = "infested"},
{cure = "euphoriant", aff = "insomnia"},
{cure = "decongestant", aff = "baldness"},
{cure = "decongestant", aff = "clumsiness"},
{cure = "decongestant", aff = "magic_impaired"},
{cure = "decongestant", aff = "hypochondria"},
{cure = "decongestant", aff = "weariness"},
{cure = "decongestant", aff = "asthma"},
{cure = "decongestant", aff = "sensitivity"},
{cure = "decongestant", aff = "ringing_ears"},
{cure = "decongestant", aff = "impairment"},
{cure = "decongestant", aff = "blood_poison"},
{cure = "depressant", aff = "commitment_fear"},
{cure = "depressant", aff = "merciful"},
{cure = "depressant", aff = "recklessness"},
{cure = "depressant", aff = "masochism"},
{cure = "depressant", aff = "agoraphobia"},
{cure = "depressant", aff = "loneliness"},
{cure = "depressant", aff = "berserking"},
{cure = "depressant", aff = "vertigo"},
{cure = "depressant", aff = "gloom_aff"},
{cure = "depressant", aff = "nyctophobia"},
{cure = "depressant", aff = "claustrophobia"},
{cure = "coagulation", aff = "body_odor"},
{cure = "coagulation", aff = "lethargy"},
{cure = "coagulation", aff = "allergies"},
{cure = "coagulation", aff = "mental_disruption"},
{cure = "coagulation", aff = "physical_disruption"},
{cure = "coagulation", aff = "vomiting"},
{cure = "coagulation", aff = "exhausted"},
{cure = "coagulation", aff = "thin_blood"},
{cure = "coagulation", aff = "rend"},
{cure = "coagulation", aff = "haemophilia"},
{cure = "panacea", aff = "stormtouched"},
{cure = "panacea", aff = "patterns"},
{cure = "panacea", aff = "rot_body"},
{cure = "panacea", aff = "rot_wither"},
{cure = "panacea", aff = "rot_heat"},
{cure = "panacea", aff = "rot_spirit"},
{cure = "panacea", aff = "rot_benign"},
{cure = "steroid", aff = "hubris"},
{cure = "steroid", aff = "pacifism"},
{cure = "steroid", aff = "peace"},
{cure = "steroid", aff = "agony"},
{cure = "steroid", aff = "accursed"},
{cure = "steroid", aff = "limp_veins"},
{cure = "steroid", aff = "lovers_effect"},
{cure = "steroid", aff = "laxity"},
{cure = "steroid", aff = "superstition"},
{cure = "steroid", aff = "generosity"},
{cure = "steroid", aff = "justice"},
{cure = "steroid", aff = "magnanimity"},
{cure = "opiate", aff = "paresis"},
{cure = "opiate", aff = "paralysis"},
{cure = "opiate", aff = "mirroring"},
{cure = "opiate", aff = "crippled_body"},
{cure = "opiate", aff = "crippled"},
{cure = "opiate", aff = "blisters"},
{cure = "opiate", aff = "slickness"},
{cure = "opiate", aff = "heartflutter"},
{cure = "opiate", aff = "slough"},
{cure = "willow", aff = "aeon"},
{cure = "willow", aff = "hellsight"},
{cure = "willow", aff = "deadening"},
{cure = "yarrow", aff = "migraine"},
{cure = "yarrow", aff = "slickness"},
{cure = "yarrow", aff = "withering"},
{cure = "yarrow", aff = "squelched"},
{cure = "yarrow", aff = "disfigurement"},
{cure = "reishi", aff = "besilence"},
}

rime.pvp.mental_aff_list = {["egocentric"] = true, ["stupidity"] = true, ["anorexia"] = true, ["epilepsy"] = true, ["mirroring"] = true, ["mental_disruption"] = true, ["peace"] = true, ["paranoia"] = true,["hallucinations"] = true, ["dizziness"] = true, ["indifference"] = true, ["berserking"] = true, ["pacifism"] = true, ["lovers_effect"] = true, ["laxity"] = true, ["hatred"] = true, ["generosity"] = true, ["claustrophobia"] = true, ["vertigo"] = true, ["faintness"] = true, ["loneliness"] = true, ["agoraphobia"] = true, ["masochism"] = true, ["recklessness"] = true, ["weariness"] = true, ["impatience"] = true, ["confusion"] = true, ["dementia"] = true, ["nyctophobia"] = true, ["dread"] = true}
rime.pvp.physical_aff_list = {["paresis"] = true, ["paralysis"] = true, ["right_arm_crippled"] = true, ["right_leg_crippled"] = true, ["left_arm_crippled"] = true, ["left_leg_crippled"] = true, ["physical_disruption"] = true, ["haemophilia"] = true, ["asthma"] = true, ["impairment"] = true,["clumsiness"] = true, ["vomiting"] = true, ["sensitivity"] = true, ["ringing_ears"] = true, ["lethargy"] = true, ["blood_poison"] = true, ["blood_curse"] = true, ["crippled_throat"] = true, ["sandrot"] = true, ["disfigurement"] = true, ["blisters"] = true, ["magic_fire"] = true, ["lightwound"] = true, ["ablaze"] = true, ["hypothermia"] = true, ["shivering"] = true, ["frozen"] = true, ["limp_veins"] = true, ["rend"] = true, ["exhausted"] = true, ["allergies"] = true, ["addiction"] = true, ["hypersomnia"] = true, ["heartflutter"] = true, ["whiplash"] = true, ["backstrain"] = true, ["sore_wrist"] = true, ["sore_ankle"] = true, ["burnt_eyes"] = true, ["blurry_vision"] = true, ["migraine"] = true, ["deadening"] = true, ["ice_encased"] = true}