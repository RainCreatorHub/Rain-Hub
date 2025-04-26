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

-- Função para modificar acessórios
local function modifyAccessories()
    local character = LocalPlayer.Character
    if not character then return end

    local head = character:FindFirstChild("Head") -- Referência à cabeça

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

                -- Desativa a colisão
                handle.CanCollide = false
                handle.Anchored = false -- Não ancorado, segue o weld

                -- Ajusta o VANS_Umbrella para ficar acima da cabeça
                if accessoryName == "VANS_Umbrella" and head then
                    -- Remove o weld existente
                    local weld = handle:FindFirstChildWhichIsA("Weld") or handle:FindFirstChildWhichIsA("WeldConstraint")
                    if weld then
                        weld:Destroy()
                    end

                    -- Cria um novo weld para posicionar acima da cabeça
                    local newWeld = Instance.new("Weld")
                    newWeld.Part0 = head
                    newWeld.Part1 = handle
                    newWeld.C0 = CFrame.new(0, 2, 0) -- 2 studs acima da cabeça
                    newWeld.Parent = handle
                    print("VANS_Umbrella posicionado acima da cabeça")
                end

                print("Configurado para seguir o LocalPlayer: " .. accessoryName)
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
