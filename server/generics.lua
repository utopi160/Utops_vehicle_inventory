---@author Gaspard.M.
---@version 1.0
--[[
    File generics.lua
    Project Utops_vehicle_inventory
    Created at 01/01/2022 17:14
    https://github.com/utopi160
--]]

---@type table
local colors = {
    ["blue"] = 3447003,
    ["red"] = 15158332,
    ["yellow"] = 15844367,
    ["orange"] = 15105570,
    ["grey"] = 9807270,
    ["purple"] = 10181046,
    ["green"] = 3066993,
    ["lightBlue"] = 1752220
}

---@generic _GenericMessages
_GenericMessages = {
    errors = "~r~Une erreur c’est produite lors de l'opération.\nMerci de réessayer.",
    logs = {
        messages = {
            ["open"] = {
                title = "__**Ouverture du coffre**__",
                message = "Le joueur id : %s (%s) vient d'ouvrir le coffre de la voiture avec la plaque **%s**.",
                color = colors["green"]
            },
            ["close"] = {
                title = "__**Fermeture du coffre**__",
                message = "Le joueur id : %s (%s) vient de fermer le coffre de la voiture avec la plaque **%s**.",
                color = colors["red"]
            },

            ["deposit_cash"] = {
                title = "__**Argent dépose(s)**__",
                message = "Le joueur id : %s (%s) vient de déposer **%s$** en liquide dans le coffre.\nLe poids est désormais de **%s** sur **%s**.\nAvec une plaque de **%s**.",
                color = colors["orange"]
            },
            ["deposit_dirty"] = {
                title = "__**Argent dépose(s)**__",
                message = "Le joueur id : %s (%s) vient de déposer **%s$** en source inconnue dans le coffre.\nLe poids est désormais de **%s** sur **%s**.\nAvec une plaque de **%s**.",
                color = colors["orange"]
            },
            ["deposit_items"] = {
                title = "__**Item déposé(s)**__",
                message = "Le joueur id : %s (%s) vient de déposer **%s %s** dans le coffre.\nLe poids est désormais de **%s** sur **%s**.\nAvec une plaque de **%s**.",
                color = colors["orange"]
            },
            ["deposit_weapons"] = {
                title = "__**Arme déposé(s)**__",
                message = "Le joueur id : %s (%s) vient de déposer **%s** avec **%s** munitions dans dans le coffre.\nLe poids est désormais de **%s** sur **%s**.\nAvec une plaque de **%s**.",
                color = colors["orange"]
            },

            ["remove_cash"] = {
                title = "__**Argent retiré(s)**__",
                message = "Le joueur id : %s (%s) vient de retirer **%s$** en liquide.\nLe poids est désormais de **%s** sur **%s**.\nAvec une plaque de **%s**.",
                color = colors["red"]
            },
            ["remove_dirty"] = {
                title = "__**Argent retiré(s)**__",
                message = "Le joueur id : %s (%s) vient de retirer **%s$** en source inconnue.\nLe poids est désormais de **%s** sur **%s**.\nAvec une plaque de **%s**.",
                color = colors["red"]
            },
            ["remove_items"] = {
                title = "__**Item retiré(s)**__",
                message = "Le joueur id : %s (%s) vient de retirer **%s %s** du coffre.\nLe poids est désormais de **%s** sur **%s**.\nAvec une plaque de **%s**.",
                color = colors["red"]
            },
            ["remove_weapons"] = {
                title = "__**Arme retiré(s)**__",
                message = "Le joueur id : %s (%s) vient de retirer **%s** avec **%s** munitions dans dans le coffre.\nLe poids est désormais de **%s** sur **%s**.\nAvec une plaque de **%s**.",
                color = colors["red"]
            },

            ["cheateur"] = {
                title = "__**Tricheur**__",
                message = "Le joueur id %s (%s) est possiblement un tricheur !",
                color = colors["red"]
            },
        }
    }
}


