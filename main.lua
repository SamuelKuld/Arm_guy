math.randomseed(os.time())

local game = require("game").new()


function love.load()
    love.mouse.setPosition(1000, 1000)
    game:load()
end

function love.draw()
    game:draw()
end

function love.keypressed(key)
    game:keypressed(key)
end

function love.update(dt)
    game:update(dt)
end
