return {
    throwstring = function(cutscene)
        local last_positions = {}

        local werewires = Utils.filter(Game.battle:getActiveEnemies(), function(e) return e.id == "spamton_ex" end)

        local werewire_index = 0
        for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
            last_positions[enemy] = {x = enemy.x, y = enemy.y}

            if enemy.id ~= "spamton_ex" then
                enemy:slideTo(740, enemy.y, 0.5)
            else
                local step = 250 / (#werewires - 1)
                enemy:slideTo(enemy.x, 502, 0.5)
                werewire_index = werewire_index + 1
            end
        end

        cutscene:wait(0.5)

        local thrower = WerewireThrowAct(werewires)
        Game.battle:addChild(thrower)

        thrower:setup()

        cutscene:text("* Press [bind:menu] to throw, aim for the weakpoint!", {wait = false, advance = false})

        cutscene:wait(function()
            if Input.pressed("menu") then
                Input.clear("menu")
                return true
            end
        end)

        cutscene:text("", {wait = false})

        local hit = cutscene:wait(thrower:throw())

        thrower:clear()

        if #hit == 0 then
            cutscene:text("* Missed!")
        else
            cutscene:text("* The wire greatly loosened!")
        end

        for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
            enemy:slideTo(last_positions[enemy].x, last_positions[enemy].y, 0.5)
        end

        cutscene:wait(0.5)

        for _,enemy in ipairs(werewires) do
            if Utils.containsValue(hit, enemy) then
                enemy:addMercy(20)
            else
                enemy:addMercy(0)
            end
        end
    end
}