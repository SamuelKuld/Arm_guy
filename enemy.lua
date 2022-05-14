require("utils.adjustments")
Enemy = {}
Enemy.__index = Enemy

function Enemy.new(x, y, speed, health, damage, weapon, name, color, radius)
    local enemy = {}
    enemy.speed = speed or math.random(Min_enemy_speed, Max_enemy_speed)
    enemy.health = health
    enemy.damage = damage
    enemy.weapon = weapon
    enemy.timer = 0
    enemy.name = name
    enemy.color = color or { math.random(0, 100) * .01, math.random(0, 100) * .01, math.random(0, 100) * .01 }
    enemy.size = radius or math.random(Min_enemy_size, Max_enemy_size)
    enemy.is_dead = false
    enemy.is_hit_color = { 1, 1, 1 }
    enemy.is_hit_color_timer = 0
    enemy.velocity = { x = math.random(-Max_enemy_speed, Max_enemy_speed), y = math.random(-Max_enemy_speed, Max_enemy_speed) }
    enemy.x = x or math.random(0 + enemy.size, Screen_size[1] - enemy.size)
    enemy.y = y or math.random(0 + enemy.size, Screen_size[2] - enemy.size)
    setmetatable(enemy, Enemy)
    return enemy
end

function Enemy:add_random_velocity()
    self.velocity.x = self.velocity.x + math.random(-Max_enemy_speed, Max_enemy_speed)
    self.velocity.y = self.velocity.y + math.random(-Max_enemy_speed, Max_enemy_speed)
end

function Enemy:step_closer_to_player(Player)
    local x_diff = Player.x - self.x
    local y_diff = Player.y - self.y
    local distance = math.sqrt(x_diff * x_diff + y_diff * y_diff)
    if distance >= 101 then
        self.x = (self.x + (x_diff / distance) * self.speed)
        self.y = (self.y + (y_diff / distance) * self.speed)
    elseif distance < 99 then
        self.x = self.x
        self.y = self.y
    end
end

function Enemy:update(dt, player)
    self.timer = self.timer + dt
    if self.is_dead then
        return
    end
    if self.x > Screen_size[1] - self.size then
        self.x = Screen_size[1] - self.size
        self.velocity.x = -self.velocity.x
    end
    if self.x < 0 + self.size then
        self.x = 0 + self.size
        self.velocity.x = -self.velocity.x
    end
    if self.y > Screen_size[2] - self.size then
        self.y = Screen_size[2] - self.size
        self.velocity.y = -self.velocity.y
    end
    if self.y < 0 + self.size then
        self.y = 0 + self.size
        self.velocity.y = -self.velocity.y
    end
    self:step_closer_to_player(player)
end

function Enemy:draw()
    if self.is_dead then
        return
    end
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x, self.y, self.size)
end
