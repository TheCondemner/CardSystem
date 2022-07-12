local clearances = {
	["D Classification"] = "Class D",
	["E Classification"] = "Class E",
	["Security Clearance 0"] = "Level 0",
	["Security Clearance 1"] = "Level 1",
	["Security Clearance 2"] = "Level 2",
	["Security Clearance 3"] = "Level 3",
	["Security Clearance 4"] = "Level 4",
	["Security Clearance 5"] = "Level 5",
	["Security Clearance Omni"] = "Omni",
	["Site Director"] = "Level 5",
	["O5 Advisors"] = "Level 5",
	["Executive Secretaries"] = "Level 5",
	["Executive Assistants"] = "Level 5",
	["O5 Council"] = "Omni",
	["Manufacturing Department"] = "Omni",
	["O5-X"] = "Omni",
	["The Administrator"] = "Universal"

}

-- Set player's attribute
local function getClearance(player)
	if player:GetRoleInGroup(6078530) ~= "Guest" then
		player:SetAttribute("SecurityClearance", clearances[player:GetRoleInGroup(6078530)])
	else
		player:SetAttribute("SecurityClearance", "Class D")
	end
end

game:GetService("Players").PlayerAdded:Connect(getClearance)