IntroHelp = {}

function IntroHelp:load()
    if level == "intro" then
        headBlocks = {{}, {}, {}}
        for i, object in ipairs(Map.layers.playerHeads.objects) do
            headBlocks[i].physics = {}
            headBlocks[i].physics.body = love.physics.newBody(World, object.x + object.width / 2, object.y + object.height / 2, "static")
            headBlocks[i].physics.shape = love.physics.newRectangleShape(object.width, object.height)
            headBlocks[i].physics.fixture = love.physics.newFixture(headBlocks[i].physics.body, headBlocks[i].physics.shape)
        end

        self.font = {}
        self.font.large = love.graphics.newFont("assets/upheavtt.ttf", 42)
        self.font.small = love.graphics.newFont("assets/upheavtt.ttf", 21)

        self.chooseCharacter = {}
        self.chooseCharacter.choose = "Choose character"
        self.chooseCharacter.change = "You can always change character by pressing 1, 2 or 3"
        for _, object in ipairs(Map.layers.playerHeads.objects) do
            if object.name == "2" then
                self.chooseCharacter.x = object.x + object.width / 2
                self.chooseCharacter.y = object.y - object.height
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
        self.collectingCoins.y = minYCoin
        self.collectingCoins.wrap = 400
    end
end

function IntroHelp:update(dt)
    if level == "intro" then

    end
end

function IntroHelp:draw()
    if level == "intro" then
        IntroHelp:drawChooseCharacter()
        IntroHelp:drawCoinInfo()
    end
end

function IntroHelp:drawChooseCharacter()
    love.graphics.setFont(self.font.large)
    love.graphics.printf(self.chooseCharacter.choose, self.chooseCharacter.x, self.chooseCharacter.y, self.chooseCharacter.wrap, "center", 0, 1, 1, self.chooseCharacter.wrap / 2, 50)
    love.graphics.setFont(self.font.small)
    love.graphics.printf(self.chooseCharacter.change, self.chooseCharacter.x, self.chooseCharacter.y, self.chooseCharacter.wrap, "center", 0, 1, 1, self.chooseCharacter.wrap / 2)
end

function IntroHelp:drawCoinInfo()
    love.graphics.setFont(self.font.large)
    love.graphics.printf(self.collectingCoins.text, self.collectingCoins.x, self.collectingCoins.y, self.collectingCoins.wrap, "center", 0, 1, 1, self.collectingCoins.wrap / 2, 200)
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
