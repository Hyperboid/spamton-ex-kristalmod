local scenes = {}
local chara = setmetatable({},{
    __index = function (t, k)
        return ({
            kris = Game.battle.party[1],
            susi = Game.battle.party[2],
            rals = Game.battle.party[3],
            spam = Game.battle.enemies[1]
        })[k]
    end
})
local function simpleDialog(text)
    return function(cutscene)
        cutscene:battlerText(chara.spam, text)
    end
end
scenes.turnbyturn = {
    function(cutscene)
        cutscene:battlerText(chara.spam,Dedent[==[
            HOLY [Howitzer]!! I'M
            SO [Ex] I CAN [Almost]
            SEE PAST THE DARK!]==])
        chara.spam.sprite:setSerious(true)
        cutscene:battlerText(chara.spam,"[speed:0.2]...[speed:0.6] [Almost].")
        chara.spam.sprite:setSerious(false)
        cutscene:battlerText(chara.spam,Dedent[==[
            KRIS! MY [Little sponge]
            BE A [[BIG SHOT!!]] AND
            GIMME THAT [Soul.]
            YOU GOT!!!]==])
    end,
}
function scenes.fallback(cutscene)
    cutscene:battlerText(chara.spam, {
        Utils.pick({"KRIS! YOU [Little Sponge]", "SUSIE! YOU [Chalk Eater]", "RALSEI! YOU [Scringly Dingly]!"}),
    })
end
---@param cutscene BattleCutscene
function scenes.master(cutscene)
	local enc = Game.battle.encounter
	local spamton = Game.battle.enemies[1]
	-- cutscene:battlerText(spamton, {"[voice:spamton]I HAVE [Becomed] OMEGA", "NOW YOU [Canned] HURT ME [Jack]"}, spamfiguration)
	if scenes.turnbyturn[enc.turns] then
		scenes.turnbyturn[enc.turns](cutscene)
    else
        scenes.fallback(cutscene)
	end
end
return scenes