require("utils/settings")

Bullet = {}
Bullet.__index = Bullet
function Bullet.new(x, y, angle, speed, damage, owner)
    local self = setmetatable({}, Bullet)
    self.x_start = x
    self.y_start = y
    self.x_end = x + math.cos(angle) * 5
    self.y_end = y + math.sin(angle) * 5
    self.angle = angle
    self.speed = speed
    self.damage = damage
    self.owner = owner
    self.dead = false
    return self
end

function Bullet:draw()
    love.graphics.setColor(255, 0, 0)
    love.graphics.line(self.x_start, self.y_start, self.x_end, self.y_end)
end

function Bullet:update(dt)
    self.x_start = self.x_start + math.cos(self.angle) * self.speed * dt
    self.y_start = self.y_start + math.sin(self.angle) * self.speed * dt
    self.x_end = self.x_end + math.cos(self.angle) * self.speed * dt
    self.y_end = self.y_end + math.sin(self.angle) * self.speed * dt
    if self.x_end < 0 or self.x_end > Screen_size[1] or self.y_end < 0 or self.y_end > Screen_size[2] then
        self.dead = true
    end
    if self.dead == true then
        self = nil
    end
end

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
    game.bullets = {}
    game.shoot_timer1 = 0
    setmetatable(game, Game)
    return game
end

function Game:load()

end

function Game:keypressed(key)

end

function Game:slowY(dt)
    self.player.velocity.y = self.player.velocity.y - Movement_increment
end

function Game:speedY(dt)
    self.player.velocity.y = self.player.velocity.y + Movement_increment
end

function Game:slowX(dt)
    self.player.velocity.x = self.player.velocity.x - Movement_increment
end

function Game:speedX(dt)
    self.player.velocity.x = self.player.velocity.x + Movement_increment
end

function Game:checkKeys(dt)
    local keys_are_pressed = false
    if love.keyboard.isDown("w") then
        self:slowY(dt)
        keys_are_pressed = true
    end

    if love.keyboard.isDown("s") then
        self:speedY(dt)
        keys_are_pressed = true
    end

    if love.keyboard.isDown("d") then
        self:speedX(dt)
        keys_are_pressed = true
    end

    if love.keyboard.isDown("a") then
        self:slowX(dt)
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
    if love.mouse.isDown("1") and self.shoot_timer1 > .1 then
        local mouse_pos_x, mouse_pos_y = love.mouse.getPosition()
        love.graphics.print("mouse_x " .. tostring(mouse_pos_x))
        love.graphics.print("mouse_y " .. tostring(mouse_pos_y), 0, 10)
        love.graphics.print("player_x " .. tostring(self.player.x), 0, 20)
        love.graphics.print("player_y " .. tostring(self.player.y), 0, 30)

        table.insert(self.bullets,
            Bullet.new(self.player.x,
                self.player.y,
                math.atan2(mouse_pos_y - self.player.y,
                    mouse_pos_x - self.player.x),
                500, 500, self.player))
        self.shoot_timer1 = 0
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function Game:update(dt)
    self.shoot_timer1 = self.shoot_timer1 + dt
    local keys_are_not_pressed = not self:checkKeys(dt)
    local inverse_keys_pressed = Inverse_keys_pressed()
    self:handle_collision()
    self.player.x = self.player.x + self.player.velocity.x * dt
    self.player.y = self.player.y + self.player.velocity.y * dt

    if keys_are_not_pressed or inverse_keys_pressed then
        self.player.velocity.x = self.player.velocity.x / 1.1
        self.player.velocity.y = self.player.velocity.y / 1.1
    end

    for i, bullet in ipairs(self.bullets) do
        bullet:update(dt)
    end
end

function Game:draw()
    for i = 1, #self.drawable_objects do
        self.drawable_objects[i]:draw()
        self:shoot()
    end
    for i = 1, #self.bullets do
        self.bullets[i]:draw()
    end
end

return Game
