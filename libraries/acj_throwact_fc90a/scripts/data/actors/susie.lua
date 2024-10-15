local Susie, super = Class("susie", true)

function Susie:init()
	super:init(self)
	
	self.animations = Utils.merge(self.animations, {
		["prepare_throw"] 		= {"prepare_throw", 0.2, false},
		["throw"]       		= {"throw", 1/15, false}
	})
	
	self.offsets = Utils.merge(self.offsets, {
		["prepare_throw"] 		= {-26, -25},
		["throw"]       		= {-26, -25}
	})
end

return Susie