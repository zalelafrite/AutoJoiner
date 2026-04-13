local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Parent = player.PlayerGui
gui.ResetOnSpawn = false

-- 🔴 CONTOUR (FRAME DERRIÈRE)
local border = Instance.new("Frame")
border.Parent = gui
border.Size = UDim2.new(0, 356, 0, 436)
border.Position = UDim2.new(0.05, -8, 0.2, -8)
border.BackgroundColor3 = Color3.fromRGB(255,0,0)
border.ZIndex = 0
Instance.new("UICorner", border).CornerRadius = UDim.new(0,18)

-- 🔥 GRADIENT MÉTAL
local borderGrad = Instance.new("UIGradient")
borderGrad.Parent = border
borderGrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
	ColorSequenceKeypoint.new(0.3, Color3.fromRGB(120,0,0)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,180,180)),
	ColorSequenceKeypoint.new(0.7, Color3.fromRGB(120,0,0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0))
}

-- animation métal
task.spawn(function()
	while true do
		TweenService:Create(borderGrad, TweenInfo.new(2, Enum.EasingStyle.Linear), {
			Rotation = borderGrad.Rotation + 180
		}):Play()
		task.wait(2)
	end
end)

-- FRAME PRINCIPAL
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 340, 0, 420)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(10,10,15)
frame.Active = true
frame.ZIndex = 1
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

-- TOP BAR
local top = Instance.new("Frame")
top.Parent = frame
top.Size = UDim2.new(1,0,0,45)
top.BackgroundColor3 = Color3.fromRGB(15,15,25)
Instance.new("UICorner", top).CornerRadius = UDim.new(0,14)

-- 🟥 TEXTE MÉTAL
local title = Instance.new("TextLabel")
title.Parent = top
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "FINDER"
title.Font = Enum.Font.GothamBlack
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255,60,60)

local textGrad = Instance.new("UIGradient")
textGrad.Parent = title
textGrad.Color = borderGrad.Color

-- sync animation
task.spawn(function()
	while true do
		textGrad.Rotation = borderGrad.Rotation
		task.wait()
	end
end)

-- 🔘 BOUTONS
local function createBtn(text, index)
	local b = Instance.new("TextButton")
	b.Parent = top
	b.Size = UDim2.new(0,36,0,30)
	b.Position = UDim2.new(1, -(index * 42), 0.5, -15)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(30,30,40)
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.GothamBold
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
	return b
end

local close = createBtn("X",1)
local mini = createBtn("-",2)

-- ACTIONS
close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- MINI ICON
local miniIcon = Instance.new("TextButton")
miniIcon.Parent = gui
miniIcon.Size = UDim2.new(0,40,0,40)
miniIcon.Position = UDim2.new(1,-50,0.5,0)
miniIcon.Text = "■"
miniIcon.Visible = false
miniIcon.BackgroundColor3 = Color3.fromRGB(20,20,30)

mini.MouseButton1Click:Connect(function()
	frame.Visible = false
	border.Visible = false
	miniIcon.Visible = true
end)

miniIcon.MouseButton1Click:Connect(function()
	frame.Visible = true
	border.Visible = true
	miniIcon.Visible = false
end)

-- DRAG
local dragging = false
local dragStart, startPos

top.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart

		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)

		border.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X - 8,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y - 8
		)
	end
end)
