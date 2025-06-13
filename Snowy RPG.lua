local RainLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/OrionLibV2/refs/heads/main/OrionLibV2.lua"))()

local Window = OrionLib:MakeWindow({
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
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

_G.AutoFarmLevel = false
local tweening = false

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
		MonCframe = CFrame.new(389, -276, 628)
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

-- Loop contínuo com verificação
RunService.RenderStepped:Connect(function()
	if _G.AutoFarmLevel and not tweening then
		local MonName, MonCframe = getLevelData()
		if MonName and MonCframe then
			local target = getClosestMonster(MonName)
			if target then
				tweening = true

				local targetPos = target.HumanoidRootPart.Position
				local teleportCFrame = CFrame.new(targetPos.X, MonCframe.Y, targetPos.Z)

				local tween = TweenService:Create(hrp, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					CFrame = teleportCFrame
				})

				tween:Play()
				tween.Completed:Wait()

				task.wait(0.1) -- Pequeno delay antes de permitir o próximo tween
				tweening = false
			end
		end
	end
end)

local Toggle = MainTab:AddToggle({
    Name = "Auto Farm Level",
    Default = false,
    Callback = _G.AutoFarmLevel(Value)
    end
})
