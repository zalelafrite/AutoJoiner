local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Parent = player.PlayerGui
gui.ResetOnSpawn = false

-- CONTOUR
local border = Instance.new("Frame", gui)
border.Size = UDim2.new(0,356,0,436)
border.Position = UDim2.new(0.05,-8,0.2,-8)
border.BackgroundColor3 = Color3.fromRGB(255,0,0)
border.ZIndex = 0
Instance.new("UICorner", border)

local grad = Instance.new("UIGradient", border)
grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,180,180)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0))
}

task.spawn(function()
	while true do
		TweenService:Create(grad, TweenInfo.new(2), {Rotation = grad.Rotation + 180}):Play()
		task.wait(2)
	end
end)

-- FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,340,0,420)
frame.Position = UDim2.new(0.05,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(10,10,15)
frame.ZIndex = 1
Instance.new("UICorner", frame)

-- TOP
local top = Instance.new("Frame", frame)
top.Size = UDim2.new(1,0,0,45)
top.BackgroundColor3 = Color3.fromRGB(15,15,25)
Instance.new("UICorner", top)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "FINDER"
title.Font = Enum.Font.GothamBlack
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255,60,60)

-- DRAG FIX
local dragging = false
local dragStart, startPos

top.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

top.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		border.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X - 8, startPos.Y.Scale, startPos.Y.Offset + delta.Y - 8)
	end
end)

-- SCROLL
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1,-10,1,-110)
scroll.Position = UDim2.new(0,5,0,50)
scroll.BackgroundTransparency = 1
scroll.ZIndex = 1
scroll.CanvasSize = UDim2.new(0,0,0,0)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,6)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
end)

-- 🔥 SCAN BUTTON (AU DESSUS)
local scanBtn = Instance.new("TextButton", frame)
scanBtn.Size = UDim2.new(1,-20,0,40)
scanBtn.Position = UDim2.new(0,10,1,-45)
scanBtn.Text = "SCAN"
scanBtn.BackgroundColor3 = Color3.fromRGB(200,60,60)
scanBtn.TextColor3 = Color3.new(1,1,1)
scanBtn.Font = Enum.Font.GothamBold
scanBtn.ZIndex = 5 -- IMPORTANT
Instance.new("UICorner", scanBtn)

-- CLEAR
local function clear()
	for _,v in ipairs(scroll:GetChildren()) do
		if v:IsA("Frame") then v:Destroy() end
	end
end

-- ITEM
local function createItem(s)
	local item = Instance.new("Frame", scroll)
	item.Size = UDim2.new(1,-10,0,55)
	item.BackgroundColor3 = Color3.fromRGB(20,20,30)
	Instance.new("UICorner", item)

	local txt = Instance.new("TextLabel", item)
	txt.Size = UDim2.new(0.6,0,1,0)
	txt.BackgroundTransparency = 1
	txt.Text = s.playing.."/"..s.maxPlayers
	txt.TextColor3 = Color3.new(1,1,1)

	local join = Instance.new("TextButton", item)
	join.Size = UDim2.new(0,80,0,35)
	join.Position = UDim2.new(1,-90,0.5,-17)
	join.Text = "JOIN"
	join.BackgroundColor3 = Color3.fromRGB(60,200,120)
	Instance.new("UICorner", join)

	join.MouseButton1Click:Connect(function()
		print("JOIN:", s.id)
		if s.playing < s.maxPlayers then
			TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, player)
		end
	end)
end

-- GET SERVERS
local function getServers()
	local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"
	local ok, res = pcall(function()
		return HttpService:GetAsync(url)
	end)
	if not ok then return {} end

	local data = HttpService:JSONDecode(res)
	return data.data or {}
end

-- SCAN
local function scan()
	print("SCAN CLICKED")

	clear()

	local servers = getServers()
	print("SERVERS:", #servers)

	for _,s in ipairs(servers) do
		if s.id ~= game.JobId then
			createItem(s)
		end
	end
end

scanBtn.MouseButton1Click:Connect(scan)
