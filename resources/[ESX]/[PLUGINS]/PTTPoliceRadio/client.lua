-- Created by Deziel0495 and IllusiveTea --

-- NOTICE
-- This script is licensed under "No License". https://choosealicense.com/no-license/
-- You are allowed to: Download, Use and Edit the Script. 
-- You are not allowed to: Copy, re-release, re-distribute it without our written permission.

--- DO NOT EDIT THIS
local holstered = true

-- RESTRICTED PEDS --
-- I've only listed peds that have a remote speaker mic, but any ped listed here will do the animations.
local skins = {
	
}

-- Add/remove weapon hashes here to be added for holster checks.
local weapons = {
	"WEAPON_PISTOL",
	"WEAPON_COMBATPISTOL",
}

-- RADIO ANIMATIONS --

Citizen.CreateThread(function()
	while true do
		Citizen.Wait( 0 )
		local ped = PlayerPedId()
		if DoesEntityExist( ped ) and not IsEntityDead( ped ) then
			if not IsPauseMenuActive() then 
				loadAnimDict( "random@arrests" )
				if IsControlJustReleased( 0, 19 ) then -- INPUT_CHARACTER_WHEEL (LEFT ALT)
					TriggerServerEvent('InteractSound_SV:PlayOnSource', 'off', 0.1)
					ClearPedTasks(ped)
					SetEnableHandcuffs(ped, false)
				else
					if IsControlJustPressed( 0, 19 ) and not IsPlayerFreeAiming(PlayerId()) then -- INPUT_CHARACTER_WHEEL (LEFT ALT)
						TriggerServerEvent('InteractSound_SV:PlayOnSource', 'on', 0.1)
						TaskPlayAnim(ped, "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
						SetEnableHandcuffs(ped, true)
					elseif IsControlJustPressed( 0, 19 ) and IsPlayerFreeAiming(PlayerId()) then -- INPUT_CHARACTER_WHEEL (LEFT ALT)
						TriggerServerEvent('InteractSound_SV:PlayOnSource', 'on', 0.1)
						TaskPlayAnim(ped, "random@arrests", "radio_chatter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
						SetEnableHandcuffs(ped, true)
					end 
					if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests", "generic_radio_enter", 3) then
						DisableActions(ped)
					elseif IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests", "radio_chatter", 3) then
						DisableActions(ped)
					end
				end
			end 
		end 
	end
end )

-- DO NOT REMOVE THESE! --

function CheckSkin(ped)
	for i = 1, #skins do
		if GetHashKey(skins[i]) == GetEntityModel(ped) then
			return true
		end
	end
	return false
end

function CheckWeapon(ped)
	for i = 1, #weapons do
		if GetHashKey(weapons[i]) == GetSelectedPedWeapon(ped) then
			return true
		end
	end
	return false
end

function DisableActions(ped)
	DisableControlAction(1, 140, true)
	DisableControlAction(1, 141, true)
	DisableControlAction(1, 142, true)
	DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
	DisablePlayerFiring(ped, true) -- Disable weapon firing
end

function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 0 )
	end
end
