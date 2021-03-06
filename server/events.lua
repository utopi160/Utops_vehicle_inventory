---@author Gaspard.M.
---@version 1.0
--[[
    File events.lua
    Project Utops_vehicle_inventory
    Created at 28/12/2021 10:30
    Credit : https://github.com/utopi160
--]]
---@type table
PlayersInCarTrunk = {}

local function refreshMenu(source, plate)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerInventory = {cash = xPlayer.getMoney(), dirty_money = xPlayer.getAccount("black_money").money, items = _ServerUtils.formatInventory(source), weapons = xPlayer.getLoadout()}

    TriggerClientEvent(("%s:OpenMenu"):format(Config_Vehicle_Inventory.eventName), source, plate, playerInventory, _VehicleInventory.list[plate])
end

RegisterNetEvent(("%s:OpenMenu"):format(Config_Vehicle_Inventory.eventName))
AddEventHandler(("%s:OpenMenu"):format(Config_Vehicle_Inventory.eventName), function(plate, info)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    ---@type _VehicleInventory
    local vehicle = _VehicleInventory.list[plate]
    local playerInventory = {cash = xPlayer.getMoney(), dirty_money = xPlayer.getAccount("black_money").money, items = _ServerUtils.formatInventory(source), weapons = xPlayer.getLoadout()}

    if PlayersInCarTrunk[source] then
        _ServerUtils.Notify(source, _GenericMessages.errors)
        _LogsManagers:registerLogs({title = _GenericMessages.logs.messages["cheateur"].title, message = (_GenericMessages.logs.messages["cheateur"].message):format(source, xPlayer.identifier), color = _GenericMessages.logs.messages["cheateur"].color})
        return
    end
    if plate == nil or type(plate) ~= "string" then
        _ServerUtils.Notify(source, _GenericMessages.errors)
        return
    end
    if info.class == nil and not Config_Vehicle_Inventory.Limit[info.class] and info.model == nil then
        _ServerUtils.Notify(source, _GenericMessages.errors)
        return
    end
    if not vehicle then
        local data = MySQL.Sync.fetchAll("SELECT inventory, owner FROM "..Config_Vehicle_Inventory.nameTable.." WHERE plate = @plate", {
            ['@plate'] = plate
        })
        if data[1] == nil then
            TriggerClientEvent(("%s:OpenMenu"):format(Config_Vehicle_Inventory.eventName), source, plate, playerInventory, _VehicleInventory.registerVehicle(plate, {class = tonumber(info.class), model = tostring(info.model), save = false }))
        else
            if data[1].inventory == nil then
                TriggerClientEvent(("%s:OpenMenu"):format(Config_Vehicle_Inventory.eventName), source, plate, playerInventory, _VehicleInventory.registerVehicle(plate, {class = tonumber(info.class), model = tostring(info.model), save = true }))
            else
                local dataVehicle = json.decode(data[1].inventory)
                local vehicle = _VehicleInventory(dataVehicle)
                if vehicle:verifyInventory() then
                    TriggerClientEvent(("%s:OpenMenu"):format(Config_Vehicle_Inventory.eventName), source, plate, playerInventory, vehicle)
                else
                    _ServerUtils.Notify(source, "~r~Une op??ration est en cours, merci de patienter.")
                end
            end
        end
    else
        if vehicle:verifyInventory() then
            TriggerClientEvent(("%s:OpenMenu"):format(Config_Vehicle_Inventory.eventName), source, plate, playerInventory, _VehicleInventory.list[plate])
        else
            _ServerUtils.Notify(source, "~r~Une op??ration est en cours, merci de patienter.")
        end
    end
    _VehicleInventory.list[plate]:verifyInventory()
    PlayersInCarTrunk[source] = plate
    _LogsManagers:registerLogs({title = _GenericMessages.logs.messages["open"].title, message = (_GenericMessages.logs.messages["open"].message):format(source, xPlayer.identifier, plate), color = _GenericMessages.logs.messages["open"].color})
end)

RegisterNetEvent(("%s:CloseMenu"):format(Config_Vehicle_Inventory.eventName))
AddEventHandler(("%s:CloseMenu"):format(Config_Vehicle_Inventory.eventName), function(plate)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    ---@type _VehicleInventory
    local vehicle = _VehicleInventory.list[plate]

    if PlayersInCarTrunk[source] ~= plate then
        _ServerUtils.Notify(source, _GenericMessages.errors)
        _LogsManagers:registerLogs({title = _GenericMessages.logs.messages["cheateur"].title, message = (_GenericMessages.logs.messages["cheateur"].message):format(source, xPlayer.identifier), color = _GenericMessages.logs.messages["cheateur"].color})
        return
    end
    if plate == nil or type(plate) ~= "string" then
        _ServerUtils.Notify(source, _GenericMessages.errors)
        return
    end
    if not vehicle then
        _VehicleInventory.registerVehicle(plate)
        _ServerUtils.Notify(source, _GenericMessages.errors)
        return
    end
    if vehicle:hasSaveInventory() then
        MySQL.Sync.execute("UPDATE `owned_vehicles` SET inventory = @inventory WHERE owned_vehicles.plate = @plate", {
            ["@plate"] = plate,
            ["@inventory"] = json.encode(vehicle),
        })
    end
    if PlayersInCarTrunk[source] == plate then
        PlayersInCarTrunk[source] = nil
        _LogsManagers:registerLogs({title = _GenericMessages.logs.messages["close"].title, message = (_GenericMessages.logs.messages["close"].message):format(source, xPlayer.identifier, plate), color = _GenericMessages.logs.messages["close"].color})
    end
end)

RegisterNetEvent(("%s:depositCash"):format(Config_Vehicle_Inventory.eventName))
AddEventHandler(("%s:depositCash"):format(Config_Vehicle_Inventory.eventName), function(plate, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    ---@type _VehicleInventory
    local vehicle = _VehicleInventory.list[plate]
    local amount = math.floor(tonumber(amount))

    if PlayersInCarTrunk[source] ~= plate then
        _ServerUtils.Notify(source, _GenericMessages.errors)
        _LogsManagers:registerLogs({title = _GenericMessages.logs.messages["cheateur"].title, message = (_GenericMessages.logs.messages["cheateur"].message):format(source, xPlayer.identifier), color = _GenericMessages.logs.messages["cheateur"].color})
        return
    end
    if plate == nil or type(plate) ~= "string" then
        _ServerUtils.Notify(source, _GenericMessages.errors)
        return
    end
    if not vehicle then
        _VehicleInventory.registerVehicle(plate)
        _ServerUtils.Notify(source, _GenericMessages.errors)
        return
    end
    if amount == nil or amount < 0 and type(amount) ~= "number" then
        _ServerUtils.Notify(source, "~r~La somme est inexact.")
        return
    end
    if vehicle:getActualWeight() >= vehicle:getMaxLimit() then
        _ServerUtils.Notify(source, "~r~Le coffre est d??j?? remplis.")
        return
    end
    if (vehicle:getActualWeight() + (amount / Config_Vehicle_Inventory.Weight.Money)) <= vehicle:getMaxLimit() then
        if xPlayer.getMoney() >= amount then
            xPlayer.removeMoney(amount)
            vehicle:depositCash(amount)
            _ServerUtils.Notify(source, ("Vous venez de poser ~g~%s$~s~ dans le coffre."):format(amount))
            refreshMenu(source, plate)
            _LogsManagers:registerLogs({title = _GenericMessages.logs.messages["deposit_cash"].title, message = (_GenericMessages.logs.messages["deposit_cash"].message):format(source, xPlayer.identifier, amount, vehicle:getActualWeight(), vehicle:getMaxLimit(), plate), color = _GenericMessages.logs.messages["deposit_cash"].color})
        else
            _ServerUtils.Notify(source, "~r~Vous n'avez pas assez d'argent.")
        end
    else
        _ServerUtils.Notify(source, "~r~Plus de place dans le coffre.")
    end
end)

RegisterNetEvent(("%s:depositDirtyMoney"):format(Config_Vehicle_Inventory.eventName))
AddEventHandler(("%s:depositDirtyMoney"):format(Config_Vehicle_Inventory.eventName), function(plate, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    ---@type _VehicleInventory
    local vehicle = _VehicleInventory.list[plate]
    local amount = math.floor(tonumber(amount))

    if PlayersInCarTrunk[source] ~= plate then
        _ServerUtils.Notify(source, _GenericMessages.errors)
        _LogsManagers:registerLogs({title = _GenericMessages.logs.messages["cheateur"].title, message = (_GenericMessages.logs.messages["cheateur"].message):format(source, xPlayer.identifier), color = _GenericMessages.logs.messages["cheateur"].color})
        return
    end
    if plate == nil or type(plate) ~= "string" then
        _ServerUtils.Notify(source, _GenericMessages.errors)
        return
    end
    if not vehicle then
        _VehicleInventory.registerVehicle(plate)
        _ServerUtils.Notify(source, _GenericMessages.errors)
        return
    end
    if amount < 0 and type(amount) ~= "number" then
        _ServerUtils.Notify(source, "~r~La somme est inexact.")
        return
    end
    if vehicle:getActualWeight() >= vehicle:getMaxLimit() then
        _ServerUtils.Notify(source, "~r~Le coffre est d??j?? remplis.")
        return
    end
    if (vehicle:getActualWeight() + (amount / Config_Vehicle_Inventory.Weight.Money)) <= vehicle:getMaxLimit() then
        if xPlayer.getAccount("black_money").money >= amount then
            xPlayer.removeAccountMoney("black_money", amount)
            vehicle:depositDirtyMoney(amount)
            _ServerUtils.Notify(source, ("Vous venez de poser ~g~%s$~s~ dans le coffre."):format(amount))
            refreshMenu(source, plate)
            _LogsManagers:registerLogs({title = _GenericMessages.logs.messages["deposit_cash"].title, message = (_GenericMessages.logs.messages["deposit_cash"].message):format(source, xPlayer.identifier, amount, vehicle:getActualWeight(), vehicle:getMaxLimit(), plate), color = _GenericMessages.logs.messages["deposit_cash"].color})
        else
            _ServerUtils.Notify(source, "~r~Vous n'avez pas assez d'argent.")
        end
    else
        _ServerUtils.Notify(source, "~r~Plus de place dans le coffre.")
    end
end)

RegisterNetEvent(("%s:depositItems"):format(Config_Vehicle_Inventory.eventName))
AddEventHandler(("%s:depositItems"):format(Config_Vehicle_Inventory.eventName), function(plate, item, number)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    ---@type _VehicleInventory
    local vehicle = _VehicleInventory.list[plate]
    local number = math.floor(tonumber(number))
    local label = ESX.GetItemLabel(item)
    local playerInventory = _ServerUtils.formatInventory(source)

    if PlayersInCarTrunk[source] ~= plate then
        _ServerUtils.Notify(source, _GenericMessages.errors)
        _LogsManagers:registerLogs({title = _GenericMessages.logs.messages["cheateur"].title, message = (_GenericMessages.logs.messages["cheateur"].message):format(source, xPlayer.identifier), color = _GenericMessages.logs.messages["cheateur"].color})
        return
    end
    if plate == nil or type(plate) ~= "string" then
        _ServerUtils.Notify(source, _GenericMessages.errors)
        return
    end
    if not vehicle then
        _VehicleInventory.registerVehicle(plate)
        _ServerUtils.Notify(source, _GenericMessages.errors)
        return
    end
    if not label or number < 0 or type(number) ~= "number" then
        _ServerUtils.Notify(source, _GenericMessages.errors)
        return
    end
    if vehicle:getActualWeight() >= vehicle:getMaxLimit() then
        _ServerUtils.Notify(source, "~r~Le coffre est d??j?? remplis.")
        return
    end
    if not playerInventory[item] then
        _ServerUtils.Notify(source, "~r~Vous ne poss??dez pas l'item.")
        return
    end
    if (playerInventory[item].count - number) < 0 then
        _ServerUtils.Notify(source, "~r~Vous ne poss??dez pas assez d'item.")
        return
    end
    if (vehicle:getActualWeight() + (number * Config_Vehicle_Inventory.Weight.Item)) <= vehicle:getMaxLimit() then
        xPlayer.removeInventoryItem(item, number)
        vehicle:depositItem(item, number)
        _ServerUtils.Notify(source, ("Vous avez d??pos?? ~o~%s~s~ %s dans le coffre"):format(number, label))
        refreshMenu(source, plate)
        _LogsManagers:registerLogs({title = _GenericMessages.logs.messages["deposit_items"].title, message = (_GenericMessages.logs.messages["deposit_items"].message):format(source, xPlayer.identifier, number, item, vehicle:getActualWeight(), vehicle:getMaxLimit(), plate), color = _GenericMessages.logs.messages["deposit_items"].color})
    else
        _ServerUtils.Notify(source, "~r~Plus de place dans le coffre.")
    end
end)

RegisterNetEvent(("%s:depositWeapon"):format(Config_Vehicle_Inventory.eventName))
AddEventHandler(("%s:depositWeapon"):format(Config_Vehicle_Inventory.eventName), function(plate, weaponName, ammo)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    ---@type _VehicleInventory
    local vehicle = _VehicleInventory.list[plate]
    local ammo = math.floor(tonumber(ammo)) or 0
    local label = ESX.GetWeaponLabel(weaponName)

    if PlayersInCarTrunk[source] ~= plate then
        _ServerUtils.Notify(source, _GenericMessages.errors)
        _LogsManagers:registerLogs({title = _GenericMessages.logs.messages["cheateur"].title, message = (_GenericMessages.logs.messages["cheateur"].message):format(source, xPlayer.identifier), color = _GenericMessages.logs.messages["cheateur"].color})
        return
    end
    if plate == nil or type(plate) ~= "string" then
        _ServerUtils.Notify(source, _GenericMessages.errors)
        return
    end
    if not vehicle then
        _VehicleInventory.registerVehicle(plate)
        _ServerUtils.Notify(source, _GenericMessages.errors)
        return
    end
    if not label or ammo < 0 or type(ammo) ~= "number" then
        _ServerUtils.Notify(source, _GenericMessages.errors)
        return
    end
    if vehicle:getActualWeight() >= vehicle:getMaxLimit() then
        _ServerUtils.Notify(source, "~r~Le coffre est d??j?? remplis.")
        return
    end
    if (vehicle:getActualWeight() + (1 * Config_Vehicle_Inventory.Weight.Weapon)) <= vehicle:getMaxLimit() then
        xPlayer.removeWeapon(weaponName)
        vehicle:depositWeapon(weaponName, ammo)
        _ServerUtils.Notify(source, ("Vous avez d??pos?? %s dans le coffre."):format(label))
        refreshMenu(source, plate)
        _LogsManagers:registerLogs({title = _GenericMessages.logs.messages["deposit_weapons"].title, message = (_GenericMessages.logs.messages["deposit_weapons"].message):format(source, xPlayer.identifier, weaponName, ammo, vehicle:getActualWeight(), vehicle:getMaxLimit(), plate), color = _GenericMessages.logs.messages["deposit_weapons"].color})
    else
        _ServerUtils.Notify(source, "~r~Plus de place dans le coffre.")
    end
end)

RegisterNetEvent(("%s:TakeCash"):format(Config_Vehicle_Inventory.eventName))
AddEventHandler(("%s:TakeCash"):format(Config_Vehicle_Inventory.eventName), function(plate, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    ---@type _VehicleInventory
    local vehicle = _VehicleInventory.list[plate]
    local amount = math.floor(tonumber(amount))

    if PlayersInCarTrunk[source] ~= plate then
        _ServerUtils.Notify(source, _GenericMessages.errors)
        _LogsManagers:registerLogs({title = _GenericMessages.logs.messages["cheateur"].title, message = (_GenericMessages.logs.messages["cheateur"].message):format(source, xPlayer.identifier), color = _GenericMessages.logs.messages["cheateur"].color})
        return
    end
    if plate == nil or type(plate) ~= "string" then
        _ServerUtils.Notify(source, _GenericMessages.errors)
        return
    end
    if not vehicle then
        _VehicleInventory.registerVehicle(plate)
        _ServerUtils.Notify(source, _GenericMessages.errors)
        return
    end
    if amount < 0 or type(amount) ~= "number" then
        _ServerUtils.Notify(source, "~r~La somme est inexact.")
        return
    end
    if (vehicle:getCash() - amount) >= 0 then
        vehicle:removeCash(amount)
        xPlayer.addMoney(amount)
        _ServerUtils.Notify(source, ("Vous avez retir?? ~g~%s~s~ du coffre"):format(amount))
        refreshMenu(source, plate)
        _LogsManagers:registerLogs({title = _GenericMessages.logs.messages["remove_cash"].title, message = (_GenericMessages.logs.messages["remove_cash"].message):format(source, xPlayer.identifier, amount, vehicle:getActualWeight(), vehicle:getMaxLimit(), plate), color = _GenericMessages.logs.messages["remove_cash"].color})
    else
        _ServerUtils.Notify(source, "~r~Vous ne pouvez pas retirer autant.")
    end
end)

RegisterNetEvent(("%s:TakeDirtyMoney"):format(Config_Vehicle_Inventory.eventName))
AddEventHandler(("%s:TakeDirtyMoney"):format(Config_Vehicle_Inventory.eventName), function(plate, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    ---@type _VehicleInventory
    local vehicle = _VehicleInventory.list[plate]
    local amount = math.floor(tonumber(amount))

    if PlayersInCarTrunk[source] ~= plate then
        _ServerUtils.Notify(source, _GenericMessages.errors)
        _LogsManagers:registerLogs({title = _GenericMessages.logs.messages["cheateur"].title, message = (_GenericMessages.logs.messages["cheateur"].message):format(source, xPlayer.identifier), color = _GenericMessages.logs.messages["cheateur"].color})
        return
    end
    if plate == nil or type(plate) ~= "string" then
        _ServerUtils.Notify(source, _GenericMessages.errors)
        return
    end
    if not vehicle then
        _VehicleInventory.registerVehicle(plate)
        _ServerUtils.Notify(source, _GenericMessages.errors)
        return
    end
    if amount < 0 or type(amount) ~= "number" then
        _ServerUtils.Notify(source, "~r~La somme est inexact.")
        return
    end
    if (vehicle:getDirtyMoney() - amount) >= 0 then
        vehicle:removeDirtyMoney(amount)
        xPlayer.addAccountMoney("black_money", amount)
        _ServerUtils.Notify(source, ("Vous avez retir?? ~m~%s~s~ du coffre"):format(amount))
        print("Je pose")
        refreshMenu(source, plate)
        _LogsManagers:registerLogs({title = _GenericMessages.logs.messages["remove_dirty"].title, message = (_GenericMessages.logs.messages["remove_dirty"].message):format(source, xPlayer.identifier, amount, vehicle:getActualWeight(), vehicle:getMaxLimit(), plate), color = _GenericMessages.logs.messages["remove_dirty"].color})
    else
        _ServerUtils.Notify(source, "~r~Vous ne pouvez pas retirer autant.")
    end
end)

RegisterNetEvent(("%s:TakeItems"):format(Config_Vehicle_Inventory.eventName))
AddEventHandler(("%s:TakeItems"):format(Config_Vehicle_Inventory.eventName), function(plate, itemName, number)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    ---@type _VehicleInventory
    local vehicle = _VehicleInventory.list[plate]
    local number = math.floor(tonumber(number))
    local items = vehicle:getItems()
    local label = ESX.GetItemLabel(itemName)

    if PlayersInCarTrunk[source] ~= plate then
        _ServerUtils.Notify(source, _GenericMessages.errors)
        _LogsManagers:registerLogs({title = _GenericMessages.logs.messages["cheateur"].title, message = (_GenericMessages.logs.messages["cheateur"].message):format(source, xPlayer.identifier), color = _GenericMessages.logs.messages["cheateur"].color})
        return
    end
    if plate == nil or type(plate) ~= "string" then
        _ServerUtils.Notify(source, _GenericMessages.errors)
        return
    end
    if not vehicle then
        _VehicleInventory.registerVehicle(plate)
        _ServerUtils.Notify(source, _GenericMessages.errors)
        return
    end
    if not label or number <= 0 or type(number) ~= "number" then
        _ServerUtils.Notify(source, "~r~La somme est inexact.")
        return
    end
    if (items[itemName].count - number) >= 0 then
        vehicle:removeItem(itemName, number)
        xPlayer.addInventoryItem(itemName, number)
        _ServerUtils.Notify(source, ("Vous avez retir?? ~o~%s~s~ %s dans le coffre"):format(number, label))
        refreshMenu(source, plate)
        _LogsManagers:registerLogs({title = _GenericMessages.logs.messages["remove_items"].title, message = (_GenericMessages.logs.messages["remove_items"].message):format(source, xPlayer.identifier, number, itemName, vehicle:getActualWeight(), vehicle:getMaxLimit(), plate), color = _GenericMessages.logs.messages["remove_items"].color})
    else
        _ServerUtils.Notify(source, "~r~Pas assez d'items dans le coffre.")
    end
end)

RegisterNetEvent(("%s:TakeWeapon"):format(Config_Vehicle_Inventory.eventName))
AddEventHandler(("%s:TakeWeapon"):format(Config_Vehicle_Inventory.eventName), function(plate, name, ammo)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    ---@type _VehicleInventory
    local vehicle = _VehicleInventory.list[plate]
    local weapon = vehicle:getWeapons()
    local ammo = math.floor(tonumber(ammo)) or 0
    local label = ESX.GetWeaponLabel(name)

    if PlayersInCarTrunk[source] ~= plate then
        _ServerUtils.Notify(source, _GenericMessages.errors)
        _LogsManagers:registerLogs({title = _GenericMessages.logs.messages["cheateur"].title, message = (_GenericMessages.logs.messages["cheateur"].message):format(source, xPlayer.identifier), color = _GenericMessages.logs.messages["cheateur"].color})
        return
    end
    if plate == nil or type(plate) ~= "string" then
        _ServerUtils.Notify(source, _GenericMessages.errors)
        return
    end
    if not vehicle then
        _VehicleInventory.registerVehicle(plate)
        _ServerUtils.Notify(source, _GenericMessages.errors)
        return
    end
    if not label or type(ammo) ~= "number" then
        _ServerUtils.Notify(source, _GenericMessages.errors)
        return
    end
    if not weapon[name] then
        _ServerUtils.Notify(source, "~r~L'arme n'est pas dans le coffre.")
        return
    end
    if (weapon[name].ammo - ammo) >= 0 then
        xPlayer.addWeapon(name, ammo)
        vehicle:removeWeapon(name, ammo)
        _ServerUtils.Notify(source, ("Vous avez retir?? ~b~%s~s~ avec ~o~%d~s~ munitions"):format(label, ammo))
        refreshMenu(source, plate)
        _LogsManagers:registerLogs({title = _GenericMessages.logs.messages["remove_weapons"].title, message = (_GenericMessages.logs.messages["remove_weapons"].message):format(source, xPlayer.identifier, name, ammo, vehicle:getActualWeight(), vehicle:getMaxLimit(), plate), color = _GenericMessages.logs.messages["remove_weapons"].color})
    else
        _ServerUtils.Notify(source, "~r~Il n'y a pas assez de munition dans le coffre.")
        return
    end
end)

