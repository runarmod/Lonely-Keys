
local STI = require("sti")
local scores = require("scores")
require("keybinds")
require("player")
require("coin")
require("key")
require("spike")
require("cloud")
require("hud")
require("introHelp")

level = "intro"

music = love.audio.newSource('music/music.wav', 'stream')
music:setLooping(true)
music:setVolume(0.01)
music:play()

function love.load()
    levelHighscore = scores.levels["level" .. level].value
    Map = STI("map/" .. level .. ".lua", {"box2d"})
    World = love.physics.newWorld(0, 0)
    World:setCallbacks(beginContact, endContact)
    Map:box2d_init(World)

    hideObjectLayers()

    -- prevent anti-aliasing
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- the sky background
    background = love.graphics.newImage("assets/background.png")

    showDeathScreen = false

    font = {
        large = love.graphics.newFont("assets/upheavtt.ttf", 42),
        small = love.graphics.newFont("assets/upheavtt.ttf", 21)
    }

    Player:load()

    Coin.addAllCoinsAndRemovePrevious()
    Key.addAllKeysAndRemovePrevious()
    Spike.addAllSpikesAndRemovePrevious()
    Cloud.addAllCloudsAndRemovePrevious()

    HUD:load()

    IntroHelp:load()

    loadDoorImages()
end

function love.update(dt)
    if showDeathScreen then return end
    World:update(dt)
    Map:update(dt)
    Player:update(dt)
    Coin.updateAll(dt)
    Key.updateAll(dt)
    Spike.updateAll(dt)
    Cloud.updateAll(dt)
    HUD:update(dt)
    IntroHelp:update(dt)
end

function love.keypressed(key)
    for _, keyBind in ipairs(keybinds.quit) do
        if keyBind == key then
            saveHighscores()
            love.event.quit()
        end
    end

    for _, keyBind in ipairs(keybinds.reload) do
        if keyBind == key then
            love.load()
            showDeathScreen = false
        end
    end

    if showDeathScreen then return end

    Player:jump(key)

    for _, keyBind in ipairs(keybinds.player1) do
        if key == keyBind then
            if Player.character == 2 or Player.character == 3 then
                Player.character = 1
                Player:loadAssets()
            end
        end
    end

    for _, keyBind in ipairs(keybinds.player2) do
        if key == keyBind then
            if Player.character == 1 or Player.character == 3 then
                Player.character = 2
                Player:loadAssets()
            end
        end
    end

    for _, keyBind in ipairs(keybinds.player3) do
        if key == keyBind then
            if Player.character == 1 or Player.character == 2 then
                Player.character = 3
                Player:loadAssets()
            end
        end
    end
end

function love.draw()
    if showDeathScreen then
        drawDeathScreen()
    else
        -- draw the background with the sun
        love.graphics.draw(background)

        love.graphics.translate(math.round(-Map.camX), math.round(-Map.camY))
        
        Cloud.drawAll()
        Spike.drawAll()
        Map:draw(-Map.camX, -Map.camY, 1, 1)
        drawDoors()

        Player:draw()
        Coin.drawAll()
        Key.drawAll()
        HUD:draw()
        IntroHelp:draw()
    end
end

function drawDoors()
    local topDoor = doorClosedTop
    local midDoor = doorClosedMid

    if Player.allKeysCollected then
        topDoor = doorOpenTop
        midDoor = doorOpenMid
    end

    for i, object in ipairs(Map.layers.startEnd.objects) do
        if object.name == "end" then
            if object.x > 200 then
                love.graphics.draw(topDoor, object.x, object.y - 35)
                love.graphics.draw(midDoor, object.x, object.y + 35)
            end
        end
    end
end

function drawDeathScreen()
    love.graphics.setBackgroundColor(0, 0, 0, 1)
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.setFont(font.large)
    love.graphics.printf("You died!", 1920 / 2, 1080 / 2, 1920, "center", 0, 1, 1, 1920 / 2)
    love.graphics.setFont(font.small)
    love.graphics.printf("Press " .. getKeybindsToActionAsString("reload") .. " to restart", 1920 / 2, 1080 / 2 + 100, 1920, "center", 0, 1, 1, 1920 / 2)
end

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

function layerInMap(layer, map)
    for i, locallayer in ipairs(map.layers) do
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

    -- indentation (number of tabs)
    for i=1, tabs - 1 do
        tabsString = tabsString .. "\t"
    end

    local tableString =  "{\n"

    for key, value in pairs(table) do
        tableString = tableString .. tabsString .. "\t" .. key .. " = "

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

function loadDoorImages()
    doorClosedTop = love.graphics.newImage("assets/Tiles/door_closedTop.png")
    doorClosedMid = love.graphics.newImage("assets/Tiles/door_closedMid.png")
    doorOpenTop = love.graphics.newImage("assets/Tiles/door_openTop.png")
    doorOpenMid = love.graphics.newImage("assets/Tiles/door_openMid.png")
end

function beginContact(firstBody, secondBody, collision)
    if Coin.beginContact(firstBody, secondBody, collision) then return end
    if Key.beginContact(firstBody, secondBody, collision) then return end
    if Spike.beginContact(firstBody, secondBody, collision) then return end
    if Cloud.beginContact(firstBody, secondBody, collision) then return end
    IntroHelp.beginContact(firstBody, secondBody, collision)
    Player:beginContact(firstBody, secondBody, collision)
end

function endContact(firstBody, secondBody, collision)
    Player:endContact(firstBody, secondBody, collision)
end

function math.round(toBeRounded)
    return math.floor(toBeRounded + 0.5)
end
