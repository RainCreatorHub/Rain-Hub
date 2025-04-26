local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Lista de acessórios a serem modificados
local accessoriesToModify = {
    "Hat1",
    "Pal Hair",
    "Pink Hair",
    "Kate Hair",
    "LavanderHair",
    "Robloxclassicred",
    "VANS_Umbrella"
}

-- Função para tornar o personagem não colidível
local function setPlayerNonCollidable(character)
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

-- Função para modificar acessórios
local function modifyAccessories()
    local character = LocalPlayer.Character
    if not character then return end

    -- Torna o personagem não colidível
    setPlayerNonCollidable(character)

    -- Percorre todos os acessórios na lista
    for _, accessoryName in ipairs(accessoriesToModify) do
        local accessory = character:FindFirstChild(accessoryName)
        if accessory and accessory:IsA("Accessory") then
            local handle = accessory:FindFirstChild("Handle")
            if handle then
                -- Remove a malha
                local mesh = handle:FindFirstChildWhichIsA("SpecialMesh") or handle:FindFirstChildWhichIsA("MeshPart")
                if mesh then
                    mesh:Destroy()
                    print("Malha removida de: " .. accessoryName)
                else
                    print("Nenhuma malha encontrada em: " .. accessoryName)
                end

                -- Ativa a colisão estática
                handle.CanCollide = true
                handle.Anchored = true -- Sem física, permanece estático

                print("Colisão estática ativada em: " .. accessoryName)
            else
                print("Handle não encontrado em: " .. accessoryName)
            end
        else
            print("Acessório não encontrado: " .. accessoryName)
        end
    end
end

-- Executa a função imediatamente e para novos personagens
modifyAccessories()
LocalPlayer.CharacterAdded:Connect(modifyAccessories)
