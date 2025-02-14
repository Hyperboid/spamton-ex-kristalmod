---@param cutscene BattleCutscene
return function(cutscene, group, subscene)
    Game.battle.encounter:preTurnCutscene(cutscene)
    local enemy = Game.battle:getActiveEnemies()[1]
    local wave = nil
    if Registry.battle_cutscenes[group][subscene] then
        Game.battle.encounter:postTurnCutscene(cutscene, cutscene:gotoCutscene(group.."."..subscene, enemy))
    elseif Registry.battle_cutscenes[group]["default"] then
        Game.battle.encounter:postTurnCutscene(cutscene, cutscene:gotoCutscene(group..".default", enemy))
    else
        error("Missing battle cutscene "..group.."."..subscene..", and couldn't fallback to "..group..".default.")
    end
end

---@generic T: EnemyBattler
---@alias BattleScriptGroup table<string, fun(cutscene: BattleCutscene, enemy:T | EnemyBattler): string>