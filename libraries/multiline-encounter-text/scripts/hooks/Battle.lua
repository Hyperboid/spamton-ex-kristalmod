---@class Battle
---
---@field table_encounter_text          string[]                       The current encounter-text text table.
---@field table_encounter_text_index    number                         The current index of table_encounter_text.

local Battle, super = Class("Battle")

function Battle:init(...)
	super.init(self, ...)
    self.table_encounter_text = {}
    self.table_encounter_text_index = 1
end

function Battle:nextTurn(...)
    super.nextTurn(self,...)
    if self.battle_ui then
        self.table_encounter_text_index = 1
        self.table_encounter_text = {}
        if type(self.battle_ui.current_encounter_text) == "table" then
            self.table_encounter_text = self.battle_ui.current_encounter_text
            self.battle_ui.current_encounter_text = self.table_encounter_text[1]
        end
        self.battle_ui.encounter_text:setText(self.battle_ui.current_encounter_text)
    end
end

function Battle:update(...)
	super.update(self, ...)

    if self.state == "ACTIONSELECT" then
        if self.table_encounter_text_index < #self.table_encounter_text then
            if not self.battle_ui.encounter_text.text.state.typing then
                self.table_encounter_text_index = self.table_encounter_text_index + 1
                self.battle_ui.current_encounter_text = self.table_encounter_text[self.table_encounter_text_index]
                self.battle_ui.encounter_text:setText(self.battle_ui.current_encounter_text)
            end
        end
    end
end

return Battle
