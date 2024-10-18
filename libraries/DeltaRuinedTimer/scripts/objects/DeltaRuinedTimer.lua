---@class DeltaRuinedTimer: Object
---@overload fun(duration, x, y) : DeltaRuinedTimer
local DeltaRuinedTimer, super = Class(Object)

function DeltaRuinedTimer:init(duration, x, y)
    super.init(self, x, y, SCREEN_WIDTH, 40)
    self.duration = duration
    self.elapsed = 0
    self.background = Sprite("backgrounds/timer",12,0)
    self.background.debug_select = false
    self.background.debug_select = false
    self.krishead = Sprite("party/kris/icon/head",68,7)
    self:addChild(self.background)
    self:addChild(self.krishead)
    self:setScale(1)
end

function DeltaRuinedTimer:update()
    super.update(self)
    self.elapsed = self.elapsed + DT
    self.krishead.x = Utils.lerp(63, 590, self.elapsed / self.duration)
    if self:getTimeLeft() < 0 and not self.isExpired then
        self.isExpired = true
        self:onExpire()
    end
end

function DeltaRuinedTimer:getTimeLeft()
    return self.duration - self.elapsed
end

function DeltaRuinedTimer:draw()
    love.graphics.setColor(0, 0, 0, 1.5)
    love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, 38)
    super.draw(self)
    local font = Assets.getFont("main", 16)
    ---@diagnostic disable-next-line: param-type-mismatch
    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(
        "Time left:\n    ".. (string.format("%.2f", self:getTimeLeft())), 0, 0
    )
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