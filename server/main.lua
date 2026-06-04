lib.locale()

local resourceName = 'pl-checkplayermoney'
local framework    = exports.pl_lib:GetFramework()

exports.pl_lib:CheckVersion(resourceName, true)

-- Builds the framework-specific SQL WHERE clause table
local SQL = {}

if framework == 'esx' then
    SQL.checkbank = [[
        SELECT identifier, firstname, lastname,
               JSON_EXTRACT(accounts, '$.bank') AS bank_amount
        FROM users
        WHERE CAST(JSON_EXTRACT(accounts, '$.bank') AS DECIMAL) > ?
    ]]
    SQL.checkcashandcrypto = [[
        SELECT identifier, firstname, lastname,
               JSON_EXTRACT(accounts, '$.bank')         AS bank_amount,
               JSON_EXTRACT(accounts, '$.black_money')  AS crypto_amount,
               JSON_EXTRACT(accounts, '$.money')        AS cash_amount
        FROM users
        WHERE CAST(JSON_EXTRACT(accounts, '$.bank') AS DECIMAL) > ?
    ]]
    SQL.checktoppeople = [[
        SELECT identifier, firstname, lastname,
               JSON_EXTRACT(accounts, '$.bank')         AS bank_amount,
               JSON_EXTRACT(accounts, '$.black_money')  AS crypto_amount,
               JSON_EXTRACT(accounts, '$.money')        AS cash_amount
        FROM users
        ORDER BY CAST(JSON_EXTRACT(accounts, '$.bank') AS DECIMAL) DESC
        LIMIT ?
    ]]
elseif framework == 'qb' or framework == 'qbox' then
    SQL.checkbank = [[
        SELECT citizenid, name,
               JSON_EXTRACT(money, '$.bank') AS bank_amount
        FROM players
        WHERE CAST(JSON_EXTRACT(money, '$.bank') AS DECIMAL) > ?
    ]]
    SQL.checkcashandcrypto = [[
        SELECT citizenid, name,
               JSON_EXTRACT(money, '$.bank')   AS bank_amount,
               JSON_EXTRACT(money, '$.crypto') AS crypto_amount,
               JSON_EXTRACT(money, '$.cash')   AS cash_amount
        FROM players
        WHERE CAST(JSON_EXTRACT(money, '$.bank') AS DECIMAL) > ?
    ]]
    SQL.checktoppeople = [[
        SELECT citizenid, name,
               JSON_EXTRACT(money, '$.bank')   AS bank_amount,
               JSON_EXTRACT(money, '$.crypto') AS crypto_amount,
               JSON_EXTRACT(money, '$.cash')   AS cash_amount
        FROM players
        ORDER BY CAST(JSON_EXTRACT(money, '$.bank') AS DECIMAL) DESC
        LIMIT ?
    ]]
else
    print('^1[' .. resourceName .. '] No compatible framework detected — script disabled.^0')
end

local function isAllowed(src)
    return IsPlayerAceAllowed(src, 'checkplayermoney')
end

local function denyLog(src)
    local id   = exports.pl_lib:GetPlayerIdentifier(src) or 'unknown'
    local name = exports.pl_lib:GetPlayerName(src)       or 'unknown'
    print('**Name:** ' .. name .. '\n**Identifier:** ' .. id .. locale('cheater'))
end

local function buildRow(row)
    return {
        cid          = row.identifier or row.citizenid,
        name         = (row.firstname and row.lastname)
                       and (row.firstname .. ' ' .. row.lastname)
                       or  row.name,
        bankAmount   = row.bank_amount,
        crypto_amount = row.crypto_amount,
        cash_amount  = row.cash_amount,
    }
end

-- ── callbacks ────────────────────────────────────────────────────────────────

lib.callback.register('pl-checkplayermoney:server:checkbank', function(source, rawAmount)
    local src    = source
    local amount = tonumber(rawAmount)
    if not amount or amount < 0 then return end
    if not isAllowed(src) then denyLog(src) return end
    if not SQL.checkbank then return end

    MySQL.query(SQL.checkbank, {amount}, function(result)
        if result and #result > 0 then
            local playerData = {}
            for _, row in ipairs(result) do
                table.insert(playerData, {
                    cid        = row.identifier or row.citizenid,
                    name       = (row.firstname and row.lastname)
                                 and (row.firstname .. ' ' .. row.lastname)
                                 or  row.name,
                    bankAmount = row.bank_amount,
                })
            end
            TriggerClientEvent('pl-checkplayermoney:SendPlayerBank', src, playerData)
        else
            TriggerClientEvent('pl-checkplayermoney:notification', src, locale('no_result'), 'error')
        end
    end)
end)

lib.callback.register('pl-checkplayermoney:server:checkcashandcrypto', function(source, rawAmount)
    local src    = source
    local amount = tonumber(rawAmount)
    if not amount or amount < 0 then return end
    if not isAllowed(src) then denyLog(src) return end
    if not SQL.checkcashandcrypto then return end

    MySQL.query(SQL.checkcashandcrypto, {amount}, function(result)
        if result then
            local playerData = {}
            for _, row in ipairs(result) do
                table.insert(playerData, buildRow(row))
            end
            TriggerClientEvent('pl-checkplayermoney:SendPlayerCashandCrypto', src, playerData)
        else
            TriggerClientEvent('pl-checkplayermoney:notification', src, locale('no_result'), 'error')
        end
    end)
end)

lib.callback.register('pl-checkplayermoney:server:checktoppeople', function(source, rawLimit)
    local src   = source
    local limit = tonumber(rawLimit)
    if not limit or limit < 1 or limit > 1000 then return end
    if not isAllowed(src) then denyLog(src) return end
    if not SQL.checktoppeople then return end

    MySQL.query(SQL.checktoppeople, {limit}, function(result)
        if result and #result > 0 then
            local playerData = {}
            for _, row in ipairs(result) do
                table.insert(playerData, buildRow(row))
            end
            TriggerClientEvent('pl-checkplayermoney:SendPlayerCashandCrypto', src, playerData)
        else
            TriggerClientEvent('pl-checkplayermoney:notification', src, locale('no_result'), 'error')
        end
    end)
end)

-- ── command ──────────────────────────────────────────────────────────────────

RegisterCommand(Config.Command, function(source)
    local src = source
    if isAllowed(src) then
        TriggerClientEvent('pl-checkplayermoney:openmenu', src)
    else
        TriggerClientEvent('pl-checkplayermoney:notification', src, locale('not_allowed'), 'error')
    end
end)

-- ── startup message ──────────────────────────────────────────────────────────

SetTimeout(1500, function()
    print('^1[' .. resourceName .. '] ^2Thank you for Downloading the Script^0')
    print('^1[' .. resourceName .. '] ^2Join our Discord for support: https://discord.gg/c6gXmtEf3H^0')
    print('^1[' .. resourceName .. '] ^220%% OFF any script — coupon: SPECIAL20 → https://pulsescripts.com/^0')
end)
