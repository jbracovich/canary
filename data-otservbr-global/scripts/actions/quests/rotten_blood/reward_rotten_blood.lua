-----------------------------
-- Spirit of Purity Mount function

local spiritofpurityMount = Action()

function spiritofpurityMount.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local mountID = 217
    local storage = 10000 -- Define el valor de almacenamiento que usarás

    -- Verifica si el jugador ya tiene la montura
    if player:hasMount(mountID) then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have Spirit of Purity mount!")
        return false
    end

    -- Verifica si el item usado es el correcto
    if table.contains({ 44048 }, item.itemid) then
        -- Verifica si el jugador tiene al menos 4 de esos items
        if player:getItemCount(44048) >= 4 then
            player:removeItem(44048, 4)
            player:addMount(mountID)
            player:setStorageValue(storage, 1)
            player:addAchievement("You got Horse Power")
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations! You won Spirit of Purity mount.")
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations! You won The Spirit of Purity achievement.")
            player:getPosition():sendMagicEffect(CONST_ME_HOLYDAMAGE)
            return true
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have the necessary items!")
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
            return false
        end
    end
end

spiritofpurityMount:id(44048)
spiritofpurityMount:register()
