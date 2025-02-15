local QBCore = GetResourceState('qb-core'):find('start') and exports['qb-core']:GetCoreObject() or nil

if not QBCore then return end

function getPlayer(target)
    local xPlayer = QBCore.Functions.GetPlayer(target)
    return xPlayer
end

function GetPlayerIdentifier(target)
    local xPlayer = QBCore.Functions.GetPlayer(target)
    return xPlayer.PlayerData.citizenid
end

function getPlayerName(target)
    local xPlayer = QBCore.Functions.GetPlayer(target)

    return xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname
end

function GetJob(target)
    local xPlayer = QBCore.Functions.GetPlayer(target)
    return xPlayer.PlayerData.job.name
end