---@class Spamscape: Object
local Spamscape, super = Class(Object)

function Spamscape:init(x,y)
    super.init(self, x,y, SCREEN_WIDTH, SCREEN_HEIGHT)
    self.background = Sprite("backgrounds/spamscape_background")
    self.background:addChild(Sprite("backgrounds/spamscape_background", 198, 0)).flip_x = true
    self.background:setScale(2)
    self.midground = Sprite("backgrounds/spamscape_midground")
    self.midground:addChild(Sprite("backgrounds/spamscape_midground", 198, 0)).flip_x = true
    self.midground:setScale(2)
    self.foreground = Sprite("backgrounds/spamscape_foreground")
    self.foreground:addChild(Sprite("backgrounds/spamscape_foreground", 198, 0)).flip_x = true
    self.foreground:setScale(2)
    self:addChild(self.background)
    self:addChild(self.midground)
    self:addChild(self.foreground)
end

return Spamscape