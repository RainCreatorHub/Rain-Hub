local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function setupAccessory(accessory, customWeld)
    if not accessory or not accessory:IsA("Accessory") then
        warn("Accessory not found or invalid: " .. (accessory and accessory.Name or "nil"))
        return
    end

    local handle = accessory:FindFirstChild("Handle")
    if not handle then
        warn("Handle not found in: " .. accessory.Name)
        return
    end

    -- Remove mesh
    local mesh = handle:FindFirstChildWhichIsA("SpecialMesh") or handle:FindFirstChildWhichIsA("MeshPart")
    if mesh then
        mesh:Destroy()
        print("Mesh removed from: " .. accessory.Name)
    else
        warn("No mesh found in: " .. accessory.Name)
    end

    -- Set handle properties to ensure persistence
    handle.CanCollide = false
    handle.Anchored = false
    handle.CanTouch = true -- Ensure it remains interactive
    handle.Locked = true -- Prevent other scripts from modifying it easily

    -- Apply custom weld if provided
    if customWeld then
        local head = accessory.Parent:FindFirstChild("Head")
        if head then
            for _, weld in ipairs(handle:GetChildren()) do
                if weld:IsA("Weld") or weld:IsA("WeldConstraint") then
                    weld:Destroy()
                end
            end
            local newWeld = Instance.new("Weld")
            newWeld.Part0 = head
            newWeld.Part1 = handle
            newWeld.C0 = customWeld
            newWeld.Parent = handle
            print(accessory.Name .. " repositioned")
        end
    end

    -- Monitor VANS_Umbrella specifically to prevent it from disappearing
    if accessory.Name == "VANS_Umbrella" then
        accessory.AncestryChanged:Connect(function(_, parent)
            if not parent then
                warn("VANS_Umbrella was removed! Attempting to reapply...")
                task.wait() -- Wait for next frame to ensure character is ready
                if LocalPlayer.Character then
                    setupAccessories() -- Reapply setup for all accessories
                end
            end
        end)
    end
end

local function setupAccessories()
    local character = LocalPlayer.Character
    if not character then return end

    local accessories = {
        {name = "PogoStick", weld = CFrame.new(-8, 0, 0)}, -- 8 studs to the left
        {name = "PlaneModel"},
        {name = "VANS_Umbrella", weld = CFrame.new(0, 11, 14)}, -- 11 studs above, 14 studs forward
        {name = "Hat1"},
        {name = "Pal Hair"}
    }

    for _, acc in ipairs(accessories) do
        setupAccessory(character:FindFirstChild(acc.name), acc.weld)
    end
end

-- Run initially and on character added
setupAccessories()
LocalPlayer.CharacterAdded:Connect(function()
    -- Wait for character to fully load
    task.wait(0.1)
    setupAccessories()
end)
