local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

-- Criar Janela
local Window = redzlib:MakeWindow({
  Title = "Rain hub | selector hub",
  SubTitle = "by zaque_blox",
  SaveFolder = ""
})

-- Botão de minimizar com imagem
Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://3926305904", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(0, 1) },
})

-- Aba de informações
local InfoTab = Window:MakeTab({"Info", "Face"})
local InfoSection = InfoTab:AddSection({"Info"})

local playerName = game.Players.LocalPlayer.Name
InfoTab:AddParagraph({"Seja Bem-vindo(a), " .. playerName .. "!", ""})

-- Aba de scripts
local ScriptTab = Window:MakeTab({"script", "box"})
local ScriptSection = ScriptTab:AddSection({"Scripts (criados por mim)"})

-- Botão para Tower Onli Wall Hop
ScriptTab:AddButton({
    Title = "Rain hub ( Tower Onli Wall Hop )",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Rain-Hub/refs/heads/main/Tower%20Onli%20Wall%20Hop.lua"))()
    end
})

-- Botão para Just a Baseplate
ScriptTab:AddButton({
    Title = "Rain ( Just a Baseplate )",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Rain-Hub/refs/heads/main/Just%20a%20Baseplate%20Select.lua"))()
    end
})
