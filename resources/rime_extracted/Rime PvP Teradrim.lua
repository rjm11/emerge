--Authors: Bulrok, Almol
tera = tera or {}

rime.teradrim = rime.teradrim or {}
rime.teradrim.fracture = rime.teradrim.fracture or false
rime.teradrim.is_momentum = rime.teradrim.is_momentum or false
rime.teradrim.can_momentum = rime.teradrim.can_momentum or true
rime.teradrim.can_trap = rime.teradrim.can_trap or true
rime.teradrim.can_earthenwill = rime.teradrim.can_earthenwill or true
rime.status.class = rime.status.class or rime.status.class
rime.rampage_target = rime.rampage_target or ''
rime.pvp.Teradrim.routes = {

	["group"] = {
		["blurb"] = {"sand curse and breaks"},
		["affs"] = {
			"hammer",
			"shielded",
			-- "anorexia",
			"stonevice",
			"shockwave",
			"writhe_impaled",
			-- "keep_prone",
			"heartflutter",
			"indifference",
			"shockwave",
			"prone",
			"collapsed_lung",
			"limbPicker",
			"damage_limb",
			"limbPrepper",
			"torso_bruised",
			"head_bruised",
			"head_broken",
			"right_leg_crippled",
			"left_leg_crippled",
			"torso_bruised_moderate",
			"collapsed_lung",
			"right_leg_mangled",
			"left_leg_mangled",
			"left_arm_crippled",
			"right_arm_crippled",
			"torso_bruised",
			"head_bruised",
			"barrage",
		},
		["sand"] = {
			"double_slice",
			"shielded",
			"rebounding",
			--"curse_rampage",
			"slough",
			"quicksand",
			"left_leg_crippled",
			"right_leg_crippled",
			"right_leg_broken",
			"left_leg_broken",
			"torso_broken",
			"head_broken",
			"left_arm_crippled",
			"right_arm_crippled",
			"left_arm_mangled",
			"right_leg_mangled",
			"right_arm_mangled",
			"left_leg_mangled",
		},
		["golem"] = {
			"wrack", 
			"grapple",
			"shout",
			"choke",
			"heartpunch",
			"rip",
			"wrench",
		}
	},
	["black"] = {
		["blurb"] = {"head first"},
		["affs"] = {
			"hammer",
			-- "quake",
			"shielded",
			-- "stonevice",
			-- "writhe_impaled",
			"raise_bruise",
			"prone_break",
			"collapsed_lung",
			"indifference",
			"limbPicker",
			"prone",
			"head_bruised_moderate",
			"damage_limb",
			"shockwave",
			"limbPrepper",
			"head_broken",
			"right_arm_mangled",
			"left_arm_mangled",
			"head_bruised",
			"limbPicker",
			"right_arm_crippled",
			"left_arm_crippled",
			"torso_bruised",
			"barrage",
			"right_leg_mangled",
			"left_leg_mangled",
			"torso_mangled",
			"torso_bruised_moderate",
			"left_arm_bruised_moderate",
			"right_arm_bruised_moderate",
			"right_leg_bruised_moderate",
			"left_leg_bruised_moderate",
			"limbPrepper",
		},
		["sand"] = {
			"double_slice",
			"shielded",
			"rebounding",
			"slough",
			"quicksand",
			"head_broken",
			"right_arm_broken",
			"left_leg_crippled",
			"right_leg_crippled",
			"torso_broken",
			"left_leg_broken",
			"left_arm_crippled",
			"right_arm_crippled",
			"left_arm_broken",
			"right_arm_broken",
			"torso_mangled",
			"head_broken",			
			"left_leg_mangled",
			"right_leg_mangled",
		},
		["golem"] = {
			"shout",
			"choke",
			"wrack",
			"shout",
			"heartpunch",
			"rip",
			"wrench",
		}
	},
}

lastLimbHit = "none"
prerestoredLimb = "none"

rime.teradrim.attacks = {
	["anorexia"] = {
		Teradrim = "quickwield right shortsword" .. rime.saved.separator .. "jab target slike",
		Tidesage = "quickwield right shortsword" .. rime.saved.separator .. "jab target slike",
		can = function()
			local target = rime.target
			-- local sand_attack = rime.teradrim.get_sand(rime.teradrim.get_flail)
			local focusbal = rime.getTimeLeft("focus", target)
			if rime.pvp.has_aff("slough", target) and focusbal >= 2 and not rime.pvp.has_aff("anorexia", target) then
				return true
			else
				return false
			end
		end,
		choice = function()
			local class = rime.status.class
			return rime.teradrim.attacks.anorexia[class]
		end,
	},

	["shockwave"] = {
		Teradrim = "earth shockwave target",
		Tidesage = "tide capsize target",
		can = function()
			local target = rime.target
			local breaks = {"left_arm_crippled", "right_arm_crippled", "left_leg_crippled", "right_leg_crippled"}
			local break_count = 0
			for k,v in ipairs(breaks) do
				if rime.pvp.has_aff(v, target) then
					break_count = break_count+1
				end
			end
			local bruises = {"left_arm_bruised", "right_arm_bruised", "left_leg_bruised", "right_leg_bruised"}
			local bruise_count = 0
			for k,v in ipairs(bruises) do
				if rime.pvp.has_aff(v, target) then
					bruise_count = bruise_count+1
				end
			end
			if break_count < 3 then
				-- if bruise_count > 1 then
					if rime.pvp.has_aff("quicksand", target) and not rime.pvp.has_aff("prone", target) then
						return true
					else
						return false
					end
				-- end
			else
				return false
			end
		end,
		choice = function()
			local class = rime.status.class
			return rime.teradrim.attacks.shockwave[class]
		end,
	},
	["cap_bruise"] = {
		Teradrim = "earth fracture target limb",
		Tidesage = "tide buckle target limb",
		can = function()
			local target_limbs = table.copy(rime.targets[rime.target].limbs)
            local sort_limbs = sortedKeys(target_limbs)
			local sorted_limbs = {}
			local bruised = {}
            local mode = rime.pvp.prediction_mode
            local last_parried = rime.targets[rime.target].parry
			local target = rime.target
			local class = rime.status.class
  
            for _, key in ipairs(sort_limbs) do
                table.insert(sorted_limbs, key)
            end
            for k, v in ipairs(rime.targets[target].limbs) do
                if rime.limit[rime.target.."_"..v .. "_restore"] then
                    table.remove(sorted_limbs, table.index_of(sorted_limbs, v))
                end
            end
  
            table.remove(sorted_limbs, table.index_of(sorted_limbs, "head"))
            table.remove(sorted_limbs, table.index_of(sorted_limbs, "torso"))
  
            if rime.pvp.canParry() and table.contains(sorted_limbs, last_parried) then
                table.remove(sorted_limbs, table.index_of(sorted_limbs, last_parried))
            end
            if lastLimbHit ~= "none" then
                table.remove(sorted_limbs, table.index_of(sorted_limbs, lastLimbHit:gsub(" ", "_")))
            end
            if prerestoredLimb ~= "none" then
                table.remove(sorted_limbs, table.index_of(sorted_limbs, prerestoredLimb:gsub(" ", "_")))
			end

			for k, v in ipairs(sorted_limbs) do
				if rime.pvp.has_aff(v.."_bruised", target) then
					table.insert(bruised, v)
				elseif rime.pvp.has_aff(v.."_bruised_moderate", target) then
					table.insert(bruised, v)
				end
			end

			if rime.teradrim.can_flail() and #bruised >= 1 and not rime.pvp.has_aff(bruised[1].."_mangled", target) then
				rime.teradrim.attacks.cap_bruise[1] = "earth fracture target "..bruised[1]:gsub("_", " ")
				return true
			else
				return false
            end
		end,
		choice = function()
			--rime.echo("cap_bruise firing")
			return rime.teradrim.attacks.cap_bruise[1]
		end,
	},
	["prone_break"] = {
		"earth fracture target limb",
		can = function()
			if rime.pvp.has_aff("left_leg_crippled", rime.target) and rime.pvp.has_aff("left_leg_broken", rime.target) and not rime.pvp.has_aff("right_leg_crippled", rime.target) then
				if not rime.pvp.parry_pred("right_leg") and lastLimbHit ~= "right leg" and rime.teradrim.bruise_check("right_leg") then
					rime.teradrim.attacks.prone_break[1] = "earth fracture target right leg"
					return true
				elseif rime.targets[rime.target].limbs.right_leg >= 1529 then
					rime.teradrim.attacks.prone_break[1] = "earth batter target right leg"
					return true
				else
					return false
				end
			elseif rime.pvp.has_aff("right_leg_crippled", rime.target) and rime.pvp.has_aff("right_leg_broken", rime.target) and not rime.pvp.has_aff("left_leg_crippled", rime.target) then
				if not rime.pvp.parry_pred("left_leg") and lastLimbHit ~= "left leg" and rime.teradrim.bruise_check("left_leg") then
					rime.teradrim.attacks.prone_break[1] = "earth fracture target left leg"
					return true
				elseif rime.targets[rime.target].limbs.left_leg >= 1529 then
					rime.teradrim.attacks.prone_break[1] = "earth batter target left leg"
					return true
				else
					return false
				end
			else
				return false
			end
		end,
		choice = function()
			return rime.teradrim.attacks.prone_break[1]
		end,
	},
	["keep_prone"] = {
		"earth fracture target limb",
		choice = function()
			return rime.teradrim.attacks.keep_prone[1]
		end,
		can = function()
			if rime.pvp.has_aff("prone", rime.target) then
				if rime.pvp.has_aff("right_leg_crippled", rime.target) and not rime.pvp.has_aff("right_leg_broken", rime.target) and not rime.pvp.has_aff("right_leg_bruised_moderate", rime.target) then
					if not rime.pvp.parry_pred("right_leg") and lastLimbHit ~= "right leg" then
						rime.teradrim.attacks.keep_prone[1] = "earth slam target right leg"
						return true
					elseif rime.targets[rime.target].limbs.right_leg >= 1529 then
						rime.teradrim.attacks.keep_prone[1] = "earth batter target right leg"
						return true
					else
						return false
					end
				elseif rime.pvp.has_aff("left_leg_crippled", rime.target) and not rime.pvp.has_aff("left_leg_broken", rime.target) and not rime.pvp.has_aff("left_leg_bruised_moderate", rime.target) then
					if not rime.pvp.parry_pred("left_leg") and lastLimbHit ~= "left leg" then
						rime.teradrim.attacks.keep_prone[1] = "earth slam target left leg"
						return true
					elseif rime.targets[rime.target].limbs.left_leg >= 1529 then
						rime.teradrim.attacks.keep_prone[1] = "earth batter target left leg"
						return true
					else
						return false
					end
				elseif not rime.pvp.has_aff("left_leg_crippled", rime.target) and not rime.pvp.has_aff("right_leg_crippled", rime.target) then
					if not rime.pvp.parry_pred("right_leg") and lastLimbHit ~= "right leg" and rime.teradrim.bruise_check("right_leg") and not rime.pvp.has_aff("right_leg_broken", rime.target) then
						rime.teradrim.attacks.keep_prone[1] = "earth fracture target right leg"
						return true
					elseif not rime.pvp.parry_pred("left_leg") and lastLimbHit ~= "left leg" and rime.teradrim.bruise_check("left_leg") and not rime.pvp.has_aff("left_leg_broken", rime.target) then
						rime.teradrim.attacks.keep_prone[1] = "earth fracture target left leg"
						return true
					elseif rime.targets[rime.target].limbs.right_leg >= 1529 and not rime.pvp.parry_pred("right_leg") then
						rime.teradrim.attacks.keep_prone[1] = "earth batter target right leg"
						return true
					elseif rime.targets[rime.target].limbs.left_leg >= 1529 and not rime.pvp.parry_pred("left_leg") then
						rime.teradrim.attacks.keep_prone[1] = "earth batter target left leg"
						return true
					else
						return false
					end
				else
					return false
				end
			else
				return false
			end
		end,
	},
	["prone"] = {
		"earth overhand target",
		choice = function()
			return rime.teradrim.attacks.prone[1]
		end,
		can = function()
			local tar = rime.target
			if (rime.pvp.has_aff('left_leg_broken', tar) or rime.pvp.has_aff('left_leg_mangled', tar)) and not rime.limit[rime.target.."_left_leg_restore"] and not rime.pvp.has_aff("prone", rime.target) then
				return true
			elseif (rime.pvp.has_aff('right_leg_mangled', tar) and rime.pvp.has_aff('right_leg_broken', tar)) and not rime.limit[rime.target.."_right_leg_restore"] and not rime.pvp.has_aff("prone", rime.target) then
				return true
			else
				return false
			end
		end,
	},
	["whiplash"] = {
		"earth skullbash target",
		choice = function()
			return rime.teradrim.attacks.whiplash[1]
		end,
		can = function()
			local tar = rime.target
			--and not rime.pvp.has_def("shielded", tar)
			if not rime.pvp.has_aff("head_mangled", tar) and rime.teradrim.can_flail() and lastLimbHit ~= "head" and rime.pvp.has_aff("head_bruised", tar) and not rime.pvp.parry_pred("head") and rime.pvp.has_aff("prone", tar) and not rime.limit[rime.target.."_head_restore"] then
				return true
			elseif not rime.pvp.has_aff("head_mangled", tar) and rime.pvp.has_aff("writhe_grappled", tar) and rime.pvp.has_aff("head_bruised", tar) and not rime.pvp.has_aff("whiplash", tar) and not rime.pvp.has_aff("head_mangled", tar) then
				return true
			else
				return false
			end
		end
	},
	["smashed_throat"] = {
		"earth skullbash target",
		choice = function()
			return rime.teradrim.attacks.smashed_throat[1]
		end,
		can = function()
			local tar = rime.target
			--and not rime.pvp.has_def("shielded", tar)
			if not rime.pvp.has_aff("head_mangled", tar) and rime.teradrim.can_flail() and lastLimbHit ~= "head" and rime.pvp.has_aff("prone", tar) and  rime.pvp.has_aff("head_bruised_critical", tar) and not rime.pvp.parry_pred("head") and not rime.limit[rime.target.."_head_restore"] then
				return true
			elseif not rime.pvp.has_aff("head_mangled", tar) and rime.pvp.has_aff("writhe_grappled", tar) and  rime.pvp.has_aff("head_bruised_critical", tar) and not rime.pvp.has_aff("smashed_throat", tar) and not rime.pvp.has_aff("head_mangled", tar) then
				return true
			else
				return false
			end
		end
	},
	["torso_mangled"] = {
		"earth batter target torso",
		choice = function()
			return rime.teradrim.attacks.torso_mangled[1]
		end,
		can = function()
			local tar = rime.target
			--and not rime.pvp.has_def("shielded", tar) 
			if rime.teradrim.can_flail() and lastLimbHit ~= "torso" and not rime.limit[rime.target.."_torso_restore"] and not rime.pvp.parry_pred("torso") and not rime.pvp.has_aff("torso_mangled", tar) then
				return true
			elseif rime.pvp.has_aff("writhe_grappled", tar) and not rime.pvp.has_aff("torso_mangled", tar) and not rime.limit[rime.target.."_torso_restore"] then
				return true
			else
				return false
			end
		end,
	},
	["head_mangled"] = {
		"earth batter target head",
		choice = function()
			return rime.teradrim.attacks.head_mangled[1]
		end,
		can = function()
			local tar = rime.target
			--and not rime.pvp.has_def("shielded", tar) 
			if rime.teradrim.can_flail() and lastLimbHit ~= "head" and not rime.limit[rime.target.."_head_restore"] and not rime.pvp.parry_pred("head") and not rime.pvp.has_aff("head_mangled", tar)  then
				return true
			elseif rime.pvp.has_aff("writhe_grappled", tar) and not rime.pvp.has_aff("head_mangled", tar) and not rime.limit[rime.target.."_head_restore"] then
				return true
			else
				return false
			end
		end,
	},
	["head_broken"] = {
		"earth batter target head",
		choice = function()
			return rime.teradrim.attacks.head_mangled[1]
		end,
		can = function()
			local tar = rime.target
			--and not rime.pvp.has_def("shielded", tar) 
			if rime.teradrim.can_flail() and lastLimbHit ~= "head" and not rime.limit[rime.target.."_head_restore"] and not rime.pvp.parry_pred("head") and not rime.pvp.has_aff("head_broken", tar)  then
				return true
			elseif rime.pvp.has_aff("writhe_grappled", tar) and not rime.pvp.has_aff("head_broken", tar) and not rime.limit[rime.target.."_head_restore"] then
				return true
			elseif not rime.pvp.canParry() and not (rime.pvp.has_aff("head_broken", rime.target) or rime.pvp.has_aff("head_mangled", rime.target)) then
				return true
			else
				return false
			end
		end,
	},
	["skullbash"] = {
		"earth skullbash target",
		choice = function()
			return rime.teradrim.attacks.skullbash[1]
		end,
		can = function()
			local tar = rime.target
			local head_bruises = {"head_bruised, head_bruised_moderate, head_bruised_critical"}
			local bruise_count = 0
			for k,v in ipairs(head_bruises) do
				if rime.pvp.has_aff(v, tar) then
					bruise_count = bruise_count+1
				end
			end
			local breaks = {"left_arm_crippled", "right_arm_crippled", "left_leg_crippled", "right_leg_crippled"}
			local break_count = 0
			for k,v in ipairs(breaks) do
				if rime.pvp.has_aff(v, tar) then
					break_count = break_count+1
				end
			end
			--and not rime.pvp.has_def("shielded", tar)
			if rime.teradrim.can_flail() and lastLimbHit ~= "head" and bruise_count >= 1 and not rime.pvp.parry_pred("head") and not rime.limit[rime.target.."_head_restore"] and not rime.pvp.has_aff("stupidity", tar) then
				return true
			else
				return false
			end
		end
	},
	["levitation"] = {
		"earth overhand target",
		choice = function()
			return rime.teradrim.attacks.levitation[1]
		end,
		can = function()
			local tar = rime.target
			-- and not rime.pvp.has_def("shielded", tar)
			if rime.pvp.has_def("rebounding", tar) and not rime.pvp.has_aff("prone", tar) then
				if rime.pvp.has_aff("left_leg_crippled", tar) and rime.pvp.has_aff("left_leg_broken", tar) and not rime.pvp.has_aff("prone", tar) then
					return true
				elseif rime.pvp.has_aff("right_leg_crippled", tar) and rime.pvp.has_aff("right_leg_broken", tar) and not rime.pvp.has_aff("prone", tar) then
					return true
				else
					return false
				end
			else
				return false
			end
		end
	},
	["quake"] = {
		"earth quake",
		choice = function()
			return rime.teradrim.attacks.quake[1]
		end,
		can = function()
			local target_limbs = table.copy(rime.targets[rime.target].limbs)
            local sort_limbs = sortedKeys(target_limbs)
			local sorted_limbs = {}
			local limbDamage = 0
            local mode = rime.pvp.prediction_mode
            local last_parried = rime.targets[rime.target].parry
			local tar = rime.target
  
            for _, key in ipairs(sort_limbs) do
                table.insert(sorted_limbs, key)
            end
			
			for k, v in ipairs(sorted_limbs) do
				limbDamage = limbDamage + rime.targets[rime.target].limbs[v]
			end

			--  and not rime.pvp.has_def("shielded", tar)
			if limbDamage >= 26000 and rime.pvp.has_aff("prone", tar) and rime.pvp.has_aff("right_leg_broken", tar) and rime.pvp.has_aff("left_leg_broken", tar) then
				return true
			elseif limbDamage >= 26000 and rime.pvp.has_aff("prone", tar) and rime.pvp.target_tumbling and rime.pvp.has_aff("right_leg_broken", tar) and rime.pvp.has_aff("left_leg_broken", tar) then
				return true
			else
				return false
			end
		end
	},
	["raise_bruise"] = {
		"earth slam target limb",
		choice = function()
			return rime.teradrim.attacks.raise_bruise[1]
		end,
		can = function()
			local tar = rime.target
			local bruises = {"left_arm_bruised", "right_arm_bruised", "left_leg_bruised", "right_leg_bruised", "torso_bruised", "head_bruised"}
			local med_bruises = {"left_arm_bruised_moderate", "right_arm_bruised_moderate", "left_leg_bruised_moderate", "right_leg_bruised_moderate", "torso_bruised_moderate", "head_bruised_moderate"}
			local bruise_count = 0
			local medium_bruise_count = 0

			for k,v in ipairs(med_bruises) do
				if rime.pvp.has_aff(v, tar) then
					medium_bruise_count = medium_bruise_count+1
				end
			end

			if medium_bruise_count > 1 then
				if rime.pvp.has_aff("head_bruised", tar) and rime.targets[rime.target].parry ~= "head" and not rime.pvp.has_aff("head_bruised_moderate", tar) then
					rime.teradrim.attacks.raise_bruise[1] = "earth facesmash target"
					return true
				elseif rime.pvp.has_aff("torso_bruised", tar) and rime.targets[rime.target].parry ~= "torso" and not rime.pvp.has_aff("torso_bruised_moderate", tar) then
					rime.teradrim.attacks.raise_bruise[1] = "earth gutsmash target"
					return true
				elseif rime.pvp.has_aff("left_arm_bruised", tar) and rime.targets[rime.target].parry ~= "left arm" and not rime.pvp.has_aff("left_arm_bruised_moderate", tar) then
					rime.teradrim.attacks.raise_bruise[1] = "earth slam target left arm"
					return true
				elseif rime.pvp.has_aff("right_arm_bruised", tar) and rime.targets[rime.target].parry ~= "right arm" and not rime.pvp.has_aff("right_arm_bruised_moderate", tar) then
					rime.teradrim.attacks.raise_bruise[1] = "earth slam target right arm"
					return true
				elseif rime.pvp.has_aff("right_leg_bruised", tar) and rime.targets[rime.target].parry ~= "right leg" and not rime.pvp.has_aff("right_leg_bruised_moderate", tar) then
					rime.teradrim.attacks.raise_bruise[1] = "earth slam target right leg"
					return true
				elseif rime.pvp.has_aff("left_leg_bruised", tar) and rime.targets[rime.target].parry ~= "left leg" and not rime.pvp.has_aff("left_leg_bruised_moderate", tar) then
					rime.teradrim.attacks.raise_bruise[1] = "earth slam target left leg"
					return true
				else
					return false
				end
			else
				return false
			end
		end
	},
	["barrage"] = {
		"earth barrage target",
		choice = function()
			return rime.teradrim.attacks.barrage[1]
		end,
		can = function()
			local target_limbs = table.copy(rime.targets[rime.target].limbs)
            local sort_limbs = sortedKeys(target_limbs)
			local sorted_limbs = {}
			local prepping = {}
			local breaking = {}
            local mode = rime.pvp.prediction_mode
            local last_parried = rime.targets[rime.target].parry
			local tar = rime.target
			local bruises = {"left_arm_bruised", "right_arm_bruised", "left_leg_bruised", "right_leg_bruised", "torso_bruised", "head_bruised"}
			local med_bruises = {"left_arm_bruised_moderate", "right_arm_bruised_moderate", "left_leg_bruised_moderate", "right_leg_bruised_moderate", "torso_bruised_moderate", "head_bruised_moderate"}
			local bruise_count = 0
			local medium_bruise_count = 0
  
            for _, key in ipairs(sort_limbs) do
                table.insert(sorted_limbs, key)
            end
            for k, v in ipairs(rime.targets[rime.target].limbs) do
                if rime.limit[rime.target.."_"..v .. "_restore"] then
                    table.remove(sorted_limbs, table.index_of(sorted_limbs, v))
                end
            end
  
            table.remove(sorted_limbs, table.index_of(sorted_limbs, "head"))
            table.remove(sorted_limbs, table.index_of(sorted_limbs, "torso"))
  
            if rime.pvp.canParry() and table.contains(sorted_limbs, last_parried) then
                table.remove(sorted_limbs, table.index_of(sorted_limbs, last_parried))
            end
            if lastLimbHit ~= "none" then
                table.remove(sorted_limbs, table.index_of(sorted_limbs, lastLimbHit:gsub(" ", "_")))
            end
            if prerestoredLimb ~= "none" then
                table.remove(sorted_limbs, table.index_of(sorted_limbs, prerestoredLimb:gsub(" ", "_")))
			end

			
			for k, v in ipairs(sorted_limbs) do
				if rime.targets[rime.target].limbs[v] < 1540 then
					table.insert(prepping, v)
				elseif rime.targets[rime.target].limbs[v] >= 2933 and rime.targets[rime.target].limbs[v] < 3333 then
					table.insert(breaking, v)
				elseif rime.targets[rime.target].limbs[v] >= 6266 and rime.targets[rime.target].limbs[v] < 6666 then
					table.insert(breaking, v)
				end
			end
			
			for k,v in ipairs(bruises) do
				if rime.pvp.has_aff(v, tar) then
					bruise_count = bruise_count+1
				end
			end

			for k,v in ipairs(med_bruises) do
				if rime.pvp.has_aff(v, tar) then
					medium_bruise_count = medium_bruise_count+1
				end
			end

			local breaks = {"left_arm_crippled", "right_arm_crippled", "left_leg_crippled", "right_leg_crippled"}
			local break_count = 0
			for k,v in ipairs(breaks) do
				if rime.pvp.has_aff(v, tar) then
					break_count = break_count+1
				end
			end
			--and not rime.pvp.has_def("shielded", tar) 
			if rime.teradrim.can_flail() and rime.vitals.sandstorm <= 5 and bruise_count < 1 and medium_bruise_count < 3 and rime.pvp.has_aff("prone", rime.target) then
				return true
			elseif rime.teradrim.can_flail() and #breaking >= 2 and rime.pvp.has_aff("prone", rime.target) then
				return true
			elseif rime.teradrim.can_flail() and medium_bruise_count < 2 and rime.pvp.has_aff("prone", rime.target) and (rime.pvp.has_aff("left_leg_broken", rime.target) or rime.pvp.has_aff("right_leg_broken", rime.target)) then
				return true
			elseif rime.teradrim.can_flail() and rime.vitals.sandstorm < 3 and bruise_count < 1 then
				return true
			else
				return false
			end
		end
	},

	["hammer"] = {
		"earth hammer target",
		choice = function()
			return rime.teradrim.attacks.hammer[1]
		end,
		can = function()
			local bruises = {"left_arm_bruised_moderate", "right_arm_bruised_moderate", "left_leg_bruised_moderate", "right_leg_bruised_moderate", "torso_bruised_moderate", "head_bruised_moderate"}
			local tar = rime.target
			local bruise_count = 0
			for k,v in ipairs(bruises) do
				if rime.pvp.has_aff(v, tar) then
					bruise_count = bruise_count+1
				end
			end

			if bruise_count >= 3 then
				return true
			else
				return false
			end
		end
	},
	["shielded"] = {
		"touch hammer target",
		choice = function()
			return rime.teradrim.attacks.shielded[1]
		end,
		can = function()
			local tar = rime.target
			if rime.pvp.has_def("shielded", tar) and rime.vitals.sandstorm <= 3 then
				return true
			else
				return false
			end
		end,
	},
	["left_leg_bruised"] = {
		"earth slam target left leg",
		choice = function()
			return rime.teradrim.attacks.left_leg_bruised[1]
		end,
		can = function()
			local tar = rime.target
			--and not rime.pvp.has_def("shielded", tar) 
			if rime.teradrim.can_flail() and lastLimbHit ~= "left leg" and not rime.limit[rime.target.."_left_leg_restore"] and not rime.pvp.parry_pred("left_leg") then
				return true
			else
				return false
			end
		end,
	},
	["right_leg_bruised"] = {
		"earth slam target right leg",
		choice = function()
			return rime.teradrim.attacks.right_leg_bruised[1]
		end,
		can = function()
			local tar = rime.target
			--and not rime.pvp.has_def("shielded", tar) 
			if rime.teradrim.can_flail() and lastLimbHit ~= "right leg" and not rime.limit[rime.target.."_right_leg_restore"] and not rime.pvp.parry_pred("right_leg") then
				return true
			else
				return false
			end
		end,
	},
	["left_arm_bruised"] = {
		"earth slam target left arm",
		choice = function()
			return rime.teradrim.attacks.left_arm_bruised[1]
		end,
		can = function()
			local tar = rime.target
			--and not rime.pvp.has_def("shielded", tar) 
			if rime.teradrim.can_flail() and lastLimbHit ~= "left arm" and not rime.limit[rime.target.."_left_arm_restore"] and not rime.pvp.parry_pred("left_arm") then
				return true
			else
				return false
			end
		end,
	},
	["right_arm_bruised"] = {
		"earth slam target right arm",
		choice = function()
			return rime.teradrim.attacks.right_arm_bruised[1]
		end,
		can = function()
			local tar = rime.target
			--and not rime.pvp.has_def("shielded", tar) 
			if rime.teradrim.can_flail() and lastLimbHit ~= "right arm" and not rime.limit[rime.target.."_right_arm_restore"] and not rime.pvp.parry_pred("right_arm") then
				return true
			else
				return false
			end
		end,
	},
	["left_leg_bruised_moderate"] = {
		"earth slam target left leg",
		choice = function()
			return rime.teradrim.attacks.left_leg_bruised_moderate[1]
		end,
		can = function()
			local tar = rime.target
			--and not rime.pvp.has_def("shielded", tar) 
			if rime.teradrim.can_flail() and lastLimbHit ~= "left leg" and rime.pvp.has_aff("left_leg_bruised", tar) and not rime.limit[rime.target.."_left_leg_restore"] and not rime.pvp.parry_pred("left_leg") then
				return true
			else
				return false
			end
		end,
	},
	["right_leg_bruised_moderate"] = {
		"earth slam target right leg",
		choice = function()
			return rime.teradrim.attacks.right_leg_bruised_moderate[1]
		end,
		can = function()
			local tar = rime.target
			-- and not rime.pvp.has_def("shielded", tar) 
			if rime.teradrim.can_flail() and lastLimbHit ~= "right leg" and rime.pvp.has_aff("right_leg_bruised", tar) and not rime.limit[rime.target.."_right_leg_restore"] and not rime.pvp.parry_pred("right_leg") then
				return true
			else
				return false
			end
		end,
	},
	["left_arm_bruised_moderate"] = {
		"earth slam target left arm",
		choice = function()
			return rime.teradrim.attacks.left_arm_bruised_moderate[1]
		end,
		can = function()
			local tar = rime.target
			--and not rime.pvp.has_def("shielded", tar) 
			if rime.teradrim.can_flail() and lastLimbHit ~= "left arm" and rime.pvp.has_aff("left_arm_bruised", tar) and not rime.limit[rime.target.."_left_arm_restore"] and not rime.pvp.parry_pred("left_arm") then
				return true
			else
				return false
			end
		end,
	},
	["right_arm_bruised_moderate"] = {
		"earth slam target right arm",
		choice = function()
			return rime.teradrim.attacks.right_arm_bruised_moderate[1]
		end,
		can = function()
			local tar = rime.target
			--and not rime.pvp.has_def("shielded", tar)
			if rime.teradrim.can_flail() and lastLimbHit ~= "right arm" and rime.pvp.has_aff("right_arm_bruised", tar) and not rime.limit[rime.target.."_right_arm_restore"] and not rime.pvp.parry_pred("right_arm") then
				return true
			else
				return false
			end
		end,
	},
	["torso_bruised"] = {
		"earth gutsmash target",
		choice = function()
			return rime.teradrim.attacks.torso_bruised[1]
		end,
		can = function()
			local tar = rime.target
			--and not rime.pvp.has_def("shielded", tar) 
			if rime.teradrim.can_flail() and lastLimbHit ~= "torso" and not rime.pvp.parry_pred("torso") and not rime.limit[rime.target.."_torso_restore"] and not rime.pvp.has_aff("torso_bruised", rime.target) then
				return true
			elseif not rime.pvp.canParry() and not rime.pvp.has_aff("torso_bruised", rime.target) then
				return true
			else
				return false
			end
		end,
	},
	["torso_bruised_moderate"] = {
		"earth gutsmash target",
		choice = function()
			return rime.teradrim.attacks.torso_bruised_moderate[1]
		end,
		can = function()
			local tar = rime.target
			--and not rime.pvp.has_def("shielded", tar) 
			if rime.teradrim.can_flail() and lastLimbHit ~= "torso" and rime.pvp.has_aff("torso_bruised", tar) and rime.pvp.has_aff("prone", tar) and not rime.pvp.parry_pred("torso") and not rime.limit[rime.target.."_torso_restore"] then
				return true
			elseif not rime.pvp.canParry() and rime.pvp.has_aff("torso_bruised", tar) and not rime.pvp.has_aff("torso_bruised_moderate", rime.target) then
				return true
			else
				return false
			end
		end,
	},
	["head_bruised"] = {
		"earth facesmash target",
		choice = function()
			return rime.teradrim.attacks.head_bruised[1]
		end,
		can = function()
			local tar = rime.target
			--and not rime.pvp.has_def("shielded", tar)
			if rime.teradrim.can_flail() and lastLimbHit ~= "head" and rime.pvp.has_aff("prone", tar) and not rime.pvp.parry_pred("head") and not rime.limit[rime.target.."_head_restore"] then
				return true
			elseif not rime.pvp.canParry() and not rime.pvp.has_aff("head_bruised", rime.target) then
				return true
			else
				return false
			end
		end,
	},
	["head_bruised_moderate"] = {
		"earth facesmash target",
		choice = function()
			return rime.teradrim.attacks.head_bruised_moderate[1]
		end,
		can = function()
			local tar = rime.target
			if rime.teradrim.can_flail() and lastLimbHit ~= "head" and rime.pvp.has_aff("head_bruised", tar) and rime.pvp.has_aff("prone", tar) and not rime.pvp.parry_pred("head") and not rime.limit[rime.target.."_head_restore"] then
				return true
			elseif not rime.pvp.canParry() and rime.pvp.has_aff("head_bruised", tar) and not rime.pvp.has_aff("head_bruised_moderate", rime.target) then
				return true
			else
				return false
			end
		end,
	},
	["head_bruised_critical"] = {
		"earth facesmash target",
		choice = function()
			return rime.teradrim.attacks.head_bruised_critical[1]
		end,
		can = function()
			local tar = rime.target
			if rime.teradrim.can_flail() and lastLimbHit ~= "head" and rime.pvp.has_aff("prone", rime.target) and rime.pvp.has_aff("head_bruised_moderate", tar) and not rime.pvp.parry_pred("head") and not rime.pvp.has_def("rebounding", tar) and not rime.limit[rime.target.."_head_restore"] then
				return true
			else
				return false
			end
		end,
	},
	["left_leg_crippled"] = {
		"earth fracture target left leg",
		"earth furor target left leg ",
		choice = function()
			local target_limbs = table.copy(rime.targets[rime.target].limbs)
            local sort_limbs = sortedKeys(target_limbs)
			local sorted_limbs = {}
			local prepping = {}
			local breaking = {}
            local mode = rime.pvp.prediction_mode
            local last_parried = rime.targets[rime.target].parry
			local tar = rime.target
			local bruises = {"left_arm_bruised", "right_arm_bruised", "left_leg_bruised", "right_leg_bruised"}
			local bruise_count = 0
  
            for _, key in ipairs(sort_limbs) do
                table.insert(sorted_limbs, key)
            end
            for k, v in ipairs(rime.targets[rime.target].limbs) do
                if rime.limit[rime.target.."_"..v .. "_restore"] then
                    table.remove(sorted_limbs, table.index_of(sorted_limbs, v))
                end
            end
  
            table.remove(sorted_limbs, table.index_of(sorted_limbs, "head"))
            table.remove(sorted_limbs, table.index_of(sorted_limbs, "torso"))
            table.remove(sorted_limbs, table.index_of(sorted_limbs, "left_leg"))
  
            if rime.pvp.canParry() and table.contains(sorted_limbs, last_parried) then
                table.remove(sorted_limbs, table.index_of(sorted_limbs, last_parried))
            end
         
			
			for k, v in ipairs(sorted_limbs) do
				if rime.targets[rime.target].limbs[v] < 2150 then
					table.insert(prepping, v)
				elseif rime.targets[rime.target].limbs[v] >= 2309 and rime.targets[rime.target].limbs[v] < 3333 then
					table.insert(breaking, v)
				elseif rime.targets[rime.target].limbs[v] >= 5642 and rime.targets[rime.target].limbs[v] < 6666 then
					table.insert(breaking, v)
				end
			end
			

			if #breaking > 1 then
				return rime.teradrim.attacks.left_leg_crippled[2] .. breaking[1]:gsub("_", " ")
			elseif rime.teradrim.bruise_check("left_leg") then
				return rime.teradrim.attacks.left_leg_crippled[1]
			
			elseif rime.teradrim.bruise_check("left_leg") and not rime.pvp.has_aff("left_leg_mangled", rime.target) then
				return rime.teradrim.attacks.left_leg_crippled[1]
			end
		end,
		can = function()
			local tar = rime.target
			-- and not rime.pvp.has_def("shielded", tar) 
			if (rime.targets[rime.target].limbs["left_leg"] >= 2309 and rime.targets[rime.target].limbs["left_leg"] < 3333) or (rime.targets[rime.target].limbs["left_leg"] >= 5642 and rime.targets[rime.target].limbs["left_leg"] < 6666) then
				if rime.teradrim.can_flail() and rime.teradrim.bruise_check("left_leg") and lastLimbHit ~= "left leg" and not rime.pvp.parry_pred("left_leg") and not rime.limit[rime.target.."_left_leg_restore"] and not rime.pvp.has_aff("left_leg_mangled", rime.target) then
					return true
				elseif not rime.pvp.canParry() and not rime.pvp.has_aff("left_leg_mangled", rime.target) then
					return true
				else
					return false
				end
			else
				return false
			end
		end
	},
	["right_leg_crippled"] = {
		"earth fracture target right leg",
		"earth furor target right leg ",
		choice = function()
			local target_limbs = table.copy(rime.targets[rime.target].limbs)
            local sort_limbs = sortedKeys(target_limbs)
			local sorted_limbs = {}
			local prepping = {}
			local breaking = {}
            local mode = rime.pvp.prediction_mode
            local last_parried = rime.targets[rime.target].parry
			local tar = rime.target
			local bruises = {"left_arm_bruised", "right_arm_bruised", "left_leg_bruised", "right_leg_bruised"}
			local bruise_count = 0
  
            for _, key in ipairs(sort_limbs) do
                table.insert(sorted_limbs, key)
            end
            for k, v in ipairs(rime.targets[rime.target].limbs) do
                if rime.limit[rime.target.."_"..v .. "_restore"] then
                    table.remove(sorted_limbs, table.index_of(sorted_limbs, v))
                end
            end
  
            table.remove(sorted_limbs, table.index_of(sorted_limbs, "head"))
            table.remove(sorted_limbs, table.index_of(sorted_limbs, "torso"))
            table.remove(sorted_limbs, table.index_of(sorted_limbs, "right_leg"))
  
            if rime.pvp.canParry() and table.contains(sorted_limbs, last_parried) then
                table.remove(sorted_limbs, table.index_of(sorted_limbs, last_parried))
            end
           

			
			for k, v in ipairs(sorted_limbs) do
				if rime.targets[rime.target].limbs[v] < 2150 then
					table.insert(prepping, v)
				elseif rime.targets[rime.target].limbs[v] >= 2309 and rime.targets[rime.target].limbs[v] < 3333 then
					table.insert(breaking, v)
				elseif rime.targets[rime.target].limbs[v] >= 5642 and rime.targets[rime.target].limbs[v] < 6666 then
					table.insert(breaking, v)
				end
			end

	
		
			if #breaking > 1 then
				return rime.teradrim.attacks.right_leg_crippled[2] .. breaking[1]:gsub("_", " ")
			elseif rime.teradrim.bruise_check("right_leg") then
				return rime.teradrim.attacks.right_leg_crippled[1]
						
			elseif rime.teradrim.bruise_check("right_leg") and not rime.pvp.has_aff("right_leg_mangled", rime.target) then
				return rime.teradrim.attacks.right_leg_crippled[1]
			end
		end,
		can = function()
			local tar = rime.target
			-- and not rime.pvp.has_def("shielded", tar) 
			if (rime.targets[rime.target].limbs["right_leg"] >= 2309 and rime.targets[rime.target].limbs["right_leg"] < 3333) or (rime.targets[rime.target].limbs["right_leg"] >= 5642 and rime.targets[rime.target].limbs["right_leg"] < 6666) then
				if rime.teradrim.can_flail() and rime.teradrim.bruise_check("right_leg") and lastLimbHit ~= "right leg" and not rime.limit[rime.target.."_right_leg_restore"] and not rime.pvp.parry_pred("right_leg") then
					return true
				elseif not rime.pvp.canParry() and not rime.pvp.has_aff("right_leg_mangled", rime.target) then
					return true
				else
					return false
				end
			else
				return false
			end
		end,
	},
	["left_arm_crippled"] = {
		"earth fracture target left arm",
		"earth furor target left arm ",
		choice = function()
			local target_limbs = table.copy(rime.targets[rime.target].limbs)
            local sort_limbs = sortedKeys(target_limbs)
			local sorted_limbs = {}
			local prepping = {}
			local breaking = {}
            local mode = rime.pvp.prediction_mode
            local last_parried = rime.targets[rime.target].parry
			local tar = rime.target
			local bruises = {"left_arm_bruised", "right_arm_bruised", "left_leg_bruised", "right_leg_bruised"}
			local bruise_count = 0
  
            for _, key in ipairs(sort_limbs) do
                table.insert(sorted_limbs, key)
            end
            for k, v in ipairs(rime.targets[rime.target].limbs) do
                if rime.limit[rime.target.."_"..v .. "_restore"] then
                    table.remove(sorted_limbs, table.index_of(sorted_limbs, v))
                end
            end
  
            table.remove(sorted_limbs, table.index_of(sorted_limbs, "head"))
            table.remove(sorted_limbs, table.index_of(sorted_limbs, "torso"))
            table.remove(sorted_limbs, table.index_of(sorted_limbs, "left_arm"))
  
            if rime.pvp.canParry() and table.contains(sorted_limbs, last_parried) then
                table.remove(sorted_limbs, table.index_of(sorted_limbs, last_parried))
            end
           

			
			for k, v in ipairs(sorted_limbs) do
				if rime.targets[rime.target].limbs[v] < 2150 then
					table.insert(prepping, v)
				elseif rime.targets[rime.target].limbs[v] >= 2309 and rime.targets[rime.target].limbs[v] < 3333 then
					table.insert(breaking, v)
				elseif rime.targets[rime.target].limbs[v] >= 5642 and rime.targets[rime.target].limbs[v] < 6666 then
					table.insert(breaking, v)
				end
			end
			
			
			if #breaking > 1 then
				return rime.teradrim.attacks.left_arm_crippled[2] .. breaking[1]:gsub("_", " ")
			elseif rime.teradrim.bruise_check("left_arm") then
				return rime.teradrim.attacks.left_arm_crippled[1]
								
			elseif rime.teradrim.bruise_check("left_arm") and not rime.pvp.has_aff("left_arm_mangled", rime.target) then
				return rime.teradrim.attacks.left_arm_crippled[1]
			end
		end,
		can = function()
			local tar = rime.target
			--and not rime.pvp.has_def("shielded", tar) 
			if (rime.targets[rime.target].limbs["left_arm"] >= 2309 and rime.targets[rime.target].limbs["left_arm"] < 3333) or (rime.targets[rime.target].limbs["left_arm"] >= 5642 and rime.targets[rime.target].limbs["left_arm"] < 6666) then
				if rime.teradrim.can_flail() and rime.teradrim.bruise_check("left_arm") and lastLimbHit ~= "left arm" and not rime.limit[rime.target.."_left_arm_restore"] and not rime.pvp.parry_pred("left_arm") then
					return true
				elseif not rime.pvp.canParry() and not rime.pvp.has_aff("left_arm_mangled", rime.target) then
					return true
				else
					return false
				end
			else
				return false
			end
		end,
	},
	["right_arm_crippled"] = {
		"earth fracture target right arm",
		"earth furor target right arm ",
		choice = function()
			local target_limbs = table.copy(rime.targets[rime.target].limbs)
            local sort_limbs = sortedKeys(target_limbs)
			local sorted_limbs = {}
			local prepping = {}
			local breaking = {}
            local mode = rime.pvp.prediction_mode
            local last_parried = rime.targets[rime.target].parry
			local tar = rime.target
			local bruises = {"left_arm_bruised", "right_arm_bruised", "left_leg_bruised", "right_leg_bruised"}
			local bruise_count = 0
  
            for _, key in ipairs(sort_limbs) do
                table.insert(sorted_limbs, key)
            end
            for k, v in ipairs(rime.targets[rime.target].limbs) do
                if rime.limit[rime.target.."_"..v .. "_restore"] then
                    table.remove(sorted_limbs, table.index_of(sorted_limbs, v))
                end
            end
  
            table.remove(sorted_limbs, table.index_of(sorted_limbs, "head"))
            table.remove(sorted_limbs, table.index_of(sorted_limbs, "torso"))
            table.remove(sorted_limbs, table.index_of(sorted_limbs, "right_arm"))
  
            if rime.pvp.canParry() and table.contains(sorted_limbs, last_parried) then
                table.remove(sorted_limbs, table.index_of(sorted_limbs, last_parried))
            end
  

			
			for k, v in ipairs(sorted_limbs) do
				if rime.targets[rime.target].limbs[v] < 2150 then
					table.insert(prepping, v)
				elseif rime.targets[rime.target].limbs[v] >= 2309 and rime.targets[rime.target].limbs[v] < 3333 then
					table.insert(breaking, v)
				elseif rime.targets[rime.target].limbs[v] >= 5642 and rime.targets[rime.target].limbs[v] < 6666 then
					table.insert(breaking, v)
				end
			end

		

			
			
			if #breaking > 1 then
				return rime.teradrim.attacks.right_arm_crippled[2] .. breaking[1]:gsub("_", " ")
			elseif rime.teradrim.bruise_check("right_arm") then
				return rime.teradrim.attacks.right_arm_crippled[1]							
			elseif rime.teradrim.bruise_check("right_arm") and not rime.pvp.has_aff("right_arm_mangled", rime.target) then
				return rime.teradrim.attacks.right_arm_crippled[1]
			end
		end,
		can = function()
			local tar = rime.target
			--and not rime.pvp.has_def("shielded", tar)
			if (rime.targets[rime.target].limbs["right_arm"] >= 2309 and rime.targets[rime.target].limbs["right_arm"] < 3333) or (rime.targets[rime.target].limbs["right_arm"] >= 5642 and rime.targets[rime.target].limbs["right_arm"] < 6666) then
				if rime.teradrim.can_flail() and rime.teradrim.bruise_check("right_arm") and lastLimbHit ~= "right arm" and not rime.limit[rime.target.."_right_arm_restore"] and not rime.pvp.parry_pred("right_arm") then
					return true
				elseif not rime.pvp.canParry() and not rime.pvp.has_aff("right_arm_mangled", rime.target) then
					return true
				else
					return false
				end
			else
				return false
			end
		end,
	},
	["indifference"] = {
		"earth skullbash target",
		choice = function()
			return rime.teradrim.attacks.indifference[1]
		end,
		can = function()
			local tar = rime.target
			--and not rime.pvp.has_def("shielded", tar) 
			if not rime.pvp.has_aff("head_mangled", tar) and rime.teradrim.can_flail() and lastLimbHit ~= "head" and rime.pvp.has_aff("prone", tar) and rime.pvp.has_aff("head_bruised_moderate", tar) and rime.targets[rime.target].limbs["head"] < 6666  and not rime.pvp.parry_pred("head") and not rime.pvp.has_aff("indifference", tar) then
				return true
			elseif not rime.pvp.has_aff("head_mangled", tar) and rime.pvp.has_aff("writhe_grappled", tar) and rime.pvp.has_aff("head_bruised_moderate", tar) and not rime.pvp.has_aff("indifference", tar) and not rime.pvp.has_aff("head_mangled", tar) then
				return true
			elseif not rime.pvp.canParry() and not rime.pvp.has_aff("head_mangled", rime.target) and rime.pvp.has_aff("head_bruised_moderate", tar) then
				return true
			else
				return false
			end
		end,
	},
	["writhe_impaled"] = {
		"earth impale target",
		choice = function()
			return rime.teradrim.attacks.writhe_impaled[1]
		end,
		can = function()
			local tar = rime.target
			if rime.pvp.route_choice == "group" then
				if rime.pvp.has_aff("prone", tar) and not (rime.pvp.has_aff("writhe_impaled", tar) or rime.pvp.has_aff("tera_impaled", tar)) then
					return true
				else
					return false
				end
			elseif rime.pvp.target_tumbling and not rime.pvp.has_aff("deepwound", tar) then
				return true
			else
				return false
			end
		end,
	},
	["stonevice"] = {
		"earth stonevice",
		choice = function()
			return rime.teradrim.attacks.stonevice[1]
		end,
		can = function()
			local tar = rime.target
			if rime.pvp.has_aff("writhe_impaled", tar) and rime.pvp.has_aff("tera_impaled", tar) then
				return true
			else
				return false
			end
		end,
	},
	["collapsed_lung"] = {
		"earth pulp target",
		choice = function()
			return rime.teradrim.attacks.collapsed_lung[1]
		end,
		can = function()
			local tar = rime.target
			--and not rime.pvp.has_def("shielded", tar)
			if rime.pvp.has_aff("prone", tar) then
				if rime.teradrim.can_flail() and lastLimbHit ~= "torso" and not rime.pvp.has_aff("collapsed_lung", tar) and (rime.pvp.has_aff("left_leg_broken", tar) or rime.pvp.has_aff("right_leg_broken", tar)) then
					return true
				elseif rime.pvp.has_aff("writhe_grappled", tar) and not rime.pvp.has_aff("collapsed_lung", tar) then
					return true
				else
					return false
				end
			else
				return false
			end
		end,
	},
	["heartflutter"] = {
		"earth gutsmash target",
		choice = function()
			return rime.teradrim.attacks.heartflutter[1]
		end,
		can = function()
			local tar = rime.target
			--and not rime.pvp.has_def("shielded", tar) 
			if rime.teradrim.can_flail() and rime.pvp.runemark_minor == "green" then
				return true
			else
				return false
			end
		end,
	},
	["limbPrepper"] = {
        "earth furor target pick1 pick2",
		"earth barrage target",
        can = function()
            local target_limbs = table.copy(rime.targets[rime.target].limbs)
            local sort_limbs = sortedKeys(target_limbs)
			local sorted_limbs = {}
			local prepping = {}
			local breaking = {}
            local mode = rime.pvp.prediction_mode
            local last_parried = rime.targets[rime.target].parry
			local tar = rime.target
  
            for _, key in ipairs(sort_limbs) do
                table.insert(sorted_limbs, key)
            end
            for k, v in ipairs(rime.targets[rime.target].limbs) do
                if rime.limit[rime.target.."_"..v .. "_restore"] then
                    table.remove(sorted_limbs, table.index_of(sorted_limbs, v))
                end
            end
  
            table.remove(sorted_limbs, table.index_of(sorted_limbs, "head"))
            table.remove(sorted_limbs, table.index_of(sorted_limbs, "torso"))
  
            if rime.pvp.canParry() and table.contains(sorted_limbs, last_parried) then
                table.remove(sorted_limbs, table.index_of(sorted_limbs, last_parried))
            end
            if lastLimbHit ~= "none" then
                table.remove(sorted_limbs, table.index_of(sorted_limbs, lastLimbHit:gsub(" ", "_")))
            end
            if prerestoredLimb ~= "none" then
                table.remove(sorted_limbs, table.index_of(sorted_limbs, prerestoredLimb:gsub(" ", "_")))
			end
			
			for k, v in ipairs(sorted_limbs) do
				if rime.targets[rime.target].limbs[v] < 1529 then
					table.insert(prepping, v)
				end
			end

			--and not rime.pvp.has_def("shielded", tar) 
            if rime.teradrim.can_flail() and #prepping > 1 then
				rime.teradrim.attacks.limbPrepper[1] = "earth furor target "..prepping[1]:gsub("_", " ").." "..prepping[2]:gsub("_", " ")
				return true
            else
            	return false
            end
        end,
		choice = function()
			return rime.teradrim.attacks.limbPrepper[1]
		end
    },
	["limbPicker"] = {
        "earth furor target pick1 pick2",
        can = function()
            local target_limbs = table.copy(rime.targets[rime.target].limbs)
            local sort_limbs = sortedKeys(target_limbs)
			local sorted_limbs = {}
			local breaking = {}
            local mode = rime.pvp.prediction_mode
            local last_parried = rime.targets[rime.target].parry
			local tar = rime.target
  
            for _, key in ipairs(sort_limbs) do
                table.insert(sorted_limbs, key)
            end
            for k, v in ipairs(rime.targets[rime.target].limbs) do
                if rime.limit[rime.target.."_"..v .. "_restore"] then
                    table.remove(sorted_limbs, table.index_of(sorted_limbs, v))
                end
            end
  
            table.remove(sorted_limbs, table.index_of(sorted_limbs, "head"))
            table.remove(sorted_limbs, table.index_of(sorted_limbs, "torso"))
  
            if rime.pvp.canParry() and table.contains(sorted_limbs, last_parried) then
                table.remove(sorted_limbs, table.index_of(sorted_limbs, last_parried))
            end
            if lastLimbHit ~= "none" then
                table.remove(sorted_limbs, table.index_of(sorted_limbs, lastLimbHit:gsub(" ", "_")))
            end
            if prerestoredLimb ~= "none" then
                table.remove(sorted_limbs, table.index_of(sorted_limbs, prerestoredLimb:gsub(" ", "_")))
			end
			
			for k, v in ipairs(sorted_limbs) do
				if (rime.targets[rime.target].limbs[v] >= 2309 and rime.targets[rime.target].limbs[v] < 3333) or (rime.targets[rime.target].limbs[v] >= 5642 and rime.targets[rime.target].limbs[v] < 6666) then
					table.insert(breaking, v)
				end
			end

			--and not rime.pvp.has_def("shielded", tar) 
            if rime.teradrim.can_flail() and #breaking > 1 then
                rime.teradrim.attacks.limbPicker[1] = "earth furor target "..breaking[1]:gsub("_", " ").." "..breaking[2]:gsub("_", " ")
                return true
            elseif not rime.pvp.canParry() and #breaking > 1 then
            	rime.teradrim.attacks.limbPicker[1] = "earth furor target "..breaking[1]:gsub("_", " ").." "..breaking[2]:gsub("_", " ")
				return true
            else
               return false
            end
		end,
		choice = function()
			return rime.teradrim.attacks.limbPicker[1]
		end
    },
    ["damage_limb"] = {
    	"earth batter target limb",
    	can = function()
    		local target_limbs = table.copy(rime.targets[rime.target].limbs)
            local sort_limbs = sortedKeys(target_limbs)
			local sorted_limbs = {}
			local breaking = {}
            local mode = rime.pvp.prediction_mode
            local last_parried = rime.targets[rime.target].parry
			local tar = rime.target
			local target_limb = ""

			for _, key in ipairs(sort_limbs) do
                table.insert(sorted_limbs, key)
            end
            for k, v in ipairs(rime.targets[rime.target].limbs) do
                if rime.limit[rime.target.."_"..v .. "_restore"] then
                    table.remove(sorted_limbs, table.index_of(sorted_limbs, v))
                end
            end

            if rime.pvp.canParry() and table.contains(sorted_limbs, last_parried) then
                table.remove(sorted_limbs, table.index_of(sorted_limbs, last_parried))
            end
            if lastLimbHit ~= "none" then
                table.remove(sorted_limbs, table.index_of(sorted_limbs, lastLimbHit:gsub(" ", "_")))
            end
            if prerestoredLimb ~= "none" then
                table.remove(sorted_limbs, table.index_of(sorted_limbs, prerestoredLimb:gsub(" ", "_")))
			end

			for k, v in ipairs(sorted_limbs) do
				if (rime.targets[rime.target].limbs[v] >= 1529 and rime.targets[rime.target].limbs[v] < 3333) or (rime.targets[rime.target].limbs[v] >= 4862 and rime.targets[rime.target].limbs[v] < 6666) then
					table.insert(breaking, v)
				end
			end

			if #breaking > 0 then
				target_limb = breaking[1]
			end

			if rime.teradrim.can_flail() and not rime.pvp.parry_pred(target_limb) and not rime.pvp.has_aff(target_limb.."_mangled", tar) and #breaking > 0 then
                rime.teradrim.attacks.damage_limb[1] = "earth batter target "..target_limb:gsub("_", " ")
                return true
            elseif #breaking > 0 and not rime.pvp.canParry() and not (rime.pvp.has_aff(target_limb.."_mangled", rime.target) or rime.pvp.has_aff(target_limb.."_broken", rime.target)) then
				rime.teradrim.attacks.damage_limb[1] = "earth batter target "..target_limb:gsub("_", " ")
				return true
            else
               return false
            end
    	end,
    	choice = function()
    		return rime.teradrim.attacks.damage_limb[1]
    	end,
    },
	["left_leg_mangled"] = {
		"earth slam target left leg",
		"earth fracture target left leg",
		"earth batter target left leg",
		choice = function()
			
			if (rime.targets[rime.target].limbs.left_leg >= 1529 and rime.targets[rime.target].limbs.left_leg < 3333) or (rime.targets[rime.target].limbs.left_leg >= 4862 and rime.targets[rime.target].limbs.left_leg < 6666) then
				
					return rime.teradrim.attacks.left_leg_mangled[3]
			elseif not rime.pvp.has_aff("left_leg_bruised", rime.target) then
				return rime.teradrim.attacks.left_leg_mangled[1]
			elseif not rime.pvp.has_aff("left_leg_bruised_moderate", rime.target) then
				return rime.teradrim.attacks.left_leg_mangled[1]
			elseif rime.teradrim.bruise_check("left_leg") and not rime.pvp.has_aff('left_leg_mangled', rime.target) then
				return rime.teradrim.attacks.left_leg_mangled[2]
			end
		end,
		can = function()
			local tar = rime.target
			if rime.teradrim.can_flail() and lastLimbHit ~= "left leg" and not rime.pvp.has_aff("left_leg_mangled", rime.target) and not rime.limit[rime.target.."_left_leg_restore"] and not rime.pvp.parry_pred("left_leg") then
				return true
			elseif not rime.pvp.canParry() and not rime.pvp.has_aff("left_leg_mangled", rime.target) then
				return true
			else
				return false
			end
		end,
	},
	["right_leg_mangled"] = {
		"earth slam target right leg",
		"earth fracture target right leg",
		"earth batter target right leg",
		choice = function()
			if (rime.targets[rime.target].limbs.right_leg >= 1529 and rime.targets[rime.target].limbs.right_leg < 3333) or (rime.targets[rime.target].limbs.right_leg >= 4862 and rime.targets[rime.target].limbs.right_leg < 6666) then
				
					return rime.teradrim.attacks.right_leg_mangled[3]
				
			elseif not rime.pvp.has_aff("right_leg_bruised", rime.target) then
				return rime.teradrim.attacks.right_leg_mangled[1]
			elseif not rime.pvp.has_aff("right_leg_bruised_moderate", rime.target) then
				return rime.teradrim.attacks.right_leg_mangled[1]
			elseif rime.teradrim.bruise_check("right_leg") and not rime.pvp.has_aff("right_leg_mangled", rime.target) then
				return rime.teradrim.attacks.right_leg_mangled[2]
			end
		end,
		can = function()
			local tar = rime.target
			if rime.teradrim.can_flail() and lastLimbHit ~= "right leg" and not rime.pvp.has_aff("right_leg_mangled", rime.target) and not rime.limit[rime.target.."_right_leg_restore"] and not rime.pvp.parry_pred("right_leg") then
				return true
			elseif not rime.pvp.canParry() and not rime.pvp.has_aff("right_leg_mangled", rime.target) then
				return true
			else
				return false
			end
		end,
	},
	["right_arm_mangled"] = {
		"earth slam target right arm",
		"earth fracture target right arm",
		"earth batter target right arm",
		choice = function()
			if (rime.targets[rime.target].limbs.right_arm >= 1529 and rime.targets[rime.target].limbs.right_arm < 3333) or (rime.targets[rime.target].limbs.right_arm >= 4862 and rime.targets[rime.target].limbs.right_arm < 6666) then
				
					return rime.teradrim.attacks.right_arm_mangled[3]
			elseif not rime.pvp.has_aff("right_arm_bruised", rime.target) then
				return rime.teradrim.attacks.right_arm_mangled[1]
			elseif not rime.pvp.has_aff("right_arm_bruised_moderate", rime.target) then
				return rime.teradrim.attacks.right_arm_mangled[1]
			elseif rime.teradrim.bruise_check("right_arm") and not rime.pvp.has_aff("right_arm_mangled", rime.target) then
				return rime.teradrim.attacks.right_arm_mangled[2]
			end
		end,
		can = function()
			local tar = rime.target
			if rime.teradrim.can_flail() and lastLimbHit ~= "right arm" and not rime.pvp.has_aff("right_arm_mangled", rime.target) and not rime.limit[rime.target.."_right_arm_restore"] and not rime.pvp.parry_pred("right_arm") then
				return true
			elseif not rime.pvp.canParry() and not rime.pvp.has_aff("right_arm_mangled", rime.target) then
				return true
			else
				return false
			end
		end,
	},
	["left_arm_mangled"] = {
		"earth slam target left arm",
		"earth fracture target left arm",
		"earth batter target left arm",
		choice = function()
			if (rime.targets[rime.target].limbs.left_arm >= 1529 and rime.targets[rime.target].limbs.left_arm < 3333 ) or (rime.targets[rime.target].limbs.left_arm >= 4862 and rime.targets[rime.target].limbs.left_arm < 6666 )then
				
					return rime.teradrim.attacks.left_arm_mangled[3]
			elseif not rime.pvp.has_aff("left_arm_bruised", rime.target) then
				return rime.teradrim.attacks.left_arm_mangled[1]
			elseif not rime.pvp.has_aff("left_arm_bruised_moderate", rime.target) and not rime.pvp.has_aff("left_arm_mangled", rime.target) then
				return rime.teradrim.attacks.left_arm_mangled[1]
			elseif rime.teradrim.bruise_check("left_arm") and not rime.pvp.has_aff("left_arm_mangled", rime.target) then
				return rime.teradrim.attacks.left_arm_mangled[2]
			end
		end,
		can = function()
			local tar = rime.target
			if rime.teradrim.can_flail() and lastLimbHit ~= "left arm" and not rime.pvp.has_aff("left_arm_mangled", rime.target) and not rime.limit[rime.target.."_left_arm_restore"] and not rime.pvp.parry_pred("left_arm") then
				return true
			elseif not rime.pvp.canParry() and not rime.pvp.has_aff("left_arm_mangled", rime.target) then
				return true
			else
				return false
			end
		end,
	},
}

rime.teradrim.sand_attacks = {
	["double_slice"] = {
		"sand slice target storm massive"..rime.saved.separator.."sand slice target storm",
		choice = function()
			return rime.teradrim.sand_attacks.double_slice[1]
		end,
		can = function()
			local tar = rime.target
			if rime.vitals.sandstorm == 5 and rime.pvp.has_def("shielded", tar) and rime.pvp.has_def("rebounding", tar) then
				return true
			else
				return false
			end
		end,
	},
	["shielded"] = {
		"sand slice target storm",
		choice = function()
			return rime.teradrim.sand_attacks.shielded[1]
		end,
		can = function()
			local tar = rime.target
			if rime.vitals.sandstorm >= 3 and rime.pvp.has_def("shielded", tar) then
				return true
			else
				return false
			end
		end,
	},
	["rebounding"] = {
		"sand slice target storm",
		choice = function()
			return rime.teradrim.sand_attacks.rebounding[1]
		end,
		can = function()
			local tar = rime.target
			if rime.vitals.sandstorm >= 3 and rime.pvp.has_def("rebounding", tar) then
				return true
			else
				return false
			end
		end,
	},
	["sand_trapped"] = {
		"sand trap target",
		choice = function()
			return rime.teradrim.sand_attacks.sand_trapped[1]
		end,
		can = function()
			local tar = rime.target
			if rime.teradrim.can_trap then
				return true
			else
				return false
			end
		end,
	},

	["slough"] = {
		"sand curse target storm",
		choice = function()
			return rime.teradrim.sand_attacks.slough[1]
		end,
		can = function()
			local treeBalance = rime.pvp.balanceCheck("tree", rime.target)
			local tar = rime.target
			if rime.vitals.sandstorm == 5 and rime.pvp.route_choice == "group" and not rime.pvp.has_aff("slough", rime.target) then
				return true
			elseif rime.vitals.sandstorm == 5 and (rime.pvp.has_aff("heartflutter", tar) or rime.pvp.has_aff("paresis", tar)) then
				return true
			else
				return false
			end
		end,
	},
	["left_leg_crippled"] = {
		"sand scourge target storm",
		choice = function()
			return rime.teradrim.sand_attacks.left_leg_crippled[1]
		end,
		can = function()
			local tar = rime.target
			if rime.vitals.sandstorm == 5 and rime.pvp.route_choice == "group" then
				return true
			elseif rime.vitals.sandstorm == 5 and not rime.pvp.has_aff("left_leg_crippled", tar) then
				return true
			else
				return false
			end
		end
	},
	["right_leg_crippled"] = {
		"sand scourge target storm",
		choice = function()
			return rime.teradrim.sand_attacks.right_leg_crippled[1]
		end,
		can = function()
			local tar = rime.target
			if rime.vitals.sandstorm == 5 and rime.pvp.route_choice == "group" then
				return true
			elseif rime.vitals.sandstorm == 5 and not rime.pvp.has_aff("right_leg_crippled", tar) then
				return true
			else
				return false
			end
		end
	},
	["left_arm_crippled"] = {
		"sand scourge target storm",
		choice = function()
			return rime.teradrim.sand_attacks.left_arm_crippled[1]
		end,
		can = function()
			local tar = rime.target
			if rime.vitals.sandstorm == 5 and rime.pvp.route_choice == "group" then
				return true
			elseif rime.vitals.sandstorm == 5 and not rime.pvp.has_aff("left_arm_crippled", tar) then
				return true
			else
				return false
			end
		end
	},
	["right_arm_crippled"] = {
		"sand scourge target storm",
		choice = function()
			return rime.teradrim.sand_attacks.right_arm_crippled[1]
		end,
		can = function()
			local tar = rime.target
			if rime.vitals.sandstorm == 5 and rime.pvp.route_choice == "group" then
				return true
			elseif rime.vitals.sandstorm == 5 and not rime.pvp.has_aff("right_arm_crippled", tar) then
				return true
			else
				return false
			end
		end
	},
	["torso_broken"] = {
		"sand shred target torso storm",
		choice = function()
			return rime.teradrim.sand_attacks.torso_broken[1]
		end,
		can = function()
			local tar = rime.target
			if rime.vitals.sandstorm == 5 and lastLimbHit ~= "torso" and not rime.limit[rime.target.."_torso_restore"] and not rime.pvp.parry_pred("torso") and not rime.pvp.has_aff("torso_mangled", tar) then
				return true
			elseif rime.pvp.has_aff("writhe_grappled", tar) and rime.vitals.sandstorm == 5 and not rime.pvp.has_aff("torso", tar) then
				return true
			else
				return false
			end
		end,
	},
	["head_broken"] = {
	"sand shred target head storm",
	choice = function()
		return rime.teradrim.sand_attacks.head_broken[1]
	end,
	can = function()
		local tar = rime.target
		if rime.vitals.sandstorm == 5 and lastLimbHit ~= "head" and not rime.limit[rime.target.."_head_restore"] and not rime.pvp.parry_pred("head") and not rime.pvp.has_aff("head_mangled", tar) then
			return true
		elseif rime.pvp.has_aff("writhe_grappled", tar) and rime.vitals.sandstorm == 5 and not rime.pvp.has_aff("head_mangled", tar) then
			return true
		else
			return false
		end
	end,
	},
	["left_leg_mangled"] = {
		"sand shred target left leg storm",
		choice = function()
			return rime.teradrim.sand_attacks.left_leg_mangled[1]
		end,
		can = function()
			local tar = rime.target
			if rime.vitals.sandstorm == 5 and lastLimbHit ~= "left leg" and not rime.limit[rime.target.."_left_leg_restore"] then
				return true
			else
				return false
			end
		end,
	},
	["right_leg_mangled"] = {
		"sand shred target right leg storm",
		choice = function()
			return rime.teradrim.sand_attacks.right_leg_mangled[1]
		end,
		can = function()
			local tar = rime.target
			if rime.vitals.sandstorm == 5 and lastLimbHit ~= "right leg" and not rime.limit[rime.target.."_right_leg_restore"] then
				return true
			else
				return false
			end
		end,
	},
	["left_arm_mangled"] = {
		"sand shred target left arm storm",
		choice = function()
			return rime.teradrim.sand_attacks.left_arm_mangled[1]
		end,
		can = function()
			local tar = rime.target
			if rime.vitals.sandstorm == 5 and lastLimbHit ~= "left arm" and not rime.limit[rime.target.."_left_arm_restore"] then
				return true
			else
				return false
			end
		end
	},
	["torso_mangled"] = {
		"sand shred target torso storm",
		choice = function()
			return rime.teradrim.sand_attacks.torso_mangled[1]
		end,
		can = function()
			local tar = rime.target
			if rime.vitals.sandstorm == 5 and lastLimbHit ~= "torso" and not rime.limit[rime.target.."_torso_restore"] then
				return true
			else
				return false
			end
		end
	},
	["right_arm_mangled"] = {
		"sand shred target right arm storm",
		choice = function()
			return rime.teradrim.sand_attacks.right_arm_mangled[1]
		end,
		can = function()
			local tar = rime.target
			if rime.vitals.sandstorm == 5 and lastLimbHit ~= "right arm" and not rime.limit[rime.target.."_right_arm_restore"] then
				return true
			else
				return false
			end
		end,
	},
	["right_arm_broken"] = {
		"sand shred target right arm storm",
		choice = function()
			return rime.teradrim.sand_attacks.right_arm_broken[1]
		end,
		can = function()
			local tar = rime.target
			if rime.vitals.sandstorm == 5 and lastLimbHit ~= "right arm" and (rime.targets[rime.target].limbs.right_arm <= 3333 and rime.targets[rime.target].limbs.right_arm >= 2700) and not rime.limit[rime.target.."_right_arm_restore"] then
				return true
			else
				return false
			end
		end,
	},
	["left_arm_broken"] = {
		"sand shred target left arm storm",
		choice = function()
			return rime.teradrim.sand_attacks.left_arm_broken[1]
		end,
		can = function()
			local tar = rime.target
			if rime.vitals.sandstorm == 5 and lastLimbHit ~= "left arm" and (rime.targets[rime.target].limbs.left_arm <= 3333 and rime.targets[rime.target].limbs.left_arm >= 2700) and not rime.limit[rime.target.."_left_arm_restore"] then
				return true
			else
				return false
			end
		end,
	},
	["left_leg_broken"] = {
		"sand shred target left leg storm",
		choice = function()
			return rime.teradrim.sand_attacks.left_leg_broken[1]
		end,
		can = function()
			local tar = rime.target
			if rime.vitals.sandstorm == 5 and lastLimbHit ~= "left leg" and (rime.targets[rime.target].limbs.left_leg <= 3333 and rime.targets[rime.target].limbs.left_leg >= 2700) and not rime.limit[rime.target.."_left_leg_restore"] then
				return true
			else
				return false
			end
		end,
	},
	["right_leg_broken"] = {
		"sand shred target right leg storm",
		choice = function()
			return rime.teradrim.sand_attacks.right_leg_broken[1]
		end,
		can = function()
			local tar = rime.target
			if rime.vitals.sandstorm == 5 and lastLimbHit ~= "right leg" and (rime.targets[rime.target].limbs.right_leg <= 3333 and rime.targets[rime.target].limbs.right_leg >= 2700) and not rime.limit[rime.target.."_right_leg_restore"] then
				return true
			else
				return false
			end
		end,
	},
	["quicksand"] = {
		"sand quicksand target storm",
		choice = function()
			return rime.teradrim.sand_attacks.quicksand[1]
		end,
		can = function()
			local breaks = {"left_arm_crippled", "right_arm_crippled", "left_leg_crippled", "right_leg_crippled"}
			local tar = rime.target
			local break_count = 0
			

			for k,v in ipairs(breaks) do
				if rime.pvp.has_aff(v, tar) then
					break_count = break_count+1
				end
			end
			local bruises = {"left_arm_bruised", "right_arm_bruised", "left_leg_bruised", "right_leg_bruised", "torso_bruised", "head_bruised"}
			local bruise_count = 0
			for k,v in ipairs(bruises) do
				if rime.pvp.has_aff(v, tar) then
					bruise_count = bruise_count+1
				end
			end
			if rime.vitals.sandstorm == 5 and rime.pvp.has_aff("prone", tar) and not rime.pvp.has_def("shielded", tar) then
				return true
			else
				return false
			end
		end,
	},
	["curse_rampage"] = {
        Teradrim = "sand curse rampage_target storm",
        Tidesage = "fog terrors rampage_target apparition",
        choice = function()
            return rime.teradrim.sand_attacks.curse_rampage[rime.status.class]
        end,
        can = function()
        	if rampage_target == '' then return false end
            local target = rime.rampage_target
            if rime.pvp.has_aff("slough", target) then return false end
            if rime.vitals.sandstorm < 5 then return false end
            return true
        end,
    },

}

rime.teradrim.golem_attacks = {
	["heartpunch"] = {
		"prepare earthenwill heartpunch",
		can = function()
			local tar = rime.target
			if rime.pvp.has_aff("torso_bruised", tar) and not rime.pvp.has_aff("heartflutter", tar) then
				return true
			else
				return false
			end
		end,
		choice = function()
			return rime.teradrim.golem_attacks.heartpunch[1]
		end,
	},
	["rip"] = {
		"prepare earthenwill rip",
		can = function()
			local tar = rime.target
			if rime.pvp.has_aff("prone", tar) then
				return true
			else
				return false
			end
		end,
		choice = function()
			return rime.teradrim.golem_attacks.rip[1]
		end,
	},
	["wrack"] = {
		"prepare earthenwill wrack",
		can = function()
			local tar = rime.target
			if rime.pvp.has_aff("torso_mangled", tar) then
				return true
			else
				return false
			end
		end,
		choice = function()
			return rime.teradrim.golem_attacks.wrack[1]
		end,
	},
	["shout"] = {
		"prepare earthenwill shout",
		can = function()
			local tar = rime.target
			if rime.pvp.has_aff("head_broken", tar) and not rime.pvp.has_aff("blurry_vision", tar) then
				return true
			else
				return false
			end
		end,
		choice = function()
			return rime.teradrim.golem_attacks.shout[1]
		end,
	},
	["grapple"] = {
		"prepare earthenwill grapple",
		can = function()
			local tar = rime.target
			if rime.pvp.has_aff("prone", tar) and rime.pvp.has_aff("torso_broken", tar) then
				return true
			else
				return false
			end
		end,
		choice = function()
			return rime.teradrim.golem_attacks.grapple[1]
		end,
	},
	["choke"] = {
		"prepare earthenwill choke",
		can = function()
			local tar = rime.target
			if rime.pvp.has_aff("prone", tar) and rime.pvp.has_aff("head_bruised_moderate", tar) then
				return true
			else
				return false
			end
		end,
		choice = function()
			return rime.teradrim.golem_attacks.choke[1]
		end,
	},
	["wrench"] = {
		"prepare earthenwill wrench",
		can = function()
			local tar = rime.target
			local med_bruises = {"left_arm_bruised_moderate", "right_arm_bruised_moderate", "left_leg_bruised_moderate", "right_leg_bruised_moderate", "torso_bruised_moderate", "head_bruised_moderate"}
			local medium_bruise_count = 0

			for k,v in ipairs(med_bruises) do
				if rime.pvp.has_aff(v, tar) then
					medium_bruise_count = medium_bruise_count+1
				end
			end

			if medium_bruise_count > 1 then
				return true
			else
				return false
			end
		end,
		choice = function()
			return rime.teradrim.golem_attacks.wrench[1]
		end,
	},
}

function rime.teradrim.get_sand()

	local tar = rime.target

	for k,v in ipairs(rime.pvp.route.sand) do
		if rime.teradrim.sand_attacks[v] then
			if not rime.pvp.has_aff(v, tar) and rime.teradrim.sand_attacks[v].can() then
				if rime.pvp.has_aff("rebounding", tar) then
					return rime.teradrim.sand_attacks["rebounding"].choice()
				else
					return rime.teradrim.sand_attacks[v].choice()
				end
			end
		end
	end

	return ""

end

function rime.teradrim.can_flail()
	local sand = rime.vitals.sandstorm
	local tar = rime.target
	
	if not rime.pvp.has_def("rebounding", tar) then
		return true
	elseif sand == 5 then
		return true
	else
		return false
	end
end

function rime.teradrim.get_golem()

	local tar = rime.target

	for k,v in ipairs(rime.pvp.route.golem) do
		if rime.teradrim.golem_attacks[v] then
			if rime.teradrim.golem_attacks[v] and rime.teradrim.golem_attacks[v].can() then
				return rime.teradrim.golem_attacks[v].choice()
			end
		end
	end

	return ""

end

function rime.teradrim.get_flail()

	local tar = rime.target
	
		for k,v in ipairs(rime.pvp.route.affs) do
			if rime.teradrim.attacks[v] then
				if (v == "stonevice" or v == "writhe_impaled") and tonumber(rime.pvp.has_stack("stonevice", tar)) <= 3 and rime.teradrim.attacks[v].can() then
					return rime.teradrim.attacks[v].choice()
				elseif not rime.pvp.has_aff(v, tar)  and rime.teradrim.attacks[v].can() then
					return rime.teradrim.attacks[v].choice()
				end
			end
		end
	
end

function rime.teradrim.bruise_check(limb)
	local tar = rime.target
	if rime.pvp.has_aff(limb.."_bruised", tar) or rime.pvp.has_aff(limb.."_bruised_moderate", tar) or rime.pvp.has_aff(limb.."_bruised_critical", tar) then
		return true
	else
		return false
	end
end

rime.pvp.targetThere = rime.pvp.targetThere or true
rime.teradrim.lastCommand = rime.teradrim.lastCommand or ""
rime.teradrim.can_momentum = rime.teradrim.can_momentum or true

function rime.teradrim.offense()


	local sep = rime.saved.separator
	local target = rime.saved.target
	local sand = rime.vitals.sandstorm
	local sand_attack = rime.teradrim.get_sand()
	local flail_attack = rime.teradrim.get_flail()
	local golem = rime.teradrim.get_golem()
	local pre_command = rime.pvp.queue_handle()
	local last_flail = ''
	local command = ''
	local focusbal = rime.getTimeLeft("focus", target)


	if flail_attack ~= nil then
		if rime.teradrim.can_momentum then
			if rime.teradrim.can_earthenwill then
				command = "order golem kill " .. rime.target ..  sep .. golem .. sep .. "earth momentum" ..  sep .. sand_attack .. sep .. flail_attack
			else
				command = "order golem kill " .. rime.target ..  sep .. "earth momentum" ..  sep .. sand_attack .. sep .. flail_attack
			end
		else
			if  rime.teradrim.can_earthenwill then
				command ="order golem kill " .. rime.target ..  sep .. golem .. sep .. sand_attack .. sep .. flail_attack
			else
				command = "order golem kill " .. rime.target ..  sep .. sand_attack .. sep .. flail_attack
			end
		end
	end


	if not rime.vitals.wielded_right:find("flail") then
		command = "quickwield right " .. rime.saved.pvp_flail .. sep .. command
	end

	if command:find("slike") then
		rime.pvp.omniCall("slike")
	end

	command = pre_command .. sep .. command
	command = command .. sep .. rime.pvp.post_queue()
	command = command:gsub("rampage_target", rime.rampage_target)
	command = command:gsub("target", rime.target)
	

	if not rime.vitals.prone then
		act(command)
		rime.teradrim.lastCommand = command
	end

end