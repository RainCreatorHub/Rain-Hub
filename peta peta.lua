local function addHighlightWithDelay(model)

    wait(0.5)

    local newHighlight = Instance.new("Highlight")

    newHighlight.FillColor = Color3.fromRGB(128, 0, 128) -- you can change fill color

    newHighlight.Parent = model

    

    local function showSpawnNotification()

        local player = game.Players.LocalPlayer

        local screenGui = Instance.new("ScreenGui")

        screenGui.Parent = player:WaitForChild("PlayerGui")

    

        local textLabel = Instance.new("TextLabel")

        textLabel.Text = "( peta peta ) apareceu"

        textLabel.TextColor3 = Color3.new(1, 1, 1) -- White color

        textLabel.BackgroundTransparency = 1

        textLabel.Size = UDim2.new(0.3, 0, 0.1, 0)

        textLabel.Position = UDim2.new(0.35, 0, 0.9, 0)

        textLabel.Font = Enum.Font.SourceSans

        textLabel.TextScaled = true

        textLabel.Parent = screenGui

    

        wait(5)

        local tweenService = game:GetService("TweenService")

        local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        local tween = tweenService:Create(textLabel, tweenInfo, {TextTransparency = 1})

        tween:Play()

    

        tween.Completed:Connect(function()

            screenGui:Destroy()

        end)

    end

    

    model.AncestryChanged:Connect(function(_, parent)

        if not parent then -- If model is destroyed

            local player = game.Players.LocalPlayer

            local screenGui = Instance.new("ScreenGui")

            screenGui.Parent = player:WaitForChild("PlayerGui")

        

            local textLabel = Instance.new("TextLabel")

            textLabel.Text = "( peta peta ) desapareceu"

            textLabel.TextColor3 = Color3.new(1, 1, 1) -- White color

            textLabel.BackgroundTransparency = 1

            textLabel.Size = UDim2.new(0.3, 0, 0.1, 0)

            textLabel.Position = UDim2.new(0.35, 0, 0.9, 0)

            textLabel.Font = Enum.Font.SourceSans

            textLabel.TextScaled = true

            textLabel.Parent = screenGui

        

            wait(5)

            local tweenService = game:GetService("TweenService")

            local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

            local tween = tweenService:Create(textLabel, tweenInfo, {TextTransparency = 1})

            tween:Play()

        

            tween.Completed:Connect(function()

                screenGui:Destroy()

            end)

        end

    end)



    showSpawnNotification()

end



local function checkAndAddHighlight()

    local clientFolder = game.Workspace:FindFirstChild("Client")

    if clientFolder then

        local enemyFolder = clientFolder:FindFirstChild("Enemy")

        if enemyFolder then

            local clientEnemyPart = enemyFolder:FindFirstChild("ClientEnemy")

            if clientEnemyPart and clientEnemyPart:IsA("Part") then

                local enemyModel = clientEnemyPart:FindFirstChild("EnemyModel")

                if enemyModel and enemyModel:IsA("Model") then

                    addHighlightWithDelay(enemyModel)

                end

                

                clientEnemyPart.ChildAdded:Connect(function(model)

                    if model:IsA("Model") and model.Name == "EnemyModel" then

                        addHighlightWithDelay(model)

                    end

                end)

            end

            

            enemyFolder.ChildAdded:Connect(function(part)

                if part:IsA("Part") and part.Name == "ClientEnemy" then

                    part.ChildAdded:Connect(function(model)

                        if model:IsA("Model") and model.Name == "EnemyModel" then

                            addHighlightWithDelay(model)

                        end

                    end)



                    if part:FindFirstChild("EnemyModel") then

                        local existingModel = part:FindFirstChild("EnemyModel")

                        if existingModel:IsA("Model") then

                            addHighlightWithDelay(existingModel)

                        end

                    end

                end

            end)

        end

        

        clientFolder.ChildAdded:Connect(function(subChild)

            if subChild:IsA("Folder") and subChild.Name == "Enemy" then

                subChild.ChildAdded:Connect(function(part)

                    if part:IsA("Part") and part.Name == "ClientEnemy" then

                        part.ChildAdded:Connect(function(model)

                            if model:IsA("Model") and model.Name == "EnemyModel" then

                                addHighlightWithDelay(model)

                            end

                        end)



                        if part:FindFirstChild("EnemyModel") then

                            local existingModel = part:FindFirstChild("EnemyModel")

                            if existingModel:IsA("Model") then

                                addHighlightWithDelay(existingModel)

                            end

                        end

                    end

                end)

            end

        end)

    end

end



local function displayScriptExecutedNotification()

    local player = game.Players.LocalPlayer

    local screenGui = Instance.new("ScreenGui")

    screenGui.Parent = player:WaitForChild("PlayerGui")



    local textLabel = Instance.new("TextLabel")

    textLabel.Text = "Script executado!"

    textLabel.TextColor3 = Color3.new(1, 1, 1) -- White color

    textLabel.BackgroundTransparency = 1

    textLabel.Size = UDim2.new(0.3, 0, 0.1, 0)

    textLabel.Position = UDim2.new(0.35, 0, 0.9, 0)

    textLabel.Font = Enum.Font.SourceSans

    textLabel.TextScaled = true

    textLabel.Parent = screenGui



    local sound = Instance.new("Sound")

    sound.SoundId = "rbxassetid://9064294662"

    sound.Parent = player:WaitForChild("PlayerGui")

    sound:Play()



    wait(5)

    local tweenService = game:GetService("TweenService")

    local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    local tween = tweenService:Create(textLabel, tweenInfo, {TextTransparency = 1})

    tween:Play()



    tween.Completed:Connect(function()

        screenGui:Destroy()

    end)

end



checkAndAddHighlight()

displayScriptExecutedNotification()



game.Workspace.ChildAdded:Connect(function(child)

    if child:IsA("Folder") and child.Name == "Client" then

        child.ChildAdded:Connect(function(subChild)

            if subChild:IsA("Folder") and subChild.Name == "Enemy" then

                subChild.ChildAdded:Connect(function(part)

                    if part:IsA("Part") and part.Name == "ClientEnemy" then

                        part.ChildAdded:Connect(function(model)

                            if model:IsA("Model") and model.Name == "EnemyModel" then

                                addHighlightWithDelay(model)

                            end

                        end)



                        if part:FindFirstChild("EnemyModel") then

                            local existingModel = part:FindFirstChild("EnemyModel")

                            if existingModel:IsA("Model") then

                                addHighlightWithDelay(existingModel)

                            end

                        end

                    end

                end)

   

                if subChild:FindFirstChild("ClientEnemy") then

                    local existingPart = subChild:FindFirstChild("ClientEnemy")

                    if existingPart:IsA("Part") then

                        existingPart.ChildAdded:Connect(function(model)

                            if model:IsA("Model") and model.Name == "EnemyModel" then

                                addHighlightWithDelay(model)

                            end

                        end)



                        if existingPart:FindFirstChild("EnemyModel") then

                            local existingModel = existingPart:FindFirstChild("EnemyModel")

                            if existingModel:IsA("Model") then

                                addHighlightWithDelay(existingModel)

                            end

                        end

                    end

                end

            end

        end)

    end

end)
