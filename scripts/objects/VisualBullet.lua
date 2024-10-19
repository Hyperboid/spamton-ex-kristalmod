---@class VisualBullet: Bullet
local VisualBullet, super = Class(Bullet)

function VisualBullet:init(...)
    super.init(self,...)
    self.tp = 0
end

function VisualBullet:onDamage(soul)
    return 0
end

function VisualBullet:onCollide()
    return false
end

return VisualBullet