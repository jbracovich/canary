local pushCreaturex = TalkAction("/coins")

function Player.getTransferableCoinsBalanceX(self)
	resultIdcoinx = db.storeQuery("SELECT `coins_transferable` FROM `accounts` WHERE `id` = " .. self:getAccountId())
	if not resultIdcoinx then return 0 end
	return result.getDataInt(resultIdcoinx, "coins_transferable")
end

function Player.setTransferableCoinsBalanceX(self, coins)
	if not self then
		return false
	end
	db.query("UPDATE `accounts` SET `coins_transferable` = " .. coins .. " WHERE `id` = " .. self:getAccountId())
	return true
end

function pushCreaturex.onSay(player, words, param)
	local howtouse = "How to use:\n /coins [playername], add, [value] | \n /coins [playername], remove \n(don't use [])"
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end
	if param == "" then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "missing parameter \n" ..howtouse)
		return false
	end
	local split = param:split(",")
	if not split[1] then
		return player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "missing command parameter \n" ..howtouse)
	end
	
	if not split[1] then
		return player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "missing parameter: PLAYER \n" ..howtouse)
	end
	local target = Player(split[1])
	if not target then
		return player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A player ".. split[1] .." is not online. \n" ..howtouse)
	end
	if not split[2] then
		return player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "missing parameter: ACTION (add/remove)\n" ..howtouse)
	end
	
	split[2] = split[2]:gsub("^%s*(.-)$", "%1")
	if split[2] == "add" then
		local coinBanlance = target:getTransferableCoinsBalanceX() or 0
		if split[3] then
			local count = tonumber(split[3])
			local newBalance = coinBanlance + count
			if target:setTransferableCoinsBalanceX(newBalance) then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[" ..count.. "] Coins enviados para: [" ..target:getName().. "]")
			else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "missing parameter: VALUE. \n" ..howtouse)
				return true
			end
		end
	elseif split[2] == "remove" then
		local coinBanlance = target:getTransferableCoinsBalanceX() or 0
if target:setTransferableCoinsBalanceX(0) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Coins de [" ..target:getName().. "] definitive to 0")
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "it was not possible to execute this, consult to eddy sanchez. \n" ..howtouse)
			return true
		end
	end
	logCommand(player, words, param)
	return false
end

pushCreaturex:separator(" ")
pushCreaturex:groupType("god")
pushCreaturex:register()