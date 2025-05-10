-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Criar GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeySystemGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Container arredondado
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 420, 0, 200)
frame.Position = UDim2.new(0.5, -210, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = frame

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Key System"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BorderSizePixel = 0
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- Botão de fechar
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
closeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
closeButton.BorderSizePixel = 0
closeButton.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Botão de Settings
local settingsButton = Instance.new("TextButton")
settingsButton.Size = UDim2.new(0, 30, 0, 30)
settingsButton.Position = UDim2.new(1, -70, 0, 5)
settingsButton.Text = "⚙"
settingsButton.Font = Enum.Font.GothamBold
settingsButton.TextSize = 18
settingsButton.TextColor3 = Color3.fromRGB(100, 200, 255)
settingsButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
settingsButton.BorderSizePixel = 0
settingsButton.Parent = frame

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 8)
settingsCorner.Parent = settingsButton

settingsButton.MouseButton1Click:Connect(function()
    warn("Botão Settings clicado! (adicione funções aqui)")
end)

-- Caixa de texto com o código
local originalCode = '_G.Key = "PASSWORD"\nloadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Game-Test/refs/heads/main/Key%20System"))()'
local codeBox = Instance.new("TextBox")
codeBox.Size = UDim2.new(0.9, 0, 0, 60)
codeBox.Position = UDim2.new(0.05, 0, 0.25, 0)
codeBox.TextWrapped = true
codeBox.ClearTextOnFocus = false
codeBox.TextEditable = true -- Allow editing to detect changes
codeBox.Text = originalCode
codeBox.Font = Enum.Font.Code
codeBox.TextSize = 16
codeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
codeBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
codeBox.TextYAlignment = Enum.TextYAlignment.Top
codeBox.Parent = frame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 8)
boxCorner.Parent = codeBox

-- Proteger o conteúdo da codeBox
codeBox:GetPropertyChangedSignal("Text"):Connect(function()
    if codeBox.Text ~= originalCode then
        codeBox.Text = originalCode -- Restaurar o texto original
        showConfirmation("Alteração Não Permitida!", Color3.fromRGB(255, 100, 100))
    end
end)

-- Botão de copiar (azul)
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0.43, 0, 0, 35)
copyButton.Position = UDim2.new(0.05, 0, 0.65, 0)
copyButton.Text = "Copiar Script"
copyButton.Font = Enum.Font.Gotham
copyButton.TextSize = 18
copyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- Blue
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.Parent = frame

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 8)
copyCorner.Parent = copyButton

-- Botão "Get Key" (azul)
local getKeyButton = Instance.new("TextButton")
getKeyButton.Size = UDim2.new(0.43, 0, 0, 35)
getKeyButton.Position = UDim2.new(0.52, 0, 0.65, 0)
getKeyButton.Text = "Get Key"
getKeyButton.Font = Enum.Font.Gotham
getKeyButton.TextSize = 18
getKeyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- Blue
getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyButton.Parent = frame

local getKeyCorner = Instance.new("UICorner")
getKeyCorner.CornerRadius = UDim.new(0, 8)
getKeyCorner.Parent = getKeyButton

-- Confirmação animada
local confirmLabel = Instance.new("TextLabel")
confirmLabel.Size = UDim2.new(1, 0, 0, 20)
confirmLabel.Position = UDim2.new(0, 0, 1, -20)
confirmLabel.Text = ""
confirmLabel.Font = Enum.Font.Gotham
confirmLabel.TextSize = 14
confirmLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
confirmLabel.BackgroundTransparency = 1
confirmLabel.Visible = false
confirmLabel.Parent = frame

-- Função para animação de confirmação
local function showConfirmation(message, color)
    confirmLabel.Text = message
    confirmLabel.TextColor3 = color or Color3.fromRGB(0, 255, 100)
    confirmLabel.Visible = true
    confirmLabel.TextTransparency = 1

    -- Animação de fade-in
    for i = 1, 10 do
        confirmLabel.TextTransparency = 1 - (i / 10)
        wait(0.02)
    end

    wait(1)

    -- Animação de fade-out
    for i = 1, 10 do
        confirmLabel.TextTransparency = i / 10
        wait(0.02)
    end

    confirmLabel.Visible = false
end

-- Evento do botão de copiar
copyButton.MouseButton1Click:Connect(function()
    setclipboard(codeBox.Text)
    showConfirmation("Script Copiado!")
end)

-- Evento do botão "Get Key"
getKeyButton.MouseButton1Click:Connect(function()
    setclipboard("https://🥶⃤.my.canva.site/key-system-1-2")
    showConfirmation("Link Copiado!")
end)

-- Tema arco-íris dinâmico no título
task.spawn(function()
    while true do
        local t = tick() * 2
        local r = math.sin(t) * 127 + 128
        local g = math.sin(t + 2) * 127 + 128
        local b = math.sin(t + 4) * 127 + 128
        title.BackgroundColor3 = Color3.fromRGB(r, g, b)
        RunService.RenderStepped:Wait()
    end
end)
