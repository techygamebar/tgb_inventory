local isopen = false
-----------------------------------------------------------------------------
-- NUI OPEN EXPORT/EVENT
-----------------------------------------------------------------------------

RegisterCommand("inv", function(source, args, rawCommand)
	if not IsPauseMenuActive() then
		open()
	end
end, false)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(1)
		SetPedConfigFlag(PlayerPedId(), 48, true)
	if not IsPauseMenuActive() then
		if IsControlJustPressed(1, 311) then
    TriggerServerEvent("getinventory")
            
		end
	end
	end
end)


-- AddEventHandler('playerSpawned', function()
--     TriggerServerEvent("getinventory")
  
--  end)

-- Citizen.CreateThread(function()
--     while true do
-- 		Citizen.Wait(1)
-- 			if not IsPauseMenuActive() then
-- 		if IsControlJustPressed(1, 20) then
-- 			hotbar()
-- 		end
-- 	end
-- 	end
-- end)

RegisterNetEvent("openinventory")
AddEventHandler("openinventory",  function(name,inventoryData)

	isopen = true
	SetNuiFocus(true, true)
	SendNUIMessage({
		type = "show",
		name = name,
		inventorydata=inventoryData
	})
end)
RegisterNetEvent("addweplocally")
AddEventHandler("addweplocally", function(invdata)
    local playerPed = PlayerPedId()
        for slot, weapon in pairs(invdata) do
        if weapon and weapon ~= "" then
            GiveWeaponToPed(playerPed, GetHashKey(weapon), 10000, false, false)
        end
    end

end)

-- function hotbar()
-- 	SetNuiFocus(false, false)
-- 	SendNUIMessage({
-- 		type = "showhotbar",
	
-- 	})
-- end
function open()
	isopen = true
	SetNuiFocus(true, true)
	SendNUIMessage({
		type = "show",
		name = GetPlayerName(source),
		inventorydata= json.encode(inventorydata)
	})
end

function close()
	isopen = false
	SetNuiFocus(false, false)
	SendNUIMessage({
		type = "hide"
	})
end


-----------------
-- NUI CALLBACKS
----------------

RegisterNUICallback('hide', function()
	close()
end)

RegisterNUICallback('saveinventory', function(inventory)
	print(inventory)
TriggerServerEvent("saveinventory", inventory)
end)

local currentWeapon = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if not IsPauseMenuActive() then
            if IsControlJustPressed(1, 157) then
                toggleWeapon(1)
            elseif IsControlJustPressed(1, 158) then
                toggleWeapon(2)
            elseif IsControlJustPressed(1, 160) then
                toggleWeapon(3)
            elseif IsControlJustPressed(1, 164) then
                toggleWeapon(4)
            elseif IsControlJustPressed(1, 165) then
                toggleWeapon(5)
            end
        end
    end
end)


RegisterNUICallback('equipweapon', function(weaponname)
    equipWeapon(weaponname)
    print(weaponname)
end)

RegisterNUICallback('useitem', function(weaponname)
    useitem(weaponname)
    print(weaponname)
end)
-------------
-- FUNCTIONS
------------

function toggleWeapon(holsterKey)
    SendNUIMessage({type = "holster", key = holsterKey})
end

function unequipWeapon()
    SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
    currentWeapon = nil
    print("Weapon unequipped")
end

function equipWeapon(weaponName)
    local ped = PlayerPedId()
    local weaponHash = GetHashKey(weaponName)

    if currentWeapon == weaponName then
        unequipWeapon()
        return
    end

    if HasPedGotWeapon(ped, weaponHash, false) and not isEquipping then
        isEquipping = true
        local animDict = "rcmjosh4"
        local animName = "josh_leadout_cop2"
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Citizen.Wait(10)
        end

        TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, 1000, 48, 0, false, false, false)
        local startTime = GetGameTimer()
        local blockDuration = 1000 
        Citizen.CreateThread(function()
            while GetGameTimer() - startTime < blockDuration do
                DisablePlayerFiring(ped, true) --  shooting
                DisableControlAction(0, 24, true) --  attack
                DisableControlAction(0, 25, true) --  aim
                Citizen.Wait(0)
            end
        end)

        Citizen.Wait(blockDuration)

        GiveWeaponToPed(ped, weaponHash, 250, false, true)
        SetCurrentPedWeapon(ped, weaponHash, true)
        currentWeapon = weaponName
        ClearPedTasks(ped)

        isEquipping = false
    end
end
local isUsingItem = false

function useitem(weaponname)
    local playerPed = GetPlayerPed(-1)
    
    if isUsingItem then
        print("Already using an item. Please wait.")
        return
    end

    print(weaponname)

    if weaponname == "ARMOUR" then
        if GetPedArmour(playerPed) >= 100 then
            print("Already have full armour.")
            return
        end

        isUsingItem = true
        -- Play armour animation
        local animDict = "move_m@intimidation@cop@unarmed"
        local animName = "idle" 

        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Citizen.Wait(0)
        end

        TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, 2000, 49, 0, false, false, false)
        Citizen.Wait(2000) 
        AddArmourToPed(playerPed, 50) 
        print("Armour applied.")

        ClearPedTasks(playerPed)
        isUsingItem = false
    elseif weaponname == "METH" then
        isUsingItem = true

        SetRunSprintMultiplierForPlayer(PlayerId(), 1.2) 
        print("Meth effect applied.")
        Citizen.Wait(10000) 
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0) 
        print("Meth effect ended.")

        isUsingItem = false
    elseif weaponname == "OXY" then
        if GetEntityHealth(playerPed) >= GetEntityMaxHealth(playerPed) then
            print("Health is already full.")
            return
        end

        isUsingItem = true

        SetEntityHealth(playerPed, GetEntityHealth(playerPed) + 25) -- + 25 HP
        print("Oxy used for healing.")

        isUsingItem = false
    else
        print("Invalid item.")
    end
end


function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end



local weapons = {
	"WEAPON_ADVANCEDRIFLE",
	"WEAPON_APPISTOL",
	"WEAPON_ASSAULTRIFLE_MK2",
	"WEAPON_ASSAULTRIFLE",
	"WEAPON_ASSAULTSHOTGUN",
	"WEAPON_ASSAULTSMG",
	"WEAPON_AUTOSHOTGUN",
	"WEAPON_BALL",
	"WEAPON_BAT",
	"WEAPON_BATTLEAXE",
	"WEAPON_BOTTLE",
	"WEAPON_CARBINERIFLE",
	"WEAPON_COMBATPDW",
	"WEAPON_COMBATPISTOL",
	"WEAPON_PISTOL",

}
local items = {
	"ARMOUR",
	"OXY",
	"METH",

}
function Isaweapon(wepname)
    for _, weapon in ipairs(weapons) do
        if weapon == wepname then
            return true
        end
    end
    return false
end
function Isaitem(itemname)
    for _, item in ipairs(items) do
        if item == itemname then
            return true
        end
    end
    return false
end

RegisterNetEvent("inventory:additem")
 AddEventHandler("inventory:additem"  , function (item)
	print(item)

	if Isaweapon(item) then
		
	local hash = GetHashKey(item)

	GiveWeaponToPed(GetPlayerPed(-1), hash, 10000, false, true)
	SendNUIMessage({
		src = "img/"..item..".png",
		action = item
	})
end
if Isaitem(item) then
		
	local hash = item

	SendNUIMessage({
		src = "img/"..item..".png",
		action = item
	})
end

end)





