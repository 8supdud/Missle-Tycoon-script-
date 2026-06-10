--[[
    ██╗   ██╗ ██████╗ ███████╗███████╗██╗  ██╗    ██╗  ██╗██╗   ██╗██████╗ 
    ██║   ██║██╔═══██╗╚══███╔╝██╔════╝╚██╗██╔╝    ██║  ██║██║   ██║██╔══██╗
    ██║   ██║██║   ██║  ███╔╝ █████╗   ╚███╔╝     ███████║██║   ██║██████╔╝
    ╚██╗ ██╔╝██║   ██║ ███╔╝  ██╔══╝   ██╔██╗     ██╔══██║██║   ██║██╔══██╗
     ╚████╔╝ ╚██████╔╝███████╗███████╗██╔╝ ██╗    ██║  ██║╚██████╔╝██████╔╝
      ╚═══╝   ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
    
    VOZEX HUB - RIVALS SCRIPT
    Fully Featured | No Crashes | Optimized
    Discord: https://discord.gg/Tttz6mNAet
--]]

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ============================================
-- CONFIGURATION
-- ============================================
local Config = {
    -- Aimbot
    AimbotEnabled = false,
    AimbotPart = "Head",
    AimbotFOV = 150,
    AimbotSmoothing = 0.3,
    AimbotSmoothingEnabled = false,
    PersistentAimbot = false,
    AimPrediction = false,
    TargetBehindWalls = false,
    DrawFOVCircle = true,
    AimbotKeybind = "RightMouseButton",
    
    -- Auto
    AutoShoot = false,
    AutoShootKeybind = "V",
    
    -- ESP
    ESPEnabled = false,
    ESPBoxes = false,
    ESPHealthBar = true,
    ESPShowName = true,
    ESPShowDistance = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
    ESPBlinking = false,
    ESPTransparency = 0.3,
    
    -- Movement
    WalkspeedEnabled = false,
    WalkspeedValue = 25.2,
    JumpPowerEnabled = false,
    JumpPowerValue = 20,
    NoclipEnabled = false,
    NoclipKeybind = "N",
    InfiniteJumpEnabled = false,
    InfiniteJumpKeybind = "X",
    FlyEnabled = false,
    FlyKeybind = "F",
    FlySpeed = 100,
    
    -- Visuals
    SixthSense = false,
    HideSmoke = false,
    HideFlashbang = false,
    NoCrosshair = false,
    ShowFPS = false,
    
    -- Themes
    CurrentTheme = "Cyber Blue",
    
    -- Misc
    TeamCheck = true,
    DebugMode = false,
}

-- ============================================
-- SERVICES
-- ============================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ============================================
-- GLOBAL VARIABLES
-- ============================================
local persistentTarget = nil
local fovCircle = nil
local aimbotActive = false
local flyConn = nil
local noclipConn = nil
local infiniteJumpConn = nil
local smokeCleanupConn = nil
local flashCleanupConn = nil
local fpsLabel = nil
local fpsConn = nil
local sixthSenseConn = nil
local currentWeapon = nil
local espHighlights = {}
local healthLabels = {}
local weaponLabels = {}

-- ============================================
-- THEMES
-- ============================================
local THEMES = {
    ["Vozex Gold"] = {
        accent = Color3.fromRGB(255, 215, 0),
        accentHover = Color3.fromRGB(255, 235, 100),
        bg = Color3.fromRGB(10, 8, 20),
        text = Color3.fromRGB(255, 255, 255),
    },
    ["Cyber Blue"] = {
        accent = Color3.fromRGB(0, 212, 255),
        accentHover = Color3.fromRGB(64, 224, 255),
        bg = Color3.fromRGB(8, 12, 28),
        text = Color3.fromRGB(235, 245, 255),
    },
    ["Neon Pink"] = {
        accent = Color3.fromRGB(255, 50, 150),
        accentHover = Color3.fromRGB(255, 100, 180),
        bg = Color3.fromRGB(20, 8, 20),
        text = Color3.fromRGB(255, 240, 250),
    },
    ["Emerald"] = {
        accent = Color3.fromRGB(80, 220, 120),
        accentHover = Color3.fromRGB(110, 250, 150),
        bg = Color3.fromRGB(12, 22, 16),
        text = Color3.fromRGB(240, 255, 245),
    },
    ["Royal Purple"] = {
        accent = Color3.fromRGB(180, 100, 255),
        accentHover = Color3.fromRGB(200, 130, 255),
        bg = Color3.fromRGB(18, 14, 28),
        text = Color3.fromRGB(250, 240, 255),
    },
}

-- ============================================
-- CREATE MAIN WINDOW
-- ============================================
local Window = Rayfield:CreateWindow({
    Name = "VOZEX HUB | RIVALS",
    LoadingTitle = "Loading Vozex Hub...",
    LoadingSubtitle = "Made with ❤️",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "VozexHubConfig"
    },
})

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================
local function applyTheme(themeName)
    local theme = THEMES[themeName] or THEMES["Cyber Blue"]
    Config.CurrentTheme = themeName
    -- Theme application for Rayfield is limited, but we store it
    Rayfield:Notify({
        Title = "Theme Changed",
        Content = "Applied " .. themeName .. " theme!",
        Duration = 2
    })
end

local function isTeammate(player)
    if not Config.TeamCheck then return false end
    local localTeam = LocalPlayer:GetAttribute("TeamID")
    local playerTeam = player:GetAttribute("TeamID")
    if localTeam and playerTeam then
        return localTeam == playerTeam
    end
    if LocalPlayer.Team and player.Team then
        return LocalPlayer.Team == player.Team
    end
    return false
end

local function isValidTarget(player)
    if not player or player == LocalPlayer then return false end
    if isTeammate(player) then return false end
    if not player.Character then return false end
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    return true
end

local function getTargetPart(character)
    if Config.AimbotPart == "Head" then
        return character:FindFirstChild("Head")
    elseif Config.AimbotPart == "UpperTorso" then
        return character:FindFirstChild("UpperTorso") or character:FindFirstChild("HumanoidRootPart")
    else
        return character:FindFirstChild("HumanoidRootPart")
    end
end

local function isVisible(targetPlayer)
    if Config.TargetBehindWalls then return true end
    local character = targetPlayer.Character
    if not character then return false end
    local targetPart = getTargetPart(character)
    if not targetPart then return false end
    
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local result = workspace:Raycast(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position), rayParams)
    if result and result.Instance then
        if not character:IsAncestorOf(result.Instance) then
            return false
        end
    end
    return true
end

local function getPredictedPosition(targetPart)
    if not Config.AimPrediction or not targetPart.AssemblyLinearVelocity then 
        return targetPart.Position 
    end
    
    local distance = (targetPart.Position - Camera.CFrame.Position).Magnitude
    local bulletSpeed = 900
    local travelTime = distance / bulletSpeed
    
    return targetPart.Position + (targetPart.AssemblyLinearVelocity * travelTime)
end

local function getClosestPlayerInFOV()
    local closest = nil
    local shortestDist = Config.AimbotFOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if isValidTarget(player) and isVisible(player) then
            local targetPart = getTargetPart(player.Character)
            if targetPart then
                local screenPos = Camera:WorldToViewportPoint(targetPart.Position)
                if screenPos.Z > 0 then
                    local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    if distance < shortestDist then
                        shortestDist = distance
                        closest = player
                    end
                end
            end
        end
    end
    return closest
end

-- ============================================
-- AIMBOT SYSTEM
-- ============================================
local function updateAimbot()
    if not Config.AimbotEnabled then 
        aimbotActive = false
        persistentTarget = nil
        return 
    end
    
    local isKeyPressed = false
    if Config.AimbotKeybind == "RightMouseButton" then
        isKeyPressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    elseif Config.AimbotKeybind == "LeftMouseButton" then
        isKeyPressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
    else
        isKeyPressed = UserInputService:IsKeyDown(Enum.KeyCode[Config.AimbotKeybind])
    end
    
    if not isKeyPressed then
        aimbotActive = false
        persistentTarget = nil
        return
    end
    
    aimbotActive = true
    local target = nil
    
    if Config.PersistentAimbot and persistentTarget and isValidTarget(persistentTarget) then
        target = persistentTarget
    else
        target = getClosestPlayerInFOV()
        if Config.PersistentAimbot and target then
            persistentTarget = target
        end
    end
    
    if not target then return end
    
    local targetPart = getTargetPart(target.Character)
    if not targetPart then return end
    
    local targetPos = getPredictedPosition(targetPart)
    local screenPos = Camera:WorldToViewportPoint(targetPos)
    
    if screenPos.Z > 0 then
        local targetVec = Vector2.new(screenPos.X, screenPos.Y)
        local currentVec = Vector2.new(Mouse.X, Mouse.Y)
        local delta = targetVec - currentVec
        
        if delta.Magnitude > Config.AimbotFOV then return end
        
        if Config.AimbotSmoothingEnabled then
            local smoothedDelta = delta * Config.AimbotSmoothing
            mousemoverel(smoothedDelta.X, smoothedDelta.Y)
        else
            mousemoverel(delta.X, delta.Y)
        end
    end
end

-- ============================================
-- AUTO SHOOT SYSTEM
-- ============================================
local autoShootActive = false
local lastAutoShootCheck = 0

local function checkAutoShoot()
    if not Config.AutoShoot then 
        if autoShootActive then
            mouse1release()
            autoShootActive = false
        end
        return 
    end
    
    local now = tick()
    if now - lastAutoShootCheck < 0.05 then return end
    lastAutoShootCheck = now
    
    local target = getClosestPlayerInFOV()
    if target and isVisible(target) then
        if not autoShootActive then
            mouse1press()
            autoShootActive = true
        end
    else
        if autoShootActive then
            mouse1release()
            autoShootActive = false
        end
    end
end

-- ============================================
-- ESP SYSTEM (Using Highlights - No Crashes)
-- ============================================
local function updateESP()
    if not Config.ESPEnabled then
        for _, highlight in pairs(espHighlights) do
            pcall(function() highlight:Destroy() end)
        end
        espHighlights = {}
        return
    end
    
    local blinkState = Config.ESPBlinking and (tick() % 1 < 0.5)
    local espColor = blinkState and Color3.fromRGB(255, 255, 255) or Config.ESPColor
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = espHighlights[player]
            
            if Config.ESPBoxes then
                if not highlight or not highlight.Parent then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "VozexESP"
                    highlight.Parent = player.Character
                    espHighlights[player] = highlight
                end
                highlight.FillColor = espColor
                highlight.FillTransparency = Config.ESPTransparency
                highlight.OutlineTransparency = 1
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Enabled = true
            else
                if highlight then
                    highlight:Destroy()
                    espHighlights[player] = nil
                end
            end
        end
    end
end

-- ============================================
-- HEALTH BARS (Using BillboardGuis)
-- ============================================
local function createHealthBar(player)
    if healthLabels[player] then return end
    
    local character = player.Character
    if not character then return end
    
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "VozexHealthBar"
    billboard.Size = UDim2.new(0, 100, 0, 20)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 0.5
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.Parent = billboard
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(1, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    fill.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.Text = ""
    label.Parent = billboard
    
    healthLabels[player] = {billboard = billboard, fill = fill, label = label}
    
    -- Update health
    task.spawn(function()
        while healthLabels[player] and player and player.Character do
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                local health = humanoid.Health
                local maxHealth = humanoid.MaxHealth
                local percent = math.clamp(health / maxHealth, 0, 1)
                fill.Size = UDim2.new(percent, 0, 1, 0)
                fill.BackgroundColor3 = percent > 0.5 and Color3.fromRGB(0, 255, 0) or 
                                       (percent > 0.25 and Color3.fromRGB(255, 255, 0) or 
                                       Color3.fromRGB(255, 0, 0))
                label.Text = math.floor(health) .. "/" .. math.floor(maxHealth)
            end
            task.wait(0.1)
        end
    end)
end

-- ============================================
-- MOVEMENT SYSTEMS
-- ============================================

-- Walkspeed & Jump Power
LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        if Config.WalkspeedEnabled then
            humanoid.WalkSpeed = Config.WalkspeedValue
        end
        if Config.JumpPowerEnabled then
            humanoid.JumpPower = Config.JumpPowerValue
        end
    end
end)

-- Noclip
local function startNoclip()
    if noclipConn then noclipConn:Disconnect() end
    noclipConn = RunService.Stepped:Connect(function()
        if not Config.NoclipEnabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

-- Infinite Jump
local function startInfiniteJump()
    if infiniteJumpConn then infiniteJumpConn:Disconnect() end
    infiniteJumpConn = UserInputService.JumpRequest:Connect(function()
        if not Config.InfiniteJumpEnabled then return end
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

-- Fly System
local function startFly()
    if flyConn then flyConn:Disconnect() end
    
    flyConn = RunService.RenderStepped:Connect(function()
        if not Config.FlyEnabled then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
        end
        
        local move = Vector3.new(0, 0, 0)
        local speed = Config.FlySpeed
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            move = move + Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            move = move - Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            move = move - Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            move = move + Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            move = move + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            move = move - Vector3.new(0, 1, 0)
        end
        
        if move.Magnitude > 0 then
            hrp.AssemblyLinearVelocity = move.Unit * speed
        else
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
    end)
end

-- ============================================
-- SIXTH SENSE (Katana/Trap Detection)
-- ============================================
local function startSixthSense()
    if sixthSenseConn then sixthSenseConn:Disconnect() end
    
    sixthSenseConn = RunService.Stepped:Connect(function()
        if not Config.SixthSense then return end
        
        local lpPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not lpPos then return end
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                -- Check for katana in hand
                local tool = player.Character:FindFirstChildOfClass("Tool")
                if tool and (tool.Name:lower():find("katana") or tool.Name:lower():find("blade")) then
                    local targetPos = player.Character:FindFirstChild("HumanoidRootPart")
                    if targetPos and (targetPos.Position - lpPos.Position).Magnitude < 150 then
                        -- Visual warning
                        local highlight = player.Character:FindFirstChild("SixthSenseHighlight")
                        if not highlight then
                            highlight = Instance.new("Highlight")
                            highlight.Name = "SixthSenseHighlight"
                            highlight.FillColor = Color3.fromRGB(255, 0, 0)
                            highlight.FillTransparency = 0.5
                            highlight.OutlineTransparency = 1
                            highlight.Parent = player.Character
                            task.delay(0.5, function()
                                if highlight then highlight:Destroy() end
                            end)
                        end
                    end
                end
            end
        end
        
        -- Check for traps
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name:lower():find("tripmine") or obj.Name:lower():find("trap") then
                if obj:IsA("BasePart") and (obj.Position - lpPos.Position).Magnitude < 100 then
                    local highlight = obj:FindFirstChild("TrapHighlight")
                    if not highlight then
                        highlight = Instance.new("SelectionBox")
                        highlight.Name = "TrapHighlight"
                        highlight.Color = Color3.fromRGB(255, 0, 0)
                        highlight.LineThickness = 0.1
                        highlight.Transparency = 0.5
                        highlight.Parent = obj
                        task.delay(1, function()
                            if highlight then highlight:Destroy() end
                        end)
                    end
                end
            end
        end
    end)
end

-- ============================================
-- VISUAL CLEANUP (Smoke/Flashbang)
-- ============================================
local function startSmokeCleanup()
    if smokeCleanupConn then smokeCleanupConn:Disconnect() end
    smokeCleanupConn = RunService.Stepped:Connect(function()
        if not Config.HideSmoke then return end
        if tick() % 3 < 0.1 then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == "Smoke Grenade" or (obj.Name:lower():find("smoke") and obj:IsA("BasePart")) then
                    pcall(function() obj:Destroy() end)
                end
                if obj:IsA("ParticleEmitter") and obj.Name:lower():find("smoke") then
                    pcall(function() obj.Enabled = false end)
                end
            end
        end
    end)
end

local function startFlashCleanup()
    if flashCleanupConn then flashCleanupConn:Disconnect() end
    flashCleanupConn = RunService.Stepped:Connect(function()
        if not Config.HideFlashbang then return end
        if tick() % 2 < 0.1 then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == "FlashbangEffect" or (obj.Name:lower():find("flash") and obj:IsA("BasePart")) then
                    pcall(function() obj:Destroy() end)
                end
            end
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                for _, obj in pairs(playerGui:GetDescendants()) do
                    if obj.Name and obj.Name:lower():find("flash") then
                        pcall(function() obj:Destroy() end)
                    end
                end
            end
        end
    end)
end

-- ============================================
-- FOV CIRCLE
-- ============================================
local function updateFOVCircle()
    if not Config.DrawFOVCircle or not Config.AimbotEnabled then
        if fovCircle then 
            fovCircle.Visible = false 
        end
        return
    end
    
    if not fovCircle then
        local success, result = pcall(function()
            local circle = Drawing.new("Circle")
            circle.Thickness = 1
            circle.Filled = false
            circle.Color = Color3.fromRGB(255, 255, 255)
            circle.Transparency = 0.5
            circle.Visible = true
            return circle
        end)
        if success then
            fovCircle = result
        else
            return
        end
    end
    
    pcall(function()
        local viewport = Camera.ViewportSize
        fovCircle.Position = Vector2.new(viewport.X / 2, viewport.Y / 2)
        fovCircle.Radius = Config.AimbotFOV
        fovCircle.Visible = true
    end)
end

-- ============================================
-- FPS COUNTER
-- ============================================
local function startFPS()
    if fpsConn then fpsConn:Disconnect() end
    if fpsLabel and fpsLabel.Remove then pcall(function() fpsLabel:Remove() end) end
    
    if not Config.ShowFPS then return end
    
    local success, result = pcall(function()
        local text = Drawing.new("Text")
        text.Size = 16
        text.Color = Color3.fromRGB(0, 255, 0)
        text.Center = false
        text.Outline = true
        text.Position = Vector2.new(10, 10)
        text.Font = 2
        return text
    end)
    
    if not success then return end
    
    fpsLabel = result
    local frameCount = 0
    local lastTime = tick()
    
    fpsConn = RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local now = tick()
        if now - lastTime >= 1 then
            local fps = frameCount
            pcall(function()
                fpsLabel.Text = "🔴 FPS: " .. fps
                if fps >= 60 then
                    fpsLabel.Color = Color3.fromRGB(0, 255, 0)
                elseif fps >= 30 then
                    fpsLabel.Color = Color3.fromRGB(255, 255, 0)
                else
                    fpsLabel.Color = Color3.fromRGB(255, 0, 0)
                end
            end)
            frameCount = 0
            lastTime = now
        end
    end)
end

-- ============================================
-- NO CROSSHAIR
-- ============================================
local function updateCrosshair()
    if Config.NoCrosshair then
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            local crosshair = playerGui:FindFirstChild("Crosshair", true)
            if crosshair then
                crosshair.Visible = false
            end
            local aimImage = playerGui:FindFirstChild("AimImage", true)
            if aimImage then
                aimImage.Visible = false
            end
        end
    end
end

-- ============================================
-- TEAM CHECK
-- ============================================
local function updateTeamCheck()
    if Config.TeamCheck then
        -- Clear teammate cache
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local highlight = player.Character and player.Character:FindFirstChild("VozexESP")
                if highlight and isTeammate(player) then
                    highlight.Enabled = false
                elseif highlight then
                    highlight.Enabled = true
                end
            end
        end
    end
end

-- ============================================
-- CREATE UI TABS
-- ============================================

-- █████╗ ██╗███╗   ███╗██████╗  ██████╗ ████████╗
-- ██╔══██╗██║████╗ ████║██╔══██╗██╔═══██╗╚══██╔══╝
-- ███████║██║██╔████╔██║██████╔╝██║   ██║   ██║   
-- ██╔══██║██║██║╚██╔╝██║██╔══██╗██║   ██║   ██║   
-- ██║  ██║██║██║ ╚═╝ ██║██████╔╝╚██████╔╝   ██║   
-- ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝╚═════╝  ╚═════╝    ╚═╝   

local AimbotTab = Window:CreateTab("Aimbot", 4483362458)

local AimbotToggle = AimbotTab:CreateToggle({
    Name = "🔫 Enable Aimbot",
    CurrentValue = false,
    Callback = function(Value)
        Config.AimbotEnabled = Value
    end
})

AimbotTab:CreateDropdown({
    Name = "🎯 Aimbot Part",
    Options = {"Head", "UpperTorso", "HumanoidRootPart"},
    CurrentOption = "Head",
    Callback = function(Option)
        Config.AimbotPart = Option
    end
})

AimbotTab:CreateSlider({
    Name = "📏 Aimbot FOV",
    Range = {50, 500},
    Increment = 5,
    CurrentValue = 150,
    Callback = function(Value)
        Config.AimbotFOV = Value
    end
})

AimbotTab:CreateToggle({
    Name = "✨ Use Smoothing",
    CurrentValue = false,
    Callback = function(Value)
        Config.AimbotSmoothingEnabled = Value
    end
})

AimbotTab:CreateSlider({
    Name = "⚡ Smoothing Amount",
    Range = {0.05, 0.5},
    Increment = 0.01,
    CurrentValue = 0.3,
    Callback = function(Value)
        Config.AimbotSmoothing = Value
    end
})

AimbotTab:CreateToggle({
    Name = "🔒 Persistent Aimbot",
    CurrentValue = false,
    Callback = function(Value)
        Config.PersistentAimbot = Value
    end
})

AimbotTab:CreateToggle({
    Name = "🔮 Aim Prediction",
    CurrentValue = false,
    Callback = function(Value)
        Config.AimPrediction = Value
    end
})

AimbotTab:CreateToggle({
    Name = "🧱 Target Behind Walls",
    CurrentValue = false,
    Callback = function(Value)
        Config.TargetBehindWalls = Value
    end
})

AimbotTab:CreateToggle({
    Name = "🟢 Draw FOV Circle",
    CurrentValue = true,
    Callback = function(Value)
        Config.DrawFOVCircle = Value
    end
})

AimbotTab:CreateKeybind({
    Name = "🎮 Aimbot Keybind",
    CurrentKeybind = "RightMouseButton",
    HoldToInteract = true,
    Callback = function(Keybind)
        Config.AimbotKeybind = Keybind
    end
})

-- █████╗ ██╗   ██╗████████╗ ██████╗ 
-- ██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗
-- ███████║██║   ██║   ██║   ██║   ██║
-- ██╔══██║██║   ██║   ██║   ██║   ██║
-- ██║  ██║╚██████╔╝   ██║   ╚██████╔╝
-- ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ 

local AutoTab = Window:CreateTab("Auto", 4483362458)

AutoTab:CreateToggle({
    Name = "🔫 Auto Shoot",
    CurrentValue = false,
    Callback = function(Value)
        Config.AutoShoot = Value
    end
})

AutoTab:CreateKeybind({
    Name = "⌨️ Auto Shoot Keybind",
    CurrentKeybind = "V",
    Callback = function(Keybind)
        Config.AutoShootKeybind = Keybind
    end
})

-- ███████╗███████╗██████╗ 
-- ██╔════╝██╔════╝██╔══██╗
-- ███████╗█████╗  ██████╔╝
-- ╚════██║██╔══╝  ██╔══██╗
-- ███████║███████╗██║  ██║
-- ╚══════╝╚══════╝╚═╝  ╚═╝

local ESPTab = Window:CreateTab("ESP", 4483362458)

local ESPToggle = ESPTab:CreateToggle({
    Name = "👁️ Enable ESP",
    CurrentValue = false,
    Callback = function(Value)
        Config.ESPEnabled = Value
        updateESP()
    end
})

ESPTab:CreateToggle({
    Name = "📦 ESP Boxes",
    CurrentValue = false,
    Callback = function(Value)
        Config.ESPBoxes = Value
        updateESP()
    end
})

ESPTab:CreateToggle({
    Name = "❤️ Health Bars",
    CurrentValue = true,
    Callback = function(Value)
        Config.ESPHealthBar = Value
        if not Value then
            for _, data in pairs(healthLabels) do
                pcall(function() data.billboard:Destroy() end)
            end
            healthLabels = {}
        end
    end
})

ESPTab:CreateToggle({
    Name = "✨ Blinking ESP",
    CurrentValue = false,
    Callback = function(Value)
        Config.ESPBlinking = Value
    end
})

ESPTab:CreateSlider({
    Name = "🎨 ESP Transparency",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = 0.3,
    Callback = function(Value)
        Config.ESPTransparency = Value
        updateESP()
    end
})

ESPTab:CreateColorPicker({
    Name = "🌈 ESP Color",
    Color = Color3.fromRGB(255, 0, 0),
    Callback = function(Color)
        Config.ESPColor = Color
        updateESP()
    end
})

-- ███╗   ███╗ ██████╗ ██╗   ██╗███████╗███╗   ███╗███████╗███╗   ██╗████████╗
-- ████╗ ████║██╔═══██╗██║   ██║██╔════╝████╗ ████║██╔════╝████╗  ██║╚══██╔══╝
-- ██╔████╔██║██║   ██║██║   ██║█████╗  ██╔████╔██║█████╗  ██╔██╗ ██║   ██║   
-- ██║╚██╔╝██║██║   ██║╚██╗ ██╔╝██╔══╝  ██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║   
-- ██║ ╚═╝ ██║╚██████╔╝ ╚████╔╝ ███████╗██║ ╚═╝ ██║███████╗██║ ╚████║   ██║   
-- ╚═╝     ╚═╝ ╚═════╝   ╚═══╝  ╚══════╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   

local MovementTab = Window:CreateTab("Movement", 4483362458)

MovementTab:CreateToggle({
    Name = "🏃 Walkspeed",
    CurrentValue = false,
    Callback = function(Value)
        Config.WalkspeedEnabled = Value
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = Value and Config.WalkspeedValue or 16
            end
        end
    end
})

MovementTab:CreateSlider({
    Name = "⚡ Walkspeed Value",
    Range = {16, 250},
    Increment = 1,
    CurrentValue = 25.2,
    Callback = function(Value)
        Config.WalkspeedValue = Value
        if Config.WalkspeedEnabled then
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = Value
                end
            end
        end
    end
})

MovementTab:CreateToggle({
    Name = "🦘 Jump Power",
    CurrentValue = false,
    Callback = function(Value)
        Config.JumpPowerEnabled = Value
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = Value and Config.JumpPowerValue or 50
            end
        end
    end
})

MovementTab:CreateSlider({
    Name = "📈 Jump Power Value",
    Range = {50, 300},
    Increment = 5,
    CurrentValue = 20,
    Callback = function(Value)
        Config.JumpPowerValue = Value
        if Config.JumpPowerEnabled then
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.JumpPower = Value
                end
            end
        end
    end
})

MovementTab:CreateToggle({
    Name = "🫥 Noclip",
    CurrentValue = false,
    Callback = function(Value)
        Config.NoclipEnabled = Value
        startNoclip()
    end
})

MovementTab:CreateKeybind({
    Name = "🔑 Noclip Keybind",
    CurrentKeybind = "N",
    Callback = function(Keybind)
        Config.NoclipKeybind = Keybind
    end
})

MovementTab:CreateToggle({
    Name = "♾️ Infinite Jump",
    CurrentValue = false,
    Callback = function(Value)
        Config.InfiniteJumpEnabled = Value
        startInfiniteJump()
    end
})

MovementTab:CreateKeybind({
    Name = "🔑 Infinite Jump Keybind",
    CurrentKeybind = "X",
    Callback = function(Keybind)
        Config.InfiniteJumpKeybind = Keybind
    end
})

MovementTab:CreateToggle({
    Name = "🕊️ Fly",
    CurrentValue = false,
    Callback = function(Value)
        Config.FlyEnabled = Value
        if Value then
            startFly()
        elseif flyConn then
            flyConn:Disconnect()
            flyConn = nil
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                end
            end
        end
    end
})

MovementTab:CreateKeybind({
    Name = "🔑 Fly Keybind",
    CurrentKeybind = "F",
    Callback = function(Keybind)
        Config.FlyKeybind = Keybind
    end
})

MovementTab:CreateSlider({
    Name = "💨 Fly Speed",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = 100,
    Callback = function(Value)
        Config.FlySpeed = Value
    end
})

-- ██╗   ██╗██╗███████╗██╗   ██╗ █████╗ ██╗     ███████╗
-- ██║   ██║██║██╔════╝██║   ██║██╔══██╗██║     ██╔════╝
-- ██║   ██║██║███████╗██║   ██║███████║██║     ███████╗
-- ╚██╗ ██╔╝██║╚════██║██║   ██║██╔══██║██║     ╚════██║
--  ╚████╔╝ ██║███████║╚██████╔╝██║  ██║███████╗███████║
--   ╚═══╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝

local VisualsTab = Window:CreateTab("Visuals", 4483362458)

VisualsTab:CreateToggle({
    Name = "🔮 Sixth Sense",
    CurrentValue = false,
    Callback = function(Value)
        Config.SixthSense = Value
        if Value then
            startSixthSense()
        elseif sixthSenseConn then
            sixthSenseConn:Disconnect()
            sixthSenseConn = nil
        end
    end
})

VisualsTab:CreateToggle({
    Name = "💨 Hide Smoke",
    CurrentValue = false,
    Callback = function(Value)
        Config.HideSmoke = Value
        startSmokeCleanup()
    end
})

VisualsTab:CreateToggle({
    Name = "💥 Hide Flashbang",
    CurrentValue = false,
    Callback = function(Value)
        Config.HideFlashbang = Value
        startFlashCleanup()
    end
})

VisualsTab:CreateToggle({
    Name = "🎯 No Crosshair",
    CurrentValue = false,
    Callback = function(Value)
        Config.NoCrosshair = Value
        updateCrosshair()
    end
})

VisualsTab:CreateToggle({
    Name = "📊 Show FPS Counter",
    CurrentValue = false,
    Callback = function(Value)
        Config.ShowFPS = Value
        startFPS()
    end
})

-- ████████╗██╗  ██╗███████╗███╗   ███╗███████╗███████╗
-- ╚══██╔══╝██║  ██║██╔════╝████╗ ████║██╔════╝██╔════╝
--    ██║   ███████║█████╗  ██╔████╔██║█████╗  ███████╗
--    ██║   ██╔══██║██╔══╝  ██║╚██╔╝██║██╔══╝  ╚════██║
--    ██║   ██║  ██║███████╗██║ ╚═╝ ██║███████╗███████║
--    ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝╚══════╝

local ThemesTab = Window:CreateTab("Themes", 4483362458)

ThemesTab:CreateDropdown({
    Name = "🎨 Select Theme",
    Options = {"Vozex Gold", "Cyber Blue", "Neon Pink", "Emerald", "Royal Purple"},
    CurrentOption = "Cyber Blue",
    Callback = function(Option)
        applyTheme(Option)
    end
})

-- ███████╗███████╗████████╗████████╗██╗███╗   ██╗ ██████╗ ███████╗
-- ██╔════╝██╔════╝╚══██╔══╝╚══██╔══╝██║████╗  ██║██╔════╝ ██╔════╝
-- ███████╗█████╗     ██║      ██║   ██║██╔██╗ ██║██║  ███╗███████╗
-- ╚════██║██╔══╝     ██║      ██║   ██║██║╚██╗██║██║   ██║╚════██║
-- ███████║███████╗   ██║      ██║   ██║██║ ╚████║╚██████╔╝███████║
-- ╚══════╝╚══════╝   ╚═╝      ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝

local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateToggle({
    Name = "👥 Team Check",
    CurrentValue = true,
    Callback = function(Value)
        Config.TeamCheck = Value
        updateTeamCheck()
    end
})

SettingsTab:CreateToggle({
    Name = "🐛 Debug Mode",
    CurrentValue = false,
    Callback = function(Value)
        Config.DebugMode = Value
        if Value then
            print("[VOZEX] Debug mode enabled")
        end
    end
})

SettingsTab:CreateButton({
    Name = "❌ Close Vozex Hub",
    Callback = function()
        -- Cleanup all connections
        if fovCircle then pcall(function() fovCircle:Remove() end) end
        if fpsLabel then pcall(function() fpsLabel:Remove() end) end
        if flyConn then flyConn:Disconnect() end
        if noclipConn then noclipConn:Disconnect() end
        if infiniteJumpConn then infiniteJumpConn:Disconnect() end
        if fpsConn then fpsConn:Disconnect() end
        if smokeCleanupConn then smokeCleanupConn:Disconnect() end
        if flashCleanupConn then flashCleanupConn:Disconnect() end
        if sixthSenseConn then sixthSenseConn:Disconnect() end
        
        -- Clean up ESP
        for _, highlight in pairs(espHighlights) do
            pcall(function() highlight:Destroy() end)
        end
        
        -- Clean up health bars
        for _, data in pairs(healthLabels) do
            pcall(function() data.billboard:Destroy() end)
        end
        
        -- Reset character
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
                humanoid.PlatformStand = false
            end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        
        Rayfield:Destroy()
    end
})

SettingsTab:CreateButton({
    Name = "💬 Join Discord",
    Callback = function()
        setclipboard("https://discord.gg/Tttz6mNAet")
        Rayfield:Notify({
            Title = "Discord Copied!",
            Content = "Discord invite copied to clipboard!",
            Duration = 3
        })
    end
})

-- ============================================
-- HEALTH BARS UPDATE LOOP
-- ============================================
task.spawn(function()
    while true do
        if Config.ESPEnabled and Config.ESPHealthBar then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and isValidTarget(player) then
                    if not healthLabels[player] then
                        createHealthBar(player)
                    end
                end
            end
        end
        task.wait(1)
    end
end)

-- ============================================
-- CHARACTER ADDED HANDLER
-- ============================================
LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    
    -- Re-apply movement settings
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        if Config.WalkspeedEnabled then
            humanoid.WalkSpeed = Config.WalkspeedValue
        end
        if Config.JumpPowerEnabled then
            humanoid.JumpPower = Config.JumpPowerValue
        end
    end
    
    -- Clean up old health bars for this player
    for player, data in pairs(healthLabels) do
        if player == LocalPlayer then
            pcall(function() data.billboard:Destroy() end)
            healthLabels[player] = nil
        end
    end
end)

-- ============================================
-- PLAYER REMOVING HANDLER
-- ============================================
Players.PlayerRemoving:Connect(function(player)
    -- Clean up ESP
    if espHighlights[player] then
        pcall(function() espHighlights[player]:Destroy() end)
        espHighlights[player] = nil
    end
    
    -- Clean up health bars
    if healthLabels[player] then
        pcall(function() healthLabels[player].billboard:Destroy() end)
        healthLabels[player] = nil
    end
end)

-- ============================================
-- MAIN RENDER LOOP
-- ============================================
RunService.RenderStepped:Connect(function()
    -- Aimbot
    updateAimbot()
    
    -- Auto Shoot
    checkAutoShoot()
    
    -- FOV Circle
    updateFOVCircle()
    
    -- Crosshair
    updateCrosshair()
end)

-- Start all systems
startNoclip()
startInfiniteJump()
startSmokeCleanup()
startFlashCleanup()
startSixthSense()
startFPS()

-- Load configuration
Rayfield:LoadConfiguration()

-- Welcome notification
Rayfield:Notify({
    Title = "✨ Vozex Hub Loaded!",
    Content = "All features are ready to use. Enjoy!",
    Duration = 4
})

print([[
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   ██╗   ██╗ ██████╗ ███████╗███████╗██╗  ██╗    ██╗  ██╗   ║
║   ██║   ██║██╔═══██╗╚══███╔╝██╔════╝╚██╗██╔╝    ██║  ██║   ║
║   ██║   ██║██║   ██║  ███╔╝ █████╗   ╚███╔╝     ███████║   ║
║   ╚██╗ ██╔╝██║   ██║ ███╔╝  ██╔══╝   ██╔██╗     ██╔══██║   ║
║    ╚████╔╝ ╚██████╔╝███████╗███████╗██╔╝ ██╗    ██║  ██║   ║
║     ╚═══╝   ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝    ╚═╝  ╚═╝   ║
║                                                              ║
║              VOZEX HUB - RIVALS EDITION                      ║
║                     FULLY LOADED!                            ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
]])