require("utils/adjustments")
require("enemy")

Wheel_Value = 0

function love.wheelmoved(x, y)
    if y < 0 and Wheel_Value > 0 then
        Wheel_Value = Wheel_Value + y * Scroll_multiplier
    elseif y > 0 then
        Wheel_Value = Wheel_Value + y * Scroll_multiplier
    end
end

Bullet = {}
Bullet.__index = Bullet
function Bullet.new(x, y, angle, owner, bullet_size)
    local self = setmetatable({}, Bullet)
    self.speed = Wheel_Value * 1000 + Bullet_speed
    self.angle = (angle + (math.random(-Bullet_spread, Bullet_spread) * .001))
    self.x_start = x + math.cos(self.angle) * self.speed * Bullet_size
    self.y_start = y + math.sin(self.angle) * self.speed * Bullet_size
    self.damage = Bullet_damage
    self.Bullet_lifetime = Bullet_lifetime
    self.owner = owner
    self.owner_gun = owner.weapon
    self.Bullet_life = 0
    self.dead = false
    self.right = true
    self.reflection_count = 0
    self.Bullet_size = bullet_size or Bullet_size
    return self
end

function Bullet:draw()
    love.graphics.setColor(Bullet_color)
    love.graphics.line(self.x_start,
        self.y_start,
        self.x_start - math.cos(self.angle) * self.speed * self.Bullet_size,
        self.y_start - math.sin(self.angle) * self.speed * self.Bullet_size
    )
end

function Bullet:update(dt)
    if self.speed < 600 * Bullet_death_speed_factor then
        self.dead = true
    end


    self.Bullet_life = self.Bullet_life + dt
    self.x_start = (self.x_start + (math.cos(self.angle) * dt * self.speed))
    self.y_start = (self.y_start + (math.sin(self.angle) * dt * self.speed))


    if self.y_start >= Screen_size[2] then
        self.y_start = Screen_size[2] - 1
        self.angle = -(self.angle) + math.random(-Reflection_innaccuracy, Reflection_innaccuracy) * .0001
        self.speed = self.speed - (.9 * Bullet_death_speed_factor)
        self.reflection_count = self.reflection_count + 1
    end
    if self.y_start <= 0 then
        self.y_start = 1
        self.angle = -(self.angle) + math.random(-Reflection_innaccuracy, Reflection_innaccuracy) * .0001
        self.speed = self.speed - (.9 * Bullet_speed_slow_factor)
        self.reflection_count = self.reflection_count + 1
    end
    -- Shooting left wall and shot from angle greater than 0 (Below the player)
    if self.x_start <= 0 and not (self.angle > 0) then
        self.x_start = 5
        self.angle = -math.pi - self.angle + math.random(-Reflection_innaccuracy, Reflection_innaccuracy) * .0001
        self.speed = self.speed - (.9 * Bullet_speed_slow_factor)
        self.reflection_count = self.reflection_count + 1
    elseif self.x_start <= 0 and self.angle > 0 then -- Shooting left wall and shot from angle less than 0 (Above the player)
        self.x_start = 5
        -- bounce off right wall
        self.angle = -math.pi - self.angle + math.random(-Reflection_innaccuracy, Reflection_innaccuracy) * .0001
        self.speed = self.speed - (.9 * Bullet_speed_slow_factor)
        self.reflection_count = self.reflection_count + 1
    end

    -- Shooting right wall and shot from angle greater than 0 (Below the player)
    if self.x_start > Screen_size[1] and self.angle > 0 then
        self.x_start = Screen_size[1] - 1
        self.angle = -math.pi - self.angle
        self.speed = self.speed - (.9 * Bullet_speed_slow_factor)
        self.reflection_count = self.reflection_count + 1
    elseif self.x_start > Screen_size[1] and self.angle < 0 then -- Shooting right wall and shot from angle less than 0 (Above the player)
        self.x_start = Screen_size[1] - 1
        self.angle = -math.pi - self.angle
        self.speed = self.speed - (.9 * Bullet_speed_slow_factor)
        self.reflection_count = self.reflection_count + 1
    end
    if self.Bullet_life > self.Bullet_lifetime then
        self.dead = true
    end
    if self.reflection_count == self.owner_gun.reflection_count then
        self.dead = true
    end
end

Player = {}
Player.__index = Player
function Player.new()
    local player = {}
    player.weapon = Weapons[1]()
    player.x = 0
    player.y = 0
    player.color = Player_color
    player.size = Player_size
    player.coordinate = { player.x, player.y }
    player.drawable_object = love.graphics.circle
    player.velocity = { x = 0, y = 0 }
    player.shoot_timer = 0
    player.bullets = {}
    setmetatable(player, Player)
    return player
end

function Player:draw()
    love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.color[4])
    self.drawable_object("fill", self.x, self.y, self.size)
end

function Player:change_weapon(weapon_template)
    local weapon_index = Weapons[weapon_template]
    if weapon_index == nil then
        self.weapon = Weapons[1]()
    else
        self.weapon = weapon_index()
    end


    Bullet_color = self.weapon.Bullet_color
    Bullet_speed = self.weapon.Bullet_speed
    Bullet_size = self.weapon.Bullet_size
    Bullet_damage = self.weapon.Bullet_damage
    Bullet_lifetime = self.weapon.Bullet_lifetime
    Bullet_spread = self.weapon.Bullet_spread
    Bullet_delay = self.weapon.Bullet_delay
    Bullet_amount = self.weapon.Bullet_amount
    Oscilation_size = self.weapon.Oscilation_size
    Wave_size = self.weapon.Wave_size
    Reflection_innaccuracy = self.weapon.Reflection_innaccuracy
    Bullet_random_speed_factor = self.weapon.Bullet_random_speed_factor
    Bullet_death_speed_factor = self.weapon.Bullet_death_speed_factor
    Bullet_speed_slow_factor = self.weapon.Bullet_speed_slow_factor
end

Game = {}
Game.__index = Game

function Game.new()
    local game = {}
    game.player = Player.new()
    game.width, game.height = love.graphics.getWidth(), love.graphics.getHeight()
    game.scaleX, game.scaleY = Screen_size[1] / 800, Screen_size[2] / 600
    game.player.size = game.scaleX * game.player.size
    love.window.setMode(Screen_size[1], Screen_size[2], { fullscreen = Full_screen })
    game.bullets = {}
    game.shoot_timer1 = 0
    game.player:change_weapon(1)
    game.current_weapon = 1
    game.enemies = {Enemy.new()}
    setmetatable(game, Game)
    return game
end

function Game:load()
    love.mouse.setVisible(false)
end

function Game:keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if key == "space" then
        if self.current_weapon == #Weapons then
            self.current_weapon = 1
            self.player:change_weapon(self.current_weapon)

        else
            self.current_weapon = self.current_weapon + 1
            self.player:change_weapon(self.current_weapon)
        end
    end
end

function Player:slowY(dt)
    self.velocity.y = self.velocity.y - Movement_increment
end

function Player:speedY(dt)
    self.velocity.y = self.velocity.y + Movement_increment
end

function Player:slowX(dt)
    self.velocity.x = self.velocity.x - Movement_increment
end

function Player:speedX(dt)
    self.velocity.x = self.velocity.x + Movement_increment
end

function Player:checkKeys(dt)
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

function Player:handle_collision()
    if self.y - self.size < 0 then
        self.y = self.size
        self.velocity.y = .001
    end
    if self.x - self.size < 0 then
        self.x = self.size
        self.velocity.x = .001
    end
    if self.x + self.size > love.graphics.getWidth() + .1 then
        self.x = love.graphics.getWidth() - self.size
        self.velocity.x = .001
    end
    if self.y + self.size > love.graphics.getHeight() + .1 then
        self.y = love.graphics.getHeight() - self.size
        self.velocity.y = .001
    end
end

function Player:shoot()
    if love.mouse.isDown("1") and self.shoot_timer > Bullet_delay then
        local mouse_pos_x, mouse_pos_y = love.mouse.getPosition()
        for i = 0, Bullet_amount do
            table.insert(self.bullets,
                Bullet.new(self.x,
                    self.y,
                    math.atan2(mouse_pos_y - self.y,
                        mouse_pos_x - self.x),
                    self, self.weapon.Bullet_size))
            self.shoot_timer = 0
        end
    end
end

function Player:update(dt)
    self.shoot_timer = self.shoot_timer + dt
    local keys_are_not_pressed = not self:checkKeys(dt)
    local inverse_keys_pressed = Inverse_keys_pressed()
    self.x = self.x + self.velocity.x * dt
    self.y = self.y + self.velocity.y * dt
    if keys_are_not_pressed or inverse_keys_pressed then
        self.velocity.x = self.velocity.x / 1.1
        self.velocity.y = self.velocity.y / 1.1
    end

    self:shoot()

    for i, bullet in ipairs(self.bullets) do
        bullet:update(dt)
        if bullet.dead then
            table.remove(self.bullets, i)
        end
    end
    self:handle_collision()
end

function Player:render_bullets()
    for i = 1, #self.bullets do
        self.bullets[i]:draw()
    end
end

function Game:update(dt)
    self.player:update(dt)
    for i, enemy in ipairs(self.enemies) do
        enemy:update(dt)
        if enemy.dead then
            table.remove(self.enemies, i)
        end
    end
end

function Render_mouse(x, y)
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.line(x, y + 2, x, y + 10)
    love.graphics.line(x, y - 2, x, y - 10)
    love.graphics.line(x + 2, y, x + 10, y)
    love.graphics.line(x - 2, y, x - 10, y)
    love.graphics.setColor(.5, .5, .5, 1)
    love.graphics.circle("line", x, y, Bullet_spread / 4)
    love.graphics.circle("line", x, y, Bullet_spread / 4)
end

function Game:draw()
    for enemy = 1, #self.enemies do
        self.enemies[enemy]:draw()
    end
    local mouse_pos_x, mouse_pos_y = love.mouse.getPosition()
    self.player:draw()
    self.player:render_bullets()
    Render_mouse(mouse_pos_x, mouse_pos_y)
end

return Game
