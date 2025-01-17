local streetName = {}

-- Configuration. Please be careful when editing. It does not check for errors.
streetName.show = true
streetName.position = {x = 0.084, y = 0.785, centered = true}
streetName.textSize = 0.25
streetName.textColour = {r = 255, g = 255, b = 255, a = 255}
-- End of configuration


Citizen.CreateThread( function()
	local lastStreetA = 0
	local lastStreetB = 0
	local lastStreetName = {}
	
	while true do
		Wait( 0 )
		if streetName.show then
			local playerPos = GetEntityCoords( GetPlayerPed( -1 ), true )
			local streetA, streetB = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, playerPos.x, playerPos.y, playerPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
			local street = {}
			
			if not ((streetA == lastStreetA or streetA == lastStreetB) and (streetB == lastStreetA or streetB == lastStreetB)) then
				-- Ignores the switcharoo while doing circles on intersections
				lastStreetA = streetA
				lastStreetB = streetB
			end
			
			if lastStreetA ~= 0 then
				table.insert( street, GetStreetNameFromHashKey( lastStreetA ) )
			end
			
			if lastStreetB ~= 0 then
				table.insert( street, GetStreetNameFromHashKey( lastStreetB ) )
			end
			
			local txt = table.concat( street, " & " )
			if string.len(txt) > 35 then
				txt = string.sub(txt,0,35).."..."
			end
			drawText(txt , streetName.position.x, streetName.position.y, {
				size = streetName.textSize,
				colour = streetName.textColour,
				outline = true,
				centered = streetName.position.centered
			})
		
		end
	end
end)

RegisterNetEvent('compass:show')
AddEventHandler('compass:show', function(toggle)
	streetName.show = toggle
end)