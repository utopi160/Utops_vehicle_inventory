---@author Gaspard.M.
---@version 1.0
--[[
    File _main.lua
    Project Utops_vehicle_inventory
    Created at 28/12/2021 10:26
    Credit : Credit : https://github.com/utopi160
--]]
---@type table
ESX = nil
TriggerEvent(Config_Vehicle_Inventory.esxGetter, function(obj)
    ESX = obj
end)

AddEventHandler("playerDropped", function()
    local source = source
    if PlayersInCarTrunk[source] then
        PlayersInCarTrunk[source] = nil
    end
end)
