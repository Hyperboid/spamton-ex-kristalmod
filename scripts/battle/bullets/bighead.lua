---@class BigHead: VisualBullet
local BigHead, super = Class(VisualBullet)

function BigHead:init(x,y,variation)
    super.init(self,x,y, "bullets/bighead/turn")
    self.sprite:setAnimation{"bullets/bighead/turn", 0.4, false}
    self:setScale(2.6)
end

function BigHead:onAdd(parent)
    super.onAdd(parent)
    ---@type Timer
    local timer = self.wave.timer
    timer:script(function (wait)
        timer:tween(1, self, {
            y = self.y - 112,
            scale_x = 3,
            scale_y = 3,
        }, "sine")
        wait(1)
        timer:tween(0.5, self, {
            y = self.y + 20,
        }, "sine")
        self:setLayer(400)
        wait(0.5)
        self.sprite:setAnimation{"bullets/bighead/flip", 0.1, true}
        wait(0.1)
        for i = 1, 3 do
            self:shake(3 * i, 0, 0.5, 0.1)
            wait(0.4)
        end
        wait(0.2)
        self.sprite:setAnimation{"bullets/bighead/open", 0.1, false}
        wait(0.5)
        self.sprite:setAnimation{"bullets/bighead/shoot", 0.1, true}
        for i = -1, 1 do
            ---@type Pipis
            local pipis = self.wave:spawnBullet("pipis", self.x, self.y)
            pipis:setPhysics({
                gravity = 0.7,
                speed = 0,
                speed_x = i * 2,
                speed_y = -7,
                gravity_direction = math.rad(90),
                direction = 0,
                friction = 0,
                match_rotation = false,
                spin = 0
            })
        end
    end)
end

return BigHead