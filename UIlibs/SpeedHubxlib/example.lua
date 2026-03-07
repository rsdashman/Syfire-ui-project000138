

loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Settings.lua"))();
local FuncsV3 = loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Main/main/Library/Example/FuncsV3"))();
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/mamafoni281/Speed-hub-x-V5.0-Library/refs/heads/main/Speed-Hub-X-5.0-Library-Source"))():CreateWindow({
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
