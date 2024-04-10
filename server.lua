local QBCore = exports['qb-core']:GetCoreObject()
lib.callback.register('pl-checkplayermoney:server:checkbank', function(source, minimumBankAmount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Identifier = QBCore.Functions.GetIdentifier(src, 'license')
    local PlayerName = Player.PlayerData.charinfo.firstname ..' '.. Player.PlayerData.charinfo.lastname
    if Player.PlayerData.job and Player.PlayerData.job.name == Config.AllowedJob then
        local query = "SELECT citizenid, name, JSON_EXTRACT(money, '$.bank') AS bank_amount FROM players WHERE CAST(JSON_EXTRACT(money, '$.bank') AS DECIMAL) > " .. minimumBankAmount .. ";"
        
        MySQL.Async.fetchAll(query, {}, function(result)
            if result then
                local playerData = {}
                for _, row in ipairs(result) do
                    local playerId = row.citizenid
                    local playerName = row.name
                    local playerBankAmount = row.bank_amount
                    table.insert(playerData, {cid = playerId, name = playerName, bankAmount = playerBankAmount})
                end

                TriggerClientEvent('pl-checkplayermoney:SendPlayerBank', source, playerData)
            else
                TriggerClientEvent('pl-checkplayermoney:notification',src,'No Result Fetched from the database','error')
            end
        end)
    else
        print('**Name:** '..PlayerName..'\n**Identifier:** '..Identifier..' Player tried to check players money. Most Probably a Cheater')
    end 
end)



lib.callback.register('pl-checkplayermoney:server:checkcashandcrypto', function(source, minimumBankAmount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Identifier = QBCore.Functions.GetIdentifier(src, 'license')
    local PlayerName = Player.PlayerData.charinfo.firstname ..' '.. Player.PlayerData.charinfo.lastname
    if Player.PlayerData.job and Player.PlayerData.job.name == Config.AllowedJob then
        local query = "SELECT citizenid, name, JSON_EXTRACT(money, '$.bank') AS bank_amount, JSON_EXTRACT(money, '$.crypto') AS crypto_amount, JSON_EXTRACT(money, '$.cash') AS cash_amount FROM players WHERE CAST(JSON_EXTRACT(money, '$.bank') AS DECIMAL) > " .. minimumBankAmount .. ";"
        
        MySQL.Async.fetchAll(query, {}, function(result)
            if result then
                local playerData = {}
                for _, row in ipairs(result) do
                    local playerId = row.citizenid
                    local playerName = row.name
                    local playerBankAmount = row.bank_amount
                    local cryptoAmount = row.crypto_amount
                    local cashAmount = row.cash_amount
                    table.insert(playerData, {cid = playerId, name = playerName, bankAmount = playerBankAmount,crypto_amount= cryptoAmount,cash_amount=cashAmount})
                end

                TriggerClientEvent('pl-checkplayermoney:SendPlayerCashandCrypto', source, playerData)
            else
                TriggerClientEvent('pl-checkplayermoney:notification',src,'No Result Fetched from the database','error')
            end
        end)
    else
        print('**Name:** '..PlayerName..'\n**Identifier:** '..Identifier..' Player tried to check players money. Most Probably a Cheater')
    end  
end)


lib.callback.register('pl-checkplayermoney:server:checktoppeople', function(source, toppeople)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Identifier = QBCore.Functions.GetIdentifier(src, 'license')
    local PlayerName = Player.PlayerData.charinfo.firstname ..' '.. Player.PlayerData.charinfo.lastname
    if Player.PlayerData.job and Player.PlayerData.job.name == Config.AllowedJob then
        local query = "SELECT citizenid, name, JSON_EXTRACT(money, '$.bank') AS bank_amount, JSON_EXTRACT(money, '$.crypto') AS crypto_amount, JSON_EXTRACT(money, '$.cash') AS cash_amount FROM players ORDER BY CAST(JSON_EXTRACT(money, '$.bank') AS DECIMAL) DESC LIMIT " .. toppeople .. ";"
        
        MySQL.Async.fetchAll(query, {}, function(result)
            if result then
                local playerData = {}
                for _, row in ipairs(result) do
                    local playerId = row.citizenid
                    local playerName = row.name
                    local playerBankAmount = row.bank_amount
                    local cryptoAmount = row.crypto_amount
                    local cashAmount = row.cash_amount

                    table.insert(playerData, {cid = playerId, name = playerName, bankAmount = playerBankAmount, crypto_amount = cryptoAmount, cash_amount=cashAmount})
                end

                TriggerClientEvent('pl-checkplayermoney:SendPlayerCashandCrypto', source, playerData)
            else
                TriggerClientEvent('pl-checkplayermoney:notification',src,'No Result Fetched from the database','error')
            end
        end)
    else
        print('**Name:** '..PlayerName..'\n**Identifier:** '..Identifier..' Player tried to check players money. Most Probably a Cheater')
    end   
end)


RegisterCommand(Config.Command, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player and Player.PlayerData then
        if Player.PlayerData.job and Player.PlayerData.job.name == Config.AllowedJob then
            TriggerClientEvent('pl-checkplayermoney:openmenu', src)
        else
            TriggerClientEvent('pl-checkplayermoney:notification', src, 'You are not allowed to use this', 'error')
        end
    end
end)