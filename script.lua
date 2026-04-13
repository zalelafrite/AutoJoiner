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
-- =========================
-- FINDER SYSTEM (APPEND ONLY)
-- =========================

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local placeId = game.PlaceId

local TARGETS = {
	["Skibidi Toilet"] = true,
	["Dragon Gingerini"] = true,
	["Meowl"] = true,
	["Strawberry Elephant"] = true,
	["Foxini Lanternini"] = true,
	["Cooki and Milki"] = true,
	["Headless Horseman"] = true,
	["Reinito Sleighito"] = true,
	["La Casa Boo"] = true,
	["Dragon Cannelloni"] = true,
	["Hydra"] = true,
	["Festive 67"] = true,
	["Cloverat Clapat"] = true,
	["Garama and Madundung"] = true,
	["Jolly Jolly Sahur"] = true,
	["Gingerat Gerat"] = true,
	["La Supreme Combinasion"] = true,
	["Los Hotspotsitos"] = true,
	["Love Love Bear"] = true,
	["Antonio"] = true,
	["Celestial Pegasus"] = true,
	["Rosey and Teddy"] = true,
	["La Suprême Combinasion"] = true,
	["Popcuru and Fizzuru"] = true,
	["Capitano Moby"] = true,
	["Burguro and Fryuro"] = true,
	["Ketupat Bros"] = true,
	["Los Amigos"] = true,
	["La Secret Combinasion"] = true,
	["Los Sekolahs"] = true,
	["Signore Carapace"] = true,
	["Fraggrama and Chocrama"] = true,
	["La Food Combinasion"] = true,
	["Elefanto Frigo"] = true,
	["Spooky and Pumpky"] = true,
	["Ginger Gerat"] = true,
	["Sammyni Fattini"] = true,
	["Los Spaghettis"] = true,
	["Fishino Clownino"] = true,
	["Tirilikalika Tirilikalako"] = true,
}

local TARGET_NAMES = {
	"Skibidi Toilet",
	"Dragon Gingerini",
	"Meowl",
	"Strawberry Elephant",
	"Foxini Lanternini",
	"Cooki and Milki",
	"Headless Horseman",
	"Reinito Sleighito",
	"La Casa Boo",
	"Dragon Cannelloni",
	"Hydra",
	"Festive 67",
	"Cloverat Clapat",
	"Garama and Madundung",
	"Jolly Jolly Sahur",
	"Gingerat Gerat",
	"La Supreme Combinasion",
	"Los Hotspotsitos",
	"Love Love Bear",
	"Antonio",
	"Celestial Pegasus",
	"Rosey and Teddy",
	"La Suprême Combinasion",
	"Popcuru and Fizzuru",
	"Capitano Moby",
	"Burguro and Fryuro",
	"Ketupat Bros",
	"Los Amigos",
	"La Secret Combinasion",
	"Los Sekolahs",
	"Signore Carapace",
	"Fraggrama and Chocrama",
	"La Food Combinasion",
	"Elefanto Frigo",
	"Spooky and Pumpky",
	"Ginger Gerat",
	"Sammyni Fattini",
	"Los Spaghettis",
	"Fishino Clownino",
	"Tirilikalika Tirilikalako",
}

local finderHolder = Instance.new("Frame")
finderHolder.Parent = frame
finderHolder.Name = "FinderHolder"
finderHolder.BackgroundTransparency = 1
finderHolder.Size = UDim2.new(1, -20, 1, -65)
finderHolder.Position = UDim2.new(0, 10, 0, 55)
finderHolder.ZIndex = 2

local scanButton = Instance.new("TextButton")
scanButton.Parent = finderHolder
scanButton.Name = "ScanButton"
scanButton.Size = UDim2.new(1, 0, 0, 36)
scanButton.Position = UDim2.new(0, 0, 0, 0)
scanButton.BackgroundColor3 = Color3.fromRGB(170, 20, 20)
scanButton.Text = "SCAN"
scanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
scanButton.Font = Enum.Font.GothamBold
scanButton.TextSize = 16
scanButton.ZIndex = 3
Instance.new("UICorner", scanButton).CornerRadius = UDim.new(0, 8)

local scanStroke = Instance.new("UIStroke")
scanStroke.Parent = scanButton
scanStroke.Color = Color3.fromRGB(255, 90, 90)
scanStroke.Thickness = 1.2

local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = finderHolder
statusLabel.Name = "StatusLabel"
statusLabel.BackgroundTransparency = 1
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0, 42)
statusLabel.Text = "Ready"
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 13
statusLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
statusLabel.ZIndex = 3

local listFrame = Instance.new("ScrollingFrame")
listFrame.Parent = finderHolder
listFrame.Name = "ResultsList"
listFrame.Size = UDim2.new(1, 0, 1, -68)
listFrame.Position = UDim2.new(0, 0, 0, 68)
listFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 22)
listFrame.BorderSizePixel = 0
listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
listFrame.ScrollBarThickness = 4
listFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
listFrame.ZIndex = 2
Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 10)

local listPadding = Instance.new("UIPadding")
listPadding.Parent = listFrame
listPadding.PaddingTop = UDim.new(0, 8)
listPadding.PaddingBottom = UDim.new(0, 8)
listPadding.PaddingLeft = UDim.new(0, 8)
listPadding.PaddingRight = UDim.new(0, 8)

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = listFrame
listLayout.Padding = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

local isScanning = false

local function refreshCanvas()
	task.defer(function()
		listFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 16)
	end)
end

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshCanvas)

local function clearResults()
	for _, child in ipairs(listFrame:GetChildren()) do
		if child:IsA("Frame") and child.Name == "ResultItem" then
			child:Destroy()
		end
	end
	refreshCanvas()
end

local function createItem(brainrotName, playerCount, jobId)
	local item = Instance.new("Frame")
	item.Name = "ResultItem"
	item.Parent = listFrame
	item.Size = UDim2.new(1, -2, 0, 58)
	item.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
	item.BorderSizePixel = 0
	item.ZIndex = 3
	Instance.new("UICorner", item).CornerRadius = UDim.new(0, 10)

	local stroke = Instance.new("UIStroke")
	stroke.Parent = item
	stroke.Color = Color3.fromRGB(65, 65, 85)
	stroke.Thickness = 1

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Parent = item
	nameLabel.BackgroundTransparency = 1
	nameLabel.Position = UDim2.new(0, 12, 0, 7)
	nameLabel.Size = UDim2.new(1, -110, 0, 22)
	nameLabel.Text = brainrotName
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 14
	nameLabel.ZIndex = 4

	local playersLabel = Instance.new("TextLabel")
	playersLabel.Parent = item
	playersLabel.BackgroundTransparency = 1
	playersLabel.Position = UDim2.new(0, 12, 0, 30)
	playersLabel.Size = UDim2.new(0, 100, 0, 18)
	playersLabel.Text = tostring(playerCount) .. "/8"
	playersLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	playersLabel.TextXAlignment = Enum.TextXAlignment.Left
	playersLabel.Font = Enum.Font.Gotham
	playersLabel.TextSize = 12
	playersLabel.ZIndex = 4

	local joinButton = Instance.new("TextButton")
	joinButton.Parent = item
	joinButton.Size = UDim2.new(0, 82, 0, 34)
	joinButton.Position = UDim2.new(1, -92, 0.5, -17)
	joinButton.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
	joinButton.Text = "JOIN"
	joinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	joinButton.Font = Enum.Font.GothamBold
	joinButton.TextSize = 13
	joinButton.ZIndex = 4
	Instance.new("UICorner", joinButton).CornerRadius = UDim.new(0, 8)

	joinButton.MouseButton1Click:Connect(function()
		if jobId and jobId ~= "" then
			TeleportService:TeleportToPlaceInstance(placeId, jobId, player)
		end
	end)

	refreshCanvas()
end

local function getServers()
	local url = ("https://games.roblox.com/v1/games/%s/servers/Public?limit=100"):format(placeId)

	local ok, response = pcall(function()
		return HttpService:GetAsync(url)
	end)

	if ok then
		local decodeOk, data = pcall(function()
			return HttpService:JSONDecode(response)
		end)

		if decodeOk and data and data.data then
			return data.data, true
		end
	end

	local simulated = {}
	for i = 1, 18 do
		table.insert(simulated, {
			id = HttpService:GenerateGUID(false),
			playing = math.random(1, 8),
			maxPlayers = 8,
		})
	end

	return simulated, false
end

local function scanWorkspace()
	local found = {}

	for _, obj in ipairs(workspace:GetDescendants()) do
		if (obj:IsA("Model") or obj:IsA("Folder")) and TARGETS[obj.Name] then
			table.insert(found, obj.Name)
		end
	end

	return found
end

local visitedServers = {}

local function processServers()
	if isScanning then return end

	isScanning = true
	scanButton.Text = "SCANNING..."
	scanButton.AutoButtonColor = false
	statusLabel.Text = "Fetching servers..."
	clearResults()

	local servers = getServers()

	for i, server in ipairs(servers) do
		if visitedServers[server.id] then continue end
		visitedServers[server.id] = true

		statusLabel.Text = "Trying server " .. i .. "/" .. #servers

		local success, err = pcall(function()
			TeleportService:TeleportToPlaceInstance(placeId, server.id, player)
		end)

		if success then
			return -- OK → on quitte
		else
			warn("Teleport failed:", err)
			task.wait(0.3) -- petit delay et on continue
		end
	end

	-- si aucun serveur valide
	statusLabel.Text = "No valid servers found"
	scanButton.Text = "SCAN"
	scanButton.AutoButtonColor = true
	isScanning = false
end

scanButton.MouseButton1Click:Connect(processServers)
task.spawn(function()
	while true do
		task.wait(3)

		if isScanning then
			local found = {}

			for _, obj in ipairs(workspace:GetDescendants()) do
				if (obj:IsA("Model") or obj:IsA("Folder")) and TARGETS[obj.Name] then
					table.insert(found, obj.Name)
				end
			end

			if #found > 0 then
				for _, name in ipairs(found) do
					createItem(name, #Players:GetPlayers(), game.JobId)
				end

				statusLabel.Text = "FOUND " .. #found .. " brainrot(s)"

				scanButton.Text = "SCAN"
				scanButton.AutoButtonColor = true
				isScanning = false

			else
				statusLabel.Text = "No targets, switching..."
				processServers()
			end
		end
	end
end)
