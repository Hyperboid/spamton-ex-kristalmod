return {
    throw_k_dummy = function(cutscene, battler, enemy)
		
		-- Variables for you to edit. Read the readme for more info.
		local battler_a = "susie"
		local battler_b = "kris"
		local ammo_offset_x = -22
		local ammo_offset_y = -28
		local angle_speed = 0.050
		local angle = 0
		local max_angle = 0.1
		local min_angle = -0.6
		local throw_speed = 35.5
		local gravity = 0.001
		local aim_string = "* Press " .. Input.getText("menu") .. " to throw, aim for the dummy!"
		local hit_string = "* Direct hit!"
		
		-- Target object. You may add more or change this one.
		local test_targ = Target(enemy, enemy.x, enemy.y + enemy.height + 15, enemy.y - enemy.height - 15, 20, hit_string)
		
		-- DO NOT CHANGE ANYTHING BELOW THIS COMMENT IF YOU DO NOT KNOW WHAT YOU ARE DOING.
		local thrower = cutscene:getCharacter(battler_a)
		local ammo = cutscene:getCharacter(battler_b)
		
		local x = ammo.x
		local y = ammo.y
		
		cutscene:text(aim_string, { advance = false })
		
		cutscene:setAnimation(thrower, "prepare_throw")
		cutscene:setAnimation(ammo, "prepare_thrown")
		
		ammo.x = thrower.x + ammo_offset_x
		ammo.y = thrower.y + ammo_offset_y
		
		local linesprite = Sprite("throw/curve", thrower.x + thrower.width + 22, thrower.y - thrower.height)
		linesprite.layer = 1000
		linesprite.origin_exact = true
		linesprite.origin_x = 4
		linesprite.origin_y = 5
		Game.battle:addChild(linesprite)
		
		cutscene:wait(function(cutscene)
			angle = angle + angle_speed * DTMULT
			if (angle <= min_angle) or (angle >= max_angle) then
				angle_speed = angle_speed * -1
			end
			linesprite.rotation = angle
			if Input.pressed("menu") then
				return true
			end
			return false
		end)
		
		linesprite:remove()
		
		local did_trigger = false
		
		cutscene:setAnimation(thrower, "throw")
		cutscene:setAnimation(ammo, "thrown")
		cutscene:text("", { advance = false })
		
		local dx = throw_speed * math.cos(angle)
		local dy = throw_speed * math.sin(angle)
		
		ammo.origin_x = 1
		
		cutscene:wait(function(cutscene)
			ammo.rotation = angle
			ammo.x = ammo.x + dx * DTMULT
			ammo.y = ammo.y + dy * DTMULT
			if (ammo.x >= test_targ.x) and (did_trigger == false) then
				test_targ:detectHit(ammo.y)
				did_trigger = true
			end
			angle = angle + gravity
			dx = throw_speed * math.cos(angle)
			dy = throw_speed * math.sin(angle)
			if ammo.x > 640 or ammo.y > 480 then
				return true
			end
			return false
		end)
		
		cutscene:setAnimation(thrower, "battle/act")
		cutscene:setAnimation(ammo, "battle/act")
		
		ammo.y = y
		ammo.x = -80
		
		cutscene:text(Game.battle.encounter.hit_string, { advance = false })
		
		ammo.rotation = 0
		ammo.origin_x = 0.5
		
		cutscene:wait(function(cutscene)
			ammo.x = ammo.x + 10 * DTMULT
			if ammo.x >= x then
				ammo.x = x
				return true
			end
			return false
		end)
		
		ammo.x = x
		ammo.y = y
		
		if Game.battle.encounter.hit_string == hit_string then
			cutscene:wait(function() return (Input.pressed("menu") or Input.pressed("confirm")) end)
		end
		
		Game.battle.encounter.hit_string = ""
    end
}