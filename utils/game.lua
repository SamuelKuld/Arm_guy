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
    game.scaleX, game.scaleY = Screen_size[1] / 800, Screen_size[2] / 600
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

function Game:shoot()
    love.graphics.setColor(1, 0, 0, 1)
    if love.mouse.isDown("1") then
        local mouse_pos_x, mouse_pos_y = love.mouse.getPosition()
        love.graphics.print("mouse_x " .. tostring(mouse_pos_x))
        love.graphics.print("mouse_y " .. tostring(mouse_pos_y), 0, 10)
        love.graphics.print("player_x " .. tostring(self.player.x), 0, 20)
        love.graphics.print("player_y " .. tostring(self.player.y), 0, 30)
        local opposite = self.player.x - mouse_pos_x
        local adjacent = self.player.y - mouse_pos_y
        love.graphics.line(self.player.x, self.player.y, mouse_pos_x, self.player.y)
        love.graphics.line(mouse_pos_x, self.player.y, mouse_pos_x, mouse_pos_y)
        local angle = math.atan(opposite / adjacent)
        love.graphics.print("angle " .. tostring(angle), 0, 40)

        return love.graphics.line(self.player.x, self.player.y, mouse_pos_x, mouse_pos_y)
    end
    love.graphics.setColor(1, 1, 1, 1)
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
        self:shoot()
    end
end

return Game
