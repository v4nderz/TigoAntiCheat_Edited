V4nder.RegisterServerCallback = function(name, cb)
    V4nder.ServerCallbacks[name] = cb
end

V4nder.RegisterServerEvent = function(name, cb)
    V4nder.ServerEvents[name] = cb
end

V4nder.TriggerClientCallback = function(source, name, cb, ...)
    local playerId = tostring(source)

    if (V4nder.ClientCallbacks == nil) then
        V4nder.ClientCallbacks = {}
    end

    if (V4nder.ClientCallbacks[playerId] == nil) then
        V4nder.ClientCallbacks[playerId] = {}
        V4nder.ClientCallbacks[playerId]['CurrentRequestId'] = 0
    end

    V4nder.ClientCallbacks[playerId][tostring(V4nder.ClientCallbacks[playerId]['CurrentRequestId'])] = cb

    TriggerClientEvent('tigoanticheat:triggerClientCallback', source, name, V4nder.ClientCallbacks[playerId]['CurrentRequestId'], ...)

    if (V4nder.ClientCallbacks[playerId]['CurrentRequestId'] < 65535) then
        V4nder.ClientCallbacks[playerId]['CurrentRequestId'] = V4nder.ClientCallbacks[playerId]['CurrentRequestId'] + 1
    else
        V4nder.ClientCallbacks[playerId]['CurrentRequestId'] = 0
    end
end

V4nder.TriggerClientEvent = function(source, name, ...)
    TriggerClientEvent('tigoanticheat:triggerClientEvent', source, name, ...)
end

V4nder.TriggerServerCallback = function(name, source, cb, ...)
    if (V4nder.ServerCallbacks ~= nil and V4nder.ServerCallbacks[name] ~= nil) then
        V4nder.ServerCallbacks[name](source, cb, ...)
    else
        print('[TigoAntiCheat] TriggerServerCallback => ' .. _('callback_not_found', name))
    end
end

V4nder.TriggerServerEvent = function(name, source, ...)
    if (V4nder.ServerEvents ~= nil and V4nder.ServerEvents[name] ~= nil) then
        V4nder.ServerEvents[name](source, ...)
    else
        print('[TigoAntiCheat] TriggerServerEvent => ' .. _('trigger_not_found', name))
    end
end

RegisterServerEvent('tigoanticheat:clientCallback')
AddEventHandler('tigoanticheat:clientCallback', function(requestId, ...)
    local _source = source
    local playerId = tonumber(_source)

    if (V4nder.ClientCallbacks ~= nil and V4nder.ClientCallbacks[playerId] ~= nil and V4nder.ClientCallbacks[playerId][requestId] ~= nil) then
        V4nder.ClientCallbacks[playerId][tostring(requestId)](...)
        V4nder.ClientCallbacks[playerId][tostring(requestId)] = nil
    end
end)