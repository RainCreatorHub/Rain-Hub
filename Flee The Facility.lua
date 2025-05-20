local OrionLibV2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/OrionLibV2/refs/heads/main/OrionLibV2.lua"))()
local window = OrionLibV2:MakeWindow({
    Title = "Rain hub | Flee The Facility",
    SubTitle = "by zaque_blox"
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local function isValidModel(obj)
    return obj:IsA("Model") and obj:FindFirstChildWhichIsA("Humanoid") and obj:FindFirstChild("HumanoidRootPart")
end

-- Aba Info
local InfoTab = window:MakeTab({ Name = "Info" })
local SectionInfo = InfoTab:AddSection({ Name = "Info" })
local Label1 = InfoTab:AddLabel({
    Name = "Bem vindo(a) " .. LocalPlayer.Name .. "!",
    Content = "obrigado por usar o Rain hub :D"
})

-- Aba Main
local MainTab = window:MakeTab({ Name = "Main" })
local SectionMain = MainTab:AddSection({ Name = "Main" })
local Label2 = MainTab:AddLabel({
    Name = "ainda sendo feito ( próxima atualização )",
    Content = "to falando sério!"
})

-- Aba ESP
local EspTab = window:MakeTab({ Name = "esp" })
local SectionEsp = EspTab:AddSection({ Name = "esp" })

-- ==== COMPUTERS ====
_G.ComputersEspEvent = _G.ComputersEspEvent or Instance.new("BindableEvent")
_G.ComputersEspCount = _G.ComputersEspCount or 0
local computerHighlights = {}

local function UpdateComputerHighlights()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "ComputerTable" then
            if not computerHighlights[obj] then
                local screen = obj:FindFirstChild("Screen")
                if screen and screen:IsA("BasePart") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ComputerESP"
                    hl.Adornee = obj
                    hl.FillTransparency = 0.5
                    hl.OutlineTransparency = 0
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = obj
                    computerHighlights[obj] = hl
                end
            end

            local screen = obj:FindFirstChild("Screen")
            if screen and computerHighlights[obj] then
                local hl = computerHighlights[obj]
                hl.FillColor = screen.Color
                hl.OutlineColor = screen.Color
            end
        end
    end

    for obj, hl in pairs(computerHighlights) do
        if not obj:IsDescendantOf(Workspace) then
            hl:Destroy()
            computerHighlights[obj] = nil
        end
    end
end

local computersRunning = false
local function ToggleComputersESP(val)
    _G.ComputersEspCount += val and 1 or -1
    _G.ComputersEspCount = math.max(0, _G.ComputersEspCount)
    _G.ComputersEspEvent:Fire(_G.ComputersEspCount > 0)

    if _G.ComputersEspCount > 0 and not computersRunning then
        computersRunning = true
        task.spawn(function()
            while _G.ComputersEspCount > 0 do
                UpdateComputerHighlights()
                task.wait(0.5)
            end
            for _, hl in pairs(computerHighlights) do
                hl:Destroy()
            end
            table.clear(computerHighlights)
            computersRunning = false
        end)
    end
end

local toggleComputers = EspTab:AddToggle({
    Name = "computers",
    Description = "destaca computadores em tempo real!",
    Default = false,
    Callback = ToggleComputersESP
})
_G.ComputersEspEvent.Event:Connect(function(state)
    if toggleComputers:Get() ~= state then
        toggleComputers:Set(state)
    end
end)

-- ==== FREEZER ====
_G.FreezerEspEvent = _G.FreezerEspEvent or Instance.new("BindableEvent")
_G.FreezerEspCount = _G.FreezerEspCount or 0
local freezerHighlights = {}

local function UpdateFreezerHighlights()
    for _, pod in ipairs(Workspace:GetDescendants()) do
        if pod.Name == "FreezePod" or pod.Name == "Freezer" or pod.Name == "Freeze" then
            if not freezerHighlights[pod] then
                local hl = Instance.new("Highlight")
                hl.Name = "FreezerESP"
                hl.Adornee = pod
                hl.FillTransparency = 0.5
                hl.OutlineTransparency = 0
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = pod
                freezerHighlights[pod] = hl
            end

            local occupied = false
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    local char = Workspace:FindFirstChild(plr.Name)
                    if char and pod:IsAncestorOf(char) then
                        occupied = true
                        break
                    end
                end
            end

            local hl = freezerHighlights[pod]
            local color = occupied and Color3.fromRGB(0, 0, 150) or Color3.fromRGB(100, 200, 255)
            hl.FillColor = color
            hl.OutlineColor = color
        end
    end

    for pod, hl in pairs(freezerHighlights) do
        if not pod:IsDescendantOf(Workspace) then
            hl:Destroy()
            freezerHighlights[pod] = nil
        end
    end
end

local freezerRunning = false
local function ToggleFreezerESP(val)
    _G.FreezerEspCount += val and 1 or -1
    _G.FreezerEspCount = math.max(0, _G.FreezerEspCount)
    _G.FreezerEspEvent:Fire(_G.FreezerEspCount > 0)

    if _G.FreezerEspCount > 0 and not freezerRunning then
        freezerRunning = true
        task.spawn(function()
            while _G.FreezerEspCount > 0 do
                UpdateFreezerHighlights()
                task.wait(0.5)
            end
            for _, hl in pairs(freezerHighlights) do
                hl:Destroy()
            end
            table.clear(freezerHighlights)
            freezerRunning = false
        end)
    end
end

local toggleFreezer = EspTab:AddToggle({
    Name = "Freezer",
    Description = "Destaca os pods de congelamento",
    Default = false,
    Callback = ToggleFreezerESP
})
_G.FreezerEspEvent.Event:Connect(function(state)
    if toggleFreezer:Get() ~= state then
        toggleFreezer:Set(state)
    end
end)

-- ==== EXIT DOORS ====
_G.ExitEspEvent = _G.ExitEspEvent or Instance.new("BindableEvent")
_G.ExitEspCount = _G.ExitEspCount or 0
local exitHighlights = {}

local function UpdateExitHighlights()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "ExitDoor" then
            if not exitHighlights[obj] then
                local hl = Instance.new("Highlight")
                hl.Name = "ExitESP"
                hl.Adornee = obj
                hl.FillColor = Color3.fromRGB(255, 255, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 0)
                hl.FillTransparency = 0.5
                hl.OutlineTransparency = 0
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = obj
                exitHighlights[obj] = hl
            end
        end
    end

    for obj, hl in pairs(exitHighlights) do
        if not obj:IsDescendantOf(Workspace) then
            hl:Destroy()
            exitHighlights[obj] = nil
        end
    end
end

local exitRunning = false
local function ToggleExitESP(val)
    _G.ExitEspCount += val and 1 or -1
    _G.ExitEspCount = math.max(0, _G.ExitEspCount)
    _G.ExitEspEvent:Fire(_G.ExitEspCount > 0)

    if _G.ExitEspCount > 0 and not exitRunning then
        exitRunning = true
        task.spawn(function()
            while _G.ExitEspCount > 0 do
                UpdateExitHighlights()
                task.wait(0.5)
            end
            for _, hl in pairs(exitHighlights) do
                hl:Destroy()
            end
            table.clear(exitHighlights)
            exitRunning = false
        end)
    end
end

local toggleExit = EspTab:AddToggle({
    Name = "Exit Door",
    Description = "Destaca saídas com a cor amarelo",
    Default = false,
    Callback = ToggleExitESP
})
_G.ExitEspEvent.Event:Connect(function(state)
    if toggleExit:Get() ~= state then
        toggleExit:Set(state)
    end
end)

-- ==== PLAYERS ====
_G.PlayersEspEvent = _G.PlayersEspEvent or Instance.new("BindableEvent")
_G.PlayersEspCount = _G.PlayersEspCount or 0
local playerHighlights = {}

local function HasHammer(player)
    local char = Workspace:FindFirstChild(player.Name)
    return char and char:FindFirstChild("Hammer") ~= nil
end

local function UpdatePlayerHighlights()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = Workspace:FindFirstChild(plr.Name)
            if char and isValidModel(char) then
                if not playerHighlights[plr] then
                    local hl = Instance.new("Highlight")
                    hl.Name = "PlayerESP"
                    hl.Adornee = char
                    hl.FillTransparency = 0.5
                    hl.OutlineTransparency = 0
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = char
                    playerHighlights[plr] = hl
                else
                    playerHighlights[plr].Adornee = char
                end

                local color = HasHammer(plr) and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
                local hl = playerHighlights[plr]
                hl.FillColor = color
                hl.OutlineColor = color
            end
        end
    end

    for plr, hl in pairs(playerHighlights) do
        if not Players:FindFirstChild(plr.Name) or not Workspace:FindFirstChild(plr.Name) then
            hl:Destroy()
            playerHighlights[plr] = nil
        end
    end
end

local playerEspRunning = false
local function TogglePlayersESP(val)
    _G.PlayersEspCount += val and 1 or -1
    _G.PlayersEspCount = math.max(0, _G.PlayersEspCount)
    _G.PlayersEspEvent:Fire(_G.PlayersEspCount > 0)

    if _G.PlayersEspCount > 0 and not playerEspRunning then
        playerEspRunning = true
        task.spawn(function()
            while _G.PlayersEspCount > 0 do
                UpdatePlayerHighlights()
                task.wait(0.3)
            end
            for _, hl in pairs(playerHighlights) do
                hl:Destroy()
            end
            table.clear(playerHighlights)
            playerEspRunning = false
        end)
    end
end

local togglePlayers = EspTab:AddToggle({
    Name = "Players",
    Description = "Destaca jogadores",
    Default = false,
    Callback = TogglePlayersESP
})
_G.PlayersEspEvent.Event:Connect(function(state)
    if togglePlayers:Get() ~= state then
        togglePlayers:Set(state)
    end
end)

-- Aba Tools
local ToolsTab = window:MakeTab({ Name = "Tools" })
local SectionTools = ToolsTab:AddSection({ Name = "survivor" })

-- ==== ANTI FAIL ====
_G.AntiFailEvent = _G.AntiFailEvent or Instance.new("BindableEvent")
_G.AntiFailCount = _G.AntiFailCount or 0
local antiFailRunning = false

local function NoFailLoop()
    -- Uses the game's existing RemoteEvent in ReplicatedStorage, no custom RemoteEvent created
    local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent", 5)
    if not remote then
        warn("Anti Fail: Game's RemoteEvent not found in ReplicatedStorage")
        return
    end
    while _G.AntiFailCount > 0 do
        local args = {
            "SetPlayerMinigameResult",
            true
        }
        remote:FireServer(unpack(args))
        task.wait(0.1)
    end
end

local function ToggleAntiFail(val)
    _G.AntiFailCount += val and 1 or -1
    _G.AntiFailCount = math.max(0, _G.AntiFailCount)
    _G.AntiFailEvent:Fire(_G.AntiFailCount > 0)

    if _G.AntiFailCount > 0 and not antiFailRunning then
        antiFailRunning = true
        task.spawn(NoFailLoop)
    else
        antiFailRunning = false
    end
end

local toggleAntiFail = ToolsTab:AddToggle({
    Name = "Anti Fail",
    Description = "sem falhas",
    Default = false,
    Callback = ToggleAntiFail
})

_G.AntiFailEvent.Event:Connect(function(state)
    if toggleAntiFail:Get() ~= state then
        toggleAntiFail:Set(state)
    end
end)

-- ==== AUTO INTERACT ====
_G.AutoInteractEvent = _G.AutoInteractEvent or Instance.new("BindableEvent")
_G.AutoInteractCount = _G.AutoInteractCount or 0
local autoInteractRunning = false

local function AutoInteractLoop()
    -- Uses the game's existing RemoteEvent in ReplicatedStorage, no custom RemoteEvent created
    local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent", 5)
    if not remote then
        warn("Auto Interact: Game's RemoteEvent not found in ReplicatedStorage")
        return
    end
    while _G.AutoInteractCount > 0 do
        local args = {
            "Input",
            "Action",
            true
        }
        remote:FireServer(unpack(args))
        task.wait(0.1)
    end
end

local function ToggleAutoInteract(val)
    _G.AutoInteractCount += val and 1 or -1
    _G.AutoInteractCount = math.max(0, _G.AutoInteractCount)
    _G.AutoInteractEvent:Fire(_G.AutoInteractCount > 0)

    if _G.AutoInteractCount > 0 and not autoInteractRunning then
        autoInteractRunning = true
        task.spawn(AutoInteractLoop)
    else
        autoInteractRunning = false
    end
end

local toggleAutoInteract = ToolsTab:AddToggle({
    Name = "Auto Interact",
    Description = "Automatically interacts with objects",
    Default = false,
    Callback = ToggleAutoInteract
})

_G.AutoInteractEvent.Event:Connect(function(state)
    if toggleAutoInteract:Get() ~= state then
        toggleAutoInteract:Set(state)
    end
end)
