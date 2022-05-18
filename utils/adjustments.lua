-- Since settings isn't really all this is, I'm just naming it "adjustments" for simplicity sake.

-- weapon meta table
Weapon = {}
Weapon.__index = Weapon
function Weapon.new()
    local weapon = {}
    weapon.name = "Pistol"
    weapon.Bullet_color = { 1, 0, 0 }
    weapon.Bullet_speed = 1000
    weapon.Bullet_size = .0001
    weapon.Bullet_damage = .1
    weapon.Bullet_lifetime = 500
    weapon.Bullet_spread = 50
    weapon.Bullet_delay = 0
    weapon.Bullet_amount = 50
    weapon.Reflection_innaccuracy = 100
    weapon.Bullet_random_speed_factor = 10
    weapon.Bullet_death_speed_factor = 0
    weapon.Bullet_speed_slow_factor = 0
    weapon.reflection_count = 3
    setmetatable(weapon, Weapon)
    return weapon
end

Shotgun1 = {}
Shotgun1.__index = Shotgun1
function Shotgun1.new()
    local shotgun1 = Weapon.new()
    shotgun1.name = "Mini Shotgun"
    shotgun1.Bullet_color = { 1, .5, 0 }
    shotgun1.Bullet_speed = 3000
    shotgun1.Bullet_size = .01
    shotgun1.Bullet_damage = 1
    shotgun1.Bullet_delay = .5
    shotgun1.Bullet_amount = 10
    shotgun1.Bullet_spread = 100
    shotgun1.reflection_count = 1
    shotgun1.Bullet_lifetime = .1
    setmetatable(shotgun1, Shotgun1)
    return shotgun1
end

Machinegun = {}
Machinegun.__index = Machinegun
function Machinegun.new()
    local machinegun = Weapon.new()
    machinegun.name = "Mini Machinegun"
    machinegun.Bullet_color = { 1, 0, 0 }
    machinegun.Bullet_speed = 1000
    machinegun.Bullet_size = .01
    machinegun.Bullet_damage = 1
    machinegun.Bullet_delay = 0.05
    machinegun.Bullet_amount = 0
    machinegun.Bullet_spread = 200
    machinegun.Bullet_lifetime = .8
    machinegun.reflection_count = 2
    setmetatable(machinegun, Machinegun)
    return machinegun
end


Sniper_Rifle = {}
Sniper_Rifle.__index = Sniper_Rifle
function Sniper_Rifle.new()
    local sniper_rifle = Weapon.new()
    sniper_rifle.name = "Mini Sniper Rifle"
    sniper_rifle.Bullet_color = { 1, 0, 0 }
    sniper_rifle.Bullet_speed = 5000
    sniper_rifle.Bullet_size = .05
    sniper_rifle.Bullet_damage = 10
    sniper_rifle.Bullet_delay = 1
    sniper_rifle.Bullet_amount = 0
    sniper_rifle.Bullet_spread = 1
    sniper_rifle.Bullet_lifetime = 5
    sniper_rifle.reflection_count = 5
    setmetatable(sniper_rifle, Sniper_Rifle)
    return sniper_rifle
end


-- Base Values
Full_screen = false
Screen_size = { 1000, 1000 }
StartPos = { 0, 0 }
Player_size = 10
Player_color = { 1, 1, 1 }
Movement_increment = 50
Scroll_multiplier = .1
Min_enemy_size, Max_enemy_size = 30, 50
Min_enemy_speed, Max_enemy_speed = 100, 200
Min_enemy_health, Max_enemy_health = 5, 10
Enemy_gun = Shotgun1.new()
Player_pew = love.audio.newSource("utils/player_pew.wav", "static")
Enemy_pew = love.audio.newSource("utils/enemy_pew.wav", "stream")
Player_damage = love.audio.newSource("utils/player_damage.wav", "static")
Enemy_damage = love.audio.newSource("utils/enemy_damage.wav", "static")
Player_dead = love.audio.newSource("utils/player_death.wav", "static")
Enemy_dead = love.audio.newSource("utils/enemy_death.wav", "static")
Bong = love.audio.newSource("utils/boing.wav", "stream")

function Boing()
end



function Enemy_death()
    Enemy_damage:stop()
    Enemy_dead:play()
end

function Player_death()
    Player_damage:stop()
    Player_pew:stop()
    Enemy_pew:stop()
    Enemy_damage:stop()
    Player_dead:setVolume(4)
    Player_dead:play()
end


function Enemy_hurt()
    Enemy_damage:stop()
    Enemy_damage:setPitch(math.random(5, 15) * .1)
    Enemy_damage:play()
end

function Player_hurt()
    Player_damage:play()
end

function Enemy_noise()
    Enemy_pew:setPitch(math.random(5, 15) * .1)
    Enemy_pew:play()
end

function Player_noise()
    if Player_pew:isPlaying() then
        Player_pew:stop()
    end
    Player_pew:setPitch(math.random(5, 15) * .1)
    Player_pew:play()
end

-- Reference-able weapons
Weapons = {
    Weapon.new,
    Shotgun1.new,
    Machinegun.new,
    Sniper_Rifle.new
}


Weapon_enemy = {}
Weapon_enemy.__index = Weapon_enemy
function Weapon_enemy.new()
    local weapon_enemy = {}
    weapon_enemy.name = "Pistol"
    weapon_enemy.Bullet_color = { 0, 1, 0 }
    weapon_enemy.Bullet_speed = 750
    weapon_enemy.Bullet_size = .05
    weapon_enemy.Bullet_damage = 1
    weapon_enemy.Bullet_lifetime = 2
    weapon_enemy.Bullet_spread = 50
    weapon_enemy.Bullet_delay = 5
    weapon_enemy.Bullet_amount = 0
    weapon_enemy.Reflection_innaccuracy = 100
    weapon_enemy.Bullet_random_speed_factor = 0
    weapon_enemy.Bullet_death_speed_factor = 0
    weapon_enemy.Bullet_speed_slow_factor = 0
    weapon_enemy.reflection_count = 3
    setmetatable(weapon_enemy, Weapon_enemy)
    return weapon_enemy
end

Enemy_weapons = {
    Weapon_enemy.new,
}