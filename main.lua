math.randomseed(os.time())

local game = require("game").new()
require("utils/adjustments")
local menu = require("menu").new()
local death = require("dead").new()

Screens = {
    game,
    menu,
    death
}
Current_screen = 2


function love.load()
    Screens[Current_screen]:load()
end

function love.draw()
    Screens[Current_screen]:draw()
end

function love.keypressed(key)
    Screens[Current_screen]:keypressed(key)
end

function love.update(dt)
    Screens[Current_screen]:update(dt)
end
