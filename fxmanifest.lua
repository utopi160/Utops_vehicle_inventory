---@author Gaspard.M.
---@version 1.0
--[[
    File fxmanifest.lua
    Project Utops_Apartments
    Created at 07/12/2021 18:25
    https://github.com/utopi160
--]]

fx_version 'adamant'

game 'gta5'

shared_scripts {
    "config.lua",
}

client_scripts {
	--Service RageUI
    "services/RageUI/RMenu.lua",
    "services/RageUI/menu/RageUI.lua",
    "services/RageUI/menu/Menu.lua",
    "services/RageUI/menu/MenuController.lua",
    "services/RageUI/components/Audio.lua",
    "services/RageUI/components/Rectangle.lua",
    "services/RageUI/components/Screen.lua",
    "services/RageUI/components/Sprite.lua",
    "services/RageUI/components/Text.lua",
    "services/RageUI/components/Visual.lua",
    "services/RageUI/menu/elements/ItemsBadge.lua",
    "services/RageUI/menu/elements/ItemsColour.lua",
    "services/RageUI/menu/elements/PanelColour.lua",
    "services/RageUI/menu/items/UIButton.lua",
    "services/RageUI/menu/items/UICheckBox.lua",
    "services/RageUI/menu/items/UIList.lua",
    "services/RageUI/menu/items/UIProgress.lua",
    "services/RageUI/menu/items/UISlider.lua",
    "services/RageUI/menu/items/UISeparator.lua",
    "services/RageUI/menu/items/UISliderHeritage.lua",
    "services/RageUI/menu/items/UISliderProgress.lua",
    "services/RageUI/menu/panels/UIColourPanel.lua",
    "services/RageUI/menu/panels/UIGridPanel.lua",
    "services/RageUI/menu/panels/UIGridPanelHorizontal.lua",
    "services/RageUI/menu/panels/UIPercentagePanel.lua",
    "services/RageUI/menu/panels/UIStatisticsPanel.lua",
    "services/RageUI/menu/windows/UIHeritage.lua",
    --Clients
    "client/*.lua",
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    "server/*.lua",
    "server/objects/main.lua",
}
