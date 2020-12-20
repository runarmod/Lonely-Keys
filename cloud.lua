local Player = require("player")

local Cloud = {}
Cloud.__index = Cloud
local ActiveClouds = {}

function Cloud.new(x, y)
    local instance = setmetatable({}, Cloud)
    instance.x = x
    instance.y = y
    instance.speed = math.random(50, 100)
    instance.img = love.graphics.newImage("assets/Items/cloud" .. math.random(1, 3) .. ".png")
    instance.width = instance.img:getWidth()
    instance.height = instance.img:getHeight()

    instance.randomTimeOffset = math.random(0, 100)

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    table.insert(ActiveClouds, instance)
end

function Cloud:update(dt)
    self.x = self.x - self.speed * dt
    if self.x < Map.camX - self.width then
        self.x = Map.camX + self.width + 1920
    end
    self.y = self.y - math.sin(love.timer.getTime() * 3 + self.randomTimeOffset) / 30
end

function Cloud:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, 1, self.width / 2, self.height / 2)
end

function Cloud.addAllCloudsAndRemovePrevious()
    ActiveClouds = {}

    if layerInMap("clouds", Map) then
        for i, cloudData in ipairs(Map.layers.clouds.objects) do
            Cloud.new(cloudData.x, cloudData.y)
        end
    end
end

function Cloud.updateAll(dt)
    for i, instance in ipairs(ActiveClouds) do
        instance:update(dt)
    end
end

function Cloud.drawAll()
    for i, instance in ipairs(ActiveClouds) do
        instance:draw()
    end
end

function Cloud.beginContact(firstBody, secondBody, collision)
    for i, instance in ipairs(ActiveClouds) do
        -- if one of the bodies are a cloud
        if firstBody == instance.physics.fixture or secondBody == instance.physics.fixture then
            -- and the other body is the player
            if firstBody == Player.physics.fixture or secondBody == Player.physics.fixture then
                return true
            end
        end
    end
end

return Cloud