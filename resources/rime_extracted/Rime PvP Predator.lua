predator = predator or {}
predator.can_feint = true
predator.slices = 0
predator.slashes = 0

--contains our attack schemes
rime.pvp.Predator.routes = { 
    ["black"] = {
        ["blurb"] = {"Slice from toe to tip"},
        ["attacks"] = {
            --attacks should be broken out by stance,
            --allows us to prioritize based ON stance.
            ["Gyanis"] = {
            	"fleshbane_head_legs",
            	"fleshbane_torso_legs",
            	"pummel_head_arms",
            	"pummel_head_legs",
            	"pummel_torso_arms",
            	"pummel_torso_legs",
                "raze",
                "ccut",
                --"feint_head",
                "lowhook_left",
                "jab_right",
                "lowhook_right",
                "jab_left",
                "lateral",
                "spinslash",
                "gouge",
                "flashkick",
            },

            ["Vae-Sant"] = {
            	"fleshbane_head_legs",
            	"fleshbane_torso_legs",
            	"pummel_head_arms",
            	"pummel_head_legs",
            	"pummel_torso_arms",
            	"pummel_torso_legs",
                "raze",
                --"feint_head",
                "gouge",
                "spinslash",
                "lateral",
                --"vertical_arm",
                --"vertical_leg",
                "jab_left",
                "jab_right",
                "lowhook_left",
                "lowhook_right",
                "flashkick",
            },

            ["Rizet"] = {
            	"fleshbane_head_legs",
            	"fleshbane_torso_legs",
            	"pummel_head_arms",
            	"pummel_head_legs",
            	"pummel_torso_arms",
            	"pummel_torso_legs",
                "raze",
                "ccut",
                "spinslash",
                "gouge",
                "lateral",
                --"vertical_arm",
                --"vertical_leg",
            },

            ["Ein-Fasit"] = {
            	"fleshbane_head_legs",
            	"fleshbane_torso_legs",
            	"pummel_head_arms",
            	"pummel_head_legs",
            	"pummel_torso_arms",
            	"pummel_torso_legs",
                "raze",
                "ccut",
                "lateral",
                --"feint_head",
                "gouge",
                "lowhook_right",
                --"vertical_arm",
                --"vertical_leg",
                "jab_left",
                "jab_right",
                "lateral",
                "lowhook_left",
                "lowhook_right",
                "flashkick",
            },

            ["Laesan"] = {
            	"fleshbane_head_legs",
            	"fleshbane_torso_legs",
            	"pummel_head_arms",
            	"pummel_head_legs",
            	"pummel_torso_arms",
            	"pummel_torso_legs",
                "raze",
                "ccut",
                --"feint_head",
                "lowhook_left",
                "lowhook_right",
                "jab_left",
                "jab_right",
                "spinslash",
            },

            ["None"] = {
            	"fleshbane_head_legs",
            	"fleshbane_torso_legs",
            	"pummel_head_arms",
            	"pummel_head_legs",
            	"pummel_torso_arms",
            	"pummel_torso_legs",
                "raze",
                "ccut",
                --"feint_head",
                "jab_left",
                "jab_right",
                "lateral",
                --"vertical_arm",
                --"vertical_leg",
                "spinslash",
                "gouge",
            },

            ["Bladesurge"] = {
            	"fleshbane_head_legs",
            	"fleshbane_torso_legs",
            	"pummel_head_arms",
            	"pummel_head_legs",
            	"pummel_torso_arms",
            	"pummel_torso_legs",
                "raze",
                "ccut",
                "fleshbane_head_legs",
                --"feint_head",
                "jab_left",
                "jab_right",
                "lowhook_left",
                "lowhook_right",
                "lateral",
                "spinslash",
                "gouge",
            },
        },
    },

    ["glimb"] = {
        ["blurb"] = {"Predator? I bearly know her!"},
        ["attacks"] = {
            --attacks should be broken out by stance,
            --allows us to prioritize based ON stance.
            ["Gyanis"] = {
            	"rake_voyria",
            	"mawcrush_voyria",
                "raze",
                "ccut",
                "lateral",
                "spinslash",
                "lowhook_left",
                "jab_right",
                "lowhook_right",
                "jab_left",
                "gouge",
                "flashkick",
            },

            ["Vae-Sant"] = {
            	"rake_voyria",
            	"mawcrush_voyria",
                "raze",
                "gouge",
                "spinslash",
                "lateral",
                "jab_left",
                "jab_right",
                "lowhook_left",
                "lowhook_right",
                "flashkick",
            },

            ["Rizet"] = {
            	"rake_voyria",
            	"mawcrush_voyria",
                "raze",
                "ccut",
                "spinslash",
                "lateral",
                "gouge",
            },

            ["Ein-Fasit"] = {
            	"rake_voyria",
            	"mawcrush_voyria",
                "raze",
                "ccut",
                "lateral",
                "gouge",
                "lowhook_right",
                "jab_left",
                "jab_right",
                "lateral",
                "lowhook_left",
                "lowhook_right",
                "flashkick",
            },

            ["Laesan"] = {
            	"rake_voyria",
            	"mawcrush_voyria",
                "raze",
                "ccut",
                "spinslash",
                "lowhook_left",
                "lowhook_right",
                "jab_left",
                "jab_right",
            },

            ["None"] = {
            	"rake_voyria",
            	"mawcrush_voyria",
                "raze",
                "ccut",
                "lateral",
                "spinslash",
                "jab_left",
                "jab_right",
                "gouge",
            },

            ["Bladesurge"] = {
            	"rake_voyria",
            	"mawcrush_voyria",
                "raze",
                "ccut",
                "lateral",
                "spinslash",
                "jab_left",
                "jab_right",
                "lowhook_left",
                "lowhook_right",
                "gouge",
            },
        },
    },

}

--attack dictionary, maps the syntax
--and various attributes to each
--attack
predator.knifeplay = {

    ["raze"] = {
        "raze",
        choice = function()
            return predator.knifeplay.raze[1]
        end,
        can = function()
            local target = rime.target
            if predator.temp_defs.rebounding == true then 
            	return true
            else
            	return false
            end
        end,
        combo = true,
        starter = true,
        type = "Raze",
        venom = false,
        used = function()
        	predator.temp_defs.rebounding = false
        end,
    },

    ["ccut"] = {
        "crescentcut",
        choice = function()
            return predator.knifeplay.ccut[1]
        end,
        can = function()
            local target = rime.target
            --if --[[rime.pvp.has_def("rebounding", target)]] predator.temp_defs.rebounding == false then return false end
            if predator.crescentcutMultiplier() >= 2.5 then return true end
            return false
        end,
        combo = true,
        starter = false,
        type = "Spinslash",
        venom = false,
        used = function()
        	return
        end,
    },

    ["jab_left"] = {
        "jab left",
        choice = function()
            return predator.knifeplay.jab_left[1]
        end,
        can = function()
            local target = rime.target
            --if --[[rime.pvp.has_def("rebounding", target)]] predator.temp_defs.rebounding == false then return false end
            if rime.pvp.canParry() and rime.targets[target].parry == "left arm" then return false end
            if rime.pvp.has_aff("left_arm_mangled", target) then return false end
            if rime.limit[target .. "_left_arm_restore"] then return false end
            return true
        end,
        combo = true,
        starter = false,
        type = "Jab",
        venom = false,
        used = function()
        	return
        end,
    },

    ["jab_right"] = {
        "jab right",
        choice = function()
            return predator.knifeplay.jab_right[1]
        end,
        can = function()
            local target = rime.target
            --if --[[rime.pvp.has_def("rebounding", target)]] predator.temp_defs.rebounding == false then return false end
            if rime.pvp.canParry() and rime.targets[target].parry == "right arm" then return false end
            if rime.pvp.has_aff("right_arm_mangled", target) then return false end
            if rime.limit[target .. "_right_arm_restore"] then return false end
            return true
        end,
        combo = true,
        starter = false,
        type = "Jab",
        venom = false,
        used = function()
        	return
        end,
    },

    ["lowhook_right"] = {
        "lowhook right",
        choice = function()
            return predator.knifeplay.lowhook_right[1]
        end,
        can = function()
            local target = rime.target
            --if --[[rime.pvp.has_def("rebounding", target)]] predator.temp_defs.rebounding == false then return false end
            if rime.pvp.canParry() and rime.targets[target].parry == "right leg" then return false end
            if rime.pvp.has_aff("right_leg_mangled", target) then return false end
            if rime.limit[target .. "_right_leg_restore"] then return false end
            return true
        end,
        combo = true,
        starter = false,
        type = "Lowhook",
        venom = false,
        used = function()
        	return
        end,
    },

    ["lowhook_left"] = {
        "lowhook left",
        choice = function()
            return predator.knifeplay.lowhook_left[1]
        end,
        can = function()
            local target = rime.target
            --if --[[rime.pvp.has_def("rebounding", target)]] predator.temp_defs.rebounding == false then return false end
            if rime.pvp.canParry() and rime.targets[target].parry == "left leg" then return false end
            if rime.pvp.has_aff("left_leg_mangled", target) then return false end
            if rime.limit[target .. "_left_leg_restore"] then return false end
            return true
        end,
        combo = true,
        starter = false,
        type = "Lowhook",
        venom = false,
        used = function()
        	return
        end,
    },

    ["spinslash"] = {
        "spinslash",
        choice = function()
            return predator.knifeplay.spinslash[1]
        end,
        can = function()
            local target = rime.target
            --if --[[rime.pvp.has_def("rebounding", target)]] predator.temp_defs.rebounding == false then return false end
            return true
        end,
        combo = true,
        starter = false,
        type = "Spinslash",
        venom = false,
        used = function()
        	return
        end,
    },

    ["gouge"] = {
        "gouge",
        choice = function()
            return predator.knifeplay.gouge[1]
        end,
        can = function()
            local target = rime.target
            --if --[[rime.pvp.has_def("rebounding", target)]] predator.temp_defs.rebounding == false then return false end
            if rime.pvp.canParry() and rime.targets[target].parry == "head" then return false end
            if rime.limit[target .. "_head_restore"] then return false end
            return true
        end,
        combo = true,
        starter = false,
        type = "Gouge",
        venom = false,
        used = function()
        	return
        end,
    },

    ["lateral"] = {
        "lateral",
        choice = function()
            return predator.knifeplay.lateral[1]
        end,
        can = function()
            local target = rime.target
            --if --[[rime.pvp.has_def("rebounding", target)]] predator.temp_defs.rebounding == false then return false end
            if rime.pvp.canParry() and rime.targets[target].parry == "torso" then return false end
            if rime.limit[target .. "_torso_restore"] then return false end
            return true
        end,
        combo = true,
        starter = false,
        type = "Lateral",
        venom = false,
        used = function()
        	return
        end, 
    },

    ["limb_flashkick"] = {
        "flashkick",
        choice = function()
            return predator.knifeplay.limb_flashkick[1]
        end,
        can = function()
            local target = rime.target
            if rime.pvp.canParry() and rime.targets[target].parry == "head" then return false end
            if rime.limit[target .. "_head_restore"] then return false end
            return true
        end,
        combo = true,
        starter = false,
        type = "Flashkick",
        venom = false,
        used = function()
        	return
        end,
    },

    ["feint_head"] = {
        "feint head",
        choice = function()
            return predator.knifeplay.feint_head[1]
        end,
        can = function()
            local target = rime.target
            --if --[[rime.pvp.has_def("rebounding", target)]] predator.temp_defs.rebounding == false then return false end
            if not predator.can_feint then return false end
            if not rime.pvp.canParry() then return false end
            return true
        end,
        combo = true,
        starter = true,
        type = "Feint",
        venom = false,
        used = function()
        	return
        end,
    },

    ["vertical_arm"] = {
        "vertical",
        choice = function()
            return predator.knifeplay.vertical_arm[1]
        end,
        can = function()
            local target = rime.target
            --if --[[rime.pvp.has_def("rebounding", target)]] predator.temp_defs.rebounding == false then return false end
            if (rime.pvp.has_aff("left_arm_crippled", target) and rime.pvp.has_aff("right_arm_crippled", target)) then return false end
            return true
        end,
        combo = true,
        starter = true,
        type = "Vertical",
        venom = "epteth",
        used = function()
        	return
        end,
    },

    ["vertical_leg"] = {
        "vertical",
        choice = function()
            return predator.knifeplay.vertical_leg[1]
        end,
        can = function()
            local target = rime.target
            --if --[[rime.pvp.has_def("rebounding", target)]] predator.temp_defs.rebounding == false then return false end
            if (rime.pvp.has_aff("left_leg_crippled", target) and rime.pvp.has_aff("right_leg_crippled", target)) then return false end
            return true
        end,
        combo = true,
        starter = true,
        type = "Vertical",
        venom = "epseth",
        used = function()
        	return
        end,
    },

    ["fleshbane_head_legs"] = {
    	"orgyuk pummel target head"..rime.saved.separator.."fleshbane target",
    	choice = function()
    		return predator.knifeplay.fleshbane_head_legs[1]
    	end,
    	can = function()
    		local target = rime.target
    		if rime.pvp.canParry() and rime.targets[target].parry == "head" then return false end
    		if rime.pvp.has_aff("fleshbane", target) then return false end
    		return true
    	end,
    	combo = false,
    	starter = true,
    	type = "Beast",
    	venom = "epseth",
        used = function()
        	return
        end,
    },

    ["fleshbane_torso_legs"] = {
    	"orgyuk pummel target torso"..rime.saved.separator.."fleshbane target",
    	choice = function()
    		return predator.knifeplay.fleshbane_torso_legs[1]
    	end,
    	can = function()
    		local target = rime.target
    		if rime.pvp.canParry() and rime.targets[target].parry == "torso" then return false end
    		if rime.pvp.has_aff("fleshbane", target) then return false end
    		return true
    	end,
    	combo = false,
    	starter = true,
    	type = "Beast",
    	venom = "epseth",
        used = function()
        	return
        end,
    },

    ["pummel_head_legs"] = {
    	"orgyuk pummel target head"..rime.saved.separator.."fleshbane target",
    	choice = function()
    		return predator.knifeplay.pummel_head_legs[1]
    	end,
    	can = function()
    		local target = rime.target
    		if rime.pvp.canParry() and rime.targets[target].parry == "head" then return false end
    		if rime.pvp.has_aff("left_leg_crippled", target) and rime.pvp.has_aff("right_leg_crippled", target) then return false end
    		if rime.pvp.has_aff("head_broken", target) then return false end
    		if rime.limit[target .. "_head_restore"] then return false end
    		if rime.targets[target].limbs.head < 1300 then return false end
    		return true
    	end,
    	combo = false,
    	starter = true,
    	type = "Beast",
    	venom = "epseth",
        used = function()
        	return
        end,
    },

    ["pummel_head_arms"] = {
    	"orgyuk pummel target head"..rime.saved.separator.."fleshbane target",
    	choice = function()
    		return predator.knifeplay.pummel_head_arms[1]
    	end,
    	can = function()
    		local target = rime.target
    		if rime.pvp.canParry() and rime.targets[target].parry == "head" then return false end
    		if rime.pvp.has_aff("left_arm_crippled", target) and rime.pvp.has_aff("right_arm_crippled", target) then return false end
    		if rime.pvp.has_aff("head_broken", target) then return false end
    		if rime.limit[target .. "_head_restore"] then return false end
    		if rime.targets[target].limbs.head < 1300 then return false end
    		return true
    	end,
    	combo = false,
    	starter = true,
    	type = "Beast",
    	venom = "epseth",
        used = function()
        	return
        end,
    },

    ["pummel_torso_arms"] = {
    	"orgyuk pummel target torso"..rime.saved.separator.."fleshbane target",
    	choice = function()
    		return predator.knifeplay.pummel_torso_arms[1]
    	end,
    	can = function()
    		local target = rime.target
    		if rime.pvp.canParry() and rime.targets[target].parry == "torso" then return false end
    		if rime.pvp.has_aff("left_arm_crippled", target) and rime.pvp.has_aff("right_arm_crippled", target) then return false end
    		if rime.pvp.has_aff("torso_broken", target) then return false end
    		if rime.limit[target .. "_torso_restore"] then return false end
    		if rime.targets[target].limbs.torso < 1300 then return false end
    		return true
    	end,
    	combo = false,
    	starter = true,
    	type = "Beast",
    	venom = "epseth",
        used = function()
        	return
        end,
    },

    ["pummel_torso_legs"] = {
    	"orgyuk pummel target torso"..rime.saved.separator.."fleshbane target",
    	choice = function()
    		return predator.knifeplay.pummel_torso_arms[1]
    	end,
    	can = function()
    		local target = rime.target
    		if rime.pvp.canParry() and rime.targets[target].parry == "torso" then return false end
    		if rime.pvp.has_aff("left_leg_crippled", target) and rime.pvp.has_aff("right_leg_crippled", target) then return false end
    		if rime.pvp.has_aff("torso_broken", target) then return false end
    		if rime.limit[target .. "_torso_restore"] then return false end
    		if rime.targets[target].limbs.torso < 1300 then return false end
    		return true
    	end,
    	combo = false,
    	starter = true,
    	type = "Beast",
    	venom = "epseth",
        used = function()
        	return
        end,
    },

    ["group_pummel"] = {
    	"orgyuk pummel target limb"..rime.saved.separator.."fleshbane target",
    	choice = function()
    		local limb = "torso"
    		local last_parried = rime.targets[rime.target].parry
    		local limbPrio = {"torso", "head", "left_leg", "right_leg"}
			for k, v in pairs(limbPrio) do
				if k~=last_parried and not rime.pvp.has_aff(k.."_broken", rime.target) then
			    	limb = k
			    	break
			  	end
			end
			return "orgyuk pummel target "..limb..""..rime.saved.separator.."fleshbane target"
    	end,
    	can = function()
    		local target = rime.target
    		return true
    	end,
    	combo = false,
    	starter = true,
    	type = "Beast",
    	venom = "voyria",
        used = function()
        	return
        end,
    },

    ["mawcrush_voyria"] = {
    	"orgyuk mawcrush target"..rime.saved.separator.."fleshbane target",
    	choice = function()
    		return predator.knifeplay.mawcrush_voyria[1]
    	end,
    	can = function()
    		local target = rime.target
    		if not rime.pvp.has_aff("torso_broken", target) then return false end
    		return true
    	end,
    	combo = false,
    	starter = true,
    	type = "Beast",
    	venom = "voyria",
        used = function()
        	return
        end,
    },

    ["rake_voyria"] = {
    	"orgyuk rake target"..rime.saved.separator.."fleshbane target",
    	choice = function()
    		return predator.knifeplay.rake_voyria[1]
    	end,
    	can = function()
    		local target = rime.target
    		if not rime.pvp.room.bloodied then return false end
    		return true
    	end,
    	combo = false,
    	starter = true,
    	type = "Beast",
    	venom = "voyria",
        used = function()
        	return
        end,
    },

}


--determines the stance we're in after a certain move
function predator.nextStance(move, stance)
	if not stance then stance = predator.stance end
local stanceFlow = {
    Jab = {None = "Gyanis", Gyanis = "Rizet",  ["Vae-Sant"] = "Gyanis", Rizet = "Rizet", ["Ein-Fasit"] = "Vae-Sant", Laesan = "Rizet"},
    Pinprick = {None = "Gyanis", Gyanis = "Rizet",  ["Vae-Sant"] = "Rizet", Rizet = "Vae-Sant", ["Ein-Fasit"] = "Ein-Fasit", Laesan = "Gyanis"},
    Lateral = {None = "Gyanis", Gyanis = "Vae-Sant",  ["Vae-Sant"] = "Ein-Fasit", Rizet = "Ein-Fasit", ["Ein-Fasit"] = "Laesan", Laesan = "Laesan"},
    Vertical = {None = "Laesan", Gyanis = "Laesan",  ["Vae-Sant"] = "Rizet", Rizet = "Ein-Fasit", ["Ein-Fasit"] = "Vae-Sant", Laesan = "Laesan"},
    Crescentcut = {None = "Vae-Sant", Gyanis = "Ein-Fasit",  ["Vae-Sant"] = "Vae-Sant", Rizet = "Laesan", ["Ein-Fasit"] = "Gyanis", Laesan = "Vae-Sant"},
    Spinslash = {None = "Vae-Sant", Gyanis = "Vae-Sant",  ["Vae-Sant"] = "Ein-Fasit", Rizet = "Laesan", ["Ein-Fasit"] = "Ein-Fasit", Laesan = "Ein-Fasit"},
    Lowhook = {None = "Vae-Sant", Gyanis = "Vae-Sant",  ["Vae-Sant"] = "Gyanis", Rizet = "Rizet", ["Ein-Fasit"] = "Gyanis", Laesan = "Gyanis"},
    Butterfly = {None = "Rizet", Gyanis = "Gyanis",  ["Vae-Sant"] = "Gyanis", Rizet = "Gyanis", ["Ein-Fasit"] = "Laesan", Laesan = "Rizet"},
    Flashkick = {None = "Rizet", Gyanis = "Rizet",  ["Vae-Sant"] = "Laesan", Rizet = "Rizet", ["Ein-Fasit"] = "Laesan", Laesan = "Vae-Sant"},
    Trip = {None = "Ein-Fasit", Gyanis = "Vae-Sant",  ["Vae-Sant"] = "Vae-Sant", Rizet = "Gyanis", ["Ein-Fasit"] = "Gyanis", Laesan = "Rizet"},
    Veinrip = {None = "None", Gyanis = "Ein-Fasit",  ["Vae-Sant"] = "Ein-Fasit", Rizet = "Gyanis", ["Ein-Fasit"] = "Laesan", Laesan = "Vae-Sant"},
    Feint = {None = "Ein-Fasit", Gyanis = "Ein-Fasit",  ["Vae-Sant"] = "Laesan", Rizet = "Rizet", ["Ein-Fasit"] = "Gyanis", Laesan = "Ein-Fasit"},
    Raze = {None = "Laesan", Gyanis = "Laesan",  ["Vae-Sant"] = "Vae-Sant", Rizet = "Vae-Sant", ["Ein-Fasit"] = "Rizet", Laesan = "Ein-Fasit"},
    Gouge = {None = "Laesan", Gyanis = "Ein-Fasit",  ["Vae-Sant"] = "Gyanis", Rizet = "Vae-Sant", ["Ein-Fasit"] = "Rizet", Laesan = "Laesan"},
    Bleed = {None = "None", Gyanis = "Laesan",  ["Vae-Sant"] = "Rizet", Rizet = "Ein-Fasit", ["Ein-Fasit"] = "Ein-Fasit", Laesan = "Vae-Sant"},
    Swiftkick = {None = "Gyanis", Gyanis = "Laesan",  ["Vae-Sant"] = "Ein-Fasit", Rizet = "Rizet", ["Ein-Fasit"] = "Vae-Sant", Laesan = "Rizet"},
    Beast = {None = "None", Gyanis = "Gyanis",  ["Vae-Sant"] = "Vae-Sant", Rizet = "Rizet", ["Ein-Fasit"] = "Ein-Fasit", Laesan = "Laesan"},
    Mindnumb = {None = "None", Gyanis = "Gyanis",  ["Vae-Sant"] = "Vae-Sant", Rizet = "Rizet", ["Ein-Fasit"] = "Ein-Fasit", Laesan = "Laesan"},
    Pheromones = {None = "None", Gyanis = "Gyanis",  ["Vae-Sant"] = "Vae-Sant", Rizet = "Rizet", ["Ein-Fasit"] = "Ein-Fasit", Laesan = "Laesan"},
}
	return stanceFlow[move][stance]
end

function predator.crescentcutMultiplier()
  local multi = 1
  local target = rime.target
  if (rime.pvp.has_aff("paresis", target) or rime.pvp.has_aff("paralysis", target)) then multi = multi + .15 end
  if rime.pvp.has_aff("left_leg_crippled", target) then multi = multi + .1 end
  if rime.pvp.has_aff("right_leg_crippled", target) then multi = multi + .1 end
  if rime.pvp.has_aff("left_arm_crippled", target) then multi = multi + .1 end
  if rime.pvp.has_aff("right_arm_crippled", target) then multi = multi + .1 end
  if rime.pvp.has_aff("prone") then multi = multi + .25 end
  if rime.pvp.has_aff("torso_broken", target) then multi = multi + .3 end
  if rime.pvp.has_aff("head_broken", target) then multi = multi + .3 end
  if rime.pvp.has_aff("left_leg_broken", target) then multi = multi + .35 end
  if rime.pvp.has_aff("right_leg_broken", target) then multi = multi + .35 end
  if rime.pvp.has_aff("left_arm_broken", target) then multi = multi + .35 end
  if rime.pvp.has_aff("right_arm_broken", target) then multi = multi + .35 end
  if rime.pvp.has_aff("head_mangled", target) then multi = multi + .5 end
  if rime.pvp.has_aff("torso_mangled", target) then multi = multi + .5 end
  --writhe affs
  for _, aff in pairs(rime.curing.affsByType.writhe) do
    if rime.pvp.has_aff(aff, target) then
      multi = multi + .15
      break
    end
  end
  return multi
end

function predator.attack_begin()
    --holds the string for our attack:
    local hitStr = ""

    --get the first attack by passing our current
    --stance (set in main):
    hitStr = predator.stance_attack(predator.stance)


    --okay, we have our first choice now. We want to check
    --if it's a c-c-c-combo!
    if predator.combo == true then
        local maxCLimit = 3;
        local cLimit = 1
        while cLimit < maxCLimit do
            --display(predator.stance)
            hitStr = hitStr.." "..predator.stance_attack(predator.stance)
            cLimit = cLimit+1
            if (climit == 3 and (predator.stance == "Laesan" or predator.stance == "Bladesurge")) then
              maxCLimit = 4;
            end
        end
    end

    return hitStr
end

function predator.stance_attack(stance)
    --just shorthand:
    local p = predator.knifeplay
    --generates an attack for the given stance, based on
    --other values.
    --display(predator.stance) -- debug display
    for k, v in pairs(rime.pvp.route.attacks[stance]) do
        --first case to evaluate: it's the starter == true attack. This is way easier!
        if p[v].starter == true and p[v].can() then
            predator.combo = p[v].combo
            predator.first = false
            predator.stance = predator.nextStance(p[v].type, predator.stance)
            if p[v].venom then predator.venom = p[v].venom end
            if p[v].used() then p[v].used() end
            return p[v].choice()
        elseif p[v].can() and p[v].starter == false and p[v].combo == true then
            predator.combo = p[v].combo
            predator.first = false
            predator.stance = predator.nextStance(p[v].type, predator.stance)
            if p[v].venom then predator.venom = p[v].venom end
            if p[v].used() then p[v].used() end
            return p[v].choice()
        end
    end
end

function predator.offense()
    --handle housekeeping here:
    local hitStr = "stand/touch dignitybecauseyoureafilthylifer/light pipes"

    --used for building combos:
    predator.combo = false --lets us know we can stack stuff!
    predator.first = true --whatever we pick is first
    predator.razing = false
    predator.venom = ""
    predator.temp_affs = table.deepcopy(rime.targets[rime.target].afflictions)
    predator.temp_limbs = table.deepcopy(rime.targets[rime.target].limbs)
    predator.temp_defs = table.deepcopy(rime.targets[rime.target].defences)

    local target = rime.target
    local sep = rime.saved.separator
    local queue = rime.pvp.queue_handle()
    local command = predator.attack_begin()
    --attack_begin first decides the type of attack, then
    --handles filling out the full string. It then returns
    --that full string here.
    --hitStr = queue.."/"..predator.attack_begin()

    if (predator.combo) then
      act(queue.. sep .. "series "..command.." "..rime.target.." " .. predator.venom .. sep..rime.pvp.post_queue())
    else
      act(queue.. sep .. command:gsub("target", rime.target).." " .. predator.venom .. sep..rime.pvp.post_queue())
    end
end
