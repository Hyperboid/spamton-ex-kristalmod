---@class FlyingHead: YellowSoulBullet
local FlyingHead, super = Class(YellowSoulBullet)

function FlyingHead:init(x, y, texture)
    super:init(self, x, y, "bullets/flyinghead/spr_sneo_crew_0")
    self:setScale(1)
    self:setColor(0.6,1,0.9)
    self.initial_x = self.x
    self.initial_y = self.y
    self.target_x = self.x
    self.target_y = self.y
    self.shot_health = 1
    self.shot_tp = 2.7 -- TODO: Get the actual amount from the game (I'm just guessing from the animation here)
    self.lerper = 0
end

function FlyingHead:update()
    super.update(self)
    self.lerper = self.lerper + DT
    local t = 0
    if self.lerper < 1 then
        t = math.pow(self.lerper - 1, 2)
    else
        t = math.pow(1 - self.lerper, 2)
    end
    self.x = Utils.lerp(self.initial_x, self.target_x, t, true)
    self.y = Utils.lerp(self.initial_y, self.target_y, t, true)
end

function FlyingHead:onYellowShot(shot, damage)
    self.shot_health = self.shot_health - damage
    if self.shot_health <= 0 then
        self:destroy(shot)
    end
    return "a", false
end

return FlyingHead