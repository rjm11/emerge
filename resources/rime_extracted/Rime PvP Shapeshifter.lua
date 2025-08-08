--Authors: Kurak, Bulrok
shifter = shifter or {}

shifter.my_jawlock = shifter.my_jawlock or false

rime.pvp.Shapeshifter.routes = {
	
	["quarter"] = {
		["attack"] = {
			"quarter",
			"writhe_thighlock",
			"writhe_armpitlock",
			"writhe_necklock",
			"left_leg_mangled",
			"left_leg_broken",
			"left_leg_crippled",
			"right_leg_mangled",
			"right_leg_broken",
			"right_leg_crippled",
			"left_leg_crippled",
			"right_arm_crippled",
			"left_arm_crippled",
		},
	["bays"] = {
			"prone",
			"anorexia",
			"stupidity",
	},
	},


}

shifter.attacks = {

	["devour"] = {
		"devour target",
		can = function()
			local rips = {"ripped_spleen", "ripped_groin", "ripped_throat"}
			local targ = rime.target
			local rip_count = 0
			for k,v in ipairs(rips) do
				if rime.pvp.has_aff(v, targ) then
					rip_count = rip_count+1
				end
			end

			if rip_count > 1 then
				return true
			else
				return false
			end
		end,
		claw = false
	},

	["shielded"] = {
		"touch hammer target",
		can = function()
            local targ = rime.target
			if rime.pvp.has_def("shielded", targ) then
				return true
			else
				return false
			end
		end,
		claw = false
	},

    ["skullwhack"] = {
        "skullwhack",
        can = function()
            local targ = rime.target
            if not shifter.no_parry() then return false end
            if rime.pvp.has_aff("head_broken",targ) and not rime.pvp.has_aff("unconscious",targ) and lastLimbHit ~= "head" and not rime.limit.head_restore and not rime.pvp.parry_pred("head") then 
                return true
            else
                return false
            end
        end,
        claw = true
    },

    ["spinalrip"] = {
    	"spinalrip target",
    	can = function()
    		local targ = rime.target
    		if rime.pvp.has_aff("paralysis",targ) and not rime.pvp.has_aff("spinal_rip", targ) then
    			return true
    		else
    			return false
    		end
    	end,
    	claw = false
    },

 
    ["blurry_vision"] = {
    	"faceslash",
		can = function()
		if not hasSkill("Faceslash") then return false end
			return true
		end,
		claw = true
	},

	["jugular"] = {
		"jugular",
		can = function()
			local targ = rime.target
			
			if not rime.pvp.has_aff("head_broken",targ) and rime.targets[rime.target].limbs.head <= 2700 and not rime.pvp.parry_pred("head ") then
				return true
			else
				return false
			end
		end,
		claw = true
	},

	["crippled_throat"] = {
		"throatslice",
		can = function()
			local targ = rime.target
			if not hasSkill("Throatslice") then return false end
			if rime.cure_set == "bard" and not rime.pvp.has_aff("head_broken",targ) and not rime.pvp.has_aff("crippled_throat",targ) then 
				return true
			else
				return false
			end
		end,
		claw = true
	},

	["slash_torso"] = {
		"slash torso",
		can = function()
			local targ = rime.target
			if not hasSkill("Slashing") then return false end
			if rime.targets[rime.target].limbs.torso <= 2700 and not rime.pvp.parry_pred("torso") and not rime.limit.torso_restore then 
				return true
			else
				return false
			end
		end,
		claw = true
	},

	["left_arm_crippled"] = {
		"rend left",
		can = function()
			local targ = rime.target
			if not hasSkill("Rend") then return false end
			if not rime.pvp.parry_pred("left_arm") and not rime.pvp.has_aff("left_arm_crippled",targ) and not rime.limit.left_arm_restore  then
				return true
			else
				return false
			end
		end,
			claw = true
	},

	["right_arm_crippled"] = {
		"rend right",
		can = function()
			local targ = rime.target
			if not hasSkill("Rend") then return false end
			if not rime.pvp.parry_pred("right_arm") and not rime.pvp.has_aff("right_arm_crippled",targ) and not rime.limit.right_arm_restore  then
				return true
			else
				return false
			end
		end,
		claw = true
	},
	["left_leg_crippled"] = {
		"hamstring left",
		can = function()
			local targ = rime.target
			if not hasSkill("Hamstring") then return false end
			if not rime.pvp.parry_pred("left_leg") and not rime.pvp.has_aff("left_leg_crippled",targ) and not rime.limit.left_leg_restore then
				return true
			else
				return false
			end
		end,
		claw = true
	},
	["right_leg_crippled"] = {
		"hamstring right",
		can = function()
			local targ = rime.target
			if not hasSkill("Hamstring") then return false end
			if not rime.pvp.parry_pred("right_leg") and not rime.pvp.has_aff("right_leg_crippled",targ) and not rime.limit.right_leg_restore then
				return true
			else
				return false
			end
		end,
		claw = true
	},

	["torso_mangled"] = {
		"gut target",
		can = function()
			local targ = rime.target
			if not hasSkill("Gut") then return false end
			if shifter.no_parry() and rime.pvp.has_aff("torso_broken",targ) and not rime.limit.torso_restore then
				return true
			else
				return false
			end
		end,
		claw = false
	},

    ["left_arm_mangled"] =    {
        "mangle left arm of target",
        can = function()
			local targ = rime.target

			if not hasSkill("Mangle") then return false end
            if shifter.no_parry() and rime.pvp.has_aff("left_arm_broken", targ) and not rime.limit.left_arm_restore then
                return true
            else
                return false
            end
        end,
        claw = false
    },

    ["right_arm_mangled"] = {
        "mangle right arm of target",
        can = function()
			local targ = rime.target

			if not hasSkill("Mangle") then return false end
            if shifter.no_parry() and rime.pvp.has_aff("right_arm_broken", targ) and not rime.limit.right_arm_restore then
                return true
            else
                return false
            end
        end,
        claw = false
    },

	["left_leg_mangled"] = {
		"mangle left leg of target",
		can = function()
			local targ = rime.target
			
			if not hasSkill("Mangle") then return false end
            if shifter.no_parry() and rime.pvp.has_aff("left_leg_broken", targ) and not rime.limit.left_leg_restore then
				return true
			else
				return false
			end
		end,
		claw = false
	},
	["right_leg_mangled"] = {
		"mangle right leg of target",
		can = function()
			local targ = rime.target

			
			if not hasSkill("Mangle") then return false end
            if shifter.no_parry() and rime.pvp.has_aff("right_leg_broken", targ) and not rime.limit.right_leg_restore then
				return true
			else
				return false
			end
		end,
		claw = false
	},

	["head_mangled"] = {
		"skullcrush target",
		can = function()
			local targ = rime.target
		
			if not hasSkill("Mangle") then return false end
			if shifter.no_parry() and rime.pvp.has_aff("head_broken", targ) and rime.pvp.has_aff("prone", targ) then
				return true
			else
				return false
			end
		end,
		claw = false
	},

	["left_arm_broken"] = {
		"destroy left arm of target",
		can = function()
			local targ = rime.target

			if not hasSkill("Destroy") then return false end
			if rime.pvp.has_aff("left_arm_crippled", targ) and lastLimbHit ~= "left arm" and not rime.limit.left_arm_restore and not rime.pvp.parry_pred("left_arm") then
				return true
			else
				return false
			end
		end,
		claw = false
	},

	["right_arm_broken"] = {
		"destroy right arm of target",
		can = function()
			local targ = rime.target
			
			if not hasSkill("Destroy") then return false end
			if rime.pvp.has_aff("right_arm_crippled", targ) and lastLimbHit ~= "right arm" and not rime.limit.right_arm_restore and not rime.pvp.parry_pred("right_arm") then
				return true
			else
				return false
			end
		end,
		claw = false
	},
	["left_leg_broken"] = {
		"destroy left leg of target",
		can = function()
			local targ = rime.target
		
			if not hasSkill("Destroy") then return false end
			if rime.pvp.has_aff("left_leg_crippled", targ) and lastLimbHit ~= "left leg" and not rime.limit.left_leg_restore and not rime.pvp.parry_pred("left_leg") then
				return true
			else
				return false
			end
		end,
		claw = false
	},
	["right_leg_broken"] = {
		"destroy right leg of target",
		can = function()
			local targ = rime.target
			
			if not hasSkill("Destroy") then return false end
			if rime.pvp.has_aff("right_leg_crippled", targ) and lastLimbHit ~= "right leg" and not rime.limit.right_leg_restore and not rime.pvp.parry_pred("right_leg") then
				return true
			else
				return false
			end
		end,
		claw = false
	},

	["writhe_thighlock"] = {
		"jawlock thigh of target",
		can = function()
			local targ = rime.target
			if not hasSkill("Thighlock") then return false end
			if rime.pvp.has_aff("ripped_groin", targ) then return false end
			if (rime.pvp.has_aff("left_leg_mangled", targ) or rime.pvp.has_aff("right_leg_mangled", targ)) and rime.pvp.has_aff("prone", targ) then
				return true
			else
				return false
			end
		end,
		claw = false
	},

	["writhe_armpitlock"] = {
		"jawlock armpit of target",
		can = function()
			local targ = rime.target
			if not hasSkill("Armpitlock") then return false end
			if not (rime.pvp.has_aff("left_leg_mangled", targ) or rime.pvp.has_aff("right_leg_mangled", targ)) and not (rime.pvp.has_aff("left_leg_broken", targ) or rime.pvp.has_aff("right_leg_broken", targ)) then return false end
			if rime.pvp.has_aff("ripped_spleen", targ) then return false end
			if (rime.pvp.has_aff("left_arm_mangled", targ) or rime.pvp.has_aff("right_arm_mangled", targ) or rime.pvp.has_aff("torso_mangled", targ)) and rime.pvp.has_aff("prone", targ) then
				return true
			else
				return false
			end
		end,
		claw = false
	},


	["writhe_necklock"] = {
		"jawlock neck of target",
		can = function()
			local targ = rime.target
			if not hasSkill("Necklock") then return false end
			if not (rime.pvp.has_aff("left_leg_mangled", targ) or rime.pvp.has_aff("right_leg_mangled", targ)) and not (rime.pvp.has_aff("left_leg_broken", targ) or rime.pvp.has_aff("right_leg_broken", targ)) then return false end
			if rime.pvp.has_aff("ripped_throat", targ) then return false end
			if rime.pvp.has_aff("head_broken", targ) and rime.pvp.has_aff("prone", targ) then
				return true
			else
				return false
			end
		end,
		claw = false
	},

	["ripped_groin"] = {
		"groinrip target",
		can = function()
			local targ = rime.target
			if not hasSkill("Groinrip") then return false end
			if rime.pvp.has_aff("writhe_thighlock", targ) then
				return true
			else
				return false
			end
		end,
		claw = false
	},

	["ripped_throat"] = {
		"throatrip target",
		can = function()
			local targ = rime.target
			if not hasSkill("Throatrip") then return false end
			if rime.pvp.has_aff("writhe_necklock", targ) then
				return true
			else
				return false
			end
		end,
		claw = false
	},

	["ripped_spleen"] = {
		"spleenrip target",
		can = function()
			local targ = rime.target
			if not hasSkill("Spleenrip") then return false end
			if rime.pvp.has_aff("writhe_armpitlock", targ) then
				return true
			else
				return false
			end
		end,
		claw = false
	},

	["quarter"] = {
		"quarter target",
		can = function()
			local targ = rime.target
			if not hasSkill("Quarter") then return false end
			if shifter.my_jawlock then return false end
			if rime.pvp.has_aff("writhe_thighlock", targ) or rime.pvp.has_aff("writhe_armpitlock", targ) or rime.pvp.has_aff("writhe_necklock", targ) then
				return true
			else
				return false
			end
		end,
		claw = false
	},

}

shifter.bays = {

    ["anorexia"] = {
        "bay distasteful at target",
        can = function()
            local targ = rime.target
			if not hasSkill("Distasteful") then return false end
            if not rime.pvp.has_aff("prone") then return false end
            if shifter.no_parry() then
                return true
            else
                return false
            end
        end,
    },

    ["prone"] = {
        "bay forceful at target",
        can = function()
            local targ = rime.target
			if not hasSkill("Forceful") then return false end
            if rime.pvp.has_aff("left_leg_broken", targ) or rime.pvp.has_aff("right_leg_broken") then
                return true
            else
                return false
            end
        end,
     },
    ["stupidity"] = {
        "bay mind-numbing at target",
        can = function()
            local targ = rime.target
			if not hasSkill("Mind-numbing") then return false end
            if not shifter.no_parry() and not rime.pvp.has_aff("prone", targ) then return false end
            if rime.pvp.has_aff("anorexia", targ) then
                return true
            else
                return false
            end
        end,
       },
}


function shifter.no_parry()

		local targ = rime.target

		if (rime.pvp.has_aff("left_arm_crippled", targ) and rime.pvp.has_aff("right_arm_crippled", targ)) or rime.pvp.has_aff("paralysis",targ) or rime.pvp.has_aff("writhe_transfix",targ)
	or rime.pvp.has_aff("writhe_impaled",targ) or rime.pvp.has_aff("writhe_web",targ) or rime.pvp.has_aff("writhe_thighlock", targ) or rime.pvp.has_aff("writhe_armpitlock", targ) or rime.pvp.has_aff("writhe_necklock", targ)
	or rime.pvp.has_aff("writhe_thighlock", targ) then 
			return true
		else  
			return false

		end
end

function shifter.can_combo()

		if rime.pvp.has_aff("left_arm_crippled") or rime.pvp.has_aff("right_arm_crippled") then return false end
		
		return true  

end

function shifter.get_bay()

	local targ = rime.target

	for k,v in ipairs(rime.pvp.route.bays) do
		if not rime.pvp.has_aff(v, targ) and shifter.bays[v].can() then
			return shifter.bays[v][1]
		end
	end

	return ""

end



function shifter.pick_attack()

		local bay = shifter.get_bay() or ""
		local targ = rime.target
		local attack = "nothing"
		local combo = shifter.can_combo()
		local attack_two = ""
		local sep = rime.saved.separator

		for k,v in ipairs(rime.pvp.route.attack) do
			if not rime.pvp.has_aff(v, targ) and shifter.attacks[v].can() then
				attack = shifter.attacks[v][1]
				combo = shifter.attacks[v].claw
				break
			end
		end

		if combo then
			for k,v in ipairs(rime.pvp.route.attack) do
				if not rime.pvp.has_aff(v, targ) and shifter.attacks[v][1] ~= attack and shifter.attacks[v].can() then
					attack_two = shifter.attacks[v][1]
					break
				end
			end
		end


		if combo then

			return "combo " .. targ .. " " .. attack .. " " .. attack_two..sep..bay

		else

			return attack..sep..bay

		end


end

function shifter.offense()

    local sep = rime.saved.separator
    local attack = shifter.pick_attack()

    attack = attack:gsub("target", rime.target)

    if attack == "nothing" then
        attack = shifter.pick_attack()
    end

    if has_def("fury") then

        attack = "pounce " .. rime.target .. sep .. attack

    end

    act(rime.pvp.queue_handle() .. sep .. attack)


end