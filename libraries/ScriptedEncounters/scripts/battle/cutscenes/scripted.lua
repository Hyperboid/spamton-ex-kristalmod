return function(cutscene, group, subscene)
    local enemy = Game.battle:getActiveEnemies()[1]
    local wave = nil
    if Registry.battle_cutscenes[group][subscene] then
        wave = cutscene:gotoCutscene(group.."."..subscene, enemy)
    elseif Registry.battle_cutscenes[group]["default"] then
        wave = cutscene:gotoCutscene(group..".default", enemy)
    else
        error("Missing battle cutscene "..group.."."..subscene..", and couldn't fallback to "..group..".default.")
    end
    if wave then
        enemy.wave_override = wave
    end
    return nil
end

---@generic T: EnemyBattler
---@alias BattleScriptGroup table<string, fun(cutscene: BattleCutscene, enemy:T | EnemyBattler): string>