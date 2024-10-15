---@class TrackLine: Object
local TrackLine, super = Class(Object)

function TrackLine:init(x,y)
    super.init(self, x,y, 320*10, 64)
    self.origin_y = 1
    self.track_sprites = Sprite("backgrounds/tracks", 0, -32)
    self.track_sprites:addChild(Sprite("backgrounds/tracks", 320, 0)).debug_select = false
    self.track_sprites:addChild(Sprite("backgrounds/tracks", (320*2), 0)).debug_select = false
    self.track_sprites:addChild(Sprite("backgrounds/tracks", (320*3), 0)).debug_select = false
    self.track_sprites:addChild(Sprite("backgrounds/tracks", (320*4), 0)).debug_select = false
    self.track_sprites:addChild(Sprite("backgrounds/tracks", (320*5), 0)).debug_select = false
    self.track_sprites:setScale(2)
    self:addChild(self.track_sprites).debug_select = false
    self.speed = 100
    self.time = 0
end

local track_speed = 1
function TrackLine:update()
    self.time = self.time + (DT * self.speed)
    self.track_sprites.x = -((track_speed * self.time) % (100*2))
end

return TrackLine