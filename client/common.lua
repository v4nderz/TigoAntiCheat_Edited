AddEventHandler('tigoanticheat:getSharedObject', function(cb)
    cb(TAC)
end)

function getSharedObject()
    return TAC
end

RegisterNetEvent('tigoanticheat:triggerClientCallback')
AddEventHandler('tigoanticheat:triggerClientCallback', function(name, requestId, ...)
    V4nder.TriggerClientCallback(name, function(...)
        TriggerServerEvent('tigoanticheat:clientCallback', requestId, ...)
    end, ...)
end)

RegisterNetEvent('tigoanticheat:triggerClientEvent')
AddEventHandler('tigoanticheat:triggerClientEvent', function(name, ...)
    V4nder.TriggerClientEvent(name, ...)
end)