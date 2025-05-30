local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local function getHRP()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Rain hub | Blue Lock: Rivals",
    SubTitle = "by zaque_blox",
    TabWidth = 160,
    Size = UDim2.fromOffset(450, 340),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Função para encontrar a bola "Football" válida
local function findValidFootball()
    local validFootball = nil

    -- Verifica diretamente na workspace
    local direct = workspace:FindFirstChild("Football")
    if direct and direct:IsA("BasePart") then
        validFootball = direct
    end

    -- Verifica nas pastas/modelos de jogadores
    for _, obj in pairs(workspace:GetChildren()) do
        if obj ~= LocalPlayer.Character and (obj:IsA("Folder") or obj:IsA("Model")) then
            local football = obj:FindFirstChild("Football")
            if football and football:IsA("BasePart") then
                validFootball = football
                break
            end
        end
    end

    -- Se tiver uma bola dentro da pasta do LocalPlayer, ignora
    local myFootball = nil
    local char = LocalPlayer.Character
    if char then
        myFootball = char:FindFirstChild("Football")
    end

    -- Só retorna a bola se não estiver com o LocalPlayer
    if validFootball and validFootball ~= myFootball then
        return validFootball
    end

    return nil
end

-- Toggle: Auto Get Ball
local running = false
local autoGetBallToggle = Tabs.Main:AddToggle("AutoGetBall", {
    Title = "Auto Get Ball",
    Default = false,
    Description = "Teleporta automaticamente até a bola 'Football' (exceto se estiver com você)"
})

autoGetBallToggle:OnChanged(function(state)
    running = state
    if running then
        task.spawn(function()
            while running and not Fluent.Unloaded do
                local football = findValidFootball()
                if football then
                    local hrp = getHRP()
                    hrp.CFrame = football.CFrame + Vector3.new(0, 3, 0)
                end
                task.wait(0.5)
            end
        end)
    end
end)

-- Configuração do SaveManager e InterfaceManager
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("Fluentkk")
SaveManager:SetFolder("FluentScriptHub/BlueLock")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Rain hub",
    Content = "script carregado com sucesso.",
    Duration = 5
})

SaveManager:LoadAutoloadConfig()
