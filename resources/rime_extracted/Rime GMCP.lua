rime.vitals.max_health = rime.vitals.max_health or 0
rime.vitals.max_mana = rime.vitals.max_mana or 0
rime.vitals.current_health = rime.vitals.current_health or 0
rime.vitals.current_mana = rime.vitals.current_mana or 0
rime.vitals.percent_health = rime.vitals.percent_health or 0
rime.vitals.percent_mana = rime.vitals.percent_mana or 0
rime.vitals.wielded_left = rime.vitals.wielded_left or 0
rime.vitals.wielded_right = rime.vitals.wielded_right or 0
rime.vitals.bleeding = rime.vitals.bleeding or 0

function rime.gmcp.getVitals()

	rime.vitals.max_health = tonumber(gmcp.Char.Vitals.maxhp) or 0
	rime.vitals.max_mana = tonumber(gmcp.Char.Vitals.maxmp) or 0
	rime.vitals.current_health = tonumber(gmcp.Char.Vitals.hp) or 0
	rime.vitals.current_mana = tonumber(gmcp.Char.Vitals.mp) or 0

	if not rime.has_aff("recklessness") and not rime.has_aff("blackout") then
		rime.vitals.percent_health = returnPercent(rime.vitals.current_health, rime.vitals.max_health) or 0
	end

	if not rime.has_aff("recklessness") and not rime.has_aff("blackout") then
		rime.vitals.percent_mana = returnPercent(rime.vitals.current_mana, rime.vitals.max_mana) or 0
	end

	rime.vitals.wielded_left = gmcp.Char.Vitals.wield_left or 0
	rime.vitals.wielded_right = gmcp.Char.Vitals.wield_right or 0
	rime.vitals.bleeding = tonumber(gmcp.Char.Vitals.bleeding) or 0
	rime.defences.general.cloak.deffed = gmcp.Char.Vitals.cloak == "1"

	rime.status.level = tonumber(string.match(gmcp.Char.Status.level, [[(%d*) %(%d*%%%)]]))

	if rime.has_aff("dead") then
		rime.vitals.dead = true
	else
		rime.vitals.dead = false
	end

	if gmcp.Char.Status.class == "Revenant" then
		rime.vitals.left_charge =  tonumber(gmcp.Char.Vitals.charge_left)
		rime.vitals.right_charge =  tonumber(gmcp.Char.Vitals.charge_right)
	end

	if gmcp.Char.Status.class == "Teradrim" then

		local stats = gmcp.Char.Vitals.charstats
		local spec = ""
		for i,v in ipairs(stats) do
			stat = string.split(v, ": ")
			if stat[1] == "Sandstorm" then
				rime.vitals.sandstorm = tonumber(stat[2])
			end
		end

	end

	for _, resource in ipairs({
		"fervour", "impurity", "shadowprice", "dithering", "ego",
	}) do
		rime.vitals[resource] = tonumber(gmcp.Char.Vitals[resource])
	end

	if gmcp.Char.Vitals.aspect then
		rime.vitals.aspect = gmcp.Char.Vitals.aspect
	end

	if gmcp.Char.Vitals.volatility or gmcp.Char.Vitals.energy then
		rime.vitals.volatility = tonumber(gmcp.Char.Vitals.volatility) or tonumber(gmcp.Char.Vitals.energy)
	end

	-- Specialized handling in the event we rename a GMCP var
	rime.balances.ability = gmcp.Char.Vitals.ability_bal == "1"
	rime.balances.equilibrium = gmcp.Char.Vitals.equilibrium == "1"
	rime.balances.balance = gmcp.Char.Vitals.balance == "1"
	rime.balances.pill = gmcp.Char.Vitals.herb == "1"
	rime.balances.poultice = gmcp.Char.Vitals.salve == "1"
	rime.defences.general.fangbarrier.deffed = gmcp.Char.Vitals.fangbarrier == "1"
	rime.vitals.prone = gmcp.Char.Vitals.prone == "1"

	-- Generic handling for non-renamed vars
	for _, b in ipairs({"tree", "elixir", "pipe", "affelixir", "focus", "moss"}) do
		rime.balances[b] = gmcp.Char.Vitals[b] == "1"
	end

	predator.stance = gmcp.Char.Vitals.knife_stance

	local writhes = {"mob_impaled", "writhe_vines", "writhe_impaled", "writhe_grappled", "writhe_web", "writhe_armpitlock", "writhe_necklock", "writhe_thighlock", "writhe_feed", "writhe_transfix", "writhe_bind", "writhe_noose", "writhe_ropes", "writhe_stasis", "writhe_gunk",}
	local foundWrithe = false
	for k,v in pairs(writhes) do
		if rime.has_aff(v) then
			foundWrithe = true
		end
	end

	if (rime.has_possible_aff("indifference") or rime.cure_set == "zealot" or rime.cure_set == "group") and gmcp.Char.Vitals.mounted == rime.saved.mount and rime.vitals.prone and not foundWrithe and not rime.has_aff("paralysis") and not rime.has_aff("asleep") and not rime.has_aff("stun") then
		rime.silent_addAff("indifference")
	elseif not rime.vitals.prone and rime.has_aff("indifference") then
		if rime.has_aff("indifference") then rime.silent_remAff("indifference") end
	end

	if gmcp.Char.Vitals.deaf == "1" then
		if rime.has_aff("deaf") then rime.silent_remAff("deaf") end
		rime.remove_possible_aff("deaf", "no_echo")
	else
		if rime.hidden_affs_total > 1 and rime.has_possible_aff("deaf") then
			rime.add_aff("deaf", "discovered")
		else
			rime.silent_addAff("deaf")
		end
	end

	if gmcp.Char.Vitals.blind == "1" then
		if rime.has_aff("blind") then rime.silent_remAff("blind") end
		rime.remove_possible_aff("blind", "no_echo")
	else
		if rime.hidden_affs_total > 1 and rime.has_possible_aff("blind") then
			rime.add_aff("blind", "discovered")
		else
			rime.silent_addAff("blind")
		end
	end



	rime.balances.writhing = rime.balances.writhing or false

	clot()

end

function rime.gmcp.getStatus()

	rime.status.class = gmcp.Char.Status.class
	rime.status.level = tonumber(string.match(gmcp.Char.Status.level, [[(%d*) %(%d*%%%)]]))
	if rime.status.class == "(None)" then rime.status.class = rime.saved.ascended_class end

end

