local Keybinds = require("keybinds")
local Player = require("player")

local IntroHelp = {}
local headBlocks = {{}, {}, {}}

function IntroHelp:load()
    if level == "intro" then
        for i, object in ipairs(Map.layers.playerHeads.objects) do
            headBlocks[i].physics = {}
            headBlocks[i].physics.body = love.physics.newBody(World, object.x + object.width / 2, object.y + object.height / 2, "static")
            headBlocks[i].physics.shape = love.physics.newRectangleShape(object.width, object.height)
            headBlocks[i].physics.fixture = love.physics.newFixture(headBlocks[i].physics.body, headBlocks[i].physics.shape)
        end

        self.yLevelInfo = 455

        self.keybinds = {}
        self.keybinds.title = "General keybinds:"
        self.keybinds.text = {}
        self.keybinds.text.right = "Right: " .. getKeybindsToActionAsString("right")
        self.keybinds.text.left = "Left: " .. getKeybindsToActionAsString("left")
        self.keybinds.text.jump = "Jump: " .. getKeybindsToActionAsString("jump")
        self.keybinds.text.duck = "Duck: " .. getKeybindsToActionAsString("duck")
        self.keybinds.text.restart = "Restart level: " .. getKeybindsToActionAsString("reload")
        self.keybinds.text.quit = "Quit: " .. getKeybindsToActionAsString("quit")
        self.keybinds.text.nextLevel = "Next level: " .. getKeybindsToActionAsString("nextLevel")
        self.keybinds.x = 200
        self.keybinds.height = font.large:getHeight(self.keybinds.title) / 1.3
        self.keybinds.width = font.large:getWidth(self.keybinds.title)
        self.keybinds.wrap = self.keybinds.width

        self.wastingTime = {}
        self.wastingTime.text = "The longer time you use, the lower score you get"
        self.wastingTime.x = Map.layers.time.objects[1].x
        self.wastingTime.wrap = 380
        
        self.earlyExit = {}
        self.earlyExit.text = "Skip tutorial"
        for i, object in ipairs(Map.layers.startEnd.objects) do
            if object.name == "end" then
                if not self.earlyExit.x then
                    self.earlyExit.x = object.x + object.width / 2
                    self.earlyExit.y = object.y - 30
                end
                if object.x < self.earlyExit.x then
                    self.earlyExit.x = object.x + object.width / 2
                    self.earlyExit.y = object.y - 30
                end
            end
        end
        self.earlyExit.wrap = 200

        self.chooseCharacter = {}
        self.chooseCharacter.choose = "Choose character"
        self.chooseCharacter.change = "You can always change character by pressing one of " .. Keybinds.player1[1] .. ", " .. Keybinds.player2[1] .. " or " .. Keybinds.player3[1]
        for _, object in ipairs(Map.layers.playerHeads.objects) do
            if object.name == "2" then
                self.chooseCharacter.x = object.x + object.width / 2
                break
            end
        end
        self.chooseCharacter.wrap = 400

        self.collectingCoins = {}
        self.collectingCoins.text = "Collecting coins earns you a higher score"
        local minXCoin = Map.layers.coins.objects[1].x
        local maxXCoin = minXCoin
        local minYCoin = Map.layers.coins.objects[1].y
        for _, object in ipairs(Map.layers.coins.objects) do
            if object.x > maxXCoin then
                maxXCoin = object.x
            end
            if object.x < minXCoin then
                minXCoin = object.x
            end
            if object.y < minYCoin then
                minYCoin = object.y
            end
        end
        self.collectingCoins.x = minXCoin + (maxXCoin - minXCoin) / 2
        self.collectingCoins.wrap = 400

        self.duck = {}
        self.duck.keys = getKeybindsToActionAsString("duck")
        self.duck.text = "You can duck under tight spaces with " .. self.duck.keys
        self.duck.x = Map.layers.duck.objects[1].x
        self.duck.wrap = 400

        self.collectingKeys = {}
        self.collectingKeys.text = "Collect all the keys to unlock the door to the next level"
        self.collectingKeys.x = Map.layers.keys.objects[1].x
        self.collectingKeys.wrap = 400

        self.pressE = {}
        self.pressE.text = "Press " .. Keybinds.nextLevel[1] .. " to go to the next level when in front of a door"
        for i, object in pairs(Map.layers.startEnd.objects) do
            if object.name == "end" then
                if not self.pressE.x then
                    self.pressE.x = object.x + object.width / 2
                end
                if object.x > self.pressE.x then
                    self.pressE.x = object.x + object.width / 2
                end
            end
        end
        self.pressE.wrap = 400
    end
end

function IntroHelp:update(dt)
    if level == "intro" then

    end
end

function IntroHelp:draw()
    if level == "intro" then
        IntroHelp:drawKeybinds()
        IntroHelp:drawEarlyExit()
        IntroHelp:drawChooseCharacter()
        IntroHelp:drawCollectingCoins()
        IntroHelp:drawWastingTime()
        IntroHelp:drawDuck()
        IntroHelp:drawCollectingKeys()
        IntroHelp:drawPressE()
    end
end

function IntroHelp:drawKeybinds()
    love.graphics.setFont(font.large)
    love.graphics.printf(self.keybinds.title, self.keybinds.x, self.yLevelInfo, self.keybinds.wrap, "center")
    love.graphics.setFont(font.small)
    local i = 1
    for action, keyBindText in pairs(self.keybinds.text) do
        love.graphics.printf(keyBindText, self.keybinds.x, self.yLevelInfo + self.keybinds.height * i + 10, self.keybinds.wrap, "center")
        i = i + 1
    end
end

function IntroHelp:drawEarlyExit()
    love.graphics.setFont(font.small)
    love.graphics.printf(self.earlyExit.text, self.earlyExit.x, self.earlyExit.y, self.earlyExit.wrap, "center", 0, 1, 1, self.earlyExit.wrap / 2)
end

function IntroHelp:drawChooseCharacter()
    love.graphics.setFont(font.large)
    love.graphics.printf(self.chooseCharacter.choose, self.chooseCharacter.x, self.yLevelInfo, self.chooseCharacter.wrap, "center", 0, 1, 1, self.chooseCharacter.wrap / 2)
    love.graphics.setFont(font.small)
    love.graphics.printf(self.chooseCharacter.change, self.chooseCharacter.x, self.yLevelInfo, self.chooseCharacter.wrap, "center", 0, 1, 1, self.chooseCharacter.wrap / 2, -75)
end

function IntroHelp:drawCollectingCoins()
    love.graphics.setFont(font.large)
    love.graphics.printf(self.collectingCoins.text, self.collectingCoins.x, self.yLevelInfo, self.collectingCoins.wrap, "center", 0, 1, 1, self.collectingCoins.wrap / 2)
end

function IntroHelp:drawWastingTime()
    love.graphics.setFont(font.large)
    love.graphics.printf(self.wastingTime.text, self.wastingTime.x, self.yLevelInfo, self.wastingTime.wrap, "center", 0, 1, 1, self.wastingTime.wrap / 2)
end

function IntroHelp:drawDuck()
    love.graphics.setFont(font.large)
    love.graphics.printf(self.duck.text, self.duck.x, self.yLevelInfo, self.duck.wrap, "center", 0, 1, 1, self.duck.wrap / 2)
end

function IntroHelp:drawCollectingKeys()
    love.graphics.setFont(font.large)
    love.graphics.printf(self.collectingKeys.text, self.collectingKeys.x, self.yLevelInfo, self.collectingKeys.wrap, "center", 0, 1, 1, self.collectingKeys.wrap / 2)
end

function IntroHelp:drawPressE()
    love.graphics.setFont(font.large)
    love.graphics.printf(self.pressE.text, self.pressE.x, self.yLevelInfo, self.pressE.wrap, "center", 0, 1, 1, self.pressE.wrap / 2)
end

function IntroHelp.beginContact(firstBody, secondBody, collision)
    for i, instance in ipairs(headBlocks) do
        -- if one of the bodies are a Block
        if firstBody == instance.physics.fixture or secondBody == instance.physics.fixture then
            -- and the other body is the player
            if firstBody == Player.physics.fixture or secondBody == Player.physics.fixture then
                Player.character = i
                Player:loadAssets()
            end
        end
    end
end

return IntroHelp