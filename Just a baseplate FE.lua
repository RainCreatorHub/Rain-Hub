local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Função para configurar os acessórios
local function setupAccessories()
    local character = LocalPlayer.Character
    if not character then return end

    local head = character:FindFirstChild("Head")

    -- Remove malhas e configura os acessórios diretamente
    -- PogoStick (Nike Shoebox Costume)
    local pogoStick = character:FindFirstChild("PogoStick")
    if pogoStick and pogoStick:IsA("Accessory") then
        local handle = pogoStick:FindFirstChild("Handle")
        if handle then
            local mesh = handle:FindFirstChildWhichIsA("SpecialMesh") or handle:FindFirstChildWhichIsA("MeshPart")
            if mesh then
                mesh:Destroy()
                print("Malha removida de: PogoStick")
            else
                print("Nenhuma malha encontrada em: PogoStick")
            end
            handle.CanCollide = false
            handle.Anchored = false -- Segue o weld
        else
            print("Handle não encontrado em: PogoStick")
        end
    else
        print("Acessório não encontrado: PogoStick")
    end

    -- PlaneModel
    local planeModel = character:FindFirstChild("PlaneModel")
    if planeModel and planeModel:IsA("Accessory") then
        local handle = planeModel:FindFirstChild("Handle")
        if handle then
            local mesh = handle:FindFirstChildWhichIsA("SpecialMesh") or handle:FindFirstChildWhichIsA("MeshPart")
            if mesh then
                mesh:Destroy()
                print("Malha removida de: PlaneModel")
            else
                print("Nenhuma malha encontrada em: PlaneModel")
            end
            handle.CanCollide = false
            handle.Anchored = false -- Segue o weld
        else
            print("Handle não encontrado em: PlaneModel")
        end
    else
        print("Acessório não encontrado: PlaneModel")
    end

    -- VANS_Umbrella
    local vansUmbrella = character:FindFirstChild("VANS_Umbrella")
    if vansUmbrella and vansUmbrella:IsA("Accessory") then
        local handle = vansUmbrella:FindFirstChild("Handle")
        if handle then
            local mesh = handle:FindFirstChildWhichIsA("SpecialMesh") or handle:FindFirstChildWhichIsA("MeshPart")
            if mesh then
                mesh:Destroy()
                print("Malha removida de: VANS_Umbrella")
            else
                print("Nenhuma malha encontrada em: VANS_Umbrella")
            end
            handle.CanCollide = false
            handle.Anchored = false -- Segue o weld

            -- Ajusta o VANS_Umbrella para ficar 11 studs acima e 14 studs para frente
            if head then
                local weld = handle:FindFirstChildWhichIsA("Weld") or handle:FindFirstChildWhichIsA("WeldConstraint")
                if weld then
                    weld:Destroy()
                end
                local newWeld = Instance.new("Weld")
                newWeld.Part0 = head
                newWeld.Part1 = handle
                newWeld.C0 = CFrame.new(0, 11, 14) -- 11 studs acima, 14 studs para frente
                newWeld.Parent = handle
                print("VANS_Umbrella posicionado 11 studs acima e 14 studs para frente")
            end
        else
            print("Handle não encontrado em: VANS_Umbrella")
        end
    else
        print("Acessório não encontrado: VANS_Umbrella")
    end

    -- Hat1
    local hat1 = character:FindFirstChild("Hat1")
    if hat1 and hat1:IsA("Accessory") then
        local handle = hat1:FindFirstChild("Handle")
        if handle then
            local mesh = handle:FindFirstChildWhichIsA("SpecialMesh") or handle:FindFirstChildWhichIsA("MeshPart")
            if mesh then
                mesh:Destroy()
                print("Malha removida de: Hat1")
            else
                print("Nenhuma malha encontrada em: Hat1")
            end
            handle.CanCollide = false
            handle.Anchored = false -- Segue o weld
        else
            print("Handle não encontrado em: Hat1")
        end
    else
        print("Acessório não encontrado: Hat1")
    end

    -- Pal Hair
    local palHair = character:FindFirstChild("Pal Hair")
    if palHair and palHair:IsA("Accessory") then
        local handle = palHair:FindFirstChild("Handle")
        if handle then
            local mesh = handle:FindFirstChildWhichIsA("SpecialMesh") or handle:FindFirstChildWhichIsA("MeshPart")
            if mesh then
                mesh:Destroy()
                print("Malha removida de: Pal Hair")
            else
                print("Nenhuma malha encontrada em: Pal Hair")
            end
            handle.CanCollide = false
            handle.Anchored = false -- Segue o weld
        else
            print("Handle não encontrado em: Pal Hair")
        end
    else
        print("Acessório não encontrado: Pal Hair")
    end
end

-- Executa a função imediatamente e para novos personagens
setupAccessories()
LocalPlayer.CharacterAdded:Connect(setupAccessories)
