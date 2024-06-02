local config = {
	{ position = { x = 32114, y = 32013, z = 13 }, destination = { x = 32103, y = 31923, z = 13 }},
	{ position = { x = 32103, y = 31921, z = 13 }, destination = { x = 32114, y = 32015, z = 13 }},
}

local entrance = Action()
function entrance.onUse(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	if player:getLevel() < 100 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Necesitas al menos nivel 100 para entrar.")
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
