
local STI = require("sti")
require("util")
local scores = require("scores")
local Keybinds = require("keybinds")
local Player = require("player")
local Coin = require("coin")
local Key = require("key")
local Spike = require("spike")
local Cloud = require("cloud")
local HUD = require("hud")
local IntroHelp = require("introHelp")

music = love.audio.newSource('music/music.wav', 'stream')
music:setLooping(true)
music:setVolume(0.01)
music:play()

function love.load()
    -- prevent anti-aliasing
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    -- the sky background
    background = love.graphics.newImage("assets/background.png")
    
    font = {
        large = love.graphics.newFont("assets/upheavtt.ttf", 42),
        small = love.graphics.newFont("assets/upheavtt.ttf", 21)
    }

    hardRestart("intro")
end

function hardRestart(lvl)
    lvl = lvl or 1
    playthroughScores = {}
    playthroughHighscore = false
    win = false
    restart(lvl)
end

function restart(lvl)
    level = lvl or level or 1
    currentLevelHighscore = scores.levels["level" .. level].value
    Map = STI("map/" .. level .. ".lua", {"box2d"})
    World = love.physics.newWorld(0, 0)
    World:setCallbacks(beginContact, endContact)
    Map:box2d_init(World)
    
    hideObjectLayers()

    showDeathScreen = false

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
    print(stringifyTable(playthroughScores))
    print(stringifyTable(scores))
    if showDeathScreen or win then return end
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
    for _, keyBind in ipairs(Keybinds.quit) do
        if keyBind == key then
            saveHighscores()
            love.event.quit()
        end
    end

    for _, keyBind in ipairs(Keybinds.reload) do
        if keyBind == key then
            if win then
                hardRestart()
            else
                restart()
            end
            showDeathScreen = false
            win = false
        end
    end

    if showDeathScreen then return end

    Player:jump(key)

    for i = 1, 3 do
        for _, keyBind in ipairs(Keybinds["player" .. i]) do
            if key == keyBind then
                if Player.character ~= i then
                    Player.character = i
                    Player:loadAssets()
                end
            end
        end
    end
end

function love.draw()
    if showDeathScreen then
        drawDeathScreen()
    elseif win then
        drawWinScreen()
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
            if object.type ~= "open" then
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

function drawWinScreen()
    love.graphics.setBackgroundColor(0, 0, 0, 1)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(font.large)
    love.graphics.printf("YOU WON! Congratulations!", 1920 / 2, 1080 / 2 - 100, 1920, "center", 0, 1, 1, 1920 / 2)
    
    if playthroughHighscore then
        love.graphics.printf("You got a new playthrough highscore of " .. playthroughScores.total, 1920 / 2, 1080 / 2, 1920, "center", 0, 1, 1, 1920 / 2)
        love.graphics.setFont(font.small)
    else
        love.graphics.setFont(font.small)
        love.graphics.printf("You got a score of " .. playthroughScores.total, 1920 / 2, 1080 / 2, 1920, "center", 0, 1, 1, 1920 / 2)
        love.graphics.printf("Highscore is " .. scores.total.value .. os.date("\ncompleted %H. %b %y %X", scores.total.time), 1920 / 2, 1080 / 2 + 50, 1920, "center", 0, 1, 1, 1920 / 2)
    end
    love.graphics.printf("Press " .. getKeybindsToActionAsString("reload") .. " to restart", 1920 / 2, 1080 / 2 + 200, 1920, "center", 0, 1, 1, 1920 / 2)
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
    return toBeRounded >= 0 and math.floor(toBeRounded + 0.5) or math.ceil(toBeRounded - 0.5)
end
