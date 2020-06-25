local AboutPanel = DBM_GUI_About:CreateNewPanel("")
AboutPanel.initial = true

local listFrame = _G["DBM_GUI_OptionsFrameList"]
local frameContainer = _G["DBM_GUI_OptionsFramePanelContainer"]
AboutPanel.frame:HookScript("OnShow", function()
	listFrame:Hide()
	frameContainer:SetPoint("TOPLEFT", listFrame, "TOPRIGHT", -205, 0)
	frameContainer:SetPoint("BOTTOMLEFT", listFrame, "BOTTOMRIGHT", -205, 0)
	frameContainer:SetPoint("RIGHT", -22, 0)
end)
AboutPanel.frame:HookScript("OnHide", function()
	_G["DBM_GUI_OptionsFramePanelContainerFOV"]:Hide()
	listFrame:Show()
	frameContainer:SetPoint("TOPLEFT", listFrame, "TOPRIGHT", 16, 0)
	frameContainer:SetPoint("BOTTOMLEFT", listFrame, "BOTTOMRIGHT", 16, 0)
	frameContainer:SetPoint("RIGHT", -22, 0)
end)

local aboutArea = AboutPanel:CreateArea("About")

local translatorsArea = AboutPanel:CreateArea("Translators")
