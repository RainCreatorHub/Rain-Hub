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
InfoTab:AddSection({ Name = "Info" })
InfoTab:AddLabel({
    Name = "Bem vindo(a) " .. LocalPlayer.Name .. "!",
    Content = " "
})

-- Aba Main
local MainTab = window:MakeTab({ Name = "Main" })

local setion = MainTab:AddSection({
        Name = "Main"
})

local Label = MainTab:AddLabel({
        Name = "ainda sendo feito ( depois de 2 atualizações )",
        Content = "to falando sério!"
})

-- Aba ESP
local espTab = window:MakeTab({ Name = "esp" })
local section = espTab:AddSection({
        Name = "esp" 
})

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

local toggleComputers = espTab:AddToggle({
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
        if pod.Name == "FreezePod" then
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

local toggleFreezer = espTab:AddToggle({
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
local exitHighlights = {}
local toggleExit = espTab:AddToggle({
    Name = "Exit Door",
    Description = "Destaca saídas com a cor amarelo",
    Default = false,
    Callback = function(state)
        if state then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj.Name == "ExitDoor" then
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
        else
            for _, hl in pairs(exitHighlights) do
                hl:Destroy()
            end
            table.clear(exitHighlights)
        end
    end
})

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

local togglePlayers = espTab:AddToggle({
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
local section = ToolsTab:AddSection({ Name = "Tools (survivor)" })
local Label = ToolsTab:AddLabel({
    Name = "ainda sendo feito ( próxima atualização )",
    Content = "to falando sério!"
})
