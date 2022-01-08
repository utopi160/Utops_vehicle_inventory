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
    inventoryKey = "L",
    eventName = "Utops_vehicle_inventory",
    nameTable = "owned_vehicles",
    distanceAction = 3.0,
    use3dme = false, -- or true
    Menus = {
        Title = "Coffre",
        Subtitle = "Votre Coffre",
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
        },
        [0] = 50,       --Compact
        [1] = 40,       --Sedan
        [2] = 60,       --SUV
        [3] = 40,       --Coupes
        [4] = 40,       --Muscle
        [5] = 40,       --Sports Classics
        [6] = 40,       --Sports
        [7] = 40,       --Super
        [8] = 0,        --Motorcycles
        [9] = 45,       --Off-road
        [10] = 100,     --Industrial
        [11] = 70000,   --Utility
        [12] = 70000,   --Vans
        [13] = 0,       --Cycles
        [14] = 60,      --Boats
        [15] = 40,      --Helicopters
        [16] = 0,       --Planes
        [17] = 100,     --Service
        [18] = 100,     --Emergency
        [19] = 0,       --Military
        [20] = 100,     --Commercial
        [21] = 0,       --Trains
    },
}