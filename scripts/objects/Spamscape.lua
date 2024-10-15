---@class Spamscape: Object
local Spamscape, super = Class(Object)

function Spamscape:init(x,y)
    super.init(self, x,y, SCREEN_WIDTH, SCREEN_HEIGHT)
    self.background = Sprite("backgrounds/spamscape_background")
    self.background:addChild(Sprite("backgrounds/spamscape_background", 198, 0)).flip_x = false
    self.background:addChild(Sprite("backgrounds/spamscape_background", (198*2), 0)).flip_x = false
    self.background:setScale(2)
    self.midground = Sprite("backgrounds/spamscape_midground")
    self.midground:addChild(Sprite("backgrounds/spamscape_midground", 198, 0)).flip_x = false
    self.midground:addChild(Sprite("backgrounds/spamscape_midground", (198*2), 0)).flip_x = false
    self.midground:setScale(2)
    self.foreground = Sprite("backgrounds/spamscape_foreground")
    self.foreground:addChild(Sprite("backgrounds/spamscape_foreground", 198, 0)).flip_x = false
    self.foreground:addChild(Sprite("backgrounds/spamscape_foreground", (198*2), 0)).flip_x = false
    self.foreground:setScale(2)
    self.tracklines = {}
    for i, v in ipairs({168,245,324}) do
        self.tracklines[i] = TrackLine(0, v)
        self.tracklines[i].speed = - 637
        self.tracklines[i].layer = 1
        self:addChild(self.tracklines[i])
    end
    self:addChild(self.background)
    self:addChild(self.midground)
    self:addChild(self.foreground)
    self.speed = 100
    self.time = 0
end

local bg_speed = 0.3
local mg_speed = 0.7
local fg_speed = 1.0
function Spamscape:update()
    self.time = self.time + (DT * self.speed)
    self.background.x = -((bg_speed * self.time) % (198*2))
    self.midground.x = -((mg_speed * self.time) % (198*2))
    self.foreground.x = -((fg_speed * self.time) % (198*2))
end

return Spamscape