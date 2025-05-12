-- Carregar a Redz Library v5
local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

-- Criando a janela do hub sem o SaveFolder
local Window = redzlib:MakeWindow({
    Title = "Rain hub | Dead Rails ( Lobby )",
    SubTitle = "By zaque_blox",
    SaveFolder = ""  -- Sem nome, como você pediu
})

-- Adicionando o botão de minimizar
Window:AddMinimizeButton({
    Button = { 
        Image = "rbxassetid://71014873973869", 
        BackgroundTransparency = 0 
    },
    Corner = { 
        CornerRadius = UDim.new(0.3, 0.3) 
    },
})

-- Aba "Info"
local InfoTab = Window:MakeTab({"Info", "Face"})
local SectionInfo = InfoTab:AddSection({"Info"})

-- Aba "Main"
local MainTab = Window:MakeTab({"Main", "Home"})
local SectionMain = MainTab:AddSection({"Lobby"})

-- Função de teleporte
local function TeleporteTo(x, y, z)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char:SetPrimaryPartCFrame(CFrame.new(x, y, z))
    end
end

-- Posições a serem teletransportadas
local positions = {
    {38, 8, 100},
    {38, 8, 116},
    {38, 8, 130},
    {38, 8, 146}
}

-- Valor inicial do slider
local maxPlayers = 1

-- Botão "Ir para jogo"
MainTab:AddButton({
    Name = "Ir para jogo",
    Description = "Quando apertar, o player será teleportado para as posições sequenciais e criará uma party.",
    Callback = function()
        -- Teleporte para cada posição
        for _, pos in ipairs(positions) do
            TeleporteTo(pos[1], pos[2], pos[3])
            task.wait(0.6)  -- Aguarda 0.6 segundos entre os teleportes
        end
        
        -- Após todos os teleportes, cria a party
        local args = {
            [1] = {
                ["trainId"] = "default",
                ["maxMembers"] = maxPlayers,  -- Garante tipo number
                ["gameMode"] = "Normal"
            }
        }

        -- Enviando o evento para criar a party
        game:GetService("ReplicatedStorage").Shared.Network.RemoteEvent.CreateParty:FireServer(unpack(args))
    end
})

-- Slider "Max Players"
MainTab:AddSlider({
    Name = "Max Players",
    Min = 1,
    Max = 10,
    Increase = 1,
    Default = 1,
    Flag = "MaxPlayersSlider",
    Callback = function(Value)
        maxPlayers = tonumber(Value)  -- Garantir que o valor seja convertido para número
        print("Max Players: " .. maxPlayers)
    end
})
