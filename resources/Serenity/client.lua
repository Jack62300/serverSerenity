

RegisterNetEvent('Serenity:applyskin')
AddEventHandler('Serenity:applyskin', function(skin, comp, draw, text)
    Citizen.CreateThread(function()
        local model = GetHashKey(skin)
        RequestModel(model)
        while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), model)
        SetPedComponentVariation(GetPlayerPed(-1), comp, draw, text, 2)
    end)
end)


RegisterNetEvent('Serenity:cleararea')
AddEventHandler('Serenity:cleararea', function(radius)
    print("Serenity"..radius)
    local coords     = GetEntityCoords(GetPlayerPed(-1))
    --ClearAreaOfEverything(coords.x, coords.y, coords.z, radius, false, false, false, false)
    ClearArea(coords.x, coords.y, coords.z, radius, true, false, false, false)
    ClearAreaOfPeds(0, 0, 0, 10000, 1)
    ClearAreaOfVehicles(0, 0, 0, 10000, false, false, false, false, false)
end)


