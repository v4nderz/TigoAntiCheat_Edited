TAC                     = {}
V4nder.CurrentRequestId    = 0
V4nder.ServerCallbacks     = {}
V4nder.ClientCallbacks     = {}
V4nder.ClientEvents        = {}
V4nder.Config              = {}
V4nder.SecurityTokens      = {}

V4nder.RegisterClientCallback = function(name, cb)
    V4nder.ClientCallbacks[name] = cb
end

V4nder.RegisterClientEvent = function(name, cb)
    V4nder.ClientEvents[name] = cb
end

V4nder.TriggerServerCallback = function(name, cb, ...)
    V4nder.ServerCallbacks[V4nder.CurrentRequestId] = cb

    local token = V4nder.GetResourceToken(GetCurrentResourceName())

    TriggerServerEvent('tigoanticheat:triggerServerCallback', name, V4nder.CurrentRequestId, token, ...)

    if (V4nder.CurrentRequestId < 65535) then
        V4nder.CurrentRequestId = V4nder.CurrentRequestId + 1
    else
        V4nder.CurrentRequestId = 0
    end
end

V4nder.TriggerServerEvent = function(name, ...)
    local token = V4nder.GetResourceToken(GetCurrentResourceName())

    TriggerServerEvent('tigoanticheat:triggerServerEvent', name, token, ...)
end

V4nder.TriggerClientCallback = function(name, cb, ...)
    if (V4nder.ClientCallbacks ~= nil and V4nder.ClientCallbacks[name] ~= nil) then
        V4nder.ClientCallbacks[name](cb, ...)
    end
end

V4nder.TriggerClientEvent = function(name, ...)
    if (V4nder.ClientEvents ~= nil and V4nder.ClientEvents[name] ~= nil) then
        V4nder.ClientEvents[name](...)
    end
end

V4nder.ShowNotification = function(msg)
    AddTextEntry('tacNotification', msg)
	SetNotificationTextEntry('tacNotification')
	DrawNotification(false, true)
end

V4nder.RequestAndDelete = function(object, detach)
    if (DoesEntityExist(object)) then
        NetworkRequestControlOfEntity(object)

        while not NetworkHasControlOfEntity(object) do
            Citizen.Wait(0)
        end

        if (detach) then
            DetachEntity(object, 0, false)
        end

        SetEntityCollision(object, false, false)
        SetEntityAlpha(object, 0.0, true)
        SetEntityAsMissionEntity(object, true, true)
        SetEntityAsNoLongerNeeded(object)
        DeleteEntity(object)
    end
end

RegisterNetEvent('tigoanticheat:serverCallback')
AddEventHandler('tigoanticheat:serverCallback', function(requestId, ...)
	if (V4nder.ServerCallbacks ~= nil and V4nder.ServerCallbacks[requestId] ~= nil) then
		V4nder.ServerCallbacks[requestId](...)
        V4nder.ServerCallbacks[requestId] = nil
	end
end)