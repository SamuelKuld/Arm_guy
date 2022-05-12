require("utils/settings")

Bullet = {}
Bullet.__index = Bullet
function Bullet.new(x, y, angle, owner)
    local self = setmetatable({}, Bullet)
    self.x_start = x
    self.y_start = y
    self.x_end = x + math.cos(angle) * Bullet_size
    self.y_end = y + math.sin(angle) * Bullet_size
    self.angle = angle + (math.random(-Bullet_spread, Bullet_spread) * .01)
    self.speed = Bullet_speed
    self.damage = Bullet_damage
    self.Bullet_lifetime = math.random(-Bullet_lifetime, Bullet_lifetime * 10) * .01
    self.owner = owner
    self.Bullet_life = 0
    self.dead = false
    self.right = true
    return self
end

function Bullet:draw()
    if self.x_end < Screen_size[1] / 2 then love.graphics.print("Angle " .. self.angle, self.x_start, self.y_start)
    else love.graphics.print("Angle " .. self.angle, self.x_start - 100, self.y_start) end
    love.graphics.setColor(Bullet_color)
    love.graphics.line(self.x_start, self.y_start, self.x_end, self.y_end)
end

function Bullet:update(dt)
    self.Bullet_life = self.Bullet_life + dt
    if self.right then
        self.x_start = self.x_start + (math.cos(self.angle) * self.speed * dt) + Oscilation_size
        self.y_start = self.y_start + (math.sin(self.angle) * self.speed * dt) + Oscilation_size
        self.x_end = self.x_end + (math.cos(self.angle) * self.speed * dt) + Oscilation_size
        self.y_end = self.y_end + (math.sin(self.angle) * self.speed * dt) + Oscilation_size
        if math.random(0, 1) == 1 then
            self.right = false
        end
    else
        self.x_start = self.x_start + (math.cos(self.angle) * self.speed * dt) - Oscilation_size
        self.y_start = self.y_start + (math.sin(self.angle) * self.speed * dt) - Oscilation_size
        self.x_end = self.x_end + (math.cos(self.angle) * self.speed * dt) - Oscilation_size
        self.y_end = self.y_end + (math.sin(self.angle) * self.speed * dt) - Oscilation_size
        if math.random(0, 1) == 1 then
            self.right = true
        end
    end
    self.x_start = self.x_start + Wave_size
    self.x_end = self.x_end + Wave_size
    if self.y_end >= Screen_size[2] then
        self.y_start = Screen_size[2] - 1
        self.y_end = Screen_size[2] - 1
        self.angle = -(self.angle)
    end
    if self.y_end < 0 then
        self.y_start = 1
        self.y_end = 1
        self.angle = -(self.angle)
    end
    if self.y_end <= 0 then
        self.y_start = 1
        self.y_end = 1
        self.angle = self.angle / 2
    end
    if self.x_end >= Screen_size[1] then
        self.x_end = Screen_size[1] - 3
        self.x_start = Screen_size[1] - 3
        self.angle = self.angle - 1.12
    end
    if self.Bullet_life > self.Bullet_lifetime then
        self.dead = true
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
    if love.mouse.isDown("1") and self.shoot_timer1 > Bullet_delay then
        local mouse_pos_x, mouse_pos_y = love.mouse.getPosition()
        for i = 0, Bullet_amount do
            table.insert(self.bullets,
                Bullet.new(self.player.x,
                    self.player.y,
                    math.atan2(mouse_pos_y - self.player.y,
                        mouse_pos_x - self.player.x),
                    500))
            self.shoot_timer1 = 0
        end
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
    if math.random(0, 1) == 1 then
        Wave_size = -Wave_size
    end
    self:shoot()
    for i, bullet in ipairs(self.bullets) do
        bullet:update(dt)
        if bullet.dead then
            table.remove(self.bullets, i)
        end
    end
end

function Game:draw()
    local mouse_pos_x, mouse_pos_y = love.mouse.getPosition()
    love.graphics.print("mouse_x " .. tostring(mouse_pos_x))
    love.graphics.print("mouse_y " .. tostring(mouse_pos_y), 0, 10)
    love.graphics.print("player_x " .. tostring(self.player.x), 0, 20)
    love.graphics.print("player_y " .. tostring(self.player.y), 0, 30)
    love.graphics.print("Mouse angle " .. tostring(math.atan2(mouse_pos_y - self.player.y, mouse_pos_x - self.player.x)), 0, 40)
    for i = 1, #self.drawable_objects do
        self.drawable_objects[i]:draw()
    end
    for i = 1, #self.bullets do
        self.bullets[i]:draw()
    end
end

return Game
