local Keybinds = require("keybinds")

function split(str, sep)
    local str = str or ""
    local s = ""
    local mathces = {}
    for i=1, #str do
        local c = str:sub(i,i)
        if c == sep then
            table.insert(mathces, s)
            s = ""
        else
            s = s .. c
        end
    end
    table.insert(mathces, s)
    return mathces
end

function getScores()
    local file = io.open("scores.txt", "r")
    local score = {levels = {}, total = {}}
    local lvl = ""

    for line in file:lines() do
        if line == "" then break end
        if not string.find(line, "time") and not string.find(line, "value")then
            lvl = line
            if line ~= "total" then
                score.levels[lvl] = {}
            end
        elseif string.find(line, "time") then
            if lvl == "total" then
                score.total.time = tonumber(split(line, "=")[2])
            else
                score.levels[lvl].time = tonumber(split(line, "=")[2])
            end
        elseif string.find(line, "value") then
            if lvl == "total" then
                score.total.value = tonumber(split(line, "=")[2])
            else
                score.levels[lvl].value = tonumber(split(line, "=")[2])
            end
        end
    end

    return score
end

function hideObjectLayers()
    for i, layer in ipairs(Map.layers) do
        if layer.type == "objectgroup" then
            layer.visible = false
        end
    end
end

function layerInMap(layer)
    for i, locallayer in ipairs(Map.layers) do
        if locallayer.name == layer then return true end
    end
    return false
end

function saveHighscores()
    local highscoresFile = io.open("scores.txt", "w")
    highscoresFile:write(lineifyTable(scores.levels) .. "total\n" .. lineifyTable(scores.total))
    highscoresFile:close()
end

function lineifyTable(table)
    local tableString =  ""
    
    for key, value in pairs(table) do
        tableString = tableString .. key
        
        -- if next element is a table, stringify that table
        if type(value) == "table" then
            tableString = tableString .. "\n" .. lineifyTable(value)
        else
            -- else just add the value
            tableString = tableString .. "=" .. value .. "\n"
        end
    end

    return tableString
end

function getKeybindsToActionAsString(action)
    local keys = ""
    local numberOfKeysToAction = #Keybinds[action]

    for i, key in ipairs(Keybinds[action]) do
        local separator = ", "
        if i == numberOfKeysToAction then
            separator = ""
        elseif i == numberOfKeysToAction - 1 then
            separator = " or "
        end
        keys = keys .. key .. separator
    end
    
    return keys
end