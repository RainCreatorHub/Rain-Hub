local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Lista de acessórios a serem modificados
local accessoriesToRemoveMesh = {
    "Hat1",
    "Pal Hair",
    "Pink Hair",
    "Kate Hair",
    "LavanderHair",
    "Robloxclassicred",
    "VANS_Umbrella"
}

-- Função para remover a malha de um acessório
local function removeAccessoryMesh()
    -- Aguarda o personagem estar carregado
    if not LocalPlayer.Character then
        LocalPlayer.CharacterAdded:Wait()
    end

    local character = LocalPlayer.Character

    -- Percorre todos os acessórios no personagem
    for _, accessoryName in ipairs(accessoriesToRemoveMesh) do
        local accessory = character:FindFirstChild(accessoryName)
        if accessory and accessory:IsA("Accessory") then
            local handle = accessory:FindFirstChild("Handle")
            if handle then
                local mesh = handle:FindFirstChildWhichIsA("SpecialMesh") or handle:FindFirstChildWhichIsA("MeshPart")
                if mesh then
                    mesh:Destroy() -- Remove a malha (apenas no cliente)
                    print("Malha removida de: " .. accessoryName)
                else
                    print("Nenhuma malha encontrada em: " .. accessoryName)
                end
            else
                print("Handle não encontrado em: " .. accessoryName)
            end
        else
            print("Acessório não encontrado: " .. accessoryName)
        end
    end
end

-- Executa a função quando o personagem carrega
LocalPlayer.CharacterAdded:Connect(removeAccessoryMesh)
removeAccessoryMesh() -- Executa imediatamente caso o personagem já esteja carregado
