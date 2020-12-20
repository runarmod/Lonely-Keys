local scores = require("scores")
local Keybinds = require("keybinds")

function changeLevel(localLevel)
    level = localLevel
    love.load()
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
    local highscoresFile = io.open("scores.lua", "w")
    highscoresFile:write("return " .. tostring(stringifyTable(scores)))
    highscoresFile:close()
end

function stringifyTable(table, tabs)
    local numElementInTable = 1
    local tabs = tabs or 1
    local tabsString = ""
    local tab = "    "

    -- indentation (number of tabs)
    for i=1, tabs - 1 do
        tabsString = tabsString .. tab
    end

    local tableString =  "{\n"

    for key, value in pairs(table) do
        tableString = tableString .. tabsString .. tab .. key .. " = "

        -- if next element is a table, stringify that table
        if type(value) == "table" then
            tableString = tableString .. stringifyTable(value, tabs + 1)
        else
            -- else just add the value
            tableString = tableString .. value
        end
        
        -- if not last element in table, add a comma
        if numElementInTable ~= lengthOfTable(table) then
            tableString = tableString .. ",\n"
        end

        numElementInTable = numElementInTable + 1
    end

    return tableString .. "\n" .. tabsString .. "}"
end

function lengthOfTable(table)
    local length = 0
    for _, __ in pairs(table) do
        length = length + 1
    end
    return length
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