local config = {
	{ position = { x = 33789, y = 32868, z = 7 }, destination = { x = 33634, y = 32770, z = 7 }},
	{ position = { x = 33633, y = 32770, z = 7 }, destination = { x = 33778, y = 32661, z = 7 }},
	{ position = { x = 33777, y = 32660, z = 7 }, destination = { x = 33904, y = 32760, z = 7 }},
	
	{ position = { x = 33903, y = 32759, z = 7 }, destination = { x = 33790, y = 32868, z = 7 }},
}

local entrance = Action()
function entrance.onUse(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	if player:getLevel() < 150 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Necesitas al menos nivel 150 para entrar.")
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return false
	end
	for _, entry in pairs(config) do
		if Position(entry.position) == item:getPosition() then
			player:teleportTo(Position(entry.destination))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	end
end

for _, entry in pairs(config) do
	entrance:position(entry.position)
end
entrance:register()
