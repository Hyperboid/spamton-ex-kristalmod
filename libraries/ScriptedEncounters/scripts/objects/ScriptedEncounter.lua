---@class ScriptedEncounter: Encounter
local ScriptedEncounter, super = Class(Encounter)

function ScriptedEncounter:init()
    super.init(self)
    self.cutscene_group = "dummy"
end

function ScriptedEncounter:getTurnCutscene()
    return "turn_"..(DEBUG_TURN_OVERRIDE or Game.battle.turn_count)
end

function ScriptedEncounter:getDialogueCutscene()
    return "scripted", self.cutscene_group, self:getTurnCutscene()
end

---@param cutscene BattleCutscene
function ScriptedEncounter:preTurnCutscene(cutscene) end

---@param cutscene BattleCutscene
---@param ... unknown
function ScriptedEncounter:postTurnCutscene(cutscene, ...)
    local enemy = Game.battle:getActiveEnemies()[1]
    local wave = ...
    if wave then enemy.wave_override = wave end
end

return ScriptedEncounter