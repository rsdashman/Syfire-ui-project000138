-- V(%5.5.5)
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

function gradient(text, startColor, endColor)
    local result = ""
    local length = #text
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
        local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
        local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)
        local char = text:sub(i, i)
        result = result .. "<font color=\"rgb(" .. r ..", " .. g .. ", " .. b .. ")\">" .. char .. "</font>"
    end
    return result
end

local Confirmed = false
WindUI:Popup({
    Title = "Bem-vindo ao Syfire Hub!",
    Icon = "rbxassetid://129260712070622",
    IconThemed = true,
    HideSearchBar = false,
    Content = "Este é um Hub feito com a " .. gradient("WindUI", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")) .. " Lib",
    Buttons = {
        {
            Title = "Cancelar",
            Callback = function() end,
            Variant = "Secondary",
        },
        {
            Title = "Continuar",
            Icon = "arrow-right",
            Callback = function() Confirmed = true end,
            Variant = "Primary",
        }
    }
})
repeat task.wait() until Confirmed

local espEnabled, flyEnabled, xrayEnabled, InfiniteJumpEnabled, noclip = false, false, false, false, false
local flySpeed, flyLoop = 100, nil


local function toggleESP(state)
    espEnabled = state
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local highlight = character:FindFirstChild("ESP_Highlight")
                if state then
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Name = "ESP_Highlight"
                        highlight.Adornee = character
                        highlight.Parent = character
                        highlight.FillColor = Color3.new(1, 0, 0)
                        highlight.OutlineColor = Color3.new(1, 1, 1)
                    end
                else
                    if highlight then
                        highlight:Destroy()
                    end
                end
            end
        end
    end
end

local function toggleFly(state)
    flyEnabled = state
    local plr = game.Players.LocalPlayer
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    if state then
        hum.PlatformStand = true
        flyLoop = game:GetService("RunService").RenderStepped:Connect(function()
            local moveVector = Vector3.new()
            local uis = game:GetService("UserInputService")
            if uis:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + workspace.CurrentCamera.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - workspace.CurrentCamera.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - workspace.CurrentCamera.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + workspace.CurrentCamera.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0,1,0) end
            if uis:IsKeyDown(Enum.KeyCode.LeftShift) then moveVector = moveVector - Vector3.new(0,1,0) end
            hrp.Velocity = moveVector.Magnitude > 0 and moveVector.Unit * flySpeed or Vector3.new()
        end)
    else
        if flyLoop then flyLoop:Disconnect() end
        hum.PlatformStand = false
        hrp.Velocity = Vector3.new(0,0,0)
    end
end

local function toggleXray(state)
    xrayEnabled = state
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and not part.Locked then
            part.LocalTransparencyModifier = state and 0.7 or 0
        end
    end
end

-- Infinite Jump
game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local player = game:GetService("Players").LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Noclip
local player = game.Players.LocalPlayer
local function updateCollision()
    local character = player.Character or player.CharacterAdded:Wait()
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            if noclip then
                part.CanCollide = false
            else
                if part.Name == "Head" or part.Name == "Torso" or part.Name == "UpperTorso" or part.Name == "LowerTorso" then
                    part.CanCollide = true
                else
                    part.CanCollide = false
                end
            end
        end
    end
end
game:GetService("RunService").Stepped:Connect(function()
    if noclip then updateCollision() end
end)

-- Criação da janela principal
local Window = WindUI:CreateWindow({
    Title = "WindUI Library",
    Icon = "rbxassetid://129260712070622",
    IconThemed = true,
    Author = "Example UI",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
    User = {
        Enabled = true, -- <- or false
        Callback = function() print("clicked") end, -- <- optional
        Anonymous = true -- <- or true
    },
    SideBarWidth = 200,
    HideSearchBar = false, -- hides searchbar
    ScrollBarEnabled = true, -- enables scrollbar
    -- Background = "rbxassetid://13511292247", -- rbxassetid only

    -- remove it below if you don't want to use the key system in your script.
    KeySystem = { -- <- keysystem enabled
        Key = { "$lue", "Glu3", "glue" },
        Note = "Free Key: Glu3",
        -- Thumbnail = {
        --     Image = "rbxassetid://18220445082", -- rbxassetid only
        --     Title = "Thumbnail"
        -- },
        URL = "link-to-linkvertise-or-discord-or-idk", -- remove this if the key is not obtained from the link.
        SaveKey = true, -- saves key : optional
    },
})


Window:CreateTopbarButton("Discord", "bird", function() setclipboard("https://discord.gg/seulink") end, 990)
Window:CreateTopbarButton("Site", "globe", function() setclipboard("https://seusite.com") end, 989)
Window:CreateTopbarButton("Fullscreen", "battery-plus", function() HideSearchBar = false end, 988)

Window:EditOpenButton({
    Title = "Hub",
    Icon = "monitor",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
    Draggable = true,
})

local Tabs = {}
do
    Tabs.Main = Window:Section({ Title = "Functions", Opened = true })
    Tabs.Player = Window:Section({ Title = "Player", Icon = "user", Opened = true })
    Tabs.Config = Window:Tab({ Title = "Config", Icon = "file-cog" })
end

local mainTab = Tabs.Main:Tab({ Title = "Utilidades", Icon = "mouse-pointer-2" })
mainTab:Button({
    Title = "Fly (Script Externo)",
    Callback = function()
        loadstring(game:HttpGet("https://gist.githubusercontent.com/rsdashman/b96e031446d5a19d8495043a1c134837/raw/acce3da478a58b6345dace47161ca89b26b5d5c3/gistfile1.txt"))()
    end
})
mainTab:Toggle({
    Title = "Noclip",
    Callback = function(state) noclip = state; updateCollision() end,
})
mainTab:Toggle({
    Title = "Xray",
    Callback = function(state) toggleXray(state) end,
})
mainTab:Toggle({
    Title = "Ragdoll Fly",
    Callback = function(state) toggleFly(state) end,
})
mainTab:Toggle({
    Title = "ESP",
    Callback = function(state) toggleESP(state) end,
})
mainTab:Toggle({
    Title = "Infinite Jump",
    Callback = function(state) InfiniteJumpEnabled = state end,
})
mainTab:Button({
    Title = "Setar ToggleKey para 'L'",
    Callback = function() Window:SetToggleKey(Enum.KeyCode.L) end,
})
mainTab:Divider()
mainTab:Button({
    Title = "Botão Travado",
    Desc = "Este botão está travado",
    Locked = true,
})

-- Funções do jogador
local playerTab = Tabs.Player:Tab({ Title = "Player" })
playerTab:Button({
    Title = "Hamsterball",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/rsdashman/Syfire-ui-project000138/refs/heads/main/some%20scripts/BallMode"))()
    end
})
playerTab:Slider({
    Title = "Walkspeed",
    Value = { Min = 16, Max = 100, Default = 16 },
    Callback = function(state)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = state
    end
})

-- Configurações e sistema de configs
local ToggleElement = Tabs.Config:Toggle({
    Title = "Toggle",
    Desc = "Config Test Toggle",
    Callback = function(v) print("Toggle Changed: " .. tostring(v)) end
})
local SliderElement = Tabs.Config:Slider({
    Title = "Slider",
    Desc = "Config Test Slider",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(v) print("Slider Changed: " .. v) end
})
local KeybindElement = Tabs.Config:Keybind({
    Title = "Keybind",
    Desc = "Config Test Keybind",
    Value = "F",
    Callback = function(v) print("Keybind Changed/Clicked: " .. v) end
})
local DropdownElement = Tabs.Config:Dropdown({
    Title = "Dropdown",
    Desc = "Config Test Dropdown",
    Values = { "Test 1", "Test 2" },
    Value = "Test 1",
    Callback = function(v) print("Dropdown Changed: " .. game:GetService("HttpService"):JSONEncode(v)) end
})
local InputElement = Tabs.Config:Input({
    Title = "Input",
    Desc = "Config Test Input",
    Value = "Test",
    Placeholder = "Digite algo...",
    Callback = function(v) print("Input Changed: " .. v) end
})
local ColorpickerElement = Tabs.Config:Colorpicker({
    Title = "Colorpicker",
    Desc = "Config Test Colorpicker",
    Default = Color3.fromHex("#315dff"),
    Transparency = 0,
    Callback = function(c,t) print("Colorpicker Changed: " .. c:ToHex() .. "\nTransparency: " .. t) end
})

-- ConfigManager
local ConfigManager = Window.ConfigManager
local myConfig = ConfigManager:CreateConfig("myConfig")
myConfig:Register("toggleNameExample", ToggleElement)
myConfig:Register("sliderNameExample", SliderElement)
myConfig:Register("keybindNameExample", KeybindElement)
myConfig:Register("dropdownNameExample", DropdownElement)
myConfig:Register("inputNameExample", InputElement)
myConfig:Register("ColorpickerNameExample", ColorpickerElement)

Tabs.Config:Button({
    Title = "Salvar Config",
    Callback = function() myConfig:Save() end
})
Tabs.Config:Button({
    Title = "Carregar Config",
    Callback = function() myConfig:Load() end
})
Tabs.Config:Button({
    Title = "Printar todas configs",
    Callback = function() print(game:GetService("HttpService"):JSONEncode(ConfigManager:AllConfigs())) end
})

