local ThrowDummy, super = Class(EnemyBattler)

function ThrowDummy:init()
    super:init(self)

    -- Enemy name
    self.name = "Dummy"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("dummy")

    -- Enemy health
    self.max_health = 800
    self.health = 800
    -- Enemy attack (determines bullet damage)
    self.attack = 4
    -- Enemy defense (usually 0)
    self.defense = 0
    -- Enemy reward
    self.gold = 100

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 20

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "basic"
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        "..."
    }
	
	defeat_type = "fatal"

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = {
		"AT 4 DF 0\n* Cotton heart and button eye\n* Looks just like a fluffy guy.",
		"Today, it wants to help you practice throwing."
	}

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* The dummy gives you a soft\nsmile.",
        "* The power of fluffy boys is\nin the air.",
        "* Smells like cardboard.",
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* The dummy looks like it's\nabout to fall over."

	self:registerAct("Throw K", "Throw\nKris", {"susie"})
end

function ThrowDummy:onAct(battler, name)
    if name == "Throw K" then
		Game.battle:startActCutscene("throw", "throw_k_dummy")

    elseif name == "Standard" then --X-Action
        if battler.chara.id == "ralsei" then
            -- R-Action text
            return "* Ralsei bowed politely.\n* The dummy spiritually bowed\nin return."
        elseif battler.chara.id == "susie" then
            -- S-Action
			return "* Susie rolled her eyes.\nIt seems she's really eager to throw someone."
        else
            -- Text for any other character (like Noelle)
            return "* "..battler.chara.name.." straightened the\ndummy's hat."
        end
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super:onAct(self, battler, name)
end

return ThrowDummy