local Kris, super = Class("kris", true)

function Kris:init()
	super:init(self)
	
	self.animations = Utils.merge(self.animations, {
		["prepare_thrown"] 		= {"prepare_thrown", 0.2, false},
		["thrown"]       		= {"thrown", 1/15, false}
	})
	
	self.offsets = Utils.merge(self.offsets, {
		["prepare_thrown"] 		= {-4, 0},
		["thrown"]       		= {-4, 0}
	})
end

return Kris