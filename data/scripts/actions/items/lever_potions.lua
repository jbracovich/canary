local leverConfig = {
    [1800] = {requiredItem = 45734, requiredCount = 1, rewardItem = 45553, rewardCount = 1, position = {x = 32359, y = 32232, z = 7}},
    [1801] = {requiredItem = 45734, requiredCount = 1, rewardItem = 45554, rewardCount = 1, position = {x = 32359, y = 32233, z = 7}},
    [1802] = {requiredItem = 45734, requiredCount = 1, rewardItem = 45555, rewardCount = 1, position = {x = 32359, y = 32234, z = 7}},
    -- Añadir más configuraciones según sea necesario
}

local leverAction = Action()

function leverAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
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

    if player:getItemCount(config.requiredItem) < config.requiredCount then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You do not have boss token to use this lever.")
        return false
    end

    player:removeItem(config.requiredItem, config.requiredCount)
    player:addItem(config.rewardItem, config.rewardCount)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have received your reward.")
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)

    return true
end

for uid, _ in pairs(leverConfig) do
    leverAction:uid(uid)
end

leverAction:register()


