Menu = {}
Menu.__index = Menu

local play_image = love.graphics.newImage("play.jpg", {})
local quit_image = love.graphics.newImage("quit.jpg", {})






function Menu.new()
    local menu = {}
    setmetatable(menu, Menu)
    menu.selections = {
        { "fill", love.graphics.getWidth() / 2 - play_image:getWidth() / 2 - 5, (love.graphics.getHeight() / 2 - quit_image:getHeight() - 150) - 5, play_image:getWidth() + 10, play_image:getHeight() + 10 },
        { "fill", love.graphics.getWidth() / 2 - quit_image:getWidth() / 2 - 5, (love.graphics.getHeight() / 2) + 95, quit_image:getWidth() + 10, quit_image:getHeight() + 10 }
    }
    menu.current_selection = 1
    return menu

end


function Menu:Draw_current_selection()
    return self.selections[self.current_selection]
end


function Menu:draw()
    love.graphics.setColor(.5,0,0)
    local args = self:Draw_current_selection()
    love.graphics.rectangle(args[1], args[2], args[3], args[4], args[5])
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(play_image, love.graphics.getWidth() / 2 - play_image:getWidth() / 2, (love.graphics.getHeight() / 2 - quit_image:getHeight() - 150))
    love.graphics.draw(quit_image, love.graphics.getWidth()/2 - quit_image:getWidth()/2, (love.graphics.getHeight()/2 ) + 100)

end

function Menu:load()

end

function Menu:update(dt)

end

function Menu:keypressed(key)
    if key == "return" and self.current_selection == 1 then
        love.mouse.setVisible(false)
        Current_screen = 1
    elseif key == "return" and self.current_selection == 2 then
        love.event.quit()
    end
    if key == "down" or key == "s" then
        self.current_selection = self.current_selection + 1
        if self.current_selection > #self.selections then
            self.current_selection = 1
        end
    end
    if key == "up" or key == "w" then
        self.current_selection = self.current_selection - 1
        if self.current_selection < 1 then
            self.current_selection = #self.selections
        end
    end
end

return Menu