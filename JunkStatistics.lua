-- Namespace
local addonName, core = ...;

JunkStatistics = {
	
	--#region Variables
	
	--- Copper value of all junk items
	---@type number
	junkCopper = 0,
	
	-- Junk item count
	--junkCount = 0,
	 
	--#endregion
	
	--#region Functions
	
	--#region Getter
	
	--- Getter for the junk copper value
	---@return number
	GetJunkCopper = function(self)
		return self.junkCopper;
	end,
	
	--#endregion
	
	--- Main function to build the frame and it's content
	Init = function(self, frame)
		-- Get translated string for the headline
		local translatedHeadline = core:Translate('calculatedSumText');
		-- Get frame and set the translated headline
		frame.content.top.wrapper.headline:SetText(translatedHeadline);

		-- Initially calculate the junk value
		self:CalculateJunkValues();

		-- Get FontString object to set money text on
		local moneyFontString = frame.content.bottom.wrapper.value;

		-- Set money text onto FontString object
		self:UpdateMoneyTextOnFontString(moneyFontString);

		-- Register BAG_UPDATE event on FontString object
		frame:RegisterEvent('BAG_UPDATE');
		frame:SetScript('OnEvent',function() JunkStatistics:CalculateJunkValues(); JunkStatistics:UpdateMoneyTextOnFontString(moneyFontString); end);
	end,
	
	CalculateJunkValues = function(self)
		-- Reset junkCopper variable
		self.junkCopper = 0;
		
		-- Iterate over all available bags
		for currentBagId = 0, NUM_BAG_SLOTS do
			-- Iterate over all slots int he currently selected bag
			for currentBagSlot = 1, GetContainerNumSlots(currentBagId) do
				local itemId = GetContainerItemID(currentBagId, currentBagSlot);
				-- Check if there's an itemId given by the function
				if( itemId ) then
					-- General information about the current slot in the bag
					local containerInfo = {};
					-- Possible returns of the function: texture, itemCount, locked, quality, readable, lootable, itemLink
					_, containerInfo.itemCount, _, containerInfo.quality, _, _, _ = GetContainerItemInfo(currentBagId, currentBagSlot);
					-- General information about the item
					local itemInfo = {};
					-- Possible returns of the function: itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice
					itemInfo.itemName, _, _, _, _, _, _, _, _, _, itemInfo.itemSellPrice = GetItemInfo(itemId);
					
					if( containerInfo.quality == 0 ) then
						-- Get sell price for current item and multiply it by the amount of the item in the current container
						local calculatedCopperSum = itemInfo.itemSellPrice * containerInfo.itemCount;
						self.junkCopper = self.junkCopper + calculatedCopperSum;
					end
				end
			end
		end
	end,

	--- Function to update a text on a proper FontString object
	---
	--- Example on how to call it manually with chat command:
	--- /run print(JunkStatistics:UpdateMoneyTextOnFontString(JunkStatisticsFrameTestContentBottomWrapperValue));
	---
	--- @param JunkStatistics self
	--- @param FontString fontString
	--- @return void
	UpdateMoneyTextOnFontString = function(self, fontString)
		local junkCopper = self:GetJunkCopper();
		local coinTextureString = GetCoinTextureString(junkCopper);
		fontString:SetText(coinTextureString);
	end,
	
	--private render = function(self)
		--TODO: Continue with proper UI styling after watching the tutorial by Mayron
		--local mainFrame = CreateFrame("Frame", "JunkStatistics_Frame", UIParent)
		--mainFrame
	--end,
	
	calculateFreeSlots = function(self)
		local freeSlots = 0
		for bag = 0, NUM_BAG_SLOTS do
			for slot = 1, GetContainerNumSlots(bag) do
				local texture = GetContainerItemInfo(bag, slot)
				if not texture then
					freeSlots = freeSlots + 1
				end
			end
		end
		print("You have", freeSlots, "free slots in your containers.")
	end
	
	--endregion
}