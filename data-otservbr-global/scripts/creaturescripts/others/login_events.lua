local loginEvents = CreatureEvent("LoginEvents")
function loginEvents.onLogin(player)
	local events = {
		"RookgaardAdvance",
		--Quests

		--Karin
		"KarinLogin",
		
		--Cults Of Tibia Quest
		"HealthPillar",
		"YalahariHealth",
	}

	for i = 1, #events do
		player:registerEvent(events[i])
	end
	return true
end

loginEvents:register()
