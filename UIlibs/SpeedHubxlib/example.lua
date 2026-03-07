

loadstring(game:HttpGet("https://raw.githubusercontent.com/rsdashman/Syfire-ui-project000138/refs/heads/main/UIlibs/SpeedHubxlib/Settings.lua"))();
local FuncsV3 = loadstring(game:HttpGet("https://raw.githubusercontent.com/rsdashman/Syfire-ui-project000138/refs/heads/main/UIlibs/SpeedHubxlib/FuncsV3.lua"))();
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/rsdashman/Syfire-ui-project000138/refs/heads/main/UIlibs/SpeedHubxlib/Libary.lua"))():CreateWindow({
    ["Tab Width"] = 160,
    ["Description"] = "",
    ["Title"] = "Speed Hub X | Library"
});

-- Single main tab with all elements
local MainTab = Library:CreateTab({
    ["Name"] = "Home",
    ["Icon"] = "rbxassetid://10723407389"
});

local FarmingSection = MainTab:AddSection("Home", true);

FuncsV3:Toggle(FarmingSection, "Toggle", "", true, function(value)
end);

FuncsV3:Button(FarmingSection, "Button", "", function()
end);

FuncsV3:Textbox(FarmingSection, "Set Speed", "Enter walk speed value", function(value)
end);
