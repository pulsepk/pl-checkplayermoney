local ESX = GetResourceState('es_extended'):find('start') and exports['es_extended']:getSharedObject() or nil

if not ESX then return end

function getPlayer(target)
    local xPlayer = ESX.GetPlayerFromId(target)
    return xPlayer
end

function GetPlayerIdentifier(target)
    local xPlayer = ESX.GetPlayerFromId(target)
    return xPlayer.getIdentifier()
end

function getPlayerName(target)
    local xPlayer = ESX.GetPlayerFromId(target)
    return xPlayer.getName()
end

function GetJob(target)
    local xPlayer = ESX.GetPlayerFromId(target)
    return xPlayer.getJob().name
end