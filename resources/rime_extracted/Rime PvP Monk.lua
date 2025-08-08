--Author: Satan
monk = monk or {}
monk.can_strike = true

monk.kicks = {

	["shielded"] = {
		"sck target",
		can = function()
			local target = rime.target
			if not monk.can("kick") then return false end
			if not rime.pvp.has_def("shielded", target) then return false end
			return true
		end,
		choice = function()
			return monk.kicks.shielded[1]
		end
	},

	["left_leg_damaged"] = {
		"snk left",
		can = function()
			local target = rime.target
			if not monk.can("kick") then return false end
			if rime.targets[target].parry == "left leg" and rime.pvp.canParry(target) then return false end
			if rime.pvp.has_aff("left_leg_damaged", target) then return false end
			if rime.pvp.lastLimb_hit == "left leg" then return false end
			return true
		end,
		choice = function()
			return monk.kicks.left_leg_damaged[1]
		end,
		combo = true,
		telepathy = true,
	},

	["right_leg_damaged"] = {
		"snk right",
		can = function()
			local target = rime.target
			if not monk.can("kick") then return false end
			if rime.targets[target].parry == "right leg" and rime.pvp.canParry(target) then return false end
			if rime.pvp.has_aff("right_leg_damaged", target) then return false end
			if rime.pvp.lastLimb_hit == "right leg" then return false end
			return true
		end,
		choice = function()
			return monk.kicks.right_leg_damaged[1]
		end,
		combo = true,
		telepathy = true,
	},

	["left_arm_damaged"] = {
		"mnk left",
		can = function()
			local target = rime.target
			if not monk.can("kick") then return false end
			if rime.targets[target].parry == "left arm" and rime.pvp.canParry(target) then return false end
			if rime.pvp.has_aff("left_arm_damaged", target) then return false end
			if rime.pvp.lastLimb_hit == "left arm" then return false end
		end,
		choice = function()
			return monk.kicks.left_arm_damaged[1]
		end,
		combo = true,
		telepathy = true,
	},

	["right_arm_damaged"] = {
		"mnk right",
		can = function()
			local target = rime.target
			if not monk.can("kick") then return false end
			if rime.targets[target].parry == "right arm" and rime.pvp.canParry(target) then return false end
			if rime.pvp.has_aff("right_arm_damaged", target) then return false end
			if rime.pvp.lastLimb_hit == "right arm" then return false end
			return true
		end,
		choice = function()
			return monk.kicks.right_arm_damaged[1]
		end,
		combo = true,
		telepathy = true,
	},

	["torso_damaged"] = {
		"sdk",
		can = function()
			local target = rime.target
			if not monk.can("kick") then return false end
			if rime.targets[target].parry == "torso" and rime.pvp.canParry(target) then return false end
			if rime.pvp.has_aff("torso_damaged", target) then return false end
			if rime.pvp.lastLimb_hit == "torso" then return false end
			return true
		end,
		choice = function()
			return monk.kicks.torso_damaged[1]
		end,
	},

	["head_damaged"] = {
		"wwk",
		can = function()
			local target = rime.target
			if not monk.can("kick") then return false end
			if rime.targets[target].parry == "head" and rime.pvp.canParry(target) then return false end
			if rime.pvp.has_aff("head_damaged", target) then return false end
			if rime.pvp.lastLimb_hit == "head" then return false end
			return true
		end,
		choice = function()
			return monk.kicks.head_damaged[1]
		end,
	},
}

function monk.can(thing)

	if thing == "kick" then
		if rime.has_aff("left_leg_broken") then return false end
		if rime.has_aff("right_leg_broken") then return false end
	elseif thing == "punch" then
		if rime.has_aff("right_arm_broken") then return false end
		if rime.has_aff("left_arm_broken") then return false end
	end

end