--Author: Bulrok
rime.pvp.Praenomen.routes = {

	["group"] = {
		["blurb"] = {"Used for groups. Will fling non primary target enemies if out doors, prioritize Sanguis skills for physical affs for quick Unravels"},
		["initial"] = {
			"effigy_damage",
			"fling_extra",
			"shielded",
			"damage",
			"annihilate",
			"seize",
			"asthma",
			"slickness",
			"paresis",
			"disrupted",
			"frenzy",
		},
		["secondary"] = {
			"push_anorexia",
			"push_impatience",
			"blood_curse",
			"confusion",
			"impatience",
			"masochism",
			"vertigo",
			"recklessness",
			"epilepsy",
			"stupidity",
		},
	},

	["black"] = {
		["blurb"] = {"Barebones Dueling"},
		["initial"] = {
			"shielded",
			"annihilate",
			"blood_rune",
			"seize",
			"blood_feast",
			"writhe_transfix",
			"force_disrupt",
			"slickness",
			"asthma",
			"disrupted",
			"allergies",
			"sensitivity",
			"disfigurement",
			"left_leg_broken",
			"right_leg_broken",
			"left_arm_broken",
			"right_arm_broken",
			"vomiting",
			"allergies",
			"haemophilia",
			"voyria",
			"minion_reset",
			"upset_effusion",
			"subdue",
			"effused_blood",
			"sapped_dexterity",
			"frenzy",
		},

		["secondary"] = {
			"blood_curse",
			"blood_poison",
			"blood_spew",
			"temptation",
			"seduction",
			"impatience",
			"stupidity",
			"epilepsy",
			"confusion",
			"berserking",
			"peace",
			"recklessness",
			"vertigo",
			"masochism",
			"agoraphobia",
			"dementia",
			"anorexia",
			"paranoia",
			"indifference",
			"amnesia",
			},
		},
}

prae = prae or {}

prae.initials = prae.initials or {}

prae.thirst = prae.thirst or false

prae.can_spew = prae.can_spew or true

prae.can_seize = prae.can_seize or true

prae.can_trill = prae.can_trill or true

prae.can_fling = prae.can_fling or true

prae.whisper_mode = prae.whisper_mode or "double"

prae.trill_mode = prae.trill_mode or false

prae.wield_mode = prae.wield_mode or "damage"

--This is a table that lists all of your possible Praenomen attacks that go before whispers or can't be combo'd with whispers

prae.initials = {

	["effigy_damage"] = {
		Praenomen = "frenzy effigy",
		choice = function()
			local class = rime.status.class
			return prae.initials.effigy_damage[class]
		end,
		can = function()
			local target = rime.target
			if not rime.pvp.has_def("dome", target) then return false end
			if not rime.targets[target].effigy then return false end
			return true
		end,
		combo = true,
		aff = "damage",
		call = "nothing",
	},

	["phreneses_sight"] = {
		"attack target oculus lightly",
		choice = function()
			return prae.initials.phreneses_sight[1]
		end,
		can = function()
			local spec = gmcp.Char.Status.spec
			local target = rime.target
			if spec ~= "Phreneses" then return false end
			if rime.pvp.has_aff("no_blind") then return false end
			if prae.can_spew then return false end
			return true
		end,
		combo = true,
		aff = "no_blind",
		call = "oculus",
	},

	["fling_extra"] = {
		"fling fling_tar",
		choice = function()
			return prae.initials.fling_extra[1]
		end,
		can = function()
			local flingable = false
			local target = rime.target
			if not prae.can_fling then return false end
			if gmcp.Char.Vitals.mounted == "0" then return false end
			for k,v in ipairs(swarm.room) do
				if v ~= target and table.contains(swarm.targeting.list, v) then
					flingable = true
					break
				end
			end
			if flingable and not rime.pvp.room.indoors then
				return true
			else
				return false
			end
		end,
		combo = true,
		aff = "flight",
		call = "nothing",
	},

	["shielded"] = {
		Praenomen = "frenzy target",
		Akkari = "denounce target",
		choice = function()
			local class = gmcp.Char.Status.class
			return prae.initials.shielded[class]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_def("shielded", target) then
				return true
			else
				return false
			end
		end,
		combo = true,
		aff = "shielded",
		call = "nothing",
	},

	["blood_rune"] = {
		"blood rune target",
		choice = function()
			return prae.initials.blood_rune[1]
		end,
		can = function()
			local spec = gmcp.Char.Status.spec
			if spec ~= "Rituos" then return false end
			if not hasSkill("Rune", "Sanguis") then return false end
			if rime.pvp.has_aff("blood_rune", rime.target) then
				return false
			else
				return true
			end
		end,
		combo = true,
		aff = "blood_rune",
		call = "nothing",
	},

	["seize"] = {
		"blood seize target",
		choice = function()
			return prae.initials.seize[1]
		end,
		can = function()
			local spec = gmcp.Char.Status.spec
			if spec ~= "Rituos" then return end
			if not prae.can_seize then return false end
			local targ = rime.target
			local mAffs = rime.pvp.mental_count(rime.target)
			local mAffBump = 4.00
			local seizeMana = tonumber((10.98) + (mAffs*mAffBump))
			--blood curse:
			-- %/10*1.5
			if rime.pvp.has_aff("blood_curse", targ) then
				seizeMana = seizeMana+((seizeMana/10)*1.5)
			end

			if ( rime.targets[rime.target].mana- seizeMana ) <= 37 and rime.pvp.has_aff("blood_rune", targ) then
				return true
			elseif ( rime.targets[rime.target].mana- seizeMana ) <= 32 then
				return true
			end
			return false
		end,
		combo = false,
		aff = "seize",
		call = "nothing",
	},

	["annihilate"] = {
		"annihilate target",
		choice = function()
			return prae.initials.annihilate[1]
		end,
		can = function()
			if rime.targets[rime.target].mana < 35 then
				return true
			elseif rime.targets[rime.target].mana < 44 and rime.pvp.has_aff("blood_rune", rime.target) then
				return true
			else
				return false
			end
		end,
		combo = false,
		aff = "annihilate",
		call = "nothing",
	},

	["blood_feast"] = {
		"blood feast target",
		can = function()
			local spec = gmcp.Char.Status.spec
			if rime.pvp.has_aff("writhe_transfix", rime.target) and spec == "Phreneses" then
				return true
			else
				return false
			end
		end,
		combo = false,
		aff = "blood_feast",
		call = "nothing",
	},

	["asthma"] = {
		Praenomen = "attack target kalmia",
		choice = function()
			local class = rime.status.class
			return prae.initials.asthma[class]
		end,
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("asthma", target) then return false end
			if not rime.canGash() then return false end
			return true
		end,
		combo = true,
		aff = "asthma",
		call = "kalmia",
	},

	["siphon"] = {
		Praenomen = "siphon target",
		choice = function()
			local class = rime.status.class
			return prae.initials.siphon[class]
		end,
		can = function()
			local target_mana = rime.targets[rime.target].mana
			local seize = prae.seize_math()
			local target = rime.target
			if not rime.pvp.has_aff("blood_curse", target) then return false end
			if not rime.pvp.has_aff("impatience", target) then return false end
			if target_mana < 56 and target_mana > 44 and not prae.can_seize then return true end
		end,
		combo = false,
		aff = "nothing",
		call = "nothing",
	},

	["no_blind"] = {
		"attack target oculus lightly",
		"attack target oculus",
		"mesmerize target",
		choice = function()
			local spec = gmcp.Char.Status.spec
			local targ = rime.target
			if rime.has_aff("prone") or rime.has_aff("left_arm_broken") or rime.has_aff("right_arm_broken") or rime.targets[targ].defences.rebounding then
				return prae.initials.no_blind[3]
	  		elseif spec == "Phreneses" then
				return prae.initials.no_blind[1]
			else
				return prae.initials.no_blind[2]
			end
		end,
		can = function()
			if rime.pvp.has_def("rebounding", rime.target) then
				return false
			else
				return true
			end
		end,
		combo = true,
		aff = "oculus",
		call = "oculus",
	},

	["writhe_transfix"] = {
		"mesmerize target",
		choice = function()
			return prae.initials.writhe_transfix[1]
		end,
		can = function()
			local targ = rime.target
			if rime.pvp.has_aff("no_blind", targ) and not rime.pvp.has_aff("writhe_impale", targ) and not rime.pvp.has_aff("writhe_transfix", targ) then
				return true
			else
				return false
			end
		end,
		combo = false,
		aff = "writhe_transfix",
		call = "nothing",
	},

	["disrupted"] = {
		Praenomen = "disrupt target",
		choice = function()
			local class = rime.status.class
			return prae.initials.disrupted[class]
		end,
		can = function()
			local targ = rime.target
			if rime.pvp.has_aff("confusion", targ) and rime.pvp.has_aff("sadness", targ) and rime.pvp.has_aff("impatience", targ) then
				return true
			elseif rime.pvp.has_aff("confusion", targ) and rime.pvp.has_aff("slickness", targ) and rime.pvp.has_aff("anorexia", targ) and rime.pvp.has_aff("asthma", targ) then
				return true
			elseif rime.has_aff("paralysis") and rime.pvp.mental_count(targ) >= 2 then
				return true
			else
				return false
			end
		end,
		combo = false,
		aff = "disrupted",
		call = "disrupted",
	},
	["damage"] = {
		"frenzy target",
		can = function()
			local target = rime.target
			if rime.pvp.has_aff("locked", target) then
				return true
			else
				return false
			end
		end,
		combo = false,
		aff = "frenzy",
		call = "nothing",
	},

	["frenzy"] = {
		"frenzy target",
		can = function()
			if rime.has_aff("prone") or rime.has_aff("paralysis") or rime.has_aff("writhe_transfix") or rime.has_aff("writhe_impaled") then
				return false
			else
				return true
			end
		end,
		combo = true,
		aff = "frenzy",
		call = "nothing",
	},

	["feed"] = {
		"feed target",
		can = function()
			local targ = rime.target
			if (rime.pvp.has_aff("physical", targ) and not (rime.targets[targ].defences.fangbarrier)) or 
	  		(rime.pvp.has_aff("blood_feast", targ) and not (rime.targets[targ].defences.fangbarrier)) then
				return true
			else
				return false
			end
		end,
		combo = true,
		aff = "feed",
		call = "nothing",
	},

	["push_feed"] = {
		"feed target",
		can = function()
			local target = rime.target
			if rime.pvp.has_def("fangbarrier", target) then return false end
			if not rime.pvp.has_aff("physical", target) then return false end
			return true
		end,
		combo = true,
		aff = "feed",
		call = "nothing",

	},
	 
	["paresis"] = {
		"attack target curare",
		choice = function()
			local spec = gmcp.Char.Status.spec
			return prae.initials.paresis[1]
		end,
		can = function()
			local target = rime.target
			local spec = gmcp.Char.Status.spec
			if rime.cure_set == "zealot" then return false end
			if rime.getTimeLeft("my_ghast") <= 2 and rime.pvp.minion == "ghastly" then return false end
			if rime.pvp.has_aff("paralysis", target) then return false end
			if rime.pvp.has_aff("paresis", target) then return false end
			if rime.canGash() then
				return true
			else
				return false
			end
		end,
		combo = true,
		aff = "curare",
		call = "curare",
	},

	["no_deaf"] = {
		"attack target prefarar",
		can = function()
			if rime.canGash() then
				return true
			else
				return false
			end
		end,
		combo = true,
		aff = "prefarar",
		call = "prefarar",
	},

	["sensitivity"] = {
		"attack target prefarar",
		can = function()
			if rime.canGash() then
				return true
			else
				return false
			end
		end,
		combo = true,
		aff = "prefarar",
		call = "prefarar",
	},
	["clumsiness"] = {
		"attack target xentio",
		can = function()
			if rime.canGash() then
				return true
			else
				return false
			end
		end,
		combo = true,
		aff = "xentio",
		call = "xentio",
	},

	["left_leg_broken"] = {
		"attack target epseth",
		can = function()
			if rime.canGash() then
				return true
			else
				return false
			end
		end,
		combo = true,
		aff = "epseth",
		call = "epseth",
	},

	["right_leg_broken"] = {
		"attack target epseth",
		can = function()
			if rime.canGash() then
				return true
			else
				return false
			end
		end,
		combo = true,
		aff = "epseth",
		call = "epseth",
	},

	["left_arm_broken"] = {
		"attack target epteth",
		can = function()
			if rime.canGash() then
				return true
			else
				return false
			end
		end,
		combo = true,
		aff = "epteth",
		call = "epteth",
	},

	["right_arm_broken"] = {
		"attack target epteth",
		can = function()
			if rime.canGash() then
				return true
			else
				return false
			end
		end,
		combo = true,
		aff = "epteth",
		call = "epteth",
	},

	["vomiting"] = {
		"attack target euphorbia",
		can = function()
			if rime.canGash() then
				return true
			else
				return false
			end
		end,
		combo = true,
		aff = "euphorbia",
		call = "euphorbia",
	},

	["allergies"] = {
		"attack target darkshade",
		can = function()
			if rime.canGash() then
				return true
			else
				return false
			end
		end,
		combo = true,
		aff = "darkshade",
		call = "darkshade",
	},

	["haemophilia"] = {
		"attack target hepafarin",
		can = function()
			if rime.canGash() then
				return true
			else
				return false
			end
		end,
		combo = true,
		aff = "hepafarin",
		call = "hepafarin",
	},

	["shyness"] = {
		"attack target digitalis",
		can = function()
			if rime.canGash() then
				return true
			else
				return false
			end
		end,
		combo = true,
		aff = "digitalis",
		call = "digitalis",
	},

	["dizziness"] = {
		"attack target larkspur",
		can = function()
			if rime.canGash() then
				return true
			else
				return false
			end
		end,
		combo = true,
		aff = "larkspur",
		call = "larkspur",
	},

	["disfigurement"] = {
		"attack target monkshood",
		can = function()
			local target = rime.target
			if not rime.pvp.has_aff("asthma", target) then return false end
			if rime.canGash() then
				return true
			else
				return false
			end
		end,
		combo = true,
		aff = "monkshood",
		call = "monkshood",
	},

	["voyria"] = {
		"attack target voyria",
		can = function()
			if rime.canGash() then
				return true
			else
				return false
			end
		end,
		combo = true,
		aff = "voyria",
		call = "voyria",
	},

	["effused_blood"] = {
		"blood effuse target",
		can = function()
			local target = rime.target
				return true
		end,
		combo = true,
		aff = "effused_blood",
		call = "nothing",
	},

	["upset_effusion"] = {
		"frenzy target upset",
		can = function()
			local targ = rime.target
			if rime.pvp.has_aff("effused_blood", targ) and not rime.pvp.has_aff("upset_effusion", targ) then
				return true
			else
				return false
			end
		end,
		combo = true,
		aff = "upset_effusion",
		call = "nothing",
	},

	["sapped_dexterity"] = {
		"frenzy target bodyleech",
		can = function()
			local targ = rime.target
			local euphoriant_affs = 0
			for k,v in ipairs(rime.curing.affsByCure.euphoriant) do
				if rime.pvp.has_aff(v, targ) then
					euphoriant_affs = euphoriant_affs+1
				end
			end
			if euphoriant_affs >= 3 then
				return true
			else
				return false
			end
		end,
		combo = true,
		aff = "sapped_dexterity",
		call = "nothing",
	},

  	["slickness"] = {
		"breathe target",
		can = function()
			local spec = gmcp.Char.Status.spec
			local target = rime.target
			local pill_balance = tonumber(rime.getTimeLeft("pill", target))
			local gate = rime.pvp.get_gate()
			if gate > pill_balance then return false end
			if not rime.pvp.has_aff("asthma", target) then return false end
			if rime.pvp.has_aff("slickness", target) then return false end
			return true 
		end,
		combo = true,
		aff = "slickness",
		call = "nothing",
	},

	["subdue"] = {
	"frenzy target subdue",
		can = function()
			local targ = rime.target
			local depressant_affs = 0
			for k,v in ipairs(rime.curing.affsByCure.depressant) do
				if rime.pvp.has_aff(v, targ) then
					depressant_affs = depressant_affs+1
				end
			end
			if depressant_affs >= 3 then
				return true
			else
				return false
			end
		end,
		combo = true,
		aff = "subdue",
		call = "nothing",
	},

	["minion_reset"] = {
		"frenzy target craze",
		can = function()
			local targ = rime.target
			local antipsychotic_affs = 0
			local mutation_conversion = {
				["eldritch"] = "hallucinations",
				["ghastly"] = "paresis",
				["festering"] = "haemophilia",
				["oozing"] = "fangbarrier",
		}
			for k,v in ipairs(rime.curing.affsByCure.antipsychotic) do
				if rime.pvp.has_aff(v, targ) then
					antipsychotic_affs = antipsychotic_affs+1
				end
			end
			if antipsychotic_affs >= 3 and not rime.pvp.minion == "oozing" and not rime.pvp.has_aff(mutation_conversion[rime.pvp.minion], targ) then
				return true
			else
				return false
			end
		end,
		combo = true,
		aff = "frenzy",
		call = "nothing",
	},
}

prae.secondary = {

		["blood_spew"] = {
			"blood spew target",
			can = function()
				if not hasSkill("Spew") then return false end
				if gmcp.Char.Status.spec ~= "Phreneses" then return false end
				if not prae.can_spew then return false end
				local target = rime.target
				if rime.pvp.has_def("rebounding", target) then return false end
				if rime.pvp.has_aff("no_blind", target) then return false end
				return true
			end,
			whisper = false,
			aff = "no_blind",
		},

		["impatience"] = {
			"impatience",
			can = function()
				if not hasSkill("Impatience") then return false end
				return true
			end,
			whisper = true,
			aff = "impatience",
		},

		["push_impatience"] = {
			"impatience",
			can = function()
				local target = rime.target
				if not hasSkill("Impatience") then return false end
				if not rime.pvp.has_aff("slough", target) then return false end
				return true
			end,
			whisper = true,
			aff = "impatience",
		},

		["confusion"] = {
			"confusion",
			can = function()
				if not hasSkill("Confusion") then return false end
				return true
			end,
			whisper = true,
			aff = "confusion",
		},

		["paranoia"] = {
			"paranoia",
			can = function()
				if not hasSkill("Paranoia") then return false end
				return true
			end,
			whisper = true,
			aff = "paranoia",
		},

		["stupidity"] = {
			"stupidity",
			can = function()
				if not hasSkill("Stupidity") then return false end
				return true
			end,
			whisper = true,
			aff = "stupidity",
		},

		["agoraphobia"] = {
			"agoraphobia",
			can = function()
				if not hasSkill("Agoraphobia") then return false end
				return true
			end,
			whisper = true,
			aff = "agoraphobia",
		},

		["masochism"] = {
			"masochism",
			can = function()
				if not hasSkill("Masochism") then return false end
				return true
			end,
			whisper = true,
			aff = "masochism",
		},

		["loneliness"] = {
			"loneliness",
			can = function()
				if not hasSkill("Loneliness") then return false end
				return true
			end,
			whisper = true,
			aff = "loneliness",
		},

		["seduction"] = {
			"seduction",
			can = function()
				if not hasSkill("Seduction") then return false end
				return true
			end,
			whisper = true,
			aff = "seduction",
		},

		["epilepsy"] = {
			"epilepsy",
			can = function()
				if not hasSkill("Epilepsy") then return false end
				return true
			end,
			whisper = true,
			aff = "epilepsy",
		},

		["anorexia"] = {
			"anorexia",
			can = function()
				if not hasSkill("Anorexia") then return false end
				return true
			end,
			whisper = true,
			aff = "anorexia",
		},

		["push_anorexia"] = {
			"anorexia",
			can = function()
				if not hasSkill("Anorexia") then return false end
				local target = rime.target
				if rime.pvp.has_aff("anorexia", target) then return false end
				if rime.pvp.has_aff("slickness", target) and rime.pvp.has_aff("asthma", target) then return true end
				if prae.init():find("breathe") and rime.pvp.has_aff("asthma", target) then
					return true
				elseif rime.pvp.has_aff("blood_poison", target) and prae.poison_count() == 3 and prae.init():find("epseth") and rime.pvp.has_aff("effused_blood", target) then
					return true
				elseif rime.pvp.has_aff("slough", target) then
					return true
				else
					return false
				end
			end,
		whisper = true,
		aff = "anorexia",
		},

		["amnesia"] = {
			"amnesia",
			can = function()
				if not hasSkill("Amnesia") then return false end
				return false
			end,
			whisper = true,
			aff = "amnesia",
		},

		["peace"] = {
			"peace",
			can = function()
				if not hasSkill("Peace") then return false end
				if not rime.cure_set == "revenant" or rime.cure_set == "templar" then
					return false
				else
					return true
				end
			end,
			whisper = true,
			aff = "peace",
		},

		["dementia"] = {
			"dementia",
			can = function()
				if not hasSkill("Dementia") then return false end
				return true
			end,
			whisper = true,
			aff = "dementia",
		},

		["push_dementia"] = {		
			"dementia",
			can = function()
				local spec = gmcp.Char.Status.spec
				local target = rime.target
				if not hasSkill("Dementia") then return false end
				if spec ~= "Rituos" then return false end
				if not rime.pvp.has_aff("impatience", target) then return false end
				if not rime.pvp.has_aff("blood_curse", target) then return false end
				if rime.pvp.has_aff("dementia", target) then return false end
				return true
			end,
			whisper = true,
			aff = "dementia",
		},

		["berserking"] = {
			"berserking",
			can = function()
				if not hasSkill("Berserking") then return false end
				return true
			end,
			whisper = true,
			aff = "berserking",
		},

		["push_berserking"] = {
			"berserking",
			can = function()
				local target = rime.target
				if not hasSkill("Berserking") then return false end
				if not rime.pvp.has_aff("impatience", target) then return false end
				if rime.pvp.has_def("shielded", target) or rime.pvp.has_def("rebounding", target) or rime.pvp.has_def("prismatic", target) then
					return true
				else
					return false
				end
			end,
			whisper = true,
			aff = "berserking",
		},

		["indifference"] = {
			"indifference",
			can = function()
				if not hasSkill("Indifference") then return false end
				return true
			end,
			whisper = true,
			aff = "indifference",
		},

		["vertigo"] = {
			"vertigo",
			can = function()
				if not hasSkill("Vertigo") then return false end
				return true
			end,
			whisper = true,
			aff = "vertigo",
		},

		["push_vertigo"] = {
			"vertigo",
			can = function()
				local target = rime.target
				if not hasSkill("Vertigo") then return false end
				if rime.pvp.room.indoors then return false end
				if not rime.pvp.has_def("flight", target) then return false end
				return true
			end,
			whisper = true,
			aff = "vertigo",
		},

		["temptation"] = {
			"temptation",
			can = function()
				if not hasSkill("Temptation") then return false end
				return true
			end,
			whisper = true,
			aff = "temptation",
		},

		["recklessness"] = {
			"recklessness",
			can = function()
				if not hasSkill("Recklessness") then return false end
				return true
			end,
			whisper = true,
			aff = "recklessness",
		},

		["blood_curse"] = {
			"blood curse target",
			can = function()
				if not hasSkill("Curse") then return false end
				local spec = gmcp.Char.Status.spec
				if spec ~= "Rituos" then return false end
				local antipsychotic_affs = 0
				local target = rime.target
				if rime.pvp.has_def("rebounding", target) then return false end
				for k,v in ipairs(rime.curing.affsByCure.antipsychotic) do
					if rime.pvp.has_aff(v, targ) then
						antipsychotic_affs = antipsychotic_affs+1
					end
				end
				if antipsychotic_affs >= tonumber(prae.curse_at) then
					return true
				else
					return false
				end
			end,
			whisper = false,
			aff = "blood_curse",
		},

		["blood_poison"] = {
			"blood poison target",
			can = function()
				if not hasSkill("Poison") then return false end
				local spec = gmcp.Char.Status.spec
				if spec ~= "Insidiae" then return false end
				if prae.init():find("frenzy") or prae.init():find("effuse") then return false end
				local tree_total = 0
				local target = rime.target
				if rime.pvp.has_def("rebounding", target) or rime.pvp.has_def("shielded", target) then return false end
				for k,v in ipairs(rime.curing.affsByCure.antipsychotic) do
					if rime.pvp.has_aff(v, target) and v ~= "sadness" then
						tree_total = tree_total+1
						break
					end
				end
			
				for k,v in ipairs(rime.curing.affsByCure.euphoriant) do
					if rime.pvp.has_aff(v, target) and v ~= "selfpity" then
						tree_total = tree_total+1
						break
					end
				end
			
				for k,v in ipairs(rime.curing.affsByCure.depressant) do
					if rime.pvp.has_aff(v, target) and v ~= "commitment_fear" then
						tree_total = tree_total+1
						break
					end
				end
				if tree_total >= 2 then
					return true
				else
					return false
				end
			end,
			whisper = false,
			aff = "blood_poison",
		},


}

function prae.seize_math(target)

	if not target then target = rime.target end

	local mAffs = rime.pvp.mental_count(target)
	local mAffBump = 4.00
	local seizeMana = tonumber((10.98) + (mAffs*mAffBump))
	--blood curse:
	-- %/10*1.5
	if rime.pvp.has_aff("blood_curse", target) then
		seizeMana = seizeMana+((seizeMana/10)*1.5)
	end

	return seizeMana

end

function prae.poison_count(target)

	if not target then target = rime.target end
	local tree_total = 0

	for k,v in ipairs(rime.curing.affsByCure.antipsychotic) do
		if rime.pvp.has_aff(v, target) and v ~= "sadness" then
			tree_total = tree_total+1
			break
		end
	end

	for k,v in ipairs(rime.curing.affsByCure.euphoriant) do
		if rime.pvp.has_aff(v, target) and v ~= "selfpity" then
			tree_total = tree_total+1
			break
		end
	end

	for k,v in ipairs(rime.curing.affsByCure.depressant) do
		if rime.pvp.has_aff(v, target) and v ~= "commitment_fear" then
			tree_total = tree_total+1
			break
		end
	end

	return tree_total

end


function rime.canGash()
	
	local target = rime.target
	local target_rebounding = tonumber(rime.getTimeLeft("rebounding", target))
	local gate = rime.pvp.get_gate()
	local gate_difference = gate - target_rebounding
	local difference = 0

	if rime.pvp.has_def("rebounding", target) then return false end
	if rime.pvp.has_def("shielded", target) then return false end
	if rime.has_aff("writhe_impaled") then return false end
	if rime.has_aff("writhe_transfix") then return false end
	if rime.has_aff("writhe_web") then return false end
	if rime.has_aff("writhe_ropes") then return false end
	if rime.has_aff("left_arm_broken") and rime.has_aff("right_arm_broken") then return false end
	if rime.has_aff("paralysis") then return false end

	if target_rebounding > gate then
		difference = target_rebounding - gate
		if difference < .6 then return false end
	end
	
	return true
	
end

function prae.init()

	local targ = rime.target
	local sep = rime.saved.separator

	for k,v in ipairs(rime.pvp.route.initial) do
		if not rime.pvp.has_aff(v, targ) and prae.initials[v].can() then
			if prae.initials[v].choice ~= nil then
				return prae.initials[v].choice():gsub("target", rime.target):gsub("hit", "target"), prae.initials[v].aff, prae.initials[v].combo, prae.initials[v].call
			else
				return prae.initials[v][1]:gsub("target", rime.target):gsub("hit", "target"), prae.initials[v].aff, prae.initials[v].combo, prae.initials[v].call
			end
		end
	end


end

function prae.second()

	local target = rime.target
	local whispers = {"confusion", "impatience", "paranoia", "stupidity", "agoraphobia", "masochism", "seduction", "epilepsy", "anorexia", "peace", "dementia", "berserking", "indifference", "vertigo", "temptation", "recklessness"}
	local attack_one = "nothing"
	local attack_two = "nothing"
	local attack_one_whisper = false
  
	local use, less, combo, shit = prae.init()

	if not combo then return "" end


	for k,v in ipairs(rime.pvp.route.secondary) do
		if not rime.pvp.has_aff(prae.secondary[v].aff, target) and prae.secondary[v].can() then
			attack_one = prae.secondary[v][1]
			attack_one_whisper = prae.secondary[v].whisper
			break
		end
	end
  
	if table.contains(whispers, attack_one) then
		for k,v in ipairs(rime.pvp.route.secondary) do
			if prae.secondary[v][1] ~= attack_one and not rime.pvp.has_aff(prae.secondary[v].aff, target) and prae.secondary[v].can() and prae.secondary[v].whisper then
				attack_two = prae.secondary[v][1]
				break
			end
		end
	end

	if attack_one == "nothing" then attack_one = "amnesia" end

	if attack_two == "nothing" then attack_two = "" end


	if not attack_one_whisper then

		return attack_one:gsub("target", rime.target)

	end

	local single, single_call = "whisper " .. attack_one .. " " .. rime.target, attack_one
	local double, double_call = "whisper " .. attack_one .. " " .. attack_two .. " " .. rime.target, attack_one .. "/" .. attack_two

	if rime.pvp.has_aff("blood_poison", target) and prae.poison_count() >= 3 then return single, single_call end
	--if gmcp.Char.Status.spec == "Phreneses" and tonumber(gmcp.Char.Vitals.blood) < 50 then return single, single_call end
	if attack_one == "temptation" then return double, double_call end
	if prae.whisper_mode == "single" and not rime.pvp.has_def("rebounding", target) and rime.pvp.has_aff("impatience", target) then return single, single_call end
	return double, double_call


end


function prae.weapon_selection()

	local spec = gmcp.Char.Status.spec
	local hp = rime.vitals.percent_health
	local left_hand = gmcp.Char.Vitals.wield_left
	local right_hand = gmcp.Char.Vitals.wield_right
	local weapons = {"scythe", "flyssa", "battleaxe", "whip", "warhammer", "glaive", "shortsword", "bastardsword", "broadsword", "whirlwind", "scales"}
	local shields = {"buckler", "tower"}
	local need_wield = "nothing"
	local weapon_chosen = "none"
	local target = rime.target
	local sep = rime.saved.separator

	if rime.pvp.has_def("flight", target) then
		need_wield = "whirlwind"
		weapon_chosen = "whirlwind " .. rime.saved.flavor_1h
	elseif prae.wield_mode == "tank" then
		if not right_hand:find(rime.saved.flavor_1h) then
			need_wield = rime.saved.shield .. " " .. rime.saved.flavor_1h
			weapon_chosen = rime.saved.flavor_1h
		end
	elseif prae.wield_mode == "damage" then
		if not left_hand:find(rime.saved.flavor_2h) then
			need_wield = rime.saved.flavor_2h
			weapon_chosen = rime.saved.flavor_2h
		end
	elseif prae.second():find("curse") then
		if not right_hand:find(rime.saved.flavor_1h) then
			need_wield = rime.saved.shield .. " " .. rimesaved.flavor_1h
			weapon_chosen = rime.saved.flavor_1h
		end
	end
--[[elseif hp < 45 and not right_hand:find(rime.saved.flavor_1h) then
		need_wield = rime.saved.shield .. " " .. rime.saved.flavor_1h
		weapon_chosen = rime.saved.flavor_1h
	elseif rime.cure_set == "carnifex" and not right_hand:find(rime.saved.flavor_1h) then
		need_wield = rime.saved.shield .. " " .. rime.saved.flavor_1h
		weapon_chosen = rime.saved.flavor_1h
	elseif rime.has_aff("lethargy") and not right_hand:find(rime.saved.flavor_1h) then
		need_wield = rime.saved.shield .. " " .. rime.saved.flavor_1h
		weapon_chosen = rime.saved.flavor_1h
	elseif (spec == "Rituos" or spec == "Phreneses") and hp > 45 and not left_hand:find(rime.saved.flavor_2h) then --and not prae.second():find("curse")
		need_wield = rime.saved.flavor_2h
		weapon_chosen = rime.saved.flavor_2h
	else
		need_wield = "nothing"
		weapon_chosen = "none"
	end]]

	if weapon_chosen == "none" then
		return "", weapon_chosen
	else
		return "wear " .. rime.saved.shield .. sep .. "quickwield both " .. need_wield, weapon_chosen
	end
	

end

prae.curse_at = 3


function prae.offense()

	local target = rime.target
	local sep = rime.saved.separator
	local init_attack, init_aff, combo, init_call = prae.init()
	local second_attack, second_call = prae.second()
	local command = ""
	local web_call = ""
	local weapon_wield, weapon = prae.weapon_selection()
	local left_hand = gmcp.Char.Vitals.wield_left
	local right_hand = gmcp.Char.Vitals.wield_right
	local weapons = {"scythe", "flyssa", "battleaxe", "whip", "warhammer", "glaive", "shortsword", "bastardsword", "rapier", "broadsword", "Yozati", "whirlwind"}
	weapon = weapon:gsub("%A+", "")
	if init_attack:find("fling_tar") then
			local fling_target = "aeryx"
			for k,v in ipairs(swarm.room) do
				if v ~= rime.target and table.contains(swarm.targeting.list, v) then
					fling_target = v
					break
				end
			end
		init_attack = init_attack:gsub("fling_tar", fling_target)
	end



	if init_attack:find("annihilate") and rime.pvp.has_aff("blood_rune", target) then
		init_attack = "activate rune"..sep..init_attack
	end

	if weapon == "none" then
		for k,v in ipairs(weapons) do
			if right_hand:find(v) then
				weapon = v
				break
			elseif left_hand:find(v) then
				weapon = v
				break
			end
		end
	end


	if rime.pvp.web_aff_calling then
		if combo then
			if init_call ~= "nothing" then
				if second_call == 1 then
					web_call = rime.pvp.omniCall(init_call.."/", "init")
				else
					web_call = rime.pvp.omniCall(init_call.."/"..second_call)
				end
			else
				web_call = rime.pvp.omniCall("/"..second_call, "whispers")
			end
		elseif init_call ~= "nothing" then
			web_call = rime.pvp.omniCall(init_call.."/", "init")
		end
	end

	if rime.pvp.web_aff_calling then

		command = rime.pvp.queue_handle() .. sep .. web_call .. sep .. weapon_wield .. sep .. init_attack .. sep .. second_attack

	else

		command = rime.pvp.queue_handle() .. sep .. web_call .. sep .. weapon_wield .. sep .. init_attack .. sep .. second_attack

	end

	if command:find("attack") and weapon_wield then
		local verb = rime.pvp.weapon_verbs[weapon]
		--if (prae.whisper_mode == "single" and verb == "gash") or second_attack:find("curse") then
		if prae.whisper_mode == "single" and verb == "gash" then
			verb = "gash "..rime.target.." lightly"
			command = command:gsub("attack "..rime.target, verb)
		elseif second_attack:find("curse") then
			verb = "gash "..rime.target.." lightly"
			command = command:gsub("attack "..rime.target, verb)
		else
			command = command:gsub("attack", verb)
		end
	end
	command = command:gsub("nothing", "")
	command = command:gsub("tfree", "target nothing")
	command = command:gsub(sep .. sep .. "+", sep)

	if command ~= rime.balance_queue and command ~= rime.balance_queue_attempted then
		act(command)
		rime.balance_queue_attempted = command
	end

end