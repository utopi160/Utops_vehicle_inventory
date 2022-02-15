---@author Gaspard.M.
---@version 1.0
--[[
    File VehicleInventory.lua
    Project Utops_vehicle_inventory
    Created at 28/12/2021 10:30
    Credit : https://github.com/utopi160
--]]

---@class _VehicleInventory
---@field public plate string
---@field public model string
---@field public class number
---@field public limit number
---@field public items table
---@field public money table
---@field public weapons table
---@field public save boolean
_VehicleInventory = {}
_VehicleInventory.__index = _VehicleInventory
_VehicleInventory.list = {}

setmetatable(_VehicleInventory, {
    __call = function(_, info)
        local self = setmetatable({}, _VehicleInventory)
        self.plate = info.plate
        self.model = info.model
        self.class = info.class
        self.limit = Config_Vehicle_Inventory.Limit.Custom[GetHashKey(self.model)] or Config_Vehicle_Inventory.Limit[self.class]
        self.items = info.items
        self.money = info.money
        self.weapons = info.weapons
        self.save = info.save

        _VehicleInventory.list[self.plate] = self
        return self
    end
})

---verifyInventory
---@public
---@return boolean
function _VehicleInventory:verifyInventory()
    local class = Config_Vehicle_Inventory.Limit[self.class]
    local limitCustom = Config_Vehicle_Inventory.Limit.Custom[GetHashKey(self.model)]

    if not limitCustom then
        if self.limit ~= class then
            self.limit = class
        end
    else
        if limitCustom ~= self.limit then
            self.limit = class
        end
    end
    if self:getActualWeight() > self:getMaxLimit() then
        repeat
            if self.items ~= {} then
                for itemName, _ in pairs(self.items) do
                    if (self.items[itemName].count - 1 ) > 1 then
                        self.items[itemName].count = self.items[itemName].count - 1
                    else
                        self.items[itemName] = nil
                    end
                end
            end
            if self.weapons ~= {} then
                for weaponName, _ in pairs(self.weapons) do
                    if (self.weapons[weaponName].count - 1 ) > 1 then
                        self.weapons[weaponName].count = self.weapons[weaponName].count - 1
                    else
                        self.weapons[weaponName] = nil
                    end
                end
            end
            if self.money.cash ~= 0 then
                if (self.money.cash - 1 ) > 0 then
                    self.money.cash = self.money.cash - 1
                end
            end
            if self.money.dirty_money ~= 0 then
                if (self.money.dirty_money - 1 ) > 0 then
                    self.money.dirty_money = self.money.dirty_money - 1
                end
            end
        until self:getActualWeight() <= self:getMaxLimit()
    end
    for itemName, _ in pairs(self.items) do
        local label = ESX.GetItemLabel(itemName)
        if not label then
            self.items[itemName] = nil
        end
    end
    for weaponName, _ in pairs(self.weapons) do
        local label = ESX.GetWeaponLabel(weaponName)
        if not label then
            self.weapons[weaponName] = nil
        end
    end
    return true
end

---registerVehicle
---@param plate string
---@public
---@return void
function _VehicleInventory.registerVehicle(plate, info)
    return  _VehicleInventory({plate = plate, items = {}, money = {cash = 0, dirty_money = 0}, weapons = {}, model = info.model, class = info.class, save = info.save})
end

---hasSaveInventory
---@public
---@return boolean
function _VehicleInventory:hasSaveInventory()
    if not self.save then
        return false
    end
    if self.items == {} and self.weapons == {} and self.money == {} then
        return false
    else
        return true
    end
end

---getItems
---@public
---@return table
function _VehicleInventory:getItems()
    return self.items
end

---getMoney
---@public
---@return table
function _VehicleInventory:getMoney()
    return self.money
end

---getCash
---@public
---@return number
function _VehicleInventory:getCash()
    return self.money.cash
end

---getDirtyMoney
---@public
---@return number
function _VehicleInventory:getDirtyMoney()
    return self.money.dirty_money
end

---getWeapons
---@public
---@return table
function _VehicleInventory:getWeapons()
    return self.weapons
end

---depositCash
---@param amounts
---@public
---@return void
function _VehicleInventory:depositCash(amounts)
    self.money.cash = self.money.cash + math.floor(tonumber(amounts))
end

---depositDirtyMoney
---@param amounts number
---@public
---@return void
function _VehicleInventory:depositDirtyMoney(amounts)
    self.money.dirty_money = self.money.dirty_money + math.floor(tonumber(amounts))
end

---getMaxLimit
---@public
---@return number
function _VehicleInventory:getMaxLimit()
    return self.limit
end

---getActualWeight
---@public
---@return number
function _VehicleInventory:getActualWeight()
    local weight = 0

    for _, item in pairs(self.items) do
        weight = weight + item.count * Config_Vehicle_Inventory.Weight.Item
    end
    for _, weapon in pairs(self.weapons) do
        weight = weight + weapon.count * Config_Vehicle_Inventory.Weight.Weapon
    end
    weight = weight + (self.money.cash / Config_Vehicle_Inventory.Weight.Money)
    weight = weight + (self.money.dirty_money / Config_Vehicle_Inventory.Weight.Money)
    print(weight)
    return weight
end

---depositItem
---@param name string
---@param number number
---@public
---@return void
function _VehicleInventory:depositItem(name, number)
    local label = ESX.GetItemLabel(name)
    if not self.items[name] then
        self.items[name] = {name = name, label = label, count = number}
    else
        self.items[name].count = self.items[name].count + number
    end
end

---depositWeapon
---@param weaponName string
---@param ammo number
---@public
---@return void
function _VehicleInventory:depositWeapon(weaponName, ammo)
    local label = ESX.GetWeaponLabel(weaponName)
    if not self.weapons[weaponName] then
        self.weapons[weaponName] = {name = weaponName, label = label, ammo = ammo, count = 1}
    else
        self.weapons[weaponName].count = self.weapons[weaponName].count + 1
        self.weapons[weaponName].ammo = self.weapons[weaponName].ammo + ammo
    end
end

---removeCash
---@param amounts number
---@public
---@return void
function _VehicleInventory:removeCash(amounts)
    self.money.cash = self.money.cash - math.floor(tonumber(amounts))
end

---removeDirtyMoney
---@param amounts number
---@public
---@return void
function _VehicleInventory:removeDirtyMoney(amounts)
    self.money.dirty_money = self.money.dirty_money - math.floor(tonumber(amounts))
end

---removeItem
---@param name string
---@param count number
---@public
---@return void
function _VehicleInventory:removeItem(name, count)
    if (self.items[name].count - count) > 0 then
        self.items[name].count = self.items[name].count - math.floor(tonumber(count))
    else
        self.items[name] = nil
    end
end

---removeWeapon
---@param name string
---@param ammo number
---@public
---@return void
function _VehicleInventory:removeWeapon(name, ammo)
    if (self.weapons[name].count - 1) > 0 then
        self.weapons[name].count = self.weapons[name].count - 1
        self.weapons[name].ammo = self.weapons[name].ammo - ammo
    else
        self.weapons[name] = nil
    end
end
