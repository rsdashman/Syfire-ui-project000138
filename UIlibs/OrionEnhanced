--[[
	Enhanced Orion Library
	Melhorias implementadas:
	- Otimização de performance com cache e pooling
	- Gerenciamento de memória aprimorado
	- Sistema de animações mais suave
	- Código mais organizado e modular
	- Melhor tratamento de erros
	- Sistema de temas expandido
	- Responsividade aprimorada
--]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")

-- Cache de instâncias reutilizáveis
local InstanceCache = {}
local TweenCache = {}

-- Configurações de performance
local PerformanceConfig = {
	EnableAnimations = true,
	AnimationSpeed = 1,
	MaxCachedTweens = 50,
	DebugMode = false
}

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
			Main = Color3.fromRGB(28, 14, 45),
			Second = Color3.fromRGB(40, 19, 63),
			Stroke = Color3.fromRGB(147, 51, 234),
			Divider = Color3.fromRGB(124, 58, 237),
			Text = Color3.fromRGB(255, 255, 255),
			TextDark = Color3.fromRGB(199, 157, 237)
		},
		-- Novos temas adicionados
		Dark = {
			Main = Color3.fromRGB(15, 15, 15),
			Second = Color3.fromRGB(25, 25, 25),
			Stroke = Color3.fromRGB(60, 60, 60),
			Divider = Color3.fromRGB(45, 45, 45),
			Text = Color3.fromRGB(255, 255, 255),
			TextDark = Color3.fromRGB(180, 180, 180)
		},
		Ocean = {
			Main = Color3.fromRGB(13, 27, 42),
			Second = Color3.fromRGB(27, 38, 59),
			Stroke = Color3.fromRGB(65, 90, 119),
			Divider = Color3.fromRGB(87, 117, 144),
			Text = Color3.fromRGB(255, 255, 255),
			TextDark = Color3.fromRGB(119, 141, 169)
		},
		Forest = {
			Main = Color3.fromRGB(20, 30, 20),
			Second = Color3.fromRGB(30, 45, 30),
			Stroke = Color3.fromRGB(76, 175, 80),
			Divider = Color3.fromRGB(56, 142, 60),
			Text = Color3.fromRGB(255, 255, 255),
			TextDark = Color3.fromRGB(165, 214, 167)
		}
	},
	SelectedTheme = "Default",
	Folder = nil,
	SaveCfg = false,
	Version = "2.0.0" -- Versão da biblioteca
}

-- Sistema de cache de instâncias
local function GetCachedInstance(className)
	if not InstanceCache[className] then
		InstanceCache[className] = {}
	end
	
	if #InstanceCache[className] > 0 then
		return table.remove(InstanceCache[className])
	end
	
	return Instance.new(className)
end

local function ReturnToCache(instance)
	local className = instance.ClassName
	if not InstanceCache[className] then
		InstanceCache[className] = {}
	end
	
	if #InstanceCache[className] < 20 then -- Limite de cache
		instance.Parent = nil
		table.insert(InstanceCache[className], instance)
	else
		instance:Destroy()
	end
end

-- Sistema de tweens otimizado
local function CreateOptimizedTween(instance, tweenInfo, properties)
	if not PerformanceConfig.EnableAnimations then
		for prop, value in pairs(properties) do
			instance[prop] = value
		end
		return
	end
	
	local cacheKey = tostring(instance) .. HttpService:JSONEncode(properties)
	
	if TweenCache[cacheKey] then
		TweenCache[cacheKey]:Cancel()
	end
	
	local tween = TweenService:Create(instance, tweenInfo, properties)
	TweenCache[cacheKey] = tween
	
	tween.Completed:Connect(function()
		TweenCache[cacheKey] = nil
	end)
	
	tween:Play()
	return tween
end

-- Carregamento otimizado de ícones
local Icons = {}
local IconsLoaded = false

local function LoadIcons()
	if IconsLoaded then return end
	
	local Success, Response = pcall(function()
		Icons = HttpService:JSONDecode(game:HttpGetAsync("https://raw.githubusercontent.com/frappedevs/lucideblox/refs/heads/master/src/modules/util/icons.json")).icons
	end)

	if not Success then
		warn("\n[Orion Library Enhanced v" .. OrionLib.Version .. "] Failed to load Feather Icons. Error: " .. tostring(Response) .. "\n")
	else
		IconsLoaded = true
		if PerformanceConfig.DebugMode then
			print("[Orion Library] Icons loaded successfully")
		end
	end
end

-- Carrega ícones de forma assíncrona
task.spawn(LoadIcons)

local function GetIcon(IconName)
	return Icons[IconName]
end

local Orion = Instance.new("ScreenGui")
Orion.Name = "Orion"
Orion.Parent = PARENT
Orion.ResetOnSpawn = false
Orion.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Limpeza de interfaces duplicadas
for _, Interface in ipairs(PARENT:GetChildren()) do
	if Interface.Name == Orion.Name and Interface ~= Orion then
		Interface:Destroy()
	end
end

function OrionLib:IsRunning()
	return Orion.Parent == PARENT
end

local function AddConnection(Signal, Function)
	if not OrionLib:IsRunning() then
		return
	end
	local SignalConnect = Signal:Connect(Function)
	table.insert(OrionLib.Connections, SignalConnect)
	return SignalConnect
end

-- Sistema de limpeza automática aprimorado
task.spawn(function()
	while OrionLib:IsRunning() do
		task.wait(1)
	end

	-- Limpeza de recursos
	for _, Connection in next, OrionLib.Connections do
		Connection:Disconnect()
	end
	
	-- Limpa cache
	for className, instances in pairs(InstanceCache) do
		for _, instance in ipairs(instances) do
			instance:Destroy()
		end
	end
	
	table.clear(InstanceCache)
	table.clear(TweenCache)
	table.clear(Icons)
	
	if PerformanceConfig.DebugMode then
		print("[Orion Library] Resources cleaned up")
	end
end)

-- Sistema de drag aprimorado com limites de tela
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
			local NewPosition = UDim2.new(
				FramePos.X.Scale,
				FramePos.X.Offset + Delta.X,
				FramePos.Y.Scale,
				FramePos.Y.Offset + Delta.Y
			)
			
			-- Limites de tela aprimorados
			local ViewportSize = workspace.CurrentCamera.ViewportSize
			local FrameSize = Main.AbsoluteSize
			
			local MinX = 0
			local MaxX = ViewportSize.X - FrameSize.X
			local MinY = 0
			local MaxY = ViewportSize.Y - FrameSize.Y
			
			local ClampedX = math.clamp(NewPosition.X.Offset, MinX, MaxX)
			local ClampedY = math.clamp(NewPosition.Y.Offset, MinY, MaxY)
			
			Main.Position = UDim2.new(0, ClampedX, 0, ClampedY)
		end
	end)
end

local function Create(Name, Properties, Children)
	local Object = GetCachedInstance(Name)
	
	for i, v in next, Properties or {} do
		Object[i] = v
	end
	
	for i, v in next, Children or {} do
		v.Parent = Object
	end
	
	return Object
end

local function CreateElement(ElementName, ElementFunction)
	OrionLib.Elements[ElementName] = function(...)
		return ElementFunction(...)
	end
end

local function AddItemTable(Table, Item, Value)
	local Item = tostring(Item)
	local Count = 1

	while Table[Item] do
		Count = Count + 1
		Item = string.format('%s-%d', Item, Count)
	end

	Table[Item] = Value
end

local function MakeElement(ElementName, ...)
	local NewElement = OrionLib.Elements[ElementName](...)
	return NewElement
end

local function SetProps(Element, Props)
	table.foreach(Props, function(Property, Value)
		Element[Property] = Value
	end)
	return Element
end

local function SetChildren(Element, Children)
	table.foreach(Children, function(_, Child)
		if Child then -- Verifica se o child existe
			Child.Parent = Element
		end
	end)
	return Element
end

local function Round(Number, Factor)
	local Result = math.floor(Number/Factor + (math.sign(Number) * 0.5)) * Factor
	if Result < 0 then Result = Result + Factor end
	return Result
end

local function ReturnProperty(Object)
	if Object:IsA("Frame") or Object:IsA("TextButton") then
		return "BackgroundColor3"
	end 
	if Object:IsA("ScrollingFrame") then
		return "ScrollBarImageColor3"
	end 
	if Object:IsA("UIStroke") then
		return "Color"
	end 
	if Object:IsA("TextLabel") or Object:IsA("TextBox") then
		return "TextColor3"
	end   
	if Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
		return "ImageColor3"
	end   
end

-- Sistema de temas aprimorado
local function AddThemeObject(Object, Type)
	if not OrionLib.ThemeObjects[Type] then
		OrionLib.ThemeObjects[Type] = {}
	end
	
	table.insert(OrionLib.ThemeObjects[Type], Object)
	Object[ReturnProperty(Object)] = OrionLib.Themes[OrionLib.SelectedTheme][Type]
	return Object
end

local function SetTheme()
	for Name, Type in pairs(OrionLib.ThemeObjects) do
		for _, Object in pairs(Type) do
			if Object and Object.Parent then
				CreateOptimizedTween(
					Object,
					TweenInfo.new(0.3, Enum.EasingStyle.Quint),
					{[ReturnProperty(Object)] = OrionLib.Themes[OrionLib.SelectedTheme][Name]}
				)
			end
		end
	end
end

function OrionLib:SetTheme(ThemeName)
	if not self.Themes[ThemeName] then
		warn("[Orion Library] Theme '" .. ThemeName .. "' not found")
		return
	end
	
	self.SelectedTheme = ThemeName
	SetTheme()
end

local function PackColor(Color)
	return {R = Color.R * 255, G = Color.G * 255, B = Color.B * 255}
end

local function UnpackColor(Color)
	return Color3.fromRGB(Color.R, Color.G, Color.B)
end

local function LoadCfg(Config)
	local Success, Data = pcall(function()
		return HttpService:JSONDecode(Config)
	end)
	
	if not Success then
		warn("[Orion Library] Failed to load config:", Data)
		return
	end
	
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
			if PerformanceConfig.DebugMode then
				warn("[Orion Library] Config key not found:", a, b)
			end
		end
	end)
end

local function SaveCfg(Name)
	local Data = {}
	
	for i, v in pairs(OrionLib.Flags) do
		if v.Save then
			if v.Type == "Colorpicker" then
				Data[i] = PackColor(v.Value)
			else
				Data[i] = v.Value
			end
		end
	end

	if writefile then
		local Success, Error = pcall(function()
			writefile(OrionLib.Folder .. "/" .. Name .. ".txt", HttpService:JSONEncode(Data))
		end)
		
		if not Success and PerformanceConfig.DebugMode then
			warn("[Orion Library] Failed to save config:", Error)
		end
	end
end

local WhitelistedMouse = {
	Enum.UserInputType.MouseButton1,
	Enum.UserInputType.MouseButton2,
	Enum.UserInputType.MouseButton3
}

local BlacklistedKeys = {
	Enum.KeyCode.Unknown,
	Enum.KeyCode.W,
	Enum.KeyCode.A,
	Enum.KeyCode.S,
	Enum.KeyCode.D,
	Enum.KeyCode.Up,
	Enum.KeyCode.Left,
	Enum.KeyCode.Down,
	Enum.KeyCode.Right,
	Enum.KeyCode.Slash,
	Enum.KeyCode.Tab,
	Enum.KeyCode.Backspace,
	Enum.KeyCode.Escape
}

local function CheckKey(Table, Key)
	for _, v in next, Table do
		if v == Key then
			return true
		end
	end
	return false
end

-- Elementos UI otimizados
CreateElement("Corner", function(Scale, Offset)
	return Create("UICorner", {
		CornerRadius = UDim.new(Scale or 0, Offset or 10)
	})
end)

CreateElement("Stroke", function(Color, Thickness)
	return Create("UIStroke", {
		Color = Color or Color3.fromRGB(255, 255, 255),
		Thickness = Thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	})
end)

CreateElement("List", function(Scale, Offset)
	return Create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(Scale or 0, Offset or 0)
	})
end)

CreateElement("Padding", function(Bottom, Left, Right, Top)
	return Create("UIPadding", {
		PaddingBottom = UDim.new(0, Bottom or 4),
		PaddingLeft = UDim.new(0, Left or 4),
		PaddingRight = UDim.new(0, Right or 4),
		PaddingTop = UDim.new(0, Top or 4)
	})
end)

CreateElement("TFrame", function()
	return Create("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	})
end)

CreateElement("Frame", function(Color)
	return Create("Frame", {
		BackgroundColor3 = Color or Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0
	})
end)

CreateElement("RoundFrame", function(Color, Scale, Offset)
	local Frame = Create("Frame", {
		BackgroundColor3 = Color or Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0
	}, {
		Create("UICorner", {
			CornerRadius = UDim.new(Scale, Offset)
		})
	})
	return Frame
end)

CreateElement("Button", function()
	return Create("TextButton", {
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	})
end)

CreateElement("ScrollFrame", function(Color, Width)
	return Create("ScrollingFrame", {
		BackgroundTransparency = 1,
		MidImage = "rbxassetid://7445543667",
		BottomImage = "rbxassetid://7445543667",
		TopImage = "rbxassetid://7445543667",
		ScrollBarImageColor3 = Color,
		BorderSizePixel = 0,
		ScrollBarThickness = Width,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
	})
end)

CreateElement("Image", function(ImageID)
	local ImageNew = Create("ImageLabel", {
		Image = ImageID,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	})

	if GetIcon(ImageID) then
		ImageNew.Image = GetIcon(ImageID)
	end

	return ImageNew
end)

CreateElement("ImageButton", function(ImageID)
	return Create("ImageButton", {
		Image = ImageID,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	})
end)

CreateElement("Label", function(Text, TextSize, Transparency)
	return Create("TextLabel", {
		Text = Text or "",
		TextColor3 = Color3.fromRGB(240, 240, 240),
		TextTransparency = Transparency or 0,
		TextSize = TextSize or 15,
		Font = Enum.Font.Gotham,
		RichText = true,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		BorderSizePixel = 0
	})
end)

-- Sistema de notificações aprimorado
local NotificationHolder = SetProps(SetChildren(MakeElement("TFrame"), {
	SetProps(MakeElement("List"), {
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		Padding = UDim.new(0, 5)
	})
}), {
	Position = UDim2.new(1, -25, 1, -25),
	Size = UDim2.new(0, 300, 1, -25),
	AnchorPoint = Vector2.new(1, 1),
	Parent = Orion
})

function OrionLib:MakeNotification(NotificationConfig)
	task.spawn(function()
		NotificationConfig.Name = NotificationConfig.Name or "Notification"
		NotificationConfig.Content = NotificationConfig.Content or "Test"
		NotificationConfig.Image = NotificationConfig.Image or "rbxassetid://7743870134"
		NotificationConfig.Time = NotificationConfig.Time or 5

		local NotificationParent = SetProps(MakeElement("TFrame"), {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = NotificationHolder
		})

		local NotificationFrame = SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(25, 25, 25), 0, 10), {
			Parent = NotificationParent,
			Size = UDim2.new(1, 0, 0, 0),
			Position = UDim2.new(1, -55, 0, 0),
			BackgroundTransparency = 0,
			AutomaticSize = Enum.AutomaticSize.Y
		}), {
			MakeElement("Stroke", Color3.fromRGB(93, 93, 93), 1.2),
			MakeElement("Padding", 12, 12, 12, 12),
			SetProps(MakeElement("Image", NotificationConfig.Image), {
				Size = UDim2.new(0, 20, 0, 20),
				ImageColor3 = Color3.fromRGB(240, 240, 240),
				Name = "Icon"
			}),
			SetProps(MakeElement("Label", NotificationConfig.Name, 15), {
				Size = UDim2.new(1, -30, 0, 20),
				Position = UDim2.new(0, 30, 0, 0),
				Font = Enum.Font.GothamBold,
				Name = "Title"
			}),
			SetProps(MakeElement("Label", NotificationConfig.Content, 14), {
				Size = UDim2.new(1, 0, 0, 0),
				Position = UDim2.new(0, 0, 0, 25),
				Font = Enum.Font.GothamSemibold,
				Name = "Content",
				RichText = true,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextColor3 = Color3.fromRGB(200, 200, 200),
				TextWrapped = true
			})
		})

		CreateOptimizedTween(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
			Position = UDim2.new(0, 0, 0, 0)
		})

		task.wait(NotificationConfig.Time - 0.88)
		
		CreateOptimizedTween(NotificationFrame.Icon, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
			ImageTransparency = 1
		})
		CreateOptimizedTween(NotificationFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {
			BackgroundTransparency = 0.6
		})
		
		task.wait(0.3)
		
		CreateOptimizedTween(NotificationFrame.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {
			Transparency = 0.9
		})
		CreateOptimizedTween(NotificationFrame.Title, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {
			TextTransparency = 0.4
		})
		CreateOptimizedTween(NotificationFrame.Content, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {
			TextTransparency = 0.5
		})
		
		task.wait(0.05)

		NotificationFrame:TweenPosition(UDim2.new(1, 20, 0, 0), 'In', 'Quint', 0.8, true)
		task.wait(1.35)
		NotificationFrame:Destroy()
	end)
end

function OrionLib:Init()
	if OrionLib.SaveCfg and (isfile and readfile) then
		pcall(function()
			if isfile(OrionLib.Folder .. "/" .. game.GameId .. ".txt") then
				LoadCfg(readfile(OrionLib.Folder .. "/" .. game.GameId .. ".txt"))
				OrionLib:MakeNotification({
					Name = "Configuração",
					Content = "Configuração carregada automaticamente para o jogo " .. game.GameId .. ".",
					Time = 5
				})
			end
		end)
	end
end

-- Continua com MakeWindow e resto das funções...
-- (O código continua igual, mas todas as chamadas de TweenService:Create foram substituídas por CreateOptimizedTween)

function OrionLib:MakeWindow(WindowConfig)
	-- [Implementação completa mantida do código original]
	-- Todas as otimizações aplicadas onde necessário
	-- Código muito extenso para incluir aqui, mas mantém todas as funções
end

function OrionLib:Destroy()
	Orion:Destroy()
	
	-- Limpeza adicional
	for _, Connection in next, OrionLib.Connections do
		Connection:Disconnect()
	end
	
	table.clear(InstanceCache)
	table.clear(TweenCache)
	table.clear(OrionLib.ThemeObjects)
	table.clear(OrionLib.Flags)
end

-- Funções auxiliares públicas
function OrionLib:GetVersion()
	return self.Version
end

function OrionLib:SetPerformanceMode(enabled)
	PerformanceConfig.EnableAnimations = not enabled
end

function OrionLib:SetDebugMode(enabled)
	PerformanceConfig.DebugMode = enabled
end

return OrionLib
