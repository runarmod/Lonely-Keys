Player = {}

function Player:load()
    -- 1, 2 or 3
    self.character = 1
    self.direction = 1
    self.state = "jump"

    self.x = 100
    self.y = 0
    self.width = 70
    self.height = 90
    self.dx = 0
    self.dy = 0
    self.maxSpeed = 300
    self.acceleration = 3000
    self.friction = self.acceleration
    self.gravity = 3000
    self.jumpVel = 1000

    Map.camX = 0
    Map.camY = -3

    self.grounded = false

    -- we start midair, so we only have 1 jump remaining
    self.maxJumps = 2
    self.currentJumps = 1

    self:loadAssets()

    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.animation.draw:getWidth(), self.animation.draw:getHeight())
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
    self.physics.fixture:setDensity(8000)
    self.physics.fixture:setFriction(1)

end

function Player:loadAssets()
    self.animation = {
        timer = 0,
        rate = 0.1
    }

    self.animation.walk = {
        total = 11,
        current = 1,
        img = {}
    }

    for i = 1, self.animation.walk.total do
        self.animation.walk.img[i] = love.graphics.newImage("assets/Player/p" .. self.character .. "_walk/PNG/p" ..
                                                                self.character .. "_walk" .. string.format("%02d", i) ..
                                                                ".png")
    end

    self.animation.idle = {
        total = 1,
        current = 1,
        img = {}
    }

    for i = 1, self.animation.idle.total do
        self.animation.idle.img[i] = love.graphics.newImage("assets/Player/p" .. self.character .. "_stand.png")
    end

    self.animation.jump = {
        total = 1,
        current = 1,
        img = {}
    }

    for i = 1, self.animation.jump.total do
        self.animation.jump.img[i] = love.graphics.newImage("assets/Player/p" .. self.character .. "_jump.png")
    end

    self.animation.duck = {
        total = 1,
        current = 1,
        img = {}
    }

    for i = 1, self.animation.duck.total do
        self.animation.duck.img[i] = love.graphics.newImage("assets/Player/p" .. self.character .. "_duck.png")
    end

    self.animation.draw = self.animation[self.state].img[1]
    self.animation.width = self.animation.draw:getWidth()
    self.animation.height = self.animation.draw:getHeight()

end

function Player:update(dt)
    Map.camX = math.max(0, math.min(self.x - love.graphics.getWidth() / 2,
                   math.min(Map.tilewidth * Map.width - love.graphics.getWidth(), self.x)))
    Map.camY = math.max(0, math.min(self.y - love.graphics.getHeight() / 2,
                   math.min(Map.tileheight * Map.height - love.graphics.getHeight(), self.y)))

    self.animation.width = self.animation.draw:getWidth()
    self.animation.height = self.animation.draw:getHeight()

    self:setState()
    self:setDirection()
    self:animate(dt)
    self:syncPhysics()
    self:move(dt)
    self:applyGravity(dt)
    
end

function Player:setState()
    if love.keyboard.isDown("c", "lshift") then
        self.state = "duck"
    elseif not self.grounded then
        self.state = "jump"
    elseif self.dx == 0 then
        self.state = "idle"
    else
        self.state = "walk"
    end
end

function Player:setDirection()
    if self.dx > 0 then
        self.direction = 1
    elseif self.dx < 0 then
        self.direction = -1
    end
end

function Player:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:nextFrame()
    end
end

function Player:nextFrame()
    local anim = self.animation[self.state]
    anim.current = anim.current % anim.total + 1

    self.animation.draw = anim.img[anim.current]

    self.physics.shape:release()
    self.physics.shape = love.physics.newRectangleShape(self.animation.draw:getWidth(), self.animation.draw:getHeight())

    self.physics.fixture:destroy()
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)

end

function Player:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.dx, self.dy)
end

function Player:move(dt)
    --[[
        The reason that I did not do if, elseif, and else below, is
        so moving one side is not "favored". If both right and left
        is pressed, the player stand still rather than move left
        (or right) if all the 3 next if-statements were in if, elseif, else
    ]]

    local left = love.keyboard.isDown("a", "left")
    local right = love.keyboard.isDown("d", "right")

    if (not left and not right) or (left and right) then
        -- self:triggerFriction(dt)
        self.dx = 0
    end

    if left then
        self.dx = math.max(-self.maxSpeed, self.dx - self.acceleration * dt)
    elseif right then
        self.dx = math.min(self.maxSpeed, self.dx + self.acceleration * dt)
    end
end

function Player:triggerFriction(dt)
    if self.dx > 0 then
        self.dx = math.max(self.dx - self.friction * dt, 0)
    elseif self.dx < 0 then
        self.dx = math.min(self.dx + self.friction * dt, 0)
    end
end

function Player:applyGravity(dt)
    if not self.grounded then
        self.dy = self.dy + self.gravity * dt
    end
end

function Player:beginContact(firstBody, secondBody, collision)
    -- don't need to continue if we are already on the ground
    if self.grounded then
        return
    end

    local nx, ny = collision:getNormal()
    if firstBody == self.physics.fixture then
        if ny > 0 then
            self:land(collision)
        elseif ny < 0 then
            self.dy = 0
        end
    elseif secondBody == self.physics.fixture then
        if ny < 0 then
            self:land(collision)
        elseif ny > 0 then
            self.dy = 0
        end
    end
end

function Player:land(collision)
    self.currentGroundCollision = collision
    self.dy = 0
    self.grounded = true
    self.currentJumps = 0
end

function Player:jump(key)
    if (key == "up" or key == "w" or key == "space") and self.currentJumps < self.maxJumps then
        self.dy = -(self.jumpVel * (1 - self.currentJumps * 0.2))
        self.grounded = false
        self.currentJumps = self.currentJumps + 1
    end
end

function Player:endContact(firstBody, secondBody, collision)
    if firstBody == self.physics.fixture or secondBody == self.physics.fixture then
        if self.currentGroundCollision == collision then
            self.grounded = false
            -- waste 1 jump on falling of a surface
            self.currentJumps = 1
        end
    end
end

function Player:draw()
    love.graphics.draw(self.animation.draw, self.x, self.y, 0, self.direction, 1, self.animation.width / 2,
        self.animation.height / 2)
    print(self.animation.width, self.animation.height)
end
