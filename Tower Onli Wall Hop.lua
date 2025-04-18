local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

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

-- Criar Abas
local InfoTab = Window:MakeTab({"Info", "Info"})
local MainTab = Window:MakeTab({"Main", "Home"})

local SwordSection = MainTab:AddSection({"Sword"})

MainTab:AddButton({
    Name = "Teleport To Sword",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.CFrame = CFrame.new(Vector3.new(-261.83, 1430.00, 619.79))
            end
        end
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
                -- Desconectar o braço esquerdo
                local leftShoulder = character:FindFirstChild("Left Shoulder")
                if leftShoulder then
                    leftShoulder:Destroy()
                end
                
                -- Teleportar o braço para a posição especificada (não ancorado)
                leftArm.Anchored = false
                leftArm.Position = Vector3.new(-261.83, 1430.00, 619.79)
                
                -- Após 200 milissegundos (0.20 segundos)
                wait(0.20)
                
                -- Teleportar de volta para perto do torso
                leftArm.Position = torso.Position + Vector3.new(-1.5, 0, 0)
                
                -- Reconectar o braço
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
                    -- Desconectar o braço esquerdo
                    local leftShoulder = character:FindFirstChild("Left Shoulder")
                    if leftShoulder then
                        leftShoulder:Destroy()
                    end
                    
                    -- Iniciar loop de teleporte
                    autoSwordLoop = game:GetService("RunService").Heartbeat:Connect(function()
                        leftArm.Anchored = false
                        leftArm.Position = Vector3.new(-261.83, 1430.00, 619.79)
                        wait(0.01) -- 10 milissegundos
                    end)
                end
            end
        else
            -- Parar o loop e reconectar o braço
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
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.CFrame = CFrame.new(Vector3.new(-78.22, 1664.81, 902.50))
            end
        end
    end
})

local SettingsTab = Window:MakeTab({"Settings", "Settings"})
local SettingsSection = SettingsTab:AddSection({"Settings"})
