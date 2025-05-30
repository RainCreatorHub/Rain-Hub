local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Rain hub | Blue Lock: Rivals",
    SubTitle = "by zaque_blox",
    TabWidth = 120,
    Size = UDim2.fromOffset(450, 340),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = ({
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
})

local Options = Fluent.Options

-- Listas de times azul e branco
local TimeAzul = {"CF", "CM", "GK", "RW", "LW"}
local TimeBranco = {"CF", "CM", "GK", "RW", "LW"}

-- Função que verifica se o time pertence à lista (case insensitive)
local function IsInTeamList(teamName, list)
    if not teamName then return false end
    teamName = tostring(teamName):lower()
    for _, v in ipairs(list) do
        if teamName == v:lower() then
            return true
        end
    end
    return false
end

-- Função para encontrar a Football no workspace ou nas pastas dos players
local function FindFootball()
    -- Procura na workspace
    local ball = workspace:FindFirstChild("Football")
    if ball then return ball end

    -- Procura nas pastas dos jogadores
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("Football") then
            return plr.Character.Football
        end
        if plr:FindFirstChild("Football") then
            return plr.Football
        end
    end
    return nil
end

-- Função para checar se a Football está dentro do time azul do LocalPlayer
local function IsFootballInTeamAzul(football)
    if not football or not football.Parent then return false end
    local parent = football.Parent
    -- Verifica se a Football está em algum jogador do time azul
    if parent:IsA("Model") and parent:FindFirstChild("Team") then
        local teamName = tostring(parent.Team.Value or ""):lower()
        if string.find(teamName, "blue") then
            return true
        end
    end
    return false
end

-- Função para verificar se o football está dentro do LocalPlayer
local function IsFootballInLocalPlayer(football)
    if not football or not football.Parent then return false end
    return football.Parent == LocalPlayer.Character or football.Parent == LocalPlayer
end

-- Toggle Auto Get Ball
local autoGetBallToggle = Tabs.Main:AddToggle("AutoGetBall", {
    Title = "Auto Get Ball",
    Default = false,
    Description = "Pega a bola se teleportando."
})

local autoGetBallEnabled = false

autoGetBallToggle:OnChanged(function(state)
    autoGetBallEnabled = state
    if state then
        task.spawn(function()
            while autoGetBallEnabled and not Fluent.Unloaded do
                local football = FindFootball()
                if football then
                    local localTeam = LocalPlayer.Team and tostring(LocalPlayer.Team.Name):lower() or ""
                    local footballParent = football.Parent

                    -- Verifica se localPlayer está no time azul e football está no time azul
                    local inBlueTeam = localTeam == "home" or localTeam == "blue"
                    local footballInBlueTeam = false
                    if footballParent and footballParent:FindFirstChild("Team") then
                        local footballTeamName = tostring(footballParent.Team.Value or ""):lower()
                        footballInBlueTeam = string.find(footballTeamName, "blue") ~= nil
                    end

                    -- Não teleporta se Football estiver dentro do LocalPlayer
                    if IsFootballInLocalPlayer(football) then
                        -- só espera até sair da pasta LocalPlayer
                        repeat task.wait() until not IsFootballInLocalPlayer(football)
                    end

                    -- Se LocalPlayer estiver em time azul e Football também, não teleporta
                    if inBlueTeam and footballInBlueTeam then
                        -- espera para re-checar
                        task.wait(0.2)
                    else
                        -- Teleportar instantâneo para a Football
                        if football:IsA("BasePart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = football.CFrame * CFrame.new(0,5,0)
                        elseif football:IsA("Model") and football:FindFirstChildWhichIsA("BasePart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = football:FindFirstChildWhichIsA("BasePart").CFrame * CFrame.new(0,5,0)
                        end
                        task.wait(0.2)
                    end
                else
                    task.wait(0.5)
                end
            end
        end)
    end
end)

-- Toggle Auto Goal
local autoGoalToggle = Tabs.Main:AddToggle("AutoGoal", {
    Title = "Auto Goal",
    Default = false,
    Description = "Teleporte-se para o gol"
})

local autoGoalEnabled = false
local goalBlueCFrame = CFrame.new(-236, 11, -53)
local goalAwayCFrame = CFrame.new(313, 11, -49)

autoGoalToggle:OnChanged(function(state)
    autoGoalEnabled = state
    if state then
        task.spawn(function()
            while autoGoalEnabled and not Fluent.Unloaded do
                local football = FindFootball()
                if football then
                    if IsFootballInLocalPlayer(football) then
                        local playerTeamName = tostring(LocalPlayer.Team.Name or ""):lower()
                        if playerTeamName == "home" then
                            -- Teleportar para gol azul
                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                LocalPlayer.Character.HumanoidRootPart.CFrame = goalBlueCFrame
                            end
                        elseif playerTeamName == "away" then
                            -- Teleportar para gol branco
                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                LocalPlayer.Character.HumanoidRootPart.CFrame = goalAwayCFrame
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end)

-- Configuração de SaveManager e InterfaceManager
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("Rain Blue Lock: Rivals | InterfaceManager")
SaveManager:SetFolder("FluentScriptHub/Rain Blue Lock: Rivals | SaveManager")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Rain hub | notificação",
    Content = "script carregado com sucesso.",
    Duration = 6
})

SaveManager:LoadAutoloadConfig()
