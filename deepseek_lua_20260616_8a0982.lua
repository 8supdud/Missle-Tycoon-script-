local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- =========================================================================
-- GROW A GARDEN 2 DATA & CONFIGURATION
-- =========================================================================
local SEEDS = {
    {"Dragon Fruit", "dragon_fruit"},
    {"Banana", "banana"},
    {"Green Bean", "green_bean"},
    {"Carrot", "carrot"},
    {"Tomato", "tomato"},
    {"Acorn", "acorn"},
    {"Apple", "apple"},
    {"Pineapple", "pineapple"},
    {"Sunflower", "sunflower"},
    {"Moon Bloom", "moon_bloom"}
}

_G.AutoBuyAllSeeds = false
_G.AutoBuySelectedSeed = false
_G.AutoHarvest = false
_G.AutoPlant = false
_G.SelectedSeedID = SEEDS[1][2]
_G.BuyDelay = 0.5
_G.HarvestDelay = 1

-- =========================================================================
-- ADVANCED NETWORK LAYER (FINDING THE CORRECT REMOTES)
-- =========================================================================
local function findRemote(remoteName, timeout)
    timeout = timeout or 5
    local startTime = tick()
    while tick() - startTime < timeout do
        for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                if remote.Name:find(remoteName) or remote.Name:lower():find(remoteName:lower()) then
                    return remote
                end
            end
        end
        task.wait(0.1)
    end
    return nil
end

-- Find the actual harvest and plant remotes
local HarvestRemote = findRemote("Harvest")
local PlantRemote = findRemote("Plant")
local PurchaseRemote = findRemote("Buy") or findRemote("Purchase") or findRemote("Shop")

-- Find the garden plots/plants in workspace
local function getGardenPlots()
    local plots = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:find("Plot") then
            table.insert(plots, obj)
        end
    end
    return plots
end

local function getReadyPlants()
    local readyPlants = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        -- Look for plants that are ready to harvest
        if obj:IsA("Model") and obj:FindFirstChild("Plant") then
            -- Check if plant has a growth value or is fully grown
            if obj:FindFirstChild("Growth") then
                if obj.Growth.Value >= 1 then
                    table.insert(readyPlants, obj)
                end
            end
        end
    end
    return readyPlants
end

local function getEmptyPlots()
    local emptyPlots = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:find("Plot") then
            -- Check if plot is empty (no plant child)
            local hasPlant = false
            for _, child in ipairs(obj:GetChildren()) do
                if child:IsA("Model") and child.Name:find("Plant") then
                    hasPlant = true
                    break
                end
            end
            if not hasPlant then
                table.insert(emptyPlots, obj)
            end
        end
    end
    return emptyPlots
end

local function buySeed(seedId)
    if PurchaseRemote then
        -- Try different remote call patterns
        local success, result = pcall(function()
            if PurchaseRemote:IsA("RemoteFunction") then
                return PurchaseRemote:InvokeServer("Buy", seedId, 1)
            else
                PurchaseRemote:FireServer("Buy", seedId, 1)
                -- Some games use different arguments
                PurchaseRemote:FireServer("Purchase", seedId, 1)
                PurchaseRemote:FireServer(seedId, 1)
            end
        end)
        return success
    end
    return false
end

local function harvestPlant(plant)
    if HarvestRemote and plant then
        pcall(function()
            if HarvestRemote:IsA("RemoteFunction") then
                return HarvestRemote:InvokeServer(plant)
            else
                HarvestRemote:FireServer(plant)
                HarvestRemote:FireServer("Harvest", plant)
            end
        end)
        return true
    end
    return false
end

local function plantSeed(plot, seedId)
    if PlantRemote and plot then
        pcall(function()
            if PlantRemote:IsA("RemoteFunction") then
                return PlantRemote:InvokeServer(plot, seedId)
            else
                PlantRemote:FireServer(plot, seedId)
                PlantRemote:FireServer("Plant", plot, seedId)
            end
        end)
        return true
    end
    return false
end

-- =========================================================================
-- AUTOMATION TASK FUNCTIONS
-- =========================================================================
local function autoHarvestLoop()
    while _G.AutoHarvest do
        local readyPlants = getReadyPlants()
        for _, plant in ipairs(readyPlants) do
            if not _G.AutoHarvest then break end
            harvestPlant(plant)
            task.wait(_G.HarvestDelay)
        end
        task.wait(0.5) -- Wait before checking again
    end
end

local function autoPlantLoop()
    while _G.AutoPlant do
        local emptyPlots = getEmptyPlots()
        if #emptyPlots > 0 and _G.SelectedSeedID then
            for _, plot in ipairs(emptyPlots) do
                if not _G.AutoPlant then break end
                plantSeed(plot, _G.SelectedSeedID)
                task.wait(0.5)
            end
        end
        task.wait(1)
    end
end

local function autoBuyLoop()
    while _G.AutoBuyAllSeeds do
        for _, seed in ipairs(SEEDS) do
            if not _G.AutoBuyAllSeeds then break end
            buySeed(seed[2])
            task.wait(_G.BuyDelay)
        end
    end
end

local function autoBuySelectedLoop()
    while _G.AutoBuySelectedSeed do
        buySeed(_G.SelectedSeedID)
        task.wait(_G.BuyDelay)
    end
end

-- =========================================================================
-- VOZEX NATIVE UI LIBRARY - THE TAB ENGINE
-- =========================================================================
local VozexUI = {}
VozexUI.Colors = {
    Bg = Color3.fromRGB(15, 22, 15), 
    Panel = Color3.fromRGB(22, 30, 22),
    PanelLight = Color3.fromRGB(32, 45, 32),
    Accent = Color3.fromRGB(50, 205, 50), 
    Text = Color3.fromRGB(240, 240, 240),
    TextDim = Color3.fromRGB(150, 170, 150),
    Red = Color3.fromRGB(255, 50, 50),
    Gold = Color3.fromRGB(255, 215, 0)
}

function VozexUI:MakeDraggable(gui, handle)
    handle = handle or gui
    local dragging, dragInput, mousePos, framePos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; mousePos = input.Position; framePos = gui.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            local screen = gui.Parent and gui.Parent:IsA("ScreenGui") and gui.Parent.AbsoluteSize or Vector2.new(1000, 1000)
            local padding = 15
            local targetX = framePos.X.Offset + delta.X
            local targetY = framePos.Y.Offset + delta.Y
            
            local minX = padding - (gui.AbsoluteSize.X * gui.AnchorPoint.X)
            local maxX = screen.X - padding - (gui.AbsoluteSize.X * (1 - gui.AnchorPoint.X))
            local minY = padding - (gui.AbsoluteSize.Y * gui.AnchorPoint.Y)
            local maxY = screen.Y - padding - (gui.AbsoluteSize.Y * (1 - gui.AnchorPoint.Y))

            gui.Position = UDim2.new(framePos.X.Scale, math.clamp(targetX, minX, maxX), framePos.Y.Scale, math.clamp(targetY, minY, maxY))
        end
    end)
end

function VozexUI:CreateWindow(opts)
    local isMobile = UserInputService.TouchEnabled
    local title = type(opts) == "table" and opts.Name or opts
    local sg = Instance.new("ScreenGui")
    sg.Name = "VozexNativeUI"
    sg.ResetOnSpawn = false
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local floatBtn = Instance.new("TextButton")
    floatBtn.Size = UDim2.new(0, 50, 0, 50)
    floatBtn.Position = UDim2.new(0.5, -25, 0, 20)
    floatBtn.BackgroundColor3 = self.Colors.Panel
    floatBtn.Text = "👑"
    floatBtn.TextSize = 24
    floatBtn.Visible = false
    floatBtn.Parent = sg
    Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(1, 0)
    local fStroke = Instance.new("UIStroke", floatBtn); fStroke.Color = self.Colors.Accent; fStroke.Thickness = 2
    self:MakeDraggable(floatBtn)

    local main = Instance.new("Frame")
    if isMobile then
        main.Size = UDim2.new(0, 600 * 0.85, 0, 480 * 0.85)
    else
        main.Size = UDim2.new(0, 600, 0, 480)
    end
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = self.Colors.Bg
    main.Active = true
    main.Parent = sg
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)
    local mStroke = Instance.new("UIStroke", main); mStroke.Color = self.Colors.PanelLight; mStroke.Thickness = 1

    local function refineUIElement(element)
        if element:IsA("Frame") or element:IsA("ScrollingFrame") or element:IsA("CanvasGroup") then
            element.Active = true
        elseif element:IsA("TextButton") or element:IsA("ImageButton") then
            element.Active = true
        end
    end
    for _, child in ipairs(main:GetDescendants()) do refineUIElement(child) end
    main.DescendantAdded:Connect(refineUIElement)

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundColor3 = self.Colors.Panel
    topBar.Parent = main
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 8)
    local tFix = Instance.new("Frame", topBar); tFix.Size = UDim2.new(1,0,0,8); tFix.Position = UDim2.new(0,0,1,-8); tFix.BackgroundColor3 = self.Colors.Panel; tFix.BorderSizePixel = 0
    self:MakeDraggable(main, topBar)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -60, 1, 0)
    titleLbl.Position = UDim2.new(0, 15, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = self.Colors.Accent
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 15
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = topBar

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 24, 0, 24)
    minBtn.Position = UDim2.new(1, -35, 0.5, -12)
    minBtn.BackgroundColor3 = self.Colors.PanelLight
    minBtn.Text = "➖"
    minBtn.TextColor3 = self.Colors.Text
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 12
    minBtn.Parent = topBar
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

    minBtn.MouseButton1Click:Connect(function() main.Visible = false; floatBtn.Visible = true end)
    floatBtn.MouseButton1Click:Connect(function() floatBtn.Visible = false; main.Visible = true end)

    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Size = UDim2.new(0, 140, 1, -40)
    tabContainer.Position = UDim2.new(0, 0, 0, 40)
    tabContainer.BackgroundColor3 = self.Colors.Panel
    tabContainer.BorderSizePixel = 0
    tabContainer.ScrollBarThickness = 0
    tabContainer.Parent = main
    local tLayout = Instance.new("UIListLayout", tabContainer); tLayout.Padding = UDim.new(0, 4); tLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Instance.new("UIPadding", tabContainer).PaddingTop = UDim.new(0, 8)
    tLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() tabContainer.CanvasSize = UDim2.new(0,0,0, tLayout.AbsoluteContentSize.Y + 15) end)

    local pageContainer = Instance.new("Frame")
    pageContainer.Size = UDim2.new(1, -140, 1, -40)
    pageContainer.Position = UDim2.new(0, 140, 0, 40)
    pageContainer.BackgroundTransparency = 1
    pageContainer.Parent = main

    local WindowObj = {Tabs = {}, CurrentTab = nil, Gui = sg}

    function WindowObj:CreateTab(name)
        local tBtn = Instance.new("TextButton")
        tBtn.Size = UDim2.new(1, -14, 0, 32)
        tBtn.BackgroundColor3 = VozexUI.Colors.PanelLight
        tBtn.BackgroundTransparency = 1
        tBtn.Text = name
        tBtn.TextColor3 = VozexUI.Colors.TextDim
        tBtn.Font = Enum.Font.GothamSemibold
        tBtn.TextSize = 13
        tBtn.Parent = tabContainer
        Instance.new("UICorner", tBtn).CornerRadius = UDim.new(0, 6)

        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 3, 0.6, 0)
        indicator.Position = UDim2.new(0, 0, 0.2, 0)
        indicator.BackgroundColor3 = VozexUI.Colors.Accent
        indicator.BackgroundTransparency = 1
        indicator.Parent = tBtn
        Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = VozexUI.Colors.Accent
        page.Visible = false
        page.Parent = pageContainer
        
        local pLayout = Instance.new("UIListLayout", page)
        pLayout.Padding = UDim.new(0, 6)
        pLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        pLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        local orderCount = 0

        local pPad = Instance.new("UIPadding", page)
        pPad.PaddingTop = UDim.new(0, 10); pPad.PaddingBottom = UDim.new(0, 10)

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
                    TweenService:Create(btn:FindFirstChild("Frame"), TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                end 
            end
            for _, p in ipairs(pageContainer:GetChildren()) do p.Visible = false end
            TweenService:Create(tBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0, TextColor3 = VozexUI.Colors.Text}):Play()
            TweenService:Create(indicator, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
            page.Visible = true
        end)

        local TabObj = {}
        
        function TabObj:CreateSection(text)
            orderCount = orderCount + 1
            local sLbl = Instance.new("TextLabel")
            sLbl.LayoutOrder = orderCount
            sLbl.Size = UDim2.new(1, -20, 0, 25)
            sLbl.BackgroundTransparency = 1
            sLbl.Text = text
            sLbl.TextColor3 = VozexUI.Colors.Accent
            sLbl.Font = Enum.Font.GothamBold
            sLbl.TextSize = 14
            sLbl.TextXAlignment = Enum.TextXAlignment.Left
            sLbl.Parent = page
        end

        function TabObj:CreateToggle(opts)
            orderCount = orderCount + 1
            local state = opts.CurrentValue or false
            local tgl = Instance.new("TextButton")
            tgl.LayoutOrder = orderCount
            tgl.Size = UDim2.new(1, -20, 0, 36)
            tgl.BackgroundColor3 = VozexUI.Colors.Panel
            tgl.Text = "   " .. opts.Name
            tgl.TextColor3 = VozexUI.Colors.Text
            tgl.Font = Enum.Font.GothamSemibold
            tgl.TextSize = 13
            tgl.TextXAlignment = Enum.TextXAlignment.Left
            tgl.Parent = page
            Instance.new("UICorner", tgl).CornerRadius = UDim.new(0, 6)
            Instance.new("UIStroke", tgl).Color = VozexUI.Colors.PanelLight

            local bg = Instance.new("Frame")
            bg.Size = UDim2.new(0, 34, 0, 18)
            bg.Position = UDim2.new(1, -45, 0.5, -9)
            bg.BackgroundColor3 = state and VozexUI.Colors.Accent or VozexUI.Colors.Bg
            bg.Parent = tgl
            Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 14, 0, 14)
            knob.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            knob.BackgroundColor3 = VozexUI.Colors.Text
            knob.Parent = bg
            Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

            tgl.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = state and VozexUI.Colors.Accent or VozexUI.Colors.Bg}):Play()
                TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
                opts.Callback(state)
            end)
        end

        function TabObj:CreateDropdown(opts)
            orderCount = orderCount + 1
            local dropBtn = Instance.new("TextButton")
            dropBtn.LayoutOrder = orderCount
            dropBtn.Size = UDim2.new(1, -20, 0, 36)
            dropBtn.BackgroundColor3 = VozexUI.Colors.Panel
            dropBtn.Text = "   " .. opts.Name .. ": " .. (opts.CurrentOption or opts.Options[1] or "")
            dropBtn.TextColor3 = VozexUI.Colors.Text
            dropBtn.Font = Enum.Font.GothamSemibold
            dropBtn.TextSize = 13
            dropBtn.TextXAlignment = Enum.TextXAlignment.Left
            dropBtn.Parent = page
            Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 6)
            Instance.new("UIStroke", dropBtn).Color = VozexUI.Colors.PanelLight

            orderCount = orderCount + 1
            local listFrame = Instance.new("Frame")
            listFrame.LayoutOrder = orderCount
            listFrame.Size = UDim2.new(1, -20, 0, 0)
            listFrame.BackgroundColor3 = VozexUI.Colors.Bg
            listFrame.ClipsDescendants = true
            listFrame.Visible = false
            listFrame.Parent = page
            Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 6)

            local open = false
            local function populate(options)
                for _, c in ipairs(listFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                local h = 0
                for _, opt in ipairs(options) do
                    local b = Instance.new("TextButton")
                    b.Size = UDim2.new(1, 0, 0, 30); b.BackgroundColor3 = VozexUI.Colors.Bg; b.Text = opt; b.TextColor3 = VozexUI.Colors.TextDim; b.Font = Enum.Font.Gotham; b.TextSize = 13; b.Parent = listFrame
                    b.MouseButton1Click:Connect(function()
                        dropBtn.Text = "   " .. opts.Name .. ": " .. opt
                        TweenService:Create(listFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -20, 0, 0)}):Play()
                        task.wait(0.2) listFrame.Visible = false; open = false
                        opts.Callback({opt})
                    end)
                    b.Position = UDim2.new(0, 0, 0, h)
                    h = h + 30
                end
                if open then listFrame.Size = UDim2.new(1, -20, 0, h) end
            end
            populate(opts.Options)

            dropBtn.MouseButton1Click:Connect(function()
                open = not open
                if open then 
                    listFrame.Visible = true 
                    TweenService:Create(listFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -20, 0, #listFrame:GetChildren() * 30)}):Play()
                else 
                    TweenService:Create(listFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -20, 0, 0)}):Play()
                    task.wait(0.2) listFrame.Visible = false 
                end
            end)
            return { Refresh = function(_, newOpts) populate(newOpts) end }
        end

        function TabObj:CreateSlider(opts)
            orderCount = orderCount + 1
            local val = opts.CurrentValue or opts.Range[1]
            local frm = Instance.new("Frame")
            frm.LayoutOrder = orderCount
            frm.Size = UDim2.new(1, -20, 0, 50)
            frm.BackgroundColor3 = VozexUI.Colors.Panel
            frm.Parent = page
            Instance.new("UICorner", frm).CornerRadius = UDim.new(0, 6)
            Instance.new("UIStroke", frm).Color = VozexUI.Colors.PanelLight

            local lbl = Instance.new("TextLabel", frm)
            lbl.Size = UDim2.new(1, -20, 0, 20); lbl.Position = UDim2.new(0, 10, 0, 5); lbl.BackgroundTransparency = 1; lbl.Text = opts.Name .. ": " .. val; lbl.TextColor3 = VozexUI.Colors.Text; lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left

            local bgBar = Instance.new("TextButton", frm)
            bgBar.Size = UDim2.new(1, -20, 0, 8); bgBar.Position = UDim2.new(0, 10, 0, 32); bgBar.BackgroundColor3 = VozexUI.Colors.Bg; bgBar.Text = ""; bgBar.AutoButtonColor = false
            Instance.new("UICorner", bgBar).CornerRadius = UDim.new(1, 0)
            
            local fill = Instance.new("Frame", bgBar)
            fill.BackgroundColor3 = VozexUI.Colors.Accent; fill.Size = UDim2.new((val - opts.Range[1])/(opts.Range[2] - opts.Range[1]), 0, 1, 0)
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
            bgBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; update(input) end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
            UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end end)
        end

        function TabObj:CreateLabel(text, color)
            orderCount = orderCount + 1
            local label = Instance.new("TextLabel")
            label.LayoutOrder = orderCount
            label.Size = UDim2.new(1, -20, 0, 30)
            label.BackgroundColor3 = VozexUI.Colors.Panel
            label.Text = text
            label.TextColor3 = color or VozexUI.Colors.Text
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.Parent = page
            Instance.new("UICorner", label).CornerRadius = UDim.new(0, 6)
        end

        return TabObj
    end

    function WindowObj:Notify(opts)
        -- Create a simple notification
        local notif = Instance.new("Frame")
        notif.Size = UDim2.new(0, 300, 0, 50)
        notif.Position = UDim2.new(0.5, -150, 0, 20)
        notif.BackgroundColor3 = self.Colors.Panel
        notif.Parent = sg
        Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 6)
        
        local titleLbl = Instance.new("TextLabel", notif)
        titleLbl.Size = UDim2.new(1, 0, 0.5, 0)
        titleLbl.Position = UDim2.new(0, 10, 0, 0)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = opts.Title or "Notification"
        titleLbl.TextColor3 = self.Colors.Accent
        titleLbl.Font = Enum.Font.GothamBold
        titleLbl.TextSize = 14
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        
        local contentLbl = Instance.new("TextLabel", notif)
        contentLbl.Size = UDim2.new(1, 0, 0.5, 0)
        contentLbl.Position = UDim2.new(0, 10, 0, 25)
        contentLbl.BackgroundTransparency = 1
        contentLbl.Text = opts.Content or ""
        contentLbl.TextColor3 = self.Colors.TextDim
        contentLbl.Font = Enum.Font.Gotham
        contentLbl.TextSize = 12
        contentLbl.TextXAlignment = Enum.TextXAlignment.Left
        
        task.delay(3, function()
            TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -150, 0, -60)}):Play()
            task.wait(0.3)
            notif:Destroy()
        end)
    end

    return WindowObj
end

-- =========================================================================
-- INITIALIZE INTERFACE CANVAS
-- =========================================================================
local Rayfield = VozexUI 
local Window = Rayfield:CreateWindow({
    Name = "Grow A Garden 2 🌱 | Vozex Hub 👑"
})

-- =========================================================================
-- TAB: SEED SHOP LOGIC
-- =========================================================================
local ShopTab = Window:CreateTab("🌱 Seed Shop")

ShopTab:CreateSection("Global Purchasing Options")

ShopTab:CreateToggle({
    Name = "🔄 Auto Buy ALL Seeds",
    CurrentValue = false,
    Callback = function(v)
        _G.AutoBuyAllSeeds = v
        if v then
            task.spawn(autoBuyLoop)
        end
    end
})

ShopTab:CreateSection("Targeted Purchasing Options")

local seedNames = {}
for _, seed in ipairs(SEEDS) do table.insert(seedNames, seed[1]) end

ShopTab:CreateDropdown({
    Name = "🎯 Choose Individual Seed",
    Options = seedNames,
    CurrentOption = SEEDS[1][1],
    Callback = function(selection)
        local selectedName = selection[1]
        for _, seed in ipairs(SEEDS) do
            if seed[1] == selectedName then
                _G.SelectedSeedID = seed[2]
                break
            end
        end
    end
})

ShopTab:CreateToggle({
    Name = "✅ Auto Buy Selected Seed",
    CurrentValue = false,
    Callback = function(v)
        _G.AutoBuySelectedSeed = v
        if v then
            task.spawn(autoBuySelectedLoop)
        end
    end
})

ShopTab:CreateSection("Throttling Configuration")

ShopTab:CreateSlider({
    Name = "Purchase Cooldown (Secs)",
    Range = {0.1, 3},
    Increment = 0.1,
    CurrentValue = 0.5,
    Callback = function(v)
        _G.BuyDelay = v
    end
})

-- =========================================================================
-- TAB: GARDEN AUTOMATION (NEW)
-- =========================================================================
local GardenTab = Window:CreateTab("🌿 Garden")

GardenTab:CreateSection("Automation Controls")

GardenTab:CreateToggle({
    Name = "🌾 Auto Harvest (Collects ready plants)",
    CurrentValue = false,
    Callback = function(v)
        _G.AutoHarvest = v
        if v then
            task.spawn(autoHarvestLoop)
        end
    end
})

GardenTab:CreateToggle({
    Name = "🌱 Auto Plant (Plants seeds in empty plots)",
    CurrentValue = false,
    Callback = function(v)
        _G.AutoPlant = v
        if v then
            task.spawn(autoPlantLoop)
        end
    end
})

GardenTab:CreateSection("Harvest Configuration")

GardenTab:CreateSlider({
    Name = "Harvest Delay (Secs)",
    Range = {0.5, 5},
    Increment = 0.1,
    CurrentValue = 1,
    Callback = function(v)
        _G.HarvestDelay = v
    end
})

GardenTab:CreateSection("Garden Status")

-- Status display
local statusLabel
GardenTab:CreateLabel("🔍 Scanning garden...", VozexUI.Colors.TextDim)

-- Update status periodically
task.spawn(function()
    while true do
        local readyCount = #getReadyPlants()
        local emptyCount = #getEmptyPlots()
        -- Update the last label
        local labels = {}
        for _, child in ipairs(pageContainer:GetChildren()) do
            if child:IsA("ScrollingFrame") and child.Visible then
                for _, grandchild in ipairs(child:GetChildren()) do
                    if grandchild:IsA("TextLabel") and grandchild.Text:find("🔍") then
                        grandchild.Text = string.format("🔍 Ready: %d | Empty Plots: %d", readyCount, emptyCount)
                    end
                end
            end
        end
        task.wait(2)
    end
end)

-- =========================================================================
-- TAB: DEBUG INFO (FOR FINDING REMOTES)
-- =========================================================================
local DebugTab = Window:CreateTab("🔧 Debug")

DebugTab:CreateSection("Remote Info")

DebugTab:CreateToggle({
    Name = "🔄 Show Remote Logs",
    CurrentValue = false,
    Callback = function(v)
        -- Toggle debug logging
        if v then
            print("=== REMOTE DEBUG INFO ===")
            print("Harvest Remote:", HarvestRemote and HarvestRemote.Name or "Not Found")
            print("Plant Remote:", PlantRemote and PlantRemote.Name or "Not Found")
            print("Purchase Remote:", PurchaseRemote and PurchaseRemote.Name or "Not Found")
            print("==========================")
        end
    end
})

DebugTab:CreateSection("Manual Actions")

DebugTab:CreateToggle({
    Name = "🔍 Scan Garden (One Time)",
    CurrentValue = false,
    Callback = function(v)
        if v then
            local ready = getReadyPlants()
            local empty = getEmptyPlots()
            print(string.format("Found %d ready plants and %d empty plots", #ready, #empty))
            for i, plant in ipairs(ready) do
                print(string.format("Ready Plant %d: %s", i, plant.Name))
            end
            _G.AutoScan = false
        end
    end
})

Window:Notify({Title = "Vozex Hub Loaded ✅", Content = "Garden automation tools ready. Use Debug tab if features don't work."})

-- =========================================================================
-- INITIALIZATION COMPLETE
-- =========================================================================
print("[VOZEX HUB] Successfully loaded Grow A Garden 2 automation")