ESX 						   = nil
local CopsConnected       	   = 0
local TaxiConnected       	   = 0
local SaniConnected       	   = 0
local MecaConnected       	   = 0
local EpicerieConnected		   = 0
local RealestateagentConnected = 0

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function CountCops()

	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0
	TaxiConnected = 0
	SaniConnected = 0
	MecaConnected = 0
	EpicerieConnected = 0
	RealestateagentConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		elseif xPlayer.job.name == 'taxi' then
			TaxiConnected = TaxiConnected + 1
		elseif xPlayer.job.name == 'mechanic' then
			MecaConnected = MecaConnected + 1
		elseif xPlayer.job.name == 'ambulance' then
			SaniConnected = SaniConnected + 1
		elseif xPlayer.job.name == 'epicerie' then
			EpicerieConnected = EpicerieConnected + 1
		elseif xPlayer.job.name == 'realestateagent' then
			RealestateagentConnected = RealestateagentConnected + 1
		end
	end

	SetTimeout(30000, CountCops)

end

CountCops()

RegisterServerEvent('esx_jobCounter:get')
AddEventHandler('esx_jobCounter:get', function()
	local counted = {}

	counted['police'] = CopsConnected
	counted['taxi'] = TaxiConnected
	counted['mechanic'] = MecaConnected
	counted['ambulance'] = SaniConnected
	counted['epicerie'] = EpicerieConnected
	counted['realestateagent'] = RealestateagentConnected

	TriggerClientEvent('esx_jobCounter:set', source, counted)
end)