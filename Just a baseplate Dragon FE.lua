local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local function setupAccessory(accessory, customWeld, initialOffset)
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
    handle.CanTouch = true
    handle.Locked = true

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

            -- Start at initial offset (20 studs below) if specified
            if initialOffset then
                newWeld.C0 = customWeld * CFrame.new(0, -20, 0)
                -- Animate to original position
                local tweenInfo = TweenInfo.new(
                    10, -- Duration (10 seconds for smooth rise)
                    Enum.EasingStyle.Sine,
                    Enum.EasingDirection.InOut
                )
                local tween = TweenService:Create(newWeld, tweenInfo, {C0 = customWeld})
                tween:Play()
            else
                newWeld.C0 = customWeld
            end

            newWeld.Parent = handle
            print(accessory.Name .. " repositioned")
        end
    end

    -- Monitor VANS_Umbrella specifically to prevent it from disappearing
    if accessory.Name == "VANS_Umbrella" then
        accessory.AncestryChanged:Connect(function(_, parent)
            if not parent then
                warn("VANS_Umbrella was removed! Attempting to reapply...")
                task.wait()
                if LocalPlayer.Character then
                    setupAccessories()
                end
            end
        end)
    end
end

local function setupAccessories()
    local character = LocalPlayer.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        -- Set JumpPower and WalkSpeed to 0
        humanoid.JumpPower = 0
        humanoid.WalkSpeed = 0
        -- Restore defaults after 10 seconds
        task.delay(10, function()
            humanoid.JumpPower = 50 -- Default Roblox JumpPower
            humanoid.WalkSpeed = 16 -- Default Roblox WalkSpeed
        end)
    end

    local accessories = {
        {name = "PogoStick", weld = CFrame.new(-8, 0, 0) * CFrame.Angles(0, math.rad(90), 0), offset = true}, -- 8 studs to the left, rotated to face right
        {name = "PlaneModel"},
        {name = "VANS_Umbrella", weld = CFrame.new(0, 11, 14), offset = true}, -- 11 studs above, 14 studs forward
        {name = "Hat1"},
        {name = "Pal Hair"}
    }

    for _, acc in ipairs(accessories) do
        setupAccessory(character:FindFirstChild(acc.name), acc.weld, acc.offset)
    end
end

-- Run initially and on character added
setupAccessories()
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.1)
    setupAccessories()
end)
