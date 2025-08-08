rime.attacks = rime.attacks or {}
rime.attacks.personal = false

rime.attacks = {

	--#Predators

	["Knifeplay"] = {},

	["Predation"] = {},

	["Beastmastery"] = {},

	--#Bards

	["Performance"] = {

		Rouse = function(target)
			return
		end,

		Guilt = function()
			return
		end,

		Seduce = function(target)
			if target == "you" then
				act("wear " .. rime.class_armor())
			else
				rime.targets[target].armored = false
			end
		end,

		Needle = function(target, venom)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			if venom == "miss" then
				rime.add_aff("clumsiness")
			end
			if rime.attacks.personal then
				if venom and venom ~= "dodge" and venom ~= "miss" then
					rime.targets[target].needle = venom
				elseif not venom then
					rime.targets[target].needle = true
					rime.bard.needle = false
				end
			end
		end,

		Tempo = function(target)
			rime.pvp.aggro(target)
			rime.last_hit = target
			rime.pvp.web_venoms()
			rime.last_hit = target
			if rime.attacks.personal then
				rime.bard.rhythm_stage = "tempo"
			end
		end,

		Unwind = function()
			return
		end,

		Rhythm = function(target, stage)
			rime.pvp.aggro(target)
			rime.last_hit = target
			rime.pvp.ignore_rebounding = true
			if rime.attacks.personal then
				rime.bard.rhythm_stage = stage
			end
		end,

		Deflect = function(target)
			rime.echo("YOU'RE GONNA HIT " .. target .. " INSTEAD.")
		end,

		Quip = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("hatred", target)
		end,

		Mundane = function(target)
			rime.echo("O mai")
		end,

		Tackle = function(target)
			rime.pvp.add_aff("prone", target)
		end,

		Sock = function(target)
			rime.pvp.aggro(target)
			if not rime.pvp.has_aff("dizziness", target) then
				rime.pvp.add_aff("dizziness", target)
			else
				rime.pvp.add_aff("dazed", target)
			end
		end,

		Ridicule = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("self_loathing", target)
		end,

		Hiltblow = function(target)
			rime.pvp.aggro(target)
			rime.last_hit = target
			rime.pvp.last_attack = "hiltblow"
			rime.pvp.add_aff("clumsiness", target)
			rime.pvp.add_aff("misery", target)
		end,

		Whistle = function(target)
			if target ~= "You" then
				rime.echo("<red>" .. target .. "<white> is moving guards!")
			end
		end,

		Crackshot = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("dizziness", target)
			rime.pvp.add_aff("perplexed", target)
		end,

		Pierce = function(target, what)
			rime.pvp.aggro(target)
			if what == "rebounding" then
				rime.pvp.noDef("rebounding", target)
				rime.pvp.noDef("shielded", target)
			elseif what == "shield" then
				rime.pvp.noDef("shielded", target)
			elseif what == "speed" then
				rime.pvp.noDef("rebounding", target)
				rime.pvp.noDef("shielded", target)
			elseif what == "failure" then
				rime.pvp.noDef("rebounding", target)
				rime.pvp.noDef("shielded", target)
			end
		end,

		Bravado = function(target)
			rime.pvp.aggro(target)
			rime.last_hit = target
			if rime.attacks.personal then
				rime.curing.class = false
			end
		end,

		Cadence = function(target)
			if target == "you" then
				return
			end
			if rime.pvp.has_aff("blackstar", target) then
				rime.echo("RIP THIS MANS")
			end
		end,
	},

	["Weaving"] = {

		Sheath = function(target)
			--add sheathe def
		end,

		Tearing = function(target)
			return
		end,

		Starfall = function(target)
			return
		end,

		Facsimile = function(target, item)
			rime.echo("Oooh, a " .. item)
		end,

		Image = function(target)
			return
		end,

		Nullstone = function(target)
			return
		end,

		Swindle = function(target)
			rime.pvp.aggro(target)
		end,

		Headstitch = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("besilence", target)
			rime.pvp.add_aff("deadening", target)
		end,

		Anelace = function(target, stab)
			if stab then
				rime.pvp.aggro(target)
				rime.pvp.add_aff("hollow", target)
				rime.pvp.add_aff("narcolepsy", target)
				rime.last_hit = target
				rime.pvp.last_attack = "anelace"
				if rime.attacks.personal then
					rime.bard.anelace = rime.bard.anelace - 1
				end
			elseif target == "You" then
				rime.bard.need_anelace = false
				rime.bard.anelace = rime.bard.anelace + 1
				if rime.bard.anelace > 2 then
					rime.bard.anelace = 2
				end
			end
		end,

		Impetus = function(lmaowhofuckingknows)
			if rime.attacks.personal then
				rime.bard.blackstar = true
			end
		end,

		Globes = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.targets[target].globes = 3
			rime.targets[target].globes_affcount = 0
		end,

		Alteration = function()
			return
		end,

		Barbs = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("manabarbs", target)
		end,

		Goblet = function(target)
			return
		end,

		Boundary = function(target)
			rime.pvp.room.boundary = true
		end,

		Thurible = function(target)
			rime.echo("NOBODY MOVE THEY'VE GOT A BOMB!")
			if target == "You" then
				rime.bard.thurible = true
			end
			return
		end,

		Polarity = function(target)
			return
		end,

		Effigy = function(target)
			rime.targets[target].effigy = true
		end,

		Runeband = function(target)
			if target == "you" then
				return
			end
			rime.pvp.add_aff("runeband", target)
			rime.pvp.aggro(target)
			rime.targets[target].runeband = "normal"
			rime.targets[target].runeband_next = 1
		end,

		Bladestorm = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.targets[target].bladestorm = 3
			if rime.targets[target].runeband == "normal" then
				rime.targets[target].runeband = "reversed"
				rime.echo("Runeband has been reversed for <red>" .. target .. "<white>.")
			elseif rime.targets[target].runeband == "reversed" then
				rime.targets[target].runeband = "normal"
				rime.echo("Runeband has been restored to normal for <red>" .. target .. "<white>.")
			end
		end,

		Ironcollar = function(target)
			if target == "you" then
				act("remove ironcollar")
				return
			end
			if rime.attacks.personal then
			end
			rime.pvp.aggro(target)
			rime.targets[target].ironcollar = "open"
			if rime.targets[target].runeband == "normal" then
				rime.targets[target].runeband = "reversed"
				rime.echo("Runeband has been reversed for <red>" .. target .. "<white>.")
			elseif rime.targets[target].runeband == "reversed" then
				rime.targets[target].runeband = "normal"
				rime.echo("Runeband has been restored to normal for <red>" .. target .. "<white>.")
			end
		end,

		Heartcage = function(target, stage)
			rime.echo("RIP THIS MANS")
			if rime.attacks.personal then
				if stage == "end" then
					rime.echo("YO KILL THIS FOOL!!")
					rime.echo("YO KILL THIS FOOL!!")
					rime.echo("YO KILL THIS FOOL!!")
					rime.echo("YO KILL THIS FOOL!!")
					rime.echo("YO KILL THIS FOOL!!")
					rime.echo("YO KILL THIS FOOL!!")
				end
			end
		end,

		Patchwork = function(target)
			rime.echo("Get this person a fucking medal.")
			rime.targets[target].aggro = rime.targets[target].aggro - 1
		end,

		Soundblast = function(target)
			for k, v in ipairs(gmcp.Room.Players) do
				rime.pvp.add_aff("no_deaf", v.name)
				rime.pvp.add_aff("ringing_ears", v.name)
			end
		end,

		Mindbreak = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("migraine", target)
			rime.pvp.add_aff("squelched", target)
		end,

		Aurora = function(target)
			return
		end,

		Scatter = function(target, thing)
			return
		end,

		Horologe = function(target)
			return
		end,

		Talisman = function(target)
			return
		end,
	},

	["Songcalling"] = {

		Sorrow = function(target, play)
			if target == "You" then
				if play then
					rime.bard.play("sorrow")
				else
					rime.bard.sing("sorrow")
				end
			end
		end,

		Inspire = function(target, play)
			if rime.attacks.personal then
				rime.bard.inspire = false
			end
		end,

		Origin = function(target, play)
			if target == "You" then
				if play then
					rime.bard.play("origin")
				else
					rime.bard.sing("origin")
				end
			end
		end,

		Charity = function(target, play)
			if target == "You" then
				if play then
					rime.bard.play("charity")
				else
					rime.bard.sing("charity")
				end
			end
		end,

		Fascination = function(target, play)
			if target == "You" then
				if play then
					rime.bard.play("fascination")
				else
					rime.bard.sing("fascination")
				end
			end
		end,

		Feasting = function(target, play)
			if target == "You" then
				if play then
					rime.bard.play("feasting")
				else
					rime.bard.sing("feasting")
				end
			end
		end,

		Fate = function(target, play)
			if target == "You" then
				if play then
					rime.bard.play("fate")
				else
					rime.bard.sing("fate")
				end
			end
		end,

		Tranquility = function(target, play)
			if target == "You" then
				if play then
					rime.bard.play("tranquility")
				else
					rime.bard.sing("tranquility")
				end
			end
		end,

		Merriment = function(target, play)
			if target == "You" then
				if play then
					rime.bard.play("tranquility")
				else
					rime.bard.sing("tranquility")
				end
			end
		end,

		Doom = function(target, play)
			if target == "You" then
				if play then
					rime.bard.play("doom")
				else
					rime.bard.sing("doom")
				end
			end
		end,

		Mythics = function(target, play)
			if target == "You" then
				if play then
					rime.bard.play("mythics")
				else
					rime.bard.sing("mythics")
				end
			end
		end,

		Foundation = function(target, play)
			if target == "You" then
				if play then
					rime.bard.play("foundation")
				else
					rime.bard.sing("foundation")
				end
			end
		end,

		Harmony = function(target, play)
			if target == "You" then
				if play then
					rime.bard.play("harmony")
				else
					rime.bard.sing("harmony")
				end
			end
		end,

		Youth = function(target, play)
			if target == "You" then
				if play then
					rime.bard.play("youth")
				else
					rime.bard.sing("youth")
				end
			end
		end,

		Awakening = function(target, play)
			if target == "You" then
				if play then
					rime.bard.play("awakening")
				else
					rime.bard.sing("awakening")
				end
			end
		end,

		Hero = function(target, play)
			if target == "You" then
				if play then
					rime.bard.play("hero")
				else
					rime.bard.sing("hero")
				end
			end
		end,

		Remembrance = function(target, play)
			if target == "You" then
				if play then
					rime.bard.play("remembrance")
				else
					rime.bard.sing("remembrance")
				end
			end
		end,

		Destiny = function(target, play)
			if target == "You" then
				if play then
					rime.bard.play("destiny")
				else
					rime.bard.sing("destiny")
				end
			end
		end,

		Induce = function(target, emotion)
			if target == "you" then
				return
			end
			rime.targets[target].emotions.induced = emotion
			rime.echo("<dark_olive_green>" .. emotion .. "<white> induced on <red>" .. target)
		end,

		Oblivion = function(target, play)
			rime.echo("YOU BETTER FUCKING KILL THIS MOTHER FUCKER. TARGET " .. string.upper(target))
			if target == "You" then
				if play then
					rime.bard.play("oblivion")
				else
					rime.bard.sing("oblivion")
				end
			end
		end,

		Decadence = function(target, play)
			if target == "You" then
				if play then
					rime.bard.play("decadence")
				else
					rime.bard.sing("decadence")
				end
			end
		end,

		Unheard = function(target, play)
			if target == "You" then
				if play then
					rime.bard.play("unheard")
				else
					rime.bard.sing("unheard")
				end
			end
		end,
	},

	--#Bloodborn
	["Esoterica"] = {
		Geminate = function(target)
            rime.pvp.addDef("reflection", target)
            if rime.attacks.personal then
            	rime.bloodborn.geminate_charge = rime.bloodborn.geminate_charge-1
            	rime.echo("Lost a charge for Geminate, down to "..rime.bloodborn.geminate_charge, "pvp")
            end
		end,

        Forestall = function(target)
            return
        end,

        Panoply = function(target)
            return
        end,

        Ascend = function(target)
            return
        end,

        Besmirch = function(target)
            return
        end,

        Indulge = function(target)
            return
        end,

        Victimise = function(target, state)
            return
        end,

        Proscribe = function(target)
            return
        end,

        Replicate = function(target)
            return
        end,

        Acumen = function(target)
            return
        end,

        Ensorcell = function(target)
            return
        end,

        Alluvion = function(target)
            return
        end,

        Enthrall = function(target, state)
            if state == "blindness" then
            	rime.pvp.add_aff("no_blind", target)
            else
            	rime.pvp.add_aff("no_blind", target)
            	rime.pvp.add_aff("writhe_transfix", target)
            end
        end,

        Blear = function(target)
            rime.pvp.room.mirage = true
            rime.echo("MIRAGE IS UP MIRAGE IS UP MIRAGE IS UP")
            rime.echo("MIRAGE IS UP MIRAGE IS UP MIRAGE IS UP")
        end,

        Rune = function(target)
            return
        end,

        Portal = function(target)
        	return
        end,

        Triplicate = function(target)
        	local trip_routes = {"group", "blue"}
        	if rime.attacks.personal then
        		if table.contains(trip_routes, rime.pvp.route_choice) then
        			rime.bloodborn.triplicate = false
        			rime.bloodborn.triple_count = 0
        		end
        	end
        end,

	},

	["Humourism"] = {

		Prowess = function(target)
			if target == "You" then
				rime.bloodborn.prowess = true
			end
		end,

		Boil = function(target, state)
			rime.pvp.aggro(target)
			if state == "Normal" then
				if rime.pvp.has_aff("ablaze", target) then
  					rime.pvp.add_stack("ablaze", target, 1)  
  				end
				rime.pvp.add_aff("ablaze", target)
			elseif state == "Phlegm" then
				rime.pvp.add_aff("blisters", target)
			end
		end,

        Disgorge = function(target, aspect, limb)
            local hit_limb = limb:gsub(" ", "_")
            rime.pvp.aggro(target)
            if rime.pvp.has_aff("ablaze", target) then
                  rime.pvp.add_stack("ablaze", target, 1)
              end
            if aspect == "Yellow" and limb ~= nil then
                if rime.pvp.has_aff("corroded_limb", target) then
                    rime.pvp.add_limb(limb, target, 1200)
                else
                    rime.pvp.add_aff("corroded_limb", target)
                    corrodedLimbTimer = tempTimer(30, [[rime.pvp.remove_aff("corroded_limb", target)]])
                    rime.targets[target].corroded_limb = hit_limb
                    rime.pvp.add_limb(limb, target, 1200)
                end
               elseif aspect == "Normal" and limb ~= nil then
                   rime.pvp.add_limb(limb, target, 1200)
            elseif aspect == "Phlegm" and limb ~= nil then
                rime.pvp.add_limb(limb, target, 1400)
            end
        end,

		Broil = function(target, aspect, limb)
			rime.pvp.aggro(target)
			if rime.pvp.has_aff("ablaze", target) then
				rime.pvp.add_stack("ablaze", target, 1)
			end
			if rime.pvp.has_aff("excess_choleric", target) then
				rime.pvp.add_aff("ablaze", target)
			end
			if rime.pvp.has_aff("ablaze", target) then
				if limb == "Arms" then
					rime.pvp.add_aff("left_arm_crippled", target)
					rime.pvp.add_aff("right_arm_crippled", target)
				elseif limb == "Legs" then
					rime.pvp.add_aff("left_leg_crippled", target)
					rime.pvp.add_aff("right_leg_crippled", target)
				end
			end
			if aspect == "Black" then
				rime.pvp.add_aff("asthma", target)
			elseif aspect == "Phlegm" then
				rime.pvp.add_aff("slickness", target)
			end
		end,

		Parch = function(target)
			return
		end,

		Retch = function(target)
			rime.pvp.aggro(target)
			if rime.pvp.has_aff("ablaze", target) then
  				rime.pvp.add_stack("ablaze", target, 1)
  			end
		end,

		Smother = function(target)
			rime.pvp.aggro(target)
			if rime.pvp.has_aff("ablaze", target) then
				rime.pvp.remove_aff("ablaze", target)
				rime.pvp.add_aff("excess_choleric", target)
			end
		end,

		Brimstone = function(target)
			return
		end,

		Swathe = function(target, aspect)
			if aspect == "Normal" then
				rime.pvp.add_aff("dizziness", target)
			elseif aspect == "Black" then
				rime.pvp.add_aff("lethargy", target)
				rime.pvp.add_aff("caloric", target)
				if rime.pvp.has_aff("prone", target) then
					rime.pvp.add_aff("confusion", target)
				end
			end
		end,

		Mist = function(target)
			return
		end,

		Uprising = function(target)
			if rime.attacks.personal then
				rime.bloodborn.can_uprising = false
			end
		end,

		Brainfreeze = function(target, aspect)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("stupidity", target)
			if aspect == "Yellow" then
				rime.pvp.add_aff("recklessness", target)
			elseif aspect == "Black" then
				rime.pvp.add_aff("masochism", target)
			end
		end,

		Revulsion = function(target, aspect, pill)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("gorged", target)
			rime.targets[target].gorged = pill
			if aspect == "Yellow" then
				if not rime.pvp.has_aff("anorexia", target) then
					rime.pvp.add_aff("anorexia", target)
				end
			elseif aspect == "Black" then
				if not rime.pvp.has_aff("indifference", target) then
					rime.pvp.add_aff("indifference", target)
				end
			end
		end,

		Perforate = function(target)
			rime.pvp.aggro(target)
		end,

		Flense = function(target, aspect, venom)
			rime.pvp.aggro(target)
			if aspect == "Phlegm" then
				rime.pvp.add_aff("hypothermia", target)
			end
			venom = rime.convert_venom(venom)
			rime.pvp.add_aff(venom, target)
		end,

		Obliteration = function(target)
			return
		end,

		Overflow = function(target)
			return
		end,

		Dissemble = function(target)
			rime.pvp.room.phenomena = "dissemble"
		end,

		Revolt = function(target)
			return
		end,

		Oppress = function(target)
			return
		end,

		Befoul = function(target, aspect)
			rime.pvp.aggro(target)
			rime.pvp.noDef("shielded", target)
			if not rime.pvp.has_def("shielded", target) then
				rime.pvp.add_aff("prone", target)
			end
			if aspect == "Black" then
				if not rime.pvp.has_aff("clumsiness", target) then
					rime.pvp.add_aff("clumsiness", target)
				elseif rime.pvp.has_aff("clumsiness", target) and not rime.pvp.has_aff("dizziness", target) then
					rime.pvp.add_aff("dizziness", target)
				elseif rime.pvp.has_aff("clumsiness", target) and rime.pvp.has_aff("dizziness", target) and not rime.pvp.has_aff("dissonance", target) then
					rime.pvp.add_aff("dissonance", target)
				end
			end
		end,

		Equilibrium = function(target, aspect)
			rime.pvp.aggro(target)
			if not rime.pvp.has_aff("vertigo", target) then
				rime.pvp.add_aff("vertigo", target)
			elseif not rime.pvp.has_aff("confusion", target) then
				rime.pvp.add_aff("confusion", target)
			end
			if aspect == "Phlegm" and not rime.pvp.has_aff("weariness", target) then
				rime.pvp.add_aff("weariness", target)
			end
			if aspect == "Yellow" and not rime.pvp.has_aff("clumsiness", target) then
				if rime.pvp.has_aff("ablaze", target) then
					rime.pvp.add_stack("ablaze", target, 1)
				end
				rime.pvp.add_aff("clumsiness", target)
			end
		end,

		Synapse = function(target, aspect)
			rime.pvp.aggro(target)
			if not rime.pvp.has_aff("paresis", target) then
				rime.pvp.add_aff("paresis", target)
			end
			if aspect == "Phlegm" and not rime.pvp.has_aff("epilepsy", target) then
				rime.pvp.add_aff("epilepsy", target)
			end
			if aspect == "Yellow" and not rime.pvp.has_aff("vertigo", target) then
				rime.pvp.add_aff("vertigo", target)
			end
		end,

		Stupor = function(target)
			rime.pvp.aggro(target)
			if rime.pvp.has_aff("dizziness") and rime.pvp.has_aff("stupidity") and rime.pvp.mental_count(target) >= 3 then
				rime.pvp.add_aff("excess_melancholic")
			end
			if not rime.pvp.has_aff("dizziness", target) then
				rime.pvp.add_aff("dizziness", target)
			end
			if not rime.pvp.has_aff("stupidity", target) then
				rime.pvp.add_aff("stupidity", target)
			end
		end,

		Plunge = function(target, aspect)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("caloric", target)
			if aspect == "Yellow" then
				rime.pvp.add_aff("sensitivity", target)
			end
			if aspect == "Phlegm" then
				rime.pvp.add_aff("caloric", target)
			end
		end,

		Frostbite = function(target, state)
			rime.pvp.aggro(target)
			if state == "failure" then
				return
			end
			if not rime.pvp.has_def("insulation", target) then
				rime.pvp.add_aff("frostbite", target)
				rime.bloodborn.frostbite_need = false
				frostbiteTimer = tempTimer(60, [[rime.pvp.remove_aff("frostbite", target)]])
			end
		end,


		Traumatize = function(target)
			return
		end,

		Tumult = function(target)
			rime.pvp.room.phenomena = "tumult"
		end,

	},

	["Hematurgy"] = {

        Draw = function(target)
            return
        end,

        Ablate = function(target)
            return
        end,

        Saturate = function(target, state)
            return
        end,

        Resurface = function(target)
            return
        end,

        Materialise = function(target)
            return
        end,

        Aspects = function(target)
            return
        end,

        Seep = function(target)
            return
        end,

        Circulate = function(target)
            return
        end,

        Forewarn = function(target)
            return
        end,

        Tendril = function(target, state)
            return
        end,

        Thrombosis = function(target, state)
            return
        end,

        Descry = function(target)
            return
        end,

        Vein = function(target)
            return
        end,

        Imbrue = function(target, state)
        	if rime.attacks.personal then
        		rime.bloodborn.imbrue = true
        	end
        end,

        Pulsate = function(target)
            return
        end,

        Contaminate = function(target)
            return
        end,

        Transfuse = function(target)
            return
        end,

        Arrhythmia = function(target)
            return
        end,

        Profane = function(target)
            if rime.attacks.personal then
            	rime.bloodborn.profane = true
            end
        end,

        Congeal = function(target)
            return
        end,

        Suffocate = function(target)
        	if rime.attacks.personal then
            	rime.bloodborn.suffocate = true
            end
        end,

        Immerge = function(target)
            if rime.attacks.personal then
                rime.bloodborn.can_immerge = false
            end
            if rime.target == target then
                act("wt TARGET HAS SHIFTED PICK A NEW TARGET PLEASE")
            end
        end,

        Primacy = function(target)
            return
        end,

        Fetter = function (target, state)
            return
        end,
		
        Palpitate = function(target)
            if rime.attacks.personal then
                if rime.bloodborn.imbrue then
                    if rime.pvp.has_aff("frozen", target) then
                        rime.pvp.add_aff("prone", target)
                    end
                    if rime.pvp.has_aff("hypothermia", target) then
                    	rime.pvp.add_aff("caloric", target)
                    else
                    	rime.pvp.add_aff("hypothermia", target)
                    end
                end
                if rime.bloodborn.suffocate then
                    if rime.pvp.has_aff("vertigo", target) then
                        rime.pvp.add_aff("muddled", target)
                     else
                        rime.pvp.add_aff("vertigo", target)
                    end
                end
                if rime.bloodborn.profane then
                    if rime.pvp.has_aff("ablaze") then
                        rime.pvp.add_stack("ablaze", target, 1)
                    else
                        rime.pvp.add_aff("ablaze")
                    end
                end
            end
        end,

        Permeate = function(target, stage)
			if target == "you" then
				if stage == "start" then
					rime.echo(matches[2]:upper() .. " IS PERMEATING THE ABSOLUTE MAD PERSON")
					rime.pvp.aggro(target)
				elseif stage == "mid" then
					rime.echo(
						"YOU'RE BEING PERMEATED BY <red>" .. matches[2]:upper() .. "<white> BITCH PAY ATTENTION",
						"pvp"
					)
					rime.echo(
						"YOU'RE BEING PERMEATED BY <red>" .. matches[2]:upper() .. "<white> BITCH PAY ATTENTION",
						"pvp"
					)
					rime.echo(
						"YOU'RE BEING PERMEATED BY <red>" .. matches[2]:upper() .. "<white> BITCH PAY ATTENTION",
						"pvp"
					)
					rime.pvp.aggro(target)
				else
					rime.echo("I can't believe you let them do this to you, smh", "pvp")
				end
			else
				if stage == "start" then
					if target ~= "You" then
						rime.echo(target .. " being permeated by " .. matches[2], "pvp")
					end
					rime.pvp.aggro(target)
				elseif stage == "mid" then
					if target ~= "You" then
						rime.echo(target .. " being permeated by " .. matches[2], "pvp")
					end
					rime.pvp.aggro(target)
				else
					if rime.attacks.personal and target ~= "You" then
						expandAlias("dab")
						rime.paused = false
						rime.pvp.aggro(target, "reset")
					else
						rime.echo(
							matches[2]:upper() .. " PERMEATED " .. target:upper() .. " THE ABSOLUTE MAD PERSON",
							"pvp"
						)
						rime.pvp.aggro(target, "reset")
					end
				end
			end
		end,

	},

	--#Carnifex
	["Savagery"] = {

		Hammerthrow = function(target)
			return
		end,

		Hack = function(target)
			rime.pvp.aggro(target)
			rime.last_hit = target
		end,

		Skewer = function(target, fail_check)
			if not fail_check then
				rime.pvp.add_aff("writhe_impaled", target)
				rime.pvp.add_limb("torso", target, 1249)
				rime.pvp.aggro(target)
				if rime.attacks.personal then
					targetImpaled = true
				end
			else
				rime.pvp.remove_aff("prone", target)
				rime.pvp.remove_aff("paralysis", target)
				rime.pvp.remove_aff("frozen", target)
				rime.pvp.remove_aff("indifference", target)
				rime.pvp.remove_aff("writhe_web", target)
				rime.pvp.remove_aff("writhe_transfix", target)
			end
			if target == rime.target then
				rime.pvp.target_tumbling = false
			end
		end,

		Wrench = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_limb("torso", target, 1249)
			if rime.attacks.personal then
				targetImpaled = true
			end
		end,

		Hook = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("prone", target)
		end,

		Spinning = function(target)
			rime.pvp.aggro(target)
			rime.last_hit = target
			--rime.pvp.web_venoms()
		end,

		Carve = function(target)
			rime.pvp.aggro(target)
			rime.last_hit = target
			rime.pvp.web_venoms()
		end,

		Reveling = function(target)
			--add def here
		end,

		Furor = function(target)
			--add def here
		end,

		Batter = function(target)
			rime.pvp.aggro(target)
			return
		end,

		Sweep = function(user)
			return
		end,

		Bruteforce = function(target)
			return
		end,

		Gutcheck = function(target)
			rime.pvp.aggro(target)
			if rime.attacks.personal then
				rime.pvp.add_limb("torso", target, 1469)
			else
				rime.pvp.add_limb("torso", target, 1400)
			end
			rime.last_hit = target
			lastLimbHit = "torso"
			rime.time("gutcheck", target)
			if target == rime.target then
				gutcheckHit = true
			end
		end,

		Charging = function(target)
			if rime.attacks.personal then
				carn.need_charge = false
			end
		end,

		Razehack = function(target, what)
			rime.pvp.aggro(target)
			rime.last_hit = target
			--rime.pvp.web_venoms()
			if what == "shield" then
				rime.pvp.noDef("shielded", target)
			elseif what == "rebounding" then
				rime.pvp.noDef("shielded", target)
				rime.pvp.noDef("rebounding", target)
			elseif what == "speed" or what == "failure" then
				rime.pvp.noDef("shielded", target)
				rime.pvp.noDef("rebounding", target)
				rime.pvp.noDef("speed", target)
			end
		end,

		Raze = function(target, what)
			rime.pvp.aggro(target)
			rime.last_hit = target
			if what == "shield" then
				rime.pvp.noDef("shielded", target)
			elseif what == "rebounding" then
				rime.pvp.noDef("shielded", target)
				rime.pvp.noDef("rebounding", target)
			elseif what == "speed" or razed == "failure" then
				rime.pvp.noDef("shielded", target)
				rime.pvp.noDef("rebounding", target)
				rime.pvp.noDef("speed", target)
			end
		end,

		Fearless = function(target)
			return
		end,

		Doublebash = function(target)
			rime.pvp.aggro(target)
			rime.last_hit = target
		end,

		Crush = function(target, where)
			rime.pvp.aggro(target)
			if where == "elbows" then
				rime.pvp.add_aff("crushed_elbows", target)
			elseif where == "knees" then
				rime.pvp.add_aff("crushed_knees", target)
			elseif where == "chest" then
				return
			end
		end,

		Pulverize = function(target)
			rime.pvp.aggro(target, "reset")
			rime.echo("RIP THIS MANS")
		end,

		Swat = function(target)
			rime.pvp.aggro(target, "reset")
			return
		end,

		Cruelty = function(target)
			return
		end,

		Herculeanrage = function()
			return
		end,

		Reckless = function()
			return
		end,

		Gripping = function()
			return
		end,

		Dismember = function(target, fail)
			rime.pvp.aggro(target)
			return
		end,

		Whirlwind = function(who, stage)
			if rime.attacks.personal then
				if stage == "start" then
					enableTimer("whirlwind_timer")
				elseif stage == "end" then
					disableTimer("whirlwind_timer")
				end
			end
			if who ~= gmcp.Char.Status.name then
				if not table.contains(rime.pvp.beyblades, who) then
					rime.pvp.beyblades[who] = {
						["venoms"] = {},
					}
				end
			end
		end,
	},

	["Warhounds"] = {

		Report = function(target)
			return
		end,

		Track = function(target)
			return
		end,

		Shatter = function(target, failure)
			if target == "you" then
				return
			end
			rime.pvp.noDef("shielded", target)
		end,

		Sniff = function(target)
			return
		end,

		Openings = function(target)
			return
		end,

		Dismiss = function(target)
			return
		end,

		Whistle = function()
			if rime.attacks.personal then
				active_hound = rime.saved.hound_atks.mark
				rime.pve.openings = false
				rime.pve.need_ents = false
				if rime.pve.bashing then
					rime.pve.bash_attack()
				end
			end
		end,

		Openings = function()
			if rime.attacks.personal then
				rime.pve.openings = true
				if rime.pve.bashing then
					rime.pve.bash_attack()
				end
			end
		end,

		Guard = function()
			return
		end,

		Flanking = function()
			if rime.attacks.personal then
				rime.defences.Carnifex.flanking.deffed = true
				if rime.pve.bashing then
					rime.pve.autoBash()
				end
			end
		end,

		Deliver = function(target)
			return
		end,

		Switch = function(target)
			if rime.attacks.personal then
				rime.pve.openings = false
			end
			return
		end,

		Recall = function(target)
			return
		end,

		Shock = function(target)
			rime.pvp.aggro(target)
			if not rime.pvp.has_aff("epilepsy", target) then
				rime.pvp.add_aff("epilepsy", target)
			elseif not rime.pvp.has_aff("hallucinations", target) then
				rime.pvp.add_aff("hallucinations", target)
			end
			carn.lastHound = "none"
		end,

		Growl = function(target)
			rime.pvp.aggro(target)
			if not rime.pvp.has_aff("dizziness", target) then
				rime.pvp.add_aff("dizziness", target)
			elseif not rime.pvp.has_aff("recklessness", target) then
				rime.pvp.add_aff("recklessness", target)
			end
			carn.lastHound = "none"
		end,

		Poisonclaw = function(target)
			rime.pvp.aggro(target)
			if not rime.pvp.has_aff("blisters", target) then
				rime.pvp.add_aff("blisters", target)
			elseif not rime.pvp.has_aff("limp_veins", target) then
				rime.pvp.add_aff("limp_veins", target)
			end
			carn.lastHound = "none"
		end,

		Acidspit = function(target)
			rime.pvp.aggro(target)
			if not rime.pvp.has_aff("weariness", target) then
				rime.pvp.add_aff("weariness", target)
			elseif not rime.pvp.has_aff("crippled", target) then
				rime.pvp.add_aff("crippled", target)
			end
			carn.lastHound = "none"
		end,

		Stare = function(target)
			rime.pvp.aggro(target)
			if not rime.pvp.has_aff("berserking", target) then
				rime.pvp.add_aff("berserking", target)
			elseif not rime.pvp.has_aff("impairment", target) then
				rime.pvp.add_aff("impairment", target)
			end
			carn.lastHound = "none"
		end,

		Mark = function(target)
			if rime.attacks.personal then
				rime.pvp.add_aff("houndmark", target)
			end
			carn.lastHound = "none"
		end,

		Tundralhowl = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("caloric", target)
			carn.lastHound = "none"
		end,

		Firebreath = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("ablaze", target)
			if rime.pvp.has_aff("ablaze", target) then
				rime.pvp.add_stack("ablaze", target, 1)
			end
			carn.lastHound = "none"
		end,

		Bite = function(target, limb)
			rime.pvp.aggro(target)
			if not limb then
				return
			end
			rime.pvp.add_limb(limb, target, 349)
			rime.last_hit = target
			carn.lastHound = "none"
		end,

		Contagion = function(target)
			return
		end,

		Ululate = function()
			return
		end,

		Rearing = function()
			return
		end,

		Develop = function()
			return
		end,

		Soulpact = function()
			return
		end,
	},

	["Deathlore"] = {

		Cull = function(target)
			if rime.attacks.personal then
				act("soul gaze")
			end
		end,

		Consumption = function()
			if rime.attacks.personal then
				if rime.defences.general.rebounding.keepup then
					rime.defences.general.rebounding.keepup = false
				end
				carn.consumption = true
				act("soul gaze")
			end
		end,

		Strike = function(target)
			if rime.attacks.personal then
				act("soul gaze")
			end
		end,

		Consume = function(target)
			return
		end,

		Souldrain = function(target)
			return
		end,

		Unify = function(target)
			return
		end,

		Reave = function(target, stage)
			if target == "you" then
				rime.targets[matches[2]].channel = true
				if stage == "begin" then
					rime.echo("YOU'RE BEING REAVED BY " .. matches[2]:upper())
					rime.pvp.aggro(target)
				elseif stage == "mid" then
					rime.echo(
						"YOU'RE BEING REAVED BY <red>" .. matches[2]:upper() .. "<white>BITCH PAY ATTENTION",
						"pvp"
					)
					rime.echo(
						"YOU'RE BEING REAVED BY <red>" .. matches[2]:upper() .. "<white>BITCH PAY ATTENTION",
						"pvp"
					)
					rime.echo(
						"YOU'RE BEING REAVED BY <red>" .. matches[2]:upper() .. "<white>BITCH PAY ATTENTION",
						"pvp"
					)
					rime.pvp.aggro(target)
				else
					rime.echo("I can't believe you let them do this to you, smh", "pvp")
				end
			else
				if stage == "begin" then
					rime.echo(target .. " being reaved by " .. matches[2], "pvp")
					rime.pvp.aggro(target)
				elseif stage == "mid" then
					rime.echo(target .. " being reaved by " .. matches[2], "pvp")
					rime.pvp.aggro(target)
				else
					if rime.attacks.personal and target ~= "You" then
						expandAlias("dab")
						rime.paused = false
						rime.pvp.aggro(target, "reset")
					else
						rime.echo(
							matches[2]:upper() .. " REAVED " .. target:upper() .. " THE ABSOLUTE MAD PERSON",
							"pvp"
						)
						rime.pvp.aggro(target, "reset")
					end
				end
			end
		end,

		Disease = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("soul_disease", target)
		end,

		Wraith = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("wraith", target)
		end,

		Soulbind = function(target)
			return
		end,

		Shroud = function(target)
			return
		end,

		Sacrifice = function(target)
			--add def here
		end,

		Fortify = function(target)
			return
		end,

		Shield = function(target)
			rime.pvp.addDef("shielded", target)
			rime.pvp.remove_aff("wraith", target)
		end,

		Erode = function(target)
			rime.pvp.aggro(target)
			rime.pvp.noDef("rebounding", target)
			rime.pvp.noDef("shielded", target)
			rime.pvp.noDef("prismatic", target)
		end,

		Substitute = function(target)
			if rime.attacks.personal then
				rime.reset()
			else
				rime.pvp.clear_target(target)
			end
		end,

		Distortion = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("distortion", target)
			if rime.attacks.personal then
				carn.can.distort = false
			end
		end,

		Implant = function(target)
			rime.pvp.aggro(target)
			return
		end,

		Frailty = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("glasslimb", target)
		end,

		Poison = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("soul_poison", target)
		end,

		Bloodburst = function(target)
			if target == "you" then
				return
			end
			rime.pvp.add_aff("hypertension", target)
			if not rime.targets[target].bloodburstCount then
				rime.targets[target].bloodburstCount = 0
			end
			rime.targets[target].bloodburstCount = rime.targets[target].bloodburstCount + 1
		end,

		Spiritsight = function()
			return
		end,

		Soulthirst = function()
			if rime.attacks.personal then
				addDef("soulthirst")
			end
		end,

		Fracture = function()
			return
		end,

		Summon = function()
			if rime.attacks.personal then
				carn.consumption = nil
			end
			return
		end,

		Puncture = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("soulpuncture", target)
		end,
	},

	--#Ravager

	["Brutality"] = {

		Attitude = function(target, attitude)
			if rime.attacks.personal then
				rime.ravager.attitude = attitude
			end
		end,

		Reflexes = function()
			return
		end,

		Velocity = function(target)
			return
		end,

		Predation = function(target, extend)
			if rime.attacks.personal then
				rime.ravager.predation = false
				if extend then
					rime.ravager.strengthSap = rime.ravager.strengthSap + 1
				end
			end
		end,

		Exhilarate = function(target)
			return
		end,

		Contempt = function(target)
			if rime.attacks.personal then
				rime.ravager.strengthSap = rime.ravager.strengthSap + 1
			else
				rime.pvp.remove_aff("paresis", target)
				rime.pvp.remove_aff("paralysis", target)
			end
		end,

		Seethe = function(target)
			return
		end,

		Bait = function(target, limb)
			if rime.attacks.personal then
				rime.ravager.baiting = limb:gsub(" ", "_")
			else
				rime.targets[target].baiting = limb:gsub(" ", "_")
			end
		end,

		Rampage = function(user, state)
			if rime.attacks.personal then
				rime.ravager.rampage = false
			end
			if state == "start" then
				rime.echo("THIS CLASS BLENDS?!")
			else
				rime.echo("THIS CLASS BLENDS!!")
			end
		end,

		Bully = function(target, limb)
			rime.pvp.aggro(target)
			if target == "you" then
				return
			end
			rime.pvp.add_limb(limb, target, 950)
		end,

		Clobber = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_aff("prone", target)
		end,

		Plexus = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_limb("torso", target, 850)
		end,

		Bustup = function(target, limb)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_aff(limb .. "_dislocated", target)
		end,

		PressurePoint = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.last_attack = "pressurepoint"
			rime.pvp.add_aff("stiffness", target)
			rime.pvp.add_aff("muscle_spasms", target)
		end,

		Haymaker = function(target)
			return
		end,

		Kneecap = function(target, limb)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_limb(limb, target, 900)
		end,

		Concussion = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_aff("stupidity", target)
			rime.pvp.add_aff("dizziness", target)
			rime.pvp.add_limb("head", target, 600)
			rime.pvp.last_attack = "concussion"
		end,

		Rebound = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_limb("torso", target, 500)
			rime.pvp.remove_aff("prone", matches[2])
		end,

		Overpower = function(target, limb)
			rime.pvp.aggro(target)
			if target == "you" then
				rime.curing.heel_rush = limb
				tempTimer(3, function()
					rime.curing.heel_rush = "none"
					gettingRushedBy = nil
				end)
				gettingRushedBy = matches[2]
			else
				rime.pvp.add_limb(limb, target, 550)
			end
		end,

		Windpipe = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_aff("crippled_throat", target)
			rime.pvp.add_limb("head", target, 350)
		end,

		Hobble = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_aff("sore_ankle", target)
		end,

		Slug = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.last_attack = "slug"
			rime.pvp.add_aff("stuttering", target)
		end,

		Flog = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_aff("backstrain", target)
		end,

		Maim = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_aff("sore_wrist", target)
		end,

		Butcher = function(target)
			rime.pvp.aggro(target)
		end,

		Whiplash = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_aff("whiplash", target)
		end,

		Tenderise = function(target, flame)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			if flame then
				if rime.pvp.has_aff("ablaze", target) then
					rime.pvp.add_stack("ablaze", target, 1)
				end
			end
		end,
	},

	["Ravaging"] = {

		Vinculum = function()
			return
		end,

		Torment = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_aff("ablaze", target)
			rime.pvp.add_stack("ablaze", target, 1)
		end,

		Prolong = function(target)
			return
		end,

		Smoulder = function()
			return
		end,

		Impressment = function()
			return
		end,

		Hood = function()
			return
		end,

		Begrudge = function()
			return
		end,

		Ruthlessness = function()
			return
		end,

		Ravage = function()
			rime.ravager.ravage = false
		end,

		Denial = function(target)
			if target == "you" then
				return
			end
			rime.pvp.addDef("rebounding", target)
		end,

		Intensify = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_stack("ablaze", target, 3)
		end,

		Bedevil = function(target, direction)
			rime.pvp.aggro(target)
			if rime.attacks.personal then
				rime.ravager.bedevil = false
			end
			if target == "you" then
				local pendulum = table.copy(rime.curing.limbs)
				if direction == "clockwise" then
					rime.curing.limbs.right_arm = pendulum.left_arm
					rime.curing.limbs.left_arm = pendulum.left_leg
					rime.curing.limbs.right_leg = pendulum.right_arm
					rime.curing.limbs.left_leg = pendulum.right_leg
				else
					rime.curing.limbs.right_arm = pendulum.right_leg
					rime.curing.limbs.left_arm = pendulum.right_arm
					rime.curing.limbs.right_leg = pendulum.left_leg
					rime.curing.limbs.left_leg = pendulum.left_arm
				end
				local limbName = "<DodgerBlue>"
				local limbNumber = "<DarkSlateGray>"
				local limbcho = "\n"
				for lmb, dmg in pairs(rime.curing.limbs) do
					if lmb == limb then
						limbName = "<orange>"
						limbNumber = "<white>"
					else
						limbName = "<DodgerBlue>"
						limbNumber = "<SteelBlue>"
					end
					limbcho = limbcho .. limbName .. lmb .. " " .. limbNumber .. dmg .. " "
				end
				cecho(limbcho)
			else
				local left_leg = rime.targets[target].afflictions.left_leg_damaged
				local left_arm = rime.targets[target].afflictions.left_arm_damaged
				local right_leg = rime.targets[target].afflictions.right_leg_damaged
				local right_arm = rime.targets[target].afflictions.right_arm_damaged
				local left_leg_mangled = rime.targets[target].afflictions.left_leg_mangled
				local left_arm_mangled = rime.targets[target].afflictions.left_arm_mangled
				local right_leg_mangled = rime.targets[target].afflictions.right_leg_mangled
				local right_arm_mangled = rime.targets[target].afflictions.right_arm_mangled
				if direction == "clockwise" then
					local pendulum = table.copy(rime.targets[target].limbs)
					rime.targets[target].limbs.right_arm = pendulum.left_arm
					rime.targets[target].afflictions.right_arm_mangled = left_arm_mangled
					rime.targets[target].afflictions.right_arm_damaged = left_arm
					rime.targets[target].afflictions.right_arm_crippled = left_arm
					rime.targets[target].limbs.left_arm = pendulum.left_leg
					rime.targets[target].afflictions.left_arm_mangled = left_leg_mangled
					rime.targets[target].afflictions.left_arm_damaged = left_leg
					rime.targets[target].afflictions.left_arm_crippled = left_leg
					rime.targets[target].limbs.right_leg = pendulum.right_arm
					rime.targets[target].afflictions.right_leg_mangled = right_arm_mangled
					rime.targets[target].afflictions.right_leg_damaged = right_arm
					rime.targets[target].afflictions.right_leg_crippled = right_arm
					rime.targets[target].limbs.left_leg = pendulum.right_leg
					rime.targets[target].afflictions.left_leg_mangled = right_leg_mangled
					rime.targets[target].afflictions.left_leg_damaged = right_leg
					rime.targets[target].afflictions.left_leg_crippled = right_leg
					local left_leg_dislocate = rime.targets[target].afflictions.left_leg_dislocated
					local left_arm_dislocate = rime.targets[target].afflictions.left_arm_dislocated
					local right_leg_dislocate = rime.targets[target].afflictions.right_leg_dislocated
					local right_arm_dislocate = rime.targets[target].afflictions.right_arm_dislocated
					rime.targets[target].afflictions.left_leg_dislocated = right_leg_dislocate
					rime.targets[target].afflictions.left_arm_dislocated = left_leg_dislocate
					rime.targets[target].afflictions.right_leg_dislocated = right_arm_dislocate
					rime.targets[target].afflictions.right_arm_dislocated = left_arm_dislocate
				else
					local pendulum = table.copy(rime.targets[target].limbs)
					rime.targets[target].limbs.right_arm = pendulum.right_leg
					rime.targets[target].afflictions.right_arm_mangled = right_leg_mangled
					rime.targets[target].afflictions.right_arm_damaged = right_leg
					rime.targets[target].afflictions.right_arm_crippled = right_leg
					rime.targets[target].limbs.left_arm = pendulum.right_arm
					rime.targets[target].afflictions.left_arm_mangled = right_arm_mangled
					rime.targets[target].afflictions.left_arm_damaged = right_arm
					rime.targets[target].afflictions.left_arm_crippled = right_arm
					rime.targets[target].limbs.right_leg = pendulum.left_leg
					rime.targets[target].afflictions.right_leg_mangled = left_leg_mangled
					rime.targets[target].afflictions.right_leg_damaged = left_leg
					rime.targets[target].afflictions.right_leg_crippled = left_leg
					rime.targets[target].limbs.left_leg = pendulum.left_arm
					rime.targets[target].afflictions.left_leg_mangled = left_arm_mangled
					rime.targets[target].afflictions.left_leg_damaged = left_arm
					rime.targets[target].afflictions.left_leg_crippled = left_arm
					local left_leg_dislocate = rime.targets[target].afflictions.left_leg_dislocated
					local left_arm_dislocate = rime.targets[target].afflictions.left_arm_dislocated
					local right_leg_dislocate = rime.targets[target].afflictions.right_leg_dislocated
					local right_arm_dislocate = rime.targets[target].afflictions.right_arm_dislocated
					rime.targets[target].afflictions.left_leg_dislocated = left_arm_dislocate
					rime.targets[target].afflictions.left_arm_dislocated = right_arm_dislocate
					rime.targets[target].afflictions.right_arm_dislocated = right_leg_dislocate
					rime.targets[target].afflictions.right_leg_dislocated = left_leg_dislocate
				end
				if target == rime.target then
					local limbName = "<white>"
					local limbNumber = "<" .. rime.saved.echo_colors.target.title .. ">"
					local limbcho = "\n"
					for lmb, dmg in pairs(rime.targets[rime.target].limbs) do
						dmg = dmg * 0.01
						if lmb == limb then
							limbName = "<orange>"
							limbNumber = "<white>"
						else
							limbName = "<" .. rime.saved.echo_colors.target.title .. ">"
							limbNumber = "<DarkSlateGray>"
						end
						limbcho = limbcho
							.. limbName
							.. string.title(lmb:gsub("_", " "))
							.. " "
							.. limbNumber
							.. dmg
							.. "% <red>| "
					end
					cecho(limbcho)
				end
				if rime.pvp.has_aff("sore_ankle", target) and not rime.pvp.has_aff("sore_wrist", target) then
					rime.targets[target].afflictions.sore_ankle = false
					rime.pvp.add_aff("sore_wrist", target)
				elseif rime.pvp.has_aff("sore_wrist", target) and not rime.pvp.has_aff("sore_ankle", target) then
					rime.targets[target].afflictions.sore_wrist = false
					rime.pvp.add_aff("sore_ankle", target)
				end
				GUI.target_aff()
			end
		end,

		Impenetrable = function()
			return
		end,

		Lancing = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			if rime.pvp.has_aff("ablaze", target) then
				rime.pvp.add_aff("heatspear", target)
			end
		end,

		Criticality = function()
			return
		end,

		Branding = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_aff("infernal_seal", target)
			if rime.pvp.has_aff("ablaze", target) then
				rime.pvp.add_stack("ablaze", target, 1)
			end
			limitStart("infernal_seal_" .. target, 125)
		end,

		Delirium = function(target)
			if rime.attacks.personal then
				rime.ravager.delirium = true
			end
		end,

		Shear = function(target, affliction)
			if target == "you" then
				return
			end
			rime.pvp.remove_aff(affliction, target)
		end,

		Extinguish = function(target, fail)
			if fail then
				rime.pvp.remove_aff("ablaze", target)
				rime.pvp.remove_aff("heatspear", target)
			else
				rime.echo("KWISPY!")
			end
		end,

		Unfinished = function(target)
			if rime.attacks.personal then
				rime.reset()
			else
				rime.pvp.clear_target(target)
			end
		end,

		Bedlam = function()
			return
		end,

		Hellfire = function()
			ravager.hellfire = true
		end,
	},

	["Egotism"] = {

		Pinpoint = function()
			return
		end,

		Haul = function()
			rime.echo("Yoink!")
		end,

		Peak = function()
			for _, v in pairs(swarm.room) do
				rime.pvp.add_aff("flash_blindness", v)
			end
		end,

		Redress = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.noDef("clarity", target)
			rime.pvp.noDef("speed", target)
			rime.pvp.noDef("levitation", target)
		end,

		Trip = function(target, direction)
			return
		end,

		Inadequacy = function(target)
			rime.pvp.add_aff("indifference", target)
		end,

		Boost = function(target)
			if rime.attacks.personal then
				rime.curing.class = false
			end
		end,

		Boast = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_aff("dementia", target)
			rime.pvp.add_aff("paranoia", target)
			rime.pvp.add_aff("merciful", target)
		end,

		Monopolise = function(target)
			return
		end,

		Trauma = function()
			return
		end,

		Pry = function()
			return
		end,

		Inflate = function()
			smugAffirmations()
		end,

		Kneel = function(target)
			if target == "you" then
				return
			end
			rime.pvp.add_aff("kneel", target)
			rime.pvp.aggro(target)
		end,

		Press = function()
			return
		end,

		Guts = function()
			return
		end,

		Outlaw = function()
			if rime.attacks.personal then
				rime.ravager.outlaw = false
			end
		end,

		Double = function()
			return
		end,
	},


	--#Executor

	["Shadowdancing"] = {

		Lithe = function(target)
			return
		end,

		Limberness = function(target)
			return
		end,

		Pirouette = function(target)
			rime.pvp.aggro(target)
			rime.last_hit = target
		end,

		Followup = {
			Whirl = function(target)
				rime.pvp.aggro(target)
				rime.last_hit = target
			end,
		},

		Incise = function(target)
			rime.pvp.aggro(target)
		end,

		Dissever = function(target)
			rime.pvp.aggro(target)
		end,

		Beguile = function(target)
			rime.pvp.aggro(target)
			rime.pvp.web_venoms()
			rime.last_hit = target
		end,

		Contrive = function(target)
			rime.pvp.aggro(target)
			rime.last_hit = target
			rime.pvp.web_venoms()
		end,

		Muddle = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("impatience", target)
		end,

		Desolate = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("heartflutter", target)
			rime.pvp.add_limb("torso", target, 260)
		end,

		Inveigle = function(target)
			rime.pvp.aggro(target)
			rime.pvp.web_venoms()
			rime.pvp.add_limb("torso", target, 250)
		end,

		Phlebotomise = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_limb("torso", target, 280)
			if rime.pvp.has_aff("impairment", target) then
				rime.pvp.add_aff("addiction", target)
			else
				rime.pvp.add_aff("impairment", target)
			end
		end,

		Stifle = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("destroyed_throat", target)
			rime.pvp.add_limb("head", target, 200)
		end,

		Ruse = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("confusion", target)
		end,

		Brutalise = function(target, fail_check)
			if not fail_check then
				rime.pvp.add_aff("writhe_impaled", target)
				rime.pvp.add_limb("torso", target, 1250)
				rime.pvp.aggro(target)
				if rime.attacks.personal then
					targetImpaled = true
				end
			else
				rime.pvp.remove_aff("prone", target)
			end
			if target == rime.target then
				rime.pvp.target_tumbling = false
			end
		end,

		Shave = function(target, def)
			if target == "you" then
				return
			end
			if def == "shield" then def = "shielded" end
			if def ~= "shielded" and def ~= "rebounding" then
				rime.pvp.noDef("rebounding", target)
				rime.pvp.noDef("shielded", target)
			end
			rime.pvp.noDef(def, target)
			rime.pvp.aggro(target)
		end,

		Contravene = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
		end,

		Impair = function(target, limb)
			if target == "you" then
				return
			end
			if string.find(limb, "leg") then
				rime.pvp.add_aff("lethargy", target)
			end
			rime.pvp.add_limb(limb, target, 280)
			rime.pvp.aggro(target)
		end,

		Brandish = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.web_venoms()
		end,

		Perplex = function(target)
			if target == "you" then return end
			rime.pvp.aggro(target)
			if not rime.pvp.has_def("rebounding", target) then
				rime.pvp.add_aff("epilepsy", target)
				rime.pvp.add_aff("laxity", target)
			end
			rime.pvp.last_attack = "perplex"
		end,

		Terminate = function(target, fail)
			if not fail then
				rime.echo("fuckin' rip", "pvp")
			else
				rime.echo("lmao get fucked loser sentinel", "pvp")
			end
		end,

		Twinraze = function(target, def)
			if def == "shield" then def = "shielded" end
			if target ~= "you" then
				if def == "failure" then
					rime.pvp.noDef("shielded", target)
					rime.pvp.noDef("rebounding", target)
					rime.pvp.noDef("speed", target)
				else
					rime.pvp.noDef(def, target)
				end
			end
		end,

		Gambol = function(target)
			rime.pvp.add_aff("prone", target)
		end,
	},

	["Subversion"] = {

		Warningshot = function(target)
			return
		end,

		Scent = function(target)
			return
		end,

		Heavyshot = function(target)
			return
		end,

		Splatter = function(target, resin)
			if target == "you" then return end
			rime.pvp.aggro(target)
			if not rime.targets[target].combusted then
				if not rime.targets[target].coldburn and not rime.targets[target].hotburn then
					rime.targets[target].coldburn = resin
					rime.echo("Coldburn set to <orange>"..resin, "pvp")
				elseif rime.targets[target].coldburn then
					rime.echo("We're shifting <ansi_light_red>"..rime.targets[target].coldburn.."<white> to the hotburn and putting <orange>"..resin.."<white> as the coldburn", "pvp")
					rime.targets[target].hotburn = rime.targets[target].coldburn
					rime.targets[target].coldburn = resin
				end
			end
		end,

		Kindle = function(target)
			if target == "you" then return end
			rime.pvp.aggro(target)
			if rime.targets[target].coldburn and not rime.targets[target].combusted then
				rime.targets[target].combusted = true
				local cold = rime.targets[target].coldburn
				local hot = rime.targets[target].hotburn
				rime.echo(target .. "'s coldburn is: <orange>" .. cold .. " <white>\(<orange>" .. execute.cycles[cold] .. "<white>\)", "pvp")
				rime.echo(target .. "'s hotburn is: <ansi_light_red>" .. hot, "pvp")
			end
		end,

		Marksense = function(target)
			return
		end,
	},

	["Artifice"] = {

		Campfire = function(target)
			return
		end,

		Bloodlust = function(target)
			return
		end,

		Inspirit = function(target)
			return
		end,

		Conceal = function(target)
			return
		end,

		Grit = function(target)
			return
		end,

		Gird = function(target)
			return
		end,

		Stoicism = function(target)
			return
		end,

		Bounding = function(target)
			return
		end,

		Illustrate = function(target)
			return
		end,

		Verglas = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_aff("caloric", target)
		end,

		Brutaliser = {

			Trample = function(target)
				return
			end,

		},

		Accost = function(target, animal)
			local daunt_aff = {
				darkhound = "claustrophobia",
				direwolf = "claustrophobia",
				brutaliser = "agoraphobia",
				raloth = "agoraphobia",
				eviscerator = "loneliness",
				crocodile = "loneliness",
				terrifier = "berserking",
				cockatrice = "berserking",
			}
			rime.pvp.aggro(target)
			rime.pvp.add_aff(daunt_aff[animal], target)
		end,

		Pester = function(target, animal)
			return
		end,

	},


--#Predator

	["Knifeplay"] = {

		Lateral = function (target)
			if target == "you" then
				return
			end
			predator.slashes = predator.slashes+1
			rime.pvp.aggro(target)
			rime.pvp.add_limb("torso", target, 600)
		end,

		Vertical = function (target)
			if target == "you" then
				return
			end
			predator.slashes = predator.slashes+1
			rime.pvp.aggro(target)
			rime.last_hit = target
		end,

		Swiftkick = function (target)
			if target == "you" then
				return
			end
		end,

		Trip = function (target)
			if target == "you" then
				return
			end
			if rime.pvp.has_aff("head_broken", target) then
				rime.pvp.add_aff("dazed", target)
			end
		end,

		Jab = function (target, limb)
			if target == "you" then
				return
			end
			predator.slashes = predator.slashes+1
			rime.pvp.aggro(target)
			rime.pvp.add_limb(limb, target, 549)
		end,

		Feint = function (target, limb)
			if target == "you" then
				return
			end
			rime.targets[target].parry = limb
			predator.can_feint = false
		end,

		Pinprick = function (target)
		    if target == "you" then
		        return
		    end
		    predator.slashes = predator.slashes+1
		    rime.pvp.aggro(target)
		    rime.pvp.add_aff("epilepsy", target)
		end,

		Raze = function (target, what)
		    if target == "you" then
		        return
		    end
		    rime.pvp.aggro(target)
		    rime.last_hit = target
		    if what == "shield" then
		        rime.pvp.noDef("shielded", target)
		    elseif what == "rebounding" then
		        rime.pvp.noDef("shielded", target)
		        rime.pvp.noDef("rebounding", target)
		    elseif what == "speed" or what == "failure" then
		        rime.pvp.noDef("shielded", target)
		        rime.pvp.noDef("rebounding", target)
		        rime.pvp.noDef("speed", target)
		    end
		end,

		Bleed = function (target)
		    if target == "you" then
		        return
		    end
		    predator.slashes = predator.slashes+1
		end,

		Flashkick = function (target)
		    if target == "you" then
		        return
		    end
		    rime.pvp.aggro(target)
		    rime.pvp.add_limb("head", target, 500)
		    --note: adds a random aff confusion, dementia, weariness, stupidity, or dizziness -if all blackout
		end,

		Crescentcut = function (target)
		    if target == "you" then
		        return
		    end
		    predator.slashes = predator.slashes+1
		    rime.pvp.aggro(target)
		    rime.last_hit = target
		    --note: variable big dmg
		end,

		Lowhook = function (target, limb)
		    if target == "you" then
		        return
		    end
		    predator.slashes = predator.slashes+1
		    rime.pvp.aggro(target)
		    rime.pvp.add_limb(limb, target, 549)
		end,

		Veinrip = function (target)
		    if target == "you" then
		        return
		    end
		    rime.pvp.aggro(target)
		    predator.slashes = predator.slashes+1
		    rime.pvp.add_limb("head", target, 149)
		end,

		Gouge = function (target)
		    if target == "you" then
		        return
		    end
		    rime.pvp.aggro(target)
		    predator.slashes = predator.slashes+2
		    rime.pvp.add_aff("disfigurement", target)
		    rime.pvp.add_limb("head", target, 648)
		    --note: This attack is a double hit and I just combined the limb dmg
		end,

		Freefall = function (target)
		end,

		Spinslash = function (target, limb)
		    if target == "you" then
		        return
		    end
		    predator.slashes = predator.slashes+2
		    rime.pvp.aggro(target)
		    rime.pvp.add_limb(limb, target, 400)
		    --note: This attack is a double hit and I just combined the limb dmg
		end,

		Butterfly = function (target)
		    rime.pvp.aggro(target)
		    predator.slashes = predator.slashes+1
		    rime.last_hit = target
		end,

		Tidalslash = function (target)
		    --have not tested it
		end,

		Pommelwhip = function (target)
		    --does blackout if hiding, and ignores rebounding
		end,

		Fleshbane = function (target)
		    if target == "you" then
		        return
		    end
		    rime.pvp.aggro(target)
		    predator.slashes = predator.slashes+1
		    rime.last_hit = target
		    rime.pvp.add_aff("fleshbane", target)
		end,

		Spacing = function ()
			return
		end,

		Trueparry = function ()
		    return
		end,

		Bloodscourge = function (target)
		    if target == "you" then
		        return
		    end
		    rime.pvp.aggro(target)
		    predator.slashes = predator.slashes+1
		    rime.last_hit = target
		    rime.pvp.add_aff("bloodscourge", target)
		end,
	},

	["Predation"] = {

		Pheromones = function (target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_aff("pacifism", target)
		end,
	
		Dartshot = function (target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.last_hit = target
		end,
	
		Windwalk = function ()
			return
		end,
	
		Entice =function ()
			return
		end,
	
		Arouse = function ()
			return
		end,
	
		Mindnumb = function (target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_aff("impairment", target)
		end,
	
		Goad = function (target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_aff("goaded", target)
		end,
	
		Ferocity = function ()
			rime.curing.class = false
		end,
	
		Pindown = function(target, fail_check)
				if not fail_check then
					rime.pvp.add_aff("writhe_dartpinned", target)
					rime.pvp.aggro(target)
				else
					rime.pvp.remove_aff("prone", target)
				end
		end,
	
		Twinshot = function (target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.last_hit = target
		end,
	
		Hostage = function(stage)
			if target == "you" then
				return
			end
			if stage == "success" then
				rime.echo("GOTCHA BITCH")
			end
		end,
	},
	
	["Beastmastery"] = {
		Beastcall = function ()
			return
		end,
	
		Redeyes = function (target)
			return
		end,
	
		Swifttrack = function ()
			return
		end,
	
		Rake = function (target)
			return
		end,
	
		Swipe = function (target, what)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			if what == "density" then
				rime.pvp.noDef("density", target)
			end
		end,
	
		Weaken = function (target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_aff("sapped_strength", target)
		end,
	
		Pummel = function (target, limb)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_limb(limb, target, 2000)
		end,
	
		Mawcrush = function (target, state)
			if state == "fail" then
				rime.pvp.remove_aff("torso_broken", target)
			end
			rime.echo("OM NOM NOM")
			rime.pvp.aggro(target)
			rime.pvp.room.bloodied = true
		end,
	
		Web = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_aff("writhe_web", target)
		end,
	
		Intoxicate = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			predator.intoxicating = target
		end,
	
		Strands = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			predator.strands = target
		end,
	
		Negate = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_aff("cutting_weakness", target)
			limitStart("cutting_weakness", 25, target)
			rime.pvp.add_aff("blunt_weakness", target)
			limitStart("blunt_weakness", 25, target)
		end,
	
		Acid = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_aff("spider_acid", target)
			limitStart("spider_acid", 15, target)
		end,
	},

	--#Earthcaller

	["Subjugation"] = {

		Calcify = function(target)
			return
		end,

		Crush = function(target, limb)
            local left = rime.vitals.wielded_left
            local right = rime.vitals.wielded_right
            if target == "you" then
                return
            end
            rime.pvp.aggro(target)
            if rime.attacks.personal then
                if earthcaller.shield_type == "tower" then
                    rime.pvp.add_limb(limb, target, 1250)
                elseif earthcaller.shield_type == "buckler" then
                    rime.pvp.add_limb(limb, target, 250)
                end
            else
                rime.pvp.add_limb(limb, target, 1250)
            end
        end,

		Anointing = function(target, rune)
			return
		end,

		Swarm = function(target)
			return
		end,

		Obliterate = function(target, limb)
			if rime.attacks.personal then
				earthcaller.can_obliterate = false
			end
			rime.pvp.add_limb(limb:gsub(" ", "_"), target, 2500)
		end,

		Facesmash = function(target)
			rime.pvp.aggro(target)
			rime.last_hit = target
			if target == "you" then
				return
			end
			if not rime.pvp.has_def("rebounding", target) then
				rime.pvp.add_aff("no_blind", target)
				rime.pvp.add_aff("misery", target)
				rime.pvp.last_attack = "facesmash"
			end
		end,

		Ossomancy = function()
			return
		end,

		Wyrmyard = function()
			return
		end,

		Resorption = function()
			return
		end,

		Crush = function(target, limb)
			local left = rime.vitals.wielded_left
			local right = rime.vitals.wielded_right
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			if rime.attacks.personal then
				if earthcaller.shield_type == "tower" then
					rime.pvp.add_limb(limb, target, 1250)
				elseif earthcaller.shield_type == "buckler" then
					rime.pvp.add_limb(limb, target, 250)
				end
			else
				rime.pvp.add_limb(limb, target, 1250)
			end
		end,

		Incisor = function(target, defence)
			if rime.pvp.has_def(defence, target) then
				rime.pvp.noDef(defence, target)
			end
		end,

		Splinter = function(target)
			return
		end,

		Dust = function(target)
			rime.pvp.add_aff("salve_seared", target)
			rime.pvp.add_aff("ablaze", target)
			if rime.pvp.has_aff("ablaze", target) then
				rime.pvp.add_stack("ablaze", target, 1)
			end
			limitStart("salve_seared_" .. target, 15)
		end,

		Fragmentation = function(target, failed)
			if failed then
				return
			end
			rime.echo("HEY! WHAT'S THAT BONE DOIN?")
			rime.pvp.aggro(target, "reset")
			return
		end,

		Endoskeleton = function(target)
			rime.pvp.clear_target(target)
		end,

		Bleach = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target, "reset")
			return
		end,

		Execution = function(target)
			if target == "you" then
				rime.echo("YOU ARE BEING EXECUTED!")
				rime.echo("YOU ARE BEING EXECUTED!")
				rime.echo("YOU ARE BEING EXECUTED!")
				rime.echo("YOU ARE BEING EXECUTED!")
			else
				rime.pvp.aggro(target)
				rime.echo(string.upper(target) .. " IS BEING EXECUTED!")
				rime.echo(string.upper(target) .. " IS BEING EXECUTED!")
				rime.echo(string.upper(target) .. " IS BEING EXECUTED!")
				rime.echo(string.upper(target) .. " IS BEING EXECUTED!")
			end
		end,

		Deface = function(target)
			rime.pvp.aggro(target)
			if target == rime.target then
				if rime.pvp.count_affs() > 5 and rime.pvp.has_aff("aftershock", target) then
					rime.pvp.add_aff("blackout", target)
				end
			end
			--blackout stuff
			return
		end,

		Crash = function(target, fail)
			if not fail then
				rime.pvp.add_aff("disrupted", target)
			end
		end,

		Infiltrate = function(target)
			if rime.attacks.personal then
				earthcaller.infiltrate = target
			end
		end,

		Strike = function(target)
			rime.pvp.aggro(target)
			rime.last_hit = target
			if target == "you" then
				return
			end
			if not rime.pvp.has_def("rebounding", target) then
				rime.pvp.add_aff("paresis", target)
			end
		end,

		Subdue = function(target)
			rime.pvp.aggro(target)
			rime.last_hit = target
			rime.pvp.web_subdues()
			return
		end,

		Slam = function(target)
			rime.pvp.aggro(target)
			rime.last_hit = target
			if not rime.pvp.has_def("rebounding", target) then
				rime.pvp.add_aff("asthma", target)
				rime.pvp.add_aff("haemophilia", target)
			end
		end,

		Horrification = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("no_blind", target)
		end,

		Punch = function(target)
			rime.pvp.aggro(target)
			rime.last_hit = target
			if target == "you" then
				return
			end
			if not rime.pvp.has_def("rebounding", target) then
				rime.pvp.add_aff("weariness", target)
			end
		end,

		Spur = function(target, aff)
			rime.pvp.aggro(target)
			if aff == "self-pity" then
				aff = "selfpity"
			end
			if target == "you" then
				return
			end
			if aff == "sensitivity" then
				aff = "no_deaf"
			end
			rime.pvp.add_aff(aff, target)
		end,

		Raze = function(target, what)
			if target == "you" then
				return
			end
			rime.last_hit = target
			if what == "shield" then
				rime.pvp.noDef("shielded", target)
			elseif what == "reflection" then
				return
			elseif what == "rebounding" then
				rime.pvp.noDef("shielded", target)
				rime.pvp.noDef("rebounding", target)
			elseif what == "speed" or what == "failure" then
				rime.pvp.noDef("shielded", target)
				rime.pvp.noDef("rebounding", target)
				rime.pvp.noDef("speed", target)
			end
			rime.pvp.aggro(target)
		end,

		Ribcage = function(target)
			rime.pvp.addDef("shielded", target)
			rime.pvp.remove_aff("wraith", target)
		end,

		Quash = function(target)
			rime.pvp.aggro(target)
		end,

		Annointing = function(target, rune)
			return
		end,
	},

	["Apocalyptia"] = {

		Libation = function(target)
			return
		end,

		Earthcall = function()
			return
		end,

		Empowerment = function()
			if rime.attacks.personal then
				earthcaller.verses.empowerment = true
				if earthcaller.auto_verses then
					expandAlias("set verses")
				end
			end
		end,

		Imprisonment = function()
			return
		end,

		Primordial = function()
			return
		end,

		Eternity = function()
			return
		end,

		Censor = function()
			return
		end,

		Wardance = function()
			return
		end,

		Reinforce = function(target)
			return
		end,

		Constitution = function()
			return
		end,

		Reckoning = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("hellsight", target)
		end,

		Revelation = function(target)
			return
		end,

		Battlehymn = function()
			return
		end,

		Euphoria = function(target)
			return
		end,

		Resolute = function()
			return
		end,

		Enervation = function()
			return
		end,

		Transgretions = function()
			return
		end,

		Ordain = function(target)
			return
		end,

		Lull = function(target)
			rime.pvp.add_aff("peace", target)
		end,

		Hysteria = function(target)
			rime.pvp.add_aff("confusion", target)
			rime.pvp.add_aff("dizziness", target)
		end,

		Imprisonment = function()
			return
		end,

		Eternity = function()
			return
		end,

		Marshal = function()
			return
		end,

		Empowerment = function()
			return
		end,

		Primordial = function()
			return
		end,

		Censor = function(stage)
			return
		end,

		Execration = function(target)
			return
		end,
	},

	["Tectonics"] = {

		Smothering = function()
			return
		end,

		Heatshield = function()
			return
		end,

		Pressurize = function()
			return
		end,

		Mould = function()
			return
		end,

		Fault = function(target)
			if rime.pvp.has_aff("agony", target) or rime.pvp.has_aff("accursed", target) then
				rime.pvp.add_aff("faulted", target)
				limitStart(target .. "_faulted", 18)
			else
				return
			end
		end,

		Insulation = function()
			return
		end,

		Spew = function(target)
			rime.pvp.add_aff("ablaze", target)
			if rime.pvp.has_aff("ablaze", target) then
				rime.pvp.add_stack("ablaze", target, 1)
			end
		end,

		Fossilise = function(target)
			if target == "you" then
				for k, v in pairs(rime.curing.pipes) do
					if k ~= "last" then
						rime.curing.pipes[k] = false
					end
				end
				local sep = rime.saved.separator
				act("outc willow" .. sep .. "outc yarrow" .. sep .. "outc reishi")
			end
			if target == rime.target then
				earthcaller.need_fossil = false
				earthcaller.can_fossilise = false
			end
		end,

		Spray = function(target)
			if target == matches[1] then
				rime.pvp.addDef("blindness", target)
			else
				rime.pvp.aggro(target)
				rime.pvp.add_aff("burnt_eyes", target)
			end
		end,

		Mould = function()
			return
		end,

		Geyser = function()
			rime.pvp.room.darkness = false
		end,

		Firewall = function(target, direction)
			rime.pvp.room[direction .. "_firewalled"] = true
		end,

		Rumbling = function()
			return
		end,

		Pyroclasm = function()
			return
		end,

		Dominance = function()
			return
		end,

		Ashfall = function(target)
			rime.pvp.add_aff("allergies", target)
		end,

		Ashcloud = function(target)
			rime.pvp.addDef("lightform", target)
		end,

		Contaminate = function(target)
			if target == "you" then
				for k, v in pairs(rime.curing.pipes) do
					if k ~= "last" then
						rime.curing.pipes[k] = false
					end
				end
				local sep = rime.saved.separator
				act("outc willow" .. sep .. "outc yarrow" .. sep .. "outc reishi")
			end
		end,

		Transfixion = function(target, blindness)
			if not blindness then
				rime.pvp.add_aff("writhe_transfix", target)
			end
			rime.pvp.add_aff("no_blind", target)
		end,

		Thermics = function(target)
			return
		end,

		Seismicity = function(target)
			return
		end,

		Vent = function(target)
			rime.pvp.add_aff("hallucinations", target)
			rime.pvp.add_aff("berserking", target)
		end,

		Aftershock = function(target)
			rime.pvp.add_aff("aftershock", target)
		end,

		Reformation = function(target)
			if rime.attacks.personal then
				rime.reset()
			else
				rime.pvp.clear_target(target)
			end
		end,
	},

	--Syssin

	["Assassination"] = {

		Doublestab = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.last_hit = target
			rime.pvp.web_venoms()
		end,

		Shrugging = function(target)
			return
		end,

		Backstab = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.last_hit = target
			rime.pvp.web_venoms()
		end,

		Flay = function(target, effect)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.last_hit = target
			rime.pvp.web_venoms()
			if effect == "rebounding" or effect == "failure-rebounding" then
				rime.pvp.noDef("rebounding", target)
			elseif effect == "fangbarrier" or effect == "failure-fangbarrier" then
				rime.pvp.noDef("fangbarrier", target)
			elseif effect == "speed" or effect == "failure-speed" then
				rime.pvp.noDef("speed", target)
			elseif effect == "shield" or effect == "failure-shield" then
				rime.pvp.noDef("shielded", target)
			elseif effect == "none" then
				rime.pvp.noDef("rebounding", target)
			end
		end,

		Bite = function(target, effect)
			if effect == "failure" then return end
			rime.pvp.aggro(target)
			rime.last_hit = target
			rime.pvp.add_aff(effect, target)
		end,

		Recuperate = function(target)
			return
		end,

		Garrote = function(target)
			rime.pvp.aggro(target)
		end,

		Warding = function(target)
			return
		end,

		Weaving = function(target)
			return
		end,

		Snipe = function(shooter, venom)
			return
		end,
	},

	["Subterfuge"] = {

		Bedazzle = function(target)
			if target == "you" then
				rime.hidden_aff("bedazzle")
				rime.hidden_aff("bedazzle")
				rime.check_hidden()
			end
		end,

		Banish = function(target)
			rime.echo("Hey look it's the really slow and terrible way of killing shadowbound")
		end,
	},

	["Hypnosis"] = {

		Marks = function(target, effect)
			local effect_conversion = {
				["Numbness"] = "numbed_skin",
			}
			effect = effect_conversion[effect]
			rime.pvp.add_aff(string.lower(effect), target)
		end,

		Sleight = function(target, effect)
			rime.pvp.add_aff(string.lower(effect), target)
		end,
	},

	--#Sciomancer

	["Sciomancy"] = {

		Channel = function(target, what)
			return
		end,

		Engulf = function(target)
			return
		end,

		Shadeling = function(target)
			return
		end,

		Falter = function(target)
			return
		end,

		Leech = function(target)
			return
		end,

		Blast = function(target)
			return
		end,

		Mantle = function(target)
			--add def
			return
		end,

		Gloom = function(target)
			rime.pvp.add_aff("gloom", target)
		end,

		Voidgaze = function(target)
			rime.pvp.add_aff("voidgaze", target)
		end,

		Ruin = function(target)
			local ruin_affs = { "clumsiness", "weariness", "lethargy", "paresis" }
			for k, v in ipairs(ruin_affs) do
				if not rime.pvp.has_aff(v, target) then
					rime.pvp.add_aff(v, target)
					break
				end
			end
		end,

		Fever = function(target)
			rime.pvp.add_aff("haemophilia", target)
			rime.pvp.add_aff("vomiting", target)
			if rime.pvp.has_aff("dementia", target) then
				rime.pvp.remove_aff("dementia", target)
				rime.pvp.add_aff("hallucinations", target)
			end
		end,

		Shadowsphere = function(target)
			rime.pvp.add_aff("shadowsphere", target)
			rime.sciomancer.can.shadowsphere = false
		end,

		Shadowbrand = function(target, complete)
			if complete == "end" then
				rime.pvp.add_aff("shadowbrand", target)
			end
		end,

		Chill = function(target)
			rime.pvp.add_aff("caloric", target)
		end,

		Scourge = function(target)
			return
		end,

		Repay = function(target)
			return
		end,

		Hew = function(target)
			rime.pvp.noDef("shielded", target)
		end,

		Shaderot = function(target)
			if target == "you" then
				return
			end
			rime.pvp.add_aff("rot", target)
		end,

		["Relapse"] = {

			Scourge = function(target)
				return
			end,
		},

		Consume = function(target, fail)
			return
		end,

		["Shadowprice"] = {

			Haunt = function(target)
				return
			end,

			Falter = function(target)
				return
			end,

			Leech = function(target)
				return
			end,

			Gloom = function(target)
				rime.pvp.add_aff("gloom", target)
			end,

			Voidgaze = function(target)
				rime.pvp.add_aff("voidgaze", target)
				rime.pvp.add_aff("no_blind", target)
				rime.pvp.noDef("blind", target)
			end,

			Ruin = function(target)
				local ruin_affs = { "clumsiness", "weariness", "lethargy", "paresis" }
				for k, v in ipairs(ruin_affs) do
					if not rime.pvp.has_aff(v, target) then
						rime.pvp.add_aff(v, target)
						break
					end
				end

				for k, v in ipairs(ruin_affs) do
					if not rime.pvp.has_aff(v, target) then
						rime.pvp.add_aff(v, target)
						break
					end
				end
			end,

			Fever = function(target)
				rime.pvp.add_aff("haemophilia", target)
				rime.pvp.add_aff("vomiting", target)
			end,

			Shadowsphere = function(target)
				rime.pvp.add_aff("shadowsphere", target)
				rime.pvp.add_aff("nyctophobia", target)
				rime.sciomancer.can.shadowsphere = false
			end,

			Shadowbrand = function(target)
				rime.pvp.add_aff("shadowbrand", target)
			end,

			Scourge = function(target)
				return
			end,

			Hew = function(target)
				rime.pvp.noDef("shielded", target)
			end,

			Shaderot = function(target)
				if target == "you" then
					return
				end
				rime.pvp.add_aff("rot", target)
				rime.pvp.add_aff("rot", target)
			end,

			Chill = function(target)
				rime.pvp.aggro(target)
				rime.pvp.add_aff("caloric", target)
				rime.pvp.add_aff("caloric", target)
			end,
		},
	},

	["Sorcery"] = {

		Replicate = function(target)
			rime.replicated = true
		end,

		Reflection = function(target)
            rime.pvp.addDef("reflection", target)
            if rime.attacks.personal then
            	rime.sciomancer.reflection_charge = rime.sciomancer.reflection_charge-1
            	rime.echo("Lost a charge for Reflection, down to "..rime.sciomancer.reflection_charge, "pvp")
            end
		end,

		Dispel = function(target)
			rime.pvp.room.mirage = false
			act("ql")
		end,

		Mirage = function(target)
			rime.pvp.room.mirage = true
			rime.echo("MIRAGE IS UP MIRAGE IS UP MIRAGE IS UP")
			rime.echo("MIRAGE IS UP MIRAGE IS UP MIRAGE IS UP")
		end,

		Transfix = function(target, blind)
			if not blind then
				rime.pvp.add_aff("no_blind", target)
				rime.pvp.add_aff("writhe_transfix", target)
			else
				rime.pvp.add_aff("no_blind", target)
			end
			rime.sciomancer.can.transfix = false
		end,

		Ensorcell = function(target)
			return
		end,

		Sagacity = function(target)
			--add def
			return
		end,

		Countercurrent = function(target)
			--add def
			return
		end,

		Blurring = function(target)
			--add def
			return
		end,

		Spectre = function(target)
			return
		end,

		Spellguard = function(target, stage)
			if target == "You" and stage == "start" then
				rime.sciomancer.can.spellguard = false
			elseif target == "You" and stage == "end" then
				rime.sciomancer.can.spellguard = true
			end
		end,

		Rigor = function(target, status)
			return
		end,
	},

	["Gravitation"] = {

		Orbit = function(target, thing)
			return
		end,

		Dismantle = function(target)
			return
		end,

		Singularity = function(target)
			return
		end,

		Genesis = function(target)
			return
		end,

		Featherstep = function(target)
			--add def
			return
		end,

		Pull = function(target)
			rime.pvp.remove_stack("gravity", target)
		end,

		Grip = function(target)
			rime.pvp.add_aff("paresis", target)
			rime.pvp.add_aff("prone", target)
			rime.pvp.add_stack("gravity", target)
		end,

		Imbue = function(target)
			rime.pvp.add_aff("imbue", target)
		end,

		Erupt = function(target, limb)
			local amount = {
				[0] = 400,
				[1] = 800,
				[2] = 1300,
				[3] = 1900,
				[4] = 2500,
				[5] = 3300,
			}
			if target == "you" then
				return
			end
			local target_gravity = rime.targets[target].stacks.gravity
			rime.pvp.add_limb(limb, target, tonumber(amount[target_gravity]))
			if not rime.pvp.has_aff("shadowbrand", target) then
				rime.targets[target].stacks.gravity = 0
				rime.echo(string.title(target) .. " lost all gravity stacks!", "pvp")
			elseif rime.pvp.has_aff("shadowbrand", target) and target_gravity < 3 then
				rime.targets[target].stacks.gravity = 0
				rime.echo(string.title(target) .. " lost all gravity stacks!", "pvp")
			end
		end,

		Impede = function(target)
			rime.pvp.add_aff("impede", target)
		end,

		Collapse = function(target)
			return
		end,

		Absorb = function(target)
			return
		end,
	},

	--#Praenomen

	["Mentis"] = {
		Lifevision = function()
			return
		end,

		Whisper = function(target)
			if target == "you" then
				if rime.has_aff("blood_curse") then
					rime.hidden_aff("blood_curse")
					rime.hidden_aff("blood_curse")
					rime.check_hidden()
				end
			end
			rime.pvp.whisper_affs(target)
			if not rime.attacks.personal then
				rime.time(target, "eq", 3.23)
			end
		end,

		Deathsight = function()
			return
		end,

		Psycombat = function()
			return
		end,

		Assess = function()
			return
		end,

		Disrupt = function(target, failure)
			if failure then
				return
			end
			rime.pvp.add_aff("disrupted", target)
		end,

		Siphon = function(target)
			return
		end,

		Mesmerize = function(target, blind)
			if not blind then
				rime.pvp.add_aff("no_blind", target)
				rime.pvp.add_aff("writhe_transfix", target)
			else
				rime.pvp.add_aff("no_blind", target)
			end
		end,

		ForkedTongue = function()
			return
		end,

		Telesense = function()
			return
		end,

		Panic = function(target)
			return
		end,

		Contemplation = function(target)
			return
		end,

		Trill = function()
			return
		end,

		Lure = function(target)
			return
		end,

		Annihilate = function(target)
			return
		end,

		Confusion = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("confusion", target)
		end,

		Fear = function(target)
			return
		end,

		Impatience = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("impatience", target)
		end,

		Paranoia = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("paranoia", target)
		end,

		Stupidity = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("stupidity", target)
		end,

		Agoraphobia = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("agoraphobia", target)
		end,

		Masochism = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("masochism", target)
		end,

		Lovers = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("lovers_effect", target)
		end,

		Seduction = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("seduction", target)
		end,

		Epilepsy = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("epilepsy", target)
		end,

		Anorexia = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("anorexia", target)
		end,

		Amnesia = function(target)
			rime.pvp.aggro(target)
			return
		end,

		Peace = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("peace", target)
		end,

		Dementia = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("dementia", target)
		end,

		Berserking = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("berserking", target)
		end,

		Indifference = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("indifference", target)
		end,

		Vertigo = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("vertigo", target)
		end,

		Temptation = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("temptation", target)
		end,

		Recklessness = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("recklessness", target)
		end,
	},
	["Sanguis"] = {
		Sanguine = function()
			return
		end,

		Pervade = function()
			return
		end,

		Seethe = function(target)
			return
		end,

		Raise = function()
			return
		end,

		Wisp = function()
			return
		end,

		Track = function()
			return
		end,

		Command = function()
			return
		end,

		Thirst = function()
			return
		end,

		Regurgitate = function(target)
			return
		end,

		Haze = function()
			return
		end,

		Level = function(target)
			return
		end,

		Effusion = function(target)
			rime.pvp.add_aff("effused_blood", target)
		end,

		Gift = function()
			return
		end,

		Mask = function()
			return
		end,

		Mutation = function()
			return
		end,

		Pulse = function(target)
			return
		end,

		Blur = function()
			return
		end,

		Trepidation = function()
			return
		end,

		Concentration = function()
			return
		end,

		Bind = function()
			return
		end,

		Shadow = function()
			return
		end,

		Path = function()
			return
		end,

		Affinity = function(target)
			return
		end,

		Deluge = function()
			return
		end,

		Sire = function()
			return
		end,

		Glance = function()
			return
		end,

		Vision = function()
			return
		end,

		Beckon = function()
			return
		end,

		Will = function()
			return
		end,

		Tune = function()
			return
		end,

		Monitor = function()
			return
		end,

		Invigorate = function()
			return
		end,

		Aegis = function()
			return
		end,

		Rile = function()
			return
		end,

		Embrace = function()
			return
		end,

		Poison = function(target)
			rime.pvp.add_aff("blood_poison", target)
		end,

		Curse = function(target)
			rime.pvp.add_aff("blood_curse", target)
		end,

		Spew = function(target)
			rime.pvp.add_aff("no_blind", target)
			rime.pvp.add_aff("no_deaf", target)
			prae.can_spew = false
			if not rime.attacks.personal then
				rime.time(target, "eq", 3)
			end
		end,

		Rune = function(target)
			rime.pvp.add_aff("blood_rune", target)
		end,

		Enrage = function()
			return
		end,

		Strengthen = function()
			return
		end,

		Feast = function(target)
			rime.pvp.add_aff("feast", target)
		end,

		Seize = function(target)
			return
		end,

		Pillar = function()
			return
		end,
	},
	["Corpus"] = {

		Mend = function(target)
			return
		end,

		Feed = function(target)
			return
		end,

		Earthmeld = function()
			return
		end,

		Eminence = function()
			return
		end,

		Frenzy = function(target, effect)
			rime.pvp.aggro(target)
			if effect == "miss" then
				return
			end
			if (effect ~= "quell" and effect ~= "sunder") and effect then
				rime.pvp.add_limb(effect, target, 899)
			else
				rime.pvp.noDef("shielded", target)
			end
		end,

		Chill = function(target)
			rime.pvp.add_aff("caloric", target)
		end,

		Nightsight = function()
			return
		end,

		Elusion = function()
			return
		end,

		Lifescent = function()
			return
		end,

		Hide = function()
			return
		end,

		Masquerade = function()
			return
		end,

		WolfForm = function()
			return
		end,

		Stalking = function()
			return
		end,

		Deadbreath = function(target)
			rime.pvp.add_aff("slickness", target)
			rime.pvp.noDef("fangbarrier", target)
			rime.pvp.web_whisper1 = "anorexia"
		end,

		Clotting = function()
			return
		end,

		Catching = function()
			return
		end,

		Clawing = function(target)
			rime.pvp.add_aff("rend", target)
		end,

		Fortify = function()
			return
		end,

		BatForm = function()
			return
		end,

		Celerity = function()
			return
		end,

		Blocking = function(direction)
			rime.echo(string.upper(direction) .. " HAS BEEN BLOCKED")
		end,

		Sunder = function(target)
			rime.pvp.noDef("shielded", target)
		end,

		MistForm = function()
			return
		end,

		Mending = function()
			return
		end,

		Lifesecent = function()
			return
		end,

		Warding = function()
			return
		end,

		Veil = function()
			return
		end,

		Gash = function(target)
			rime.pvp.aggro(target)
			rime.last_hit = target
			rime.pvp.web_venoms()
		end,

		Fling = function(target)
			if rime.attacks.personal then
				prae.can_fling = false
			end
			act("ql")
		end,

		Entomb = function()
			return
		end,

		Deathlink = function()
			return
		end,

		Potence = function()
			return
		end,

		Fade = function()
			return
		end,

		Reconstruct = function(user, limb)
			if user == "You" then
				return
			end
			local limb = limb:gsub(" ", "_")
			rime.pvp.remove_limb(limb, 1500, matches[2])
			local dmg = rime.targets[matches[2]].limbs[limb]
			if rime.pvp.has_aff(limb .. "_mangled", user) and dmg < 6666 then
				rime.pvp.remove_aff(limb .. "_mangled", user)
			elseif rime.pvp.has_aff(limb .. "_damaged", user) and dmg < 3333 then
				rime.pvp.remove_aff(limb .. "_damaged", user)
			end
		end,

		Purify = function()
			return
		end,
	},

	--#Indorani
	["Tarot"] = {
		Charging = function(target)
			return
		end,

		Inscribing = function(target)
			return
		end,

		Cardpacks = function(target)
			return
		end,

		Emperor = function(target)
			return
		end,

		Magician = function(target)
			return
		end,

		Priestess = function(target)
			rime.targets[target].aggro = rime.targets[target].aggro - 1
		end,

		Fool = function(target)
			rime.pvp.aggro_count_down()
			return
		end,

		Chariot = function(target)
			return
		end,

		Hermit = function(target)
			return
		end,

		Empress = function(target)
			if target == rime.target and indo.need_empress then
				indo.need_empress = false
				if rime.pvp.ai then
					rime.pvp.offense()
				end
			end
		end,

		Sun = function(target)
			if rime.attacks.personal then
				--indo.eclipse = indo.eclipse + 1
			end
			if rime.pvp.web_sun then
				rime.pvp.add_aff(rime.pvp.web_sun, target)
			end
		end,

		Lovers = function(target)
			rime.pvp.add_aff("lovers_effect", target)
		end,

		Hierophant = function(target)
			return
		end,

		Sandman = function(target)
			if not rime.pvp.has_def("insomnia", target) then
				rime.pvp.add_aff("asleep", target)
			else
				rime.pvp.noDef("insomnia", target)
			end
		end,

		Hangedman = function(target, arg)
			if arg == "prone" then
				rime.pvp.add_aff("prone", target)
			elseif arg == "entangle" then
				rime.pvp.add_aff("writhe_ropes", target)
			end
		end,

		Warrior = function(target, limb)
			rime.pvp.add_limb(limb, target, 1250)
		end,

		Tower = function(target)
			rime.echo("Exits have been <red>rubbled", "pvp")
		end,

		Wheel = function(target)
			indo.can_wheel = false
			local not_affs = { "leeched_aura", "no_deaf", "no_blind", "writhe_ropes" }
			local affs = {}
			for k, v in pairs(rime.targets[target].afflictions) do
				if v and not table.contains(not_affs, k) then
					table.insert(affs, k)
				end
			end
			if #affs < 2 then
				rime.pvp.remove_aff(affs[1], target)
			else
				indo.need_diag = true
			end
			delitem(affs, "impatience")
			delitem(affs, "paresis")
			indo.wheeled_affs = affs
		end,

		Creator = function(target, type)
			if rime.attacks.personal then
				indo.can_creator = false
				if rime.pvp.ai then
					rime.pvp.offense()
				end
			end
			if type == "demonscape" then
				rime.echo(class_color() .. "fking yikes dawg")
			elseif type == "dreamscape" then
				rime.echo(class_color() .. "GO TO SLEEP BITCH. DIE, DIE, WHY ARE YOU STILL ALIVE?!")
			end
		end,

		Adder = function(target)
			if target == "you" then
				if matches[3] == "Tarot" then
					rime.curing.adder = true
				else
					rime.curing.diamond = true
				end
				return
			end
			indo.add_ready = false
			rime.targets[target].adder = true
			rime.pvp.add_aff("haemophilia", target)
		end,

		Justice = function(target)
			rime.pvp.add_aff("justice", target)
		end,

		Star = function(target)
			return
		end,

		Aeon = function(target)
			rime.pvp.aggro(target)
		end,

		Eclipse = function(target)
			return
		end,

		Lust = function(target)
			return
		end,

		Universe = function(target)
			rime.echo("Hey, that's a <purple>UNIVERSE Tarot!")
		end,

		Despair = function(target)
			return
		end,

		Devil = function(target)
			return
		end,

		Moon = function(target)
			if rime.attacks.personal then
				--indo.eclipse = indo.eclipse + 1
			end
			if rime.pvp.web_moon then
				rime.pvp.add_aff(rime.pvp.web_moon, target)
			end
		end,

		Death = function(target)
			rime.echo(target .. " is gonna die soon.")
		end,

		Imprint = function(target)
			return
		end,
	},
	["Domination"] = {
		Dervish = {
			Act = function()
				for k, v in pairs(rime.targets) do
					rime.targets[k].defences.flight = false
				end
			end,
		},

		Sycophant = function(target)
			return
		end,

		Gremlin = function(target)
			return
		end,

		Transcendence = function(target)
			return
		end,

		ChaosOrb = function(target)
			return
		end,

		Bloodleech = function(target)
			return
		end,

		Firelord = function(target)
			return
		end,

		Minion = function(target)
			return
		end,

		Worm = function(target)
			return
		end,

		Mask = function(target)
			return
		end,

		Slime = {
			Envelop = function()
				return
			end,
		},

		Pathfinder = function(target)
			return
		end,

		Soulmaster = function(target)
			return
		end,

		Humbug = function(target)
			return
		end,

		Chimera = {
			Roar = function(target)
				if rime.attacks.personal then
					indo.can_chimera = false
				end
				rime.pvp.add_aff("no_deaf", target)
			end,
			Headbutt = function(target)
				if rime.attacks.personal then
					indo.can_chimera = false
				end
				return
			end,
			Gas = function(target)
				rime.pvp.noDef("insomnia", target)
				if rime.attacks.personal then
					indo.can_chimera = false
				end
				return
			end,
		},

		Bubonis = function(target)
			return
		end,

		Doppleganger = function(target)
			return
		end,

		Storm = function(target)
			return
		end,

		Gatekeeper = function(target)
			return
		end,

		Hound = function(target)
			return
		end,

		Link = function(target)
			return
		end,

		Crone = function(target)
			return
		end,

		Pit = function(target)
			rime.targets[target].aggro = rime.targets[target].aggro + 100
			return
		end,
	},
	["Necromancy"] = {
		
		Deathsight = function(target)
			return
		end,

		Essence = function(target)
			return
		end,

		Decay = function(target)
			return
		end,

		Dissect = function(target)
			return
		end,

		Chill = function(target)
			rime.targets[target].chilled_count = rime.targets[target].chilled_count + 3
			rime.echo(
				"Current chill count for <red>"
					.. target
					.. "<white> is <royal_blue>"
					.. rime.targets[target].chilled_count
					.. "<white>."
			)
		end,

		Nightsight = function(target)
			return
		end,

		Sense = function(target)
			return
		end,

		Night = function(target)
			return
		end,

		Shroud = function(target)
			return
		end,

		Screech = function(target)
			for _, v in ipairs(gmcp.Room.Players) do
				rime.pvp.add_aff("no_deaf", v.name)
			end
		end,

		Belch = function(target)
			return
		end,

		Taint = function(target)
			return
		end,

		Leech = function(target)
			if target ~= "you" then
				rime.targets[target].leeching = true
			end
		end,

		Bonedagger = function(target)
			rime.last_hit = target
			rime.pvp.ignore_rebounding = true
			rime.pvp.web_venoms_noreb()
		end,

		Lifevision = function(target)
			return
		end,

		Shrivel = function(target, limb)
			if limb ~= "legs" and limb ~= "arms" then
				if limb == "throat" then
					rime.pvp.add_aff("crippled_throat", target)
				else
					rime.pvp.add_aff(limb .. "_crippled", target)
					rime.pvp.aggro(target)
				end
			end
		end,

		Soulmask = function(target)
			return
		end,

		Cannibalism = function(target)
			return
		end,

		Ectoplasm = function(target)
			return
		end,

		Morisensus = function(target)
			return
		end,

		Putrefaction = function(target)
			return
		end,

		Solidify = function(target)
			return
		end,

		Drain = function(target)
			return
		end,

		Deathaura = function(target)
			return
		end,

		Bonehelm = function(target)
			return
		end,

		Deform = function(target)
			rime.pvp.add_aff("deform", target)
		end,

		Gravehands = function(target)
			return
		end,

		Gravechill = function(target)
			return
		end,

		Rot = function(target)
			return
		end,

		Desecration = function(target)
			return
		end,

		Vengeance = function(target)
			return
		end,

		Regeneration = function(target)
			return
		end,

		Blackwind = function(target)
			return
		end,

		Vivisect = function(target)
			return
		end,

		Soulcage = function(target)
			if rime.attacks.personal then
				rime.reset()
			else
				rime.pvp.clear_target(target)
			end
		end,
	},

     --Teradrim

	["Terramancy"] = {

		Earthenmaw = function()
			return
		end,

		Inscribe = function()
			return
		end,

		Formation = function()
			return
		end,

		Batter = function(target, limb)
			limb = limb or "nothing"
			rime.last_hit = target
			local hit_limb = limb:gsub(" ", "_")
			rime.pvp.lastLimbHit = hit_limb
			if rime.pvp.runemark_major == "red" then
				rime.pvp.lastLimb_damage = 1804
				rime.pvp.add_limb(limb, target, 1804)
			else
				rime.pvp.lastLimb_damage = 1440
				rime.pvp.add_limb(limb, target, 1440)
			end
		end,

		Absorb = function()
			return
		end,

		Stonebind = function()
			return
		end,

		Surefooted = function()
			return
		end,

		Entwine = function()
			return
		end,

		Slam = function(target, limb)
			rime.last_hit = target
			if target == "you" then return end
			local hit_limb = limb:gsub(" ", "_")
			rime.pvp.lastLimbHit = hit_limb
			if rime.pvp.runemark_major == "red" then
				rime.pvp.lastLimb_damage = 1312
				rime.pvp.add_limb(limb, target, 1312)
			else
				rime.pvp.lastLimb_damage = 1049
				rime.pvp.add_limb(limb, target, 1049)
			end
			if rime.pvp.has_aff(limb.."_bruised_critical", target) then
				rime.pvp.last_affliction = limb.."_bruised_critical"
				return
			elseif rime.pvp.has_aff(limb.."bruised_moderate", target) then
				rime.pvp.last_affliction = limb.."_bruised_critical"
				rime.pvp.add_aff(limb.."_bruised_critical", target)
			elseif rime.pvp.has_aff(limb.."bruised", target) then
				rime.pvp.last_affliction = limb.."_bruised_moderate"
				rime.pvp.add_aff(limb.."_bruised_moderate", target)
			else
				rime.pvp.last_affliction = limb.."_bruised"
				rime.pvp.add_aff(limb.."_bruised", target)
			end
		end,

		Stoneblast = function(target)
			if rime.pvp.has_def("rebounding", target) then
			end
		end,

		Resonance = function()
			return
		end,

		Facesmash = function(target)
			rime.last_hit = target
			rime.pvp.lastLimbHit = "head"
			
			if not rime.pvp.has_def("rebounding", target) then
				if rime.pvp.runemark_major == "red" then
					rime.pvp.add_limb("head", target, 1706)	
					rime.pvp.lastLimb_damage = 1706
				else
					rime.pvp.add_limb("head", target, 1365)	
					rime.pvp.lastLimb_damage = 1365
				end		
			end
		end,

		Stonefury = function()
			return
		end,

		Grasp = function(target)
			rime.last_hit = target
		end,

		Rockshower = function()
			return
		end,

		Gutsmash = function(target)
			rime.last_hit = target
			rime.pvp.lastLimbHit = "torso"
			rime.pvp.lastLimb_damage = 1260
			if not rime.pvp.has_def("rebounding", target) then
				if rime.pvp.runemark_major == "red" then
					rime.pvp.add_limb("torso", target, 1574)	
					rime.pvp.lastLimb_damage = 1574
				else
					rime.pvp.add_limb("torso", target, 1259)	
					rime.pvp.lastLimb_damage = 1259
				end				
			end
			-- if rime.pvp.runemark_major == "green" then
			-- 	rime.pvp.add_aff("heartflutter", target)
			-- end
		end,

		Quake = function()
			return
		end,

		Erosion = function()
			return
		end,

		Runemark = function()
			return
		end,

		Earthenpass = function(target)
			return
		end,

		Chasm = function(target)
			return
		end,

		Fracture = function(target, limb)
			rime.last_hit = target
			if target == "you" then return end
			local hit_limb = limb:gsub(" ", "_")
			rime.pvp.lastLimbHit = hit_limb
			
			if rime.pvp.has_aff(limb.."_bruised_critical", target) then
				if rime.pvp.runemark_major == "red" then
					rime.pvp.lastLimb_damage = 2900
					rime.pvp.add_limb(limb, target, 2900)
				else
					rime.pvp.lastLimb_damage = 2400
					rime.pvp.add_limb(limb, target, 2400)
				end
			elseif rime.pvp.has_aff(limb.."_bruised_moderate", target) then
				if rime.pvp.runemark_major == "red" then
					rime.pvp.lastLimb_damage = 2500
					rime.pvp.add_limb(limb, target, 2500)
				else
					rime.pvp.lastLimb_damage = 2000
					rime.pvp.add_limb(limb, target, 2000)
				end
			elseif rime.pvp.has_aff(limb.."_bruised", target) then
				if rime.pvp.runemark_major == "red" then
					rime.pvp.lastLimb_damage = 2000
					rime.pvp.add_limb(limb, target, 2000)
				else
					rime.pvp.lastLimb_damage = 1600
					rime.pvp.add_limb(limb, target, 1600)
				end
			elseif rime.pvp.runemark_major == "red" then
				rime.pvp.lastLimb_damage = 1600
				rime.pvp.add_limb(limb, target, 1600)
			else
				rime.pvp.lastLimb_damage = 1200
				rime.pvp.add_limb(limb, target, 1200)
			end
		end,

		Impale = function(target)
			rime.pvp.add_aff("writhe_impaled", target)
			rime.pvp.add_aff("tera_impaled", target)
			rime.pvp.add_limb("torso", target, 1250)
			if target == rime.target then rime.pvp.target_tumbling = false end
		end,

		Steady = function()
			return
		end,

		Ricochet = function()
			return
		end,

		Stonevice = function(target)
			rime.pvp.remove_aff("writhe_impaled", target)
			rime.pvp.remove_aff("tera_impaled", target)
			rime.pvp.add_aff("lightwound", target)
			rime.pvp.add_aff("deepwound", target)
			rime.pvp.add_limb("torso", target, 950)
		end,

		Furor = function(target, limb)
			rime.last_hit = target
			if target == "you" then return end
			local hit_limb = limb:gsub(" ", "_")
			rime.pvp.lastLimbHit = hit_limb
			if rime.pvp.runemark_major == "red" then
				rime.pvp.lastLimb_damage = 1024
				rime.pvp.add_limb(limb, target, 1024)
			else
				rime.pvp.lastLimb_damage = 817
				rime.pvp.add_limb(limb, target, 817)
			end
		end,

		Overhand = function(target)
			rime.last_hit = target
			rime.pvp.add_aff("prone", target)
		end,

		Momentum = function()
			return
		end,

		Pulp = function(target)
			if target == "you" then return end
			rime.pvp.aggro(target)
			rime.last_hit = target
			rime.pvp.lastLimbHit = "torso"
			rime.pvp.add_aff("collapsed_lung", target)
			rime.pvp.add_limb("torso", target, 699)
		end,

		Earthenwill = function()
			return
		end,

		Barrage = function(target)
			rime.last_hit = target
		end,

        Skullbash = function(target)
            if target == "you" then return end
            rime.last_hit = target
			rime.pvp.lastLimbHit = "head"
			
			if not rime.pvp.has_def("rebounding", target) then
				if rime.pvp.runemark_major == "red" then
					rime.pvp.lastLimb_damage = 2099
					rime.pvp.add_limb("head", target, 2099)
				else
					rime.pvp.lastLimb_damage = 1676
					rime.pvp.add_limb("head", target, 1676)
				end		
	            if rime.pvp.has_aff("head_bruised", target) then rime.pvp.add_aff("whiplash", target) end
	            if rime.pvp.has_aff("head_bruised_moderate", target) then rime.pvp.add_aff("indifference", target) end
	            if rime.pvp.has_aff("head_bruised_critical", target) then rime.pvp.add_aff("smashed_throat", target) end
			end
        end,

		Shockwave = function(target)
			rime.last_hit = target
			rime.pvp.add_aff("prone", target)
		end,

		Hammer = function(target)
			rime.last_hit = target
		end,

		Earthenform = function()
			return
		end,
	},

	["Desiccation"] = {
		Scour = function()
			if rime.attacks.personal then return end
			rime.time("lockbreaker", target)
		end,

		Flood = function()
			return
		end,

		Sandwalk = function()
			return
		end,

		Surge = function()
			return
		end,

		Trap = function(target)
			rime.last_hit = target
			rime.teradrim.can_trap = false
			rime.pvp.add_aff("sand_trapped", target)
			limitStart(target.."_sand_trapped", 30)		
		end,

		Presences = function()
			return
		end,

		Regeneration = function()
			return
		end,

		Ruminate = function()
			return
		end,

		Sandstorm = function()
			return
		end,

		Concealment = function()
			return
		end,

		Desiccate = function()
			return
		end,

		Shift = function(target)
			rime.last_hit = target
		end,

		Disturbances = function()
			return
		end,

		Blast = function()
			return
		end,

		Simoon = function(target)
			rime.last_hit = target
		end,

		Distort = function()
			return
		end,

		Shield = function(target)
			if target == "you" then return end
			rime.pvp.addDef("shielded", target)
		end,

		Swelter = function()
			return
		end,

		Confound = function()
			return
		end,

		Projection = function()
			return
		end,

		Wave = function(target)
			rime.last_hit = target
		end,

		Instability = function()
			return
		end,

		Spikes = function()
			return
		end,

		Harshen = function()
			return
		end,

		Desert = function()
			return
		end,

		Whirl = function()
			return
		end,

		Meld = function()
			return
		end,

		Pillar = function()
			return
		end,

		Whip = function(target)
			rime.last_hit = target
		end,

		Scourge = function(target)
			rime.last_hit = target
		end,

		Slice = function(target)
			rime.last_hit = target
		end,

		Shred = function(target, limb)
			rime.last_hit = target
			if target == "you" then return end
			local hit_limb = limb:gsub(" ", "_")
			rime.pvp.lastLimbHit = hit_limb
			rime.pvp.lastLimb_damage = 700
			rime.pvp.add_limb(limb, target, 700)
		end,

		Curse = function(target)
			rime.pvp.add_aff("slough", target)
			limitStart(target.."_slough", 10)
		end,

		Quicksand = function(target)
			rime.last_hit = target
			rime.pvp.add_aff("quicksand", target)
			limitStart(target.."_quicksand", 20)
		end,
    },

    ["Animation"] = {
		Animate = function()
			return
		end,

		Instruct = function()
			return
		end,

		Imprinting = function()
			return
		end,

		Erasure = function()
			return
		end,

		Movement = function()
			return
		end,

		Earthpaint = function()
			return
		end,

		Listening = function()
			return
		end,

		Escape = function()
			return
		end,

		Glance = function()
			return
		end,

		Priority = function()
			return
		end,

		Recover = function()
			return
		end,

		Bodylink = function()
			return
		end,

		Memory = function()
			return
		end,

		Servant = function()
			return
		end,

		Twinsoul = function()
			return
		end,

		Intertwine = function()
			return
		end,

		Vigilance = function()
			return
		end,

		Strike = function()
			return
		end,

		Barrel = function(target)
			return
		end,

		Heartpunch = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("heartflutter", target)
		end,

		Rip = function(target)
			return
		end,

		Wrack = function(target)
			return
		end,

		Shout = function(target)
			return
		end,

		Grapple = function(target)
			return
		end,

		Shatter = function(target)
			rime.pvp.noDef("shielded", target)
		end,

		Pummel = function(target)
			return
		end,

		Choke = function(target)
			rime.pvp.add_aff("blurry_vision", target)
		end,

		Wrench = function(target, limb)
			rime.pvp.aggro(target)
    		rime.pvp.add_aff(limb.."_dislocated", target)		
		end,

		Knockdown = function(target)
			return
		end,

		Corner = function()
			return
		end,

		Fend = function()
			return
		end,

		Airguard = function()
			return
		end,

		Rattle = function(target)
			return
		end,

		Prop = function()
			return
		end,

		Cycling = function()
			return
		end,

		Shake = function(target)
			return
		end,

		Kneeshatter = function(target)
			return
		end,

		Steadfast = function()
			return
		end,
    },

	--#Archivist

	["Cultivation"] = {},

	["Enlightenment"] = {},

	["Voidgazing"] = {},

	["Numerology"] = {
		Forget = function(target)
			return
		end,

		Primality = function(target)
			return
		end,

		Duality = function(target)
			return
		end,

		Triunity = function(target)
			return
		end,

		Spheres = function(target)
			return
		end,

		Empower = function(target)
			return
		end,

		Fix = function(target)
			return
		end,

		Settle = function(target)
			return
		end,

		Position = function(target)
			return
		end,

		Collapse = function(target)
			return
		end,

		Oneness = function(target)
			return
		end,

		Retrieve = function(target)
			return
		end,

		Glimpse = function(target)
			return
		end,

		Absorb = function(target)
			return
		end,

		Ascent = function(target)
			return
		end,

		Veil = function(target)
			return
		end,

		Changeheart = function(target)
			if target == "you" then
				rime.hidden_aff("changeheart")
				rime.check_hidden()
				rime.need_enemy = true
				return
			end
			rime.last_hit = target
			rime.pvp.web_venoms_noreb()
		end,

		Bloodwork = function(target)
			return
		end,

		Sublimation = function(target)
			return
		end,

		Weakness = function(target)
			return
		end,

		Formation = function(target)
			return
		end,

		Stream = function(target)
			return
		end,

		Affliction = function(target)
			if target == "you" then
				rime.hidden_aff("affliction")
				rime.check_hidden()
			end
		end,

		Dilation = function(target)
			return
		end,

		Symphony = function(target)
			return
		end,

		Syncopate = function(target)
			if target ~= "you" then
				local extraTime = 3 + rime.pvp.mental_count(target)
				for k, v in spairs(rime.targets[target].cooldowns) do
					if v == true then
						local timeLeft, totalTime = 0, 0
						if rime.targets[target].time[k .. "CD"] ~= nil then
							timeLeft = remainingTime(rime.targets[target].time[k .. "CD"])

							killTimer(rime.targets[target].time[k .. "CD"])
							rime.targets[target].time[k .. "CD"] = tempTimer(timeLeft + extraTime, function()
								rime.targets[target].cooldowns[k] = false
							end)
							rime.echo(
								"Syncopate hit "
									.. k
									.. " for "
									.. target
									.. ": CD is now "
									.. string.format("%4.1f", remainingTime(rime.targets[target].time[k .. "CD"]))
									.. "s away!",
								"pvp"
							)
							--echo("extraTime was "..extraTime..", and timeLeft was "..timeLeft..". But it is now "..remainingTime(rime.targets[target].time[k.."CD"]).."\n")
						end
						if rime.targets[target].time[k .. "Balance"] ~= nil then
							totalTime = rime.targets[target].time[k .. "Balance"]
						end
					end
				end
			end
			if rime.attacks.personal and target == rime.target then
				archivist.cooldowns.syncopate = true
			end
			return
		end,

		Link = function(target)
			return
		end,

		Return = function(target)
			return
		end,

		Madness = function(target)
			if rime.attacks.personal then
				archivist.cooldowns.madness = true
			end
			rime.pvp.add_aff("dementia", target)
			rime.pvp.add_aff("hallucinations", target)
			rime.pvp.add_aff("paranoia", target)
		end,

		Unravel = function(target)
			return
		end,

		Recollection = function(target)
			if rime.attacks.personal and archivist.toggles.recollection then
				archivist.toggle_rec()
			end
			return
		end,
	},

	["Geometrics"] = {
		Codex = function(target)
			return
		end,

		Incite = function(target)
			return
		end,

		Shape = function(target, hidden)
			if not hidden then
				return
			end
			if target == "you" then
				rime.hidden_aff("shapes")
				rime.check_hidden()
			end
		end,

		Token = function(target)
			return
		end,

		Impress = function(target)
			return
		end,

		Afterimage = function(target)
			return
		end,

		Invert = function(target)
			if rime.attacks.personal then
				archivist.token.invert = true
			end
			return
		end,

		Trace = function(target)
			if rime.attacks.personal then
				archivist.token.trace = true
				if target ~= nil then
					archivist.token.traceTarget = target
				end
			end
			return
		end,

		Conjoin = function(target)
			if rime.attacks.personal then
				archivist.cooldowns.conjoin = true
			end
			if target == "you" then
				--DO nothing for now but probably need to add pre-checks or w/e.
			end
			return
		end,

		Pattern = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("patterns", target)
		end,

		Sealing = function(target)
			return
		end,

		Matrix = function(target)
			rime.pvp.aggro(target)
		end,

		Crux = function(target)
			rime.pvp.aggro(target)
		end,

		Fork = function(target)
			rime.pvp.noDef("shielded", target)
		end,

		Triangle = function(target)
			rime.pvp.add_aff("Triangle", target)
		end,

		Square = function(target)
			rime.pvp.add_aff("Square", target)
		end,

		Circle = function(target)
			rime.pvp.add_aff("Circle", target)
		end,

		Swirl = function(target)
			return
		end,

		Arrow = function(target)
			return
		end,

		Lens = function(target)
			if rime.attacks.personal then
				archivist.token.trace = false
				archivist.token.traceTarget = ""
				archivist.token.invert = false
			end
			return
		end,

		Wave = function(target)
			return
		end,

		Bloom = function(target)
			return
		end,

		Rod = function(target)
			return
		end,

		Crescent = function(target)
			if target == "you" then
				return
			end
			if not rime.attacks.personal then
				rime.targets[target].geoCrescent = true
			end
			return
		end,

		Hex = function(target)
			if not rime.attacks.personal and target ~= "you" then
				rime.targets[target].geoHex = true
			end
			return
		end,

		Star = function(target)
			return
		end,

		Lemniscate = function(target)
			rime.pvp.add_aff("lemniscate", target)
			return
		end,
	},

	["Bioessence"] = {
		Energy = function(target)
			return
		end,

		Jolt = function(target)
			return
		end,

		Diagnose = function(target)
			return
		end,

		Infection = function(target)
			if rime.attacks.personal then
				rime.pvp.add_aff("mutagen", target)
				return
			else
				if rime.pvp.has_aff("mutagen", rime.target) then
					rime.pvp.remove_aff("mutagen", rime.target)
					rime.echo("Wtf someone just overwrote your mutagen. Slap them!")
				else
					rime.echo("Someone else has infected with mutagen, AVOID INFECTING!")
				end
			end
			return
		end,

		Preservation = function(target)
			return
		end,

		Preserve = function(target, level)
			if target == "you" then
				return
			end
			if level == "mild" then
				rime.pvp.add_aff("caloric", target)
			end
			if level == "moderate" then
				rime.pvp.add_aff("caloric", target)
				rime.pvp.add_aff("caloric", target)
			end
			if level == "severe" then
				rime.pvp.add_aff("caloric", target)
				rime.pvp.add_aff("caloric", target)
				rime.pvp.add_aff("caloric", target)
			end
		end,

		Tension = function(target)
			return
		end,

		Knitting = function(target)
			if rime.attacks.personal and archivist.toggles.knitting then
				archivist.toggle_knit()
			end
			return
		end,

		Flare = function(target)
			rime.pvp.aggro(target)
			if string.lower(target) ~= "you" then
				archivist.flared = true
				act("bio flare " .. target)
			end
		end,

		Steroid = function(target)
			return
		end,

		Probe = function(target)
			return
		end,

		Adaptation = function(target)
			return
		end,

		Osmosis = function(target)
			return
		end,

		Stimulant = function(target)
			return
		end,

		Ethereal = function(target)
			if rime.attacks.personal and archivist.toggles.ethereal then
				archivist.toggle_ethereal()
			end
			return
		end,

		Catabolism = function(target)
			return
		end,

		Ameliorate = function(target)
			return
		end,

		Growth = function(target)
			if rime.attacks.personal then
				--tempTimer(3.6, [[archivist.wait_growth = true]])
			end
			return
		end,

		Autonomy = function(target)
			return
		end,

		Nexus = function(target)
			return
		end,

		Advance = function(target)
			if rime.attacks.personal then
				rime.pvp.add_aff("mutagen", target)
				return
			else
				if rime.pvp.has_aff("mutagen", rime.target) then
					rime.echo("Wtf someone just overwrote your mutagen. Slap them!")
				else
					rime.echo("Someone else has infected with mutagen, AVOID INFECTING!")
				end
			end
			return
		end,

		Mutagen = function(target)
			return
		end,

		Depressant = function(target)
			return
		end,

		Acute = function(target)
			return
		end,

		Somnolent = function(target)
			return
		end,

		Psychoactive = function(target)
			return
		end,

		Virulent = function(target)
			rime.pvp.aggro(target)
			rime.pvp.ignore_rebounding = true
			rime.last_hit = target
			rime.pvp.web_venoms_noreb()
		end,

		Reactive = function(target)
			return
		end,

		Narcotic = function(target)
			return
		end,

		Chronic = function(target)
			return
		end,

		Degenerative = function(target)
			return
		end,

		Malignant = function(target)
			return
		end,

		Sporatic = function(target)
			return
		end,

		Atrophic = function(target)
			return
		end,

		Morphic = function(target)
			return
		end,
	},

	--#Ascendril
	["Thaumaturgy"] = {

		Shift = function(target)
			if rime.target == target then
				act("wt TARGET HAS SHIFTED PICK A NEW TARGET PLEASE")
			end
		end,

		Flare = function(target)
			return
		end,

		Stall = function(target)
			return
		end,
	},

	["Elemancy"] = {

		Fireball = function(target)
			return
		end,

		Prism = function(target)
			return
		end,

		Feedback = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.remove_aff("muddled", target)
			rime.targets[target].mana = 100
		end,

		Thunder = function(target)
			rime.pvp.add_aff("stupidity", target)
			rime.pvp.add_aff("dizziness", target)
		end,

		Coldsnap = function(target, element)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_aff("stupidity", target)
			if element == "Fire" then
				rime.pvp.add_aff("recklessness", target)
			elseif element == "Air" then
				rime.pvp.add_aff("masochism", target)
			end
		end,
	},

	["Arcanism"] = {

		Prism = function(caster)
			return
		end,

		Transfix = function(target)
			rime.pvp.add_aff("writhe_transfix", target)
			rime.pvp.add_aff("no_blind", target)
		end,
	},

	--#Alchemist

	["Alchemy"] = {

		Static = function(target)
			rime.pvp.aggro(target)
			return
		end,

		Resuscitation = function(target)
			return
		end,

		Corrosive = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.noDef("shielded", target)
		end,

		Virulent = function(target)
			if target == "you" then
				rime.vitals.damage_expected = true
			else
				rime.pvp.aggro(target)
				rime.last_hit = target
				rime.pvp.web_venoms_noreb()
				return
			end
		end,

		Upset = function(target)
			rime.pvp.aggro(target)
			return
		end,

		Intrusive = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("lifebane", target)
		end,

		Electroshock = function(target)
			if target == "you" then
				return
			else
				rime.pvp.add_aff("paresis", target)
				rime.pvp.add_aff("stupidity", target)
				rime.pvp.aggro(target)
			end
		end,

		Incendiary = function(target)
			rime.pvp.aggro(target)
			return
		end,

		Malignant = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("vitalbane", target)
		end,

        Discorporate = function(target, failure)
            if failure then
                rime.echo("u suck")
            else
                rime.echo("Omae Wa Mou Shindeiru")
                rime.targets[target].disabled = true
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
        end,

		Fulmination = function(target)
			rime.pvp.aggro(target)
			return
		end,

		Neurotic = function(target)
			if target == "you" then
				rime.add_possible_aff("hallucinations")
			else
				rime.pvp.add_aff("confusion", target)
				rime.pvp.add_aff("impatience", target)
				rime.pvp.aggro(target)
			end
		end,

		Currents = function(target)
			if target == "you" then
				rime.vitals.damage_expected = true
			else
				rime.pvp.aggro(target)
				rime.targets[target].currents = 2
			end
		end,

		Parity = function(target)
			rime.pvp.aggro(target)
			return
		end,

		Infiltrative = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("infested", target)
		end,

		Rousing = function(target, who)
			if who ~= "ally" then
				rime.pvp.aggro(target)
				rime.pvp.add_aff("no_deaf", target)
				rime.pvp.add_aff("no_blind", target)
				rime.pvp.add_aff("sensitivity", target)
			end
		end,

		Pathogen = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("blighted", target)
		end,

		Preparation = function(target, ability)
			if target == "You" then
				alchemist.prepared = ability
			end
		end,

		Catalysed = {

			Static = function(target)
				rime.pvp.aggro(target)
			end,

			Upset = function(target)
				rime.pvp.aggro(target)
				return
			end,

			Virulent = function(target)
				if target == "you" then
					rime.curing.vinethorns = rime.curing.vinethorns + 1
				else
					rime.pvp.aggro(target)
					rime.last_hit = target
					rime.pvp.web_venoms_noreb()
					rime.pvp.add_aff("fragments", target)
				end
			end,

			Intrusive = function(target)
				rime.pvp.aggro(target)
				rime.pvp.add_aff("lifebane", target)
				rime.pvp.add_aff("plodding", target)
			end,

			Electroshock = function(target)
				if target == "you" then
					rime.curing.shamans_are_bullshit = true
				else
					rime.pvp.aggro(target)
					rime.pvp.add_aff("stupidity", target)
					rime.pvp.add_aff("paresis", target)
					rime.pvp.add_aff("blackout", target)
				end
			end,

			Incendiary = function(target)
				rime.pvp.aggro(target)
				return
			end,

			Malignant = function(target)
				rime.pvp.aggro(target)
				rime.pvp.add_aff("vitalbane", target)
				rime.pvp.add_aff("idiocy", target)
			end,

			Fulmination = function(target)
				rime.pvp.aggro(target)
				rime.pvp.add_aff("thunderstorm", target)
			end,

			Neurotic = function(target)
				rime.pvp.aggro(target)
				rime.pvp.add_aff("impatience", target)
				rime.pvp.add_aff("confusion", target)
				rime.pvp.add_aff("hallucinations", target)
			end,

			Currents = function(target)
				rime.pvp.aggro(target)
				if target == "you" then
					rime.hidden_aff("staticburst")
					rime.check_hidden()
				else
					rime.targets[target].currents = 3
				end
			end,

			Parity = function(target)
				rime.pvp.aggro(target)
				rime.pvp.add_aff("justice", target)
			end,

			Infiltrative = function(target)
				rime.pvp.aggro(target)
				if rime.attacks.personal then
					alchemist.boosted_infiltrate = true
				end
			end,

			Rousing = function(target, who)
				if who ~= "ally" then
					rime.pvp.aggro(target)
					rime.pvp.add_aff("no_deaf", target)
					rime.pvp.add_aff("no_blind", target)
					rime.pvp.add_aff("sensitivity", target)
				end
			end,

			Pathogen = function(target)
				rime.pvp.aggro(target)
				if rime.attacks.personal then
					alchemist.boosted_pathogen = true
				end
			end,
		},
	},

	["Experimentation"] = {

		Ignitition = function(target)
			return
		end,

		Recall = function(target)
			return
		end,

		Obfuscation = function(target)
			return
		end,

		Crutch = function(target)
			return
		end,

		Cognisance = function(target)
			return
		end,

		Disciplines = function(target)
			return
		end,

		Prognosis = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("dread", target)
		end,

		Hallucinogen = function(target)
			rime.pvp.aggro(target)
			rime.last_hit = target
			rime.pvp.web_venoms_noreb()
		end,

		Exposure = function(target, off)
			if target ~= "You" then
				alchemist.exposed_target = target
			end
		end,

		Causality = function(target)
			rime.targets[target].causality = true
			rime.time("causality", target, 6)
			cecho(
				"\n"
					.. class_color()
					.. "It is, of course, the way of all things. You see, there is only one constant, one universal, it is the only real truth: Causality. Action â reaction; cause â and effect."
			)
		end,
	},

	["Botany"] = {

		Quills = function(target)
			if rime.attacks.personal then
				alchemist.can_quills = false
			else
				rime.echo("Hey someone is protecting " .. target)
			end
		end,

		Subversion = function(target)
			--rly need to start tracking class cures properly
		end,

		Pheromones = function(target)
			rime.pvp.add_aff("pheromones", target)
		end,

		Frequencies = function(target)
			return
		end,

		Curtail = function(target)
			return
		end,

		Envelop = function(target)
			rime.pvp.addDef("shielded", target)
		end,

		Containment = function(target)
			return
		end,

		Clutching = function(target)
			return
		end,

		Bloodsap = function(target)
			return
		end,

		Fronds = function(target)
			return
		end,

		Decompose = function(target)
			if target == "You" then
				alchemist.can_decompose = false
			end
		end,
	},

	--#Shifter

	["Shapeshifting"] = {

		Scent = function(target)
			return
		end,

		Bodyheat = function(target)
			return
		end,

		Metabolize = function(target)
			return
		end,

		Thickhide = function(target)
			return
		end,

		Endurance = function(target)
			return
		end,

		Pounce = function(target)
			rime.pvp.noDef("shielded", target)
			rime.pvp.aggro(target)
		end,

		Revert = function(target)
			return
		end,

		Swipe = function(target)
			return
		end,

		Sniff = function(target)
			return
		end,

		Salivate = function(target)
			return
		end,

		Rage = function(target)
			for _, aff in ipairs(rime.curing.affsByCure.steroid) do
				if rime.pvp.has_aff(aff, target) then
					rime.pvp.remove_aff(aff, target)
					break
				end
			end
		end,

		Harden = function(target)
			return
		end,

		Return = function(target)
			return
		end,
	},

	["Ferality"] = {

		Slash = function(target, limb)
			rime.last_hit = target
			local hit_limb = limb:gsub(" ", "_")
			rime.pvp.lastLimb_hit = hit_limb
			rime.pvp.lastLimb_damage = 750
			rime.pvp.add_limb(limb, target, 750)
		end,

		Gut = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("torso_mangled", target)
		end,

		Mangle = function(target, limb)
			rime.last_hit = target
			local hit_limb = limb:gsub(" ", "_")
			rime.pvp.lastLimb_hit = hit_limb
			local limbMath = 6667 - rime.targets[rime.target].limbs[hit_limb]
			rime.pvp.aggro(target)
			rime.pvp.add_aff(limb.."_crippled", target)
			rime.pvp.add_aff(limb.."_damaged", target)
			rime.pvp.add_aff(limb.."_mangled", target)
			rime.pvp.add_limb(limb, target, limbMath)
		end,

		Destroy = function(target, limb)
			rime.last_hit = target
			local hit_limb = limb:gsub(" ", "_")
			rime.pvp.lastLimb_hit = hit_limb
			local limbMath = 3334 - rime.targets[rime.target].limbs[hit_limb]
			rime.pvp.aggro(target)
			rime.pvp.add_aff(limb.."_crippled", target)
			rime.pvp.add_aff(limb.."_damaged", target)
			rime.pvp.add_limb(limb, target, limbMath)
		end,

		Thighlock = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("writhe_thighlock", target)
			rime.pvp.add_aff("prone", target)
			if rime.attacks.personal then
				shifter.my_jawlock = true
			else
			shifter.my_jawlock = false
			end
		end,

		Necklock = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("writhe_necklock", target)
			rime.pvp.add_aff("prone", target)
			if rime.attacks.personal then
				shifter.my_jawlock = true
			else
			shifter.my_jawlock = false
			end
		end,

		Armpitlock = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("writhe_armpitlock", target)
			rime.pvp.add_aff("prone", target)
			if rime.attacks.personal then
				shifter.my_jawlock = true
			else
				shifter.my_jawlock = false
			end
		end,
		Skullcrush = function(target)
			rime.pvp.aggro(target)
			rime.last_hit = target
			local hit_limb = limb:gsub(" ", "_")
			rime.pvp.lastLimb_hit = hit_limb
			local limbMath = 6667 - rime.targets[rime.target].limbs[hit_limb]
			rime.pvp.add_aff(limb.."_crippled", target)
			rime.pvp.add_aff(limb.."_damaged", target)
			rime.pvp.add_aff(limb.."_mangled", target)
			rime.pvp.add_limb(limb, target, limbMath)
			rime.pvp.add_aff("prone", target)
		end,

    	Quarter = function(target)
        	rime.pvp.aggro(target, "reset")
        	rime.echo("Bai")
        	if shifter.my_jawlock then
            	shifter.my_jawlock = false
       	 	end
    	end,

		Groinrip = function(target)
			rime.pvp.aggro(target)
			rime.pvp.remove_aff("writhe_thighlock", target)
			rime.pvp.add_aff("ripped_groin", target)
		end,

		Throatrip = function(target)
			rime.pvp.aggro(target)
			rime.pvp.remove_aff("writhe_necklock", target)
			rime.pvp.add_aff("ripped_throat", target)
		end,

		Skullwhack = function(target)
			rime.last_hit = target
			local limb = "head"
			rime.pvp.lastLimb_hit = "head"
			rime.pvp.lastLimb_damage = 750
			rime.pvp.add_limb(limb, target, 750)
		end,

		Faceslash = function(target)
			rime.last_hit = target
			local limb = "head"
			rime.pvp.lastLimb_hit = "head"
			rime.pvp.lastLimb_damage = 750
			rime.pvp.add_limb(limb, target, 750)
			rime.pvp.add_aff("blurry_vision", target)
		end,

		Facemaul = function(target)
			rime.last_hit = target
			local limb = "head"
			rime.pvp.lastLimb_hit = "head"
			rime.pvp.lastLimb_damage = 1179
			rime.pvp.add_limb(limb, target, 1179)
			if rime.pvp.has_aff("blurry_vision", target) then
				rime.pvp.add_aff("mauled_face", target)
			end
		end,

		Jugular = function(target)
			rime.last_hit = target
			local limb = "head"
			rime.pvp.lastLimb_hit = "head"
			rime.pvp.lastLimb_damage = 750
			rime.pvp.add_limb(limb, target, 750)
		end,

		Bite = function(target, limb)
			rime.last_hit = target
			local hit_limb = limb:gsub(" ", "_")
			rime.pvp.lastLimb_hit = hit_limb
			rime.pvp.lastLimb_damage = 899
			rime.pvp.add_limb(limb, target, 899)
		end,

	   Throatslice = function(target)
			rime.last_hit = target
			local limb = "head"
			rime.pvp.lastLimb_hit = "head"
			rime.pvp.lastLimb_damage = 695
			rime.pvp.add_limb(limb, target, 695)
			rime.pvp.add_aff("crippled_throat", target)
		end,


		Hamstring = function(target, limb)
			rime.last_hit = target
			local hit_limb = limb:gsub(" ", "_")
			rime.pvp.lastLimb_hit = hit_limb
			rime.pvp.lastLimb_damage = 565
			rime.pvp.add_limb(limb, target, 565)
			rime.pvp.add_aff(limb.."_crippled", target)
		end,

		Rend = function(target, limb)
			rime.last_hit = target
			local hit_limb = limb:gsub(" ", "_")
			rime.pvp.lastLimb_hit = hit_limb
			rime.pvp.lastLimb_damage = 565
			rime.pvp.add_limb(limb, target, 565)
			rime.pvp.add_aff(limb.."_crippled", target)
		end,

		Bodypunch = function(target)
			rime.last_hit = target
			local limb = "torso"
			rime.pvp.lastLimb_hit = "torso"
			rime.pvp.lastLimb_damage = 700
			rime.pvp.add_limb(limb, target, 700)
		end,

		Spinalcrack = function(target)
			rime.last_hit = target
			local limb = "torso"
			rime.pvp.lastLimb_hit = "torso"
			rime.pvp.lastLimb_damage = 999
			rime.pvp.add_limb(limb, target, 999)
			rime.pvp.add_aff("paresis", target)
		end,

		Spleenrip = function(target)
			rime.pvp.aggro(target)
			rime.pvp.remove_aff("writhe_armpitlock", target)
			rime.pvp.add_aff("torso_damaged", target)
			rime.pvp.add_aff("ripped_spleen", target)
		end,

		Deathroll = function(target)
			rime.pvp.aggro(target)
			rime.pvp.remove_aff("writhe_armpitlock", target)
			rime.pvp.remove_aff("writhe_necklock", target)
			rime.pvp.remove_aff("writhe_thighlock", target)
		end,

		Neckdrag = function(target)
			return
		end,
		
		Spinalrip = function(target)
			rime.last_hit = target
			local limb = "torso"
			rime.pvp.lastLimb_hit = "torso"
			rime.pvp.lastLimb_damage = 750
			rime.pvp.add_limb(limb, target, 750)
			rime.pvp.add_aff("spinal_rip", target)
		end,

		Flurry = function(target)
			rime.last_hit = target
		end,

		Devour = function(target)
			rime.pvp.aggro(target, "reset")
			rime.echo("Om Nom Nom Nom")
		end,

	},

["Vocalizing"] = {

	Boneshaking = function(target)
		return
	end,

	Baying = function(target, aff)
		rime.pvp.aggro(target)
		local aff_conversion = {
			["distasteful"] = "anorexia",
			["terrorizing"] = "fear",
			["piercing"] = "no_deaf",
			["paralyzing"] = "paresis",
			["baleful"] = "impairment",
			["forceful"] = "prone",
		}
		rime.pvp.add_aff(aff_conversion[aff], target)
	end,

	Wailing = function(target, stage)
		if rime.attacks.personal then
			if stage == "begin" then
				shifter.can_howl = false
				table.insert(shifter.howling, "wailing")
				rime.remove_value(shifter.howl_set, "wailing")
			else
				rime.remove_value(shifter.howling, "wailing")
			end
		end
	end,

	Lulling = function(target, stage)
		if rime.attacks.personal then
			if stage == "begin" then
				shifter.can_howl = false
				table.insert(shifter.howling, "lulling")
				rime.remove_value(shifter.howl_set, "lulling")
			else
				rime.remove_value(shifter.howling, "lulling")
			end
		end
	end,

	Befuddling = function(target, stage)
		if rime.attacks.personal then
			if stage == "begin" then
				shifter.can_howl = false
				table.insert(shifter.howling, "befuddling")
				rime.remove_value(shifter.howl_set, "befuddling")
			else
				rime.remove_value(shifter.howling, "befuddling")
			end
		end
	end,

	Disturbing = function(target, stage)
		if rime.attacks.personal then
			if stage == "begin" then
				shifter.can_howl = false
				table.insert(shifter.howling, "disturbing")
				rime.remove_value(shifter.howl_set, "disturbing")
			else
				rime.remove_value(shifter.howling, "disturbing")
			end
		end
	end,

	Attuning = function(target)
		return
	end,

	Paralyzing = function(target, stage)
		if rime.attacks.personal then
			if stage == "begin" then
				shifter.can_howl = false
				table.insert(shifter.howling, "paralysis")
				rime.remove_value(shifter.howl_set, "paralysis")
			else
				rime.remove_value(shifter.howling, "paralysis")
			end
		end
	end,

	Blurring = function(target, stage)
		if rime.attacks.personal then
			if stage == "begin" then
				shifter.can_howl = false
				table.insert(shifter.howling, "blurry")
				rime.remove_value(shifter.howl_set, "blurry")
			else
				rime.remove_value(shifter.howling, "blurry")
			end
		end
	end,

	Baleful = function(target, stage)
		if rime.attacks.personal then
			if stage == "begin" then
				shifter.can_howl = false
				table.insert(shifter.howling, "baleful")
				rime.remove_value(shifter.howl_set, "baleful")
			else
				rime.remove_value(shifter.howling, "baleful")
			end
		end
	end,

	Snarling = function(target, stage)
		return
	end,

	Rousing = function(target, stage)
		if rime.attacks.personal then
			if stage == "begin" then
				shifter.can_howl = false
				table.insert(shifter.howling, "rousing")
				rime.remove_value(shifter.howl_set, "rousing")
			else
				rime.remove_value(shifter.howling, "rousing")
			end
		end
	end,

	Distasteful = function(target, stage)
		if rime.attacks.personal then
			if stage == "begin" then
				shifter.can_howl = false
				table.insert(shifter.howling, "anorexia")
				rime.remove_value(shifter.howl_set, "anorexia")
			else
				rime.remove_value(shifter.howling, "anorexia")
			end
		end
	end,

	Forceful = function(target, stage)
		if rime.attacks.personal then
			if stage == "begin" then
				shifter.can_howl = false
				table.insert(shifter.howling, "forceful")
				rime.remove_value(shifter.howl_set, "forceful")
			else
				rime.remove_value(shifter.howling, "forceful")
			end
		end
	end,

	Berserking = function(target, stage)
		if rime.attacks.personal then
			if stage == "begin" then
				shifter.can_howl = false
				table.insert(shifter.howling, "berserking")
				rime.remove_value(shifter.howl_set, "berserking")
			else
				rime.remove_value(shifter.howling, "berserking")
			end
		end
	end,

	Soothing = function(target, stage)
		if rime.attacks.personal then
			if stage == "begin" then
				shifter.can_howl = false
				table.insert(shifter.howling, "soothing")
				rime.remove_value(shifter.howl_set, "soothing")
			else
				rime.remove_value(shifter.howling, "soothing")
			end
		end
	end,

	Comforting = function(target, stage)
		if rime.attacks.personal then
			if stage == "begin" then
				shifter.can_howl = false
				table.insert(shifter.howling, "comforting")
				rime.remove_value(shifter.howl_set, "comforting")
			else
				rime.remove_value(shifter.howling, "comforting")
			end
		end
	end,

	Deep = function(target, stage)
		if rime.attacks.personal then
			if stage == "begin" then
				shifter.can_howl = false
				table.insert(shifter.howling, "plodding")
				rime.remove_value(shifter.howl_set, "plodding")
			else
				rime.remove_value(shifter.howling, "plodding")
			end
		end
	end,


	Dumbing = function(target, stage)
		if rime.attacks.personal then
			if stage == "begin" then
				shifter.can_howl = false
				table.insert(shifter.howling, "idiocy")
				rime.remove_value(shifter.howl_set, "idiocy")
			else
				rime.remove_value(shifter.howling, "idiocy")
			end
		end
	end,

	Invigorating = function(target, stage)
		if rime.attacks.personal then
			if stage == "begin" then
				shifter.can_howl = false
				table.insert(shifter.howling, "invigorating")
				rime.remove_value(shifter.howl_set, "invigorating")
			else
				rime.remove_value(shifter.howling, "invigorating")
			end
		end
	end,

	Enfeebling = function(target, stage)
		if rime.attacks.personal then
			if stage == "begin" then
				shifter.can_howl = false
				table.insert(shifter.howling, "enfeebling")
				rime.remove_value(shifter.howl_set, "enfeebling")
			else
				rime.remove_value(shifter.howling, "enfeebling")
			end
		end
	end,


},

	--#Wayfarer

	["Tenacity"] = {
		--Ranged Tenacity
		Lob = function(target)
			rime.pvp.aggro(target)
			rime.pvp.ignore_rebounding = true
			rime.last_hit = target
			rime.pvp.web_venoms_noreb()
			if target == rime.pvp.rampage_victim then
				rime.pvp.add_aff(rime.pvp.rampage_venom, target)
				rime.pvp.rampage_venom = false
			end
		end,

		Cripple = function(target)
			rime.pvp.aggro(target)
			rime.pvp.ignore_rebounding = true
			rime.last_hit = target
			rime.pvp.web_venoms_noreb()
			if target == rime.pvp.rampage_victim then
				rime.pvp.add_aff(rime.pvp.rampage_venom, target)
				rime.pvp.rampage_venom = false
			end
		end,

		Obstruct = function(target)
			return
		end,

		Assault = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			--NOTE probably want to parry the limb that gets hit here? Maybe? Not sure :(
			rime.pvp.ignore_rebounding = true
			rime.last_hit = target
			rime.pvp.web_venoms()
			if target == rime.pvp.rampage_victim then
				rime.pvp.add_aff(rime.pvp.rampage_venom, target)
				rime.pvp.rampage_venom = false
			end
		end,

		Slaughter = function(target) --double axe req prone+ crippled leg = faster axe return
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.ignore_rebounding = true
			rime.last_hit = target
			rime.pvp.web_venoms()
		end,

		Carve = function(target)
			rime.pvp.aggro(target)
			--vomit and torso damage/ If vomit or damaged torso stun and fallen instead may need to adjust code
			if target == "you" then
				return
			end
			rime.pvp.ignore_rebounding = true
			rime.last_hit = target
			rime.pvp.web_venoms()
		end,

		Retrieve = function(target) --range line of sight pull
			return
		end,

		Toss = function(target) --this needs work because it has a lot of options venoms + time delays
			rime.pvp.aggro(target)
			return
		end,

		Embed = function(target) --this needs work soon
			rime.pvp.aggro(target)
			return
		end,

		-- Melee Tenacity
		Devastate = function(target)
			rime.last_hit = target
			rime.pvp.aggro(target)
			local gotOne = false
			if rime.pvp.has_def("shielded", target) then
				rime.pvp.noDef("shielded", target)
				gotOne = true
			end
			if rime.pvp.has_def("rebounding", target) then
				rime.pvp.noDef("rebounding", target)
				if gotone then
					gotOne = false
				else
					gotOne = true
				end
			end
			if gotOne then
				rime.last_hit = target
			end
		end,

		Chop = function(target)
			rime.last_hit = target
			rime.pvp.aggro(target)
			rime.pvp.web_venoms()
		end,

		Sweep = function(target)
			rime.last_hit = target
			rime.pvp.aggro(target)
			rime.pvp.web_venoms()
		end,

		Lacerate = function(target)
			rime.last_hit = target
			rime.pvp.aggro(target)
			rime.pvp.web_venoms()
		end,

		Bash = function(target)
			rime.last_hit = target
			rime.pvp.aggro(target)
			rime.pvp.web_venoms()
		end,

		Dropstrike = function(target)
			rime.last_hit = target
			rime.pvp.aggro(target)
			rime.pvp.web_venoms()
		end,

		Whirlwind = function(target)
			rime.last_hit = target
			rime.pvp.aggro(target)
			rime.pvp.web_venoms()
		end,

		Punish = function(target)
			rime.last_hit = target
			rime.pvp.aggro(target)
			rime.pvp.web_venoms()
		end,

		Ravage = function(target)
			rime.last_hit = target
			rime.pvp.aggro(target)
			rime.pvp.web_venoms()
		end,

		Ambush = function(target)
			rime.last_hit = target
			rime.pvp.aggro(target)
			rime.pvp.web_venoms()
		end,

		Execute = function(target)
			rime.last_hit = target
			rime.pvp.aggro(target)
			rime.pvp.web_venoms()
		end,

		Opportunity = function(target)
			return
		end,
	},

	["Fury"] = {

		Consume = function(target)
			return
		end,

		Expunge = function(target, boosted)
			if boosted and rime.pvp.has_aff("stupidity", target) then
				rime.pvp.remove_aff("stupidity", target)
			end
		end,

		Shake = function(target, boosted)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_aff("weariness", target)
		end,

		Threaten = function(target, boosted)
			rime.pvp.add_aff("hatred", target)
			rime.pvp.aggro(target)
			if boosted then
				rime.pvp.add_aff("masochism", target)
				rime.pvp.noDef("rebounding", target)
				rime.pvp.noDef("shielded", target)
				rime.pvp.noDef("prismatic", target)
			end
		end,

		Distract = function(target, boosted)
			if target == "you" then
				rime.parried = "nothing"
			end
			rime.pvp.aggro(target)
			rime.targets[target].parry = "nothing"
		end,

		Enrage = function(target)
			return
		end,

		Halt = function(target, boosted)
			if target == "you" then
				return
			end
			rime.pvp.add_aff("lethargy", target)
			rime.pvp.aggro(target)
		end,

		Shatter = function(target, boosted)
			if target == "you" then
				rime.hidden_aff("shatter")
				rime.check_hidden()
			end
			rime.pvp.aggro(target)
		end,

		Warcry = function(target, boosted)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_aff("no_deaf", target)
			if boosted then
				rime.pvp.add_aff("ringing_ears", target)
			end
		end,

		Startle = function(target, boosted)
			if target == "you" then
				rime.pvp.aggro(target)
				limitEnd("rebounding")
				rime.silent_addAff("rebounding")
				remDef("rebounding")
			end
		end,

		Exhaust = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_aff("exhausted", target)
		end,

		Battlechant = function(target)
			return
		end,

		Disorient = function(target)
			rime.echo("Yo fuck " .. target, "pvp")
		end,
	},

	["Wayfaring"] = {

		Ironskin = function()
			return
		end,

		Tracking = function(target)
			return
		end,
	},

	["Axe"] = {

		Rampage = function(target)
			return
		end,
	},

	--#Monk

	["Tekura"] = {

		Kipup = function(caster, stance)
			return
		end,

		Stance = function(caster, stance)
			return
		end,

		Scythekick = function(target)
			rime.pvp.aggro(target)
			rime.pvp.noDef("shielded", target)
		end,

		Backbreaker = function(target)
			rime.pvp.aggro(target)
			return
		end,

		Cometkick = function(target)
			rime.pvp.aggro(target)
			if rime.pvp.has_aff("right_arm_crippled", target) and rime.pvp.has_aff("left_arm_crippled", target) then
				rime.pvp.add_aff("collapsed_lung", target)
			end
		end,

		Whirlwind = function(target)
			rime.pvp.aggro(target)
			--headstuff
			return
		end,

		Moonkick = function(target)
			rime.pvp.aggro(target)
			--blahblah
			return
		end,

		Sweepkick = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("prone", target)
		end,

		Sidekick = function(target)
			rime.pvp.aggro(target)
			return
		end,

		Hammerfist = function(target)
			rime.pvp.aggro(target)
			--add stuff for blank here. Legs
			return
		end,

		Uppercut = function(target)
			rime.pvp.aggro(target)
			--add stuff for head damage here
			return
		end,

		Palmstrike = function(target)
			rime.pvp.aggro(target)
			rime.pvp.add_aff("blurry_vision", target)
			if rime.attacks.personal then
				enableTrigger("palmstrike_hit_confirm")
			end
		end,

		Snapkick = function(target)
			rime.pvp.aggro(target)
			--add stuff for blank here. Legs
			return
		end,

		Feint = function(target, limb)
			if target == "you" then
				rime.parried = limb
			end
			rime.pvp.aggro(target)
			return
		end,

		Bladehand = function(target)
			return
		end,

		Wrench = function(target)
			rime.pvp.aggro(target)
			return
		end,

		Spear = function(target)
			rime.pvp.aggro(target)
			return
		end,

		Jab = function(target)
			rime.pvp.aggro(target)
			return
		end,

		Slam = function(target)
			rime.pvp.aggro(target)
			return
		end,

		Hook = function(target)
			rime.pvp.aggro(target)
			return
		end,
	},

	["Kaido"] = {

		Strike = function(target)
			rime.pvp.aggro(target)
			if rime.attacks.personal then
				monk.can_strike = false
			end
			if target == "you" then
				rime.strike_mode = true
			end
			rime.targets[target].limbs.torso = 0
			rime.pvp.remove_aff("torso_damaged", target)
			rime.pvp.remove_aff("torso_mangled", target)
		end,

		Banish = function(target)
			rime.pvp.aggro(target, "reset")
		end,

		Resistance = function(target)
			return
		end,

		Numbness = function(target)
			return
		end,

		Cripple = function(target)
			rime.pvp.aggro(target)
			rime.pvp.aggro(target)
			return
		end,

		Enfeeble = function(target)
			rime.pvp.aggro(target)
			--add indorani support here
		end,

		Transmute = function(target)
			--add check for contemplate/annihilate here
		end,

		Deliverance = function(target, proc)
			if proc == "channel" then
				rime.echo("MOTHERFUCKIN DELIVERANCE STARTING")
				rime.echo("MOTHERFUCKIN DELIVERANCE STARTING")
			elseif proc == "active" then
				rime.echo("DELIVERANCE UP!! DELIVERANCE UP!!")
				rime.echo("DELIVERANCE UP!! DELIVERANCE UP!!")
				if rime.pvp.ai and target == rime.target then
					rime.pvp.ai = false
					act("queue clear")
				end
				rime.pvp.room.deliverance = true
			end
			if proc == "proc" then
				rime.pvp.room.deliverance = true
				rime.targets[target].deliverance = true
				if rime.pvp.ai and target == rime.target then
					rime.pvp.ai = false
					act("queue clear")
				end
				if target == "you" then
					swarm.removeTarget(target)
					swarm.autoTargeting()
				else
					rime.echo("DELIVERANCE UP!! DELIVERANCE UP!!")
					swarm.removeTarget(target)
					swarm.autoTargeting()
					rime.targets[target].deliverance = true
					if rime.pvp.ai and rime.target == target then
						rime.pvp.ai = false
					end
				end
			elseif proc == "end" then
				rime.pvp.room.deliverance = false
				act("wt DELIVERANCE OVER, BLEND OR KILL THE MONK WHATEVER I DON'T CARE")
				rime.targets[target].deliverance = false
			else
				swarm.removeTarget(target)
				swarm.autoTargeting()
			end
		end,
	},

	["Telepathy"] = {

		Clamp = function(target)
			return
		end,

		Command = function(target)
			return
		end,

		Blackout = function(target)
			return
		end,
	},

	--#Revenant

	["Riving"] = {

		Gripping = function(target)
			return
		end,

		Anguish = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			if not rime.pvp.has_aff("no_deaf", target) then
				rime.pvp.add_aff("no_deaf", target)
			else
				rime.pvp.add_aff("prone", target)
			end
		end,

		Clotting = function(target)
			return
		end,

		Envenom = function(target)
			return
		end,

		Sturdiness = function(target)
			return
		end,

		Juxtapose = function(target)
			rime.pvp.aggro(target, "reset")
			if target == "you" then
				return
			end
			rime.targets[matches[2]].aggro = rime.targets[matches[2]].aggro + 15
			rime.targets[target].defences.defended = true
			rime.targets[matches[2]].defending = target
			if rime.attacks.personal then
				defending = target
				return
			end
			act("wt " .. target .. " is being defended by " .. string.upper(matches[2]) .. "!")
			table.remove(swarm.room, table.index_of(swarm.room, string.upper(matches[2])))
			expandAlias("nt")
		end,

		Rage = function(target)
			for _, aff in ipairs(rime.curing.affsByCure.steroid) do
				if rime.pvp.has_aff(aff, target) then
					rime.pvp.remove_aff(aff, target)
					break
				end
			end
		end,

		MainGauche = function(target)
			return
		end,

		Separate = function(target)
			rime.pvp.aggro(target)
			return
		end,

		Circle = function(target)
			rime.pvp.aggro(target)
			if rime.attacks.personal then
				rev.need_circle = false
			end
		end,

		Rive = function(target)
			rime.pvp.aggro(target)
			rime.last_hit = target
		end,

		Raze = function(target, what)
			rime.pvp.aggro(target)
			rime.last_hit = target
			if what == "shield" then
				rime.pvp.noDef("shielded", target)
			elseif what == "rebounding" then
				rime.pvp.noDef("shielded", target)
				rime.pvp.noDef("rebounding", target)
			elseif what == "speed" or razed == "failure" then
				rime.pvp.noDef("shielded", target)
				rime.pvp.noDef("rebounding", target)
				rime.pvp.noDef("speed", target)
			end
		end,

		Fell = function(target)
			rime.pvp.aggro(target)
			rime.last_hit = target
		end,

		Duplicity = function(target)
			rime.pvp.aggro(target)
			rime.last_hit = target
		end,

		Umbrage = function(target, hit)
			if hit then
				rime.last_hit = target
				rime.pvp.ignore_rebounding = true
			end
		end,

		Initiate = function(target)
			rime.pvp.aggro(target)
			return
		end,

		Gouge = function(target)
			rime.pvp.aggro(target)
			rime.last_hit = target
			rime.pvp.web_venoms()
		end,

		Deceive = function(target, what)
			rime.pvp.aggro(target)
			rime.last_hit = target
			if what == "shield" then
				rime.pvp.noDef("shielded", target)
			elseif what == "rebounding" then
				rime.pvp.noDef("shielded", target)
				rime.pvp.noDef("rebounding", target)
			elseif what == "speed" or what == "failure" then
				rime.pvp.noDef("shielded", target)
				rime.pvp.noDef("rebounding", target)
				rime.pvp.noDef("speed", target)
			end
			rime.pvp.web_venoms()
			rev.wilaveee = false
		end,

		Razestrike = function(target, what)
			rime.pvp.aggro(target)
			rime.last_hit = target
			if what == "shield" then
				rime.pvp.noDef("shielded", target)
			elseif what == "rebounding" then
				rime.pvp.noDef("shielded", target)
				rime.pvp.noDef("rebounding", target)
			elseif what == "speed" or what == "failure" then
				rime.pvp.noDef("shielded", target)
				rime.pvp.noDef("rebounding", target)
				rime.pvp.noDef("speed", target)
			end
			rime.pvp.web_venoms()
			rev.wilaveee = false
		end,

		Eclipse = function(target, stage)
			if target == "you" then
				if stage == "start" then
					rime.echo(matches[2]:upper() .. " IS ECLIPSING THE ABSOLUTE MAD PERSON")
					rime.pvp.aggro(target)
				elseif stage == "mid" then
					rime.echo(
						"YOU'RE BEING ECLIPSED BY <red>" .. matches[2]:upper() .. "<white>BITCH PAY ATTENTION",
						"pvp"
					)
					rime.echo(
						"YOU'RE BEING ECLIPSED BY <red>" .. matches[2]:upper() .. "<white>BITCH PAY ATTENTION",
						"pvp"
					)
					rime.echo(
						"YOU'RE BEING ECLIPSED BY <red>" .. matches[2]:upper() .. "<white>BITCH PAY ATTENTION",
						"pvp"
					)
					rime.pvp.aggro(target)
				else
					rime.echo("I can't believe you let them do this to you, smh", "pvp")
				end
			else
				if stage == "start" then
					if target ~= "You" then
						rime.echo(target .. " being eclipsed by " .. matches[2], "pvp")
					end
					rime.pvp.aggro(target)
				elseif stage == "mid" then
					if target ~= "You" then
						rime.echo(target .. " being eclipsed by " .. matches[2], "pvp")
					end
					rime.pvp.aggro(target)
				else
					if rime.attacks.personal and target ~= "You" then
						expandAlias("dab")
						rime.paused = false
						rime.pvp.aggro(target, "reset")
					else
						rime.echo(
							matches[2]:upper() .. " ECLIPSED " .. target:upper() .. " THE ABSOLUTE MAD PERSON",
							"pvp"
						)
						rime.pvp.aggro(target, "reset")
					end
				end
			end
		end,

		Harrow = function(target)
			return
		end,

		Transpierce = function(target, fail_check)
			if not fail_check then
				rime.pvp.add_aff("writhe_impaled", target)
				rime.pvp.add_limb("torso", target, 1000)
				rime.pvp.aggro(target)
				if rime.attacks.personal then
					targetImpaled = true
				end
			else
				rime.pvp.remove_aff("prone", target)
			end
			rime.pvp.remove_aff("lurk", target)
			if target == rime.target then
				rime.pvp.target_tumbling = false
			end
		end,

		Hemoclysm = function(target, limb)
			--[[save this for logic later? limb = limb:gsub(" ", "_")]]
			rev.bongoBonanza = true
			rev.wilaveee = true
			rime.pvp.remove_aff("lurk", target)
		end,

		Calm = function()
			return
		end,

		Jumpcut = function(target, what)
			if what == "impale" then
				rime.pvp.add_aff("writhe_impaled", target)
				rime.pvp.add_aff("prone", target)
				rime.pvp.aggro(target)
				if rime.attacks.personal then
					targetImpaled = true
				end
				if target == rime.target then
					rime.pvp.target_tumbling = false
				end
			elseif what == "hack" then
				rime.pvp.add_aff("prone", target)
			else
				return
			end
		end,

		Harvest = function(target)
			return
		end,

		Extirpate = function(target)
			if rime.attacks.personal then
				targetImpaled = false
			end
			rime.pvp.remove_aff("writhe_impaled", target)
			rime.pvp.remove_aff("lurk", target)
			rev.wilaveee = true
		end,
	},

	["Manifestation"] = {

		Phantasm = function(target)
			--handled with a trigger
			return
		end,

		Engulf = function(target)
			return
		end,

		Chimerization = function(target)
			--also handled with a separate trigger
			return
		end,

		Parasite = function(target)
			if target == "you" then
				return
			end
			rime.pvp.add_aff("withering", target)
		end,

		Serpent = function(target, state)
			return
		end,

		Discord = function(target, affliction)
			if target == "you" then
				return
			end
			rime.pvp.aggro(target)
			rime.pvp.add_aff(affliction, target)
		end,
	},

	["Chirography"] = {

		Iyedlo = function(target)
			return
		end,

		Lawid = function(target, type)
			if target == "you" then
				return
			end
			if type == "two-hand" then
				rime.pvp.add_limb("torso", target, 1400)
			end
		end,

		Telvi = function(target, hands)
			if target == "you" then
				return
			end
			if hands == "two-hand" then
				rime.pvp.add_aff("caloric", target)
				rime.pvp.add_aff("caloric", target)
			else
				rime.pvp.add_aff("caloric", target)
			end
		end,

		Atdum = function(target)
			if target == "you" then
				return
			end
			rime.last_hit = target
			rime.pvp.ignore_rebounding = true
		end,

		Aneda = function(target)
			if rime.attacks.personal then
				if not rev.aneda_left_scribed then
					rev.aneda_left_scribed = true
				else
					rev.aneda_right_scribed = true
				end
			end
		end,

		Lurk = function(target)
			rime.pvp.add_aff("lurk", target)
			if rime.attacks.personal then
				rev.canlurk = false
			end
		end,

		Cull = function(target)
			rime.echo("RIP THIS MANS")
		end,
	},

	--#Misc

	["Blood"] = {
		--This should be in Sanguis. What the hell Keroc? smh smh
		Strengthen = function(target)
			return
		end,

	},

	["Toxicology"] = {

		Rag = function(target)
			return
		end,
	},

	["Dampen"] = {

		Aegis = function(target, stage)
			return
		end,
	},

	["Weaponry"] = {

		Attack = function(target)
			return
		end,

		Brainsmash = function(target)
			return
		end,

		Decapitate = function(target)
			return
		end,

		Behead = function(target)
			return
		end,

		Shatter = function(target, limb)
			if target == "you" and limb == "start" then
				rime.echo("YO THEY'RE BUST YOUR FUCKIN' KNEECAPS")
			end
			return
		end,
	},

	["Archery"] = {

		Shoot = function(target)
			return
		end,
	},

	["Avoidance"] = {

		Nimbleness = function(target)
			rime.targets[target].defences.nimbleness = true
		end,

		Bolstering = function(target)
			return
		end,
	},

	["Refining"] = {

		Disperse = function(target)
			for k, v in ipairs(rime.curing.priority.default.writhe) do
				rime.pvp.remove_aff(v, target)
				rime.pvp.remove_aff("tera_impaled", target)
			end

			if target == rime.target and targetImpaled then
				targetImpaled = false
			end
		end,

		Control = function(target)
			return
		end,
	},

	["Enchantment"] = {

		Negation = function(user)
			rime.pvp.clear_target(user)
		end,

		Firewall = function(user, direction)
			return
		end,

		Firelash = function(target)
			return
		end,

		Icewall = function(user, direction)
			rime.pvp.room[direction .. "_icewalled"] = true
		end,

		Eye = function(target)
			rime.pvp.noDef("lightform", "All")
			rime.pvp.noDef("blackwind", "All")
		end,

		Allsight = function(target)
			--add def
			return
		end,

		Waterwalking = function(target)
			--add def
			return
		end,

		Worrystone = function(caster)
			return
		end,

		Whirlwind = function(caster)
			return
		end,

		Pestilence = function(target)
			return
		end,

		Beacon = function(target)
			return
		end,
	},

	["Artifact"] = {

		Boomerang = function(target, status)
			return
		end,

		Challengeblade = function(target)
			rime.echo("You know the law. Two men enter, one man leaves.", "pvp")
		end,

		Locket = function(target)
			return
		end,

		Light = function(target)
			return
		end,

		Darkness = function(target)
			return
		end,

		Flood = function(target)
			return
		end,

		Stability = function(target)
			rime.pvp.addDef("density", target)
		end,

		Shroud = function(target)
			rime.pvp.addDef("shroud", target)
		end,

		Wand = {

			Reflection = function(target)
				if rime.attacks.personal then
					rime.saved.reflection_charge = rime.saved.reflection_charge - 1
					if rime.saved.reflection_charge < 1 then
						rime.saved.reflection_charge = 0
					end
				end
			end,
		},
	},

	["Antiquated"] = {

		["Ring"] = {

			Defend = function(target)
				rime.pvp.aggro(target, "reset")
				if target == "you" then
					return
				end
				rime.targets[matches[2]].aggro = rime.targets[matches[2]].aggro + 15
				rime.targets[target].defences.defended = true
				if rime.attacks.personal then
					defending = target
					return
				end
				act("wt " .. target .. " is being defended by " .. string.upper(matches[2]) .. "!")
				table.remove(swarm.room, table.index_of(swarm.room, string.upper(matches[2])))
				expandAlias("nt")
			end,
		},
	},

	--consistency!

	["Research"] = {

		Ylemcore = function(target)
			rime.targets[target].mana = 100
			rime.echo("lmao coward")
		end,

	},

	["Elemental"] = {

		Blast = function(target, type)
			return
		end,
	},

	["Gaming"] = {

		Wildcard = function(target)
			return
		end,
	},

	["Obscuring"] = {

		Cloak = function(target)
			return
		end,
	},

	["Water"] = {

		Conduit = function(target)
			return
		end,
	},

	["Justice"] = {

		Scales = function()
			for k, v in pairs(swarm.room) do
				rime.pvp.add_aff("justice", v)
			end
		end,
	},

	["Siphon"] = {

		Health = function()
			rime.echo("Stupid ass non-conforming combat messages")
		end,
	},

	["Relic"] = {

		Swoop = function(target)
			return
		end,

		Hornlock = function(target)
			return
		end,

		Reminisce = function(target)
			return
		end,

		Fangs = function(target)
			return
		end,

		Yank = function(target)
			return
		end,

		Rake = function(target)
			return
		end,

		Translocator = function(target)
			return
		end,

		Webspray = function(target, dodged)
			if target == "you" then
				return
			end
			if not dodged then
				rime.pvp.add_aff("writhe_web", target)
			else
				rime.targets[target].webevasion = true
			end
		end,

		Entangle = function(target)
			if target == "you" then
				return
			end
			if not dodged then
				rime.pvp.add_aff("writhe_web", target)
			else
				rime.targets[target].webevasion = true
			end
		end,

		Deathknell = function(target)
			if target == "You" then
				rime.cooldowns.deathknell = false
			end
		end,
	},

	["Fishing"] = {

		Cast = function(target)
			return
		end,

		Catch = function(target)
			return
		end,

		Reel = function(target)
			return
		end,

		Cut = function(target)
			return
		end,

		Discern = function(target)
			return
		end,

		Disappointment = function(target)
			return
		end,

		Lead = function(target)
			return
		end,
	},

	["Racial"] = {

		Peeling = function(target)
			rime.echo("Gross but at least it doesn't smell anymore.")
		end,

		Shift = function(target)
			return
		end,

		Scent = function(target)
			return
		end,

		Gripping = function(target)
			return
		end,

		Tusk = function(target)
			return
		end,

		Headbash = function(target)
			rime.echo(string.title(target) .. " messed with the bull..")
		end,

		Hover = function(target)
			return
		end,
	},

	["Race"] = {

		Icebreath = function(target)
			rime.pvp.add_aff("caloric", target)
		end,
	},

	["Tattoos"] = {

        Anchor = function(target)
            if string.lower(target) == "you" then
                rime.add_aff("anchor")
                tempTimer(45, function() rime.remove_aff("anchor") end)
            else
                local tgt = target
                rime.pvp.add_aff("anchor",tgt)
                tempTimer(45, function() rime.pvp.remove_aff("anchor",tgt) end)
            end
            return
        end,

        Feather = function(target)
            if string.lower(target) == "you" then
                rime.remove_aff("prone")
            else
                rime.pvp.remove_aff("prone",target)
            end
            return
        end,

        Cloud = function(target)
            return
        end,

        Flower = function(target)
            return
        end,

		Hammer = function(target)
			rime.pvp.noDef("shielded", target)
		end,

		Crystal = function(target)
			rev.wilaveee = false
			if rime.attacks.personal then
				rime.pvp.cooldowns.crystal = true
			end
			return
		end,

		Starburst = function(target)
			if rime.attacks.personal then
				rime.reset()
			else
				rime.pvp.clear_target(target)
			end
			act("wt " .. target .. " starbursted!")
		end,

		Cloak = function(target)
			rime.pvp.addDef("cloak", target)
		end,

		Shield = function(target)
			rime.pvp.addDef("shielded", target)
			rime.pvp.remove_aff("wraith", target)
		end,

		Mindseye = function(target)
			return
		end,

		Flame = function(target)
			return
		end,

		Web = function(target, dodged)
			if not dodged then
				rime.pvp.add_aff("writhe_web", target)
			end
		end,

		Wand = function(target)
			rime.targets[target].mana = 100
		end,

		Book = function(target)
			rime.echo("Lmao like anyone reads in this game.")
		end,

		Prism = function(target)
			return
		end,

		Feather = function(target)
			return
		end,
	},

	["Survival"] = {

		Restoration = function(target)
			if not rime.pvp.has_aff("left_arm_damaged", target) then
				rime.pvp.remove_aff("left_arm_crippled", target)
			end
			if not rime.pvp.has_aff("right_arm_damaged", target) then
				rime.pvp.remove_aff("right_arm_crippled", target)
			end
			if not rime.pvp.has_aff("left_leg_damaged", target) then
				rime.pvp.remove_aff("left_leg_crippled", target)
			end
			if not rime.pvp.has_aff("right_leg_damaged", target) then
				rime.pvp.remove_aff("right_leg_crippled", target)
			end
		end,

		Shaking = function(target, type)
			if target == "You" and type == "Strong" then
				rime.pvp.can_shake = false
			end
		end,

	},

	["Hunting"] = {

		Fitness = function(target)
			if rime.attacks.personal then
				rime.curing.class_breaker = false
				return
			end
			rime.pvp.remove_aff("asthma", target)
			rime.time("fitness", target, 20)
		end,

		Overdrive = function(target)
			return
		end,
	},

	["Vision"] = {

		Search = function(target)
			return
		end,
	},

	["Manipulation"] = {

		Wealth = function(target)
			return
		end,

		Blockade = function(user, direction)
			rime.pvp.room[direction .. "_icewalled"] = true
		end,

		Returning = function(target)
			return
		end,

		Recall = function(target, channel)
			return
		end,

		Combustion = function(target)
			return
		end,

		Backlash = function(target, proc)
			return
		end,

		Dome = function(target)
			if target == "You" then
				target = "me"
			end
			rime.pvp.addDef("dome", target)
			if rime.pvp.web_aff_calling then
				act("wt Dome up on " .. target)
			end
			--[[if rime.targets[target].effigy then
				rime.target_track("effigy")
			end]]
			if target ~= "me" then
				rime.pvp.aggro(target, reset)
			end
		end,

		Wellness = function(target)
			return
		end,

		Wisdom = function(target)
			return
		end,

		Blizzard = function(target)
			rime.echo("Oh no we're trapped")
		end,
	},

	["Prize"] = {

		Open = function(target)
			rime.echo("wow neat")
		end,
	},

	["Combine"] = {

		Chocolate = function(target)
			rime.echo("This Combat Message Makes So Much Sense.")
		end,
	},

	["Boon"] = {

		Firework = function(target)
			rime.echo("Oooooh. Ahhhhhhh.")
		end,
	},

	["Pillage"] = {

		Caravan = function(target, stage)
			if stage == "end" and target == "You" then
				rime.echo("PILLAGING FINISHED")
			end
		end,
	},

	--special 200 snowflakes

	["Aetherial"] = {

		Arise = function(target)
			return
		end,

		Bastion = function(target)
			return
		end,

		Jinx = function(target)
			rime.pvp.aggro(target)
			if target == "you" then
				rime.add_possible_aff("stupidity")
				rime.add_possible_aff("indifference")
				rime.add_possible_aff("recklessness")
				rime.add_possible_aff("confusion")
				rime.add_possible_aff("anorexia")
				rime.add_possible_aff("dementia")
			end
		end,

		Band = function(target)
			return
		end,

		Revitalise = function(target)
			return
		end,
	},

	["Astral"] = {

		Eversion = function(target)
			rime.pvp.aggro(target)
			if rime.attacks.personal then
				ascended.doubleHitVenomDeluxeOnlyAtTacoBell = false
				enableTrigger("Shard Affliction")
				ascended.sync = false
			end
			if target == "you" then
				rime.hidden_aff("blossom")
			end
		end,

		Hamartia = function(target, shield)
			rime.pvp.aggro(target)
			if shield then
				rime.pvp.noDef("shielded", target)
			end
			if rime.attacks.personal then
				ascended.secondary = false
			end
		end,

		Crescent = function(target)
			rime.pvp.aggro(target)
			if rime.attacks.personal then
				ascended.resource[class] = ascended.resource[class] - 3
				if ascended.resource[class] < 0 then
					ascended.resource[class] = 0
				end
			end
		end,
	},

	["Chaos"] = {

		Mend = function(target)
			return
		end,

		Embrace = function(target)
			return
		end,

		Fever = function(target)
			rime.pvp.aggro(target)
			if target == "you" then
				rime.add_possible_aff("stupidity")
				rime.add_possible_aff("indifference")
				rime.add_possible_aff("recklessness")
				rime.add_possible_aff("confusion")
				rime.add_possible_aff("anorexia")
				rime.add_possible_aff("dementia")
			end
		end,

		Havoc = function(target)
			rime.pvp.aggro(target)
			if target == "you" then
				rime.add_possible_aff("paresis")
				rime.add_possible_aff("clumsiness")
				rime.add_possible_aff("vomiting")
				rime.add_possible_aff("weariness")
				rime.add_possible_aff("asthma")
				rime.add_possible_aff("haemophilia")
			end
		end,
	},

	["Nocturn"] = {

		Shadow = function(target)
			return
		end,
	},

	["Adherent"] = {

		Gateway = function(target)
			return
		end,

        Ascend = function(target)
            if rime.attacks.personal then
                rime.status.class = rime.saved.ascended_class
                act("score", "stat", "ab")
                rime.defences.profileLoaded = false
            end
        end,

		Riot = function(target, shield)
			rime.pvp.aggro(target)
			if shield then
				rime.pvp.noDef("shielded", target)
			end
			if rime.attacks.personal then
				ascended.secondary = false
			end
		end,

		Senesce = function(target, shield)
			rime.pvp.aggro(target)
			if shield then
				rime.pvp.noDef("shielded", target)
			end
			if rime.attacks.personal then
				ascended.secondary = false
			end
		end,

		Besiege = function(target, shield)
			rime.pvp.aggro(target)
			if shield then
				rime.pvp.noDef("shielded", target)
			end
			if rime.attacks.personal then
				ascended.secondary = false
			end
		end,

		Duskywing = function(target, shield)
			rime.pvp.aggro(target)
			if shield then
				rime.pvp.noDef("shielded", target)
			end
			if rime.attacks.personal then
				ascended.secondary = false
			end
		end,

		Barrier = function(target)
			return
		end,

		Inferno = function(target)
			rime.pvp.aggro(target)
			if target == "you" then
				rime.hidden_aff("inferno")
			end
			if rime.pvp.has_aff("ablaze", target) then
				rime.pvp.add_stack("ablaze", target, 1)
			end
		end,

		Blossom = function(target)
			rime.pvp.aggro(target)
			if target == "you" then
				rime.hidden_aff("blossom")
			end
		end,

		Tentacle = function(target)
			rime.pvp.aggro(target)
			rime.pvp.web_venoms_noreb()
		end,

		Balefire = function(target)
			rime.pvp.aggro(target)
		end,

		Purify = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro_count_down(target, 1)
		end,

		Avatar = function(target)
			rime.pvp.aggro(target)
			rime.pvp.web_venoms_noreb()
			if rime.attacks.personal then
				ascended.sync = false
			end
		end,

		Shards = function(target)
			rime.pvp.aggro(target)
			if rime.attacks.personal then
				ascended.doubleHitVenomDeluxeOnlyAtTacoBell = false
				enableTrigger("Shard Affliction")
				ascended.sync = false
			end
			if target == "you" then
				rime.hidden_aff("blossom")
			end
		end,

		Spiral = function(target)
			rime.pvp.aggro(target)
			if rime.attacks.personal then
				ascended.doubleHitVenomDeluxeOnlyAtTacoBell = false
				enableTrigger("Shard Affliction")
				ascended.sync = false
			end
			if target == "you" then
				rime.hidden_aff("blossom")
			end
		end,

		Smoulder = function(target)
			rime.pvp.aggro(target)
			if rime.attacks.personal then
				ascended.doubleHitVenomDeluxeOnlyAtTacoBell = false
				enableTrigger("Shard Affliction")
				ascended.sync = false
			end
			if target == "you" then
				rime.hidden_aff("inferno")
			end
			if rime.pvp.has_aff("ablaze", target) then
				rime.pvp.add_stack("ablaze", target, 1)
			end
		end,

		Pillage = function(target)
			rime.pvp.aggro(target)
			if rime.attacks.personal then
				ascended.doubleHitVenomDeluxeOnlyAtTacoBell = false
				enableTrigger("Shard Affliction")
				ascended.sync = false
			end
			if target == "you" then
				rime.hidden_aff("inferno")
			end
			if rime.pvp.has_aff("ablaze", target) then
				rime.pvp.add_stack("ablaze", target, 1)
			end
		end,

		Recalesce = function(target)
			rime.pvp.aggro(target)
			if rime.attacks.personal then
				ascended.doubleHitVenomDeluxeOnlyAtTacoBell = false
				enableTrigger("Shard Affliction")
				ascended.sync = false
			end
			if target == "you" then
				rime.hidden_aff("inferno")
			end
		end,

		Coldflame = function(target)
			rime.pvp.aggro(target)
			if rime.attacks.personal then
				ascended.doubleHitVenomDeluxeOnlyAtTacoBell = false
				enableTrigger("Shard Affliction")
				ascended.sync = false
			end
			if target == "you" then
				rime.hidden_aff("inferno")
			end
			if rime.pvp.has_aff("ablaze", target) then
				rime.pvp.add_stack("ablaze", target, 1)
			end
		end,

		Warp = function(target)
			rime.pvp.aggro(target)
			if rime.pvp.has_aff("magic_weakness", target) then
				rime.pvp.add_aff("disfigurement", target)
				rime.pvp.add_aff("slickness", target)
			else
				rime.pvp.add_aff("fire_weakness", target)
				rime.pvp.add_aff("magic_weakness", target)
			end
			limitStart("resist_wither" .. target, 31)
			if rime.attacks.personal then
				local class = rime.saved.ascended_class
				ascended.resource[class] = ascended.resource[class] - 1
				if ascended.resource[class] < 0 then
					ascended.resource[class] = 0
				end
			end
		end,

		Decay = function(target)
			rime.pvp.aggro(target)
			if rime.pvp.has_aff("magic_weakness", target) then
				rime.pvp.add_aff("disfigurement", target)
				rime.pvp.add_aff("slickness", target)
			else
				rime.pvp.add_aff("fire_weakness", target)
				rime.pvp.add_aff("magic_weakness", target)
			end
			limitStart("resist_wither" .. target, 31)
			if rime.attacks.personal then
				local class = rime.saved.ascended_class
				ascended.resource[class] = ascended.resource[class] - 1
				if ascended.resource[class] < 0 then
					ascended.resource[class] = 0
				end
			end
		end,

		Wither = function(target)
			rime.pvp.aggro(target)
			if rime.pvp.has_aff("magic_weakness", target) then
				rime.pvp.add_aff("disfigurement", target)
				rime.pvp.add_aff("slickness", target)
			else
				rime.pvp.add_aff("fire_weakness", target)
				rime.pvp.add_aff("magic_weakness", target)
			end
			limitStart("resist_wither" .. target, 31)
			if rime.attacks.personal then
				local class = rime.saved.ascended_class
				ascended.resource[class] = ascended.resource[class] - 1
				if ascended.resource[class] < 0 then
					ascended.resource[class] = 0
				end
			end
		end,

		Quell = function(target)
			rime.pvp.aggro(target)
			if rime.pvp.has_aff("magic_weakness", target) then
				rime.pvp.add_aff("disfigurement", target)
				rime.pvp.add_aff("slickness", target)
			else
				rime.pvp.add_aff("fire_weakness", target)
				rime.pvp.add_aff("magic_weakness", target)
			end
			limitStart("resist_wither" .. target, 31)
			if rime.attacks.personal then
				local class = rime.saved.ascended_class
				ascended.resource[class] = ascended.resource[class] - 1
				if ascended.resource[class] < 0 then
					ascended.resource[class] = 0
				end
			end
		end,

		Unwind = function(target)
			rime.pvp.aggro(target)
			if rime.pvp.has_aff("magic_weakness", target) then
				rime.pvp.add_aff("disfigurement", target)
				rime.pvp.add_aff("slickness", target)
			else
				rime.pvp.add_aff("fire_weakness", target)
				rime.pvp.add_aff("magic_weakness", target)
			end
			limitStart("resist_wither" .. target, 31)
			if rime.attacks.personal then
				local class = rime.saved.ascended_class
				ascended.resource[class] = ascended.resource[class] - 1
				if ascended.resource[class] < 0 then
					ascended.resource[class] = 0
				end
			end
		end,

		Embrace = function(target)
			if rime.attacks.personal then
				local class = rime.saved.ascended_class
				ascended.resource[class] = ascended.resource[class] - 2
				if ascended.resource[class] < 0 then
					ascended.resource[class] = 0
				end
			end
		end,

		Descent = function(target)
			if rime.attacks.personal then
				local class = rime.saved.ascended_class
				ascended.resource[class] = ascended.resource[class] - 2
				if ascended.resource[class] < 0 then
					ascended.resource[class] = 0
				end
			end
		end,

		Catastrophe = function(target)
			rime.pvp.aggro(target)
			if rime.attacks.personal then
				local class = rime.saved.ascended_class
				local class = rime.saved.ascended_class
				ascended.resource[class] = ascended.resource[class] - 3
				if ascended.resource[class] < 0 then
					ascended.resource[class] = 0
				end
			end
		end,

		Temerate = function(target)
			rime.pvp.aggro(target)
			if rime.attacks.personal then
				local class = rime.saved.ascended_class
				ascended.resource[class] = ascended.resource[class] - 3
				if ascended.resource[class] < 0 then
					ascended.resource[class] = 0
				end
			end
		end,

		Might = function(target)
			rime.pvp.aggro(target)
			if rime.attacks.personal then
				local class = rime.saved.ascended_class
				ascended.resource[class] = ascended.resource[class] - 3
				if ascended.resource[class] < 0 then
					ascended.resource[class] = 0
				end
			end
		end,

		Conquer = function(target)
			rime.pvp.aggro(target)
			if rime.attacks.personal then
				local class = rime.saved.ascended_class
				ascended.resource[class] = ascended.resource[class] - 3
				if ascended.resource[class] < 0 then
					ascended.resource[class] = 0
				end
			end
		end,


		Vortex = function(target)
			if rime.attacks.personal then
				local class = rime.saved.ascended_class
				ascended.resource[class] = ascended.resource[class] - 1
				if ascended.resource[class] < 0 then
					ascended.resource[class] = 0
				end
			end
		end,

		Mortalfire = function(user)
			if rime.attacks.personal then
				ascended.mortalfire = false
			end
		end,

		Legion = function(target)
			if rime.attacks.personal then
				ascended.portal = false
				if ascended.portaltimer then
					killTimer(ascended.portaltimer)
				end
				ascended.portaltimer = tempTimer(90, function()
					ascended.portal = true
				end)
			end
		end,

		Gifts = function(target)
			if rime.attacks.personal then
				ascended.portal = false
				if ascended.portaltimer then
					killTimer(ascended.portaltimer)
				end
				ascended.portaltimer = tempTimer(90, function()
					ascended.portal = true
				end)
			end
		end,

		Enslave = function(target)
			if rime.attacks.personal then
				ascended.portal = false
				if ascended.portaltimer then
					killTimer(ascended.portaltimer)
				end
				ascended.portaltimer = tempTimer(90, function()
					ascended.portal = true
				end)
			end
		end,

		Despot = function(target)
			return
		end,

	},

	["Titan"] = {

		Awaken = function(target)
			return
		end,

		Corrode = function(target, shield)
			rime.pvp.aggro(target)
			rime.pvp.web_venoms_noreb()
			if shield then
				rime.pvp.noDef("shielded", target)
			end
			if rime.attacks.personal then
				ascended.secondary = false
			end
		end,

		Irradiance = function(target)
			return
		end,

		Defy = function(target)
			if target == "you" then
				return
			end
			rime.pvp.aggro_count_down(target, 1)
		end,

		Spear = function(target)
			rime.pvp.aggro(target)
			rime.pvp.web_venoms_noreb()
			if rime.attacks.personal then
				ascended.sync = false
			end
		end,

		Fissure = function(target)
			rime.pvp.aggro(target)
			if rime.attacks.personal then
				ascended.doubleHitVenomDeluxeOnlyAtTacoBell = false
				enableTrigger("Shard Affliction")
				ascended.sync = false
			end
			if target == "you" then
				rime.hidden_aff("blossom")
			end
		end,

		Sicken = function(target)
			rime.pvp.aggro(target)
			if rime.attacks.personal then
				ascended.doubleHitVenomDeluxeOnlyAtTacoBell = false
				enableTrigger("Shard Affliction")
				ascended.sync = false
			end
			if target == "you" then
				rime.hidden_aff("blossom")
			end
		end,

		Staredown = function(target)
			rime.pvp.aggro(target)
			if rime.pvp.has_aff("magic_weakness", target) then
				rime.pvp.add_aff("disfigurement", target)
				rime.pvp.add_aff("slickness", target)
			else
				rime.pvp.add_aff("fire_weakness", target)
				rime.pvp.add_aff("magic_weakness", target)
				limitStart("resist_wither" .. target, 31)
			end
			if rime.attacks.personal then
				ascended.resource.Titan = ascended.resource.Titan - 1
				if ascended.resource.Titan < 0 then
					ascended.resource.Titan = 0
				end
			end
		end,

		Energize = function(target)
			if rime.attacks.personal then
				ascended.resource.Titan = ascended.resource.Titan - 2
				if ascended.resource.Titan < 0 then
					ascended.resource.Titan = 0
				end
			end
		end,

		Crush = function(target)
			rime.pvp.aggro(target)
			if rime.attacks.personal then
				ascended.resource.Titan = ascended.resource.Titan - 3
				if ascended.resource.Titan < 0 then
					ascended.resource.Titan = 0
				end
			end
		end,

		Onslaught = function(target)
			rime.pvp.aggro(target)
			if rime.attacks.personal then
				ascended.resource.Titan = ascended.resource.Titan - 1
				if ascended.resource.Titan < 0 then
					ascended.resource.Titan = 0
				end
			end
		end,

		Remnant = function(user)
			if rime.attacks.personal then
				titan.remnant = false
			end
		end,

		Eldcall = function(target)
			if rime.attacks.personal then
				ascended.portal = false
				if ascended.portaltimer then
					killTimer(ascended.portaltimer)
				end
				ascended.portaltimer = tempTimer(90, function()
					ascended.portal = true
				end)
			end
		end,
	},


    ["Tyranny"] = {

    	Virulence = function(target)
    		return
    	end,

    	Enforce = function(target)
    		return
    	end,

    	Offer = function(target)
    		return
    	end,

        Conquer = function(target)
            return
        end,

        Bestow = function(target)
            return
        end,

        Assess = function(target)
            return
        end,

        Flourish = function(target)
            return
        end,

        Collect = function(target)
            return
        end,

        Decree = function(target)
            return
        end,

        Shape = function(target)
        	return
        end,

        Drink = function(target)
        	return
        end,

        Embed = function(target)
        	return
        end,

        Bloodform = function(target)
        	return
        end,

        Crater = function(target, stage)
        	return
        end

    },

    ["Conqueror"] = {

    	Release = function(target)
    		return
    	end,

    	Torrent = function(target, type)
    		return
    	end,

    	Mobilise = function(target)
    		return
    	end,

    	Tap = function(target)
    		return
    	end,

    	Tear = function(target, stage)
    		return
    	end,

    },

    ["Memory"] = {

    	Impression = function(target, area)
    		return
    	end,
    },

}