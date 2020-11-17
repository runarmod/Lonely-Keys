local STI = require("sti")
require("player")
require("coin")
require("hud")

function love.load()
    Map = STI("map/1.lua", {"box2d"})
    World = love.physics.newWorld(0, 0)
    World:setCallbacks(beginContact, endContact)
    Map:box2d_init(World)

    Map.layers.solid.visible = false
    Map.layers.deadly.visible = false
    Map.layers.caveEntrance.visible = false
    Map.layers.caveExit.visible = false

    -- prevent anti-aliasing
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- the sky background
    background = love.graphics.newImage("assets1/sky.png")

    -- the mountain background
    mountains = {}
    mountains.one, mountains.two = {}, {}
    mountains.one.image = love.graphics.newImage("assets1/Mountains_1.png")
    mountains.two.image = love.graphics.newImage("assets1/Mountains_2.png")
    mountains.one.position, mountains.two.position = 0, 0

    Player:load()

    Coin.addAllCoins()

    HUD:load()
end

function love.update(dt)
    World:update(dt)
    Map:update(dt)
    Player:update(dt)
    Coin.updateAll(dt)
    HUD:update(dt)

    mountains.one.position = -(Map.camX * 0.25 - love.graphics.getWidth() / 4) % love.graphics.getWidth()
    mountains.two.position = -(Map.camX * 0.5 - love.graphics.getWidth() / 4) % love.graphics.getWidth()
end

function love.keypressed(key)
    Player:jump(key)

    if key == 'escape' then
        love.event.quit()
    elseif key == 'r' then
        love.load()
    end

    if key == '1' then
        if Player.character == 2 or Player.character == 3 then
            Player.character = 1
            Player:loadAssets()
            print("SPILLER 1")
        end
    end

    if key == '2' then
        if Player.character == 1 or Player.character == 3 then
            Player.character = 2
            Player:loadAssets()
            print("SPILLER 2")
        end
    end

    if key == '3' then
        if Player.character == 1 or Player.character == 2 then
            Player.character = 3
            Player:loadAssets()
            print("SPILLER 3")
        end
    end
end

function love.draw()
    -- -- draw the background with the sun
    love.graphics.draw(background, 0, 0, 0, love.graphics.getHeight() / background:getHeight())

    -- -- draw the two mountain-backgrounds
    for _, mountain in pairs(mountains) do
        love.graphics.draw(mountain.image, mountain.position, 0, 0,
            love.graphics.getWidth() / mountain.image:getWidth(), love.graphics.getHeight() / mountain.image:getHeight())
        love.graphics.draw(mountain.image, mountain.position - love.graphics.getWidth(), 0, 0,
            love.graphics.getWidth() / mountain.image:getWidth(), love.graphics.getHeight() / mountain.image:getHeight())
    end

    love.graphics.translate(math.round(-Map.camX), math.round(-Map.camY))
    
    Map:draw(-Map.camX, -Map.camY, 1, 1)
    -- love.graphics.push()
    -- love.graphics.scale(1, 1)

    Player:draw()
    Coin.drawAll()
    HUD:draw()

    -- love.graphics.pop()
end

function beginContact(firstBody, secondBody, collision)
    if Coin.beginContact(firstBody, secondBody, collision) then return end
    Player:beginContact(firstBody, secondBody, collision)
end

function endContact(firstBody, secondBody, collision)
    Player:endContact(firstBody, secondBody, collision)
end

function math.round(toBeRounded)
    return math.floor(toBeRounded + 0.5)
end
