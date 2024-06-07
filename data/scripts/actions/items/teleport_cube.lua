local config = {
    price = 50000, -- Este valor ya no es necesario, pero lo dejamos por si en el futuro quieres volver a activarlo
    storage = 9007,
    cooldown = 10,
    locations = {
        { name="Trainer", position = Position(32365, 32236, 7) },
        { name="Thais", position = Position(32369, 32241, 7) },
        { name="Venore", position = Position(32957, 32076, 7) },
        { name="Carlin", position = Position(32360, 31782, 7) },
        { name="Ab'Dendriel", position = Position(32732, 31634, 7) },
        { name="Ankrahmun", position = Position(33194, 32853, 8) },
        { name="Liberty Bay", position = Position(32317, 32826, 7) },
        { name="Roshamuul", position = Position(33513, 32363, 6) },
        { name="DraconiaVip City", position = Position(32373, 32236, 7) },
        { name = "Darashia", position = Position(33213, 32454, 1) },
        { name = "Edron", position = Position(33217, 31814, 8) },
        { name = "Farmine", position = Position(33023, 31521, 11) },
        { name = "Issavi", position = Position(33921, 31477, 5) },
        { name = "Kazordoon", position = Position(32649, 31925, 11) },
        { name = "Krailos", position = Position(33657, 31665, 8) },
        { name = "Marapur", position = Position(33842, 32853, 7) },
        { name = "Port Hope", position = Position(32594, 32745, 7) },
        { name = "Rathleton", position = Position(33594, 31899, 6) },
        { name = "Svargrond", position = Position(32212, 31132, 7) },
        { name = "Yalahar", position = Position(32787, 31276, 7) }
    }
}

local function supremeCubeMessage(player, effect, message)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
    player:getPosition():sendMagicEffect(effect)
end

local function windowChoice(window, player, location)
    window:addChoice(location.name, function(player, button, choice)
        if button.name == "Select" then
            player:teleportTo(location.position, true)
            -- player:removeMoneyBank(config.price) -- Eliminada la deducción de dinero
            supremeCubeMessage(player, CONST_ME_TELEPORT, "Welcome to " .. location.name)
            player:setStorageValue(config.storage, os.time() + config.cooldown)
        end
        return true
    end)
end

local teleportCube = Action()

function teleportCube.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local inPz = player:getTile():hasFlag(TILESTATE_PROTECTIONZONE)
    local inFight = player:isPzLocked() or player:getCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT)
    local house = player:getHouse()

    if not inPz then
        supremeCubeMessage(player, CONST_ME_POFF, "You can only use this in a protection zone.")
        return true
    end

    if not player:isVip() then
        supremeCubeMessage(player, CONST_ME_POFF, "You need to be a VIP to use this.")
        return true
    end

    -- if player:getMoney() + player:getBankBalance() < config.price then -- Eliminada la verificación de dinero
    --     supremeCubeMessage(player, CONST_ME_POFF, "You don't have enough money.")
    --     return true
    -- end

    if player:getStorageValue(config.storage) > os.time() then
        local remainingTime = player:getStorageValue(config.storage) - os.time()
        supremeCubeMessage(player, CONST_ME_POFF, "You can use it again in: " .. remainingTime .. " seconds.")
        return true
    end

    local window = ModalWindow({
        title = "Teleport Modal",
        message = "Select a Location.", -- Eliminada la mención del precio
    })

    if house then
        windowChoice(window, player, { name = "House", position = house:getExitPosition() })
    end

    for _, location in pairs(config.locations) do
        windowChoice(window, player, location)
    end

    window:addButton("Select")
    window:addButton("Close")
    window:setDefaultEnterButton(0)
    window:setDefaultEscapeButton(1)
    window:sendToPlayer(player)

    return true
end

teleportCube:id(31633)
teleportCube:register()


