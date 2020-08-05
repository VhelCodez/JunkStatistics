--[[ Namespace ]]
local addonName, core = ...;

local function SlashCommandsHandler(str)

	if( #str == 0 ) then
		core.commands.help();
		return;
	end
	
	local path = core.commands;
	
	local args = { string.split(" ", str) };
	for index, arg in pairs(args) do
		arg = arg:lower(); -- Alternative: string.lower(arg);
		if( #arg > 0 ) then
			if(path[arg]) then
				if( type(path[arg]) == 'function' ) then
					-- Command found. Take rest of arguments as parameters for the command
					path[arg](select(index + 1, unpack(args)));
					return;
				elseif( type(path[arg]) == 'table' ) then
					-- Sub command possible. Extend path
					path = path[arg];
				else
					-- No command or sub-command found. Return help
					core.commands.help();
					return;
				end
			else
				-- No command or sub-command found. Return help
				core.commands.help();
				return;
			end
		end
	end
end

--[[
	Function to return a proper translated message according to the player's locale
	Returns the locale enUS if no other translation was found.
	@var string field - Can take multiple layers of field with period concatenation
 ]]
function core:Translate(field)
	local locale = core.Config.CurrentLocale;
	
	-- Translations path. Could be altered, durign following the splitted field parameter
	local translationsPath = core.Translations[locale];
	
	-- Parameter 'field' could be a string like 'text.example'. We need to split
	local fieldParts = { string.split('.', field) };
	for _, fieldPart in pairs(fieldParts) do
		if( translationsPath[fieldPart] ) then
			translationsPath = translationsPath[fieldPart];
		else
			return '|cffff5555{' .. locale .. ' is missing field \'' .. field .. '\'}|r';
		end
	end
	return translationsPath;
end

function core:Print(...)
	local hex = core.Config.textColors.addonName.hex;
	local prefix = string.format('|cff%s%s|r', hex:upper(), addonName .. ':');
	DEFAULT_CHAT_FRAME:AddMessage(string.join(' ', prefix, tostringall(...)));
end

function core:init(event, name)
	if( name ~= addonName ) then
		return;
	end

	-- allows using left and right buttons to move through chat 'edit' box
	for i = 1, NUM_CHAT_WINDOWS do
		_G["ChatFrame"..i.."EditBox"]:SetAltArrowKeyMode(false)
	end

	----------------------------------
	-- Register Slash Commands!
	----------------------------------
	SLASH_RELOADUI1 = "/rl" -- new slash command for reloading UI
	SlashCmdList.RELOADUI = ReloadUI

	SLASH_FRAMESTK1 = "/fs" -- new slash command for showing framestack tool
	SlashCmdList.FRAMESTK = function()
		LoadAddOn('Blizzard_DebugTools')
		FrameStackTooltip_Toggle()
	end

	SLASH_JunkStatistics1 = '/js';
	SlashCmdList.JunkStatistics = SlashCommandsHandler;
	core:Print(core:Translate('welcome') .. ' ' .. UnitName("player"));

	JunkStatistics:Init(core.Config.MainFrame);
end

local events = CreateFrame("Frame");
events:RegisterEvent("ADDON_LOADED");
events:SetScript("OnEvent", core.init);