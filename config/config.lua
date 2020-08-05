--[[ Namespace ]]
local addonName, core = ...;

core.Config = {};

local Config = core.Config;

-- Current locale of the player's client. Eg.: deDE or enUS
Config.CurrentLocale = GetLocale();

--[[ Text colors ]]
Config.textColors = {
	addonName = {
		rgb = {
			r = 0.0, -- 0/255
			g = 0.4, -- 102/255
			b = 1.0, -- 255/255
		},
		hex = '0066ff'
	},
	commands = {
		rgb = {
			r = 0,
			g = 0.5,
			b = 0,
		},
		hex = '007f00'
	}
};

core.Config.MainFrame = JunkStatisticsFrame;

function Config:Toggle()
	-- Actual toggling
	if( Config.MainFrame:IsShown() ) then
		Config.MainFrame:Hide();
	else
		Config.MainFrame:Show();
	end
end

core.commands = {
	['toggle'] = core.Config.Toggle,
	
	['help'] = function()
		local commandsHex = core.Config.textColors.commands.hex:upper();
		print(" ");
		core:Print(core:Translate('help.headline'));
		core:Print("|cff" .. commandsHex .. "/js toggle|r - " .. core:Translate('help.toggle'));
		core:Print("|cff" .. commandsHex .. "/js help|r - " .. core:Translate('help.help'));
		print(" ");
	end
};