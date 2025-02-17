---@class EnemyBattler.spamton_ex : EnemyBattler
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
    self.spare_points = 0

    self.auto_spare = true --(automatically spares and exits the battle when mercy reaches 100)

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "basic",
        --"bluepipistest", i failed :(
        --"aiming",
        --"movingarena"
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
        --"* Spamton tries to sell you a \ncar!\n[wait:4]* ...But he lost his keys.",
    }
    -- Prevent from getting tired [at half pri] i mean health
    self.tired_percentage = 0

    -- Register act called "Smile"
    self:registerAct("Snap")
    -- Register party act with Ralsei called "Tell Story"
    -- (second argument is description, usually empty)
    self:registerAct("SnapAll", "", {"susie", "ralsei"})
    self:registerAct("ThrowString", "Toss Kris\nto free\nwire\n", {"susie"}, 0)
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
        self.sprite:snapStrings(1)
        self.dialogue_override = "... ^^"
        self.sprite:setStringCount(math.max(0,(100-self.mercy)/2))
        return "* You snapped a wire!"
    elseif name == "SnapAll" then
        Assets.playSound("damage")
        self.sprite:snapStrings(3)
        self:addMercy(7)
        self.sprite:setStringCount(math.max(0,(100-self.mercy)/2))
        return "Everyone snapped wires!"
    elseif name == "ThrowString" then
        Game.battle:startActCutscene("specil", "throwstring")
    elseif name == "Standard" then --X-Action
        Assets.playSound("damage")
        self.sprite:snapStrings(1)
        self:addMercy(2)
        self.sprite:setStringCount(math.max(0,(100-self.mercy)/2))
        return "* "..battler.chara:getName().." snapped a wire!"
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

return SpamtonEX
