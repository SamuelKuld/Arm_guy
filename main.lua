local game = require("utils/game").new()


function love.load()
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
