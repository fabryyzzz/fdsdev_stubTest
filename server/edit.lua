logconfig = {
    "", -- 1: Evidence created
    "", -- 2: Evidence deleted
}

function getCore()
    if Config.Framework == 'esx' then 
        return exports['es_extended']:getSharedObject() 
    elseif Config.Framework == 'qb-core' then 
        return exports['qb-core']:GetCoreObject()
    end
end

CORE = getCore()
function GetIdentifier(src)
    if Config.Framework == "esx" then 
        local xPlayer = CORE.GetPlayerFromId(src)
        return xPlayer.identifier
    elseif Config.Framework == "qb" then
        return CORE.Functions.GetIdentifier(src, 'license')
    end
end 

function GetDob(src)
    if Config.Framework == 'esx' then 
        return ESX.GetPlayerFromId(src).dateofbirth
    elseif Config.Framework == 'qb' then 
        return CORE.Functions.GetPlayer(src).charinfo.birthdate
    end
end

function GetFullName(src)
    if Config.Framework == 'esx' then 
        return (CORE.GetPlayerFromId(src).firstname and CORE.GetPlayerFromId(src).lastname and (CORE.GetPlayerFromId(src).firstname .. " " .. ESX.GetPlayerFromId(src).lastname) or CORE.GetPlayerFromId(src).name)
    elseif Config.Framework == 'qb' then 
        return CORE.Functions.GetPlayer(source).charinfo.firstname .. " " .. CORE.Functions.GetPlayer(source).charinfo.lastname
    end
end

function GetJob(src)
    if Config.Framework == 'esx' then 
        return (CORE.GetPlayerFromId(src).job.name)
    elseif Config.Framework == 'qb' then 
        return CORE.Functions.GetPlayer(src).PlayerData.job.name
    end
end
function GetJobGrade(src)
    if Config.Framework == 'esx' then
        return (CORE.GetPlayerFromId(src).job.grade)
    elseif Config.Framework == 'qb' then 
        return CORE.Functions.GetPlayer(src).PlayerData.job.grade
    end
end