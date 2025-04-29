--[[ 
    Library: Redz Library v5
]]

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
    SubTitle = "by ????",
    SaveFolder = "Rain_hub_tower_onli_wall_hop"
})

Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://71014873973869", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(0.3, 0) }
})

-- Aba Info
local InfoTab = Window:MakeTab({"Info", "Info"})
InfoTab:AddSection({"Info"})

InfoTab:AddParagraph({"Seja bem-vindo(a) " .. player.Name .. " ao Rain Hub!", "Obrigado por usar o Rain Hub :D"})

InfoTab:AddSection({"Creator ( Próximo Update )"})

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

MainTab:AddSection({"Player ( Próximo update )"})

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
espTab:AddSection({"esp"})

local espAtivo = false

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
                        highlight.FillColor = Color3.new(1, 0, 0)
                        highlight.Parent = otherPlayer.Character
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

espTab:AddToggle({
    Name = "Player",
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
    Default = false,
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
