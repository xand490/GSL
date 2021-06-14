GrimsoulLegion = LibStub("AceAddon-3.0"):NewAddon("GrimsoulLegion", "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0")
local LibAceSerializer = LibStub:GetLibrary("AceSerializer-3.0")

local frame = CreateFrame( "Frame" )
local AceGUI = LibStub("AceGUI-3.0")
local GSLIcon = LibStub("LibDBIcon-1.0")

local classColorsTable = {
	Warrior = "\124cFFC79C6E",
	Paladin = "\124cFFF58CBA",
	Shaman = "\124cFF0070DE",
	Hunter = "\124cFFABD473",
	Druid = "\124cFFFF7D0A",
	Rogue = "\124cFFFFF569",
	Priest = "\124cFFFFFFFF",
	Warlock = "\124cFF9482C9",
	Mage = "\124cFF69CCF0"
	}
local rankColorsTable = {
	S = "\124cFF02F3FF",
	A = "\124cFF20FF00",
	B = "\124cFFF7FF00",
	C = "\124cFFFF8800", 
	D = "\124cFFFF0078",
	F = "\124cFFFF0000",
	N = "\124cFFFF0000"
	}

local tierColorsTable = {
	S = "\124cFFe6cc80",
	A = "\124cFFff8000",
	B = "\124cFFa335ee",
	C = "\124cFF0070dd", 
	D = "\124cFF1eff00",
}

local origChatFrame_OnHyperlinkShow = ChatFrame_OnHyperlinkShow

local statusEnableText = "GSL LC Tooltips is currently: Disabled"

local currentPlayer = UnitName("player")



local GSLLDB = LibStub("LibDataBroker-1.1"):NewDataObject("GSLTooltips", {
type = "data source",
text = "GSL Tooltips",
icon = "Interface\\Icons\\Ability_creature_cursed_05",
OnClick = function(self,button,down)
	if button == "LeftButton" then
		if ItemListsDB.enabled then 
			statusEnableText = "GSL LC Tooltips is currently: Disabled"
			ItemListsDB.enabled = false
		else
			statusEnableText = "GSL LC Tooltips is currently: Enabled"
			ItemListsDB.enabled = true
		end
	GrimsoulLegion:Print(statusEnableText)
	elseif button == "RightButton" then
		popupConfig()
	end
end,
OnTooltipShow = function(tooltip) -- Icon tooltip
	tooltip:AddLine("GSL LC Tooltips")
	tooltip:AddLine("Version    : 1.0b") -- EDIT TOC and PKMETA
	tooltip:AddLine("Left click : Enable/Disable display")
	tooltip:AddLine("Right click: Open config")
	tooltip:AddLine("Hold Alt   : Change tooltip display")
	tooltip:AddLine("Chat CMD   : /gsl")
	tooltip:AddLine("Database ID: " .. ItemListsDB.DBImportID)
end,
})

function showSync()
	if syncShown then
		return
	end

	syncShown = true

	syncFrame = AceGUI:Create("Frame")
	syncFrame:SetTitle("Sync GSL Data")
	syncFrame.sizer_se:Hide()
	syncFrame.sizer_s:Hide()
	syncFrame.sizer_e:Hide()
	syncFrame:SetWidth(300)
	syncFrame:SetHeight(200)
	syncFrame:SetLayout("Flow")
	local targetField = AceGUI:Create("EditBox")
	targetField:SetLabel("Who do you want to send data to?")
	targetField:DisableButton(true)
	syncFrame:AddChild(targetField)
	
	local SyncButton = AceGUI:Create("Button")
	SyncButton:SetText("Sync")
	syncFrame:AddChild(SyncButton)
	SyncButton:SetCallback("OnClick", function (obj, button, down)
		-- Start sync operation
		GrimsoulLegion:SendComm(targetField:GetText(), "RTS", ItemListsDB.DBImportID)
		
	end)







	syncFrame:SetCallback("OnClose", 
	function(widget)
	  AceGUI:Release(widget)
	  syncShown = false
	end
   )
end


function popupConfig()

	if frameShown then
		return
	end
	
	frameShown = true



	popup = AceGUI:Create("Frame")
	popup:SetTitle("Grimsoul Legion LC Tooltips")
	popup:SetStatusText(statusEnableText)

	popup.sizer_se:Hide()
	popup.sizer_s:Hide()
	popup.sizer_e:Hide()
	popup:SetWidth(600)
	popup:SetHeight(340)
	local checkboxGroup = AceGUI:Create("SimpleGroup")
	checkboxGroup:SetRelativeWidth(0.4)
	local textboxGroup = AceGUI:Create("SimpleGroup")
	textboxGroup:SetRelativeWidth(0.6)

	local checkLabel = AceGUI:Create("Label")
    checkLabel:SetText("Tooltip display settings")
	checkboxGroup:AddChild(checkLabel)

	local check1 = AceGUI:Create("CheckBox")
	check1:SetLabel("Priority Note")
	check1:SetValue(ItemListsDB.displayPrioNote)
	checkboxGroup:AddChild(check1)

	local check6 = AceGUI:Create("CheckBox")
	check6:SetLabel("Guild Note")
	check6:SetValue(ItemListsDB.displayGuildNote)
	checkboxGroup:AddChild(check6)

	local check2 = AceGUI:Create("CheckBox")
	check2:SetLabel("Raid Teams")
	check2:SetValue(ItemListsDB.displayRank)
	checkboxGroup:AddChild(check2)

	--[[local check3 = AceGUI:Create("CheckBox")
	check3:SetLabel("Wishlists")
	check3:SetValue(ItemListsDB.displayWishes)
	checkboxGroup:AddChild(check3)]]--

	--[[local check4 = AceGUI:Create("CheckBox")
	check4:SetLabel("Priolists")
	check4:SetValue(ItemListsDB.displayPrios)
	checkboxGroup:AddChild(check4)]]--

	--[[local check5 = AceGUI:Create("CheckBox")
	check5:SetLabel("Display Alt *")
	check5:SetValue(ItemListsDB.displayAlts)
	checkboxGroup:AddChild(check5)]]--

	--[[local check7 = AceGUI:Create("CheckBox")
	check7:SetLabel("Hide received wishes")
	check7:SetValue(ItemListsDB.hideReceivedWishes)
	checkboxGroup:AddChild(check7)

	local check8 = AceGUI:Create("CheckBox")
	check8:SetLabel("Hide received prios")
	check8:SetValue(ItemListsDB.hideReceivedPrios)
	checkboxGroup:AddChild(check8)

	local check9 = AceGUI:Create("CheckBox")
	check9:SetLabel("Always show received")
	check9:SetValue(ItemListsDB.forceReceivedList)
	checkboxGroup:AddChild(check9)]]--

	local check10 = AceGUI:Create("CheckBox")
	check10:SetLabel("Only Show Tooltips in Raids")
	check10:SetValue(ItemListsDB.onlyInRaid)
	checkboxGroup:AddChild(check10)

	local check11 = AceGUI:Create("CheckBox")
	check11:SetLabel("Only Show Raid Members")
	check11:SetValue(ItemListsDB.onlyRaidMembers)
	checkboxGroup:AddChild(check11)

	-- END OF CHECKBOXES

	--[[local slider1 = AceGUI:Create("Slider")
	slider1:SetValue(ItemListsDB.maxNames)
	slider1:SetSliderValues(1,10,1)
	slider1:SetLabel("How many names to display")
	slider1:SetRelativeWidth(1)
	textboxGroup:AddChild(slider1)]]--

	local inputfield = AceGUI:Create("MultiLineEditBox")
	inputfield:SetLabel("Paste CSV here")
	inputfield:SetNumLines(12)
	inputfield:SetWidth(320)

	local textBuffer, i, lastPaste = {}, 0, 0
	local pasted = ""
	inputfield.editBox:SetScript("OnShow", function(obj)
		obj:SetText("")
		pasted = ""
	end)
	local function clearBuffer(obj1)
		obj1:SetScript('OnUpdate', nil)
		pasted = strtrim(table.concat(textBuffer))
		inputfield.editBox:ClearFocus()
	end
	inputfield.editBox:SetScript('OnChar', function(obj2, c)
		if lastPaste ~= GetTime() then
			textBuffer, i, lastPaste = {}, 0, GetTime()
			obj2:SetScript('OnUpdate', clearBuffer)
		end
		i = i + 1
		textBuffer[i] = c
	end)
	inputfield.editBox:SetMaxBytes(2500)
	inputfield.editBox:SetScript("OnMouseUp", nil);

	inputfield:DisableButton(true)
	textboxGroup:AddChild(inputfield)

	local parseData = AceGUI:Create("Button")
	parseData:SetText("Parse")
	textboxGroup:AddChild(parseData)

	popup:SetLayout("Flow")

	popup:AddChild(checkboxGroup)
	popup:AddChild(textboxGroup)


	check1:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.displayPrioNote = check1:GetValue()
	end)
	check2:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.displayRank = check2:GetValue()
	end)
	--[[check3:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.displayWishes = check3:GetValue()
	end)]]--
	--[[check4:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.displayPrios = check4:GetValue()
	end)]]--
	--[[check5:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.displayAlts = check5:GetValue()
	end)]]--
	check6:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.displayGuildNote = check6:GetValue()
	end)
	--[[check7:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.hideReceivedWishes = check7:GetValue()
	end)
	check8:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.hideReceivedPrios = check8:GetValue()
	end)
	check9:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.forceReceivedList = check9:GetValue()
	end)]]--

	check10:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.onlyInRaid = check10:GetValue()
	end)

	check11:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.onlyRaidMembers = check11:GetValue()
	end)

	--[[slider1:SetCallback("OnMouseUp", function(slid)
		ItemListsDB.maxNames = slid:GetValue()
	end)]]--]]

	parseData:SetCallback("OnClick", function (obj, button, down)
		--message(pasted)
		if pasted == "" then return end
		obj:SetText(ParseText(pasted))
		inputfield:SetText("")
	end)




	popup:SetCallback("OnClose", 
	function(widget)
	  AceGUI:Release(widget)
	  frameShown = false
	end
   )
end


function GrimsoulLegion:OnInitialize() --Fires when the addon is being set up.
	self.db = LibStub("AceDB-3.0"):New("GSLDB", { profile = { minimap = { hide = false, }, }, })
	GSLIcon:Register("GSLTooltips", GSLLDB,  self.db.profile.minimap) 
	self:RegisterChatCommand("gsl", "ChatCommands") 
	self:RegisterComm("GSLSync", GrimsoulLegion:OnCommReceived())

end



function GrimsoulLegion:OnEnable() --Fires when the addon loads, makes sure there is a db to look at.

	if ItemListsDB == nil then ItemListsDB = {} end
	if ItemListsDB.itemNotes == nil then ItemListsDB.itemNotes = {} end
	if ItemListsDB.enabled == nil then ItemListsDB.enabled = true end
	if ItemListsDB.displayPrioNote == nil then ItemListsDB.displayPrioNote = true end
	if ItemListsDB.displayGuildNote == nil then ItemListsDB.displayGuildNote = true end
	if ItemListsDB.displayRank == nil then ItemListsDB.displayRank = true end
	--if ItemListsDB.displayWishes == nil then ItemListsDB.displayWishes = true end
	--if ItemListsDB.displayPrios == nil then ItemListsDB.displayPrios = true end
	--if ItemListsDB.displayAlts == nil then ItemListsDB.displayAlts = true end
	--if ItemListsDB.maxNames == nil then ItemListsDB.maxNames = 3 end
	--if ItemListsDB.hideReceivedWishes == nil then ItemListsDB.hideReceivedWishes = false end
	--if ItemListsDB.hideReceivedPrios == nil then ItemListsDB.hideReceivedPrios = false end
	--if ItemListsDB.forceReceivedList == nil then ItemListsDB.forceReceivedList = false end
	if ItemListsDB.onlyInRaid == nil then ItemListsDB.onlyInRaid = false end
	if ItemListsDB.onlyRaidMembers == nil then ItemListsDB.onlyRaidMembers = false end
	if ItemListsDB.DBImportID == nil then ItemListsDB.DBImportID = 0 end

	if ItemListsDB.enabled then 
		statusEnableText = "GSL LC Tooltips is currently: Enabled"
	end
	
end

function GrimsoulLegion:ChatCommands(arg)
	if arg == "" then 
		popupConfig()
	elseif arg == "minimap" then
		self.db.profile.minimap.hide = not self.db.profile.minimap.hide 
		if self.db.profile.minimap.hide then
			GSLIcon:Hide("GSLTooltips") 
		else 
			GSLIcon:Show("GSLTooltips") 
		end 
	elseif arg == "toggle" then
		if ItemListsDB.enabled then 
			statusEnableText = "GSL LC Tooltips is currently: Disabled"
			ItemListsDB.enabled = false
		else
			statusEnableText = "GSL LC Tooltips is currently: Enabled"
			ItemListsDB.enabled = true
		end
		GrimsoulLegion:Print(statusEnableText)
	elseif arg == "sync" then
		showSync()
	else 
		GrimsoulLegion:Print("Thats my BIS command arguments\nminimap - toggle minimap icon\ntoogle - enable/disable function\nno argument - open config\nanything else - show this text")
	end

end 

local function ModifyItemTooltip( tt ) -- Function for modifying the tooltip
	if not ItemListsDB.enabled then return end
	if ItemListsDB.onlyInRaid then
		if not IsInRaid() then return end
	end
	local itemName, itemLink = tt:GetItem() 
	if not itemName then return end
	local itemID = select( 1, GetItemInfoInstant( itemName ) )
	
	if itemID == nil then
		itemID = tonumber( string.match( itemLink, "item:?(%d+):" ) )
		if itemID == nil then
			return
		end
	end

	local itemNotes = ItemListsDB.itemNotes[itemID]
	if itemNotes == nil then return end -- Item not in DB, escape out of function.
	tt:AddLine("|cffffd839*********************************************************************")
	tt:AddLine("|cffff8000Grimsoul Legion", 1, 0.02, 0.01, 1, 0)
	
	if IsAltKeyDown() == false then --Display something different if alt is held down.

	if ItemListsDB.displayPrioNote then
		for k,v in pairs(itemNotes.wishlist) do
			tt:AddLine("|cffa335eePriority Note: " .. "|cffffffff" .. v.prio) break
		end
	end

tt:AddLine(" ")
		-- %%%%%%%%%%%%%%%%% WISHLIST

		--if ItemListsDB.displayWishes then
			local itemWishes = {}
			local wishlistString = ""
			local smallestKey = 0
			local smallestWish = {}
			local keyIndex = 1
			local defcol = "|cffffd839"
			if itemNotes.wishlist ~= nil then
				add = false
				for k,v in pairs(itemNotes.wishlist) do



					if ItemListsDB.onlyRaidMembers then
						if UnitInRaid(v.name) ~= nil then --if they are in the raid display and the raid only option is on here
								--tt:AddLine(classColorsTable[ v.class ] .. v.name)

						if ItemListsDB.displayRank then
							tt:AddLine(classColorsTable[ v.class ] .. v.name .. " - " .. v.spec .. " " .. "|cffffffff" .. "Tier: " .. tierColorsTable[v.tier] .. v.tier .. "|cffffd839    "..v.team .. " R: " .. v.ratio .. " A: " .. v.attendance)
						else
							tt:AddLine(classColorsTable[ v.class ] .. v.name .. " - " .. v.spec .. " " .. "|cffffffff" .. "Tier: " .. tierColorsTable[v.tier] .. v.tier .. "|cffffd839    R: " .. v.ratio .. " A: " .. v.attendance)							
						end
						
						tt:AddLine(tierColorsTable["S"] .. "S" .. "|cffffffff" .. ": " .. v.scount .. ", " .. v.sdayssince .. "   " ..tierColorsTable["A"] .. " A" .. "|cffffffff" .. ": " .. v.acount .. ", " .. v.adayssince .. "   " ..tierColorsTable["B"] .. " B" .. "|cffffffff" .. ": " .. v.bcount .. ", " .. v.bdayssince .. "   " ..tierColorsTable["C"] .. " C" .. "|cffffffff" .. ": " .. v.ccount .. ", " .. v.cdayssince .. "   " ..tierColorsTable["D"] .. " D" .. "|cffffffff" .. ": " .. v.dcount .. ", " .. v.ddayssince)
							
							add = true
						end
					else --if raid only option is off

						if ItemListsDB.displayRank then
							tt:AddLine(classColorsTable[ v.class ] .. v.name .. " - " .. v.spec .. " " .. "|cffffffff" .. "Tier: " .. tierColorsTable[v.tier] .. v.tier .. "|cffffd839    "..v.team .. " R: " .. v.ratio .. " A: " .. v.attendance)
						else
							tt:AddLine(classColorsTable[ v.class ] .. v.name .. " - " .. v.spec .. " " .. "|cffffffff" .. "Tier: " .. tierColorsTable[v.tier] .. v.tier .. "|cffffd839    R: " .. v.ratio .. " A: " .. v.attendance)							
						end
						
						tt:AddLine(tierColorsTable["S"] .. "S" .. "|cffffffff" .. ": " .. v.scount .. ", " .. v.sdayssince .. "   " ..tierColorsTable["A"] .. " A" .. "|cffffffff" .. ": " .. v.acount .. ", " .. v.adayssince .. "   " ..tierColorsTable["B"] .. " B" .. "|cffffffff" .. ": " .. v.bcount .. ", " .. v.bdayssince .. "   " ..tierColorsTable["C"] .. " C" .. "|cffffffff" .. ": " .. v.ccount .. ", " .. v.cdayssince .. "   " ..tierColorsTable["D"] .. " D" .. "|cffffffff" .. ": " .. v.dcount .. ", " .. v.ddayssince)
						add = true
					end

					
					--[[if add == true then
						itemWishes[keyIndex] = v 
						keyIndex = keyIndex + 1
					else
						totalHiddenWishes = totalHiddenWishes + 1
					end--]]
				
				end
				
			end
		--end

	else -- when alt is down

		if ItemListsDB.displayPrioNote then
		for k,v in pairs(itemNotes.wishlist) do
			tt:AddLine("|cffa335eePriority Note: " .. "|cffffffff" .. v.prio) break
		end
	end
tt:AddLine(" ")
		for k,v in pairs(itemNotes.wishlist) do

			if ItemListsDB.onlyRaidMembers then
						if UnitInRaid(v.name) ~= nil then --if they are in the raid display and the raid only option is on here

								
							tt:AddLine(classColorsTable[ v.class ] .. v.name .. " - " .. v.spec .. " " .. "|cffffffff" .. "Tier: " .. tierColorsTable[v.tier] .. v.tier .. "|cffffd839    R: " .. v.ratio .. " A: " .. v.attendance)
							tt:AddLine(tierColorsTable["S"] .. "S" .. "|cffffffff" .. ": " .. v.scount .. ", " .. v.sdayssince .. "   " ..tierColorsTable["A"] .. " A" .. "|cffffffff" .. ": " .. v.acount .. ", " .. v.adayssince .. "   " ..tierColorsTable["B"] .. " B" .. "|cffffffff" .. ": " .. v.bcount .. ", " .. v.bdayssince .. "   " ..tierColorsTable["C"] .. " C" .. "|cffffffff" .. ": " .. v.ccount .. ", " .. v.cdayssince .. "   " ..tierColorsTable["D"] .. " D" .. "|cffffffff" .. ": " .. v.dcount .. ", " .. v.ddayssince)
					
							local lastInSlot = v.lastslot[v.slot]
							if lastInSlot == nil then
							elseif lastInSlot == "" then
							else
								local lastSlot = {strsplit("^", lastInSlot)}
								local lastDate = lastSlot[1]
								local lastItem = lastSlot[2]
								local lastTier = lastSlot[3]
								tt:AddLine("Last item received in this slot: ")
								tt:AddLine(tierColorsTable[lastTier].. lastTier .. "|cffffffff: "..tierColorsTable["B"]..lastItem.." |cffffffff"..lastDate)
							end

							tt:AddLine("Last 3 items received:")
							if v.last3loot == nil then
								tt:AddLine("|cffffffffNone")
							elseif v.last3loot == "" then
								tt:AddLine("|cffffffffNone")
							else

								local lastThree = {strsplit("|", v.last3loot)}

								local last = ""

								for c=1,3,1 do
									if lastThree[c] == nil then
									elseif lastThree[c] == "" then
									else

							   			local prevloot = {strsplit("^", lastThree[c])}
							   			local date = prevloot[1]
							   			local item = prevloot[2]
							   			local tier = prevloot[3]

							   			last = last .. " " .. tierColorsTable[tier] .. tier .. "|cffffffff: " ..tierColorsTable["B"] .. item 
						   		end
						   		end
						   		
						   		tt:AddLine(last)
							end
						end
			else
tt:AddLine(classColorsTable[ v.class ] .. v.name .. " - " .. v.spec .. " " .. "|cffffffff" .. "Tier: " .. tierColorsTable[v.tier] .. v.tier .. "|cffffd839    R: " .. v.ratio .. " A: " .. v.attendance)
							tt:AddLine(tierColorsTable["S"] .. "S" .. "|cffffffff" .. ": " .. v.scount .. ", " .. v.sdayssince .. "   " ..tierColorsTable["A"] .. " A" .. "|cffffffff" .. ": " .. v.acount .. ", " .. v.adayssince .. "   " ..tierColorsTable["B"] .. " B" .. "|cffffffff" .. ": " .. v.bcount .. ", " .. v.bdayssince .. "   " ..tierColorsTable["C"] .. " C" .. "|cffffffff" .. ": " .. v.ccount .. ", " .. v.cdayssince .. "   " ..tierColorsTable["D"] .. " D" .. "|cffffffff" .. ": " .. v.dcount .. ", " .. v.ddayssince)
					
							local lastInSlot = v.lastslot[v.slot]
							if lastInSlot == nil then
							elseif lastInSlot == "" then
							else
								local lastSlot = {strsplit("^", lastInSlot)}
								local lastDate = lastSlot[1]
								local lastItem = lastSlot[2]
								local lastTier = lastSlot[3]
								tt:AddLine("Last item received in this slot: ")
								tt:AddLine(tierColorsTable[lastTier].. lastTier .. "|cffffffff: "..tierColorsTable["B"]..lastItem.." |cffffffff"..lastDate)
							end

							tt:AddLine("Last 3 items received:")
							if v.last3loot == nil then
								tt:AddLine("|cffffffffNone")
							elseif v.last3loot == "" then
								tt:AddLine("|cffffffffNone")
							else

								local lastThree = {strsplit("|", v.last3loot)}

								local last = ""

								for c=1,3,1 do
									if lastThree[c] == nil then
									elseif lastThree[c] == "" then
									else

							   			local prevloot = {strsplit("^", lastThree[c])}
							   			local date = prevloot[1]
							   			local item = prevloot[2]
							   			local tier = prevloot[3]

							   			last = last .. " " .. tierColorsTable[tier] .. tier .. "|cffffffff: " ..tierColorsTable["B"] .. item 
						   		end
						   		end
						   		
						   		tt:AddLine(last)
							end
						

			end	

	--[[		tt:AddLine(classColorsTable[ v.class ] .. v.name .. " - " .. v.spec .. " " .. "|cffffffff" .. "Tier: " .. tierColorsTable[v.tier] .. v.tier .. "|cffffd839    R: " .. v.ratio .. " A: " .. v.attendance)
			tt:AddLine(tierColorsTable["S"] .. "S" .. "|cffffffff" .. ": " .. v.scount .. ", " .. v.sdayssince .. "   " ..tierColorsTable["A"] .. " A" .. "|cffffffff" .. ": " .. v.acount .. ", " .. v.adayssince .. "   " ..tierColorsTable["B"] .. " B" .. "|cffffffff" .. ": " .. v.bcount .. ", " .. v.bdayssince .. "   " ..tierColorsTable["C"] .. " C" .. "|cffffffff" .. ": " .. v.ccount .. ", " .. v.cdayssince .. "   " ..tierColorsTable["D"] .. " D" .. "|cffffffff" .. ": " .. v.dcount .. ", " .. v.ddayssince)
	
			local lastInSlot = v.lastslot[v.slot]
			if lastInSlot == nil then
			elseif lastInSlot == "" then
			else
				local lastSlot = {strsplit("^", lastInSlot)}
				local lastDate = lastSlot[1]
				local lastItem = lastSlot[2]
				local lastTier = lastSlot[3]
				tt:AddLine("Last item received in this slot: ")
				tt:AddLine(tierColorsTable[lastTier].. lastTier .. "|cffffffff: "..tierColorsTable["B"]..lastItem.." |cffffffff"..lastDate)
			end



			tt:AddLine("Last 3 items received:")
			if v.last3loot == nil then
				tt:AddLine("|cffffffffNone")
			elseif v.last3loot == "" then
				tt:AddLine("|cffffffffNone")
			else

				local lastThree = {strsplit("|", v.last3loot)}

				local last = ""

				for c=1,3,1 do
					if lastThree[c] == nil then
					elseif lastThree[c] == "" then
					else

			   			local prevloot = {strsplit("^", lastThree[c])}
			   			local date = prevloot[1]
			   			local item = prevloot[2]
			   			local tier = prevloot[3]

			   			last = last .. " " .. tierColorsTable[tier] .. tier .. "|cffffffff: " ..tierColorsTable["B"] .. item 
		   		end
		   		end
		   		
		   		tt:AddLine(last)
			end

			

   		



]]--

			--[[tt:AddLine("Last item received in this slot: "..tierColorsTable["B"].."[Super Duper Mace]")
			tt:AddLine("Last 3 items received:")
		

			tt:AddLine(tierColorsTable["B"].."[Dragonspine Trophy] [Eye of Gruul] [Dazzas Tingled Finger]")]]--
			--tt:AddLine(" ")

		end	

	end
end

-- TODO: Affects more than the static item frame. Need to look into this later
--[[ ChatFrame_OnHyperlinkShow = function(...) -- Hook into the static item info window, not the tooltip.
    local chatFrame, link, text, button = ...
    local result = origChatFrame_OnHyperlinkShow(...)
    
        ShowUIPanel(ItemRefTooltip)
        if (not ItemRefTooltip:IsVisible()) then
            ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE")
        end
        
       	ModifyItemTooltip(ItemRefTooltip)

        ItemRefTooltip:Show(); ItemRefTooltip:Show()

    --return result
end ]]



local function InitFrame() --Starts the listener for tooltips
	GameTooltip:HookScript( "OnTooltipSetItem", ModifyItemTooltip )
end

function ParseText(input)
	if input == nil then return "NoData" end
	local header = "team,name,class,rank,spec,itemInfo,attendance,ratio,scount,sdayssince,acount,adayssince,bcount,bdayssince,ccount,cdayssince,dcount,ddayssince,last3loot,lasttwohand,lastback,lastfeet,lastonehand,lastlegs,lastring,lastshoulders,lastgloves,lastneck,lastranged,lasthead,lastchest,lasttoken,lastheldoff,lastoffhand,lastbag,lasttrinket,lastwaist,lastwrist,lastmainhand,"

	local parsedLines = {}
	local parsedEntries = {}
	
	for line in input:gmatch("([^\n]*)\n?") do -- Extract the lines into seperate entries in an array.
		table.insert(parsedLines, line..",")
	end
	if (parsedLines[1] ~= header) then return "Wrong Header" end -- Validate the header
	
	local headerData = {}
	for lineKey,line in pairs(parsedLines) do
		entry = {}
		if lineKey == 1 then
			headerData = ParseCSVLine(parsedLines[lineKey])
		else
			for key,value in pairs(ParseCSVLine(line)) do
				if key == 1 and value == "item_note" then
				end
				entry[ headerData[key] ] = value
			end
			table.insert(parsedEntries, entry)
		end
	end
	table.remove(parsedEntries) -- Pop of the malformed last entry.
	local noteTable = {}

	for k,e in pairs(parsedEntries) do


	local items = {strsplit(";", e.itemInfo)}


	for c=#items,1,-1 do
		
   			local item = {strsplit("^", items[c])}
   			local tier = item[1]
   			local prio = item[2]
   			local itemID = item[3]
   			local slot = item[4]
   	
		local tempTable = {}
		local tempCharTable = {}

		tempTable = noteTable[ tonumber(itemID) ] --Try and load the item element
		if tempTable == nil then noteTable[ tonumber(itemID) ] = {} end -- Make an array because this is the first time the item is seen

			tempCharTable.class = e.class
			tempCharTable.name = e.name
			tempCharTable.team = e.team
			tempCharTable.sort_order = 0
			tempCharTable.member_name = e.name
			tempCharTable.character_is_alt = 0
			tempCharTable.prio = prio
			tempCharTable.tier = tier
			tempCharTable.slot = slot
			tempCharTable.spec = e.spec
			tempCharTable.attendance = e.attendance
			tempCharTable.ratio = e.ratio
			tempCharTable.scount = e.scount
			tempCharTable.acount = e.acount
			tempCharTable.bcount = e.bcount
			tempCharTable.ccount = e.ccount
			tempCharTable.dcount = e.dcount
			tempCharTable.sdayssince = e.sdayssince
			tempCharTable.adayssince = e.adayssince
			tempCharTable.bdayssince = e.bdayssince
			tempCharTable.cdayssince = e.cdayssince
			tempCharTable.ddayssince = e.ddayssince
			tempCharTable.last3loot =  e.last3loot

			lastSlot = {}

			lastSlot["Back"] = e.lastback
			lastSlot["Two-Hand"] = e.lasttwohand
			lastSlot['Feet'] = e.lastfeet
			lastSlot['One-Hand'] = e.lastonehand
			lastSlot['Legs'] = e.lastlegs
			lastSlot['Finger'] = e.lastring
			lastSlot['Shoulder'] = e.lastshoulders
			lastSlot['Hands'] = e.lastgloves
			lastSlot['Neck'] = e.lastneck
			lastSlot['Ranged'] = e.lastranged
			lastSlot['Head'] = e.lasthead
			lastSlot['Chest'] = e.lastchest
			lastSlot['token/recipe'] = e.lasttoken
			lastSlot['Held In Off-hand'] = e.lastheldoff
			lastSlot['Off Hand'] = e.lastoffhand
			lastSlot['Trinket'] = e.lasttrinket
			lastSlot['Waist'] = e.lastwaist
			lastSlot['Wrist'] = e.lastwrist
			lastSlot['Main Hand'] = e.lastmainhand
			lastSlot['Bag'] = e.lastbag
			tempCharTable.lastslot = lastSlot


			if tempTable ~= nil then tempTable = tempTable.wishlist end -- Look at the wishlist element if it exist then load it
			if tempTable == nil then --If the loaded item is nil then its the first wish for this item so just save it directly
				tempTable = {}
				table.insert(tempTable,tempCharTable)
			else -- Else insert it into the old one before saving.
				table.insert(tempTable,tempCharTable)
			end
			noteTable[tonumber(itemID)].wishlist = tempTable
		end
	end

	ItemListsDB["itemNotes"] = noteTable -- Add it to peristent storage
	ItemListsDB.DBImportID = math.floor(GetTime())
	return "Done"
end

function ParseCSVLine (line,sep) 

	local res = {}
	local pos = 1
	sep = sep or ','
	while true do 
		local c = string.sub(line,pos,pos)
		if (c == "") then break end
		if (c == '"') then
			-- quoted value (ignore separator within)
			local txt = ""
			repeat
				local startp,endp = string.find(line,'^%b""',pos)
				txt = txt..string.sub(line,startp+1,endp-1)
				pos = endp + 1
				c = string.sub(line,pos,pos) 
				if (c == '"') then txt = txt..'"' end 
				-- check first char AFTER quoted string, if it is another
				-- quoted string without separator, then temp it
				-- this is the way to "escape" the quote char in a quote. example:
				--   value1,"blub""blip""boing",value3  will result in blub"blip"boing  for the middle
			until (c ~= '"')
			table.insert(res,txt)
			assert(c == sep or c == "")
			pos = pos + 1
		else	
			-- no quotes used, just look for the first separator
			local startp,endp = string.find(line,sep,pos)
			if (startp) then 
				table.insert(res,string.sub(line,pos,startp-1))
				pos = endp + 1
			else
				-- no separator found -> use rest of string and terminate
				table.insert(res,string.sub(line,pos))
				break
			end 
		end
	end
	return res
end

function GrimsoulLegion:OnCommReceived(prefix, serializedMsg, distri, sender)
	if prefix == "GSLSync" then
		if sender ~= currentPlayer then 
			if syncShown then 
				local valid, command, data = LibAceSerializer:Deserialize(serializedMsg)
				if valid then
					if command == "INFO" then
						GrimsoulLegion:Print(data)
					elseif command == "RTS" then
						--Someone is asking if we're ready to recieve, check their id against ours.
						if ItemListsDB.DBImportID == data then
							GrimsoulLegion:SendComm(sender,"INFO", currentPlayer .. " already have this data")
						else
							GrimsoulLegion:SendComm(sender,"RTR","Please donate gold if you like this addon") 
						end
					elseif command == "RTR" then
						--Sender is ready to recieve, Transmit data.
						GrimsoulLegion:Print("Sending data to " .. sender)
						GrimsoulLegion:SendComm(sender, "INFO", "You are about to receive GSL data from ".. currentPlayer)
						GrimsoulLegion:SendComm(sender, "DBID", ItemListsDB.DBImportID)
						GrimsoulLegion:SendComm(sender, "TABLES", ItemListsDB.itemNotes)

					elseif command == "TABLES" then
						ItemListsDB.itemNotes = data
						GrimsoulLegion:Print("ID " .. ItemListsDB.DBImportID .. " have been imported, exit the game via menus or reload to save it.")
						GrimsoulLegion:SendComm(sender, "INFO", currentPlayer .. " is now on ID " .. ItemListsDB.DBImportID )
					elseif command == "DBID" then
						ItemListsDB.DBImportID = data
						
					end
				end
			else
				GrimsoulLegion:Print(sender .." is trying to send you data, however sync window is not open. Do /gsl sync and have them re-send")
				GrimsoulLegion:SendComm(sender,"INFO", currentPlayer .." does not have sync window open. Try again")
			end
		end
	end
end

function GrimsoulLegion:SendComm(target, command, data )
    local serialized = nil
    if data then
        serialized = LibAceSerializer:Serialize(command, data)
	end
	if target == "PARTY" then 
		GrimsoulLegion:SendCommMessage("GSLSync", serialized, target, "BULK")
	elseif target == "RAID" then 
		GrimsoulLegion:SendCommMessage("GSLSync", serialized, target, "BULK")
	elseif target == "GUILD" then 
		GrimsoulLegion:SendCommMessage("GSLSync", serialized, target, "BULK")
	else 
		GrimsoulLegion:SendCommMessage("GSLSync", serialized, "WHISPER", target, "BULK")
	end
    
end

InitFrame()
