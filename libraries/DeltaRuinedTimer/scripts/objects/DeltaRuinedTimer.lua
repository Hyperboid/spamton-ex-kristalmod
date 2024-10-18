---@class DeltaRuinedTimer: Object
---@overload fun(duration, x, y) : DeltaRuinedTimer
local DeltaRuinedTimer, super = Class(Object)

function DeltaRuinedTimer:init(duration, x, y)
    super.init(self, x, y, SCREEN_WIDTH, 80)
    self.duration = duration
    self.elapsed = 0
    self:setScale(1)
end

function DeltaRuinedTimer:update()
    super.update(self)
end

function DeltaRuinedTimer:draw()
    super.draw(self)
end

function DeltaRuinedTimer:onExpire()
    if Game.battle then
        if Game.battle.encounter and Game.battle.encounter.onTimerExpire then
            Game.battle.encounter:onTimerExpire()
        else
            Game:gameOver(Game.battle:getSoulLocation())
        end
    else
        if Game.world.map and Game.world.map.onTimerExpire then
            Game.world.map:onTimerExpire()
        else
            Game:gameOver(Game.world.soul:getPosition())
        end
    end
end

return DeltaRuinedTimer