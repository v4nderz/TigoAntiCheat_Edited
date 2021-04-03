TAC                         = {}
V4nder.StartedPlayers          = {}
V4nder.ServerCallbacks         = {}
V4nder.ServerEvents            = {}
V4nder.ClientCallbacks         = {}
V4nder.ClientEvents            = {}
V4nder.PlayerBans              = {}
V4nder.BanListLoaded           = false
V4nder.Config                  = {}
V4nder.ConfigLoaded            = false
V4nder.SecurityTokens          = {}
V4nder.SecurityTokensLoaded    = false
V4nder.WhitelistedIPs          = {}
V4nder.WhitelistedIPsLoaded    = false
V4nder.CheckedIPs              = {}
V4nder.Version                 = '0.0.0'

AddEventHandler('tigoanticheat:getSharedObject', function(cb)
    cb(TAC)
end)

function getSharedObject()
    return TAC
end

RegisterServerEvent('tigoanticheat:triggerServerCallback')
AddEventHandler('tigoanticheat:triggerServerCallback', function(name, requestId, token, ...)
    local _source = source

    if (V4nder.ValidateOrKick(_source, GetCurrentResourceName(), token)) then
        V4nder.TriggerServerCallback(name, _source, function(...)
            TriggerClientEvent('tigoanticheat:serverCallback', _source, requestId, ...)
        end, ...)
    end
end)

RegisterServerEvent('tigoanticheat:triggerServerEvent')
AddEventHandler('tigoanticheat:triggerServerEvent', function(name, token, ...)
    local _source = source

    if (V4nder.ValidateOrKick(_source, GetCurrentResourceName(), token)) then
        V4nder.TriggerServerEvent(name, _source, ...)
    end
end)

AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
    V4nder.PlayerConnecting(source, setCallback, deferrals)
end)

V4nder.GetConfigVariable = function(name, _type, _default)
    _type = _type or 'string'
    _default = _default or ''

    local value = GetConvar(name, _default) or _default

    if (string.lower(_type) == 'string') then
        return tostring(value)
    end

    if (string.lower(_type) == 'boolean' or
        string.lower(_type) == 'bool') then
        return (string.lower(value) == 'true' or value == true or tostring(value) == '1' or tonumber(value) == 1)
    end

    return value
end