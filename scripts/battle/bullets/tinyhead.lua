---@class TinyHead: Bullet
local TinyHead, super = Class(Bullet)
function TinyHead:init(x, y, dir, speed)
    super:init(self, x, y, "bullets/flyinghead/spr_sneo_crew_0")
    self.physics.direction = dir
    self.physics.speed = speed
    self:setScale(0.5)
    self.tp = 100
end

return TinyHead
