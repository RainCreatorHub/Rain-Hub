-- Carrega a biblioteca OrionLibV2
local p = "https://pastebin.com/raw/7pirbSGM"
local OrionLibV2 = loadstring(game:HttpGet(p))()

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

local label = infoTab:AddLabel({
    Name = "Bem-vindo(a) " .. player.Name .. " ao Rain Hub para Forsaken!",
    Content = "Nome Bonito!"
})

local label = infoTab:AddLabel({
    Name = "Idade da conta: " .. player.AccountAge,
    Content = "Ta velho(a) em kk"
})

local section = infoTab:AddSection({ Name = "creator" })

local label = infoTab:AddLabel({
    Name = "Membros: zaque_blox - ( titok )"
    Content = "Infelizmente só eu..."
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
                return bar.Size.X.Scale >= (background.Size.X.Scale * 0.95) -- Se Bar estiver igual ou maior que 95% de Background
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

-- Toggle para ativar/desativar ESP de geradores
local Toggle = espTab:AddToggle({
    Name = "Generator",
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
local RigsESP = { running = false, highlights = {} }

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

-- Atualiza ESP de rigs
function RigsESP:update()
    for model, _ in pairs(self.highlights) do
        if not model:IsDescendantOf(workspace) then
            self.highlights[model]:Destroy()
            self.highlights[model] = nil
        end
    end

    local playersFolder = workspace:FindFirstChild("Players")
    if not playersFolder then return end

    local survivorsFolder = playersFolder:FindFirstChild("Survivors")
    if survivorsFolder then
        for _, model in ipairs(survivorsFolder:GetChildren()) do
            if model:IsA("Model") and model:FindFirstChildWhichIsA("Humanoid") then
                self:manageHighlight(model, Color3.fromRGB(0, 255, 0))
            end
        end
    end

    local killersFolder = playersFolder:FindFirstChild("Killers")
    if killersFolder then
        for _, model in ipairs(killersFolder:GetChildren()) do
            if model:IsA("Model") and model:FindFirstChildWhichIsA("Humanoid") then
                self:manageHighlight(model, Color3.fromRGB(255, 0, 0))
            end
        end
    end
end

-- Inicia ESP de rigs
function RigsESP:start()
    self.running = true
    task.spawn(function()
        while self.running do
            self:update()
            task.wait(0.5)
        end
    end)
end

-- Para ESP de rigs
function RigsESP:stop()
    self.running = false
    for _, highlight in pairs(self.highlights) do
        highlight:Destroy()
    end
    self.highlights = {}
end

-- Toggle para ativar/desativar ESP de survivors e killers
local Toggle = espTab:AddToggle({
    Name = "Survivors/Killers",
    Description = "Destaca Survivors (verde) e Killers (vermelho)",
    Default = false,
    Callback = function(state)
        if state then
            RigsESP:start()
        else
            RigsESP:stop()
        end
    end
})
