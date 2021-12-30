---@author Gaspard.M.
---@version 1.0
--[[
    File utils.lua
    Project Utops_vehicle_inventory
    Created at 28/12/2021 10:26
    https://github.com/utopi160
--]]
---@class _ClientUtils
_ClientUtils = {}

---GetVehicleInRage
---@public
---@return boolean
function _ClientUtils.GetVehicleInRage()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local forward = GetOffsetFromEntityInWorldCoords(ped, 0.0, 3.0, 0.0)
    local shapeTestHandle = StartExpensiveSynchronousShapeTestLosProbe(coords, forward, -1, ped, 4)
    local retval ,hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTestHandle)
    return entityHit > 0 and GetEntityType(entityHit) == 2, entityHit
end

---Notify
---@param msg string
---@public
---@return void
function _ClientUtils.Notify(msg)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(("~g~<C>Coffre</C>~s~:\n%s"):format(msg))
    DrawNotification(0,1)
end

---GetNumberInTheTable
---@param Table table
---@public
---@return void
function _ClientUtils.GetNumberInTheTable(Table)
    local count = 0
    for k, v in pairs(Table) do
        count = count + 1
    end
    return count
end

---Keyboard
---@param entryTitle string
---@param textEntry string
---@param inputText string
---@param maxLength number
---@public
---@return void
function _ClientUtils.Keyboard(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, "", inputText, "", "", "", maxLength)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end