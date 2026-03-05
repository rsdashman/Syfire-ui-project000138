--[[
	NovaUI Library — Rebuilt over Orion Base
	Visual redesign: glassmorphism, smooth animations, glow effects, tab indicators
	All original functions preserved and compatible.
--]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")

local TemporaryRoles = {
	[8730679277] = "Developer"
}

local PARENT = game:GetService("CoreGui")

local OrionLib = {
	Elements = {},
	ThemeObjects = {},
	Connections = {},
	Flags = {},
	FavoriteEvent = Instance.new("BindableEvent"),
	Themes = {
		Default = {
			Main      = Color3.fromRGB(12, 12, 18),
			Second    = Color3.fromRGB(18, 18, 28),
			Stroke    = Color3.fromRGB(80, 60, 140),
			Divider   = Color3.fromRGB(100, 80, 180),
			Text      = Color3.fromRGB(240, 240, 255),
			TextDark  = Color3.fromRGB(140, 120, 200),
			Accent    = Color3.fromRGB(120, 80, 220),
			AccentDark= Color3.fromRGB(70, 40, 140),
			Surface   = Color3.fromRGB(22, 22, 36),
			Glow      = Color3.fromRGB(100, 60, 200),
		}
	},
	SelectedTheme = "Default",
	Folder = nil,
	SaveCfg = false
}

-- ─── Icons ────────────────────────────────────────────────────────────────────
local Icons = {}
local Success, Response = pcall(function()
	Icons = HttpService:JSONDecode(game:HttpGetAsync(
		"https://raw.githubusercontent.com/frappedevs/lucideblox/refs/heads/master/src/modules/util/icons.json"
	)).icons
end)
if not Success then
	warn("\nNova Library - Failed to load icons. Error: " .. Response .. "\n")
end

local function GetIcon(IconName)
	return Icons[IconName] or nil
end

-- ─── ScreenGui ────────────────────────────────────────────────────────────────
local Orion = Instance.new("ScreenGui")
Orion.Name = "NovaUI"
Orion.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Orion.Parent = PARENT

for _, Interface in ipairs(PARENT:GetChildren()) do
	if Interface.Name == Orion.Name and Interface ~= Orion then
		Interface:Destroy()
	end
end

-- ─── Utility ──────────────────────────────────────────────────────────────────
function OrionLib:IsRunning()
	return Orion.Parent == PARENT
end

local function AddConnection(Signal, Function)
	if not OrionLib:IsRunning() then return end
	local c = Signal:Connect(Function)
	table.insert(OrionLib.Connections, c)
	return c
end

task.spawn(function()
	while OrionLib:IsRunning() do wait() end
	for _, c in next, OrionLib.Connections do c:Disconnect() end
end)

local function MakeDraggable(DragPoint, Main)
	local Dragging, DragInput, MousePos, FramePos = false
	AddConnection(DragPoint.InputBegan, function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			Dragging = true
			MousePos = Input.Position
			FramePos = Main.Position
			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)
	AddConnection(DragPoint.InputChanged, function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement then
			DragInput = Input
		end
	end)
	AddConnection(UserInputService.InputChanged, function(Input)
		if Input == DragInput and Dragging then
			local Delta = Input.Position - MousePos
			Main.Position = UDim2.new(
				FramePos.X.Scale, FramePos.X.Offset + Delta.X,
				FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y
			)
		end
	end)
end

local function Create(Name, Properties, Children)
	local Object = Instance.new(Name)
	for i, v in next, Properties or {} do Object[i] = v end
	for _, v in next, Children or {} do v.Parent = Object end
	return Object
end

local function CreateElement(Name, Fn)
	OrionLib.Elements[Name] = function(...) return Fn(...) end
end

local function AddItemTable(Table, Item, Value)
	local key = tostring(Item)
	local count = 1
	while Table[key] do
		count += 1
		key = string.format('%s-%d', Item, count)
	end
	Table[key] = Value
end

local function MakeElement(Name, ...)
	return OrionLib.Elements[Name](...)
end

local function SetProps(Element, Props)
	table.foreach(Props, function(p, v) Element[p] = v end)
	return Element
end

local function SetChildren(Element, Children)
	table.foreach(Children, function(_, c) c.Parent = Element end)
	return Element
end

local function Round(Number, Factor)
	local r = math.floor(Number / Factor + math.sign(Number) * 0.5) * Factor
	if r < 0 then r = r + Factor end
	return r
end

local function ReturnProperty(Object)
	if Object:IsA("Frame") or Object:IsA("TextButton") then return "BackgroundColor3" end
	if Object:IsA("ScrollingFrame") then return "ScrollBarImageColor3" end
	if Object:IsA("UIStroke") then return "Color" end
	if Object:IsA("TextLabel") or Object:IsA("TextBox") then return "TextColor3" end
	if Object:IsA("ImageLabel") or Object:IsA("ImageButton") then return "ImageColor3" end
end

local function AddThemeObject(Object, Type)
	if not OrionLib.ThemeObjects[Type] then OrionLib.ThemeObjects[Type] = {} end
	table.insert(OrionLib.ThemeObjects[Type], Object)
	Object[ReturnProperty(Object)] = OrionLib.Themes[OrionLib.SelectedTheme][Type]
	return Object
end

local function SetTheme()
	for Name, Type in pairs(OrionLib.ThemeObjects) do
		for _, Object in pairs(Type) do
			Object[ReturnProperty(Object)] = OrionLib.Themes[OrionLib.SelectedTheme][Name]
		end
	end
end

local function PackColor(Color)
	return {R = Color.R * 255, G = Color.G * 255, B = Color.B * 255}
end

local function UnpackColor(Color)
	return Color3.fromRGB(Color.R, Color.G, Color.B)
end

local function LoadCfg(Config)
	local Data = HttpService:JSONDecode(Config)
	table.foreach(Data, function(a, b)
		if OrionLib.Flags[a] then
			spawn(function()
				if OrionLib.Flags[a].Type == "Colorpicker" then
					OrionLib.Flags[a]:Set(UnpackColor(b))
				else
					OrionLib.Flags[a]:Set(b)
				end
			end)
		else
			warn("Nova Config Loader - Could not find ", a, b)
		end
	end)
end

local function SaveCfg(Name)
	local Data = {}
	for i, v in pairs(OrionLib.Flags) do
		if v.Save then
			Data[i] = v.Type == "Colorpicker" and PackColor(v.Value) or v.Value
		end
	end
	if writefile then
		writefile(OrionLib.Folder .. "/" .. Name .. ".txt", HttpService:JSONEncode(Data))
	end
end

local WhitelistedMouse  = {Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseButton3}
local BlacklistedKeys   = {Enum.KeyCode.Unknown, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D,
	Enum.KeyCode.Up, Enum.KeyCode.Left, Enum.KeyCode.Down, Enum.KeyCode.Right,
	Enum.KeyCode.Slash, Enum.KeyCode.Tab, Enum.KeyCode.Backspace, Enum.KeyCode.Escape}

local function CheckKey(Table, Key)
	for _, v in next, Table do if v == Key then return true end end
end

-- ─── Base Elements ────────────────────────────────────────────────────────────
CreateElement("Corner", function(Scale, Offset)
	return Create("UICorner", {CornerRadius = UDim.new(Scale or 0, Offset or 10)})
end)

CreateElement("Stroke", function(Color, Thickness)
	return Create("UIStroke", {Color = Color or Color3.fromRGB(255,255,255), Thickness = Thickness or 1})
end)

CreateElement("List", function(Scale, Offset)
	return Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(Scale or 0, Offset or 0)})
end)

CreateElement("Padding", function(Bottom, Left, Right, Top)
	return Create("UIPadding", {
		PaddingBottom = UDim.new(0, Bottom or 4),
		PaddingLeft   = UDim.new(0, Left   or 4),
		PaddingRight  = UDim.new(0, Right  or 4),
		PaddingTop    = UDim.new(0, Top    or 4),
	})
end)

CreateElement("TFrame", function()
	return Create("Frame", {BackgroundTransparency = 1})
end)

CreateElement("Frame", function(Color)
	return Create("Frame", {BackgroundColor3 = Color or Color3.fromRGB(255,255,255), BorderSizePixel = 0})
end)

CreateElement("RoundFrame", function(Color, Scale, Offset)
	return Create("Frame", {
		BackgroundColor3 = Color or Color3.fromRGB(255,255,255),
		BorderSizePixel  = 0,
	}, {
		Create("UICorner", {CornerRadius = UDim.new(Scale, Offset)})
	})
end)

CreateElement("Button", function()
	return Create("TextButton", {
		Text = "", AutoButtonColor = false,
		BackgroundTransparency = 1, BorderSizePixel = 0
	})
end)

CreateElement("ScrollFrame", function(Color, Width)
	return Create("ScrollingFrame", {
		BackgroundTransparency = 1,
		MidImage    = "rbxassetid://7445543667",
		BottomImage = "rbxassetid://7445543667",
		TopImage    = "rbxassetid://7445543667",
		ScrollBarImageColor3 = Color,
		BorderSizePixel      = 0,
		ScrollBarThickness   = Width,
		CanvasSize           = UDim2.new(0,0,0,0)
	})
end)

CreateElement("Image", function(ImageID)
	local img = Create("ImageLabel", {Image = ImageID, BackgroundTransparency = 1})
	if GetIcon(ImageID) then img.Image = GetIcon(ImageID) end
	return img
end)

CreateElement("ImageButton", function(ImageID)
	return Create("ImageButton", {Image = ImageID, BackgroundTransparency = 1})
end)

CreateElement("Label", function(Text, TextSize, Transparency)
	return Create("TextLabel", {
		Text                = Text or "",
		TextColor3          = Color3.fromRGB(240,240,240),
		TextTransparency    = Transparency or 0,
		TextSize            = TextSize or 15,
		Font                = Enum.Font.GothamSemibold,
		RichText            = true,
		BackgroundTransparency = 1,
		TextXAlignment      = Enum.TextXAlignment.Left,
	})
end)

-- ─── Helpers: glow frame & gradient accent ────────────────────────────────────
local function MakeGlowFrame(Color, Radius)
	local f = Create("ImageLabel", {
		BackgroundTransparency = 1,
		Image  = "rbxassetid://5028857084",
		ImageColor3 = Color or Color3.fromRGB(100,60,220),
		ImageTransparency = 0.6,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(24,24,276,276),
		ZIndex = 0,
	})
	return f
end

local function Tween(obj, t, props)
	TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

-- ─── Notifications ────────────────────────────────────────────────────────────
local NotificationHolder = SetProps(SetChildren(MakeElement("TFrame"), {
	SetProps(MakeElement("List"), {
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder           = Enum.SortOrder.LayoutOrder,
		VerticalAlignment   = Enum.VerticalAlignment.Bottom,
		Padding             = UDim.new(0, 8),
	})
}), {
	Position    = UDim2.new(1, -20, 1, -20),
	Size        = UDim2.new(0, 320, 1, -20),
	AnchorPoint = Vector2.new(1, 1),
	Parent      = Orion,
})

function OrionLib:MakeNotification(NotificationConfig)
	spawn(function()
		NotificationConfig.Name    = NotificationConfig.Name    or "Notification"
		NotificationConfig.Content = NotificationConfig.Content or "..."
		NotificationConfig.Image   = NotificationConfig.Image   or "rbxassetid://7743870134"
		NotificationConfig.Time    = NotificationConfig.Time    or 5

		local T = OrionLib.Themes[OrionLib.SelectedTheme]

		local Wrap = SetProps(MakeElement("TFrame"), {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = NotificationHolder,
		})

		-- accent bar left
		local AccentBar = Create("Frame", {
			Size = UDim2.new(0, 3, 1, 0),
			BackgroundColor3 = T.Accent,
			BorderSizePixel = 0,
			ZIndex = 5,
		}, { Create("UICorner", {CornerRadius = UDim.new(0, 3)}) })

		local NFrame = SetChildren(SetProps(
			Create("Frame", {
				BackgroundColor3 = T.Surface,
				BorderSizePixel  = 0,
				Size             = UDim2.new(1, 0, 0, 0),
				AutomaticSize    = Enum.AutomaticSize.Y,
				ClipsDescendants = false,
				Position         = UDim2.new(1, 20, 0, 0),
			}), {}
		), {
			Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
			Create("UIStroke", {Color = T.Stroke, Thickness = 1}),
			AccentBar,
			Create("UIPadding", {
				PaddingLeft   = UDim.new(0, 16),
				PaddingRight  = UDim.new(0, 12),
				PaddingTop    = UDim.new(0, 10),
				PaddingBottom = UDim.new(0, 10),
			}),
			SetProps(MakeElement("Image", NotificationConfig.Image), {
				Size        = UDim2.new(0, 18, 0, 18),
				Position    = UDim2.new(0, 0, 0, 0),
				ImageColor3 = T.Accent,
				Name        = "Icon",
				ZIndex      = 5,
			}),
			SetProps(MakeElement("Label", NotificationConfig.Name, 14), {
				Size     = UDim2.new(1, -26, 0, 18),
				Position = UDim2.new(0, 26, 0, 0),
				Font     = Enum.Font.GothamBold,
				Name     = "Title",
				ZIndex   = 5,
			}),
			SetProps(MakeElement("Label", NotificationConfig.Content, 13), {
				Size          = UDim2.new(1, 0, 0, 0),
				Position      = UDim2.new(0, 0, 0, 24),
				Font          = Enum.Font.Gotham,
				Name          = "Content",
				AutomaticSize = Enum.AutomaticSize.Y,
				TextColor3    = T.TextDark,
				TextWrapped   = true,
				RichText      = true,
				ZIndex        = 5,
			}),
		})
		NFrame.Parent = Wrap

		Tween(NFrame, 0.5, {Position = UDim2.new(0, 0, 0, 0)})

		wait(NotificationConfig.Time - 0.9)
		Tween(NFrame.Icon,    0.4, {ImageTransparency = 1})
		Tween(NFrame,         0.7, {BackgroundTransparency = 0.5})
		wait(0.3)
		Tween(NFrame.UIStroke, 0.6, {Transparency = 0.9})
		Tween(NFrame.Title,    0.6, {TextTransparency = 0.5})
		Tween(NFrame.Content,  0.6, {TextTransparency = 0.6})
		wait(0.1)
		NFrame:TweenPosition(UDim2.new(1, 20, 0, 0), 'In', 'Quint', 0.7, true)
		wait(1.2)
		NFrame:Destroy()
	end)
end

function OrionLib:Init()
	if OrionLib.SaveCfg and (isfile and readfile) then
		pcall(function()
			if isfile(OrionLib.Folder .. "/" .. game.GameId .. ".txt") then
				LoadCfg(readfile(OrionLib.Folder .. "/" .. game.GameId .. ".txt"))
				OrionLib:MakeNotification({
					Name    = "Configuration",
					Content = "Auto-loaded configuration for game " .. game.GameId .. ".",
					Time    = 5
				})
			end
		end)
	end
end

-- ─── Main Window ──────────────────────────────────────────────────────────────
function OrionLib:MakeWindow(WindowConfig)
	local FirstTab = true
	local Minimized = false
	local Loaded    = false
	local UIHidden  = false

	WindowConfig = WindowConfig or {}
	WindowConfig.Name          = WindowConfig.Name          or "NovaDev"
	WindowConfig.ConfigFolder  = WindowConfig.ConfigFolder  or WindowConfig.Name
	WindowConfig.SaveConfig    = WindowConfig.SaveConfig    or false
	if WindowConfig.IntroEnabled == nil then WindowConfig.IntroEnabled = true end
	WindowConfig.IntroText     = WindowConfig.IntroText     or "NovaDev"
	WindowConfig.CloseCallback = WindowConfig.CloseCallback or function() end
	WindowConfig.ShowIcon      = WindowConfig.ShowIcon      or false
	WindowConfig.Icon          = WindowConfig.Icon          or "rbxassetid://7743870134"
	WindowConfig.IntroIcon     = WindowConfig.IntroIcon     or "rbxassetid://7743870134"
	WindowConfig.SearchBar     = WindowConfig.SearchBar     or nil

	OrionLib.Folder   = WindowConfig.ConfigFolder
	OrionLib.SaveCfg  = WindowConfig.SaveConfig

	if WindowConfig.SaveConfig then
		if (isfolder and makefolder) and not isfolder(WindowConfig.ConfigFolder) then
			makefolder(WindowConfig.ConfigFolder)
		end
	end

	local T = OrionLib.Themes[OrionLib.SelectedTheme]

	-- ── Sidebar ────────────────────────────────────────────────────────────────
	-- Active tab indicator bar
	local TabIndicator = Create("Frame", {
		Size             = UDim2.new(0, 3, 0, 26),
		Position         = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = T.Accent,
		BorderSizePixel  = 0,
		ZIndex           = 10,
	}, { Create("UICorner", {CornerRadius = UDim.new(0, 3)}) })

	local TabHolder = AddThemeObject(SetChildren(SetProps(
		MakeElement("ScrollFrame", Color3.fromRGB(255,255,255), 3),
		WindowConfig.SearchBar and {
			Size     = UDim2.new(1, 0, 1, -100),
			Position = UDim2.new(0, 0, 0, 48),
		} or {
			Size     = UDim2.new(1, 0, 1, -60),
			Position = UDim2.new(0, 0, 0, 10),
		}
	), {
		MakeElement("List"),
		MakeElement("Padding", 6, 6, 6, 6),
	}), "Divider")

	AddConnection(TabHolder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		TabHolder.CanvasSize = UDim2.new(0, 0, 0, TabHolder.UIListLayout.AbsoluteContentSize.Y + 16)
	end)

	-- ── Top-right controls ─────────────────────────────────────────────────────
	local CloseBtn = SetChildren(SetProps(MakeElement("Button"), {
		Size = UDim2.new(0.5, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
	}), {
		AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://7072725342"), {
			AnchorPoint = Vector2.new(0.5,0.5),
			Position    = UDim2.new(0.5,0,0.5,0),
			Size        = UDim2.new(0,14,0,14),
		}), "Text"),
	})

	local MinimizeBtn = SetChildren(SetProps(MakeElement("Button"), {
		Size = UDim2.new(0.5, 0, 1, 0),
	}), {
		AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://7072719338"), {
			AnchorPoint = Vector2.new(0.5,0.5),
			Position    = UDim2.new(0.5,0,0.5,0),
			Size        = UDim2.new(0,14,0,14),
			Name        = "Ico",
		}), "Text"),
	})

	local DragPoint = SetProps(MakeElement("TFrame"), {
		Size = UDim2.new(1, 0, 0, 48),
	})

	-- ── Sidebar user profile ───────────────────────────────────────────────────
	local ProfileSection = SetChildren(SetProps(MakeElement("TFrame"), {
		Size     = UDim2.new(1, 0, 0, 52),
		Position = UDim2.new(0, 0, 1, -52),
	}), {
		-- divider line
		Create("Frame", {
			Size             = UDim2.new(1, -12, 0, 1),
			Position         = UDim2.new(0, 6, 0, 0),
			BackgroundColor3 = T.Stroke,
			BorderSizePixel  = 0,
			BackgroundTransparency = 0.5,
		}),
		-- avatar
		AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255,255,255), 1, 0), {
			AnchorPoint = Vector2.new(0, 0.5),
			Size        = UDim2.new(0, 30, 0, 30),
			Position    = UDim2.new(0, 8, 0.5, 4),
		}), {
			SetProps(MakeElement("Image",
				"https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
			), {Size = UDim2.new(1,0,1,0)}),
			AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://4031889928"), {
				Size = UDim2.new(1,0,1,0),
			}), "Surface" ~= nil and "Second" or "Second"),
			MakeElement("Corner", 1),
		}), "Divider"),
		AddThemeObject(SetProps(MakeElement("Label", LocalPlayer.DisplayName, 12), {
			Size     = UDim2.new(1, -52, 0, 13),
			Position = UDim2.new(0, 46, 0, 10),
			Font     = Enum.Font.GothamBold,
			ClipsDescendants = true,
		}), "Text"),
		AddThemeObject(SetProps(MakeElement("Label", TemporaryRoles[LocalPlayer.UserId] or "Member", 10), {
			Size     = UDim2.new(1, -52, 0, 11),
			Position = UDim2.new(0, 46, 0, 26),
		}), "TextDark"),
	})

	-- ── Sidebar gradient overlay ───────────────────────────────────────────────
	local SidebarGradient = Create("ImageLabel", {
		BackgroundTransparency = 1,
		Size  = UDim2.new(1, 0, 0, 40),
		Position = UDim2.new(0, 0, 1, -92),
		Image = "rbxassetid://5028857084", -- soft shadow image
		ImageColor3 = T.Second,
		ImageTransparency = 0.2,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(1,1,1,1),
		ZIndex = 3,
	})

	local WindowStuff = AddThemeObject(SetChildren(SetProps(
		MakeElement("RoundFrame", Color3.fromRGB(255,255,255), 0, 12), {
			Size     = UDim2.new(0, 155, 1, -48),
			Position = UDim2.new(0, 0, 0, 48),
		}
	), {
		-- top-left round filler
		AddThemeObject(SetProps(MakeElement("Frame"), {
			Size     = UDim2.new(1, 0, 0, 12),
			Position = UDim2.new(0, 0, 0, 0),
		}), "Second"),
		AddThemeObject(SetProps(MakeElement("Frame"), {
			Size     = UDim2.new(0, 12, 1, 0),
			Position = UDim2.new(1, -12, 0, 0),
		}), "Second"),
		-- right edge separator
		AddThemeObject(SetProps(MakeElement("Frame"), {
			Size     = UDim2.new(0, 1, 1, 0),
			Position = UDim2.new(1, -1, 0, 0),
		}), "Stroke"),
		TabHolder,
		ProfileSection,
		SidebarGradient,
		TabIndicator,
	}), "Second")

	-- ── SearchBar ─────────────────────────────────────────────────────────────
	local Tabs = {}

	if WindowConfig.SearchBar then
		local SearchBox = Create("TextBox", {
			Size             = UDim2.new(1, -16, 1, 0),
			Position         = UDim2.new(0, 8, 0, 0),
			BackgroundTransparency = 1,
			TextColor3       = Color3.fromRGB(255,255,255),
			PlaceholderColor3= Color3.fromRGB(160,140,200),
			PlaceholderText  = WindowConfig.SearchBar.Default or "Search...",
			Font             = Enum.Font.Gotham,
			TextWrapped      = true,
			Text             = '',
			TextXAlignment   = Enum.TextXAlignment.Left,
			TextSize         = 13,
			ClearTextOnFocus = WindowConfig.SearchBar.ClearTextOnFocus or true,
		})

		local TextboxActual = AddThemeObject(SearchBox, "Text")

		local SearchBar = AddThemeObject(SetChildren(SetProps(
			MakeElement("RoundFrame", Color3.fromRGB(255,255,255), 0, 8), {
				Parent   = WindowStuff,
				Size     = UDim2.new(1, -16, 0, 28),
				Position = UDim2.new(0, 8, 0, 14),
			}
		), {
			AddThemeObject(MakeElement("Stroke"), "Stroke"),
			-- Search icon
			SetProps(MakeElement("Image", "rbxassetid://3192519002"), {
				Size     = UDim2.new(0, 13, 0, 13),
				Position = UDim2.new(0, 4, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				ImageColor3 = T.TextDark,
			}),
			TextboxActual,
		}), "Main")

		local function SearchHandle()
			local Text = string.lower(SearchBox.Text)
			for i, v in pairs(Tabs) do
				if v:IsA('TextButton') then
					v.Visible = string.find(string.lower(i), Text) ~= nil
				end
			end
		end
		AddConnection(TextboxActual:GetPropertyChangedSignal("Text"), SearchHandle)
	end

	-- ── Topbar ────────────────────────────────────────────────────────────────
	local WindowName = AddThemeObject(SetProps(MakeElement("Label", WindowConfig.Name, 16), {
		Size     = UDim2.new(1, -120, 1, 0),
		Position = UDim2.new(0, 20, 0, 0),
		Font     = Enum.Font.GothamBlack,
		TextSize = 18,
	}), "Text")

	-- accent gradient under topbar name
	local NameAccent = Create("Frame", {
		Size             = UDim2.new(0, 0, 0, 2),
		Position         = UDim2.new(0, 20, 1, -2),
		BackgroundColor3 = T.Accent,
		BorderSizePixel  = 0,
		ZIndex           = 6,
	}, {
		Create("UICorner", {CornerRadius = UDim.new(0, 2)}),
		Create("UIGradient", {
			Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, T.Accent),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 100, 255)),
			},
		}),
	})

	local WindowTopBarLine = AddThemeObject(SetProps(MakeElement("Frame"), {
		Size     = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 1, -1),
		BackgroundTransparency = 0.6,
	}), "Stroke")

	-- control buttons frame
	local ControlFrame = AddThemeObject(SetChildren(
		SetProps(MakeElement("RoundFrame", Color3.fromRGB(255,255,255), 0, 6), {
			Size     = UDim2.new(0, 56, 0, 24),
			Position = UDim2.new(1, -72, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
		}), {
			AddThemeObject(MakeElement("Stroke"), "Stroke"),
			AddThemeObject(SetProps(MakeElement("Frame"), {
				Size     = UDim2.new(0, 1, 1, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
			}), "Stroke"),
			CloseBtn,
			MinimizeBtn,
		}
	), "Second")

	local MainWindow = AddThemeObject(SetChildren(SetProps(
		MakeElement("RoundFrame", Color3.fromRGB(255,255,255), 0, 12), {
			Parent           = Orion,
			Position         = UDim2.new(0.5, -310, 0.5, -175),
			Size             = UDim2.new(0, 620, 0, 350),
			ClipsDescendants = true,
		}
	), {
		-- subtle inner glow effect (dark vignette top)
		Create("ImageLabel", {
			BackgroundTransparency = 1,
			Size  = UDim2.new(1, 0, 0, 60),
			Image = "rbxassetid://5028857084",
			ImageColor3 = Color3.fromRGB(0,0,0),
			ImageTransparency = 0.7,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(1,1,1,1),
			ZIndex = 0,
		}),
		SetChildren(SetProps(MakeElement("TFrame"), {
			Size = UDim2.new(1, 0, 0, 48),
			Name = "TopBar",
			ZIndex = 5,
		}), {
			WindowName,
			NameAccent,
			WindowTopBarLine,
			ControlFrame,
		}),
		DragPoint,
		WindowStuff,
	}), "Main")

	-- animate name accent width on load
	task.delay(0.1, function()
		Tween(NameAccent, 0.6, {Size = UDim2.new(0, WindowName.TextBounds.X, 0, 2)})
	end)

	if WindowConfig.ShowIcon then
		WindowName.Position = UDim2.new(0, 46, 0, 0)
		SetProps(MakeElement("Image", WindowConfig.Icon), {
			Size     = UDim2.new(0, 18, 0, 18),
			Position = UDim2.new(0, 20, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Parent   = MainWindow.TopBar,
		})
	end

	MakeDraggable(DragPoint, MainWindow)

	-- ── Mobile / Close / Minimize ─────────────────────────────────────────────
	local _currentKey = Enum.KeyCode.RightShift
	local isMobile = table.find({Enum.Platform.IOS, Enum.Platform.Android}, UserInputService:GetPlatform())

	local MobileIcon = SetChildren(SetProps(MakeElement("ImageButton", "http://www.roblox.com/asset/?id=17570737246"), {
		Position = UDim2.new(0.25, 0, 0.1, 0),
		Size     = UDim2.new(0, 36, 0, 36),
		Parent   = Orion,
		Visible  = false,
	}), {MakeElement("Corner", 1, 0)})

	MakeDraggable(MobileIcon, MobileIcon)

	AddConnection(MobileIcon.MouseButton1Click, function()
		MainWindow.Visible = true
		MobileIcon.Visible = false
	end)

	AddConnection(CloseBtn.MouseButton1Up, function()
		MainWindow.Visible = false
		UIHidden = true
		if UserInputService.TouchEnabled then MobileIcon.Visible = true end
		OrionLib:MakeNotification({
			Name    = "Interface fechada",
			Content = (isMobile and 'Toque na <b>Icon' or 'Pressione <b>' .. _currentKey.Name) .. "</b> para abrir novamente.",
			Time    = 5,
		})
		WindowConfig.CloseCallback()
	end)

	AddConnection(UserInputService.InputBegan, function(Input)
		if Input.KeyCode == _currentKey then
			MobileIcon.Visible = false
			MainWindow.Visible = not MainWindow.Visible
		end
	end)

	AddConnection(MinimizeBtn.MouseButton1Up, function()
		if Minimized then
			TweenService:Create(MainWindow, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
				{Size = UDim2.new(0, 620, 0, 350)}):Play()
			MinimizeBtn.Ico.Image = "rbxassetid://7072719338"
			wait(0.02)
			MainWindow.ClipsDescendants = false
			WindowStuff.Visible = true
			WindowTopBarLine.Visible = true
		else
			MainWindow.ClipsDescendants = true
			WindowTopBarLine.Visible = false
			MinimizeBtn.Ico.Image = "rbxassetid://7072720870"
			TweenService:Create(MainWindow, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
				{Size = UDim2.new(0, WindowName.TextBounds.X + 160, 0, 48)}):Play()
			wait(0.12)
			WindowStuff.Visible = false
		end
		Minimized = not Minimized
	end)

	-- ── Intro sequence ────────────────────────────────────────────────────────
	local function LoadSequence()
		MainWindow.Visible = false

		local Backdrop = Create("Frame", {
			Parent           = Orion,
			BackgroundColor3 = Color3.fromRGB(8, 8, 14),
			BackgroundTransparency = 0,
			Size             = UDim2.new(1, 0, 1, 0),
			ZIndex           = 20,
		})

		local Logo = SetProps(MakeElement("Image", WindowConfig.IntroIcon), {
			Parent           = Backdrop,
			AnchorPoint      = Vector2.new(0.5, 0.5),
			Position         = UDim2.new(0.5, 0, 0.45, 0),
			Size             = UDim2.new(0, 32, 0, 32),
			ImageColor3      = Color3.fromRGB(255,255,255),
			ImageTransparency= 1,
			ZIndex           = 21,
		})

		local IntroText = SetProps(MakeElement("Label", WindowConfig.IntroText, 18), {
			Parent            = Backdrop,
			Size              = UDim2.new(1, 0, 0, 30),
			AnchorPoint       = Vector2.new(0.5, 0.5),
			Position          = UDim2.new(0.5, 22, 0.5, 0),
			TextXAlignment    = Enum.TextXAlignment.Center,
			Font              = Enum.Font.GothamBlack,
			TextTransparency  = 1,
			ZIndex            = 21,
		})

		-- glow ring
		local GlowRing = Create("ImageLabel", {
			Parent           = Backdrop,
			AnchorPoint      = Vector2.new(0.5, 0.5),
			Position         = UDim2.new(0.5, 0, 0.45, 0),
			Size             = UDim2.new(0, 80, 0, 80),
			Image            = "rbxassetid://5028857084",
			ImageColor3      = T.Accent,
			ImageTransparency= 1,
			BackgroundTransparency = 1,
			ScaleType        = Enum.ScaleType.Slice,
			SliceCenter      = Rect.new(24,24,276,276),
			ZIndex           = 20,
		})

		Tween(Logo,    0.4, {ImageTransparency = 0, Position = UDim2.new(0.5, 0, 0.5, 0)})
		Tween(GlowRing,0.5, {ImageTransparency = 0.5, Position = UDim2.new(0.5, 0, 0.5, 0)})
		wait(0.9)
		Tween(Logo,    0.3, {Position = UDim2.new(0.5, -(IntroText.TextBounds.X / 2 + 4), 0.5, 0)})
		wait(0.35)
		Tween(IntroText, 0.35, {TextTransparency = 0})
		wait(1.8)
		Tween(GlowRing,  0.4, {ImageTransparency = 1})
		Tween(Backdrop,  0.5, {BackgroundTransparency = 1})
		Tween(IntroText, 0.4, {TextTransparency = 1})
		Tween(Logo,      0.4, {ImageTransparency = 1})
		wait(0.55)
		Backdrop:Destroy()
		MainWindow.Visible = true
	end

	if WindowConfig.IntroEnabled then LoadSequence() end

	-- ─────────────────────────────────────────────────────────────────────────
	local Functions = {}

	function Functions:MakeTab(TabConfig)
		TabConfig      = TabConfig or {}
		TabConfig.Name = TabConfig.Name or "Tab"
		TabConfig.Icon = TabConfig.Icon or ""

		-- Tab button in sidebar
		local TabFrame = SetChildren(SetProps(MakeElement("Button"), {
			Size             = UDim2.new(1, 0, 0, 34),
			Parent           = TabHolder,
			BackgroundColor3 = T.Second,
			BackgroundTransparency = 1,
			ClipsDescendants = false,
		}), {
			-- hover/active bg
			Create("Frame", {
				Name             = "ActiveBg",
				Size             = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = T.Accent,
				BackgroundTransparency = 1,
				BorderSizePixel  = 0,
			}, {Create("UICorner", {CornerRadius = UDim.new(0, 7)})}),
			AddThemeObject(SetProps(MakeElement("Image", TabConfig.Icon), {
				AnchorPoint      = Vector2.new(0, 0.5),
				Size             = UDim2.new(0, 16, 0, 16),
				Position         = UDim2.new(0, 12, 0.5, 0),
				ImageTransparency= 0.55,
				Name             = "Ico",
			}), "Text"),
			AddThemeObject(SetProps(MakeElement("Label", TabConfig.Name, 13), {
				Size             = UDim2.new(1, -38, 1, 0),
				Position         = UDim2.new(0, 34, 0, 0),
				Font             = Enum.Font.GothamSemibold,
				TextTransparency = 0.55,
				Name             = "Title",
			}), "Text"),
		})

		if GetIcon(TabConfig.Icon) then TabFrame.Ico.Image = GetIcon(TabConfig.Icon) end
		AddItemTable(Tabs, TabConfig.Name, TabFrame)

		-- Content panel
		local Container = AddThemeObject(SetChildren(SetProps(
			MakeElement("ScrollFrame", Color3.fromRGB(255,255,255), 4), {
				Size     = UDim2.new(1, -155, 1, -48),
				Position = UDim2.new(0, 155, 0, 48),
				Parent   = MainWindow,
				Visible  = false,
				Name     = "ItemContainer",
			}
		), {
			MakeElement("List", 0, 6),
			MakeElement("Padding", 14, 10, 10, 14),
		}), "Divider")

		AddConnection(Container.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			Container.CanvasSize = UDim2.new(0, 0, 0, Container.UIListLayout.AbsoluteContentSize.Y + 30)
		end)

		local function ActivateTab()
			-- animate indicator to this tab
			local tabAbsPos = TabFrame.AbsolutePosition.Y - TabHolder.AbsolutePosition.Y + TabHolder.CanvasPosition.Y
			Tween(TabIndicator, 0.25, {
				Position = UDim2.new(0, 0, 0, tabAbsPos + 4),
				Size     = UDim2.new(0, 3, 0, 26),
			})
		end

		if FirstTab then
			FirstTab = false
			TabFrame.Ico.ImageTransparency = 0
			TabFrame.Title.TextTransparency = 0
			TabFrame.Title.Font = Enum.Font.GothamBold
			TabFrame.ActiveBg.BackgroundTransparency = 0.88
			Container.Visible = true
			task.delay(0.15, ActivateTab)
		end

		AddConnection(TabFrame.MouseButton1Click, function()
			-- reset all tabs
			for _, Tab in next, TabHolder:GetChildren() do
				if Tab:IsA("TextButton") then
					Tab.Title.Font = Enum.Font.GothamSemibold
					Tween(Tab.Ico,       0.2, {ImageTransparency = 0.55})
					Tween(Tab.Title,     0.2, {TextTransparency  = 0.55})
					Tween(Tab.ActiveBg,  0.2, {BackgroundTransparency = 1})
				end
			end
			for _, ItemContainer in next, MainWindow:GetChildren() do
				if ItemContainer.Name == "ItemContainer" then
					ItemContainer.Visible = false
				end
			end
			-- activate this tab
			Tween(TabFrame.Ico,      0.2, {ImageTransparency = 0})
			Tween(TabFrame.Title,    0.2, {TextTransparency  = 0})
			Tween(TabFrame.ActiveBg, 0.2, {BackgroundTransparency = 0.88})
			TabFrame.Title.Font = Enum.Font.GothamBold
			Container.Visible = true
			ActivateTab()
		end)

		-- Hover effect
		AddConnection(TabFrame.MouseEnter, function()
			if TabFrame.ActiveBg.BackgroundTransparency > 0.5 then
				Tween(TabFrame.ActiveBg, 0.15, {BackgroundTransparency = 0.95})
			end
		end)
		AddConnection(TabFrame.MouseLeave, function()
			if TabFrame.ActiveBg.BackgroundTransparency > 0.5 then
				Tween(TabFrame.ActiveBg, 0.15, {BackgroundTransparency = 1})
			end
		end)

		-- ── Element builders ──────────────────────────────────────────────────
		local function GetElements(ItemParent)
			local ElementFunction = {}

			-- ── Styling helpers for items ──────────────────────────────────────
			local function MakeItemFrame(size)
				return AddThemeObject(SetChildren(SetProps(
					MakeElement("RoundFrame", Color3.fromRGB(255,255,255), 0, 8), {
						Size             = size or UDim2.new(1, 0, 0, 34),
						Parent           = ItemParent,
						BackgroundTransparency = 0,
					}
				), {
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
				}), "Second")
			end

			function ElementFunction:AddLog(Text)
				local LogFrame = AddThemeObject(SetChildren(SetProps(
					MakeElement("RoundFrame", Color3.fromRGB(255,255,255), 0, 8), {
						Size                   = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 0.7,
						Parent                 = ItemParent,
					}
				), {
					AddThemeObject(SetProps(MakeElement("Label", Text, 15), {
						Size             = UDim2.new(1, -12, 1, 0),
						Position         = UDim2.new(0, 12, 0, 0),
						TextXAlignment   = Enum.TextXAlignment.Center,
						TextSize         = 19,
						TextWrapped      = true,
						Font             = Enum.Font.GothamBold,
						Name             = "Content",
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
				}), "Second")
			end

			function ElementFunction:AddLabel(Text)
				local LabelFrame = AddThemeObject(SetChildren(SetProps(
					MakeElement("RoundFrame", Color3.fromRGB(255,255,255), 0, 8), {
						Size                   = UDim2.new(1, 0, 0, 32),
						BackgroundTransparency = 0.7,
						Parent                 = ItemParent,
					}
				), {
					AddThemeObject(SetProps(MakeElement("Label", Text, 14), {
						Size     = UDim2.new(1, -14, 1, 0),
						Position = UDim2.new(0, 14, 0, 0),
						Font     = Enum.Font.GothamSemibold,
						Name     = "Content",
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
				}), "Second")
				local LabelFunction = {}
				function LabelFunction:Set(ToChange) LabelFrame.Content.Text = ToChange end
				return LabelFunction
			end

			function ElementFunction:AddParagraph(Text, Content)
				Text    = Text    or "Text"
				Content = Content or "Content"
				local PFrame = AddThemeObject(SetChildren(SetProps(
					MakeElement("RoundFrame", Color3.fromRGB(255,255,255), 0, 8), {
						Size                   = UDim2.new(1, 0, 0, 30),
						BackgroundTransparency = 0.7,
						Parent                 = ItemParent,
					}
				), {
					AddThemeObject(SetProps(MakeElement("Label", Text, 14), {
						Size     = UDim2.new(1, -14, 0, 14),
						Position = UDim2.new(0, 14, 0, 10),
						Font     = Enum.Font.GothamBold,
						Name     = "Title",
					}), "Text"),
					AddThemeObject(SetProps(MakeElement("Label", "", 12), {
						Size          = UDim2.new(1, -28, 0, 0),
						Position      = UDim2.new(0, 14, 0, 27),
						Font          = Enum.Font.Gotham,
						Name          = "Content",
						TextWrapped   = true,
						AutomaticSize = Enum.AutomaticSize.Y,
					}), "TextDark"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
				}), "Second")
				AddConnection(PFrame.Content:GetPropertyChangedSignal("Text"), function()
					PFrame.Content.Size = UDim2.new(1, -28, 0, PFrame.Content.TextBounds.Y)
					PFrame.Size = UDim2.new(1, 0, 0, PFrame.Content.TextBounds.Y + 38)
				end)
				PFrame.Content.Text = Content
				local PFunc = {}
				function PFunc:Set(v) PFrame.Content.Text = v end
				return PFunc
			end

			function ElementFunction:AddButton(ButtonConfig)
				ButtonConfig          = ButtonConfig or {}
				ButtonConfig.Name     = ButtonConfig.Name     or "Button"
				ButtonConfig.Callback = ButtonConfig.Callback or function() end
				ButtonConfig.Icon     = ButtonConfig.Icon     or "rbxassetid://3944703587"
				ButtonConfig.OriginalName = ButtonConfig.OriginalName or tostring(ButtonConfig.Name or "")

				local Splitted = string.split(ButtonConfig.Name, " / ")
				local Script   = Splitted and Splitted[2]
				if Script then
					ButtonConfig.Name = Script
					ButtonConfig.CanFavorite = true
				end

				local Button = {}
				local Click  = SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 1, 0)})

				local FavoriteButton = ButtonConfig.CanFavorite and SetProps(MakeElement("ImageButton", "http://www.roblox.com/asset/?id=109586771228631"), {
					Size     = UDim2.new(0, 18, 0, 18),
					Position = UDim2.new(1, -52, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					ZIndex   = 25,
				})

				local ButtonFrame = AddThemeObject(SetChildren(SetProps(
					MakeElement("RoundFrame", Color3.fromRGB(255,255,255), 0, 8), {
						Size   = UDim2.new(1, 0, 0, 34),
						Parent = ItemParent,
					}
				), {
					-- left accent strip
					Create("Frame", {
						Size             = UDim2.new(0, 3, 0.55, 0),
						AnchorPoint      = Vector2.new(0, 0.5),
						Position         = UDim2.new(0, 0, 0.5, 0),
						BackgroundColor3 = T.Accent,
						BorderSizePixel  = 0,
						BackgroundTransparency = 0.5,
						Name             = "AccentStrip",
					}, {Create("UICorner", {CornerRadius = UDim.new(0, 3)})}),
					AddThemeObject(SetProps(MakeElement("Label", ButtonConfig.Name, 14), {
						Size     = UDim2.new(1, -50, 1, 0),
						Position = UDim2.new(0, 14, 0, 0),
						Font     = Enum.Font.GothamSemibold,
						Name     = "Content",
					}), "Text"),
					AddThemeObject(SetProps(MakeElement("Image", ButtonConfig.Icon), {
						Size        = UDim2.new(0, 16, 0, 16),
						AnchorPoint = Vector2.new(0, 0.5),
						Position    = UDim2.new(1, -32, 0.5, 0),
					}), "TextDark"),
					ButtonConfig.CanFavorite and AddThemeObject(FavoriteButton, "TextDark") or nil,
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					Click,
				}), "Second")

				local function BtnColor(extra)
					return Color3.fromRGB(
						T.Second.R*255 + extra,
						T.Second.G*255 + extra,
						T.Second.B*255 + extra
					)
				end

				AddConnection(Click.MouseEnter,      function() Tween(ButtonFrame, 0.18, {BackgroundColor3 = BtnColor(6)}) end)
				AddConnection(Click.MouseLeave,      function() Tween(ButtonFrame, 0.18, {BackgroundColor3 = T.Second}) end)
				AddConnection(Click.MouseButton1Down,function() Tween(ButtonFrame, 0.1,  {BackgroundColor3 = BtnColor(14)}) end)
				AddConnection(Click.MouseButton1Up,  function()
					Tween(ButtonFrame, 0.18, {BackgroundColor3 = BtnColor(6)})
					spawn(ButtonConfig.Callback)
				end)

				if FavoriteButton then
					AddConnection(FavoriteButton.MouseButton1Down, function()
						OrionLib.FavoriteEvent:Fire(ButtonConfig.OriginalName)
					end)
				end

				function Button:Set(t) ButtonFrame.Content.Text = t end
				Button.Instance = ButtonFrame
				return Button
			end

			function ElementFunction:AddToggle(ToggleConfig)
				ToggleConfig          = ToggleConfig or {}
				ToggleConfig.Name     = ToggleConfig.Name     or "Toggle"
				ToggleConfig.Default  = ToggleConfig.Default  or false
				ToggleConfig.Callback = ToggleConfig.Callback or function() end
				ToggleConfig.Color    = ToggleConfig.Color    or Color3.fromRGB(120, 80, 220)
				ToggleConfig.Flag     = ToggleConfig.Flag     or nil
				ToggleConfig.Save     = ToggleConfig.Save     or false

				local Toggle = {Value = ToggleConfig.Default, Save = ToggleConfig.Save}
				local Click  = SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 1, 0)})

				-- pill toggle
				local Pill = Create("Frame", {
					Size             = UDim2.new(0, 36, 0, 20),
					AnchorPoint      = Vector2.new(1, 0.5),
					Position         = UDim2.new(1, -12, 0.5, 0),
					BackgroundColor3 = T.AccentDark,
					BorderSizePixel  = 0,
				}, {
					Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
					Create("UIStroke", {Color = T.Stroke, Thickness = 1, Name = "Stroke"}),
				})

				local PillKnob = Create("Frame", {
					Name             = "Knob",
					Size             = UDim2.new(0, 14, 0, 14),
					AnchorPoint      = Vector2.new(0.5, 0.5),
					Position         = UDim2.new(0, 10, 0.5, 0),
					BackgroundColor3 = Color3.fromRGB(200, 200, 220),
					BorderSizePixel  = 0,
					Parent           = Pill,
				}, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})

				local ToggleFrame = AddThemeObject(SetChildren(SetProps(
					MakeElement("RoundFrame", Color3.fromRGB(255,255,255), 0, 8), {
						Size   = UDim2.new(1, 0, 0, 38),
						Parent = ItemParent,
					}
				), {
					AddThemeObject(SetProps(MakeElement("Label", ToggleConfig.Name, 14), {
						Size     = UDim2.new(1, -60, 1, 0),
						Position = UDim2.new(0, 14, 0, 0),
						Font     = Enum.Font.GothamSemibold,
						Name     = "Content",
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					Pill,
					Click,
				}), "Second")

				function Toggle:Set(Value)
					Toggle.Value = Value
					Tween(Pill,          0.25, {BackgroundColor3 = Value and ToggleConfig.Color or T.AccentDark})
					Tween(Pill.Stroke,   0.25, {Color = Value and ToggleConfig.Color or T.Stroke})
					Tween(PillKnob,      0.25, {
						Position         = UDim2.new(0, Value and 26 or 10, 0.5, 0),
						BackgroundColor3 = Value and Color3.fromRGB(255,255,255) or Color3.fromRGB(160,160,180),
					})
					ToggleConfig.Callback(Toggle.Value)
				end

				Toggle:Set(Toggle.Value)

				local function TglColor(extra)
					return Color3.fromRGB(T.Second.R*255+extra, T.Second.G*255+extra, T.Second.B*255+extra)
				end
				AddConnection(Click.MouseEnter,      function() Tween(ToggleFrame, 0.18, {BackgroundColor3 = TglColor(5)}) end)
				AddConnection(Click.MouseLeave,      function() Tween(ToggleFrame, 0.18, {BackgroundColor3 = T.Second}) end)
				AddConnection(Click.MouseButton1Up,  function()
					Tween(ToggleFrame, 0.18, {BackgroundColor3 = TglColor(5)})
					SaveCfg(game.GameId)
					Toggle:Set(not Toggle.Value)
				end)
				AddConnection(Click.MouseButton1Down,function() Tween(ToggleFrame, 0.1, {BackgroundColor3 = TglColor(10)}) end)

				if ToggleConfig.Flag then OrionLib.Flags[ToggleConfig.Flag] = Toggle end
				return Toggle
			end

			function ElementFunction:AddSlider(SliderConfig)
				SliderConfig           = SliderConfig or {}
				SliderConfig.Name      = SliderConfig.Name      or "Slider"
				SliderConfig.Min       = SliderConfig.Min       or 0
				SliderConfig.Max       = SliderConfig.Max       or 100
				SliderConfig.Increment = SliderConfig.Increment or 1
				SliderConfig.Default   = SliderConfig.Default   or 50
				SliderConfig.Callback  = SliderConfig.Callback  or function() end
				SliderConfig.ValueName = SliderConfig.ValueName or ""
				SliderConfig.Color     = SliderConfig.Color     or T.Accent
				SliderConfig.Flag      = SliderConfig.Flag      or nil
				SliderConfig.Save      = SliderConfig.Save      or false

				local Slider  = {Value = SliderConfig.Default, Save = SliderConfig.Save}
				local Dragging = false

				local SliderDrag = SetChildren(SetProps(
					MakeElement("RoundFrame", SliderConfig.Color, 0, 5), {
						Size             = UDim2.new(0, 0, 1, 0),
						BackgroundTransparency = 0.15,
						ClipsDescendants = true,
					}
				), {
					AddThemeObject(SetProps(MakeElement("Label", "val", 12), {
						Size     = UDim2.new(1, -8, 0, 14),
						Position = UDim2.new(0, 8, 0, 5),
						Font     = Enum.Font.GothamBold,
						Name     = "Value",
					}), "Text"),
					-- glow on drag bar
					Create("Frame", {
						Size             = UDim2.new(0, 6, 1, 0),
						Position         = UDim2.new(1, -3, 0, 0),
						BackgroundColor3 = SliderConfig.Color,
						BorderSizePixel  = 0,
						BackgroundTransparency = 0.4,
					}, {Create("UICorner", {CornerRadius = UDim.new(0, 5)})}),
				})

				local SliderBar = SetChildren(SetProps(
					MakeElement("RoundFrame", SliderConfig.Color, 0, 5), {
						Size             = UDim2.new(1, -24, 0, 24),
						Position         = UDim2.new(0, 12, 0, 32),
						BackgroundTransparency = 0.88,
					}
				), {
					Create("UIStroke", {Color = SliderConfig.Color, Thickness = 1}),
					AddThemeObject(SetProps(MakeElement("Label", "val", 12), {
						Size     = UDim2.new(1, -8, 0, 14),
						Position = UDim2.new(0, 8, 0, 5),
						Font     = Enum.Font.GothamBold,
						Name     = "Value",
						TextTransparency = 0.7,
					}), "Text"),
					SliderDrag,
				})

				local SliderFrame = AddThemeObject(SetChildren(SetProps(
					MakeElement("RoundFrame", Color3.fromRGB(255,255,255), 0, 8), {
						Size   = UDim2.new(1, 0, 0, 64),
						Parent = ItemParent,
					}
				), {
					AddThemeObject(SetProps(MakeElement("Label", SliderConfig.Name, 14), {
						Size     = UDim2.new(1, -14, 0, 14),
						Position = UDim2.new(0, 14, 0, 10),
						Font     = Enum.Font.GothamSemibold,
						Name     = "Content",
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					SliderBar,
				}), "Second")

				SliderBar.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true end
				end)
				SliderBar.InputEnded:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
				end)
				UserInputService.InputChanged:Connect(function(Input)
					if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
						local s = math.clamp((Input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
						Slider:Set(SliderConfig.Min + (SliderConfig.Max - SliderConfig.Min) * s)
						SaveCfg(game.GameId)
					end
				end)

				function Slider:Set(Value)
					self.Value = math.clamp(Round(Value, SliderConfig.Increment), SliderConfig.Min, SliderConfig.Max)
					Tween(SliderDrag, 0.12, {Size = UDim2.fromScale((self.Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), 1)})
					local txt = tostring(self.Value) .. " " .. SliderConfig.ValueName
					SliderBar.Value.Text  = txt
					SliderDrag.Value.Text = txt
					SliderConfig.Callback(self.Value)
				end

				Slider:Set(Slider.Value)
				if SliderConfig.Flag then OrionLib.Flags[SliderConfig.Flag] = Slider end
				return Slider
			end

			function ElementFunction:AddDropdown(DropdownConfig)
				DropdownConfig          = DropdownConfig or {}
				DropdownConfig.Name     = DropdownConfig.Name     or "Dropdown"
				DropdownConfig.Options  = DropdownConfig.Options  or {}
				DropdownConfig.Default  = DropdownConfig.Default  or ""
				DropdownConfig.Callback = DropdownConfig.Callback or function() end
				DropdownConfig.Flag     = DropdownConfig.Flag     or nil
				DropdownConfig.Save     = DropdownConfig.Save     or false

				local Dropdown = {Value = DropdownConfig.Default, Options = DropdownConfig.Options, Buttons = {}, Toggled = false, Type = "Dropdown", Save = DropdownConfig.Save}
				local MaxElements = 5
				if not table.find(Dropdown.Options, Dropdown.Value) then Dropdown.Value = "..." end

				local DropdownList = MakeElement("List")
				local DropdownContainer = AddThemeObject(SetProps(SetChildren(
					MakeElement("ScrollFrame", Color3.fromRGB(40,40,40), 3), {DropdownList}
				), {
					Parent           = ItemParent,
					Position         = UDim2.new(0, 0, 0, 38),
					Size             = UDim2.new(1, 0, 1, -38),
					ClipsDescendants = true,
				}), "Divider")

				local Click = SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 1, 0)})

				local DropdownFrame = AddThemeObject(SetChildren(SetProps(
					MakeElement("RoundFrame", Color3.fromRGB(255,255,255), 0, 8), {
						Size             = UDim2.new(1, 0, 0, 38),
						Parent           = ItemParent,
						ClipsDescendants = true,
					}
				), {
					DropdownContainer,
					SetProps(SetChildren(MakeElement("TFrame"), {
						AddThemeObject(SetProps(MakeElement("Label", DropdownConfig.Name, 14), {
							Size     = UDim2.new(1, -14, 1, 0),
							Position = UDim2.new(0, 14, 0, 0),
							Font     = Enum.Font.GothamSemibold,
							Name     = "Content",
						}), "Text"),
						AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://7072706796"), {
							Size        = UDim2.new(0, 16, 0, 16),
							AnchorPoint = Vector2.new(0, 0.5),
							Position    = UDim2.new(1, -28, 0.5, 0),
							Name        = "Ico",
						}), "TextDark"),
						AddThemeObject(SetProps(MakeElement("Label", "Selected", 12), {
							Size           = UDim2.new(1, -40, 1, 0),
							Font           = Enum.Font.Gotham,
							Name           = "Selected",
							TextXAlignment = Enum.TextXAlignment.Right,
						}), "TextDark"),
						AddThemeObject(SetProps(MakeElement("Frame"), {
							Size     = UDim2.new(1, 0, 0, 1),
							Position = UDim2.new(0, 0, 1, -1),
							Name     = "Line",
							Visible  = false,
						}), "Stroke"),
						Click,
					}), {
						Size             = UDim2.new(1, 0, 0, 38),
						ClipsDescendants = true,
						Name             = "F",
					}),
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					MakeElement("Corner", 0, 8),
				}), "Second")

				AddConnection(DropdownList:GetPropertyChangedSignal("AbsoluteContentSize"), function()
					DropdownContainer.CanvasSize = UDim2.new(0, 0, 0, DropdownList.AbsoluteContentSize.Y)
				end)

				local function AddOptions(Options)
					for _, Option in pairs(Options) do
						local OptionBtn = AddThemeObject(SetProps(SetChildren(MakeElement("Button"), {
							MakeElement("Corner", 0, 6),
							AddThemeObject(SetProps(MakeElement("Label", Option, 12, 0.4), {
								Position = UDim2.new(0, 10, 0, 0),
								Size     = UDim2.new(1, -10, 1, 0),
								Name     = "Title",
							}), "Text"),
						}), {
							Parent                 = DropdownContainer,
							Size                   = UDim2.new(1, 0, 0, 28),
							BackgroundTransparency = 1,
							ClipsDescendants       = true,
						}), "Divider")
						AddConnection(OptionBtn.MouseButton1Click, function()
							Dropdown:Set(Option)
							SaveCfg(game.GameId)
						end)
						Dropdown.Buttons[Option] = OptionBtn
					end
				end

				function Dropdown:Refresh(Options, Delete)
					if Delete then
						for _, v in pairs(Dropdown.Buttons) do v:Destroy() end
						table.clear(Dropdown.Options)
						table.clear(Dropdown.Buttons)
					end
					Dropdown.Options = Options
					AddOptions(Dropdown.Options)
				end

				function Dropdown:Set(Value)
					if not table.find(Dropdown.Options, Value) then
						Dropdown.Value = "..."
						DropdownFrame.F.Selected.Text = Dropdown.Value
						for _, v in pairs(Dropdown.Buttons) do
							Tween(v, 0.12, {BackgroundTransparency = 1})
							Tween(v.Title, 0.12, {TextTransparency = 0.4})
						end
						return
					end
					Dropdown.Value = Value
					DropdownFrame.F.Selected.Text = Dropdown.Value
					for _, v in pairs(Dropdown.Buttons) do
						Tween(v, 0.12, {BackgroundTransparency = 1})
						Tween(v.Title, 0.12, {TextTransparency = 0.4})
					end
					Tween(Dropdown.Buttons[Value], 0.12, {BackgroundTransparency = 0})
					Tween(Dropdown.Buttons[Value].Title, 0.12, {TextTransparency = 0})
					return DropdownConfig.Callback(Dropdown.Value)
				end

				AddConnection(Click.MouseButton1Click, function()
					Dropdown.Toggled = not Dropdown.Toggled
					DropdownFrame.F.Line.Visible = Dropdown.Toggled
					Tween(DropdownFrame.F.Ico, 0.15, {Rotation = Dropdown.Toggled and 180 or 0})
					local expandH = #Dropdown.Options > MaxElements
						and (38 + MaxElements * 28)
						or  (DropdownList.AbsoluteContentSize.Y + 38)
					Tween(DropdownFrame, 0.15, {Size = Dropdown.Toggled
						and UDim2.new(1, 0, 0, expandH)
						or  UDim2.new(1, 0, 0, 38)
					})
				end)

				Dropdown:Refresh(Dropdown.Options, false)
				Dropdown:Set(Dropdown.Value)
				if DropdownConfig.Flag then OrionLib.Flags[DropdownConfig.Flag] = Dropdown end
				return Dropdown
			end

			function ElementFunction:AddBind(BindConfig)
				BindConfig          = BindConfig or {}
				BindConfig.Name     = BindConfig.Name     or "Bind"
				BindConfig.Default  = BindConfig.Default  or Enum.KeyCode.Unknown
				BindConfig.Hold     = BindConfig.Hold     or false
				BindConfig.Callback = BindConfig.Callback or function() end
				BindConfig.Flag     = BindConfig.Flag     or nil
				BindConfig.Save     = BindConfig.Save     or false

				local Bind   = {Value = nil, Binding = false, Type = "Bind", Save = BindConfig.Save}
				local Holding = false
				local Click  = SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 1, 0)})

				local BindBox = AddThemeObject(SetChildren(SetProps(
					MakeElement("RoundFrame", Color3.fromRGB(255,255,255), 0, 6), {
						Size        = UDim2.new(0, 28, 0, 22),
						AnchorPoint = Vector2.new(1, 0.5),
						Position    = UDim2.new(1, -12, 0.5, 0),
					}
				), {
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					AddThemeObject(SetProps(MakeElement("Label", BindConfig.Name, 12), {
						Size           = UDim2.new(1, 0, 1, 0),
						Font           = Enum.Font.GothamBold,
						TextXAlignment = Enum.TextXAlignment.Center,
						Name           = "Value",
					}), "Text"),
				}), "Main")

				local BindFrame = AddThemeObject(SetChildren(SetProps(
					MakeElement("RoundFrame", Color3.fromRGB(255,255,255), 0, 8), {
						Size   = UDim2.new(1, 0, 0, 38),
						Parent = ItemParent,
					}
				), {
					AddThemeObject(SetProps(MakeElement("Label", BindConfig.Name, 14), {
						Size     = UDim2.new(1, -60, 1, 0),
						Position = UDim2.new(0, 14, 0, 0),
						Font     = Enum.Font.GothamSemibold,
						Name     = "Content",
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					BindBox,
					Click,
				}), "Second")

				AddConnection(BindBox.Value:GetPropertyChangedSignal("Text"), function()
					Tween(BindBox, 0.2, {Size = UDim2.new(0, BindBox.Value.TextBounds.X + 18, 0, 22)})
				end)
				AddConnection(Click.InputEnded, function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						if Bind.Binding then return end
						Bind.Binding = true
						BindBox.Value.Text = "..."
					end
				end)
				AddConnection(UserInputService.InputBegan, function(Input)
					if UserInputService:GetFocusedTextBox() then return end
					if (Input.KeyCode.Name == Bind.Value or Input.UserInputType.Name == Bind.Value) and not Bind.Binding then
						if BindConfig.Hold then Holding = true; BindConfig.Callback(Holding)
						else BindConfig.Callback(Input) end
					elseif Bind.Binding then
						local Key
						pcall(function() if not CheckKey(BlacklistedKeys, Input.KeyCode) then Key = Input.KeyCode end end)
						pcall(function() if CheckKey(WhitelistedMouse, Input.UserInputType) and not Key then Key = Input.UserInputType end end)
						Key = Key or Bind.Value
						Bind:Set(Key)
						SaveCfg(game.GameId)
					end
				end)
				AddConnection(UserInputService.InputEnded, function(Input)
					if Input.KeyCode.Name == Bind.Value or Input.UserInputType.Name == Bind.Value then
						if BindConfig.Hold and Holding then Holding = false; BindConfig.Callback(Holding) end
					end
				end)

				local function BnColor(e) return Color3.fromRGB(T.Second.R*255+e, T.Second.G*255+e, T.Second.B*255+e) end
				AddConnection(Click.MouseEnter,       function() Tween(BindFrame, 0.18, {BackgroundColor3 = BnColor(5)}) end)
				AddConnection(Click.MouseLeave,       function() Tween(BindFrame, 0.18, {BackgroundColor3 = T.Second}) end)
				AddConnection(Click.MouseButton1Up,   function() Tween(BindFrame, 0.18, {BackgroundColor3 = BnColor(5)}) end)
				AddConnection(Click.MouseButton1Down, function() Tween(BindFrame, 0.1,  {BackgroundColor3 = BnColor(10)}) end)

				function Bind:Set(Key)
					Bind.Binding = false
					Bind.Value = Key or Bind.Value
					Bind.Value = Bind.Value.Name or Bind.Value
					BindBox.Value.Text = Bind.Value
				end

				Bind:Set(BindConfig.Default)
				if BindConfig.Flag then OrionLib.Flags[BindConfig.Flag] = Bind end
				return Bind
			end

			function ElementFunction:AddTextbox(TextboxConfig)
				TextboxConfig              = TextboxConfig or {}
				TextboxConfig.Name         = TextboxConfig.Name         or "Textbox"
				TextboxConfig.Default      = TextboxConfig.Default      or ""
				TextboxConfig.TextDisappear= TextboxConfig.TextDisappear or false
				TextboxConfig.Callback     = TextboxConfig.Callback     or function() end

				local Click = SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 1, 0)})
				local TextboxActual = AddThemeObject(Create("TextBox", {
					Size              = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					TextColor3        = Color3.fromRGB(255,255,255),
					PlaceholderColor3 = Color3.fromRGB(160,140,200),
					PlaceholderText   = "Type here...",
					Font              = Enum.Font.Gotham,
					TextXAlignment    = Enum.TextXAlignment.Center,
					TextSize          = 13,
					ClearTextOnFocus  = false,
				}), "Text")

				local TextContainer = AddThemeObject(SetChildren(SetProps(
					MakeElement("RoundFrame", Color3.fromRGB(255,255,255), 0, 6), {
						Size        = UDim2.new(0, 28, 0, 22),
						AnchorPoint = Vector2.new(1, 0.5),
						Position    = UDim2.new(1, -12, 0.5, 0),
					}
				), {
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					TextboxActual,
				}), "Main")

				local TextboxFrame = AddThemeObject(SetChildren(SetProps(
					MakeElement("RoundFrame", Color3.fromRGB(255,255,255), 0, 8), {
						Size   = UDim2.new(1, 0, 0, 38),
						Parent = ItemParent,
					}
				), {
					AddThemeObject(SetProps(MakeElement("Label", TextboxConfig.Name, 14), {
						Size     = UDim2.new(1, -60, 1, 0),
						Position = UDim2.new(0, 14, 0, 0),
						Font     = Enum.Font.GothamSemibold,
						Name     = "Content",
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					TextContainer,
					Click,
				}), "Second")

				AddConnection(TextboxActual:GetPropertyChangedSignal("Text"), function()
					Tween(TextContainer, 0.35, {Size = UDim2.new(0, TextboxActual.TextBounds.X + 18, 0, 22)})
				end)
				AddConnection(TextboxActual.FocusLost, function()
					TextboxConfig.Callback(TextboxActual.Text)
					if TextboxConfig.TextDisappear then TextboxActual.Text = "" end
				end)
				TextboxActual.Text = TextboxConfig.Default

				local function TbColor(e) return Color3.fromRGB(T.Second.R*255+e, T.Second.G*255+e, T.Second.B*255+e) end
				AddConnection(Click.MouseEnter,       function() Tween(TextboxFrame, 0.18, {BackgroundColor3 = TbColor(5)}) end)
				AddConnection(Click.MouseLeave,       function() Tween(TextboxFrame, 0.18, {BackgroundColor3 = T.Second}) end)
				AddConnection(Click.MouseButton1Up,   function() Tween(TextboxFrame, 0.18, {BackgroundColor3 = TbColor(5)}); TextboxActual:CaptureFocus() end)
				AddConnection(Click.MouseButton1Down, function() Tween(TextboxFrame, 0.1,  {BackgroundColor3 = TbColor(10)}) end)
			end

			function ElementFunction:AddColorpicker(ColorpickerConfig)
				ColorpickerConfig          = ColorpickerConfig or {}
				ColorpickerConfig.Name     = ColorpickerConfig.Name     or "Colorpicker"
				ColorpickerConfig.Default  = ColorpickerConfig.Default  or Color3.fromRGB(255,255,255)
				ColorpickerConfig.Callback = ColorpickerConfig.Callback or function() end
				ColorpickerConfig.Flag     = ColorpickerConfig.Flag     or nil
				ColorpickerConfig.Save     = ColorpickerConfig.Save     or false

				local ColorH, ColorS, ColorV = 1, 1, 1
				local Colorpicker = {Value = ColorpickerConfig.Default, Toggled = false, Type = "Colorpicker", Save = ColorpickerConfig.Save}

				local ColorSelection = Create("ImageLabel", {
					Size             = UDim2.new(0, 16, 0, 16),
					Position         = UDim2.new(select(3, Color3.toHSV(Colorpicker.Value))),
					ScaleType        = Enum.ScaleType.Fit,
					AnchorPoint      = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Image            = "http://www.roblox.com/asset/?id=4805639000",
				})

				local HueSelection = Create("ImageLabel", {
					Size             = UDim2.new(0, 16, 0, 16),
					Position         = UDim2.new(0.5, 0, 1 - select(1, Color3.toHSV(Colorpicker.Value))),
					ScaleType        = Enum.ScaleType.Fit,
					AnchorPoint      = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Image            = "http://www.roblox.com/asset/?id=4805639000",
				})

				local Color = Create("ImageLabel", {
					Size    = UDim2.new(1, -28, 1, 0),
					Visible = false,
					Image   = "rbxassetid://4155801252",
				}, {
					Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
					ColorSelection,
				})

				local Hue = Create("Frame", {
					Size     = UDim2.new(0, 18, 1, 0),
					Position = UDim2.new(1, -18, 0, 0),
					Visible  = false,
				}, {
					Create("UIGradient", {Rotation = 270, Color = ColorSequence.new{
						ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255,0,4)),
						ColorSequenceKeypoint.new(0.20, Color3.fromRGB(234,255,0)),
						ColorSequenceKeypoint.new(0.40, Color3.fromRGB(21,255,0)),
						ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0,255,255)),
						ColorSequenceKeypoint.new(0.80, Color3.fromRGB(0,17,255)),
						ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255,0,251)),
						ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255,0,4)),
					}}),
					Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
					HueSelection,
				})

				local ColorpickerContainer = Create("Frame", {
					Position         = UDim2.new(0, 0, 0, 32),
					Size             = UDim2.new(1, 0, 1, -32),
					BackgroundTransparency = 1,
					ClipsDescendants = true,
				}, {
					Hue, Color,
					Create("UIPadding", {
						PaddingLeft   = UDim.new(0, 30),
						PaddingRight  = UDim.new(0, 30),
						PaddingBottom = UDim.new(0, 10),
						PaddingTop    = UDim.new(0, 14),
					}),
				})

				local Click = SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 1, 0)})

				local ColorpickerBox = AddThemeObject(SetChildren(SetProps(
					MakeElement("RoundFrame", Color3.fromRGB(255,255,255), 0, 6), {
						Size        = UDim2.new(0, 22, 0, 22),
						AnchorPoint = Vector2.new(1, 0.5),
						Position    = UDim2.new(1, -12, 0.5, 0),
					}
				), {
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
				}), "Main")

				local ColorpickerFrame = AddThemeObject(SetChildren(SetProps(
					MakeElement("RoundFrame", Color3.fromRGB(255,255,255), 0, 8), {
						Size   = UDim2.new(1, 0, 0, 38),
						Parent = ItemParent,
					}
				), {
					SetProps(SetChildren(MakeElement("TFrame"), {
						AddThemeObject(SetProps(MakeElement("Label", ColorpickerConfig.Name, 14), {
							Size     = UDim2.new(1, -60, 1, 0),
							Position = UDim2.new(0, 14, 0, 0),
							Font     = Enum.Font.GothamSemibold,
							Name     = "Content",
						}), "Text"),
						ColorpickerBox,
						Click,
						AddThemeObject(SetProps(MakeElement("Frame"), {
							Size     = UDim2.new(1, 0, 0, 1),
							Position = UDim2.new(0, 0, 1, -1),
							Name     = "Line",
							Visible  = false,
						}), "Stroke"),
					}), {Size = UDim2.new(1, 0, 0, 38), ClipsDescendants = true, Name = "F"}),
					ColorpickerContainer,
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
				}), "Second")

				AddConnection(Click.MouseButton1Click, function()
					Colorpicker.Toggled = not Colorpicker.Toggled
					Tween(ColorpickerFrame, 0.15, {Size = Colorpicker.Toggled and UDim2.new(1, 0, 0, 148) or UDim2.new(1, 0, 0, 38)})
					Color.Visible = Colorpicker.Toggled
					Hue.Visible   = Colorpicker.Toggled
					ColorpickerFrame.F.Line.Visible = Colorpicker.Toggled
				end)

				local function UpdateColorPicker()
					ColorpickerBox.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
					Color.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
					Colorpicker:Set(ColorpickerBox.BackgroundColor3)
					ColorpickerConfig.Callback(ColorpickerBox.BackgroundColor3)
					SaveCfg(game.GameId)
				end

				ColorH = 1 - (math.clamp(HueSelection.AbsolutePosition.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
				ColorS = (math.clamp(ColorSelection.AbsolutePosition.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
				ColorV = 1 - (math.clamp(ColorSelection.AbsolutePosition.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)

				local ColorInput, HueInput
				AddConnection(Color.InputBegan, function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if ColorInput then ColorInput:Disconnect() end
						ColorInput = AddConnection(RunService.RenderStepped, function()
							ColorS = math.clamp((Mouse.X - Color.AbsolutePosition.X) / Color.AbsoluteSize.X, 0, 1)
							ColorV = 1 - math.clamp((Mouse.Y - Color.AbsolutePosition.Y) / Color.AbsoluteSize.Y, 0, 1)
							ColorSelection.Position = UDim2.new(ColorS, 0, 1-ColorV, 0)
							UpdateColorPicker()
						end)
					end
				end)
				AddConnection(Color.InputEnded, function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and ColorInput then ColorInput:Disconnect() end
				end)
				AddConnection(Hue.InputBegan, function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if HueInput then HueInput:Disconnect() end
						HueInput = AddConnection(RunService.RenderStepped, function()
							local HueY = math.clamp((Mouse.Y - Hue.AbsolutePosition.Y) / Hue.AbsoluteSize.Y, 0, 1)
							HueSelection.Position = UDim2.new(0.5, 0, HueY, 0)
							ColorH = 1 - HueY
							UpdateColorPicker()
						end)
					end
				end)
				AddConnection(Hue.InputEnded, function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and HueInput then HueInput:Disconnect() end
				end)

				function Colorpicker:Set(Value)
					Colorpicker.Value = Value
					ColorpickerBox.BackgroundColor3 = Colorpicker.Value
					ColorpickerConfig.Callback(Colorpicker.Value)
				end

				Colorpicker:Set(Colorpicker.Value)
				if ColorpickerConfig.Flag then OrionLib.Flags[ColorpickerConfig.Flag] = Colorpicker end
				return Colorpicker
			end

			return ElementFunction
		end -- GetElements

		local ElementFunction = {}

		function ElementFunction:AddSection(SectionConfig)
			SectionConfig.Name = SectionConfig.Name or "Section"

			local SectionFrame = SetChildren(SetProps(MakeElement("TFrame"), {
				Size   = UDim2.new(1, 0, 0, 26),
				Parent = Container,
			}), {
				-- section title
				SetChildren(SetProps(MakeElement("TFrame"), {
					Size = UDim2.new(1, 0, 0, 20),
				}), {
					Create("Frame", {
						Size             = UDim2.new(0, 3, 0, 12),
						AnchorPoint      = Vector2.new(0, 0.5),
						Position         = UDim2.new(0, 0, 0.5, 0),
						BackgroundColor3 = T.Accent,
						BorderSizePixel  = 0,
						BackgroundTransparency = 0.3,
					}, {Create("UICorner", {CornerRadius = UDim.new(0, 3)})}),
					AddThemeObject(SetProps(MakeElement("Label", SectionConfig.Name, 12), {
						Size     = UDim2.new(1, -10, 1, 0),
						Position = UDim2.new(0, 8, 0, 3),
						Font     = Enum.Font.GothamBold,
					}), "TextDark"),
				}),
				SetChildren(SetProps(MakeElement("TFrame"), {
					AnchorPoint = Vector2.new(0, 0),
					Size        = UDim2.new(1, 0, 1, -24),
					Position    = UDim2.new(0, 0, 0, 22),
					Name        = "Holder",
				}), {
					MakeElement("List", 0, 6),
				}),
			})

			AddConnection(SectionFrame.Holder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
				SectionFrame.Size        = UDim2.new(1, 0, 0, SectionFrame.Holder.UIListLayout.AbsoluteContentSize.Y + 30)
				SectionFrame.Holder.Size = UDim2.new(1, 0, 0, SectionFrame.Holder.UIListLayout.AbsoluteContentSize.Y)
			end)

			local SectionFunction = {}
			for i, v in next, GetElements(SectionFrame.Holder) do SectionFunction[i] = v end
			return SectionFunction
		end

		for i, v in next, GetElements(Container) do ElementFunction[i] = v end
		return ElementFunction
	end -- MakeTab

	function Functions:ChangeKey(Keybind)
		_currentKey = Keybind
	end

	function Functions:Destroy()
		for _, c in next, OrionLib.Connections do c:Disconnect() end
		MainWindow:Destroy()
		MobileIcon:Destroy()
	end

	return Functions
end

function OrionLib:Destroy()
	Orion:Destroy()
end

return OrionLib
