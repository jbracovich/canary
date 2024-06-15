local BuffItem = Action()

-- Configuración del ítem de buff
local BUFF_ITEM_ID = 45672 -- Cambia este ID por el del ítem que deseas usar
local BUFF_DURATION = 60 -- Duración del buff en minutos (60 minutos)
local DAMAGE_MULTIPLIER = 1.5
local DEFENSE_MULTIPLIER = 1.5

function BuffItem.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Establecer el valor de almacenamiento del buff
    player:setStorageValue(Karin.PlayerSetup.Buff.Storage, 1)

    -- Aplicar efectos visuales y mensaje
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You feel a surge of power!")
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
    
    -- Establecer los multiplicadores temporales
    Karin.PlayerSetup.Buff.DAMAGE_MULTIPLIER = DAMAGE_MULTIPLIER
    Karin.PlayerSetup.Buff.DEFENSE_MULTIPLIER = DEFENSE_MULTIPLIER

    -- Eliminar el ítem del inventario del jugador
    item:remove(1)

    -- Programar la eliminación del buff después de la duración especificada
    addEvent(function()
        player:setStorageValue(Karin.PlayerSetup.Buff.Storage, -1)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The surge of power fades away.")
        Karin.PlayerSetup.Buff.DAMAGE_MULTIPLIER = 1.0
        Karin.PlayerSetup.Buff.DEFENSE_MULTIPLIER = 1.0
    end, BUFF_DURATION * 60 * 1000)

    return true
end

BuffItem:id(45672)
BuffItem:register()

