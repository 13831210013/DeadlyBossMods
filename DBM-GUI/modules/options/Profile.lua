local After = C_Timer.After
local DBM, DBM_AllSavedOptions, DBM_UsedProfile, DBM_UseDualProfile = DBM, DBM_AllSavedOptions, DBM_UsedProfile, DBM_UseDualProfile

local L = DBM_GUI_L

local create, refresh
local profileDropdown = {}

local profilePanel			= DBM_GUI_Options:CreateNewPanel(L.Panel_Profile)

local createProfileArea		= profilePanel:CreateArea(L.Area_CreateProfile)
local createTextbox			= createProfileArea:CreateEditBox(L.EnterProfileName, "", 175)
createTextbox:SetMaxLetters(17)
createTextbox:SetPoint("TOPLEFT", 30, -25)
createTextbox:SetScript("OnEnterPressed", function()
	create()
end)

local createButton			= createProfileArea:CreateButton(L.CreateProfile)
createButton:SetPoint("LEFT", createTextbox, "RIGHT", 10, 0)
createButton:SetScript("OnClick", function()
	create()
end)

local applyProfileArea		= profilePanel:CreateArea(L.Area_ApplyProfile)
local applyProfile			= applyProfileArea:CreateDropdown(L.SelectProfileToApply, profileDropdown, nil, nil, function(value)
	DBM_UsedProfile = value
	DBM:ApplyProfile(value)
	refresh()
end)
applyProfile:SetPoint("TOPLEFT", 0, -20)
applyProfile:SetScript("OnShow", function()
	applyProfile:SetSelectedValue(DBM_UsedProfile)
end)

local copyProfileArea		= profilePanel:CreateArea(L.Area_CopyProfile)
local copyProfile			= copyProfileArea:CreateDropdown(L.SelectProfileToCopy, profileDropdown, nil, nil, function(value)
	DBM:CopyProfile(value)
	After(0.05, refresh)
end)
copyProfile:SetPoint("TOPLEFT", 0, -20)
copyProfile:SetScript("OnShow", function()
	copyProfile.value = nil
	copyProfile.text = nil
	_G[copyProfile:GetName() .. "Text"]:SetText("")
end)

local deleteProfileArea		= profilePanel:CreateArea(L.Area_DeleteProfile)
local deleteProfile			= deleteProfileArea:CreateDropdown(L.SelectProfileToDelete, profileDropdown, nil, nil, function(value)
	DBM:DeleteProfile(value)
	After(0.05, refresh)
end)
deleteProfile:SetPoint("TOPLEFT", 0, -20)
deleteProfile:SetScript("OnShow", function()
	deleteProfile.value = nil
	deleteProfile.text = nil
	_G[deleteProfile:GetName() .. "Text"]:SetText("")
end)

local dualProfileArea		= profilePanel:CreateArea(L.Area_DualProfile)
local dualProfile			= dualProfileArea:CreateCheckButton(L.DualProfile, true)
dualProfile:SetScript("OnClick", function()
	DBM_UseDualProfile = not DBM_UseDualProfile
	DBM:SpecChanged(true)
end)
dualProfile:SetChecked(DBM_UseDualProfile)

function create()
	if createTextbox:GetText() then
		local text = createTextbox:GetText()
		text = text:gsub(" ", "")
		if text ~= "" then
			DBM:CreateProfile(createTextbox:GetText())
			createTextbox:SetText("")
			createTextbox:ClearFocus()
			refresh()
		end
	end
end

do
	local pairs, twipe, tinsert = pairs, table.wipe, table.insert

	function refresh()
		twipe(profileDropdown)
		for name, _ in pairs(DBM_AllSavedOptions) do
			tinsert(profileDropdown, {
				text	= name,
				value	= name
			})
		end
		applyProfile:GetScript("OnShow")()
		copyProfile:GetScript("OnShow")()
		deleteProfile:GetScript("OnShow")()
	end
end

refresh()
