coins = 0
coinsPerSecond = 1
multiplier = 1
multiplierCost = 1
multiplierPerSecond = 1
extra = 0
extraCost = 1
coinsPerSecond = 1

buttonWidth, buttonHeight = 100, 50
buttons = {}

function love.load()

    love.window.setTitle("Incremental Game")
    love.window.setMode(800, 600)

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

    createButton(350, 250, buttonWidth, buttonHeight, "Buy Multiplier", function()
        if coins >= multiplierCost then
            coins = coins - multiplierCost
            multiplier = multiplier + 0.1
            multiplierCost = multiplierCost * 1.5
            buySound:play()
        end
    end)
        
    createButton(350, 320, buttonWidth, buttonHeight, "Buy Extra", function()
        if multiplier >= extraCost then
            multiplier = multiplier - extraCost
            extra = extra + 0.1
            extraCost = extraCost * 1.5
            buySound:play()
        end
    end)

end

function love.update(dt)
    coins = coins + coinsPerSecond * multiplier * dt
    multiplier = multiplier + multiplierPerSecond * extra * dt

    if math.floor(coins) > 0 and math.floor(coins) % 10 == 0 then
        coinSound:play()
    end

end

function love.draw()
    
    love.graphics.setColor(1, 1, 1)

    love.graphics.print("Coins: " .. string.format("%.2f", coins), 20, 20)
    love.graphics.print("Multiplier: " .. string.format("%.2f", multiplier), 20, 50)
    love.graphics.print("Extra: " .. string.format("%.2f", extra), 20, 70)
    
    for _, button in ipairs(buttons) do
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)

        love.graphics.setColor(1, 1, 1)
        love.graphics.print(button.label, button.x + 5, button.y + 15)

        if button.label == "Buy Multiplier" then
            love.graphics.print("Price: " .. string.format("%.2f", multiplierCost), button.x + button.width + 10, button.y + 15)
        elseif button.label == "Buy Extra" then
            love.graphics.print("Price: " .. string.format("%.2f", extraCost), button.x + button.width + 10, button.y + 15)
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