math.randomseed(os.time())

local game = require("game").new()
require("utils.adjustments")

function love.load()
    print("Attempting to load  screen " .. game.current_screen)
    love.window.setFullscreen(Full_screen)
    game.screens[game.current_screen]:load()
end

function love.draw()
    print("Attempting to draw  screen " .. game.current_screen)
    game.screens[game.current_screen]:draw()
end

function love.keypressed(key)
    if key == "escape" then
        game.current_screen = game.current_screen + 1
        if game.current_screen > #game.screens then
            game.current_screen = 1
        end
    else
        game.screens[game.current_screen]:keypressed(key)
    end
end

function love.update(dt)
    print("Attempting to update  screen " .. game.current_screen)
    game.screens[game.current_screen]:update(dt)
end
