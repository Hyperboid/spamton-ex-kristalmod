local SmallBullet, super = Class(Bullet)

function SmallBullet:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "bullets/bigsmallbullet")
    helthkare=3
    self:setColor(
        0x43/256,
        0xb3/256, 
        0xd9/256
    )

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed


self.rotation=0


end

function SmallBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super.update(self)

    self.rotation=self.rotation+10

    self.speed=self.speed*.9

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