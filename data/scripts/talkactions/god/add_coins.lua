-- /addcoins <tipo>, <player>, <quantidade>

local addCoins = TalkAction("/addcoins")

function addCoins.onSay(player, words, param)
	-- Criar log do comando
	logCommand(player, words, param)

	-- Verifica se os parâmetros foram passados
	if param == "" then
		player:sendCancelMessage("Usage: /addcoins <notransfer|transfer>, <player>, <amount>")
		return true
	end

	local split = param:split(",")
	if #split < 3 then
		player:sendCancelMessage("Usage: /addcoins <notransfer|transfer>, <player>, <amount>")
		return true
	end

	local coinType = split[1]:trim():lower() -- Tipo de coin (notransfer ou transfer)
	local name = split[2]:trim() -- Nome do player
	local amount = tonumber(split[3]) -- Quantidade

	-- Verifica se o tipo de moeda é válido
	if coinType ~= "notransfer" and coinType ~= "transfer" then
		player:sendCancelMessage("Invalid coin type. Use 'notransfer' or 'transfer'.")
		return true
	end

	-- Verifica se o nome do jogador é válido
	local normalizedName = Game.getNormalizedPlayerName(name)
	if not normalizedName then
		player:sendCancelMessage("Player '" .. name .. "' does not exist.")
		return true
	end
	name = normalizedName

	-- Verifica se o valor é válido
	if not amount or amount == 0 then
		player:sendCancelMessage("Invalid amount.")
		return true
	end

	local targetPlayer = Player(name)
	if not targetPlayer then
		player:sendCancelMessage("Player '" .. name .. "' is not online.")
		return true
	end

	-- Define se vai adicionar ou remover
	local action = "added"
	if amount < 0 then
		action = "removed"
		amount = math.abs(amount)
	end

	-- Aplica a ação correta
	if coinType == "notransfer" then
		if action == "added" then
			targetPlayer:addTibiaCoins(amount)
		else
			targetPlayer:removeTibiaCoins(amount)
		end
	elseif coinType == "transfer" then
		if action == "added" then
			targetPlayer:addTransferableCoins(amount)
		else
			targetPlayer:removeTransferableCoins(amount)
		end
	end

	-- Mensagens de confirmação
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Successfully " .. action .. " " .. amount .. " " .. (coinType == "notransfer" and "Tibia Coins" or "Transferable Coins") .. " to " .. name .. ".")
	targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, player:getName() .. " " .. action .. " " .. amount .. " " .. (coinType == "notransfer" and "Tibia Coins" or "Transferable Coins") .. " from your character.")

	-- Log da operação
	logger.info("{} {} {} {} to {} player", player:getName(), action, amount, (coinType == "notransfer" and "Tibia Coins" or "Transferable Coins"), name)

	return true
end

addCoins:separator(" ")
addCoins:groupType("god")
addCoins:register()