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

local player = Players.LocalPlayer
local hrp -- Definido inicialmente como nil, será atualizado no CharacterAdded

-- Função para atualizar o hrp quando o personagem mudar
local function updateHRP(character)
    hrp = character:WaitForChild("HumanoidRootPart")
end

-- Conectar o evento CharacterAdded para atualizar hrp
player.CharacterAdded:Connect(updateHRP)

-- Definir hrp inicial se o personagem já existir
if player.Character then
    updateHRP(player.Character)
end

_G.AutoFarmLevel = false
_G.KillAura = false

-- ⬇️ Fallback positions por nome do mob (na ordem do getLevelData, apenas OscarFish com 3 posições)
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
    KnightLoser = CFrame.new(4675, 1025, 3886)
}

-- ⬇️ Função que retorna nome do mob baseado no MyLevel
local function getLevelData()
    local MyLevel = player:WaitForChild("Data"):WaitForChild("Stats"):WaitForChild("Level").Value
    local MonName

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
    elseif MyLevel >= 380 and MyLevel <= 514 then
        MonName = "Ender"
    elseif MyLevel >= 515 then
        MonName = "KnightLoser"
    end

    return MonName
end

-- ⬇️ Retorna o mob mais próximo com o nome exato
local function getClosestMonster(name)
    if not hrp then return nil end -- Verifica se hrp existe
    local closest, dist = nil, math.huge
    for _, obj in pairs(workspace:GetChildren()) do
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
    if not hrp then return nil end -- Verifica se hrp existe
    local positions = fallbackPositions[name]
    if not positions then
        return nil
    end

    -- Se for OscarFish, seleciona a posição mais próxima entre as 3
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

    -- Para outros mobs, retorna a posição única
    return positions
end

-- ⬇️ Loop do AutoFarm com Tween 8 studs acima do monstro
task.spawn(function()
    local tween
    while true do
        if _G.AutoFarmLevel and hrp then -- Verifica se hrp existe
            local name = getLevelData()
            local target = getClosestMonster(name)

            if target and target:FindFirstChild("HumanoidRootPart") then
                local pos = target.HumanoidRootPart.Position
                local cf = CFrame.new(pos.X, pos.Y + 8, pos.Z)
                if (hrp.Position - cf.Position).Magnitude > 4 then
                    if tween then tween:Cancel() end
                    tween = TweenService:Create(hrp, TweenInfo.new(0.4), {CFrame = cf})
                    tween:Play()
                end
            else
                local cf = getClosestFallback(name)
                if cf then
                    if tween then tween:Cancel() end
                    tween = TweenService:Create(hrp, TweenInfo.new(0.4), {CFrame = cf})
                    tween:Play()
                end
            end
        end
        task.wait(0.1)
    end
end)

-- ⬇️ Kill Aura Loop
task.spawn(function()
    while true do
        if _G.KillAura and hrp then -- Verifica se hrp existe
            local remote = ReplicatedStorage:FindFirstChild("M1PumpkinDeluxeEvent")
            if remote then
                for _, mob in ipairs(workspace:GetChildren()) do
                    if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") then
                        if (hrp.Position - mob.HumanoidRootPart.Position).Magnitude < 25 then
                            remote:FireServer()
                        end
                    end
                end
            end
        end
        task.wait(0.2)
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
    Description = "Aura que mata quem estiver perto dela.",
    Default = false,
    Callback = function(v)
        _G.KillAura = v
    end
})
