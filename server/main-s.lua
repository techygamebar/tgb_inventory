-- RegisterCommand("addwep",function (source, args)
--     local source  = source
-- local identifier = GetPlayerIdentifier(source)
-- 	local wep = tostring(args[1])
-- 	local ammoCount = tonumber(args[2])
-- TriggerClientEvent("addwep",source, wep,ammoCount)
-- print(wep)
-- print(ammoCount)

-- local items = "{ 1:" ..wep..  "},{ 2:"  
-- MySQL.Async.execute('UPDATE players SET items = @items  WHERE identifier = @identifier', {
-- 	['@identifier'] = GetPlayerIdentifier(source),
-- 	['@items'] = items
-- })
-- end)


-- local source  = source
-- local identifier = GetPlayerIdentifier(source)
-- MySQL.Async.fetchScalar('SELECT 1 FROM lobby WHERE identifier = @identifier', {
-- 	['identifier'] = identifier
-- }, function(hasVoted)
-- 	if not hasVoted then
-- 		MySQL.Async.execute('INSERT INTO lobby (identifier, lobby) VALUES (@identifier, @lobby)', {
-- 			['identifier'] = identifier,
-- 			['lobby'] = lobby
-- 		})
-- 	else
-- MySQL.Async.execute('UPDATE lobby SET lobby = @lobby  WHERE identifier = @identifier', {
-- 	['@identifier'] = GetPlayerIdentifier(source),
-- 	['@lobby'] = lobby
-- })

-- {"4":{"count":6,"name":"hake"},"3":{"count":2,"name":"fishingrod"},"6":{"count":1,"name":"WEAPON_NIGHTSTICK"},"5":{"count":2,"name":"pike"},"8":{"count":8,"name":"scad"},"7":{"count":2,"name":"disc_ammo_rifle_large"},"2":{"count":2,"name":"WEAPON_CARBINERIFLE"},"1":{"count":94,"name":"bucket"}}





RegisterCommand("additem", function (source,args,raw)
local identifier = GetPlayerIdentifiers(source)[1]
   print(args[1])
	TriggerClientEvent("inventory:additem",source , args[1])

end)


-- RegisterServerEvent('inventory:additem')
-- AddEventHandler('inventory:additem', function(source ,item)
--     local source  = source
-- local identifier = GetPlayerIdentifier(source)
-- print(item)
--    if item == "WEAPON_APPISTOL" or item == "WEAPON_PISTOL" then
	
-- TriggerClientEvent("inventory:additem", source, item)
--    else

--    end
-- end)

-- RegisterCommand("additem", function (source)
-- 	local identifier = GetPlayerIdentifier(source)
-- 	 TriggerEvent("inventory:additem", source , "WEAPON_PISTOL")
-- 	TriggerEvent("inventory:additem", source , "WEAPON_APPISTOL")
   

-- end)


AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
   local _source = source
   local identifier = GetPlayerIdentifiers(_source)[1] 

   if identifier then
       MySQL.Async.fetchScalar('SELECT COUNT(1) FROM inventory WHERE identifier = @identifier', {
           ['@identifier'] = identifier
       }, function(count)
           if count == 0 then
               MySQL.Async.execute('INSERT INTO inventory (identifier, inventory) VALUES (@identifier, @inventory)', {
                   ['@identifier'] = identifier,
                   ['@inventory'] = json.encode({})
               }, function(rowsChanged)
                   if rowsChanged > 0 then
                       print("Player record created for SteamID:", identifier)
                   else
                       print("Failed to create player record for SteamID:", identifier)
                   end
               end)
           else
               print("Player record already exists for SteamID:", identifier)
           end
       end)
   else
       print("Player SteamID not found")
   end
end)


RegisterNetEvent('saveinventory')
AddEventHandler('saveinventory', function(inventory)
    local _source = source
    local identifier = GetPlayerIdentifiers(_source)[1] 

    if identifier then
        local inv = json.encode(inventory)
        MySQL.Async.execute('UPDATE inventory SET inventory = @inventory WHERE identifier = @identifier', {
            ['@identifier'] = identifier,
            ['@inventory'] = inv,
           
        }, function(affectedRows)
            if affectedRows > 0 then
                print("Inventory updated for SteamID:", identifier)
            else
                print("Failed to update inventory for SteamID:", identifier)
            end
        end)
    end
end)


RegisterNetEvent('getinventory')
AddEventHandler('getinventory', function()
    local source = source
    local identifier = GetPlayerIdentifiers(source)[1] 
   local name = GetPlayerName(source)
    if identifier then
        MySQL.Async.fetchAll('SELECT inventory FROM inventory WHERE identifier = @identifier', {
            ['@identifier'] = identifier
        }, function(result)
            if result[1] then
                local inventoryData = result[1].inventory
                local cs = json.encode(inventoryData)
                -- Decode the JSON string into a Lua table
                local cs2 = json.decode(cs)
                -- print(inventoryData)
             
               
                -- Decode the nested JSON string inside the 'crosshair' property
                -- local showCrosshair = crosshairObject.showCrosshair
                TriggerClientEvent('openinventory', source, name, cs2)
             TriggerClientEvent('addweplocally', source,json.decode(inventoryData))



               else
                -- print("No inventory found for this player")
            end
        end)
    end
end)

