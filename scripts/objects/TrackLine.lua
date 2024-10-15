---@class TrackLine: Object
local TrackLine, super = Class(Object)

function TrackLine:init(x,y)
    super.init(self, x,y, 200*5, 37*2)
    -- self.origin_y = 37
    self.track_sprites = Sprite("backgrounds/tracks")
    self.track_sprites:addChild(Sprite("backgrounds/tracks", 100, 0)).debug_select = false
    self.track_sprites:addChild(Sprite("backgrounds/tracks", (100*2), 0)).debug_select = false
    self.track_sprites:addChild(Sprite("backgrounds/tracks", (100*3), 0)).debug_select = false
    self.track_sprites:addChild(Sprite("backgrounds/tracks", (100*4), 0)).debug_select = false
    self.track_sprites:addChild(Sprite("backgrounds/tracks", (100*5), 0)).debug_select = false
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