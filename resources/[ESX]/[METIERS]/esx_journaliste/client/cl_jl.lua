local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData              = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local Blips                   = {}

local isInMarker              = false
local isInPublicMarker        = false
local hintIsShowed            = false
local hintToDisplay           = "no hint to display"

ESX                           = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

-- Create blips
Citizen.CreateThread(function()

    local blipMarker = Config.Blips.Blip
    local blipCoord = AddBlipForCoord(blipMarker.Pos.x, blipMarker.Pos.y, blipMarker.Pos.z)

    SetBlipSprite (blipCoord, blipMarker.Sprite)
    SetBlipDisplay(blipCoord, blipMarker.Display)
    SetBlipScale  (blipCoord, blipMarker.Scale)
    SetBlipColour (blipCoord, blipMarker.Colour)
    SetBlipAsShortRange(blipCoord, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('map_blip'))
    EndTextCommandSetBlipName(blipCoord)


end)

function SetVehicleMaxMods(vehicle)

  local props = {
    modEngine       = 3,
    modBrakes       = 3,
    modTransmission = 3,
    modSuspension   = 3,
    modTurbo        = true,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)

end

function IsJobTrue()
    if PlayerData ~= nil then
        local IsJobTrue = false
        if PlayerData.job ~= nil and PlayerData.job.name == 'journaliste' then
            IsJobTrue = true
        end
        return IsJobTrue
    end
end

function IsGradeBoss()
    if PlayerData ~= nil then
        local IsGradeBoss = false
        if PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'viceboss' then
            IsGradeBoss = true
        end
        return IsGradeBoss
    end
end

function cleanPlayer(playerPed)
  ClearPedBloodDamage(playerPed)
  ResetPedVisibleDamage(playerPed)
  ClearPedLastWeaponDamage(playerPed)
  ResetPedMovementClipset(playerPed, 0)
end

function setClipset(playerPed, clip)
  RequestAnimSet(clip)
  while not HasAnimSetLoaded(clip) do
    Citizen.Wait(0)
  end
  SetPedMovementClipset(playerPed, clip, true)
end

function setUniform(job, playerPed)
  TriggerEvent('skinchanger:getSkin', function(skin)

    if skin.sex == 0 then
      if Config.Uniforms[job].male ~= nil then
        TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
      else
        ESX.ShowNotification(_U('no_outfit'))
      end
      if job ~= 'citizen_wear' and job ~= 'journaliste_outfit' then
        setClipset(playerPed, "MOVE_M@POSH@")
      end
    else
      if Config.Uniforms[job].female ~= nil then
        TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
      else
        ESX.ShowNotification(_U('no_outfit'))
      end
      if job ~= 'citizen_wear' and job ~= 'journaliste_outfit' then
        setClipset(playerPed, "MOVE_F@POSH@")
      end
    end

  end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function OpenCloakroomMenu()

  local playerPed = GetPlayerPed(-1)

  local elements = {
    { label = _U('citizen_wear'),     value = 'citizen_wear'},
    { label = _U('journaliste_outfit'),    value = 'journaliste_outfit'},
    { label = _U('journaliste_outfit_1'),  value = 'journaliste_outfit_1'},
    { label = _U('journaliste_outfit_2'),  value = 'journaliste_outfit_2'},
    { label = _U('journaliste_outfit_3'),  value = 'journaliste_outfit_3'},
  }
	
	ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'cloakroom',
    {
      title    = _U('cloakroom'),
      align    = 'top-left',
      elements = elements,
    },
    function(data, menu)

      isBarman = false
      cleanPlayer(playerPed)

      if data.current.value == 'citizen_wear' then
	    TriggerServerEvent("player:serviceOff", "journaliste")
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
          TriggerEvent('skinchanger:loadSkin', skin)
        end)
      end

      if data.current.value == 'journaliste_outfit' then
		TriggerServerEvent("player:serviceOn", "journaliste")
	  end
      if data.current.value == 'journaliste_outfit_1' and PlayerData.job.grade_name == 'reporter' or PlayerData.job.grade_name == 'investigator' or IsGradeBoss() then
		TriggerServerEvent("player:serviceOn", "journaliste")
	  end
      if  data.current.value == 'journaliste_outfit_2' and PlayerData.job.grade_name == 'investigator' or IsGradeBoss() then
		TriggerServerEvent("player:serviceOn", "journaliste")
	  end
      if  data.current.value == 'journaliste_outfit_3' and IsGradeBoss() then
		TriggerServerEvent("player:serviceOn", "journaliste")
      --then
        setUniform(data.current.value, playerPed)
      end

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}

    end,
    function(data, menu)
      menu.close()
      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}
    end
  )
end

function OpenBillingMenu(player)

  ESX.UI.Menu.Open(
    'dialog', GetCurrentResourceName(), 'billing',
    {
      title = _U('billing_amount')
    },
    function(data, menu)
    
      local amount = tonumber(data.value)
      local player, distance = ESX.Game.GetClosestPlayer()

      if player ~= -1 and distance <= 3.0 then

        menu.close()
        if amount == nil then
            ESX.ShowNotification(_U('amount_invalid'))
        else
            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_journaliste', _U('billing'), amount)
        end

      else
        ESX.ShowNotification(_U('no_players_nearby'))
      end

    end,
    function(data, menu)
        menu.close()
    end
  )
end

function OpenVaultMenu()

  if Config.EnableVaultManagement then

    local elements = {
      {label = _U('get_weapon'), value = 'get_weapon'},
      {label = _U('put_weapon'), value = 'put_weapon'},
      {label = _U('get_object'), value = 'get_stock'},
      {label = _U('put_object'), value = 'put_stock'}
    }
    

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vault',
      {
        title    = _U('vault'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        if data.current.value == 'get_weapon' then
          OpenGetWeaponMenu()
        end

        if data.current.value == 'put_weapon' then
          OpenPutWeaponMenu()
        end

        if data.current.value == 'put_stock' then
           OpenPutStocksMenu()
        end

        if data.current.value == 'get_stock' then
           OpenGetStocksMenu()
        end

      end,
      
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_vault'
        CurrentActionMsg  = _U('open_vault')
        CurrentActionData = {}
      end
    )

  end

end

function OpenGetStocksMenu()

  ESX.TriggerServerCallback('esx_journaliste:getStockItems', function(items)

    print(json.encode(items))

    local elements = {}

    for i=1, #items, 1 do
      table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = 'Journaliste Stock',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              OpenGetStocksMenu()

              TriggerServerEvent('esx_journaliste:getStockItem', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutStocksMenu()

  ESX.TriggerServerCallback('esx_journaliste:getPlayerInventory', function(inventory)

    local elements = {}

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
      end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = _U('inventory'),
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              OpenPutStocksMenu()

              TriggerServerEvent('esx_journaliste:putStockItems', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)


end

function OpenGetWeaponMenu()

  ESX.TriggerServerCallback('esx_journaliste:getVaultWeapons', function(weapons)

    local elements = {}

    for i=1, #weapons, 1 do
      if weapons[i].count > 0 then
        table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), value = weapons[i].name})
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vault_get_weapon',
      {
        title    = _U('get_weapon_menu'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        ESX.TriggerServerCallback('esx_journaliste:removeVaultWeapon', function()
          OpenGetWeaponMenu()
        end, data.current.value)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutWeaponMenu()

  local elements   = {}
  local playerPed  = GetPlayerPed(-1)
  local weaponList = ESX.GetWeaponList()

  for i=1, #weaponList, 1 do

    local weaponHash = GetHashKey(weaponList[i].name)

    if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
      local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
      table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
    end

  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'vault_put_weapon',
    {
      title    = _U('put_weapon_menu'),
      align    = 'top-left',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      ESX.TriggerServerCallback('esx_journaliste:addVaultWeapon', function()
        OpenPutWeaponMenu()
      end, data.current.value)

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function OpenVehicleSpawnerMenu()

  local vehicles = Config.Zones.Vehicles
  
  ESX.UI.Menu.CloseAll()

  if Config.EnableSocietyOwnedVehicles then

    local elements = {}

    ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles)

      for i=1, #garageVehicles, 1 do
        table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles[i].model) .. ' [' .. garageVehicles[i].plate .. ']', value = garageVehicles[i]})
      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vehicle_spawner',
        {
          title    = _U('vehicle_menu'),
          align    = 'top-left',
          elements = elements,
        },
        function(data, menu)

          menu.close()

          local vehicleProps = data.current.value
		  local vehicleSpawnPoint = vehicles.SpawnPoint
          ESX.Game.SpawnVehicle(vehicleProps.model, vehicleSpawnPoint, vehicles.Heading, function(vehicle)
              ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
              local playerPed = GetPlayerPed(-1)
              --TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)  -- teleport into vehicle
          end)            

          TriggerServerEvent('esx_society:removeVehicleFromGarage', 'journaliste', vehicleProps)

        end,
        function(data, menu)

          menu.close()

          CurrentAction     = 'menu_vehicle_spawner'
          CurrentActionMsg  = _U('vehicle_spawner')
          CurrentActionData = {}

        end
      )

    end, 'journaliste')

  else

    local elements = {}

    for i=1, #Config.AuthorizedVehicles, 1 do
      local vehicle = Config.AuthorizedVehicles[i]
      table.insert(elements, {label = vehicle.label, value = vehicle.name, location = vehicle.location})
    end

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'vehicle_spawner',
	  {
		title    = _U('vehicle_menu'),
		align    = 'top-left',
		elements = elements,
	  },
	  function(data, menu)

		menu.close()
		local spawnPoints = Config.SpawnPoints
		local model = data.current.value
		local location = data.current.location
		
		local vehicle = GetClosestVehicle(spawnPoints[location].x, spawnPoints[location].y, spawnPoints[location].z,  3.0,  0,  71)

		if not DoesEntityExist(vehicle) then

		  local playerPed = GetPlayerPed(-1)

		  if Config.MaxInService == -1 then
			
			ESX.Game.SpawnVehicle(model, {
			  x = spawnPoints[location].x,
			  y = spawnPoints[location].y,
			  z = spawnPoints[location].z
			}, spawnPoints[location].o, function(vehicle)
			  TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1) -- teleport into vehicle
			  SetVehicleMaxMods(vehicle)
			  SetVehicleDirtLevel(vehicle, 0)
			end)

		  else

			ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)

			  if canTakeService then

				ESX.Game.SpawnVehicle(model, {
				  x = vehicles[partNum].SpawnPoint.x,
				  y = vehicles[partNum].SpawnPoint.y,
				  z = vehicles[partNum].SpawnPoint.z
				}, vehicles[partNum].Heading, function(vehicle)
				  --TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)  -- teleport into vehicle
				  SetVehicleMaxMods(vehicle)
				  SetVehicleDirtLevel(vehicle, 0)
				end)

			  else
				ESX.ShowNotification(_U('service_max') .. inServiceCount .. '/' .. maxInService)
			  end

			end, 'etat')

		  end

		else
		  ESX.ShowNotification(_U('vehicle_out'))
		end

	  end,
	  function(data, menu)

		menu.close()

		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('vehicle_spawner')
		CurrentActionData = {}

	  end
	)

	

  end

end

AddEventHandler('esx_journaliste:hasEnteredMarker', function(zone)
 
    if zone == 'BossActions' and IsGradeBoss() then
      CurrentAction     = 'menu_boss_actions'
      CurrentActionMsg  = _U('open_bossmenu')
      CurrentActionData = {}
    end
 
    if zone == 'Cloakrooms' then
      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}
    end	

    if zone == 'Vehicles' then
        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = _U('vehicle_spawner')
        CurrentActionData = {}
    end	
	
    if Config.EnableVaultManagement then
      if zone == 'Vaults' then
        CurrentAction     = 'menu_vault'
        CurrentActionMsg  = _U('open_vault')
        CurrentActionData = {}
      end
    end	

    if zone == 'VehicleDeleters' or zone == 'VehicleDeletersHelico' then

      local playerPed = GetPlayerPed(-1)

      if IsPedInAnyVehicle(playerPed,  false) then

        local vehicle = GetVehiclePedIsIn(playerPed,  false)

        CurrentAction     = 'delete_vehicle'
        CurrentActionMsg  = _U('store_vehicle')
        CurrentActionData = {vehicle = vehicle}
      end

    end
 
    if zone == 'FromBossDeskToIn' then
      CurrentAction     = 'from_in_to_boss_desk'
      CurrentActionMsg  = _U('from_in_to_boss_desk_msg')
      CurrentActionData = {}
    end
    if zone == 'FromInToBossDesk' then
      CurrentAction     = 'from_boss_desk_to_in'
      CurrentActionMsg  = _U('from_boss_desk_to_in_msg')
      CurrentActionData = {}
    end
 
    if zone == 'FromReunionToIn' then
      CurrentAction     = 'from_in_to_reunion'
      CurrentActionMsg  = _U('from_in_to_reunion_msg')
      CurrentActionData = {}
    end
    if zone == 'FromInToReunion' then
      CurrentAction     = 'from_reunion_to_in'
      CurrentActionMsg  = _U('from_reunion_to_in_msg')
      CurrentActionData = {}
    end
	
    if zone == 'FromRoofToFloor' then
      CurrentAction     = 'from_floor_to_roof'
      CurrentActionMsg  = _U('from_floor_to_roof_msg')
      CurrentActionData = {}
    end
    if zone == 'FromFloorToRoof' then
      CurrentAction     = 'from_roof_to_floor'
      CurrentActionMsg  = _U('from_roof_to_floor_msg')
      CurrentActionData = {}
    end
	
    if zone == 'FromRoofToFirst' then
      CurrentAction     = 'from_first_to_roof'
      CurrentActionMsg  = _U('from_first_to_roof_msg')
      CurrentActionData = {}
    end
    if zone == 'FromFirstToRoof' then
      CurrentAction     = 'from_roof_to_first'
      CurrentActionMsg  = _U('from_roof_to_first_msg')
      CurrentActionData = {}
    end
	
    if zone == 'FromFirstToFloor' then
      CurrentAction     = 'from_floor_to_first'
      CurrentActionMsg  = _U('from_floor_to_first_msg')
      CurrentActionData = {}
    end
    if zone == 'FromFloorToFirst' then
      CurrentAction     = 'from_first_to_floor'
      CurrentActionMsg  = _U('from_first_to_floor_msg')
      CurrentActionData = {}
    end
	
    if zone == 'FromPhotoToRoof' then
      CurrentAction     = 'from_roof_to_photo'
      CurrentActionMsg  = _U('from_roof_to_photo_msg')
      CurrentActionData = {}
    end
    if zone == 'FromRoofToPhoto' then
      CurrentAction     = 'from_photo_to_roof'
      CurrentActionMsg  = _U('from_photo_to_roof_msg')
      CurrentActionData = {}
    end
	
end)

AddEventHandler('esx_journaliste:hasExitedMarker', function(zone)

    CurrentAction = nil
    ESX.UI.Menu.CloseAll()

end)

-- Display markers
Citizen.CreateThread(function()
    while true do

        Wait(0)
        if IsJobTrue() then

            local coords = GetEntityCoords(GetPlayerPed(-1))

            for k,v in pairs(Config.Zones) do
                if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
                    DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, false, false, false, false)
                end
            end

        end

    end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
    while true do

        Wait(0)
        if IsJobTrue() then

            local coords      = GetEntityCoords(GetPlayerPed(-1))
            local isInMarker  = false
            local currentZone = nil

            for k,v in pairs(Config.Zones) do
                if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
                    isInMarker  = true
                    currentZone = k
                end
            end

            if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
                HasAlreadyEnteredMarker = true
                LastZone                = currentZone
                TriggerEvent('esx_journaliste:hasEnteredMarker', currentZone)
            end

            if not isInMarker and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
                TriggerEvent('esx_journaliste:hasExitedMarker', LastZone)
            end

        end

    end
end)

-- Key Controls
Citizen.CreateThread(function()
  while true do

    Citizen.Wait(0)

    if CurrentAction ~= nil then

      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlJustReleased(0,  Keys['E']) and IsJobTrue() then

        if CurrentAction == 'menu_cloakroom' then
            OpenCloakroomMenu()
        end

        if CurrentAction == 'menu_vault' then
            OpenVaultMenu()
        end
		
        if CurrentAction == 'menu_vehicle_spawner' then
            OpenVehicleSpawnerMenu()
        end

        if CurrentAction == 'delete_vehicle' then

          if Config.EnableSocietyOwnedVehicles then

            local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
            TriggerServerEvent('esx_society:putVehicleInGarage', 'journaliste', vehicleProps)

          else

            if
              GetEntityModel(vehicle) == GetHashKey('rumpo')
            then
              TriggerServerEvent('esx_service:disableService', 'journaliste')
            end

          end

          ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
        end
		
        if CurrentAction == 'menu_boss_actions' and IsGradeBoss() then

          local options = {
            wash      = Config.EnableMoneyWash,
          }

          ESX.UI.Menu.CloseAll()

          TriggerEvent('esx_society:openBossMenu', 'journaliste', function(data, menu)

            menu.close()
            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = _U('open_bossmenu')
            CurrentActionData = {}

          end,options)

        end

		if CurrentAction == 'from_in_to_boss_desk' then
			ESX.Game.Teleport(GetPlayerPed(-1),  Config.Zones.FromInToBossDesk.Pos)
		end
		if CurrentAction == 'from_boss_desk_to_in' then
			ESX.Game.Teleport(GetPlayerPed(-1),  Config.Zones.FromBossDeskToIn.Pos)
		end

		if CurrentAction == 'from_in_to_reunion' then
			ESX.Game.Teleport(GetPlayerPed(-1),  Config.Zones.FromInToReunion.Pos)
		end
		if CurrentAction == 'from_reunion_to_in' then
			ESX.Game.Teleport(GetPlayerPed(-1),  Config.Zones.FromReunionToIn.Pos)
		end

		if CurrentAction == 'from_floor_to_roof' then
			ESX.Game.Teleport(GetPlayerPed(-1),  Config.Zones.FromFloorToRoof.Pos)
		end
		if CurrentAction == 'from_roof_to_floor' then
			ESX.Game.Teleport(GetPlayerPed(-1),  Config.Zones.FromRoofToFloor.Pos)
		end

		if CurrentAction == 'from_first_to_roof' then
			ESX.Game.Teleport(GetPlayerPed(-1),  Config.Zones.FromFirstToRoof.Pos)
		end
		if CurrentAction == 'from_roof_to_first' then
			ESX.Game.Teleport(GetPlayerPed(-1),  Config.Zones.FromRoofToFirst.Pos)
		end

		if CurrentAction == 'from_floor_to_first' then
			ESX.Game.Teleport(GetPlayerPed(-1),  Config.Zones.FromFloorToFirst.Pos)
		end
		if CurrentAction == 'from_first_to_floor' then
			ESX.Game.Teleport(GetPlayerPed(-1),  Config.Zones.FromFirstToFloor.Pos)
		end

		if CurrentAction == 'from_roof_to_photo' then
			ESX.Game.Teleport(GetPlayerPed(-1),  Config.Zones.FromRoofToPhoto.Pos)
		end
		if CurrentAction == 'from_photo_to_roof' then
			ESX.Game.Teleport(GetPlayerPed(-1),  Config.Zones.FromPhotoToRoof.Pos)
		end

        CurrentAction = nil

      end

    end

    if IsControlJustReleased(0,  Keys['F6']) and IsJobTrue()then
        OpenBillingMenu()
    end


  end
end)