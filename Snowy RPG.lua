local RainLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/OrionLibV2/refs/heads/main/OrionLibV2.lua"))()

local Window = RainLib:MakeWindow({
    Title = "Rain hub | Snowy RPG",
    SubTitle = "by zaque_blox"
})

local MainTab = Window:MakeTab({ Name = "Main" })
local section = MainTab:AddSection({ Name = "Farm" })

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local hrp -- Definido inicialmente como nil, será atualizado no CharacterAdded
local lastRemoteFire = 0 -- Debounce para RemoteEvent
local vectorForce -- Para aplicar força contrária à queda
local originalCollisions = {} -- Para armazenar estado original de CanCollide

-- Função para atualizar o hrp e configurar noclip/VectorForce
local function updateHRP(character)
    hrp = character:WaitForChild("HumanoidRootPart", 10)
    
    -- Armazenar estado original de CanCollide
    originalCollisions = {}
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            originalCollisions[part] = part.CanCollide
        end
    end
    
    -- Criar VectorForce no hrp
    if vectorForce then
        vectorForce:Destroy()
    end
    vectorForce = Instance.new("VectorForce")
    local attachment = Instance.new("Attachment")
    attachment.Name = "ForceAttachment"
    attachment.Parent = hrp
    vectorForce.Attachment0 = attachment
    vectorForce.Parent = hrp
    vectorForce.Enabled = false
end

-- Conectar o evento CharacterAdded para atualizar hrp
player.CharacterAdded:Connect(updateHRP)

-- Definir hrp inicial se o personagem já existir
if player.Character then
    updateHRP(player.Character)
end

_G.AutoFarmLevel = false
_G.KillAura = false

-- ⬇️ Fallback positions por nome do mob (mantida a ordem, apenas OscarFish com 3 posições)
local fallbackPositions = {
    SmallFish1 = CFrame.new(-255, 13, 931),
    BigFish = CFrame.new(-289, 21, -163),
    SmallFish2 = CFrame.new(367, -234, -233),
    StoneKid = CFrame.new(-59, 37, 239),
    StoneTeen = CFrame.new(-59, 37, 239),
    Frog = CFrame.new(-207, 70, -298),
    OscarFishBeta = CFrame.new(394, -275, 648),
    OscarFish = {
        CFrame.new(985, 59, 907),
        CFrame.new(1083, -228, 770),
        CFrame.new(1003, -229, 970)
    },
    DarkHolder = CFrame.new(1841, 404, 1485),
    WinterLoser = CFrame.new(2566, 411, 2677),
    Ender = CFrame.new(4207, 632, 2822),
    Minus = CFrame.new(5319, 671, 2417),
    KnightLoser = CFrame.new(4675, 1025, 3886)
}

-- ⬇️ Função que retorna nome do mob e altura (StudsY) baseado no MyLevel
local function getLevelData()
    local MyLevel = player:WaitForChild("Data"):WaitForChild("Stats"):WaitForChild("Level", 10).Value
    local MonName, StudsY = nil, 8 -- Altura padrão de 8 studs
    if MyLevel >= 0 and MyLevel <= 4 then
        MonName = "SmallFish1"
    elseif MyLevel >= 5 and MyLevel <= 21 then
        MonName = "BigFish"
    elseif MyLevel >= 22 and MyLevel <= 29 then
        MonName = "SmallFish2"
    elseif MyLevel >= 30 and MyLevel <= 33 then
        MonName = "StoneKid"
    elseif MyLevel >= 34 and MyLevel <= 36 then
        MonName = "StoneTeen"
    elseif MyLevel >= 37 and MyLevel <= 64 then
        MonName = "Frog"
    elseif MyLevel >= 65 and MyLevel <= 74 then
        MonName = "OscarFishBeta"
    elseif MyLevel >= 75 and MyLevel <= 178 then
        MonName = "OscarFish"
    elseif MyLevel >= 179 and MyLevel <= 199 then
        MonName = "DarkHolder"
    elseif MyLevel >= 200 and MyLevel <= 379 then
        MonName = "WinterLoser"
        StudsY = 3
    elseif MyLevel >= 380 and MyLevel <= 449 then
        MonName = "Ender"
        StudsY = 6
    elseif MyLevel >= 450 and MyLevel <= 514 then
        MonName = "Minus"
        StudsY = 4
    elseif MyLevel >= 515 then
        MonName = "KnightLoser"
        StudsY = 6
    end
    return MonName, StudsY
end

-- ⬇️ Retorna o mob mais próximo com o nome exato (atualizado em tempo real)
local function getClosestMonster(name)
    if not hrp then return nil end
    local closest, dist = nil, math.huge
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj.Name == name and obj:FindFirstChild("HumanoidRootPart") then
            local d = (hrp.Position - obj.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                closest = obj
            end
        end
    end
    return closest
end

-- ⬇️ Retorna a posição de fallback mais próxima (para OscarFish) ou a posição única
local function getClosestFallback(name)
    if not hrp then return nil end
    local positions = fallbackPositions[name]
    if not positions then
        return nil
    end
    if name == "OscarFish" then
        local closestPos, minDist = nil, math.huge
        for _, cf in ipairs(positions) do
            local d = (hrp.Position - cf.Position).Magnitude
            if d < minDist then
                minDist = d
                closestPos = cf
            end
        end
        return closestPos
    end
    return positions
end

-- ⬇️ Calcula a velocidade com base na distância
local function getTweenSpeed(distance)
    if distance <= 50 then
        return 2000 -- 2000 studs/s para 50 studs
    elseif distance >= 3000 then
        return 450 -- 450 studs/s para 3000 studs ou mais
    elseif distance <= 200 then
        -- Interpolar entre 50 (2000) e 200 (1200)
        local t = (distance - 50) / (200 - 50)
        return 2000 + (1200 - 2000) * t
    else
        -- Interpolar entre 200 (1200) e 3000 (450)
        local t = (distance - 200) / (3000 - 200)
        return 1200 + (450 - 1200) * t
    end
end

-- ⬇️ Função para ativar/desativar noclip
local function setNoclip(enabled)
    if not player.Character then return end
    for _, part in pairs(player.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not enabled
        end
    end
end

-- ⬇️ Loop para atualizar a força contrária à queda em tempo real
task.spawn(function()
    while true do
        if _G.AutoFarmLevel and hrp and vectorForce then
            vectorForce.Enabled = true
            local mass = hrp:GetMass()
            local gravity = Workspace.Gravity
            local velocityY = hrp.Velocity.Y
            local damping = 2 -- Pequeno amortecimento para estabilidade
            -- Força contrária: F = m * g * 1.05 - m * v_y * damping
            local forceY = mass * gravity * 1.05 - mass * velocityY * damping
            vectorForce.Force = Vector3.new(0, forceY, 0)
        elseif vectorForce then
            vectorForce.Enabled = false
            vectorForce.Force = Vector3.new(0, 0, 0)
        end
        task.wait() -- Atualizar a cada frame (~1/60s)
    end
end)

-- ⬇️ Loop do AutoFarm com Tween contínuo sem parar (atualizado em tempo real)
task.spawn(function()
    local tween
    while true do
        if _G.AutoFarmLevel and hrp then
            setNoclip(true) -- Ativar noclip durante o tween
            local name, studsY = getLevelData() -- Usar nível do jogador
            local target = getClosestMonster(name) -- Verificar posição em tempo real
            local cf
            if target and target:FindFirstChild("HumanoidRootPart") then
                local pos = target.HumanoidRootPart.Position -- Posição atual do mob
                cf = CFrame.new(pos.X, pos.Y + studsY, pos.Z)
            else
                cf = getClosestFallback(name)
            end
            if cf then
                local distance = (hrp.Position - cf.Position).Magnitude
                local speed = getTweenSpeed(distance)
                local duration = math.max(0.1, distance / speed) -- Evitar duração muito curta
                if tween then tween:Cancel() end
                tween = TweenService:Create(
                    hrp,
                    TweenInfo.new(duration, Enum.EasingStyle.Linear),
                    {CFrame = cf}
                )
                tween:Play()
            end
        else
            if tween then
                tween:Cancel()
                tween = nil
            end
            if vectorForce then
                vectorForce.Enabled = false
                vectorForce.Force = Vector3.new(0, 0, 0)
            end
            setNoclip(false) -- Desativar noclip
            -- Restaurar CanCollide original
            if player.Character then
                for part, canCollide in pairs(originalCollisions) do
                    if part.Parent then
                        part.CanCollide = canCollide
                    end
                end
            end
        end
        task.wait() -- Atualizar a cada frame (~1/60s)
    end
end)

-- ⬇️ Kill Aura Loop com debounce (atualizado em tempo real)
task.spawn(function()
    local remote = ReplicatedStorage:FindFirstChild("M1PumpkinDeluxeEvent")
    while true do
        if _G.KillAura and hrp and remote then
            for _, mob in ipairs(Workspace:GetChildren()) do
                if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") then
                    if (hrp.Position - mob.HumanoidRootPart.Position).Magnitude < 25 then
                        local currentTime = tick()
                        if currentTime - lastRemoteFire >= 0.2 then
                            remote:FireServer()
                            lastRemoteFire = currentTime
                        end
                    end
                end
            end
        end
        task.wait() -- Atualizar a cada frame (~1/60s)
    end
end)

-- ⬇️ UI
local Toggle = MainTab:AddToggle({
    Name = "Auto Farm Level",
    Description = "Farma level automaticamente sem precisar ir manualmente.",
    Default = false,
    Callback = function(v)
        _G.AutoFarmLevel = v
    end
})

local section = MainTab:AddSection({ Name = "Aura" })

local Toggle = MainTab:AddToggle({
    Name = "Kill Aura",
    Description = "Aura que mata Mon { Mob } que estiver perto dela.",
    Default = false,
    Callback = function(v)
        _G.KillAura = v
    end
})
