---@author Gaspard.M.
---@version 1.0
--[[
    File utils.lua
    Project Utops_vehicle_inventory
    Created at 28/12/2021 10:26
    https://github.com/utopi160
--]]
---@class _ServerUtils
_ServerUtils = {}

---formatInventory
---@param id number
---@return table
function _ServerUtils.formatInventory(id)
    local xPlayer = ESX.GetPlayerFromId(id)
    local inventory = {}
    for _, itemInfo in pairs(xPlayer.getInventory(true)) do
        inventory[itemInfo.name] = itemInfo
    end
    return inventory
end

---Notify
---@param id number
---@param msg string
---@public
---@return void
function _ServerUtils.Notify(id, msg)
    TriggerClientEvent("esx:showNotification", id, ("~g~<C>Coffre</C>~s~:\n%s"):format(msg))
end