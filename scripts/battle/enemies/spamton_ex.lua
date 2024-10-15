local SpamtonEX, super = Class(EnemyBattler)

function SpamtonEX:init()
    super.init(self)

    -- Enemy name
    self.name = "Spamton EX"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("spamton_ex")

    -- Enemy health
    self.max_health = (59999 * 2) + 1
    self.health = self.max_health
    -- Enemy attack (determines bullet damage)
    self.attack = 4
    -- Enemy defense (usually 0)
    self.defense = 0
    -- Enemy reward
    self.money = 100

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 20

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "basic",
        "aiming",
        "movingarena"
    }

    self.random_waves = self.waves

    self.wave_count = 0

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        "..."
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "* "

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* Spamton EX is doing strange\ndance moves!",
	"* Spamton bakes a cake using a vegan pipis substitute.",
	"* Smells like Spamton.",
	"* Spamton tries to sell you a \ncar!\n[wait:4]\n...But he lost his keys."
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* The dummy looks like it's\nabout to fall over."

    -- Register act called "Smile"
    self:registerAct("Snap")
    -- Register party act with Ralsei called "Tell Story"
    -- (second argument is description, usually empty)
    self:registerAct("SnapAll", "", {"susie", "ralsei"})
    self:registerAct("ThrowString", "Toss Kris\nto free\nwire\n", {"susie"}, 10000)
end

function SpamtonEX:hurt(amount,...)
    if amount > 70 then
        super.hurt(self,59999, ...)
    else
        super.hurt(self, amount * 132, ...)
    end
end

function SpamtonEX:onAct(battler, name)
    if name == "Check" then 
        return {
            "* SPAMTON EX - BIGGER AND BETTER THAN EVER!",
            "* THOUGH... DEFENSE IS STILL A\nLITTLE \"[color:yellow]SHAKY[color:white].\""
        }
    elseif name == "Snap" then
        Assets.playSound("damage")
        self:addMercy(2)
        self.sprite:snapStrings(3)
        self.dialogue_override = "... ^^"
        self.sprite:setStringCount(math.max(0,100-self.mercy))
        return "* You snapped a wire!"
    elseif name == "SnapAll" then
        Assets.playSound("damage")
        self.sprite:snapStrings(3)
        self:addMercy(7)
        self.sprite:setStringCount(math.max(0,100-self.mercy))
        return "Everyone snapped wires!"
    elseif name == "Standard" then --X-Action
        Assets.playSound("damage")
        self.sprite:snapString(nil, true)
        self:addMercy(2)
        self.sprite:setStringCount(math.max(0,100-self.mercy))
        return "* "..battler.chara:getName().." snapped a wire!"
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

-- Adapted from Fun Town: ETERNAL LUMINA

function SpamtonEX:selectWave()
	if Game.world and Game.world.map and Game.world.map.spin_speed and Game.world.map.spin_speed < 0.32 then
		Game.world.map.timer:tween(0.5, Game.world.map, {spin_speed = Game.world.map.spin_speed + 0.01}, 'in-sine')
	end

	local waves = self.waves
	self.wave_count = self.wave_count + 1
	
	if waves and #waves > 0 then
		local wave = waves[self.wave_count]
		
		if not wave then
			local wave = Utils.pick(self.random_waves)
			self.selected_wave = wave
			
			return wave
		end
		
		self.selected_wave = wave
		return waves[self.wave_count]
	end
end

return SpamtonEX
