local leverConfig = {
    [1799] = {rewardItem = 45672, cost = 10000000, rewardCount = 1, position = {x = 32359, y = 32231, z = 7}},
    -- Añadir más configuraciones según sea necesario
}

local leverShop = Action()

function leverShop.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local config = leverConfig[item.uid]
    if not config then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This lever is not configured correctly.")
        return false
    end

    local playerPosition = player:getPosition()
    if playerPosition.x ~= config.position.x or playerPosition.y ~= config.position.y or playerPosition.z ~= config.position.z then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to be at the specific position to use this lever.")
        return false
    end

    if not player:removeMoney(config.cost) then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You do not have enough money to use this lever.")
        return false
    end

    player:addItem(config.rewardItem, config.rewardCount)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have received your reward.")
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)

    return true
end

for uid, _ in pairs(leverConfig) do
    leverShop:uid(uid)
end

leverShop:register()
