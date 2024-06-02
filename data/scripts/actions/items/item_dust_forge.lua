local dust = Action()

function dust.onUse(player, item, fromPosition, target, toPosition, isHotkey)
local amount = 25 -- quantidade de dusts que o item vai dar
local totalDusts = player:getForgeDusts()
local limitDusts = 1000 -- quantidade maxima de dusts
  
	if (totalDusts + amount) < limitDusts then
		player:addForgeDusts(amount)
	  
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Recibiste "..amount.." Dusts")
		item:remove(1)
		return true
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "No es Posible Recibir mas de 1000")
	end
end

dust:id(37160) -- ID do item a ser transformado em dusts
dust:register()
