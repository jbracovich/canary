local ban = TalkAction("/ban")

function ban.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local name, reason, duration = param:match("([^,]+),%s*(.-)%s*,%s*(%d+)")
	if not name then
		player:sendCancelMessage("Invalid parameters. Usage: /ban <name>, <reason>, <duration>")
		return false
	end

	local accountId = getAccountNumberByPlayerName(name)
	if accountId == 0 then
		return true
	end

	local resultId = db.storeQuery("SELECT 1 FROM `account_bans` WHERE `account_id` = " .. accountId)
	if resultId ~= false then
		Result.free(resultId)
		return true
	end

	local timeNow = os.time()
	local expiresAt = timeNow + (tonumber(duration) * 86400)
	db.query("INSERT INTO `account_bans` (`account_id`, `reason`, `banned_at`, `expires_at`, `banned_by`) VALUES (" .. accountId .. ", " .. db.escapeString(reason) .. ", " .. timeNow .. ", " .. expiresAt .. ", " .. player:getGuid() .. ")")

	local target = Player(name)
	if target then
		local text = target:getName() .. " has been banned"
		player:sendTextMessage(MESSAGE_ADMINISTRATOR, text)
		Webhook.sendMessage("Player Banned", text .. " reason: " .. reason .. ". (by: " .. player:getName() .. ")", WEBHOOK_COLOR_YELLOW, announcementChannels["serverAnnouncements"])
		target:remove()
	else
		player:sendTextMessage(MESSAGE_ADMINISTRATOR, name .. " has been banned.")
	end

	return true
end

ban:separator(" ")
ban:groupType("gamemaster")
ban:register()
