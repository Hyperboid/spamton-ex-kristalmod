local Target = Class()

function Target:init(enemy, x, y1, y2, mercy, hit_string)
	self.enemy = enemy
	self.x = x
	self.y1 = y1
	self.y2 = y2
	self.mercy = mercy or 15
	self.hit_string = hit_string or ""
end

function Target:hit() -- What will happen when the Target is hit by the ally?
	self.enemy:addMercy(self.mercy)
	Game.battle.encounter.hit_string = self.hit_string
end

function Target:detectHit(ally_y) -- Did the ally hit the Target? In other words, is the ally's y value in the range of the y values of the Target?
	if (ally_y > self.y2 and ally_y < self.y1) or (ally_y < self.y2 and ally_y > self.y1) then
		self:hit()
	end
end

function Target:yShift(offset)
	y1 = y1 + offset
	y2 = y2 + offset
end

-- For what I can tell, there should be no real need to extend this for updating values or rendering sprites. You can do that in the cutscene.
-- However, if you want to extend this as a new object to change what happens when it's hit or add some other value, don't let me stop you.
-- Though, I guess you could also extend this to switch x values and y values in detection like a basketball hoop.

return Target