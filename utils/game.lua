require("utils/settings")

Player = {}
Player.__index = Player
function Player.new()
    local player = {}
    player.x = 0
    player.y = 0
    player.color = Player_color
    player.size = Player_size
    player.coordinate = { player.x, player.y }
    player.drawable_object = love.graphics.circle
    player.velocity = { x = 0, y = 0 }
    setmetatable(player, Player)
    return player
end

function Player:draw()
    love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.color[4])
    self.drawable_object("fill", self.x, self.y, self.size)
end

Game = {}
Game.__index = Game

function Game.new()
    local game = {}
    game.player = Player.new()
    game.width, game.height = love.graphics.getWidth(), love.graphics.getHeight()
    game.scaleX, game.scaleY = Screen_size[1]/800, Screen_size[2]/600
    game.player.size = game.scaleX * game.player.size
    love.window.setMode(Screen_size[1], Screen_size[2])
    game.drawable_objects = { game.player }
    setmetatable(game, Game)
    return game
end

function Game:load()

end

function Game:keypressed(key)

end

function Game:slowY()
    self.player.velocity.y = self.player.velocity.y - Movement_increment
end

function Game:speedY()
    self.player.velocity.y = self.player.velocity.y + Movement_increment
end

function Game:slowX()
    self.player.velocity.x = self.player.velocity.x - Movement_increment
end

function Game:speedX()
    self.player.velocity.x = self.player.velocity.x + Movement_increment
end

function Game:checkKeys()
    local keys_are_pressed = false
    if love.keyboard.isDown("w") then
        self:slowY()
        keys_are_pressed = true
    end

    if love.keyboard.isDown("s") then
        self:speedY()
        keys_are_pressed = true
    end

    if love.keyboard.isDown("d") then
        self:speedX()
        keys_are_pressed = true
    end

    if love.keyboard.isDown("a") then
        self:slowX()
        keys_are_pressed = true
    end

    return keys_are_pressed
end

function Inverse_keys_pressed()
    local inverse_keys_pressed = false
    if love.keyboard.isDown("w") and love.keyboard.isDown("s") then
        inverse_keys_pressed = true
    end

    if love.keyboard.isDown("d") and love.keyboard.isDown("a") then
        inverse_keys_pressed = true
    end

    return inverse_keys_pressed
end

function Game:neither_velocities_too_slow()
    if (self.player.velocity.x < .001 and self.player.velocity.x > -.001) or
        (self.player.velocity.y < .001 and self.player.velocity.y > -.001) then
        return false
    end
    return true
end

function Game:handle_collision()
    if self.player.y - self.player.size < 0 then
        self.player.y = self.player.size
        self.player.velocity.y = .001
    end
    if self.player.x - self.player.size < 0 then
        self.player.x = self.player.size
        self.player.velocity.x = .001
    end
    if self.player.x + self.player.size > love.graphics.getWidth() + .1 then
        self.player.x = love.graphics.getWidth() - self.player.size
        self.player.velocity.x = .001
    end
    if self.player.y + self.player.size > love.graphics.getHeight() + .1 then
        self.player.y = love.graphics.getHeight() - self.player.size
        self.player.velocity.y = .001
    end
end

function Game:update(dt)
    local keys_are_not_pressed = not self:checkKeys()
    local inverse_keys_pressed = Inverse_keys_pressed()
    self:handle_collision()
    self.player.x = self.player.x + self.player.velocity.x
    self.player.y = self.player.y + self.player.velocity.y

    if keys_are_not_pressed or inverse_keys_pressed then
        self.player.velocity.x = self.player.velocity.x / 1.1
        self.player.velocity.y = self.player.velocity.y / 1.1
    end

end

function Game:draw()
    for i = 1, #self.drawable_objects do
        self.drawable_objects[i]:draw()
    end
end

return Game
