--[[
    VOZEX HUB - RIVALS SCRIPT
    Fixed: Removed "Lightning" error, stable UI
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
local Lighting = game:GetService("Lighting")
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
    TextDim = Color3.fromRGB(150, 150, 150)
}

function VozexUI:MakeDraggable(gui, handle)
    handle = handle or gui
    local dragging, dragInput, mousePos, framePos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            gui.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

function VozexUI:CreateWindow(opts)
    local title = type(opts) == "table" and opts.Name or opts
    local sg = Instance.new("ScreenGui")
    sg.Name = "VozexNativeUI"
    sg.ResetOnSpawn = false
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then
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
    local fStroke = Instance.new("UIStroke", floatBtn)
    fStroke.Color = self.Colors.Accent
    fStroke.Thickness = 2
    self:MakeDraggable(floatBtn)

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 580, 0, 480)
    main.Position = UDim2.new(0.5, -290, 0.5, -240)
    main.BackgroundColor3 = self.Colors.Bg
    main.Active = true
    main.Parent = sg
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
    local mStroke = Instance.new("UIStroke", main)
    mStroke.Color = self.Colors.PanelLight
    mStroke.Thickness = 1

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 45)
    topBar.BackgroundColor3 = self.Colors.Panel
    topBar.Parent = main
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 10)
    local tFix = Instance.new("Frame", topBar)
    tFix.Size = UDim2.new(1, 0, 0, 8)
    tFix.Position = UDim2.new(0, 0, 1, -8)
    tFix.BackgroundColor3 = self.Colors.Panel
    tFix.BorderSizePixel = 0
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
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = self.Colors.Text
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
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

    local WindowObj = {Tabs = {}, CurrentTab = nil, Gui = sg}

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
        
        local pPad = Instance.new("UIPadding", page)
        pPad.PaddingTop = UDim.new(0, 8)
        pPad.PaddingBottom = UDim.new(0, 8)

        pLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() 
            page.CanvasSize = UDim2.new(0, 0, 0, pLayout.AbsoluteContentSize.Y + 20)
        end)

        if not self.CurrentTab then
            self.CurrentTab = page
            page.Visible = true
            tBtn.BackgroundTransparency = 0
            tBtn.TextColor3 = VozexUI.Colors.Text
            indicator.BackgroundTransparency = 0
        end

        tBtn.MouseButton1Click:Connect(function()
            for _, btn in ipairs(tabContainer:GetChildren()) do 
                if btn:IsA("TextButton") then 
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = VozexUI.Colors.TextDim}):Play()
                    local ind = btn:FindFirstChild("Frame")
                    if ind then TweenService:Create(ind, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() end
                end 
            end
            for _, p in ipairs(pageContainer:GetChildren()) do
                if p:IsA("ScrollingFrame") then p.Visible = false end
            end
            
            TweenService:Create(tBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0, TextColor3 = VozexUI.Colors.Text}):Play()
            TweenService:Create(indicator, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
            page.Visible = true
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
            Instance.new("UIStroke", btn).Color = VozexUI.Colors.PanelLight
            
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
            Instance.new("UIStroke", tgl).Color = VozexUI.Colors.PanelLight

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
            Instance.new("UIStroke", frm).Color = VozexUI.Colors.PanelLight

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
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    update(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
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
            Instance.new("UIStroke", dropBtn).Color = VozexUI.Colors.PanelLight

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
            
            return { Refresh = function(_, newOpts) populate(newOpts) end }
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
            Instance.new("UIStroke", btn).Color = VozexUI.Colors.PanelLight

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
                    Color3.fromRGB(255, 0, 255),
                    Color3.fromRGB(0, 255, 255),
                    Color3.fromRGB(255, 255, 255),
                    Color3.fromRGB(255, 215, 0),
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
            return { Set = function(_, txt) lbl.Text = "   " .. txt end }
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
    AimbotPart = "Head",
    AimbotFOV = 150,
    AimbotSmoothing = 0.3,
    AimbotSmoothingEnabled = false,
    PersistentAimbot = false,
    TargetBehindWalls = false,
    DrawFOVCircle = true,
    AutoShoot = false,
    ESPEnabled = false,
    ESPBoxes = false,
    ESPHealthBar = true,
    ESPColor = Color3.fromRGB(255, 0, 0),
    ESPBlinking = false,
    ESPTransparency = 0.3,
    WalkspeedEnabled = false,
    WalkspeedValue = 25.2,
    JumpPowerEnabled = false,
    JumpPowerValue = 20,
    NoclipEnabled = false,
    InfiniteJumpEnabled = false,
    FlyEnabled = false,
    FlySpeed = 100,
    SixthSense = false,
    HideSmoke = false,
    HideFlashbang = false,
    NoCrosshair = false,
    ShowFPS = false,
    TeamCheck = true,
}

-- ============================================
-- GLOBAL VARIABLES
-- ============================================
local persistentTarget = nil
local fovCircle = nil
local flyConn = nil
local noclipConn = nil
local infiniteJumpConn = nil
local fpsLabel = nil
local fpsConn = nil
local smokeCleanupConn = nil
local flashCleanupConn = nil
local sixthSenseConn = nil
local espHighlights = {}
local healthBars = {}

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================
local function isTeammate(player)
    if not Config.TeamCheck then return false end
    local localTeam = LocalPlayer:GetAttribute("TeamID")
    local playerTeam = player:GetAttribute("TeamID")
    if localTeam and playerTeam then
        return localTeam == playerTeam
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
-- AIMBOT
-- ============================================
local function updateAimbot()
    if not Config.AimbotEnabled then 
        persistentTarget = nil
        return 
    end
    
    if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        persistentTarget = nil
        return
    end
    
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
    
    local screenPos = Camera:WorldToViewportPoint(targetPart.Position)
    if screenPos.Z > 0 then
        local targetVec = Vector2.new(screenPos.X, screenPos.Y)
        local currentVec = Vector2.new(Mouse.X, Mouse.Y)
        local delta = targetVec - currentVec
        
        if Config.AimbotSmoothingEnabled then
            local smoothedDelta = delta * Config.AimbotSmoothing
            mousemoverel(smoothedDelta.X, smoothedDelta.Y)
        else
            mousemoverel(delta.X, delta.Y)
        end
    end
end

-- ============================================
-- AUTO SHOOT
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
                    pcall(function() highlight:Destroy() end)
                    espHighlights[player] = nil
                end
            end
        end
    end
end

-- ============================================
-- HEALTH BARS
-- ============================================
local function createHealthBar(player)
    if healthBars[player] then return end
    
    local character = player.Character
    if not character then return end
    
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    pcall(function()
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
        label.TextSize = 11
        label.Text = ""
        label.Parent = billboard
        
        healthBars[player] = {billboard = billboard, fill = fill, label = label}
        
        task.spawn(function()
            while healthBars[player] and player and player.Character do
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    local health = humanoid.Health
                    local maxHealth = humanoid.MaxHealth
                    local percent = math.clamp(health / maxHealth, 0, 1)
                    fill.Size = UDim2.new(percent, 0, 1, 0)
                    if percent > 0.5 then
                        fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                    elseif percent > 0.25 then
                        fill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                    else
                        fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                    end
                    label.Text = math.floor(health) .. "/" .. math.floor(maxHealth)
                end
                task.wait(0.1)
            end
        end)
    end)
end

-- ============================================
-- MOVEMENT SYSTEMS
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
            if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
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
-- SIXTH SENSE
-- ============================================
local function startSixthSense()
    if sixthSenseConn then sixthSenseConn:Disconnect() end
    
    sixthSenseConn = RunService.Stepped:Connect(function()
        if not Config.SixthSense then return end
        
        local lpPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not lpPos then return end
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local tool = player.Character:FindFirstChildOfClass("Tool")
                if tool and (tool.Name:lower():find("katana") or tool.Name:lower():find("blade")) then
                    local targetPos = player.Character:FindFirstChild("HumanoidRootPart")
                    if targetPos and (targetPos.Position - lpPos.Position).Magnitude < 150 then
                        local highlight = player.Character:FindFirstChild("SixthSenseHighlight")
                        if not highlight then
                            highlight = Instance.new("Highlight")
                            highlight.Name = "SixthSenseHighlight"
                            highlight.FillColor = Color3.fromRGB(255, 0, 0)
                            highlight.FillTransparency = 0.5
                            highlight.Parent = player.Character
                            task.delay(0.5, function()
                                if highlight then highlight:Destroy() end
                            end)
                        end
                    end
                end
            end
        end
    end)
end

-- ============================================
-- VISUAL CLEANUP
-- ============================================
local function startSmokeCleanup()
    if smokeCleanupConn then smokeCleanupConn:Disconnect() end
    smokeCleanupConn = RunService.Stepped:Connect(function()
        if not Config.HideSmoke then return end
        if tick() % 3 < 0.1 then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == "Smoke Grenade" then
                    pcall(function() obj:Destroy() end)
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
                if obj.Name == "FlashbangEffect" then
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
        pcall(function()
            fovCircle = Drawing.new("Circle")
            fovCircle.Thickness = 1
            fovCircle.Filled = false
            fovCircle.Color = Color3.fromRGB(255, 255, 255)
            fovCircle.Visible = true
        end)
    end
    
    pcall(function()
        if fovCircle then
            local viewport = Camera.ViewportSize
            fovCircle.Position = Vector2.new(viewport.X / 2, viewport.Y / 2)
            fovCircle.Radius = Config.AimbotFOV
            fovCircle.Visible = true
        end
    end)
end

-- ============================================
-- FPS COUNTER
-- ============================================
local function startFPS()
    if fpsConn then fpsConn:Disconnect() end
    if fpsLabel and fpsLabel.Remove then pcall(function() fpsLabel:Remove() end) end
    
    if not Config.ShowFPS then return end
    
    pcall(function()
        fpsLabel = Drawing.new("Text")
        fpsLabel.Size = 16
        fpsLabel.Color = Color3.fromRGB(0, 255, 0)
        fpsLabel.Center = false
        fpsLabel.Outline = true
        fpsLabel.Position = Vector2.new(10, 10)
        fpsLabel.Font = 2
    end)
    
    if not fpsLabel then return end
    
    local frameCount = 0
    local lastTime = tick()
    
    fpsConn = RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local now = tick()
        if now - lastTime >= 1 then
            local fps = frameCount
            pcall(function()
                if fpsLabel then
                    fpsLabel.Text = "FPS: " .. fps
                    if fps >= 60 then
                        fpsLabel.Color = Color3.fromRGB(0, 255, 0)
                    elseif fps >= 30 then
                        fpsLabel.Color = Color3.fromRGB(255, 255, 0)
                    else
                        fpsLabel.Color = Color3.fromRGB(255, 0, 0)
                    end
                end
            end)
            frameCount = 0
            lastTime = now
        end
    end)
end

-- ============================================
-- CREATE UI
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

AimbotTab:CreateDropdown({
    Name = "Aimbot Part",
    Options = {"Head", "UpperTorso", "HumanoidRootPart"},
    CurrentOption = "Head",
    Callback = function(Opt)
        Config.AimbotPart = Opt[1]
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

AimbotTab:CreateToggle({
    Name = "Persistent Aimbot",
    CurrentValue = false,
    Callback = function(Value)
        Config.PersistentAimbot = Value
    end
})

AimbotTab:CreateToggle({
    Name = "Target Behind Walls",
    CurrentValue = false,
    Callback = function(Value)
        Config.TargetBehindWalls = Value
    end
})

AimbotTab:CreateToggle({
    Name = "Draw FOV Circle",
    CurrentValue = true,
    Callback = function(Value)
        Config.DrawFOVCircle = Value
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

ESPTab:CreateToggle({
    Name = "Health Bars",
    CurrentValue = true,
    Callback = function(Value)
        Config.ESPHealthBar = Value
    end
})

ESPTab:CreateToggle({
    Name = "Blinking ESP",
    CurrentValue = false,
    Callback = function(Value)
        Config.ESPBlinking = Value
    end
})

ESPTab:CreateSlider({
    Name = "ESP Transparency",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = 0.3,
    Callback = function(Value)
        Config.ESPTransparency = Value
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

-- Movement Tab
local MovementTab = Window:CreateTab("🏃 Movement")

MovementTab:CreateToggle({
    Name = "Walkspeed",
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
        Config.NoclipEnabled = Value
        startNoclip()
    end
})

MovementTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(Value)
        Config.InfiniteJumpEnabled = Value
        startInfiniteJump()
    end
})

MovementTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(Value)
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

-- Visuals Tab
local VisualsTab = Window:CreateTab("🎨 Visuals")

VisualsTab:CreateToggle({
    Name = "Sixth Sense",
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
    Name = "Hide Smoke",
    CurrentValue = false,
    Callback = function(Value)
        Config.HideSmoke = Value
        startSmokeCleanup()
    end
})

VisualsTab:CreateToggle({
    Name = "Hide Flashbang",
    CurrentValue = false,
    Callback = function(Value)
        Config.HideFlashbang = Value
        startFlashCleanup()
    end
})

VisualsTab:CreateToggle({
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

VisualsTab:CreateToggle({
    Name = "Show FPS Counter",
    CurrentValue = false,
    Callback = function(Value)
        Config.ShowFPS = Value
        startFPS()
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("⚙️ Settings")

SettingsTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Callback = function(Value)
        Config.TeamCheck = Value
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
-- HEALTH BARS UPDATE LOOP
-- ============================================
task.spawn(function()
    while true do
        if Config.ESPEnabled and Config.ESPHealthBar then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and isValidTarget(player) then
                    if not healthBars[player] then
                        createHealthBar(player)
                    end
                end
            end
        end
        task.wait(1)
    end
end)

-- ============================================
-- CLEANUP ON PLAYER REMOVE
-- ============================================
Players.PlayerRemoving:Connect(function(player)
    if espHighlights[player] then
        pcall(function() espHighlights[player]:Destroy() end)
        espHighlights[player] = nil
    end
    if healthBars[player] then
        pcall(function() healthBars[player].billboard:Destroy() end)
        healthBars[player] = nil
    end
end)

-- ============================================
-- MAIN RENDER LOOP
-- ============================================
RunService.RenderStepped:Connect(function()
    pcall(updateAimbot)
    pcall(checkAutoShoot)
    pcall(updateFOVCircle)
    pcall(updateESP)
end)

-- ============================================
-- START ALL SYSTEMS
-- ============================================
startNoclip()
startInfiniteJump()
startSmokeCleanup()
startFlashCleanup()
startFPS()

-- Welcome message
Window:Notify({
    Title = "✨ Vozex Hub Loaded!",
    Content = "All features are ready. Enjoy!",
    Duration = 3
})

print("VOZEX HUB - RIVALS EDITION (FIXED) LOADED SUCCESSFULLY!")