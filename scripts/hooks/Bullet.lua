---@diagnostic disable-next-line: circle-doc-class
---@class Bullet:Bullet
local Bullet, super = Class(Bullet)
function Bullet:getDamage()
    if Game.battle.encounter.funnycheat > 6 then
        Game:gameOver(Game.battle:getSoulLocation())
    end
    return super.getDamage(self)
end
return Bullet