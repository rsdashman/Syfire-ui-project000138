local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
--<script's zone>







print("Release 0")











































--<script's zone/>



--controls




--[[
toggle



local featureToggle = ElementsSection:Toggle({
    Title = "Fly",
    --Desc = "Unlocks additional functionality",
    Value = false,
    Callback = function(enabled) 
        

    end
})




]]


--[[
other examples


for i = 1, 40 do
    table.insert(values, "Test " .. i)
end

ElementsSection:Space()


local testDropdown = ElementsSection:Dropdown({
    Title = "Dropdown test",
    Values = values,
    Value = "Test 1",
    Callback = function(option)
        -- WindUI:Notify({
        --     Title = "Dropdown",
        --     Content = "Selected: "..option,
        --     Duration = 2
        -- })
    end
})

testDropdown:Refresh(values)

ElementsSection:Divider()

ElementsSection:Button({
    Title = "Show Notification",
    Icon = "bell",
    Callback = function()
        WindUI:Notify({
            Title = "Hello WindUI!",
            Content = "This is a sample notification",
            Icon = "bell",
            Duration = 3
        })
    end
})

ElementsSection:Colorpicker({
    Title = "Select Color",
    --Desc = "Select coloe",
    Default = Color3.fromHex("#30ff6a"),
    Transparency = 0, -- enable transparency
    Callback = function(color, transparency)
        WindUI:Notify({
            Title = "Color Changed",
            Content = "New color: "..color:ToHex().."\nTransparency: "..transparency,
            Duration = 2
        })
    end
})

ElementsSection:Code({
    Title = "my_code.luau",
    Code = [[print("Hello world!")]],
--    OnCopy = function()
--        print("Copied to clipboard!")
--    end
--})



--]]



















--controls/



local Window = WindUI:CreateWindow({
    Title = "Th4ms.Vip : Universal scripts",
    Icon = "moon",
    Author = "Th4mKrs",
    Folder = "WindUI_Example",
    Size = UDim2.fromOffset(230, 300),
    Theme = "Violet",

    
    HidePanelBackground = false,
    NewElements = false,
    -- Background = WindUI:Gradient({
    --     ["0"] = { Color = Color3.fromHex("#0f0c29"), Transparency = 1 },
    --     ["100"] = { Color = Color3.fromHex("#302b63"), Transparency = 0.9 },
    -- }, {
    --     Rotation = 45,
    -- }),
    --Background = "video:https://cdn.discordapp.com/attachments/1337368451865645096/1402703845657673878/VID_20250616_180732_158.webm?ex=68958a01&is=68943881&hm=164c5b04d1076308b38055075f7eb0653c1d73bec9bcee08e918a31321fe3058&",
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            WindUI:Notify({
                Title = "User Profile",
                Content = "User profile clicked!",
                Duration = 3
            })
        end
    },
    Acrylic = false,
    HideSearchBar = false,
    SideBarWidth = 200,

})

--[[

icons--

https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua

--

]]

Window:CreateTopbarButton("theme-switcher", "moon", function()
    WindUI:SetTheme(WindUI:GetCurrentTheme() == "Dark" and "Light" or "Dark")
    WindUI:Notify({
        Title = "Theme Changed",
        Content = "Current theme: "..WindUI:GetCurrentTheme(),
        Duration = 2
    })
end, 990)

local Sections = {
    Main = Window:Section({ Title = "Main", Opened = true }),
    Settings = Window:Section({ Title = "SETTINGS", Opened = true }),
    Utilities = Window:Section({ Title = "MORE", Opened = true })
}

local Tabs = {
    Elements = Sections.Main:Tab({ Title = "Main", Icon = "layout-grid", Desc = "UI Elements Example" }),
    scripts1 = Sections.Settings:Tab({ Title = "More scripts", Icon = "anvil" }),
    Config = Sections.Utilities:Tab({ Title = "CONFIGURATION", Icon = "settings" }),

}


----------------
----------------ELEMENTS
----------------

Tabs.Elements:Section({
    Title = "Interactive Components",
    TextSize = 20,
})

Tabs.Elements:Section({
    Title = "Explore Th4m's hub with powerful elements",
    TextSize = 16,
    TextTransparency = .25,
})

Tabs.Elements:Divider()

local ElementsSection = Tabs.Elements:Section({
    Title = "Control Painel",
    Icon = "game",
})

local toggleState = false
local featureToggle = ElementsSection:Toggle({
    Title = "Fly",
    --Desc = "Unlocks additional functionality",
    Value = false,
    Callback = function(enabled) 
        
       _G.FlyEnabled = enabled

        if _G._FlyConn then
            _G._FlyConn:Disconnect()
            _G._FlyConn = nil
        end

        if not enabled then
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.Velocity = Vector3.zero
            end
            return
        end

        local UIS = game:GetService("UserInputService")
        local RunService = game:GetService("RunService")
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")

        local speed = 60
        local flying = true
        local direction = Vector3.zero

        local keysDown = {}

        _G._FlyConn = RunService.RenderStepped:Connect(function()
            if not _G.FlyEnabled then return end

            direction = Vector3.zero
            local cam = workspace.CurrentCamera

            if keysDown["W"] then direction = direction + cam.CFrame.LookVector end
            if keysDown["S"] then direction = direction - cam.CFrame.LookVector end
            if keysDown["A"] then direction = direction - cam.CFrame.RightVector end
            if keysDown["D"] then direction = direction + cam.CFrame.RightVector end
            if keysDown["Space"] then direction = direction + cam.CFrame.UpVector end
            if keysDown["LeftShift"] then direction = direction - cam.CFrame.UpVector end

            if direction.Magnitude > 0 then
                hrp.Velocity = direction.Unit * speed
            else
                hrp.Velocity = Vector3.zero
            end
        end)

        UIS.InputBegan:Connect(function(input, gpe)
            if not gpe then
                keysDown[input.KeyCode.Name] = true
            end
        end)

        UIS.InputEnded:Connect(function(input, gpe)
            if not gpe then
                keysDown[input.KeyCode.Name] = false
            end
        end)


    end
})

--slider
local intensitySlider = ElementsSection:Slider({
    Title = "WalkSpeed",
    Desc = "Adjust the walkspeed",
    Value = { Min = 16, Max = 250, Default = 16 },
    Callback = function(Value)
        


        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = Value
        end


    end
})
--slider
local values = {}

local intensitySlider = ElementsSection:Slider({
    Title = "Jump Power",
    Desc = "Adjust the JPP",
    Value = { Min = 16, Max = 250, Default = 16 },
    Callback = function(Value)
        


        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = Value
        end


    end
})



local featureToggle = ElementsSection:Toggle({
    Title = "Inf Jump",
    --Desc = "Unlocks additional functionality",
    Value = false,
    Callback = function(enabled) 
        
        _G.InfJumpEnabled = enabled

        if _G._InfJumpConn then
            _G._InfJumpConn:Disconnect()
            _G._InfJumpConn = nil
        end

        if enabled then
            local UserInputService = game:GetService("UserInputService")
            _G._InfJumpConn = UserInputService.JumpRequest:Connect(function()
                local player = game.Players.LocalPlayer
                if player and player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end
})

local featureToggle = ElementsSection:Toggle({
    Title = "Noclip",
    --Desc = "Unlocks additional functionality",
    Value = false,
    Callback = function(enabled) 
        
		       _G.NoClipEnabled = enabled

        -- Parar qualquer loop anterior
        if _G._NoClipLoop then
            _G._NoClipLoop:Disconnect()
            _G._NoClipLoop = nil
        end

        -- Ativar noclip
        if enabled then
            local RunService = game:GetService("RunService")

            _G._NoClipLoop = RunService.Stepped:Connect(function()
                local character = game.Players.LocalPlayer.Character
                if character then
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") and (part.Name == "Head" or part.Name == "Torso" or part.Name == "UpperTorso" or part.Name == "LowerTorso" or part.Name == "HumanoidRootPart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            -- Restaurar colisão
            local character = game.Players.LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and (part.Name == "Head" or part.Name == "Torso" or part.Name == "UpperTorso" or part.Name == "LowerTorso" or part.Name == "HumanoidRootPart") then
                        part.CanCollide = true
                    end
                end
            end
        end

    end
})







----------------
----------------ELEMENTS/////
----------------









Tabs.scripts1:Section({
    Title = "Interactive Components",
    TextSize = 20,
})

Tabs.scripts1:Section({
    Title = "Explore WindUI's powerful elements",
    TextSize = 16,
    TextTransparency = .25,
})

Tabs.scripts1:Divider()

local scripts1sel = Tabs.scripts1:Section({
    Title = "Section Example",
    Icon = "clock",
})


local intensitySlider = scripts1sel:Slider({
    Title = "WalkSpeed",
    Desc = "Adjust the walkspeed",
    Value = { Min = 16, Max = 250, Default = 16 },
    Callback = function(value)
        





    end
})


























































































































---SETTINGS---


Tabs.Config:Paragraph({
    Title = "Configuration Manager",
    Desc = "Save and load your settings",
    Image = "save",
    ImageSize = 20,
    Color = "White"
})

local configName = "default"
local configFile = nil
local MyPlayerData = {
    name = "Player1",
    level = 1,
    inventory = { "sword", "shield", "potion" }
}

Tabs.Config:Input({
    Title = "Config Name",
    Value = configName,
    Callback = function(value)
        configName = value or "default"
    end
})

local ConfigManager = Window.ConfigManager
if ConfigManager then
    ConfigManager:Init(Window)
    
    Tabs.Config:Button({
        Title = "loc:SAVE_CONFIG",
        Icon = "save",
        Variant = "Primary",
        Callback = function()
            configFile = ConfigManager:CreateConfig(configName)
            
            configFile:Register("featureToggle", featureToggle)
            configFile:Register("intensitySlider", intensitySlider)
            configFile:Register("testDropdown", testDropdown)
            configFile:Register("themeDropdown", themeDropdown)
            configFile:Register("transparencySlider", transparencySlider)
            
            configFile:Set("playerData", MyPlayerData)
            configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))
            
            if configFile:Save() then
                WindUI:Notify({ 
                    Title = "loc:SAVE_CONFIG", 
                    Content = "Saved as: "..configName,
                    Icon = "check",
                    Duration = 3
                })
            else
                WindUI:Notify({ 
                    Title = "Error", 
                    Content = "Failed to save config",
                    Icon = "x",
                    Duration = 3
                })
            end
        end
    })

    Tabs.Config:Button({
        Title = "loc:LOAD_CONFIG",
        Icon = "folder",
        Callback = function()
            configFile = ConfigManager:CreateConfig(configName)
            local loadedData = configFile:Load()
            
            if loadedData then
                if loadedData.playerData then
                    MyPlayerData = loadedData.playerData
                end
                
                local lastSave = loadedData.lastSave or "Unknown"
                WindUI:Notify({ 
                    Title = "loc:LOAD_CONFIG", 
                    Content = "Loaded: "..configName.."\nLast save: "..lastSave,
                    Icon = "refresh-cw",
                    Duration = 5
                })
                
                Tabs.Config:Paragraph({
                    Title = "Player Data",
                    Desc = string.format("Name: %s\nLevel: %d\nInventory: %s", 
                        MyPlayerData.name, 
                        MyPlayerData.level, 
                        table.concat(MyPlayerData.inventory, ", "))
                })
            else
                WindUI:Notify({ 
                    Title = "Error", 
                    Content = "Failed to load config",
                    Icon = "x",
                    Duration = 3
                })
            end
        end
    })
else
    Tabs.Config:Paragraph({
        Title = "Config Manager Not Available",
        Desc = "This feature requires ConfigManager",
        Image = "alert-triangle",
        ImageSize = 20,
        Color = "White"
    })
end

























































Tabs.Config:Paragraph({
    Title = "Customize Interface",
    Desc = "Personalize your experience",
    Image = "palette",
    ImageSize = 20,
    Color = "White"
})

local themes = {}
for themeName, _ in pairs(WindUI:GetThemes()) do
    table.insert(themes, themeName)
end
table.sort(themes)

local canchangetheme = true
local canchangedropdown = true



local themeDropdown = Tabs.Config:Dropdown({
    Title = "THEME_SELECT",
    Values = themes,
    SearchBarEnabled = true,
    MenuWidth = 280,
    Value = "Dark",
    Callback = function(theme)
        canchangedropdown = false
        WindUI:SetTheme(theme)
        WindUI:Notify({
            Title = "Theme Applied",
            Content = theme,
            Icon = "palette",
            Duration = 2
        })
        canchangedropdown = true
    end
})

local transparencySlider = Tabs.Config:Slider({
    Title = "TRANSPARENCY",
    Value = { 
        Min = 0,
        Max = 1,
        Default = 0.2,
    },
    Step = 0.1,
    Callback = function(value)
        WindUI.TransparencyValue = tonumber(value)
        Window:ToggleTransparency(tonumber(value) > 0)
    end
})

local ThemeToggle = Tabs.Config:Toggle({
    Title = "Enable Dark Mode",
    Desc = "Use dark color scheme",
    Value = true,
    Callback = function(state)
        if canchangetheme then
            WindUI:SetTheme(state and "Dark" or "Light")
        end
        if canchangedropdown then
            themeDropdown:Select(state and "Dark" or "Light")
        end
    end
})

WindUI:OnThemeChange(function(theme)
    canchangetheme = false
    ThemeToggle:Set(theme == "Dark")
    canchangetheme = true
end)


Tabs.Config:Button({
    Title = "Create New Theme",
    Icon = "plus",
    Callback = function()
        Window:Dialog({
            Title = "Create Theme",
            Content = "This feature is coming soon!",
            Buttons = {
                {
                    Title = "OK",
                    Variant = "Primary"
                }
            }
        })
    end
})
