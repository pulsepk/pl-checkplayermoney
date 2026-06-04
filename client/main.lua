lib.locale()

local framework = exports.pl_lib:GetFramework()

-- ── notifications ─────────────────────────────────────────────────────────────

RegisterNetEvent('pl-checkplayermoney:notification')
AddEventHandler('pl-checkplayermoney:notification', function(message, ntype)
    exports.pl_lib:Notify('', message, ntype or 'success')
end)

-- ── bank-only results ─────────────────────────────────────────────────────────

RegisterNetEvent('pl-checkplayermoney:SendPlayerBank')
AddEventHandler('pl-checkplayermoney:SendPlayerBank', function(playerData)
    local options = {}
    for _, player in ipairs(playerData) do
        options[#options + 1] = {
            title       = '🧑 ' .. player.name,
            description = string.format('🏦 %s | 🆔 %s', player.bankAmount, player.cid),
            metadata    = {
                { label = 'Name',         value = player.name },
                { label = 'Citizen ID',   value = player.cid },
                { label = 'Bank Balance', value = '$' .. player.bankAmount },
            },
        }
    end
    exports.pl_lib:ContextMenu('pl-checkplayermoney', '💰 Player Bank Info', options)
end)

-- ── cash + crypto/black-money results ────────────────────────────────────────

RegisterNetEvent('pl-checkplayermoney:SendPlayerCashandCrypto')
AddEventHandler('pl-checkplayermoney:SendPlayerCashandCrypto', function(playerData)
    local cryptoLabel = framework == 'esx' and 'Black Money' or 'Crypto'
    local options     = {}
    for _, player in ipairs(playerData) do
        options[#options + 1] = {
            title       = '🧑 ' .. player.name,
            description = string.format('💵 %s | 🏦 %s | 🆔 %s | 🪙 %s',
                player.cash_amount, player.bankAmount, player.cid, player.crypto_amount),
            metadata    = {
                { label = 'Name',         value = player.name },
                { label = 'Citizen ID',   value = player.cid },
                { label = 'Cash',         value = '$' .. player.cash_amount },
                { label = 'Bank Balance', value = '$' .. player.bankAmount },
                { label = cryptoLabel,    value = '$' .. player.crypto_amount },
            },
        }
    end
    exports.pl_lib:ContextMenu('pl-checkplayermoney', '💰 Player Wallet Overview', options)
end)

-- ── menu ──────────────────────────────────────────────────────────────────────

RegisterNetEvent('pl-checkplayermoney:openmenu')
AddEventHandler('pl-checkplayermoney:openmenu', function()
    local isEsx       = framework == 'esx'
    local extraLabel  = isEsx and '💵 Include Cash + Black Money' or '💵 Include Cash + Crypto'
    local extraDesc   = 'Check to include cash and ' .. (isEsx and 'black money' or 'crypto')

    local input = exports.pl_lib:ShowInputDialog('📊 Check Player Money', {
        {
            type        = 'number',
            label       = '🔝 Show Top Players',
            description = locale('enter_top_people') or 'Enter how many top players to display',
        },
        {
            type        = 'number',
            label       = '💰 Minimum Bank Balance',
            description = locale('minimum_bank') or 'Players with bank above this amount',
        },
        {
            type        = 'checkbox',
            label       = extraLabel,
            description = extraDesc,
        },
    })

    if not input then return end

    local topPeople         = input[1]
    local minimumBankAmount = tonumber(input[2])
    local includeExtras     = input[3]

    if topPeople and topPeople > 0 then
        lib.callback.await('pl-checkplayermoney:server:checktoppeople', false, topPeople)
    elseif minimumBankAmount then
        if includeExtras then
            lib.callback.await('pl-checkplayermoney:server:checkcashandcrypto', true, minimumBankAmount)
        else
            lib.callback.await('pl-checkplayermoney:server:checkbank', false, minimumBankAmount)
        end
    end
end)
