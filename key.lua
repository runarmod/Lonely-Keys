local Player = require("player")

local Key = {}
Key.__index = Key
local ActiveKeys = {}

local keyImages = {
    keyYellow = love.graphics.newImage("assets/Items/keyYellow.png"),
    keyBlue = love.graphics.newImage("assets/Items/keyBlue.png"),
    keyGreen = love.graphics.newImage("assets/Items/keyGreen.png"),
    keyRed = love.graphics.newImage("assets/Items/keyRed.png")
}

function Key.new(key, x, y)
    local instance = setmetatable({}, Key)
    instance.x = x
    instance.y = y
    instance.name = key
    instance.img = keyImages[key]
    instance.randomTimeOffset = math.random(0, 100)

    instance.width = instance.img:getWidth()
    instance.height = instance.img:getHeight()

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    table.insert(ActiveKeys, instance)
end

function Key:remove()
    for i, instance in ipairs(ActiveKeys) do
        if instance == self then
            Player:addKey(instance.name)
            self.physics.body:destroy()
            table.remove(ActiveKeys, i)
        end
    end
end

function Key:update(dt)
    self:levitate(dt)
    self:checkRemove()
end

function Key:checkRemove()
    if self.toBeRemoved then
        self:remove()
        self.playKeySound()
    end
end

function Key:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, 1, self.width / 2, self.height / 2)
end

function Key.addAllKeysAndRemovePrevious()
    ActiveKeys = {}

    if layerInMap("keys", Map) then
        for i, KeyData in ipairs(Map.layers.keys.objects) do
            Key.new(KeyData.name, KeyData.x, KeyData.y)
        end
    end
end

function Key.updateAll(dt)
    for i, instance in ipairs(ActiveKeys) do
        instance:update(dt)
    end
end

function Key.drawAll()
    for i, instance in ipairs(ActiveKeys) do
        instance:draw()
    end
end

function Key:levitate(dt)
    self.y = self.y - math.sin(love.timer.getTime() * 3 + self.randomTimeOffset) / 30
end

function Key.playKeySound()
    Player.sounds.key:clone():play()
end

function Key.beginContact(firstBody, secondBody, collision)
    for i, instance in ipairs(ActiveKeys) do
        -- if one of the bodies are the a Key
        if firstBody == instance.physics.fixture or secondBody == instance.physics.fixture then
            -- and the other body is the player
            if firstBody == Player.physics.fixture or secondBody == Player.physics.fixture then
                -- remove the Key
                instance.toBeRemoved = true
                return true
            end
        end
    end
end

return Key