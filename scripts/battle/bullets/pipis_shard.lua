---@class PipisShard: VisualBullet
local PipisShard, super = Class(VisualBullet)

function PipisShard:init(x,y,variation)
    super.init(self,x,y,"bullets/pipis/shard_" .. (variation or Utils.random(1,3,1)))
    self:setPhysics({
        gravity = 1.0,
        speed = 0,
        speed_x = Utils.random(-5, 5),
        speed_y = -Utils.random(5, 10),
        gravity_direction = math.rad(90),
        direction = 0,
        friction = 0,
        match_rotation = false,
        spin = 0
    })
    self.hitbox = nil -- very important
    self:setScale(1)
    self:setColor(
        0x43/256,
        0xb3/256, 
        0xd9/256
    )
    self.tp = 0
end

return PipisShard