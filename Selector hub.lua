local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

-- Criar Janela
local Window = redzlib:MakeWindow({
  Title = "Rain hub | selector hub",
  SubTitle = "by zaque_blox",
  SaveFolder = ""
})

-- Botão de minimizar com imagem
Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://12367753304", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(1, 0) },
})

-- Aba de informações
local InfoTab = Window:MakeTab({"Info", "Face"})
local InfoSection = InfoTab:AddSection({"Info"})

local playerName = game.Players.LocalPlayer.Name
InfoTab:AddParagraph({"Seja Bem-vindo(a), " .. playerName .. "!", ""})

-- Aba de scripts
local ScriptTab = Window:MakeTab({"script", "box"})
local ScriptSection = ScriptTab:AddSection({"Scripts (criados por mim)"})

-- Função separada para carregar o script
local function TowerOnliWallHop()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Rain-Hub/refs/heads/main/Tower%20Onli%20Wall%20Hop.lua"))()
end

-- Botão
ScriptTab:AddButton({
    Title = "Rain hub ( Tower Onli Wall Hop )",
    Callback = function()
        TowerOnliWallHop()
    end
})

-- Função separada para carregar o script
local function JustABaseplate()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Rain-Hub/refs/heads/main/Just%20a%20Baseplate%20Select.lua"))()
end

-- Botão 
ScriptTab:AddButton({
    Title = "Rain hub ( Just a Baseplate )",
    Callback = function()
        JustABaseplate()
    end
})

-- Botão 
ScriptTab:AddButton({
    Title = "Rain hub ( forsaken ) - ( FE ) - ( incompleto )",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Rain-Hub/refs/heads/main/Forsaken.lua"))()
    end
})

local function FEuniversal()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Rain-Hub/refs/heads/main/universal.lua"))()
end

-- Botão 
ScriptTab:AddButton({
    Title = "Rain hub ( universal ) - ( FE )",
    Callback = function()
        FEuniversal()
    end
})
