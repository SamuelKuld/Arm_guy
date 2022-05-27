Menu = {}
Menu.__index = Menu


function Menu.new()
    local menu = {}
    setmetatable(menu, Menu)
    return menu
end

function Menu:draw()

end

function Menu:load()

end

function Menu:update(dt)

end

function Menu:keypressed(key)

end

return Menu