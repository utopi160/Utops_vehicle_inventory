---@author Gaspard.M.
---@version 1.0
--[[
    File menu.lua
    Project Utops_vehicle_inventory
    Created at 28/12/2021 10:26
    Credit : https://github.com/utopi160
--]]
---@class _ClientMenu
_ClientMenu = {}
_ClientMenu.Open = false

FreezeEntityPosition(PlayerPedId(), false)
RegisterNetEvent(("%s:OpenMenu"):format(Config_Vehicle_Inventory.eventName))
AddEventHandler(("%s:OpenMenu"):format(Config_Vehicle_Inventory.eventName), function(plate, playerInventory, vehicle)
    if _ClientMenu.Open then
        _ClientMenu.Open = false
        Wait(2)
    end
    FreezeEntityPosition(PlayerPedId(), true)
    _ClientMenu.Open = true

    local Weapon = {}
    Weapon.Selected = {}
    Weapon.Ammo = {0, 10, 50, 70, 100, 150, 200, 300, 600}
    local function getActualWeight()
        local weight = 0
        for _, item in pairs(vehicle.items) do
            weight = item.count * Config_Vehicle_Inventory.Weight.Item
        end
        for _, weapon in pairs(vehicle.weapons) do
            weight = weapon.count * Config_Vehicle_Inventory.Weight.Weapon
        end
        weight = weight + (vehicle.money.cash / Config_Vehicle_Inventory.Weight.Money)
        weight = weight + (vehicle.money.dirty_money / Config_Vehicle_Inventory.Weight.Money)
        return weight
    end

    RMenu.Add("vehicle_inventory", "main", RageUI.CreateMenu(Config_Vehicle_Inventory.Menus.Title, Config_Vehicle_Inventory.Menus.Subtitle))
    RMenu.Add("vehicle_inventory", "player_inventory", RageUI.CreateSubMenu(RMenu:Get("vehicle_inventory", "main"), Config_Vehicle_Inventory.Menus.Title, Config_Vehicle_Inventory.Menus.Subtitle))
    RMenu.Add("vehicle_inventory", "vehicle_inventory", RageUI.CreateSubMenu(RMenu:Get("vehicle_inventory", "main"), Config_Vehicle_Inventory.Menus.Title, Config_Vehicle_Inventory.Menus.Subtitle))
    RMenu.Add("vehicle_inventory", "vehicle_inventory_weapon", RageUI.CreateSubMenu(RMenu:Get("vehicle_inventory", "vehicle_inventory"), Config_Vehicle_Inventory.Menus.Title, Config_Vehicle_Inventory.Menus.Subtitle))
    RageUI.Visible(RMenu:Get("vehicle_inventory", "main"), true)

    CreateThread(function()
        while _ClientMenu.Open do
            local CheckMenuOpen = false
            local function CheckMenu()
                CheckMenuOpen = true
            end
            local coords = GetEntityCoords(ActualVehicle)
            DrawMarker(2, coords.x, coords.y, coords.z + 1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 170, 0, 1, 2, 0, nil, nil, 0)
            RageUI.IsVisible(RMenu:Get('vehicle_inventory', "main"), true, true, true, function()
                CheckMenu()
                RageUI.Separator(("↓ Plaque : ~b~%s~s~ ↓"):format(plate))
                RageUI.Separator(("Contenu: ~y~%s/~y~%d"):format(getActualWeight(), vehicle.limit))

                RageUI.ButtonWithStyle(("Votre inventaire - (~o~%s~s~)"):format(_ClientUtils.GetNumberInTheTable(playerInventory.items) + #playerInventory.weapons), nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                end, RMenu:Get('vehicle_inventory', "player_inventory"))

                RageUI.ButtonWithStyle(("Le coffre - (~o~%s~s~)"):format(_ClientUtils.GetNumberInTheTable(vehicle.items) + _ClientUtils.GetNumberInTheTable(vehicle.weapons)), nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                end, RMenu:Get('vehicle_inventory', "vehicle_inventory"))
            end)

            RageUI.IsVisible(RMenu:Get('vehicle_inventory', "vehicle_inventory"), true, true, true, function()
                CheckMenu()
                    RageUI.Separator("↓ ~b~Liquide~s~ ↓")
                    RageUI.ButtonWithStyle(("Argent liquide : ~y~ %s"):format(vehicle.money.cash), nil, {RightLabel = "→"}, vehicle.money.cash ~= 0, function(Hovered, Active, Selected)
                        if Selected then
                            local amount = tonumber(_ClientUtils.Keyboard("liquide", "~b~Nombre d'argent à retirer", "", 10))
                            if amount ~= nil and type(amount) == "number" and amount >= 1 and amount <= vehicle.money.cash then
                                amount = math.floor(amount)
                                TriggerServerEvent(("%s:TakeCash"):format(Config_Vehicle_Inventory.eventName), plate, amount)
                            else
                                _ClientUtils.Notify("~r~La somme est inexact.")
                            end
                        end
                    end)
                    RageUI.ButtonWithStyle(("Source inconnue : ~m~ %s"):format(vehicle.money.dirty_money), nil, {RightLabel = "→"}, vehicle.money.dirty_money ~= 0, function(Hovered, Active, Selected)
                        if Selected then
                            local amount = tonumber(_ClientUtils.Keyboard("liquide", "~b~Nombre d'argent à retirer", "", 10))
                            if amount ~= nil and type(amount) == "number" and amount >= 1 and amount <= vehicle.money.dirty_money then
                                amount = math.floor(amount)
                                TriggerServerEvent(("%s:TakeDirtyMoney"):format(Config_Vehicle_Inventory.eventName), plate, amount)
                            else
                                _ClientUtils.Notify("~r~La somme est inexact.")
                            end
                        end
                    end)
                    RageUI.Separator("↓ ~b~Votre Inventaire~s~ ↓")
                    local countItems = 0
                    for itemName, itemInfo in pairs(vehicle.items) do
                        countItems = countItems + 1
                        RageUI.ButtonWithStyle(("[~b~%d~s~] - %s"):format(itemInfo.count, itemInfo.label), nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local number = tonumber(_ClientUtils.Keyboard("liquide", "~b~Nombre d'items à retirer", "", 10))
                                if number ~= nil and type(number) == "number" and number >= 1 and number <= itemInfo.count then
                                    number = math.floor(number)
                                    TriggerServerEvent(("%s:TakeItems"):format(Config_Vehicle_Inventory.eventName), plate, itemName, number)
                                else
                                    _ClientUtils.Notify("~r~La somme est inexact.")
                                end
                            end
                        end)
                    end
                    if countItems == 0 then
                        RageUI.Separator("")
                        RageUI.Separator("~r~Aucun Item")
                        RageUI.Separator("")
                    end

                    RageUI.Separator("↓ ~b~Vos Armes~s~ ↓")
                    local countWeapons = 0
                    for _, weaponInfo in pairs(vehicle.weapons) do
                        countWeapons = countWeapons + 1
                        RageUI.ButtonWithStyle(("[~r~%d~s~] - %s (~o~%d~s~)"):format(weaponInfo.count, weaponInfo.label, weaponInfo.ammo or 0), nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                Weapon.Selected = {label = weaponInfo.label, name = weaponInfo.name, ammo = weaponInfo.ammo}
                            end
                        end, RMenu:Get('vehicle_inventory', "vehicle_inventory_weapon"))
                    end
                    if countWeapons == 0 then
                        RageUI.Separator("")
                        RageUI.Separator("~r~Aucune Arme")
                        RageUI.Separator("")
                    end
            end)
            RageUI.IsVisible(RMenu:Get('vehicle_inventory', "vehicle_inventory_weapon"), true, true, true, function()
                CheckMenu()
                RageUI.Separator(("↓ Prendre : ~b~%s ~s~ ↓"):format(Weapon.Selected.label))
                for _, ammo in pairs(Weapon.Ammo) do
                    if ammo <= Weapon.Selected.ammo then
                        RageUI.ButtonWithStyle(("Prendre l'arme avec ~o~%s~s~ munitions"):format(ammo), nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                TriggerServerEvent(("%s:TakeWeapon"):format(Config_Vehicle_Inventory.eventName), plate, Weapon.Selected.name, ammo)
                            end
                        end)
                    end
                end
            end)
            RageUI.IsVisible(RMenu:Get('vehicle_inventory', "player_inventory"), true, true, true, function()
                CheckMenu()
                RageUI.Separator("↓ ~b~Liquide~s~ ↓")
                RageUI.ButtonWithStyle(("Argent liquide : ~y~ %s"):format(playerInventory.cash), nil, {RightLabel = "→"},  playerInventory.cash ~= 0, function(Hovered, Active, Selected)
                    if Selected then
                        local amount = tonumber(_ClientUtils.Keyboard("liquide", "~b~Nombre d'argent à retirer", "", 10))
                        if amount ~= nil and type(amount) == "number" and amount >= 1 and amount <= playerInventory.cash then
                            amount = math.floor(amount)
                            TriggerServerEvent(("%s:depositCash"):format(Config_Vehicle_Inventory.eventName), plate, amount)
                        else
                            _ClientUtils.Notify("~r~La somme est inexact.")
                        end
                    end
                end)
                RageUI.ButtonWithStyle(("Source inconnue : ~m~ %s"):format(playerInventory.dirty_money), nil, {RightLabel = "→"},  playerInventory.dirty_money ~= 0, function(Hovered, Active, Selected)
                    if Selected then
                        local amount = tonumber(_ClientUtils.Keyboard("liquide", "~b~Nombre d'argent à retirer", "", 10))
                        if amount ~= nil and type(amount) == "number" and amount >= 1 and amount <= playerInventory.dirty_money then
                            amount = math.floor(amount)
                            TriggerServerEvent(("%s:depositDirtyMoney"):format(Config_Vehicle_Inventory.eventName), plate, amount)
                        else
                            _ClientUtils.Notify("~r~La somme est inexact.")
                        end
                    end
                end)
                RageUI.Separator("↓ ~b~Votre Inventaire~s~ ↓")
                local countItems = 0
                for itemName, itemInfo in pairs(playerInventory.items) do
                    countItems = countItems + 1
                    if itemInfo.count > 0 then
                        RageUI.ButtonWithStyle(("[~b~%d~s~] - %s"):format(itemInfo.count, itemInfo.label), nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local number = tonumber(_ClientUtils.Keyboard("liquide", "~b~Nombre d'items à retirer", "", 10))
                                if number ~= nil and type(number) == "number" and number >= 1 and number <= itemInfo.count then
                                    number = math.floor(number)
                                    TriggerServerEvent(("%s:depositItems"):format(Config_Vehicle_Inventory.eventName), plate, itemName, number)
                                else
                                    _ClientUtils.Notify("~r~La somme est inexact.")
                                end
                            end
                        end)
                    end
                end
                if countItems == 0 then
                    RageUI.Separator("")
                    RageUI.Separator("~r~Aucun Item")
                    RageUI.Separator("")
                end
                RageUI.Separator("↓ ~b~Vos Armes~s~ ↓")
                local countWeapons = 0
                for _, weaponInfo in pairs(playerInventory.weapons) do
                    countWeapons = countWeapons + 1
                    RageUI.ButtonWithStyle(("[~r~%d~s~] - %s"):format(weaponInfo.ammo or 0, weaponInfo.label), nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent(("%s:depositWeapon"):format(Config_Vehicle_Inventory.eventName), plate, weaponInfo.name, weaponInfo.ammo)
                        end
                    end)
                end
                if countWeapons == 0 then
                    RageUI.Separator("")
                    RageUI.Separator("~r~Aucune Arme")
                    RageUI.Separator("")
                end
            end)
            if _ClientMenu.Open and not CheckMenuOpen then
                _ClientMenu.Open = false
                if Config_Vehicle_Inventory.use3dme then
                    ExecuteCommand("me Ferme le coffre")
                end
                TriggerServerEvent(("%s:CloseMenu"):format(Config_Vehicle_Inventory.eventName), plate)
                FreezeEntityPosition(PlayerPedId(), false)
                SetVehicleDoorShut(actualVehicle, 5, 0)
                SetVehicleDoorShut(actualVehicle, 2, 0)
                SetVehicleDoorShut(actualVehicle, 3, 0)
                RMenu:DeleteType("vehicle_inventory")
                actualVehicle = nil
            end
            Wait(1)
        end
    end)
end)


