local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

local Window = redzlib:MakeWindow({
    Title = "Rain hub | FE | Just a baseplate",
    SubTitle = "by zaque_blox",
    SaveFolder = ""
})

Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://7101487397", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(35, 1) },
})

local Info = Window:MakeTab({"Info", "Info"})
local Section = Info:AddSection({"Info"})

local scriptTab = Window:MakeTab({"Scripts", "box"})
local Section = scriptTab:AddSection({"Meus scripts ( FE )"})

local Button = scriptTab:AddButton({
    Title = "FE dragon ( bug )",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Rain-Hub/refs/heads/main/Just%20a%20Baseplate%20script.lua"))()
    end
})
