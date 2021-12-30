---@author Gaspard.M.
---@version 1.0
--[[
    File _main.lua
    Project Utops_vehicle_inventory
    Created at 28/12/2021 10:25
    https://github.com/utopi160
--]]
RegisterKeyMapping("trunk", "Open Vehicle Inventory", 'keyboard', Config_Vehicle_Inventory.inventoryKey)
RegisterCommand("trunk", function()
    local vehicle, entity = _ClientUtils.GetVehicleInRage()
    if vehicle and not _ClientUtils.Open then
        TriggerServerEvent(("%s:OpenMenu"):format(Config_Vehicle_Inventory.EventName), GetVehicleNumberPlateText(entity), {class = GetVehicleClass(entity), model = GetDisplayNameFromVehicleModel(GetEntityModel(entity))})
    else
        _ClientUtils.Notify("~r~Aucun véhicule proche de vous.")
    end
end, false)