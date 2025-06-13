local RainLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/OrionLibV2/refs/heads/main/OrionLibV2.lua"))()

local Window = RainLib:MakeWindow({
    Title = "Rain hub | Snowy RPG",
    SubTitle = "by zaque_blox"
})

local MainTab = Window:MakeTab({
    Name = "Main"
})

local section = MainTab:AddSection({
    Name = "Farm"
})

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local hrp = player.Character or player.CharacterAdded:Wait()
hrp = hrp:WaitForChild("HumanoidRootPart")

_G.AutoFarmLevel = false
local isRunning = false

-- Função que determina nome e CFrame do monstro com base no nível
local function getLevelData()
	local level = player:WaitForChild("Data"):WaitForChild("Stats"):WaitForChild("Level").Value
	local MonName, MonCframe

	if level >= 0 and level <= 4 then
		MonName = "SmallFish1"
		MonCframe = CFrame.new(-296, 24, 68)
	elseif level >= 5 and level <= 21 then
		MonName = "BigFish"
		MonCframe = CFrame.new(-346, 38, -151)
	elseif level >= 22 and level <= 29 then
		MonName = "SmallFish2"
		MonCframe = CFrame.new(466, -221, -219)
	elseif level >= 30 and level <= 33 then
		MonName = "StoneKid"
		MonCframe = CFrame.new(-11, 32, 97)
	elseif level >= 34 and level <= 36 then
		MonName = "StoneTeen"
		MonCframe = CFrame.new(-85, 36, 200)
	elseif level >= 37 and level <= 64 then
		MonName = "Frog"
		MonCframe = CFrame.new(-11, 26, 26)
	elseif level >= 65 then
		MonName = "OscarFishBeta"
		MonCframe = CFrame.new(394, -275, 648)
	end

	return MonName, MonCframe
end

-- Função que encontra o monstro mais próximo com o nome
local function getClosestMonster(name)
	local closest = nil
	local minDist = math.huge

	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj.Name == name and obj:FindFirstChild("HumanoidRootPart") then
			local dist = (hrp.Position - obj.HumanoidRootPart.Position).Magnitude
			if dist < minDist then
				minDist = dist
				closest = obj
			end
		end
	end

	return closest
end

-- Loop mais leve usando task.spawn
task.spawn(function()
	while true do
		if _G.AutoFarmLevel and not isRunning then
			isRunning = true

			local MonName, MonCframe = getLevelData()
			if MonName and MonCframe then
				local target = getClosestMonster(MonName)
				if target then
					local targetPos = target.HumanoidRootPart.Position
					local teleportCFrame = CFrame.new(targetPos.X, MonCframe.Y, targetPos.Z)

					local tween = TweenService:Create(hrp, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						CFrame = teleportCFrame
					})
					tween:Play()
					tween.Completed:Wait()
				end
			end

			task.wait(0.3) -- Pequeno intervalo entre cada execução
			isRunning = false
		end
		task.wait(0.1) -- Evita uso pesado da CPU
	end
end)

local Toggle = MainTab:AddToggle({
    Name = "Auto Farm Level",
    Default = false,
    Callback = function(Value)
    _G.AutoFarmLevel = Value
    if Value then
      _G.AutoFarmLevel = Value
    end
    if Value then
    while Value do
     game:GetService("ReplicatedStorage"):WaitForChild("M1PumpkinDeluxeEvent"):FireServer()
     wait()
   end
  end
})
