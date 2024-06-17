
ESX = exports['es_extended']:getSharedObject()

local guantoData = {}
local stubResults = {}

RegisterServerEvent("fdsdev_paraffinGlove:requestData", function()
    TriggerClientEvent("fdsdev_paraffinGlove:recieveData", source, stubResults, guantoData[GetIdentifier(source)] and guantoData[GetIdentifier(source)].stato or false)
end)

RegisterServerEvent("realm_script:guanto:syncData", function(bool)
    local src = source
    local identifier = GetIdentifier(src)
    if not guantoData[identifier] then 
        guantoData[identifier] = {
            identifier = identifier,
            stato = bool,
            shootday = os.date("%Y/%m/%d"),
        }
        MySQL.Async.execute('INSERT INTO fdsdev_gunpowderdata (identifier, stato, shootday) VALUES (@identifier, @stato, @shootday) ', {
            ["@stato"] =  bool,
            ["@shootday"] =  os.date("%Y/%m/%d"),
            ["@identifier"] =  identifier
        })

    else
        guantoData[identifier] = {
            identifier = identifier,
            stato = bool,
            shootday = os.date("%Y/%m/%d"),
        }
    end
end)

function SendLog(n, title, desc)
   local content = {
        {
        	["color"] = '15874618', --rosso
            ["title"] = title,
            ["description"] = desc,
            ["footer"] = {
                ["text"] = os.date("%x %X %p")
                
            }, 
        }
    }
  	PerformHttpRequest( logconfig[n], function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end

-- RegisterServerEvent("realm_script:guanto:requestLocalBool", function()
--     TriggerClientEvent("realm_script:guanto:recieveLocalBool", source, guantoData[src] or false)
-- end)

-- ESX.RegisterServerCallback("realm_script:guanto:getData", function(source, cb, idPlayer)
--     if idPlayer then
--         cb(guantoData[idPlayer] or false)
--     end
-- end)

RegisterNetEvent("fdsdev_paraffinGlove:testPlayer", function(id)
    TriggerClientEvent("fdsdev_paraffinGlove:beingTested", id, source, guantoData[GetIdentifier(source)])
end)
local lastId = 0
RegisterNetEvent("fdsdev_paraffinGlove:tested", function(srcMandante, data)
    local identifier = GetIdentifier(source)
    local newid = lastId + 1 
    stubResults[newid] = {
        id = newid,
        date = os.date("%d/%m/%y"),
        player = GetFullName(source), 
        -- player = "Kyle Johnson", 
        identifier = identifier,
        dob = GetDob(source),
        -- dob = "12/01/20",
        result = data.stato
    }
    TriggerClientEvent("fdsdev_paraffinGlove:tested", srcMandante, source, stubResults[newid])
    MySQL.Async.execute('INSERT INTO fdsdev_stubtest (date, player, identifier, dob, result, id) VALUES (@date, @player, @identifier, @dob, @result, @id) ', {
        ["@date"] =  stubResults[newid].date,
        ["@player"] =  stubResults[newid].player,
        ["@identifier"] =  stubResults[newid].identifier,
        ["@dob"] =  stubResults[newid].dob,
        ["@result"] = stubResults[newid].result,
        ["@id"] = newid,
    })
    
    SendLog(1, (locale.evidenceCreated):format(GetPlayerName(srcMandante), srcMandante, GetPlayerName(source), source, identifier, data.stato))
    TriggerClientEvent("fdsdev_paraffinGlove:recieveData", -1, stubResults)
end)

booleanisitua = {
    ["1"] = true,
    ["0"] = false
}
booleanisituadue = {
    ["true"] = true,
    ["false"] = false
}

Citizen.CreateThread(function()
    MySQL.Async.fetchAll('SELECT * FROM fdsdev_stubtest', {}, function(result)
        for i=1, #result, 1 do
            if lastId == 0 then 
                lastId = tonumber(result[i].id)
            end
            stubResults[tostring(result[i].id)] = result[i]
            stubResults[tostring(result[i].id)].result = booleanisitua[stubResults[tostring(result[i].id)].result]
            if result[i].id > lastId then
                lastId = tonumber(result[i].id)
            end
        end
    end)

    MySQL.Async.fetchAll('SELECT * FROM fdsdev_gunpowderdata', {}, function(result)
        for i=1, #result, 1 do
            guantoData[result[i].identifier] = result[i]
            guantoData[result[i].identifier].stato = booleanisituadue[guantoData[result[i].identifier].stato]
            local date = guantoData[result[i].identifier].shootday
            local reference = os.time{day=date:sub(9, 10), year=date:sub(1, 4), month=date:sub(6, 7)}
            local daysfrom = os.difftime(os.time(), reference) / (24 * 60 * 60) -- seconds in a day
            local wholedays = math.floor(daysfrom)
            if wholedays < 0 then
                wholedays = 0
            end
            if Config.DaysToClear - (wholedays or 0) <= 0 then
                guantoData[result[i].identifier].stato = false
            end
        end
    end)
end)


RegisterNetEvent("fdsdev_paraffinGlove:eliminaCio", function(id, due)
    local src = source
    if Config.jobs[GetJob(src)] and GetJobGrade(src) >= Config.jobs[GetJob(src)] then
        MySQL.Async.execute('DELETE FROM fdsdev_stubtest WHERE id = @id ', {
            ["@id"] = tonumber(id),
        })
        SendLog(2, (locale.evidenceDeleted):format(GetPlayerName(source), source, id, json.encode(stubResults[tonumber(id)])))
        stubResults[tostring(id)] = nil
        stubResults[tonumber(id)] = nil
        TriggerClientEvent("fdsdev_paraffinGlove:recieveData", -1, stubResults)
    end 
end)


AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
	if eventData.secondsRemaining == 120 then
        for k,v in pairs(guantoData) do 
            MySQL.Async.fetchAll('UPDATE fdsdev_gunpowderdata SET stato = @stato, shootday = @shootday WHERE identifier = @identifier', {
                ["@stato"] =  tostring(v.stato),
                ["@shootday"] =  v.shootday,
                ["@identifier"] =  v.identifier,
            })
        end
	end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for k,v in pairs(guantoData) do
            MySQL.Async.fetchAll('UPDATE fdsdev_gunpowderdata SET stato = @stato, shootday = @shootday WHERE identifier = @identifier', {
                ["@stato"] =  tostring(v.stato),
                ["@shootday"] =  v.shootday,
                ["@identifier"] =  v.identifier,
            })
        end
    end
end)