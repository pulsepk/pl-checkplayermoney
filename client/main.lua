lib.locale()

RegisterNetEvent('pl-checkplayermoney:notification')
AddEventHandler('pl-checkplayermoney:notification', function(message, type)
    if Config.Notify == 'ox' then
        TriggerEvent('ox_lib:notify', {description = message, type = type or "success"})
    elseif Config.Notify == 'custom' then
        -- Add your custom notifications here
    end
end)


RegisterNetEvent('pl-checkplayermoney:SendPlayerBank')
AddEventHandler('pl-checkplayermoney:SendPlayerBank', function(playerData)
    local options = {}
    for _, player in ipairs(playerData) do
        local option = {
            title = "🧑 " .. player.name,
            description = string.format("🏦 %s | 🆔 %s", player.bankAmount, player.cid),
            metadata = {
                {label = 'Name', value = player.name},
                {label = 'Citizen ID', value = player.cid},
                {label = 'Bank Balance', value = "$" .. player.bankAmount},
            },
            args = {
                bank = player.bankAmount,
                cid = player.cid,
            },
        }
        table.insert(options, option)
    end

    lib.registerContext({
        id = 'pl-checkplayermoney',
        title = "💰 Player Bank Info",
        options = options
    })

    lib.showContext('pl-checkplayermoney')
end)

RegisterNetEvent('pl-checkplayermoney:SendPlayerCashandCrypto')
AddEventHandler('pl-checkplayermoney:SendPlayerCashandCrypto', function(playerData)
    local options = {}
    for _, player in ipairs(playerData) do
        local cryptoLabel = Config.Framework == "ESX" and "Black Money" or "Crypto"
        local option = {
            title = "🧑 " .. player.name,
            description = string.format("💵 %s | 🏦 %s | 🆔 %s | 🪙 %s", player.cash_amount, player.bankAmount, player.cid, player.crypto_amount),
            metadata = {
                {label = 'Name', value = player.name},
                {label = 'Citizen ID', value = player.cid},
                {label = 'Cash', value = "$" .. player.cash_amount},
                {label = 'Bank Balance', value = "$" .. player.bankAmount},
                {label = cryptoLabel, value = "$" .. player.crypto_amount},
            },
            args = {
                bank = player.bankAmount,
                cash = player.cash_amount,
                crypto = player.crypto_amount,
                cid = player.cid
            }
        }

        table.insert(options, option)
    end

    lib.registerContext({
        id = 'pl-checkplayermoney',
        title = "💰 Player Wallet Overview",
        options = options
    })

    lib.showContext('pl-checkplayermoney')
end)

RegisterNetEvent('pl-checkplayermoney:openmenu')
AddEventHandler('pl-checkplayermoney:openmenu', function()
    local inputs = {
        {
            type = 'number',
            label = '🔝 Show Top Players',
            description = locale("enter_top_people") or "Enter how many top players to display"
        },
        {
            type = 'number',
            label = '💰 Minimum Bank Balance',
            description = locale("minimum_bank") or "Players with bank above this amount"
        }
    }

    -- Add checkbox depending on framework
    local checkboxLabel = (Config.Framework == "ESX")
        and '💵 Include Cash + Black Money'
        or '💵 Include Cash + Crypto'

    table.insert(inputs, {
        type = 'checkbox',
        label = checkboxLabel,
        description = "Check to include cash and " .. (Config.Framework == "ESX" and "black money" or "crypto")
    })

    local input = lib.inputDialog('📊 Check Player Money', inputs)

    if input then
        local topPeople = input[1]
        local minimumBankAmount = tonumber(input[2])
        local includeExtras = input[3]

        if topPeople and topPeople > 0 then
            lib.callback.await('pl-checkplayermoney:server:checktoppeople', false, topPeople)
        elseif minimumBankAmount then
            if includeExtras then
                lib.callback.await('pl-checkplayermoney:server:checkcashandcrypto', true, minimumBankAmount)
            else
                lib.callback.await('pl-checkplayermoney:server:checkbank', false, minimumBankAmount)
            end
        end
    end
end)


