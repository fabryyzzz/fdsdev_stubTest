local haSparato = true
local waitThread = 5
local lavando  = false
local incremento = 0
local haSparato = false
local oldIncremento = 0
local stubResults = {}

RegisterNetEvent("realm_script:guanto:recieveLocalBool", function(sparato)
    haSparato = sparato
end)

RegisterNetEvent("fdsdev_paraffinGlove:recieveData", function(stubResults_sv, personalData)
    stubResults = stubResults_sv
    if personalData then
        haSparato = true
        HaSparato()
    end
end)

local sparatoria = false
RegisterNetEvent("CEventGunShot", function(a, b, c, d)
    if sparatoria or haSparato then return end
    if not Config.BlacklistedWeapons[GetSelectedPedWeapon(PlayerPedId())] then
        haSparato = true

        TriggerServerEvent("realm_script:guanto:syncData", true)
        HaSparato()
        Citizen.Wait(5000)
        sparatoria = false 
    end
end)

avviso = 0
coordPlayer = {}
local puoLavarsi = true
hasparatothread = false
function HaSparato()
    if hasparatothread then return end
    Citizen.CreateThread(function()
        while haSparato do
            oldIncremento = incremento
            if IsEntityInWater(PlayerPedId()) and puoLavarsi then
                coordPlayer[#coordPlayer + 1] = GetEntityCoords(PlayerPedId())
                incremento = incremento + 1
                if not lavando then
                    lavando = true
                    Citizen.CreateThread(function()
                        if lib.progressCircle({
                            id = 'a',
                            duration = Config.SecondsToClear,
                            position = 'bottom',
                            label = locale.cleaning,
                            useWhileDead = false,
                            canCancel = false,
                            disable = {
                                car = true,
                            },
                            anim = {},
                            prop = {},
                        }) then  else end
                        Citizen.CreateThread(function()
                            if lavando then
                                lavando, haSparato, waitThread = false, false, 5
                                TriggerServerEvent("realm_script:guanto:syncData", false)
                                lib.notify({
                                    title = locale.watersuccessNotify,
                                    description = locale.watersuccessNotify2,
                                    position = 'center-right',
                                    style = {
                                        backgroundColor = '#141517',
                                        color = '#30c53f',
                                        ['.description'] = {
                                          color = '#909296'
                                        }
                                    },
                                    icon = 'shower',
                                    iconColor = '#30c53f',
                                    iconAnimation = 'spin',
                                })
                            end
                        end)
                    end)
                    
                end
            elseif not IsEntityInWater(PlayerPedId()) then
                puoLavarsi = true
            end
            Citizen.CreateThread(function()
                local idCrd = #coordPlayer
                Citizen.Wait(1000)
                if Config.NeedToMoveInWater and lavando and #(GetEntityCoords(PlayerPedId()) - coordPlayer[idCrd]) < 0.3 then
                    if avviso < 4 then
                        avviso = avviso + 1
                        lib.notify({
                            title = locale.move,
                            description = (locale.move2):format(avviso),
                            position = 'center-right',
                            style = {
                                backgroundColor = '#141517',
                                color = '#e3980e',
                                ['.description'] = {
                                  color = '#909296'
                                }
                            },
                            icon = 'circle-exclamation',
                            iconColor = '#e3980e',
                            iconAnimation = 'spin',
                        })
                    else
                        lavando = false
                        avviso = 0
                        puoLavarsi = false
                        coordPlayer = {}
                        lib.cancelProgress()
                        lib.notify({
                            title = locale.waterErrorNotify,
                            description = locale.waterErrorNotify2,
                            position = 'center-right',
                            style = {
                                backgroundColor = '#141517',
                                color = '#C1C2C5',
                                ['.description'] = {
                                  color = '#909296'
                                }
                            },
                            icon = 'circle-exclamation',
                            iconColor = '#C53030',
                            iconAnimation = 'spin',
                        })
                    end
                end
            end)
            if incremento == oldIncremento and lavando then
                lavando = false
                lib.cancelProgress()
                lib.notify({
                    title = locale.waterErrorNotify,
                    description = locale.waterErrorNotify2,
                    position = 'center-right',
                    style = {
                        backgroundColor = '#141517',
                        color = '#C1C2C5',
                        ['.description'] = {
                          color = '#909296'
                        }
                    },
                    icon = 'circle-exclamation',
                    iconColor = '#C53030',
                    iconAnimation = 'spin',
                })
            end
            Citizen.Wait(1000)
        end
        hasparatothread = false
    end)
end

local targetForensic = {}
function forensicFunction()
    print("ciao")
    for k,v in pairs(targetForensic) do
        -- TriggerEvent('gridsystem:unregisterMarker', v)
        if Config.Target == "qb" then
            exports['qb-target']:RemoveZone(v)
        else
            exports.ox_target:removeZone(v)
        end
    end
    targetForensic = {}
    local player = PlayerPedId()
    local coords = GetEntityCoords(player)
    for k,v in pairs(Config.ForensicZones) do
        if AuthFunc() then
            if Config.Target == "qb" then
                targetForensic[k] = "stub" .. k
                exports['qb-target']:AddBoxZone("stub" .. k, v.database + vec3(0,0,0.5), 2.0, 2.0, { -- The name has to be unique, the coords a vector3 as shown, the 1.5 is the length of the boxzone and the 1.6 is the width of the boxzone, the length and width have to be float values
                name = "stub" .. k, -- This is the name of the zone recognized by PolyZone, this has to be unique so it doesn't mess up with other zones
                heading = 12.0, -- The heading of the boxzone, this has to be a float value
                debugPoly = true, -- This is for enabling/disabling the drawing of the box, it accepts only a boolean value (true or false), when true it will draw the polyzone in green
                minZ = v.database.z - 1.0, -- This is the bottom of the boxzone, this can be different from the Z value in the coords, this has to be a float value
                maxZ = v.database.z + 1.0, -- This is the top of the boxzone, this can be different from the Z value in the coords, this has to be a float value
                }, {
                options = { -- This is your options table, in this table all the options will be specified for the target to accept
                    { -- This is the first table with options, you can make as many options inside the options table as you want
                    num = 1, -- This is the position number of your option in the list of options in the qb-target context menu (OPTIONAL)
                    type = "client", -- This specifies the type of event the target has to trigger on click, this can be "client", "server", "command" or "qbcommand", this is OPTIONAL and will only work if the event is also specified
                    icon = 'fas fa-database', -- This is the icon that will display next to this trigger option
                    label = locale.databaseaccess, -- This is the label of this option which you would be able to click on to trigger everything, this has to be a string
                    action = function(entity) -- This is the action it has to perform, this REPLACES the event and this is OPTIONAL
                        local players, nearbyPlayer = GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0)
                        local nearby = {}
                        for i = 1, #players, 1 do
                            if players[i] ~= PlayerId() then
                                table.insert(nearby, {label = GetPlayerName(players[i]) .. " - ID " ..GetPlayerServerId(players[i]), value = GetPlayerServerId(players[i])})
                            end
                        end
                        SetNuiFocus(true, true)
                        SendNUIMessage({
                            open = true,
                            nearPlayers = nearby,
                            stubResults = stubResults
                        })
                    end,
                    }
                },
            })
            else
                targetForensic[k] = exports.ox_target:addBoxZone({
                    coords = v.database + vec3(0,0,0.5),
                    size = vec3(2.0, 2.0, 2.0),
                    options = {
                        {
                            label = locale.databaseaccess, 
                            icon = "fa-solid fa-database",
                            onSelect = function()
                                local players, nearbyPlayer = GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0)
                                local nearby = {}
                                for i = 1, #players, 1 do
                                    if players[i] ~= PlayerId() then
                                        table.insert(nearby, {label = GetPlayerName(players[i]) .. " - ID " ..GetPlayerServerId(players[i]), value = GetPlayerServerId(players[i])})
                                    end
                                end
                                SetNuiFocus(true, true)
                                SendNUIMessage({
                                    open = true,
                                    nearPlayers = nearby,
                                    stubResults = stubResults
                                })
                            end, 
                        }
                    }
                })
            end
        end
    end
    
end

RegisterNUICallback("eliminaQuesto", function(data)
    TriggerServerEvent("fdsdev_paraffinGlove:eliminaCio", data.idPlayer, data.situa)
end)
RegisterNUICallback("close", function(data)
    SetNuiFocus(false, false)
end)

RegisterNUICallback("refreshAll", function(data)
    local players, nearbyPlayer = GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0)
    local nearby = {}
    for i = 1, #players, 1 do
        if players[i] ~= PlayerId() then
            table.insert(nearby, {label = GetPlayerName(players[i]) .. " - ID " ..GetPlayerServerId(players[i]), value = GetPlayerServerId(players[i])})
        end
    end
    SendNUIMessage({
        refresh = true,
        nearPlayers = nearby,
        stubResults = stubResults
    })
end)
RegisterNUICallback("testPlayer", function(data)
    SetNuiFocus(false, false)
    local situa = false
    local players, nearbyPlayer = GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0)
    for i = 1, #players, 1 do
        if GetPlayerServerId(players[i]) == tonumber(data.idPlayer) then
            situa = true
        end
    end
    if situa then
        TriggerServerEvent("fdsdev_paraffinGlove:testPlayer", data.idPlayer)
        if lib.progressCircle({
            duration = 10000,
            position = 'bottom',
            label = locale.beingtested2,
            useWhileDead = false,
            canCancel = false,
            disable = {
                move = true,
                combat = true,
                car = true,
            },
            anim = {
                dict = "anim@heists@heist_corona@single_team",
                clip = "single_team_loop_boss",
                flag = 51
            },
            prop = {},
        }) then  else end
    end
end)

RegisterNetEvent("fdsdev_paraffinGlove:beingTested", function(srcMandante, data)
    local situa = false
    local players, nearbyPlayer = GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0)
    for i = 1, #players, 1 do
        if GetPlayerServerId(players[i]) == srcMandante then
            situa = true
        end
    end

    if situa then
        if lib.progressCircle({
            duration = 10000,
            position = 'bottom',
            label = locale.beingtested,
            useWhileDead = false,
            canCancel = false,
            disable = {
                move = true,
                combat = true,
                car = true,
            },
            anim = {
                dict = 'anim@amb@clubhouse@bar@drink@idle_a',
                clip = 'idle_a_bartender',
                flag = 51
            },
            prop = {},
        }) then  else end
        TriggerServerEvent("fdsdev_paraffinGlove:tested", srcMandante, data)
    end
end)

RegisterNetEvent("fdsdev_paraffinGlove:tested", function(srcProprietario, data)
    SetNuiFocus(true, true)
    SendNUIMessage({
        testTerminato = true,
        esito = data
    })
end)


function GetPlayers(onlyOtherPlayers, returnKeyValue, returnPeds)
	local players, myPlayer = {}, PlayerId()

	for k,player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)

		if DoesEntityExist(ped) and ((onlyOtherPlayers and player ~= myPlayer) or not onlyOtherPlayers) then
			if returnKeyValue then
				players[player] = ped
			else
				players[#players + 1] = returnPeds and ped or player
			end
		end
	end

	return players
end

function GetPlayersInArea(coords, maxDistance)
	return EnumerateEntitiesWithinDistance(GetPlayers(false, true), true, coords, maxDistance)
end

function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
	local nearbyEntities = {}

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = ESX.PlayerData.ped
		coords = GetEntityCoords(playerPed)
	end

	for k,entity in pairs(entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if distance <= maxDistance then
			nearbyEntities[#nearbyEntities + 1] = isPlayerEntities and k or entity
		end
	end

	return nearbyEntities
end