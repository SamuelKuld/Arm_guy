Game_over = {}
Game_over.__index = Game_over
function Change_screen(game_pointer)
    game_pointer.current_screen = 3
end

function Game_over.new(game_pointer)
    local Game_over = {}
    Game_over.game_pointer = game_pointer
    setmetatable(Game_over, Game_over)
    return Game_over
end

function Game_over:draw()
    love.mouse.setVisible(true)
    love.graphics.setColor(0, .5, 0, 255)
    love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - 40, love.graphics.getHeight() / 2 - 85, 100, 100)
    love.graphics.setColor(.5, 0, 0, 255)
    love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - 40, love.graphics.getHeight() / 2 + 15, 100, 100)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("Play", (love.graphics.getWidth() / 2), love.graphics.getHeight() / 2 - 50)
    love.graphics.print("Score : " ..  self.game_pointer.score, (love.graphics.getWidth() / 2), love.graphics.getHeight() / 2 + 50)
    love.graphics.print("game_over")
end

function Game_over:update()
    if love.mouse.isDown('1') then
        if love.mouse.getX() > (love.graphics.getWidth() / 2) - 40 and
            love.mouse.getX() < (love.graphics.getWidth() / 2) + 60 and
            love.mouse.getY() > love.graphics.getHeight() / 2 - 85 and
            love.mouse.getY() < love.graphics.getHeight() / 2 + 15 then

        end
        if love.mouse.getX() > (love.graphics.getWidth() / 2) - 40 and
            love.mouse.getX() < (love.graphics.getWidth() / 2) + 60 and
            love.mouse.getY() > love.graphics.getHeight() / 2 - 15 and
            love.mouse.getY() < love.graphics.getHeight() / 2 + 115 then

        end
    end
end

function Game_over:load()

end

function Game_over:keypressed(key)

end

return Game_over
