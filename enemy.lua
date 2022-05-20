require("utils.adjustments")
Enemy = {}
Enemy.__index = Enemy

function Enemy.new(x, y, speed, health, damage, weapon, name, color, radius)
    local enemy = {}
    Entities = Entities + 1
    enemy.speed = speed or math.random(Min_enemy_speed, Max_enemy_speed)
    enemy.size = radius or math.random(Min_enemy_size, Max_enemy_size)
    enemy.health = health or enemy.size / 10
    enemy.damage = damage
    enemy.weapon = weapon
    enemy.type = "enemy"
    enemy.timer = 0
    enemy.name = name
    enemy.color = color or { math.random(0, 100) * .01, math.random(0, 100) * .01, math.random(0, 100) * .01 }
    enemy.is_dead = false
    enemy.is_enemy = true
    enemy.is_hit_color = { 1, 1, 1 }
    enemy.is_hit_color_timer = 0
    enemy.velocity = { x=0, y=0 }
    enemy.timer = math.random(0, 100) * .01
    -- enemy.weapon = random enemy weapon
    enemy.weapon = Enemy_weapons[math.random(1, #Enemy_weapons)]()
    enemy.x = x or math.random(0 + enemy.size, Screen_size[1] - enemy.size)
    enemy.y = y or math.random(0 + enemy.size, Screen_size[2] - enemy.size)
    setmetatable(enemy, Enemy)
    return enemy
end

function Enemy:shoot(player)
    local playerx_to_enemy = self.x - player.x
    local playery_to_enemy = self.y - player.y
    local distance_to_player = math.sqrt(playerx_to_enemy * playerx_to_enemy + playery_to_enemy * playery_to_enemy)
    if self.timer >= self.weapon.Bullet_delay and distance_to_player < 500 then
        Enemy_noise()
        local bullet = Bullet.new(self.x, self.y, math.atan2(player.y - self.y, player.x - self.x), self)
        return bullet
    end
end

function Enemy:damage(bullet_damage)
    self.health = self.health - bullet_damage
    self.color[1] = 1 / self.health
    self.color[2], self.color[3] = self.color[2] - self.color[1], self.color[2] - self.color[1]
    if self.health <= 0 then
        self.is_dead = true
        return 
    end
    Enemy_hurt()
end
function Enemy:add_random_velocity()
    self.velocity.x = self.velocity.x + math.random(-Max_enemy_speed, Max_enemy_speed)
    self.velocity.y = self.velocity.y + math.random(-Max_enemy_speed, Max_enemy_speed)
end

function Enemy:step_closer_to_player(Player, dt)
    local playerx_to_enemy = self.x - Player.x
    local playery_to_enemy = self.y - Player.y
    local distance_to_player = math.sqrt(playerx_to_enemy * playerx_to_enemy + playery_to_enemy * playery_to_enemy)
    if distance_to_player > 1 then
        if playerx_to_enemy > -distance_to_player /2 then
            self.velocity.x = self.velocity.x + self.speed / 10 * dt
        elseif playerx_to_enemy > distance_to_player / 2 then
            self.velocity.x = self.velocity.x - self.speed / 10 * dt
        end
        if playery_to_enemy > -distance_to_player / 2 then
            self.velocity.y = self.velocity.y + self.speed / 10 * dt
        elseif playery_to_enemy > distance_to_player / 2 then
            self.velocity.y = self.velocity.y - self.speed / 10 * dt
        end
    elseif distance_to_player > 10 then
        self.velocity.x, self.velocity.y = 0,0
        self.x, self.y = self.x - (playerx_to_enemy / distance_to_player *  self.speed * 2) * dt , self.y - (playery_to_enemy /distance_to_player * self.speed * 2) * dt
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
    self:step_closer_to_player(player, dt)
    self.x = self.x + self.velocity.x * .5
    self.y = self.y + self.velocity.y * .5

end

function Enemy:draw()
    if self.is_dead then
        return
    end
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x, self.y, self.size)
end
