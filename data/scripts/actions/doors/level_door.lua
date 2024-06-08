local doorIds = {}
for index, value in ipairs(LevelDoorTable) do
    if not table.contains(doorIds, value.openDoor) then
        table.insert(doorIds, value.openDoor)
    end

    if not table.contains(doorIds, value.closedDoor) then
        table.insert(doorIds, value.closedDoor)
    end
end

local levelDoor = Action()
function levelDoor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    for index, value in ipairs(LevelDoorTable) do
        if value.closedDoor == item.itemid then
            if item.actionid > 0 and player:getLevel() >= item.actionid - 1000 then
                item:transform(value.openDoor)
                item:getPosition():sendSingleSoundEffect(SOUND_EFFECT_TYPE_ACTION_OPEN_DOOR)
                player:teleportTo(toPosition, true)
                return true
            else
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Only the worthy may pass.")
                return true
            end
        end
    end

    if Creature.checkCreatureInsideDoor(player, toPosition) then
        return true
    end
    return true
end

for index, value in ipairs(doorIds) do
    levelDoor:id(value)
end

levelDoor:register()

function Creature.checkCreatureInsideDoor(player, position)
    local tile = Tile(position)
    if not tile then
        return false
    end

    local topCreature = tile:getTopCreature()
    if not topCreature then
        return false
    end

    if topCreature then
        -- Add logic to handle the creature found inside the door
    end

    return false
end
