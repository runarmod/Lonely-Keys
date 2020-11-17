HUD = {}

function HUD:load()
    self.shadowOffset = 3
    self.font = love.graphics.newFont("assets/upheavtt.ttf", 42)

    self.coin = {}
    self.coin.img = love.graphics.newImage("assets/HUD/hud_coins.png")
    self.coin.height = self.coin.img:getHeight()
    self.coin.width = self.coin.img:getWidth()
    self.coin.x = 50
    self.coin.y = 50
end

function HUD:update(dt)
    
end

function HUD:draw()
    HUD:drawCoin()
    HUD:drawCoinAmount()
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