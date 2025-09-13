-- Main.lua
local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua", true))()
local Npcs = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Rain-Hub/refs/heads/main/Snowy%20RPG/Modules/Npcs.lua", true))() -- substitua pelo link real

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local hrp = nil
local lastRemoteFire = 0

-- Part invisível para Tween
local TweenPart = Instance.new("Part")
TweenPart.Size = Vector3.new(2,2,2)
TweenPart.Transparency = 1
TweenPart.Anchored = true
TweenPart.CanCollide = false
TweenPart.Parent = Workspace

-- Atualiza HRP ao spawn
local function updateHRP(character)
    hrp = character:WaitForChild("HumanoidRootPart", 10)
end
player.CharacterAdded:Connect(updateHRP)
if player.Character then updateHRP(player.Character) end

-- Configurações globais
_G.AutoFarmLevel = false
_G.KillAura = false

-- Função Tween para Part
local function TweenTo(pos, speed)
    local distance = (TweenPart.Position - pos).Magnitude
    local duration = math.max(0.1, distance / speed)
    local tween = TweenService:Create(TweenPart, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos)})
    tween:Play()
    return tween
end

-- Função para encontrar o NPC mais próximo
local function getClosestNPC(name)
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

-- Loop AutoFarm
task.spawn(function()
    local tween
    while true do
        if _G.AutoFarmLevel and hrp then
            local npcName, studsY = Npcs.GetNpc()
            local target = getClosestNPC(npcName)
            local targetPos
            if target then
                targetPos = target.HumanoidRootPart.Position + Vector3.new(0, studsY, 0)
            else
                -- fallback
                local fallback = Npcs.FallbackPositions[npcName]
                if typeof(fallback) == "table" then
                    -- Caso como OscarFish com várias posições
                    local minDist, closestPos = math.huge, fallback[1]
                    for _, cf in ipairs(fallback) do
                        local d = (hrp.Position - cf.Position).Magnitude
                        if d < minDist then
                            minDist = d
                            closestPos = cf
                        end
                    end
                    targetPos = closestPos.Position + Vector3.new(0, studsY, 0)
                else
                    targetPos = fallback.Position + Vector3.new(0, studsY, 0)
                end
            end

            if targetPos then
                if tween then tween:Cancel() end
                tween = TweenTo(targetPos, 200) -- 200 studs/s
                -- Move player para Part invisível
                hrp.CFrame = TweenPart.CFrame
            end
        else
            if tween then tween:Cancel() end
        end
        task.wait(0.1)
    end
end)

-- Loop Kill Aura
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
        task.wait(0.05)
    end
end)

-- UI
local Window = Luna:CreateWindow({
	Name = "Rain Hub | Snowy RPG",
	Subtitle = "by zaque_blox",
	LoadingEnabled = true,
	LoadingTitle = "Rain Hub",
	LoadingSubtitle = "Snowy RPG"
})

local MainTab = Window:CreateTab({Name = "Main", Icon = "view_in_ar", ShowTitle = true})
MainTab:CreateSection("Farm")
MainTab:CreateDivider()

MainTab:CreateToggle({
	Name = "Auto Farm Level",
	Description = "Farma level automaticamente.",
	CurrentValue = false,
	Callback = function(val) _G.AutoFarmLevel = val end
})

MainTab:CreateSection("Aura")
MainTab:CreateDivider()

MainTab:CreateToggle({
	Name = "Kill Aura",
	Description = "Mata mobs próximos automaticamente.",
	CurrentValue = false,
	Callback = function(val) _G.KillAura = val end
})
