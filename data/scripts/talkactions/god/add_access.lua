local addaccess = TalkAction("/addaccess")

local accessList = {
	rotten = {
		{id = 47952, value = 1}
	},
	falcons = {
		{id = 46001, value = 1}, {id = 46017, value = 1}, {id = 46018, value = 4}, {id = 46019, value = 1},
		{id = 46020, value = 1}, {id = 46021, value = 1}, {id = 46022, value = 1}, {id = 46023, value = 1},
		{id = 46024, value = 1}, {id = 46025, value = 1}, {id = 46026, value = 1}, {id = 46027, value = 1},
		{id = 46028, value = 1}, {id = 46029, value = 1}, {id = 46030, value = 1}
	},
	asuras = {
		{id = 46001, value = 1}, {id = 46002, value = 1}, {id = 46003, value = 1}, {id = 46004, value = 1},
		{id = 46005, value = 1}, {id = 46006, value = 1}, {id = 46007, value = 1}, {id = 46008, value = 1},
		{id = 46009, value = 1}, {id = 46010, value = 1}, {id = 46011, value = 1}, {id = 46012, value = 1},
		{id = 46013, value = 1}, {id = 46014, value = 1}, {id = 46015, value = 1}, {id = 46016, value = 1}
	}
}

function addaccess.onSay(player, words, param)
	-- Create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local split = param:split(",")
	if #split < 2 then
		player:sendCancelMessage("Usage: /addaccess <player name>, <'rotten', 'falcons','asuras'>")
		return true
	end

	local playerName = split[1]
	local target = Player(playerName)

	if not target then
		player:sendCancelMessage("Player not found.")
		return true
	end

	local accessParam = string.trim(split[2])
	local accessEntries = accessList[accessParam]

	if not accessEntries then
		player:sendCancelMessage("Invalid access name.")
		return false
	end

	for _, access in ipairs(accessEntries) do
		if target:getStorageValue(access.id) == -1 then
			local accessMsg = "Set access: " .. access.id .. "."
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, accessMsg)
			target:setStorageValue(access.id, access.value)
			target:save()
		end
	end

	local message = "Set access: " .. accessParam .. " to player " .. playerName .. "."
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)

	return true
end

addaccess:separator(" ")
addaccess:groupType("god")
addaccess:register()
