local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

-- Criar Janela
local Window = redzlib:MakeWindow({
  Title = "Rain hub | selector hub",
  SubTitle = "by zaque_blox",
  SaveFolder = ""
})

-- Botão minimize
Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(0, 1) },
})

local InfoTab = Window:MakeTab({"Info", "Face"})
local Section = InfoTab:AddSection({"Info"})

local playerName = game.Players.LocalPlayer.Name
local Paragraph = InfoTab:AddParagraph({"Seja Bem vindo(a) " .. playerName .. "!", ""})

local scriptTab = Window:MakeTab({"script", "box"})
local Section = scriptTab:AddSection({"scripts ( criado por mim )"})

local Button = scriptTab:AddButton({
    Title = "Rain hub ( Tower Onli Wall Hop )",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Rain-Hub/refs/heads/main/Tower%20Onli%20Wall%20Hop.lua"))()
    end
})

local Button = scriptTab:AddButton({
    Title = "Rain ( Just a Baseplate )",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Rain-Hub/refs/heads/main/Just%20a%20Baseplate%20Select.lua"))()
    end
})
