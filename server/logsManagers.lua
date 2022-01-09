---@author Gaspard.M.
---@version 1.0
--[[
    File logsManagers.lua
    Project Utops_vehicle_inventory
    Created at 01/01/2022 17:00
    https://github.com/utopi160
--]]
---@class _LogsManagers
_LogsManagers = {}
_LogsManagers.discordWebhook = ""

---registerLogs
---@param info table
---@public
---@return table
function _LogsManagers:registerLogs(info)
    local content  = {
        {
            ["color"] = info.color,
            ["title"] = info.title,
            ["description"] = info.message,
        }
    }
    PerformHttpRequest(_LogsManagers.discordWebhook, function(err, text, headers) end, 'POST', json.encode({username = "Utops_vehicle_inventory", embeds = content}), { ['Content-Type'] = 'application/json' })
end
