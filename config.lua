---@author Gaspard.M.
---@version 1.0
--[[
    File config.lua
    Project Utops_vehicle_inventory
    Created at 28/12/2021 10:28
    Credit : https://github.com/utopi160
--]]

---@class Config_Vehicle_Inventory
Config_Vehicle_Inventory = {
    esxGetter = "esx:getSharedObject",
    inventoryKey = "F1",
    eventName = "Utops_vehicle_inventory",
    distanceAction = 3.0,
    use3dme = true,
    Menus = {
        Title = "Coffre",
        Subtitle = "Votre Coffre",
    },
    Logs = {
        discordWebhook = "https://discord.com/api/webhooks/926869506536636426/fQAeVgfZJNFcpWfHRTRt3pS0WxBHmY0Utnu1svWqX0UqOtuImXtS-ZdJFkkaoOVo-qsv",
    },
    Weight = {
        Item = 1,
        Weapon = 2,
        Money = 1000, -- 50$ / 1000 = weight money
    },
    PlateJob = {
        ["LSPD"] = true,
    },
    Limit = {
        Custom = {
            --[GetHashKey("BLISTA")] = 10,
        };
        [0] = 50,       --Compact             -3
        [1] = 40,       --Sedan               -3
        [2] = 60,       --SUV                 -4
        [3] = 40,       --Coupes              -2
        [4] = 40,       --Muscle              -2
        [5] = 40,       --Sports Classics     -2
        [6] = 40,       --Sports              -2
        [7] = 40,       --Super               -2
        [8] = 0,        --Motorcycles
        [9] = 45,       --Off-road            -3
        [10] = 100,     --Industrial         -5
        [11] = 70000,   --Utility            -3
        [12] = 70000,   --Vans               -2
        [13] = 0,       --Cycles
        [14] = 60,      --Boats              -5
        [15] = 40,      --Helicopters        -2
        [16] = 0,       --Planes
        [17] = 100,     --Service            -5
        [18] = 100,     --Emergency          -5
        [19] = 0,       --Military
        [20] = 100,     --Commercial         -5
        [21] = 0,       --Trains
    },
}