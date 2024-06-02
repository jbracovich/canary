local frags = TalkAction("!frags")

function frags.onSay(player, words, param)
    local totalFrags = #player:getKills()
    player:sendTextMessage(MESSAGE_ATTENTION, "You have " .. #player:getKills() .. " unjustified kills.")
    return true
end

frags:separator(" ")
frags:groupType("normal")
frags:register()
