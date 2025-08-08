--Authors: Xarian, Holbrook, Linne

archivist = archivist or {}
archivist.attacks = archivist.attacks or {}
archivist.debug = false
archivist.debugString = ""
archivist.cooldowns = {
	["madness"] = false,
	["conjoin"] = false,
	["syncopate"] = false,
	["empower"] = false,
	["matrix"] = 0,
}
archivist.position = {}
archivist.position.mode = ""
archivist.position.target = ""

archivist.toggles = {
	["knitting"] = false,
	["recollection"] = false,
	["ethereal"] = false,
}

archivist.token = {
	trace = false,
	traceTarget = "",
	invert = false,
	id = 0,
}

archivist.afterimages = {}

archivist.bio = 0

archivist.capturingMutagenList = false
archivist.mutagenList = archivist.mutagenList or {} 

archivist.madness_affs = {}
archivist.want_empower = "jhako"
archivist.flared = false
archivist.want_conjoin = false
archivist.current_empower = ""
archivist.offense_timer = 0
archivist.wait_growth = false
archivist.current_impression = "none"
archivist.wait_until = 0
archivist.next_affs = {}
archivist.mutagen = {
	["addiction"] = getEpoch(),
	["impairment"] = getEpoch(),
	["lethargy"] = getEpoch()
}
archivist.next_bal = getEpoch()
archivist.timers = {
	["mutagen"] = getEpoch(),
	["first_mutagen"] = getEpoch(),
	["growth"] = getEpoch(),
	["hex"] = getEpoch(), --Moved this to rime.targets[target].time.hexTimer. We also have crescentTimer there.
	["targetRenew"] = getEpoch(),
	["targetTree"] = getEpoch(),
	["targetFocus"] = getEpoch(),
	["matrix"] = getEpoch(),
}
archivist.shapes = {
	["triangle"] = {["laxity"] = true, ["lovers_effect"] = true, ["peace"] = true, ["magnanimity"] = true},
	["square"] = {["dizziness"] = true, ["faintness"] = true, ["epilepsy"] = true, ["shyness"] = true},
	["circle"] = {["merciful"] = true, ["masochism"] = true, ["berserking"] = true, ["recklessness"] = true}
}
archivist.shape_affs = table.union(archivist.shapes.triangle, archivist.shapes.square, archivist.shapes.circle)

rime.pvp.Archivist.routes = {
	["cheese"] = {
		["main"] = {
			"shielded",
			"unravel",
			"infect",
			"cheese",
			"wait",
			"matrix",
			"shape",
			"pattern",
			"lemniscate",
			"hex",
			"crux",
		},
		["mutagen"] = {
			["name"] = "zugzwang",
			["potency"] = "chronic",
			["effects"] = {"impairment", "addiction", "lethargy"}
		},
		["shape_afflictions"] = {
			["dizziness"] = true,
			["laxity"] = true,
			["faintness"] = true,
			["epilepsy"] = true,
			["magnamity"] = true,
		}
	},
	["group_default"] = {
		["main"] = {
			"shielded",
			"unravel",
			"infect",
			"madness",
			"crux",
		},
		["mutagen"] = {
			["name"] = "zugzwang",
			["potency"] = "chronic",
			["effects"] = {"impairment", "addiction", "lethargy"}
		},
		["shape_afflictions"] = {
			["dizziness"] = true,
			["laxity"] = true,
			["faintness"] = true,
		}
	},	
	["unravel"] = {
		["main"] = {
			"shielded",
			"changeheart_ally_prone",
			"unravel",
			"infect",
			"matrix",
			"madness",
			"shape",
			"pattern",
			"lemniscate",
			"growth",
			"hex",
			"fillerPattern",
			--"crux",
			"affliction"
		},
		["mutagen"] = {
			["name"] = "zugzwang",
			["potency"] = "chronic",
			["effects"] = {"impairment", "addiction", "lethargy"}
		},
		["shape_afflictions"] = {
			["dizziness"] = true,
			["laxity"] = true,
			["faintness"] = true,
		}
	},
	["unravel2"] = {
		["main"] = {
			"shielded",
			"changeheart_ally_prone",
			"unravel",
			"sealing",
			"infect",
			"flare",
			"lemniscate",
			"matrix",
			"madness",
			"pattern",
			"growth",
			"shape",
			"fillerPattern",
			"hex",
			"crux",
			"affliction"
		},
		["mutagen"] = {
			["name"] = "zugzwang",
			["potency"] = "chronic",
			["effects"] = {"impairment", "addiction", "lethargy"}
		},
		["shape_afflictions"] = {
			["dizziness"] = true,
			["laxity"] = true,
			["faintness"] = true,
		}
	},
	["seal_dmg"] = {
		["main"] = {
			"shielded",
			"changeheart_ally_prone",
			"unravel",
			"sealed_crux",
			"crescent",
			"seal_circle",
			"seal_square",
			"seal_triangle",
			"infect",
			"pattern_before_matrix",
			"flare_phys",
			"one_matrix",
			"lemniscate",
			"madness",
			"shape",
			"fillerPattern",
			"crux",
		},
		["mutagen"] = {
			["name"] = "antipsy",
			["potency"] = "sporatic",
			["effects"] = {"sadness", "impairment", "lethargy"}
		},
		["shape_afflictions"] = {
			["laxity"] = true,
			["faintness"] = true,
			["dizziness"] = true,
		}
	},
	["group"] = {
		["main"] = {
			"shielded",
			"unravel",
			"ethereal",
			"flare",
			"pattern_before_matrix",
			"infect",
			"madness",
			"one_matrix",
			"shape",
			"crux",
		},
		["mutagen"] = {
			["name"] = "groupfight",
			["potency"] = "sporatic",
			["effects"] = {"impairment", "addiction", "lethargy"}
		},
		["shape_afflictions"] = {
			["dizziness"] = true,
			["faintness"] = true,
		}
	},
	["mental"] = {
		["main"] = {
			"shielded",
			"unravel",
			"infect",
			"cheese",
			"wait",
			"syncopate",
			"matrix",
			"hex",
			"madness",
			"shape",
			"pattern",
			"lemniscate",
			"crescent",
			"crux",
			"affliction"
		},
		["mutagen"] = {
			["name"] = "zugzwang",
			["potency"] = "chronic",
			["effects"] = {"impairment", "addiction", "lethargy"}
		},
		["shape_afflictions"] = {
			["merciful"] = true,
			["laxity"] = true,
			["dizziness"] = true,
			["faintness"] = true,
			["epilepsy"] = true,
			["magnamity"] = true,
		}
	},
	["mental2"] = {
		["main"] = {
			"shielded",
			"unravel",
			"infect",
			"syncopate",
			"matrix",
			"hex",
			"madness",
			"shape",
			"pattern",
			"lemniscate",
			"crescent",
			"crux",
			"affliction"
		},
		["mutagen"] = {
			["name"] = "zugzwang",
			["potency"] = "chronic",
			["effects"] = {"impairment", "addiction", "lethargy"}
		},
		["shape_afflictions"] = {
			["merciful"] = true,
			["laxity"] = true,
			["dizziness"] = true,
			["faintness"] = true,
			["epilepsy"] = true,
			["magnamity"] = true,
		}
	}
}

archivist.attacks = {
	["cheese"] = {
		can = function()
			if not rime.pvp.has_aff("mutagen", rime.target) then return false end
			--if rime.targets[rime.target].target_mental < 2 then return false end
			local addiction = archivist.mutagen.addiction - getEpoch()
			return addiction < 18 or (archivist.timers.growth < 10 and archivist.wait_growth)
		end,
		choice = function()
			local addiction = archivist.mutagen.addiction - getEpoch()
			if archivist.wait_growth then 
				local echo_string = "addiction in: "..string.format("%.2f", addiction)
				echo_string = echo_string .. string.format(", growth %.2fs old", getEpoch() - archivist.timers.growth)
				rime.echo(echo_string)
			end
			if addiction > 7.5 and not archivist.attacks.wait.can() then
				if archivist.attacks.hex.can() then
					return archivist.attacks.hex.choice()
				else
					return archivist.attacks.shape.choice()
				end
			elseif addiction > 4 and addiction < 7 and not archivist.wait_growth then
				return archivist.attacks.growth.choice()
			elseif addiction > 1.8 and archivist.wait_growth then
				local attack, aff = archivist.attacks.madness.choice()
				return archivist.concat({attack, "bio stimulant"}), aff --this table.concat was an actString
			elseif getEpoch() - archivist.timers.growth > 6 and archivist.wait_growth then
				return archivist.concat({archivist.pick_impression({}, "swirl"), "bio flare target", "bio steroid"}) --this table.concat was an actString
			else
				if archivist.current_impression ~= "swirl" then return archivist.pick_impression({}, "swirl") end
			end
		end
	},
	["changeheart_ally_prone"] = {
		can = function ()
			if rime.has_aff("prone") then
				return true
			else
				return false
			end
		end,
		choice = function()
			archivist.want_empower = "ef'tig"
			return "elicit changeheart target ally"
		end
	},
	["shape"] = {
		can = function()
			--we need to do something here to not attempt to give shape affs for stuff we've got sealed
			--maybe we can just not attempt shape if we've got more than 1 seal going on the target? matrix and shit should be going at this point
			-- ^ this is lazy
			if archivist.cooldowns.conjoin and not has_def("conjoin") then return false end
			if table.size(table.complement(rime.pvp.route.shape_afflictions, rime.targets[rime.target].afflictions)) == 0 then return false end
			return true
		end,
		choice = function()
			local afflict = next(table.complement(rime.pvp.route.shape_afflictions, rime.targets[rime.target].afflictions))
			local shape = archivist.getShape(afflict)
			if archivist.debug then rime.echo("Incite: "..shape.." ("..afflict..")") end
			archivist.want_conjoin = true
			archivist.pick_impression({}, "hex") --do we want bloom here? maybe we should smart select to make sure
			return "incite "..shape.." target", {[archivist.next_shape_aff(shape)] = true}
		end
	},
	["infect"] = {
		can = function()
			return not rime.pvp.has_aff("mutagen", rime.target)
		end,
		choice = function()
			local mutagen = rime.pvp.route.mutagen
			local str = ""
			if not archivist.mutagenExists(mutagen.name) then str = archivist.makeMutagen(mutagen) end
			archivist.pick_impression({}, "bloom")
			return str..rime.saved.separator.."bio infect target with "..mutagen.name, {["mutagen"] = true}
		end
	},
	["syncopate"] = {
		can = function()
			return not archivist.cooldowns.syncopate and rime.pvp.mental_count(target) >= 5
		end,
		choice = function()
			return "elicit syncopate target"
		end
	},	
	["wait"] = {
		can = function()
			if not rime.pvp.has_aff("mutagen", rime.target) 
			or not archivist.wait_growth then return false end
			local has_muta_physical = false
			for _, v in ipairs(rime.pvp.route.mutagen.effects) do 
				if rime.pvp.has_aff(v, rime.target) then has_muta_physical = true end
			end
			if archivist.wait_growth
			and has_muta_physical then return true end
			return false
		end,
		choice = function()
			if not rime.pvp.has_aff("mental_disruption", rime.target) then
				return archivist.pick_impression({}, "swirl")
			elseif not rime.pvp.has_aff("vomiting", rime.target) then
				return archivist.pick_impression({}, "bloom")
			else
				return archivist.pick_impression({}, "star")
			end
		end
	},
	["growth"] = {
		can = function()
			if not rime.pvp.has_aff("mutagen", rime.target)
				or archivist.wait_growth 
			then return false end
			if getEpoch() - archivist.timers.growth < 10 then return false end
			if getEpoch() - archivist.timers.mutagen > 2.2 
				and getEpoch() - archivist.timers.mutagen < 3 
			then return true end
			return false
		end,
		choice = function()
			archivist.pick_impression({}, "swirl")
			return "bio growth target", {}
		end
	},
	["seal_triangle"] = {
		can = function()
			if not archivist.next_shape_aff("triangle") and not rime.pvp.has_aff("sealing_triangle") then
				return true
			end
			return false
		end,
		choice = function()
			return "geo sealing triangle target", {["sealing_triangle"] = true}
		end
	},
	["seal_circle"] = {
		can = function()
			if not archivist.next_shape_aff("circle") and not rime.pvp.has_aff("sealing_circle") then
				return true
			end
			return false
		end,
		choice = function()
			return "geo sealing circle target", {["sealing_circle"] = true}
		end
	},
	["seal_square"] = {
		can = function()
			if not archivist.next_shape_aff("square") and not rime.pvp.has_aff("sealing_square") then
				return true
			end
			return false
		end,
		choice = function()
			return "geo sealing square target", {["sealing_circle"] = true}
		end
	},
	["sealing"] = {
		can = function()
			if not archivist.next_shape_aff("triangle")
			or not archivist.next_shape_aff("circle")
			or not archivist.next_shape_aff("square") then
				if not rime.pvp.has_aff("sealing_triangle") or not rime.pvp.has_aff("sealing_circle") or not rime.pvp.has_aff("sealing_square") then
					return true
				else
					return false
				end
			end
			return false
		end,
		choice = function()
			if not archivist.next_shape_aff("triangle") and not rime.pvp.has_aff("sealing_triangle") then
				return "geo sealing triangle target", {["sealing_triangle"] = true}
			elseif not archivist.next_shape_aff("square") and not rime.pvp.has_aff("sealing_square") then
				return "geo sealing square target", {["sealing_square"] = true}
			elseif not archivist.next_shape_aff("circle") and not rime.pvp.has_aff("sealing_circle") then
				return "geo sealing circle target", {["sealing_circle"] = true}
			end
		end
	},
	["crescent"] = {
		can = function()
			if table.size(table.intersection({["sealing_triangle"] = true, ["sealing_square"] = true, ["sealing_circle"] = true}, 
			rime.targets[rime.target].afflictions)) > 2 and not rime.targets[rime.target].geoCrescent then return true end
			return false
		end,
		choice = function()
			archivist.pick_impression({}, "star")
			return "incite crescent target"
		end
	},
	["pattern"] = {
		can = function()
			--couple of conditions. If shielded, we can pattern regardless.
			--If not shielded, we want to make sure they have matrix or lemniscate first.
			--do we want to do this at all if there's no pending afterimages on them? it does
			if rime.pvp.has_def("shielded", rime.target) and rime.pvp.has_aff("matrix", rime.target) and not rime.pvp.has_aff("patterns", rime.target) then return true end
			if not rime.pvp.has_def("shielded", rime.target) and 
				(rime.pvp.has_aff("matrix", rime.target) or rime.pvp.has_aff("lemniscate", rime.target)) and 
				not rime.pvp.has_aff("patterns", rime.target) 
			then
				return true
			end
			return false
			-- if getEpoch() - archivist.timers.first_mutagen < 9 then return true end
		end,
		choice = function()
			return "geo pattern target", {["patterns"] = true}
		end
	},
	["fillerPattern"] = {
		can = function()
			--This one only fires if madness and conjoin are off CD.
			--Note position of this should be after madness and shape.
			if rime.pvp.has_aff("patterns", rime.target) then return false end
			return (archivist.cooldowns.conjoin or archivist.cooldowns.madness)
		end,
		choice = function()
			archivist.pick_impression({}, "bloom")
			return "geo pattern target", {["patterns"] = true}
		end
	},
	["pattern_before_matrix"] = {
		can = function()
			--matrix hits exactly 5s after you use it, so we always want to try and have patterns on them beforehand
			if rime.pvp.has_aff("patterns", rime.target) then return false end
			local timediff = getEpoch() - archivist.timers.matrix
			--are we within a proper window?
			return ((timediff >= 2 and timediff <= 4.5)) --and archivist.cooldowns.madness)
		end,
		choice = function()
			rime.echo("debug: pattern_before_matrix firing due to upcoming matrix (hopefully?)", "pvp")
			archivist.pick_impression({}, "bloom")
			return "geo pattern target", {["patterns"] = true}
		end
	},
	["hex"] = {
		can = function()
			return not rime.targets[rime.target].geoHex
		end,
		choice = function()
			return "incite hex target", {}
		end
	},
	["lemniscate"] = {
		can = function()
			--this sometimes causes us to waste matrix hits if one is in progress
			--also we probably shouldn't be using this at all unless there's shape afterimages in the pipeline somewhere
			--also see if we even have any afterimages to use it with, if not, this is a long eq and we probably shouldn't be using it needlessly
			local matrix_time = getEpoch() - archivist.timers.matrix
			if matrix_time >= 3 and matrix_time <= 5.5 then 
				rime.echo("debug: skipping LEM to (hopefully) upcoming matrix", "pvp")
				return false 
			end -- skip for the moment
			if not rime.pvp.has_aff("lemniscate", rime.target) and rime.pvp.has_aff("patterns", rime.target) and archivist.afterimages_count(rime.target) >= 2 then return true end
			-- this worked ok with just 1 afterimage, but maybe we should up it to 2 to at least make sure matrix is gonna happen?
			return false
		end,
		choice = function()
			return "incite lemniscate target", {["lemniscate"] = true}
		end
	},
	["crux"] = {
		can = function()
			return true
		end,
		choice = function()
			archivist.pick_impression({}, "star")
			rime.echo("WE DO BE CRUXIN OUT HERE. DRY. WHY ARE WE DOING THIS.")
			--at least try to salvage this by setting star impression so we can get SOME aff throughput out of it
			archivist.pick_impression({}, "star")
			return "incite crux target", {}
		end
	},
	["sealed_crux"] = {
		can = function()
			--will utilize crux's increased damage when sealing, should probably have at least 2 sealed shapes first though
			--only if crescent is on cooldown though <- nah fuck that it
			if table.size(table.intersection({["sealing_triangle"] = true, ["sealing_square"] = true, ["sealing_circle"] = true}, 
			rime.targets[rime.target].afflictions)) >= 2 or rime.targets[rime.target].geoCrescent then
				return true
			end
		end,
		choice = function()
			archivist.pick_impression({}, "star")
			return "incite crux target", {}
		end
	},
	["matrix"] = {
		can = function()
			if not rime.pvp.has_aff("patterns", rime.target) then return false end
			return (archivist.next_shape_aff("triangle")
			and archivist.next_shape_aff("square")
			and archivist.next_shape_aff("circle"))
		end,
		choice = function()
			--return "geo matrix target", {[archivist.next_shape_aff("square")] = true,
										--- [archivist.next_shape_aff("triangle")] = true,
										-- [archivist.next_shape_aff("circle")] = true}
										return "geo matrix target", {}
		end
	},
	["one_matrix"] = {
		can = function()
			if not rime.pvp.has_aff("patterns", rime.target) then return false end
			return (archivist.next_shape_aff("triangle")
			and archivist.next_shape_aff("square")
			and archivist.next_shape_aff("circle") and getEpoch() - archivist.timers.matrix >= 5)
		end,
		choice = function()
			archivist.want_conjoin = true
			--return "geo matrix target", {[archivist.next_shape_aff("square")] = true,
										--- [archivist.next_shape_aff("triangle")] = true,
										-- [archivist.next_shape_aff("circle")] = true}
										return "geo matrix target", {}
		end
	},
	["hard_matrix"] = {
		can = function () 
			--we can "hard matrix" when conjoin is available and we've got patterns stuck
			if not rime.pvp.has_aff("patterns", rime.target) then 
				return false 
			end

			if archivist.cooldowns.conjoin and not has_def("conjoin") then
				return false
			end

			return (archivist.next_shape_aff("triangle")
			and archivist.next_shape_aff("square")
			and archivist.next_shape_aff("circle"))
		end,
		choice = function()
			archivist.want_conjoin = true
			archivist.pick_impression({}, "hex")
			return "geo matrix target", {}
		end
	},
	["madness"] = {
		can = function()
			if archivist.cooldowns.madness then return false end
			archivist.madness_affs = table.complement({["dementia"] = true, ["hallucinations"] = true, ["paranoia"] = true}, rime.targets[rime.target].afflictions)
			return table.size(archivist.madness_affs) > 1
		end,
		choice = function()
			archivist.want_empower = "jhako"
			archivist.pick_impression({}, "bloom")
			return "elicit madness target", table.complement({["dementia"] = true, ["hallucinations"] = true, ["paranoia"] = true}, rime.targets[rime.target].afflictions)
		end
	},
	["madness_after_pattern"] = {
		can = function()
			if archivist.cooldowns.madness then return false end
			archivist.madness_affs = table.complement({["dementia"] = true, ["hallucinations"] = true, ["paranoia"] = true}, rime.targets[rime.target].afflictions)
			local timediff = getEpoch() - archivist.timers.matrix
			--are we within a proper window?
			return table.size(archivist.madness_affs) > 1 and not ((timediff >= 2.5 and timediff <= 5.5))
		end,
		choice = function()
			archivist.want_empower = "jhako"
			archivist.pick_impression({}, "bloom")
			return "elicit madness target", table.complement({["dementia"] = true, ["hallucinations"] = true, ["paranoia"] = true}, rime.targets[rime.target].afflictions)
		end
	},
	["affliction"] = {
		can = function()
			return true
		end,
		choice = function()
			archivist.want_empower = "yi"
			return "elicit affliction target"
		end
	},
	["shielded"] = {
		can = function()
			return rime.pvp.has_def("shielded", rime.target)
		end,
		choice = function()
			if rime.pvp.has_aff("patterns") then
				return "incite fork target"
			end
			return "touch hammer target"
		end
	},
	["unravel"] = {
		can = function()
			local target = rime.target
			if not rime.pvp.has_aff("mutagen", target) then return false end 
			if rime.pvp.mental_count(target) < 3
			or rime.pvp.physical_count(target) < 3 then return false end
			return true
		end,
		choice = function()
			archivist.want_empower = "rafic"
			return "elicit unravel "..rime.target
		end
	},
	["trace"] = {
		can = function()
			if archivist.token.id == "" then return false end
			if archivist.token.trace then return false end
			return true;
		end,
		choice = function()
			return "drop token"..rime.saved.separator.."geo trace" --adding drop token here isn't clean, sue me! -Holbrook
		end
	},
	["invert"] = {
		can = function()
			if archivist.token.id == "" then return false end
			if archivist.token.invert then return false end
			return true;
		end,
		choice = function()
			return "drop token"..rime.saved.separator.."geo invert" --adding drop token here isn't clean, sue me! -Holbrook
		end
	},
	["knitting"] = {
		can = function()
			if not archivist.toggles.knitting then return false end
			if rime.vitals.percent_health <= 60 and gmcp.Char.Vitals.fallen ~= "1" and archivist.bio > 0 then
				return true
			end
			return false
		end,
		choice = function()
			return "bio knitting"
		end
	},
	["ethereal"] = {
		can = function()
			if not archivist.toggles.ethereal then return false end
			if rime.vitals.percent_health <= 60 and archivist.bio >= 2 then
				return true
			end
			return false
		end,
		choice = function()
			archivist.pick_impression({}, "crescent")
			return "bio ethereal"
		end
	},
	["recollection"] = {
		can = function()
			if not archivist.toggles.recollection then return false end
			if gmcp.Char.Vitals.fallen ~= "1" and not (rime.has_aff("paresis") or rime.has_aff("paralysis")) and 
			(gmcp.Char.Vitals.tree == "0" or gmcp.Char.Vitals.renew == "0") then
				return true
			end
			local conditions = ""
			if  (rime.has_aff("paresis") or rime.has_aff("paralysis")) then conditions = conditions .. "Had paresis/paralysis "
			end
			return false
		end,
		choice = function()
			archivist.want_empower = "yuef"
			return "elicit recollection"
		end
	},
	["flare"] = {
		can = function()
			if rime.pvp.has_aff(archivist.mutagenNextAff(), rime.target) then return false end
			if rime.pvp.mental_count(target) >= 5 and archivist.bio >= 1 then 
				if rime.pvp.physical_count(target) >= 3 and rime.pvp.mental_count(target) >= 3 and rime.pvp.has_aff("mutagen", target) then
					rime.echo("Oi, you should be unravelling!","pvp")
					return false
				end
				return true
			end
			return false
		end,
		choice = function()
			return "bio flare target"
		end
	},
	["flare_phys"] = {
		--this only flares if the next mutagen aff is actually physical
		can = function()
			if rime.pvp.has_aff(archivist.mutagenNextAff(), rime.target) then return false end
			if rime.pvp.mental_count(target) >= 5 and archivist.bio >= 1 and table.contains(rime.curing.affsByType.physical, archivist.mutagenNextAff()) then 
				if rime.pvp.physical_count(target) >= 3 and rime.pvp.mental_count(target) >= 3 and rime.pvp.has_aff("mutagen", target) then
					rime.echo("Oi, you should be unravelling!","pvp")
					return false
				end
				return true
			end
			return false
		end,
		choice = function()
			return "bio flare target"
		end
	},
}

function archivist.concat(strings)
	local outputStr = ""
	local sep = rime.saved.separator
	for k, v in ipairs(strings) do
		outputStr = outputStr .. v .. sep
	end
	return outputStr
end

function archivist.ignore_aff(aff)
	if aff == "no_deaf" then
		return true
	end
	if aff == "no_blind" then
		return true
	end
	if aff == "prone" then
		return true
	end

	return false
end

function archivist.track_afterimage(shape_type, tar)
	--afterimages will fire after every use of square/triangle/circle & matrix 5 seconds after they're used on a target
	--IF the target is alone OR if they have patterns.
	--if they have lemniscate, afterimages will self-loop without reapplication up to 15 times.
	--lemniscate will fade after 9 seconds, or remain indefinitely if they have at least 1 aff from any of the triangle/circle/square pools
	--afterimages are independent of one another
	--so it's worth tracking afterimages because:
	--	1) we can then use logic to determine if lemniscate is actually worth using (aka do we have any afterimages in the pipeline it'll benefit from?)
	--	2) we can assign a priority to keeping patterns up on someone to ensure afterimage affs actually hit
	-- 	3) we'll be able to react to upcoming matrix hits of 3+ affs
	table.insert(archivist.afterimages, {time_set = getEpoch(), type = shape_type, target = tar})
end

function archivist.handle_afterimages()
	--any afterimages with a time > 5.5 did not fire, so should be removed.
	--successful afterimages will relapse again with lemniscate
	for k, v in ipairs(archivist.afterimages) do
		local time = getEpoch() - v.time_set
		if time >= 5.1 then
			table.remove(archivist.afterimages, k)
			--we should maybe check to see if they're in-room here too, otherwise afterimage will keep firing
			--rime.echo(f("debug: removed failed {v.type} afterimage on {v.target} after {time}s"), "pvp")
		end
	end
end

function archivist.afterimages_count(tar)
	local count = 0
	for k, v in ipairs(archivist.afterimages) do
		if v.target:lower() == tar:lower() then count = count + 1 end
	end
	return count
end

function archivist.remove_oldest_afterimage(shape_type, tar)
	local oldest = {time_set = getEpoch()}
	local rem_index = nil
	for k, v in ipairs(archivist.afterimages) do
		if v.type == shape_type and v.target == tar and v.time_set <= oldest.time_set then
			oldest = v
			rem_index = k
		end
	end
	if oldest ~= nil then
		table.remove(archivist.afterimages, rem_index)
		return oldest
	else
		return false
	end
end

function archivist.get_attacks()
	for k, v in ipairs(rime.pvp.route.main) do
		if archivist.attacks[v].can() then
			if archivist.debug then 
				archivist.debugString = archivist.debugString .. "get_attacks() "..v.." "
			end
			return archivist.attacks[v].choice()
		end
	end
end

function archivist.next_shape_aff(shape)
	for k, _ in pairs(archivist.shapes[shape]) do
		if not rime.pvp.has_aff(k, rime.target) then return k end
	end
	return false
end

function archivist.pick_impression(aff, shape_wanted)
	aff = aff or {}
	local shape = "star"
	if not rime.pvp.has_aff("vomiting", rime.target) and
	table.size(table.intersection(aff, rime.pvp.mental_aff_list)) > 0 and
	rime.pvp.mental_count(target) % 5 + table.size(table.intersection(aff, rime.pvp.mental_aff_list)) >= 5 then
		shape = "bloom"
	elseif not rime.pvp.has_aff("mental_disruption", rime.target) and
	(rime.pvp.has_aff("faintness", rime.target) or
	(getEpoch() - archivist.timers.mutagen > 6 and archivist.wait_growth)) then
		shape = "swirl"
	elseif not rime.pvp.has_aff("hypochondria", rime.target) then
		shape = "hex"
	end
	if shape_wanted ~= nil then shape = shape_wanted end
	if shape ~= archivist.current_impression then return "geo impress "..shape end
	return ""
end

function archivist.get_pre_attack(aff)
	local target = rime.target
	local commands = {}
	local sep = rime.saved.separator
	if archivist.want_conjoin and not has_def("conjoin") then
		table.insert(commands, "geo conjoin") end
	table.insert(commands, archivist.pick_impression(aff))
	if archivist.want_empower ~= archivist.current_empower then
		table.insert(commands, "empower "..archivist.want_empower)
	end

	return table.concat(commands, sep)
end

function archivist.mutagenExists(mut)
	for k, v in pairs(archivist.mutagenList) do
		if string.lower(mut) == string.lower(k) then
			return true
		end
	end
	return false
end

archivist.mutagenEffects = {
	["sadness"] = "Depressant",
	["lethargy"] = "Somnolent",
	["masochism"] = "Psychoactive",
	["allergies"] = "Reactive",
	["addiction"] = "Narcotic",
	["impairment"] = "Degenerative",
	["blisters"] = "Malignant",
	["weariness"] = "Atrophic"
}

archivist.mutagenAffs = {
	["Depressant"] = "sadness",
	["Somnolent"] = "lethargy",
	["Psychoactive"] = "masochism",
	["Reactive"] = "allergies",
	["Narcotic"] = "addiction",
	["Degenerative"] = "impairment",
	["Malignant"] = "blisters",
	["Atrophic"] = "weariness",
  }
  

function archivist.makeMutagen(arg)
	local muta
	muta = archivist.concat({"mutagen "..arg.name.." delete", --this table.concat was an actstring
		"mutagen new "..arg.name,
		"mutagen "..arg.name.." potency "..arg.potency})
	for _, effect in pairs(arg.effects) do
		muta = muta..rime.saved.separator.."mutagen "..arg.name.." effect "..archivist.mutagenEffects[effect]
	end
	return muta..rime.saved.separator.."mutagen "..arg.name.." complete"
end

function archivist.mutagenFired(aff, target)
	rime.pvp.add_aff(aff, target)
	if target ~= rime.target or not rime.pvp.has_aff("mutagen", target) then return end
	if archivist.flared then
		archivist.flared = false
		return end
	local time = getEpoch()
	local size = table.size(rime.pvp.route.mutagen.effects)
	local mutagen_inverse = {}
	local mutagen_index = 0
	local index = 0
	for k,v in pairs(rime.pvp.route.mutagen.effects) do
		mutagen_inverse[v] = k
	 end
	mutagen_index = mutagen_inverse[aff]
	archivist.mutagen[aff] = getEpoch() + 3*9.2 
	for i=1,2 do
		local timer_aff
		index = (i + mutagen_index)
		if index > size then index = (index % size) end
		timer_aff = rime.pvp.route.mutagen.effects[index]
		archivist.mutagen[timer_aff] = getEpoch() + i * 9.2 
		rime.echo(timer_aff .. ": "..string.format("%.2f", archivist.mutagen[timer_aff] - getEpoch()), "pvp")
	end
	rime.echo(aff .. ": "..string.format("%.2f", archivist.mutagen[aff] - getEpoch()), "pvp")
	if archivist.timers.mutagen and time - archivist.timers.mutagen < 15 then
		echo(string.format(" %.2f", time - archivist.timers.mutagen)) end
	archivist.timers.mutagen = time
end

function archivist.getShape(aff)
	for k, _ in pairs(archivist.shapes) do
		if archivist.shapes[k][aff] then return k end
	end
	return "circle"
end

function archivist.growthHit(target)
	target = string.title(target)
	rime.pvp.add_aff("prone", target)
	if target ~= rime.target then return end
	archivist.wait_growth = false
	rime.echo(string.format("BIO GROWTH HIT! %.2f", getEpoch() - archivist.timers.growth), "pvp")
	for _, v in pairs(rime.pvp.route.mutagen.effects) do
		rime.pvp.add_aff(v, target)
	end
end

--returns next affliction and time to next affliction
function archivist.mutagenNextAff()
	local currentTime = getEpoch()
	local small = 100
	local nextMutAff = ""
	for k, v in pairs(archivist.mutagen) do
		local diff = v - currentTime
		if diff < small and diff > 0 then 
			small = diff
			nextMutAff = k
		end
	end
	return nextMutAff, diff
end

function archivist.usedBal(cost)
	archivist.next_bal = getEpoch() + cost
end

function archivist.speedup()
	if archivist.next_bal - getEpoch() > 1 then
		if not rime.balances.equilibrium then
			act("bio stimulant")
		elseif not rime.balances.balance then
			act("bio steroid")
		end
	end
end

function archivist.toggle_ethereal()
	if archivist.toggles.ethereal then 
		archivist.toggles.ethereal = false
		rime.echo("Toggling off Ethereal!", "pvp")
	else
		archivist.toggles.ethereal = true
		rime.echo("Toggling on Ethereal!", "pvp")
	end
end

function archivist.toggle_knit()
	if archivist.toggles.knitting then 
		archivist.toggles.knitting = false
		rime.echo("Toggling off Knitting!", "pvp")
	else
		archivist.toggles.knitting = true
		rime.echo("Toggling on Knitting!", "pvp")
	end
end

function archivist.toggle_rec()
	if archivist.toggles.recollection then 
		archivist.toggles.recollection = false
		rime.echo("Toggling off Recollection!", "pvp")
	else
		archivist.toggles.recollection = true
		rime.echo("Toggling on Recollection!", "pvp")
	end
end

function archivist.toggleWaitGrowth()
	if archivist.wait_growth then
		archivist.wait_growth = false
		rime.echo("No longer prioritizing growth!","pvp")
	else
		archivist.wait_growth = true
		rime.echo("Prioritizing growth until it hits! Toggle if you change your mind!","pvp")
	end
end

function archivist.offense()
	killTimer(archivist.offense_timer)
	if rime.pvp.ai then
		archivist.offense_timer = tempTimer(0.5, rime.pvp.offense)
	end

	archivist.handle_afterimages()

	if archivist.attacks.unravel.can() then
		archivist.speedup()
	end
	if table.size(table.intersection({["sealing_triangle"] = true, ["sealing_square"] = true, ["sealing_circle"] = true}, 
			rime.targets[rime.target].afflictions)) > 1 and rime.targets[rime.target].geoCrescent then
				-- we've got at least one circle sealed and crescent is active, so GO HARD.
				archivist.speedup()
	end
	if rime.has_aff("left_arm_broken") and rime.has_aff("right_arm_broken") then
		return ""
	elseif rime.has_aff("prone") then
		--we can empower ef'tig changeheart ally pacifism while prone and we absoluitely should
		local command = rime.pvp.queue_handle() .. sep .. archivist.attacks["changeheart_ally_prone"].choice()
		command = command:gsub("target", rime.target)
		if archivist.debug then
			archivist.debugString = archivist.debugString .. "offense(): using changeheart_ally_prone to stall"
			rime.echo(archivist.debugString)
			archivist.debugString = ""
		end
		act(command)
		return ""
	elseif getEpoch() < archivist.wait_until then
		return ""
	end
	archivist.want_conjoin = false
	archivist.bio = tonumber(gmcp.Char.Vitals.bio)
	local attack, aff = archivist.get_attacks()
	if not attack then return end
	local sep = rime.saved.separator
	local queue_handle = rime.pvp.queue_handle()
	local web_call = ""
	local command = ""
	local pre_attack = archivist.get_pre_attack(aff) or ""
	if archivist.debug then
		archivist.debugString = archivist.debugString .. "offense(): "..attack.." "
		rime.echo(archivist.debugString)
		archivist.debugString = ""
		--display(aff)
	end
	if rime.pvp.web_aff_calling then
		command = queue_handle .. sep .. web_call .. sep .. pre_attack .. sep .. attack
	else
		command = queue_handle .. sep .. pre_attack .. sep .. attack
	end

	command = command:gsub("target", rime.target)
	if not (rime.pvp.has_aff("prone") or rime.pvp.has_aff("writhe_grappled")) then
		act(command)
	end
end
