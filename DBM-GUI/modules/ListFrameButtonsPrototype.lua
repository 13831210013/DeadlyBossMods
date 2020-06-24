local setmetatable, ipairs = setmetatable, ipairs
local DBM_GUI = DBM_GUI

local L = DBM_GUI_L

local TabPrototype = {}

local function GetDepth(tab, name, depth)
	depth = depth or 1
	for _, v in ipairs(tab.Buttons) do
		if v.frame.name == name then
			if not v.parent then
				return depth + 1
			end
			depth = depth + GetDepth(tab, v.parent, depth)
		end
	end
	return depth
end

local function SetParentHasChilds(tab, parent)
	if not parent then
		return
	end
	for _, v in ipairs(tab.Buttons) do
		if v.frame.name == parent then
			v.frame.haschilds = true
		end
	end
end

local function GetVisibleSubButtons(tab, parent, tabs)
	for _, v in ipairs(tab.Buttons) do
		if v.parent == parent then
			tabs[#tabs + 1] = v
			if v.frame.showSub then
				GetVisibleSubButtons(tab, v.frame.name, tabs)
			end
		end
	end
end

function TabPrototype:CreateCategory(frame, parent)
	frame.depth = parent and GetDepth(self, parent) or 1
	SetParentHasChilds(self, parent)
	self.Buttons[#self.Buttons + 1] = {
		frame	= frame,
		parent	= parent
	}
	return #self.Buttons
end

function TabPrototype:GetVisibleButtons()
	local tabs = {}
	for _, v in ipairs(self.Buttons) do
		if not v.parent then
			tabs[#tabs + 1] = v
			if v.frame.showSub then
				GetVisibleSubButtons(self, v.frame.name, tabs)
			end
		end
	end
	return tabs
end

function TabPrototype:CreateNewPanel(frameName, showSub)
	local panel = DBM_GUI:NewCreateNewPanel(frameName, showSub)
	panel.frame.depth = 1
	self.Buttons[#self.Buttons + 1] = {
		frame	= panel.frame
	}
	return panel
end

function DBM_GUI:CreateNewTab(name)
	local optionFrame = _G["DBM_GUI_OptionsFrame"]
	local mt = setmetatable({
		Buttons = {}
	}, {
		__index = TabPrototype
	})
	local i = #DBM_GUI.tabs + 1
	DBM_GUI.tabs[i] = mt
	local frame = CreateFrame("Frame", "$parentDBM" .. i, optionFrame)
	--frame.name = name
	frame:Hide()
	local button = CreateFrame("Button", "DBM_GUI_OptionsFrameTab" .. i, optionFrame, "OptionsFrameTabButtonTemplate")
	local buttonText = _G[button:GetName() .. "Text"]
	buttonText:SetText(name)
	buttonText:SetPoint("LEFT", 22, -2)
	buttonText:Show()
	button:Show()
	if i == 1 then
		button:SetPoint("TOPLEFT", optionFrame, 20, -18)
	else
		button:SetPoint("TOPLEFT", "DBM_GUI_OptionsFrameTab" .. (i - 1), "TOPRIGHT", -15, 0)
	end
	button:SetScript("OnClick", function()
		optionFrame:ShowTab(i)
	end)
	local buttonWidth = button:GetWidth()
	function mt:Hide()
		button:Hide()
		button:SetWidth(15)
	end
	function mt:Show()
		button:Show()
		button:SetWidth(buttonWidth)
	end
	return mt
end

-- TODO: Should this go somewhere else?
_G["DBM_GUI_Raids"] = DBM_GUI:CreateNewTab(L.OTabRaids)
_G["DBM_GUI_Dungeons"] = DBM_GUI:CreateNewTab(L.OTabDungeons)
_G["DBM_GUI_Options"] = DBM_GUI:CreateNewTab(L.OTabOptions)
_G["DBM_GUI_Plugins"] = DBM_GUI:CreateNewTab(L.OTabPlugins)
_G["DBM_GUI_About"] = DBM_GUI:CreateNewTab(L.OTabAbout)

_G["DBM_GUI_Plugins"]:Hide() -- Only show plugins tab when there are registered plugins
