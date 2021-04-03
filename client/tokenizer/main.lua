V4nder.RegisterClientEvent('tigoanticheat:storeSecurityToken', function(newToken)
    if (V4nder.SecurityTokens == nil) then
        V4nder.SecurityTokens = {}
    end

    V4nder.SecurityTokens[newToken.name] = newToken

    V4nder.TriggerServerEvent('tigoanticheat:storeSecurityToken', newToken.name)
end)

V4nder.GetResourceToken = function(resource)
    if (resource ~= nil) then
        local securityTokens = V4nder.SecurityTokens or {}
        local resourceToken = securityTokens[resource] or {}
        local token = resourceToken.token or nil

        return token
    end

    return nil
end