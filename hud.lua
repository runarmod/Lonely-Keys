HUD = {}

function HUD:load()
    self.shadowOffset = 3

    self.coin = {
        img = love.graphics.newImage("assets/HUD/hud_coins.png"),
        x = 300,
        y = 50
    }
    self.coin.width, self.coin.height = self.coin.img:getDimensions()

    self.key = {
        img = {
            disabled = {
                keyYellow = love.graphics.newImage("assets/HUD/hud_keyYellow_disabled.png"),
                keyBlue = love.graphics.newImage("assets/HUD/hud_keyBlue_disabled.png"),
                keyGreen = love.graphics.newImage("assets/HUD/hud_keyGreen_disabled.png"),
                keyRed = love.graphics.newImage("assets/HUD/hud_keyRed_disabled.png")
            },

            collected = {
                keyYellow = love.graphics.newImage("assets/HUD/hud_keyYellow.png"),
                keyBlue = love.graphics.newImage("assets/HUD/hud_keyBlue.png"),
                keyGreen = love.graphics.newImage("assets/HUD/hud_keyGreen.png"),
                keyRed = love.graphics.newImage("assets/HUD/hud_keyRed.png")
            }
        },
        x = 1200,
        y = 50
    }
    self.key.width, self.key.height = self.key.img.collected.keyYellow:getDimensions()


    self.FPS = {
        x = 50,
        y = 50
    }


    self.timer = {
        x = 550,
        y = 50,
        startTime = love.timer.getTime()
    }


    self.lives = {
        x = 800,
        y = 50,
        total = Player.lives,
        full = {
            img = love.graphics.newImage("assets/HUD/hud_heartFull.png")
        },
        half = {
            img = love.graphics.newImage("assets/HUD/hud_heartHalf.png")
        },
        empty = {
            img = love.graphics.newImage("assets/HUD/hud_heartEmpty.png")
        },
    }
    self.lives.width, self.lives.height = self.lives.full.img:getDimensions()

    
    self.score = {
        x = 1500,
        y = 50,
        value = Player.score
    }
end

function HUD:update(dt)
    HUD:updateFPS()
    HUD:updateTime()
    HUD:updateLives()
    HUD:updateScore(dt)
end

function HUD:updateFPS()
    self.FPS.value = love.timer.getFPS()
end

function HUD:updateTime()
    self.timer.currentTime = love.timer.getTime() - self.timer.startTime
end

function HUD:updateLives()
    self.lives.half.value = 1
    if Player.lives % 1 == 0 then
        self.lives.half.value = 0
    end

    self.lives.full.value = Player.lives - 0.5 * self.lives.half.value

    self.lives.empty.value = self.lives.total - self.lives.full.value - self.lives.half.value
end

function HUD:updateScore(dt)
    self.score.value = Player.score.value
end

function HUD:draw()
    HUD:drawFPS()
    HUD:drawCoin()
    HUD:drawCoinAmount()
    HUD:drawDisabledKeys()
    HUD:drawCollectedKeys()
    HUD:drawTime()
    HUD:drawLives()
    HUD:drawScore()
end

function HUD:drawFPS()
    local FPSDisplayText = "FPS: " .. self.FPS.value
    love.graphics.setFont(font.large)
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.print(FPSDisplayText, Map.camX + self.FPS.x + self.shadowOffset,
        Map.camY + self.FPS.y + self.shadowOffset)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(FPSDisplayText, Map.camX + self.FPS.x, Map.camY + self.FPS.y)
end

function HUD:drawCoin()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.draw(self.coin.img, Map.camX + self.coin.x + self.shadowOffset,
        Map.camY + self.coin.y + self.shadowOffset)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.coin.img, Map.camX + self.coin.x, Map.camY + self.coin.y)
end

function HUD:drawCoinAmount()
    local coinDisplayText = " : " .. Player.coins
    love.graphics.setFont(font.large)
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.print(coinDisplayText, Map.camX + self.coin.x + self.shadowOffset + self.coin.width,
        Map.camY + self.coin.y + self.shadowOffset)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(coinDisplayText, Map.camX + self.coin.x + self.coin.width, Map.camY + self.coin.y)
end

function HUD:drawDisabledKeys()
    local i = 1
    for _, playerAvailableKey in ipairs(Player.keys.available) do
        for keyName, currentKey in pairs(self.key.img.disabled) do
            if playerAvailableKey == keyName then
                local offset = (i - 1) * (self.key.width * 1.4)
                love.graphics.setColor(0, 0, 0, 0.5)
                love.graphics.draw(currentKey, Map.camX + self.key.x + self.shadowOffset + offset,
                    Map.camY + self.key.y + self.shadowOffset)
                love.graphics.setColor(1, 1, 1, 1)
                love.graphics.draw(currentKey, Map.camX + self.key.x + offset, Map.camY + self.key.y)
                i = i + 1
                break
            end
        end
    end
end

function HUD:drawCollectedKeys()
    local i = 1
    local doubleBreak = false
    for _, availableKeyName in ipairs(Player.keys.available) do
            for _, playerCollectedKey in ipairs(Player.keys.collected) do
                if availableKeyName == playerCollectedKey then
                    local offset = (i - 1) * (self.key.width * 1.4)
                    love.graphics.setColor(0, 0, 0, 0.5)
                    love.graphics.draw(self.key.img.collected[playerCollectedKey], Map.camX + self.key.x + self.shadowOffset + offset, Map.camY + self.key.y + self.shadowOffset)
                    love.graphics.setColor(1, 1, 1, 1)
                    love.graphics.draw(self.key.img.collected[playerCollectedKey], Map.camX + self.key.x + offset, Map.camY + self.key.y)
                    doubleBreak = true
                    break
                end
            end
        i = i + 1
    end
end

function HUD:drawTime()
    local timeDisplayText = string.format("Time: %.1f", self.timer.currentTime)
    love.graphics.setFont(font.large)
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.print(timeDisplayText, Map.camX + self.timer.x + self.shadowOffset,
        Map.camY + self.timer.y + self.shadowOffset)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(timeDisplayText, Map.camX + self.timer.x, Map.camY + self.timer.y)
end

function HUD:drawLives()
    HUD:drawFullLives()
    HUD:drawHalfLives()
    HUD:drawEmptyLives()
end

function HUD:drawFullLives()
    for i = 1, self.lives.full.value do
        local offset = (i - 1) * self.lives.width
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.draw(self.lives.full.img, Map.camX + self.lives.x + offset + self.shadowOffset,
            Map.camY + self.lives.y + self.shadowOffset)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.lives.full.img, Map.camX + self.lives.x + offset, Map.camY + self.lives.y)
    end
end

function HUD:drawHalfLives()
    for i = 1, self.lives.half.value do
        local offset = (i - 1) * self.lives.width + self.lives.full.value * self.lives.width
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.draw(self.lives.half.img, Map.camX + self.lives.x + offset + self.shadowOffset,
            Map.camY + self.lives.y + self.shadowOffset)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.lives.half.img, Map.camX + self.lives.x + offset, Map.camY + self.lives.y)
    end
end

function HUD:drawEmptyLives()
    for i = 1, self.lives.empty.value do
        local offset = (i - 1) * self.lives.width + self.lives.full.value * self.lives.width + self.lives.half.value * self.lives.width
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.draw(self.lives.empty.img, Map.camX + self.lives.x + offset + self.shadowOffset,
            Map.camY + self.lives.y + self.shadowOffset)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.lives.empty.img, Map.camX + self.lives.x + offset, Map.camY + self.lives.y)
    end
end

function HUD:drawScore()
    local scoreDisplayText = string.format("Score: %.0f", self.score.value)
    love.graphics.setFont(font.large)
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.print(scoreDisplayText, Map.camX + self.score.x + self.shadowOffset,
        Map.camY + self.score.y + self.shadowOffset)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(scoreDisplayText, Map.camX + self.score.x, Map.camY + self.score.y)
end