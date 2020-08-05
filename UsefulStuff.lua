-- Namespace
local addonName, core = ...;

function core:SetFrameMovable(frame)
	--[[ Commands Description: https://wowwiki.fandom.com/wiki/Making_Draggable_Frames ]]
	frame:SetMovable(true);
	frame:EnableMouse(true);
	frame:SetScript("OnDragStart", frame.StartMoving);
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing);
	frame:RegisterForDrag("LeftButton");
end