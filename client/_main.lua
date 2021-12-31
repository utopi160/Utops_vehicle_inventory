---@author Gaspard.M.
---@version 1.0
--[[
    File _main.lua
    Project Utops_vehicle_inventory
    Created at 28/12/2021 10:25
    https://github.com/utopi160
--]]
---@type number
ActualVehicle = nil

RegisterKeyMapping("trunk", "Open Vehicle Inventory", 'keyboard', Config_Vehicle_Inventory.inventoryKey)
RegisterCommand("trunk", function()
    local vehicle, entity = _ClientUtils.GetVehicleInRage()
    local class, heading, plate = GetVehicleClass(entity), GetEntityHeading(entity),  GetVehicleNumberPlateText(entity)
    if vehicle and not _ClientUtils.Open then
        if GetVehicleDoorLockStatus(entity) ~= 2 then
            ActualVehicle = entity
            SetEntityHeading(PlayerPedId(), heading)
            if class == 12 or class == 17 or class == 19 or class == 20 then
                SetVehicleDoorOpen(entity, 2, 0, 0)
                SetVehicleDoorOpen(entity, 3, 0, 0)
                SetVehicleDoorOpen(entity, 5, 0, 0)
            else
                SetVehicleDoorOpen(entity, 5, 0, 0)
            end
            if Config_Vehicle_Inventory.PlateJob[plate] then
                local new = ("%s-%d"):format(plate, math.random(1, 900))
                SetVehicleNumberPlateText(entity, new)
            end
            TriggerServerEvent(("%s:OpenMenu"):format(Config_Vehicle_Inventory.EventName),GetVehicleNumberPlateText(entity), {class = class, model = GetDisplayNameFromVehicleModel(GetEntityModel(entity))})
        else
            _ClientUtils.Notify("~r~Le véhicule est fermé !")
        end
    else
        _ClientUtils.Notify("~r~Aucun véhicule proche de vous.")
    end
end, false)