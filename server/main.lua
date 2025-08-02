lib.locale()
local resourceName ="pl-checkplayermoney"

lib.versionCheck('pulsepk/pl-checkplayermoney')

lib.callback.register('pl-checkplayermoney:server:checkbank', function(source, minimumBankAmount)
    local src = source
    local Player = getPlayer(src)
    local Identifier = GetPlayerIdentifier(src)
    local PlayerName = getPlayerName(src)
    if IsPlayerAceAllowed(src, 'checkplayermoney') then
        local query = nil
        if Config.Framework == "ESX" then
            query = "SELECT identifier, firstname, lastname, JSON_EXTRACT(accounts, '$.bank') AS bank_amount FROM users WHERE CAST(JSON_EXTRACT(accounts, '$.bank') AS DECIMAL) > " .. minimumBankAmount .. ";"
        elseif Config.Framework == "QBCore" then
            query = "SELECT citizenid, name, JSON_EXTRACT(money, '$.bank') AS bank_amount FROM players WHERE CAST(JSON_EXTRACT(money, '$.bank') AS DECIMAL) > " .. minimumBankAmount .. ";"
        else
            print("Error: Unknown framework!")
            return
        end
        MySQL.Async.fetchAll(query, {}, function(result)
            if result and #result > 0 then
                local playerData = {}
                for _, row in ipairs(result) do
                    local playerId = row.identifier or row.citizenid
                    local playerName = (row.firstname and row.lastname) and (row.firstname .. ' ' .. row.lastname) or row.name
                    local playerBankAmount = row.bank_amount

                    table.insert(playerData, {cid = playerId, name = playerName, bankAmount = playerBankAmount})
                end

                TriggerClientEvent('pl-checkplayermoney:SendPlayerBank', src, playerData)
            else
                TriggerClientEvent('pl-checkplayermoney:notification', src, locale("no_result"), 'error')
            end
        end)
    else
        print('**Name:** '..PlayerName..'\n**Identifier:** '..Identifier.. locale("cheater"))
    end 
end)



lib.callback.register('pl-checkplayermoney:server:checkcashandcrypto', function(source, minimumBankAmount)
    local src = source
    local Player = getPlayer(src)
    local Identifier = GetPlayerIdentifier(src)
    local PlayerName = getPlayerName(src)
    if IsPlayerAceAllowed(src, 'checkplayermoney') then
        local query = nil
        if Config.Framework == "ESX" then
            query = "SELECT identifier, firstname, lastname, JSON_EXTRACT(accounts, '$.bank') AS bank_amount, JSON_EXTRACT(accounts, '$.black_money') AS black_amount, JSON_EXTRACT(accounts, '$.money') AS cash_amount FROM users WHERE CAST(JSON_EXTRACT(accounts, '$.bank') AS DECIMAL) > " .. minimumBankAmount .. ";"
        elseif Config.Framework == "QBCore" then
            query = "SELECT citizenid, name, JSON_EXTRACT(money, '$.bank') AS bank_amount, JSON_EXTRACT(money, '$.crypto') AS crypto_amount, JSON_EXTRACT(money, '$.cash') AS cash_amount FROM players WHERE CAST(JSON_EXTRACT(money, '$.bank') AS DECIMAL) > " .. minimumBankAmount .. ";"
        else
            print("Error: Unknown framework!")
            return
        end
        MySQL.Async.fetchAll(query, {}, function(result)
            if result then
                local playerData = {}
                for _, row in ipairs(result) do
                    local playerId = row.identifier or row.citizenid
                    local playerName = (row.firstname and row.lastname) and (row.firstname .. ' ' .. row.lastname) or row.name
                    local playerBankAmount = row.bank_amount
                    local cryptoAmount = row.crypto_amount or row.black_amount
                    local cashAmount = row.cash_amount
                    table.insert(playerData, {cid = playerId, name = playerName, bankAmount = playerBankAmount,crypto_amount= cryptoAmount,cash_amount=cashAmount})
                end

                TriggerClientEvent('pl-checkplayermoney:SendPlayerCashandCrypto', source, playerData)
            else
                TriggerClientEvent('pl-checkplayermoney:notification',src,locale("no_result"),'error')
            end
        end)
    else
        print('**Name:** '..PlayerName..'\n**Identifier:** '..Identifier..locale("cheater"))
    end
end)


lib.callback.register('pl-checkplayermoney:server:checktoppeople', function(source, toppeople)
    local src = source
    local Player = getPlayer(src)
    local Identifier = GetPlayerIdentifier(src)
    local PlayerName = getPlayerName(src)
    if IsPlayerAceAllowed(src, 'checkplayermoney') then
        local query = nil
        if Config.Framework == "ESX" then
            query = "SELECT identifier, firstname, lastname, JSON_EXTRACT(accounts, '$.bank') AS bank_amount, JSON_EXTRACT(accounts, '$.black_money') AS black_amount, JSON_EXTRACT(accounts, '$.money') AS money_amount FROM users ORDER BY CAST(JSON_EXTRACT(accounts, '$.bank') AS DECIMAL) DESC LIMIT " .. toppeople .. ";"
        elseif Config.Framework == "QBCore" then
            query = "SELECT citizenid, name, JSON_EXTRACT(money, '$.bank') AS bank_amount, JSON_EXTRACT(money, '$.crypto') AS crypto_amount, JSON_EXTRACT(money, '$.cash') AS cash_amount FROM players ORDER BY CAST(JSON_EXTRACT(money, '$.bank') AS DECIMAL) DESC LIMIT " .. toppeople .. ";"
        else
            print("Error: Unknown framework!")
            return
        end
        MySQL.Async.fetchAll(query, {}, function(result)
            if result and #result > 0 then
                local playerData = {}
                for _, row in ipairs(result) do
                    local playerId = row.identifier or row.citizenid
                    local playerName = (row.firstname and row.lastname) and (row.firstname..' '..row.lastname) or row.name
                    local playerBankAmount = row.bank_amount
                    local cryptoAmount = row.black_amount or row.crypto_amount
                    local cashAmount = row.money_amount or row.cash_amount
    
                    table.insert(playerData, {
                        cid = playerId, 
                        name = playerName, 
                        bankAmount = playerBankAmount, 
                        crypto_amount = cryptoAmount, 
                        cash_amount = cashAmount
                    })
                end
    
                TriggerClientEvent('pl-checkplayermoney:SendPlayerCashandCrypto', src, playerData)
            else
                TriggerClientEvent('pl-checkplayermoney:notification', src, locale("no_result"), 'error')
            end
        end)
    else
        print('**Name:** '..PlayerName..'\n**Identifier:** '..Identifier..locale("cheater"))
    end
end)


RegisterCommand(Config.Command, function(source)
    local src = source
    if IsPlayerAceAllowed(src, 'checkplayermoney') then
        TriggerClientEvent('pl-checkplayermoney:openmenu', src)
    else
        TriggerClientEvent('pl-checkplayermoney:notification', src, locale("no_result"), 'error')
   end
end)

local WaterMark = function()
    SetTimeout(1500, function()
        print('^1['..resourceName..'] ^2Thank you for Downloading the Script^0')
        print('^1['..resourceName..'] ^2If you encounter any issues please Join the discord https://discord.gg/c6gXmtEf3H to get support..^0')
        print('^1['..resourceName..'] ^2Enjoy a secret 20% OFF any script of your choice on https://pulsescripts.com/^0')
        print('^1['..resourceName..'] ^2Using the coupon code: SPECIAL20 (one-time use coupon, choose wisely)^0')
    
    end)
end

WaterMark()
