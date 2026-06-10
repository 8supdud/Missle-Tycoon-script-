--[[
    ██╗   ██╗ ██████╗ ███████╗███████╗██╗  ██╗    ██╗  ██╗██╗   ██╗██████╗ 
    ██║   ██║██╔═══██╗╚══███╔╝██╔════╝╚██╗██╔╝    ██║  ██║██║   ██║██╔══██╗
    ██║   ██║██║   ██║  ███╔╝ █████╗   ╚███╔╝     ███████║██║   ██║██████╔╝
    ╚██╗ ██╔╝██║   ██║ ███╔╝  ██╔══╝   ██╔██╗     ██╔══██║██║   ██║██╔══██╗
     ╚████╔╝ ╚██████╔╝███████╗███████╗██╔╝ ██╗    ██║  ██║╚██████╔╝██████╔╝
      ╚═══╝   ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
    
    VOZEX HUB - RIVALS SCRIPT
    STABLE | NO CRASHES | FULLY FEATURED
--]]

-- ============================================
-- SERVICES
-- ============================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- ============================================
-- VOZEX NATIVE UI
-- ============================================
local VozexUI = {}
VozexUI.Colors = {
    Bg = Color3.fromRGB(15, 15, 15),
    Panel = Color3.fromRGB(22, 22, 22),
    PanelLight = Color3.fromRGB(30, 30, 30),
    Accent = Color3.fromRGB(255, 215, 0),
    Text = Color3.fromRGB(240, 240, 240),
    TextDim = Color3.fromRGB(150, 150, 150),
    Warning = Color3.fromRGB(255, 100, 100)
}

-- Warning message for risky features
local function showBanWarning(featureName)
    local warnFrame = Instance.new("Frame")
    warnFrame.Size = UDim2.new(0, 350, 0, 80)
    warnFrame.Position = UDim2.new(0.5, -175, 0.5, -40)
    warnFrame.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
    warnFrame.BackgroundTransparency = 0.95
    warnFrame.ZIndex = 1000
    warnFrame.Parent = CoreGui
    Instance.new("UICorner", warnFrame).CornerRadius = UDim.new(0, 8)
    
    local warnLabel = Instance.new("TextLabel", warnFrame)
    warnLabel.Size = UDim2.new(1, -20, 1, -10)
    warnLabel.Position = UDim2.new(0, 10, 0, 5)
    warnLabel.BackgroundTransparency = 1
    warnLabel.Text = "⚠️ WARNING ⚠️\n" .. featureName .. " can get you BANNED!\nUse at your own risk. Vozex Hub is not responsible."
    warnLabel.TextColor3 = VozexUI.Colors.Warning
    warnLabel.Font = Enum.Font.GothamBold
    warnLabel.TextSize = 13
    warnLabel.TextWrapped = true
    warnLabel.TextYAlignment = Enum.TextYAlignment.Center
    warnLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    TweenService:Create(warnFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.3}):Play()
    task.delay(3, function()
        TweenService:Create(warnFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        task.wait(0.3)
        warnFrame:Destroy()
    end)
end

function VozexUI:MakeDraggable(gui, handle)
    handle = handle or gui
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function VozexUI:CreateWindow(opts)
    local title = type(opts) == "table" and opts.Name or opts
    local sg = Instance.new("ScreenGui")
    sg.Name = "VozexNativeUI"
    sg.ResetOnSpawn = false
    
    local success, err = pcall(function()
        sg.Parent = CoreGui
    end)
    if not success then
        sg.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    local floatBtn = Instance.new("TextButton")
    floatBtn.Size = UDim2.new(0, 50, 0, 50)
    floatBtn.Position = UDim2.new(0.5, -25, 0, 20)
    floatBtn.BackgroundColor3 = self.Colors.Panel
    floatBtn.Text = "👑"
    floatBtn.TextSize = 24
    floatBtn.Visible = false
    floatBtn.Parent = sg
    Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(1, 0)
    self:MakeDraggable(floatBtn, floatBtn)

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 580, 0, 480)
    main.Position = UDim2.new(0.5, -290, 0.5, -240)
    main.BackgroundColor3 = self.Colors.Bg
    main.Active = true
    main.Parent = sg
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 45)
    topBar.BackgroundColor3 = self.Colors.Panel
    topBar.Parent = main
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 10)
    self:MakeDraggable(main, topBar)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -80, 1, 0)
    titleLbl.Position = UDim2.new(0, 15, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = self.Colors.Accent
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 18
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = topBar

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 28, 0, 28)
    minBtn.Position = UDim2.new(1, -80, 0.5, -14)
    minBtn.BackgroundColor3 = self.Colors.PanelLight
    minBtn.Text = "➖"
    minBtn.TextColor3 = self.Colors.Text
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 14
    minBtn.Parent = topBar
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -42, 0.5, -14)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    closeBtn.Text = "x"  -- normal x, not X
    closeBtn.TextColor3 = self.Colors.Text
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.Parent = topBar
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

    minBtn.MouseButton1Click:Connect(function()
        main.Visible = false
        floatBtn.Visible = true
    end)
    floatBtn.MouseButton1Click:Connect(function()
        floatBtn.Visible = false
        main.Visible = true
    end)
    closeBtn.MouseButton1Click:Connect(function()
        sg:Destroy()
        -- Cleanup
        if flyConn then pcall(function() flyConn:Disconnect() end) end
        if noclipConn then pcall(function() noclipConn:Disconnect() end) end
        if infiniteJumpConn then pcall(function() infiniteJumpConn:Disconnect() end) end
    end)

    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Size = UDim2.new(0, 150, 1, -45)
    tabContainer.Position = UDim2.new(0, 0, 0, 45)
    tabContainer.BackgroundColor3 = self.Colors.Panel
    tabContainer.BorderSizePixel = 0
    tabContainer.ScrollBarThickness = 0
    tabContainer.Parent = main
    local tLayout = Instance.new("UIListLayout", tabContainer)
    tLayout.Padding = UDim.new(0, 6)
    tLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Instance.new("UIPadding", tabContainer).PaddingTop = UDim.new(0, 12)
    tLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContainer.CanvasSize = UDim2.new(0, 0, 0, tLayout.AbsoluteContentSize.Y + 20)
    end)

    local pageContainer = Instance.new("Frame")
    pageContainer.Size = UDim2.new(1, -150, 1, -45)
    pageContainer.Position = UDim2.new(0, 150, 0, 45)
    pageContainer.BackgroundTransparency = 1
    pageContainer.Parent = main

    local WindowObj = {}

    function WindowObj:CreateTab(name, icon)
        local tBtn = Instance.new("TextButton")
        tBtn.Size = UDim2.new(1, -16, 0, 38)
        tBtn.BackgroundColor3 = VozexUI.Colors.PanelLight
        tBtn.BackgroundTransparency = 1
        tBtn.Text = "  " .. (icon or "•") .. "  " .. name
        tBtn.TextColor3 = VozexUI.Colors.TextDim
        tBtn.Font = Enum.Font.GothamSemibold
        tBtn.TextSize = 13
        tBtn.TextXAlignment = Enum.TextXAlignment.Left
        tBtn.Parent = tabContainer
        Instance.new("UICorner", tBtn).CornerRadius = UDim.new(0, 8)

        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 4, 0.7, 0)
        indicator.Position = UDim2.new(0, 0, 0.15, 0)
        indicator.BackgroundColor3 = VozexUI.Colors.Accent
        indicator.BackgroundTransparency = 1
        indicator.Parent = tBtn
        Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, -10, 1, -10)
        page.Position = UDim2.new(0, 5, 0, 5)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 4
        page.ScrollBarImageColor3 = VozexUI.Colors.Accent
        page.Visible = false
        page.Parent = pageContainer
        
        local pLayout = Instance.new("UIListLayout", page)
        pLayout.Padding = UDim.new(0, 8)
        pLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        Instance.new("UIPadding", page).PaddingTop = UDim.new(0, 8)

        pLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() 
            page.CanvasSize = UDim2.new(0, 0, 0, pLayout.AbsoluteContentSize.Y + 20)
        end)

        local TabObj = {}
        
        function TabObj:CreateSection(text)
            local sLbl = Instance.new("TextLabel")
            sLbl.Size = UDim2.new(1, -20, 0, 28)
            sLbl.BackgroundTransparency = 1
            sLbl.Text = text
            sLbl.TextColor3 = VozexUI.Colors.Accent
            sLbl.Font = Enum.Font.GothamBold
            sLbl.TextSize = 15
            sLbl.TextXAlignment = Enum.TextXAlignment.Left
            sLbl.Parent = page
        end

        function TabObj:CreateButton(opts)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -20, 0, 40)
            btn.BackgroundColor3 = VozexUI.Colors.Panel
            btn.Text = opts.Name
            btn.TextColor3 = VozexUI.Colors.Text
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 14
            btn.Parent = page
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
            
            btn.MouseButton1Click:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = VozexUI.Colors.PanelLight}):Play()
                opts.Callback()
                task.wait(0.1)
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = VozexUI.Colors.Panel}):Play()
            end)
        end

        function TabObj:CreateToggle(opts)
            local state = opts.CurrentValue or false
            local tgl = Instance.new("TextButton")
            tgl.Size = UDim2.new(1, -20, 0, 40)
            tgl.BackgroundColor3 = VozexUI.Colors.Panel
            tgl.Text = "   " .. opts.Name
            tgl.TextColor3 = VozexUI.Colors.Text
            tgl.Font = Enum.Font.GothamSemibold
            tgl.TextSize = 14
            tgl.TextXAlignment = Enum.TextXAlignment.Left
            tgl.Parent = page
            Instance.new("UICorner", tgl).CornerRadius = UDim.new(0, 8)

            local bg = Instance.new("Frame")
            bg.Size = UDim2.new(0, 40, 0, 22)
            bg.Position = UDim2.new(1, -52, 0.5, -11)
            bg.BackgroundColor3 = state and VozexUI.Colors.Accent or VozexUI.Colors.Bg
            bg.Parent = tgl
            Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 18, 0, 18)
            knob.Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            knob.BackgroundColor3 = VozexUI.Colors.Text
            knob.Parent = bg
            Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

            tgl.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = state and VozexUI.Colors.Accent or VozexUI.Colors.Bg}):Play()
                TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play()
                opts.Callback(state)
            end)
        end

        function TabObj:CreateSlider(opts)
            local val = opts.CurrentValue or opts.Range[1]
            local frm = Instance.new("Frame")
            frm.Size = UDim2.new(1, -20, 0, 65)
            frm.BackgroundColor3 = VozexUI.Colors.Panel
            frm.Parent = page
            Instance.new("UICorner", frm).CornerRadius = UDim.new(0, 8)

            local lbl = Instance.new("TextLabel", frm)
            lbl.Size = UDim2.new(1, -20, 0, 25)
            lbl.Position = UDim2.new(0, 10, 0, 5)
            lbl.BackgroundTransparency = 1
            lbl.Text = opts.Name .. ": " .. val
            lbl.TextColor3 = VozexUI.Colors.Text
            lbl.Font = Enum.Font.GothamSemibold
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left

            local bgBar = Instance.new("TextButton", frm)
            bgBar.Size = UDim2.new(1, -20, 0, 8)
            bgBar.Position = UDim2.new(0, 10, 0, 45)
            bgBar.BackgroundColor3 = VozexUI.Colors.Bg
            bgBar.Text = ""
            bgBar.AutoButtonColor = false
            Instance.new("UICorner", bgBar).CornerRadius = UDim.new(1, 0)
            
            local fill = Instance.new("Frame", bgBar)
            fill.BackgroundColor3 = VozexUI.Colors.Accent
            fill.Size = UDim2.new((val - opts.Range[1])/(opts.Range[2] - opts.Range[1]), 0, 1, 0)
            Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

            local dragging = false
            local function update(input)
                local pct = math.clamp((input.Position.X - bgBar.AbsolutePosition.X) / bgBar.AbsoluteSize.X, 0, 1)
                local rawVal = opts.Range[1] + pct * (opts.Range[2] - opts.Range[1])
                local inc = opts.Increment or 1
                val = math.floor(rawVal / inc + 0.5) * inc
                TweenService:Create(fill, TweenInfo.new(0.1), {Size = UDim2.new((val - opts.Range[1])/(opts.Range[2] - opts.Range[1]), 0, 1, 0)}):Play()
                lbl.Text = opts.Name .. ": " .. val
                opts.Callback(val)
            end
            bgBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    update(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    update(input)
                end
            end)
        end

        function TabObj:CreateDropdown(opts)
            local dropBtn = Instance.new("TextButton")
            dropBtn.Size = UDim2.new(1, -20, 0, 40)
            dropBtn.BackgroundColor3 = VozexUI.Colors.Panel
            dropBtn.Text = "   " .. opts.Name .. ": " .. (opts.CurrentOption or opts.Options[1] or "")
            dropBtn.TextColor3 = VozexUI.Colors.Text
            dropBtn.Font = Enum.Font.GothamSemibold
            dropBtn.TextSize = 13
            dropBtn.TextXAlignment = Enum.TextXAlignment.Left
            dropBtn.Parent = page
            Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 8)

            local listFrame = Instance.new("Frame")
            listFrame.Size = UDim2.new(1, -20, 0, 0)
            listFrame.BackgroundColor3 = VozexUI.Colors.Bg
            listFrame.ClipsDescendants = true
            listFrame.Visible = false
            listFrame.Parent = page
            Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 8)
            local lLayout = Instance.new("UIListLayout", listFrame)
            lLayout.Padding = UDim.new(0, 2)

            local open = false
            local function populate(options)
                for _, c in ipairs(listFrame:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                local h = 0
                for _, opt in ipairs(options) do
                    local b = Instance.new("TextButton")
                    b.Size = UDim2.new(1, 0, 0, 32)
                    b.BackgroundColor3 = VozexUI.Colors.Bg
                    b.Text = "   " .. opt
                    b.TextColor3 = VozexUI.Colors.TextDim
                    b.Font = Enum.Font.Gotham
                    b.TextSize = 13
                    b.TextXAlignment = Enum.TextXAlignment.Left
                    b.Parent = listFrame
                    b.MouseButton1Click:Connect(function()
                        dropBtn.Text = "   " .. opts.Name .. ": " .. opt
                        TweenService:Create(listFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -20, 0, 0)}):Play()
                        task.wait(0.2)
                        listFrame.Visible = false
                        open = false
                        opts.Callback({opt})
                    end)
                    h = h + 32
                end
                if open then
                    listFrame.Size = UDim2.new(1, -20, 0, math.min(h, 160))
                end
            end
            populate(opts.Options)

            dropBtn.MouseButton1Click:Connect(function()
                open = not open
                if open then 
                    listFrame.Visible = true 
                    local totalH = #listFrame:GetChildren() * 32
                    TweenService:Create(listFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -20, 0, math.min(totalH, 160))}):Play()
                else 
                    TweenService:Create(listFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -20, 0, 0)}):Play()
                    task.wait(0.2)
                    listFrame.Visible = false 
                end
            end)
        end

        function TabObj:CreateColorPicker(opts)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -20, 0, 40)
            btn.BackgroundColor3 = VozexUI.Colors.Panel
            btn.Text = "   " .. opts.Name
            btn.TextColor3 = VozexUI.Colors.Text
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 13
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Parent = page
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

            local colorPreview = Instance.new("Frame")
            colorPreview.Size = UDim2.new(0, 30, 0, 22)
            colorPreview.Position = UDim2.new(1, -42, 0.5, -11)
            colorPreview.BackgroundColor3 = opts.Color or VozexUI.Colors.Accent
            colorPreview.Parent = btn
            Instance.new("UICorner", colorPreview).CornerRadius = UDim.new(0, 6)

            btn.MouseButton1Click:Connect(function()
                local colors = {
                    Color3.fromRGB(255, 0, 0),
                    Color3.fromRGB(0, 255, 0),
                    Color3.fromRGB(0, 0, 255),
                    Color3.fromRGB(255, 255, 0),
                    Color3.fromRGB(255, 215, 0),
                    Color3.fromRGB(255, 255, 255),
                }
                local newColor = colors[math.random(1, #colors)]
                colorPreview.BackgroundColor3 = newColor
                opts.Callback(newColor)
            end)
        end

        function TabObj:CreateLabel(text)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -20, 0, 35)
            lbl.BackgroundColor3 = VozexUI.Colors.Panel
            lbl.Text = "   " .. text
            lbl.TextColor3 = VozexUI.Colors.TextDim
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = page
            Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 8)
        end

        return TabObj
    end

    function WindowObj:Notify(opts)
        local notif = Instance.new("Frame")
        notif.Size = UDim2.new(0, 300, 0, 50)
        notif.Position = UDim2.new(1, -320, 0, 60)
        notif.BackgroundColor3 = self.Colors.Panel
        notif.Parent = sg
        Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)
        
        local title = Instance.new("TextLabel", notif)
        title.Size = UDim2.new(1, -20, 0, 20)
        title.Position = UDim2.new(0, 10, 0, 5)
        title.BackgroundTransparency = 1
        title.Text = opts.Title or "Notification"
        title.TextColor3 = self.Colors.Accent
        title.Font = Enum.Font.GothamBold
        title.TextSize = 13
        title.TextXAlignment = Enum.TextXAlignment.Left
        
        local content = Instance.new("TextLabel", notif)
        content.Size = UDim2.new(1, -20, 0, 20)
        content.Position = UDim2.new(0, 10, 0, 25)
        content.BackgroundTransparency = 1
        content.Text = opts.Content or ""
        content.TextColor3 = self.Colors.TextDim
        content.Font = Enum.Font.Gotham
        content.TextSize = 12
        content.TextXAlignment = Enum.TextXAlignment.Left
        
        task.delay(opts.Duration or 3, function()
            TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(1, -320, 0, -100)}):Play()
            task.wait(0.3)
            notif:Destroy()
        end)
        
        TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = UDim2.new(1, -320, 0, 60)}):Play()
    end

    return WindowObj
end

-- ============================================
-- CONFIGURATION
-- ============================================
local Config = {
    AimbotEnabled = false,
    AimbotFOV = 150,
    AimbotSmoothing = 0.3,
    AimbotSmoothingEnabled = false,
    AutoShoot = false,
    ESPEnabled = false,
    ESPBoxes = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
    WalkspeedEnabled = false,
    WalkspeedValue = 25.2,
    JumpPowerEnabled = false,
    JumpPowerValue = 20,
    NoclipEnabled = false,
    InfiniteJumpEnabled = false,
    FlyEnabled = false,
    FlySpeed = 100,
    NoCrosshair = false,
}

-- ============================================
-- GLOBAL VARIABLES
-- ============================================
local flyConn = nil
local noclipConn = nil
local infiniteJumpConn = nil
local espHighlights = {}

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================
local function isValidTarget(player)
    if not player or player == LocalPlayer then return false end
    if not player.Character then return false end
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    return true
end

local function getClosestPlayer()
    local closest = nil
    local shortestDist = Config.AimbotFOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if isValidTarget(player) then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local screenPos = Camera:WorldToViewportPoint(head.Position)
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
-- AIMBOT
-- ============================================
local function updateAimbot()
    if not Config.AimbotEnabled then return end
    if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
    
    local target = getClosestPlayer()
    if not target then return end
    
    local head = target.Character:FindFirstChild("Head")
    if not head then return end
    
    local screenPos = Camera:WorldToViewportPoint(head.Position)
    if screenPos.Z > 0 then
        local delta = Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)
        if Config.AimbotSmoothingEnabled then
            mousemoverel(delta.X * Config.AimbotSmoothing, delta.Y * Config.AimbotSmoothing)
        else
            mousemoverel(delta.X, delta.Y)
        end
    end
end

-- ============================================
-- AUTO SHOOT
-- ============================================
local autoShootActive = false

local function checkAutoShoot()
    if not Config.AutoShoot then
        if autoShootActive then
            mouse1release()
            autoShootActive = false
        end
        return
    end
    
    local target = getClosestPlayer()
    if target then
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
-- ESP
-- ============================================
local function updateESP()
    if not Config.ESPEnabled then
        for _, highlight in pairs(espHighlights) do
            pcall(function() highlight:Destroy() end)
        end
        espHighlights = {}
        return
    end
    
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
                highlight.FillColor = Config.ESPColor
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 1
                highlight.Enabled = true
            else
                if highlight then
                    pcall(function() highlight:Destroy() end)
                    espHighlights[player] = nil
                end
            end
        end
    end
end

-- ============================================
-- MOVEMENT SYSTEMS (WITH WARNINGS)
-- ============================================

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

local function startInfiniteJump()
    if infiniteJumpConn then infiniteJumpConn:Disconnect() end
    infiniteJumpConn = UserInputService.JumpRequest:Connect(function()
        if not Config.InfiniteJumpEnabled then return end
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

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
-- CREATE UI WINDOW
-- ============================================
local Window = VozexUI:CreateWindow({
    Name = "VOZEX HUB 👑 | RIVALS"
})

-- Aimbot Tab
local AimbotTab = Window:CreateTab("🎯 Aimbot")

AimbotTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = false,
    Callback = function(Value)
        Config.AimbotEnabled = Value
    end
})

AimbotTab:CreateSlider({
    Name = "Aimbot FOV",
    Range = {50, 500},
    Increment = 5,
    CurrentValue = 150,
    Callback = function(Value)
        Config.AimbotFOV = Value
    end
})

AimbotTab:CreateToggle({
    Name = "Use Smoothing",
    CurrentValue = false,
    Callback = function(Value)
        Config.AimbotSmoothingEnabled = Value
    end
})

AimbotTab:CreateSlider({
    Name = "Smoothing Amount",
    Range = {0.05, 0.5},
    Increment = 0.01,
    CurrentValue = 0.3,
    Callback = function(Value)
        Config.AimbotSmoothing = Value
    end
})

-- Auto Tab
local AutoTab = Window:CreateTab("🤖 Auto")

AutoTab:CreateToggle({
    Name = "Auto Shoot",
    CurrentValue = false,
    Callback = function(Value)
        Config.AutoShoot = Value
    end
})

-- ESP Tab
local ESPTab = Window:CreateTab("👁️ ESP")

ESPTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Callback = function(Value)
        Config.ESPEnabled = Value
        updateESP()
    end
})

ESPTab:CreateToggle({
    Name = "ESP Boxes",
    CurrentValue = false,
    Callback = function(Value)
        Config.ESPBoxes = Value
        updateESP()
    end
})

ESPTab:CreateColorPicker({
    Name = "ESP Color",
    Color = Color3.fromRGB(255, 0, 0),
    Callback = function(Color)
        Config.ESPColor = Color
        updateESP()
    end
})

-- Movement Tab (WITH WARNINGS)
local MovementTab = Window:CreateTab("🏃 Movement")

MovementTab:CreateToggle({
    Name = "Walkspeed",
    CurrentValue = false,
    Callback = function(Value)
        if Value then showBanWarning("Walkspeed modification") end
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
    Name = "Walkspeed Value",
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
    Name = "Jump Power",
    CurrentValue = false,
    Callback = function(Value)
        if Value then showBanWarning("Jump Power modification") end
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
    Name = "Jump Power Value",
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
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(Value)
        if Value then showBanWarning("Noclip") end
        Config.NoclipEnabled = Value
        startNoclip()
    end
})

MovementTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(Value)
        if Value then showBanWarning("Infinite Jump") end
        Config.InfiniteJumpEnabled = Value
        startInfiniteJump()
    end
})

MovementTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(Value)
        if Value then showBanWarning("Fly") end
        Config.FlyEnabled = Value
        if Value then
            startFly()
        elseif flyConn then
            flyConn:Disconnect()
            flyConn = nil
        end
    end
})

MovementTab:CreateSlider({
    Name = "Fly Speed",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = 100,
    Callback = function(Value)
        Config.FlySpeed = Value
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("⚙️ Settings")

SettingsTab:CreateToggle({
    Name = "No Crosshair",
    CurrentValue = false,
    Callback = function(Value)
        Config.NoCrosshair = Value
        if Value then
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                local crosshair = playerGui:FindFirstChild("Crosshair", true)
                if crosshair then crosshair.Visible = false end
            end
        end
    end
})

SettingsTab:CreateButton({
    Name = "Join Discord",
    Callback = function()
        setclipboard("https://discord.gg/Tttz6mNAet")
        Window:Notify({Title = "Discord", Content = "Link copied to clipboard!", Duration = 2})
    end
})

-- ============================================
-- CLEANUP
-- ============================================
Players.PlayerRemoving:Connect(function(player)
    if espHighlights[player] then
        pcall(function() espHighlights[player]:Destroy() end)
        espHighlights[player] = nil
    end
end)

-- ============================================
-- MAIN LOOP
-- ============================================
RunService.RenderStepped:Connect(function()
    pcall(updateAimbot)
    pcall(checkAutoShoot)
    pcall(updateESP)
end)

-- Start systems
startNoclip()
startInfiniteJump()

-- Welcome
Window:Notify({
    Title = "✨ Vozex Hub Loaded!",
    Content = "All features ready. Use at your own risk!",
    Duration = 3
})

print("VOZEX HUB - RIVALS EDITION LOADED!")