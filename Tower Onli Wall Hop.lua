local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

-- Variável global do modo de teleporte
getgenv().TeleportMode = "Teleport"

-- Serviço Tween
local TweenService = game:GetService("TweenService")

-- Função para teleportar com suporte a Tween
function TeleportTo(position)
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if getgenv().TeleportMode == "Teleport" then
        root.CFrame = CFrame.new(position)
    elseif getgenv().TeleportMode == "Tween" then
        local speed = redzlib.Flags["Tween Speed"] or 100
        local tweenTime = 5 / (speed / 20)
        local tween = TweenService:Create(root, TweenInfo.new(tweenTime), {CFrame = CFrame.new(position)})
        tween:Play()
    end
end

-- Criar Janela
local Window = redzlib:MakeWindow({
    Title = "Rain Hub | Tower only wall hop",
    SubTitle = "by zaque_blox",
    SaveFolder = "Rain_hub_tower_onli_wall_hop"
})

Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://71014873973869", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(0.3, 0.3) },
})

-- Info Tab
local InfoTab = Window:MakeTab({"Info", "Info"})
local InfoSection = InfoTab:AddSection({"Info"})

local playerName = game.Players.LocalPlayer.Name
local Paragraph = InfoTab:AddParagraph({"seja bem-vindo(a) " .. playerName .. " ao Rain hub!", ""})

-- Main Tab
local MainTab = Window:MakeTab({"Main", "Home"})
local SwordSection = MainTab:AddSection({"Sword"})

MainTab:AddButton({
    Name = "Teleport To Sword",
    Callback = function()
        TeleportTo(Vector3.new(-261.83, 1430.00, 619.79))
    end
})

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

local GameSection = MainTab:AddSection({"Game"})

MainTab:AddButton({
    Name = "Win Game",
    Callback = function()
        TeleportTo(Vector3.new(-78.22, 1664.81, 902.50))
    end
})

-- Settings Tab
local SettingsTab = Window:MakeTab({"Settings", "Settings"})
local SettingsSection = SettingsTab:AddSection({"Settings Teleport"})

SettingsTab:AddDropdown({
    Name = "Teleport Mode",
    Description = "Escolha o modo de teleporte",
    Options = {"Teleport", "Tween"},
    Default = "Teleport",
    Flag = "Teleport Mode",
    Callback = function(Value)
        getgenv().TeleportMode = Value
        print("Modo de teleporte selecionado:", Value)
    end
})

SettingsTab:AddSlider({
    Name = "Tween Speed",
    Min = 1,
    Max = 350,
    Increase = 1,
    Default = 100,
    Flag = "Tween Speed",
    Callback = function(Value)
        print("Valor do Slider: " .. Value)
    end
})
