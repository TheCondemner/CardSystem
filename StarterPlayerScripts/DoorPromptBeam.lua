---------------------------------------------------------------------------------------------------------------------------------------------------------
-- [Service Imports]

local PPS = game:GetService('ProximityPromptService')
local RS = game:GetService('ReplicatedStorage')

---------------------------------------------------------------------------------------------------------------------------------------------------------
-- [Variables]

local player = game:GetService('Players').LocalPlayer
wait(2) -- TODO: Replace with a player.CharacterAppearanceLoaded:Wait() for production
local torso = player.Character:WaitForChild('UpperTorso')

local colors = {
	['w'] = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(244, 244, 244)), ColorSequenceKeypoint.new(1, Color3.fromRGB(244, 244, 244))},
	['r'] = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(244, 0, 0)),     ColorSequenceKeypoint.new(1, Color3.fromRGB(244, 0, 0))    },
	['g'] = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 244, 0)),     ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 244, 0))    }
}
local connected = {}

indicatorBeam = Instance.new('Beam')
indicatorBeam.Name = 'IndicatorBeam'
indicatorBeam.FaceCamera = true
indicatorBeam.Width0 = 0.1
indicatorBeam.Width1 = indicatorBeam.Width0
indicatorBeam.Parent = workspace

indicatorBeam.Attachment0 = torso:FindFirstChild('BodyFrontAttachment')

local changeColorEvent = RS:WaitForChild('ChangeIndicatorBeamColor')

---------------------------------------------------------------------------------------------------------------------------------------------------------
-- [Functions]

changeColorEvent.OnClientEvent:Connect(function(color, model)
	if indicatorBeam then
		connected[model] = color
		indicatorBeam.Color = colors[connected[model]]
	end
end)

PPS.PromptShown:Connect(function(prompt)
	local attachment = prompt.Parent:FindFirstChild('IndicatorBeamAttachment') -- Specific Attachment Name Required
	if attachment then
		local model = prompt:FindFirstAncestor('Keycard_Reader').Parent --Only For Doors

		if not connected[model] then connected[model] = 'w' end

		indicatorBeam.Color = colors[connected[model]]
		indicatorBeam.Attachment1 = attachment
	end
end)

PPS.PromptHidden:Connect(function(prompt)
	indicatorBeam.Attachment1 = nil
	indicatorBeam.Color = colors['w']
end)
