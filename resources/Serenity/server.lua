ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('es:addGroupCommand', 'setmodel', 'mod', function(source, args, user)
  if args[2] ~= nil and args[3] ~= nil and args[4] ~= nil then
	TriggerClientEvent('Serenity:applyskin', source, args[1] ,tonumber(args[2]) ,tonumber(args[3]) ,tonumber(args[4]))
  else
	TriggerClientEvent('Serenity:applyskin', source, args[1] ,1 ,1 ,1)
  end
end, function(source, args, user)
  TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, 'Insufficient permissions!')
end, {help = "Set Model xxxxx"})

TriggerEvent('es:addGroupCommand', 'cleararea', 'mod', function(source, args, user)
  local radius = 10
  if args[1] ~= nil then
    radius = args[1] 
  end
  TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, 'Zone Clear '.. radius)
  TriggerClientEvent('Serenity:cleararea', source, radius )
end, function(source, args, user)
  TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, 'Insufficient permissions!')
end, {help = "Clear zone"})