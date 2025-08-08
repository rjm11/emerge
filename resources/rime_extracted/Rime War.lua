rime.war = rime.war or {}
rime.war.engine = rime.war.engine or ""

rime.saved.militia = rime.saved.militia or {}
rime.saved.militia.enorian = rime.saved.militia.enorian or {}
rime.saved.militia.duiran = rime.saved.militia.duiran or {}
rime.saved.militia.spinesreach = rime.saved.militia.spinesreach or {}
rime.saved.militia.bloodloch = rime.saved.militia.bloodloch or {}
rime.saved.militia.highlights = rime.saved.militia.highlights or {}
rime.saved.militia.colours = {
    enorian = "gold",
    duiran = "yellow_green",
    bloodloch = "a_darkred",
    spinesreach = "turquoise",
} or {}

function rime.addMilitia(militiaList, city)
    rime.saved.militia[city] = {}
    for name in string.gmatch(militiaList, '([^ ]+)') do
        table.insert(rime.saved.militia[city], string.title(name))
    end
    rime.echo("Added"..militiaList.." to "..string.title(city).."!","war")
end

function rime.updateMilitia(city)
    if rime.saved.militia[city] == nil then
        rime.echo("Incorrect city specified. Please check your spelling.","war")
        return
    end
    local militiaList = ""
    local tempID = tempRegexTrigger("(^[a-zA-Z, ]+)$", function () local playerList = matches[1]:gsub(",", ""); militiaList = militiaList .. " " .. playerList end)
    tempPromptTrigger(function() killTrigger(tempID); rime.addMilitia(militiaList, city) end,1) --kills above trigger after the first promptTrigger, which runs only once.
    act("mwho "..city)

end

function rime.displayMilitiaMembers()
    local cities = {"enorian", "duiran", "bloodloch","spinesreach"}
    cecho("<DodgerBlue>Currently known members of city militia:\n")
    cecho("<DodgerBlue>----------------------------------------\n")
    for _, c in spairs(cities) do
        if rime.saved.militia[c] ~= nil then
            cecho("<"..rime.saved.militia.colours[c]..">"..string.title(c).." (".. table.size(rime.saved.militia[c])..")<reset>\n"..table.concat(rime.saved.militia[c],", ").."\n")
        end
    end
end

function rime.resetMilitiaMembers()
    local cities = {"enorian", "duiran", "bloodloch","spinesreach"}
    for _, c in spairs(cities) do 
        rime.saved.militia[c] = {}
    end
    rime.echo("Militia members reset for all cities!")
end

function rime.displayMilitiaColours()
    local cities = {"enorian", "duiran", "bloodloch","spinesreach"}
    cecho("<DodgerBlue>Colours for militia tracking:\n")
    cecho("<DodgerBlue>-----------------------------\n")
    for _, c in spairs(cities) do
        cecho("  "..string.title(c)..": <"..rime.saved.militia.colours[c]..">"..rime.saved.militia.colours[c].."\n")
    end
    cecho("<DodgerBlue>-----------------------------\n")
end

function rime.setMilitiaColours(city, colour)
    rime.saved.militia.colours[city] = colour
    rime.echo("Colour for "..string.title(city).." set to <"..colour..">"..colour,"war")
end

function rime.militiaHighlight()
    local cities = {"enorian", "duiran", "bloodloch","spinesreach"}
    for _, c in spairs(cities) do
        for k, v in pairs(rime.saved.militia[c]) do
            table.insert(rime.saved.militia.highlights, tempTrigger(v, [[selectString("]] .. v .. [[", 1) fg("]]..rime.saved.militia.colours[c]..[[") resetFormat()]]))
        end
    end
    rime.echo("Militia highlights enabled.","war")    
end

function rime.removeMilitiaHighlight()
    for k, v in pairs(rime.saved.militia.highlights) do
        killTrigger(v)
    end
    rime.saved.militia.highlights = {}
    rime.echo("Militia highlights removed.","war")
end