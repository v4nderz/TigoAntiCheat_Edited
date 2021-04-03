V4nder.LoadBanList = function()
    local banlistContent = LoadResourceFile(GetCurrentResourceName(), 'data/banlist.json')

    if (not banlistContent) then
        local newBanlist = json.encode({})

        banlistContent = newBanlist

        SaveResourceFile(GetCurrentResourceName(), 'data/banlist.json', newBanlist, -1)
    end

    local banlist = json.decode(banlistContent)

    if (not banlist) then
        print('-------------------!' .. _('fatal_error') .. '!------------------\n')
        print(_('failed_to_load_banlist') .. '\n')
        print(_('failed_to_load_check') .. '\n')
        print('-------------------!' .. _('fatal_error') .. '!------------------\n')

        V4nder.PlayerBans = {}
    else
        V4nder.PlayerBans = banlist
    end

    V4nder.BanListLoaded = true
end

V4nder.LoadConfig = function()
    V4nder.LoadVersion()

    V4nder.Config = {
        UpdateIdentifiers   = V4nder.GetConfigVariable('tigoanticheat.updateidentifiers', 'boolean'),
        GodMode             = V4nder.GetConfigVariable('tigoanticheat.godmode', 'boolean'),
        Webhook             = V4nder.GetConfigVariable('tigoanticheat.webhook', 'string'),
        BypassEnabled       = V4nder.GetConfigVariable('tigoanticheat.bypassenabled', 'boolean'),
        VPNCheck            = V4nder.GetConfigVariable('tigoanticheat.VPNCheck', 'boolean', true),
        VPNKey              = V4nder.GetConfigVariable('tigoanticheat.VPNKey', 'string')
    }

    V4nder.ConfigLoaded = true
end

V4nder.LoadVersion = function()
    local currentVersion = LoadResourceFile(GetCurrentResourceName(), 'version')

    if (not currentVersion) then
        V4nder.Version = '0.0.0'
    else
        V4nder.Version = currentVersion
    end
end

V4nder.AddBlacklist = function(data)
    local banlistContent = LoadResourceFile(GetCurrentResourceName(), 'data/banlist.json')

    if (not banlistContent) then
        local newBanlist = json.encode({})

        banlistContent = newBanlist

        SaveResourceFile(GetCurrentResourceName(), 'data/banlist.json', newBanlist, -1)
    end

    local banlist = json.decode(banlistContent)

    if (not banlist) then
        print('-------------------!' .. _('fatal_error') .. '!------------------\n')
        print(_('failed_to_load_banlist') .. '\n')
        print(_('failed_to_load_check') .. '\n')
        print('-------------------!' .. _('fatal_error') .. '!------------------\n')
        return
    end

    if (data.identifiers ~= nil and #data.identifiers > 0) then
        table.insert(banlist, data)

        V4nder.PlayerBans = banlist

        V4nder.LogBanToDiscord(data)

        SaveResourceFile(GetCurrentResourceName(), 'data/banlist.json', json.encode(banlist, { indent = true }), -1)
    end
end

V4nder.BanPlayerByEvent = function(playerId, event)
    if (playerId ~= nil and playerId > 0 and not V4nder.IgnorePlayer(source)) then
        local bannedIdentifiers = GetPlayerIdentifiers(playerId)

        if (bannedIdentifiers == nil or #bannedIdentifiers <= 0) then
            DropPlayer(playerId, _('user_ban_reason', _('unknown')))
            return
        end

        local playerBan = {
            name = GetPlayerName(playerId) or _('unknown'),
            reason = _('banlist_ban_reason', event),
            identifiers = bannedIdentifiers
        }

        V4nder.AddBlacklist(playerBan)

        DropPlayer(playerId, _('user_ban_reason', playerBan.name))
    end
end

V4nder.BanPlayerWithNoReason = function(playerId)
    if (playerId ~= nil and playerId > 0 and not V4nder.IgnorePlayer(source)) then
        local bannedIdentifiers = GetPlayerIdentifiers(playerId)

        if (bannedIdentifiers == nil or #bannedIdentifiers <= 0) then
            DropPlayer(playerId, _('user_ban_reason', _('unknown')))
            return
        end

        local playerBan = {
            name = GetPlayerName(playerId) or _('unknown'),
            reason = '',
            identifiers = bannedIdentifiers
        }

        V4nder.AddBlacklist(playerBan)

        DropPlayer(playerId, _('user_ban_reason', playerBan.name))
    end
end

V4nder.BanPlayerWithReason = function(playerId, reason)
    if (playerId ~= nil and playerId > 0 and not V4nder.IgnorePlayer(source)) then
        local bannedIdentifiers = GetPlayerIdentifiers(playerId)

        if (bannedIdentifiers == nil or #bannedIdentifiers <= 0) then
            DropPlayer(playerId, _('user_ban_reason', _('unknown')))
            return
        end

        local playerBan = {
            name = GetPlayerName(playerId) or _('unknown'),
            reason = reason,
            identifiers = bannedIdentifiers
        }

        V4nder.AddBlacklist(playerBan)

        DropPlayer(playerId, _('user_ban_reason', playerBan.name))
    end
end

V4nder.KickPlayerWithReason = function(playerId, reason)
    if (playerId ~= nil and playerId > 0 and not V4nder.IgnorePlayer(source)) then
        DropPlayer(playerId, _('user_kick_reason', reason))
    end
end

V4nder.PlayerConnecting = function(playerId, setCallback, deferrals)
    local vpnChecked = false

    deferrals.defer()
    deferrals.update(_U('checking'))

    Citizen.Wait(100)

    if (not V4nder.BanListLoaded) then
        deferrals.done(_('banlist_not_loaded_kick_player'))
        return
    end

    if (V4nder.IgnorePlayer(playerId)) then
        deferrals.done()
        return
    end

    local identifiers = GetPlayerIdentifiers(playerId)

    if (identifiers == nil or #identifiers <= 0) then
        DropPlayer(playerId, _('user_ban_reason', _('unknown')))
        return
    end

    for __, playerBan in pairs(V4nder.PlayerBans) do
        if (V4nder.TableContainsItem(identifiers, playerBan.identifiers, true)) then
            if (V4nder.Config.UpdateIdentifiers) then
                V4nder.CheckForNewIdentifiers(playerId, identifiers, playerBan.name, playerBan.reason)
            end

            deferrals.done(_('user_ban_reason', playerBan.name))
            return
        end
    end

    if (V4nder.Config.VPNCheck) then
        if (V4nder.IgnorePlayer(playerId)) then
            return
        end

        local playerIP = V4nder.GetPlayerIP(playerId)

        if (playerIP == nil) then
            deferrals.done(_('ip_blocked'))
            return
        end

        while (not V4nder.ConfigLoaded) do
            Citizen.Wait(10)
        end

        local ipInfo = {}

        if (V4nder.CheckedIPs ~= nil and V4nder.CheckedIPs[playerIP] ~= nil) then
            ipInfo = V4nder.CheckedIPs[playerIP] or {}

            local blockIP =  ipInfo.block or 0

            if (blockIP == 1) then
                local ignoreIP = false

                if (V4nder.WhitelistedIPsLoaded) then
                    for _, ip in pairs(V4nder.WhitelistedIPs) do
                        if (ip == playerIP) then
                            ignoreIP = true
                        end
                    end
                end

                if (not ignoreIP) then
                    deferrals.done(_('ip_blocked'))
                    return
                end
            end

            vpnChecked = true
        else
            PerformHttpRequest('http://v2.api.iphub.info/ip/' .. playerIP, function(statusCode, response, headers)
                if (statusCode == 200) then
                    local rawData = response or '{}'
                    ipInfo = json.decode(rawData)

                    V4nder.CheckedIPs[playerIP] = ipInfo

                    local blockIP =  ipInfo.block or 0

                    if (blockIP == 1) then
                        local ignoreIP = false

                        if (V4nder.WhitelistedIPsLoaded) then
                            for _, ip in pairs(V4nder.WhitelistedIPs) do
                                if (ip == playerIP) then
                                    ignoreIP = true
                                end
                            end
                        end

                        if (not ignoreIP) then
                            deferrals.done(_('ip_blocked'))
                            return
                        end
                    end
                end

                vpnChecked = true
            end, 'GET', '', {
                ['X-Key'] = V4nder.Config.VPNKey
            })
        end
    end

    while not vpnChecked do
        Citizen.Wait(10)
    end

    deferrals.done()
end

V4nder.CheckForNewIdentifiers = function(playerId, identifiers, name, reason)
    local newIdentifiers = {}

    for _, identifier in pairs(identifiers) do
        local identifierFound = false

        for _, playerBan in pairs(V4nder.PlayerBans) do
            if (V4nder.TableContainsItem({ identifier }, playerBan.identifiers, true)) then
                identifierFound = true
            end
        end

        if (not identifierFound) then
            table.insert(newIdentifiers, identifier)
        end
    end

    if (#newIdentifiers > 0) then
        local playerBan = {
            name = GetPlayerName(playerId) or _('unknown'),
            reason = _('new_identifiers_found', reason, name),
            identifiers = newIdentifiers
        }

        V4nder.AddBlacklist(playerBan)
    end
end

V4nder.LogBanToDiscord = function (data)
    if (V4nder.Config.Webhook == nil or
        V4nder.Config.Webhook == '') then
        return
    end

    local identifierString = ''

    for _, identifier in pairs(data.identifiers or {}) do
        identifierString = identifierString .. identifier

        if (_ ~= #data.identifiers) then
            identifierString = identifierString .. '\n '
        end
    end

    local discordInfo = {
        ["color"] = "15158332",
        ["type"] = "rich",
        ["title"] = _('discord_title'),
        ["description"] = _('discord_description', data.name, data.reason, identifierString),
        ["footer"] = {
            ["text"] = 'TigoAntiCheat | ' .. V4nder.Version
        }
    }

    PerformHttpRequest(V4nder.Config.Webhook, function(err, text, headers) end, 'POST', json.encode({ username = 'TigoAntiCheat', embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
end

Citizen.CreateThread(function()
    while not V4nder.BanListLoaded do
        V4nder.LoadBanList()

        Citizen.Wait(10)
    end

    while not V4nder.ConfigLoaded do
        V4nder.LoadConfig()

        Citizen.Wait(10)
    end

    while not V4nder.WhitelistedIPsLoaded do
        V4nder.LoadWhitelistedIPs()

        Citizen.Wait(10)
    end
end)

V4nder.RegisterServerCallback('tigoanticheat:getServerConfig', function(source, cb)
    while not V4nder.ConfigLoaded do
        Citizen.Wait(10)
    end

    if ((V4nder.Config.GodMode or false) and V4nder.IgnorePlayer(source)) then
        V4nder.Config.GodMode = false
    end

    V4nder.Config.HasBypass = V4nder.IgnorePlayer(source)

    cb(V4nder.Config)
end)

V4nder.RegisterServerCallback('tigoanticheat:getRegisteredCommands', function(source, cb)
    cb(GetRegisteredCommands())
end)

V4nder.RegisterServerEvent('tigoanticheat:banPlayer', function(source, type, item)
    local _type = type or 'default'
    local _item = item or 'none'

    _type = string.lower(_type)

    if (_type == 'default') then
        V4nder.BanPlayerWithNoReason(source)
    elseif (_type == 'godmode') then
        V4nder.BanPlayerWithReason(source, _U('ban_type_godmode'))
    elseif (_type == 'injection') then
        V4nder.BanPlayerWithReason(source, _U('ban_type_injection'))
    elseif (_type == 'blacklisted_weapon') then
        V4nder.BanPlayerWithReason(source, _U('ban_type_blacklisted_weapon', _item))
    elseif (_type == 'blacklisted_key') then
        V4nder.BanPlayerWithReason(source, _U('ban_type_blacklisted_key', _item))
    elseif (_type == 'hash') then
        V4nder.BanPlayerWithReason(source, _U('ban_type_hash'))
    elseif (_type == 'esx_shared') then
        V4nder.BanPlayerWithReason(source, _U('ban_type_esx_shared'))
    elseif (_type == 'superjump') then
        V4nder.BanPlayerWithReason(source, _U('ban_type_superjump'))
    elseif (_type == 'event') then
        V4nder.BanPlayerByEvent(source, _item)
    end
end)

V4nder.RegisterServerEvent('tigoanticheat:playerResourceStarted', function(source)
    if (V4nder.StartedPlayers ~= nil and V4nder.StartedPlayers[tostring(source)] ~= nil and V4nder.StartedPlayers[tostring(source)]) then
        V4nder.BanPlayerWithReason(source, _U('lua_executor_found'))
    end

    if (V4nder.StartedPlayers[tostring(source)] == nil) then
        V4nder.StartedPlayers[tostring(source)] = {
            lastResponse = os.time(os.date("!*t")),
            numberOfTimesFailed = 0
        }
    end
end)

V4nder.RegisterServerEvent('tigoanticheat:logToConsole', function(source, message)
    print(message)
end)

AddEventHandler('taeratto_anticheat:server:ban', function(source, reason)
    V4nder.BanPlayerWithReason(source, reason)
end)


TaerAttOResources = {}
TaerAttOStopResourceTemp = nil
TaerAttOStartResourceTemp = nil

local function GetResources()
    local resources = {}
    for i = 1, GetNumResources() do
        local resource = GetResourceByFindIndex(i) or 'Unknown'
        local status = GetResourceState(resource) or 'Unknown'
        print(resource .. ' : ' .. status)
        -- if GetResourceState(resource) == "started" then
        
            resources[resource] = {
                status = status
            }
        -- end
        -- resources[i] = resource
        
    end
    return resources
end

Citizen.CreateThread(function()
    Citizen.Wait(15000)
    TaerAttOResources = GetResources()
    print(json.encode(TaerAttOResources))
end)

AddEventHandler('onResourceStart', function(resource)
    print('resource:start ' .. resource)
    TaerAttOStartResourceTemp = resource
end)

V4nder.RegisterServerEvent('monster_anticheat:server:startResource', function(source, resource)
    local _source = source
    print(resource .. ' starting')
    if (TaerAttOResources[resource] == nil and resource ~= GetCurrentResourceName()) or not TaerAttOStartResourceTemp then
        -- V4nder.BanPlayerWithReason(_source, 'Start Resource Hack!')
        print('baned!! : ' .. _source)
        print('not admin start')
        -- DropPlayer(_source, 'Start Resource Hack!')
    elseif TaerAttOStartResourceTemp and TaerAttOStartResourceTemp == resource then
        print('_admin start')
    end
    TaerAttOStartResourceTemp = nil
end)

AddEventHandler('onResourceStop', function(resource)
    TaerAttOStopResourceTemp = resource
end)

V4nder.RegisterServerEvent('monster_anticheat:server:stopResource', function(source, resource)
    local _source = source
    print('stop resource name: ' .. resource .. ' by ID: ' .. source)
    if TaerAttOStopResourceTemp and TaerAttOStopResourceTemp == resource then
        print('_admin stop')
    else
        print('not admin stop')
    end
end)
