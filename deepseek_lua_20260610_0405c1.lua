-- Rayfield UI Library Loader
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Window
local Window = Rayfield:CreateWindow({
    Name = "Vozex Hub 👑 | Blade Ball 🗡",
    LoadingTitle = "Vozex Hub",
    LoadingSubtitle = "Developed by NuclearBobo & Jicky",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "VozexHub",
        FileName = "BladeBall"
    },
    Discord = {
        Enabled = true,
        Invite = "9tbzJhtVZD",
        RememberJoins = true
    },
    KeySystem = false
})

-- Tabs
local CombatTab = Window:CreateTab("Combat", nil)
local MovementTab = Window:CreateTab("Movement", nil)
local VisualsTab = Window:CreateTab("Visuals", nil)
local CreditsTab = Window:CreateTab("Credits", nil)
local ExtraTab = Window:CreateTab("Extra", nil)

-- Variables
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualInput = game:GetService("VirtualInputManager")

-- Aura Variables
getgenv().aura_Enabled = true
getgenv().AutoSpamEnabled = false
getgenv().HitSoundEnabled = true
getgenv().HitEffectEnabled = true

getgenv().Config = {
    AutoParry = true,
    ParryMethod = "Remote", -- Remote or Virtual
    ParryRange = 22,
    ParryDelay = 0.08,
    Prediction = 0.12,
    PingCompensation = true,
    BallSpeedCheck = true,
    
    AutoSpam = false,
    SpamRange = 18,
    SpamDelay = 0.1,
    
    Detection = {
        Singularity = true,
        Infinity = true,
        DeathSlash = true,
        Curse = true
    }
}

-- Movement Variables
getgenv().Movement = {
    WalkSpeed = 36,
    JumpPower = 50,
    InfiniteJump = false,
    AntiRagdoll = true,
    AirControl = 1,
    FlyEnabled = false,
    FlySpeed = 65,
    NoclipEnabled = false
}

-- Visuals Variables
getgenv().Visuals = {
    BallESP = false,
    BallESPColor = Color3.fromRGB(255, 0, 0),
    Tracer = false,
    TracerColor = Color3.fromRGB(0, 255, 0),
    SafeZone = false,
    Fullbright = false,
    FOV = 70,
    HitEffect = true,
    HitSound = true
}

-- Aura Core Variables
local tripleBalls = Workspace:WaitForChild("Balls", 9e9)
local remoteEvent = nil
local totalParries = 0
local lastParryTime = 0
local currentBall = nil
local spamActive = false

-- Find the correct remote
local function findRemote()
    local remotes = {
        ReplicatedStorage:FindFirstChild("Remotes"),
        ReplicatedStorage:FindFirstChild("Network"),
        ReplicatedStorage:FindFirstChild("Game"),
        game:GetService("ReplicatedStorage")
    }
    
    for _, remoteFolder in ipairs(remotes) do
        if remoteFolder then
            for _, child in ipairs(remoteFolder:GetChildren()) do
                if child:IsA("RemoteEvent") and (child.Name:lower():find("parry") or child.Name:lower():find("block") or child.Name:lower():find("defend")) then
                    return child
                end
            end
        end
    end
    
    for _, service in ipairs({game:GetService("AdService"), game:GetService("SocialService")}) do
        local remote = service:FindFirstChildOfClass("RemoteEvent")
        if remote and (#remote.Name > 10 or remote.Name:find("\n")) then
            return remote
        end
    end
    
    local parryButton = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("ParryButtonPress")
    if parryButton then return parryButton end
    
    return nil
end

-- Send parry remotely
local function sendParry()
    if not remoteEvent then
        remoteEvent = findRemote()
    end
    
    if remoteEvent then
        pcall(function()
            remoteEvent:FireServer()
            if remoteEvent.Name == "ParryButtonPress" then
                remoteEvent:FireServer()
            end
        end)
    end
end

-- Virtual key press (more legit)
local function virtualParry()
    pcall(function()
        VirtualInput:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.01)
        VirtualInput:SendKeyEvent(false, Enum.KeyCode.F, false, game)
    end)
end

-- Find the real ball
local function findRealBall()
    local fastestBall = nil
    local highestSpeed = 0
    
    for _, ball in ipairs(tripleBalls:GetChildren()) do
        if ball:IsA("BasePart") and ball:FindFirstChild("Attachment") then
            local speed = ball.AssemblyLinearVelocity.Magnitude
            local isReal = ball:GetAttribute("realBall") or ball:GetAttribute("isReal") or (speed > 30 and speed < 300)
            
            if isReal and speed > highestSpeed then
                highestSpeed = speed
                fastestBall = ball
            end
        end
    end
    
    return fastestBall
end

-- Get closest enemy
local function getClosestEnemy()
    local closest = nil
    local closestDist = math.huge
    
    if Workspace:FindFirstChild("Alive") then
        for _, enemy in ipairs(Workspace.Alive:GetChildren()) do
            if enemy ~= Player.Character and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                local dist = Player:DistanceFromCharacter(enemy.HumanoidRootPart.Position)
                if dist < closestDist then
                    closestDist = dist
                    closest = enemy
                end
            end
        end
    end
    
    return closest, closestDist
end

-- Check if ball is coming towards player
local function isBallComingToPlayer(ball)
    if not ball or not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return false end
    
    local playerPos = Player.Character.HumanoidRootPart.Position
    local ballPos = ball.Position
    local ballVel = ball.AssemblyLinearVelocity
    
    if ballVel.Magnitude < 5 then return false end
    
    local directionToPlayer = (playerPos - ballPos).Unit
    local ballDirection = ballVel.Unit
    
    local dot = directionToPlayer:Dot(ballDirection)
    
    return dot > 0.3
end

-- Calculate time until impact
local function timeToImpact(ball)
    if not ball or not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return math.huge end
    
    local playerPos = Player.Character.HumanoidRootPart.Position
    local ballPos = ball.Position
    local ballVel = ball.AssemblyLinearVelocity
    
    if ballVel.Magnitude < 1 then return math.huge end
    
    local relativePos = playerPos - ballPos
    local distance = relativePos.Magnitude
    
    local ping = 0
    if getgenv().Config.PingCompensation then
        ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
    end
    
    local time = (distance / ballVel.Magnitude) - ping - getgenv().Config.Prediction
    
    return time
end

-- Check if player is targeted
local function isPlayerTargeted()
    if not Player.Character then return false end
    return Player.Character:FindFirstChild("Highlight") ~= nil
end

-- Main parry logic
local function handleParry()
    if not getgenv().Config.AutoParry then return end
    if not getgenv().aura_Enabled then return end
    if not isPlayerTargeted() then return end
    
    local ball = findRealBall()
    if not ball then return end
    
    if getgenv().Config.BallSpeedCheck and ball.AssemblyLinearVelocity.Magnitude < 10 then return end
    
    if not isBallComingToPlayer(ball) then return end
    
    local timeToHit = timeToImpact(ball)
    local distanceToBall = Player:DistanceFromCharacter(ball.Position)
    
    -- Parry when ball is in range and close enough
    if distanceToBall <= getgenv().Config.ParryRange and timeToHit <= 0.25 and timeToHit > 0 and (tick() - lastParryTime) > 0.1 then
        
        lastParryTime = tick()
        
        if getgenv().Config.ParryMethod == "Remote" then
            sendParry()
        else
            virtualParry()
        end
        
        return true
    end
    
    return false
end

-- Auto spam logic
local function handleSpam()
    if not getgenv().AutoSpamEnabled then return end
    if not spamActive then return end
    
    local enemy, dist = getClosestEnemy()
    if enemy and dist <= getgenv().Config.SpamRange then
        if remoteEvent and remoteEvent.Name ~= "ParryButtonPress" then
            pcall(function()
                remoteEvent:FireServer(0.5, CFrame.new(), {[enemy.Name] = enemy.HumanoidRootPart.Position}, {enemy.HumanoidRootPart.Position.X, enemy.HumanoidRootPart.Position.Y}, false)
            end)
        end
    end
end

-- Hit sound
local hitSound = Instance.new("Sound")
hitSound.SoundId = "rbxassetid://9120386436"
hitSound.Volume = 0.5

-- Hit effect
local function createHitEffect(ball)
    if not getgenv().Visuals.HitEffect then return end
    if not ball then return end
    
    local attachment = Instance.new("Attachment")
    attachment.Parent = ball
    
    local particleEmitter = Instance.new("ParticleEmitter")
    particleEmitter.Parent = attachment
    particleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    particleEmitter.Rate = 200
    particleEmitter.Lifetime = NumberRange.new(0.3)
    particleEmitter.SpreadAngle = Vector2.new(360, 360)
    particleEmitter.VelocityInheritance = 0
    particleEmitter.Speed = NumberRange.new(5, 15)
    particleEmitter.Enabled = true
    
    task.wait(0.1)
    particleEmitter.Enabled = false
    task.wait(0.3)
    particleEmitter:Destroy()
    attachment:Destroy()
end

-- Parry success detection
pcall(function()
    local remoteFolder = ReplicatedStorage:FindFirstChild("Remotes")
    if remoteFolder then
        local parrySuccess = remoteFolder:FindFirstChild("ParrySuccess")
        if parrySuccess then
            parrySuccess.OnClientEvent:Connect(function()
                totalParries = totalParries + 1
                
                if getgenv().Visuals.HitSound then
                    hitSound:Play()
                end
                
                local ball = findRealBall()
                if ball then
                    createHitEffect(ball)
                end
            end)
        end
        
        local parrySuccessAll = remoteFolder:FindFirstChild("ParrySuccessAll")
        if parrySuccessAll then
            parrySuccessAll.OnClientEvent:Connect(function()
                totalParries = totalParries + 1
            end)
        end
    end
end)

-- Ball removed cleanup
tripleBalls.ChildRemoved:Connect(function()
    currentBall = nil
end)

-- Auto spam toggle (F key)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        getgenv().AutoSpamEnabled = not getgenv().AutoSpamEnabled
        Rayfield:Notify({
            Title = "Auto Spam",
            Content = getgenv().AutoSpamEnabled and "Enabled ✅" or "Disabled ❌",
            Duration = 2
        })
    end
end)

-- Movement handling
local function updateMovement()
    local char = Player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    humanoid.WalkSpeed = getgenv().Movement.WalkSpeed
    humanoid.JumpPower = getgenv().Movement.JumpPower
    humanoid.AirControl = getgenv().Movement.AirControl
end

-- Infinite jump
local infiniteJumpConnection = nil
local function setupInfiniteJump()
    if infiniteJumpConnection then
        infiniteJumpConnection:Disconnect()
    end
    
    if getgenv().Movement.InfiniteJump then
        infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end

-- Anti ragdoll
local function setupAntiRagdoll()
    local char = Player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
            if humanoid.PlatformStand and getgenv().Movement.AntiRagdoll then
                task.wait(0.05)
                humanoid.PlatformStand = false
            end
        end)
    end
end

-- Fly system
local flying = false
local flyBodyGyro = nil
local flyBodyVelocity = nil

local function toggleFly()
    local char = Player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    flying = not flying
    
    if flying then
        humanoid.PlatformStand = true
        
        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.P = 9e4
        flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBodyGyro.CFrame = rootPart.CFrame
        flyBodyGyro.Parent = rootPart
        
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyBodyVelocity.Parent = rootPart
        
        Rayfield:Notify({
            Title = "Fly",
            Content = "Enabled ✅ Press again to disable",
            Duration = 2
        })
    else
        if flyBodyGyro then flyBodyGyro:Destroy() end
        if flyBodyVelocity then flyBodyVelocity:Destroy() end
        humanoid.PlatformStand = false
        
        Rayfield:Notify({
            Title = "Fly",
            Content = "Disabled ❌",
            Duration = 2
        })
    end
end

-- Fly update loop
local function updateFly()
    if not flying then return end
    
    local char = Player.Character
    if not char then return end
    
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not rootPart or not flyBodyVelocity then return end
    
    local camera = Workspace.CurrentCamera
    local moveDirection = Vector3.new()
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        moveDirection = moveDirection + camera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        moveDirection = moveDirection - camera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        moveDirection = moveDirection - camera.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        moveDirection = moveDirection + camera.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        moveDirection = moveDirection + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        moveDirection = moveDirection - Vector3.new(0, 1, 0)
    end
    
    if moveDirection.Magnitude > 0 then
        flyBodyVelocity.Velocity = moveDirection.Unit * getgenv().Movement.FlySpeed
    else
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
    
    if flyBodyGyro then
        flyBodyGyro.CFrame = camera.CFrame
    end
end

-- Noclip
local noclipConnection = nil
local function setupNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
    end
    
    if getgenv().Movement.NoclipEnabled then
        noclipConnection = RunService.RenderStepped:Connect(function()
            local char = Player.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end

-- Fullbright
local originalLighting = {}
local function setupFullbright()
    local lighting = game:GetService("Lighting")
    
    if getgenv().Visuals.Fullbright then
        originalLighting.Ambient = lighting.Ambient
        originalLighting.Brightness = lighting.Brightness
        originalLighting.GlobalShadows = lighting.GlobalShadows
        originalLighting.ClockTime = lighting.ClockTime
        
        lighting.Ambient = Color3.fromRGB(255, 255, 255)
        lighting.Brightness = 2
        lighting.GlobalShadows = false
        lighting.ClockTime = 12
    else
        lighting.Ambient = originalLighting.Ambient or Color3.fromRGB(0, 0, 0)
        lighting.Brightness = originalLighting.Brightness or 1
        lighting.GlobalShadows = originalLighting.GlobalShadows or true
        lighting.ClockTime = originalLighting.ClockTime or 14
    end
end

-- FOV
local function setupFOV()
    if Workspace.CurrentCamera then
        Workspace.CurrentCamera.FieldOfView = getgenv().Visuals.FOV
    end
end

-- ESP and Tracers
local espObjects = {}

local function setupESP()
    for _, obj in pairs(espObjects) do
        if obj then obj:Destroy() end
    end
    espObjects = {}
    
    if not getgenv().Visuals.BallESP and not getgenv().Visuals.Tracer then return end
    
    local ball = findRealBall()
    if not ball then return end
    
    if getgenv().Visuals.BallESP then
        local highlight = Instance.new("Highlight")
        highlight.Parent = ball
        highlight.FillColor = getgenv().Visuals.BallESPColor
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0.3
        table.insert(espObjects, highlight)
    end
    
    if getgenv().Visuals.Tracer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local tracerLine = Drawing.new("Line")
        tracerLine.Visible = true
        tracerLine.Color = getgenv().Visuals.TracerColor
        tracerLine.Thickness = 2
        tracerLine.Transparency = 0.5
        
        local updateTracer = RunService.RenderStepped:Connect(function()
            if not ball or not Player.Character then
                tracerLine.Visible = false
                return
            end
            
            local ballPos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(ball.Position)
            local playerPos = Workspace.CurrentCamera:WorldToViewportPoint(Player.Character.HumanoidRootPart.Position)
            
            if onScreen then
                tracerLine.Visible = true
                tracerLine.From = Vector2.new(playerPos.X, playerPos.Y)
                tracerLine.To = Vector2.new(ballPos.X, ballPos.Y)
            else
                tracerLine.Visible = false
            end
        end)
        
        table.insert(espObjects, updateTracer)
        table.insert(espObjects, tracerLine)
    end
end

-- Safe zone circle
local function setupSafeZone()
    if not getgenv().Visuals.SafeZone then return end
    
    local ring = Instance.new("Part")
    ring.Name = "SafeZoneRing"
    ring.Shape = Enum.PartType.Cylinder
    ring.Size = Vector3.new(30, 0.2, 30)
    ring.Anchored = true
    ring.CanCollide = false
    ring.Transparency = 0.5
    ring.Color = Color3.fromRGB(0, 255, 255)
    ring.Material = Enum.Material.Neon
    
    local attachment = Instance.new("Attachment")
    attachment.Parent = ring
    
    local ringEffect = Instance.new("RingEffect")
    ringEffect.Parent = attachment
    ringEffect.Radius = 15
    
    local playerPos = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if playerPos then
        ring.Position = playerPos.Position
    end
    
    ring.Parent = Workspace
    table.insert(espObjects, ring)
end

-- Main loops
local function startParryLoop()
    while task.wait(0.05) do
        if getgenv().aura_Enabled then
            handleParry()
        end
    end
end

local function startSpamLoop()
    while task.wait(getgenv().Config.SpamDelay) do
        if getgenv().AutoSpamEnabled and spamActive then
            handleSpam()
        end
    end
end

local function startFlyUpdateLoop()
    while task.wait(0.03) do
        updateFly()
    end
end

-- Start loops
task.spawn(startParryLoop)
task.spawn(startSpamLoop)
task.spawn(startFlyUpdateLoop)

-- Character spawn handling
Player.CharacterAdded:Connect(function(char)
    task.wait(0.3)
    updateMovement()
    setupAntiRagdoll()
    setupNoclip()
    setupFullbright()
    setupFOV()
    
    spamActive = true
    currentBall = nil
end)

Player.CharacterRemoving:Connect(function()
    spamActive = false
    if flyBodyGyro then flyBodyGyro:Destroy() end
    if flyBodyVelocity then flyBodyVelocity:Destroy() end
    flying = false
end)

-- Update loops for visuals
RunService.RenderStepped:Connect(function()
    if Player.Character then
        updateMovement()
        setupFOV()
        
        for _, obj in pairs(espObjects) do
            if obj and obj.Destroy then
                pcall(function() obj:Destroy() end)
            end
        end
        espObjects = {}
        
        setupESP()
        
        if getgenv().Visuals.SafeZone then
            setupSafeZone()
        end
    end
end)

-- Setup infinite jump on change
local function onInfiniteJumpChange()
    setupInfiniteJump()
end

-- Setup noclip on change
local function onNoclipChange()
    setupNoclip()
end

-- Stats watermark
local function updateWatermark()
    while task.wait(5) do
        Rayfield:SetWatermarkVisibility(true)
        Rayfield:SetWatermark("Vozex Hub | Parries: " .. totalParries .. " | Ping: " .. math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) .. "ms")
    end
end
task.spawn(updateWatermark)

-- ============ UI CREATION ============

-- Combat Tab
local ParrySection = CombatTab:CreateSection("⚔️ Auto Parry")

CombatTab:CreateToggle({
    Name = "Enable Auto Parry",
    CurrentValue = getgenv().Config.AutoParry,
    Flag = "AutoParry",
    Callback = function(Value)
        getgenv().Config.AutoParry = Value
        if Value then
            Rayfield:Notify({Title = "Auto Parry", Content = "Enabled ✅", Duration = 1})
        else
            Rayfield:Notify({Title = "Auto Parry", Content = "Disabled ❌", Duration = 1})
        end
    end
})

CombatTab:CreateDropdown({
    Name = "Parry Method",
    Options = {"Remote", "Virtual Key (F)"},
    CurrentOption = "Remote",
    Flag = "ParryMethod",
    Callback = function(Option)
        getgenv().Config.ParryMethod = Option == "Remote" and "Remote" or "Virtual"
    end
})

CombatTab:CreateSlider({
    Name = "Parry Range",
    Range = {10, 35},
    Increment = 0.5,
    Suffix = " studs",
    CurrentValue = getgenv().Config.ParryRange,
    Flag = "ParryRange",
    Callback = function(Value)
        getgenv().Config.ParryRange = Value
    end
})

CombatTab:CreateSlider({
    Name = "Prediction Time",
    Range = {0.05, 0.35},
    Increment = 0.01,
    Suffix = " sec",
    CurrentValue = getgenv().Config.Prediction,
    Flag = "Prediction",
    Callback = function(Value)
        getgenv().Config.Prediction = Value
    end
})

CombatTab:CreateSlider({
    Name = "Parry Delay",
    Range = {0.02, 0.2},
    Increment = 0.01,
    Suffix = " sec",
    CurrentValue = getgenv().Config.ParryDelay,
    Flag = "ParryDelay",
    Callback = function(Value)
        getgenv().Config.ParryDelay = Value
    end
})

CombatTab:CreateToggle({
    Name = "Ping Compensation",
    CurrentValue = getgenv().Config.PingCompensation,
    Flag = "PingCompensation",
    Callback = function(Value)
        getgenv().Config.PingCompensation = Value
    end
})

CombatTab:CreateToggle({
    Name = "Ball Speed Check",
    CurrentValue = getgenv().Config.BallSpeedCheck,
    Flag = "BallSpeedCheck",
    Callback = function(Value)
        getgenv().Config.BallSpeedCheck = Value
    end
})

local SpamSection = CombatTab:CreateSection("🎯 Auto Spam")

CombatTab:CreateToggle({
    Name = "Enable Auto Spam (Hold F)",
    CurrentValue = getgenv().AutoSpamEnabled,
    Flag = "AutoSpam",
    Callback = function(Value)
        getgenv().AutoSpamEnabled = Value
        spamActive = Value
    end
})

CombatTab:CreateSlider({
    Name = "Spam Range",
    Range = {10, 30},
    Increment = 0.5,
    Suffix = " studs",
    CurrentValue = getgenv().Config.SpamRange,
    Flag = "SpamRange",
    Callback = function(Value)
        getgenv().Config.SpamRange = Value
    end
})

CombatTab:CreateSlider({
    Name = "Spam Delay",
    Range = {0.05, 0.3},
    Increment = 0.01,
    Suffix = " sec",
    CurrentValue = getgenv().Config.SpamDelay,
    Flag = "SpamDelay",
    Callback = function(Value)
        getgenv().Config.SpamDelay = Value
    end
})

local DetectionSection = CombatTab:CreateSection("🔍 Detection Systems")

CombatTab:CreateToggle({
    Name = "Singularity Detection",
    CurrentValue = getgenv().Config.Detection.Singularity,
    Flag = "Singularity",
    Callback = function(Value)
        getgenv().Config.Detection.Singularity = Value
    end
})

CombatTab:CreateToggle({
    Name = "Infinity Detection",
    CurrentValue = getgenv().Config.Detection.Infinity,
    Flag = "Infinity",
    Callback = function(Value)
        getgenv().Config.Detection.Infinity = Value
    end
})

CombatTab:CreateToggle({
    Name = "Death Slash Detection",
    CurrentValue = getgenv().Config.Detection.DeathSlash,
    Flag = "DeathSlash",
    Callback = function(Value)
        getgenv().Config.Detection.DeathSlash = Value
    end
})

CombatTab:CreateToggle({
    Name = "Curse Detection",
    CurrentValue = getgenv().Config.Detection.Curse,
    Flag = "Curse",
    Callback = function(Value)
        getgenv().Config.Detection.Curse = Value
    end
})

local EffectsSection = CombatTab:CreateSection("✨ Effects")

CombatTab:CreateToggle({
    Name = "Hit Sound Effect",
    CurrentValue = getgenv().Visuals.HitSound,
    Flag = "HitSound",
    Callback = function(Value)
        getgenv().Visuals.HitSound = Value
    end
})

CombatTab:CreateToggle({
    Name = "Hit Particle Effect",
    CurrentValue = getgenv().Visuals.HitEffect,
    Flag = "HitEffect",
    Callback = function(Value)
        getgenv().Visuals.HitEffect = Value
    end
})

-- Movement Tab
local BasicMovementSection = MovementTab:CreateSection("🏃 Basic Movement")

MovementTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 100},
    Increment = 1,
    Suffix = "",
    CurrentValue = getgenv().Movement.WalkSpeed,
    Flag = "MoveWalkSpeed",
    Callback = function(Value)
        getgenv().Movement.WalkSpeed = Value
        updateMovement()
    end
})

MovementTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 200},
    Increment = 5,
    Suffix = "",
    CurrentValue = getgenv().Movement.JumpPower,
    Flag = "MoveJumpPower",
    Callback = function(Value)
        getgenv().Movement.JumpPower = Value
        updateMovement()
    end
})

MovementTab:CreateSlider({
    Name = "Air Control",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "",
    CurrentValue = getgenv().Movement.AirControl,
    Flag = "AirControl",
    Callback = function(Value)
        getgenv().Movement.AirControl = Value
        updateMovement()
    end
})

MovementTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = getgenv().Movement.InfiniteJump,
    Flag = "InfiniteJump",
    Callback = function(Value)
        getgenv().Movement.InfiniteJump = Value
        onInfiniteJumpChange()
    end
})

MovementTab:CreateToggle({
    Name = "Anti-Ragdoll",
    CurrentValue = getgenv().Movement.AntiRagdoll,
    Flag = "AntiRagdoll",
    Callback = function(Value)
        getgenv().Movement.AntiRagdoll = Value
        setupAntiRagdoll()
    end
})

local AdvancedMovementSection = MovementTab:CreateSection("🚀 Advanced Movement")

MovementTab:CreateButton({
    Name = "Toggle Fly",
    Callback = function()
        toggleFly()
    end
})

MovementTab:CreateSlider({
    Name = "Fly Speed",
    Range = {30, 200},
    Increment = 5,
    Suffix = "",
    CurrentValue = getgenv().Movement.FlySpeed,
    Flag = "FlySpeed",
    Callback = function(Value)
        getgenv().Movement.FlySpeed = Value
    end
})

MovementTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = getgenv().Movement.NoclipEnabled,
    Flag = "Noclip",
    Callback = function(Value)
        getgenv().Movement.NoclipEnabled = Value
        onNoclipChange()
    end
})

-- Visuals Tab
local GameVisualsSection = VisualsTab:CreateSection("👁️ Game Visuals")

VisualsTab:CreateToggle({
    Name = "Ball ESP",
    CurrentValue = getgenv().Visuals.BallESP,
    Flag = "BallESP",
    Callback = function(Value)
        getgenv().Visuals.BallESP = Value
    end
})

VisualsTab:CreateColorPicker({
    Name = "Ball ESP Color",
    Color = getgenv().Visuals.BallESPColor,
    Flag = "BallESPColor",
    Callback = function(Color)
        getgenv().Visuals.BallESPColor = Color
    end
})

VisualsTab:CreateToggle({
    Name = "Target Tracer",
    CurrentValue = getgenv().Visuals.Tracer,
    Flag = "Tracer",
    Callback = function(Value)
        getgenv().Visuals.Tracer = Value
    end
})

VisualsTab:CreateColorPicker({
    Name = "Tracer Color",
    Color = getgenv().Visuals.TracerColor,
    Flag = "TracerColor",
    Callback = function(Color)
        getgenv().Visuals.TracerColor = Color
    end
})

VisualsTab:CreateToggle({
    Name = "Safe Zone Circle",
    CurrentValue = getgenv().Visuals.SafeZone,
    Flag = "SafeZone",
    Callback = function(Value)
        getgenv().Visuals.SafeZone = Value
    end
})

local CameraSection = VisualsTab:CreateSection("📷 Camera & Lighting")

VisualsTab:CreateSlider({
    Name = "Field of View",
    Range = {70, 120},
    Increment = 1,
    Suffix = "",
    CurrentValue = getgenv().Visuals.FOV,
    Flag = "FOV",
    Callback = function(Value)
        getgenv().Visuals.FOV = Value
        setupFOV()
    end
})

VisualsTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = getgenv().Visuals.Fullbright,
    Flag = "Fullbright",
    Callback = function(Value)
        getgenv().Visuals.Fullbright = Value
        setupFullbright()
    end
})

-- Credits Tab
CreditsTab:CreateLabel("━━━━━━━━━━━━━━━━━━━━━━━━")
CreditsTab:CreateLabel("🎮 Vozex Hub | Blade Ball 🗡")
CreditsTab:CreateLabel("━━━━━━━━━━━━━━━━━━━━━━━━")
CreditsTab:CreateLabel("👨‍💻 Development Team")
CreditsTab:CreateLabel("   • NuclearBobo")
CreditsTab:CreateLabel("   • Jicky")
CreditsTab:CreateLabel("")
CreditsTab:CreateLabel("📜 Script: Vozex Hub")
CreditsTab:CreateLabel("🎨 UI Library: Rayfield")
CreditsTab:CreateLabel("━━━━━━━━━━━━━━━━━━━━━━━━")

CreditsTab:CreateButton({
    Name = "Join Discord Server",
    Callback = function()
        setclipboard("https://discord.gg/9tbzJhtVZD")
        Rayfield:Notify({
            Title = "Discord",
            Content = "Link copied to clipboard!",
            Duration = 2
        })
    end
})

-- Extra Tab
ExtraTab:CreateLabel("⭐ Thank you for using Vozex Hub! ⭐")
ExtraTab:CreateLabel("Made with love by NuclearBobo & Jicky")

ExtraTab:CreateButton({
    Name = "Hide/Show UI",
    Callback = function()
        Rayfield:Toggle()
    end
})

ExtraTab:CreateButton({
    Name = "Teleport to Lobby",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end
})

ExtraTab:CreateButton({
    Name = "Rejoin Game",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
    end
})

-- Initialization
local function initialize()
    remoteEvent = findRemote()
    setupInfiniteJump()
    
    Rayfield:Notify({
        Title = "Vozex Hub",
        Content = "Loaded successfully! Press F to toggle Auto Spam",
        Duration = 5
    })
    
    if Player.Character then
        task.wait(0.5)
        updateMovement()
        setupAntiRagdoll()
        setupFullbright()
        setupFOV()
        spamActive = true
    end
end

initialize()