local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local VALID_KEY = "VNHubKeyKsbskwoLsjekLapqowjebJabwnkwejoJwkwo"
local GET_KEY_LINK = "https://link4m.net/nmIQrba"
local SCRIPT_URL = "https://auradt.site/script=vnhub.lua"
local CACHE_FILE = "VNHub_SavedKeyCache.json"
local CACHE_DURATION = 86400

local function loadMainScript()
	local ok, err = pcall(function()
		loadstring(game:HttpGet(SCRIPT_URL))()
	end)
	if not ok then
		warn("[VN Hub] Failed to load main script: " .. tostring(err))
	end
end

local function getSavedKeyData()
	if not (isfile and readfile) then return nil end
	local ok, raw = pcall(readfile, CACHE_FILE)
	if not ok or not raw then return nil end
	local decodedOk, data = pcall(function()
		return HttpService:JSONDecode(raw)
	end)
	if decodedOk and type(data) == "table" and type(data.key) == "string" and type(data.savedAt) == "number" then
		if os.time() - data.savedAt <= CACHE_DURATION then
			return data
		end
	end
	return nil
end

local function saveKeyCache(keyValue)
	if not writefile then return end
	pcall(function()
		writefile(CACHE_FILE, HttpService:JSONEncode({
			key = keyValue,
			savedAt = os.time()
		}))
	end)
end

local cached = getSavedKeyData()
if cached and cached.key == VALID_KEY then
	loadMainScript()
	return
end

local parentGui = CoreGui
pcall(function()
	if gethui then
		parentGui = gethui()
	end
end)

local existing = parentGui:FindFirstChild("VNHubKeySystemGui")
if existing then
	existing:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VNHubKeySystemGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = parentGui

-- Main Glassmorphic Ocean Blue Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 370, 0, 236)
MainFrame.Position = UDim2.new(0.5, -185, 0.5, -118)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 22, 36)
MainFrame.BackgroundTransparency = 0.24
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 48, 74)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 28, 46)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 18, 32))
})
MainGradient.Rotation = 135
MainGradient.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(56, 189, 248)
MainStroke.Transparency = 0.28
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local StrokeGradient = Instance.new("UIGradient")
StrokeGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(125, 211, 252)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(14, 165, 233)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(2, 132, 199))
})
StrokeGradient.Rotation = 45
StrokeGradient.Parent = MainStroke

-- Top Glow Accent Bar
local TopGlow = Instance.new("Frame")
TopGlow.Name = "TopGlow"
TopGlow.Size = UDim2.new(0.45, 0, 0, 2)
TopGlow.Position = UDim2.new(0.275, 0, 0, 0)
TopGlow.BackgroundColor3 = Color3.fromRGB(125, 211, 252)
TopGlow.BackgroundTransparency = 0.15
TopGlow.BorderSizePixel = 0
TopGlow.Parent = MainFrame

local TopGlowCorner = Instance.new("UICorner")
TopGlowCorner.CornerRadius = UDim.new(1, 0)
TopGlowCorner.Parent = TopGlow

-- Title (VN Hub)
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -36, 0, 30)
TitleLabel.Position = UDim2.new(0, 18, 0, 12)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.FredokaOne
TitleLabel.Text = "VN Hub"
TitleLabel.TextColor3 = Color3.fromRGB(240, 249, 255)
TitleLabel.TextSize = 23
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.Parent = MainFrame

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(125, 211, 252))
})
TitleGradient.Rotation = 90
TitleGradient.Parent = TitleLabel

-- Subtitle Below Title (English)
local SubtitleLabel = Instance.new("TextLabel")
SubtitleLabel.Name = "SubtitleLabel"
SubtitleLabel.Size = UDim2.new(1, -36, 0, 18)
SubtitleLabel.Position = UDim2.new(0, 18, 0, 42)
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Font = Enum.Font.GothamMedium
SubtitleLabel.Text = "Please Enter The Correct Key Here"
SubtitleLabel.TextColor3 = Color3.fromRGB(148, 210, 245)
SubtitleLabel.TextSize = 11.5
SubtitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Center
SubtitleLabel.Parent = MainFrame

-- Key Input Field (Zero Default Focus Border)
local InputFrame = Instance.new("Frame")
InputFrame.Name = "InputFrame"
InputFrame.Size = UDim2.new(1, -36, 0, 42)
InputFrame.Position = UDim2.new(0, 18, 0, 68)
InputFrame.BackgroundColor3 = Color3.fromRGB(9, 27, 45)
InputFrame.BackgroundTransparency = 0.25
InputFrame.BorderSizePixel = 0
InputFrame.ClipsDescendants = true
InputFrame.Parent = MainFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 11)
InputCorner.Parent = InputFrame

local InputStroke = Instance.new("UIStroke")
InputStroke.Color = Color3.fromRGB(56, 189, 248)
InputStroke.Transparency = 0.52
InputStroke.Thickness = 1.2
InputStroke.Parent = InputFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Name = "KeyBox"
KeyBox.Size = UDim2.new(1, -24, 1, 0)
KeyBox.Position = UDim2.new(0, 12, 0, 0)
KeyBox.BackgroundTransparency = 1
KeyBox.BorderSizePixel = 0
KeyBox.ClearTextOnFocus = false
KeyBox.Font = Enum.Font.GothamMedium
KeyBox.PlaceholderText = "Paste key here..."
KeyBox.PlaceholderColor3 = Color3.fromRGB(125, 165, 195)
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(240, 249, 255)
KeyBox.TextSize = 13
KeyBox.TextXAlignment = Enum.TextXAlignment.Center
KeyBox.TextTruncate = Enum.TextTruncate.AtEnd
KeyBox.Parent = InputFrame

KeyBox.Focused:Connect(function()
	TweenService:Create(InputStroke, TweenInfo.new(0.2), {
		Color = Color3.fromRGB(125, 211, 252),
		Transparency = 0.15
	}):Play()
end)

KeyBox.FocusLost:Connect(function()
	TweenService:Create(InputStroke, TweenInfo.new(0.2), {
		Color = Color3.fromRGB(56, 189, 248),
		Transparency = 0.52
	}):Play()
end)

-- Action Buttons Row (Side-by-Side, Clean Margins)
local ButtonRow = Instance.new("Frame")
ButtonRow.Name = "ButtonRow"
ButtonRow.Size = UDim2.new(1, -36, 0, 42)
ButtonRow.Position = UDim2.new(0, 18, 0, 120)
ButtonRow.BackgroundTransparency = 1
ButtonRow.Parent = MainFrame

local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Name = "GetKeyButton"
GetKeyBtn.Size = UDim2.new(0.48, 0, 1, 0)
GetKeyBtn.Position = UDim2.new(0, 0, 0, 0)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(16, 48, 76)
GetKeyBtn.BackgroundTransparency = 0.2
GetKeyBtn.BorderSizePixel = 0
GetKeyBtn.AutoButtonColor = false
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.Text = "Get Key"
GetKeyBtn.TextColor3 = Color3.fromRGB(224, 242, 254)
GetKeyBtn.TextSize = 13
GetKeyBtn.Parent = ButtonRow

local GetKeyCorner = Instance.new("UICorner")
GetKeyCorner.CornerRadius = UDim.new(0, 11)
GetKeyCorner.Parent = GetKeyBtn

local GetKeyStroke = Instance.new("UIStroke")
GetKeyStroke.Color = Color3.fromRGB(56, 189, 248)
GetKeyStroke.Transparency = 0.45
GetKeyStroke.Thickness = 1.1
GetKeyStroke.Parent = GetKeyBtn

local CheckKeyBtn = Instance.new("TextButton")
CheckKeyBtn.Name = "CheckKeyButton"
CheckKeyBtn.Size = UDim2.new(0.48, 0, 1, 0)
CheckKeyBtn.Position = UDim2.new(0.52, 0, 0, 0)
CheckKeyBtn.BackgroundColor3 = Color3.fromRGB(14, 165, 233)
CheckKeyBtn.BackgroundTransparency = 0.08
CheckKeyBtn.BorderSizePixel = 0
CheckKeyBtn.AutoButtonColor = false
CheckKeyBtn.Font = Enum.Font.GothamBold
CheckKeyBtn.Text = "Check Key"
CheckKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CheckKeyBtn.TextSize = 13
CheckKeyBtn.Parent = ButtonRow

local CheckKeyCorner = Instance.new("UICorner")
CheckKeyCorner.CornerRadius = UDim.new(0, 11)
CheckKeyCorner.Parent = CheckKeyBtn

local CheckKeyGradient = Instance.new("UIGradient")
CheckKeyGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(56, 189, 248)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(2, 132, 199))
})
CheckKeyGradient.Rotation = 90
CheckKeyGradient.Parent = CheckKeyBtn

-- Notification Banner Placed Below Get Key & Check Key Buttons
local Banner = Instance.new("Frame")
Banner.Name = "NotificationBanner"
Banner.Size = UDim2.new(1, -36, 0, 30)
Banner.Position = UDim2.new(0, 18, 0, 174)
Banner.BackgroundColor3 = Color3.fromRGB(14, 42, 66)
Banner.BackgroundTransparency = 0.35
Banner.BorderSizePixel = 0
Banner.Parent = MainFrame

local BannerCorner = Instance.new("UICorner")
BannerCorner.CornerRadius = UDim.new(0, 9)
BannerCorner.Parent = Banner

local BannerStroke = Instance.new("UIStroke")
BannerStroke.Color = Color3.fromRGB(56, 189, 248)
BannerStroke.Transparency = 0.65
BannerStroke.Thickness = 1
BannerStroke.Parent = Banner

local BannerLabel = Instance.new("TextLabel")
BannerLabel.Size = UDim2.new(1, -14, 1, 0)
BannerLabel.Position = UDim2.new(0, 7, 0, 0)
BannerLabel.BackgroundTransparency = 1
BannerLabel.Font = Enum.Font.GothamMedium
BannerLabel.Text = "Waiting for key verification..."
BannerLabel.TextColor3 = Color3.fromRGB(186, 230, 253)
BannerLabel.TextSize = 12
BannerLabel.TextTruncate = Enum.TextTruncate.AtEnd
BannerLabel.TextXAlignment = Enum.TextXAlignment.Center
BannerLabel.Parent = Banner

local function setBanner(text, textColor, bgColor, strokeColor)
	BannerLabel.Text = text
	TweenService:Create(BannerLabel, TweenInfo.new(0.2), { TextColor3 = textColor }):Play()
	TweenService:Create(Banner, TweenInfo.new(0.2), { BackgroundColor3 = bgColor }):Play()
	TweenService:Create(BannerStroke, TweenInfo.new(0.2), { Color = strokeColor }):Play()
end

-- Subtle Hover Feedback
GetKeyBtn.MouseEnter:Connect(function()
	TweenService:Create(GetKeyBtn, TweenInfo.new(0.18), { BackgroundTransparency = 0.05 }):Play()
end)
GetKeyBtn.MouseLeave:Connect(function()
	TweenService:Create(GetKeyBtn, TweenInfo.new(0.18), { BackgroundTransparency = 0.2 }):Play()
end)

CheckKeyBtn.MouseEnter:Connect(function()
	TweenService:Create(CheckKeyBtn, TweenInfo.new(0.18), { BackgroundTransparency = 0 }):Play()
end)
CheckKeyBtn.MouseLeave:Connect(function()
	TweenService:Create(CheckKeyBtn, TweenInfo.new(0.18), { BackgroundTransparency = 0.08 }):Play()
end)

-- Smooth Drag Support
local dragging = false
local dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- Ultra-Smooth Damped Spring Shake on Invalid Key
local isShaking = false

local function playSmoothErrorShake()
	if isShaking then return end
	isShaking = true

	local originPos = MainFrame.Position
	KeyBox.Text = ""

	setBanner(
		"Invalid key! Please try again.",
		Color3.fromRGB(254, 165, 165),
		Color3.fromRGB(69, 20, 28),
		Color3.fromRGB(248, 113, 113)
	)

	TweenService:Create(
		InputStroke,
		TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
		{ Color = Color3.fromRGB(248, 113, 113), Transparency = 0.1 }
	):Play()

	local keyframes = {
		{ offset = -8, duration = 0.055 },
		{ offset = 8,  duration = 0.065 },
		{ offset = -6, duration = 0.065 },
		{ offset = 5,  duration = 0.065 },
		{ offset = -3, duration = 0.065 },
		{ offset = 2,  duration = 0.060 },
		{ offset = 0,  duration = 0.065 }
	}

	for _, step in ipairs(keyframes) do
		local tween = TweenService:Create(
			MainFrame,
			TweenInfo.new(step.duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
			{ Position = UDim2.new(originPos.X.Scale, originPos.X.Offset + step.offset, originPos.Y.Scale, originPos.Y.Offset) }
		)
		tween:Play()
		tween.Completed:Wait()
	end

	MainFrame.Position = originPos

	task.delay(1.1, function()
		TweenService:Create(
			InputStroke,
			TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
			{ Color = Color3.fromRGB(56, 189, 248), Transparency = 0.52 }
		):Play()
	end)

	isShaking = false
end

-- Button Actions (Manual Click Verification Only)
GetKeyBtn.MouseButton1Click:Connect(function()
	local copied = false
	if setclipboard then
		pcall(function()
			setclipboard(GET_KEY_LINK)
			copied = true
		end)
	end

	if copied then
		setBanner(
			"Key link copied to clipboard!",
			Color3.fromRGB(125, 211, 252),
			Color3.fromRGB(12, 48, 76),
			Color3.fromRGB(56, 189, 248)
		)
	else
		setBanner(
			"Clipboard unavailable on this executor.",
			Color3.fromRGB(253, 224, 130),
			Color3.fromRGB(58, 44, 16),
			Color3.fromRGB(250, 204, 21)
		)
	end
end)

CheckKeyBtn.MouseButton1Click:Connect(function()
	local enteredKey = string.gsub(KeyBox.Text or "", "^%s*(.-)%s*$", "%1")
	if enteredKey == VALID_KEY then
		saveKeyCache(enteredKey)
		setBanner(
			"Key verified! Loading VN Hub...",
			Color3.fromRGB(134, 239, 172),
			Color3.fromRGB(14, 54, 42),
			Color3.fromRGB(52, 211, 153)
		)

		local fadeTween = TweenService:Create(
			MainFrame,
			TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 350, 0, 218),
				Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset + 10, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset + 9)
			}
		)
		fadeTween:Play()
		task.wait(0.3)
		ScreenGui:Destroy()
		loadMainScript()
	else
		playSmoothErrorShake()
	end
end)
