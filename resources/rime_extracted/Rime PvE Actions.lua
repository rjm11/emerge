rime.pve.actions = {

	["the Forgotten Dome"] = {

		["56106"] = {
			action = function()
				--Kelki turn in for Forgotten Dome
				if rime.pve.bashing then
					act("give 50 kelki to hoelth", "give 50 kelki to hoelth")
				end
			end
		},
	},

	["the Ayhesa Cliffs"] = {

		["19996"] = {
			action = function()
				if rime.pve.bashing then
					act("give 50 spellshaper to ephin", "give 50 spellshaper to ephin")
				end
			end
		},
	},

	["the Squal"] = {

		["59343"] = {
			action = function()
				if rime.pve.bashing then
					act("give 50 keeper to sutra", "give 50 keeper to sutra")
				end
			end
		}
	},

	["Yuzurai village"] = {

		["59993"] = {
			action = function()
				if rime.pve.bashing then
					act("give 50 rojalli to dakun", "give 50 rojalli to dakun")
				end
			end
		},
	},

	["the Three Rock Outpost"] = {

		["20330"] = {
			action = function()
				if rime.pve.bashing then
					act("give 50 horse to ugtar", "give 50 buffalo to ugtar")
				end
			end
		},

		["20581"] = {
			action = function()
				if rime.pve.bashing then
					act("give 50 wildcat to ennioch")
				end
			end
		},
	},

	["the Mamashi Tunnels"] = {

		["20921"] = {
			action = function()
				if rime.pve.bashing then
					act("give 50 githani to hecree")
				end
			end
		},
	},

	["the Prelatorian Highway"] = {

	},

	["the Dyisen-Ashtan Memoryscape"] = {

	},
}