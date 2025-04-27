local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function setupAccessory(accessory, customWeld, initialOffset)
    if not accessory or not accessory:IsA("Accessory") then
        warn("Accessory not found or invalid: " .. (accessory and accessory.Name or "nil"))
        return
    end

    local handle = accessory:FindFirstChild("Handle")
    if not handle then
        warn("Handle not found in: " .. accessory.Name)
        return
    end

    -- Remover mesh
    local mesh = handle:FindFirstChildWhichIsA("SpecialMesh") or handle:FindFirstChildWhichIsA("MeshPart")
    if mesh then
        mesh:Destroy()
        print("Mesh removed from: " .. accessory.Name)
    else
        warn("No mesh found in: " .. accessory.Name)
    end

    -- Configurar propriedades do handle
    handle.CanCollide = false
    handle.Anchored = false
    handle.CanTouch = true
    handle.Locked = true

    -- Aplicar weld personalizado
    if customWeld then
        local head = accessory.Parent:FindFirstChild("Head")
        if head then
            for _, weld in ipairs(handle:GetChildren()) do
                if weld:IsA("Weld") or weld:IsA("WeldConstraint") then
                    weld:Destroy()
                end
            end
            local newWeld = Instance.new("Weld")
            newWeld.Name = "AccessoryWeld"
            newWeld.Part0 = head
            newWeld.Part1 = handle

            if initialOffset then
                newWeld.C0 = customWeld * CFrame.new(0, -20, 0)
                local tweenInfo = TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                local tween = TweenService:Create(newWeld, tweenInfo, {C0 = customWeld})
                tween:Play()
            else
                newWeld.C0 = customWeld
            end

            newWeld.Parent = handle
            print(accessory.Name .. " repositioned")
        end
    end

    -- Monitorar VANS_Umbrella
    if accessory.Name == "VANS_Umbrella" then
        accessory.AncestryChanged:Connect(function(_, parent)
            if not parent then
                warn("VANS_Umbrella was removed! Attempting to reapply...")
                task.wait()
                if LocalPlayer.Character then
                    setupAccessories()
                end
            end
        end)
    end

    -- Pull Handles System: Monitorar e corrigir posição do handle
    local lastCheck = tick()
    RunService.Heartbeat:Connect(function()
        if tick() - lastCheck < 0.1 then return end -- Verificar a cada 0.1s para otimizar
        lastCheck = tick()

        if handle and handle.Parent and LocalPlayer.Character then
            local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local weld = handle:FindFirstChild("AccessoryWeld")
                if weld and weld.Part0 and weld.Part1 then
                    local distance = (handle.Position - humanoidRootPart.Position).Magnitude
                    if distance > 50 then
                        warn("Handle " .. accessory.Name .. " too far! Reapplying weld...")
                        handle.CFrame = humanoidRootPart.CFrame * customWeld
                    end
                end
            end
        end
    end)
end

local function setupAccessories()
    local character = LocalPlayer.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.JumpPower = 0
        humanoid.WalkSpeed = 0
        task.delay(5, function()
            humanoid.JumpPower = 50
            humanoid.WalkSpeed = 16
        end)
    end

    local accessories = {
        {name = "PogoStick", weld = CFrame.new(-8, 0, 0) * CFrame.Angles(0, math.rad(90), 0), offset = true},
        {name = "PlaneModel", weld = CFrame.new(8, 0, 0), offset = true},
        {name = "VANS_Umbrella", weld = CFrame.new(0, 11, 14), offset = true},
        {name = "Hat1"},
        {name = "Pal Hair"}
    }

    for _, acc in ipairs(accessories) do
        setupAccessory(character:FindFirstChild(acc.name), acc.weld, acc.offset)
    end
end

-- Inicializar
setupAccessories()

-- Monitorar quando o personagem é adicionado
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.1)
    setupAccessories()
end)
