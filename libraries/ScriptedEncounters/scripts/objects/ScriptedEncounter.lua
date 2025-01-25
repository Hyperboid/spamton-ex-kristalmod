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

return ScriptedEncounter