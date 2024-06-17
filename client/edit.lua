CORE = nil
PlayerData = {}
if Config.Framework == "esx" then
    CORE = exports['es_extended']:getSharedObject()
    while CORE == nil do
        Citizen.Wait(0)
    end
    PlayerData = CORE.GetPlayerData()
else
    CORE = exports['qb-core']:GetCoreObject()
    while CORE == nil do
        Citizen.Wait(0)
    end
    PlayerData = CORE.Functions.GetPlayerData()
end

if Config.Framework == "qb" then
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        TriggerServerEvent("fdsdev_paraffinGlove:requestData")
        forensicFunction()
    end)
else
    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded',function(xPlayer, isNew, skin)
        TriggerServerEvent("fdsdev_paraffinGlove:requestData")
        forensicFunction()
    end)
end


function LoadScript()
    TriggerServerEvent("fdsdev_paraffinGlove:requestData")
    forensicFunction()
end

RegisterNetEvent('esx:setJob', function(job)
    PlayerData.job = job
    forensicFunction()
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = val
    forensicFunction()
end)

function AuthFunc()
    if PlayerData.job and Config.jobs[PlayerData.job.name] and PlayerData.job.grade >= Config.jobs[PlayerData.job.name] then
        return true
    end
end