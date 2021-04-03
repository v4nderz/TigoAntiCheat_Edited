local CheckIfClientResourceIsRunningTriggerd = false

V4nder.RegisterServerEvent('tigoanticheat:stillAlive', function(source)
    if (V4nder.StartedPlayers[tostring(source)] == nil) then
        V4nder.StartedPlayers[tostring(source)] = {
            lastResponse = os.time(os.date("!*t")),
            numberOfTimesFailed = 0
        }
    end

    V4nder.StartedPlayers[tostring(source)].lastResponse = os.time(os.date("!*t"))
end)

Citizen.CreateThread(function()
    Citizen.Wait(5000)

    if (not CheckIfClientResourceIsRunningTriggerd) then
        CheckIfClientResourceIsRunning()
        CheckIfClientResourceIsRunningTriggerd = true
    end
end)

RegisterServerEvent('es:firstJoinProper')
AddEventHandler('es:firstJoinProper', function()
    local _source = source

    if (V4nder.StartedPlayers[tostring(_source)] == nil) then
        V4nder.StartedPlayers[tostring(_source)] = {
            lastResponse = os.time(os.date("!*t")),
            numberOfTimesFailed = 0
        }
    end
end)

function CheckIfClientResourceIsRunning()
    CheckIfClientResourceIsRunningTriggerd = true

    for _, playerId in pairs(GetPlayers()) do
        if (V4nder.StartedPlayers[tostring(playerId)] == nil) then
            V4nder.StartedPlayers[tostring(playerId)] = {
                lastResponse = os.time(os.date("!*t")),
                numberOfTimesFailed = 0
            }
        end
    end

    if (V4nder.StartedPlayers == nil) then
        V4nder.StartedPlayers = {}
    end

    for playerId, data in pairs(V4nder.StartedPlayers) do
        if (playerId ~= nil and tonumber(playerId) ~= 0) then
            local banned = false

            if (V4nder.StartedPlayers[playerId].numberOfTimesFailed > 5) then
                V4nder.BanPlayerWithReason(tonumber(playerId), _U('ban_type_client_files_blocked'))
                banned = true
            end

            if (not banned) then
                if ((V4nder.StartedPlayers[playerId].lastResponse + 100) < os.time(os.date("!*t"))) then
                    V4nder.StartedPlayers[playerId].numberOfTimesFailed = V4nder.StartedPlayers[playerId].numberOfTimesFailed + 1
                end

                V4nder.TriggerClientCallback(tonumber(playerId), 'tigoanticheat:stillAlive', function()
                    if (V4nder.StartedPlayers[playerId] ~= nil) then
                        V4nder.StartedPlayers[playerId].lastResponse = os.time(os.date("!*t"))

                        if (V4nder.StartedPlayers[playerId].numberOfTimesFailed > 0) then
                            V4nder.StartedPlayers[playerId].numberOfTimesFailed = V4nder.StartedPlayers[playerId].numberOfTimesFailed - 1
                        end
                    end
                end)
            end
        end
    end

    SetTimeout(60000, CheckIfClientResourceIsRunning)
end

RegisterServerEvent('playerDropped')
AddEventHandler('playerDropped', function()
    local _source = source

    if (V4nder.StartedPlayers ~= nil and V4nder.StartedPlayers[tostring(_source)] ~= nil) then
        V4nder.StartedPlayers[tostring(_source)] = nil
    end
end)