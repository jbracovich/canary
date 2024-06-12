local imbuement = Action()

function imbuement.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if configManager.getBoolean(configKeys.TOGGLE_IMBUEMENT_SHRINE_STORAGE) and player:getStorageValue(Storage.ForgottenKnowledge.Tomes) ~= 1 then
        return player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You did not collect enough knowledge from the ancient Shapers. Visit the Shaper temple in Thais for help.")
    end

    if not target then
        return player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to select a valid item to use the shrine.")
    end

    -- Verificación de que el target es un ítem válido
    local targetItem = target:isItem()
    if not targetItem then
        return player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can only use the shrine on a valid item.")
    end

    player:openImbuementWindow(target)
    return true
end

imbuement:id(25060, 25061, 25174, 25175, 25182, 25183, 24964)
imbuement:register()
