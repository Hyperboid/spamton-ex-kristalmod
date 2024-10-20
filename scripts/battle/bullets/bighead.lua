---@class BigHead: VisualBullet
local BigHead, super = Class(VisualBullet)

function BigHead:init(x,y,variation)
    super.init(self,x,y, "bullets/bighead/turn")
    self.sprite:setAnimation{"bullets/bighead/turn", 0.2, true}
    self:setScale(2.6)
end

function BigHead:onAdd(parent)
    super.onAdd(parent)
    ---@type Timer
    local timer = self.wave.timer
    timer:script(function (wait)
        timer:tween(2, self, {
            y = self.y - 112,
            scale_x = 3,
            scale_y = 3,
        })
        wait(2)
        timer:tween(0.5, self, {
            y = self.y + 20,
        })
        self:setLayer(400)
        wait(0.5)
    end)
end

return BigHead