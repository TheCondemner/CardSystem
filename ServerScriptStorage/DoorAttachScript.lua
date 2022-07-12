---------------------------------------------------------------------------------------------------------------------------------------------------------
-- [Service Imports]

local TS = game:GetService("TweenService")
local RS = game:GetService('ReplicatedStorage')
local CS = game:GetService("CollectionService")

---------------------------------------------------------------------------------------------------------------------------------------------------------
-- [Variables]

local running = {}

local changeColorEvent = RS:WaitForChild('ChangeIndicatorBeamColor')

---------------------------------------------------------------------------------------------------------------------------------------------------------
-- [Control Door]

local function controlDoor(player, part) 
	-- [Debounce]
	local parentModel = part.Parent
	if (not running[parentModel]) then
		running[parentModel] = true
		-- [Get Parent Part]
		if (parentModel ~= game:GetService("ReplicatedStorage"):FindFirstChild("TagList")) then
			local permissions = require(parentModel.Clearances)
			local keycardreaders = {}
			-- [Get All KeycardReader Models]
			for i = 1, #parentModel:GetChildren() do
				if (parentModel:GetChildren()[i].Name == "Keycard_Reader") then 
					table.insert(keycardreaders, parentModel:GetChildren()[i])
				end
			end

			-- [Check If Permitted]
			if (permissions[player:GetAttribute("SecurityClearance")] or permissions[player.Team.Name]) then
				if (parentModel:FindFirstChild("Door")) then -- [If Single Door]
					local door = parentModel:WaitForChild("Door")
					-- [Get Sounds]
					local accessGranted = Instance.new("Sound", parentModel)
					accessGranted.SoundId = "rbxassetid://200888468"
					local openDoor = Instance.new("Sound", parentModel)
					openDoor.SoundId = "rbxassetid://983439147"
					local closeDoor = Instance.new("Sound", parentModel)
					closeDoor.SoundId = "rbxassetid://983438447"
					-- [Get Tween]
					local tweenTime = 1.5
					local tweenInfo =  TweenInfo.new(tweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, true)
					local tweenGoal = {Position = (door.CFrame + (door.CFrame * CFrame.Angles(0, 0, math.rad(90))).lookVector * (-1*door.Size.Z - 0.1)).Position}
					local tween = TS:Create(door, tweenInfo, tweenGoal)
					-- [Animation]
					accessGranted:Play()
					wait(0.5)
					-- [Change Light Colour To Green]
					for i = 1, #keycardreaders do keycardreaders[i]:WaitForChild("Light").BrickColor = BrickColor.new("Lime green") end
					parentModel:WaitForChild("Light1").BrickColor = BrickColor.new("Lime green")
					parentModel:WaitForChild("Light2").BrickColor = BrickColor.new("Lime green")
					changeColorEvent:FireClient(player, 'g', parentModel)
					wait(0.5)
					openDoor:Play()
					tween:Play()
					wait(tweenTime)
					tween:Pause()
					wait(2)
					closeDoor:Play()
					tween:Play()
					wait(tweenTime)
					-- [Destroy Sound Children]
					closeDoor.Ended:Connect(function() openDoor:Destroy() closeDoor:Destroy() accessGranted:Destroy() end)				
					
				elseif (parentModel:FindFirstChild("Door1")) then -- [If Double Door]
					local door1 = parentModel:WaitForChild("Door1")
					local door2 = parentModel:WaitForChild("Door2")
					-- [Get Sounds]
					local accessGranted = Instance.new("Sound", parentModel)
					accessGranted.SoundId = "rbxassetid://200888468"
					local openDoor = Instance.new("Sound", parentModel)
					openDoor.SoundId = "rbxassetid://983439147"
					local closeDoor = Instance.new("Sound", parentModel)
					closeDoor.SoundId = "rbxassetid://983438447"
					-- [Tween]
					local tweenTime = 1.5
					local tweenInfo =  TweenInfo.new(tweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, true)
					local tweenGoal1 = {Position = (door1.CFrame + (door1.CFrame * CFrame.Angles(0, 0, math.rad(90))).lookVector * (door1.Size.Z*-1 - 0.1)).Position}
					local tweenGoal2 = {Position = (door2.CFrame + (door2.CFrame * CFrame.Angles(0, 0, math.rad(90))).lookVector * (door2.Size.Z*-1 - 0.1)).Position}
					local tween1 = TS:Create(door1, tweenInfo, tweenGoal1)
					local tween2 = TS:Create(door2, tweenInfo, tweenGoal2)
					-- [Animation]
					accessGranted:Play()
					wait(0.7)
					-- [Change Light Colour To Green]
					for i = 1, #keycardreaders do keycardreaders[i]:WaitForChild("Light").BrickColor = BrickColor.new("Lime green") end	
					parentModel:WaitForChild("Light1").BrickColor = BrickColor.new("Lime green")
					parentModel:WaitForChild("Light2").BrickColor = BrickColor.new("Lime green")
					changeColorEvent:FireClient(player, 'g', parentModel)
					wait(0.3)
					openDoor:Play()
					tween1:Play()
					tween2:Play()
					wait(tweenTime)
					tween1:Pause()
					tween2:Pause()
					wait(2)
					closeDoor:Play()
					tween1:Play()
					tween2:Play()
					wait(tweenTime)
					-- [Destroy Sound Children]
					closeDoor.Ended:Connect(function() openDoor:Destroy() closeDoor:Destroy() accessGranted:Destroy()end)
				end
			else
				-- [Get Sounds]
				local accessDenied = Instance.new("Sound", parentModel)
				accessDenied.SoundId = 'rbxassetid://200888510'
				accessDenied:Play()
				wait(0.5)
				-- [Change Light Colour To Red]
				for i = 1, #keycardreaders do keycardreaders[i]:WaitForChild("Light").BrickColor = BrickColor.new("Really red") end
				parentModel:WaitForChild("Light1").BrickColor = BrickColor.new("Really red")
				parentModel:WaitForChild("Light2").BrickColor = BrickColor.new("Really red")
				changeColorEvent:FireClient(player, 'r', parentModel)
				wait(1)
				accessDenied:Destroy()
			end
			-- [Change Light Colour To White]
			for i = 1, #keycardreaders do keycardreaders[i]:WaitForChild("Light").BrickColor = BrickColor.new("Institutional white") end
			parentModel:WaitForChild("Light1").BrickColor = BrickColor.new("Institutional white")
			parentModel:WaitForChild("Light2").BrickColor = BrickColor.new("Institutional white")
			changeColorEvent:FireClient(player, 'w', parentModel)
			--for i = 1, #keycardreaders do keycardreaders[i]:FindFirstChild("Frame"):FindFirstChild("PromptUI").Enabled = true end
		end
		wait(0.5)
		running[parentModel] = false
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------
-- [On Event]

-- [Attach To Keycard Readers]
for _, keycardReader in pairs(CS:GetTagged("KeycardReader")) do
	-- print(keycardReader.Parent:GetChildren())
	if (keycardReader.Parent ~= "TagList") then
		local PromptUI = Instance.new("ProximityPrompt")
		PromptUI.Name = "PromptUI"
		PromptUI.Parent = keycardReader:FindFirstChild("Frame")
		PromptUI.RequiresLineOfSight = true
		PromptUI.MaxActivationDistance = 10
		PromptUI.Style = 'Custom'
		
		local BeamAttachment = Instance.new('Attachment')
		BeamAttachment.Name = 'IndicatorBeamAttachment'
		BeamAttachment.Parent = keycardReader:FindFirstChild("Frame")
		
		PromptUI.Triggered:Connect(function(player)
			controlDoor(player, keycardReader)
		end)
	end
end
