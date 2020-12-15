
Spike = {img = love.graphics.newImage("assets/Items/spikes.png")}
Spike.__index = Spike

Spike.width = Spike.img:getWidth()
Spike.height = Spike.img:getHeight()

ActiveSpikes = {}

function Spike.new(x, y)
    local instance = setmetatable({}, Spike)
    instance.x = x
    instance.y = y
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x + instance.width / 2, instance.y + instance.height / 2, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    table.insert(ActiveSpikes, instance)
end

function Spike:update(dt)
end

function Spike:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, 0, self.height / 2)
end

function Spike.addAllSpikesAndRemovePrevious()
    ActiveSpikes = {}

    if layerInMap("spikes", Map) then
        for i, spikeData in ipairs(Map.layers.spikes.objects) do
            Spike.new(spikeData.x, spikeData.y)
        end
    end
end

function Spike.updateAll(dt)
    for i, instance in ipairs(ActiveSpikes) do
        instance:update(dt)
    end
end

function Spike.drawAll()
    for i, instance in ipairs(ActiveSpikes) do
        instance:draw()
    end
end

function Spike.beginContact(firstBody, secondBody, collision)
    for i, instance in ipairs(ActiveSpikes) do
        -- if one of the bodies are a spike
        if firstBody == instance.physics.fixture or secondBody == instance.physics.fixture then
            -- and the other body is the player
            if firstBody == Player.physics.fixture or secondBody == Player.physics.fixture then
                -- play hurtsound and damage Player
                Player:takeDamage(0.5)
                return true
            end
        end
    end
end
