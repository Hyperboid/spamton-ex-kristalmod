---@class BasicWave : Wave
local Basic, super = Class(Wave)

function Basic:deployHeads()
    self.timer:script(function(wait)
        -- Our X position is offscreen, to the right
        local x = Utils.pick({SCREEN_WIDTH + 20, -20})
        -- Get a random Y position between the top and the bottom of the arena
        local y = Utils.pick({Game.battle.arena.top + 10, Game.battle.arena.y, Game.battle.arena.bottom - 10})

        -- Spawn smallbullet going left with speed 8 (see scripts/battle/bullets/smallbullet.lua)
        for i=1,4 do
            local bullet = self:spawnBullet("flyinghead", x, y, math.rad(180), 0)
            if x > 0 then
                bullet.target_x = Game.battle.arena.x + (20 * i)
                bullet.target_x = bullet.target_x + 20
            else
                bullet.target_x = Game.battle.arena.x - (20 * i)
                bullet.target_x = bullet.target_x + 80
                bullet.sprite.flip_x = true
            end
            -- Dont remove the bullet offscreen, because we spawn it offscreen
            bullet.remove_offscreen = false
            bullet.shot_t_threshold = bullet.shot_t_threshold + (i * 0.02)
            wait(0.1)
        end
    end)
end

function Basic:onStart()
    self:deployHeads()
    -- Every 0.66 seconds...
    self.timer:every(4/3, function ()
        self:deployHeads()
    end)
end

function Basic:onArenaEnter()
    Game.battle.arena:setSize(270,110)
end

function Basic:update()
    -- Code here gets called every frame

    super.update(self)
end

return Basic