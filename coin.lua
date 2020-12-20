local Player = require("player")

local Coin = {}
Coin.__index = Coin
local ActiveCoins = {}

function Coin.new(x, y)
    local instance = setmetatable({}, Coin)
    instance.x = x
    instance.y = y
    instance.img = love.graphics.newImage("assets/Items/coinGold.png")
    instance.width = instance.img:getWidth()
    instance.height = instance.img:getHeight()
    instance.scaleX = 1
    instance.randomTimeOffset = math.random(0, 100)

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    table.insert(ActiveCoins, instance)
end

function Coin:remove()
    for i, instance in ipairs(ActiveCoins) do
        if instance == self then
            Player:incrementCoins(1)
            Player:increaseScore(10)
            self.physics.body:destroy()
            table.remove(ActiveCoins, i)
        end
    end
end

function Coin:update(dt)
    self:spin(dt)
    self:checkRemove()
end

function Coin:checkRemove()
    if self.toBeRemoved then
        self:remove()
        self.playCoinSound()
    end
end

function Coin:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, 1, self.width / 2, self.height / 2)
end

function Coin.addAllCoinsAndRemovePrevious()
    ActiveCoins = {}

    if layerInMap("coins", Map) then
        for i, coinData in ipairs(Map.layers.coins.objects) do
            Coin.new(coinData.x, coinData.y)
        end
    end
end

function Coin.updateAll(dt)
    for i, instance in ipairs(ActiveCoins) do
        instance:update(dt)
    end
end

function Coin.drawAll()
    for i, instance in ipairs(ActiveCoins) do
        instance:draw()
    end
end

function Coin:spin(dt)
    self.scaleX = math.sin(love.timer.getTime() * 2 + self.randomTimeOffset)
end

function Coin.playCoinSound()
    Player.sounds.coin:clone():play()
end

function Coin.beginContact(firstBody, secondBody, collision)
    for i, instance in ipairs(ActiveCoins) do
        -- if one of the bodies are the a coin
        if firstBody == instance.physics.fixture or secondBody == instance.physics.fixture then
            -- and the other body is the player
            if firstBody == Player.physics.fixture or secondBody == Player.physics.fixture then
                -- remove the coin
                instance.toBeRemoved = true
                return true
            end
        end
    end
end

return Coin