local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('pl-checkplayermoney:notification')
AddEventHandler('pl-checkplayermoney:notification', function(message, type)
    if Config.Notify == 'qb' then
        QBCore.Functions.Notify(message, type)
    elseif Config.Notify == 'ox' then
        TriggerEvent('ox_lib:notify', {description = message, type = type or "success"})
    elseif Config.Notify == 'okok' then
        TriggerEvent('okokNotify:Alert', message, 6000, type)
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
                {label = 'bank', value = playerBankAmount.bankAmount},
                {label = 'cid', value = playerBankAmount.cid},
                {label = 'name', value = playerBankAmount.name},
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
        
        local option = {
            title = playerBankAmount.name,
            description = 'Bank: ' .. playerBankAmount.bankAmount .. ' | Citizen ID: ' .. playerBankAmount.cid..' | Cash: '..playerBankAmount.cash_amount..' | Crypto: '..playerBankAmount.crypto_amount,
            metadata = {
                {label = 'bank', value = playerBankAmount.bankAmount},
                {label = 'cash', value = playerBankAmount.cash_amount},
                {label = 'crypto', value = playerBankAmount.crypto_amount},
                {label = 'cid', value = playerBankAmount.cid},
                {label = 'name', value = playerBankAmount.name},
            },
            args = {
                bank = playerBankAmount.bankAmount,
                cash = playerBankAmount.cash_amount,
                crypto = playerBankAmount.crypto_amount,
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

RegisterNetEvent('pl-checkplayermoney:openmenu')
AddEventHandler('pl-checkplayermoney:openmenu', function()
    local input = lib.inputDialog('Check Player Money', {
        {type = 'number', label = 'Top People', description = 'Please Enter the top people you want to check'},
        {type = 'number', label = 'Amount', description = 'Enter Minimum Bank Amount'},
        {type = 'checkbox', label = 'Show Cash and Crypto'},
    })
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

