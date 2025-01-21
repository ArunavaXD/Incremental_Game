coins = 0
coinsPerSecond = 1
multiplier = 1
multiplierCost = 1
multiplierPerSecond = 1
extra = 0
extraCost = 1
extraPerSecond = 1
boost = 0
boostCost = 1
boostPerSecond = 1
luck = 0
luckCost = 1
luckPerSecond = 1
increment = 0.5

buttonWidth, buttonHeight = 150, 75
buttons = {}
buttonHover = nil

function love.load()

    love.window.setTitle("Incremental Game")
    love.window.setMode(800, 600)

    font20 = love.graphics.newFont(20)

    buySound = love.audio.newSource("sounds/buttonClick.wav", "static")
    coinSound = love.audio.newSource("sounds/coinSound.wav", "static")
    coinSound:setVolume(0.1)

    function createButton(x, y, width, height, label, onClick)
        table.insert(buttons, {
            x = x,
            y = y,
            width = width,
            height = height,
            label = label,
            onClick = onClick,
        })
    end

        createButton(350, 120, buttonWidth, buttonHeight, "Click for Coins", function()
        coins = coins + coinsPerSecond * multiplier
        buySound:play()
    end)

    createButton(350, 250, buttonWidth, buttonHeight, "Buy Multiplier", function()
        if coins >= multiplierCost then
            coins = coins - multiplierCost
            multiplier = multiplier + increment
            multiplierCost = multiplierCost * 1.1
            buySound:play()
        end
    end)
        
    createButton(350, 320, buttonWidth, buttonHeight, "Buy Extra", function()
        if multiplier >= extraCost then
            multiplier = multiplier - extraCost
            extra = extra + increment
            extraCost = extraCost * 1.1
            buySound:play()
        end
    end)

    createButton(350, 390, buttonWidth, buttonHeight, "Buy Boost", function()
        if extra >= boostCost then
            extra = extra - boostCost
            boost = boost + increment
            boostCost = boostCost * 1.1
            buySound:play()
        end
    end)

    createButton(350, 460, buttonWidth, buttonHeight, "Buy Luck", function()
        if boost >= luckCost then
            boost = boost - luckCost
            luck = luck + increment 
            luckCost = luckCost * 1.1
            buySound:play()
        end
    end)

end

function love.update(dt)
    coins = coins + coinsPerSecond * multiplier * dt
    multiplier = multiplier + multiplierPerSecond * extra * dt
    extra = extra + extraPerSecond * boost * dt
    boost = boost + boostPerSecond * luck * dt 

    if math.floor(coins) > 0 and math.floor(coins) % 10 == 0 then
        coinSound:play()
    end

    buttonHover = nil
    local mouseX, mouseY = love.mouse.getPosition()

    for _, button in ipairs(buttons) do
        if mouseX >= button.x and mouseX <= button.x + button.width and
            mouseY >= button.y and mouseY <= button.y + button.height then
                buttonHover = button
        end
    end

end

function love.draw()
    love.graphics.setFont(font20)
    love.graphics.setColor(1, 1, 1)

    love.graphics.print("Coins: " .. string.format("%.2f", coins), 20, 50)
    love.graphics.print("Multiplier: " .. string.format("%.2f", multiplier), 20, 100)
    love.graphics.print("Extra: " .. string.format("%.2f", extra), 20, 150)
    love.graphics.print("Boost: " .. string.format("%.2f", boost), 20, 200)
    love.graphics.print("Luck: " .. string.format("%.2f", luck), 20, 250)

    for _, button in ipairs(buttons) do
        if button == buttonHover then
            love.graphics.setColor(0.8, 0.8, 0.8)
        else
            love.graphics.setColor(0, 0, 0)
        end
        love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)

        love.graphics.setColor(1, 1, 1)
        love.graphics.print(button.label, button.x + 5, button.y + 15)

        if button.label == "Buy Multiplier" then
            love.graphics.print("Price: " .. string.format("%.2f", multiplierCost), button.x + button.width + 10, button.y + 15)
        elseif button.label == "Buy Extra" then
            love.graphics.print("Price: " .. string.format("%.2f", extraCost), button.x + button.width + 10, button.y + 15)
        elseif button.label == "Buy Boost" then
            love.graphics.print("Price: " .. string.format("%.2f", boostCost), button.x + button.width + 10, button.y + 15)
        elseif button.label == "Buy Luck" then
            love.graphics.print("Price: " .. string.format("%.2f", luckCost), button.x + button.width + 10, button.y + 15)
        end
    end
end


function love.mousepressed(x, y, button, istouch, presses)
    for _, buttonObj in ipairs(buttons) do
        if x >= buttonObj.x and x <= buttonObj.x + buttonObj.width and
           y >= buttonObj.y and y <= buttonObj.y + buttonObj.height then
                buttonObj.onClick()
        end
    end 
end

function love.keypressed(key)

end
