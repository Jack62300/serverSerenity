ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('duty:police')
AddEventHandler('duty:police', function(job)

        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.job.name == 'police' and xPlayer.job.grade == 0 then
        xPlayer.setJob('offpolice', 0)	
    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 1 then
        xPlayer.setJob('offpolice', 1)
    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 2 then
        xPlayer.setJob('offpolice', 2)
    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 3 then
        xPlayer.setJob('offpolice', 3)
    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 4 then
        xPlayer.setJob('offpolice', 4)
	elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 5 then
        xPlayer.setJob('offpolice', 5)
	elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 6 then
        xPlayer.setJob('offpolice', 6)
    end

	if xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 0 then
        xPlayer.setJob('police', 0)	
    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 1 then
        xPlayer.setJob('police', 1)
    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 2 then
        xPlayer.setJob('police', 2)
    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 3 then
        xPlayer.setJob('police', 3)
    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 4 then
        xPlayer.setJob('police', 4)
	elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 5 then
        xPlayer.setJob('police', 5)
	elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 6 then
        xPlayer.setJob('police', 6)
    end
end)

RegisterServerEvent('duty:ambulance')
AddEventHandler('duty:ambulance', function(job)

        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer.job.name == 'ambulance' and xPlayer.job.grade == 0 then
        xPlayer.setJob('offambulance', 0)
	elseif xPlayer.job.name == 'ambulance' and xPlayer.job.grade == 1 then
        xPlayer.setJob('offambulance', 1)
    elseif xPlayer.job.name == 'ambulance' and xPlayer.job.grade == 2 then
        xPlayer.setJob('offambulance', 2)
    elseif xPlayer.job.name == 'ambulance' and xPlayer.job.grade == 3 then
        xPlayer.setJob('offambulance', 3)
	elseif xPlayer.job.name == 'ambulance' and xPlayer.job.grade == 4 then
        xPlayer.setJob('offambulance', 4)
	elseif xPlayer.job.name == 'ambulance' and xPlayer.job.grade == 5 then
        xPlayer.setJob('offambulance', 5)
	elseif xPlayer.job.name == 'ambulance' and xPlayer.job.grade == 6 then
        xPlayer.setJob('offambulance', 6)
    end

    if xPlayer.job.name == 'offambulance' and xPlayer.job.grade ==0 then
        xPlayer.setJob('ambulance', 0)
	elseif xPlayer.job.name == 'offambulance' and xPlayer.job.grade == 1 then
        xPlayer.setJob('ambulance', 1)
    elseif xPlayer.job.name == 'offambulance' and xPlayer.job.grade == 2 then
        xPlayer.setJob('ambulance', 2)
    elseif xPlayer.job.name == 'offambulance' and xPlayer.job.grade == 3 then
        xPlayer.setJob('ambulance', 3)
	elseif xPlayer.job.name == 'offambulance' and xPlayer.job.grade == 4 then
        xPlayer.setJob('ambulance', 4)
	elseif xPlayer.job.name == 'offambulance' and xPlayer.job.grade == 5 then
        xPlayer.setJob('ambulance', 5)
	elseif xPlayer.job.name == 'offambulance' and xPlayer.job.grade == 6 then
        xPlayer.setJob('ambulance', 6)
    end
end)