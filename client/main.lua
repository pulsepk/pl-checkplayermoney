lib.locale()

RegisterNetEvent('pl-checkplayermoney:notification')
AddEventHandler('pl-checkplayermoney:notification', function(message, type)
    if Config.Notify == 'qb' then
        TriggerEvent("QBCore:Notify", message, type, 6000)
    elseif Config.Notify == 'ox' then
        TriggerEvent('ox_lib:notify', {description = message, type = type or "success"})
    elseif Config.Notify == 'esx' then
        TriggerEvent("esx:showNotification", message)
    elseif Config.Notify == 'okok' then
        TriggerEvent('okokNotify:Alert', message, 6000, type)
    elseif Config.Notify == 'wasabi' then
        exports.wasabi_notify:notify('PL Check Money', message, 6000, type, false, 'fas fa-ghost')
    elseif Config.Notify == 'custom' then
        -- Add your custom notifications here
    end
end)


RegisterNetEvent('pl-checkplayermoney:SendPlayerBank')
AddEventHandler('pl-checkplayermoney:SendPlayerBank', function(playerData)
    local options = {}
    for _, playerBankAmount in ipairs(playerData) do
        
        local option = {
            title = playerBankAmount.name,
            description = 'Bank: ' .. playerBankAmount.bankAmount .. ' | Citizen ID: ' .. playerBankAmount.cid,
            metadata = {
                {label = 'Bank', value = playerBankAmount.bankAmount},
                {label = 'ID', value = playerBankAmount.cid},
                {label = 'Name', value = playerBankAmount.name},
            },
            args = {
                bank = playerBankAmount.bankAmount,
                cid = playerBankAmount.cid,
            },
        }
        table.insert(options, option)
    end
    lib.registerContext({
        id = 'pl-checkplayermoney',
        title = "Player Money",
        options = options
    })

    lib.showContext('pl-checkplayermoney')
end)

RegisterNetEvent('pl-checkplayermoney:SendPlayerCashandCrypto')
AddEventHandler('pl-checkplayermoney:SendPlayerCashandCrypto', function(playerData)
    local options = {}
    for _, playerBankAmount in ipairs(playerData) do
        local description = 'Bank: ' .. playerBankAmount.bankAmount .. 
                            ' | Citizen ID: ' .. playerBankAmount.cid .. 
                            ' | Cash: ' .. playerBankAmount.cash_amount
        if Config.Framework == "ESX" then
            description = description .. ' | Black Money: ' .. playerBankAmount.crypto_amount
        elseif Config.Framework == "QBCore" then
            description = description .. ' | Crypto: ' .. playerBankAmount.crypto_amount
        end
    
        local option = {
            title = playerBankAmount.name,
            description = description,
            metadata = {
                {label = 'Bank', value = playerBankAmount.bankAmount},
                {label = 'Cash', value = playerBankAmount.cash_amount},
                {label = 'ID', value = playerBankAmount.cid},
                {label = 'Name', value = playerBankAmount.name}
            },
            args = {
                bank = playerBankAmount.bankAmount,
                cash = playerBankAmount.cash_amount,
                crypto = playerBankAmount.crypto_amount,
                cid = playerBankAmount.cid
            }
        }
        local cryptoLabel = Config.Framework == "ESX" and "Black Money" or "Crypto"
        table.insert(option.metadata, {label = cryptoLabel, value = playerBankAmount.crypto_amount})
        table.insert(options, option)
    end
    
    lib.registerContext({
        id = 'pl-checkplayermoney',
        title = "Player Money",
        options = options
    })

    lib.showContext('pl-checkplayermoney')
end)

RegisterNetEvent('pl-checkplayermoney:openmenu')
AddEventHandler('pl-checkplayermoney:openmenu', function()
    local input = {
        {type = 'number', label = 'Top People', description = locale("enter_top_people")},
        {type = 'number', label = 'Amount', description = locale("minimum_bank")}
    }
    if Config.Framework == "ESX" then
        table.insert(input, {type = 'checkbox', label = 'Show Cash and Black Money'})
    elseif Config.Framework == "QBCore" then
        table.insert(input, {type = 'checkbox', label = 'Show Cash and Crypto'})
    end
    
    local input = lib.inputDialog('Check Player Money', input)
    if input then
        local topPeople = input[1]
        local minimumBankAmount = tonumber(input[2])
        local showCashAndCrypto = input[3]

        if topPeople then
            lib.callback.await('pl-checkplayermoney:server:checktoppeople', false, topPeople)
         elseif minimumBankAmount then
            if showCashAndCrypto then
                lib.callback.await('pl-checkplayermoney:server:checkcashandcrypto', true, minimumBankAmount)
            else
                lib.callback.await('pl-checkplayermoney:server:checkbank', false, minimumBankAmount)
            end
        end
    end
end)

