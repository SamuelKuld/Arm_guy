Screen = {}
Screen.__index = Screen

function Screen.new(game_pointer)
    local screen = {}
    screen.game_pointer = game_pointer
    setmetatable(screen, Screen)
    return screen
end
function Screen.Change_screen(game_pointer)
    print("Changing Screen to 1")
    game_pointer.current_screen = 1
end
function Screen:draw()
    love.mouse.setVisible(true)
    love.graphics.setColor(0, .5, 0, 255)
    love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - 40, love.graphics.getHeight() / 2 - 85, 100, 100)
    love.graphics.setColor(.5, 0, 0, 255)
    love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - 40, love.graphics.getHeight() / 2 + 15, 100, 100)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("Play", (love.graphics.getWidth() / 2), love.graphics.getHeight() / 2 - 50)
    love.graphics.print("Quit", (love.graphics.getWidth() / 2), love.graphics.getHeight() / 2 + 50)
    love.graphics.print("Menu")
end

function Screen:update()
    if love.mouse.isDown('1') then
        if love.mouse.getX() > (love.graphics.getWidth() / 2) - 40 and
            love.mouse.getX() < (love.graphics.getWidth() / 2) + 60 and
            love.mouse.getY() > love.graphics.getHeight() / 2 - 85 and
            love.mouse.getY() < love.graphics.getHeight() / 2 + 15 then

            self.Change_screen(self.game_pointer)
        end
        if love.mouse.getX() > (love.graphics.getWidth() / 2) - 40 and
            love.mouse.getX() < (love.graphics.getWidth() / 2) + 60 and
            love.mouse.getY() > love.graphics.getHeight() / 2 - 15 and
            love.mouse.getY() < love.graphics.getHeight() / 2 + 115 then

            love.event.quit()
        end
    end
end

function Screen:load()

end

function Screen:keypressed(key)

end

return Screen
