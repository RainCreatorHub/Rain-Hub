local OrionLibV2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/RainLibV2/refs/heads/main/OrionLibV2.lua"))()

-- Criação da janela principal
local window = OrionLibV2:MakeWindow({
    Title = "Rain Hub | Forsaken",
    SubTitle = "By Zaque_blox"
})

-- Referência ao jogador local
local player = game.Players.LocalPlayer

-- Aba: Informações
local infoTab = window:MakeTab({ Name = "Info" })
local section = infoTab:AddSection({ Name = "info" })

local Label = infoTab:AddLabel({
    Name = "Bem-vindo(a) " .. player.Name .. " ao Rain Hub para Forsaken!",
    Content = "Nome Bonito!"
})

local Label = infoTab:AddLabel({
    Name = "Idade da conta: " .. player.AccountAge,
    Content = "Ta velho(a) em kk"
})

-- Aba: Main (reservada para futuras funcionalidades)
local mainTab = window:MakeTab({ Name = "Main" })
local section = mainTab:AddSection({ Name = "Main" })

-- Aba: ESP
local espTab = window:MakeTab({ Name = "esp" })
local section = espTab:AddSection({ Name = "esp" })

-- Módulo: ESP para Geradores
local GeneratorESP = { running = false, highlights = {} }

-- Função para verificar progresso da barra
function GeneratorESP:checkProgress(generator)
    local progress = generator:FindFirstChild("Progress", true)
    if progress then
        local barUI = progress:FindFirstChild("BarUI")
        if barUI then
            local bar = barUI:FindFirstChild("Bar")
            local background = barUI:FindFirstChild("Background")
            if bar and background then
                return bar.Size.X.Scale >= (background.Size.X.Scale * 0.95) -- Considera proximidade de 95%
            end
        end
    end
    return false
end

-- Cria ou atualiza o highlight do objeto
function GeneratorESP:manageHighlight(obj, color)
    if not self.highlights[obj] then
        local highlight = Instance.new("Highlight")
        highlight.Name = "RainHubGeneratorESP"
        highlight.Adornee = obj
        highlight.FillColor = color
        highlight.OutlineColor = color
        highlight.FillTransparency = 0.3
        highlight.OutlineTransparency = 0
        highlight.Parent = obj
        self.highlights[obj] = highlight
    else
        self.highlights[obj].FillColor = color
        self.highlights[obj].OutlineColor = color
    end
end

-- Atualiza os highlights dos geradores
function GeneratorESP:updateHighlights()
    for obj, _ in pairs(self.highlights) do
        if not obj:IsDescendantOf(workspace) then
            self.highlights[obj]:Destroy()
            self.highlights[obj] = nil
        end
    end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == "Generator" then
            local cor = self:checkProgress(obj) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 0)
            self:manageHighlight(obj, cor)
        end
    end
end

-- Inicia ESP de geradores
function GeneratorESP:start()
    self.running = true
    task.spawn(function()
        while self.running do
            GeneratorESP:updateHighlights()
            task.wait(0.5)
        end
    end)
end

-- Para ESP de geradores
function GeneratorESP:stop()
    self.running = false
    for _, highlight in pairs(self.highlights) do
        highlight:Destroy()
    end
    self.highlights = {}
end

-- Toggle para ativar/desativar ESP de Gerador (s)
local Toggle = espTab:AddToggle({
    Name = "Generator (s)",
    Description = "Destaca geradores com ESP (verde para cheios, amarelo para não cheios)",
    Default = false,
    Callback = function(state)
        if state then
            GeneratorESP:start()
        else
            GeneratorESP:stop()
        end
    end
})

-- Módulo: ESP para Rigs (Survivors e Killers)
local RigsESP = { runningSurvivors = false, runningKillers = false, highlights = {} }

-- Cria ou atualiza o highlight do rig
function RigsESP:manageHighlight(model, cor)
    if not self.highlights[model] then
        local highlight = Instance.new("Highlight")
        highlight.Name = "RainHubRigESP"
        highlight.Adornee = model
        highlight.FillColor = cor
        highlight.OutlineColor = cor
        highlight.FillTransparency = 0.3
        highlight.OutlineTransparency = 0
        highlight.Parent = model
        self.highlights[model] = highlight
    end
end

-- Toggle para ativar/desativar ESP de Survivor (s)
local ToggleSurvivors = espTab:AddToggle({
    Name = "Survivor (s)",
    Description = "Destaca Survivors (verde)",
    Default = false,
    Callback = function(state)
        if state then
            RigsESP.runningSurvivors = true
            task.spawn(function()
                while RigsESP.runningSurvivors do
                    local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
                    if survivorsFolder then
                        for _, model in ipairs(survivorsFolder:GetChildren()) do
                            if model:IsA("Model") and model:FindFirstChildWhichIsA("Humanoid") then
                                RigsESP:manageHighlight(model, Color3.fromRGB(0, 255, 0))
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
        else
            RigsESP.runningSurvivors = false
            for obj, highlight in pairs(RigsESP.highlights) do
                if highlight.FillColor == Color3.fromRGB(0, 255, 0) then
                    highlight:Destroy()
                    RigsESP.highlights[obj] = nil
                end
            end
        end
    end
})

-- Toggle para ativar/desativar ESP de Killer (s)
local ToggleKillers = espTab:AddToggle({
    Name = "Killer (s)",
    Description = "Destaca Killers (vermelho)",
    Default = false,
    Callback = function(state)
        if state then
            RigsESP.runningKillers = true
            task.spawn(function()
                while RigsESP.runningKillers do
                    local killersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
                    if killersFolder then
                        for _, model in ipairs(killersFolder:GetChildren()) do
                            if model:IsA("Model") and model:FindFirstChildWhichIsA("Humanoid") then
                                RigsESP:manageHighlight(model, Color3.fromRGB(255, 0, 0))
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
        else
            RigsESP.runningKillers = false
            for obj, highlight in pairs(RigsESP.highlights) do
                if highlight.FillColor == Color3.fromRGB(255, 0, 0) then
                    highlight:Destroy()
                    RigsESP.highlights[obj] = nil
                end
            end
        end
    end
})
