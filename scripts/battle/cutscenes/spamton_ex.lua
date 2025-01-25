local scenes = {}
local function simpleDialog(text)
    if type(text) ~= "table" then text = {text} end
    return function(cutscene, spamton)
        for i = 1, #text do
            cutscene:battlerText(spamton, text[i])
        end
    end
end

---@type (fun(cutscene:BattleCutscene, spamton: EnemyBattler.spamton_ex): string)[]
scenes.turnbyturn = {
    function(cutscene, spamton)
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
        return "basic"
    end,
}
function scenes.default(cutscene, spamton, kris, susie, ralsei)
    cutscene:battlerText(spamton, {
        Utils.pick({"KRIS! YOU [Little Sponge]", "SUSIE! YOU [Chalk Eater]", "RALSEI! YOU [Scringly Dingly]!"}),
    })
    return "bluepipistest"
end

for i=1,#scenes.turnbyturn do
    scenes["turn_"..i] = scenes.turnbyturn[i]
end

return scenes