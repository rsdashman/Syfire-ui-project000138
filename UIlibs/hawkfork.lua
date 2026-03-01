--[[

      ___ ___                __     .____    ._____.    
     /   |   \_____ __  _  _|  | __ |    |   |__\_ |__  
    /    ~    \__  \\ \/ \/ /  |/ / |    |   |  || __ \ 
    \    Y    // __ \\     /|    <  |    |___|  || \_\ \
     \___|_  /(____  /\/\_/ |__|_ \ |_______ \__||___  /
           \/      \/            \/         \/       \/ 

    Hawk Lib - A Roblox UI Library by hankiwastaken on discord
    Version: 12/02/2026
    
    This ui lib is inspired from Fluent, Rayfield and Wind UI Libraries.
    This library is designed to be user-friendly and easy to use, with a focus on customization and performance.

    This ui library is still in development, and may contain bugs or issues.
    It has mobile compliability, even sliders and color pickers work!
    It has more than 15+ themes, and you can also create your own themes by modifying this ui lib.


    It will get updates, and new features will be added in the future. If you have any suggestions or feedback, please feel free to contact me on discord.
    Discord: hankiwastaken


]]


if not game:IsLoaded() then
	repeat
		wait()
		warn("Game should be loaded for Hawk Lib to work successfully.")
	until game:IsLoaded()
end

--Folder Creation
if not isfolder("Rise") then
	makefolder("Rise")
end

if not isfolder("Rise/Settings") then
	makefolder("Rise/Settings")
end

if not isfolder("Rise/Assets") then
	makefolder("Rise/Assets")
end

local UserInputService = game:GetService("UserInputService")
local OnPc = not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled
local OnMobile =
	UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled
local OnTabletLaptop =
	UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")
local input = game:GetService("UserInputService")
local corner = Instance.new("UICorner")
local Circle = Instance.new("ImageLabel")
local getasset = getcustomasset or getsynasset

Circle.Name = "Circle"
Circle.BackgroundColor3 = Color3.new(0.533333, 0.533333, 0.533333)
Circle.BackgroundTransparency = 1
Circle.ImageColor3 = Color3.new(0.454902, 0.454902, 0.454902)
Circle.Image = "rbxassetid://266543268"
Circle.ImageTransparency = 0.8
Circle.BorderSizePixel = 0
corner.Parent = Circle

local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function Update(input)
		local Delta = input.Position - DragStart
		local pos =
			UDim2.new(
				StartPosition.X.Scale,
				StartPosition.X.Offset + Delta.X,
				StartPosition.Y.Scale,
				StartPosition.Y.Offset + Delta.Y
			)
		local Tween = TweenService:Create(object, TweenInfo.new(0.2), {Position = pos})
		Tween:Play()
	end

	topbarobject.InputBegan:Connect(
		function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true
				DragStart = input.Position
				StartPosition = object.Position

				input.Changed:Connect(
					function()
						if input.UserInputState == Enum.UserInputState.End then
							Dragging = false
						end
					end
				)
			end
		end
	)

	topbarobject.InputChanged:Connect(
		function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseMovement or
				input.UserInputType == Enum.UserInputType.Touch
			then
				DragInput = input
			end
		end
	)

	UserInputService.InputChanged:Connect(
		function(input)
			if input == DragInput and Dragging then
				Update(input)
			end
		end
	)
end

HawkLib = {
	Themes = {
		Rise = {
			-- Genel
			Hover = Color3.fromRGB(45, 45, 45),
			Main = Color3.fromRGB(18, 18, 18),
			Shadow = Color3.fromRGB(255, 0, 4),
			TitleBar = Color3.fromRGB(18, 18, 18),
			Tabs = Color3.fromRGB(36, 36, 36),
			TabBefore = Color3.fromRGB(30, 30, 30),
			TabAfter = Color3.fromRGB(34, 34, 34),
			OpenFrame = Color3.fromRGB(31, 31, 31),
			Open = Color3.fromRGB(35, 35, 35),
			TitleTextColor = Color3.fromRGB(255, 255, 255),
			TabTextColor = Color3.fromRGB(255, 255, 255),
			TitleLineColor = Color3.fromRGB(39, 39, 39),
			PageTitleColor = Color3.fromRGB(198, 198, 198),
			Selection = Color3.fromRGB(255, 0, 4), -- Kırmızı vurgu
			CloseMinimize = Color3.fromRGB(106, 106, 106),

			-- Itemler
			ItemColors = Color3.fromRGB(27, 27, 27),
			ItemTitleColors = Color3.fromRGB(231, 231, 231),
			ItemTextColors = Color3.fromRGB(171, 171, 170),
			ItemTextBoxKeyBindColors = Color3.fromRGB(24, 24, 24),
			ItemTextBoxKeyBindStrokeColors = Color3.fromRGB(68, 68, 68),
			ItemTextBoxTextColor = Color3.fromRGB(132, 132, 132),
			ItemKeyBindTextColor = Color3.fromRGB(255, 0, 4),	
			ToggleTickColor = Color3.fromRGB(255, 0, 4),
			ButtonClickIconColor = Color3.fromRGB(213, 213, 213),
			SliderButtonFrameColor = Color3.fromRGB(55, 30, 30),
			InSliderFrame = Color3.fromRGB(255, 0, 4),
			NumColor = Color3.fromRGB(255, 255, 255),

			-- Slider (Eksik olan Gradient Slider özellikleri eklendi)
			FirstSlider = { First = Color3.fromRGB(255, 0, 4), Second = Color3.fromRGB(150, 0, 2) },
			SecondSlider = { First = Color3.fromRGB(60, 60, 60), Second = Color3.fromRGB(30, 30, 30) },

			-- Dropdown (Eksik olan Item ve Hover özellikleri eklendi)
			DropdownColorPickerImageArrowColors = Color3.fromRGB(199, 199, 199),
			DropdownItem = Color3.fromRGB(255, 255, 255),
			DropdownItemHover = Color3.fromRGB(255, 0, 4),
			DropdownItemFirst = Color3.fromRGB(40, 40, 40),
			DropdownItemSecond = Color3.fromRGB(25, 25, 25),

			-- Notify
			NotificationNotifyColor = Color3.fromRGB(42, 44, 42),
			NotificationNotifyTitleColor = Color3.fromRGB(231, 231, 231),
			NotificationNotifyTextColor = Color3.fromRGB(171, 171, 170),
			IconColor = Color3.fromRGB(255, 0, 4),
			IconShadow = Color3.fromRGB(0, 0, 0),
			NotifyButtons = Color3.fromRGB(163, 162, 165),

			-- Toggle (Eksik olan SlidingToggle özellikleri eklendi)
			ToggleFrameColor = Color3.fromRGB(40, 40, 40),
			SlidingTogglePrimer = Color3.fromRGB(80, 80, 80),
			SlidingToggleSeconder = Color3.fromRGB(30, 30, 30),

			ToggledFrameColor = Color3.fromRGB(60, 20, 20),
			SlidingToggleToggledPrimer = Color3.fromRGB(255, 0, 4),
			SlidingToggleToggledSeconder = Color3.fromRGB(150, 0, 2),
		},
		Hawk = {
			-- Genel
			Hover = Color3.fromRGB(45, 45, 50),
			Main = Color3.fromRGB(25, 25, 30),
			Shadow = Color3.fromRGB(255, 70, 85),
			TitleBar = Color3.fromRGB(30, 30, 35),
			Tabs = Color3.fromRGB(35, 35, 40),
			TabBefore = Color3.fromRGB(32, 32, 36),
			TabAfter = Color3.fromRGB(40, 40, 45),
			OpenFrame = Color3.fromRGB(30, 30, 35),
			Open = Color3.fromRGB(35, 35, 40),
			TitleTextColor = Color3.fromRGB(255, 255, 255),
			TabTextColor = Color3.fromRGB(200, 200, 210),
			TitleLineColor = Color3.fromRGB(255, 70, 85),
			PageTitleColor = Color3.fromRGB(255, 70, 85),
			Selection = Color3.fromRGB(255, 70, 85),
			CloseMinimize = Color3.fromRGB(150, 150, 160),

			-- Itemler
			ItemColors = Color3.fromRGB(35, 35, 40),
			ItemTitleColors = Color3.fromRGB(240, 240, 245),
			ItemTextColors = Color3.fromRGB(180, 180, 190),
			ItemTextBoxKeyBindColors = Color3.fromRGB(25, 25, 30),
			ItemTextBoxKeyBindStrokeColors = Color3.fromRGB(60, 60, 70),
			ItemTextBoxTextColor = Color3.fromRGB(160, 160, 170),
			ItemKeyBindTextColor = Color3.fromRGB(255, 70, 85),	
			ToggleTickColor = Color3.fromRGB(255, 70, 85),
			ButtonClickIconColor = Color3.fromRGB(255, 255, 255),
			SliderButtonFrameColor = Color3.fromRGB(45, 45, 50),
			InSliderFrame = Color3.fromRGB(255, 70, 85),
			NumColor = Color3.fromRGB(255, 100, 110),

			-- Slider (Düzeltildi)
			FirstSlider = { First = Color3.fromRGB(255, 70, 85), Second = Color3.fromRGB(200, 50, 60) },
			SecondSlider = { First = Color3.fromRGB(50, 50, 60), Second = Color3.fromRGB(30, 30, 35) },

			-- Dropdown (Okunabilir hale getirildi)
			DropdownColorPickerImageArrowColors = Color3.fromRGB(220, 220, 230),
			DropdownItem = Color3.fromRGB(255, 255, 255), -- Yazı rengi
			DropdownItemHover = Color3.fromRGB(255, 70, 85), -- Hover rengi
			DropdownItemFirst = Color3.fromRGB(40, 40, 45), -- Arka plan başı
			DropdownItemSecond = Color3.fromRGB(25, 25, 30), -- Arka plan sonu

			-- Notify
			NotificationNotifyColor = Color3.fromRGB(30, 30, 35),
			NotificationNotifyTitleColor = Color3.fromRGB(255, 255, 255),
			NotificationNotifyTextColor = Color3.fromRGB(200, 200, 210),
			IconColor = Color3.fromRGB(255, 70, 85),
			IconShadow = Color3.fromRGB(0, 0, 0),
			NotifyButtons = Color3.fromRGB(180, 180, 190),

			-- Toggle (Daha belirgin)
			ToggleFrameColor = Color3.fromRGB(40, 40, 45),
			SlidingTogglePrimer = Color3.fromRGB(80, 80, 90),
			SlidingToggleSeconder = Color3.fromRGB(30, 30, 35),

			ToggledFrameColor = Color3.fromRGB(60, 60, 70),
			SlidingToggleToggledPrimer = Color3.fromRGB(255, 70, 85),
			SlidingToggleToggledSeconder = Color3.fromRGB(150, 40, 50),
		},
		Red = {
			Hover = Color3.fromRGB(45, 30, 30),
			Main = Color3.fromRGB(20, 15, 15),
			Shadow = Color3.fromRGB(255, 60, 80),
			TitleBar = Color3.fromRGB(25, 18, 18),
			Tabs = Color3.fromRGB(35, 25, 25),
			TabBefore = Color3.fromRGB(30, 20, 20),
			TabAfter = Color3.fromRGB(40, 28, 28),
			OpenFrame = Color3.fromRGB(25, 18, 18),
			Open = Color3.fromRGB(30, 22, 22),
			TitleTextColor = Color3.fromRGB(255, 240, 240),
			TabTextColor = Color3.fromRGB(255, 200, 200),
			TitleLineColor = Color3.fromRGB(255, 60, 80),
			PageTitleColor = Color3.fromRGB(255, 100, 120),
			Selection = Color3.fromRGB(255, 40, 60),
			CloseMinimize = Color3.fromRGB(180, 100, 110),
			ItemColors = Color3.fromRGB(35, 25, 25),
			ItemTitleColors = Color3.fromRGB(255, 240, 240),
			ItemTextColors = Color3.fromRGB(200, 180, 180),
			ItemTextBoxKeyBindColors = Color3.fromRGB(25, 18, 18),
			ItemTextBoxKeyBindStrokeColors = Color3.fromRGB(100, 40, 50),
			ItemTextBoxTextColor = Color3.fromRGB(180, 150, 150),
			ItemKeyBindTextColor = Color3.fromRGB(255, 60, 80),	
			ToggleTickColor = Color3.fromRGB(255, 60, 80),
			ButtonClickIconColor = Color3.fromRGB(255, 200, 200),		
			SliderButtonFrameColor = Color3.fromRGB(60, 30, 35),
			InSliderFrame = Color3.fromRGB(255, 60, 80),
			NumColor = Color3.fromRGB(255, 130, 150),

			-- Slider
			FirstSlider = { First = Color3.fromRGB(255, 60, 80), Second = Color3.fromRGB(150, 30, 40) },
			SecondSlider = { First = Color3.fromRGB(80, 40, 45), Second = Color3.fromRGB(30, 15, 15) },

			-- Dropdown
			DropdownColorPickerImageArrowColors = Color3.fromRGB(255, 200, 200),
			DropdownItem = Color3.fromRGB(255, 240, 240),
			DropdownItemHover = Color3.fromRGB(255, 60, 80),
			DropdownItemFirst = Color3.fromRGB(50, 30, 30),
			DropdownItemSecond = Color3.fromRGB(25, 15, 15),

			NotificationNotifyColor = Color3.fromRGB(30, 20, 20),
			NotificationNotifyTitleColor = Color3.fromRGB(255, 255, 255),
			NotificationNotifyTextColor = Color3.fromRGB(200, 180, 180),
			IconColor = Color3.fromRGB(255, 60, 80),
			IconShadow = Color3.fromRGB(0, 0, 0),
			NotifyButtons = Color3.fromRGB(200, 150, 150),

			-- Toggle
			ToggleFrameColor = Color3.fromRGB(50, 30, 30),
			SlidingTogglePrimer = Color3.fromRGB(100, 50, 50),
			SlidingToggleSeconder = Color3.fromRGB(30, 15, 15),

			ToggledFrameColor = Color3.fromRGB(80, 40, 40),
			SlidingToggleToggledPrimer = Color3.fromRGB(255, 60, 80),
			SlidingToggleToggledSeconder = Color3.fromRGB(150, 30, 40),
		},
		Cyberpunk = {
			Hover = Color3.fromRGB(20, 30, 50),
			Main = Color3.fromRGB(10, 10, 20),
			Shadow = Color3.fromRGB(0, 255, 255),
			TitleBar = Color3.fromRGB(15, 15, 30),
			Tabs = Color3.fromRGB(20, 20, 40),
			TabBefore = Color3.fromRGB(18, 18, 35),
			TabAfter = Color3.fromRGB(25, 25, 50),
			OpenFrame = Color3.fromRGB(15, 15, 30),
			Open = Color3.fromRGB(20, 20, 35),
			TitleTextColor = Color3.fromRGB(0, 255, 255),
			TabTextColor = Color3.fromRGB(255, 255, 255),
			TitleLineColor = Color3.fromRGB(255, 0, 255),
			PageTitleColor = Color3.fromRGB(0, 255, 255),
			Selection = Color3.fromRGB(0, 255, 128),
			CloseMinimize = Color3.fromRGB(255, 0, 255),
			ItemColors = Color3.fromRGB(20, 20, 35),
			ItemTitleColors = Color3.fromRGB(0, 255, 255),
			ItemTextColors = Color3.fromRGB(200, 200, 255),
			ItemTextBoxKeyBindColors = Color3.fromRGB(10, 10, 25),
			ItemTextBoxKeyBindStrokeColors = Color3.fromRGB(0, 255, 255),
			ItemTextBoxTextColor = Color3.fromRGB(0, 200, 255),
			ItemKeyBindTextColor = Color3.fromRGB(255, 0, 255),
			ToggleTickColor = Color3.fromRGB(0, 255, 128),
			ButtonClickIconColor = Color3.fromRGB(0, 255, 255),
			SliderButtonFrameColor = Color3.fromRGB(30, 20, 50),
			InSliderFrame = Color3.fromRGB(0, 255, 255),
			NumColor = Color3.fromRGB(255, 0, 255),

			-- Slider (Neon Cyan)
			FirstSlider = { First = Color3.fromRGB(0, 255, 255), Second = Color3.fromRGB(0, 100, 150) },
			SecondSlider = { First = Color3.fromRGB(50, 0, 100), Second = Color3.fromRGB(20, 0, 50) },

			-- Dropdown
			DropdownColorPickerImageArrowColors = Color3.fromRGB(0, 255, 255),
			DropdownItem = Color3.fromRGB(255, 255, 255),
			DropdownItemHover = Color3.fromRGB(0, 255, 255),
			DropdownItemFirst = Color3.fromRGB(30, 30, 60),
			DropdownItemSecond = Color3.fromRGB(15, 15, 30),

			NotificationNotifyColor = Color3.fromRGB(15, 15, 30),
			NotificationNotifyTitleColor = Color3.fromRGB(0, 255, 255),
			NotificationNotifyTextColor = Color3.fromRGB(200, 200, 255),
			IconColor = Color3.fromRGB(0, 255, 255),
			IconShadow = Color3.fromRGB(255, 0, 255),
			NotifyButtons = Color3.fromRGB(0, 255, 200),

			-- Toggle (Neon Green/Pink)
			ToggleFrameColor = Color3.fromRGB(20, 20, 40),
			SlidingTogglePrimer = Color3.fromRGB(0, 100, 100),
			SlidingToggleSeconder = Color3.fromRGB(10, 10, 20),

			ToggledFrameColor = Color3.fromRGB(0, 50, 100),
			SlidingToggleToggledPrimer = Color3.fromRGB(0, 255, 128),
			SlidingToggleToggledSeconder = Color3.fromRGB(0, 200, 200),
		},
		TokyoNight = {
			Hover = Color3.fromRGB(53, 55, 77),
			Main = Color3.fromRGB(26, 27, 38),
			Shadow = Color3.fromRGB(122, 162, 247),
			TitleBar = Color3.fromRGB(31, 32, 45),
			Tabs = Color3.fromRGB(36, 37, 50),
			TabBefore = Color3.fromRGB(34, 36, 50),
			TabAfter = Color3.fromRGB(43, 45, 63),
			OpenFrame = Color3.fromRGB(31, 32, 45),
			Open = Color3.fromRGB(35, 36, 49),
			TitleTextColor = Color3.fromRGB(169, 177, 214),
			TabTextColor = Color3.fromRGB(192, 202, 245),
			TitleLineColor = Color3.fromRGB(86, 95, 137),
			PageTitleColor = Color3.fromRGB(122, 162, 247),
			Selection = Color3.fromRGB(158, 206, 106),
			CloseMinimize = Color3.fromRGB(224, 175, 104),
			ItemColors = Color3.fromRGB(43, 45, 63),
			ItemTitleColors = Color3.fromRGB(192, 202, 245),
			ItemTextColors = Color3.fromRGB(169, 177, 214),
			ItemTextBoxKeyBindColors = Color3.fromRGB(22, 23, 33),
			ItemTextBoxKeyBindStrokeColors = Color3.fromRGB(86, 95, 137),
			ItemTextBoxTextColor = Color3.fromRGB(133, 148, 186),
			ItemKeyBindTextColor = Color3.fromRGB(158, 206, 106),
			ToggleTickColor = Color3.fromRGB(158, 206, 106),
			ButtonClickIconColor = Color3.fromRGB(122, 162, 247),

			SliderButtonFrameColor = Color3.fromRGB(41, 46, 66),
			InSliderFrame = Color3.fromRGB(224, 175, 104),
			NumColor = Color3.fromRGB(187, 154, 247),

			-- Slider (Daha pastel)
			FirstSlider = { First = Color3.fromRGB(122, 162, 247), Second = Color3.fromRGB(60, 80, 120) },
			SecondSlider = { First = Color3.fromRGB(50, 50, 65), Second = Color3.fromRGB(30, 30, 40) },

			-- Dropdown
			DropdownColorPickerImageArrowColors = Color3.fromRGB(169, 177, 214),
			DropdownItem = Color3.fromRGB(255, 255, 255),
			DropdownItemHover = Color3.fromRGB(122, 162, 247),
			DropdownItemFirst = Color3.fromRGB(50, 52, 70),
			DropdownItemSecond = Color3.fromRGB(30, 30, 40),

			NotificationNotifyColor = Color3.fromRGB(31, 32, 45),
			NotificationNotifyTitleColor = Color3.fromRGB(192, 202, 245),
			NotificationNotifyTextColor = Color3.fromRGB(169, 177, 214),
			IconColor = Color3.fromRGB(122, 162, 247),
			IconShadow = Color3.fromRGB(26, 27, 38),
			NotifyButtons = Color3.fromRGB(158, 206, 106),

			-- Toggle (Yeşil/Mavi uyumu)
			ToggleFrameColor = Color3.fromRGB(61, 61, 81),
			SlidingTogglePrimer = Color3.fromRGB(86, 95, 137),
			SlidingToggleSeconder = Color3.fromRGB(30, 30, 40),

			ToggledFrameColor = Color3.fromRGB(50, 60, 80),
			SlidingToggleToggledPrimer = Color3.fromRGB(158, 206, 106),
			SlidingToggleToggledSeconder = Color3.fromRGB(100, 140, 70),
		},
		OLED = {
			Hover = Color3.fromRGB(25, 25, 25),
			Main = Color3.fromRGB(0, 0, 0),
			Shadow = Color3.fromRGB(255, 255, 255),
			TitleBar = Color3.fromRGB(5, 5, 5),
			Tabs = Color3.fromRGB(10, 10, 10),
			TabBefore = Color3.fromRGB(8, 8, 8),
			TabAfter = Color3.fromRGB(15, 15, 15),
			OpenFrame = Color3.fromRGB(5, 5, 5),
			Open = Color3.fromRGB(10, 10, 10),
			TitleTextColor = Color3.fromRGB(255, 255, 255),
			TabTextColor = Color3.fromRGB(220, 220, 220),
			TitleLineColor = Color3.fromRGB(80, 80, 80),
			PageTitleColor = Color3.fromRGB(255, 255, 255),
			Selection = Color3.fromRGB(0, 255, 0), -- Matrix Green
			CloseMinimize = Color3.fromRGB(150, 150, 150),
			ItemColors = Color3.fromRGB(12, 12, 12),
			ItemTitleColors = Color3.fromRGB(255, 255, 255),
			ItemTextColors = Color3.fromRGB(180, 180, 180),
			ItemTextBoxKeyBindColors = Color3.fromRGB(5, 5, 5),
			ItemTextBoxKeyBindStrokeColors = Color3.fromRGB(50, 50, 50),
			ItemTextBoxTextColor = Color3.fromRGB(200, 200, 200),
			ItemKeyBindTextColor = Color3.fromRGB(0, 255, 0),
			ToggleTickColor = Color3.fromRGB(0, 255, 0),
			ButtonClickIconColor = Color3.fromRGB(255, 255, 255),
			SliderButtonFrameColor = Color3.fromRGB(20, 20, 20),
			InSliderFrame = Color3.fromRGB(255, 255, 255),
			NumColor = Color3.fromRGB(0, 255, 0),

			-- Slider (Siyah/Beyaz/Yeşil)
			FirstSlider = { First = Color3.fromRGB(0, 255, 0), Second = Color3.fromRGB(0, 100, 0) },
			SecondSlider = { First = Color3.fromRGB(40, 40, 40), Second = Color3.fromRGB(10, 10, 10) },

			-- Dropdown
			DropdownColorPickerImageArrowColors = Color3.fromRGB(255, 255, 255),
			DropdownItem = Color3.fromRGB(255, 255, 255),
			DropdownItemHover = Color3.fromRGB(0, 255, 0),
			DropdownItemFirst = Color3.fromRGB(20, 20, 20),
			DropdownItemSecond = Color3.fromRGB(5, 5, 5),

			NotificationNotifyColor = Color3.fromRGB(10, 10, 10),
			NotificationNotifyTitleColor = Color3.fromRGB(255, 255, 255),
			NotificationNotifyTextColor = Color3.fromRGB(200, 200, 200),
			IconColor = Color3.fromRGB(255, 255, 255),
			IconShadow = Color3.fromRGB(0, 0, 0),
			NotifyButtons = Color3.fromRGB(0, 255, 0),

			-- Toggle
			ToggleFrameColor = Color3.fromRGB(30, 30, 30),
			SlidingTogglePrimer = Color3.fromRGB(60, 60, 60),
			SlidingToggleSeconder = Color3.fromRGB(10, 10, 10),

			ToggledFrameColor = Color3.fromRGB(40, 40, 40),
			SlidingToggleToggledPrimer = Color3.fromRGB(0, 255, 0),
			SlidingToggleToggledSeconder = Color3.fromRGB(0, 100, 0),
		},
		BloodRed = {
			Hover = Color3.fromRGB(50, 20, 20),
			Main = Color3.fromRGB(15, 8, 8),
			Shadow = Color3.fromRGB(220, 20, 60),
			TitleBar = Color3.fromRGB(20, 12, 12),
			Tabs = Color3.fromRGB(30, 18, 18),
			TabBefore = Color3.fromRGB(25, 15, 15),
			TabAfter = Color3.fromRGB(35, 22, 22),
			OpenFrame = Color3.fromRGB(25, 15, 15),
			Open = Color3.fromRGB(30, 18, 18),
			TitleTextColor = Color3.fromRGB(255, 80, 80),
			TabTextColor = Color3.fromRGB(255, 200, 200),
			TitleLineColor = Color3.fromRGB(180, 0, 0),
			PageTitleColor = Color3.fromRGB(255, 0, 0),
			Selection = Color3.fromRGB(255, 0, 0),
			CloseMinimize = Color3.fromRGB(200, 50, 50),
			ItemColors = Color3.fromRGB(25, 15, 15),
			ItemTitleColors = Color3.fromRGB(255, 80, 80),
			ItemTextColors = Color3.fromRGB(220, 180, 180),
			ItemTextBoxKeyBindColors = Color3.fromRGB(15, 10, 10),
			ItemTextBoxKeyBindStrokeColors = Color3.fromRGB(120, 30, 30),
			ItemTextBoxTextColor = Color3.fromRGB(200, 150, 150),
			ItemKeyBindTextColor = Color3.fromRGB(255, 50, 50),
			ToggleTickColor = Color3.fromRGB(255, 0, 0),
			ButtonClickIconColor = Color3.fromRGB(255, 80, 80),
			SliderButtonFrameColor = Color3.fromRGB(45, 20, 20),
			InSliderFrame = Color3.fromRGB(255, 0, 0),
			NumColor = Color3.fromRGB(255, 80, 80),

			-- Slider (Kan Kırmızısı)
			FirstSlider = { First = Color3.fromRGB(255, 0, 0), Second = Color3.fromRGB(139, 0, 0) },
			SecondSlider = { First = Color3.fromRGB(80, 20, 20), Second = Color3.fromRGB(30, 10, 10) },

			-- Dropdown
			DropdownColorPickerImageArrowColors = Color3.fromRGB(255, 150, 150),
			DropdownItem = Color3.fromRGB(255, 220, 220),
			DropdownItemHover = Color3.fromRGB(255, 0, 0),
			DropdownItemFirst = Color3.fromRGB(60, 20, 20),
			DropdownItemSecond = Color3.fromRGB(20, 10, 10),

			NotificationNotifyColor = Color3.fromRGB(20, 10, 10),
			NotificationNotifyTitleColor = Color3.fromRGB(255, 80, 80),
			NotificationNotifyTextColor = Color3.fromRGB(220, 150, 150),
			IconColor = Color3.fromRGB(255, 0, 0),
			IconShadow = Color3.fromRGB(100, 0, 0),
			NotifyButtons = Color3.fromRGB(255, 50, 50),

			-- Toggle
			ToggleFrameColor = Color3.fromRGB(60, 20, 20),
			SlidingTogglePrimer = Color3.fromRGB(120, 50, 50),
			SlidingToggleSeconder = Color3.fromRGB(30, 10, 10),

			ToggledFrameColor = Color3.fromRGB(100, 20, 20),
			SlidingToggleToggledPrimer = Color3.fromRGB(255, 0, 0),
			SlidingToggleToggledSeconder = Color3.fromRGB(139, 0, 0),
		},
		White = {
			Hover = Color3.fromRGB(230, 235, 240),
			Main = Color3.fromRGB(255, 255, 255),
			Shadow = Color3.fromRGB(200, 200, 200),
			TitleBar = Color3.fromRGB(245, 245, 250),
			Tabs = Color3.fromRGB(235, 235, 240),
			TabBefore = Color3.fromRGB(240, 240, 245),
			TabAfter = Color3.fromRGB(225, 225, 230),
			OpenFrame = Color3.fromRGB(245, 245, 250),
			Open = Color3.fromRGB(240, 240, 245),
			TitleTextColor = Color3.fromRGB(50, 50, 60),
			TabTextColor = Color3.fromRGB(80, 80, 90),
			TitleLineColor = Color3.fromRGB(200, 200, 200),
			PageTitleColor = Color3.fromRGB(0, 122, 255),
			Selection = Color3.fromRGB(0, 122, 255),
			CloseMinimize = Color3.fromRGB(150, 150, 160),
			ItemColors = Color3.fromRGB(250, 250, 255),
			ItemTitleColors = Color3.fromRGB(50, 50, 60),
			ItemTextColors = Color3.fromRGB(100, 100, 110),
			ItemTextBoxKeyBindColors = Color3.fromRGB(240, 240, 245),
			ItemTextBoxKeyBindStrokeColors = Color3.fromRGB(200, 200, 210),
			ItemTextBoxTextColor = Color3.fromRGB(80, 80, 90),
			ItemKeyBindTextColor = Color3.fromRGB(0, 122, 255),
			ToggleTickColor = Color3.fromRGB(0, 122, 255),
			ButtonClickIconColor = Color3.fromRGB(50, 50, 60),
			SliderButtonFrameColor = Color3.fromRGB(230, 230, 240),
			InSliderFrame = Color3.fromRGB(0, 122, 255),
			NumColor = Color3.fromRGB(0, 122, 255),

			-- Slider (Mavi/Gri)
			FirstSlider = { First = Color3.fromRGB(0, 122, 255), Second = Color3.fromRGB(100, 180, 255) },
			SecondSlider = { First = Color3.fromRGB(220, 220, 230), Second = Color3.fromRGB(200, 200, 210) },

			-- Dropdown (Yazı koyu, arka plan açık)
			DropdownColorPickerImageArrowColors = Color3.fromRGB(100, 100, 110),
			DropdownItem = Color3.fromRGB(50, 50, 60), -- Koyu yazı
			DropdownItemHover = Color3.fromRGB(0, 122, 255),
			DropdownItemFirst = Color3.fromRGB(240, 240, 250), -- Açık arka plan
			DropdownItemSecond = Color3.fromRGB(220, 220, 230),

			NotificationNotifyColor = Color3.fromRGB(245, 245, 250),
			NotificationNotifyTitleColor = Color3.fromRGB(50, 50, 60),
			NotificationNotifyTextColor = Color3.fromRGB(100, 100, 110),
			IconColor = Color3.fromRGB(0, 122, 255),
			IconShadow = Color3.fromRGB(200, 200, 200),
			NotifyButtons = Color3.fromRGB(0, 122, 255),

			-- Toggle (iOS Style)
			ToggleFrameColor = Color3.fromRGB(220, 220, 230),
			SlidingTogglePrimer = Color3.fromRGB(180, 180, 190),
			SlidingToggleSeconder = Color3.fromRGB(240, 240, 250),

			ToggledFrameColor = Color3.fromRGB(200, 210, 255),
			SlidingToggleToggledPrimer = Color3.fromRGB(0, 122, 255),
			SlidingToggleToggledSeconder = Color3.fromRGB(50, 150, 255),
		},
		Ubuntu = {
			Hover = Color3.fromRGB(70, 25, 50),
			Main = Color3.fromRGB(48, 10, 36),
			Shadow = Color3.fromRGB(233, 84, 32),
			TitleBar = Color3.fromRGB(56, 14, 42),
			Tabs = Color3.fromRGB(64, 18, 48),
			TabBefore = Color3.fromRGB(60, 16, 45),
			TabAfter = Color3.fromRGB(72, 22, 54),
			OpenFrame = Color3.fromRGB(56, 14, 42),
			Open = Color3.fromRGB(64, 18, 48),
			TitleTextColor = Color3.fromRGB(255, 255, 255),
			TabTextColor = Color3.fromRGB(240, 240, 240),
			TitleLineColor = Color3.fromRGB(233, 84, 32),
			PageTitleColor = Color3.fromRGB(233, 84, 32),
			Selection = Color3.fromRGB(233, 84, 32),
			CloseMinimize = Color3.fromRGB(200, 60, 30),
			ItemColors = Color3.fromRGB(64, 18, 48),
			ItemTitleColors = Color3.fromRGB(255, 255, 255),
			ItemTextColors = Color3.fromRGB(200, 180, 190),
			ItemTextBoxKeyBindColors = Color3.fromRGB(40, 10, 30),
			ItemTextBoxKeyBindStrokeColors = Color3.fromRGB(172, 45, 130),
			ItemTextBoxTextColor = Color3.fromRGB(180, 160, 170),
			ItemKeyBindTextColor = Color3.fromRGB(233, 84, 32),
			ToggleTickColor = Color3.fromRGB(233, 84, 32),
			ButtonClickIconColor = Color3.fromRGB(255, 255, 255),
			SliderButtonFrameColor = Color3.fromRGB(56, 20, 44),
			InSliderFrame = Color3.fromRGB(233, 84, 32),
			NumColor = Color3.fromRGB(255, 255, 255),

			-- Slider (Ubuntu Orange/Purple)
			FirstSlider = { First = Color3.fromRGB(233, 84, 32), Second = Color3.fromRGB(200, 60, 20) },
			SecondSlider = { First = Color3.fromRGB(100, 30, 80), Second = Color3.fromRGB(40, 10, 30) },

			-- Dropdown
			DropdownColorPickerImageArrowColors = Color3.fromRGB(200, 180, 190),
			DropdownItem = Color3.fromRGB(255, 255, 255),
			DropdownItemHover = Color3.fromRGB(233, 84, 32),
			DropdownItemFirst = Color3.fromRGB(70, 25, 55),
			DropdownItemSecond = Color3.fromRGB(48, 10, 36),

			NotificationNotifyColor = Color3.fromRGB(56, 14, 42),
			NotificationNotifyTitleColor = Color3.fromRGB(255, 255, 255),
			NotificationNotifyTextColor = Color3.fromRGB(200, 180, 190),
			IconColor = Color3.fromRGB(233, 84, 32),
			IconShadow = Color3.fromRGB(48, 10, 36),
			NotifyButtons = Color3.fromRGB(233, 84, 32),

			-- Toggle
			ToggleFrameColor = Color3.fromRGB(70, 25, 55),
			SlidingTogglePrimer = Color3.fromRGB(120, 40, 90),
			SlidingToggleSeconder = Color3.fromRGB(40, 10, 30),

			ToggledFrameColor = Color3.fromRGB(100, 30, 80),
			SlidingToggleToggledPrimer = Color3.fromRGB(233, 84, 32),
			SlidingToggleToggledSeconder = Color3.fromRGB(170, 60, 20),
		},
		Glacier = {
			Hover = Color3.fromRGB(210, 230, 245),
			Main = Color3.fromRGB(240, 248, 255),
			Shadow = Color3.fromRGB(176, 196, 222),
			TitleBar = Color3.fromRGB(230, 245, 255),
			Tabs = Color3.fromRGB(220, 240, 250),
			TabBefore = Color3.fromRGB(235, 248, 255),
			TabAfter = Color3.fromRGB(200, 230, 245),
			OpenFrame = Color3.fromRGB(230, 245, 255),
			Open = Color3.fromRGB(240, 248, 255),
			TitleTextColor = Color3.fromRGB(25, 55, 75),
			TabTextColor = Color3.fromRGB(50, 90, 110),
			TitleLineColor = Color3.fromRGB(173, 216, 230),
			PageTitleColor = Color3.fromRGB(70, 130, 180),
			Selection = Color3.fromRGB(0, 191, 255),
			CloseMinimize = Color3.fromRGB(100, 149, 237),
			ItemColors = Color3.fromRGB(245, 252, 255),
			ItemTitleColors = Color3.fromRGB(25, 55, 75),
			ItemTextColors = Color3.fromRGB(70, 110, 130),
			ItemTextBoxKeyBindColors = Color3.fromRGB(225, 245, 255),
			ItemTextBoxKeyBindStrokeColors = Color3.fromRGB(176, 196, 222),
			ItemTextBoxTextColor = Color3.fromRGB(60, 100, 120),
			ItemKeyBindTextColor = Color3.fromRGB(0, 150, 200),
			ToggleTickColor = Color3.fromRGB(0, 191, 255),
			ButtonClickIconColor = Color3.fromRGB(70, 130, 180),
			SliderButtonFrameColor = Color3.fromRGB(200, 230, 245),
			InSliderFrame = Color3.fromRGB(0, 191, 255),
			NumColor = Color3.fromRGB(0, 150, 200),

			-- Slider (Buz Mavisi)
			FirstSlider = { First = Color3.fromRGB(0, 191, 255), Second = Color3.fromRGB(100, 149, 237) },
			SecondSlider = { First = Color3.fromRGB(200, 230, 245), Second = Color3.fromRGB(176, 196, 222) },

			-- Dropdown
			DropdownColorPickerImageArrowColors = Color3.fromRGB(70, 110, 130),
			DropdownItem = Color3.fromRGB(25, 55, 75), -- Koyu yazı
			DropdownItemHover = Color3.fromRGB(0, 191, 255),
			DropdownItemFirst = Color3.fromRGB(220, 240, 250),
			DropdownItemSecond = Color3.fromRGB(200, 230, 245),

			NotificationNotifyColor = Color3.fromRGB(230, 245, 255),
			NotificationNotifyTitleColor = Color3.fromRGB(25, 55, 75),
			NotificationNotifyTextColor = Color3.fromRGB(70, 110, 130),
			IconColor = Color3.fromRGB(70, 130, 180),
			IconShadow = Color3.fromRGB(176, 196, 222),
			NotifyButtons = Color3.fromRGB(0, 191, 255),

			-- Toggle
			ToggleFrameColor = Color3.fromRGB(180, 210, 230),
			SlidingTogglePrimer = Color3.fromRGB(150, 180, 200),
			SlidingToggleSeconder = Color3.fromRGB(220, 240, 255),

			ToggledFrameColor = Color3.fromRGB(160, 200, 240),
			SlidingToggleToggledPrimer = Color3.fromRGB(0, 191, 255),
			SlidingToggleToggledSeconder = Color3.fromRGB(135, 206, 250),
		},
		Midnight = {
			Hover = Color3.fromRGB(35, 35, 60),
			Main = Color3.fromRGB(10, 10, 25),
			Shadow = Color3.fromRGB(75, 0, 130),
			TitleBar = Color3.fromRGB(15, 15, 35),
			Tabs = Color3.fromRGB(20, 20, 45),
			TabBefore = Color3.fromRGB(18, 18, 40),
			TabAfter = Color3.fromRGB(30, 30, 60),
			OpenFrame = Color3.fromRGB(15, 15, 35),
			Open = Color3.fromRGB(20, 20, 40),
			TitleTextColor = Color3.fromRGB(180, 200, 255),
			TabTextColor = Color3.fromRGB(160, 160, 200),
			TitleLineColor = Color3.fromRGB(100, 50, 180),
			PageTitleColor = Color3.fromRGB(147, 112, 219),
			Selection = Color3.fromRGB(0, 255, 255),
			CloseMinimize = Color3.fromRGB(148, 0, 211),
			ItemColors = Color3.fromRGB(20, 20, 40),
			ItemTitleColors = Color3.fromRGB(180, 200, 255),
			ItemTextColors = Color3.fromRGB(150, 150, 190),
			ItemTextBoxKeyBindColors = Color3.fromRGB(10, 10, 25),
			ItemTextBoxKeyBindStrokeColors = Color3.fromRGB(75, 0, 130),
			ItemTextBoxTextColor = Color3.fromRGB(120, 120, 160),
			ItemKeyBindTextColor = Color3.fromRGB(186, 85, 211),
			ToggleTickColor = Color3.fromRGB(0, 255, 255),
			ButtonClickIconColor = Color3.fromRGB(138, 180, 248),
			SliderButtonFrameColor = Color3.fromRGB(30, 30, 60),
			InSliderFrame = Color3.fromRGB(0, 255, 255),
			NumColor = Color3.fromRGB(186, 85, 211),

			-- Slider (Mor/Cyan)
			FirstSlider = { First = Color3.fromRGB(147, 112, 219), Second = Color3.fromRGB(75, 0, 130) },
			SecondSlider = { First = Color3.fromRGB(40, 40, 70), Second = Color3.fromRGB(20, 20, 40) },

			-- Dropdown
			DropdownColorPickerImageArrowColors = Color3.fromRGB(150, 150, 190),
			DropdownItem = Color3.fromRGB(200, 220, 255),
			DropdownItemHover = Color3.fromRGB(0, 255, 255),
			DropdownItemFirst = Color3.fromRGB(35, 35, 70),
			DropdownItemSecond = Color3.fromRGB(15, 15, 35),

			NotificationNotifyColor = Color3.fromRGB(15, 15, 35),
			NotificationNotifyTitleColor = Color3.fromRGB(138, 180, 248),
			NotificationNotifyTextColor = Color3.fromRGB(150, 150, 190),
			IconColor = Color3.fromRGB(147, 112, 219),
			IconShadow = Color3.fromRGB(75, 0, 130),
			NotifyButtons = Color3.fromRGB(0, 255, 255),

			-- Toggle
			ToggleFrameColor = Color3.fromRGB(30, 30, 60),
			SlidingTogglePrimer = Color3.fromRGB(60, 40, 100),
			SlidingToggleSeconder = Color3.fromRGB(15, 15, 30),

			ToggledFrameColor = Color3.fromRGB(50, 40, 100),
			SlidingToggleToggledPrimer = Color3.fromRGB(0, 255, 255),
			SlidingToggleToggledSeconder = Color3.fromRGB(0, 150, 200),
		},
		Anime = {
			Hover = Color3.fromRGB(255, 230, 240),
			Main = Color3.fromRGB(255, 240, 245),
			Shadow = Color3.fromRGB(255, 182, 193),
			TitleBar = Color3.fromRGB(255, 228, 235),
			Tabs = Color3.fromRGB(255, 220, 230),
			TabBefore = Color3.fromRGB(255, 235, 240),
			TabAfter = Color3.fromRGB(255, 200, 220),
			OpenFrame = Color3.fromRGB(255, 228, 235),
			Open = Color3.fromRGB(255, 240, 245),
			TitleTextColor = Color3.fromRGB(139, 69, 101),
			TabTextColor = Color3.fromRGB(150, 90, 110),
			TitleLineColor = Color3.fromRGB(255, 105, 180),
			PageTitleColor = Color3.fromRGB(255, 20, 147),
			Selection = Color3.fromRGB(255, 105, 180),
			CloseMinimize = Color3.fromRGB(255, 160, 180),
			ItemColors = Color3.fromRGB(255, 245, 250),
			ItemTitleColors = Color3.fromRGB(139, 69, 101),
			ItemTextColors = Color3.fromRGB(180, 130, 150),
			ItemTextBoxKeyBindColors = Color3.fromRGB(255, 235, 245),
			ItemTextBoxKeyBindStrokeColors = Color3.fromRGB(255, 182, 193),
			ItemTextBoxTextColor = Color3.fromRGB(180, 140, 160),
			ItemKeyBindTextColor = Color3.fromRGB(255, 105, 180),
			ToggleTickColor = Color3.fromRGB(255, 105, 180),
			ButtonClickIconColor = Color3.fromRGB(139, 69, 101),
			SliderButtonFrameColor = Color3.fromRGB(255, 210, 225),
			InSliderFrame = Color3.fromRGB(255, 105, 180),
			NumColor = Color3.fromRGB(255, 20, 147),

			-- Slider (Hot Pink)
			FirstSlider = { First = Color3.fromRGB(255, 105, 180), Second = Color3.fromRGB(255, 20, 147) },
			SecondSlider = { First = Color3.fromRGB(255, 220, 230), Second = Color3.fromRGB(255, 200, 220) },

			-- Dropdown
			DropdownColorPickerImageArrowColors = Color3.fromRGB(160, 120, 140),
			DropdownItem = Color3.fromRGB(139, 69, 101),
			DropdownItemHover = Color3.fromRGB(255, 20, 147),
			DropdownItemFirst = Color3.fromRGB(255, 235, 245),
			DropdownItemSecond = Color3.fromRGB(255, 220, 235),

			NotificationNotifyColor = Color3.fromRGB(255, 228, 235),
			NotificationNotifyTitleColor = Color3.fromRGB(139, 69, 101),
			NotificationNotifyTextColor = Color3.fromRGB(160, 120, 140),
			IconColor = Color3.fromRGB(255, 105, 180),
			IconShadow = Color3.fromRGB(255, 182, 193),
			NotifyButtons = Color3.fromRGB(255, 105, 180),

			-- Toggle
			ToggleFrameColor = Color3.fromRGB(255, 200, 220),
			SlidingTogglePrimer = Color3.fromRGB(255, 180, 200),
			SlidingToggleSeconder = Color3.fromRGB(255, 230, 240),

			ToggledFrameColor = Color3.fromRGB(255, 150, 180),
			SlidingToggleToggledPrimer = Color3.fromRGB(255, 20, 147),
			SlidingToggleToggledSeconder = Color3.fromRGB(255, 105, 180),
		},
		Femboy = {
			Hover = Color3.fromRGB(255, 235, 245),
			Main = Color3.fromRGB(255, 245, 250),
			Shadow = Color3.fromRGB(255, 192, 203),
			TitleBar = Color3.fromRGB(255, 240, 245),
			Tabs = Color3.fromRGB(255, 235, 240),
			TabBefore = Color3.fromRGB(255, 248, 250),
			TabAfter = Color3.fromRGB(255, 220, 230),
			OpenFrame = Color3.fromRGB(255, 240, 245),
			Open = Color3.fromRGB(255, 245, 250),
			TitleTextColor = Color3.fromRGB(219, 112, 147),
			TabTextColor = Color3.fromRGB(199, 21, 133),
			TitleLineColor = Color3.fromRGB(255, 182, 193),
			PageTitleColor = Color3.fromRGB(255, 20, 147),
			Selection = Color3.fromRGB(255, 105, 180),
			CloseMinimize = Color3.fromRGB(255, 160, 180),
			ItemColors = Color3.fromRGB(255, 250, 252),
			ItemTitleColors = Color3.fromRGB(219, 112, 147),
			ItemTextColors = Color3.fromRGB(180, 120, 140),
			ItemTextBoxKeyBindColors = Color3.fromRGB(255, 240, 245),
			ItemTextBoxKeyBindStrokeColors = Color3.fromRGB(255, 182, 193),
			ItemTextBoxTextColor = Color3.fromRGB(200, 160, 170),
			ItemKeyBindTextColor = Color3.fromRGB(255, 20, 147),
			ToggleTickColor = Color3.fromRGB(255, 105, 180),
			ButtonClickIconColor = Color3.fromRGB(219, 112, 147),
			SliderButtonFrameColor = Color3.fromRGB(255, 220, 235),
			InSliderFrame = Color3.fromRGB(255, 105, 180),
			NumColor = Color3.fromRGB(255, 20, 147),

			-- Slider (Pastel Pembe)
			FirstSlider = { First = Color3.fromRGB(255, 105, 180), Second = Color3.fromRGB(255, 182, 193) },
			SecondSlider = { First = Color3.fromRGB(255, 230, 240), Second = Color3.fromRGB(255, 210, 225) },

			-- Dropdown
			DropdownColorPickerImageArrowColors = Color3.fromRGB(180, 120, 140),
			DropdownItem = Color3.fromRGB(219, 112, 147),
			DropdownItemHover = Color3.fromRGB(255, 20, 147),
			DropdownItemFirst = Color3.fromRGB(255, 240, 250),
			DropdownItemSecond = Color3.fromRGB(255, 230, 240),

			NotificationNotifyColor = Color3.fromRGB(255, 240, 245),
			NotificationNotifyTitleColor = Color3.fromRGB(219, 112, 147),
			NotificationNotifyTextColor = Color3.fromRGB(180, 120, 140),
			IconColor = Color3.fromRGB(255, 182, 193),
			IconShadow = Color3.fromRGB(255, 192, 203),
			NotifyButtons = Color3.fromRGB(255, 105, 180),

			-- Toggle
			ToggleFrameColor = Color3.fromRGB(255, 210, 230),
			SlidingTogglePrimer = Color3.fromRGB(255, 190, 210),
			SlidingToggleSeconder = Color3.fromRGB(255, 245, 255),

			ToggledFrameColor = Color3.fromRGB(255, 160, 190),
			SlidingToggleToggledPrimer = Color3.fromRGB(255, 105, 180),
			SlidingToggleToggledSeconder = Color3.fromRGB(255, 182, 193),
		},
		Hanki = {
			Hover = Color3.fromRGB(40, 70, 110),
			Main = Color3.fromRGB(25, 50, 80),
			Shadow = Color3.fromRGB(255, 140, 0),
			TitleBar = Color3.fromRGB(30, 60, 95),
			Tabs = Color3.fromRGB(35, 70, 110),
			TabBefore = Color3.fromRGB(29, 66, 108),
			TabAfter = Color3.fromRGB(40, 75, 115),
			OpenFrame = Color3.fromRGB(30, 60, 95),
			Open = Color3.fromRGB(25, 50, 80),
			TitleTextColor = Color3.fromRGB(255, 140, 0),
			TabTextColor = Color3.fromRGB(255, 165, 0),
			TitleLineColor = Color3.fromRGB(255, 140, 0),
			PageTitleColor = Color3.fromRGB(255, 69, 0),
			Selection = Color3.fromRGB(255, 140, 0),
			CloseMinimize = Color3.fromRGB(255, 100, 0),
			ItemColors = Color3.fromRGB(35, 65, 100),
			ItemTitleColors = Color3.fromRGB(255, 140, 0),
			ItemTextColors = Color3.fromRGB(255, 180, 80),
			ItemTextBoxKeyBindColors = Color3.fromRGB(20, 40, 65),
			ItemTextBoxKeyBindStrokeColors = Color3.fromRGB(255, 140, 0),
			ItemTextBoxTextColor = Color3.fromRGB(255, 160, 60),
			ItemKeyBindTextColor = Color3.fromRGB(255, 69, 0),
			ToggleTickColor = Color3.fromRGB(255, 140, 0),
			ButtonClickIconColor = Color3.fromRGB(255, 140, 0),
			SliderButtonFrameColor = Color3.fromRGB(20, 45, 75),
			InSliderFrame = Color3.fromRGB(0, 150, 255),
			NumColor = Color3.fromRGB(0, 200, 255),

			-- Slider (Turuncu/Mavi Kontrast)
			FirstSlider = { First = Color3.fromRGB(255, 140, 0), Second = Color3.fromRGB(200, 100, 0) },
			SecondSlider = { First = Color3.fromRGB(40, 70, 110), Second = Color3.fromRGB(20, 40, 65) },

			-- Dropdown
			DropdownColorPickerImageArrowColors = Color3.fromRGB(255, 180, 80),
			DropdownItem = Color3.fromRGB(255, 255, 255),
			DropdownItemHover = Color3.fromRGB(255, 140, 0),
			DropdownItemFirst = Color3.fromRGB(40, 75, 115),
			DropdownItemSecond = Color3.fromRGB(20, 45, 75),

			NotificationNotifyColor = Color3.fromRGB(30, 60, 95),
			NotificationNotifyTitleColor = Color3.fromRGB(255, 140, 0),
			NotificationNotifyTextColor = Color3.fromRGB(255, 180, 80),
			IconColor = Color3.fromRGB(255, 140, 0),
			IconShadow = Color3.fromRGB(255, 100, 0),
			NotifyButtons = Color3.fromRGB(0, 150, 255),

			-- Toggle
			ToggleFrameColor = Color3.fromRGB(40, 70, 100),
			SlidingTogglePrimer = Color3.fromRGB(80, 110, 150),
			SlidingToggleSeconder = Color3.fromRGB(20, 40, 65),

			ToggledFrameColor = Color3.fromRGB(50, 90, 130),
			SlidingToggleToggledPrimer = Color3.fromRGB(255, 140, 0),
			SlidingToggleToggledSeconder = Color3.fromRGB(200, 100, 0),
		},
		Ocean = {
			-- Okyanus mavisi tema - sakinleştirici ve profesyonel
			Hover = Color3.fromRGB(30, 50, 70),
			Main = Color3.fromRGB(15, 30, 50),
			Shadow = Color3.fromRGB(0, 180, 255),
			TitleBar = Color3.fromRGB(20, 38, 60),
			Tabs = Color3.fromRGB(28, 48, 72),
			TabBefore = Color3.fromRGB(25, 43, 66),
			TabAfter = Color3.fromRGB(32, 52, 77),
			OpenFrame = Color3.fromRGB(20, 38, 60),
			Open = Color3.fromRGB(25, 43, 66),
			TitleTextColor = Color3.fromRGB(200, 240, 255),
			TabTextColor = Color3.fromRGB(180, 220, 255),
			TitleLineColor = Color3.fromRGB(0, 180, 255),
			PageTitleColor = Color3.fromRGB(100, 210, 255),
			Selection = Color3.fromRGB(0, 180, 255),
			CloseMinimize = Color3.fromRGB(120, 180, 220),
			ItemColors = Color3.fromRGB(25, 43, 66),
			ItemTitleColors = Color3.fromRGB(220, 245, 255),
			ItemTextColors = Color3.fromRGB(160, 200, 230),
			ItemTextBoxKeyBindColors = Color3.fromRGB(18, 33, 55),
			ItemTextBoxKeyBindStrokeColors = Color3.fromRGB(0, 140, 200),
			ItemTextBoxTextColor = Color3.fromRGB(140, 180, 210),
			ItemKeyBindTextColor = Color3.fromRGB(0, 200, 255),
			ToggleTickColor = Color3.fromRGB(0, 180, 255),
			ButtonClickIconColor = Color3.fromRGB(200, 240, 255),
			SliderButtonFrameColor = Color3.fromRGB(20, 45, 70),
			InSliderFrame = Color3.fromRGB(0, 180, 255),
			NumColor = Color3.fromRGB(120, 220, 255),

			-- Slider
			FirstSlider = { First = Color3.fromRGB(0, 180, 255), Second = Color3.fromRGB(0, 120, 200) },
			SecondSlider = { First = Color3.fromRGB(40, 65, 90), Second = Color3.fromRGB(20, 38, 60) },

			-- Dropdown
			DropdownColorPickerImageArrowColors = Color3.fromRGB(180, 220, 255),
			DropdownItem = Color3.fromRGB(220, 245, 255),
			DropdownItemHover = Color3.fromRGB(0, 180, 255),
			DropdownItemFirst = Color3.fromRGB(32, 52, 77),
			DropdownItemSecond = Color3.fromRGB(18, 33, 55),

			NotificationNotifyColor = Color3.fromRGB(20, 38, 60),
			NotificationNotifyTitleColor = Color3.fromRGB(220, 245, 255),
			NotificationNotifyTextColor = Color3.fromRGB(160, 200, 230),
			IconColor = Color3.fromRGB(0, 180, 255),
			IconShadow = Color3.fromRGB(0, 100, 150),
			NotifyButtons = Color3.fromRGB(100, 180, 230),

			-- Toggle
			ToggleFrameColor = Color3.fromRGB(32, 52, 77),
			SlidingTogglePrimer = Color3.fromRGB(70, 100, 130),
			SlidingToggleSeconder = Color3.fromRGB(20, 38, 60),

			ToggledFrameColor = Color3.fromRGB(20, 60, 90),
			SlidingToggleToggledPrimer = Color3.fromRGB(0, 180, 255),
			SlidingToggleToggledSeconder = Color3.fromRGB(0, 120, 200),
		},
		Forest = {
			-- Orman yeşili tema - doğal ve rahatlatıcı
			Hover = Color3.fromRGB(35, 55, 40),
			Main = Color3.fromRGB(20, 32, 24),
			Shadow = Color3.fromRGB(100, 255, 120),
			TitleBar = Color3.fromRGB(25, 40, 28),
			Tabs = Color3.fromRGB(32, 50, 36),
			TabBefore = Color3.fromRGB(28, 45, 32),
			TabAfter = Color3.fromRGB(36, 55, 40),
			OpenFrame = Color3.fromRGB(25, 40, 28),
			Open = Color3.fromRGB(30, 46, 34),
			TitleTextColor = Color3.fromRGB(200, 255, 210),
			TabTextColor = Color3.fromRGB(180, 240, 190),
			TitleLineColor = Color3.fromRGB(100, 255, 120),
			PageTitleColor = Color3.fromRGB(130, 255, 150),
			Selection = Color3.fromRGB(80, 255, 100),
			CloseMinimize = Color3.fromRGB(140, 200, 150),
			ItemColors = Color3.fromRGB(28, 45, 32),
			ItemTitleColors = Color3.fromRGB(210, 255, 220),
			ItemTextColors = Color3.fromRGB(170, 220, 180),
			ItemTextBoxKeyBindColors = Color3.fromRGB(22, 35, 26),
			ItemTextBoxKeyBindStrokeColors = Color3.fromRGB(80, 180, 100),
			ItemTextBoxTextColor = Color3.fromRGB(150, 200, 160),
			ItemKeyBindTextColor = Color3.fromRGB(100, 255, 120),
			ToggleTickColor = Color3.fromRGB(100, 255, 120),
			ButtonClickIconColor = Color3.fromRGB(200, 255, 210),
			SliderButtonFrameColor = Color3.fromRGB(25, 50, 35),
			InSliderFrame = Color3.fromRGB(80, 255, 100),
			NumColor = Color3.fromRGB(150, 255, 170),

			-- Slider
			FirstSlider = { First = Color3.fromRGB(100, 255, 120), Second = Color3.fromRGB(50, 200, 70) },
			SecondSlider = { First = Color3.fromRGB(45, 70, 50), Second = Color3.fromRGB(25, 40, 28) },

			-- Dropdown
			DropdownColorPickerImageArrowColors = Color3.fromRGB(180, 240, 190),
			DropdownItem = Color3.fromRGB(210, 255, 220),
			DropdownItemHover = Color3.fromRGB(100, 255, 120),
			DropdownItemFirst = Color3.fromRGB(36, 55, 40),
			DropdownItemSecond = Color3.fromRGB(22, 35, 26),

			NotificationNotifyColor = Color3.fromRGB(25, 40, 28),
			NotificationNotifyTitleColor = Color3.fromRGB(210, 255, 220),
			NotificationNotifyTextColor = Color3.fromRGB(170, 220, 180),
			IconColor = Color3.fromRGB(100, 255, 120),
			IconShadow = Color3.fromRGB(30, 100, 40),
			NotifyButtons = Color3.fromRGB(120, 200, 140),

			-- Toggle
			ToggleFrameColor = Color3.fromRGB(36, 55, 40),
			SlidingTogglePrimer = Color3.fromRGB(70, 110, 80),
			SlidingToggleSeconder = Color3.fromRGB(25, 40, 28),

			ToggledFrameColor = Color3.fromRGB(40, 80, 50),
			SlidingToggleToggledPrimer = Color3.fromRGB(100, 255, 120),
			SlidingToggleToggledSeconder = Color3.fromRGB(50, 200, 70),
		},
		Sunset = {
			-- Gün batımı tema - turuncu/pembe/mor gradyanlar
			Hover = Color3.fromRGB(60, 40, 50),
			Main = Color3.fromRGB(30, 20, 30),
			Shadow = Color3.fromRGB(255, 120, 80),
			TitleBar = Color3.fromRGB(40, 28, 38),
			Tabs = Color3.fromRGB(50, 35, 48),
			TabBefore = Color3.fromRGB(45, 30, 43),
			TabAfter = Color3.fromRGB(55, 38, 52),
			OpenFrame = Color3.fromRGB(40, 28, 38),
			Open = Color3.fromRGB(45, 32, 43),
			TitleTextColor = Color3.fromRGB(255, 200, 180),
			TabTextColor = Color3.fromRGB(255, 180, 200),
			TitleLineColor = Color3.fromRGB(255, 120, 150),
			PageTitleColor = Color3.fromRGB(255, 150, 100),
			Selection = Color3.fromRGB(255, 130, 90),
			CloseMinimize = Color3.fromRGB(200, 140, 160),
			ItemColors = Color3.fromRGB(45, 32, 43),
			ItemTitleColors = Color3.fromRGB(255, 220, 200),
			ItemTextColors = Color3.fromRGB(230, 180, 190),
			ItemTextBoxKeyBindColors = Color3.fromRGB(35, 24, 33),
			ItemTextBoxKeyBindStrokeColors = Color3.fromRGB(200, 100, 120),
			ItemTextBoxTextColor = Color3.fromRGB(210, 160, 170),
			ItemKeyBindTextColor = Color3.fromRGB(255, 130, 90),
			ToggleTickColor = Color3.fromRGB(255, 120, 150),
			ButtonClickIconColor = Color3.fromRGB(255, 200, 180),
			SliderButtonFrameColor = Color3.fromRGB(55, 35, 48),
			InSliderFrame = Color3.fromRGB(255, 130, 90),
			NumColor = Color3.fromRGB(255, 180, 140),

			-- Slider - Sunset gradient
			FirstSlider = { First = Color3.fromRGB(255, 120, 80), Second = Color3.fromRGB(255, 80, 150) },
			SecondSlider = { First = Color3.fromRGB(70, 50, 60), Second = Color3.fromRGB(40, 28, 38) },

			-- Dropdown
			DropdownColorPickerImageArrowColors = Color3.fromRGB(255, 180, 160),
			DropdownItem = Color3.fromRGB(255, 220, 200),
			DropdownItemHover = Color3.fromRGB(255, 130, 90),
			DropdownItemFirst = Color3.fromRGB(55, 38, 52),
			DropdownItemSecond = Color3.fromRGB(35, 24, 33),

			NotificationNotifyColor = Color3.fromRGB(40, 28, 38),
			NotificationNotifyTitleColor = Color3.fromRGB(255, 220, 200),
			NotificationNotifyTextColor = Color3.fromRGB(230, 180, 190),
			IconColor = Color3.fromRGB(255, 120, 150),
			IconShadow = Color3.fromRGB(150, 50, 80),
			NotifyButtons = Color3.fromRGB(220, 160, 180),

			-- Toggle
			ToggleFrameColor = Color3.fromRGB(55, 38, 52),
			SlidingTogglePrimer = Color3.fromRGB(110, 80, 100),
			SlidingToggleSeconder = Color3.fromRGB(40, 28, 38),

			ToggledFrameColor = Color3.fromRGB(80, 50, 70),
			SlidingToggleToggledPrimer = Color3.fromRGB(255, 120, 80),
			SlidingToggleToggledSeconder = Color3.fromRGB(255, 80, 150),
		},
	},
    --config Settings Start Here
	Elements = {
		["Toggle"] = {};
		["TextBox"] = {};
		["Slider"] = {};
		["ColorPicker"] = {};
		["CheckBox"] = {};
		["Dropdown"] = {};
		["Keybind"] = {};
	},
}

local LoadHawkConfig = "disabled"
HawkLib["Settings"] = {
	["Toggle"] = {},
	["TextBox"] = {},
	["Slider"] = {},
	["ColorPicker"] = {},
	["CheckBox"] = {},
	["Dropdown"] = {},
	["Keybind"] = {}
}

local HawkConfigName = ""
local HawkConfigSettings = HawkLib["Settings"]

local Strawn = {RainbowColorValue = 0, HueSelectionPosition = 0}

-- Sistema de favoritos
local Favorites = {}
local FavoritesTab = nil

-- Função para adicionar/remover favoritos
local function toggleFavorite(itemName, parentTab)
    if Favorites[itemName] then
        -- Remover dos favoritos
        Favorites[itemName] = nil
    else
        -- Adicionar aos favoritos
        Favorites[itemName] = {
            name = itemName,
            parentTab = parentTab
        }
        
        -- Se a aba de favoritos existir, adicionar o item lá também
        if FavoritesTab then
            -- Criar um botão duplicado na aba de favoritos
            local favButton = Instance.new("Frame")
            local UICorner_8 = Instance.new("UICorner")
            local ButtonListing = Instance.new("Frame")
            local UIListLayout_6 = Instance.new("UIListLayout")
            local ButtonTitle = Instance.new("TextLabel")
            local ButtonText = Instance.new("TextLabel")
            local ButtonClick = Instance.new("TextButton")
            local ClickIcon = Instance.new("ImageLabel")
            local FavoriteStar = Instance.new("ImageButton") -- Estrela de favorito
            
            favButton.Name = itemName.."_fav"
            favButton.Parent = FavoritesTab.Container
            favButton.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
            favButton.BorderColor3 = HawkLib.Themes[Theme].ItemColors
            favButton.BorderSizePixel = 0
            
            UICorner_8.CornerRadius = UDim.new(0, 6)
            UICorner_8.Parent = favButton
            
            ButtonListing.Name = "ButtonListing"
            ButtonListing.Parent = favButton
            ButtonListing.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
            ButtonListing.BackgroundTransparency = 1.000
            ButtonListing.BorderColor3 = Color3.fromRGB(43, 43, 41)
            ButtonListing.BorderSizePixel = 0
            ButtonListing.Position = UDim2.new(0.0306905378, 0, 0.17634055, 0)
            ButtonListing.Size = UDim2.new(0, 372, 0, 32)
            
            UIListLayout_6.Parent = ButtonListing
            UIListLayout_6.SortOrder = Enum.SortOrder.LayoutOrder
            
            ButtonTitle.Name = "ButtonTitle"
            ButtonTitle.Parent = ButtonListing
            ButtonTitle.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
            ButtonTitle.BackgroundTransparency = 1.000
            ButtonTitle.BorderColor3 = Color3.fromRGB(43, 43, 41)
            ButtonTitle.BorderSizePixel = 0
            ButtonTitle.Size = UDim2.new(0, 379, 0, 17)
            ButtonTitle.Font = Enum.Font.GothamBold
            ButtonTitle.Text = "⭐ " .. itemName
            ButtonTitle.TextColor3 = HawkLib.Themes[Theme].ItemTitleColors
            ButtonTitle.TextSize = 15.000
            ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            ButtonText.Name = "ButtonText"
            ButtonText.Parent = ButtonListing
            ButtonText.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
            ButtonText.BackgroundTransparency = 1.000
            ButtonText.BorderColor3 = Color3.fromRGB(43, 43, 41)
            ButtonText.BorderSizePixel = 0
            ButtonText.Position = UDim2.new(0, 0, 0.170000002, 0)
            ButtonText.Size = UDim2.new(0, 379, 0, 17)
            ButtonText.Font = Enum.Font.Gotham
            ButtonText.TextColor3 = HawkLib.Themes[Theme].ItemTextColors
            ButtonText.TextSize = 15.000
            ButtonText.TextXAlignment = Enum.TextXAlignment.Left
            
            ButtonClick.Name = "ButtonClick"
            ButtonClick.Parent = favButton
            ButtonClick.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            ButtonClick.BackgroundTransparency = 1.000
            ButtonClick.BorderColor3 = Color3.fromRGB(35, 35, 35)
            ButtonClick.BorderSizePixel = 0
            ButtonClick.Size = UDim2.new(0, 391, 0, 55)
            ButtonClick.Font = Enum.Font.SourceSans
            ButtonClick.Text = ""
            ButtonClick.TextColor3 = Color3.fromRGB(0, 0, 0)
            ButtonClick.TextSize = 1.000
            ButtonClick.TextTransparency = 1.000
            ButtonClick.AutoButtonColor = false
            
            ClickIcon.Name = "ClickIcon"
            ClickIcon.Parent = favButton
            ClickIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ClickIcon.BackgroundTransparency = 1.000
            ClickIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ClickIcon.BorderSizePixel = 0
            ClickIcon.Size = UDim2.new(0, 33, 0, 33)
            ClickIcon.Image = "rbxassetid://13570069771"
            ClickIcon.ImageColor3 = HawkLib.Themes[Theme].ButtonClickIconColor
            
            -- Estrela de favorito
            FavoriteStar.Name = "FavoriteStar"
            FavoriteStar.Parent = favButton
            FavoriteStar.BackgroundTransparency = 1
            FavoriteStar.BorderSizePixel = 0
            FavoriteStar.Position = UDim2.new(0.75, 0, 0.176, 0)
            FavoriteStar.Size = UDim2.new(0, 25, 0, 25)
            FavoriteStar.Image = "rbxassetid://2708898245" -- Estrela padrão
            FavoriteStar.ImageColor3 = Color3.fromRGB(255, 215, 0) -- Dourado
            
            favButton.MouseEnter:Connect(function()
                TweenService:Create(
                    favButton,
                    TweenInfo.new(.2, Enum.EasingStyle.Quad),
                    {BackgroundColor3 = HawkLib.Themes[Theme].Hover}
                ):Play()
            end)
            favButton.MouseLeave:Connect(function()
                TweenService:Create(
                    favButton,
                    TweenInfo.new(.2, Enum.EasingStyle.Quad),
                    {BackgroundColor3 = HawkLib.Themes[Theme].ItemColors}
                ):Play()
            end)
            
            ButtonClick.MouseButton1Click:Connect(function()
                -- Quando clicar no favorito, navegar para a aba original
                if parentTab then
                    parentTab.TabButton:FireClick()
                end
            end)
            
            TweenService:Create(
                FavoritesTab.Page,
                TweenInfo.new(.2, Enum.EasingStyle.Quad),
                {CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
            ):Play()
        end
    end
end
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local input = game:GetService("UserInputService")
local corner = Instance.new("UICorner")
local Circle = Instance.new("ImageLabel")
Circle.Name = "Circle"
Circle.BackgroundColor3 = Color3.new(0.533333, 0.533333, 0.533333)
Circle.BackgroundTransparency = 1
Circle.ImageColor3 = Color3.new(0.454902, 0.454902, 0.454902)
Circle.Image = "rbxassetid://266543268"
Circle.ImageTransparency = 0.8
Circle.BorderSizePixel = 0

corner.CornerRadius = UDim.new(1, 6)
corner.Name = "DropdownCorner"
corner.Parent = Circle
Strawn.RainbowColorValue = 999999999999999999999999999

local LibParent
LibParent = game.CoreGui

local Hawk = Instance.new("ScreenGui")
local HawkNotifications = Instance.new("ScreenGui")

coroutine.wrap(
	function()
		while wait() do
			Strawn.RainbowColorValue = Strawn.RainbowColorValue + 1 / 255
			Strawn.HueSelectionPosition = Strawn.HueSelectionPosition + 1

			if Strawn.RainbowColorValue >= 1 then
				Strawn.RainbowColorValue = 0
			end

			if Strawn.HueSelectionPosition == 80 then
				Strawn.HueSelectionPosition = 0
			end
		end
	end
)()

function ripple(button, x, y)
	spawn(
		function()
			button.ClipsDescendants = true
			local circle = Circle:Clone()
			circle.Parent = button
			circle.ZIndex = 1000
			circle.ImageColor3 = Color3.fromRGB(255, 255, 255)
			local new_x = x - circle.AbsolutePosition.X
			local new_y = y - circle.AbsolutePosition.Y
			circle.Position = UDim2.new(0, new_x, 0, new_y)
			local size = 0
			if button.AbsoluteSize.X > button.AbsoluteSize.Y then
				size = button.AbsoluteSize.X * 1.5
			elseif button.AbsoluteSize.X < button.AbsoluteSize.Y then
				size = button.AbsoluteSize.Y * 1.5
			elseif button.AbsoluteSize.X == button.AbsoluteSize.Y then
				size = button.AbsoluteSize.X * 1.5
			end
			circle:TweenSizeAndPosition(
				UDim2.new(0, size, 0, size),
				UDim2.new(0.5, -size / 2, 0.5, -size / 2),
				"Out",
				"Linear",
				0.3
			)
			for i = 1, 10 do
				circle.ImageTransparency = i / 10
				wait()
			end
			circle:Destroy()
		end
	)
end

local notiftheme

function HawkLib:Window(Win)
	if _HawkKey == "pencizurnabayilirim" then
		local ScriptName
		local DestroyIfExists
		local Theme

		for i, v in next, Win do
			if string.lower(i) == "scriptname" or string.lower(i) == "name" then
				ScriptName = v
			elseif string.lower(i) == "destroyifexists" or string.lower(i) == "destroy" then
				DestroyIfExists = v
			elseif string.lower(i) == "theme" then
				Theme = v
			end
		end

		local selectedtheme = Theme
		local Theme
		local bali = DestroyIfExists

		if bali ~= nil then
			if bali == true then
				for i, v in pairs(LibParent:GetChildren()) do
					if v.Name == "Hawk" then
						v:Destroy()
					end
				end
			end
		end

		if selectedtheme ~= nil then
			if selectedtheme == "Rise" then
				Theme = "Rise"
			elseif selectedtheme == "Red" then
				Theme = "Red"
			elseif selectedtheme == "Hawk" then
				Theme = "Hawk"
			elseif selectedtheme == "Cyberpunk" then
				Theme = "Cyberpunk"
			elseif selectedtheme == "TokyoNight" then
				Theme = "TokyoNight"
			elseif selectedtheme == "OLED" then
				Theme = "OLED"
			elseif selectedtheme == "BloodRed" then
				Theme = "BloodRed"
			elseif selectedtheme == "White" then
				Theme = "White"
			elseif selectedtheme == "Ubuntu" then
				Theme = "Ubuntu"
			elseif selectedtheme == "Midnight" then
				Theme = "Midnight"
			elseif selectedtheme == "Glacier" then
				Theme = "Glacier"
			elseif selectedtheme == "Anime" then
				Theme = "Anime"
			elseif selectedtheme == "Femboy" then
				Theme = "Femboy"
			elseif selectedtheme == "Hanki" then
				Theme = "Hanki"
			elseif selectedtheme == "Ocean" then
				Theme = "Ocean"
			elseif selectedtheme == "Forest" then
				Theme = "Forest"
			elseif selectedtheme == "Sunset" then
				Theme = "Sunset"
			else
				Theme = "Rise"
			end
		else
			Theme = "Rise"
		end

		notiftheme = Theme

		local FirstTab = false
		local Main = Instance.new("Frame")
		local UICorner1 = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local TitleBar = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local BarFixer = Instance.new("Frame")
		local Line = Instance.new("Frame")
		local Line_2 = Instance.new("Frame")
		local Close = Instance.new("TextButton")
		local Minimize = Instance.new("TextButton")
		local Title = Instance.new("TextLabel")
		local Tabs = Instance.new("ScrollingFrame")
		local TabLayout = Instance.new("UIListLayout")
		local Pages = Instance.new("Frame")
		local Shadow = Instance.new("ImageLabel")

		Hawk.Name = "Hawk"
		Hawk.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		Hawk.ResetOnSpawn = false
		Hawk.Parent = LibParent

		Main.Name = "Main"
		Main.Parent = Hawk
		Main.BackgroundColor3 = HawkLib.Themes[Theme].Main
		Main.BackgroundTransparency = 0.020
		Main.BorderColor3 = Color3.fromRGB(36, 36, 36)
		Main.BorderSizePixel = 0

		if OnPc then
			Main.Position = UDim2.new(0.281687975, 0, 0.0610276647, 0)
			Main.Size = UDim2.new(0, 592, 0, 451)
		else
			Main.Position = UDim2.new(0.5, -296, 0.5, -135)
			Main.Size = UDim2.new(0, 592, 0, 270)
		end

		UICorner1.Parent = Main

		UIStroke.Parent = Main
		UIStroke.Color = Color3.fromRGB(42, 42, 42)
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

		TitleBar.Name = "TitleBar"
		TitleBar.Parent = Main
		TitleBar.BackgroundColor3 = HawkLib.Themes[Theme].TitleBar
		TitleBar.BorderColor3 = Color3.fromRGB(36, 36, 36)
		TitleBar.BorderSizePixel = 0

		if OnPc then
			TitleBar.Size = UDim2.new(0, 592, 0, 33)
		else
			TitleBar.Size = UDim2.new(0, 592, 0, 33)
		end

		UICorner_2.Parent = TitleBar
		MakeDraggable(TitleBar, Main)
		BarFixer.Name = "BarFixer"
		BarFixer.Parent = TitleBar
		BarFixer.BackgroundColor3 = HawkLib.Themes[Theme].TitleBar
		BarFixer.BorderColor3 = HawkLib.Themes[Theme].TitleBar
		BarFixer.BorderSizePixel = 0
		BarFixer.Position = UDim2.new(0, 0, 0.818181813, 0)

		if OnPc then
			BarFixer.Size = UDim2.new(0, 592, 0, 15)
		else
			BarFixer.Size = UDim2.new(0, 592, 0, 12)
		end

		MakeDraggable(BarFixer, Main)
		Line.Name = "Line"
		Line.Parent = BarFixer
		Line.BackgroundColor3 = HawkLib.Themes[Theme].TitleLineColor
		Line.BorderColor3 = Color3.fromRGB(44, 44, 44)
		Line.BorderSizePixel = 0
		Line.Position = UDim2.new(-0.000580968102, 0, 1.0672729, 0)
		Line.Size = UDim2.new(0, 593, 0, -2)
		MakeDraggable(Line, Main)
		Close.Name = "Close"
		Close.Parent = TitleBar
		Close.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
		Close.BackgroundTransparency = 1.000
		Close.BorderColor3 = Color3.fromRGB(36, 36, 36)
		Close.BorderSizePixel = 0
		Close.Position = UDim2.new(0.944256783, 0, 0.25, 0)
		Close.Size = UDim2.new(0, 20, 0, 19)
		Close.Font = Enum.Font.Gotham
		Close.Text = "X"
		Close.TextColor3 = HawkLib.Themes[Theme].CloseMinimize
		Close.TextSize = 18.000
		Close.Visible = false

		Line_2.Name = "Line"
		Line_2.Parent = TitleBar
		Line_2.BackgroundColor3 = HawkLib.Themes[Theme].TitleLineColor
		Line_2.BorderColor3 = Color3.fromRGB(74, 74, 74)
		Line_2.BorderSizePixel = 0

		if OnPc then
			Line_2.Size = UDim2.new(0.003, 0, -3.369, -300)
			Line_2.Position = UDim2.new(0.311, 0, 13.7, 0)
		else
			Line_2.Size = UDim2.new(0.00300000003, 0, 0, -231)
			Line_2.Position = UDim2.new(0.311, 0, 8.2, 0)
		end

		Minimize.Name = "Minimize"
		Minimize.Parent = TitleBar
		Minimize.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
		Minimize.BackgroundTransparency = 1.000
		Minimize.BorderColor3 = Color3.fromRGB(36, 36, 36)
		Minimize.BorderSizePixel = 0
		Minimize.Position = UDim2.new(0.891891897, 0, 0.25, 0)
		Minimize.Size = UDim2.new(0, 20, 0, 19)
		Minimize.Font = Enum.Font.Merriweather
		Minimize.Text = "-"
		Minimize.TextColor3 = HawkLib.Themes[Theme].CloseMinimize
		Minimize.TextSize = 34.000
		Minimize.Visible = false

		Title.Name = "Title"
		Title.Parent = TitleBar
		Title.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
		Title.BackgroundTransparency = 1.000
		Title.BorderColor3 = Color3.fromRGB(36, 36, 36)
		Title.BorderSizePixel = 0
		Title.Position = UDim2.new(0.0320945941, 0, 0, 0)
		Title.Size = UDim2.new(0, 112, 0, 42)
		Title.Font = Enum.Font.Gotham
		Title.Text = ScriptName
		Title.TextColor3 = HawkLib.Themes[Theme].TitleTextColor
		Title.TextSize = 16.000
		Title.TextXAlignment = Enum.TextXAlignment.Left

		MakeDraggable(Title, Main)
		Tabs.Name = "Tabs"
		Tabs.Parent = Main
		Tabs.Active = true
		Tabs.BackgroundColor3 = HawkLib.Themes[Theme].Tabs
		Tabs.BackgroundTransparency = 1.000
		Tabs.BorderColor3 = Color3.fromRGB(36, 36, 36)
		Tabs.BorderSizePixel = 0
		Tabs.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
		Tabs.BottomImage = ""
		Tabs.MidImage = ""
		Tabs.ScrollBarThickness = 0

		if OnPc then
			Tabs.Size = UDim2.new(0, 171, 0, 391)
			Tabs.Position = UDim2.new(0.0118243247, 0, 0.114482902, 0)
		else
			Tabs.Size = UDim2.new(0, 171, 0, 213)
			Tabs.Position = UDim2.new(0.012, 0, 0.18, 0)
		end

		MakeDraggable(Tabs, Main)
		TabLayout.Parent = Tabs
		TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
		TabLayout.Padding = UDim.new(0, 9)

		Pages.Name = "Pages"
		Pages.Parent = Main
		Pages.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
		Pages.BackgroundTransparency = 1.000
		Pages.BorderColor3 = Color3.fromRGB(36, 36, 36)
		Pages.BorderSizePixel = 0

		if OnPc then
			Pages.Position = UDim2.new(0.317567557, 0, 0.0931263864, 0)
			Pages.Size = UDim2.new(0, 404, 0, 408)
		else
			Pages.Position = UDim2.new(0.318, 0, 0.134, 0)
			Pages.Size = UDim2.new(0, 404, 0, 233)
		end

		Shadow.Name = "Shadow"
		Shadow.Parent = Main
		Shadow.Active = true
		Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Shadow.BackgroundTransparency = 1.000
		Shadow.Position = UDim2.new(0, -15, 0, -15)
		Shadow.Size = UDim2.new(1, 30, 1, 30)
		Shadow.ZIndex = 0
		Shadow.Image = "rbxassetid://5028857084"
		Shadow.ImageColor3 = HawkLib.Themes[Theme].Shadow
		Shadow.ScaleType = Enum.ScaleType.Slice
		Shadow.SliceCenter = Rect.new(24, 24, 276, 276)

			-- Adicionando a barra de pesquisa
			local SearchFrame = Instance.new("Frame")
			local SearchTextBox = Instance.new("TextBox")
			local SearchIcon = Instance.new("ImageLabel")
				
			SearchFrame.Name = "SearchFrame"
			SearchFrame.Parent = Tabs
			SearchFrame.BackgroundColor3 = HawkLib.Themes[Theme].TabBefore
			SearchFrame.BorderColor3 = Color3.fromRGB(33, 33, 33)
			SearchFrame.BorderSizePixel = 0
			SearchFrame.Size = UDim2.new(0, 150, 0, 30)
			SearchFrame.Position = UDim2.new(0, 10, 0, 10)
				
			local SearchCorner = Instance.new("UICorner")
			SearchCorner.CornerRadius = UDim.new(0, 4)
			SearchCorner.Parent = SearchFrame
				
			SearchTextBox.Name = "SearchTextBox"
			SearchTextBox.Parent = SearchFrame
			SearchTextBox.BackgroundColor3 = HawkLib.Themes[Theme].ItemTextBoxKeyBindColors
			SearchTextBox.BorderColor3 = HawkLib.Themes[Theme].ItemTextBoxKeyBindStrokeColors
			SearchTextBox.BorderSizePixel = 0
			SearchTextBox.Position = UDim2.new(0, 8, 0, 4)
			SearchTextBox.Size = UDim2.new(0, 105, 0, 22)
			SearchTextBox.Font = Enum.Font.Gotham
			SearchTextBox.PlaceholderText = "Search tabs..."
			SearchTextBox.Text = ""
			SearchTextBox.TextColor3 = HawkLib.Themes[Theme].ItemTextBoxTextColor
			SearchTextBox.TextSize = 12.000
			SearchTextBox.TextXAlignment = Enum.TextXAlignment.Left
				
			local TextBoxCorner = Instance.new("UICorner")
			TextBoxCorner.CornerRadius = UDim.new(0, 4)
			TextBoxCorner.Parent = SearchTextBox
				
			SearchIcon.Name = "SearchIcon"
			SearchIcon.Parent = SearchFrame
			SearchIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SearchIcon.BackgroundTransparency = 1.000
			SearchIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SearchIcon.BorderSizePixel = 0
			SearchIcon.Position = UDim2.new(0, 120, 0, 4)
			SearchIcon.Size = UDim2.new(0, 20, 0, 22)
			SearchIcon.Image = "http://www.roblox.com/asset/?id=6031094684"
			SearchIcon.ImageColor3 = HawkLib.Themes[Theme].ItemTextBoxTextColor
		
			-- Função de animação para quando o mouse entra/sai de um botão
			local function animateButtonIn(button)
				TweenService:Create(
					button,
					TweenInfo.new(0.2, Enum.EasingStyle.Quad),
					{BackgroundColor3 = HawkLib.Themes[Theme].Hover}
				):Play()
			end
		
			local function animateButtonOut(button)
				TweenService:Create(
					button,
					TweenInfo.new(0.2, Enum.EasingStyle.Quad),
					{BackgroundColor3 = HawkLib.Themes[Theme].TabBefore}
				):Play()
			end
		
			-- Função para filtrar abas
			local function filterTabs(searchText)
				local allTabs = Tabs:GetChildren()
				for _, child in pairs(allTabs) do
					if child:IsA("Frame") and child.Name == "TabBtnFrame" then
						local tabText = child.TabText.Text
						if searchText == "" or string.find(string.lower(tabText), string.lower(searchText)) then
							child.Visible = true
						else
							child.Visible = false
						end
					end
				end
			end
		
			-- Conectar evento de mudança de texto na caixa de pesquisa
			SearchTextBox.FocusLost:Connect(function()
				filterTabs(SearchTextBox.Text)
			end)
		
			SearchTextBox:GetPropertyChangedSignal("Text"):Connect(function()
				filterTabs(SearchTextBox.Text)
			end)
		
			-- Eventos para animações da barra de pesquisa
			SearchTextBox.MouseEnter:Connect(function()
				animateButtonIn(SearchFrame)
			end)
		
			SearchTextBox.MouseLeave:Connect(function()
				if not SearchTextBox:IsFocused() then
					animateButtonOut(SearchFrame)
				end
			end)
		
			SearchTextBox.Focused:Connect(function()
				animateButtonIn(SearchFrame)
			end)
		
			SearchTextBox.FocusLost:Connect(function()
				if not (game:GetService("UserInputService"):GetMouseLocation().X >= SearchTextBox.AbsolutePosition.X and 
					   game:GetService("UserInputService"):GetMouseLocation().X <= SearchTextBox.AbsolutePosition.X + SearchTextBox.AbsoluteSize.X and
					   game:GetService("UserInputService"):GetMouseLocation().Y >= SearchTextBox.AbsolutePosition.Y and
					   game:GetService("UserInputService"):GetMouseLocation().Y <= SearchTextBox.AbsolutePosition.Y + SearchTextBox.AbsoluteSize.Y) then
					animateButtonOut(SearchFrame)
				end
			end)
		
		local Sayfalar = {}
		
		function HawkLib:ToggleUI()
			if Hawk.Enabled == true then
				Hawk.Enabled = false
			else
				Hawk.Enabled = true
			end
			return setmetatable({}, {__index = Sayfalar})
		end

		function HawkLib:Destroy()
			Hawk:Destroy()
			return setmetatable({}, {__index = Sayfalar})
		end

		function Sayfalar:ToggleUI()
			if Hawk.Enabled == true then
				Hawk.Enabled = false
			else
				Hawk.Enabled = true
			end
			return setmetatable({}, {__index = Sayfalar})
		end

		function Sayfalar:Destroy()
			Hawk:Destroy()
			return setmetatable({}, {__index = Sayfalar})
		end

		function Sayfalar:Minimize(tebel)
			local visibility
			local callback
			local openbutton

			for i, v in next, tebel do
				if string.lower(i) == "visibility" then
					visibility = v
				elseif string.lower(i) == "callback" then
					callback = v
				elseif string.lower(i) == "openbutton" then
					openbutton = v
				end
			end

			if visibility ~= nil then
				if visibility == true then
					Minimize.Visible = true

					if openbutton ~= nil then
						if openbutton == true then
							local OpenFrame = Instance.new("Frame")
							local Open = Instance.new("TextButton")
							local UICorner = Instance.new("UICorner")
							local UI2Corner = Instance.new("UICorner")

							OpenFrame.Name = "OpenFrame"
							OpenFrame.Parent = Hawk
							OpenFrame.Active = true
							OpenFrame.BackgroundColor3 = HawkLib.Themes[Theme].OpenFrame
							OpenFrame.Position = UDim2.new(0, 0, 0, 282)
							OpenFrame.Selectable = true
							OpenFrame.Size = UDim2.new(0, 120, 0, 50)
							OpenFrame.Visible = false
							OpenFrame.ZIndex = 0
							MakeDraggable(OpenFrame, OpenFrame)

							UICorner.CornerRadius = UDim.new(0, 8)
							UICorner.Parent = OpenFrame

							Open.Name = "Open"
							Open.Parent = OpenFrame
							Open.BackgroundColor3 = HawkLib.Themes[Theme].Open
							Open.Size = UDim2.new(1.0, 0, 0.92, 0)
							Open.Font = Enum.Font.GothamBold
							Open.Text = ScriptName
							Open.TextColor3 = Color3.fromRGB(231, 231, 231)
							Open.TextSize = 17.000
							Open.TextWrapped = true
							Open.AutoButtonColor = false
							MakeDraggable(Open, OpenFrame)

							local oldpos

							UI2Corner.CornerRadius = UDim.new(0, 5)
							UI2Corner.Parent = Open

							Minimize.MouseButton1Click:Connect(
								function()
									OpenFrame.Visible = true
									Main.Visible = false
								end
							)

							Open.MouseButton1Click:Connect(
								function()
									OpenFrame.Visible = false
									Main.Visible = true
								end
							)
						end
					end
				else
					Minimize:Destroy()
				end
			else
				Minimize:Destroy()
			end

			if callback then
				Minimize.MouseButton1Click:Connect(
					function()
						pcall(callback)
					end
				)
			end
			return setmetatable({}, {__index = Sayfalar})
		end

		function Sayfalar:Close(tebel)
			local visibility
			local callback

			for i, v in next, tebel do
				if string.lower(i) == "visibility" then
					visibility = v
				elseif string.lower(i) == "callback" then
					callback = v
				end
			end

			if visibility ~= nil then
				if visibility == true then
					Close.Visible = true
				else
					Close:Destroy()
				end
			else
				Close:Destroy()
			end

			if callback then
				Close.MouseButton1Click:Connect(
					function()
						pcall(callback)
					end
				)
			end
			return setmetatable({}, {__index = Sayfalar})
		end

		-- Função para criar a aba de favoritos
		local function createFavoritesTab(window)
		    if not FavoritesTab then
		        FavoritesTab = window:Tab("Favorites", "Saved Items")
		        
		        -- Adicionar um label explicativo
		        if FavoritesTab.ContainerItems then
		            local label = FavoritesTab.ContainerItems:Label("Favorites", "Items you have marked as favorites appear here")
		        end
		    end
		    return FavoritesTab
		end
		
		function Sayfalar:Tab(TabName, PageTitle)
			local xd = PageTitle

			local TabBtnFrame = Instance.new("Frame")
			local aa = Instance.new("UICorner")
			local Selected = Instance.new("Frame")
			local bb = Instance.new("UICorner")
			local TabText = Instance.new("TextLabel")
			local TabButton = Instance.new("TextButton")
			local UIListLayout_2 = Instance.new("UIListLayout")
			local Page = Instance.new("ScrollingFrame")
			local Container = Instance.new("Frame")
			local UIListLayout_4 = Instance.new("UIListLayout")
			local PageTitle = Instance.new("TextLabel")

			TabBtnFrame.Name = "TabBtnFrame"
			TabBtnFrame.Parent = Tabs
			TabBtnFrame.BackgroundColor3 = HawkLib.Themes[Theme].TabBefore
			TabBtnFrame.BorderColor3 = Color3.fromRGB(33, 33, 33)
			TabBtnFrame.BorderSizePixel = 0
			TabBtnFrame.Size = UDim2.new(0, 171, 0, 36)

			aa.Parent = TabBtnFrame

			Selected.Name = "Selected"
			Selected.Parent = TabBtnFrame
			Selected.BackgroundColor3 = HawkLib.Themes[Theme].Selection
			Selected.BackgroundTransparency = 1
			Selected.BorderColor3 = HawkLib.Themes[Theme].Selection
			Selected.BorderSizePixel = 0
			Selected.Position = UDim2.new(0, 0, 0.277777791, 0)
			Selected.Size = UDim2.new(0, 6, 0, 18)

			bb.Parent = Selected

			TabText.Name = "TabText"
			TabText.Parent = Selected
			TabText.BackgroundColor3 = Color3.fromRGB(47, 46, 45)
			TabText.BackgroundTransparency = 1.000
			TabText.BorderColor3 = Color3.fromRGB(47, 46, 45)
			TabText.BorderSizePixel = 0
			TabText.Position = UDim2.new(2.09615064, 0, -0.5, 0)
			TabText.Size = UDim2.new(0, 130, 0, 36)
			TabText.Font = Enum.Font.Gotham
			TabText.Text = TabName
			TabText.TextColor3 = HawkLib.Themes[Theme].TabTextColor
			TabText.TextSize = 15.000
			TabText.TextXAlignment = Enum.TextXAlignment.Left

			TabButton.Name = "TabText"
			TabButton.Parent = Selected
			TabButton.BackgroundColor3 = Color3.fromRGB(47, 46, 45)
			TabButton.BackgroundTransparency = 1.000
			TabButton.BorderColor3 = Color3.fromRGB(47, 46, 45)
			TabButton.BorderSizePixel = 0
			TabButton.Position = UDim2.new(0, 0, -0.5, 0)
			TabButton.Size = TabBtnFrame.Size
			TabButton.Font = Enum.Font.Gotham
			TabButton.Text = ""
			TabButton.TextTransparency = 1
			TabButton.TextColor3 = HawkLib.Themes[Theme].TabTextColor
			TabButton.TextSize = 15.000
			TabButton.TextXAlignment = Enum.TextXAlignment.Left

			UIListLayout_2.Parent = TabBtnFrame
			UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center

			Page.Name = "Page"
			Page.Parent = Pages
			Page.Active = true
			Page.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
			Page.BackgroundTransparency = 1.000
			Page.BorderColor3 = Color3.fromRGB(36, 36, 36)
			Page.BorderSizePixel = 0
			Page.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
			Page.BottomImage = ""
			Page.CanvasPosition = Vector2.new(0, 0)
			Page.CanvasSize = UDim2.new(0, 0, 3, 0)
			Page.MidImage = ""
			Page.ScrollBarThickness = 0
			Page.TopImage = ""
			Page.Visible = false

			if OnPc then
				Page.Position = UDim2.new(0, 0, 0.02, 0)
				Page.Size = UDim2.new(0, 404, 0, 394)
			else
				Page.Position = UDim2.new(0, 0, 0.039, 0)
				Page.Size = UDim2.new(0, 404, 0, 218)
			end

			Container.Name = "Container"
			Container.Parent = Page
			Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Container.BackgroundTransparency = 1.000
			Container.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Container.BorderSizePixel = 0
			Container.Position = UDim2.new(-0.00742574269, 0, 0, 0)
			Container.Size = UDim2.new(0, 407, 0, 509)

			UIListLayout_4.Parent = Container
			UIListLayout_4.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout_4.Padding = UDim.new(0, 8)

			PageTitle.Name = "PageTitle"
			PageTitle.Parent = Container
			PageTitle.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
			PageTitle.BackgroundTransparency = 1.000
			PageTitle.BorderColor3 = Color3.fromRGB(36, 36, 36)
			PageTitle.BorderSizePixel = 0
			PageTitle.Font = Enum.Font.TitilliumWeb
			PageTitle.TextColor3 = HawkLib.Themes[Theme].PageTitleColor
			PageTitle.TextSize = 25.000
			PageTitle.TextXAlignment = Enum.TextXAlignment.Left
			PageTitle.Size = UDim2.new(0, 389, 0, 36)

			local zort
			if xd ~= nil then
				zort = xd
				PageTitle.Text = zort
			else
				PageTitle:Destroy()
			end

			if FirstTab == false then
				FirstTab = true
				Selected.BackgroundTransparency = 0.040
				TabBtnFrame.BackgroundColor3 = HawkLib.Themes[Theme].TabAfter
				TabBtnFrame.BorderColor3 = HawkLib.Themes[Theme].TabAfter
				Page.Visible = true
			end

			TabButton.MouseButton1Click:Connect(
				function()
					if Page.Visible ~= true then
						for i, v in pairs(Pages:GetDescendants()) do
							if v.Name == "Page" then
								v.Visible = false
							end
						end
						for i, v in pairs(Tabs:GetChildren()) do
							if v:IsA("Frame") then
								TweenService:Create(
									v,
									TweenInfo.new(.2, Enum.EasingStyle.Quad),
									{BackgroundColor3 = HawkLib.Themes[Theme].TabBefore}
								):Play()
								TweenService:Create(
									v.Selected,
									TweenInfo.new(.2, Enum.EasingStyle.Quad),
									{BackgroundTransparency = 1}
								):Play()
							end
						end
						TweenService:Create(
							TabBtnFrame,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{BackgroundColor3 = HawkLib.Themes[Theme].TabAfter}
						):Play()
						TweenService:Create(
							Selected,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{BackgroundTransparency = 0.040}
						):Play()
						TweenService:Create(
							Selected,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{Size = UDim2.new(0, 6, 0, 20)}
						):Play()
						wait(0.1)
						TweenService:Create(
							Selected,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{Size = UDim2.new(0, 6, 0, 18)}
						):Play()

						Page.Visible = true
					end
				end
			)

			-- Adicionando efeitos visuais ao passar o mouse sobre a aba
			TabButton.MouseEnter:Connect(function()
				if Page.Visible ~= true then
					TweenService:Create(
						TabBtnFrame,
						TweenInfo.new(0.2, Enum.EasingStyle.Quad),
						{BackgroundColor3 = HawkLib.Themes[Theme].Hover}
					):Play()
				end
			end)

			TabButton.MouseLeave:Connect(function()
				if Page.Visible ~= true then
					TweenService:Create(
						TabBtnFrame,
						TweenInfo.new(0.2, Enum.EasingStyle.Quad),
						{BackgroundColor3 = HawkLib.Themes[Theme].TabBefore}
					):Play()
				end
			end)

			TweenService:Create(
				Tabs,
				TweenInfo.new(.2, Enum.EasingStyle.Quad),
				{CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)}
			):Play()

			local ContainerItems = {}
			local datas = false
			function HawkLib:NewConfig(ConfigName)
				HawkConfigName = ConfigName
			end

			-- Criar aba de favoritos se ainda não existir
			createFavoritesTab(self)

			function HawkLib:SaveConfig()
				local savedfilename = "Rise/Settings/" .. HawkConfigName .. "Settings.json"
				local save = HttpService:JSONEncode(HawkConfigSettings)
				writefile(savedfilename, save)
			end

			-- LoadConfig fonksiyonundan hemen sonra (satır ~3030)
			function HawkLib:LoadConfig(ConfigName)
				LoadHawkConfig = "enabled"
				if not isfile("Rise/Settings/" .. ConfigName .. "Settings.json") then
					warn("Config file not found!")
					return false
				end

				local savedfile = readfile("Rise/Settings/" .. ConfigName .. "Settings.json")
				datas = HttpService:JSONDecode(savedfile)

				-- Toggle
				for i, v in pairs(datas.Toggle) do
					for a, b in next, v do
						if HawkLib.Elements.Toggle[a] then
							HawkLib.Elements.Toggle[a]:UpdateToggle(b.Status)
						end
					end
				end

				-- Slider
				for i, v in pairs(datas.Slider) do
					for a, b in next, v do
						if HawkLib.Elements.Slider[a] then
							HawkLib.Elements.Slider[a]:SetValue(b.Value)
						end
					end
				end

				-- Checkbox
				for i, v in pairs(datas.CheckBox) do
					for a, b in next, v do
						if HawkLib.Elements.CheckBox[a] then
							HawkLib.Elements.CheckBox[a]:UpdateCheckBox(b.Status)
						end
					end
				end

				-- Color Picker
				for i, v in pairs(datas.ColorPicker) do
					for a, b in next, v do
						if HawkLib.Elements.ColorPicker[a] then
							if b.Color ~= nil then
								local colorStr = tostring(b.Color)
								local r, g, bl = colorStr:match("(%d+%.?%d*), (%d+%.?%d*), (%d+%.?%d*)")
								if r and g and bl then
									local color = Color3.new(tonumber(r), tonumber(g), tonumber(bl))
									HawkLib.Elements.ColorPicker[a]:SetColor(color)
								end
							end
						end
					end
				end

				-- Keybind
				for i, v in pairs(datas.Keybind) do
					for a, b in next, v do
						if HawkLib.Elements.Keybind[a] then
							HawkLib.Elements.Keybind[a]:SetKey(b.Key)
						end
					end
				end

				-- Textbox
				for i, v in pairs(datas.TextBox) do
					for a, b in next, v do
						if HawkLib.Elements.TextBox[a] then
							HawkLib.Elements.TextBox[a]:SetText(b.Text)
						end
					end
				end

				-- Dropdown

				for i, v in pairs(datas.Dropdown) do
					for a, b in next, v do
						if HawkLib.Elements.Dropdown[a] then
							print(a)
							HawkLib.Elements.Dropdown[a]:Select(b.Selected, true)
						end
					end
				end

				LoadHawkConfig = nil

				print("Config loaded:", HawkConfigName)
				return true
			end

			function ContainerItems:Section(Title)
				local x = Title

				if x ~= nil then
					local SectionTitle = Instance.new("TextLabel")

					SectionTitle.Name = "SectionTitle"
					SectionTitle.Parent = Container
					SectionTitle.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
					SectionTitle.BackgroundTransparency = 1.000
					SectionTitle.BorderColor3 = Color3.fromRGB(36, 36, 36)
					SectionTitle.BorderSizePixel = 0
					SectionTitle.Position = UDim2.new(0.0248858687, 0, 0.0769230798, 0)
					SectionTitle.Font = Enum.Font.JosefinSans
					SectionTitle.Text = x
					SectionTitle.TextColor3 = HawkLib.Themes[Theme].ItemTextColors
					SectionTitle.TextSize = 14.000
					SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
					SectionTitle.Size = UDim2.new(0, 387, 0, 18)

					TweenService:Create(
						Page,
						TweenInfo.new(.2, Enum.EasingStyle.Quad),
						{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
					):Play()
				end
			end

			function ContainerItems:Label(title, description)
				local explainin = description

				local Label = Instance.new("Frame")
				local UICorner_7 = Instance.new("UICorner")
				local LabelListing = Instance.new("Frame")
				local UIListLayout_5 = Instance.new("UIListLayout")
				local LabelMainText = Instance.new("TextLabel")
				local LabelText = Instance.new("TextLabel")

				Label.Name = "Label"
				Label.Parent = Container
				Label.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
				Label.BorderColor3 = HawkLib.Themes[Theme].ItemColors
				Label.BorderSizePixel = 0
				Label.Position = UDim2.new(0, 0, 0.602941155, 0)

				UICorner_7.CornerRadius = UDim.new(0, 6)
				UICorner_7.Parent = Label

				LabelListing.Name = "LabelListing"
				LabelListing.Parent = Label
				LabelListing.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
				LabelListing.BackgroundTransparency = 1.000
				LabelListing.BorderColor3 = HawkLib.Themes[Theme].ItemColors
				LabelListing.BorderSizePixel = 0
				LabelListing.Position = UDim2.new(0.0306905378, 0, 0.17634055, 0)
				LabelListing.Size = UDim2.new(0, 372, 0, 32)

				UIListLayout_5.Parent = LabelListing
				UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder

				LabelMainText.Name = "LabelMainText"
				LabelMainText.Parent = LabelListing
				LabelMainText.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
				LabelMainText.BackgroundTransparency = 1.000
				LabelMainText.BorderColor3 = Color3.fromRGB(43, 43, 41)
				LabelMainText.BorderSizePixel = 0
				LabelMainText.Font = Enum.Font.GothamBold
				LabelMainText.Text = title
				LabelMainText.TextColor3 = HawkLib.Themes[Theme].ItemTitleColors
				LabelMainText.TextSize = 15.000
				LabelMainText.TextXAlignment = Enum.TextXAlignment.Left

				LabelText.Name = "LabelText"
				LabelText.Parent = LabelListing
				LabelText.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
				LabelText.BackgroundTransparency = 1.000
				LabelText.BorderColor3 = Color3.fromRGB(43, 43, 41)
				LabelText.BorderSizePixel = 0
				LabelText.Position = UDim2.new(0, 0, 0.170000002, 0)
				LabelText.Font = Enum.Font.Gotham
				LabelText.TextColor3 = HawkLib.Themes[Theme].ItemTextColors
				LabelText.TextSize = 15.000
				LabelText.TextXAlignment = Enum.TextXAlignment.Left

				TweenService:Create(
					Page,
					TweenInfo.new(.2, Enum.EasingStyle.Quad),
					{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
				):Play()

				if explainin ~= nil then
					LabelMainText.Size = UDim2.new(0, 379, 0, 17)
					LabelText.Size = UDim2.new(0, 379, 0, 17)
					Label.Size = UDim2.new(0, 391, 0, 55)
					LabelText.Text = description
				elseif explainin == nil then
					LabelText.TextTransparency = 1
					LabelMainText.Size = UDim2.new(0, 379, 0, 23)
					Label.Size = UDim2.new(0, 391, 0, 40)
				end

				local apdeyt = {}
				function apdeyt:UpdateLabel(test, descriptio)
					local newdescription = descriptio

					if newdescription ~= nil then
						LabelMainText.Text = test
						LabelText.Text = newdescription
					else
						LabelMainText.Text = test
					end

					TweenService:Create(
						Page,
						TweenInfo.new(.2, Enum.EasingStyle.Quad),
						{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
					):Play()
				end
				return apdeyt
			end

			-- Adicionando a propriedade de favoritos ao botão
			function ContainerItems:Button(yazi, description, callback)
				local check = description
				callback = callback or function()
				end

				local buttoncheck = {}

				local Button = Instance.new("Frame")
				local UICorner_8 = Instance.new("UICorner")
				local ButtonListing = Instance.new("Frame")
				local UIListLayout_6 = Instance.new("UIListLayout")
				local ButtonTitle = Instance.new("TextLabel")
				local ButtonText = Instance.new("TextLabel")
				local ButtonClick = Instance.new("TextButton")
				local ClickIcon = Instance.new("ImageLabel")

				Button.Name = "Button"
				Button.Parent = Container
				Button.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
				Button.BorderColor3 = HawkLib.Themes[Theme].ItemColors
				Button.BorderSizePixel = 0
				Button.Position = UDim2.new(0, 0, 0.602941155, 0)

				UICorner_8.CornerRadius = UDim.new(0, 6)
				UICorner_8.Parent = Button

				ButtonListing.Name = "ButtonListing"
				ButtonListing.Parent = Button
				ButtonListing.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
				ButtonListing.BackgroundTransparency = 1.000
				ButtonListing.BorderColor3 = Color3.fromRGB(43, 43, 41)
				ButtonListing.BorderSizePixel = 0
				ButtonListing.Position = UDim2.new(0.0306905378, 0, 0.17634055, 0)
				ButtonListing.Size = UDim2.new(0, 372, 0, 32)

				UIListLayout_6.Parent = ButtonListing
				UIListLayout_6.SortOrder = Enum.SortOrder.LayoutOrder

				ButtonTitle.Name = "ButtonTitle"
				ButtonTitle.Parent = ButtonListing
				ButtonTitle.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
				ButtonTitle.BackgroundTransparency = 1.000
				ButtonTitle.BorderColor3 = Color3.fromRGB(43, 43, 41)
				ButtonTitle.BorderSizePixel = 0
				ButtonTitle.Size = UDim2.new(0, 379, 0, 17)
				ButtonTitle.Font = Enum.Font.GothamBold
				ButtonTitle.Text = yazi
				ButtonTitle.TextColor3 = HawkLib.Themes[Theme].ItemTitleColors
				ButtonTitle.TextSize = 15.000
				ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left

				ButtonText.Name = "ButtonText"
				ButtonText.Parent = ButtonListing
				ButtonText.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
				ButtonText.BackgroundTransparency = 1.000
				ButtonText.BorderColor3 = Color3.fromRGB(43, 43, 41)
				ButtonText.BorderSizePixel = 0
				ButtonText.Position = UDim2.new(0, 0, 0.170000002, 0)
				ButtonText.Size = UDim2.new(0, 379, 0, 17)
				ButtonText.Font = Enum.Font.Gotham
				ButtonText.TextColor3 = HawkLib.Themes[Theme].ItemTextColors
				ButtonText.TextSize = 15.000
				ButtonText.TextXAlignment = Enum.TextXAlignment.Left

				ButtonClick.Name = "ButtonClick"
				ButtonClick.Parent = Button
				ButtonClick.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				ButtonClick.BackgroundTransparency = 1.000
				ButtonClick.BorderColor3 = Color3.fromRGB(35, 35, 35)
				ButtonClick.BorderSizePixel = 0
				ButtonClick.Size = UDim2.new(0, 391, 0, 55)
				ButtonClick.Font = Enum.Font.SourceSans
				ButtonClick.Text = ""
				ButtonClick.TextColor3 = Color3.fromRGB(0, 0, 0)
				ButtonClick.TextSize = 1.000
				ButtonClick.TextTransparency = 1.000
				ButtonClick.AutoButtonColor = false

				ClickIcon.Name = "ClickIcon"
				ClickIcon.Parent = Button
				ClickIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ClickIcon.BackgroundTransparency = 1.000
				ClickIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ClickIcon.BorderSizePixel = 0
				ClickIcon.Size = UDim2.new(0, 33, 0, 33)
				ClickIcon.Image = "rbxassetid://13570069771"
				ClickIcon.ImageColor3 = HawkLib.Themes[Theme].ButtonClickIconColor

				-- Estrela de favorito
				local FavoriteStar = Instance.new("ImageButton")
				FavoriteStar.Name = "FavoriteStar"
				FavoriteStar.Parent = Button
				FavoriteStar.BackgroundTransparency = 1
				FavoriteStar.BorderSizePixel = 0
				FavoriteStar.Position = UDim2.new(0.75, 0, 0.176, 0)
				FavoriteStar.Size = UDim2.new(0, 25, 0, 25)
				FavoriteStar.Image = "rbxassetid://2708898245" -- Estrela padrão
				FavoriteStar.ImageColor3 = Color3.fromRGB(139, 139, 139) -- Cinza escuro
				
				-- Verificar se o item já está nos favoritos
				if Favorites[yazi] then
					FavoriteStar.ImageColor3 = Color3.fromRGB(255, 215, 0) -- Dourado
				end
				
				-- Evento de clique na estrela de favorito
				FavoriteStar.MouseButton1Click:Connect(function()
					toggleFavorite(yazi, {TabButton = TabButton})
					-- Alternar cor da estrela
					if Favorites[yazi] then
						FavoriteStar.ImageColor3 = Color3.fromRGB(255, 215, 0) -- Dourado
					else
						FavoriteStar.ImageColor3 = Color3.fromRGB(139, 139, 139) -- Cinza
					end
				end)

				Button.MouseEnter:Connect(
					function()
						TweenService:Create(
							Button,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{BackgroundColor3 = HawkLib.Themes[Theme].Hover}
						):Play()
					end
				)
				Button.MouseLeave:Connect(
					function()
						TweenService:Create(
							Button,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{BackgroundColor3 = HawkLib.Themes[Theme].ItemColors}
						):Play()
					end
				)

				local buttonanim

				if check ~= nil and not tostring(check):match("function") then
					ButtonTitle.Size = UDim2.new(0, 379, 0, 17)
					ButtonText.Size = UDim2.new(0, 379, 0, 17)
					Button.Size = UDim2.new(0, 391, 0, 55)
					ButtonText.Text = tostring(description)
					ClickIcon.Position = UDim2.new(0.898, 0, 0.176, 0)
					buttonanim = Button.AbsoluteSize.Y
					table.insert(buttoncheck, callback)
				elseif tostring(check):match("function") then
					table.insert(buttoncheck, description)
					ButtonText.TextTransparency = 1
					ButtonTitle.Size = UDim2.new(0, 379, 0, 32)
					Button.Size = UDim2.new(0, 391, 0, 44)
					ClickIcon.Position = UDim2.new(0.89, 0, 0.11, 0)
					buttonanim = Button.AbsoluteSize.Y
				end

				ButtonClick.MouseButton1Click:Connect(
					function()
						TweenService:Create(
							Button,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{Size = UDim2.new(0, 375, 0, buttonanim)}
						):Play()
						wait()
						TweenService:Create(
							Button,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{Size = UDim2.new(0, 391, 0, buttonanim)}
						):Play()
						pcall(buttoncheck[1])
					end
				)
				TweenService:Create(
					Page,
					TweenInfo.new(.2, Enum.EasingStyle.Quad),
					{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
				):Play()

				local update = {}
				function update:UpdateButton(test, newdesc, kalbak)
					newdescriptwion = newdesc
					zort = kalbak
					kalbak = kalbak or function()
					end

					if tostring(newdescriptwion):match("function") then
						table.clear(buttoncheck)
						wait()
						table.insert(buttoncheck, newdescriptwion)
						ButtonText.TextTransparency = 1
						ButtonTitle.Size = UDim2.new(0, 379, 0, 32)
						Button.Size = UDim2.new(0, 391, 0, 44)
						ClickIcon.Position = UDim2.new(0.89, 0, 0.11, 0)
						buttonanim = Button.AbsoluteSize.Y
					elseif tostring(zort):match("function") then
						table.clear(buttoncheck)
						wait()
						table.insert(buttoncheck, zort)
						ButtonText.TextTransparency = 0
						ButtonTitle.Size = UDim2.new(0, 379, 0, 17)
						ButtonText.Size = UDim2.new(0, 379, 0, 17)
						Button.Size = UDim2.new(0, 391, 0, 55)
						ButtonText.Text = tostring(newdescriptwion)
						ButtonTitle.Text = test
						ClickIcon.Position = UDim2.new(0.898, 0, 0.176, 0)
						buttonanim = Button.AbsoluteSize.Y
					end

					ButtonTitle.Text = test
					TweenService:Create(
						Page,
						TweenInfo.new(.2, Enum.EasingStyle.Quad),
						{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
					):Play()
				end
				return update
			end

			function ContainerItems:Paragraph(pharagraphtitle, description)
				local desc = description or {}

				local Pharagraph = Instance.new("Frame")
				local UICorner_9 = Instance.new("UICorner")
				local PharagraphListing = Instance.new("Frame")
				local PharagraphTitle = Instance.new("TextLabel")
				local ParagraphLayout = Instance.new("UIListLayout")

				Pharagraph.Name = "Pharagraph"
				Pharagraph.Parent = Container
				Pharagraph.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
				Pharagraph.BorderColor3 = HawkLib.Themes[Theme].ItemColors
				Pharagraph.BorderSizePixel = 0
				Pharagraph.Position = UDim2.new(0.0196560193, 0, 0.333988219, 0)

				UICorner_9.CornerRadius = UDim.new(0, 6)
				UICorner_9.Parent = Pharagraph

				PharagraphListing.Name = "PharagraphListing"
				PharagraphListing.Parent = Pharagraph
				PharagraphListing.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
				PharagraphListing.BackgroundTransparency = 1.000
				PharagraphListing.BorderColor3 = Color3.fromRGB(43, 43, 41)
				PharagraphListing.BorderSizePixel = 0

				PharagraphTitle.Name = "PharagraphTitle"
				PharagraphTitle.Parent = PharagraphListing
				PharagraphTitle.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
				PharagraphTitle.BackgroundTransparency = 1.000
				PharagraphTitle.BorderColor3 = Color3.fromRGB(43, 43, 41)
				PharagraphTitle.BorderSizePixel = 0
				PharagraphTitle.Size = UDim2.new(0, 379, 0, 17)
				PharagraphTitle.Font = Enum.Font.GothamBold
				PharagraphTitle.Text = pharagraphtitle
				PharagraphTitle.TextColor3 = HawkLib.Themes[Theme].ItemTitleColors
				PharagraphTitle.TextSize = 15.000
				PharagraphTitle.TextXAlignment = Enum.TextXAlignment.Left

				ParagraphLayout.Parent = PharagraphListing
				ParagraphLayout.SortOrder = Enum.SortOrder.LayoutOrder
				ParagraphLayout.Padding = UDim.new(0, 2)

				local paragraphtable = {}
				for i, v in pairs(desc) do
					table.insert(paragraphtable, v)

					local PharagraphText = Instance.new("TextLabel")
					PharagraphText.Name = "PharagraphText"
					PharagraphText.Parent = PharagraphListing
					PharagraphText.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
					PharagraphText.BackgroundTransparency = 1.000
					PharagraphText.BorderColor3 = Color3.fromRGB(43, 43, 41)
					PharagraphText.BorderSizePixel = 0
					PharagraphText.ClipsDescendants = true
					PharagraphText.Position = UDim2.new(0, 0, 0.177083328, 0)
					PharagraphText.Size = UDim2.new(0, 372, 0, 15)
					PharagraphText.Font = Enum.Font.Gotham
					PharagraphText.Text = v
					PharagraphText.TextColor3 = HawkLib.Themes[Theme].ItemTextColors
					PharagraphText.TextSize = 15.000
					PharagraphText.TextWrapped = true
					PharagraphText.TextXAlignment = Enum.TextXAlignment.Left
					PharagraphText.TextYAlignment = Enum.TextYAlignment.Top

					TweenService:Create(
						Page,
						TweenInfo.new(.2, Enum.EasingStyle.Quad),
						{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
					):Play()
				end

				local fullparagraph = #paragraphtable
				if fullparagraph == 1 then
					Pharagraph.Size = UDim2.new(0, 391, 0, 50)
					PharagraphListing.Position = UDim2.new(0.0306905378, 0, 0.15, 0)
					PharagraphListing.Size = UDim2.new(0, 372, 0, 40)
				elseif fullparagraph == 2 then
					Pharagraph.Size = UDim2.new(0, 391, 0, 70)
					PharagraphListing.Position = UDim2.new(0.0306905378, 0, 0.13, 0)
					PharagraphListing.Size = UDim2.new(0, 372, 0, 50)
				elseif fullparagraph == 3 then
					Pharagraph.Size = UDim2.new(0, 391, 0, 85)
					PharagraphListing.Position = UDim2.new(0.0306905378, 0, 0.10, 0)
					PharagraphListing.Size = UDim2.new(0, 372, 0, 60)
				elseif fullparagraph == 4 then
					Pharagraph.Size = UDim2.new(0, 391, 0, 100)
					PharagraphListing.Position = UDim2.new(0.0306905378, 0, 0.09, 0)
					PharagraphListing.Size = UDim2.new(0, 372, 0, 60)
				elseif fullparagraph == 5 then
					Pharagraph.Size = UDim2.new(0, 391, 0, 120)
					PharagraphListing.Position = UDim2.new(0.0306905378, 0, 0.06, 0)
					PharagraphListing.Size = UDim2.new(0, 372, 0, 60)
				elseif fullparagraph > 5 then
					PharagraphListing.Position = UDim2.new(0.0306905378, 0, 0.06, 0)
					Pharagraph.Size = UDim2.new(0, 391, 0, ParagraphLayout.AbsoluteContentSize.Y + 20)
				end

				TweenService:Create(
					Page,
					TweenInfo.new(.2, Enum.EasingStyle.Quad),
					{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
				):Play()
			end

			function ContainerItems:Slider(Text, description, minvalue, maxvalue, callback)
				local xdd = description
				local drag = false
				minvalue = tonumber(minvalue)
				maxvalue = tonumber(maxvalue)

				callback = callback or function()
				end

				local ConfigSliderSettings = {}
				table.insert(HawkConfigSettings.Slider, ConfigSliderSettings)
				local ConfigSliderTitle = Text:gsub("[^%w]", "") .. "SliderSettings"

				ConfigSliderSettings[ConfigSliderTitle] = {}

				local mouse = game.Players.LocalPlayer:GetMouse()
				local uis = game:GetService("UserInputService")

				local Slider = Instance.new("Frame")
				local UICorner_14 = Instance.new("UICorner")
				local SliderListing = Instance.new("Frame")
				local SliderButtonFrame = Instance.new("Frame")
				local SliderButton = Instance.new("TextButton")
				local UICorner_15 = Instance.new("UICorner")
				local UICorner_16 = Instance.new("UICorner")
				local InSliderFrame = Instance.new("Frame")
				local UICorner_17 = Instance.new("UICorner")
				local UIGradient2 = Instance.new("UIGradient")
				local UIGradient_3 = Instance.new("UIGradient")
				local UIListLayout_8 = Instance.new("UIListLayout")
				local Num = Instance.new("TextLabel")
				local SliderTitle = Instance.new("TextLabel")
				local SliderText = Instance.new("TextLabel")
				local UICorner_20 = Instance.new("UICorner")

				local Num2 = Instance.new("TextLabel")
				local UICorner17 = Instance.new("UICorner")

				Slider.Name = "Slider"
				Slider.Parent = Container
				Slider.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
				Slider.BorderColor3 = Color3.fromRGB(35, 35, 35)
				Slider.BorderSizePixel = 0
				Slider.Position = UDim2.new(0.0196560193, 0, 0.569744587, 0)
				Slider.Size = UDim2.new(0, 391, 0, 83)

				UICorner_14.CornerRadius = UDim.new(0, 6)
				UICorner_14.Parent = Slider

				SliderListing.Name = "SliderListing"
				SliderListing.Parent = Slider
				SliderListing.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
				SliderListing.BackgroundTransparency = 1.000
				SliderListing.BorderColor3 = Color3.fromRGB(43, 43, 41)
				SliderListing.BorderSizePixel = 0
				SliderListing.Position = UDim2.new(0.0300000273, 0, 0.585481942, 0)
				SliderListing.Size = UDim2.new(0, 370, 0, 22)

				SliderButtonFrame.Name = "SliderButtonFrame"
				SliderButtonFrame.Parent = SliderListing
				SliderButtonFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderButtonFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
				SliderButtonFrame.BorderSizePixel = 0
				SliderButtonFrame.Size = UDim2.new(0, 370, 0, 22)
				SliderButtonFrame.ZIndex = 0

				SliderButton.Name = "SliderButton"
				SliderButton.Parent = SliderButtonFrame
				SliderButton.BackgroundColor3 = HawkLib.Themes[Theme].SliderButtonFrameColor
				SliderButton.BackgroundTransparency = 1.000
				SliderButton.BorderColor3 = Color3.fromRGB(35, 45, 55)
				SliderButton.BorderSizePixel = 0
				SliderButton.Size = UDim2.new(0, 372, 0, 32)
				SliderButton.Font = Enum.Font.SourceSans
				SliderButton.Text = ""
				SliderButton.TextColor3 = Color3.fromRGB(0, 0, 0)
				SliderButton.TextSize = 14.000

				UICorner_15.CornerRadius = UDim.new(0, 6)
				UICorner_15.Parent = SliderButton

				UICorner_16.CornerRadius = UDim.new(0, 4)
				UICorner_16.Parent = SliderButtonFrame

				InSliderFrame.Name = "InSliderFrame"
				InSliderFrame.Parent = SliderButtonFrame
				InSliderFrame.BackgroundColor3 = HawkLib.Themes[Theme].InSliderFrame
				InSliderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				InSliderFrame.BorderSizePixel = 0
				InSliderFrame.Position = UDim2.new(-0.00268817204, 0, 0, 0)
				InSliderFrame.Size = UDim2.new(0, 7, 0, 22)

				UICorner_17.CornerRadius = UDim.new(0, 4)
				UICorner_17.Parent = InSliderFrame

				UIGradient2.Color =
					ColorSequence.new {
						ColorSequenceKeypoint.new(0.00, HawkLib.Themes[Theme].FirstSlider.First),
						ColorSequenceKeypoint.new(1.00, HawkLib.Themes[Theme].FirstSlider.Second)
					}
				UIGradient2.Rotation = 90
				UIGradient2.Parent = InSliderFrame

				UIGradient_3.Color =
					ColorSequence.new {
						ColorSequenceKeypoint.new(0.00, HawkLib.Themes[Theme].SecondSlider.First),
						ColorSequenceKeypoint.new(1.00, HawkLib.Themes[Theme].SecondSlider.Second)
					}
				UIGradient_3.Rotation = 90
				UIGradient_3.Parent = SliderButtonFrame

				UIListLayout_8.Parent = SliderListing
				UIListLayout_8.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout_8.Padding = UDim.new(0, 8)

				Num.Name = "Num"
				Num.Parent = Slider
				Num.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Num.BackgroundTransparency = 1.000
				Num.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Num.BorderSizePixel = 0
				Num.Position = UDim2.new(0.809751689, 0, 0.0722891539, 0)
				Num.Size = UDim2.new(0, 66, 0, 17)
				Num.Font = Enum.Font.Gotham
				Num.Text = minvalue
				Num.TextColor3 = HawkLib.Themes[Theme].NumColor
				Num.TextSize = 14.000
				Num.TextXAlignment = Enum.TextXAlignment.Right

				SliderTitle.Name = "SliderTitle"
				SliderTitle.Parent = Slider
				SliderTitle.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
				SliderTitle.BackgroundTransparency = 1.000
				SliderTitle.BorderColor3 = Color3.fromRGB(43, 43, 41)
				SliderTitle.BorderSizePixel = 0
				SliderTitle.Position = UDim2.new(0.0204397533, 0, 0.0817018077, 0)
				SliderTitle.Size = UDim2.new(0, 374, 0, 17)
				SliderTitle.Font = Enum.Font.GothamBold
				SliderTitle.Text = Text
				SliderTitle.TextColor3 = HawkLib.Themes[Theme].ItemTitleColors
				SliderTitle.TextSize = 15.000
				SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

				SliderText.Name = "SliderText"
				SliderText.Parent = Slider
				SliderText.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
				SliderText.BackgroundTransparency = 1.000
				SliderText.BorderColor3 = Color3.fromRGB(43, 43, 41)
				SliderText.BorderSizePixel = 0
				SliderText.Position = UDim2.new(0.0200000182, 0, 0.286521077, 0)
				SliderText.Size = UDim2.new(0, 374, 0, 16)
				SliderText.Font = Enum.Font.Gotham
				SliderText.TextColor3 = HawkLib.Themes[Theme].ItemTextColors
				SliderText.TextSize = 15.000
				SliderText.Text = ""
				SliderText.TextXAlignment = Enum.TextXAlignment.Left

				UICorner_20.CornerRadius = UDim.new(0, 5)
				UICorner_20.Parent = Slider

				UICorner_20.CornerRadius = UDim.new(0, 5)
				UICorner_20.Parent = Num

				-- Estrela de favorito para Slider
				local FavoriteStar = Instance.new("ImageButton")
				FavoriteStar.Name = "FavoriteStar"
				FavoriteStar.Parent = Slider
				FavoriteStar.BackgroundTransparency = 1
				FavoriteStar.BorderSizePixel = 0
				FavoriteStar.Position = UDim2.new(0.75, 0, 0.08, 0)
				FavoriteStar.Size = UDim2.new(0, 25, 0, 25)
				FavoriteStar.Image = "rbxassetid://2708898245" -- Estrela padrão
				FavoriteStar.ImageColor3 = Color3.fromRGB(139, 139, 139) -- Cinza escuro
				
				-- Verificar se o item já está nos favoritos
				if Favorites[Text] then
					FavoriteStar.ImageColor3 = Color3.fromRGB(255, 215, 0) -- Dourado
				end
				
				-- Evento de clique na estrela de favorito
				FavoriteStar.MouseButton1Click:Connect(function()
					toggleFavorite(Text, {TabButton = TabButton})
					-- Alternar cor da estrela
					if Favorites[Text] then
						FavoriteStar.ImageColor3 = Color3.fromRGB(255, 215, 0) -- Dourado
					else
						FavoriteStar.ImageColor3 = Color3.fromRGB(139, 139, 139) -- Cinza
					end
				end)

				Num2.Name = "Num"
				Num2.Parent = InSliderFrame
				Num2.Active = true
				Num2.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
				Num2.BackgroundTransparency = 1.000
				Num2.BorderColor3 = Color3.fromRGB(67, 67, 67)
				Num2.Position = UDim2.new(0.930921078, 0, -1.65260839, 0)
				Num2.Size = UDim2.new(0, 30, 0, 18)
				Num2.Font = Enum.Font.GothamBold
				Num2.Text = minvalue
				Num2.TextColor3 = Color3.fromRGB(255, 255, 255)
				Num2.TextSize = 14.000
				Num2.TextTransparency = 1.000
				Num2.TextXAlignment = Enum.TextXAlignment.Left

				local a = Instance.new("UICorner")

				a.CornerRadius = UDim.new(0, 5)
				a.Parent = Slider

				local b = Instance.new("UICorner")

				b.CornerRadius = UDim.new(0, 5)
				b.Parent = Num

				if tonumber(xdd) == nil then
					SliderText.Text = description
				end

				SliderButton.MouseEnter:Connect(
					function()
						TweenService:Create(Num2, TweenInfo.new(.2, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play(

						)
					end
				)

				SliderButton.MouseLeave:Connect(
					function()
						TweenService:Create(Num2, TweenInfo.new(.2, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play(

						)
					end
				)

				local moving = false
				Slider.MouseEnter:Connect(
					function()
						moving = true
						TweenService:Create(
							Slider,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{BackgroundColor3 = HawkLib.Themes[Theme].Hover}
						):Play()
					end
				)
				Slider.MouseLeave:Connect(
					function()
						moving = false
						TweenService:Create(
							Slider,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{BackgroundColor3 = HawkLib.Themes[Theme].ItemColors}
						):Play()
						Page.ScrollingEnabled = true
					end
				)

				local mouse = game.Players.LocalPlayer:GetMouse()
				local uis = game:GetService("UserInputService")
				local Value

				local function moveslider()
					Page.ScrollingEnabled = false

					local mousePos = math.clamp(mouse.X - SliderButtonFrame.AbsolutePosition.X, 0, 371)

					Value = math.floor(
						(((tonumber(maxvalue) - tonumber(minvalue)) / 371) * mousePos) +
							tonumber(minvalue)
					)

					if mousePos >= 370 then
						Value = tonumber(maxvalue)
					end

					if mousePos <= 1 then
						Value = tonumber(minvalue)
					end

					Num.Text = Value
					Num2.Text = Value
					pcall(
						function()
							callback(Value)
						end
					)
					ConfigSliderSettings[ConfigSliderTitle]["Value"] = Value

					local visualSize = math.max(mousePos, 7)
					InSliderFrame:TweenSize(
						UDim2.new(0, visualSize, 0, 22),
						"In",
						"Quad",
						0.09
					)
				end
			

				SliderButton.MouseButton1Down:Connect(
					function()
						if OnPc then
							moveslider()

							moveconnection =
								mouse.Move:Connect(
									function()
										moveslider()
									end
								)
							releaseconnection =
								uis.InputEnded:Connect(
									function(Mouse)
										if
											Mouse.UserInputType == Enum.UserInputType.MouseButton1 or
											Mouse.UserInputType == Enum.UserInputType.Touch
										then
											moveslider()
											moveconnection:Disconnect()
											releaseconnection:Disconnect()
										end
									end
								)
						else
							moveslider()

							moveconnection =
								mouse.Move:Connect(
									function()
										if moving then
											moveslider()
										end
									end
								)

							startmouse =
								SliderButton.InputBegan:Connect(
									function(Mouse)
										if
											Mouse.UserInputType == Enum.UserInputType.Touch or
											Mouse.UserInputType == Enum.UserInputType.MouseButton1
										then
											moveslider()
										end
									end
								)

							movemouse =
								SliderButton.InputChanged:Connect(
									function(Mouse)
										if
											Mouse.UserInputType == Enum.UserInputType.Touch or
											Mouse.UserInputType == Enum.UserInputType.MouseButton1
										then
											moveslider()
										end
									end
								)

							releasemouse =
								SliderButton.InputEnded:Connect(
									function(Mouse)
										if
											Mouse.UserInputType == Enum.UserInputType.Touch or
											Mouse.UserInputType == Enum.UserInputType.MouseMovement
										then
											moveslider()
											movemouse:Disconnect()
											startmouse:Disconnect()
											releasemouse:Disconnect()
											Page.ScrollingEnabled = true
										end
									end
								)
						end
					end
				)

				TweenService:Create(
					Page,
					TweenInfo.new(.2, Enum.EasingStyle.Quad),
					{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
				):Play()

				TweenService:Create(
					Page,
					TweenInfo.new(.2, Enum.EasingStyle.Quad),
					{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
				):Play()
				local slid = {}
				function slid:SetValue(dodoj)
					if dodoj == nil then
						dodoj = 0
						local percentage =
							math.clamp(
								(Mouse.X - InSliderFrame.AbsolutePosition.X) / (InSliderFrame.AbsoluteSize.X),
								0,
								1
							)
						local value =
							math.floor(
								(((tonumber(maxvalue) - tonumber(minvalue)) / 371) * percentage) + tonumber(minvalue)
							)

						dodoj = value

						Num.Text = tostring(dodoj)
						Num2.Text = tostring(dodoj)

						local calculatedWidth = math.max(percentage * 371, 7)
						InSliderFrame.Size = UDim2.new(0, calculatedWidth, 0, 22)

						pcall(
							function()
								callback(dodoj)
							end
						)
					else
						Num.Text = tostring(dodoj)
						Num2.Text = tostring(dodoj)

						local percentage = ((dodoj - tonumber(minvalue)) / (tonumber(maxvalue) - tonumber(minvalue)))
						local calculatedWidth = math.max(percentage * 371, 7)
						InSliderFrame.Size = UDim2.new(0, calculatedWidth, 0, 22)

						pcall(
							function()
								callback(dodoj)
							end
						)
					end

					ConfigSliderSettings[ConfigSliderTitle]["Value"] = dodoj
				end

				function slid:SetColor(bruuuh)
					local aaa = bruuuh
					if aaa ~= nil and type(aaa) == "table" then
						for i, v in pairs(aaa) do
							if i == "SliderPrimer" then
								for _, q in next, v do
									UIGradient2.Color =
										ColorSequence.new {
											ColorSequenceKeypoint.new(0.00, v["FirstColor"]),
											ColorSequenceKeypoint.new(1.00, v["SecondColor"])
										}
								end
							elseif i == "SliderSeconder" then
								for _, q in next, v do
									UIGradient_3.Color =
										ColorSequence.new {
											ColorSequenceKeypoint.new(0.00, v["FirstColor"]),
											ColorSequenceKeypoint.new(1.00, v["SecondColor"])
										}
								end
							end
						end
					end
				end

				function slid:GetValue()
					return tonumber(Num.Text)
				end

				HawkLib.Elements.Slider[ConfigSliderTitle] = slid
				return slid
			end

			function ContainerItems:Line()
				local Line = Instance.new("Frame")
				local LineCorner = Instance.new("UICorner")

				Line.Name = "Line"
				Line.Parent = Container
				Line.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
				Line.BorderColor3 = Color3.fromRGB(43, 43, 41)
				Line.BorderSizePixel = 0
				Line.Position = UDim2.new(0.377149731, 0, 1.22200394, 0)
				Line.Size = UDim2.new(0, 391, 0, 8)

				LineCorner.Parent = Line

				TweenService:Create(
					Page,
					TweenInfo.new(.2, Enum.EasingStyle.Quad),
					{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
				):Play()
			end

			function ContainerItems:ColorPicker(text, description, preset, callback)
				local ConfigColorpickerSettings = {}
				table.insert(HawkConfigSettings.ColorPicker, ConfigColorpickerSettings)
				local ConfigColorpickerTitle = text:gsub("[^%w]", "") .. "ColorpickerSettings"

				ConfigColorpickerSettings[ConfigColorpickerTitle] = {}
				ConfigColorpickerSettings[ConfigColorpickerTitle]["Color"] = tostring(preset)

				local ColorPickerToggled = false
				local OldToggleColor = Color3.fromRGB(0, 0, 0)
				local OldColor = Color3.fromRGB(0, 0, 0)
				local OldColorSelectionPosition = nil
				local OldHueSelectionPosition = nil
				local ColorH, ColorS, ColorV = 1, 1, 1
				local RainbowColorPicker = false
				local ColorPickerInput = nil
				local ColorInput = nil
				local HueInput = nil

				local ColorpickerListing = Instance.new("Frame")
				local ColorpickerLayout = Instance.new("UIListLayout")
				local Colorpicker = Instance.new("TextButton")
				local Title = Instance.new("TextLabel")
				local Description = Instance.new("TextLabel")
				local BoxColor = Instance.new("Frame")
				local BoxcolorCorner = Instance.new("UICorner")
				local ColorpickerCorner = Instance.new("UICorner")

				Colorpicker.Name = "Colorpicker"
				Colorpicker.Parent = Container
				Colorpicker.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
				Colorpicker.Position = UDim2.new(0, 0, 0, 0)
				Colorpicker.Size = UDim2.new(0, 391, 0, 55)
				Colorpicker.AutoButtonColor = false
				Colorpicker.Font = Enum.Font.Gotham
				Colorpicker.Text = ""
				Colorpicker.TextColor3 = Color3.fromRGB(255, 255, 255)
				Colorpicker.TextSize = 14.000

				ColorpickerListing.Name = "ButtonListing"
				ColorpickerListing.Parent = Colorpicker
				ColorpickerListing.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
				ColorpickerListing.BackgroundTransparency = 1.000
				ColorpickerListing.BorderColor3 = Color3.fromRGB(43, 43, 41)
				ColorpickerListing.BorderSizePixel = 0
				ColorpickerListing.Position = UDim2.new(0.0306905378, 0, 0.17634055, 0)
				ColorpickerListing.Size = UDim2.new(0, 372, 0, 32)

				ColorpickerLayout.Parent = ColorpickerListing
				ColorpickerLayout.SortOrder = Enum.SortOrder.LayoutOrder

				Title.Name = "Title"
				Title.Parent = ColorpickerListing
				Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Title.BackgroundTransparency = 1.000
				Title.Size = UDim2.new(0, 379, 0, 17)
				Title.Text = text
				Title.Font = Enum.Font.GothamBold
				Title.TextColor3 = HawkLib.Themes[Theme].ItemTitleColors
				Title.TextSize = 15.000
				Title.TextXAlignment = Enum.TextXAlignment.Left

				Description.Name = "ButtonText"
				Description.Parent = ColorpickerListing
				Description.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
				Description.BackgroundTransparency = 1.000
				Description.BorderColor3 = Color3.fromRGB(43, 43, 41)
				Description.BorderSizePixel = 0
				Description.Position = UDim2.new(0, 0, 0.170000002, 0)
				Description.Size = UDim2.new(0, 379, 0, 17)
				Description.Font = Enum.Font.Gotham
				Description.TextColor3 = HawkLib.Themes[Theme].ItemTextColors
				Description.TextSize = 15.000
				Description.Text = description
				Description.TextXAlignment = Enum.TextXAlignment.Left

				BoxColor.Name = "Boxcolor"
				BoxColor.Parent = Colorpicker
				BoxColor.BackgroundColor3 = preset
				BoxColor.Position = UDim2.new(0.83, 0, 0.24, 0)
				BoxColor.Size = UDim2.new(0, 51, 0, 25)

				BoxcolorCorner.CornerRadius = UDim.new(0, 6)
				BoxcolorCorner.Name = "BoxcolorCorner"
				BoxcolorCorner.Parent = BoxColor

				ColorpickerCorner.CornerRadius = UDim.new(0, 4)
				ColorpickerCorner.Name = "ColorpickerCorner"
				ColorpickerCorner.Parent = Colorpicker

				if description == "" then
					ColorpickerListing.Position = UDim2.new(0.0306905378, 0, 0.349999994, 0)
				else
					ColorpickerListing.Position = UDim2.new(0.0306905378, 0, 0.17634055, 0)
				end

				local ColorpickerFrame = Instance.new("Frame")
				local DropdownFrameCorner = Instance.new("UICorner")
				local Hue = Instance.new("ImageLabel")
				local HueCorner = Instance.new("UICorner")
				local HueGradient = Instance.new("UIGradient")
				local HueSelection = Instance.new("ImageLabel")
				local Color = Instance.new("ImageLabel")
				local ColorCorner = Instance.new("UICorner")
				local ColorSelection = Instance.new("ImageLabel")
				local Confirm = Instance.new("TextButton")
				local ButtonCorner = Instance.new("UICorner")
				local RainbowToggle = Instance.new("TextButton")
				local RainbowToggleCorner = Instance.new("UICorner")
				local RainbowTitle = Instance.new("TextLabel")
				local RainbowToggleFrame = Instance.new("Frame")
				local RainbowToggleFrameCorner = Instance.new("UICorner")
				local RainbowToggleFrameRainbow = Instance.new("Frame")
				local RainbowToggleFrameRainbowCorner = Instance.new("UICorner")
				local RainbowToggleDot = Instance.new("Frame")
				local RainbowToggleDotCorner = Instance.new("UICorner")

				ColorpickerFrame.Name = "ColorpickerFrame"
				ColorpickerFrame.Parent = Container
				ColorpickerFrame.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
				ColorpickerFrame.BackgroundTransparency = 0.2
				ColorpickerFrame.BorderSizePixel = 0
				ColorpickerFrame.Position = UDim2.new(0, 0, 0, 0)
				ColorpickerFrame.Size = UDim2.new(0, 391, 0, 0)
				ColorpickerFrame.Visible = false
				ColorpickerFrame.ClipsDescendants = true

				DropdownFrameCorner.Name = "DropdownFrameCorner"
				DropdownFrameCorner.Parent = ColorpickerFrame

				Hue.Name = "Hue"
				Hue.Parent = ColorpickerFrame
				Hue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Hue.Position = UDim2.new(0, 209, 0, 9)
				Hue.Size = UDim2.new(0, 25, 0, 80)

				HueCorner.CornerRadius = UDim.new(0, 3)
				HueCorner.Name = "HueCorner"
				HueCorner.Parent = Hue

				HueGradient.Color =
					ColorSequence.new {
						ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)),
						ColorSequenceKeypoint.new(0.20, Color3.fromRGB(234, 255, 0)),
						ColorSequenceKeypoint.new(0.40, Color3.fromRGB(21, 255, 0)),
						ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 255, 255)),
						ColorSequenceKeypoint.new(0.80, Color3.fromRGB(0, 17, 255)),
						ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 251)),
						ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4))
					}
				HueGradient.Rotation = 270
				HueGradient.Name = "HueGradient"
				HueGradient.Parent = Hue

				HueSelection.Name = "HueSelection"
				HueSelection.Parent = Hue
				HueSelection.AnchorPoint = Vector2.new(0.5, 0.5)
				HueSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				HueSelection.BackgroundTransparency = 1.000
				HueSelection.Position = UDim2.new(0.48, 0, 1 - select(1, Color3.toHSV(preset)))
				HueSelection.Size = UDim2.new(0, 18, 0, 18)
				HueSelection.Image = "http://www.roblox.com/asset/?id=4805639000"

				Color.Name = "Color"
				Color.Parent = ColorpickerFrame
				Color.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
				Color.Position = UDim2.new(0, 9, 0, 9)
				Color.Size = UDim2.new(0, 194, 0, 80)
				Color.ZIndex = 10
				Color.Image = "rbxassetid://4155801252"

				ColorCorner.CornerRadius = UDim.new(0, 3)
				ColorCorner.Name = "ColorCorner"
				ColorCorner.Parent = Color

				ColorSelection.Name = "ColorSelection"
				ColorSelection.Parent = Color
				ColorSelection.AnchorPoint = Vector2.new(0.5, 0.5)
				ColorSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ColorSelection.BackgroundTransparency = 1.000
				ColorSelection.Position = UDim2.new(preset and select(3, Color3.toHSV(preset)))
				ColorSelection.Size = UDim2.new(0, 18, 0, 18)
				ColorSelection.Image = "http://www.roblox.com/asset/?id=4805639000"
				ColorSelection.ScaleType = Enum.ScaleType.Fit

				Confirm.Name = "Confirm"
				Confirm.Parent = ColorpickerFrame
				Confirm.BackgroundColor3 = HawkLib.Themes[Theme].TitleBar
				Confirm.BackgroundTransparency = 1
				Confirm.Position = UDim2.new(0.62, 0, 0.0900000036, 0)
				Confirm.Size = UDim2.new(0, 145, 0, 27)
				Confirm.AutoButtonColor = false
				Confirm.Font = Enum.Font.Gotham
				Confirm.Text = "Confirm"
				Confirm.TextColor3 = HawkLib.Themes[Theme].ItemTitleColors
				Confirm.TextSize = 14.000

				ButtonCorner.Name = "ButtonCorner"
				ButtonCorner.Parent = Confirm

				RainbowToggle.Name = "RainbowToggle"
				RainbowToggle.Parent = ColorpickerFrame
				RainbowToggle.BackgroundColor3 = HawkLib.Themes[Theme].TitleBar
				RainbowToggle.Position = UDim2.new(0.62, 0, 0.431324542, 0)
				RainbowToggle.Size = UDim2.new(0, 145, 0, 27)
				RainbowToggle.AutoButtonColor = false
				RainbowToggle.BackgroundTransparency = 1
				RainbowToggle.Font = Enum.Font.Gotham
				RainbowToggle.Text = ""
				RainbowToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
				RainbowToggle.TextSize = 14.000

				RainbowToggleCorner.Name = "RainbowToggleCorner"
				RainbowToggleCorner.Parent = RainbowToggle

				RainbowTitle.Name = "RainbowTitle"
				RainbowTitle.Parent = RainbowToggle
				RainbowTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				RainbowTitle.BackgroundTransparency = 1.000
				RainbowTitle.Position = UDim2.new(0.1, 0, 0, 0)
				RainbowTitle.Size = UDim2.new(0, 29, 0, 27)
				RainbowTitle.Font = Enum.Font.Gotham
				RainbowTitle.Text = "Rainbow"
				RainbowTitle.TextColor3 = HawkLib.Themes[Theme].ItemTitleColors
				RainbowTitle.TextSize = 14.000
				RainbowTitle.TextXAlignment = Enum.TextXAlignment.Left

				RainbowToggleFrame.Name = "RainbowToggleFrame"
				RainbowToggleFrame.Parent = RainbowToggle
				RainbowToggleFrame.BackgroundColor3 = HawkLib.Themes[Theme].Main
				RainbowToggleFrame.Position = UDim2.new(0.693, 0, 0.142857149, 0)
				RainbowToggleFrame.Size = UDim2.new(0, 36, 0, 19)

				RainbowToggleFrameCorner.CornerRadius = UDim.new(1, 0)
				RainbowToggleFrameCorner.Name = "RainbowToggleFrameCorner"
				RainbowToggleFrameCorner.Parent = RainbowToggleFrame

				RainbowToggleFrameRainbow.Name = "RainbowToggleFrameRainbow"
				RainbowToggleFrameRainbow.Parent = RainbowToggleFrame
				RainbowToggleFrameRainbow.BackgroundColor3 = Color3.fromRGB(67, 136, 246)
				RainbowToggleFrameRainbow.BackgroundTransparency = 1.000
				RainbowToggleFrameRainbow.Position = UDim2.new(-0.0198377371, 0, 0.00601506233, 0)
				RainbowToggleFrameRainbow.Size = UDim2.new(0, 36, 0, 19)

				RainbowToggleFrameRainbowCorner.CornerRadius = UDim.new(1, 0)
				RainbowToggleFrameRainbowCorner.Name = "RainbowToggleFrameRainbowCorner"
				RainbowToggleFrameRainbowCorner.Parent = RainbowToggleFrameRainbow

				RainbowToggleDot.Name = "RainbowToggleDot"
				RainbowToggleDot.Parent = RainbowToggleFrameRainbow
				RainbowToggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				RainbowToggleDot.Position = UDim2.new(0.104999997, -3, 0.289000005, -4)
				RainbowToggleDot.Size = UDim2.new(0, 16, 0, 16)

				RainbowToggleDotCorner.CornerRadius = UDim.new(1, 0)
				RainbowToggleDotCorner.Name = "RainbowToggleDotCorner"
				RainbowToggleDotCorner.Parent = RainbowToggleDot

				TweenService:Create(
					Page,
					TweenInfo.new(.2, Enum.EasingStyle.Quad),
					{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
				):Play()

				Colorpicker.MouseEnter:Connect(
					function()
						TweenService:Create(
							Colorpicker,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{BackgroundColor3 = HawkLib.Themes[Theme].Hover}
						):Play()
					end
				)
				Colorpicker.MouseLeave:Connect(
					function()
						TweenService:Create(
							Colorpicker,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{BackgroundColor3 = HawkLib.Themes[Theme].ItemColors}
						):Play()
						Page.ScrollingEnabled = true
					end
				)

				local function UpdateColorPicker(nope)
					BoxColor.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
					Color.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
					ConfigColorpickerSettings[ConfigColorpickerTitle]["Color"] = tostring(BoxColor.BackgroundColor3)
					pcall(callback, BoxColor.BackgroundColor3)
				end

				ColorH =
					1 -
					(math.clamp(HueSelection.AbsolutePosition.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) /
						Hue.AbsoluteSize.Y)
				ColorS =
					(math.clamp(ColorSelection.AbsolutePosition.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) /
						Color.AbsoluteSize.X)
				ColorV =
					1 -
					(math.clamp(ColorSelection.AbsolutePosition.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) /
						Color.AbsoluteSize.Y)

				BoxColor.BackgroundColor3 = preset
				Color.BackgroundColor3 = preset
				pcall(callback, BoxColor.BackgroundColor3)
				ConfigColorpickerSettings[ConfigColorpickerTitle]["Color"] = preset

				Color.InputBegan:Connect(
					function(input)
						if
							input.UserInputType == Enum.UserInputType.MouseButton1 or
							input.UserInputType == Enum.UserInputType.Touch
						then
							Page.ScrollingEnabled = false
							if RainbowColorPicker then
								return
							end

							if ColorInput then
								ColorInput:Disconnect()
							end

							ColorInput =
								RunService.RenderStepped:Connect(
									function()
										local ColorX =
										(math.clamp(Mouse.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) /
											Color.AbsoluteSize.X)
										local ColorY =
										(math.clamp(Mouse.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) /
											Color.AbsoluteSize.Y)

										ColorSelection.Position = UDim2.new(ColorX, 0, ColorY, 0)
										ColorS = ColorX
										ColorV = 1 - ColorY

										UpdateColorPicker(true)
									end
								)
						end
					end
				)

				Color.InputChanged:Connect(
					function(input)
						if
							input.UserInputType == Enum.UserInputType.MouseButton1 or
							input.UserInputType == Enum.UserInputType.Touch
						then
							Page.ScrollingEnabled = false
							if RainbowColorPicker then
								return
							end

							if ColorInput then
								ColorInput:Disconnect()
							end

							ColorInput =
								RunService.RenderStepped:Connect(
									function()
										local ColorX =
										(math.clamp(Mouse.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) /
											Color.AbsoluteSize.X)
										local ColorY =
										(math.clamp(Mouse.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) /
											Color.AbsoluteSize.Y)

										ColorSelection.Position = UDim2.new(ColorX, 0, ColorY, 0)
										ColorS = ColorX
										ColorV = 1 - ColorY

										UpdateColorPicker(true)
									end
								)
						end
					end
				)

				Color.InputEnded:Connect(
					function(input)
						if
							input.UserInputType == Enum.UserInputType.MouseButton1 or
							input.UserInputType == Enum.UserInputType.Touch
						then
							if ColorInput then
								ColorInput:Disconnect()
							end
						end
					end
				)

				Hue.InputBegan:Connect(
					function(input)
						if
							input.UserInputType == Enum.UserInputType.MouseButton1 or
							input.UserInputType == Enum.UserInputType.Touch
						then
							Page.ScrollingEnabled = false
							if RainbowColorPicker then
								return
							end

							if HueInput then
								HueInput:Disconnect()
							end

							HueInput =
								RunService.RenderStepped:Connect(
									function()
										local HueY =
										(math.clamp(Mouse.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) /
											Hue.AbsoluteSize.Y)

										HueSelection.Position = UDim2.new(0.48, 0, HueY, 0)
										ColorH = 1 - HueY

										UpdateColorPicker(true)
									end
								)
						end
					end
				)

				Hue.InputChanged:Connect(
					function(input)
						if
							input.UserInputType == Enum.UserInputType.MouseButton1 or
							input.UserInputType == Enum.UserInputType.Touch
						then
							Page.ScrollingEnabled = false
							if RainbowColorPicker then
								return
							end

							if HueInput then
								HueInput:Disconnect()
							end

							HueInput =
								RunService.RenderStepped:Connect(
									function()
										local HueY =
										(math.clamp(Mouse.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) /
											Hue.AbsoluteSize.Y)

										HueSelection.Position = UDim2.new(0.48, 0, HueY, 0)
										ColorH = 1 - HueY

										UpdateColorPicker(true)
									end
								)
						end
					end
				)

				Hue.InputEnded:Connect(
					function(input)
						if
							input.UserInputType == Enum.UserInputType.MouseButton1 or
							input.UserInputType == Enum.UserInputType.Touch
						then
							if HueInput then
								HueInput:Disconnect()
							end
						end
						if not LibParent:FindFirstChild("Hawk") then
							if HueInput then
								HueInput:Disconnect()
							end
						end
					end
				)

				RainbowToggle.MouseButton1Click:Connect(
					function()
						RainbowColorPicker = not RainbowColorPicker

						if ColorInput then
							ColorInput:Disconnect()
						end

						if HueInput then
							HueInput:Disconnect()
						end

						if RainbowColorPicker then
							TweenService:Create(
								RainbowToggleFrameRainbow,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{BackgroundTransparency = 0}
							):Play()
							TweenService:Create(
								RainbowToggleDot,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{Position = UDim2.new(0.595, -3, 0.289000005, -4)}
							):Play()

							OldToggleColor = BoxColor.BackgroundColor3
							OldColor = Color.BackgroundColor3
							OldColorSelectionPosition = ColorSelection.Position
							OldHueSelectionPosition = HueSelection.Position

							while RainbowColorPicker do
								BoxColor.BackgroundColor3 = Color3.fromHSV(Strawn.RainbowColorValue, 1, 1)
								Color.BackgroundColor3 = Color3.fromHSV(Strawn.RainbowColorValue, 1, 1)

								ColorSelection.Position = UDim2.new(1, 0, 0, 0)
								HueSelection.Position = UDim2.new(0.48, 0, 0, Strawn.HueSelectionPosition)

								pcall(callback, BoxColor.BackgroundColor3)
								wait()
							end
						elseif not RainbowColorPicker then
							TweenService:Create(
								RainbowToggleFrameRainbow,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{BackgroundTransparency = 1}
							):Play()
							TweenService:Create(
								RainbowToggleDot,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{Position = UDim2.new(0.104999997, -3, 0.289000005, -4)}
							):Play()

							BoxColor.BackgroundColor3 = OldToggleColor
							Color.BackgroundColor3 = OldColor

							ColorSelection.Position = OldColorSelectionPosition
							HueSelection.Position = OldHueSelectionPosition

							pcall(callback, BoxColor.BackgroundColor3)
						end
						ConfigColorpickerSettings[ConfigColorpickerTitle]["Color"] = BoxColor.BackgroundColor3
					end
				)

				Colorpicker.MouseButton1Click:Connect(
					function()
						if ColorPickerToggled == false then
							ColorPickerToggled = not ColorPickerToggled
							ColorpickerFrame.Visible = true
							ColorpickerFrame:TweenSize(
								UDim2.new(0, 391, 0, 100),
								Enum.EasingDirection.Out,
								Enum.EasingStyle.Quart,
								0.1,
								true
							)

							repeat
								wait()
							until ColorpickerFrame.Size == UDim2.new(0, 391, 0, 100)
							TweenService:Create(
								Page,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
							):Play()
						else
							ColorPickerToggled = not ColorPickerToggled

							ColorpickerFrame:TweenSize(
								UDim2.new(0, 391, 0, 0),
								Enum.EasingDirection.Out,
								Enum.EasingStyle.Quart,
								0.1,
								true
							)
							repeat
								wait()
							until ColorpickerFrame.Size == UDim2.new(0, 391, 0, 0)
							ColorpickerFrame.Visible = false
							TweenService:Create(
								Page,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
							):Play()
						end
					end
				)

				Confirm.MouseButton1Click:Connect(
					function()
						ColorPickerToggled = not ColorPickerToggled

						ColorpickerFrame:TweenSize(
							UDim2.new(0, 391, 0, 0),
							Enum.EasingDirection.Out,
							Enum.EasingStyle.Quart,
							0.1,
							true
						)
						repeat
							wait()
						until ColorpickerFrame.Size == UDim2.new(0, 391, 0, 0)
						ColorpickerFrame.Visible = false
						TweenService:Create(
							Page,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
						):Play()
					end
				)

				TweenService:Create(
					Page,
					TweenInfo.new(.2, Enum.EasingStyle.Quad),
					{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
				):Play()

				local colory = {}

				function colory:SetColor(colorrrr)
					if typeof(colorrrr) ~= "Color3" then
						return
					end
					local h, s, v = Color3.toHSV(colorrrr)
					ColorH = h
					ColorS = s
					ColorV = v
					BoxColor.BackgroundColor3 = colorrrr
					Color.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
					ColorSelection.Position = UDim2.new(s, 0, 1 - v, 0)
					HueSelection.Position = UDim2.new(0.48, 0, 1 - h, 0)

					if RainbowColorPicker then
						RainbowColorPicker = false

						TweenService:Create(
							RainbowToggleFrameRainbow,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{BackgroundTransparency = 1}
						):Play()

						TweenService:Create(
							RainbowToggleDot,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{Position = UDim2.new(0.104999997, -3, 0.289000005, -4)}
						):Play()
					end
					ConfigColorpickerSettings[ConfigColorpickerTitle]["Color"] = tostring(colorrrr)
					pcall(callback, colorrrr)
				end

				HawkLib.Elements.ColorPicker[ConfigColorpickerTitle] = colory

				return colory
			end

			function ContainerItems:KeyBind(title, description, first, callback)
				callback = callback or function()
				end
				local oldKey = first

				local ConfigKeybindSettings = {}
				table.insert(HawkConfigSettings.Keybind, ConfigKeybindSettings)
				local ConfigKeybindTitle = title:gsub("[^%w]", "") .. "KeybindSettings"

				ConfigKeybindSettings[ConfigKeybindTitle] = {}
				ConfigKeybindSettings[ConfigKeybindTitle]["Key"] = oldKey

				local KeyBind = Instance.new("Frame")
				local UICorner_22 = Instance.new("UICorner")
				local KeyBindTitle = Instance.new("TextLabel")
				local BindSelection = Instance.new("Frame")
				local UICorner_23 = Instance.new("UICorner")
				local UIStroke_9 = Instance.new("UIStroke")
				local Bind = Instance.new("TextButton")
				local KeyBindText = Instance.new("TextLabel")

				KeyBind.Name = "KeyBind"
				KeyBind.Parent = Container
				KeyBind.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
				KeyBind.BorderColor3 = HawkLib.Themes[Theme].ItemColors
				KeyBind.BorderSizePixel = 0
				KeyBind.Position = UDim2.new(0.0196560193, 0, 0.748526514, 0)
				KeyBind.Size = UDim2.new(0, 391, 0, 51)

				UICorner_22.CornerRadius = UDim.new(0, 6)
				UICorner_22.Parent = KeyBind

				KeyBindTitle.Name = "KeyBindTitle"
				KeyBindTitle.Parent = KeyBind
				KeyBindTitle.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
				KeyBindTitle.BackgroundTransparency = 1.000
				KeyBindTitle.BorderColor3 = Color3.fromRGB(43, 43, 41)
				KeyBindTitle.BorderSizePixel = 0
				KeyBindTitle.Position = UDim2.new(0.0199999996, 0, 0.0820000023, 0)
				KeyBindTitle.Size = UDim2.new(0, 374, 0, 22)
				KeyBindTitle.Font = Enum.Font.GothamBold
				KeyBindTitle.Text = title
				KeyBindTitle.TextColor3 = HawkLib.Themes[Theme].ItemTitleColors
				KeyBindTitle.TextSize = 15.000
				KeyBindTitle.TextXAlignment = Enum.TextXAlignment.Left

				BindSelection.Name = "BindSelection"
				BindSelection.Parent = KeyBind
				BindSelection.BackgroundColor3 = HawkLib.Themes[Theme].ItemTextBoxKeyBindColors
				BindSelection.BorderColor3 = HawkLib.Themes[Theme].ItemTextBoxKeyBindColors
				BindSelection.BorderSizePixel = 0
				BindSelection.Position = UDim2.new(0.90025574, 0, 0.221034035, 0)
				BindSelection.Size = UDim2.new(0, 30, 0, 28)

				UICorner_23.CornerRadius = UDim.new(0, 6)
				UICorner_23.Parent = BindSelection

				UIStroke_9.Parent = BindSelection
				UIStroke_9.Color = HawkLib.Themes[Theme].ItemTextBoxKeyBindStrokeColors
				UIStroke_9.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

				Bind.Name = "Bind"
				Bind.Parent = BindSelection
				Bind.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
				Bind.BackgroundTransparency = 1.000
				Bind.BorderColor3 = Color3.fromRGB(27, 27, 27)
				Bind.BorderSizePixel = 0
				Bind.Size = UDim2.new(0, 30, 0, 28)
				Bind.Font = Enum.Font.Gotham
				Bind.Text = first
				Bind.TextColor3 = HawkLib.Themes[Theme].ItemKeyBindTextColor
				Bind.TextSize = 16.000
				Bind.AutoButtonColor = false

				KeyBindText.Name = "KeyBindText"
				KeyBindText.Parent = KeyBind
				KeyBindText.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
				KeyBindText.BackgroundTransparency = 1.000
				KeyBindText.BorderColor3 = Color3.fromRGB(43, 43, 41)
				KeyBindText.BorderSizePixel = 0
				KeyBindText.Position = UDim2.new(0.0199999996, 0, 0.504000008, 0)
				KeyBindText.Size = UDim2.new(0, 374, 0, 16)
				KeyBindText.Font = Enum.Font.Gotham
				KeyBindText.Text = description
				KeyBindText.TextColor3 = HawkLib.Themes[Theme].ItemTextColors
				KeyBindText.TextSize = 15.000
				KeyBindText.TextXAlignment = Enum.TextXAlignment.Left

				if description == "" then
					KeyBindTitle.Position = UDim2.new(0.0199999996, 0, 0.3, 0)
				else
					KeyBindTitle.Position = UDim2.new(0.0199999996, 0, 0.0820000023, 0)
				end

				KeyBind.MouseEnter:Connect(
					function()
						TweenService:Create(
							KeyBind,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{BackgroundColor3 = HawkLib.Themes[Theme].Hover}
						):Play()
					end
				)
				KeyBind.MouseLeave:Connect(
					function()
						TweenService:Create(
							KeyBind,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{BackgroundColor3 = HawkLib.Themes[Theme].ItemColors}
						):Play()
					end
				)

				Bind.MouseButton1Click:Connect(
					function()
						ripple(BindSelection, Mouse.X, Mouse.Y)
					end
				)

				Bind.MouseButton1Click:Connect(
					function(e)
						Bind.Text = ". . ."
						local a, b = game:GetService("UserInputService").InputBegan:wait()
						if a.KeyCode.Name ~= "Unknown" then
							Bind.Text = a.KeyCode.Name
							oldKey = a.KeyCode.Name
							print(a.KeyCode.Name)
							ConfigKeybindSettings[ConfigKeybindTitle]["Key"] = oldKey
						end
					end
				)

				game:GetService("UserInputService").InputBegan:connect(
					function(current, ok)
						if not ok then
							if current.KeyCode.Name == oldKey then
								callback()
							end
						end
					end
				)

				Bind:GetPropertyChangedSignal("Text"):Connect(
					function()
						if string.len(Bind.Text) == 1 then
							BindSelection.Position = UDim2.new(0.902813315, 0, 0.181818187, 0)
							Bind.Size = UDim2.new(0, 30, 0, 28)
							BindSelection.Size = UDim2.new(0, 30, 0, 28)
						elseif string.len(Bind.Text) == 2 then
							BindSelection.Position = UDim2.new(0.89, 0, 0.181818187, 0)
							Bind.Size = UDim2.new(0, 36, 0, 28)
							BindSelection.Size = UDim2.new(0, 36, 0, 28)
						elseif string.len(Bind.Text) == 3 then
							BindSelection.Position = UDim2.new(0.885, 0, 0.181818187, 0)
							Bind.Size = UDim2.new(0, 39, 0, 28)
							BindSelection.Size = UDim2.new(0, 39, 0, 28)
						elseif string.len(Bind.Text) == 4 then
							BindSelection.Position = UDim2.new(0.85, 0, 0.181818187, 0)
							Bind.Size = UDim2.new(0, 52, 0, 28)
							BindSelection.Size = UDim2.new(0, 52, 0, 28)
						elseif string.len(Bind.Text) == 5 then
							BindSelection.Position = UDim2.new(0.84, 0, 0.181818187, 0)
							Bind.Size = UDim2.new(0, 58, 0, 28)
							BindSelection.Size = UDim2.new(0, 58, 0, 28)
						elseif string.len(Bind.Text) == 6 then
							BindSelection.Position = UDim2.new(0.83, 0, 0.181818187, 0)
							Bind.Size = UDim2.new(0, 60, 0, 28)
							BindSelection.Size = UDim2.new(0, 60, 0, 28)
						elseif string.len(Bind.Text) >= 7 and string.len(Bind.Text) < 9 then
							BindSelection.Position = UDim2.new(0.76, 0, 0.181818187, 0)
							Bind.Size = UDim2.new(0, 83, 0, 28)
							BindSelection.Size = UDim2.new(0, 83, 0, 28)
						elseif string.len(Bind.Text) == 9 then
							BindSelection.Position = UDim2.new(0.74, 0, 0.181818187, 0)
							Bind.Size = UDim2.new(0, 93, 0, 28)
							BindSelection.Size = UDim2.new(0, 93, 0, 28)
						elseif string.len(Bind.Text) > 9 and string.len(Bind.Text) < 11 then
							BindSelection.Position = UDim2.new(0.74, 0, 0.181818187, 0)
							Bind.Size = UDim2.new(0, 97, 0, 28)
							BindSelection.Size = UDim2.new(0, 97, 0, 28)
						elseif string.len(Bind.Text) >= 11 and string.len(Bind.Text) < 16 then
							BindSelection.Position = UDim2.new(0.67, 0, 0.181818187, 0)
							Bind.Size = UDim2.new(0, 123, 0, 28)
							BindSelection.Size = UDim2.new(0, 123, 0, 28)
						end
					end
				)

				local keybnid = {}

				function keybnid:SetKey(key)
					Bind.Text = tostring(key)
					oldKey = tostring(key)
				end

				TweenService:Create(
					Page,
					TweenInfo.new(.2, Enum.EasingStyle.Quad),
					{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
				):Play()

				HawkLib.Elements.Keybind[ConfigKeybindTitle] = keybnid

				return keybnid
			end

			function ContainerItems:Toggle(TexT, desc, check, callback)
				check = check or nil
				callback = callback or function()
				end

				local ConfigToggleSettings = {}
				table.insert(HawkConfigSettings.Toggle, ConfigToggleSettings)
				local ConfigToggleTitle = TexT:gsub("[^%w]", "") .. "ToggleSettings"

				ConfigToggleSettings[ConfigToggleTitle] = {}
				ConfigToggleSettings[ConfigToggleTitle]["Status"] = false

				local toggled = false
				local Toggle = Instance.new("Frame")
				local UICorner_10 = Instance.new("UICorner")
				local ToggleText = Instance.new("TextLabel")
				local ToggleFrame = Instance.new("Frame")
				local UICorner_11 = Instance.new("UICorner")
				local SlidingToggle = Instance.new("Frame")
				local UICorner_12 = Instance.new("UICorner")
				local UIGradient_3 = Instance.new("UIGradient")
				local ToggleClick = Instance.new("TextButton")
				local TextboxText_2 = Instance.new("TextLabel")

				Toggle.Name = "Toggle"
				Toggle.Parent = Container
				Toggle.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
				Toggle.BorderColor3 = Color3.fromRGB(43, 43, 41)
				Toggle.BorderSizePixel = 0
				Toggle.Position = UDim2.new(0.0196560193, 0, 0.748526514, 0)
				Toggle.Size = UDim2.new(0, 391, 0, 51)

				UICorner_10.CornerRadius = UDim.new(0, 6)
				UICorner_10.Parent = Toggle

				ToggleText.Name = "ToggleText"
				ToggleText.Parent = Toggle
				ToggleText.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
				ToggleText.BackgroundTransparency = 1.000
				ToggleText.BorderColor3 = Color3.fromRGB(43, 43, 41)
				ToggleText.BorderSizePixel = 0
				ToggleText.Position = UDim2.new(0.0199999996, 0, 0.0820000023, 0)
				ToggleText.Size = UDim2.new(0, 374, 0, 22)
				ToggleText.Font = Enum.Font.GothamBold
				ToggleText.Text = TexT
				ToggleText.TextColor3 = HawkLib.Themes[Theme].ItemTitleColors
				ToggleText.TextSize = 15.000
				ToggleText.TextXAlignment = Enum.TextXAlignment.Left

				ToggleFrame.Name = "ToggleFrame"
				ToggleFrame.Parent = Toggle
				ToggleFrame.BackgroundColor3 = HawkLib.Themes[Theme].ToggleFrameColor
				ToggleFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ToggleFrame.BorderSizePixel = 0
				ToggleFrame.Position = UDim2.new(0.856777489, 0, 0.275297672, 0)
				ToggleFrame.Size = UDim2.new(0, 46, 0, 21)

				UICorner_11.CornerRadius = UDim.new(99, 99)
				UICorner_11.Parent = ToggleFrame

				SlidingToggle.Name = "SlidingToggle"
				SlidingToggle.Parent = ToggleFrame
				SlidingToggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SlidingToggle.BorderColor3 = Color3.fromRGB(255, 255, 255)
				SlidingToggle.BorderSizePixel = 0
				SlidingToggle.Size = UDim2.new(0, 20, 0, 21)

				UICorner_12.CornerRadius = UDim.new(99, 99)
				UICorner_12.Parent = SlidingToggle

				UIGradient_3.Color =
					ColorSequence.new {
						ColorSequenceKeypoint.new(0.00, HawkLib.Themes[Theme].SlidingTogglePrimer),
						ColorSequenceKeypoint.new(1.00, HawkLib.Themes[Theme].SlidingToggleSeconder)
					}
				UIGradient_3.Rotation = 90
				UIGradient_3.Parent = SlidingToggle

				ToggleClick.Name = "ToggleClick"
				ToggleClick.Parent = Toggle
				ToggleClick.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				ToggleClick.BackgroundTransparency = 1.000
				ToggleClick.BorderColor3 = Color3.fromRGB(35, 35, 35)
				ToggleClick.BorderSizePixel = 0
				ToggleClick.Size = UDim2.new(0, 391, 0, 44)
				ToggleClick.Font = Enum.Font.SourceSans
				ToggleClick.Text = ""
				ToggleClick.TextColor3 = Color3.fromRGB(0, 0, 0)
				ToggleClick.TextSize = 1.000
				ToggleClick.TextTransparency = 1.000

				TextboxText_2.Name = "TextboxText"
				TextboxText_2.Parent = Toggle
				TextboxText_2.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
				TextboxText_2.BackgroundTransparency = 1.000
				TextboxText_2.BorderColor3 = Color3.fromRGB(43, 43, 41)
				TextboxText_2.BorderSizePixel = 0
				TextboxText_2.Position = UDim2.new(0.0199999996, 0, 0.504000008, 0)
				TextboxText_2.Size = UDim2.new(0, 374, 0, 16)
				TextboxText_2.Font = Enum.Font.Gotham
				TextboxText_2.Text = desc
				TextboxText_2.TextColor3 = HawkLib.Themes[Theme].ItemTextColors
				TextboxText_2.TextSize = 15.000
				TextboxText_2.TextXAlignment = Enum.TextXAlignment.Left

				-- Estrela de favorito para Toggle
				local FavoriteStar = Instance.new("ImageButton")
				FavoriteStar.Name = "FavoriteStar"
				FavoriteStar.Parent = Toggle
				FavoriteStar.BackgroundTransparency = 1
				FavoriteStar.BorderSizePixel = 0
				FavoriteStar.Position = UDim2.new(0.75, 0, 0.1, 0)
				FavoriteStar.Size = UDim2.new(0, 25, 0, 25)
				FavoriteStar.Image = "rbxassetid://2708898245" -- Estrela padrão
				FavoriteStar.ImageColor3 = Color3.fromRGB(139, 139, 139) -- Cinza escuro
				
				-- Verificar se o item já está nos favoritos
				if Favorites[TexT] then
					FavoriteStar.ImageColor3 = Color3.fromRGB(255, 215, 0) -- Dourado
				end
				
				-- Evento de clique na estrela de favorito
				FavoriteStar.MouseButton1Click:Connect(function()
					toggleFavorite(TexT, {TabButton = TabButton})
					-- Alternar cor da estrela
					if Favorites[TexT] then
						FavoriteStar.ImageColor3 = Color3.fromRGB(255, 215, 0) -- Dourado
					else
						FavoriteStar.ImageColor3 = Color3.fromRGB(139, 139, 139) -- Cinza
					end
				end)

				Toggle.MouseEnter:Connect(
					function()
						TweenService:Create(
							Toggle,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{BackgroundColor3 = HawkLib.Themes[Theme].Hover}
						):Play()
					end
				)

				Toggle.MouseLeave:Connect(
					function()
						TweenService:Create(
							Toggle,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{BackgroundColor3 = HawkLib.Themes[Theme].ItemColors}
						):Play()
					end
				)

				if desc == "" then
					ToggleText.Position = UDim2.new(0.0199999996, 0, 0.300000012, 0)
				else
					ToggleText.Position = UDim2.new(0.0199999996, 0, 0.0820000023, 0)
				end

				ToggleClick.MouseButton1Click:Connect(
					function()
						if toggled == false then
							UIGradient_3.Color =
								ColorSequence.new {
									ColorSequenceKeypoint.new(0.00, HawkLib.Themes[Theme].SlidingToggleToggledPrimer),
									ColorSequenceKeypoint.new(1.00, HawkLib.Themes[Theme].SlidingToggleToggledSeconder)
								}
							TweenService:Create(
								SlidingToggle,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{Position = UDim2.new(0.543, 0, 0, 0)}
							):Play()
							TweenService:Create(
								ToggleFrame,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{BackgroundColor3 = HawkLib.Themes[Theme].ToggledFrameColor}
							):Play()
							toggled = true
						else
							UIGradient_3.Color =
								ColorSequence.new {
									ColorSequenceKeypoint.new(0.00, HawkLib.Themes[Theme].SlidingTogglePrimer),
									ColorSequenceKeypoint.new(1.00, HawkLib.Themes[Theme].SlidingToggleSeconder)
								}
							TweenService:Create(
								SlidingToggle,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{Position = UDim2.new(0, 0, 0, 0)}
							):Play()
							TweenService:Create(
								ToggleFrame,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{BackgroundColor3 = HawkLib.Themes[Theme].ToggleFrameColor}
							):Play()
							toggled = false
						end
						ConfigToggleSettings[ConfigToggleTitle]["Status"] = toggled
						pcall(callback, toggled)
					end
				)

				TweenService:Create(
					Page,
					TweenInfo.new(.2, Enum.EasingStyle.Quad),
					{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
				):Play()

				local Toggleee = {}

				function Toggleee:UpdateToggle(boolean)
					local zz = boolean

					if zz ~= nil then
						toggled = zz
						if toggled == false then
							UIGradient_3.Color =
								ColorSequence.new {
									ColorSequenceKeypoint.new(0.00, HawkLib.Themes[Theme].SlidingTogglePrimer),
									ColorSequenceKeypoint.new(1.00, HawkLib.Themes[Theme].SlidingToggleSeconder)
								}
							TweenService:Create(
								SlidingToggle,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{Position = UDim2.new(0, 0, 0, 0)}
							):Play()
							TweenService:Create(
								ToggleFrame,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{BackgroundColor3 = HawkLib.Themes[Theme].ToggleFrameColor}
							):Play()
						elseif toggled == true then
							UIGradient_3.Color =
								ColorSequence.new {
									ColorSequenceKeypoint.new(0.00, HawkLib.Themes[Theme].SlidingToggleToggledPrimer),
									ColorSequenceKeypoint.new(1.00, HawkLib.Themes[Theme].SlidingToggleToggledSeconder)
								}
							TweenService:Create(
								SlidingToggle,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{Position = UDim2.new(0.543, 0, 0, 0)}
							):Play()
							TweenService:Create(
								ToggleFrame,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{BackgroundColor3 = HawkLib.Themes[Theme].ToggledFrameColor}
							):Play()
						end
						pcall(callback, zz)
						ConfigToggleSettings[ConfigToggleTitle]["Status"] = boolean
					end
				end

				if check == true then
					Toggleee:UpdateToggle(true)
				elseif check == false then
					Toggleee:UpdateToggle(false)
				end

				HawkLib.Elements.Toggle[ConfigToggleTitle] = Toggleee

				return Toggleee
			end

			function ContainerItems:CheckBox(TexT, check, callback)
				check = check or nil
				callback = callback or function()
				end

				local ConfigCheckboxSettings = {}
				table.insert(HawkConfigSettings.CheckBox, ConfigCheckboxSettings)

				local ConfigCheckboxTitle = TexT:gsub("[^%w]", "") .. "CheckboxSettings"

				ConfigCheckboxSettings[ConfigCheckboxTitle] = {}
				ConfigCheckboxSettings[ConfigCheckboxTitle]["Status"] = tostring(check)

				local toggled = false
				local ToggleFrame = Instance.new("Frame")
				local Toggle = Instance.new("TextButton")
				local UICorner_25 = Instance.new("UICorner")
				local ToggleText = Instance.new("TextLabel")
				local UICorner_26 = Instance.new("UICorner")
				local ToggleIconer = Instance.new("Frame")
				local UICorner_27 = Instance.new("UICorner")
				local done = Instance.new("ImageLabel")
				local UICorner_28 = Instance.new("UICorner")
				local UICorner_29 = Instance.new("UICorner")
				local UIStroke = Instance.new("UIStroke")

				ToggleFrame.Name = "ToggleFrame"
				ToggleFrame.Parent = Container
				ToggleFrame.Active = true
				ToggleFrame.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
				ToggleFrame.BorderColor3 = HawkLib.Themes[Theme].ItemColors
				ToggleFrame.Position = UDim2.new(0.0196850393, 0, 0.637992859, 0)
				ToggleFrame.Size = UDim2.new(0, 391, 0, 44)

				Toggle.Name = "Toggle"
				Toggle.Parent = ToggleFrame
				Toggle.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
				Toggle.BackgroundTransparency = 1.000
				Toggle.BorderColor3 = HawkLib.Themes[Theme].ItemColors
				Toggle.Size = UDim2.new(0, 391, 0, 44)
				Toggle.Font = Enum.Font.GothamBold
				Toggle.Text = ""
				Toggle.TextColor3 = Color3.fromRGB(154, 154, 154)
				Toggle.TextSize = 14.000
				Toggle.AutoButtonColor = false

				UICorner_25.CornerRadius = UDim.new(0, 5)
				UICorner_25.Parent = Toggle

				ToggleText.Name = "ToggleText"
				ToggleText.Parent = Toggle
				ToggleText.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
				ToggleText.BackgroundTransparency = 1.000
				ToggleText.BorderColor3 = HawkLib.Themes[Theme].ItemColors
				ToggleText.Position = UDim2.new(0.031, 0, 0.275, 0)
				ToggleText.Size = UDim2.new(0, 121, 0, 22)
				ToggleText.Font = Enum.Font.GothamBold
				ToggleText.Text = TexT
				ToggleText.TextColor3 = HawkLib.Themes[Theme].ItemTitleColors
				ToggleText.TextSize = 14.000
				ToggleText.TextXAlignment = Enum.TextXAlignment.Left

				UICorner_26.CornerRadius = UDim.new(0, 5)
				UICorner_26.Parent = ToggleText

				ToggleIconer.Name = "ToggleIconer"
				ToggleIconer.Parent = Toggle
				ToggleIconer.BackgroundColor3 = HawkLib.Themes[Theme].ItemTextBoxKeyBindColors
				ToggleIconer.BorderColor3 = HawkLib.Themes[Theme].ItemTextBoxKeyBindColors
				ToggleIconer.BorderSizePixel = 0
				ToggleIconer.Position = UDim2.new(0.915300488, 0, 0.275297672, 0)
				ToggleIconer.Size = UDim2.new(0, 22, 0, 22)

				UICorner_27.CornerRadius = UDim.new(0, 4)
				UICorner_27.Parent = ToggleIconer

				UIStroke.Parent = ToggleIconer
				UIStroke.Color = HawkLib.Themes[Theme].ItemTextBoxKeyBindStrokeColors
				UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

				done.Name = "done"
				done.Parent = ToggleIconer
				done.BackgroundColor3 = HawkLib.Themes[Theme].ItemTextBoxKeyBindColors
				done.BorderColor3 = HawkLib.Themes[Theme].ItemTextBoxKeyBindColors
				done.BackgroundTransparency = 1
				done.Position = UDim2.new(0.0909090936, 0, 0.0909090936, 0)
				done.Size = UDim2.new(0, 18, 0, 18)
				done.ZIndex = 2
				done.Image = "rbxassetid://3926305904"
				done.ImageRectOffset = Vector2.new(644, 204)
				done.ImageRectSize = Vector2.new(36, 36)
				done.ImageColor3 = HawkLib.Themes[Theme].ToggleTickColor
				done.ImageTransparency = 1

				UICorner_28.CornerRadius = UDim.new(0, 4)
				UICorner_28.Parent = done

				UICorner_29.CornerRadius = UDim.new(0, 5)
				UICorner_29.Parent = ToggleFrame

				-- Estrela de favorito para CheckBox
				local FavoriteStar = Instance.new("ImageButton")
				FavoriteStar.Name = "FavoriteStar"
				FavoriteStar.Parent = ToggleFrame
				FavoriteStar.BackgroundTransparency = 1
				FavoriteStar.BorderSizePixel = 0
				FavoriteStar.Position = UDim2.new(0.85, 0, 0.15, 0)
				FavoriteStar.Size = UDim2.new(0, 25, 0, 25)
				FavoriteStar.Image = "rbxassetid://2708898245" -- Estrela padrão
				FavoriteStar.ImageColor3 = Color3.fromRGB(139, 139, 139) -- Cinza escuro
				
				-- Verificar se o item já está nos favoritos
				if Favorites[TexT] then
					FavoriteStar.ImageColor3 = Color3.fromRGB(255, 215, 0) -- Dourado
				end
				
				-- Evento de clique na estrela de favorito
				FavoriteStar.MouseButton1Click:Connect(function()
					toggleFavorite(TexT, {TabButton = TabButton})
					-- Alternar cor da estrela
					if Favorites[TexT] then
						FavoriteStar.ImageColor3 = Color3.fromRGB(255, 215, 0) -- Dourado
					else
						FavoriteStar.ImageColor3 = Color3.fromRGB(139, 139, 139) -- Cinza
					end
				end)

				ToggleFrame.MouseEnter:Connect(
					function()
						TweenService:Create(
							ToggleFrame,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{BackgroundColor3 = HawkLib.Themes[Theme].Hover}
						):Play()
					end
				)

				ToggleFrame.MouseLeave:Connect(
					function()
						TweenService:Create(
							ToggleFrame,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{BackgroundColor3 = HawkLib.Themes[Theme].ItemColors}
						):Play()
					end
				)

				Toggle.MouseButton1Click:Connect(
					function()
						if not focusing then
							if toggled == false then
								TweenService:Create(
									done,
									TweenInfo.new(0.11, Enum.EasingStyle.Linear, Enum.EasingDirection.In),
									{
										ImageTransparency = 0
									}
								):Play()
							else
								TweenService:Create(
									done,
									TweenInfo.new(0.11, Enum.EasingStyle.Linear, Enum.EasingDirection.In),
									{
										ImageTransparency = 1
									}
								):Play()
							end
							toggled = not toggled
							wait(0.3)
							pcall(callback, toggled)
							ConfigCheckboxSettings[ConfigCheckboxTitle]["Status"] = toggled
						end
					end
				)

				TweenService:Create(
					Page,
					TweenInfo.new(.2, Enum.EasingStyle.Quad),
					{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
				):Play()

				local Toggleee = {}

				function Toggleee:UpdateCheckBox(boolean)
					local zz = boolean

					if zz ~= nil then
						toggled = zz
						if toggled == false then
							TweenService:Create(
								done,
								TweenInfo.new(0.11, Enum.EasingStyle.Linear, Enum.EasingDirection.In),
								{
									ImageTransparency = 1
								}
							):Play()
						else
							TweenService:Create(
								done,
								TweenInfo.new(0.11, Enum.EasingStyle.Linear, Enum.EasingDirection.In),
								{
									ImageTransparency = 0
								}
							):Play()
						end
						pcall(callback, zz)
						ConfigCheckboxSettings[ConfigCheckboxTitle]["Status"] = zz
					end
				end

				if check == true then
					Toggleee:UpdateCheckBox(true)
				elseif check == false then
					Toggleee:UpdateCheckBox(false)
				elseif check == nil or tostring(check):match("func") then
					TweenService:Create(
						done,
						TweenInfo.new(0.11, Enum.EasingStyle.Linear, Enum.EasingDirection.In),
						{
							ImageTransparency = 1
						}
					):Play()
				end

				HawkLib.Elements.CheckBox[ConfigCheckboxTitle] = Toggleee

				return Toggleee
			end

			function ContainerItems:TextBox(anan)
				local tile
				local desc
				local holdertext
				local call
				local disableee
				for i, v in pairs(anan) do
					if i == "Title" then
						tile = v
					elseif i == "Description" then
						desc = v
					elseif i == "PlaceHolderText" then
						holdertext = v
					elseif i == "Callback" then
						call = v
					elseif i == "DisableReset" then
						disableee = v
					end
				end

				local ConfigTextboxSettings = {}
				table.insert(HawkConfigSettings.TextBox, ConfigTextboxSettings)
				local ConfigTextboxTitle = tile:gsub("[^%w]", "") .. "TextboxSettings"

				ConfigTextboxSettings[ConfigTextboxTitle] = {}
				ConfigTextboxSettings[ConfigTextboxTitle]["DisableReset"] = disableee
				ConfigTextboxSettings[ConfigTextboxTitle]["Text"] = ""
				local TextBox = Instance.new("Frame")
				local UICorner_8 = Instance.new("UICorner")
				local TexttingBox = Instance.new("TextBox")
				local UICorner_9 = Instance.new("UICorner")
				local TextBoxTitle = Instance.new("TextLabel")
				local TextboxText = Instance.new("TextLabel")

				TextBox.Name = "TextBox"
				TextBox.Parent = Container
				TextBox.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
				TextBox.BorderColor3 = Color3.fromRGB(43, 43, 41)
				TextBox.BorderSizePixel = 0
				TextBox.Position = UDim2.new(0.0196560193, 0, 0.711198449, 0)
				TextBox.Size = UDim2.new(0, 391, 0, 51)

				UICorner_8.CornerRadius = UDim.new(0, 6)
				UICorner_8.Parent = TextBox

				TexttingBox.Name = "TexttingBox"
				TexttingBox.Parent = TextBox
				TexttingBox.BackgroundColor3 = HawkLib.Themes[Theme].ItemTextBoxKeyBindColors
				TexttingBox.BorderColor3 = Color3.fromRGB(27, 27, 27)
				TexttingBox.BorderSizePixel = 0
				TexttingBox.Position = UDim2.new(0.696, 0, 0.221, 0)
				TexttingBox.Size = UDim2.new(0, 108, 0, 27)
				TexttingBox.ClearTextOnFocus = false
				TexttingBox.Font = Enum.Font.Gotham
				TexttingBox.PlaceholderColor3 = Color3.fromRGB(132, 132, 132)
				TexttingBox.PlaceholderText = holdertext
				TexttingBox.Text = ""
				TexttingBox.TextColor3 = HawkLib.Themes[Theme].ItemTextBoxTextColor
				TexttingBox.TextSize = 14.000
				TexttingBox.ClipsDescendants = true
				if disableee == true then
					TexttingBox.ClearTextOnFocus = false
				else
					TexttingBox.ClearTextOnFocus = true
				end

				UICorner_9.CornerRadius = UDim.new(0, 6)
				UICorner_9.Parent = TexttingBox

				TextBoxTitle.Name = "TextBoxTitle"
				TextBoxTitle.Parent = TextBox
				TextBoxTitle.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
				TextBoxTitle.BackgroundTransparency = 1.000
				TextBoxTitle.BorderColor3 = Color3.fromRGB(43, 43, 41)
				TextBoxTitle.BorderSizePixel = 0
				TextBoxTitle.Position = UDim2.new(0.0199999996, 0, 0.0820000023, 0)
				TextBoxTitle.Size = UDim2.new(0, 374, 0, 22)
				TextBoxTitle.Font = Enum.Font.GothamBold
				TextBoxTitle.Text = tile
				TextBoxTitle.TextColor3 = HawkLib.Themes[Theme].ItemTitleColors
				TextBoxTitle.TextSize = 15.000
				TextBoxTitle.TextXAlignment = Enum.TextXAlignment.Left

				TextboxText.Name = "TextboxText"
				TextboxText.Parent = TextBox
				TextboxText.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
				TextboxText.BackgroundTransparency = 1.000
				TextboxText.BorderColor3 = Color3.fromRGB(43, 43, 41)
				TextboxText.BorderSizePixel = 0
				TextboxText.Position = UDim2.new(0.0199999996, 0, 0.504000008, 0)
				TextboxText.Size = UDim2.new(0, 374, 0, 16)
				TextboxText.Font = Enum.Font.Gotham
				TextboxText.Text = desc
				TextboxText.TextColor3 = HawkLib.Themes[Theme].ItemTextColors
				TextboxText.TextSize = 15.000
				TextboxText.TextXAlignment = Enum.TextXAlignment.Left

				if desc == "" then
					TextBoxTitle.Position = UDim2.new(0.0199999996, 0, 0.3, 0)
				else
					TextBoxTitle.Position = UDim2.new(0.0199999996, 0, 0.0820000023, 0)
				end

				-- Estrela de favorito para TextBox
				local FavoriteStar = Instance.new("ImageButton")
				FavoriteStar.Name = "FavoriteStar"
				FavoriteStar.Parent = TextBox
				FavoriteStar.BackgroundTransparency = 1
				FavoriteStar.BorderSizePixel = 0
				FavoriteStar.Position = UDim2.new(0.85, 0, 0.1, 0)
				FavoriteStar.Size = UDim2.new(0, 25, 0, 25)
				FavoriteStar.Image = "rbxassetid://2708898245" -- Estrela padrão
				FavoriteStar.ImageColor3 = Color3.fromRGB(139, 139, 139) -- Cinza escuro
				
				-- Verificar se o item já está nos favoritos
				if Favorites[tile] then
					FavoriteStar.ImageColor3 = Color3.fromRGB(255, 215, 0) -- Dourado
				end
				
				-- Evento de clique na estrela de favorito
				FavoriteStar.MouseButton1Click:Connect(function()
					toggleFavorite(tile, {TabButton = TabButton})
					-- Alternar cor da estrela
					if Favorites[tile] then
						FavoriteStar.ImageColor3 = Color3.fromRGB(255, 215, 0) -- Dourado
					else
						FavoriteStar.ImageColor3 = Color3.fromRGB(139, 139, 139) -- Cinza
					end
				end)

				TextBox.MouseEnter:Connect(
					function()
						TweenService:Create(
							TextBox,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{BackgroundColor3 = HawkLib.Themes[Theme].Hover}
						):Play()
					end
				)
				TextBox.MouseLeave:Connect(
					function()
						TweenService:Create(
							TextBox,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{BackgroundColor3 = HawkLib.Themes[Theme].ItemColors}
						):Play()
					end
				)

				TexttingBox.FocusLost:Connect(
					function(ep)
						if ep then
							if #TexttingBox.Text > 0 then
								pcall(call, TexttingBox.Text)
								if ConfigTextboxSettings[ConfigTextboxTitle]["DisableReset"] == true then
									ConfigTextboxSettings[ConfigTextboxTitle]["Text"] = TexttingBox.Text
								else
									ConfigTextboxSettings[ConfigTextboxTitle]["Text"] = "savedisabled"
								end
								if disableee == false then
									TexttingBox.Text = ""
								end
							end
						end
					end
				)

				TexttingBox:GetPropertyChangedSignal("PlaceholderText"):Connect(
					function()
						if #TexttingBox.PlaceholderText < 9 then
							TweenService:Create(
								TexttingBox,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{Size = UDim2.new(0, 81, 0, 27)}
							):Play()
							TweenService:Create(
								TexttingBox,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{Position = UDim2.new(0.772, 0, 0.221, 0)}
							):Play()
							TexttingBox.TextScaled = false
						elseif #TexttingBox.PlaceholderText > 9 and #TexttingBox.PlaceholderText < 16 then
							TweenService:Create(
								TexttingBox,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{Size = UDim2.new(0, 124, 0, 27)}
							):Play()
							TweenService:Create(
								TexttingBox,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{Position = UDim2.new(0.655, 0, 0.221, 0)}
							):Play()
							TexttingBox.TextScaled = false
						elseif #TexttingBox.PlaceholderText > 16 and #TexttingBox.PlaceholderText < 23 then
							TweenService:Create(
								TexttingBox,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{Size = UDim2.new(0, 175, 0, 27)}
							):Play()
							TweenService:Create(
								TexttingBox,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{Position = UDim2.new(0.524, 0, 0.221, 0)}
							):Play()
							TexttingBox.TextScaled = false
						elseif #TexttingBox.PlaceholderText > 23 then
							TexttingBox.TextScaled = true
						end
					end
				)

				TexttingBox:GetPropertyChangedSignal("Text"):Connect(
					function()
						if #TexttingBox.Text < 9 then
							TweenService:Create(
								TexttingBox,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{Size = UDim2.new(0, 81, 0, 27)}
							):Play()
							TweenService:Create(
								TexttingBox,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{Position = UDim2.new(0.772, 0, 0.221, 0)}
							):Play()
							TexttingBox.TextScaled = false
						elseif #TexttingBox.Text > 9 and #TexttingBox.Text < 16 then
							TweenService:Create(
								TexttingBox,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{Size = UDim2.new(0, 124, 0, 27)}
							):Play()
							TweenService:Create(
								TexttingBox,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{Position = UDim2.new(0.655, 0, 0.221, 0)}
							):Play()
							TexttingBox.TextScaled = false
						elseif #TexttingBox.Text > 16 and #TexttingBox.Text < 23 then
							TweenService:Create(
								TexttingBox,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{Size = UDim2.new(0, 175, 0, 27)}
							):Play()
							TweenService:Create(
								TexttingBox,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{Position = UDim2.new(0.524, 0, 0.221, 0)}
							):Play()
							TexttingBox.TextScaled = false
						elseif #TexttingBox.Text > 23 then
							TexttingBox.TextScaled = true
						end
					end
				)

				TweenService:Create(
					Page,
					TweenInfo.new(.2, Enum.EasingStyle.Quad),
					{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
				):Play()

				local checkboxxx = {}

				function checkboxxx:SetText(text)
					TexttingBox.Text = tostring(text)
					pcall(call, text)
				end

				HawkLib.Elements.TextBox[ConfigTextboxTitle] = checkboxxx

				return checkboxxx
			end

			function ContainerItems:Dropdown(dropz)
				local dropdowntoggle = false
				local callback = dropz.Callback or function()
				end
				local multiopt = dropz.MultiOption

				local ConfigDropdownSettings = {}
				table.insert(HawkConfigSettings.Dropdown, ConfigDropdownSettings)
				local ConfigDropdownTitle = dropz.Title:gsub("[^%w]", "") .. "DropdownSettings"

				ConfigDropdownSettings[ConfigDropdownTitle] = {}
				ConfigDropdownSettings[ConfigDropdownTitle]["MultiOption"] = dropz.MultiOption
				ConfigDropdownSettings[ConfigDropdownTitle]["Selected"] = {}

				local function GetPos(tablename, itemname)
					if type(tablename) == "table" then
						for i, v in next, tablename do
							if tostring(v) == tostring(itemname) then
								return i
							end
						end
					end
				end

				local ItemsContainer = {}
				local Dropdown = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local DropdownTitle = Instance.new("TextLabel")
				local DropdownDescription = Instance.new("TextLabel")
				local DropdownFrame = Instance.new("Frame")
				local DropItemHolder = Instance.new("ScrollingFrame")
				local UIListLayout = Instance.new("UIListLayout")
				local Search = Instance.new("TextBox")
				local ImageLabel = Instance.new("ImageLabel")
				local UICorner_6 = Instance.new("UICorner")
				local Plus = Instance.new("TextLabel")
				local DropToggler = Instance.new("TextButton")
				local UICorner = Instance.new("UICorner")
				local DropBar = Instance.new("Frame")
				local SelectedText = Instance.new("TextLabel")
				local SelectedItem = Instance.new("TextLabel")

				Dropdown.Name = "Dropdown"
				Dropdown.Parent = Container
				Dropdown.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
				Dropdown.BorderColor3 = Color3.fromRGB(35, 35, 35)
				Dropdown.BorderSizePixel = 0
				Dropdown.Position = UDim2.new(0.0196560193, 0, 1.32137716, 0)
				Dropdown.Size = UDim2.new(0, 391, 0, 52)

				Dropdown.MouseEnter:Connect(
					function()
						TweenService:Create(
							Dropdown,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{BackgroundColor3 = HawkLib.Themes[Theme].Hover}
						):Play()
					end
				)
				Dropdown.MouseLeave:Connect(
					function()
						TweenService:Create(
							Dropdown,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{BackgroundColor3 = HawkLib.Themes[Theme].ItemColors}
						):Play()
					end
				)

				UICorner.CornerRadius = UDim.new(0, 6)
				UICorner.Parent = Dropdown

				DropBar.Name = "DropBar"
				DropBar.Parent = Dropdown
				DropBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropBar.BackgroundTransparency = 1.000
				DropBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropBar.Position = UDim2.new(0, 0, 0, 0)
				DropBar.BorderSizePixel = 0
				DropBar.Size = UDim2.new(0, 386, 0, 50)

				DropdownTitle.Name = "DropdownTitle"
				DropdownTitle.Parent = DropBar
				DropdownTitle.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
				DropdownTitle.BackgroundTransparency = 1.000
				DropdownTitle.BorderColor3 = Color3.fromRGB(43, 43, 41)
				DropdownTitle.BorderSizePixel = 0
				DropdownTitle.Position = UDim2.new(0.023, 0, 0.086, 0)
				DropdownTitle.Size = UDim2.new(0, 374, 0, 22)
				DropdownTitle.Font = Enum.Font.GothamBold
				DropdownTitle.Text = dropz.Title
				DropdownTitle.TextColor3 = HawkLib.Themes[Theme].ItemTitleColors
				DropdownTitle.TextSize = 15.000
				DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left

				DropdownDescription.Name = "DropdownDescription"
				DropdownDescription.Parent = DropBar
				DropdownDescription.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
				DropdownDescription.BackgroundTransparency = 1.000
				DropdownDescription.BorderColor3 = Color3.fromRGB(43, 43, 41)
				DropdownDescription.BorderSizePixel = 0
				DropdownDescription.Position = UDim2.new(0.023, 0, 0.467, 0)
				DropdownDescription.Size = UDim2.new(0, 374, 0, 16)
				DropdownDescription.Font = Enum.Font.Gotham
				DropdownDescription.Text = dropz.Description
				DropdownDescription.TextColor3 = HawkLib.Themes[Theme].ItemTextColors
				DropdownDescription.TextSize = 15.000
				DropdownDescription.TextXAlignment = Enum.TextXAlignment.Left

				DropdownFrame.Name = "DropdownFrame"
				DropdownFrame.Parent = Dropdown
				DropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				DropdownFrame.BorderColor3 = Color3.fromRGB(35, 35, 35)
				DropdownFrame.BorderSizePixel = 0
				DropdownFrame.Position = UDim2.new(0, 0, 0.240641713, 0)
				DropdownFrame.Size = UDim2.new(0, 391, 0, 137)
				DropdownFrame.BackgroundTransparency = 1
				DropdownFrame.Visible = false

				DropItemHolder.Name = "DropItemHolder"
				DropItemHolder.Parent = DropdownFrame
				DropItemHolder.Active = true
				DropItemHolder.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
				DropItemHolder.BackgroundTransparency = 1.000
				DropItemHolder.BorderColor3 = Color3.fromRGB(32, 32, 32)
				DropItemHolder.BorderSizePixel = 0
				DropItemHolder.Position = UDim2.new(0.018, 0, 0.345, 0)
				DropItemHolder.Size = UDim2.new(0, 382, 0, 81)
				DropItemHolder.ScrollBarThickness = 5
				DropItemHolder.ScrollBarImageTransparency = 1

				UIListLayout.Parent = DropItemHolder
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout.Padding = UDim.new(0, 6)

				Search.Name = "Search"
				Search.Parent = DropdownFrame
				Search.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				Search.BackgroundTransparency = 1.000
				Search.BorderColor3 = Color3.fromRGB(35, 35, 35)
				Search.BorderSizePixel = 0
				Search.Position = UDim2.new(0.0741688013, 0, 0.0291970801, 0)
				Search.Size = UDim2.new(0, 348, 0, 23)
				Search.Font = Enum.Font.SourceSans
				Search.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
				Search.PlaceholderText = "Search Item"
				Search.Text = ""
				Search.TextColor3 = Color3.fromRGB(178, 178, 178)
				Search.TextSize = 18.000
				Search.TextXAlignment = Enum.TextXAlignment.Left
				Search.ClearTextOnFocus = false
				Search.TextTransparency = 1

				ImageLabel.Parent = Search
				ImageLabel.BackgroundTransparency = 1.000
				ImageLabel.BorderSizePixel = 0
				ImageLabel.Position = UDim2.new(-0.063000001, 0, 0.0599999987, 0)
				ImageLabel.Size = UDim2.new(0, 20, 0, 22)
				ImageLabel.Image = "http://www.roblox.com/asset/?id=6031154871"
				ImageLabel.ImageColor3 = Color3.fromRGB(178, 178, 178)
				ImageLabel.ImageTransparency = 1

				SelectedItem.Name = "SelectedText"
				SelectedItem.Parent = DropdownFrame
				SelectedItem.Active = true
				SelectedItem.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				SelectedItem.BorderColor3 = Color3.fromRGB(35, 35, 35)
				SelectedItem.BorderSizePixel = 0
				SelectedItem.Position = UDim2.new(0.181125343, 0, 0.167883217, 0)
				SelectedItem.Size = UDim2.new(0, 184, 0, 18)
				SelectedItem.Font = Enum.Font.Gotham
				SelectedItem.Text = "~"
				SelectedItem.TextColor3 = Color3.fromRGB(255, 255, 255)
				SelectedItem.TextSize = 14.000
				SelectedItem.TextStrokeColor3 = Color3.fromRGB(178, 178, 178)
				SelectedItem.TextXAlignment = Enum.TextXAlignment.Left
				SelectedItem.BackgroundTransparency = 1

				SelectedText.Name = "SelectedItem"
				SelectedText.Parent = DropdownFrame
				SelectedText.Active = true
				SelectedText.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				SelectedText.BorderColor3 = Color3.fromRGB(35, 35, 35)
				SelectedText.BorderSizePixel = 0
				SelectedText.Position = UDim2.new(0.029838074, 0, 0.167883217, 0)
				SelectedText.Size = UDim2.new(0, 60, 0, 18)
				SelectedText.Font = Enum.Font.SourceSans
				SelectedText.Text = "Selected: "
				SelectedText.TextColor3 = Color3.fromRGB(178, 178, 178)
				SelectedText.TextSize = 18.000
				SelectedText.TextStrokeColor3 = Color3.fromRGB(178, 178, 178)
				SelectedText.TextXAlignment = Enum.TextXAlignment.Left
				SelectedText.BackgroundTransparency = 1

				Search.Focused:Connect(
					function()
						TweenService:Create(ImageLabel, TweenInfo.new(.2, Enum.EasingStyle.Linear), {Rotation = 360}):Play(

						)
					end
				)

				Search.FocusLost:Connect(
					function()
						TweenService:Create(ImageLabel, TweenInfo.new(.2, Enum.EasingStyle.Linear), {Rotation = 0}):Play(

						)
					end
				)

				Search:GetPropertyChangedSignal("Text"):Connect(
					function()
						for i, v in pairs(DropItemHolder:GetDescendants()) do
							if v:IsA("TextButton") then
								if string.match(string.lower(v.Text), string.lower(Search.Text)) then
									v.Parent.Visible = true
								else
									v.Parent.Visible = false
								end
							end
						end
						if Search.Text == "" then
							for i, v in pairs(DropItemHolder:GetDescendants()) do
								if v:IsA("TextButton") then
									v.Parent.Visible = true
								end
							end
						end
					end
				)

				UICorner_6.CornerRadius = UDim.new(0, 6)
				UICorner_6.Parent = DropdownFrame

				Plus.Parent = DropBar
				Plus.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Plus.BackgroundTransparency = 1.000
				Plus.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Plus.BorderSizePixel = 0
				Plus.Position = UDim2.new(0.905115128, 0, 0.27, 0)
				Plus.Size = UDim2.new(0, 26, 0, 24)
				Plus.Font = Enum.Font.Unknown
				Plus.Text = "+"
				Plus.TextColor3 = HawkLib.Themes[Theme].ItemTitleColors
				Plus.TextSize = 22.000

				DropToggler.Name = "DropToggler"
				DropToggler.Parent = Dropdown
				DropToggler.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropToggler.BackgroundTransparency = 1.000
				DropToggler.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropToggler.BorderSizePixel = 0
				DropToggler.Size = UDim2.new(0, 391, 0, 52)
				DropToggler.Font = Enum.Font.SourceSans
				DropToggler.Text = ""
				DropToggler.TextColor3 = Color3.fromRGB(0, 0, 0)
				DropToggler.TextSize = 14.000
				DropToggler.TextTransparency = 1.000

				UICorner.CornerRadius = UDim.new(0, 6)
				UICorner.Parent = DropToggler

				-- Estrela de favorito para Dropdown
				local FavoriteStar = Instance.new("ImageButton")
				FavoriteStar.Name = "FavoriteStar"
				FavoriteStar.Parent = Dropdown
				FavoriteStar.BackgroundTransparency = 1
				FavoriteStar.BorderSizePixel = 0
				FavoriteStar.Position = UDim2.new(0.85, 0, 0.1, 0)
				FavoriteStar.Size = UDim2.new(0, 25, 0, 25)
				FavoriteStar.Image = "rbxassetid://2708898245" -- Estrela padrão
				FavoriteStar.ImageColor3 = Color3.fromRGB(139, 139, 139) -- Cinza escuro
				
				-- Verificar se o item já está nos favoritos
				if Favorites[dropz.Title] then
					FavoriteStar.ImageColor3 = Color3.fromRGB(255, 215, 0) -- Dourado
				end
				
				-- Evento de clique na estrela de favorito
				FavoriteStar.MouseButton1Click:Connect(function()
					toggleFavorite(dropz.Title, {TabButton = TabButton})
					-- Alternar cor da estrela
					if Favorites[dropz.Title] then
						FavoriteStar.ImageColor3 = Color3.fromRGB(255, 215, 0) -- Dourado
					else
						FavoriteStar.ImageColor3 = Color3.fromRGB(139, 139, 139) -- Cinza
					end
				end)

				TweenService:Create(
					Page,
					TweenInfo.new(.2, Enum.EasingStyle.Quad),
					{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
				):Play()

				DropToggler.MouseButton1Click:Connect(
					function()
						TweenService:Create(
							Page,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
						):Play()

						if dropdowntoggle == false then
							dropdowntoggle = true
							DropdownFrame.Visible = true
							for i, v in pairs(DropdownFrame:GetDescendants()) do
								if v:IsA("TextButton") and v.Name ~= "ItemButton" then
									TweenService:Create(
										v,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{BackgroundTransparency = 0}
									):Play()
									TweenService:Create(
										v,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{TextTransparency = 0}
									):Play()
								elseif v:IsA("TextButton") and v.Name == "ItemButton" then
									TweenService:Create(
										v,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{TextTransparency = 0}
									):Play()
								elseif v:IsA("TextLabel") then
									TweenService:Create(
										v,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{TextTransparency = 0}
									):Play()
								elseif v:IsA("TextBox") then
									TweenService:Create(
										v,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{TextTransparency = 0}
									):Play()
								elseif v:IsA("ImageLabel") then
									TweenService:Create(
										v,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{ImageTransparency = 0}
									):Play()
								elseif v:IsA("ScrollingFrame") then
									TweenService:Create(
										v,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{ScrollBarImageTransparency = 0}
									):Play()
								elseif v:IsA("UIGradient") then
									v.Transparency = NumberSequence.new(0)
								end
							end
							TweenService:Create(
								Plus,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{Rotation = 225}
							):Play()
							TweenService:Create(
								Dropdown,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{Size = UDim2.new(0, 391, 0, 179)}
							):Play()
							repeat
								wait()
								TweenService:Create(
									Page,
									TweenInfo.new(.2, Enum.EasingStyle.Quad),
									{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
								):Play()
							until Dropdown.Size == UDim2.new(0, 391, 0, 52)
						elseif dropdowntoggle == true then
							dropdowntoggle = false
							for i, v in pairs(DropdownFrame:GetDescendants()) do
								if v:IsA("TextButton") then
									TweenService:Create(
										v,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{BackgroundTransparency = 1}
									):Play()
									TweenService:Create(
										v,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{TextTransparency = 1}
									):Play()
								elseif v:IsA("TextLabel") then
									TweenService:Create(
										v,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{TextTransparency = 1}
									):Play()
								elseif v:IsA("TextBox") then
									TweenService:Create(
										v,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{TextTransparency = 1}
									):Play()
								elseif v:IsA("ImageLabel") then
									TweenService:Create(
										v,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{ImageTransparency = 1}
									):Play()
								elseif v:IsA("ScrollingFrame") then
									TweenService:Create(
										v,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{ScrollBarImageTransparency = 1}
									):Play()
								elseif v:IsA("UIGradient") then
									v.Transparency = NumberSequence.new(1)
								end
							end
							TweenService:Create(
								Plus,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{Rotation = 0}
							):Play()
							DropdownFrame.Visible = false
							TweenService:Create(
								Dropdown,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{Size = UDim2.new(0, 391, 0, 52)}
							):Play()
							repeat
								wait()
								TweenService:Create(
									Page,
									TweenInfo.new(.2, Enum.EasingStyle.Quad),
									{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
								):Play()
							until Dropdown.Size == UDim2.new(0, 391, 0, 52)
						end
					end
				)

				local droptable
				for i, v in pairs(dropz.List) do
					if type(dropz.List) == "table" then
						droptable = dropz.List
					end
					local itemtoggled = false
					local ItemFrame = Instance.new("Frame")
					local UICorner_2 = Instance.new("UICorner")
					local ItemButton = Instance.new("TextButton")
					local UICorner_3 = Instance.new("UICorner")
					local UIGradient = Instance.new("UIGradient")

					ItemFrame.Name = "ItemFrame"
					ItemFrame.Parent = DropItemHolder
					ItemFrame.BackgroundColor3 = HawkLib.Themes[Theme].DropdownItem
					ItemFrame.BorderColor3 = Color3.fromRGB(49, 49, 49)
					ItemFrame.BorderSizePixel = 0
					ItemFrame.Size = UDim2.new(0, 369, 0, 27)

					UICorner_2.CornerRadius = UDim.new(0, 5)
					UICorner_2.Parent = ItemFrame

					ItemButton.Name = "ItemButton"
					ItemButton.Parent = ItemFrame
					ItemButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
					ItemButton.BackgroundTransparency = 1.000
					ItemButton.BorderColor3 = Color3.fromRGB(60, 60, 60)
					ItemButton.BorderSizePixel = 0
					ItemButton.Size = UDim2.new(0, 369, 0, 27)
					ItemButton.Font = Enum.Font.Gotham
					ItemButton.Text = v
					ItemButton.TextColor3 = Color3.fromRGB(220, 220, 219)
					ItemButton.TextSize = 14.000
					ItemButton.BackgroundTransparency = 1

					UICorner_3.Parent = ItemButton

					UIGradient.Color =
						ColorSequence.new {
							ColorSequenceKeypoint.new(0.00, HawkLib.Themes[Theme].DropdownItemFirst),
							ColorSequenceKeypoint.new(1.00, HawkLib.Themes[Theme].DropdownItemSecond)
						}
					UIGradient.Rotation = 90
					UIGradient.Parent = ItemFrame

					TweenService:Create(
						Page,
						TweenInfo.new(.2, Enum.EasingStyle.Quad),
						{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
					):Play()
					TweenService:Create(
						DropItemHolder,
						TweenInfo.new(.2, Enum.EasingStyle.Quad),
						{CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)}
					):Play()

					local function Update(bool)
						itemtoggled = bool
						if bool == false then
							TweenService:Create(
								ItemFrame,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{BackgroundColor3 =  HawkLib.Themes[Theme].DropdownItem}
							):Play()
							if SelectedItem.Text:match("," .. v) then
								SelectedItem.Text = SelectedItem.Text:gsub("," .. v, "")
							elseif SelectedItem.Text:match(v .. ",") then
								SelectedItem.Text = SelectedItem.Text:gsub(v .. ",", "")
							end
							SelectedItem.Text = SelectedItem.Text:gsub(v, "")
							if SelectedItem.Text == "" then
								SelectedItem.Text = "~"
							end

							table.remove(
								ConfigDropdownSettings[ConfigDropdownTitle]["Selected"],
								GetPos(ConfigDropdownSettings[ConfigDropdownTitle]["Selected"], v)
							)
						elseif bool == true then
							TweenService:Create(
								ItemFrame,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{BackgroundColor3 =  HawkLib.Themes[Theme].DropdownItemHover}
							):Play()
							if not SelectedItem.Text:find(v) then
								if SelectedItem.Text == "~" then
									SelectedItem.Text = v
								else
									SelectedItem.Text = SelectedItem.Text .. "," .. v
								end
							end
							if not table.find(ConfigDropdownSettings[ConfigDropdownTitle]["Selected"], v) then
								table.insert(ConfigDropdownSettings[ConfigDropdownTitle]["Selected"], v)
							end
						end
						if LoadHawkConfig ~= "enabled" then
							pcall(callback, v, bool)
						end
					end

					if multiopt == true then
						ItemButton.MouseButton1Click:Connect(
							function()
								if itemtoggled == false then
									itemtoggled = true
									TweenService:Create(
										ItemFrame,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{BackgroundColor3 =  HawkLib.Themes[Theme].DropdownItemHover}
									):Play()
									if SelectedItem.Text == "~" then
										SelectedItem.Text = v
									else
										SelectedItem.Text =
											SelectedItem.Text:gsub(SelectedItem.Text, SelectedItem.Text .. "," .. v)
									end
									table.insert(ConfigDropdownSettings[ConfigDropdownTitle]["Selected"], v)
								elseif itemtoggled == true then
									itemtoggled = false
									TweenService:Create(
										ItemFrame,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{BackgroundColor3 =  HawkLib.Themes[Theme].DropdownItem}
									):Play()
									if SelectedItem.Text:match("," .. v) then
										SelectedItem.Text = SelectedItem.Text:gsub("," .. v, "")
									elseif SelectedItem.Text:match(v .. ",") then
										SelectedItem.Text = SelectedItem.Text:gsub(v .. ",", "")
									end
									SelectedItem.Text = SelectedItem.Text:gsub(v, "")
									if SelectedItem.Text == "" then
										SelectedItem.Text = "~"
									end

									table.remove(
										ConfigDropdownSettings[ConfigDropdownTitle]["Selected"],
										GetPos(ConfigDropdownSettings[ConfigDropdownTitle]["Selected"], v)
									)
								end
								pcall(callback, v, itemtoggled)
							end
						)
					else
						SelectedText.Visible = false
						SelectedItem.Visible = false
						ItemButton.MouseButton1Click:Connect(
							function()
								TweenService:Create(
									ItemFrame,
									TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
									{BackgroundColor3 =  HawkLib.Themes[Theme].DropdownItemHover}
								):Play()
								SelectedItem.Text = tostring(v)
								wait(0.2)
								TweenService:Create(
									ItemFrame,
									TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
									{BackgroundColor3 =  HawkLib.Themes[Theme].DropdownItem}
								):Play()
								wait(0.2)
								for i, v in pairs(DropdownFrame:GetDescendants()) do
									if v:IsA("TextButton") then
										TweenService:Create(
											v,
											TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
											{BackgroundTransparency = 1}
										):Play()
										TweenService:Create(
											v,
											TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
											{TextTransparency = 1}
										):Play()
									elseif v:IsA("TextLabel") then
										TweenService:Create(
											v,
											TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
											{TextTransparency = 1}
										):Play()
									elseif v:IsA("TextBox") then
										TweenService:Create(
											v,
											TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
											{TextTransparency = 1}
										):Play()
									elseif v:IsA("ImageLabel") then
										TweenService:Create(
											v,
											TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
											{ImageTransparency = 1}
										):Play()
									elseif v:IsA("ScrollingFrame") then
										TweenService:Create(
											v,
											TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
											{ScrollBarImageTransparency = 1}
										):Play()
									elseif v:IsA("UIGradient") then
										v.Transparency = NumberSequence.new(1)
									end
									DropdownFrame.Visible = false
									TweenService:Create(
										Dropdown,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{Size = UDim2.new(0, 391, 0, 52)}
									):Play()
									TweenService:Create(
										Plus,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{Rotation = 0}
									):Play()
								end
								pcall(callback, v)
							end
						)
					end

					ItemsContainer[v] = Update
				end

				TweenService:Create(
					Page,
					TweenInfo.new(.2, Enum.EasingStyle.Quad),
					{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
				):Play()

				local dropfuncs = {}

				if multiopt == true then
					SelectedItem.Visible = true
					SelectedText.Visible = true
					function dropfuncs:Add(iteeemnam, toggle, callback)
						local additoggle = toggle
						callback = callback or function()
						end
						local ItemFrame = Instance.new("Frame")
						local UICorner_2 = Instance.new("UICorner")
						local ItemButton = Instance.new("TextButton")
						local UICorner_3 = Instance.new("UICorner")
						local UIGradient = Instance.new("UIGradient")

						ItemFrame.Name = "ItemFrame"
						ItemFrame.Parent = DropItemHolder
						ItemFrame.BackgroundColor3 = HawkLib.Themes[Theme].DropdownItem
						ItemFrame.BorderColor3 = Color3.fromRGB(49, 49, 49)
						ItemFrame.BorderSizePixel = 0
						ItemFrame.Size = UDim2.new(0, 369, 0, 27)

						UICorner_2.CornerRadius = UDim.new(0, 5)
						UICorner_2.Parent = ItemFrame

						ItemButton.Name = "ItemButton"
						ItemButton.Parent = ItemFrame
						ItemButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
						ItemButton.BackgroundTransparency = 1.000
						ItemButton.BorderColor3 = Color3.fromRGB(60, 60, 60)
						ItemButton.BorderSizePixel = 0
						ItemButton.Size = UDim2.new(0, 369, 0, 27)
						ItemButton.Font = Enum.Font.Gotham
						ItemButton.Text = iteeemnam
						ItemButton.TextColor3 = Color3.fromRGB(220, 220, 219)
						ItemButton.TextSize = 14.000
						ItemButton.BackgroundTransparency = 1

						UICorner_3.Parent = ItemButton

						UIGradient.Color =
							ColorSequence.new {
								ColorSequenceKeypoint.new(0.00, HawkLib.Themes[Theme].DropdownItemFirst),
								ColorSequenceKeypoint.new(1.00, HawkLib.Themes[Theme].DropdownItemSecond)
							}
						UIGradient.Rotation = 90
						UIGradient.Parent = ItemFrame

						TweenService:Create(
							Page,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
						):Play()
						TweenService:Create(
							DropItemHolder,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)}
						):Play()

						local function Update(bool)
							additoggle = bool
							if bool == false then
								TweenService:Create(
									ItemFrame,
									TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
									{BackgroundColor3 = HawkLib.Themes[Theme].DropdownItem}
								):Play()
								if SelectedItem.Text:match("," .. iteeemnam) then
									SelectedItem.Text = SelectedItem.Text:gsub("," .. iteeemnam, "")
								elseif SelectedItem.Text:match(iteeemnam .. ",") then
									SelectedItem.Text = SelectedItem.Text:gsub(iteeemnam .. ",", "")
								end
								SelectedItem.Text = SelectedItem.Text:gsub(iteeemnam, "")
								if SelectedItem.Text == "" then
									SelectedItem.Text = "~"
								end

								table.remove(
									ConfigDropdownSettings[ConfigDropdownTitle]["Selected"],
									GetPos(ConfigDropdownSettings[ConfigDropdownTitle]["Selected"], iteeemnam)
								)
							elseif bool == true then
								TweenService:Create(
									ItemFrame,
									TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
									{BackgroundColor3 = HawkLib.Themes[Theme].DropdownItemHover}
								):Play()
								if SelectedItem.Text == "~" then
									SelectedItem.Text = iteeemnam
								else
									SelectedItem.Text =
										SelectedItem.Text:gsub(SelectedItem.Text, SelectedItem.Text .. "," .. iteeemnam)
								end
								table.insert(ConfigDropdownSettings[ConfigDropdownTitle]["Selected"], iteeemnam)
							end
							if LoadHawkConfig ~= "enabled" then
								pcall(callback, iteeemnam, bool)
							end
						end

						ItemButton.MouseButton1Click:Connect(
							function()
								if additoggle == false then
									additoggle = true
									TweenService:Create(
										ItemFrame,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{BackgroundColor3 = HawkLib.Themes[Theme].DropdownItemHover}
									):Play()
									if SelectedItem.Text == "~" then
										SelectedItem.Text = tostring(iteeemnam)
									else
										SelectedItem.Text =
											SelectedItem.Text:gsub(
												SelectedItem.Text,
												SelectedItem.Text .. "," .. tostring(iteeemnam)
											)
									end
									table.insert(ConfigDropdownSettings[ConfigDropdownTitle]["Selected"], iteeemnam)
								elseif additoggle == true then
									additoggle = false
									TweenService:Create(
										ItemFrame,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{BackgroundColor3 = HawkLib.Themes[Theme].DropdownItem}
									):Play()
									if SelectedItem.Text:match("," .. iteeemnam) then
										SelectedItem.Text = SelectedItem.Text:gsub("," .. iteeemnam, "")
									elseif SelectedItem.Text:match(iteeemnam .. ",") then
										SelectedItem.Text = SelectedItem.Text:gsub(iteeemnam .. ",", "")
									end
									SelectedItem.Text = SelectedItem.Text:gsub(iteeemnam, "")
									if SelectedItem.Text == "" then
										SelectedItem.Text = "~"
									end
									table.remove(
										ConfigDropdownSettings[ConfigDropdownTitle]["Selected"],
										GetPos(ConfigDropdownSettings[ConfigDropdownTitle]["Selected"], iteeemnam)
									)
								end
								pcall(callback, iteeemnam, additoggle)
							end
						)

						ItemsContainer[iteeemnam] = Update
					end
				else
					SelectedItem.Visible = false
					SelectedText.Visible = false
					function dropfuncs:Add(iteeemnam, callback)
						callback = callback or function()
						end
						local ItemFrame = Instance.new("Frame")
						local UICorner_2 = Instance.new("UICorner")
						local ItemButton = Instance.new("TextButton")
						local UICorner_3 = Instance.new("UICorner")
						local UIGradient = Instance.new("UIGradient")

						ItemFrame.Name = "ItemFrame"
						ItemFrame.Parent = DropItemHolder
						ItemFrame.BackgroundColor3 =HawkLib.Themes[Theme].DropdownItem
						ItemFrame.BorderColor3 = Color3.fromRGB(49, 49, 49)
						ItemFrame.BorderSizePixel = 0
						ItemFrame.Size = UDim2.new(0, 369, 0, 27)

						UICorner_2.CornerRadius = UDim.new(0, 5)
						UICorner_2.Parent = ItemFrame

						ItemButton.Name = "ItemButton"
						ItemButton.Parent = ItemFrame
						ItemButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
						ItemButton.BackgroundTransparency = 1.000
						ItemButton.BorderColor3 = Color3.fromRGB(60, 60, 60)
						ItemButton.BorderSizePixel = 0
						ItemButton.Size = UDim2.new(0, 369, 0, 27)
						ItemButton.Font = Enum.Font.Gotham
						ItemButton.Text = iteeemnam
						ItemButton.TextColor3 = Color3.fromRGB(220, 220, 219)
						ItemButton.TextSize = 14.000
						ItemButton.BackgroundTransparency = 1

						UICorner_3.Parent = ItemButton

						UIGradient.Color =
							ColorSequence.new {
								ColorSequenceKeypoint.new(0.00, HawkLib.Themes[Theme].DropdownItemFirst),
								ColorSequenceKeypoint.new(1.00, HawkLib.Themes[Theme].DropdownItemSecond)
							}
						UIGradient.Rotation = 90
						UIGradient.Parent = ItemFrame

						TweenService:Create(
							Page,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
						):Play()
						TweenService:Create(
							DropItemHolder,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)}
						):Play()

						ItemButton.MouseButton1Click:Connect(
							function()
								TweenService:Create(
									ItemFrame,
									TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
									{BackgroundColor3 = HawkLib.Themes[Theme].DropdownItemHover}
								):Play()
								SelectedItem.Text = tostring(iteeemnam)
								wait(0.1)
								TweenService:Create(
									ItemFrame,
									TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
									{BackgroundColor3 = HawkLib.Themes[Theme].DropdownItem}
								):Play()
								pcall(callback, iteeemnam)
								ItemsContainer[iteeemnam] = {iteeemnam, ItemButton}
							end
						)
					end
				end

				function dropfuncs:Remove(iteeem)
					for i, v in pairs(DropItemHolder:GetDescendants()) do
						if v:IsA("TextButton") then
							if v.Text == iteeem then
								v.Parent:Destroy()
							end
						end
					end
					if SelectedItem.Text == tostring(iteeem) then
						SelectedItem.Text = "~"
					else
						SelectedItem.Text = SelectedItem.Text:gsub("," .. tostring(iteeem), "")
					end

					TweenService:Create(
						DropItemHolder,
						TweenInfo.new(.2, Enum.EasingStyle.Quad),
						{CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)}
					):Play()
					table.remove(
						ConfigDropdownSettings[ConfigDropdownTitle]["Selected"],
						GetPos(ConfigDropdownSettings[ConfigDropdownTitle]["Selected"], iteeem)
					)
					table.remove(
						ConfigDropdownSettings[ConfigDropdownTitle]["Selected"],
						GetPos(ItemsContainer[iteeem], iteeem)
					)
				end

				function dropfuncs:Clear()
					for i, v in pairs(DropItemHolder:GetChildren()) do
						if v:IsA("Frame") and v.Name == "ItemFrame" then
							v:Destroy()
						end
					end
					for i, v in pairs(DropdownFrame:GetDescendants()) do
						TweenService:Create(
							Page,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
						):Play()

						if v:IsA("TextButton") then
							TweenService:Create(
								v,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{BackgroundTransparency = 1}
							):Play()
							TweenService:Create(
								v,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{TextTransparency = 1}
							):Play()
						elseif v:IsA("TextLabel") then
							TweenService:Create(
								v,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{TextTransparency = 1}
							):Play()
						elseif v:IsA("TextBox") then
							TweenService:Create(
								v,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{TextTransparency = 1}
							):Play()
						elseif v:IsA("ImageLabel") then
							TweenService:Create(
								v,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{ImageTransparency = 1}
							):Play()
						elseif v:IsA("ScrollingFrame") then
							TweenService:Create(
								v,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{ScrollBarImageTransparency = 1}
							):Play()
						elseif v:IsA("UIGradient") then
							v.Transparency = NumberSequence.new(1)
						end
						SelectedItem.Text = "~"
						TweenService:Create(
							Page,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
						):Play()

						DropdownFrame.Visible = false
						TweenService:Create(
							Dropdown,
							TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
							{Size = UDim2.new(0, 391, 0, 52)}
						):Play()
						TweenService:Create(
							Plus,
							TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
							{Rotation = 0}
						):Play()
						TweenService:Create(
							DropItemHolder,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)}
						):Play()
						for i, v in pairs(ConfigDropdownSettings[ConfigDropdownTitle]["Selected"]) do
							i = nil
						end
						for i, v in pairs(ItemsContainer) do
							i = nil
						end
					end
				end

				function dropfuncs:Refresh(anan)
					local toglid
					local newtebil
					if type(anan) == "table" then
						for i, v in pairs(anan) do
							if i == "MultiOption" then
								toglid = v
							elseif i == "NewList" then
								newtebil = v
							end
						end
					end
					dropfuncs:Clear()
					wait(1)
					SelectedItem.Text = "~"
					DropdownFrame.Visible = true
					for i, v in pairs(DropdownFrame:GetDescendants()) do
						if v:IsA("TextButton") and v.Name ~= "ItemButton" then
							TweenService:Create(
								v,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{BackgroundTransparency = 0}
							):Play()
							TweenService:Create(
								v,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{TextTransparency = 0}
							):Play()
						elseif v:IsA("TextButton") and v.Name == "ItemButton" then
							TweenService:Create(
								v,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{TextTransparency = 0}
							):Play()
						elseif v:IsA("TextLabel") then
							TweenService:Create(
								v,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{TextTransparency = 0}
							):Play()
						elseif v:IsA("TextBox") then
							TweenService:Create(
								v,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{TextTransparency = 0}
							):Play()
						elseif v:IsA("ImageLabel") then
							TweenService:Create(
								v,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{ImageTransparency = 0}
							):Play()
						elseif v:IsA("ScrollingFrame") then
							TweenService:Create(
								v,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{ScrollBarImageTransparency = 0}
							):Play()
						elseif v:IsA("UIGradient") then
							v.Transparency = NumberSequence.new(0)
						end
					end
					TweenService:Create(
						Plus,
						TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{Rotation = 225}
					):Play()
					TweenService:Create(
						Dropdown,
						TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{Size = UDim2.new(0, 391, 0, 179)}
					):Play()
					repeat
						wait()
						TweenService:Create(
							Page,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
						):Play()
					until Dropdown.Size == UDim2.new(0, 391, 0, 179)

					for i, v in pairs(newtebil) do
						if type(newtebil) == "table" then
							local droptable = newtebil
						end
						local itemtoggled = false
						local ItemFrame = Instance.new("Frame")
						local UICorner_2 = Instance.new("UICorner")
						local ItemButton = Instance.new("TextButton")
						local UICorner_3 = Instance.new("UICorner")
						local UIGradient = Instance.new("UIGradient")

						ItemFrame.Name = "ItemFrame"
						ItemFrame.Parent = DropItemHolder
						ItemFrame.BackgroundColor3 = HawkLib.Themes[Theme].DropdownItem
						ItemFrame.BorderColor3 = Color3.fromRGB(49, 49, 49)
						ItemFrame.BorderSizePixel = 0
						ItemFrame.Size = UDim2.new(0, 369, 0, 27)

						UICorner_2.CornerRadius = UDim.new(0, 5)
						UICorner_2.Parent = ItemFrame

						ItemButton.Name = "ItemButton"
						ItemButton.Parent = ItemFrame
						ItemButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
						ItemButton.BackgroundTransparency = 1.000
						ItemButton.BorderColor3 = Color3.fromRGB(60, 60, 60)
						ItemButton.BorderSizePixel = 0
						ItemButton.Size = UDim2.new(0, 369, 0, 27)
						ItemButton.Font = Enum.Font.Gotham
						ItemButton.Text = v
						ItemButton.TextColor3 = Color3.fromRGB(220, 220, 219)
						ItemButton.TextSize = 14.000
						ItemButton.BackgroundTransparency = 1

						UICorner_3.Parent = ItemButton

						UIGradient.Color =
							ColorSequence.new {
								ColorSequenceKeypoint.new(0.00, HawkLib.Themes[Theme].DropdownItemFirst),
								ColorSequenceKeypoint.new(1.00, HawkLib.Themes[Theme].DropdownItemSecond)
							}
						UIGradient.Rotation = 90
						UIGradient.Parent = ItemFrame

						TweenService:Create(
							Page,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
						):Play()
						TweenService:Create(
							DropItemHolder,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)}
						):Play()
						if toglid == true then
							multiopt = true
							SelectedItem.Visible = true
							SelectedText.Visible = true
							ItemButton.MouseButton1Click:Connect(
								function()
									if itemtoggled == false then
										itemtoggled = true
										TweenService:Create(
											ItemFrame,
											TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
											{BackgroundColor3 = HawkLib.Themes[Theme].DropdownItemHover}
										):Play()
										if SelectedItem.Text == "~" then
											SelectedItem.Text = tostring(v)
										else
											SelectedItem.Text =
												SelectedItem.Text:gsub(
													SelectedItem.Text,
													SelectedItem.Text .. "," .. tostring(v)
												)
										end
										table.insert(ConfigDropdownSettings[ConfigDropdownTitle]["Selected"], v)
									elseif itemtoggled == true then
										itemtoggled = false
										TweenService:Create(
											ItemFrame,
											TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
											{BackgroundColor3 = HawkLib.Themes[Theme].DropdownItem}
										):Play()

										if SelectedItem.Text:match("," .. v) then
											SelectedItem.Text = SelectedItem.Text:gsub("," .. v, "")
										elseif SelectedItem.Text:match(v .. ",") then
											SelectedItem.Text = SelectedItem.Text:gsub(v .. ",", "")
										end
										SelectedItem.Text = SelectedItem.Text:gsub(v, "")
										if SelectedItem.Text == "" then
											SelectedItem.Text = "~"
										end
										table.remove(
											ConfigDropdownSettings[ConfigDropdownTitle]["Selected"],
											GetPos(ConfigDropdownSettings[ConfigDropdownTitle]["Selected"], v)
										)
									end

									pcall(callback, v, itemtoggled)
								end
							)

							local function Update(bool)
								itemtoggled = bool
								if bool == false then
									TweenService:Create(
										ItemFrame,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{BackgroundColor3 = HawkLib.Themes[Theme].DropdownItem}
									):Play()
									if SelectedItem.Text:match("," .. v) then
										SelectedItem.Text = SelectedItem.Text:gsub("," .. v, "")
									elseif SelectedItem.Text:match(v .. ",") then
										SelectedItem.Text = SelectedItem.Text:gsub(v .. ",", "")
									end
									SelectedItem.Text = SelectedItem.Text:gsub(v, "")
									if SelectedItem.Text == "" then
										SelectedItem.Text = "~"
									end

									table.remove(
										ConfigDropdownSettings[ConfigDropdownTitle]["Selected"],
										GetPos(ConfigDropdownSettings[ConfigDropdownTitle]["Selected"], v)
									)
								elseif bool == true then
									TweenService:Create(
										ItemFrame,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{BackgroundColor3 = HawkLib.Themes[Theme].DropdownItemHover}
									):Play()
									if SelectedItem.Text == "~" then
										SelectedItem.Text = v
									else
										SelectedItem.Text =
											SelectedItem.Text:gsub(SelectedItem.Text, SelectedItem.Text .. "," .. v)
									end
									table.insert(ConfigDropdownSettings[ConfigDropdownTitle]["Selected"], v)
								end
								if LoadHawkConfig ~= "enabled" then
									pcall(callback, v, bool)
								end
							end

							ItemsContainer[v] = Update
						else
							multiopt = false
							SelectedItem.Visible = false
							SelectedText.Visible = false
							ItemButton.MouseButton1Click:Connect(
								function()
									TweenService:Create(
										ItemFrame,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{BackgroundColor3 = HawkLib.Themes[Theme].DropdownItemHover}
									):Play()
									wait(0.1)
									TweenService:Create(
										ItemFrame,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{BackgroundColor3 = HawkLib.Themes[Theme].DropdownItem}
									):Play()
									wait(0.1)
									for i, v in pairs(DropdownFrame:GetDescendants()) do
										if v:IsA("TextButton") then
											TweenService:Create(
												v,
												TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
												{BackgroundTransparency = 1}
											):Play()
											TweenService:Create(
												v,
												TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
												{TextTransparency = 1}
											):Play()
										elseif v:IsA("TextLabel") then
											TweenService:Create(
												v,
												TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
												{TextTransparency = 1}
											):Play()
										elseif v:IsA("TextBox") then
											TweenService:Create(
												v,
												TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
												{TextTransparency = 1}
											):Play()
										elseif v:IsA("ImageLabel") then
											TweenService:Create(
												v,
												TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
												{ImageTransparency = 1}
											):Play()
										elseif v:IsA("ScrollingFrame") then
											TweenService:Create(
												v,
												TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
												{ScrollBarImageTransparency = 1}
											):Play()
										elseif v:IsA("UIGradient") then
											v.Transparency = NumberSequence.new(1)
										end
										DropdownFrame.Visible = false
										TweenService:Create(
											Dropdown,
											TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
											{Size = UDim2.new(0, 391, 0, 52)}
										):Play()
										TweenService:Create(
											Plus,
											TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
											{Rotation = 0}
										):Play()
									end
									pcall(callback, v)
								end
							)
						end
					end
				end

				function dropfuncs:Select(Item, reset)
					if reset then
						-- Önce tüm seçimleri temizle
						for itemName, updateFunc in pairs(ItemsContainer) do
							updateFunc(false)
						end
						SelectedItem.Text = "~"
						ConfigDropdownSettings[ConfigDropdownTitle]["Selected"] = {}
					end

					-- Geçici olarak callback'leri devre dışı bırak
					local tempLoadState = LoadHawkConfig
					LoadHawkConfig = "enabled"

					if type(Item) == "table" then
						for _, v in pairs(Item) do
							if ItemsContainer[v] then
								ItemsContainer[v](true)
							end
						end
					elseif type(Item) == "string" then
						if ItemsContainer[Item] then
							ItemsContainer[Item](true)
						end
					end

					-- Callback'leri tekrar aktif et
					LoadHawkConfig = tempLoadState
				end

				HawkLib.Elements.Dropdown[ConfigDropdownTitle] = dropfuncs

				return dropfuncs
			end

			function ContainerItems:Image(ImageData)
				local name = ImageData.Title
				local minititle = ImageData.MiniTitle
				local filename = ImageData.FileName
				local checkfile = ImageData.CheckFile
				local imagelink = ImageData.ImageLink
				local imagecolor = ImageData.ImageColor
				local description = ImageData.Description
				local stroke = ImageData.StrokeColor
				local volume = ImageData.Volume
				local writeinto = ImageData.WriteInto
				local imagetype = ImageData.Type

				if not isfolder(writeinto) then
					makefolder(writeinto)
				end
				
				if not isfolder(writeinto.."/Assets") then
					makefolder(writeinto.."/Assets")
				end

				local ImageToggled = false

				local Image = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local ImageTitle = Instance.new("TextLabel")
				local ImageButton = Instance.new("TextButton")
				local Arrow = Instance.new("ImageButton")
				local ImageFrame = Instance.new("Frame")
				local UICorner_2 = Instance.new("UICorner")
				local UICorner_3 = Instance.new("UICorner")
				local UIStroke = Instance.new("UIStroke")
				local UIListLayout = Instance.new("UIListLayout")
				local ImageListing = Instance.new("Frame")
				local UIListLayout_2 = Instance.new("UIListLayout")
				local ButtonTitle = Instance.new("TextLabel")

				Image.Name = "Image"
				Image.Parent = Container
				Image.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
				Image.BorderColor3 = HawkLib.Themes[Theme].ItemColors
				Image.BorderSizePixel = 0
				Image.Position = UDim2.new(0.0196560193, 0, 0.748526514, 0)
				Image.Size = UDim2.new(0, 391, 0, 44)

				UICorner.CornerRadius = UDim.new(0, 6)
				UICorner.Parent = Image

				ImageTitle.Name = "ImageTitle"
				ImageTitle.Parent = Image
				ImageTitle.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
				ImageTitle.BackgroundTransparency = 1.000
				ImageTitle.BorderColor3 = HawkLib.Themes[Theme].ItemColors
				ImageTitle.BorderSizePixel = 0
				ImageTitle.Position = UDim2.new(0.0306905378, 0, 0.275297672, 0)
				ImageTitle.Size = UDim2.new(0, 121, 0, 22)
				ImageTitle.Font = Enum.Font.GothamBold
				ImageTitle.Text = name
				ImageTitle.TextColor3 = HawkLib.Themes[Theme].ItemTitleColors
				ImageTitle.TextSize = 15.000
				ImageTitle.TextXAlignment = Enum.TextXAlignment.Left

				ImageButton.Name = "ImageButton"
				ImageButton.Parent = Image
				ImageButton.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
				ImageButton.BackgroundTransparency = 1.000
				ImageButton.BorderColor3 = HawkLib.Themes[Theme].ItemColors
				ImageButton.BorderSizePixel = 0
				ImageButton.Size = UDim2.new(0, 391, 0, 44)
				ImageButton.Font = Enum.Font.SourceSans
				ImageButton.Text = ""
				ImageButton.TextColor3 = Color3.fromRGB(0, 0, 0)
				ImageButton.TextSize = 14.000
				ImageButton.AutoButtonColor = false

				Arrow.Name = "Arrow"
				Arrow.Parent = Image
				Arrow.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
				Arrow.BackgroundTransparency = 1.000
				Arrow.Position = UDim2.new(0.913561523, 0, 0.211111104, 0)
				Arrow.Size = UDim2.new(0, 26, 0, 27)
				Arrow.Image = "rbxassetid://6034818372"
				Arrow.ImageColor3 = HawkLib.Themes[Theme].ItemTitleColors

				ImageFrame.Name = "ImageFrame"
				ImageFrame.Parent = Container
				ImageFrame.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
				ImageFrame.BorderColor3 = HawkLib.Themes[Theme].ItemColors
				ImageFrame.BackgroundTransparency = 0.2
				ImageFrame.BorderSizePixel = 0
				ImageFrame.Position = UDim2.new(0.00175316073, 0, 1.71075165, 0)
				ImageFrame.Size = UDim2.new(0, 391, 0, 0)
				ImageFrame.Visible = false

				UICorner_2.CornerRadius = UDim.new(0, 6)
				UICorner_2.Parent = ImageFrame

				local imgloop = false
	
				if imagetype == "Image" then
					if string.find(imagelink, "rbxassetid") then
						local ImageLabel = Instance.new("ImageLabel")
						ImageLabel.Parent = ImageFrame
						ImageLabel.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
						ImageLabel.BackgroundTransparency = 1.000
						ImageLabel.BorderColor3 = HawkLib.Themes[Theme].ItemColors
						ImageLabel.BorderSizePixel = 0
						ImageLabel.Position = UDim2.new(0, 0, 0.0250000004, 0)
						ImageLabel.Size = UDim2.new(0, 97, 0, 95)
						ImageLabel.ImageColor3 = imagecolor
						ImageLabel.ImageTransparency = 1
						ImageLabel.Image = imagelink

						UICorner_3.Parent = ImageLabel

						UIStroke.Parent = ImageLabel
						UIStroke.Color = stroke
						UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
						UIStroke.Transparency = 1
					elseif string.find(imagelink, "https") then
						if checkfile ~= nil then
							if checkfile == false then
								writefile(
									tostring(writeinto) .. "/Assets/" .. tostring(filename),
									game:HttpGet(tostring(imagelink), true)
								)
							else
								if checkfile == true then
									if not isfile(tostring(writeinto) .. "/Assets/" .. tostring(filename)) then
										writefile(
											tostring(writeinto) .. "/Assets/" .. tostring(filename),
											game:HttpGet(tostring(imagelink), true)
										)
									end
								end
							end
						else
							checkfile = false
							writefile(
								tostring(writeinto) .. "/Assets/" .. tostring(filename),
								game:HttpGet(tostring(imagelink), true)
							)
						end
						
						local ImageLabel = Instance.new("ImageLabel")
						ImageLabel.Parent = ImageFrame
						ImageLabel.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
						ImageLabel.BackgroundTransparency = 1.000
						ImageLabel.BorderColor3 = HawkLib.Themes[Theme].ItemColors
						ImageLabel.BorderSizePixel = 0
						ImageLabel.Position = UDim2.new(0, 0, 0.0250000004, 0)
						ImageLabel.Size = UDim2.new(0, 97, 0, 95)
						ImageLabel.ImageColor3 = imagecolor
						ImageLabel.ImageTransparency = 1
						ImageLabel.Image = getasset(writeinto .. "/Assets/" .. filename)

						UICorner_3.Parent = ImageLabel

						UIStroke.Parent = ImageLabel
						UIStroke.Color = stroke
						UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
						UIStroke.Transparency = 1
					end
				elseif imagetype == "Video" then
					if string.find(imagelink, "https") then
						if checkfile ~= nil then
							if checkfile == false then
								writefile(
									tostring(writeinto) .. "\\" .. tostring(filename),
									game:HttpGet(tostring(imagelink), true)
								)
							else
								if checkfile == true then
									if not isfile(tostring(writeinto) .. "\\" .. tostring(filename)) then
										writefile(
											tostring(writeinto) .. "\\" .. tostring(filename),
											game:HttpGet(tostring(imagelink), true)
										)
									end
								end
							end
						else
							checkfile = false
							writefile(
								tostring(writeinto) .. "/Assets/" .. tostring(filename),
								game:HttpGet(tostring(imagelink), true)
							)
						end

						local getasset = getcustomasset or getsynasset
						local VideoLabel = Instance.new("VideoFrame")
						VideoLabel.Parent = ImageFrame
						VideoLabel.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
						VideoLabel.BackgroundTransparency = 1.000
						VideoLabel.BorderColor3 = HawkLib.Themes[Theme].ItemColors
						VideoLabel.BorderSizePixel = 0
						VideoLabel.Position = UDim2.new(0, 0, 0.0250000004, 0)
						VideoLabel.Size = UDim2.new(0, 97, 0, 95)
						VideoLabel.Video = getasset(writeinto .. "\\" .. filename)
						VideoLabel.Volume = tonumber(volume)
						VideoLabel.Looped = true
						VideoLabel.Playing = ImageToggled

						UICorner_3.Parent = VideoLabel

						UIStroke.Parent = VideoLabel
						UIStroke.Color = stroke
						UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
						UIStroke.Transparency = 1
					end
				end

				local function activate()
					for i, v in pairs(ImageFrame:GetChildren()) do
						if v:IsA("ImageLabel") then
							TweenService:Create(
								v,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{ImageTransparency = 0}
							):Play()
						elseif v:IsA("VideoFrame") then
							TweenService:Create(
								v,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{BackgroundTransparency = 0}
							):Play()
							v.Playing = true
						end
					end
				end

				local function disable()
					for i, v in pairs(ImageFrame:GetChildren()) do
						if v:IsA("ImageLabel") then
							TweenService:Create(
								v,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{ImageTransparency = 1}
							):Play()
						elseif v:IsA("VideoFrame") then
							TweenService:Create(
								v,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{BackgroundTransparency = 1}
							):Play()
							v.Playing = false
						end
					end
				end

				UIListLayout.Parent = ImageFrame
				UIListLayout.FillDirection = Enum.FillDirection.Horizontal
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
				UIListLayout.Padding = UDim.new(0, 30)

				ImageListing.Name = "ImageListing"
				ImageListing.Parent = ImageFrame
				ImageListing.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
				ImageListing.BackgroundTransparency = 1.000
				ImageListing.BorderColor3 = HawkLib.Themes[Theme].ItemColors
				ImageListing.BorderSizePixel = 0
				ImageListing.Position = UDim2.new(0.312020451, 0, 0, 0)
				ImageListing.Size = UDim2.new(0, 104, 0, 100)

				UIListLayout_2.Parent = ImageListing
				UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center

				ButtonTitle.Name = "ButtonTitle"
				ButtonTitle.Parent = ImageListing
				ButtonTitle.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
				ButtonTitle.BackgroundTransparency = 1.000
				ButtonTitle.BorderColor3 = HawkLib.Themes[Theme].ItemColors
				ButtonTitle.BorderSizePixel = 0
				ButtonTitle.Size = UDim2.new(0, 379, 0, 17)
				ButtonTitle.Font = Enum.Font.GothamBold
				ButtonTitle.Text = minititle
				ButtonTitle.TextColor3 = HawkLib.Themes[Theme].ItemTitleColors
				ButtonTitle.TextSize = 15.000
				ButtonTitle.TextTransparency = 1
				ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left

				TweenService:Create(
					Page,
					TweenInfo.new(.2, Enum.EasingStyle.Quad),
					{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
				):Play()
				for i, v in next, description do
					local ButtonText = Instance.new("TextLabel")
					ButtonText.Name = "ButtonText"
					ButtonText.Parent = ImageListing
					ButtonText.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
					ButtonText.BackgroundTransparency = 1.000
					ButtonText.BorderColor3 = HawkLib.Themes[Theme].ItemColors
					ButtonText.BorderSizePixel = 0
					ButtonText.Position = UDim2.new(0, 0, 0.170000002, 0)
					ButtonText.Size = UDim2.new(0, 379, 0, 17)
					ButtonText.Font = Enum.Font.Gotham
					ButtonText.Text = v
					ButtonText.TextTransparency = 1
					ButtonText.TextColor3 = HawkLib.Themes[Theme].ItemTextColors
					ButtonText.TextSize = 15.000
					ButtonText.TextXAlignment = Enum.TextXAlignment.Left

					TweenService:Create(
						Page,
						TweenInfo.new(.2, Enum.EasingStyle.Quad),
						{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
					):Play()
				end

				Image.MouseEnter:Connect(
					function()
						TweenService:Create(
							Image,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{BackgroundColor3 = HawkLib.Themes[Theme].Hover}
						):Play()
					end
				)
				Image.MouseLeave:Connect(
					function()
						TweenService:Create(
							Image,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{BackgroundColor3 = HawkLib.Themes[Theme].ItemColors}
						):Play()
					end
				)

				TweenService:Create(
					Page,
					TweenInfo.new(.2, Enum.EasingStyle.Quad),
					{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
				):Play()
				ImageButton.MouseButton1Click:Connect(
					function()
						if ImageToggled == false then
							ImageFrame.Visible = true
							ImageFrame:TweenSize(
								UDim2.new(0, 391, 0, 100),
								Enum.EasingDirection.Out,
								Enum.EasingStyle.Quart,
								0.1,
								true
							)
							activate()
							TweenService:Create(
								UIStroke,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{Transparency = 0}
							):Play()
							TweenService:Create(
								ButtonTitle,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{TextTransparency = 0}
							):Play()
							for i, v in pairs(ImageListing:GetChildren()) do
								if v.Name == "ButtonText" then
									TweenService:Create(
										v,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{TextTransparency = 0}
									):Play()
								end
							end
							TweenService:Create(
								Arrow,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{Rotation = 180}
							):Play()
							TweenService:Create(
								Page,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
							):Play()
							repeat
								wait()
								TweenService:Create(
									Page,
									TweenInfo.new(.2, Enum.EasingStyle.Quad),
									{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
								):Play()
							until ImageFrame.Size == UDim2.new(0, 391, 0, 100)
						else
							disable()
							TweenService:Create(
								UIStroke,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{Transparency = 1}
							):Play()
							TweenService:Create(
								ButtonTitle,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{TextTransparency = 1}
							):Play()
							for i, v in pairs(ImageListing:GetChildren()) do
								if v.Name == "ButtonText" then
									TweenService:Create(
										v,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{TextTransparency = 1}
									):Play()
								end
							end
							ImageFrame:TweenSize(
								UDim2.new(0, 391, 0, 0),
								Enum.EasingDirection.Out,
								Enum.EasingStyle.Quart,
								0.1,
								true
							)
							TweenService:Create(
								Arrow,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{Rotation = 0}
							):Play()
							ImageFrame.Visible = false
							TweenService:Create(
								Page,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
							):Play()
							repeat
								wait()
								TweenService:Create(
									Page,
									TweenInfo.new(.2, Enum.EasingStyle.Quad),
									{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
								):Play()
							until ImageFrame.Size == UDim2.new(0, 391, 0, 0)
						end
						ImageToggled = not ImageToggled
					end
				)

				TweenService:Create(
					Page,
					TweenInfo.new(.2, Enum.EasingStyle.Quad),
					{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
				):Play()
			end

			function ContainerItems:Video(anan)
				local title
				local descriptio
				local linq
				local writeinto
				local filename
				local volume

				if anan ~= nil then
					for i, v in pairs(anan) do
						if i == "VideoTitle" then
							title = tostring(v)
						elseif i == "VideoDescription" then
							descriptio = tostring(v)
						elseif i == "VideoLink" then
							linq = tostring(v)
						elseif i == "VideoVolume" then
							volume = tostring(v)
						elseif i == "WriteInto" then
							writeinto = tostring(v)
						elseif i == "FileName" then
							filename = tostring(v)
						end
					end
				end
				local videotoggle = false
				local Video = Instance.new("Frame")
				local UICorner_29 = Instance.new("UICorner")
				local VideoTitle = Instance.new("TextLabel")
				local ImageLabel_6 = Instance.new("ImageLabel")
				local VideoBar = Instance.new("Frame")
				local VideoButton = Instance.new("TextButton")
				local VideoFrame = Instance.new("Frame")
				local UICorner_30 = Instance.new("UICorner")
				local VF = Instance.new("Frame")
				local UICorner_31 = Instance.new("UICorner")
				local VidBtnS = Instance.new("Frame")
				local buttonscorner = Instance.new("UICorner")
				local UIListLayout_8 = Instance.new("UIListLayout")
				local Start = Instance.new("ImageButton")
				local Stop = Instance.new("ImageButton")
				local Prev5 = Instance.new("ImageButton")
				local Skip5 = Instance.new("ImageButton")
				local UICorner_32 = Instance.new("UICorner")
				local VideoDescription = Instance.new("TextLabel")
				local RealVideo = Instance.new("VideoFrame")
				local VideoStroke = Instance.new("UIStroke")
				local VideoCorner = Instance.new("UICorner")

				Video.Name = "Video"
				Video.Parent = Container
				Video.BackgroundColor3 = HawkLib.Themes[Theme].ItemColors
				Video.BorderColor3 = Color3.fromRGB(35, 35, 35)
				Video.BorderSizePixel = 0
				Video.Position = UDim2.new(0.0196560193, 0, 2.83218288, 0)
				Video.Size = UDim2.new(0, 391, 0, 56)

				Video.MouseEnter:Connect(
					function()
						TweenService:Create(
							Video,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{BackgroundColor3 = HawkLib.Themes[Theme].Hover}
						):Play()
					end
				)
				Video.MouseLeave:Connect(
					function()
						TweenService:Create(
							Video,
							TweenInfo.new(.2, Enum.EasingStyle.Quad),
							{BackgroundColor3 = HawkLib.Themes[Theme].ItemColors}
						):Play()
					end
				)

				VideoBar.Name = "VideoBar"
				VideoBar.Parent = Video
				VideoBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				VideoBar.BackgroundTransparency = 1.000
				VideoBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
				VideoBar.BorderSizePixel = 0
				VideoBar.Size = UDim2.new(0, 386, 0, 48)

				UICorner_29.CornerRadius = UDim.new(0, 6)
				UICorner_29.Parent = Video

				VideoTitle.Name = "VideoTitle"
				VideoTitle.Parent = VideoBar
				VideoTitle.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
				VideoTitle.BackgroundTransparency = 1.000
				VideoTitle.BorderColor3 = Color3.fromRGB(43, 43, 41)
				VideoTitle.BorderSizePixel = 0
				VideoTitle.Position = UDim2.new(0.023, 0, 0.096, 0)
				VideoTitle.Size = UDim2.new(0, 374, 0, 22)
				VideoTitle.Font = Enum.Font.GothamBold
				VideoTitle.Text = title
				VideoTitle.TextColor3 = HawkLib.Themes[Theme].ItemTitleColors
				VideoTitle.TextSize = 15.000
				VideoTitle.TextXAlignment = Enum.TextXAlignment.Left

				ImageLabel_6.Parent = VideoBar
				ImageLabel_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ImageLabel_6.BackgroundTransparency = 1.000
				ImageLabel_6.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ImageLabel_6.BorderSizePixel = 0
				ImageLabel_6.Position = UDim2.new(0.905, 0, 0.322, 0)
				ImageLabel_6.Rotation = 0
				ImageLabel_6.Size = UDim2.new(0, 26, 0, 24)
				ImageLabel_6.Image = "rbxassetid://6034818372"
				ImageLabel_6.ImageColor3 = Color3.fromRGB(199, 199, 199)

				VideoFrame.Name = "VideoFrame"
				VideoFrame.Parent = Video
				VideoFrame.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
				VideoFrame.BorderColor3 = Color3.fromRGB(33, 33, 33)
				VideoFrame.BorderSizePixel = 0
				VideoFrame.Position = UDim2.new(0.00511508947, 0, 0.264405489, 0)
				VideoFrame.Size = UDim2.new(0, 387, 0, 150)
				VideoFrame.Visible = false
				VideoFrame.BackgroundTransparency = 1

				UICorner_30.CornerRadius = UDim.new(0, 6)
				UICorner_30.Parent = VideoFrame

				VF.Name = "VF"
				VF.Parent = VideoFrame
				VF.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				VF.BackgroundTransparency = 1.000
				VF.BorderColor3 = Color3.fromRGB(0, 0, 0)
				VF.BorderSizePixel = 0
				VF.Position = UDim2.new(0.150000006, 0, 0, 0)
				VF.Size = UDim2.new(0, 240, 0, 135)

				RealVideo.Name = "RealVideo"
				RealVideo.Parent = VF
				RealVideo.Size = UDim2.new(0, 240, 0, 135)
				RealVideo.BackgroundTransparency = 1
				RealVideo.Volume = tonumber(volume)
				RealVideo.Looped = true

				VideoCorner.CornerRadius = UDim.new(0, 8)
				VideoCorner.Parent = RealVideo

				VideoStroke.Parent = RealVideo
				VideoStroke.Color = Color3.fromRGB(1, 124, 91)
				VideoStroke.ApplyStrokeMode = "Border"
				VideoStroke.LineJoinMode = "Round"
				VideoStroke.Thickness = 1
				VideoStroke.Transparency = 1

				if getgenv().getcustomasset then
					writefile(tostring(writeinto) .. "\\" .. tostring(filename), game:HttpGet(tostring(linq), true))
					wait()
					RealVideo.Video = getcustomasset(writeinto .. "\\" .. filename)
				end

				UICorner_31.Parent = VF

				VidBtnS.Name = "VidBtnS"
				VidBtnS.Parent = VideoFrame
				VidBtnS.BackgroundColor3 = Color3.fromRGB(61, 61, 61)
				VidBtnS.BackgroundTransparency = 1
				VidBtnS.BorderColor3 = Color3.fromRGB(0, 0, 0)
				VidBtnS.BorderSizePixel = 0
				VidBtnS.Position = UDim2.new(0.811369538, 0, 0.0498685725, 0)
				VidBtnS.Size = UDim2.new(0, 29, 0, 118)
				VidBtnS.BackgroundTransparency = 1

				buttonscorner.CornerRadius = UDim.new(0, 6)
				buttonscorner.Parent = VidBtnS

				UIListLayout_8.Parent = VidBtnS
				UIListLayout_8.HorizontalAlignment = Enum.HorizontalAlignment.Center
				UIListLayout_8.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout_8.VerticalAlignment = Enum.VerticalAlignment.Center

				Start.Name = "Start"
				Start.Parent = VidBtnS
				Start.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
				Start.BackgroundTransparency = 1.000
				Start.BorderColor3 = Color3.fromRGB(33, 33, 33)
				Start.BorderSizePixel = 0
				Start.Position = UDim2.new(0.206896558, 0, 0.0762711838, 0)
				Start.Size = UDim2.new(0, 25, 0, 25)
				Start.Image = "rbxassetid://6026663699"
				Start.ImageTransparency = 1
				Start.MouseButton1Click:Connect(
					function()
						RealVideo:Play()
					end
				)

				Stop.Name = "Stop"
				Stop.Parent = VidBtnS
				Stop.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
				Stop.BackgroundTransparency = 1.000
				Stop.BorderColor3 = Color3.fromRGB(33, 33, 33)
				Stop.BorderSizePixel = 0
				Stop.Position = UDim2.new(0.206896558, 0, 0.288135588, 0)
				Stop.Size = UDim2.new(0, 25, 0, 25)
				Stop.Image = "rbxassetid://6026681576"
				Stop.ImageTransparency = 1
				Stop.MouseButton1Click:Connect(
					function()
						RealVideo:Pause()
					end
				)

				Prev5.Name = "Prev5"
				Prev5.Parent = VidBtnS
				Prev5.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
				Prev5.BackgroundTransparency = 1.000
				Prev5.BorderColor3 = Color3.fromRGB(33, 33, 33)
				Prev5.BorderSizePixel = 0
				Prev5.Position = UDim2.new(0.206896558, 0, 0.5, 0)
				Prev5.Size = UDim2.new(0, 25, 0, 25)
				Prev5.Image = "rbxassetid://6026667011"
				Prev5.ImageTransparency = 1
				Prev5.MouseButton1Click:Connect(
					function()
						RealVideo.TimePosition = RealVideo.TimePosition - 5
					end
				)

				Skip5.Name = "Skip5"
				Skip5.Parent = VidBtnS
				Skip5.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
				Skip5.BackgroundTransparency = 1.000
				Skip5.BorderColor3 = Color3.fromRGB(33, 33, 33)
				Skip5.BorderSizePixel = 0
				Skip5.Position = UDim2.new(0.206896558, 0, 0.711864412, 0)
				Skip5.Size = UDim2.new(0, 25, 0, 25)
				Skip5.Image = "rbxassetid://6026667005"
				Skip5.ImageTransparency = 1
				Skip5.MouseButton1Click:Connect(
					function()
						RealVideo.TimePosition = RealVideo.TimePosition + 5
					end
				)

				Skip5.Parent = VidBtnS

				VideoDescription.Name = "VideoDescription"
				VideoDescription.Parent = VideoBar
				VideoDescription.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
				VideoDescription.BackgroundTransparency = 1.000
				VideoDescription.BorderColor3 = Color3.fromRGB(43, 43, 41)
				VideoDescription.BorderSizePixel = 0
				VideoDescription.Position = UDim2.new(0.023, 0, 0.559, 0)
				VideoDescription.Size = UDim2.new(0, 374, 0, 16)
				VideoDescription.Font = Enum.Font.Gotham
				VideoDescription.Text = descriptio
				VideoDescription.TextColor3 = HawkLib.Themes[Theme].ItemTextColors
				VideoDescription.TextSize = 15.000
				VideoDescription.TextXAlignment = Enum.TextXAlignment.Left

				VideoButton.Name = "VideoButton"
				VideoButton.Parent = Video
				VideoButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				VideoButton.BackgroundTransparency = 1.000
				VideoButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
				VideoButton.BorderSizePixel = 0
				VideoButton.Size = UDim2.new(0, 389, 0, 56)
				VideoButton.Font = Enum.Font.SourceSans
				VideoButton.Text = ""
				VideoButton.TextColor3 = Color3.fromRGB(0, 0, 0)
				VideoButton.TextSize = 14.000
				VideoButton.TextTransparency = 1.000
				VideoButton.MouseButton1Click:Connect(
					function()
						if videotoggle == false then
							videotoggle = true
							TweenService:Create(
								ImageLabel_6,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{Rotation = 180}
							):Play()
							TweenService:Create(
								Video,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{Size = UDim2.new(0, 391, 0, 204)}
							):Play()
							repeat
								wait()
								TweenService:Create(
									Page,
									TweenInfo.new(.2, Enum.EasingStyle.Quad),
									{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
								):Play()
							until Video.Size == UDim2.new(0, 391, 0, 204)
							TweenService:Create(
								Page,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
							):Play()
							VideoFrame.Visible = true
							wait(0.3)
							for i, v in pairs(VideoFrame:GetDescendants()) do
								if v:IsA("Frame") and v.Name == "VidBtnS" then
									TweenService:Create(
										v,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{BackgroundTransparency = 0.8}
									):Play()
								elseif v:IsA("ImageButton") then
									TweenService:Create(
										v,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{ImageTransparency = 0}
									):Play()
								end
							end
						elseif videotoggle == true then
							videotoggle = false
							for i, v in pairs(VideoFrame:GetDescendants()) do
								if v:IsA("Frame") and v.Name == "VidBtnS" then
									TweenService:Create(
										v,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{BackgroundTransparency = 1}
									):Play()
								elseif v:IsA("ImageButton") then
									TweenService:Create(
										v,
										TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
										{ImageTransparency = 1}
									):Play()
								end
							end
							wait(0.3)
							VideoFrame.Visible = false
							TweenService:Create(
								ImageLabel_6,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{Rotation = 0}
							):Play()
							TweenService:Create(
								Video,
								TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
								{Size = UDim2.new(0, 391, 0, 56)}
							):Play()
							repeat
								wait()
								TweenService:Create(
									Page,
									TweenInfo.new(.2, Enum.EasingStyle.Quad),
									{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
								):Play()
							until Video.Size == UDim2.new(0, 391, 0, 56)
							TweenService:Create(
								Page,
								TweenInfo.new(.2, Enum.EasingStyle.Quad),
								{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
							):Play()
						end
					end
				)

				TweenService:Create(
					Page,
					TweenInfo.new(.2, Enum.EasingStyle.Quad),
					{CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y)}
				):Play()
			end

			return ContainerItems
		end

		return Sayfalar
	end
end

function HawkLib:AddNotifications()
	if _HawkKey == "pencizurnabayilirim" then
		for i, v in pairs(LibParent:GetChildren()) do
			if v.Name == "HawkNotifications" then
				v:Destroy()
			end
		end
		
		local NotificationListing = Instance.new("Frame")
		local UIListLayout = Instance.new("UIListLayout")
		local UICorner = Instance.new("UICorner")
		local NotifyListing = Instance.new("Frame")
		local UIListLayout_3 = Instance.new("UIListLayout")
		local UICorner_5 = Instance.new("UICorner")

		HawkNotifications.Name = "HawkNotifications"
		HawkNotifications.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		HawkNotifications.ResetOnSpawn = false
		HawkNotifications.Parent = LibParent

		NotificationListing.Name = "NotificationListing"
		NotificationListing.Parent = HawkNotifications
		NotificationListing.AnchorPoint = Vector2.new(1, 0)
		NotificationListing.BackgroundColor3 = Color3.fromRGB(42, 44, 42)
		NotificationListing.BackgroundTransparency = 1.000
		NotificationListing.BorderColor3 = Color3.fromRGB(42, 44, 42)
		NotificationListing.BorderSizePixel = 0
		NotificationListing.Position = UDim2.new(0.986912012, 0, -0.0441767052, 0)
		NotificationListing.Size = UDim2.new(1, 0, 1, 0)

		UIListLayout.Parent = NotificationListing
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
		UIListLayout.Padding = UDim.new(0, 13)

		UICorner.Parent = NotificationListing

		NotifyListing.Name = "NotifyListing"
		NotifyListing.Parent = HawkNotifications
		NotifyListing.BackgroundColor3 = Color3.fromRGB(42, 44, 42)
		NotifyListing.BackgroundTransparency = 1.000
		NotifyListing.BorderColor3 = Color3.fromRGB(42, 44, 42)
		NotifyListing.BorderSizePixel = 0
		NotifyListing.Position = UDim2.new(0.0177570097, 0, -0.0441767052, 0)
		NotifyListing.Size = UDim2.new(1, 0, 1, 0)

		UIListLayout_3.Parent = NotifyListing
		UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_3.VerticalAlignment = Enum.VerticalAlignment.Bottom
		UIListLayout_3.Padding = UDim.new(0, 13)

		UICorner_5.Parent = NotifyListing

		local NotificationItems = {}

		function NotificationItems:Notification(notificatioN)
			task.spawn(
				function()
					local animation = notificatioN.Animated
					local NotificationType = "Notification"
					local Description = #notificatioN.Description
					local notification = Instance.new("Frame")
					local UICorner_2 = Instance.new("UICorner")
					local notificationcontainer = Instance.new("Frame")
					local UICorner_3 = Instance.new("UICorner")
					local Listing = Instance.new("Frame")
					local UIListLayout_2 = Instance.new("UIListLayout")
					local LabelMainText = Instance.new("TextLabel")
					local LabelText = Instance.new("TextLabel")
					local IconFrame = Instance.new("Frame")
					local UICorner_4 = Instance.new("UICorner")
					local Icon = Instance.new("ImageLabel")
					local Shadow = Instance.new("ImageLabel")
					local Blur = Instance.new("ImageLabel")
					local UIGradient = Instance.new("UIGradient")
					local BlurCorner = Instance.new("UICorner")

					notification.Name = "notification"
					notification.Parent = NotificationListing
					notification.BackgroundColor3 = Color3.fromRGB(42, 44, 42)
					notification.BackgroundTransparency = 1.000
					notification.BorderColor3 = Color3.fromRGB(42, 44, 42)
					notification.BorderSizePixel = 0
					notification.Position = UDim2.new(0, 0, 0, 0)
					notification.Size = UDim2.new(0, 287, 0, 61)

					UICorner_2.Parent = notification

					notificationcontainer.Name = "notificationcontainer"
					notificationcontainer.Parent = notification
					notificationcontainer.BackgroundColor3 = Color3.fromRGB(42, 44, 42)
					notificationcontainer.BackgroundTransparency = 0.1
					notificationcontainer.BorderColor3 = Color3.fromRGB(42, 44, 42)
					notificationcontainer.BorderSizePixel = 0
					notificationcontainer.Size = UDim2.new(0, 287, 0, 61)
					notificationcontainer.Position = UDim2.new(5, 0, 0, 0)

					UICorner_3.Parent = notificationcontainer

					Listing.Name = "Listing"
					Listing.Parent = notificationcontainer
					Listing.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
					Listing.BackgroundTransparency = 1.000
					Listing.BorderColor3 = Color3.fromRGB(43, 43, 41)
					Listing.BorderSizePixel = 0
					Listing.Position = UDim2.new(0.21212545, 0, 0.240000233, 0)
					Listing.Size = UDim2.new(0, 189, 0, 35)

					UIListLayout_2.Parent = Listing
					UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
					UIListLayout_2.Padding = UDim.new(0, 2)

					LabelMainText.Name = "LabelMainText"
					LabelMainText.Parent = Listing
					LabelMainText.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
					LabelMainText.BackgroundTransparency = 1.000
					LabelMainText.BorderColor3 = Color3.fromRGB(43, 43, 41)
					LabelMainText.BorderSizePixel = 0
					LabelMainText.Position = UDim2.new(0.0331491716, 0, -3.97142863, 0)
					LabelMainText.Size = UDim2.new(0, 232, 0, 17)
					LabelMainText.Font = Enum.Font.GothamBold
					LabelMainText.Text = tostring(notificatioN.Title)
					LabelMainText.TextColor3 = Color3.fromRGB(231, 231, 231)
					LabelMainText.TextSize = 15.000
					LabelMainText.TextStrokeColor3 = Color3.fromRGB(231, 231, 231)
					LabelMainText.TextXAlignment = Enum.TextXAlignment.Left

					LabelText.Name = "LabelText"
					LabelText.Parent = Listing
					LabelText.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
					LabelText.BackgroundTransparency = 1.000
					LabelText.BorderColor3 = Color3.fromRGB(43, 43, 41)
					LabelText.BorderSizePixel = 0
					LabelText.Position = UDim2.new(0.104972377, 0, -2.28571439, 0)
					LabelText.Size = UDim2.new(0, 232, 0, 17)
					LabelText.Font = Enum.Font.Gotham
					LabelText.Text = tostring(notificatioN.Description)
					LabelText.TextColor3 = Color3.fromRGB(171, 171, 170)
					LabelText.TextSize = 15.000
					LabelText.TextStrokeColor3 = Color3.fromRGB(171, 171, 170)
					LabelText.TextXAlignment = Enum.TextXAlignment.Left
					LabelText.TextYAlignment = Enum.TextYAlignment.Top
					LabelText.TextWrapped = true

					IconFrame.Name = "IconFrame"
					IconFrame.Parent = notificationcontainer
					IconFrame.BackgroundColor3 = Color3.fromRGB(155, 135, 255)
					IconFrame.BorderColor3 = Color3.fromRGB(155, 135, 255)
					IconFrame.Position = UDim2.new(0.0419999994, 0, 0.162, 0)
					IconFrame.Size = UDim2.new(0, 41, 0, 41)

					UICorner_4.Parent = IconFrame

					Icon.Name = "Icon"
					Icon.Parent = IconFrame
					Icon.BackgroundColor3 = Color3.fromRGB(155, 135, 255)
					Icon.BackgroundTransparency = 1.000
					Icon.BorderColor3 = Color3.fromRGB(155, 135, 255)
					Icon.Position = UDim2.new(0.159, 0, 0.18, 0)
					Icon.Size = UDim2.new(0, 26, 0, 26)
					Icon.Image = "rbxassetid://3926305904"
					Icon.ImageRectOffset = Vector2.new(924, 724)
					Icon.ImageRectSize = Vector2.new(34, 36)

					Shadow.Name = "Shadow"
					Shadow.Parent = IconFrame
					Shadow.Active = true
					Shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Shadow.BackgroundTransparency = 1.000
					Shadow.BorderColor3 = Color3.fromRGB(27, 42, 53)
					Shadow.Position = UDim2.new(0, -15, 0, -15)
					Shadow.Size = UDim2.new(1, 30, 1, 30)
					Shadow.ZIndex = 0
					Shadow.Image = "rbxassetid://5028857084"
					Shadow.ImageColor3 = Color3.fromRGB(155, 135, 255)
					Shadow.ImageTransparency = 0.700
					Shadow.ScaleType = Enum.ScaleType.Slice
					Shadow.SliceCenter = Rect.new(24, 24, 276, 276)

					Blur.Name = "Blur"
					Blur.Parent = notificationcontainer
					Blur.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Blur.BackgroundTransparency = 0.9
					Blur.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Blur.BorderSizePixel = 0
					Blur.Position = UDim2.new(0, 0, 0, 0)
					Blur.Size = UDim2.new(0, 287, 0, 61)
					Blur.Image = "rbxassetid://82777277344027"
					Blur.ImageTransparency = 0.900

					if animation == true then
						Blur.Visible = true
					else
						Blur.Visible = false
					end

					UIGradient.Color =
						ColorSequence.new {
							ColorSequenceKeypoint.new(0.00, Color3.fromRGB(29, 29, 29)),
							ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))
						}
					UIGradient.Rotation = -360
					UIGradient.Parent = Blur

					BlurCorner.Parent = Blur
					Selector = notificatioN.Selection
					if Selector == "Done" then
						Icon.Image = "rbxassetid://3926305904"
						Icon.ImageRectOffset = Vector2.new(644, 204)
						Icon.ImageRectSize = Vector2.new(36, 36)
						IconFrame.BackgroundColor3 = Color3.fromRGB(7, 197, 90)
						NotificationType = "Done"
					elseif Selector == "Error" or Selector == "Err" then
						Icon.Image = "rbxassetid://3926305904"
						Icon.ImageRectOffset = Vector2.new(924, 724)
						Icon.ImageRectSize = Vector2.new(34, 36)
						IconFrame.BackgroundColor3 = Color3.fromRGB(255, 96, 96)
						NotificationType = "Error"
					elseif Selector == "Warning" or Selector == "Warn" then
						Icon.Image = "rbxassetid://163905183"
						Icon.ImageRectOffset = Vector2.new(0, 0)
						Icon.ImageRectSize = Vector2.new(0, 0)
						IconFrame.BackgroundColor3 = Color3.fromRGB(255, 140, 24)
						NotificationType = "Warn"
					elseif Selector == "Notification" or Selector == "Notify" then
						Icon.Image = "rbxassetid://7021995683"
						Icon.ImageRectOffset = Vector2.new(0, 0)
						Icon.ImageRectSize = Vector2.new(0, 0)
						IconFrame.BackgroundColor3 = Color3.fromRGB(155, 135, 255)
						NotificationType = "Notification"
					end

					if Description <= 32 then
						notification.Size = UDim2.new(0, 287, 0, 61)
						notificationcontainer.Size = UDim2.new(0, 287, 0, 61)
						Listing.Size = UDim2.new(0, 189, 0, 35)
						Listing.Position = UDim2.new(0.212, 0, 0.24, 0)
						IconFrame.Position = UDim2.new(0.042, 0, 0.162, 0)
						LabelText.Size = UDim2.new(0, 232, 0, 17)
						Blur.Size = UDim2.new(0, 287, 0, 61)
					elseif Description > 32 and Description <= 89 then
						notification.Size = UDim2.new(0, 287, 0, 91)
						notificationcontainer.Size = UDim2.new(0, 287, 0, 91)
						Listing.Size = UDim2.new(0, 189, 0, 74)
						Listing.Position = UDim2.new(0.212, 0, 0.086, 0)
						IconFrame.Position = UDim2.new(0.045, 0, 0.272, 0)
						LabelText.Size = UDim2.new(0, 219, 0, 57)
						Blur.Size = UDim2.new(0, 287, 0, 91)
					elseif Description > 89 and Description <= 155 then
						notification.Size = UDim2.new(0, 287, 0, 136)
						notificationcontainer.Size = UDim2.new(0, 287, 0, 136)
						Listing.Size = UDim2.new(0, 218, 0, 116)
						Listing.Position = UDim2.new(0.212, 0, 0.086, 0)
						IconFrame.Position = UDim2.new(0.042, 0, 0.338, 0)
						LabelText.Size = UDim2.new(0, 219, 0, 57)
						Blur.Size = UDim2.new(0, 287, 0, 136)
					elseif Description > 155 and Description <= 243 then
						notification.Size = UDim2.new(0, 287, 0, 188)
						notificationcontainer.Size = UDim2.new(0, 287, 0, 188)
						Listing.Size = UDim2.new(0, 218, 0, 164)
						Listing.Position = UDim2.new(0.212, 0, 0.086, 0)
						IconFrame.Position = UDim2.new(0.039, 0, 0.386, 0)
						LabelText.Size = UDim2.new(0, 219, 0, 57)
						Blur.Size = UDim2.new(0, 219, 0, 145)
					elseif Description > 243 then
						notification.Size = UDim2.new(0, 287, 0, 188)
						notificationcontainer.Size = UDim2.new(0, 287, 0, 188)
						Listing.Size = UDim2.new(0, 218, 0, 164)
						Listing.Position = UDim2.new(0.212, 0, 0.086, 0)
						IconFrame.Position = UDim2.new(0.039, 0, 0.386, 0)
						LabelText.Size = UDim2.new(0, 219, 0, 57)
						Blur.Size = UDim2.new(0, 219, 0, 145)
						LabelText.TextScaled = true
					end

					TweenService:Create(
						notificationcontainer,
						TweenInfo.new(1.5, Enum.EasingStyle.Quad),
						{Position = UDim2.new(0, 0, 0, 0)}
					):Play()
					repeat
						wait()
					until notificationcontainer.Position == UDim2.new(0, 0, 0, 0)
					if NotificationType == "Notification" then
						TweenService:Create(Icon, TweenInfo.new(1.5, Enum.EasingStyle.Quad), {Rotation = 70}):Play()
						wait(0.4)
						TweenService:Create(Icon, TweenInfo.new(1.5, Enum.EasingStyle.Quad), {Rotation = -70}):Play()
						wait(0.4)
						TweenService:Create(Icon, TweenInfo.new(1.5, Enum.EasingStyle.Quad), {Rotation = 0}):Play()
					elseif NotificationType == "Warn" then
						Icon.ImageTransparency = 1
						TweenService:Create(Icon, TweenInfo.new(1.5, Enum.EasingStyle.Quad), {ImageTransparency = 0}):Play(

						)
					end
					wait(tonumber(notificatioN.Cooldown))
					TweenService:Create(
						notificationcontainer,
						TweenInfo.new(1.8, Enum.EasingStyle.Linear),
						{Position = UDim2.new(15, 0, 0, 0)}
					):Play()
					repeat
						wait()
					until notificationcontainer.Position == UDim2.new(15, 0, 0, 0)
					notification:Destroy()
					animation = false

					while animation == true do
						wait()
						TweenService:Create(
							UIGradient,
							TweenInfo.new(1.5, Enum.EasingStyle.Quad),
							{Rotation = UIGradient.Rotation + 90}
						):Play()
					end
				end
			)
		end

		function NotificationItems:Notify(NotiFY)
			task.spawn(
				function()
					local Description = #NotiFY.Description

					callback = NotiFY.Callback or function()
					end

					local animation = NotiFY.Animated
					local NotifyType = "Notification"
					local notify = Instance.new("Frame")
					local notifycontainer = Instance.new("Frame")
					local UICorner_2 = Instance.new("UICorner")
					local Listing = Instance.new("Frame")
					local UIListLayout_2 = Instance.new("UIListLayout")
					local LabelMainText = Instance.new("TextLabel")
					local LabelText = Instance.new("TextLabel")
					local IconFrame = Instance.new("Frame")
					local UICorner_3 = Instance.new("UICorner")
					local Shadow = Instance.new("ImageLabel")
					local Icon = Instance.new("ImageLabel")
					local clear = Instance.new("ImageButton")
					local done = Instance.new("ImageButton")
					local UICorner_8 = Instance.new("UICorner")
					local Blur = Instance.new("ImageLabel")
					local UIGradient = Instance.new("UIGradient")
					local BlurCorner = Instance.new("UICorner")

					notify.Name = "notify"
					notify.Parent = NotifyListing
					notify.BackgroundColor3 = Color3.fromRGB(42, 44, 42)
					notify.BackgroundTransparency = 1.000
					notify.BorderColor3 = Color3.fromRGB(42, 44, 42)
					notify.BorderSizePixel = 0
					notify.Position = UDim2.new(-4, 0, 0, 0)
					notify.Size = UDim2.new(0, 287, 0, 61)

					notifycontainer.Name = "notifycontainer"
					notifycontainer.Parent = notify
					notifycontainer.BackgroundColor3 = Color3.fromRGB(42, 44, 42)
					notifycontainer.BackgroundTransparency = 0.200
					notifycontainer.BorderColor3 = Color3.fromRGB(42, 44, 42)
					notifycontainer.BorderSizePixel = 0
					notifycontainer.Size = UDim2.new(0, 287, 0, 61)

					UICorner_2.Parent = notifycontainer

					Listing.Name = "Listing"
					Listing.Parent = notifycontainer
					Listing.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
					Listing.BackgroundTransparency = 1.000
					Listing.BorderColor3 = Color3.fromRGB(43, 43, 41)
					Listing.BorderSizePixel = 0
					Listing.Position = UDim2.new(0.21212545, 0, 0.240000233, 0)
					Listing.Size = UDim2.new(0, 189, 0, 35)

					UIListLayout_2.Parent = Listing
					UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
					UIListLayout_2.Padding = UDim.new(0, 2)

					LabelMainText.Name = "LabelMainText"
					LabelMainText.Parent = Listing
					LabelMainText.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
					LabelMainText.BackgroundTransparency = 1.000
					LabelMainText.BorderColor3 = Color3.fromRGB(43, 43, 41)
					LabelMainText.BorderSizePixel = 0
					LabelMainText.Position = UDim2.new(-0.161290318, 0, 0.4375, 0)
					LabelMainText.Size = UDim2.new(0, 232, 0, 17)
					LabelMainText.Font = Enum.Font.GothamBold
					LabelMainText.Text = tostring(NotiFY.Title)
					LabelMainText.TextColor3 = Color3.fromRGB(231, 231, 231)
					LabelMainText.TextSize = 15.000
					LabelMainText.TextXAlignment = Enum.TextXAlignment.Left

					LabelText.Name = "LabelText"
					LabelText.Parent = Listing
					LabelText.BackgroundColor3 = Color3.fromRGB(43, 43, 41)
					LabelText.BackgroundTransparency = 1.000
					LabelText.BorderColor3 = Color3.fromRGB(43, 43, 41)
					LabelText.BorderSizePixel = 0
					LabelText.Position = UDim2.new(0, 0, 0.485714287, 0)
					LabelText.Size = UDim2.new(0, 162, 0, 20)
					LabelText.Font = Enum.Font.Gotham
					LabelText.Text = tostring(NotiFY.Description)
					LabelText.TextColor3 = Color3.fromRGB(171, 171, 170)
					LabelText.TextSize = 15.000
					LabelText.TextXAlignment = Enum.TextXAlignment.Left
					LabelText.TextWrapped = true
					LabelText.TextYAlignment = Enum.TextYAlignment.Top

					IconFrame.Name = "IconFrame"
					IconFrame.Parent = notifycontainer
					IconFrame.BackgroundColor3 = Color3.fromRGB(155, 135, 255)
					IconFrame.Position = UDim2.new(0.0421351716, 0, 0.161546558, 0)
					IconFrame.Size = UDim2.new(0, 41, 0, 41)

					UICorner_3.Parent = IconFrame

					Shadow.Name = "Shadow"
					Shadow.Parent = IconFrame
					Shadow.Active = true
					Shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Shadow.BackgroundTransparency = 1.000
					Shadow.BorderColor3 = Color3.fromRGB(27, 42, 53)
					Shadow.Position = UDim2.new(0, -15, 0, -15)
					Shadow.Size = UDim2.new(1, 30, 1, 30)
					Shadow.ZIndex = 0
					Shadow.Image = "rbxassetid://5028857084"
					Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
					Shadow.ScaleType = Enum.ScaleType.Slice
					Shadow.SliceCenter = Rect.new(24, 24, 276, 276)

					Icon.Name = "Icon"
					Icon.Parent = IconFrame
					Icon.BackgroundColor3 = Color3.fromRGB(155, 135, 255)
					Icon.BackgroundTransparency = 1.000
					Icon.BorderColor3 = Color3.fromRGB(155, 135, 255)
					Icon.Position = UDim2.new(0.159283891, 0, 0.179691225, 0)
					Icon.Rotation = 0
					Icon.Size = UDim2.new(0, 26, 0, 26)
					Icon.Image = "http://www.roblox.com/asset/?id=7021995683"

					clear.Name = "clear"
					clear.Parent = notifycontainer
					clear.BackgroundTransparency = 1.000
					clear.BorderColor3 = Color3.fromRGB(27, 42, 53)
					clear.LayoutOrder = 5
					clear.Size = UDim2.new(0, 19, 0, 19)
					clear.ZIndex = 2
					clear.Image = "rbxassetid://3926305904"
					clear.ImageColor3 = Color3.fromRGB(252, 250, 255)
					clear.ImageRectOffset = Vector2.new(924, 724)
					clear.ImageRectSize = Vector2.new(36, 36)

					done.Name = "done"
					done.Parent = notifycontainer
					done.BackgroundTransparency = 1.000
					done.BorderColor3 = Color3.fromRGB(27, 42, 53)
					done.LayoutOrder = 1
					done.Size = UDim2.new(0, 19, 0, 19)
					done.ZIndex = 2
					done.Image = "rbxassetid://3926305904"
					done.ImageColor3 = Color3.fromRGB(252, 250, 255)
					done.ImageRectOffset = Vector2.new(644, 204)
					done.ImageRectSize = Vector2.new(36, 36)

					UICorner_8.Parent = notify

					Blur.Name = "Blur"
					Blur.Parent = notifycontainer
					Blur.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Blur.BackgroundTransparency = 0.9
					Blur.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Blur.BorderSizePixel = 0
					Blur.Position = UDim2.new(0, 0, 0, 0)
					Blur.Size = UDim2.new(0, 287, 0, 61)
					Blur.Image = "rbxassetid://82777277344027"
					Blur.ImageTransparency = 0.900

					UIGradient.Color =
						ColorSequence.new {
							ColorSequenceKeypoint.new(0.00, Color3.fromRGB(29, 29, 29)),
							ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))
						}
					UIGradient.Rotation = -360
					UIGradient.Parent = Blur

					BlurCorner.Parent = Blur

					if animation == true then
						Blur.Visible = true
					else
						Blur.Visible = false
					end

					if Description <= 32 then
						notify.Size = UDim2.new(0, 287, 0, 61)
						notifycontainer.Size = UDim2.new(0, 287, 0, 61)
						Listing.Size = UDim2.new(0, 189, 0, 35)
						Listing.Position = UDim2.new(0.212, 0, 0.24, 0)
						IconFrame.Position = UDim2.new(0.042, 0, 0.162, 0)
						LabelText.Size = UDim2.new(0, 182, 0, 17)
						Blur.Size = UDim2.new(0, 287, 0, 61)
						done.Position = UDim2.new(0.886262596, 0, 0.174426973, 0)
						clear.Position = UDim2.new(0.886262715, 0, 0.539350688, 0)
					elseif Description > 32 and Description <= 89 then
						notify.Size = UDim2.new(0, 287, 0, 91)
						notifycontainer.Size = UDim2.new(0, 287, 0, 91)
						Listing.Size = UDim2.new(0, 189, 0, 74)
						Listing.Position = UDim2.new(0.212, 0, 0.086, 0)
						IconFrame.Position = UDim2.new(0.045, 0, 0.272, 0)
						LabelText.Size = UDim2.new(0, 182, 0, 57)
						Blur.Size = UDim2.new(0, 287, 0, 91)
						done.Position = UDim2.new(0.886, 0, 0.141, 0)
						clear.Position = UDim2.new(0.886, 0, 0.605, 0)
					elseif Description > 89 and Description <= 155 then
						notify.Size = UDim2.new(0, 287, 0, 136)
						notifycontainer.Size = UDim2.new(0, 287, 0, 136)
						Listing.Size = UDim2.new(0, 218, 0, 116)
						Listing.Position = UDim2.new(0.212, 0, 0.086, 0)
						IconFrame.Position = UDim2.new(0.042, 0, 0.338, 0)
						LabelText.Size = UDim2.new(0, 182, 0, 57)
						Blur.Size = UDim2.new(0, 287, 0, 136)
						done.Position = UDim2.new(0.886, 0, 0.094, 0)
						clear.Position = UDim2.new(0.886, 0, 0.753, 0)
					elseif Description > 155 and Description <= 243 then
						notify.Size = UDim2.new(0, 287, 0, 188)
						notifycontainer.Size = UDim2.new(0, 287, 0, 188)
						Listing.Size = UDim2.new(0, 218, 0, 164)
						Listing.Position = UDim2.new(0.212, 0, 0.086, 0)
						IconFrame.Position = UDim2.new(0.039, 0, 0.386, 0)
						LabelText.Size = UDim2.new(0, 182, 0, 57)
						Blur.Size = UDim2.new(0, 219, 0, 145)
						done.Position = UDim2.new(0.886, 0, 0.057, 0)
						clear.Position = UDim2.new(0.886, 0, 0.853, 0)
					elseif Description > 243 then
						notify.Size = UDim2.new(0, 287, 0, 188)
						notifycontainer.Size = UDim2.new(0, 287, 0, 188)
						Listing.Size = UDim2.new(0, 218, 0, 164)
						Listing.Position = UDim2.new(0.212, 0, 0.086, 0)
						IconFrame.Position = UDim2.new(0.039, 0, 0.386, 0)
						LabelText.Size = UDim2.new(0, 182, 0, 57)
						Blur.Size = UDim2.new(0, 219, 0, 145)
						done.Position = UDim2.new(0.886, 0, 0.057, 0)
						clear.Position = UDim2.new(0.886, 0, 0.853, 0)
						LabelText.TextScaled = true
					end

					local x =
						RunService.RenderStepped:Connect(
							function()
								wait()
								if animation == true then
									TweenService:Create(
										UIGradient,
										TweenInfo.new(1.5, Enum.EasingStyle.Quad),
										{Rotation = UIGradient.Rotation + 90}
									):Play()
								end
							end
						)

					clear.MouseButton1Click:Connect(
						function()
							animation = false
							TweenService:Create(
								notifycontainer,
								TweenInfo.new(2, Enum.EasingStyle.Linear),
								{Position = UDim2.new(-4, 0, 0, 0)}
							):Play()
							x:Disconnect()
							wait(2)
							notify:Destroy()
						end
					)

					done.MouseButton1Click:Connect(
						function()
							animation = false
							for i, v in pairs(notify:GetDescendants()) do
								if v:IsA("Frame") then
									TweenService:Create(
										v,
										TweenInfo.new(.2, Enum.EasingStyle.Linear),
										{BackgroundTransparency = 1}
									):Play()
								elseif v:IsA("UIStroke") then
									TweenService:Create(
										v,
										TweenInfo.new(.2, Enum.EasingStyle.Linear),
										{Transparency = 1}
									):Play()
								elseif v:IsA("TextLabel") then
									TweenService:Create(
										v,
										TweenInfo.new(.2, Enum.EasingStyle.Linear),
										{TextTransparency = 1}
									):Play()
								elseif v:IsA("ImageButton") then
									TweenService:Create(
										v,
										TweenInfo.new(.2, Enum.EasingStyle.Linear),
										{ImageTransparency = 1}
									):Play()
								elseif v:IsA("ImageLabel") then
									TweenService:Create(
										v,
										TweenInfo.new(.2, Enum.EasingStyle.Linear),
										{ImageTransparency = 1}
									):Play()
								end
							end
							TweenService:Create(
								notify,
								TweenInfo.new(.2, Enum.EasingStyle.Linear),
								{BackgroundTransparency = 1}
							):Play()
							x:Disconnect()
							wait(0.2)
							notify:Destroy()
							pcall(callback)
						end
					)
					Selector = NotiFY.Selection
					if Selector == "Done" then
						Icon.Image = "rbxassetid://3926305904"
						Icon.ImageRectOffset = Vector2.new(644, 204)
						Icon.ImageRectSize = Vector2.new(36, 36)
						IconFrame.BackgroundColor3 = Color3.fromRGB(7, 197, 90)
						NotifyType = "Done"
					elseif Selector == "Error" or Selector == "Err" then
						Icon.Image = "rbxassetid://3926305904"
						Icon.ImageRectOffset = Vector2.new(924, 724)
						Icon.ImageRectSize = Vector2.new(34, 36)
						IconFrame.BackgroundColor3 = Color3.fromRGB(255, 96, 96)
						NotifyType = "Error"
					elseif Selector == "Warning" or Selector == "Warn" then
						Icon.Image = "rbxassetid://163905183"
						Icon.ImageRectOffset = Vector2.new(0, 0)
						Icon.ImageRectSize = Vector2.new(0, 0)
						IconFrame.BackgroundColor3 = Color3.fromRGB(255, 140, 24)
						NotifyType = "Warn"
					elseif Selector == "Notification" or Selector == "Notify" then
						Icon.Image = "rbxassetid://7021995683"
						Icon.ImageRectOffset = Vector2.new(0, 0)
						Icon.ImageRectSize = Vector2.new(0, 0)
						IconFrame.BackgroundColor3 = Color3.fromRGB(155, 135, 255)
						NotifyType = "Notification"
					end

					TweenService:Create(
						notifycontainer,
						TweenInfo.new(1.5, Enum.EasingStyle.Quad),
						{Position = UDim2.new(0, 0, 0, 0)}
					):Play()
				end
			)
		end

		function NotificationItems:CreateNotification(anan)
			local gamenotificationended = true
			for i, v in pairs(LibParent:GetDescendants()) do
				if v.Name == "GameNotification" then
					v:Destroy()
				end
			end
			local imag
			local titil
			local minititil
			local desc
			local op1
			local op2
			local yestext
			local yescallback
			local notext
			local nocallback
			for i, v in pairs(anan) do
				if i == "ImageId" then
					imag = v
				elseif i == "Title" then
					titil = v
				elseif i == "MiniTitle" then
					minititil = v
				elseif i == "Description" then
					desc = v
				elseif i == "Option1" then
					for _, q in next, v do
						if _ == "Text" then
							yestext = q
						elseif _ == "Callback" then
							yescallback = q
						end
					end
				elseif i == "Option2" then
					for _, q in next, v do
						if _ == "Text" then
							notext = q
						elseif _ == "Callback" then
							nocallback = q
						end
					end
				end
			end

			local Main = Instance.new("Frame")
			local UICornerGam = Instance.new("UICorner")
			local TitleBar = Instance.new("Frame")
			local UICorner_2 = Instance.new("UICorner")
			local Title = Instance.new("TextLabel")
			local Logo = Instance.new("ImageLabel")
			local UICorner_4 = Instance.new("UICorner")
			local Page = Instance.new("Frame")
			local UICorner_5 = Instance.new("UICorner")
			local Showercase = Instance.new("TextLabel")
			local UICorner_6 = Instance.new("UICorner")
			local MiniTitle = Instance.new("TextLabel")
			local UICorner_7 = Instance.new("UICorner")
			local YesFrame = Instance.new("Frame")
			local Yes = Instance.new("TextButton")
			local UICorner_8 = Instance.new("UICorner")
			local UICorner_9 = Instance.new("UICorner")
			local UIGradient = Instance.new("UIGradient")
			local NoFrame = Instance.new("Frame")
			local UICorner_10 = Instance.new("UICorner")
			local No = Instance.new("TextButton")
			local UICorner_11 = Instance.new("UICorner")
			local UICorner_12 = Instance.new("UICorner")
			local UIGradient_2 = Instance.new("UIGradient")
			local UIGradient_3 = Instance.new("UIGradient")
			local Shadow = Instance.new("ImageLabel")
			local UIStroke = Instance.new("UIStroke")
			local UIStroke2 = Instance.new("UIStroke")

			Main.Name = "GameNotification"
			Main.Parent = HawkNotifications
			Main.Active = true
			Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Main.BackgroundTransparency = 1.000
			Main.BorderColor3 = Color3.fromRGB(27, 27, 27)
			Main.Position = UDim2.new(0.5, -183, 0.03, 0)
			Main.Size = UDim2.new(0, 7, 0, 54)
			Main.Visible = false

			UICornerGam.CornerRadius = UDim.new(0, 5)
			UICornerGam.Parent = Main

			TitleBar.Name = "TitleBar"
			TitleBar.Parent = Main
			TitleBar.BackgroundColor3 = Color3.fromRGB(37, 36, 37)
			TitleBar.BackgroundTransparency = 1.000
			TitleBar.BorderColor3 = Color3.fromRGB(37, 36, 37)
			TitleBar.Size = UDim2.new(0, 366, 0, 54)
			TitleBar.Visible = false

			UICorner.CornerRadius = UDim.new(0, 5)
			UICorner.Parent = TitleBar

			Title.Name = "Title"
			Title.Parent = TitleBar
			Title.Active = true
			Title.BackgroundColor3 = Color3.fromRGB(37, 36, 37)
			Title.BackgroundTransparency = 1.000
			Title.BorderColor3 = Color3.fromRGB(37, 36, 37)
			Title.Position = UDim2.new(0.167, 0, 0.046, 0)
			Title.Size = UDim2.new(0, 164, 0, 48)
			Title.Font = Enum.Font.MontserratMedium
			Title.Text = titil
			Title.TextColor3 = Color3.fromRGB(225, 225, 225)
			Title.TextSize = 14.000
			Title.TextTransparency = 1.000
			Title.TextXAlignment = Enum.TextXAlignment.Left

			UICorner_4.CornerRadius = UDim.new(0, 5)
			UICorner_4.Parent = Title

			Logo.Name = "Logo"
			Logo.Parent = TitleBar
			Logo.BackgroundColor3 = Color3.fromRGB(37, 36, 37)
			Logo.BackgroundTransparency = 1.000
			Logo.BorderColor3 = Color3.fromRGB(37, 36, 37)
			Logo.Position = UDim2.new(0, 0, 0.056, 0)
			Logo.Size = UDim2.new(0, 53, 0, 48)
			Logo.Image = imag
			Logo.ImageTransparency = 1.000

			UICorner_5.CornerRadius = UDim.new(0, 5)
			UICorner_5.Parent = Logo

			Page.Name = "Page"
			Page.Parent = Main
			Page.BackgroundColor3 = Color3.fromRGB(37, 36, 37)
			Page.BackgroundTransparency = 1.000
			Page.BorderColor3 = Color3.fromRGB(37, 36, 37)
			Page.Position = UDim2.new(0, 0, 0.298, 0)
			Page.Size = UDim2.new(0, 366, 0, 127)
			Page.Visible = false

			UICorner_6.CornerRadius = UDim.new(0, 5)
			UICorner_6.Parent = Page

			Showercase.Name = "Showercase"
			Showercase.Parent = Page
			Showercase.BackgroundColor3 = Color3.fromRGB(37, 36, 37)
			Showercase.BackgroundTransparency = 1.000
			Showercase.BorderColor3 = Color3.fromRGB(37, 36, 37)
			Showercase.Position = UDim2.new(0.055, 0, 0.209, 0)
			Showercase.Size = UDim2.new(0, 332, 0, 48)
			Showercase.Font = Enum.Font.Montserrat
			Showercase.Text = desc
			Showercase.TextColor3 = Color3.fromRGB(208, 208, 208)
			Showercase.TextSize = 16
			Showercase.TextTransparency = 1.000
			Showercase.TextWrapped = true
			Showercase.TextXAlignment = Enum.TextXAlignment.Left
			Showercase.TextYAlignment = Enum.TextYAlignment.Top
			Showercase.TextWrapped = true

			UICorner_7.CornerRadius = UDim.new(0, 5)
			UICorner_7.Parent = Showercase

			MiniTitle.Name = "MiniTitle"
			MiniTitle.Parent = Page
			MiniTitle.Active = true
			MiniTitle.BackgroundColor3 = Color3.fromRGB(37, 36, 37)
			MiniTitle.BackgroundTransparency = 1.000
			MiniTitle.BorderColor3 = Color3.fromRGB(37, 36, 37)
			MiniTitle.Position = UDim2.new(0.052, 0, 0.005, 0)
			MiniTitle.Size = UDim2.new(0, 332, 0, 28)
			MiniTitle.Font = Enum.Font.MontserratBold
			MiniTitle.Text = minititil
			MiniTitle.TextColor3 = Color3.fromRGB(225, 225, 225)
			MiniTitle.TextSize = 14.000
			MiniTitle.TextTransparency = 1.000
			MiniTitle.TextXAlignment = Enum.TextXAlignment.Left

			UICorner_8.CornerRadius = UDim.new(0, 5)
			UICorner_8.Parent = MiniTitle

			YesFrame.Name = "YesFrame"
			YesFrame.Parent = Page
			YesFrame.BackgroundColor3 = Color3.fromRGB(1, 68, 50)
			YesFrame.BackgroundTransparency = 1.000
			YesFrame.BorderColor3 = Color3.fromRGB(1, 98, 73)
			YesFrame.Position = UDim2.new(0.035, 0, 0.63, 0)
			YesFrame.Size = UDim2.new(0, 164, 0, 44)

			Yes.Name = "Yes"
			Yes.Parent = YesFrame
			Yes.BackgroundColor3 = Color3.fromRGB(1, 98, 73)
			Yes.BackgroundTransparency = 1.000
			Yes.BorderColor3 = Color3.fromRGB(1, 98, 73)
			Yes.Size = UDim2.new(0, 164, 0, 44)
			Yes.Font = Enum.Font.SourceSansBold
			Yes.Text = yestext
			Yes.TextColor3 = Color3.fromRGB(255, 255, 255)
			Yes.TextSize = 21
			Yes.TextTransparency = 1.000

			UIGradient.Color =
				ColorSequence.new {
					ColorSequenceKeypoint.new(0.00, Color3.fromRGB(54, 54, 54)),
					ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))
				}
			UIGradient.Rotation = 90
			UIGradient.Parent = YesFrame
			UIGradient.Transparency = NumberSequence.new(1)

			UICorner_9.CornerRadius = UDim.new(0, 10)
			UICorner_9.Parent = Yes

			UICorner_10.CornerRadius = UDim.new(0, 10)
			UICorner_10.Parent = YesFrame

			NoFrame.Name = "NoFrame"
			NoFrame.Parent = Page
			NoFrame.BackgroundColor3 = Color3.fromRGB(75, 34, 36)
			NoFrame.BackgroundTransparency = 1.000
			NoFrame.BorderColor3 = Color3.fromRGB(107, 48, 51)
			NoFrame.Position = UDim2.new(0.511071026, 0, 0.63, 0)
			NoFrame.Size = UDim2.new(0, 164, 0, 44)

			UICorner_11.CornerRadius = UDim.new(0, 10)
			UICorner_11.Parent = NoFrame

			No.Name = "No"
			No.Parent = NoFrame
			No.BackgroundColor3 = Color3.fromRGB(107, 48, 51)
			No.BackgroundTransparency = 1.000
			No.BorderColor3 = Color3.fromRGB(107, 48, 51)
			No.Size = UDim2.new(0, 164, 0, 44)
			No.Font = Enum.Font.SourceSansBold
			No.Text = notext
			No.TextColor3 = Color3.fromRGB(255, 255, 255)
			No.TextSize = 21.000
			No.TextTransparency = 1.000

			UICorner_12.CornerRadius = UDim.new(0, 10)
			UICorner_12.Parent = No

			UIGradient_2.Color =
				ColorSequence.new {
					ColorSequenceKeypoint.new(0.00, Color3.fromRGB(54, 54, 54)),
					ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))
				}
			UIGradient_2.Rotation = 90
			UIGradient_2.Parent = NoFrame
			UIGradient_2.Transparency = NumberSequence.new(1)

			UIGradient_3.Color =
				ColorSequence.new {
					ColorSequenceKeypoint.new(0.00, Color3.fromRGB(27, 27, 27)),
					ColorSequenceKeypoint.new(0.83, Color3.fromRGB(27, 27, 27)),
					ColorSequenceKeypoint.new(1.00, Color3.fromRGB(54, 54, 80))
				}
			UIGradient_3.Rotation = 50
			UIGradient_3.Parent = Main
			UIGradient_3.Transparency = NumberSequence.new(1)

			UIStroke.Parent = YesFrame
			UIStroke.Color = Color3.fromRGB(1, 124, 91)
			UIStroke.ApplyStrokeMode = "Border"
			UIStroke.LineJoinMode = "Round"
			UIStroke.Thickness = 1
			UIStroke.Transparency = 1

			UIStroke2.Parent = NoFrame
			UIStroke2.Color = Color3.fromRGB(140, 63, 70)
			UIStroke2.ApplyStrokeMode = "Border"
			UIStroke2.LineJoinMode = "Round"
			UIStroke2.Thickness = 1
			UIStroke2.Transparency = 1

			function Open()
				gamenotificationended = false
				Main.Visible = true
				UIGradient_3.Transparency = NumberSequence.new(0)
				TweenService:Create(
					Main,
					TweenInfo.new(.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{BackgroundTransparency = 0}
				):Play()
				wait(0.4)
				TweenService:Create(
					Main,
					TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{Size = UDim2.new(0, 366, 0, 54)}
				):Play()
				wait(1)
				TweenService:Create(
					Main,
					TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{Size = UDim2.new(0, 366, 0, 195)}
				):Play()
				wait(1)
				TitleBar.Visible = true
				TweenService:Create(
					TitleBar,
					TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{BackgroundTransparency = 0}
				):Play()
				wait(0.4)
				TweenService:Create(
					Logo,
					TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{ImageTransparency = 0}
				):Play()
				wait(0.4)
				TweenService:Create(
					Title,
					TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{TextTransparency = 0}
				):Play()
				wait(0.4)
				Page.Visible = true
				TweenService:Create(
					MiniTitle,
					TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{TextTransparency = 0}
				):Play()
				wait(0.4)
				TweenService:Create(
					Showercase,
					TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{TextTransparency = 0}
				):Play()
				wait(0.4)
				TweenService:Create(
					YesFrame,
					TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{BackgroundTransparency = 0}
				):Play()
				TweenService:Create(
					Yes,
					TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{TextTransparency = 0}
				):Play()
				TweenService:Create(
					UIStroke,
					TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{Transparency = 0}
				):Play()
				UIGradient.Transparency = NumberSequence.new(0)
				wait(0.4)
				TweenService:Create(
					NoFrame,
					TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{BackgroundTransparency = 0}
				):Play()
				TweenService:Create(
					No,
					TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{TextTransparency = 0}
				):Play()
				TweenService:Create(
					UIStroke2,
					TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{Transparency = 0}
				):Play()
				UIGradient_2.Transparency = NumberSequence.new(0)
				wait(1)
				gamenotificationended = true
			end

			function Close()
				if gamenotificationended == false then
					return
				end
				for i, v in next, Main:GetDescendants() do
					if v:IsA("Frame") then
						TweenService:Create(
							v,
							TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
							{BackgroundTransparency = 1}
						):Play()
					elseif v:IsA("TextLabel") then
						TweenService:Create(
							v,
							TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
							{BackgroundTransparency = 1}
						):Play()
						TweenService:Create(
							v,
							TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
							{TextTransparency = 1}
						):Play()
					elseif v:IsA("TextButton") then
						TweenService:Create(
							v,
							TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
							{BackgroundTransparency = 1}
						):Play()
						TweenService:Create(
							v,
							TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
							{TextTransparency = 1}
						):Play()
					elseif v:IsA("UIStroke") then
						TweenService:Create(
							v,
							TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
							{Transparency = 1}
						):Play()
					elseif v:IsA("ImageLabel") then
						TweenService:Create(
							v,
							TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
							{ImageTransparency = 1}
						):Play()
					elseif v:IsA("ImageButton") then
						TweenService:Create(
							v,
							TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
							{ImageTransparency = 1}
						):Play()
					end
				end
				TweenService:Create(
					Main,
					TweenInfo.new(.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{BackgroundTransparency = 1}
				):Play()
			end

			Yes.MouseButton1Click:Connect(
				function()
					Close()
					wait(0.1)
					for i, v in pairs(LibParent:GetDescendants()) do
						if v.Name == "Main" and v:FindFirstChild("NoFrame") then
							v:Destroy()
						end
					end
					pcall(yescallback)
				end
			)

			No.MouseButton1Click:Connect(
				function()
					Close()
					wait(0.1)
					for i, v in pairs(LibParent:GetDescendants()) do
						if v.Name == "Main" and v:FindFirstChild("NoFrame") then
							v:Destroy()
						end
					end
					pcall(nocallback)
				end
			)

			Open()
		end

		return NotificationItems
	end
end

return HawkLib
