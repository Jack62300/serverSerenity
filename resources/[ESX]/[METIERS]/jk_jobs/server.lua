ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_jk_jobs:setJobt')
AddEventHandler('esx_jk_jobs:setJobt', function(job)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.setJob("lumberjack", 0)-- 0 is job grade
	TriggerClientEvent('esx:showNotification', source, 'Vous avez un nouveau Job ~g~' .. xPlayer.getName())
end)

RegisterServerEvent('esx_jk_jobs:setJobm')
AddEventHandler('esx_jk_jobs:setJobm', function(job)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.setJob("trucker", 0)-- 0 is job grade
	TriggerClientEvent('esx:showNotification', source, 'Vous avez un nouveau Job ~g~' .. xPlayer.getName())
end)

RegisterServerEvent('esx_jk_jobs:setJobp')
AddEventHandler('esx_jk_jobs:setJobp', function(job)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.setJob("unemployed", 0)-- 0 is job grade
	TriggerClientEvent('esx:showNotification', source, 'Vous n avez plus de Job ~g~' .. xPlayer.getName())
end)

RegisterServerEvent('esx_jk_jobs:setJobn')
AddEventHandler('esx_jk_jobs:setJobn', function(job)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.setJob("poolcleaner", 0) -- 0 is job grade
	TriggerClientEvent('esx:showNotification', source, 'Vous avez un nouveau Job ~g~' .. xPlayer.getName())	
end)
