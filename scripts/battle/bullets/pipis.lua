---@class Pipis: YellowSoulBullet
local Pipis, super = Class(YellowSoulBullet, "pipis")
local sprite_prefix = "bullets/pipis/egg_"
function Pipis:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, sprite_prefix..1)
    self:setScale(1)
    self:setColor(
        0x43/256,
        0xb3/256, 
        0xd9/256
    )
    self.shot_health = 3
    self.shot_tp = 0.5 -- TODO: Get the actual amount from the game (I'm just guessing from the animation here)
    self.lerper = 0
    self.shot_status = 0

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
    self:setScale(2)


self.rotation=0


end

-- No update method. Different types
-- of pipis will have their own.

function Pipis:onYellowShot(shot, damage)
    Assets.playSound("bomb", 0.4)
    local return_val = super.onYellowShot(self, shot,damage)
    self:setSprite(sprite_prefix..4-self.shot_health)
    return return_val
end

function Pipis:destroy(shot)
    for i = 1, 10, 1 do
        print(Utils.dump(self.wave:spawnBullet("pipis_shard", self.x, self.y)))
    end
    super.destroy(self,shot)
    -- shot:destroy()
end

return Pipis