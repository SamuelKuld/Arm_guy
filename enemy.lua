require("utils.adjustments")
Enemy = {}
Enemy.__index = Enemy

function Enemy.new(x, y, speed, health, damage, weapon, name, color, radius)
    local enemy = {}
    enemy.speed = speed or math.random(Min_enemy_speed, Max_enemy_speed)
    enemy.health = health
    enemy.damage = damage
    enemy.weapon = weapon
    enemy.name = name
    enemy.color = color or { math.random(0, 100) * .01, math.random(0, 100) * .01, math.random(0, 100) * .01 }
    enemy.size = radius or math.random(Min_enemy_size, Max_enemy_size)
    enemy.is_dead = false
    enemy.is_hit_color = { 1, 1, 1 }
    enemy.is_hit_color_timer = 0
    enemy.velocity = { x = math.random(Min_enemy_speed, Max_enemy_speed), y = math.random(Min_enemy_speed, Max_enemy_speed) }
    enemy.x = x or math.random(0 + enemy.size, Screen_size[1] - enemy.size)
    enemy.y = y or math.random(0 + enemy.size, Screen_size[2] - enemy.size)
    setmetatable(enemy, Enemy)
    return enemy
end

function Enemy:update(dt)

    if self.is_dead then
        return
        self.x = self.x + self.velocity.x * dt
    end
    self.y = self.y + self.velocity.y * dt
    self.velocity.y = self.velocity.y + math.random(-self.velocity.y, self.velocity.y) * dt
    self.velocity.x = self.velocity.x + math.random(-self.velocity.y, self.velocity.x) * dt
    if self.x > Screen_size[1] - self.size then
        self.x = Screen_size[1] - self.size
        self.velocity.x = math.random(-self.velocity.x)
    end
    if self.x < 0 + self.size then
        self.x = 0 + self.size
        self.velocity.x = math.random(-self.velocity.x)
    end
    if self.y > Screen_size[2] - self.size then
        self.y = Screen_size[2] - self.size
        self.velocity.y = math.random(-self.velocity.y)
    end
    if self.y < 0 + self.size then
        self.y = 0 + self.size
        self.velocity.y = math.random(-self.velocity.y)
    end
end

function Enemy:draw()
    if self.is_dead then
        return
    end
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x, self.y, self.size)
end
