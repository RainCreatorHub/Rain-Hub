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
    Button = { Image = "rbxassetid://12367753304", BackgroundTransparency = 0 },
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
InfoTab:AddButton({
    Title = "Tiktok ( oficial ) - ( Rain Creator )",
    Callback = function()
        setclipboard("https://www.tiktok.com/@rain_creator_hub?_t=ZS-8vxzg1IZuLZ&_r=1")
    end
})
InfoTab:AddButton({
    Title = "Tiktok ( oficial ) - ( zaque_blox )",
    Callback = function()
        setclipboard("https://www.tiktok.com/@zaque_blox.ofc?_t=ZM-8vxzwlorCpL&_r=1")
    end
})

InfoTab:AddSection({"Links ( Library )"})
InfoTab:AddButton({
    Title = "Library ( Redz Library v5 )",
    Callback = function()
        setclipboard("https://github.com/zaque-blox/Redz-Library-/blob/main/README.md")
    end
})
InfoTab:AddButton({
    Title = "Library ( Rain Lib ) - ( Minha Ui Library )",
    Callback = function()
        setclipboard("https://github.com/RainCreatorHub/RainLib/blob/main/README.md")
    end
})

-- Aba Principal
local MainTab = Window:MakeTab({"Main", "Home"})
MainTab:AddSection({"Sword ( Auto and No Auto )"})

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
    Flag = "AutoSword",
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

-- Seção de jogador
MainTab:AddSection({"Player"})

local killAllLoop
local originalPositions = {} -- Tabela para armazenar posições iniciais

MainTab:AddToggle({
    Name = "spam Kill All ( beta )",
    Description = "matar todos ( fique com a espada equipada e fique clicando )",
    Default = false,
    Callback = function(state)
        if state then
            -- Limpar posições antigas
            originalPositions = {}
            
            killAllLoop = RunService.Heartbeat:Connect(function()
                local localChar = player.Character
                if not localChar then return end
                local localHRP = localChar:FindFirstChild("HumanoidRootPart")
                if not localHRP then return end
                local localHumanoid = localChar:FindFirstChild("Humanoid")
                if localHumanoid and localHumanoid.Health <= 0 then return end

                for _, otherPlayer in ipairs(Players:GetPlayers()) do
                    if otherPlayer ~= player and otherPlayer.Character then
                        local otherHRP = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local otherHumanoid = otherPlayer.Character:FindFirstChild("Humanoid")
                        if otherHRP and otherHumanoid and otherHumanoid.Health > 0 then
                            -- Armazenar posição inicial se não estiver salva
                            if not originalPositions[otherPlayer] then
                                originalPositions[otherPlayer] = otherHRP.CFrame
                            end
                            -- Mover hitbox para 4 studs à frente
                            otherHRP.Anchored = false
                            otherHRP.Size = Vector3.new(10, 10, 10)
                            local position = (localHRP.CFrame * CFrame.new(0, 0, -4)).Position
                            otherHRP.CFrame = CFrame.new(position) * localHRP.CFrame.Rotation
                        end
                    end
                end
            end)
        else
            if killAllLoop then
                killAllLoop:Disconnect()
                killAllLoop = nil
            end

            -- Restaurar tamanho e posições das hitboxes
            for otherPlayer, originalCFrame in pairs(originalPositions) do
                if otherPlayer.Character then
                    local otherHRP = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if otherHRP then
                        otherHRP.Size = Vector3.new(2, 2, 1)
                        otherHRP.CFrame = originalCFrame
                    end
                end
            end
            -- Limpar tabela de posições
            originalPositions = {}
        end
    end
})

-- Aba Teleporte
local TeleportTab = Window:MakeTab({"Teleport", "Locate"})
TeleportTab:AddSection({"Teleport"})

-- locais
TeleportTab:AddDropdown({
    Name = "Locate",
    Description = "Selecione o local para teleportar",
    Options = {"end", "sword", "spawn"},
    Default = "no locate",
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

-- stages...
TeleportTab:AddDropdown({
    Name = "stages",
    Description = "Selecione o local para teleportar",
    Options = {"stage 1", "stage 2"},
    Default = "no stages",
    Flag = "stagesTeleport",
    Callback = function(Value)
        if Value == "stage 1" then
            TeleportTo(Vector3.new(-22, 1435, 531))
        elseif Value == "stage 2" then
            TeleportTo(Vector3.new(-22, 1440, 543))
        end
    end
})

-- Aba esp
local espTab = Window:MakeTab({"esp", "Eye"})
espTab:AddSection({"normal ( esp )"})

local espAtivo = false
local maxDistance = 100000
local playerHighlightColor = Color3.new(1, 0, 0)
local playerRainbowLoopRunning = false
local lastPlayerColor = "Red"

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
    lastPlayerColor = colorName
    playerRainbowLoopRunning = false

    if colorName == "Rainbow" then
        playerRainbowLoopRunning = true
        coroutine.wrap(function()
            local colorIndex = 1
            while espAtivo and playerRainbowLoopRunning do
                playerHighlightColor = rainbowColors[colorIndex]
                for _, otherPlayer in pairs(Players:GetPlayers()) do
                    if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Highlight") then
                        otherPlayer.Character.Highlight.OutlineColor = playerHighlightColor
                        otherPlayer.Character.Highlight.FillColor = playerHighlightColor
                    end
                end
                colorIndex = (colorIndex % #rainbowColors) + 1
                task.wait(0.5)
            end
        end)()
    else
        if colorName == "Red" then
            playerHighlightColor = Color3.new(1, 0, 0)
        elseif colorName == "Blue" then
            playerHighlightColor = Color3.new(0, 0, 1)
        elseif colorName == "Yellow" then
            playerHighlightColor = Color3.new(1, 1, 0)
        end
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
    local currentColor = redzlib.Flags["PlayerEspColor"] or lastPlayerColor or "Red"
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
local swordRainbowLoopRunning = false
local lastSwordColor = "Red"

local function updateHighlightColor(colorName)
    lastSwordColor = colorName
    swordRainbowLoopRunning = false

    if colorName == "Rainbow" then
        swordRainbowLoopRunning = true
        coroutine.wrap(function()
            local colorIndex = 1
            while espadaESPAtivo and swordRainbowLoopRunning do
                espadaHighlightColor = rainbowColors[colorIndex]
                if espadaHighlight and espadaHighlight.Adornee then
                    espadaHighlight.OutlineColor = espadaHighlightColor
                    espadaHighlight.FillColor = espadaHighlightColor
                end
                colorIndex = (colorIndex % #rainbowColors) + 1
                task.wait(0.5)
            end
        end)()
    else
        if colorName == "Red" then
            espadaHighlightColor = Color3.new(1, 0, 0)
        elseif colorName == "Blue" then
            espadaHighlightColor = Color3.new(0, 0, 1)
        elseif colorName == "Yellow" then
            espadaHighlightColor = Color3.new(1, 1, 0)
        end
        if espadaHighlight and espadaHighlight.Adornee then
            espadaHighlight.OutlineColor = espadaHighlightColor
            espadaHighlight.FillColor = espadaHighlightColor
        end
    end
end

local function ativarESPEspada()
    espadaESPAtivo = true
    local currentColor = redzlib.Flags["SwordEspColor"] or lastSwordColor or "Red"
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
scriptTab:AddSection({"FE admin"})

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

scriptTab:AddSection({"FE hug"})
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
