_G.AutoFarm = false
_G.AutoCheckQuest = false
_G.AutoResizeHitbox = false
_G.AutoAttack = false
_G.AutoGetQuest = false
_G.AutoEquipFightStyle = false

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

function CheckQuest() 
	local player = Players.LocalPlayer
	MyLevel = player.Data.Level.Value
	if MyLevel == 1 or MyLevel <= 9 then
		Mon = "Bandit"
		LevelQuest = 1
		NameQuest = "BanditQuest1"
		NameMon = "Bandit"
		CFrameQuest = CFrame.new(1059.37195, 15.4495068, 1550.4231)
		CFrameMon = CFrame.new(1045.962646484375, 27.00250816345215, 1560.8203125)
	end
end

function HasActiveQuest()
	local player = Players.LocalPlayer
	-- Exemplo: assumindo que existe player.Data.QuestActive como BoolValue
	local questActiveValue = player:FindFirstChild("Data") and player.Data:FindFirstChild("QuestActive")
	if questActiveValue and questActiveValue.Value == true then
		return true
	end
	return false
end

function GetQuest()
	local args = {
		[1] = "StartQuest";
		[2] = NameQuest;
		[3] = LevelQuest;
	}
	game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 9e9):WaitForChild("CommF_", 9e9):InvokeServer(unpack(args))
end

function TweenTo(x, y, z)
	local LocalPlayer = Players.LocalPlayer
	local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local HRP = Character:WaitForChild("HumanoidRootPart")

	local targetPosition = Vector3.new(x, y, z)
	local distance = (HRP.Position - targetPosition).Magnitude

	local speed
	if distance <= 50 then
		speed = 2000
	elseif distance <= 100 then
		speed = 1200
	else
		speed = 350
	end

	local duration = distance / speed
	if duration < 0.05 then
		duration = 0.05
	end

	local goal = {
		CFrame = CFrame.new(x, y, z)
	}

	local tweenInfo = TweenInfo.new(
		duration,
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.Out
	)

	local tween = TweenService:Create(HRP, tweenInfo, goal)
	tween:Play()
end

function TeleportToMon()
	if not NameMon then return end

	GetQuest()

	local LocalPlayer = Players.LocalPlayer
	local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local HRP = Character:WaitForChild("HumanoidRootPart")

	local closest = nil
	local shortestDistance = math.huge

	for _, v in ipairs(Workspace:GetDescendants()) do
		if v:IsA("Model") and v.Name == NameMon and v:FindFirstChild("HumanoidRootPart") then
			local distance = (HRP.Position - v.HumanoidRootPart.Position).Magnitude
			if distance < shortestDistance then
				shortestDistance = distance
				closest = v
			end
		end
	end

	if closest then
		local pos = closest.HumanoidRootPart.Position
		TweenTo(pos.X, pos.Y, pos.Z)
	end
end

function ResizeHitboxes()
	if not _G.AutoResizeHitbox then return end

	local size = Vector3.new(30, 30, 30)

	for _, monster in pairs(Workspace:GetDescendants()) do
		if monster:IsA("Model") and monster:FindFirstChild("HumanoidRootPart") then
			local hrp = monster.HumanoidRootPart
			hrp.Size = size
			hrp.Transparency = 0.4
		end
	end
end

spawn(function()
	while true do
		if _G.AutoCheckQuest then
			CheckQuest()
		end

		if _G.AutoGetQuest and not HasActiveQuest() then
			GetQuest()
		end

		ResizeHitboxes()
		wait(1)
	end
end)

function AutoFarmLevel:Play()
	_G.AutoFarm = true
	_G.AutoCheckQuest = true
	_G.AutoResizeHitbox = true
	_G.AutoAttack = true
	_G.AutoGetQuest = true
	_G.AutoEquipFightStyle = true
end

function AutoFarmLevel:Stop()
	_G.AutoFarm = false
	_G.AutoCheckQuest = false
	_G.AutoResizeHitbox = false
	_G.AutoAttack = false
	_G.AutoGetQuest = false
	_G.AutoEquipFightStyle = false
end
