--== Inicialização ==--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Aguarda o LocalPlayer
local player
repeat
    player = Players.LocalPlayer
    if not player then
        task.wait(0.1)
    end
until player

-- Carrega a biblioteca RedzHubV5
local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()
getgenv().TeleportMode = "Teleport"

--== Funções ==--
function TeleportTo(position)
    local character = player.Character
    if not character or not character.Parent then return end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if getgenv().TeleportMode == "Teleport" then
        root.CFrame = CFrame.new(position)
    elseif getgenv().TeleportMode == "Tween" then
        local speed = redzlib.Flags["TweenSpeed"] or 100
        local tweenTime = 5 / (speed / 20)
        local tween = TweenService:Create(root, TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), {CFrame = CFrame.new(position)})
        tween:Play()
    end
end

--== Interface ==--
local Window = redzlib:MakeWindow({
    Title = "Rain Hub | Tower only wall hop",
    SubTitle = "by zaque_blox",
    SaveFolder = "Rain_hub_tower_onli_wall_hop"
})

Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://7101487397", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(0.3, 0) }
})

-- Aba Info
local InfoTab = Window:MakeTab({"Info", "Info"})
InfoTab:AddSection({"Info"})

InfoTab:AddParagraph({"Seja bem-vindo(a) " .. player.Name .. " ao Rain Hub!", "Obrigado por usar o Rain Hub :D"})

InfoTab:AddSection({"Creator"})
InfoTab:AddParagraph({"Criador: zaque_blox", "Real Nick: zaquel638 Display Nick: zaqueblox"})
InfoTab:AddParagraph({"Idade: 11", "essa é a minha idade Real!"})
InfoTab:AddParagraph({"Membros: zaque_blox", "Só tem eu..."})

InfoTab:AddSection({"Ui Library"})
InfoTab:AddParagraph({"Tem uma ui library?", "sim"})
InfoTab:AddParagraph({"Nome da ui library?", "Rain Lib"})
InfoTab:AddParagraph({"Ui Library usada no código?", "Redz Library v5"})

InfoTab:AddSection({"Links ( sociais )"})
local CopyButton = InfoTab:AddButton({
    Title = "Tiktok ( oficial ) - ( Rain Creator )",
    Callback = function()
        setclipboard("https://www.tiktok.com/@rain_creator_hub?_t=ZS-8vxzg1IZuLZ&_r=1")
    end
})

local CopyButton = InfoTab:AddButton({
    Title = "Tiktok ( oficial ) - ( zaque_blox )",
    Callback = function()
        setclipboard("https://www.tiktok.com/@zaque_blox.ofc?_t=ZM-8vxzwlorCpL&_r=1")
    end
})

InfoTab:AddSection({"Links ( Library )"})
local CopyButton = InfoTab:AddButton({
    Title = "Library ( Redz Library v5 )",
    Callback = function()
        setclipboard("https://github.com/zaque-blox/Redz-Library-/blob/main/README.md")
    end
})

local CopyButton = InfoTab:AddButton({
    Title = "Library ( Rain Lib ) - ( Minha Ui Library )",
    Callback = function()
        setclipboard("https://github.com/RainCreatorHub/RainLib/blob/main/README.md")
    end
})

-- Aba Principal
local MainTab = Window:MakeTab({"Main", "Home"})
MainTab:AddSection({"Sword"})

MainTab:AddButton({
    Name = "Get Sword",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character then
            local leftArm = character:FindFirstChild("Left Arm")
            local torso = character:FindFirstChild("Torso")
            if leftArm and torso then
                local leftShoulder = character:FindFirstChild("Left Shoulder")
                if leftShoulder then leftShoulder:Destroy() end

                leftArm.Anchored = false
                leftArm.Position = Vector3.new(-261.83, 1430.00, 619.79)
                wait(0.20)
                leftArm.Position = torso.Position + Vector3.new(-1.5, 0, 0)
                local newShoulder = Instance.new("Motor6D")
                newShoulder.Name = "Left Shoulder"
                newShoulder.Part0 = torso
                newShoulder.Part1 = leftArm
                newShoulder.C0 = CFrame.new(-1.5, 0.5, 0) * CFrame.Angles(0, math.rad(-90), 0)
                newShoulder.C1 = CFrame.new(0, 0.5, 0) * CFrame.Angles(0, math.rad(-90), 0)
                newShoulder.Parent = torso
            end
        end
    end
})

local autoSwordLoop
MainTab:AddToggle({
    Name = "Auto Get Sword",
    Default = false,
    Flag = "AutoSwordToggle",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local character = player.Character
        if Value then
            if character then
                local leftArm = character:FindFirstChild("Left Arm")
                local torso = character:FindFirstChild("Torso")
                if leftArm and torso then
                    local leftShoulder = character:FindFirstChild("Left Shoulder")
                    if leftShoulder then leftShoulder:Destroy() end

                    autoSwordLoop = game:GetService("RunService").Heartbeat:Connect(function()
                        leftArm.Anchored = false
                        leftArm.Position = Vector3.new(-261.83, 1430.00, 619.79)
                        wait(0.01)
                    end)
                end
            end
        else
            if autoSwordLoop then
                autoSwordLoop:Disconnect()
                autoSwordLoop = nil

                if character then
                    local leftArm = character:FindFirstChild("Left Arm")
                    local torso = character:FindFirstChild("Torso")
                    if leftArm and torso then
                        leftArm.Position = torso.Position + Vector3.new(-1.5, 0, 0)
                        local newShoulder = Instance.new("Motor6D")
                        newShoulder.Name = "Left Shoulder"
                        newShoulder.Part0 = torso
                        newShoulder.Part1 = leftArm
                        newShoulder.C0 = CFrame.new(-1.5, 0.5, 0) * CFrame.Angles(0, math.rad(-90), 0)
                        newShoulder.C1 = CFrame.new(0, 0.5, 0) * CFrame.Angles(0, math.rad(-90), 0)
                        newShoulder.Parent = torso
                    end
                end
            end
        end
    end
})

MainTab:AddSection({"Player"})

-- Adiciona o toggle Noclip
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local Noclipping = nil
local Clip = true -- Começa como verdadeiro (colisão ativada)
local floatName = "HumanoidRootPart" -- Ou qualquer nome de parte a ignorar

MainTab:AddToggle({
    Name = "Noclip",
    Description = "Permite atravessar paredes e objetos",
    Default = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
        Clip = not Value

        if not Clip then
            -- Ativa o noclip
            local function NoclipLoop()
                if not Clip and LocalPlayer.Character then
                    for _, child in pairs(LocalPlayer.Character:GetDescendants()) do
                        if child:IsA("BasePart") and child.CanCollide and child.Name ~= floatName then
                            child.CanCollide = true
                        end
                    end
                end
            end

            Noclipping = RunService.Stepped:Connect(NoclipLoop)
        else
            -- Desativa o noclip
            if Noclipping then
                Noclipping:Disconnect()
                Noclipping = nil
            end

            if LocalPlayer.Character then
                for _, child in pairs(LocalPlayer.Character:GetDescendants()) do
                    if child:IsA("BasePart") then
                        child.CanCollide = true
                    end
                end
            end
        end
    end
})

-- Aba Teleporte
local TeleportTab = Window:MakeTab({"Teleport", "Locate"})
TeleportTab:AddSection({"Teleport"})

TeleportTab:AddDropdown({
    Name = "Locate",
    Description = "Selecione o local para teleportar",
    Options = {"end", "sword", "spawn"},
    Default = nil,
    Flag = "TeleportLocation",
    Callback = function(Value)
        if Value == "end" then
            TeleportTo(Vector3.new(-78.22, 1664.81, 902.50))
        elseif Value == "sword" then
            TeleportTo(Vector3.new(-261.83, 1430.00, 619.79))
        elseif Value == "spawn" then
            TeleportTo(Vector3.new(-22, 1431, 520))
        end
    end
})

-- Aba esp
local espTab = Window:MakeTab({"esp", "Eye"})
espTab:AddSection({"normal ( esp )"})

local espAtivo = false
local maxDistance = 100000 -- Distância máxima em studs
local playerHighlightColor = Color3.new(1, 0, 0) -- Cor inicial do contorno e preenchimento dos jogadores
local playerRainbowLoopRunning = false -- Controle do loop Rainbow para jogadores
local lastPlayerColor = "Red" -- Armazena a última cor selecionada para jogadores

-- Lista das 30 cores para o ciclo Rainbow
local rainbowColors = {
    Color3.fromRGB(255, 0, 0),    -- Red
    Color3.fromRGB(0, 0, 255),    -- Blue
    Color3.fromRGB(255, 255, 0),  -- Yellow
    Color3.fromRGB(0, 128, 0),    -- Green
    Color3.fromRGB(128, 0, 128),  -- Purple
    Color3.fromRGB(255, 165, 0),  -- Orange
    Color3.fromRGB(255, 192, 203),-- Pink
    Color3.fromRGB(0, 0, 0),      -- Black
    Color3.fromRGB(255, 255, 255),-- White
    Color3.fromRGB(128, 128, 128),-- Gray
    Color3.fromRGB(165, 42, 42),  -- Brown
    Color3.fromRGB(0, 255, 255),  -- Cyan
    Color3.fromRGB(255, 0, 255),  -- Magenta
    Color3.fromRGB(64, 224, 208), -- Turquoise
    Color3.fromRGB(50, 205, 50),  -- Lime
    Color3.fromRGB(75, 0, 130),   -- Indigo
    Color3.fromRGB(238, 130, 238),-- Violet
    Color3.fromRGB(255, 215, 0),  -- Gold
    Color3.fromRGB(192, 192, 192),-- Silver
    Color3.fromRGB(245, 245, 220),-- Beige
    Color3.fromRGB(255, 127, 127),-- Coral
    Color3.fromRGB(0, 128, 128),  -- Teal
    Color3.fromRGB(128, 0, 0),    -- Maroon
    Color3.fromRGB(128, 128, 0),  -- Olive
    Color3.fromRGB(0, 0, 128),    -- Navy
    Color3.fromRGB(220, 20, 60),  -- Crimson
    Color3.fromRGB(152, 255, 152),-- Mint
    Color3.fromRGB(230, 230, 250),-- Lavender
    Color3.fromRGB(250, 128, 114),-- Salmon
    Color3.fromRGB(255, 0, 128)   -- Fuchsia
}

local function updatePlayerHighlightColor(colorName)
    print("Atualizando cor dos jogadores para:", colorName)
    lastPlayerColor = colorName -- Armazena a cor selecionada
    playerRainbowLoopRunning = false -- Para qualquer loop Rainbow anterior

    if colorName == "Rainbow" then
        playerRainbowLoopRunning = true
        coroutine.wrap(function()
            print("Iniciando ciclo Rainbow para jogadores")
            local colorIndex = 1
            while espAtivo and playerRainbowLoopRunning do
                playerHighlightColor = rainbowColors[colorIndex]
                print("Cor atual jogadores:", colorIndex, playerHighlightColor)
                for _, otherPlayer in pairs(Players:GetPlayers()) do
                    if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Highlight") then
                        otherPlayer.Character.Highlight.OutlineColor = playerHighlightColor
                        otherPlayer.Character.Highlight.FillColor = playerHighlightColor
                    end
                end
                colorIndex = (colorIndex % #rainbowColors) + 1
                task.wait(0.5)
            end
            print("Ciclo Rainbow dos jogadores parado")
        end)()
    else
        if colorName == "Red" then
            playerHighlightColor = Color3.new(1, 0, 0)
        elseif colorName == "Blue" then
            playerHighlightColor = Color3.new(0, 0, 1)
        elseif colorName == "Yellow" then
            playerHighlightColor = Color3.new(1, 1, 0)
        end
        print("Aplicando cor fixa para jogadores:", playerHighlightColor)
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Highlight") then
                otherPlayer.Character.Highlight.OutlineColor = playerHighlightColor
                otherPlayer.Character.Highlight.FillColor = playerHighlightColor
            end
        end
    end
end

local function ativarESPPlayer()
    espAtivo = true
    print("Ativando ESP para jogadores")
    -- Usa a última cor selecionada ou o valor do dropdown
    local currentColor = redzlib.Flags["PlayerEspColor"] or lastPlayerColor or "Red"
    print("Cor inicial dos jogadores:", currentColor)
    updatePlayerHighlightColor(currentColor)
    coroutine.wrap(function()
        while espAtivo do
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local root = otherPlayer.Character.HumanoidRootPart
                    local playerRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if playerRoot then
                        local distance = (playerRoot.Position - root.Position).Magnitude
                        if distance <= maxDistance then
                            if not otherPlayer.Character:FindFirstChild("Highlight") then
                                local highlight = Instance.new("Highlight")
                                highlight.Adornee = otherPlayer.Character
                                highlight.OutlineColor = playerHighlightColor
                                highlight.FillColor = playerHighlightColor
                                highlight.OutlineTransparency = 0
                                highlight.FillTransparency = 0.5
                                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                highlight.Parent = otherPlayer.Character
                            end
                        else
                            if otherPlayer.Character:FindFirstChild("Highlight") then
                                otherPlayer.Character.Highlight:Destroy()
                            end
                        end
                    end
                end
            end
            task.wait(0.04)
        end
    end)()
end

local function desativarESPPlayer()
    espAtivo = false
    playerRainbowLoopRunning = false
    print("Desativando ESP para jogadores")
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Highlight") then
            otherPlayer.Character.Highlight:Destroy()
        end
    end
end

espTab:AddToggle({
    Name = "Player",
    Description = "ver players no mapa",
    Default = false,
    Flag = "Player",
    Callback = function(state)
        if state then
            ativarESPPlayer()
        else
            desativarESPPlayer()
        end
    end
})

espTab:AddDropdown({
    Name = "color ( player )",
    Description = "selecionar a cor do contorno",
    Options = {"Red", "Blue", "Yellow", "Rainbow"},
    Default = "Red",
    Flag = "PlayerEspColor",
    Callback = function(Value)
        updatePlayerHighlightColor(Value)
    end
})

espTab:AddSection({"sword ( esp )"})

local espadaESPAtivo = false
local espadaHighlight = nil
local maxDistance = 100000
local espadaHighlightColor = Color3.new(1, 0, 0)
local swordRainbowLoopRunning = false -- Controle do loop Rainbow para espada
local lastSwordColor = "Red" -- Armazena a última cor selecionada para espada

local function updateHighlightColor(colorName)
    print("Atualizando cor da espada para:", colorName)
    lastSwordColor = colorName -- Armazena a cor selecionada
    swordRainbowLoopRunning = false -- Para qualquer loop Rainbow anterior

    if colorName == "Rainbow" then
        swordRainbowLoopRunning = true
        coroutine.wrap(function()
            print("Iniciando ciclo Rainbow para espada")
            local colorIndex = 1
            while espadaESPAtivo and swordRainbowLoopRunning do
                espadaHighlightColor = rainbowColors[colorIndex]
                print("Cor atual espada:", colorIndex, espadaHighlightColor)
                if espadaHighlight and espadaHighlight.Adornee then
                    espadaHighlight.OutlineColor = espadaHighlightColor
                    espadaHighlight.FillColor = espadaHighlightColor
                end
                colorIndex = (colorIndex % #rainbowColors) + 1
                task.wait(0.5)
            end
            print("Ciclo Rainbow da espada parado")
        end)()
    else
        if colorName == "Red" then
            espadaHighlightColor = Color3.new(1, 0, 0)
        elseif colorName == "Blue" then
            espadaHighlightColor = Color3.new(0, 0, 1)
        elseif colorName == "Yellow" then
            espadaHighlightColor = Color3.new(1, 1, 0)
        end
        print("Aplicando cor fixa para espada:", espadaHighlightColor)
        if espadaHighlight and espadaHighlight.Adornee then
            espadaHighlight.OutlineColor = espadaHighlightColor
            espadaHighlight.FillColor = espadaHighlightColor
        end
    end
end

local function ativarESPEspada()
    espadaESPAtivo = true
    print("Ativando ESP para espada")
    -- Usa a última cor selecionada ou o valor do dropdown
    local currentColor = redzlib.Flags["SwordEspColor"] or lastSwordColor or "Red"
    print("Cor inicial da espada:", currentColor)
    updateHighlightColor(currentColor)
    coroutine.wrap(function()
        while espadaESPAtivo do
            local espada = game.Workspace:FindFirstChild("ClassicSword")
            local playerRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if espada and playerRoot then
                local espadaPos = espada:IsA("BasePart") and espada.Position or espada:GetPivot().Position
                local distance = (playerRoot.Position - espadaPos).Magnitude
                if distance <= maxDistance and not espada:FindFirstChild("Highlight") then
                    espadaHighlight = Instance.new("Highlight")
                    espadaHighlight.Adornee = espada
                    espadaHighlight.OutlineColor = espadaHighlightColor
                    espadaHighlight.FillColor = espadaHighlightColor
                    espadaHighlight.OutlineTransparency = 0
                    espadaHighlight.FillTransparency = 0.8
                    espadaHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    espadaHighlight.Parent = espada
                elseif (distance > maxDistance or not espada) and espadaHighlight then
                    espadaHighlight:Destroy()
                    espadaHighlight = nil
                end
            elseif not espada and espadaHighlight then
                espadaHighlight:Destroy()
                espadaHighlight = nil
            end
            task.wait(0.04)
        end
    end)()
end

local function desativarESPEspada()
    espadaESPAtivo = false
    swordRainbowLoopRunning = false
    print("Desativando ESP para espada")
    if espadaHighlight then
        espadaHighlight:Destroy()
        espadaHighlight = nil
    end
end

espTab:AddToggle({
    Name = "Sword",
    Description = "Ver a espada",
    Default = false,
    Flag = "Sword",
    Callback = function(state)
        if state then
            ativarESPEspada()
        else
            desativarESPEspada()
        end
    end
})

espTab:AddDropdown({
    Name = "color ( sword )",
    Description = "selecionar a cor do contorno",
    Options = {"Red", "Blue", "Yellow", "Rainbow"},
    Default = "Red",
    Flag = "SwordEspColor",
    Callback = function(Value)
        updateHighlightColor(Value)
    end
})

local scriptTab = Window:MakeTab({"script", "box"})
scriptTab:AddSection({"script"})

local executeButton = scriptTab:AddButton({
    Title = "universal ( Infinite Yield ) - ( FE )",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end
})

local executeButton = scriptTab:AddButton({
    Title = "universal ( Nameless Admin ) - ( FE )",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/Source.lua"))()
    end
})

local executeButton = scriptTab:AddButton({
    Title = "universal ( Fly V3 ) - ( FE )",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Gui-Fly-v3-37111"))()
    end
})

local executeButton = scriptTab:AddButton({
    Title = "universal ( Hug ) - ( FE )",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FE-HUG-R6-23876"))()
    end
})

-- Aba Configurações
local SettingsTab = Window:MakeTab({"Settings", "Settings"})
SettingsTab:AddSection({"settings"})

SettingsTab:AddDropdown({
    Name = "Teleport Mode",
    Description = "Escolha o modo de teleporte",
    Options = {"Teleport", "Tween"},
    Default = "Teleport",
    Flag = "TeleportMode",
    Callback = function(Value)
        getgenv().TeleportMode = Value
        print("Modo de teleporte selecionado:", Value)
    end
})

SettingsTab:AddSlider({
    Name = "Tween Speed",
    Min = 1,
    Max = 350,
    Increment = 1,
    Default = 100,
    Flag = "TweenSpeed",
    Callback = function(Value)
        print("Velocidade do Tween: ", Value)
    end
})

SettingsTab:AddSection({"Anti"})

local AntiVoidEnabled = false
SettingsTab:AddToggle({
    Name = "Anti-void",
    Default = true,
    Flag = "AntiVoid",
    Callback = function(Value)
        AntiVoidEnabled = Value
        print(Value and "Anti-void ativado!" or "Anti-void desativado!")
    end
})

--== Anti-Void ==--
RunService.Heartbeat:Connect(function()
    if not AntiVoidEnabled then return end

    local character = player.Character
    if not character then return end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if root.Position.Y < 20 then
        local bodyVelocity = root:FindFirstChild("AntiVoidVelocity") or Instance.new("BodyVelocity")
        bodyVelocity.Name = "AntiVoidVelocity"
        bodyVelocity.Velocity = Vector3.new(0, 820, 0)
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.P = 5000
        bodyVelocity.Parent = root
    else
        local antiVoidVelocity = root:FindFirstChild("AntiVoidVelocity")
        if antiVoidVelocity then
            antiVoidVelocity:Destroy()
        end
    end
end)
