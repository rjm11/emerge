--Author: Bulrok
rime.bard = rime.bard or {}
rime.bard.song = false
rime.bard.weave_hand = rime.bard.weave_hand or "left"
rime.bard.weapon_hand = rime.bard.weapon_hand or "right"
rime.bard.playing = false
rime.bard.singing = false
rime.bard.halfbeat = rime.bard.halfbeat or false
rime.bard.rhythm_stage = false
rime.bard.anelace = rime.bard.anelace or 0
rime.bard.audience = "nobody"
rime.bard.inspire = true
rime.bard.needle = true
rime.bard.blackstar = false
rime.bard.need_anelace = false
rime.bard.instruments = {"cello", "ocarina",}

rime.pvp.Bard.routes = {

	["black"] = {
		["blurb"] = {"🎶 Fuck you too bitch, call the cops. I'ma kill you and them loud ass mother fuckin' barkin' dogs 🎶"},
		["weapon"] = "falcion",
		["melody"] = "discordance",
		["attacks"] = {
			"break_locket",
			"heartcage",
			"bravado",
			"dazed",
			"boundary",
			"ironcollar",
			"locked_collar",
			"collar_stab",
			"sing_fate",
			"sing_awakening",
			"sing_destiny",
			"sing_fascination",
			"sing_decadence",
			"collar_anelace",
			"collar_bladestorm",
			"sing_remembrance",
			"sing_charity",
			"sing_sorrow",
			"globes",
			"runeband",
			"needle",
			"hiltblow",
			"push_besilence",
			"tempo",
			"push_selfloathing",
			"quip",
			"ridicule",
			"crackshot",
			"headstitch",
			"soundblast",
			"rebounding",
			"paresis",
			"asthma",
			"dizziness",
			"shyness",
			"weariness",
			"slickness",
			"anorexia",
			"stupidity",
			"dizziness",
			"allergies",
			"left_leg_broken",
			"right_leg_broken",
			"vomiting",
			"haemophilia",
			"left_arm_broken",
			"right_arm_broken",
			"voyria",
		},

		["induce"] = {
            "heartcage_induce",
            "low_happiness",
            "happiness",
            "fear",
            "anger",
            "stress",
            "disgust",
            "sadness",
            "surprise",
		},
	},

	["red"] = {
		["blurb"] = {"🎶 Wanna resolve things in a bloodier way? Just study a tape of NWA. 🎶"},
		["weapon"] = "falcion",
		["melody"] = "discordance",
		["attacks"] = {
			"break_locket",
			"heartcage",
			"bravado",
			"boundary",
			"ironcollar",
			"locked_collar",
			"collar_stab",
			"sing_awakening",
			"sing_destiny",
			"collar_anelace",
			"collar_bladestorm",
			"sing_remembrance",
			"sing_charity",
			"sing_sorrow",
			"globes",
			"runeband",
			"needle",
			"swindle_dizziness",
			"swindle_confusion",
			"lovers_effect",
			"hiltblow",
			"push_besilence",
			"tempo",
			"push_selfloathing",
			"quip",
			"ridicule",
			"crackshot",
			"headstitch",
			"rebounding",
			"paresis",
			"peace",
			"asthma",
			"shyness",
			"weariness",
			"slickness",
			"anorexia",
			"stupidity",
			"dizziness",
			"left_leg_broken",
			"right_leg_broken",
			"vomiting",
			"haemophilia",
		},

		["induce"] = {
            "heartcage_induce",
            "low_happiness",
            "happiness",
            "fear",
            "anger",
            "stress",
            "disgust",
            "sadness",
            "surprise",
		},
	},

	["white"] = {
		["blurb"] = {"🎶 Your bedtime stories are scaring everyone. 🎶"},
		["weapon"] = "falcion",
		["melody"] = "discordance",
		["attacks"] = {
			"break_locket",
			"bravado",
			"boundary",
			"sing_awakening",
			"sing_destiny",
			"heartcage",
			"globes",
			"runeband",
			"needle",
			"push_selfloathing",
			"hiltblow",
			"ironcollar",
			"bladestorm",
			"push_besilence",
			"anelace",
			"tempo",
			"quip",
			"ridicule",
			"crackshot",
			"headstitch",
			"rebounding",
			"paresis",
			"shyness",
			"asthma",
			"weariness",
			"shyness",
			"slickness",
			"allergies",
			"stupidity",
			"anorexia",
			"vomiting",
			"haemophilia",
		},

		["induce"] = {
            "heartcage_induce",
            "happiness",
            "fear",
            "anger",
            "stress",
            "disgust",
            "sadness",
            "surprise",
		},
	},

	["support"] = {
		["blurb"] = { "🎶 I can be your hero baby.. 🎶" },
		["weapon"] = "instrument",
		["melody"] = "euphonia",
		["attacks"] = {
			"effigy",
			"patchwork",
			"play_youth",
			"sing_youth",
			--"effigy",
			"quip",
			"ridicule",
			"needle",
			"tempo",
			"pierce",
			"voyria",
			"paresis",
			"asthma",
			"slickness",
			"anorexia",
			"shyness",
			"dizziness",
			"sensitivity",
		},

		["induce"] = {},
	}

}

function rime.bard.rhythm_envenom(rhythm)

    local target = rime.target

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
        sleep = "delphinium",
        left_arm_broken = "epteth",
        right_arm_broken = "epteth",
        left_leg_broken = "epseth",
        right_leg_broken = "epseth",
        squelched = "selarnia",
        deadening = "vardrax",
    }

    local ven1 = rime.convert_venom(string.match(rime.bard.get_attack(), "tempo %a+ (%a+)"))

    for k,v in ipairs(rime.pvp.route.attacks) do
		if not rime.pvp.has_aff(v, target) and ven1 ~= v and v ~= "paresis" and rime.convert_affliction(v) and rime.targets[target].needle ~= rime.convert_venom(v) then
			return rime.convert_affliction(v)
		end
	end
	return ""

end

function rime.bard.sing(song)

	rime.bard.singing = song

	limitStart("singing", 8.2)

end

function rime.bard.play(song)

	rime.bard.playing = song

	limitStart("playing", 6.2)

end

function rime.bard.globes(target)

	local globes_affs = {"perplexed", "confusion", "dizziness"}
	local tar_globes = rime.targets[target].globes
	rime.pvp.add_aff(globes_affs[tar_globes], target)

end


function rime.bard.song_hit(target, song)

	local songs = {
		charitable = "generosity",
		decadent = "addiction",
	}

	rime.pvp.add_aff(songs[song], target)

end

function rime.bard.emotion(target)

	local target_primary = rime.targets[target].emotions.induced

	if target_primary == "none" then

		return tonumber(0)

	else

		return tonumber(rime.targets[target].emotions[target_primary])

	end

end

function rime.bard.rune_band(target)

	local runeband_affs = {"stupidity", "paranoia", "ringing_ears", "loneliness", "exhausted", "laxity", "clumsiness"}

	if rime.targets[target].runeband == "normal" then
		rime.pvp.add_aff(runeband_affs[rime.targets[target].runeband_next], target)
		rime.targets[target].runeband_next = rime.targets[target].runeband_next+1
		if rime.targets[target].runeband_next > 7 then
			rime.targets[target].runeband_next = 1
			rime.echo("Reached the end of Runeband affs, starting over!")
		end
	elseif rime.targets[target].runeband == "reversed" then
		rime.pvp.add_aff(runeband_affs[rime.targets[target].runeband_next], target)
		rime.targets[target].runeband_next = rime.targets[target].runeband_next-1
		if rime.targets[target].runeband_next < 1 then
			rime.targets[target].runeband_next = 7
			rime.echo("Reached the end of reversed Runeband affs, starting over!")
		end
	end

end

function rime.bard.induce(target)

	local target_emotions = rime.targets[target].emotions

	local induce_priority = {
		"fear",
		"sadness",
		"surprise",
	}

	if target_emotions.induced == "none" then
		for k,v in ipairs(induce_priority) do
			if target_emotions[v] > 25 then
				--return "induce "..v.." in "..target
			end
		end
	end


	for k,v in ipairs(rime.pvp.route.induce) do
		if rime.bard.induces[v].can() and target_emotions.induced ~= v  then
			local decision = rime.bard.induces[v].choice()
			return rime.bard.induces[v].command(decision)
		end
	end

	return ""

end

function rime.bard.venom_filter(rhythm)

	local target = rime.target

	for k,v in ipairs(rime.pvp.route.attacks) do
		if rime.convert_affliction(v) and not rime.pvp.has_aff(v, target) and rime.targets[target].needle ~= rime.convert_affliction(v) then
			return rime.convert_affliction(v)
		end
	end
end



function rime.bard.bravado()


	local classAffs = {}

    for k,v in pairs(rime.afflictions) do
        if v then
            table.insert(classAffs, k)
            classAffs[k] = true
        end
    end

	local affs = {}
	local needClass = false

	local sep = rime.saved.separator

	classAffs[rime.curing.tried.pill] = false
	classAffs[rime.curing.tried.poultice] = false
	classAffs[rime.curing.tried.pipe] = false
	classAffs[rime.curing.tried.focus] = false
	
	if rime.has_aff("right_arm_damaged") then classAffs["right_arm_broken"] = false end
	if rime.has_aff("left_arm_damaged") then classAffs["left_arm_broken"] = false end
	if rime.has_aff("right_leg_damaged") then classAffs["right_leg_broken"] = false end
	if rime.has_aff("left_leg_damaged") then classAffs["left_leg_broken"] = false end
	if rime.has_aff("heatspear") then classAffs["ablaze"] = false end
	if rime.has_aff("frozen") then classAffs["shivering"] = false end

		for k,v in pairs(rime.curing.affsByType.renew) do
			if classAffs[v] then
				additem(affs, v)
			end
		end
	
	if rime.curing.class then
		
		if #affs > 2 then
			return true 
		else 
			return false 
		end

	end

end

function rime.bard.sock()

	local classAffs = {}

    for k,v in pairs(rime.afflictions) do
        if v then
            table.insert(classAffs, k)
            classAffs[k] = true
        end
    end

	local affs = {}
	local needClass = false

	local sep = rime.saved.separator

	classAffs[rime.curing.tried.pill] = false
	classAffs[rime.curing.tried.poultice] = false
	classAffs[rime.curing.tried.pipe] = false
	classAffs[rime.curing.tried.focus] = false
	
	if rime.has_aff("right_arm_damaged") then classAffs["right_arm_broken"] = false end
	if rime.has_aff("left_arm_damaged") then classAffs["left_arm_broken"] = false end
	if rime.has_aff("right_leg_damaged") then classAffs["right_leg_broken"] = false end
	if rime.has_aff("left_leg_damaged") then classAffs["left_leg_broken"] = false end
	if rime.has_aff("heatspear") then classAffs["ablaze"] = false end
	if rime.has_aff("frozen") then classAffs["shivering"] = false end

		for k,v in pairs(rime.curing.affsByType.renew) do
			if classAffs[v] then
				additem(affs, v)
			end
		end
		
		if #affs > 2 then
			return true 
		else 
			return false 
		end

end

rime.bard.induces = {

	["push"] = {},

	["happiness"] = {
		command = function(action)
			local choices = {"induce happiness in "..rime.target}
			return choices[action]
		end,
		can = function()
			local target = rime.target
			if not hasSkill("Induce") then return false end
			if rime.targets[target].emotions.happiness < 100 then return false end
			if rime.targets[target].ironcollar ~= "closed" then return false end
			return true
		end,
		choice = function()
			return 1
		end,
	},

	["low_happiness"] = {
		command = function(action)
			local choices = {"induce happiness in "..rime.target}
			return choices[action]
		end,
		can = function()
			local target = rime.target
			if not hasSkill("Induce") then return false end
			if rime.targets[target].emotions.happiness < 30 then return false end
			if rime.targets[target].ironcollar == "closed" then return false end
			return true
		end,
		choice = function()
			return 1
		end,
	},

	["sadness"] = {
		command = function(action)
			local choices = {"induce sadness in "..rime.target}
			return choices[action]
		end,
		can = function()
			local target = rime.target
			if not hasSkill("Induce") then return false end
			if rime.targets[target].emotions.sadness >= 30 then
				return true
			else
				return false
			end
		end,
		choice = function()
			return 1
		end,
	},

	["surprise"] = {
		command = function(action)
			local choices = {"induce surprise in "..rime.target}
			return choices[action]
		end,
		can = function()
			local target = rime.target
			if not hasSkill("Induce") then return false end
			if rime.targets[target].emotions.surprise >= 30 then
				return true
			else
				return false
			end
		end,
		choice = function()
			return 1
		end,
	},

	["anger"] = {
		command = function(action)
			local choices = {"induce anger in "..rime.target}
			return choices[action]
		end,
		can = function()
			local target = rime.target
			if not hasSkill("Induce") then return false end
			if rime.targets[target].emotions.anger >= 50 then
				return true
			else
				return false
			end
		end,
		choice = function()
			return 1
		end,
	},

	["stress"] = {
		command = function(action)
			local choices = {"induce stress in "..rime.target}
			return choices[action]
		end,
		can = function()
			local target = rime.target
			if not hasSkill("Induce") then return false end
			if rime.targets[target].emotions.stress >= 30 then
				return true
			else
				return false
			end
		end,
		choice = function()
			return 1
		end,
	},

	["fear"] = {
		command = function(action)
			local choices = {"induce fear in "..rime.target}
			return choices[action]
		end,
		can = function()
			local target = rime.target
			if not hasSkill("Induce") then return false end
			if rime.targets[target].emotions.fear >= 30 then
				return true
			else
				return false
			end
		end,
		choice = function()
			return 1
		end,
	},

	["disgust"] = {
		command = function(action)
			local choices = {"induce disgust in "..rime.target}
			return choices[action]
		end,
		can = function()
			local target = rime.target
			if not hasSkill("Induce") then return false end
			if rime.targets[target].emotions.disgust >= 30 then
				return true
			else
				return false
			end
		end,
		choice = function()
			return 1
		end,
	},

    ["heartcage_induce"] = {
        command = function(action)
            local target = rime.target
            return "induce "..action.." in "..target
        end,
        can = function()
        	local target = rime.target
            local target_emotions = rime.targets[target].emotions
              local highest = "fear"
              for k,v in ipairs(target_emotions) do
                if k == "induced" then
                elseif v > target_emotions[highest] then
                    highest = k
                end
            end
              if target_emotions[highest] >= 75 then
                  return true
              else
                  return false
              end
          end,
        choice = function()
        	local target = rime.target
            local target_emotions = rime.targets[target].emotions
            local highest = "fear"
            for k,v in ipairs(target_emotions) do
                if k == "induced" then
                elseif v > target_emotions[highest] then
                    highest = k
                end
            end
            return highest
        end,
    },

}

rime.bard.attacks = {

	--[[["deliverance_deflect"]
		command = function()
			local ally = rime.pvp.pick_ally("deflect")]]

	["soundblast"] = {
		command = "weave soundblast",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("no_deaf", target) then return false end
			if rime.pvp.has_aff("ringing_ears", target) then return false end
			if rime.vitals.dithering > 0 then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["reprisal_lock"] = {
		command = "wipe right"..rime.saved.separator.."envenom right with slike"..rime.saved.separator.."envenom right with gecko"..rime.saved.separator.."reprisal",
		can = function()
			local target = rime.target
			local focus = rime.getTimeLeft("focus", target)
			local my_gate = rime.pvp.get_gate()
			local reprisal_class = {"carnifex", "templar", "sentinel", "syssin", "zealot", "monk"}
			local found_one = false
			for k,v in ipairs(reprisal_class) do
				if rime.cure_set == v then
					found_one = true
					break
				end
			end
			if my_gate > focus then return false end
			if not rime.pvp.has_aff("asthma", target) then return false end
			if rime.vitals.dithering > 0 then return false end
			if rime.has_aff("paresis") then return false end
			if rime.has_aff("paralysis") then return false end
			return found_one
		end,
		combo = function()
			return false
		end,
	},

	["sing_fate"] = {
		command = "sing song of fate",
		can = function()
			local target = rime.target
			if rime.bard.singing then return false end
			if rime.targets[target].fate then return false end
			return true
		end,
		combo = function()
			return false
		end
	},

	["sing_awakening"] = {
		command = "sing song of awakening",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("awakened", target) then return false end
			if rime.bard.singing then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["sing_youth"] = {
		command = "sing song of youth",
		can = function()
			if rime.bard.singing then return false end
			return true
		end,
		combo = function()
			return false
		end
	},

	["play_youth"] = {
		command = "play song of youth",
		can = function()
			if rime.bard.playing then return false end
			return rime.bard.instrument_check()
		end,
		combo = function()
			return false
		end,
	},

	["sing_remembrance"] = {
		command = "sing song of remembrance",
		can = function()
			if rime.has_aff("peace") then return false end
			if not rime.bard.halfbeat then return false end
			if rime.bard.singing then return false end
			if rime.vitals.dithering > 0 then return true end
		end,
		combo = function()
			return false
		end,
	},

	["sing_destiny"] = {
		command = "sing song of destiny",
		can = function()
			if has_def("destiny") then return false end
			if not rime.bard.halfbeat then return false end
			if rime.bard.singing then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["play_destiny"] = {
		command = "play song of destiny",
		can = function()
			if has_def("destiny") then return false end
			if not rime.bard.halfbeat then return false end
			if rime.bard.playing then return false end
			return rime.bard.instrument_check()
		end,
		combo = function()
			return false
		end,
	},

	["sing_charity"] = {
		command = "sing song of charity",
		can = function()
			local target = rime.target
			if rime.bard.singing then return false end
			if not rime.bard.halfbeat then return false end
			if rime.pvp.has_aff("generosity", target) then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["play_charity"] = {
		command = "play song of charity",
		can = function()
			local target = rime.target
			if rime.bard.playing then return false end
			if not rime.bard.halfbeat then return false end
			if rime.pvp.has_aff("generosity", target) then return false end
			return rime.bard.instrument_check()
		end,
		combo = function()
			return false
		end,
	},

	["sing_decadence"] = {
		command = "sing song of decadence",
		can = function()
			local target = rime.target
			if rime.bard.singing then return false end
			if not rime.bard.halfbeat then return false end
			if rime.pvp.has_aff("addiction", target) then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["play_decadence"] = {
		command = "play song of decadence",
		can = function()
			local target = rime.target
			if rime.bard.playing then return false end
			if not rime.bard.halfbeat then return false end
			if rime.pvp.has_aff("addiction", target) then return false end
			return rime.bard.instrument_check()
		end,
		combo = function()
			return false
		end,
	},

	["sing_sorrow"] = {
		command = "sing song of sorrow",
		can = function()
			local target = rime.target
			if rime.bard.singing then return false end
			if not rime.bard.halfbeat then return false end
			if rime.pvp.has_aff("migraine", target) then return false end
			if rime.pvp.has_aff("squelched", target) then return false end
			if not rime.pvp.has_aff("asthma", target) then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["play_sorrow"] = {
		command = "play song of sorrow",
		can = function()
			local target = rime.target
			if rime.bard.singing then return false end
			if not rime.bard.halfbeat then return false end
			if rime.pvp.has_aff("migraine", target) then return false end
			if rime.pvp.has_aff("squelched", target) then return false end
			return rime.bard.instrument_check()
		end,
		combo = function()
			return false
		end,
	},

	["sing_fascination"] = {
		command = "sing song of fascination",
		can = function()
			local target = rime.target
			if rime.bard.singing then return false end
			if not rime.bard.halfbeat then return false end
			if rime.pvp.has_aff("writhe_stasis", target) then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["globes"] = {
		command = "weave globes target",
		can = function()
			local target = rime.target
			if rime.targets[target].globes > 0 then return false end
			if rime.vitals.dithering > 0 then return false end
			if not has_def("destiny") then return false end
			return true
		end,
		combo = function()
			return has_def("destiny")
		end,
	},

	["boundary"] = {
		command = "weave boundary",
		can = function()
			if rime.pvp.room.boundary then return false end
			if rime.vitals.dithering > 0 then return false end
			return true
		end,
		combo = function()
			return has_def("destiny")
		end,
	},

	["runeband"] = {
		command = "weave runeband target",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("runeband", target) then return false end
			if rime.vitals.dithering > 0 then return false end
			return true
		end,
		combo = function()
			return has_def("destiny")
		end,
	},

	["bladestorm"] = {
		command = "weave bladestorm target",
		can = function()
			local target = rime.target
			if rime.targets[target].bladestorm > 0 then return false end
			if rime.vitals.dithering > 0 then return false end
			return true
		end,
		combo = function()
			return has_def("destiny")
		end,
	},

	["collar_bladestorm"] = {
		command = "weave bladestorm target",
		can = function()
			local target = rime.target
			if rime.targets[target].bladestorm > 0 then return false end
			if rime.vitals.dithering > 0 then return false end
			if rime.targets[target].ironcollar ~= "closed" then return false end
			return true
		end,
		combo = function()
			return has_def("destiny")
		end,
	},

	["anelace"] = {
		command = "weave anelace\\stab target",
		can = function()
			local target = rime.target
			if not has_def("destiny") then return false end
			if rime.pvp.has_aff("hollow", target) then return false end
			if rime.pvp.has_aff("narcolepsy", target) then return false end
			if rime.targets[target].ironcollar ~= "closed" then return false end
			if rime.bard.anelace == 2 then return false end
			if rime.vitals.dithering > 0 then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["collar_anelace"] = {
		command = "weave anelace",
		can = function()
			local target = rime.target
			if rime.bard.anelace == 2 then return false end
			if rime.targets[target].ironcollar == "closed" then return false end
			if rime.vitals.dithering > 0 then return false end
			if rime.getTimeLeft("induce", target) < 3 and rime.bard.anelace > 0 then return false end --added induce check lmao
			if not has_def("destiny") then return false end
			--maybe induced check here?
			return true
		end,
		combo = function()
			return has_def("destiny")
		end,
	},

	["collar_stab"] = {
		command = "quickwield left anelace\\stab target",
		can = function()
			local target = rime.target
			if rime.bard.anelace == 0 then return false end
			if rime.targets[target].ironcollar == "closed" then return false end
			if rime.targets[target].emotions.induced ~= "happiness" then return false end
			if rime.pvp.has_aff("hollow", target) then return false end
			if rime.getTimeLeft("tree", target) < 4 or rime.getTimeLeft("tree", target) == 0 then return false end
			if rime.vitals.dithering > 0 then return false end
			if rime.getTimeLeft("induce", target) > 3 or rime.getTimeLeft("induce", target) == 0 then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["patchwork"] = {
		command = "weave patchwork ally",
		can = function()
			local ally = rime.pvp.pick_ally("aggro")
			if rime.targets[ally].aggro < 1 then return false end
			if rime.vitals.dithering > 0 then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["needle"] = {
		command = "needle target venom",
		can = function()
			local target = rime.target
			if rime.targets[target].needle then return false end
			if rime.pvp.has_def("shielded", target) then return false end
			if not rime.bard.needle then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["tempo"] = {
		command = "tempo target venom",
		can = function()
			local target = rime.target
			if rime.bard.rhythm_stage then return false end
			if rime.pvp.has_aff("anorexia", target)
				and rime.pvp.has_aff("slickness", target)
				and rime.pvp.has_aff("besilence", target)
				and rime.pvp.has_aff("asthma", target)
				and rime.pvp.has_aff("paralysis", target)
				and rime.pvp.has_aff("left_leg_broken", target)
				and rime.pvp.has_aff("right_leg_broken", target) then return false end
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_def("shielded", target) then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["headstitch"] = {
		command = "weave headstitch target",
		can = function()
			local target = rime.target
			if rime.vitals.dithering > 0 then return false end
			if rime.pvp.has_aff("besilence", target) then return false end
			if rime.pvp.has_aff("deadening", target) then return false end
			if rime.targets[target].globes == 0 then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["hiltblow"] = {
		command = "hiltblow target",
		can = function()
			local target = rime.target
			if rime.bard.rhythm_stage then return false end
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_def("shielded", target) then return false end
			if rime.pvp.has_aff("clumsiness", target) then return false end
			if rime.pvp.has_aff("misery", target) then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["ridicule"] = {
		command = "ridicule target",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("self_loathing", target) then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["quip"] = {
		command = "quip target",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("hatred", target) then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["crackshot"] = {
		command = "crackshot target",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("perplexed", target) then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["effigy"] = {
		command = "weave effigy target",
		can = function()
			local target = rime.target
			if rime.vitals.dithering > 0 then return false end
			if not rime.pvp.room.boundary then return false end
			if rime.targets[target].effigy then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["swindle_dizziness"] = {
		command = "weave swindle target",
		can = function()
			local target = rime.target
			if rime.vitals.dithering > 0 then return false end
			if rime.pvp.has_aff("dizziness", target) then return false end
			if rime.targets[target].globes ~= 3 then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["swindle_confusion"] = {
		command = "weave swindle target",
		can = function()
			local target = rime.target
			if rime.vitals.dithering > 0 then return false end
			if rime.pvp.has_aff("confusion", target) then return false end
			if rime.targets[target].globes ~= 2 then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["swindle_perplexed"] = {
		command = "weave swindle target",
		can = function()
			local target = rime.target
			if rime.vitals.dithering > 0 then return false end
			if rime.pvp.has_aff("perplexed", target) then return false end
			if rime.targets[target].globes ~= 1 then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["bravado"] = {
		command = "bravado target venom",
		can = function()
			local target = rime.target
			if not rime.curing.class then return false end
			if rime.bard.rhythm_stage then return false end
			if rime.pvp.has_def("rebounding", target) then return false end
			if rime.pvp.has_aff("shielded", target) then return false end
			return rime.bard.bravado()
		end,
		combo = function()
			return false
		end,
	},

	["ironcollar"] = {
		command = "weave ironcollar target",
		can = function()
			local target = rime.target
			local eucrasia_affs = {"misery", "narcolepsy", "hollow",}
			local eucrasia_count = 0
			if not rime.pvp.has_aff("perplexed", target) then return false end
			if rime.targets[target].ironcollar == "closed" then return false end
			for k,v in ipairs(eucrasia_affs) do
				if rime.pvp.has_aff(v, target) then
					eucrasia_count = eucrasia_count+1
				end
			end
			if eucrasia_count < 1 then return false end
			if rime.vitals.dithering > 0 then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["locked_collar"] = {
		command = "weave ironcollar target",
		can = function()
			local target = rime.target
			local eucrasia_affs = {"misery", "narcolepsy", "hollow",}
			local eucrasia_count = 0
			if not rime.pvp.has_aff("perplexed", target) then return false end
			if rime.targets[target].ironcollar == "closed" then return false end
			if rime.vitals.dithering > 0 then return false end
			if not rime.pvp.has_aff("locked", target) then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["rebounding"] = {
		command = "pierce target",
		can = function()
			local target = rime.target
			if not rime.pvp.has_def("rebounding", target) then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["push_selfloathing"] = {
		command = "ridicule target",
		can = function()
			local target = rime.target
			if not rime.targets[target].ironcollar then return false end
			if rime.pvp.has_aff("self_loathing", target) then return false end
			if rime.pvp.count_affs() < 3 then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["heartcage"] = {
		command = "weave heartcage target",
		can = function()
			local target = rime.target
			if not rime.pvp.has_aff("prone", target) then return false end
			if not rime.targets[target].ironcollar then return false end
			if rime.bard.emotion(target) < 50 then return false end
			if rime.vitals.dithering > 0 then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["break_locket"] = {
		command = "break heartcage",
		can = function()
			if rime.bard.heartcage then return true else return false end
		end,
		combo = function()
			return false
		end,
	},

	["push_besilence"] = {
		command = "weave headstitch target",
		can = function()
			local target = rime.target
			if not rime.pvp.has_aff("asthma", target) then return false end
			if not rime.pvp.has_aff("clumsiness", target) then return false end
			if not rime.pvp.has_aff("weariness", target) then return false end
			if rime.pvp.has_aff("besilence", target) then return false end
			if rime.vitals.dithering > 0 then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["stab_anelace"] = {
		command = "quickwield right anelace" .. rime.saved.separator .. "stab target",
		can = function()
			local target = rime.target
			if rime.bard.anelace == 0 then return false end
			if rime.pvp.has_aff("hollow", target) then return false end
			if rime.pvp.has_aff("narcolepsy", target) then return false end
			if rime.targets[target].emotions.induced ~= "happiness" then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["lock_besilence"] = {
		command = "weave headstitch target",
		can = function()
			local target = rime.target
			if not rime.pvp.has_aff("anorexia", target) then return false end
			if not rime.pvp.has_aff("slickness", target) then return false end
			if not rime.pvp.has_aff("asthma", target) then return false end
			if rime.pvp.has_aff("besilence", target) then return false end
			if rime.vitals.dithering > 0 then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["push_tempo"] = {
		command = "tempo target venom",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("rebounding", target) then return false end
			if not rime.pvp.has_aff("asthma", target) then return false end
			if not rime.pvp.has_aff("clumsiness", target) then return false end
			if rime.bard.rhythm_stage then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["impetus"] = {
		command = "weave impetus",
		can = function()
			local target = rime.target
			if not rime.pvp.has_aff("asthma", target) then return false end
			if not rime.pvp.has_aff("slickness", target) then return false end
			if not rime.pvp.has_aff("anorexia", target) then return false end
			if not rime.pvp.has_aff("besilence", target) then return false end
			if not rime.pvp.has_aff("shyness", target) then return false end
			if rime.pvp.has_aff("blackstar", target) then return false end
			if rime.pvp.has_aff("paresis", target) or rime.pvp.has_aff("paralysis", target) then
				return true
			end
		end,
		combo = function()
			return false
		end,
	},

	["cadence"] = {
		command = "cadence target",
		can = function()
			local target = rime.target
			if not rime.pvp.has_aff("blackstar", target) then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["lovers_effect"] = {
		command = "seduce target",
		can = function()
			local target = rime.target
			if rime.targets[target].emotions.induced ~= "happiness" then return false end
			if rime.pvp.has_aff("lovers_effect", target) then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},

	["dazed"] = {
		command = "sock target",
		can = function()
			local target = rime.target
			if not rime.pvp.has_aff("dizziness", target) then return false end
			return rime.bard.sock()
		end,
		combo = function()
			return false
		end,
	},

	["image"] = {
		command = "weave image",
		can = function()
			local target = rime.target
			if not rime.targets[target].fate then return false end
			local room = gmcp.Room.Players
			local found_me = false
			for k,v in ipairs(room) do
				if room[k].name == gmcp.Char.Status.name then
					found_me = true
				end
			end
			if found_me then return false end
			if rime.vitals.dithering > 0 then return false end
			if rime.targets[target].ironcollar ~= "closed" then return false end
			return true
		end,
		combo = function()
			return false
		end,
	},


}

function rime.bard.get_attack()

	local attack_one = false
	local attack_two = false
	local sep = rime.saved.separator
	local attack = "nothing"

	for k,v in ipairs(rime.pvp.route.attacks) do
		if rime.bard.attacks[v] == nil then rime.echo(v.." is not defined in the offense.") end
		if rime.bard.attacks[v].can() then
			if rime.bard.attacks[v].combo() then
				attack_one = rime.bard.attacks[v].command
				--rime.echo("attack one has been set to "..v)
				break
			else
				attack_two = rime.bard.attacks[v].command
				--rime.echo("attack two has been set to "..v)
				break
			end
		end
	end

	if attack_one then
		for k,v in ipairs(rime.pvp.route.attacks) do
			if rime.bard.attacks[v].can() and rime.bard.attacks[v].command ~= attack_one then
				--rime.echo("attack two was actually set right here I guess, to "..v)
				attack_two = rime.bard.attacks[v].command
				break
			end
		end
	end

	if attack_one then

		attack = attack_one .. sep .. attack_two

		if attack:find("ally") and rime.bard.audience ~= rime.pvp.pick_ally("aggro") then
			attack = "audience ally"
		end

		attack = attack:gsub("ally", rime.pvp.pick_ally("aggro"))

		return attack:gsub("target", rime.target):gsub("venom", rime.bard.venom_filter())

	elseif attack_two then

		attack = attack_two

		if attack:find("ally") and rime.bard.audience ~= rime.pvp.pick_ally("aggro") then
			attack = "audience ally"
		end

		attack = attack:gsub("ally", rime.pvp.pick_ally("aggro"))

		return attack:gsub("target", rime.target):gsub("venom", rime.bard.venom_filter())
	end

	if not attack_one and not attack_two then
		rime.echo("Lmao")
		return "tempo "..rime.target.." curare"
	end

end

function rime.bard.instrument_check()

	for k,v in ipairs(rime.bard.instruments) do
		if rime.vitals.wielded_left:find(v) then
			return true
		end
	end

	return false

end

function rime.bard.wield_juggle()

	local command = rime.bard.get_attack()
	local sep = rime.saved.separator

	if command:find("weave") then
		if rime.bard.instrument_check() then
			return sep .. "secure right" .. sep
		else
			return sep .. "secure left" .. sep .. "unwield left" .. sep
		end
	elseif not rime.vitals.wielded_right:find(rime.saved.bard_weapon) then
		return sep .. "secure right" .. sep .."unwield right" .. sep .. "quickwield right "..rime.saved.bard_weapon .. sep
	end

	return ""

end

function rime.bard.offense()

	local target = rime.target
	local sep = rime.saved.separator
	local pre_command = rime.pvp.queue_handle() .. sep .. "coldread "..target
	local attack = rime.bard.get_attack()
	local rhythm
	local induce = rime.bard.induce(target)
	local command = ""
	local web_call = ""

	if rime.bard.singing or rime.bard.playing then
		pre_command = pre_command .. sep .. induce
	end
	if has_def("euphonia") and rime.bard.inspire then
		pre_command = pre_command .. sep .. "inspire"
	end
	if attack:find("youth") or attack:find("patchwork") then
		if rime.bard.audience ~= rime.pvp.pick_ally("aggro") then
			attack = "audience "..rime.pvp.pick_ally("aggro") .. sep .. attack
		end
	end
	pre_command = pre_command .. rime.bard.wield_juggle()
	if (rime.vitals.wielded_left:find("thurible") or rime.vitals.wielded_right:find("thurible")) and attack:find("weave") then
		pre_command = pre_command .. sep .. "unwield thurible" .. sep .. "drop thurible"
	end

	if attack:find("tempo") or attack:find("bravado") then
		if rime.pvp.web_aff_calling then
			web_call = "wt afflicting "..rime.target..": "..rime.bard.venom_filter()
			rhythm = "wipe "..rime.bard.weapon_hand..sep.."envenom "..rime.bard.weapon_hand.." with "..rime.bard.rhythm_envenom()
			command = pre_command .. sep .. web_call .. sep .. attack .. sep .. rhythm
		else
			rhythm = "wipe "..rime.bard.weapon_hand..sep.."envenom "..rime.bard.weapon_hand.." with "..rime.bard.rhythm_envenom()
			command = pre_command .. sep .. attack .. sep .. rhythm
		end
	else
		command = pre_command .. sep .. attack
	end

	if command ~= rime.balance_queue and command ~= rime.balance_queue_attempted then
		act(command)
	end


	--if rime.bard.audience ~= rime.pvp.ally then
		--act("audience "..rime.pvp.ally)
	--end

end