-- Aguarda até que o LocalPlayer esteja disponível com uma verificação mais robusta
local Players = game:GetService("Players")
local player
repeat
    player = Players.LocalPlayer
    if not player then
        task.wait(0.1) -- Aguarda um pouco antes de tentar novamente
    end
until player

local playerGui = player:WaitForChild("PlayerGui") 
local RunService = game:GetService("RunService")

local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

local Window = redzlib:MakeWindow({
    Title = "Rain Hub | Universal",
    SubTitle = "by Rain Creator",
    SaveFolder = "Dragon_Hub_universal.json"
})

Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://71014873973869", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(35, 1) },
})

-- Criar as abas com ícones personalizados
local Tabs = { 
    Info = Window:MakeTab({"Info", "Info"}),
    Main = Window:MakeTab({"Main", "Home"}),
    Esp = Window:MakeTab({"esp", "eye"}),
    Combate = Window:MakeTab({"combate", "swords"}),
    Settings = Window:MakeTab({"settings", "settings"})
}

-- Aba Info
local InfoSection = Tabs.Info:AddSection({"Info"})
local CriadorParagraph = Tabs.Info:AddParagraph({"Criador", "feito somente por { zaque_blox - zaquel }"})
local VersaoParagraph = Tabs.Info:AddParagraph({"Versão", "2.0"})
local GrupoSection = Tabs.Info:AddSection({"Link"})
local GrupoZapButton = Tabs.Info:AddButton({"Grupo do zap", 
    Callback = function() 
        setclipboard("https://chat.whatsapp.com/CpJRk0pToQsKx94iKIm2a7") 
    end 
})

-- Aba Main
local MainSection = Tabs.Main:AddSection({"Main"})

-- Variáveis de controle 
local camLockAtivo = false 
local mirarNaCabecaAtivo = false 
local teamCheckAtivo = true
local espTeamCheckAtivo = true
local espAtivo = false 
local espHealthBarAtivo = false 
local espLineAtivo = false 
local espHitboxAtivo = false 
local espLines = {} 
local espHitboxes = {}
local aimbotConnection = nil
local espHealthConnection = nil
local espLineConnection = nil

-- Funções auxiliares
local function getTeamColor(player) 
    local team = player.Team 
    return team and team.TeamColor.Color or Color3.fromRGB(255, 255, 255) 
end

local function encontrarInimigoMaisProximo() 
    local nearestPlayer = nil 
    local minDistance = math.huge
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return nil end
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local humanoid = otherPlayer.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then  
                local playerColor = getTeamColor(player)  
                local otherPlayerColor = getTeamColor(otherPlayer)  
                if teamCheckAtivo and playerColor == otherPlayerColor then  
                    continue  
                end  
                local rootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local distance = (player.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude  
                    if distance < minDistance then  
                        minDistance = distance  
                        nearestPlayer = otherPlayer  
                    end  
                end
            end  
        end
    end
    return nearestPlayer
end

local function ativarAimbot() 
    if aimbotConnection then aimbotConnection:Disconnect() end
    camLockAtivo = true 
    aimbotConnection = RunService.RenderStepped:Connect(function() 
        if not camLockAtivo then return end
        local nearestPlayer = encontrarInimigoMaisProximo()
        if nearestPlayer and nearestPlayer.Character then
            local humanoid = nearestPlayer.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then  
                local camera = game.Workspace.CurrentCamera  
                local targetPart = nearestPlayer.Character:FindFirstChild("HumanoidRootPart")  
                if mirarNaCabecaAtivo and nearestPlayer.Character:FindFirstChild("Head") then  
                    targetPart = nearestPlayer.Character.Head  
                end  
                if targetPart then  
                    camera.CFrame = CFrame.new(camera.CFrame.Position, targetPart.Position)  
                end  
            end  
        end  
    end)
end

local function desativarAimbot() 
    camLockAtivo = false 
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
end

local function atualizarESP()
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Highlight") then
            local highlight = otherPlayer.Character.Highlight
            if espTeamCheckAtivo then
                highlight.FillColor = getTeamColor(otherPlayer)
            else
                highlight.FillColor = Color3.new(1, 0, 0)
            end
        end
    end
end

local function createOrUpdateHealthBar(player) 
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then 
        if player.Character:FindFirstChild("HealthBar") then 
            player.Character.HealthBar:Destroy() 
        end
        local healthBar = Instance.new("BillboardGui")
        healthBar.Name = "HealthBar"
        healthBar.Size = UDim2.new(4, 0, 0.6, 0)
        healthBar.StudsOffset = Vector3.new(0, 3, 0)
        healthBar.AlwaysOnTop = true
        healthBar.Adornee = player.Character:WaitForChild("HumanoidRootPart")
        healthBar.Parent = player.Character
        local barBackground = Instance.new("Frame")  
        barBackground.Size = UDim2.new(1, 0, 1, 0)  
        barBackground.BackgroundColor3 = Color3.new(0, 0, 0)  
        barBackground.BorderSizePixel = 1  
        barBackground.Parent = healthBar  
        local bar = Instance.new("Frame")  
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            bar.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)  
            bar.BackgroundColor3 = Color3.new(0, 1, 0)  
            bar.BorderSizePixel = 0  
            bar.Parent = barBackground  
            humanoid:GetPropertyChangedSignal("Health"):Connect(function()  
                if player.Character and player.Character:FindFirstChild("Humanoid") then  
                    local healthPercentage = humanoid.Health / humanoid.MaxHealth  
                    bar.Size = UDim2.new(healthPercentage, 0, 1, 0)  
                end  
            end)
        end
    end
end

local function ativarESPPlayer() 
    espAtivo = true 
    spawn(function()
        while espAtivo do
            for _, otherPlayer in pairs(Players:GetPlayers()) do 
                if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then 
                    if not otherPlayer.Character:FindFirstChild("Highlight") then 
                        local highlight = Instance.new("Highlight") 
                        highlight.Adornee = otherPlayer.Character 
                        highlight.OutlineColor = Color3.new(0, 0, 0)
                        highlight.Parent = otherPlayer.Character 
                    end 
                    local highlight = otherPlayer.Character.Highlight
                    if espTeamCheckAtivo then
                        highlight.FillColor = getTeamColor(otherPlayer)
                    else
                        highlight.FillColor = Color3.new(1, 0, 0)
                    end
                end 
            end 
            task.wait(0.04)
        end
    end)
end

local function desativarESPPlayer() 
    espAtivo = false 
    for _, otherPlayer in pairs(Players:GetPlayers()) do 
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Highlight") then 
            otherPlayer.Character.Highlight:Destroy() 
        end 
    end 
end

local function ativarESPHealthBar() 
    if espHealthConnection then espHealthConnection:Disconnect() end
    espHealthBarAtivo = true 
    espHealthConnection = RunService.Heartbeat:Connect(function() 
        if not espHealthBarAtivo then return end
        for _, otherPlayer in pairs(Players:GetPlayers()) do 
            if otherPlayer ~= player then 
                createOrUpdateHealthBar(otherPlayer) 
            end 
        end 
    end) 
end

local function desativarESPHealthBar() 
    espHealthBarAtivo = false 
    if espHealthConnection then
        espHealthConnection:Disconnect()
        espHealthConnection = nil
    end
    for _, otherPlayer in pairs(Players:GetPlayers()) do 
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HealthBar") then 
            otherPlayer.Character.HealthBar:Destroy() 
        end 
    end 
end

local function ativarESPLine() 
    if espLineConnection then espLineConnection:Disconnect() end
    espLineAtivo = true 
    espLineConnection = RunService.RenderStepped:Connect(function() 
        if not espLineAtivo then return end 
        for _, line in pairs(espLines) do 
            if line then line:Destroy() end 
        end 
        table.clear(espLines)
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
        for _, target in pairs(Players:GetPlayers()) do
            if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local targetHRP = target.Character.HumanoidRootPart
                local playerHRP = player.Character.HumanoidRootPart
                local line = Instance.new("Part")
                line.Name = "ESPLine"
                line.Size = Vector3.new(0.1, 0.1, (targetHRP.Position - playerHRP.Position).Magnitude)
                line.Anchored = true
                line.CanCollide = false
                line.Color = Color3.new(1, 0, 0)
                line.Material = Enum.Material.Neon
                line.Transparency = 0.5
                line.Parent = workspace
                line.CFrame = CFrame.new((playerHRP.Position + targetHRP.Position) / 2, targetHRP.Position)
                table.insert(espLines, line)
            end
        end
    end)
end

local function desativarESPLine() 
    espLineAtivo = false 
    if espLineConnection then
        espLineConnection:Disconnect()
        espLineConnection = nil
    end
    for _, line in pairs(espLines) do 
        if line then line:Destroy() end 
    end 
    table.clear(espLines) 
end

local function ativarESPHitbox() 
    espHitboxAtivo = true 
    for _, otherPlayer in pairs(Players:GetPlayers()) do 
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then 
            local humanoidRootPart = otherPlayer.Character.HumanoidRootPart 
            local hitbox = Instance.new("Part") 
            hitbox.Name = "ESPHitbox" 
            hitbox.Size = humanoidRootPart.Size + Vector3.new(2, 3, 2)
            hitbox.Position = humanoidRootPart.Position 
            hitbox.Anchored = true 
            hitbox.CanCollide = false 
            hitbox.Color = Color3.fromRGB(0, 255, 0)
            hitbox.Material = Enum.Material.Neon
            hitbox.Transparency = 0.3
            hitbox.Parent = workspace 
            local highlight = Instance.new("Highlight")
            highlight.Adornee = hitbox
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.new(0, 0, 0)
            highlight.FillTransparency = 0.3
            highlight.OutlineTransparency = 0
            highlight.Parent = hitbox
            table.insert(espHitboxes, hitbox)
            local connection
            connection = RunService.Heartbeat:Connect(function()
                if not espHitboxAtivo or not otherPlayer.Character or not otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    hitbox:Destroy()
                    connection:Disconnect()
                    return
                end
                hitbox.Position = otherPlayer.Character.HumanoidRootPart.Position
            end)
        end
    end
end

local function desativarESPHitbox() 
    espHitboxAtivo = false 
    for _, hitbox in pairs(espHitboxes) do 
        if hitbox then hitbox:Destroy() end 
    end 
    table.clear(espHitboxes) 
end

-- Aba Esp
local EspSection = Tabs.Esp:AddSection({"esp"})
local EspPlayerToggle = Tabs.Esp:AddToggle({
    Name = "Player",
    Default = false,
    Callback = function(state) 
        if state then 
            ativarESPPlayer() 
        else 
            desativarESPPlayer() 
        end 
        if espTeamCheckAtivo then
            atualizarESP()
        end
    end 
})
local EspHealthBarToggle = Tabs.Esp:AddToggle({
    Name = "HealthBar",
    Default = false,
    Callback = function(state) 
        if state then 
            ativarESPHealthBar() 
        else 
            desativarESPHealthBar() 
        end 
    end 
})
local EspLineToggle = Tabs.Esp:AddToggle({
    Name = "Line",
    Default = false,
    Callback = function(state) 
        if state then 
            ativarESPLine() 
        else 
            desativarESPLine() 
        end 
    end 
})
local EspHitboxToggle = Tabs.Esp:AddToggle({
    Name = "Hitbox",
    Default = false,
    Callback = function(state) 
        if state then 
            ativarESPHitbox() 
        else 
            desativarESPHitbox() 
        end 
    end 
})

-- Aba Combate
local CombateSection = Tabs.Combate:AddSection({"Aim"})
local AimbotToggle = Tabs.Combate:AddToggle({
    Name = "Aimbot",
    Default = false,
    Callback = function(state) 
        if state then 
            ativarAimbot() 
        else 
            desativarAimbot() 
        end 
    end 
})
local HeadToggle = Tabs.Combate:AddToggle({
    Name = "Head",
    Default = false,
    Callback = function(state) 
        mirarNaCabecaAtivo = state 
    end 
})

-- Aba Settings
local SettingsSection = Tabs.Settings:AddSection({"settings"})
local TeamCheckToggle = Tabs.Settings:AddToggle({
    Name = "Team Check Aimbot",
    Default = true,
    Callback = function(state) 
        teamCheckAtivo = state 
    end 
})
local TeamCheckEspPlayerToggle = Tabs.Settings:AddToggle({
    Name = "Team Check Esp player",
    Default = true,
    Callback = function(state) 
        espTeamCheckAtivo = state 
        if espAtivo then
            atualizarESP()
        end
    end 
})
