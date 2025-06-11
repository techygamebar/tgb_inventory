



RegisterCommand("additem", function(source, args, raw)
    if not args[1] or not args[2] then
        TriggerClientEvent("chat:addMessage", source, {
            args = {"^1SYSTEM", "Usage: /additem [playerID] [itemName]"}
        })
        return
    end

    local targetId = tonumber(args[1])
    local itemName = args[2]

    if targetId and GetPlayerIdentifiers(targetId)[1] then
        TriggerClientEvent("inventory:additem", targetId, itemName)

        TriggerClientEvent("chat:addMessage", source, {
            args = {"^2SYSTEM", "Item '" .. itemName .. "' given to player ID " .. targetId}
        })
    else
        TriggerClientEvent("chat:addMessage", source, {
            args = {"^1SYSTEM", "Invalid player ID."}
        })
    end
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
                   ['@inventory'] = json.encode({
                    holster1 = "", holster2 = "", holster3 = "", holster4 = "", holster5 = "",
                    holster6 = "", holster7 = "", holster8 = "", holster9 = "", holster10 = "",
                    slot1 = "", slot2 = "", slot3 = "", slot4 = "", slot5 = "", slot6 = "",
                    slot7 = "", slot8 = "", slot9 = "", slot10 = "", slot11 = "", slot12 = "",
                    slot13 = "", slot14 = "", slot15 = "", slot16 = "", slot17 = "", slot18 = "",
                    slot19 = "", slot20 = "", slot21 = "", slot22 = "", slot23 = "", slot24 = "",
                    slot25 = "", slot26 = "", slot27 = "", slot28 = "", slot29 = "", slot30 = "",
                    slot31 = "", slot32 = "", slot33 = "", slot34 = "", slot35 = "", slot36 = ""
                })
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
                local cs2 = json.decode(cs)
                -- print(inventoryData)
             
               
                -- local showCrosshair = crosshairObject.showCrosshair
                TriggerClientEvent('openinventory', source, name, cs2)
             TriggerClientEvent('addweplocally', source,json.decode(inventoryData))



               else
                -- print("No inventory found for this player")
            end
        end)
    end
end)

