V4nder.ServerConfigLoaded = false

AddEventHandler('onResourceStart', function(resourceName)
    V4nder.TriggerServerEvent('monster_anticheat:server:startResource', resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    V4nder.TriggerServerEvent('tigoanticheat:playerResourceStarted')
end)

AddEventHandler('onResourceStop', function(resourceName)
    V4nder.TriggerServerEvent('monster_anticheat:server:stopResource', resourceName)
end)

Citizen.CreateThread(function()
    V4nder.LaodServerConfig()

    Citizen.Wait(1000)

    while not V4nder.ServerConfigLoaded do
        Citizen.Wait(1000)

        V4nder.LaodServerConfig()
    end

    return
end)

V4nder.LaodServerConfig = function()
    if (not V4nder.ServerConfigLoaded) then
        V4nder.TriggerServerCallback('tigoanticheat:getServerConfig', function(config)
            V4nder.Config = config
            V4nder.Config.BlacklistedWeapons = {}
            V4nder.Config.BlacklistedVehicles = {}
            V4nder.Config.HasBypass = V4nder.Config.HasBypass or false

            for _, blacklistedWeapon in pairs(Config.BlacklistedWeapons) do
                V4nder.Config.BlacklistedWeapons[blacklistedWeapon] = GetHashKey(blacklistedWeapon)
            end

            for _, blacklistedVehicle in pairs(Config.BlacklistedVehicles) do
                V4nder.Config.BlacklistedVehicles[blacklistedVehicle] = GetHashKey(blacklistedVehicle)
            end

            V4nder.ServerConfigLoaded = true
        end)
    end
end
