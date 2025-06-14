local RainLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/OrionLibV2/refs/heads/main/OrionLibV2.lua"))()

local Window = RainLib:MakeWindow({
    Title = "Rain hub | Snowy RPG",
    SubTitle = "by zaque_blox"
})

local MainTab = Window:MakeTab({ Name = "Main" })
MainTab:AddSection({ Name = "Farm" })

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local hrp = player.Character or player.CharacterAdded:Wait()
hrp = hrp:WaitForChild("HumanoidRootPart")

_G.AutoFarmLevel = false
_G.KillAura = false

-- ⬇️ Fallback positions por nome do mob
local fallbackPositions = {
	Frog = CFrame.new(-207, 70, -298),
	BigFish = CFrame.new(-289, 21, -163),
	SmallFish1 = CFrame.new(-255, 13, 931),
	DarkHolder = CFrame.new(1841, 404, 1485),
	OscarFish = CFrame.new(1077, -205, 907),
	OscarFishBeta = CFrame.new(394, -275, 648),
	WinterLoser = CFrame.new(2566, 411, 2677)
}

-- ⬇️ Função que retorna nome do mob baseado no level
local function getLevelData()
	local level = player:WaitForChild("Data"):WaitForChild("Stats"):WaitForChild("Level").Value
	local MonName

	if level >= 0 and level <= 4 then
		MonName = "SmallFish1"
	elseif level >= 5 and level <= 21 then
		MonName = "BigFish"
	elseif level >= 22 and level <= 29 then
		MonName = "SmallFish2"
	elseif level >= 30 and level <= 33 then
		MonName = "StoneKid"
	elseif level >= 34 and level <= 36 then
		MonName = "StoneTeen"
	elseif level >= 37 and level <= 64 then
		MonName = "Frog"
	elseif level >= 65 and level <= 74 then
		MonName = "OscarFishBeta"
	elseif level >= 75 and level <= 133 then
		MonName = "OscarFish"
	elseif level >= 134 and level <= 149 then
		MonName = "DarkHolder"
	elseif level >= 150 then
		MonName = "WinterLoser"
	end

	return MonName
end

-- ⬇️ Retorna o mob mais próximo com o nome exato
local function getClosestMonster(name)
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

-- ⬇️ Loop do AutoFarm com Tween 7 studs acima do monstro
task.spawn(function()
	local tween
	while true do
		if _G.AutoFarmLevel then
			local name = getLevelData()
			local target = getClosestMonster(name)

			if target and target:FindFirstChild("HumanoidRootPart") then
				local pos = target.HumanoidRootPart.Position
				local cf = CFrame.new(pos.X, pos.Y + 7, pos.Z)
				if (hrp.Position - cf.Position).Magnitude > 4 then
					if tween then tween:Cancel() end
					tween = TweenService:Create(hrp, TweenInfo.new(0.4), {CFrame = cf})
					tween:Play()
				end
			elseif fallbackPositions[name] then
				local cf = fallbackPositions[name]
				if tween then tween:Cancel() end
				tween = TweenService:Create(hrp, TweenInfo.new(0.4), {CFrame = cf})
				tween:Play()
			end
		end
		task.wait(0.1)
	end
end)

-- ⬇️ Kill Aura Loop
task.spawn(function()
	while true do
		if _G.KillAura then
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
MainTab:AddToggle({
	Name = "Auto Farm Level",
	Default = false,
	Callback = function(v)
		_G.AutoFarmLevel = v
	end
})

MainTab:AddSection({ Name = "Aura" })

MainTab:AddToggle({
	Name = "Kill Aura",
	Default = false,
	Callback = function(v)
		_G.KillAura = v
	end
})
