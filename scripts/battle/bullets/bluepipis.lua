local SmallBullet, super = Class(Bullet)

function SmallBullet:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/bigsmallbullet")
    helthkare=3
    self:setScale(1)
    self:setColor(
        0x43/256,
        0xb3/256, 
        0xd9/256
    )
    self.initial_x = self.x
    self.initial_y = self.y
    self.target_x = self.x
    self.target_y = self.y
    self.shot_health = 1
    self.shot_tp = 0.5 -- TODO: Get the actual amount from the game (I'm just guessing from the animation here)
    self.lerper = 0
    self.shot_status = 0

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed


self.rotation=0


end

function SmallBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)

    self.rotation=self.rotation+7

    self.physics.speed=self.physics.speed*.97

    super.update(self)
    if self.alpha < 1 then return end -- this is temp
    self.lerper = self.lerper + DT
    local t = 0


    if self.lerper < 1 then
        t = 1-math.pow(1-self.lerper, 1.8)
    else
        t = 1+math.pow(self.lerper-1,1.8)
    end
    self.x = Utils.lerp(self.initial_x, self.target_x, t, true)
    self.y = Utils.lerp(self.initial_y, self.target_y, t, true)

    if t > 0.9 and self.shot_status == 0 then
        self.shot_status = 1
        self.sprite:set({"bullets/flyinghead/spr_sneo_crew", 0.5})
    end
    if self.sprite.frame == 2 and self.shot_status == 1 then
        local x, y = self.x, self.y
        local angle = Utils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)
        self.wave:spawnBullet("smallbullet", x, y, angle, 8)
        self.shot_status = 2
    end

end

function SmallBullet:onYellowShot(shot, damage)
    Assets.playSound("bomb", 0.4)
    return super.onYellowShot(self, shot,damage)
end

function SmallBullet:destroy(shot)
    if self.shot_tp ~= 0 then
        Game:giveTension(self.shot_tp)
    end
    self.hitbox = nil
    self:fadeOutAndRemove(0.2)
end

return SmallBullet