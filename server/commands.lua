V4nder.Commands = {}

V4nder.IsConsole = function(playerId)
    return (playerId == nil or playerId <= 0 or tostring(playerId) == '0')
end

RegisterCommand('anticheat', function(source, args, raw)
    if (not V4nder.PlayerAllowed(source)) then
        V4nder.Print(false, '%{reset}[%{red}' .. _('name') .. '%{reset}] %{white}' .. _('not_allowed', '%{red}/anticheat%{reset}'))
        return
    end

    local isConsole = V4nder.IsConsole(source)

    if (args == nil or string.lower(type(args)) ~= 'table' or #args <= 0 or string.lower(tostring(args[1])) == 'help') then
        V4nder.Commands['help'].func(isConsole, {})
        return
    end

    local command = string.lower(tostring(args[1]))

    for key, data in pairs(V4nder.Commands) do
        if (string.lower(key) == command) then
            local param = args[2] or nil
            data.func(isConsole, param)
            return
        end
    end

    V4nder.Print(isConsole, '%{reset}[%{red}' .. _('name') .. '%{reset}] %{white}' .. _('command') .. ' %{red}/anticheat ' .. command .. ' %{white}' .. _('command_not_found'))
end)

V4nder.Commands['reload'] = {
    description = _('command_reload'),
    func = function(isConsole)
        V4nder.LoadBanList()
        V4nder.Print(isConsole, '%{reset}[%{red}' .. _('name') .. '%{reset}] %{white}' .. _('banlist_reloaded'))
    end
}

V4nder.Commands['ip-reload'] = {
    description = _('ips_command_reload'),
    func = function(isConsole)
        V4nder.LoadWhitelistedIPs()
        V4nder.Print(isConsole, '%{reset}[%{red}' .. _('name') .. '%{reset}] %{white}' .. _('ips_reloaded'))
    end
}

V4nder.Commands['ip-add'] = {
    description = _('ips_command_add'),
    func = function(isConsole, ip)
        if (V4nder.AddIPToWhitelist(ip)) then
            V4nder.Print(isConsole, '%{reset}[%{red}' .. _('name') .. '%{reset}] %{white}' .. _('ip_added', ip))
        else
            V4nder.Print(isConsole, '%{reset}[%{red}' .. _('name') .. '%{reset}] %{white}' .. _('ip_invalid', ip))
        end
    end
}

V4nder.Commands['total'] = {
    description = _('command_total'),
    func = function(isConsole)
        V4nder.Print(isConsole, '%{reset}[%{red}' .. _('name') .. '%{reset}] %{white}' .. _('total_bans', #V4nder.PlayerBans))
    end
}

V4nder.Commands['help'] = {
    description = _('command_help'),
    func = function(isConsole)
        local string = '%{reset}[%{red}' .. _('name') .. '%{reset}] %{white}' .. _('available_commands') .. '\n %{black}--------------------------------------------------------------\n'

        for command, data in pairs(V4nder.Commands) do
            string = string .. '%{red}/anticheat ' .. command .. ' %{black}| %{white}' .. data.description .. '\n'
        end

        string = string .. '%{black}--------------------------------------------------------------%{reset}'

        V4nder.Print(isConsole, string)
    end
}

V4nder.Print = function(isConsole, string)
    if (isConsole) then
        V4nder.PrintToConsole(string)
    else
        V4nder.PrintToUser(string)
    end
end

V4nder.PlayerAllowed = function(playerId)
    local isConsole = V4nder.IsConsole(playerId)

    if (isConsole) then
        return isConsole
    end

    if (IsPlayerAceAllowed(playerId, 'tigoanticheat.commands')) then
        return true
    end

    return false
end

V4nder.IgnorePlayer = function(playerId)
    local isConsole = V4nder.IsConsole(playerId)

    if (isConsole) then
        return isConsole
    end

    if (not V4nder.Config.BypassEnabled) then
        return false
    end

    if (IsPlayerAceAllowed(playerId, 'tigoanticheat.bypass')) then
        return true
    end

    return false
end