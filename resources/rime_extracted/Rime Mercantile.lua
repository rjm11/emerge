
rime.mercantile = rime.mercantile or {}

rime.mercantile.floor_price = {}

rime.mercantile.enchantment = {

	["meteor_wanted"] = 0,
	["meteor"] = 0,
	["worrystone_wanted"] = 0,
	["worrystone"] = 0,
	["discernment_wanted"] = 0,
	["discernment"] = 0,
	["whirlwind_wanted"] = 0,
	["whirlwind"] = 0,

}

rime.mercantile.bombcrafting = {

	crafting = 0,
	current_craft = "nothing",

	commodity_prices = {
		["sulphur"] = 100,
		["clay"] = 20,
	},
	materials = {
		["sonicbomb"] = {
			clay = 1,
			obsidian = 2,
			sulphur = 3,
		},
		["fusebomb"] = {
			ashes = 1,
			clay = 1,
			sulphur =1,
		},
		["shockwave"] = {
			iron = 5,
			ashes = 3,
			sulphur = 2,
		},
	}
}

function rime.mercantile.bombcrafting.bomb_ingredients(bomb, number)

	number = tonumber(number)

	if not rime.mercantile.bombcrafting.materials[bomb] then rime.echo("Don't know how to make that!", "merchant") return end
	if not number then number = 1 end

	local to_do = {}
	local short_mats = rime.mercantile.bombcrafting.materials[bomb]

	for k,v in pairs(short_mats) do
		if k == "ashes" then k = "ash" end
		table.insert(to_do, "outc "..tonumber(v*number).." "..k)
	end

	rime.mercantile.bombcrafting.crafting = number
	rime.mercantile.bombcrafting.current_craft = bomb

	act("qeb "..table.concat(to_do, rime.saved.separator), "bomb construct "..bomb)

end

function rime.mercantile.bombcrafting.pricing(bomb)

	local short_mats = rime.mercantile.bombcrafting.materials[bomb]
	local cost_to_make = 0

	for k,v in pairs(short_mats) do
		if k == "ashes" then k = "ash" end
		if rime.mercantile.bombcrafting.commodity_prices[k] then
			cost_to_make = cost_to_make+(tonumber(v)*tonumber(rime.mercantile.bombcrafting.commodity_prices[k]))
		elseif rime.saved.commodity_prices[k.."_average"] then
			cost_to_make = cost_to_make+(tonumber(v)*tonumber(rime.saved.commodity_prices[k.."_average"]))
		end
	end

	cost_to_make = cost_to_make/5

	rime.echo("It costs you "..cost_to_make.." gold to make 1 "..bomb, "merchant")

end

function rime.mercantile.bombcrafting.craft_bomb()

	if rime.mercantile.bombcrafting.crafting > 0 then
		act("qeb bomb construct "..rime.mercantile.bombcrafting.current_craft)
	end

end



function rime.mercantile.enchant(number, item)

	rime.mercantile.enchantment[item.."_wanted"] = tonumber(number)

	rime.echo("<red>" .. number .. "<purple> " .. item .." <white>queued to enchant.")

end

function rime.mercantile.commodity_check(commodity)


	if commodity then

		rime.saved.commodity[commodity.."_average"] = {}

		for k,v in pairs(rime.saved.commodity) do
  			if rime.saved.commodity[k][commodity] then
    			table.insert(rime.saved.commodity[commodity.."_average"], rime.saved.commodity[k][commodity])
  			end
		end

		local average_price = math.floor(getAverage(rime.saved.commodity[commodity.."_average"]))

		rime.echo("The average price listed for "..commodity.." is "..average_price.." gold.", "merchant")
		rime.echo("You have bought "..commodity.." at an average of "..math.floor(rime.saved.commodity_prices[commodity.."_average"]).." gold.", "merchant")

		local cost_difference = math.floor(average_price-rime.saved.commodity_prices[commodity.."_average"])

		if cost_difference < 0 then

			rime.echo("You've paid <red>"..cost_difference.." gold<white> extra per piece of "..commodity.." than the market average.", "merchant")

		else

			rime.echo("You've paid <green>"..cost_difference.." gold<white> less per piece of "..commodity.." than the market average.", "merchant")

		end

	else

		for k,v in pairs(rime.saved.commodity) do
			rime.saved.commodity[k.."_average"] = {}
		end

		rime.echo("Reset the average for everything!", "merchant")

	end

end

function priceItems(type, price, shelf)
	priceprice = price
	priceshelf = shelf
	for k, v in pairs(priceItem) do
		if v == type then 
			send("drop " .. k)
			send("shop price item " .. k .. " " .. price .. " shelf " .. shelf)
		end
	end 
end


function priceCache(price, shelf)
	for k,v in pairs(curativePills) do
		send("shop price cache " .. v .. " ".. price .. " shelf " .. shelf)
	end
end


function priceFurniture()
	local timertime = 0
    for shelf in ipairs(furnitureDesigns) do
        for k,v in pairs(furnitureDesigns[shelf]) do
        	tempTimer(timertime, function() send("shop unprice design " .. k) end)
        	timertime = timertime+.2
			tempTimer(timertime, function() send("shop price design "..k.." "..v.." shelf "..shelf) end)
        end
    end
end

function priceFood()
	local timertime = 0
    for shelf in ipairs(foodDesigns) do
        for k,v in pairs(foodDesigns[shelf]) do
        	tempTimer(timertime, function() send("shop unprice design " .. k) end)
        	timertime = timertime+.2
			tempTimer(timertime, function() send("shop price design "..k.." "..v.." shelf "..shelf) end)
        end
    end
end

function priceClothing()
    for shelf in ipairs(clothingDesigns) do
        for k,v in pairs(clothingDesigns[shelf]) do
            send ("shop unprice design " .. k)
						send ("shop price design "..k.." "..v.." shelf "..shelf)
        end
    end
end

rime.minipets = rime.minipets or {}
rime.minipets.extra = {}
rime.minipets.info_gather = false

function rime.minipets.add(pet)

	if not rime.saved.minipets then
		rime.saved.minipets = {}
		rime.echo("No minipets were detected, created saved list.")
		rime.echo("Please remember that this does not track duplicates")
	end

	if not table.contains(rime.saved.minipets, pet) then
		table.insert(rime.saved.minipets, pet)
		rime.echo("Added <deep_pink>"..pet.."<white> to rime.saved.minipets")
	end

end

--[[function rime.mercantile.shop_log(item)

    if not rime.saved.shop_log then
        rime.saved.shop_log = {}
        rime.echo("No shop log was detected, so making one!", "merchant")
    end

    if not rime.saved.shop_log[date] then
        rime.saved.shop_log[date] = {}
        rime.echo("No log entries for "..date.." found, starting an entry for it.", "merchant")
    end

	if not rime.saved.shop_log[item] then
		rime.saved.shop_log[item] = {
			["amount"] = amount,
			["gold"] = gold,
			[]
	end

	if not rime.saved.shop_log[buyer] then
		rime.saved.shop_log[buyer] = {}
		rime.echo("")

end]]