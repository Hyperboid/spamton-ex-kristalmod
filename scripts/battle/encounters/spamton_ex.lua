---@class Sencounter: Encounter
local Sencounter, super = Class(Encounter)

local function triangle(t)
    return ((math.abs(((t*100) % 100) - 50))/50)-.5
end

function Sencounter:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = ({
        "[face:susie/teeth_b][voice:susie]* Kris, what the hell??\nWe're going backwards?",
        "[face:susie/annoyed][voice:susie]* We need to win FAST before we run outta track!"
    })[1] -- remove the [1] when tfl's pr is done

    -- Battle music ("battle" is rude buster)
    self.music = nil--
    self.music = "murderbydeals"
    -- Enables the purple grid battle background
    self.background = false

    -- Add the dummy enemy to the encounter
    self:addEnemy("spamton_ex", 511, 259)

    
    self.spamscape = Spamscape()
    self.spamscape.speed = -100
    self.spamscape.layer = -999
    self.spamcarts = Sprite("backgrounds/carts",0,0)
    self.spamcarts:setScale(2)
    self.spamcarts.debug_select = false
    self.spamcarts.layer=-501
    self.drtimer = DeltaRuinedTimer(715)
    self.turns = 0
    --- Uncomment this line to add another!
    --self:addEnemy("dummy")
end

function Sencounter:onBattleStart()
    pcall(function()
        local reference = Sprite("reference")
        reference.alpha = .5
        reference.layer = -1000
        reference:setScale(0.71)
        Game.battle:addChild(reference)
    end)
    Game.battle:addChild(self.drtimer)
    Game.battle:addChild(self.spamscape).debug_select = false
    Game.battle:addChild(self.spamcarts)
end

function Sencounter:onTimerExpire()
    Assets.playSound("drive")
    Game:gameOver(Game.battle:getSoulLocation())
end

function Sencounter:onActionsStart()
    self.turns = self.turns + 1
end

function Sencounter:beforeStateChange(old,new) 
    if new == "ENEMYDIALOGUE" and #Game.battle.enemies > 0 then
		local cutscene = Game.battle:startCutscene("spamton_ex.master")
		cutscene:after(function()
            Game.battle:setState("DIALOGUEEND")
		end)
	end
end
function Sencounter:update()
    super.update(self)
end

function Sencounter:onFunnyYellowCheat()
    Assets.playSound("carhonk")
    -- Attack increases faster and faster
    Game.battle.enemies[1].attack = Game.battle.enemies[1].attack + self.funnycheat
    Game.battle.enemies[1].sprite.head.sprite.color = COLORS.red
    Game.battle.enemies[1].sprite:inflateEgo{
        {0.15, 2},
        {0.05, 2},
        {0.15, 1},
        {0.15, 1},
        {0.15, 2},
        {0.25, 2.5},
        {0.15, 1},
    }
end

function Sencounter:createSoul(x,y,color)
    return YellowSoul(x,y)
end

return Sencounter
