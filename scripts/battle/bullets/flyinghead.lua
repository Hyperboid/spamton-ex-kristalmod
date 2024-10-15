---@class FlyingHead: YellowSoulBullet
local FlyingHead, super = Class(YellowSoulBullet)

function FlyingHead:init(x, y, texture)
    super:init(self, x, y, texture)

    self.shot_health = 1
    self.shot_tp = 2.7 -- TODO: Get the actual amount from the game (I'm just guessing from the animation here)
end

function FlyingHead:update()
    
end

function FlyingHead:onYellowShot(shot, damage)
    self.shot_health = self.shot_health - damage
    if self.shot_health <= 0 then
        self:destroy(shot)
    end
    return "a", false
end

return FlyingHead