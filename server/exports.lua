---@author Gaspard.M.
---@version 1.0
--[[
    File exports.lua
    Project Utops_vehicle_inventory
    Created at 31/12/2021 14:50
    Credit : https://github.com/utopi160
--]]
-- Voici un example, à vous de jouer pour rendre cette "librairie" plus complète !

--[[
    plate = Vehicle plate (string)
    model = Vehicle name (string)
    class = Vehicle class (number)
    item = Add item (table)
    example = exports.Utops_vehicle_inventory:createInventoryAddItem("HD 456", "sultan", 10, {name = "bread", count = 10})
]]--
function createVehicleInventoryAddItem(plate, model, class, item)
    if plate ~= nil and type(plate) == "string" and model ~= nil and type(model) == "string" and class ~= nil and type(class) == "number" and Config_Vehicle_Inventory.Limit[class] and item ~= nil and item ~= {} and type(item) == "table" then
        if not _VehicleInventory.list[plate] then
            local vehicle = _VehicleInventory.registerVehicle(plate, {model = model, class = class, false})
            if (vehicle:getActualWeight() + item.count * Config_Vehicle_Inventory.Weight.Item) <= vehicle:getMaxLimit() then
                vehicle:depositItem(item.name, item.count)
            end
        else
            local vehicle = _VehicleInventory.list[plate]
            if (vehicle:getActualWeight() + item.count * Config_Vehicle_Inventory.Weight.Item) <= vehicle:getMaxLimit() then
                vehicle:depositItem(item.name, item.count)
            end
        end
    end
end

--[[
    plate = Vehicle plate (string)
    item = Add item (table)
    example = exports.Utops_vehicle_inventory:createInventoryAddItem("HD 456", {name = "bread", count = 10})
]]--
function removeVehicleInventoryItem(plate, item)
    if plate ~= nil and type(plate) == "string" and item ~= nil and item ~= {} and type(item) == "table" then
        local vehicle = _VehicleInventory.list[plate]
        if vehicle then
            vehicle:removeItem(item.name, item.count)
        end
    end
end