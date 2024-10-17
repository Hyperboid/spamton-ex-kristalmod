---@class FlyingHead: YellowSoulBullet
local FlyingHead, super = Class(YellowSoulBullet)
local sprite_prefix = "bullets/flyinghead/spr_sneo_crew_"
function FlyingHead:init(x, y, texture)
    super:init(self, x, y, sprite_prefix .. "0")
    self:setScale(1)
    self:setColor(
        0x43/256,
        0xb3/256, 
        0xd9/256
    )
    self.initial_x = self.x
    self.initial_y = self.y
    self.target_x = self.x
    self.target_y = self.y
    self.shot_health = 1
    self.shot_tp = 0.5 -- TODO: Get the actual amount from the game (I'm just guessing from the animation here)
    self.lerper = 0
    self.shot_status = 0
    self.speed = 1
    self.shot_t_threshold = 0.9
end

function FlyingHead:update()
    super.update(self)
    if self.alpha < 1 then return end -- this is temp
    self.lerper = self.lerper + (DT * self.speed)
    local t = 0


    if self.lerper < 1 then
        t = 1-math.pow(1-self.lerper, 1.8)
    else
        t = 1+math.pow(self.lerper-1,1.8)
    end
    self.x = Utils.lerp(self.initial_x, self.target_x, t, true)
    self.y = Utils.lerp(self.initial_y, self.target_y, t, true)

    if t > self.shot_t_threshold and self.shot_status == 0 then
        self.shot_status = 1
        self.sprite:set({"bullets/flyinghead/spr_sneo_crew", 0.5})
    end
    if self.sprite.frame == 2 and self.shot_status == 1 then
        local x, y = self.x, self.y
        local angle = Utils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)
        self.wave:spawnBullet("smallbullet", x, y, angle, 8)
        self.shot_status = 2
    end
    
end

function FlyingHead:onYellowShot(shot, damage)
    Assets.playSound("bomb", 0.4)
    return super.onYellowShot(self, shot,damage)
end

function FlyingHead:destroy(shot)
    local breakFx = BreakEffect(self.sprite.texture, self.x, self.y)
    breakFx.origin_x = self.origin_x
    breakFx.origin_y = self.origin_y
    breakFx.flip_x = self.sprite.flip_x ~= self.flip_x
    breakFx.flip_y = self.sprite.flip_y ~= self.flip_y
    breakFx.color = self.color
    breakFx.layer = self.layer + 1
    self.parent:addChild(breakFx)
    super.destroy(self,shot)
end

return FlyingHead