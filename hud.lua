HUD = {}

function HUD:load()
    self.shadowOffset = 3
    self.font = love.graphics.newFont("assets/upheavtt.ttf", 42)

    self.coin = {}
    self.coin.img = love.graphics.newImage("assets/HUD/hud_coins.png")
    self.coin.height = self.coin.img:getHeight()
    self.coin.width = self.coin.img:getWidth()
    self.coin.x = 300
    self.coin.y = 50

    self.FPS = {}
    self.FPS.x = 50
    self.FPS.y = 50

    self.timer = {}
    self.timer.x = 550
    self.timer.y = 50
    self.timer.startTime = love.timer.getTime()
end

function HUD:update(dt)
    HUD:updateFPS()
    HUD:updateTime()
end

function HUD:updateFPS()
    self.FPS.value = love.timer.getFPS()
end

function HUD:updateTime()
    self.timer.currentTime = love.timer.getTime() - self.timer.startTime
end

function HUD:draw()
    HUD:drawFPS()
    HUD:drawCoin()
    HUD:drawCoinAmount()
    HUD:drawTime()
end

function HUD:drawFPS()
    local FPSDisplayText = "FPS: " .. self.FPS.value
    love.graphics.setFont(self.font)
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.print(FPSDisplayText, Map.camX + self.FPS.x + self.shadowOffset, Map.camY + self.FPS.y + self.shadowOffset)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(FPSDisplayText, Map.camX + self.FPS.x, Map.camY + self.FPS.y)
end

function HUD:drawCoin()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.draw(self.coin.img, Map.camX + self.coin.x + self.shadowOffset, Map.camY + self.coin.y + self.shadowOffset)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.coin.img, Map.camX + self.coin.x, Map.camY + self.coin.y)
end

function HUD:drawCoinAmount()
    local coinDisplayText = " : " .. Player.coins
    love.graphics.setFont(self.font)
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.print(coinDisplayText, Map.camX + self.coin.x + self.shadowOffset + self.coin.width, Map.camY + self.coin.y + self.shadowOffset)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(coinDisplayText, Map.camX + self.coin.x + self.coin.width, Map.camY + self.coin.y)
end

function HUD:drawTime()
    local timeDisplayText = string.format("Time: %.1f", self.timer.currentTime)
    love.graphics.setFont(self.font)
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.print(timeDisplayText, Map.camX + self.timer.x + self.shadowOffset, Map.camY + self.timer.y + self.shadowOffset)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(timeDisplayText, Map.camX + self.timer.x, Map.camY + self.timer.y)
end