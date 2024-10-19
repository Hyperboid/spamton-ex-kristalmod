--- The `Battle` Object manages everything related to battles in Kristal. \
--- A globally available reference to the in-use `Battle` instance is stored in [`Game.battle`](lua://Game.battle).
---
---@class Battle : Battle
---
---@field party                     PartyBattler[]                  A table of all the `PartyBattler`s in the current battle
---
---@field money                     integer                         Current amount of victory money
---@field xp                        number                          Current amount of victory xp
---
---@field used_violence             boolean
---
---@field ui_move                   love.Source                     A sound source for the `ui_move` sfx, should be used for every time this sound plays in battle
---@field ui_select                 love.Source                     A sound source for the `ui_select` sfx, should be used for every time this sound plays in battle
---@field spare_sound               love.Source                     A sound source for the `spare` sfx, should be used for every time this sound plays in battle
---@
---@field party_beginning_positions table<[number, number]>         The position of each `PartyBattler` at the start of the battle transition
---@field enemy_beginning_positions table<[number, number]>         The position of each `EnemyBattler` at the start of the battle transition
---@
---@field party_world_characters    table<string, Character>        A list of mappings between `PartyBattler`s (by id) and their representations as `Character`s in the world, if they exist
---@field enemy_world_characters    table<EnemyBattler, Character>  A list of mappings between `EnemyBattler`s and their representations as `Character`s in the world, if they exist
---@field battler_targets           table<[number, number]>         Target positions for `PartyBattler`s to transition to at the start of battle
---
---@field encounter_context         ChaserEnemy?                    An optional `ChaserEnemy` instance that initiated the battle
---
---@field state                     string                          The current state of the battle - should never be set manually, see [`Battle:setState()`](lua://Battle.setState) instead
---@field substate                  string                          The current substate of the battle - should never be set manually, see [`Battle:setSubState()`](lua://Battle.setSubState) instead
---@field state_reason              string?                         The reason for the current state of the battle - should never be set manually, see [`Battle:setState()`](lua://Battle.setState) instead
---
---@field camera                    Camera
---
---@field cutscene                  BattleCutscene?                 The active battle cutscene, if it exists - see [`Battle:startCutscene()`](lua://Battle.startCutscene) or [`Battle:startActCutscene()`](lua://Battle.startActCutscene) for how to start cutscenes
---
---@field turn_count                integer                         The current turn number
---
---@field battle_ui                 BattleUI
---@field tension_bar               TensionBar
---
---@field arena                     Arena?
---@field soul                      Soul?
---
---@field music                     Music
---
---@field mask                      ArenaMask                       Objects parented to this will be masked to the arena
---@field timer                     Timer
---
---@field attackers                 EnemyBattler[]
---@field normal_attackers          PartyBattler[]
---@field auto_attackers            PartyBattler[]
---
---@field enemies                   EnemyBattler[]
---@field enemies_index             EnemyBattler[]
---@field enemy_dialogue            SpeechBubble[]
---@field enemies_to_remove         EnemyBattler[]
---@field defeated_enemies          EnemyBattler[]
---@field waves                     Wave[]
---
---@field encounter                 Encounter                       The encounter currently being used for this battle *(only set during `postInit()`)*
---@field resume_world_music        boolean                         *(only set during `postInit()`)*
---@field transitioned              boolean                         Whether the battle opened with a transition *(only set during `postInit()`)*
---
---@overload fun(...) : Battle
local Battle, super = Class(Battle)

function Battle:init()
    super.init(self)
    self.table_encounter_text = {}
    self.table_encounter_text_index = 1
end

--- Advances to the next turn of the battle
function Battle:nextTurn()
    self.turn_count = self.turn_count + 1
    if self.turn_count > 1 then
        if self.encounter:onTurnEnd() then
            return
        end
        for _,enemy in ipairs(self:getActiveEnemies()) do
            if enemy:onTurnEnd() then
                return
            end
        end
    end

    for _,action in ipairs(self.current_actions) do
        if action.action == "DEFEND" then
            self:finishAction(action)
        end
    end

    for _,enemy in ipairs(self.enemies) do
        enemy.selected_wave = nil
        enemy.hit_count = 0
    end

    for _,battler in ipairs(self.party) do
        battler.hit_count = 0
        if (battler.chara:getHealth() <= 0) and battler.chara:canAutoHeal() then
            battler:heal(battler.chara:autoHealAmount(), nil, true)
        end
        battler.action = nil
    end

    self.attackers = {}
    self.normal_attackers = {}
    self.auto_attackers = {}

    self.current_selecting = 1
    while not (self.party[self.current_selecting]:isActive()) do
        self.current_selecting = self.current_selecting + 1
        if self.current_selecting > #self.party then
            Kristal.Console:warn("Nobody up! This shouldn't happen...")
            self.current_selecting = 1
            break
        end
    end

    self.current_button = 1

    self.character_actions = {}
    self.current_actions = {}
    self.processed_action = {}

    if self.battle_ui then
        for _,box in ipairs(self.battle_ui.action_boxes) do
            box.selected_button = 1
            --box:setHeadIcon("head")
            box:resetHeadIcon()
        end
        if self.state == "INTRO" or self.state_reason == "INTRO" or not self.seen_encounter_text then
            self.seen_encounter_text = true
            self.battle_ui.current_encounter_text = self.encounter.text
        else
            self.battle_ui.current_encounter_text = self:getEncounterText()
        end
        self.table_encounter_text_index = 1
        self.table_encounter_text = {}
        if type(self.battle_ui.current_encounter_text) == "table" then
            self.table_encounter_text = self.battle_ui.current_encounter_text
            self.battle_ui.current_encounter_text = self.table_encounter_text[1]
        end
        self.battle_ui.encounter_text:setText(self.battle_ui.current_encounter_text)
    end

    if self.soul then
        self:returnSoul()
    end

    self.encounter:onTurnStart()

    for _,enemy in ipairs(self:getActiveEnemies()) do
        enemy:onTurnStart()
    end

    if self.battle_ui then
        for _,party in ipairs(self.party) do
            party.chara:onTurnStart(party)
        end
    end

    if self.current_selecting ~= 0 and self.state ~= "ACTIONSELECT" then
        self:setState("ACTIONSELECT")
    end
end

function Battle:update()
    for _,enemy in ipairs(self.enemies_to_remove) do
        Utils.removeFromTable(self.enemies, enemy)
        local enemy_y = Utils.getKey(self.enemies_index, enemy)
        if enemy_y then
            self.enemies_index[enemy_y] = false
        end
    end
    self.enemies_to_remove = {}

    if self.cutscene then
        if not self.cutscene.ended then
            self.cutscene:update()
        else
            self.cutscene = nil
        end
    end
    if Game.battle == nil then return end -- cutscene ended the battle

    if self.state == "TRANSITION" then
        self:updateTransition()
    elseif self.state == "INTRO" then
        self:updateIntro()
    elseif self.state == "ATTACKING" then
        self:updateAttacking()
    elseif self.state == "ACTIONSDONE" then
        self.actions_done_timer = Utils.approach(self.actions_done_timer, 0, DT)
        local any_hurt = false
        for _,enemy in ipairs(self.enemies) do
            if enemy.hurt_timer > 0 then
                any_hurt = true
                break
            end
        end
        if self.actions_done_timer == 0 and not any_hurt then
            self:resetAttackers()
            if not self.encounter:onActionsEnd() then
                self:setState("ENEMYDIALOGUE")
            end
        end
    elseif self.state == "DEFENDINGBEGIN" then
        self.defending_begin_timer = self.defending_begin_timer + DTMULT
        if self.defending_begin_timer >= 15 then
            self:setState("DEFENDING")
        end
    elseif self.state == "DEFENDING" then
        self:updateWaves()
    elseif self.state == "ENEMYDIALOGUE" then
        self.textbox_timer = self.textbox_timer - DTMULT
        if (self.textbox_timer <= 0) and self.use_textbox_timer then
            self:advanceBoxes()
        else
            local all_done = true
            for _,textbox in ipairs(self.enemy_dialogue) do
                if not textbox:isDone() then
                    all_done = false
                    break
                end
            end
            if all_done then
                self:setState("DIALOGUEEND")
            end
        end
    elseif self.state == "ACTIONSELECT" then
        if self.table_encounter_text_index < #self.table_encounter_text and self.table_encounter_text ~= {} then
            if not self.battle_ui.encounter_text.text.state.typing then
                self.table_encounter_text_index = self.table_encounter_text_index + 1
                self.battle_ui.current_encounter_text = self.table_encounter_text[self.table_encounter_text_index]
                self.battle_ui.encounter_text:setText(self.battle_ui.current_encounter_text)
            end
        end
    end

    if self.state ~= "TRANSITIONOUT" then
        self.encounter:update()
    end
    
    -- prevents the bolts afterimage from continuing till the edge of the screen when all the enemies are defeated but there're still unfinished attacks
    if self.state ~= "ATTACKING" then
        for _,attack in ipairs(self.battle_ui.attack_boxes) do
            if not attack.attacked and attack:getClose() <= -2 then
                attack:miss()
            end
        end
    end

    self.offset = self.offset + 1 * DTMULT

    if self.offset > 100 then
        self.offset = self.offset - 100
    end

    if (self.state == "ENEMYDIALOGUE") or (self.state == "DEFENDINGBEGIN") or (self.state == "DEFENDING") then
        self.background_fade_alpha = math.min(self.background_fade_alpha + (0.05 * DTMULT), 0.75)
        if not self.darkify then
            self.darkify = true
            for _,battler in ipairs(self.party) do
                battler.should_darken = true
            end
        end
    end

    if Utils.containsValue({"DEFENDINGEND", "ACTIONSELECT", "ACTIONS", "VICTORY", "TRANSITIONOUT", "BATTLETEXT"}, self.state) then
        self.background_fade_alpha = math.max(self.background_fade_alpha - (0.05 * DTMULT), 0)
        if self.darkify then
            self.darkify = false
            for _,battler in ipairs(self.party) do
                battler.should_darken = false
            end
        end
    end

    -- Always sort
    --self.update_child_list = true
    Object.update(self)

    if self.state == "TRANSITIONOUT" then
        self:updateTransitionOut()
    end
end

return Battle
