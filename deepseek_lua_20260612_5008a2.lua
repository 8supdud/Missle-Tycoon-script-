--[[
    NUCLEARBOBO ULTIMATE HUB - COMPLETE EDITION
    Asylum Life - With TP to Players, TP to Safe Zone, Auto Kill, Anti-Ragdoll
]]

-- ANTI-DETECTION LAYER 1: METATABLE PROTECTION
local function setupMetatableProtection()
    local mt = getrawmetatable and getrawmetatable(game) or getmetatable(game)
    if mt then
        local old_namecall = mt.__namecall
        local old_index = mt.__index
        
        setreadonly(mt, false)
        
        mt.__namecall = function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            
            if method == "FindFirstChild" and tostring(args[1]):match("Script") then
                return nil
            end
            if method == "GetDescendants" then
                return {}
            end
            if method == "GetChildren" then
                return {}
            end
            
            return old_namecall(self, ...)
        end
        
        mt.__index = function(self, key)
            if key == "Source" or key == "Script" then
                return nil
            end
            return old_index(self, key)
        end
        
        setreadonly(mt, true)
    end
end

-- ANTI-DETECTION LAYER 2: ENVIRONMENT CLEANUP
local function cleanEnvironment()
    for i = 1, 100 do print("") end
    
    local oldWrite = writefile
    local oldAppend = appendfile
    
    writefile = function() end
    appendfile = function() end
    
    getgenv()._NuclearboboIdentity = "Nuclearbobo_" .. math.random(100000, 999999)
end

-- ANTI-RAGDOLL SYSTEM
local antiRagdoll = {
    active = true,
    connections = {}
}

local function setupAntiRagdoll()
    local player = game.Players.LocalPlayer
    
    local function fixRagdoll(character)
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        if humanoid.PlatformStand then
            humanoid.PlatformStand = false
        end
        
        if humanoid.Sit then
            humanoid.Sit = false
        end
        
        local humanoidRoot = character:FindFirstChild("HumanoidRootPart")
        if humanoidRoot then
            humanoidRoot.Anchored = false
        end
        
        for _, constraint in pairs(character:GetDescendants()) do
            if constraint:IsA("Motor6D") and (constraint.Name:lower():match("ragdoll") or constraint.Name:lower():match("limp")) then
                constraint:Destroy()
            end
        end
        
        humanoid.AutoRotate = true
        humanoid.HipHeight = 2
    end
    
    local function continuousProtection(character)
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        local connection = game:GetService("RunService").RenderStepped:Connect(function()
            if not antiRagdoll.active then return end
            
            if character and character.Parent then
                if humanoid.PlatformStand then
                    humanoid.PlatformStand = false
                end
                
                if humanoid.Sit then
                    humanoid.Sit = false
                end
                
                local humanoidRoot = character:FindFirstChild("HumanoidRootPart")
                if humanoidRoot and humanoidRoot.JointsCount < 10 then
                    fixRagdoll(character)
                end
            end
        end)
        
        table.insert(antiRagdoll.connections, connection)
    end
    
    local function onCharacterAdded(character)
        task.wait(0.5)
        continuousProtection(character)
        
        local humanoid = character:WaitForChild("Humanoid")
        local stateConnection = humanoid.StateChanged:Connect(function(oldState, newState)
            if not antiRagdoll.active then return end
            
            if newState == Enum.HumanoidStateType.Physics then
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                task.wait(0.1)
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
            
            if newState == Enum.HumanoidStateType.PlatformStand then
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
            
            if newState == Enum.HumanoidStateType.FallingDown then
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
        
        table.insert(antiRagdoll.connections, stateConnection)
    end
    
    if player.Character then
        onCharacterAdded(player.Character)
    end
    
    player.CharacterAdded:Connect(onCharacterAdded)
end

-- ANTI-DETECTION LAYER 3: RANDOMIZED BEHAVIOR
local function randomWait(min, max)
    local delay = (min or 0.05) + (math.random() * (max or 0.15))
    task.wait(delay)
end

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local currentCamera = workspace.CurrentCamera

-- SETTINGS
local config = {
    hitbox = 7,
    walkspeed = 16,
    jumppower = 50,
    gravity = 196.2,
    flySpeed = 50,
    noclip = false,
    fly = false,
    autoKill = false,
    autoPunch = false,
    autoTeleport = false,
    teleportDelay = 2
}

-- VARIABLES
local character = LP.Character
local humanoidRoot = character and character:FindFirstChild("HumanoidRootPart")
local humanoid = character and character:FindFirstChild("Humanoid")
local autoPunchActive = false
local autoKillActive = false
local autoTeleportActive = false
local flyConnection = nil
local noclipConnection = nil
local flyBodyVelocity = nil
local flyBodyGyro = nil
local flying = false
local selectedPlayer = nil

-- Initialize anti-ragdoll
setupAntiRagdoll()

-- TP TO PLAYER FUNCTION
local function teleportToPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then
        return false
    end
    
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then
        return false
    end
    
    local currentChar = LP.Character
    if not currentChar then
        return false
    end
    
    local currentRoot = currentChar:FindFirstChild("HumanoidRootPart")
    if not currentRoot then
        return false
    end
    
    -- Smooth teleport with visual effect
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(currentRoot, tweenInfo, {CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)})
    tween:Play()
    tween.Completed:Wait()
    
    return true
end

-- TP TO SAFE ZONE FUNCTION
local function teleportToSafeZone()
    local safeZonePositions = {
        Vector3.new(1000, 1000, 1000),
        Vector3.new(-1000, 1000, -1000),
        Vector3.new(0, 1000, 0),
        Vector3.new(500, 500, 500)
    }
    
    local safePos = safeZonePositions[math.random(1, #safeZonePositions)]
    
    -- Create safe zone visual
    local safePart = Instance.new("Part")
    safePart.Size = Vector3.new(50, 1, 50)
    safePart.Position = safePos
    safePart.Anchored = true
    safePart.Transparency = 0.5
    safePart.Color = Color3.fromRGB(0, 255, 0)
    safePart.Material = Enum.Material.Neon
    safePart.Parent = workspace
    
    -- Teleport with effect
    if humanoidRoot then
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(humanoidRoot, tweenInfo, {CFrame = safePart.CFrame * CFrame.new(0, 3, 0)})
        tween:Play()
        tween.Completed:Wait()
    end
    
    task.wait(2)
    safePart:Destroy()
    
    return true
end

-- AUTO TELEPORT TO NEAREST PLAYER
local function startAutoTeleport()
    task.spawn(function()
        while autoTeleportActive and humanoid and humanoid.Health > 0 do
            local nearestPlayer = nil
            local nearestDistance = math.huge
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LP and player.Character then
                    local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot and humanoidRoot then
                        local distance = (targetRoot.Position - humanoidRoot.Position).Magnitude
                        if distance < nearestDistance then
                            nearestDistance = distance
                            nearestPlayer = player
                        end
                    end
                end
            end
            
            if nearestPlayer then
                teleportToPlayer(nearestPlayer)
            end
            
            randomWait(config.teleportDelay, config.teleportDelay + 1)
        end
    end)
end

-- TP TO SPECIFIC PLAYER FUNCTION
local function teleportToSelectedPlayer()
    if selectedPlayer and selectedPlayer.Character then
        teleportToPlayer(selectedPlayer)
        return true
    end
    return false
end

-- CREATE PLAYER LIST FOR TP
local function createPlayerList(mainFrame, yOffset)
    local playerListFrame = Instance.new("ScrollingFrame")
    playerListFrame.Size = UDim2.new(0, 280, 0, 120)
    playerListFrame.Position = UDim2.new(0.5, -140, 0, yOffset)
    playerListFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    playerListFrame.BackgroundTransparency = 0.3
    playerListFrame.BorderSizePixel = 0
    playerListFrame.ScrollBarThickness = 5
    playerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    playerListFrame.Parent = mainFrame
    
    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 8)
    listCorner.Parent = playerListFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 25)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "👥 CLICK PLAYER TO TP"
    titleLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 12
    titleLabel.Parent = playerListFrame
    
    local playerButtons = {}
    local buttonY = 25
    
    local function refreshPlayerList()
        -- Clear existing buttons
        for _, btn in pairs(playerButtons) do
            if btn then pcall(function() btn:Destroy() end) end
        end
        playerButtons = {}
        buttonY = 25
        
        -- Get all players
        local players = Players:GetPlayers()
        local canvasHeight = 25 + (#players * 30)
        playerListFrame.CanvasSize = UDim2.new(0, 0, 0, canvasHeight)
        
        for _, player in pairs(players) do
            if player ~= LP then
                local playerBtn = Instance.new("TextButton")
                playerBtn.Size = UDim2.new(1, -10, 0, 28)
                playerBtn.Position = UDim2.new(0, 5, 0, buttonY)
                playerBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                playerBtn.Text = player.Name .. " [" .. (player.Character and "Online" or "Offline") .. "]"
                playerBtn.TextColor3 = player.Character and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
                playerBtn.Font = Enum.Font.Gotham
                playerBtn.TextSize = 12
                playerBtn.Parent = playerListFrame
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 5)
                btnCorner.Parent = playerBtn
                
                playerBtn.MouseButton1Click:Connect(function()
                    selectedPlayer = player
                    -- Highlight selected
                    for _, btn in pairs(playerButtons) do
                        if btn then
                            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                        end
                    end
                    playerBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 150)
                    
                    -- Teleport immediately on click
                    teleportToSelectedPlayer()
                end)
                
                table.insert(playerButtons, playerBtn)
                buttonY = buttonY + 32
            end
        end
    end
    
    -- Refresh list initially and when players join/leave
    refreshPlayerList()
    Players.PlayerAdded:Connect(refreshPlayerList)
    Players.PlayerRemoving:Connect(refreshPlayerList)
    
    -- Refresh periodically
    task.spawn(function()
        while playerListFrame and playerListFrame.Parent do
            task.wait(5)
            pcall(refreshPlayerList)
        end
    end)
    
    return playerListFrame
end

-- STEALTH UI CREATION
local function createStealthUI()
    local guiNames = {"RobloxGui", "CoreGui", "PlayerList", "Chat", "Backpack", "HealthGui"}
    local guiName = guiNames[math.random(1, #guiNames)] .. "_" .. math.random(1000, 9999)
    
    local gui = Instance.new("ScreenGui")
    gui.Name = guiName
    gui.Parent = LP:WaitForChild("PlayerGui")
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    
    return gui
end

-- CREATE MAIN UI
local function createUI()
    local gui = createStealthUI()
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 420, 0, 700)
    mainFrame.Position = UDim2.new(0.5, -210, 0.5, -350)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = gui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = mainFrame
    
    -- Scrolling frame for content
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -10, 1, -10)
    scrollFrame.Position = UDim2.new(0, 5, 0, 5)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 900)
    scrollFrame.Parent = mainFrame
    
    -- Rainbow border
    local border = Instance.new("UIStroke")
    border.Thickness = 2
    border.Color = Color3.fromRGB(255, 0, 0)
    border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    border.Parent = mainFrame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 45)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚡ NUCLEARBOBO HUB ⚡"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.FredokaOne
    title.TextSize = 22
    title.Parent = scrollFrame
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 20)
    subtitle.Position = UDim2.new(0, 0, 0, 40)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Complete Asylum Life Hub | Anti-Ragdoll | Player Teleport"
    subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 11
    subtitle.Parent = scrollFrame
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.FredokaOne
    closeBtn.TextSize = 18
    closeBtn.Parent = mainFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = closeBtn
    
    local yOffset = 70
    
    -- Helper function to create buttons
    local function createButton(text, yPos, color)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 300, 0, 38)
        btn.Position = UDim2.new(0.5, -150, 0, yPos)
        btn.BackgroundColor3 = color
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.Parent = scrollFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        return btn
    end
    
    local function createSlider(text, yPos, minVal, maxVal, currentVal)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0, 300, 0, 50)
        container.Position = UDim2.new(0.5, -150, 0, yPos)
        container.BackgroundTransparency = 1
        container.Parent = scrollFrame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text .. ": " .. currentVal
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.Font = Enum.Font.Gotham
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container
        
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, -45, 0, 4)
        sliderFrame.Position = UDim2.new(0, 0, 0.5, 10)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        sliderFrame.BorderSizePixel = 0
        sliderFrame.Parent = container
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new((currentVal - minVal) / (maxVal - minVal), 0, 1, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderFrame
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 2)
        fillCorner.Parent = sliderFill
        
        local valueBox = Instance.new("TextBox")
        valueBox.Size = UDim2.new(0, 35, 0, 25)
        valueBox.Position = UDim2.new(1, -35, 0, 10)
        valueBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        valueBox.Text = tostring(math.floor(currentVal))
        valueBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        valueBox.Font = Enum.Font.Gotham
        valueBox.TextSize = 12
        valueBox.Parent = container
        
        local boxCorner = Instance.new("UICorner")
        boxCorner.CornerRadius = UDim.new(0, 4)
        boxCorner.Parent = valueBox
        
        local dragging = false
        local currentValue = currentVal
        
        local function updateValue(input)
            local pos = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
            local newVal = minVal + (maxVal - minVal) * pos
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            valueBox.Text = tostring(math.floor(newVal))
            label.Text = text .. ": " .. math.floor(newVal)
            currentValue = math.floor(newVal)
            return currentValue
        end
        
        sliderFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                updateValue(input)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateValue(input)
            end
        end)
        
        valueBox.FocusLost:Connect(function()
            local val = tonumber(valueBox.Text)
            if val then
                val = math.clamp(val, minVal, maxVal)
                local pos = (val - minVal) / (maxVal - minVal)
                sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                valueBox.Text = tostring(math.floor(val))
                label.Text = text .. ": " .. math.floor(val)
                currentValue = math.floor(val)
            else
                valueBox.Text = tostring(currentValue)
            end
        end)
        
        return {valueBox, label, function() return currentValue end}
    end
    
    -- TELEPORT SECTION (MAIN FEATURE)
    local tpLabel = Instance.new("TextLabel")
    tpLabel.Size = UDim2.new(1, 0, 0, 30)
    tpLabel.Position = UDim2.new(0, 10, 0, yOffset)
    tpLabel.BackgroundTransparency = 1
    tpLabel.Text = "🌐 TELEPORT SYSTEM"
    tpLabel.TextColor3 = Color3.fromRGB(100, 255, 200)
    tpLabel.Font = Enum.Font.GothamBold
    tpLabel.TextSize = 16
    tpLabel.TextXAlignment = Enum.TextXAlignment.Left
    tpLabel.Parent = scrollFrame
    yOffset = yOffset + 35
    
    -- Player List for TP
    local playerList = createPlayerList(scrollFrame, yOffset)
    yOffset = yOffset + 135
    
    -- TP to Safe Zone Button
    local tpSafeBtn = createButton("🏠 TP TO SAFE ZONE", yOffset, Color3.fromRGB(80, 80, 150))
    yOffset = yOffset + 50
    
    -- Auto Teleport Toggle
    local autoTpBtn = createButton("🔴 AUTO TP TO PLAYERS [OFF]", yOffset, Color3.fromRGB(60, 60, 75))
    yOffset = yOffset + 50
    
    -- Teleport Delay Slider
    local tpDelaySlider = createSlider("TP Delay (seconds)", yOffset, 1, 10, config.teleportDelay)
    yOffset = yOffset + 55
    
    -- Combat Section
    local combatLabel = Instance.new("TextLabel")
    combatLabel.Size = UDim2.new(1, 0, 0, 30)
    combatLabel.Position = UDim2.new(0, 10, 0, yOffset)
    combatLabel.BackgroundTransparency = 1
    combatLabel.Text = "⚔️ COMBAT SYSTEM"
    combatLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    combatLabel.Font = Enum.Font.GothamBold
    combatLabel.TextSize = 16
    combatLabel.TextXAlignment = Enum.TextXAlignment.Left
    combatLabel.Parent = scrollFrame
    yOffset = yOffset + 35
    
    local autoPunchBtn = createButton("🔴 AUTO PUNCH [OFF]", yOffset, Color3.fromRGB(60, 60, 75))
    yOffset = yOffset + 45
    
    local autoKillBtn = createButton("🔴 AUTO KILL [OFF]", yOffset, Color3.fromRGB(60, 60, 75))
    yOffset = yOffset + 50
    
    local hitboxSlider = createSlider("Hitbox Size", yOffset, 3, 20, config.hitbox)
    yOffset = yOffset + 55
    
    -- Movement Section
    local moveLabel = Instance.new("TextLabel")
    moveLabel.Size = UDim2.new(1, 0, 0, 30)
    moveLabel.Position = UDim2.new(0, 10, 0, yOffset)
    moveLabel.BackgroundTransparency = 1
    moveLabel.Text = "🏃 MOVEMENT"
    moveLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    moveLabel.Font = Enum.Font.GothamBold
    moveLabel.TextSize = 16
    moveLabel.TextXAlignment = Enum.TextXAlignment.Left
    moveLabel.Parent = scrollFrame
    yOffset = yOffset + 35
    
    local wsSlider = createSlider("Walk Speed", yOffset, 16, 120, config.walkspeed)
    yOffset = yOffset + 55
    
    local jpSlider = createSlider("Jump Power", yOffset, 50, 250, config.jumppower)
    yOffset = yOffset + 55
    
    local gravSlider = createSlider("Gravity", yOffset, 0, 500, config.gravity)
    yOffset = yOffset + 55
    
    local noclipBtn = createButton("❌ NOCLIP [OFF]", yOffset, Color3.fromRGB(60, 60, 75))
    yOffset = yOffset + 50
    
    local ragdollBtn = createButton("🛡️ ANTI-RAGDOLL [ON]", yOffset, Color3.fromRGB(50, 100, 50))
    yOffset = yOffset + 50
    
    -- Flight Section
    local flyLabel = Instance.new("TextLabel")
    flyLabel.Size = UDim2.new(1, 0, 0, 30)
    flyLabel.Position = UDim2.new(0, 10, 0, yOffset)
    flyLabel.BackgroundTransparency = 1
    flyLabel.Text = "✈️ FLIGHT SYSTEM"
    flyLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
    flyLabel.Font = Enum.Font.GothamBold
    flyLabel.TextSize = 16
    flyLabel.TextXAlignment = Enum.TextXAlignment.Left
    flyLabel.Parent = scrollFrame
    yOffset = yOffset + 35
    
    local flyToggleBtn = createButton("❌ FLY MODE [OFF]", yOffset, Color3.fromRGB(60, 60, 75))
    yOffset = yOffset + 50
    
    local flySpeedSlider = createSlider("Flight Speed", yOffset, 30, 300, config.flySpeed)
    yOffset = yOffset + 55
    
    -- Utility Section
    local utilLabel = Instance.new("TextLabel")
    utilLabel.Size = UDim2.new(1, 0, 0, 30)
    utilLabel.Position = UDim2.new(0, 10, 0, yOffset)
    utilLabel.BackgroundTransparency = 1
    utilLabel.Text = "🛠️ UTILITY"
    utilLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
    utilLabel.Font = Enum.Font.GothamBold
    utilLabel.TextSize = 16
    utilLabel.TextXAlignment = Enum.TextXAlignment.Left
    utilLabel.Parent = scrollFrame
    yOffset = yOffset + 35
    
    local rejoinBtn = createButton("🔄 REJOIN GAME", yOffset, Color3.fromRGB(80, 80, 100))
    yOffset = yOffset + 50
    
    local infiniteYieldBtn = createButton("♾️ LOAD INFINITE YIELD", yOffset, Color3.fromRGB(80, 80, 100))
    yOffset = yOffset + 60
    
    -- Update canvas size
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 50)
    
    -- Button states
    local punchState = false
    local killState = false
    local noclipState = false
    local flyState = false
    local ragdollState = true
    local autoTpState = false
    
    -- Button functionality
    tpSafeBtn.MouseButton1Click:Connect(function()
        teleportToSafeZone()
    end)
    
    autoTpBtn.MouseButton1Click:Connect(function()
        autoTpState = not autoTpState
        autoTeleportActive = autoTpState
        config.autoTeleport = autoTpState
        autoTpBtn.Text = (autoTpState and "🟢 AUTO TP TO PLAYERS [ON]" or "🔴 AUTO TP TO PLAYERS [OFF]")
        autoTpBtn.BackgroundColor3 = autoTpState and Color3.fromRGB(50, 130, 50) or Color3.fromRGB(60, 60, 75)
        if autoTpState then startAutoTeleport() end
    end)
    
    autoPunchBtn.MouseButton1Click:Connect(function()
        punchState = not punchState
        autoPunchActive = punchState
        config.autoPunch = punchState
        autoPunchBtn.Text = (punchState and "🟢 AUTO PUNCH [ON]" or "🔴 AUTO PUNCH [OFF]")
        autoPunchBtn.BackgroundColor3 = punchState and Color3.fromRGB(50, 130, 50) or Color3.fromRGB(60, 60, 75)
        if punchState then startAutoPunch() end
    end)
    
    autoKillBtn.MouseButton1Click:Connect(function()
        killState = not killState
        autoKillActive = killState
        config.autoKill = killState
        autoKillBtn.Text = (killState and "🟢 AUTO KILL [ON]" or "🔴 AUTO KILL [OFF]")
        autoKillBtn.BackgroundColor3 = killState and Color3.fromRGB(50, 130, 50) or Color3.fromRGB(60, 60, 75)
        if killState then startAutoKill() end
    end)
    
    noclipBtn.MouseButton1Click:Connect(function()
        noclipState = not noclipState
        config.noclip = noclipState
        noclipBtn.Text = (noclipState and "✅ NOCLIP [ON]" or "❌ NOCLIP [OFF]")
        noclipBtn.BackgroundColor3 = noclipState and Color3.fromRGB(50, 130, 50) or Color3.fromRGB(60, 60, 75)
        if noclipState then startNoclip() elseif noclipConnection then noclipConnection:Disconnect() end
    end)
    
    ragdollBtn.MouseButton1Click:Connect(function()
        ragdollState = not ragdollState
        antiRagdoll.active = ragdollState
        ragdollBtn.Text = (ragdollState and "🛡️ ANTI-RAGDOLL [ON]" or "⚠️ ANTI-RAGDOLL [OFF]")
        ragdollBtn.BackgroundColor3 = ragdollState and Color3.fromRGB(50, 130, 50) or Color3.fromRGB(60, 60, 75)
    end)
    
    flyToggleBtn.MouseButton1Click:Connect(function()
        flyState = not flyState
        config.fly = flyState
        flyToggleBtn.Text = (flyState and "✅ FLY MODE [ON]" or "❌ FLY MODE [OFF]")
        flyToggleBtn.BackgroundColor3 = flyState and Color3.fromRGB(50, 130, 50) or Color3.fromRGB(60, 60, 75)
        if flyState then startFly() else stopFly() end
    end)
    
    rejoinBtn.MouseButton1Click:Connect(function()
        TeleportService:Teleport(game.PlaceId)
    end)
    
    infiniteYieldBtn.MouseButton1Click:Connect(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end)
    
    -- Slider update function
    local function updateSliders()
        if hitboxSlider[3] then config.hitbox = hitboxSlider[3]() end
        if wsSlider[3] then 
            config.walkspeed = wsSlider[3]()
            if humanoid then humanoid.WalkSpeed = config.walkspeed end
        end
        if jpSlider[3] then 
            config.jumppower = jpSlider[3]()
            if humanoid then humanoid.JumpPower = config.jumppower end
        end
        if gravSlider[3] then 
            config.gravity = gravSlider[3]()
            workspace.Gravity = config.gravity
        end
        if flySpeedSlider[3] then config.flySpeed = flySpeedSlider[3]() end
        if tpDelaySlider[3] then config.teleportDelay = tpDelaySlider[3]() end
    end
    
    -- Update sliders periodically
    task.spawn(function()
        while gui.Parent do
            task.wait(0.5)
            pcall(updateSliders)
        end
    end)
    
    -- Rainbow animation
    local hue = 0
    local rainbowConn = RunService.RenderStepped:Connect(function()
        hue = (hue + 0.003) % 1
        border.Color = Color3.fromHSV(hue, 1, 1)
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        rainbowConn:Disconnect()
        if flyConnection then stopFly() end
        if noclipConnection then noclipConnection:Disconnect() end
        gui:Destroy()
    end)
    
    return gui
end

-- CORE FUNCTIONALITY
local function unCollidePlayers()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end

local function startAutoPunch()
    task.spawn(function()
        while autoPunchActive and humanoid and humanoid.Health > 0 do
            local randomDelay = 0.6 + math.random() * 0.6
            task.wait(randomDelay)
            
            local remoteEvent = ReplicatedStorage:FindFirstChild("RemoteEvents")
            if remoteEvent and remoteEvent:FindFirstChild("Weapons") then
                local punchRemote = remoteEvent.Weapons:FindFirstChild("Punch")
                if punchRemote then
                    punchRemote:FireServer()
                end
            end
        end
    end)
end

local function startAutoKill()
    task.spawn(function()
        while autoKillActive and humanoid and humanoid.Health > 0 do
            RunService.Heartbeat:Wait()
            
            for _, target in pairs(Players:GetPlayers()) do
                if target ~= LP and target.Character and not target.Character:FindFirstChildWhichIsA("Forcefield") then
                    local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                    local targetHumanoid = target.Character:FindFirstChildOfClass("Humanoid")
                    
                    if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                        local killStart = tick()
                        while autoKillActive and humanoid and humanoid.Health > 0 and targetHumanoid.Health > 0 and (tick() - killStart) < 4 do
                            RunService.RenderStepped:Wait()
                            
                            if math.random(1, 100) > 90 then
                                unCollidePlayers()
                            end
                            
                            if humanoidRoot and targetRoot then
                                targetRoot.CFrame = humanoidRoot.CFrame * CFrame.new(0, 0, -4.5)
                                targetRoot.Size = Vector3.new(config.hitbox, config.hitbox, config.hitbox)
                                targetRoot.Transparency = 0.6
                            end
                            randomWait(0.01, 0.03)
                        end
                    end
                end
            end
            randomWait(0.3, 0.8)
        end
    end)
end

local function startNoclip()
    if noclipConnection then noclipConnection:Disconnect() end
    
    noclipConnection = RunService.Stepped:Connect(function()
        if character and config.noclip then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function startFly()
    if flyConnection then stopFly() end
    if not (character and humanoid and humanoidRoot) then return end
    
    flying = true
    
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = humanoidRoot
    
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    flyBodyGyro.Parent = humanoidRoot
    
    local function updateMovement()
        if not (flying and humanoidRoot and flyBodyVelocity) then return end
        
        local camCF = currentCamera.CFrame
        local moveVec = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyPressed(Enum.KeyCode.W) then moveVec = moveVec + camCF.LookVector end
        if UserInputService:IsKeyPressed(Enum.KeyCode.S) then moveVec = moveVec - camCF.LookVector end
        if UserInputService:IsKeyPressed(Enum.KeyCode.D) then moveVec = moveVec + camCF.RightVector end
        if UserInputService:IsKeyPressed(Enum.KeyCode.A) then moveVec = moveVec - camCF.RightVector end
        if UserInputService:IsKeyPressed(Enum.KeyCode.Space) then moveVec = moveVec + camCF.UpVector end
        if UserInputService:IsKeyPressed(Enum.KeyCode.LeftControl) then moveVec = moveVec - camCF.UpVector end
        
        if moveVec.Magnitude > 0 then moveVec = moveVec.Unit end
        
        flyBodyVelocity.Velocity = moveVec * config.flySpeed
        flyBodyGyro.CFrame = camCF
    end
    
    flyConnection = RunService.RenderStepped:Connect(updateMovement)
    humanoid.PlatformStand = true
end

local function stopFly()
    flying = false
    
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    if flyBodyVelocity then
        flyBodyVelocity:Destroy()
        flyBodyVelocity = nil
    end
    
    if flyBodyGyro then
        flyBodyGyro:Destroy()
        flyBodyGyro = nil
    end
    
    if humanoid then
        humanoid.PlatformStand = false
    end
end

-- CHARACTER RESPAWN HANDLING
LP.CharacterAdded:Connect(function(newChar)
    randomWait(1, 2)
    character = newChar
    humanoidRoot = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
    
    if humanoid then
        humanoid.WalkSpeed = config.walkspeed
        humanoid.JumpPower = config.jumppower
    end
    
    workspace.Gravity = config.gravity
    
    if autoPunchActive then startAutoPunch() end
    if autoKillActive then startAutoKill() end
    if autoTeleportActive then startAutoTeleport() end
    if config.fly then startFly() end
    if config.noclip then startNoclip() end
end)

-- INITIALIZATION
local function initialize()
    pcall(setupMetatableProtection)
    pcall(cleanEnvironment)
    
    randomWait(1.5, 3)
    
    if humanoid then
        pcall(function()
            humanoid.WalkSpeed = config.walkspeed
            humanoid.JumpPower = config.jumppower
        end)
    end
    
    pcall(function()
        workspace.Gravity = config.gravity
    end)
    
    pcall(createUI)
    
    print("⚡ Nuclearbobo Hub Loaded - Complete Edition ⚡")
    print("✨ Features: TP to Players, TP to Safe Zone, Auto Kill, Anti-Ragdoll ✨")
end

-- START SCRIPT
local success, err = pcall(initialize)
if not success then
    task.wait(5)
    pcall(initialize)
end