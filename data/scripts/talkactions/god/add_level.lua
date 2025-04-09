local function getExpForLevel(level)
    level = level - 1
    return ((50 * level * level * level) - (150 * level * level) + (400 * level)) / 3
end

local addLevel = TalkAction("/addlevel")

function addLevel.onSay(player, words, param)
    if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
        return true
    end

    if param == "" then
        player:sendCancelMessage("Command param required.")
        return false
    end

    local split = param:split(",")
    if not split[2] then
        player:sendCancelMessage("Insufficient parameters.")
        return false
    end

    local count = tonumber(split[2])
    if not count then
        player:sendCancelMessage("Invalid level count.")
        return false
    end

    -- Update online players
    for _, target in ipairs(Game.getPlayers()) do
        local targetLevel = target:getLevel() + count
        local targetExp = getExpForLevel(targetLevel)
        local addExp = targetExp - target:getExperience()
        target:addExperience(addExp, false)
    end

    -- Update offline players via database query
    local players = db.storeQuery("SELECT `name`, `level`, `experience` FROM `players`")
    if players ~= nil then
        repeat
            local playerName = result.getDataString(players, "name")
            local playerLevel = result.getDataInt(players, "level")
            local playerExp = result.getDataInt(players, "experience")

            local targetLevel = playerLevel + count
            local targetExp = getExpForLevel(targetLevel)
            local addExp = targetExp - playerExp

            -- Update the player's experience in the database
            db.query("UPDATE `players` SET `experience` = " .. targetExp .. " WHERE `name` = '" .. playerName .. "'")

        until not result.next(players)
        result.free(players)
    end

    return false
end

addLevel:separator(" ")
addLevel:groupType("god")
addLevel:register()