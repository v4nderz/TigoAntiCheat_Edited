V4nder.LoadSecurityTokens = function()
    local tokenContent = LoadResourceFile(GetCurrentResourceName(), 'data/token.json')

    if (not tokenContent) then
        local newTokenList = json.encode({})

        tokenContent = newTokenList

        SaveResourceFile(GetCurrentResourceName(), 'data/token.json', newTokenList, -1)
    end

    local storedTokens = json.decode(tokenContent)

    if (not storedTokens) then
        print('-------------------!' .. _('fatal_error') .. '!------------------\n')
        print(_('failed_to_load_tokenlist') .. '\n')
        print(_('failed_to_load_check') .. '\n')
        print('-------------------!' .. _('fatal_error') .. '!------------------\n')

        V4nder.SecurityTokens = {}
    else
        V4nder.SecurityTokens = storedTokens
    end

    V4nder.SecurityTokensLoaded = true
end

V4nder.SaveSecurityTokens = function()
    SaveResourceFile(GetCurrentResourceName(), 'data/token.json', json.encode(V4nder.SecurityTokens or {}, { indent = true }), -1)
end

V4nder.GetSteamIdentifier = function(source)
    if (source == nil) then
        return ''
    end

    local playerId = tonumber(source)

    if (playerId <= 0) then
        return ''
    end

    local identifiers, steamIdentifier = GetPlayerIdentifiers(source)

    for _, identifier in pairs(identifiers) do
        if (string.match(string.lower(identifier), 'steam:')) then
            steamIdentifier = identifier
        end
    end

    return steamIdentifier
end

V4nder.GetClientSecurityToken = function(source, resource)
    if (V4nder.SecurityTokens ~= nil and V4nder.SecurityTokens[tostring(source)] ~= nil) then
        local steamIdentifier = V4nder.GetSteamIdentifier(source)

        for _, resourceToken in pairs(V4nder.SecurityTokens[tostring(source)]) do
            if (resourceToken.name == resource and resourceToken.steam == steamIdentifier) then
                return resourceToken
            elseif (resourceToken.name == resource) then
                table.remove(V4nder.SecurityTokens[tostring(source)], _)
            end
        end
    end

    return nil
end

V4nder.GenerateSecurityToken = function(source, resource)
    local currentToken = V4nder.GetClientSecurityToken(source, resource)

    if (currentToken == nil) then
        local newResourceToken = {
            name = resource,
            token = V4nder.RandomString(Config.TokenLength),
            time = os.time(),
            steam = V4nder.GetSteamIdentifier(source),
            shared = false
        }

        if (V4nder.SecurityTokens == nil) then
            V4nder.SecurityTokens = {}
        end

        if (V4nder.SecurityTokens[tostring(source)] == nil) then
            V4nder.SecurityTokens[tostring(source)] = {}
        end

        table.insert(V4nder.SecurityTokens[tostring(source)], newResourceToken)

        V4nder.SaveSecurityTokens()

        return newResourceToken
    end

    return nil
end

V4nder.GetCurrentSecurityToken = function(source, resource)
    local currentToken = V4nder.GetClientSecurityToken(source, resource)

    if (currentToken == nil) then
        local newToken = V4nder.GenerateSecurityToken(source, resource)

        if (not newToken.shared) then
            V4nder.TriggerClientEvent(source, 'tigoanticheat:storeSecurityToken', newToken)
        end

        if (newToken == nil) then
            V4nder.KickPlayerWithReason(source, _U('kick_type_security_token'))
            return nil
        else
            return newToken
        end
    end

    return currentToken
end

V4nder.ValidateToken = function(source, resource, token)
    local currentToken = V4nder.GetCurrentSecurityToken(source, resource)

    if (currentToken == nil and token == nil) then
        return true
    elseif(currentToken ~= nil and not currentToken.shared and token == nil) then
        return true
    elseif(currentToken ~= nil and currentToken.token == token) then
        return true
    end

    return false
end

V4nder.ValidateOrKick = function(source, resource, token)
    if (not V4nder.ValidateToken(source, resource, token)) then
        V4nder.KickPlayerWithReason(_U('kick_type_security_mismatch'))
        return false
    end

    return true
end

V4nder.RegisterServerEvent('tigoanticheat:storeSecurityToken', function(source, resource)
    if (V4nder.SecurityTokens ~= nil and V4nder.SecurityTokens[tostring(source)] ~= nil) then
        local steamIdentifier = V4nder.GetSteamIdentifier(source)

        for _, resourceToken in pairs(V4nder.SecurityTokens[tostring(source)]) do
            if (resourceToken.name == resource and resourceToken.steam == steamIdentifier) then
                resourceToken.shared = true
                V4nder.SecurityTokens[tostring(source)][_].shared = true
            elseif (resourceToken.name == resource) then
                table.remove(V4nder.SecurityTokens[tostring(source)], _)
            end
        end

        V4nder.SaveSecurityTokens()
    end
end)