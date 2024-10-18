local scenes = {}
local function simpleDialog(text)
    return function(cutscene, spamton, kris, susie, ralsei)
        cutscene:battlerText(spamton, text)
    end
end
scenes.turnbyturn = {
    function(cutscene, spamton, kris, susie, ralsei)
        cutscene:battlerText(spamton,Dedent[==[
            HOLY [Howitzer]!! I'M
            SO [Ex] I CAN [Almost]
            SEE PAST THE DARK!]==])
        spamton.sprite:setSerious(true)
        cutscene:battlerText(spamton,"[speed:0.2]...[speed:0.6] [Almost].")
        spamton.sprite:setSerious(false)
        cutscene:battlerText(spamton,Dedent[==[
            KRIS! MY [Little sponge]
            BE A [[BIG SHOT!!]] AND
            GIMME THAT [Soul.]
            YOU GOT!!!]==])
    end,
}
function scenes.fallback(cutscene, spamton, kris, susie, ralsei)
    cutscene:battlerText(spamton, {
        Utils.pick({"KRIS! YOU [Little Sponge]", "SUSIE! YOU [Chalk Eater]", "RALSEI! YOU [Scringly Dingly]!"}),
    })
end
---@param cutscene BattleCutscene
function scenes.master(cutscene)
	local enc = Game.battle.encounter
	local spamton = Game.battle.enemies[1]
    local kris = Game.battle.party[1]
    local susie = Game.battle.party[2]
    local ralsei = Game.battle.party[3]
	-- cutscene:battlerText(spamton, {"[voice:spamton]I HAVE [Becomed] OMEGA", "NOW YOU [Canned] HURT ME [Jack]"}, spamfiguration)
	if scenes.turnbyturn[Game.battle.turn_count] then
		scenes.turnbyturn[Game.battle.turn_count](cutscene, spamton, kris, susie, ralsei)
    else
        scenes.fallback(cutscene, spamton, kris, susie, ralsei)
	end
end
return scenes