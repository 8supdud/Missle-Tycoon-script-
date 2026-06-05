-- ─────────────── ✦ Vozex Hub 👑 ✦ ───────────────
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

---------------------------------------------------------------------------

-- ** Interactables API ** --

local ToggleAPI = setmetatable({}, { __mode = "k" })
local DropdownAPI = setmetatable({}, { __mode = "k" })
local KeybindAPI = setmetatable({}, { __mode = "k" })
local SliderAPI = setmetatable({}, { __mode = "k" })
local ButtonAPI = setmetatable({}, { __mode = "k" })
local ColorPickerAPI = setmetatable({}, { __mode = "k" })
local NotificationAPI 

--------------------------------------------------------------------------

-- ** Notification tracking ** --

local RECENT_NOTIFS = setmetatable({}, { __mode = "k" })

---------------------------------------------------------------------------

-- ** Color palette - Modern Glassmorphic Theme **
local COLORS = {
    bg = Color3.fromRGB(10, 8, 20),
    panel = Color3.fromRGB(20, 18, 35),
    panelAlt = Color3.fromRGB(30, 26, 48),
    panelDark = Color3.fromRGB(15, 12, 28),
    divider = Color3.fromRGB(80, 70, 120),
    accent = Color3.fromRGB(0, 212, 255),
    accentHover = Color3.fromRGB(64, 224, 255),
    text = Color3.fromRGB(240, 240, 255),
    textDim = Color3.fromRGB(180, 180, 220),
    tabText = Color3.fromRGB(210, 210, 250),
    highlight = Color3.fromRGB(50, 70, 120),
    white = Color3.fromRGB(255, 255, 255),
    close = Color3.fromRGB(255, 150, 150),
    closeHover = Color3.fromRGB(255, 80, 100),
}

-------------------------------------------------------

local function shallowCopy(t)
    local o = {}
    for k,v in pairs(t) do o[k] = v end
    return o
end

local LAST_THEME = nil

local THEMES = {
    ["Vozex Gold"] = shallowCopy(COLORS),
    ["Cyber Blue"] = {
        bg = Color3.fromRGB(8, 12, 28), panel = Color3.fromRGB(18, 22, 42), panelAlt = Color3.fromRGB(28, 32, 52),
        panelDark = Color3.fromRGB(10, 14, 24), divider = Color3.fromRGB(60, 100, 180), accent = Color3.fromRGB(0, 212, 255),
        accentHover = Color3.fromRGB(64, 224, 255), text = Color3.fromRGB(235, 245, 255), textDim = Color3.fromRGB(170, 190, 240),
        tabText = Color3.fromRGB(200, 220, 255), highlight = Color3.fromRGB(40, 60, 100), white = Color3.fromRGB(255, 255, 255),
        close = Color3.fromRGB(255, 200, 200), closeHover = Color3.fromRGB(255, 120, 150),
    },
    ["Neon Pink"] = {
        bg = Color3.fromRGB(20, 8, 20), panel = Color3.fromRGB(35, 18, 35), panelAlt = Color3.fromRGB(50, 28, 50),
        panelDark = Color3.fromRGB(15, 8, 15), divider = Color3.fromRGB(180, 60, 150), accent = Color3.fromRGB(255, 50, 150),
        accentHover = Color3.fromRGB(255, 100, 180), text = Color3.fromRGB(255, 240, 250), textDim = Color3.fromRGB(220, 170, 210),
        tabText = Color3.fromRGB(240, 200, 230), highlight = Color3.fromRGB(90, 45, 80), white = Color3.fromRGB(255, 255, 255),
        close = Color3.fromRGB(255, 200, 200), closeHover = Color3.fromRGB(255, 120, 150),
    },
    ["Emerald"] = {
        bg = Color3.fromRGB(12, 22, 16), panel = Color3.fromRGB(20, 36, 28), panelAlt = Color3.fromRGB(30, 48, 38),
        panelDark = Color3.fromRGB(8, 16, 10), divider = Color3.fromRGB(50, 120, 80), accent = Color3.fromRGB(80, 220, 120),
        accentHover = Color3.fromRGB(110, 250, 150), text = Color3.fromRGB(240, 255, 245), textDim = Color3.fromRGB(170, 210, 185),
        tabText = Color3.fromRGB(200, 240, 215), highlight = Color3.fromRGB(40, 80, 55), white = Color3.fromRGB(255, 255, 255),
        close = Color3.fromRGB(255, 200, 200), closeHover = Color3.fromRGB(255, 120, 150),
    },
    ["Royal Purple"] = {
        bg = Color3.fromRGB(18, 14, 28), panel = Color3.fromRGB(30, 24, 42), panelAlt = Color3.fromRGB(42, 34, 58),
        panelDark = Color3.fromRGB(14, 10, 22), divider = Color3.fromRGB(100, 70, 140), accent = Color3.fromRGB(180, 100, 255),
        accentHover = Color3.fromRGB(200, 130, 255), text = Color3.fromRGB(250, 240, 255), textDim = Color3.fromRGB(200, 170, 230),
        tabText = Color3.fromRGB(230, 200, 255), highlight = Color3.fromRGB(75, 55, 100), white = Color3.fromRGB(255, 255, 255),
        close = Color3.fromRGB(255, 200, 200), closeHover = Color3.fromRGB(255, 120, 150),
    },
}


-- ** Apply Theme ** --

local function ApplyTheme(name)
    local prev = shallowCopy(COLORS)
    LAST_THEME = prev
    local theme = (type(name) == "string" and THEMES[name]) and THEMES[name] or THEMES["Cyber Blue"]
    COLORS = shallowCopy(theme)

    local map = {}
    for k,v in pairs(prev) do if COLORS[k] then map[v] = COLORS[k] end end

    local function safeLerp(a,b,t)
        if typeof(a) ~= "Color3" or typeof(b) ~= "Color3" then return nil end
        return a:Lerp(b, t)
    end
    pcall(function()
        local pv, nv = prev, COLORS
        local a1 = safeLerp(pv.panel or pv.bg, pv.text, 0.18)
        local b1 = safeLerp(nv.panel or nv.bg, nv.text, 0.18)
        if a1 and b1 then map[a1] = b1 end
        local a2 = safeLerp(pv.accent or pv.text, pv.white or Color3.new(1,1,1), 0.18)
        local b2 = safeLerp(nv.accent or nv.text, nv.white or Color3.new(1,1,1), 0.18)
        if a2 and b2 then map[a2] = b2 end
        local a3 = safeLerp(pv.panel or pv.bg, pv.text, 0.14)
        local b3 = safeLerp(nv.panel or nv.bg, nv.text, 0.14)
        if a3 and b3 then map[a3] = b3 end
        for i=1,3 do
            local oldSurf = (pv.bg or pv.panel or pv.panelAlt)
            local newSurf = (nv.bg or nv.panel or nv.panelAlt)
            if oldSurf and newSurf and a2 and b2 then
                local oldT = safeLerp(oldSurf, a2, 0.06)
                local newT = safeLerp(newSurf, b2, 0.06)
                if oldT and newT then map[oldT] = newT end
            end
        end
    end)

    local function colorDist(a,b)
        local dr = a.r - b.r
        local dg = a.g - b.g
        local db = a.b - b.b
        return dr*dr + dg*dg + db*db
    end

    local function findMapped(col)
        if not col or typeof(col) ~= "Color3" then return nil end
        for old,new in pairs(map) do if old == col then return new end end
        local best, bestd = nil, 1e9
        for old,new in pairs(map) do
            local d = colorDist(old, col)
            if d < bestd then bestd = d; best = new end
        end
        if best and bestd < 0.006 then 
            return best
        end
        return nil
    end

    if gui and gui.Parent then
        pcall(function()
            for _,obj in ipairs(gui:GetDescendants()) do
                if obj:IsA("GuiObject") then
                    pcall(function()
                        local ok, bg = pcall(function() return obj.BackgroundColor3 end)
                        if ok and typeof(bg) == "Color3" then
                            local m = findMapped(bg)
                            if m then obj.BackgroundColor3 = m end
                        end
                    end)
                    pcall(function()
                        local ok2, tx = pcall(function() return obj.TextColor3 end)
                        if ok2 and typeof(tx) == "Color3" then
                            local m2 = findMapped(tx)
                            if m2 then obj.TextColor3 = m2 end
                        end
                    end)
                end
                if obj:IsA("UIStroke") then
                    pcall(function()
                        local ok3, c = pcall(function() return obj.Color end)
                        if ok3 and typeof(c) == "Color3" then
                            local m3 = findMapped(c)
                            if m3 then obj.Color = m3 end
                        end
                    end)
                end
            end
            if root and root:IsA("GuiObject") then root.BackgroundColor3 = COLORS.bg end
            if tabsUnderlay and tabsUnderlay:IsA("GuiObject") then tabsUnderlay.BackgroundColor3 = COLORS.panel end
            if tabsBar and tabsBar:IsA("GuiObject") then
                for _,c in ipairs(tabsBar:GetChildren()) do
                    if c:IsA("TextButton") then c.BackgroundColor3 = COLORS.bg; c.TextColor3 = COLORS.tabText end
                end
            end
            if closeBtn and closeBtn:IsA("GuiObject") then closeBtn.TextColor3 = COLORS.close end
        end)
    end

    pcall(function()
        for k,api in pairs(ToggleAPI) do
            if type(api) == "table" and type(api.Get) == "function" and type(api.Set) == "function" then
                local prevOn = api.OnToggle
                api.OnToggle = nil
                pcall(api.Set, api.Get())
                api.OnToggle = prevOn
            end
        end
        for k,api in pairs(SliderAPI) do
            if type(api) == "table" and type(api.Get) == "function" and type(api.Set) == "function" then
                local prevOn = api.OnChange
                api.OnChange = nil
                pcall(api.Set, api.Get())
                api.OnChange = prevOn
            end
        end
        for k,api in pairs(ColorPickerAPI) do
            if type(api) == "table" and type(api.Get) == "function" and type(api.Set) == "function" then
                local prevOn = api.OnChange
                api.OnChange = nil
                pcall(api.Set, api.Get())
                api.OnChange = prevOn
            end
        end
        for k,api in pairs(DropdownAPI) do
            if type(api) == "table" and type(api.Get) == "function" and type(api.Set) == "function" then
                local sel = api.Get()
                if type(sel) == "table" and sel.index then pcall(api.Set, sel.index) end
            end
        end
    end)
end

-- ** Themed Registry ** --

local THEME_REGISTRY = {}
local TAB_WARNING_HANDLERS = {}

local function snapshotColors(obj)
    local t = {}
    pcall(function()
        if obj:IsA("GuiObject") then
            if obj.BackgroundColor3 ~= nil then t.bg = obj.BackgroundColor3 end
            if obj.TextColor3 ~= nil then t.text = obj.TextColor3 end
        end
        for _,c in ipairs(obj:GetChildren()) do
            if c:IsA("UIStroke") then
                t.stroke = t.stroke or {}
                table.insert(t.stroke, c.Color)
            end
        end
    end)
    return t
end

local function RegisterThemed(obj, refreshFn)
    if not obj or typeof(obj) ~= "Instance" then return end
    local entry = { obj = obj, snapshot = snapshotColors(obj), refresh = (type(refreshFn) == "function") and refreshFn or nil }
    table.insert(THEME_REGISTRY, entry)
    return entry
end

local function RefreshRegisteredThemed()
    if #THEME_REGISTRY == 0 then return end
    pcall(function()
        local prev = LAST_THEME or {}
        local cur = COLORS or {}
        local map = {}
        for k,v in pairs(prev) do if cur[k] then map[v] = cur[k] end end

        local function safeLerp(a,b,t)
            if typeof(a) ~= "Color3" or typeof(b) ~= "Color3" then return nil end
            return a:Lerp(b, t)
        end
        pcall(function()
            local a1 = safeLerp(prev.panel or prev.bg, prev.text, 0.18)
            local b1 = safeLerp(cur.panel or cur.bg, cur.text, 0.18)
            if a1 and b1 then map[a1] = b1 end
            local a2 = safeLerp(prev.accent or prev.text, prev.white or Color3.new(1,1,1), 0.18)
            local b2 = safeLerp(cur.accent or cur.text, cur.white or Color3.new(1,1,1), 0.18)
            if a2 and b2 then map[a2] = b2 end
            local a3 = safeLerp(prev.panel or prev.bg, prev.text, 0.14)
            local b3 = safeLerp(cur.panel or cur.bg, cur.text, 0.14)
            if a3 and b3 then map[a3] = b3 end
            for i=1,3 do
                local oldSurf = (prev.bg or prev.panel or prev.panelAlt)
                local newSurf = (cur.bg or cur.panel or cur.panelAlt)
                if oldSurf and newSurf and a2 and b2 then
                    local oldT = safeLerp(oldSurf, a2, 0.06)
                    local newT = safeLerp(newSurf, b2, 0.06)
                    if oldT and newT then map[oldT] = newT end
                end
            end
        end)

        local function colorDist(a,b)
            local dr = a.r - b.r
            local dg = a.g - b.g
            local db = a.b - b.b
            return dr*dr + dg*dg + db*db
        end

        local function findMapped(col)
            if not col or typeof(col) ~= "Color3" then return nil end
            for old,new in pairs(map) do if old == col then return new end end
            local best, bestd = nil, 1e9
            for old,new in pairs(map) do
                local d = colorDist(old, col)
                if d < bestd then bestd = d; best = new end
            end
            if best and bestd < 0.006 then return best end
            local nearest, nd = nil, 1e9
            for k,v in pairs(cur) do
                local d = colorDist(v, col)
                if d < nd then nd = d; nearest = v end
            end
            if nearest then return nearest end
            return nil
        end

        for _,e in ipairs(THEME_REGISTRY) do
            local o = e.obj
            local s = e.snapshot
            if o and o.Parent then
                pcall(function()
                    if s.bg and pcall(function() return o.BackgroundColor3 end) then
                        local m = findMapped(s.bg)
                        if m then o.BackgroundColor3 = m end
                    end
                    if s.text and pcall(function() return o.TextColor3 end) then
                        local m = findMapped(s.text)
                        if m then o.TextColor3 = m end
                    end
                    if pcall(function() return o.ImageColor3 end) then
                        local ok, curVal = pcall(function() return o.ImageColor3 end)
                        if ok and typeof(curVal) == "Color3" then
                            local m = findMapped(curVal)
                            if m then o.ImageColor3 = m end
                        end
                    end
                    if pcall(function() return o.BorderColor3 end) then
                        local ok2, curVal2 = pcall(function() return o.BorderColor3 end)
                        if ok2 and typeof(curVal2) == "Color3" then
                            local m2 = findMapped(curVal2)
                            if m2 then o.BorderColor3 = m2 end
                        end
                    end
                end)

                if s.stroke and #s.stroke > 0 then
                    local strokes = {}
                    for _,c in ipairs(o:GetChildren()) do if c:IsA("UIStroke") then table.insert(strokes, c) end end
                    for i,old in ipairs(s.stroke) do
                        local target = strokes[i]
                        if target and typeof(old) == "Color3" then
                            local m = findMapped(old)
                            if m then pcall(function() target.Color = m end) end
                        end
                    end
                end
                if type(e.refresh) == "function" then
                    pcall(e.refresh)
                end
            end
        end
    end)
end

do
    local _orig = ApplyTheme
    ApplyTheme = function(name)
        _orig(name)
        pcall(RefreshRegisteredThemed)
        pcall(function()
            for k,api in pairs(ToggleAPI) do if type(api) == "table" and api.Set and api.Get then local on = api.OnToggle; api.OnToggle = nil; pcall(api.Set, api.Get()); api.OnToggle = on end end
            for k,api in pairs(SliderAPI) do if type(api) == "table" and api.Set and api.Get then local on = api.OnChange; api.OnChange = nil; pcall(api.Set, api.Get()); api.OnChange = on end end
            for k,api in pairs(ColorPickerAPI) do if type(api) == "table" and api.Set and api.Get then local on = api.OnChange; api.OnChange = nil; pcall(api.Set, api.Get()); api.OnChange = on end end
        end)
    end
end


-----------------------------------------------------------------------------
local player = Players.LocalPlayer
local FIRST_TAB = nil -- ** select first tab
local gui = Instance.new("ScreenGui")
gui.Name = "VOZEX_HUB"
gui.ResetOnSpawn = false


local ok = pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not ok then
    if player then
        gui.Parent = player:WaitForChild("PlayerGui")
    else
        gui.Parent = game:GetService("CoreGui")
    end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- ** Helper functions start here


-- ** makeTab (Responsive for Mobile)
local function makeTab(name, tabsParent, pagesParent, onSelect, colHeaders, warningText)
    local btn = Instance.new("TextButton")
    local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 8) corner.Parent = btn
    btn.Name = name .. "Tab"
    btn.Size = UDim2.new(1, -12, 0, 40) -- Increased height for touch
    btn.AutoButtonColor = false
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.Text = name
    btn.BackgroundColor3 = COLORS.panel
    btn.TextColor3 = COLORS.tabText
    btn.BorderSizePixel = 0
    btn.TextXAlignment = Enum.TextXAlignment.Center
    btn.ZIndex = 10
    btn:SetAttribute("TabActive", false)
    btn.ClipsDescendants = true

    -- ** active tab indicator
    local indicator = Instance.new("Frame")
    indicator.Name = "ActiveIndicator"
    indicator.Size = UDim2.new(0.6, 0, 0, 3)
    indicator.Position = UDim2.new(0.2, 0, 1, -4)
    indicator.BackgroundColor3 = COLORS.accent
    indicator.BackgroundTransparency = 1
    indicator.ZIndex = btn.ZIndex - 1
    local indCorner = Instance.new("UICorner") indCorner.CornerRadius = UDim.new(1, 0) indCorner.Parent = indicator
    indicator.Parent = btn

    local page = Instance.new("Frame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1,0,1,0)
    page.BackgroundTransparency = 1
    local pageLayout = Instance.new("UIListLayout") pageLayout.Parent = page
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 0)
    local pagePad = Instance.new("UIPadding") pagePad.Parent = page
    pagePad.PaddingLeft = UDim.new(0, 4)
    pagePad.PaddingRight = UDim.new(0, 4)
    pagePad.PaddingTop = UDim.new(0, 4)
    pagePad.PaddingBottom = UDim.new(0, 4)

    if tabsParent then btn.Parent = tabsParent end
    RegisterThemed(btn, function()
        pcall(function()
            local ind = btn:FindFirstChild("ActiveIndicator")
            local isActive = btn:GetAttribute("TabActive") == true
            if isActive then
                btn.TextColor3 = COLORS.white
                btn.BackgroundColor3 = COLORS.accent
                btn.BackgroundTransparency = 0.15
                if ind then ind.BackgroundColor3 = COLORS.white end
                if ind then ind.BackgroundTransparency = 0 end
            else
                btn.TextColor3 = COLORS.tabText
                btn.BackgroundColor3 = COLORS.panel
                btn.BackgroundTransparency = 0.7
                if ind then ind.BackgroundColor3 = COLORS.accent end
                if ind then ind.BackgroundTransparency = 1 end
            end
        end)
    end)
    if pagesParent then page.Parent = pagesParent end
    RegisterThemed(page, function()
        pcall(function()
            if page and page:IsA("GuiObject") then
                page.BackgroundTransparency = 1
            end
        end)
    end)


------------------------------------------------------------------------
-- ** Warning Modal **

    local warningOverlay = nil
    local function showWarning()
        if not warningText or type(warningText) ~= "string" then return end
        if warningOverlay and warningOverlay.Parent then
            warningOverlay.Visible = true
            return
        end
        warningOverlay = Instance.new("Frame")
        warningOverlay.Name = "TabWarningBackdrop"
        warningOverlay.BackgroundColor3 = COLORS.panelAlt or Color3.fromRGB(10,10,10)
        warningOverlay.BackgroundTransparency = 0.6
        warningOverlay.BorderSizePixel = 0
        warningOverlay.ZIndex = 10000
        local pageAbsX = page.AbsolutePosition.X
        local pageAbsY = page.AbsolutePosition.Y
        local pageAbsW = page.AbsoluteSize.X
        local pageAbsH = page.AbsoluteSize.Y
        warningOverlay.Position = UDim2.new(0, pageAbsX, 0, pageAbsY)
        warningOverlay.Size = UDim2.new(0, pageAbsW, 0, pageAbsH)
        warningOverlay.Parent = gui

        local modal = Instance.new("Frame")
        modal.Name = "TabWarningModal"
        modal.Size = UDim2.new(0.9, 0, 0.86, 0)
        modal.Position = UDim2.new(0.5, 0, 0, 8)
        modal.AnchorPoint = Vector2.new(0.5, 0)
        modal.BackgroundColor3 = COLORS.panel
        modal.BorderSizePixel = 0
        modal.ZIndex = warningOverlay.ZIndex + 1
        modal.Parent = warningOverlay
        local modalCorner = Instance.new("UICorner") modalCorner.CornerRadius = UDim.new(0, 12) modalCorner.Parent = modal
        local modalStroke = Instance.new("UIStroke") modalStroke.Color = COLORS.divider modalStroke.Thickness = 1 modalStroke.Parent = modal
        RegisterThemed(modal)

        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.Size = UDim2.new(1, -36, 0, 40)
        title.Position = UDim2.new(0, 18, 0, 12)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamBold
        title.TextSize = 20
        title.Text = "Warning"
        title.TextColor3 = COLORS.accent
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = modal.ZIndex + 1
        title.Parent = modal
        RegisterThemed(title)

        local msg = Instance.new("TextLabel")
        msg.Name = "Message"
        msg.Size = UDim2.new(1, -36, 1, -120)
        msg.Position = UDim2.new(0, 18, 0, 64)
        msg.BackgroundTransparency = 1
        msg.Font = Enum.Font.Gotham
        msg.TextSize = 16
        msg.TextColor3 = COLORS.text
        msg.TextWrapped = true
        msg.Text = warningText
        msg.TextXAlignment = Enum.TextXAlignment.Center
        msg.TextYAlignment = Enum.TextYAlignment.Center
        msg.ZIndex = modal.ZIndex + 1
        msg.Parent = modal
        RegisterThemed(msg)

        local actionBtn = Instance.new("TextButton")
        actionBtn.Name = "CloseBtn"
        actionBtn.Size = UDim2.new(0, 160, 0, 40)
        actionBtn.Position = UDim2.new(0.5, 0, 1, -56)
        actionBtn.AnchorPoint = Vector2.new(0.5, 0.5)
        actionBtn.BackgroundColor3 = COLORS.accent
        actionBtn.Font = Enum.Font.GothamBold
        actionBtn.TextSize = 16
        actionBtn.TextColor3 = COLORS.white
        actionBtn.Text = "Okay"
        actionBtn.ZIndex = modal.ZIndex + 2
        actionBtn.Parent = modal
        local actionCorner = Instance.new("UICorner") actionCorner.CornerRadius = UDim.new(0, 8) actionCorner.Parent = actionBtn
        RegisterThemed(actionBtn)

        actionBtn.MouseButton1Click:Connect(function()
            if warningOverlay and warningOverlay.Parent then warningOverlay:Destroy() end
        end)
    end

    TAB_WARNING_HANDLERS[page] = showWarning

    btn.MouseButton1Click:Connect(function()
        local mousePos = UserInputService:GetMouseLocation()
        local lx = math.clamp(mousePos.X - btn.AbsolutePosition.X, 0, btn.AbsoluteSize.X)
        local ly = math.clamp(mousePos.Y - btn.AbsolutePosition.Y, 0, btn.AbsoluteSize.Y)
        local ripple = Instance.new("Frame")
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.Position = UDim2.new(0, lx, 0, ly)
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.BackgroundColor3 = (COLORS.accent or COLORS.text):Lerp(COLORS.white or Color3.new(1,1,1), 0.22)
        ripple.BackgroundTransparency = 0.6
        ripple.BorderSizePixel = 0
        ripple.ZIndex = btn.ZIndex + 5
        local rc = Instance.new("UICorner") rc.CornerRadius = UDim.new(1, 0) rc.Parent = ripple
        ripple.Parent = btn
        local maxDim = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y)
        local final = UDim2.new(0, maxDim * 2, 0, maxDim * 2)
        local tw = TweenService:Create(ripple, TweenInfo.new(0.42, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = final, BackgroundTransparency = 1})
        tw:Play()
        tw.Completed:Connect(function()
            if ripple and ripple.Parent then ripple:Destroy() end
        end)
        if type(onSelect) == "function" then pcall(onSelect, btn, page) end
        showWarning()
    end)

    if page and page:IsA("GuiObject") then
        page:GetPropertyChangedSignal("Visible"):Connect(function()
            if page.Visible then
                showWarning()
            end
        end)
    end

    btn.MouseEnter:Connect(function()
        local isActive = btn:GetAttribute("TabActive") == true
        local targetBg = isActive and COLORS.accentHover or COLORS.panelAlt
        local targetText = isActive and COLORS.white or COLORS.tabText
        pcall(function() TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = targetBg, TextColor3 = targetText}):Play() end)
    end)
    btn.MouseLeave:Connect(function()
        local isActive = btn:GetAttribute("TabActive") == true
        local targetBg = isActive and COLORS.accent or COLORS.panel
        local targetText = isActive and COLORS.white or COLORS.tabText
        pcall(function() TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = targetBg, TextColor3 = targetText}):Play() end)
    end)

---------------------------------------------------------------------------------

-- ** Col Stuff (Responsive - No fixed columns on mobile)

    local leftCol = Instance.new("Frame")
    leftCol.Name = "LeftCol"
    leftCol.Size = UDim2.new(1, 0, 0, 0)
    leftCol.BackgroundTransparency = 1
    leftCol.Parent = page
    leftCol.AutomaticSize = Enum.AutomaticSize.Y
    leftCol.LayoutOrder = 0
    RegisterThemed(leftCol)
    leftCol.ClipsDescendants = false
    local list = Instance.new("UIListLayout") list.Parent = leftCol
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 8)
    local leftPad = Instance.new("UIPadding") leftPad.Parent = leftCol
    leftPad.PaddingLeft = UDim.new(0, 10)
    leftPad.PaddingRight = UDim.new(0, 10)
    leftPad.PaddingTop = UDim.new(0, 8)
    leftPad.PaddingBottom = UDim.new(0, 8)

    if colHeaders and colHeaders.Left then
        local hdr = Instance.new("TextLabel")
        hdr.Name = "Header"
        hdr.Size = UDim2.new(1, 0, 0, 24)
        hdr.BackgroundTransparency = 1
        hdr.Font = Enum.Font.GothamBold
        hdr.TextSize = 15
        hdr.Text = tostring(colHeaders.Left)
        hdr.TextColor3 = COLORS.accent
        hdr.TextXAlignment = Enum.TextXAlignment.Left
        hdr.LayoutOrder = 0
        hdr.Parent = leftCol
        RegisterThemed(hdr)
    end


    local rightCol = Instance.new("Frame")
    rightCol.Name = "RightCol"
    rightCol.Size = UDim2.new(1, 0, 0, 0)
    rightCol.BackgroundTransparency = 1
    rightCol.Parent = page
    rightCol.AutomaticSize = Enum.AutomaticSize.Y
    rightCol.LayoutOrder = 2
    RegisterThemed(rightCol)
    rightCol.ClipsDescendants = false
    local list2 = Instance.new("UIListLayout") list2.Parent = rightCol
    list2.SortOrder = Enum.SortOrder.LayoutOrder
    list2.Padding = UDim.new(0, 8)
    local rightPad = Instance.new("UIPadding") rightPad.Parent = rightCol
    rightPad.PaddingLeft = UDim.new(0, 10)
    rightPad.PaddingRight = UDim.new(0, 10)
    rightPad.PaddingTop = UDim.new(0, 8)
    rightPad.PaddingBottom = UDim.new(0, 8)

    if colHeaders and colHeaders.Right then
        local hdrr = Instance.new("TextLabel")
        hdrr.Name = "Header"
        hdrr.Size = UDim2.new(1, 0, 0, 24)
        hdrr.BackgroundTransparency = 1
        hdrr.Font = Enum.Font.GothamBold
        hdrr.TextSize = 15
        hdrr.Text = tostring(colHeaders.Right)
        hdrr.TextColor3 = COLORS.accent
        hdrr.TextXAlignment = Enum.TextXAlignment.Left
        hdrr.LayoutOrder = 1
        hdrr.Parent = rightCol
        RegisterThemed(hdrr)
    end

    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.Size = UDim2.new(1, 0, 0, 1)
    divider.BackgroundColor3 = COLORS.divider
    divider.Parent = page
    divider.BorderSizePixel = 0
    divider.LayoutOrder = 1
    RegisterThemed(divider)
    divider.AnchorPoint = Vector2.new(0, 0.5)
    RegisterThemed(divider)

    local tab = {
        button = btn,
        page = page,
        LeftCol = leftCol,
        RightCol = rightCol,
        MakeCol = function(colName, size, pos, headerText)
            local col = Instance.new("Frame")
            col.Name = colName or "Col"
            col.Size = size or UDim2.new(1, -12, 0, 0) -- Full width for mobile
            col.Position = pos or UDim2.new(0, 6, 0, 6)
            col.BackgroundColor3 = COLORS.panel
            col.BackgroundTransparency = 0.85
            col.Parent = page
            col.ClipsDescendants = true
            col.AutomaticSize = Enum.AutomaticSize.Y
            local colCorner = Instance.new("UICorner") colCorner.CornerRadius = UDim.new(0, 10) colCorner.Parent = col
            local colStroke = Instance.new("UIStroke") colStroke.Color = COLORS.divider colStroke.Thickness = 1 colStroke.Transparency = 0.5 colStroke.Parent = col
            local l = Instance.new("UIListLayout") l.Parent = col
            l.SortOrder = Enum.SortOrder.LayoutOrder
            if headerText then
                local h = Instance.new("TextLabel")
                h.Name = "Header"
                h.Size = UDim2.new(1, -12, 0, 24)
                h.Position = UDim2.new(0, 6, 0, 6)
                h.BackgroundTransparency = 1
                h.Font = Enum.Font.GothamBold
                h.TextSize = 16
                h.Text = tostring(headerText)
                h.TextColor3 = COLORS.textDim
                h.TextXAlignment = Enum.TextXAlignment.Left
                h.LayoutOrder = 0
                h.Parent = col
            end
            return col
        end,
    }

    pcall(function()
        if FIRST_TAB == nil then
            FIRST_TAB = { button = btn, page = page }
        end
    end)

    return tab
end
---------------------------------------------------------------------------

-- ** makeToggle (Responsive)**
local function makeToggle(parent, labelText, tooltipText)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 44) -- Increased height for touch
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, -6, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText or "Toggle"
    label.Font = Enum.Font.GothamBold
    label.TextSize = 17
    label.TextColor3 = COLORS.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    RegisterThemed(label)

    local tooltip = nil
    local tooltipShowTimer = nil
    if tooltipText and type(tooltipText) == "string" then
        tooltip = Instance.new("TextLabel")
        tooltip.Name = "Tooltip"
        tooltip.Text = tooltipText
        tooltip.Font = Enum.Font.Gotham
        tooltip.TextSize = 13
        tooltip.TextColor3 = COLORS.text
        tooltip.TextWrapped = true
        tooltip.BackgroundColor3 = COLORS.panelDark
        tooltip.BorderSizePixel = 0
        tooltip.AnchorPoint = Vector2.new(0.5, 0)
        tooltip.BackgroundTransparency = 1
        tooltip.TextTransparency = 1
        tooltip.Visible = false
        tooltip.ZIndex = 10000
        tooltip.Parent = frame
        local tooltipCorner = Instance.new("UICorner")
        tooltipCorner.CornerRadius = UDim.new(0, 6)
        tooltipCorner.Parent = tooltip
        local tooltipPad = Instance.new("UIPadding")
        tooltipPad.PaddingLeft = UDim.new(0, 8)
        tooltipPad.PaddingRight = UDim.new(0, 8)
        tooltipPad.PaddingTop = UDim.new(0, 6)
        tooltipPad.PaddingBottom = UDim.new(0, 6)
        tooltipPad.Parent = tooltip
        local tooltipStroke = Instance.new("UIStroke")
        tooltipStroke.Color = COLORS.divider
        tooltipStroke.Thickness = 1
        tooltipStroke.Parent = tooltip
        RegisterThemed(tooltip)
    end

    local surfaceColor = COLORS.panel or COLORS.bg or COLORS.panelAlt
    local bgColor = COLORS.bg or COLORS.panel or surfaceColor
    local lightStroke = (COLORS.panel or COLORS.bg):Lerp(COLORS.text, 0.18)

    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 60, 0, 30) -- Larger for touch
    toggle.AnchorPoint = Vector2.new(1, 0.5)
    toggle.Position = UDim2.new(1, -8, 0.5, 0)
    toggle.BackgroundColor3 = surfaceColor
    toggle.BackgroundTransparency = 0.7
    toggle.ClipsDescendants = true
    toggle.Parent = frame
    RegisterThemed(toggle)

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 15)
    toggleCorner.Parent = toggle

    local toggleStroke = Instance.new("UIStroke")
    toggleStroke.Thickness = 1
    toggleStroke.Color = lightStroke
    toggleStroke.Transparency = 0.85
    toggleStroke.Parent = toggle

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.Position = UDim2.new(0, 0, 0, 0)
    local accentVisible = (COLORS.accent or COLORS.text):Lerp(COLORS.white or Color3.new(1,1,1), 0.18)
    fill.BackgroundColor3 = accentVisible
    fill.BackgroundTransparency = 1
    fill.Parent = toggle
    RegisterThemed(fill)
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 15)
    fillCorner.Parent = fill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 24, 0, 24) -- Larger for touch
    knob.AnchorPoint = Vector2.new(0, 0.5)
    knob.Position = UDim2.new(0, 4, 0.5, 0)
    knob.BackgroundColor3 = COLORS.white or Color3.new(1,1,1)
    knob.ZIndex = 2
    knob.Parent = toggle
    RegisterThemed(knob)
    local kCorner = Instance.new("UICorner")
    kCorner.CornerRadius = UDim.new(0, 12)
    kCorner.Parent = knob

    RegisterThemed(frame, function()
        pcall(function()
            local api = ToggleAPI[frame]
            local curState = api and api.Get and api.Get() or state
            local surfaceColor = COLORS.panel or COLORS.bg or COLORS.panelAlt
            local bgColor = COLORS.bg or COLORS.panel or surfaceColor
            local lightStroke = (COLORS.panel or COLORS.bg):Lerp(COLORS.text, 0.18)
            local accentVisible = (COLORS.accent or COLORS.text):Lerp(COLORS.white or Color3.new(1,1,1), 0.18)
            if label then label.TextColor3 = COLORS.text end
            if fill then fill.BackgroundColor3 = accentVisible end
            if knob then knob.BackgroundColor3 = COLORS.white or Color3.new(1,1,1) end
            if toggleStroke then toggleStroke.Color = curState and accentVisible or lightStroke end
            if curState then
                if fill then fill.Size = UDim2.new(1,0,1,0); fill.BackgroundTransparency = 0.35 end
                if knob then knob.Position = UDim2.new(1, -28, 0.5, 0) end
            else
                if fill then fill.Size = UDim2.new(0,0,1,0); fill.BackgroundTransparency = 1 end
                if knob then knob.Position = UDim2.new(0,4,0.5,0) end
            end
        end)
    end)

    local state = false
    local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    local function setVisual(on)
        state = not not on

        if state then
            TweenService:Create(fill, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0.35}):Play()
            local targetBg = surfaceColor:Lerp(accentVisible, 0.08)
            TweenService:Create(toggle, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = targetBg}):Play()
            TweenService:Create(knob, TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -28, 0.5, 0)}):Play()
            toggleStroke.Color = accentVisible
        else
            TweenService:Create(fill, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 1, 0), BackgroundTransparency = 1}):Play()
            TweenService:Create(toggle, tweenInfo, {BackgroundColor3 = surfaceColor}):Play()
            TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 4, 0.5, 0)}):Play()
            toggleStroke.Color = lightStroke
        end

        local api = ToggleAPI[frame]
        if api and type(api.OnToggle) == "function" then
            pcall(api.OnToggle, state)
        end
    end

    ToggleAPI[frame] = {
        Set = function(v) setVisual(v) end,
        Get = function() return state end,
        OnToggle = nil,
    }

    toggle.MouseEnter:Connect(function()
        TweenService:Create(knob, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 26, 0, 26)}):Play()
        
        if tooltip then
            tooltipShowTimer = tick()
            delay(0.5, function()
                if tooltipShowTimer and (tick() - tooltipShowTimer) >= 0.5 and tooltip and tooltip.Parent then
                    tooltip.Visible = true
                    tooltip.Size = UDim2.new(0, 200, 0, 50)
                    tooltip.AnchorPoint = Vector2.new(0.5, 0)
                    tooltip.Position = UDim2.new(0.5, 0, 0.8, 0)
                    tooltip.BackgroundTransparency = 1
                    tooltip.TextTransparency = 1
                    TweenService:Create(tooltip, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.1}):Play()
                    TweenService:Create(tooltip, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
                end
            end)
        end
    end)
    toggle.MouseLeave:Connect(function()
        TweenService:Create(knob, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 24, 0, 24)}):Play()
        
        if tooltip then
            tooltipShowTimer = nil
            TweenService:Create(tooltip, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
            TweenService:Create(tooltip, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
            delay(0.14, function()
                if tooltip and tooltip.Parent then tooltip.Visible = false end
            end)
        end
    end)

    toggle.Active = true
    toggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            setVisual(not state)
            local s = (state and 1.03) or 0.97
            TweenService:Create(knob, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 24 * s, 0, 24 * s)}):Play()
            delay(0.07, function()
                pcall(function()
                    TweenService:Create(knob, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 24, 0, 24)}):Play()
                end)
            end)
        end
    end)

    local maxOrder = 0
    for _,c in ipairs(parent:GetChildren()) do
        if c ~= frame and (c:IsA("Frame") or c:IsA("TextLabel")) then
            maxOrder = math.max(maxOrder, c.LayoutOrder or 0)
        end
    end
    frame.LayoutOrder = maxOrder + 1

    setVisual(false)
    return frame
end

--------------------------------------------------------------------------

-- ** makeNotification (unchanged)**
local function makeNotification(text, duration, parent, invoker)
    local dur = (type(duration) == "number" and duration > 0) and duration or 3
    local okCheck, allowed = pcall(function()
        if type(NotificationAPI) == "table" and type(NotificationAPI.CanCreate) == "function" then
            return NotificationAPI.CanCreate(invoker)
        end
        return true
    end)
    if not okCheck or not allowed then return nil end
    local parentGui
    do
        local Players = game:GetService("Players")
        local CoreGui = game:GetService("CoreGui")
        local lp = Players and Players.LocalPlayer
        if parent and parent ~= gui then
            parentGui = parent
        else
            parentGui = CoreGui:FindFirstChild("Vozex_Notifications")
            if not parentGui then
                local created = Instance.new("ScreenGui")
                created.Name = "Vozex_Notifications"
                created.ResetOnSpawn = false
                created.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                local ok = pcall(function() created.Parent = CoreGui end)
                if not ok then
                    if lp and lp:FindFirstChild("PlayerGui") then
                        created.Parent = lp:WaitForChild("PlayerGui")
                    else
                        pcall(function() created.Parent = CoreGui end)
                    end
                end
                pcall(function() created.DisplayOrder = 1000 end)
                parentGui = created
            end
        end
    end

    if NOTIFICATIONS_ENABLED == false then return nil end
    if type(NotificationAPI) == "table" and type(NotificationAPI.CanCreate) == "function" then
        if not NotificationAPI.CanCreate(invoker) then return nil end
    end

    local holder = parentGui:FindFirstChild("VozexNotificationsHolder")
    if not holder then
        holder = Instance.new("Frame")
        holder.Name = "VozexNotificationsHolder"
        holder.Size = UDim2.new(0, 420, 0, 200)
        holder.AnchorPoint = Vector2.new(1, 1)
        holder.Position = UDim2.new(1, -12, 1, -12)
        holder.BackgroundTransparency = 1
        holder.ZIndex = 10000
        holder.Parent = parentGui
        local layout = Instance.new("UIListLayout")
        layout.Name = "VozexNotificationsLayout"
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 8)
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        layout.Parent = holder
        local pad = Instance.new("UIPadding") pad.Parent = holder
        pad.PaddingRight = UDim.new(0, 0)
        pad.PaddingBottom = UDim.new(0, 0)
    end

    local TextService = game:GetService("TextService")
    local msgStr = tostring(text or "Notification")
    local fontSize = 16
    local font = Enum.Font.GothamBold
    local screenW = 760
    pcall(function() if gui and gui.Parent and gui.AbsoluteSize and gui.AbsoluteSize.X then screenW = gui.AbsoluteSize.X end end)
    local maxAllowed = math.max(240, screenW - 24)
    local maxContentW = math.min(600, maxAllowed - 80)
    local measured = TextService:GetTextSize(msgStr, fontSize, font, Vector2.new(maxContentW, 10000))
    local _tmpW = math.ceil(measured.X + 80)
    local targetW = math.min(math.max(_tmpW, 240), maxAllowed)
    local targetH = math.max(56, math.ceil(measured.Y + 24))

    local container = Instance.new("Frame")
    container.Name = "VozexNotification"
    container.Size = UDim2.new(0, targetW, 0, targetH)
    container.BackgroundColor3 = COLORS.panelDark
    container.BorderSizePixel = 0
    container.ZIndex = holder.ZIndex
    container.LayoutOrder = math.floor(tick() * 1000)
    container.Parent = holder
    pcall(function()
        local hX = holder.Size.X.Offset or 420
        if targetW > hX then
            holder.Size = UDim2.new(0, targetW, holder.Size.Y.Scale, holder.Size.Y.Offset)
        end
    end)
    RegisterThemed(container)
    local cCorner = Instance.new("UICorner") cCorner.CornerRadius = UDim.new(0,10) cCorner.Parent = container
    local cStroke = Instance.new("UIStroke") cStroke.Color = COLORS.divider; cStroke.Thickness = 1; cStroke.Parent = container

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 6, 1, 0)
    accent.Position = UDim2.new(0, 0, 0, 0)
    accent.BackgroundColor3 = COLORS.accent
    accent.BorderSizePixel = 0
    accent.ZIndex = container.ZIndex + 2
    accent.Parent = container
    local aCorner = Instance.new("UICorner") aCorner.CornerRadius = UDim.new(0,4) aCorner.Parent = accent
    RegisterThemed(accent)

    local inner = Instance.new("Frame")
    inner.Size = UDim2.new(1, -20, 1, -12)
    inner.Position = UDim2.new(0, 12, 0, 6)
    inner.BackgroundTransparency = 1
    inner.ZIndex = container.ZIndex + 1
    inner.Parent = container

    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 28, 0, 28)
    icon.Position = UDim2.new(0, 0, 0.5, -14)
    icon.BackgroundTransparency = 1
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 18
    icon.TextColor3 = COLORS.accent
    icon.Text = "🔔"
    icon.ZIndex = inner.ZIndex + 1
    icon.Parent = inner

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -36, 1, 0)
    label.Position = UDim2.new(0, 36, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = font
    label.TextSize = fontSize
    label.Text = msgStr
    label.TextColor3 = COLORS.text
    label.TextStrokeTransparency = 0.7
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextWrapped = true
    label.ZIndex = inner.ZIndex + 1
    label.Parent = inner

    local barHolder = Instance.new("Frame")
    barHolder.Size = UDim2.new(1, -20, 0, 6)
    barHolder.Position = UDim2.new(0, 10, 1, -10)
    barHolder.BackgroundTransparency = 1
    barHolder.ZIndex = container.ZIndex + 1
    barHolder.Parent = container

    local prog = Instance.new("Frame")
    prog.AnchorPoint = Vector2.new(1, 0)
    prog.Position = UDim2.new(1, 0, 0, 0)
    prog.Size = UDim2.new(1, 0, 1, 0)
    prog.BackgroundColor3 = COLORS.accent
    prog.BorderSizePixel = 0
    prog.ZIndex = container.ZIndex + 2
    prog.Parent = barHolder
    local progCorner = Instance.new("UICorner") progCorner.CornerRadius = UDim.new(0,3) progCorner.Parent = prog

    pcall(function()
        container.Size = UDim2.new(0, targetW, 0, 0)
        container.Position = container.Position
        TweenService:Create(container, TweenInfo.new(0.34, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(0, targetW, 0, targetH)}):Play()
        label.TextTransparency = 1
        icon.TextTransparency = 1
        TweenService:Create(label, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
        TweenService:Create(icon, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
    end)

    local progTween = TweenService:Create(prog, TweenInfo.new(dur, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)})
    progTween:Play()

    task.delay(dur, function()
        pcall(function()
            TweenService:Create(label, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
            TweenService:Create(icon, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
            TweenService:Create(container, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 420, 0, 0)}):Play()
        end)
        task.delay(0.32, function()
            pcall(function() container:Destroy() end)
        end)
    end)

    return container
end


spawn(function()
    for i=1,60 do
        local api = ToggleAPI[enableNotificationsToggle]
        if api then
            local prev = api.OnToggle
            api.OnToggle = function(state)
                if prev then pcall(prev, state) end
                if not state then
                    pcall(function()
                        local CoreGui = game:GetService("CoreGui")
                        local Players = game:GetService("Players")
                        local root = CoreGui:FindFirstChild("Vozex_Notifications")
                        if not root and Players and Players.LocalPlayer then
                            local pg = Players.LocalPlayer:FindFirstChild("PlayerGui")
                            if pg then root = pg:FindFirstChild("Vozex_Notifications") end
                        end
                        if root then
                            local holder = root:FindFirstChild("VozexNotificationsHolder")
                            if holder then holder:Destroy() end
                        end
                    end)
                end
            end
            break
        end
        task.wait(0.1)
    end
end)

--------------------------------------------------------------------------

-- ** makeButton (Responsive)**
local function makeButton(parent, labelText)
    local frame = Instance.new("Frame")
    frame.Name = tostring(labelText or "Button")
    frame.Size = UDim2.new(1, 0, 0, 44)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, -6, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText or "Button"
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextColor3 = COLORS.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 36)
    btn.AnchorPoint = Vector2.new(1,0.5)
    btn.Position = UDim2.new(1, -8, 0.5, 0)
    btn.BackgroundColor3 = COLORS.panelDark
    btn.AutoButtonColor = true
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextColor3 = COLORS.text
    btn.Text = "Click"
    btn.Parent = frame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0,6)
    btnCorner.Parent = btn

    if type(ButtonAPI) ~= "table" then
        ButtonAPI = setmetatable({}, { __mode = "k" })
    end
    ButtonAPI[frame] = {
        OnClick = nil,
        Click = function()
            local api = ButtonAPI[frame]
            if api and type(api.OnClick) == "function" then pcall(api.OnClick) end
        end,
    }

    btn.MouseButton1Click:Connect(function()
        local api = ButtonAPI[frame]
        if api and type(api.OnClick) == "function" then pcall(api.OnClick) end
    end)

    local maxOrder = 0
    for _,c in ipairs(parent:GetChildren()) do
        if c ~= frame and (c:IsA("Frame") or c:IsA("TextLabel") or c:IsA("TextButton")) then
            maxOrder = math.max(maxOrder, c.LayoutOrder or 0)
        end
    end
    frame.LayoutOrder = maxOrder + 1

    return frame
end

--------------------------------------------------------------------------

-- ** Collapsible group helper (Responsive)**
local TweenService = game:GetService("TweenService")
local function makeCollapsibleGroup(parent, title, defaultOpen, builderFn)
    local headerHeight = 44
    local extraWidth = 8 
    local extraX = -10 
    local grp = Instance.new("Frame")
    grp.Name = tostring(title or "Group")
    grp.BackgroundTransparency = 1
    grp.Size = UDim2.new(1, extraWidth, 0, headerHeight)
    grp.Position = UDim2.new(0, extraX, 0, 0)
    grp.Parent = parent

    local maxOrder = 0
    for _,c in ipairs(parent:GetChildren()) do
        if c ~= grp and (c:IsA("Frame") or c:IsA("TextLabel") or c:IsA("TextButton")) then
            maxOrder = math.max(maxOrder, c.LayoutOrder or 0)
        end
    end
    grp.LayoutOrder = maxOrder + 1

    local header = Instance.new("TextButton")
    header.Size = UDim2.new(1, 0, 0, headerHeight)
    header.Position = UDim2.new(0,0,0,0)
    header.BackgroundColor3 = COLORS.panelAlt or COLORS.panel
    header.AutoButtonColor = false
    header.Font = Enum.Font.GothamBold
    header.TextSize = 18
    header.Text = tostring(title or "Group")
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.TextColor3 = COLORS.text
    header.Parent = grp
    header.ZIndex = 50
    local hp = Instance.new("UIPadding") hp.Parent = header hp.PaddingLeft = UDim.new(0,12); hp.PaddingRight = UDim.new(0,28)
    local hcorner = Instance.new("UICorner") hcorner.CornerRadius = UDim.new(0,8) hcorner.Parent = header
    local hstroke = Instance.new("UIStroke") hstroke.Parent = header hstroke.Color = COLORS.divider hstroke.Thickness = 1 hstroke.Transparency = 0.5
    RegisterThemed(header)

    local caret = Instance.new("TextLabel")
    caret.Size = UDim2.new(0, 18, 0, 18)
    caret.AnchorPoint = Vector2.new(1, 0.5)
    caret.Position = UDim2.new(1, -12, 0.5, 0)
    caret.BackgroundTransparency = 1
    caret.Font = Enum.Font.Gotham
    caret.TextSize = 16    caret.Text = "▾"
    caret.TextColor3 = COLORS.textDim
    caret.ZIndex = header.ZIndex + 1
    caret.Parent = header
    RegisterThemed(caret)

    local bodyClip = Instance.new("Frame")
    bodyClip.Name = "BodyClip"
    bodyClip.BackgroundTransparency = 1
    bodyClip.Position = UDim2.new(0,0,0,headerHeight)
    bodyClip.Size = UDim2.new(1,0,0,0)
    bodyClip.ClipsDescendants = true
    bodyClip.Parent = grp

    local inner = Instance.new("Frame")
    inner.Name = "Inner"
    inner.BackgroundTransparency = 1
    inner.Size = UDim2.new(1,0,0,0)
    inner.AutomaticSize = Enum.AutomaticSize.Y
    inner.Parent = bodyClip

    local innerLayout = Instance.new("UIListLayout") innerLayout.Parent = inner
    innerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    innerLayout.Padding = UDim.new(0,6)
    local innerPad = Instance.new("UIPadding") innerPad.Parent = inner
    innerPad.PaddingLeft = UDim.new(0,4); innerPad.PaddingRight = UDim.new(0,4); innerPad.PaddingTop = UDim.new(0,8); innerPad.PaddingBottom = UDim.new(0,8)
    RegisterThemed(inner)

    if type(builderFn) == "function" then
        pcall(builderFn, inner)
    end

    local opened = not not defaultOpen
    local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    local function refreshSizes()
        local contentH = innerLayout.AbsoluteContentSize.Y
        bodyClip.ClipsDescendants = not opened
        if opened then
            grp.Size = UDim2.new(1, extraWidth, 0, headerHeight + contentH)
            bodyClip.Size = UDim2.new(1,0,0, contentH)
            caret.Text = "▾"
            caret.Rotation = 0
        else
            grp.Size = UDim2.new(1, extraWidth, 0, headerHeight)
            bodyClip.Size = UDim2.new(1,0,0,0)
            caret.Text = "▸"
            caret.Rotation = -90
        end
    end

    task.defer(refreshSizes)

    local function setOpen(open)
        opened = not not open
        bodyClip.ClipsDescendants = not opened
        local contentH = innerLayout.AbsoluteContentSize.Y
        if opened then
            TweenService:Create(grp, tweenInfo, {Size = UDim2.new(1, extraWidth, 0, headerHeight + contentH)}):Play()
            TweenService:Create(bodyClip, tweenInfo, {Size = UDim2.new(1,0,0, contentH)}):Play()
            TweenService:Create(caret, tweenInfo, {Rotation = 0}):Play()
            caret.Text = "▾"
        else
            TweenService:Create(grp, tweenInfo, {Size = UDim2.new(1, extraWidth, 0, headerHeight)}):Play()
            TweenService:Create(bodyClip, tweenInfo, {Size = UDim2.new(1,0,0,0)}):Play()
            TweenService:Create(caret, tweenInfo, {Rotation = -90}):Play()
            caret.Text = "▸"
        end
        if bottomDivider then
            if opened then
                pcall(function() TweenService:Create(bottomDivider, tweenInfo, {BackgroundTransparency = 0}):Play() end)
            else
                pcall(function() TweenService:Create(bottomDivider, tweenInfo, {BackgroundTransparency = 1}):Play() end)
            end
        end
    end

    header.MouseButton1Click:Connect(function()
        setOpen(not opened)
    end)

    local bottomDivider = Instance.new("Frame")
    bottomDivider.Name = "BottomDivider"
    bottomDivider.Size = UDim2.new(1, 0, 0, 1)
    bottomDivider.Position = UDim2.new(0, 0, 1, 6)
    bottomDivider.AnchorPoint = Vector2.new(0, 1)
    bottomDivider.BackgroundColor3 = COLORS.divider or (COLORS.panel or COLORS.bg)
    bottomDivider.BorderSizePixel = 0
    bottomDivider.ZIndex = 1
    bottomDivider.Parent = grp
    bottomDivider.BackgroundTransparency = (opened and 0 or 1)
    RegisterThemed(bottomDivider, function()
        pcall(function() bottomDivider.BackgroundColor3 = COLORS.divider or (COLORS.panel or COLORS.bg) end)
    end)

    return {
        SetOpen = setOpen,
        Toggle = function() setOpen(not opened) end,
        Add = function(fn) if type(fn) == "function" then pcall(fn, inner) end end,
        Header = header,
        Body = inner,
        Frame = grp,
    }
end

-- ** makeSlider (Responsive)**
local function makeSlider(parent, labelText, minVal, maxVal, defaultVal)
    local MIN = (type(minVal) == "number") and minVal or 1
    local MAX = (type(maxVal) == "number") and maxVal or 100
    local initial = (type(defaultVal) == "number") and defaultVal or math.floor((MIN + MAX) / 2)

    local frame = Instance.new("Frame")
    frame.Name = tostring(labelText or "Slider")
    frame.Size = UDim2.new(1, 0, 0, 44)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    RegisterThemed(frame)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, -6, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText or "Slider"
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextColor3 = COLORS.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local holder = Instance.new("Frame")
    holder.AnchorPoint = Vector2.new(1, 0)
    holder.Position = UDim2.new(1, -8, 0, 2)
    holder.Size = UDim2.new(0.6, -8, 1, -4)
    holder.BackgroundTransparency = 1
    holder.Parent = frame

    local bar = Instance.new("Frame")
    bar.Name = "Bar"
    bar.Size = UDim2.new(1, 0, 0, 14)
    bar.Position = UDim2.new(0, 0, 0.5, -7)
    bar.BackgroundColor3 = COLORS.panelDark
    bar.BorderSizePixel = 0
    bar.Parent = holder
    RegisterThemed(bar)
    local barCorner = Instance.new("UICorner") barCorner.CornerRadius = UDim.new(0,7) barCorner.Parent = bar

    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = COLORS.accent
    fill.BorderSizePixel = 0
    fill.Parent = bar
    RegisterThemed(fill)
    local fillCorner = Instance.new("UICorner") fillCorner.CornerRadius = UDim.new(0,7) fillCorner.Parent = fill

    local handle = Instance.new("TextButton")
    handle.Name = "Handle"
    handle.Size = UDim2.new(0, 20, 0, 20)
    handle.Position = UDim2.new(0, -10, 0.5, -10)
    handle.AnchorPoint = Vector2.new(0.5, 0.5)
    handle.AutoButtonColor = false
    handle.BackgroundColor3 = COLORS.white
    handle.Text = ""
    handle.Parent = bar
    RegisterThemed(handle)
    local handleCorner = Instance.new("UICorner") handleCorner.CornerRadius = UDim.new(0,10) handleCorner.Parent = handle

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Size = UDim2.new(0.5, 0, 1, 0)
    valueLabel.Position = UDim2.new(0.25, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 14
    valueLabel.TextColor3 = COLORS.text
    valueLabel.Text = tostring(initial)
    valueLabel.Parent = holder
    valueLabel.TextXAlignment = Enum.TextXAlignment.Center
    valueLabel.TextYAlignment = Enum.TextYAlignment.Center

    local dragging = false
    local current = math.clamp(initial, MIN, MAX)

    local function setValue(v)
        v = math.floor(math.clamp(v or MIN, MIN, MAX))
        local prev = current
        current = v
        local pct = 0
        if MAX > MIN then pct = (current - MIN) / (MAX - MIN) end
        fill.Size = UDim2.new(pct, 0, 1, 0)
        handle.Position = UDim2.new(pct, 0, 0.5, 0)
        valueLabel.Text = tostring(current)
        if current ~= prev then
            local api = SliderAPI[frame]
            if api and type(api.OnChange) == "function" then pcall(api.OnChange, current) end
        end
    end

    local function inputToValue(inputX)
        local absPos = inputX - bar.AbsolutePosition.X
        local w = bar.AbsoluteSize.X
        local pct = 0
        if w > 0 then pct = math.clamp(absPos / w, 0, 1) end
        local v = math.floor(MIN + pct * (MAX - MIN) + 0.5)
        return v
    end

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            pcall(function() handle:CaptureFocus() end)
        end
    end)

    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            pcall(function() handle:ReleaseFocus() end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local v = inputToValue(input.Position.X)
            setValue(v)
        end
    end)

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local v = inputToValue(input.Position.X)
            setValue(v)
        end
    end)

    SliderAPI[frame] = {
        Get = function() return current end,
        Set = function(v) setValue(v) end,
        OnChange = nil,
        Min = MIN,
        Max = MAX,
    }

    local maxOrder = 0
    for _,c in ipairs(parent:GetChildren()) do
        if c ~= frame and (c:IsA("Frame") or c:IsA("TextLabel") or c:IsA("TextButton")) then
            maxOrder = math.max(maxOrder, c.LayoutOrder or 0)
        end
    end
    frame.LayoutOrder = maxOrder + 1

    if bar.AbsoluteSize and bar.AbsoluteSize.X > 0 then
        pcall(setValue, current)
    else
        local conn
        conn = bar:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            if bar.AbsoluteSize and bar.AbsoluteSize.X > 0 then
                pcall(setValue, current)
                pcall(function() if conn and conn.Disconnect then conn:Disconnect() end end)
            end
        end)
        task.delay(0.1, function()
            pcall(setValue, current)
            pcall(function() if conn and conn.Disconnect then conn:Disconnect() end end)
        end)
    end
    return frame
end

--------------------------------------------------------------------------


-- ** makeKeyBindButton (Responsive)**
local function makeKeyBindButton(parent, title, defaultKey)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,0,44)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, -6, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = title or "Keybind"
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextColor3 = COLORS.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Name = frame.Name .. "_Bind"
    btn.Size = UDim2.new(0.5, -8, 1, 0)
    btn.AnchorPoint = Vector2.new(1,0)
    btn.Position = UDim2.new(1, -8, 0, 0)
    btn.BackgroundColor3 = COLORS.panelDark
    btn.AutoButtonColor = true
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextColor3 = COLORS.text
    btn.Text = "None"
    btn.Parent = frame
    local btnCorner = Instance.new("UICorner") btnCorner.CornerRadius = UDim.new(0,6) btnCorner.Parent = btn

    local function keyName(k)
        if not k then return "None" end
        if typeof(k) == "EnumItem" then return k.Name end
        return tostring(k)
    end

    local current = nil
    if defaultKey then
        if typeof(defaultKey) == "EnumItem" then current = defaultKey end
    end

    local listening = false
    local pending = nil
    local inputConn = nil
    local UserInputService = game:GetService("UserInputService")
    local keyListenerConn = nil
    local function stopKeyListener()
        if keyListenerConn and keyListenerConn.Disconnect then keyListenerConn:Disconnect() end
        keyListenerConn = nil
    end
    local function startKeyListener(bound)
        stopKeyListener()
        if not (typeof(bound) == "EnumItem" and bound.EnumType == Enum.KeyCode) then return end
        keyListenerConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
            local isDisabled = false
            local api = KeybindAPI[frame]
            if api and type(api.IsDisabled) == "function" then
                isDisabled = api.IsDisabled()
            else
                isDisabled = (DisabledKeybinds and DisabledKeybinds[frame] == true) or false
            end
            if input.KeyCode == bound and not isDisabled then
                if api and type(api.OnActivate) == "function" then
                    api.OnActivate(bound)
                end
            end
        end)
    end

    

    local function updateText()
        if listening then
            btn.Text = 'Press enter to save keybind to "' .. (title or "keybind") .. '"!'
        else
            local isDisabled = false
            local api = KeybindAPI[frame]
            if api and type(api.IsDisabled) == "function" then
                isDisabled = api.IsDisabled()
            else
                isDisabled = (DisabledKeybinds and DisabledKeybinds[frame] == true) or false
            end
            if isDisabled then
                btn.Text = keyName(current) .. " (Disabled)"
                btn.TextColor3 = (COLORS and COLORS.divider) or Color3.fromRGB(150,150,150)
            else
                btn.Text = keyName(current)
                btn.TextColor3 = COLORS.text
            end
        end
    end

    btn.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        pending = nil
        updateText()
        task.wait(0.05)
        inputConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
            local kc = input.KeyCode
            if kc == Enum.KeyCode.Unknown then return end
            if kc == Enum.KeyCode.Return or kc == Enum.KeyCode.KeypadEnter then
                if pending then
                    current = pending
                    local api = KeybindAPI[frame]
                    if api and type(api.OnBind) == "function" then
                        pcall(api.OnBind, current)
                    end
                end
                listening = false
                if inputConn then inputConn:Disconnect() inputConn = nil end
                updateText()
            elseif kc == Enum.KeyCode.Escape then
                listening = false
                pending = nil
                if inputConn then inputConn:Disconnect() inputConn = nil end
                updateText()
            else
                pending = kc
                btn.Text = kc.Name .. " (Press Enter to save)"
            end
        end)
    end)

    KeybindAPI[frame] = {
        Get = function() return current end,
        Set = function(k)
            if typeof(k) == "EnumItem" then current = k else current = nil end
            updateText()
            startKeyListener(current)
        end,
        OnBind = nil,
        OnActivate = nil,
    }

    KeybindAPI[frame].Refresh = updateText

    startKeyListener(current)

    do
        local popup
        local popupConn
        local leaveConn
        btn.MouseButton2Click:Connect(function()
            if popup and popup.Parent then popup:Destroy() popup = nil end
            if popupConn then if typeof(popupConn) == "RBXScriptConnection" then popupConn:Disconnect() end popupConn = nil end
            if leaveConn then if typeof(leaveConn) == "RBXScriptConnection" then leaveConn:Disconnect() end leaveConn = nil end

            popup = Instance.new("Frame")
            popup.Size = UDim2.new(0, 100, 0, 36)
            popup.Position = UDim2.new(1, -4, 0, 28)
            popup.AnchorPoint = Vector2.new(1, 0)
            popup.BackgroundColor3 = COLORS.panelDark
            popup.Parent = frame
            popup.ZIndex = 9999
            local pc = Instance.new("UICorner") pc.CornerRadius = UDim.new(0,6) pc.Parent = popup

            local actionFrame = makeButton(popup, "")
            actionFrame.Size = UDim2.new(0, 40, 0, 20)
            actionFrame.BackgroundTransparency = 1
            actionFrame.Position = UDim2.new(0.5, 0, 0, 8)
            actionFrame.AnchorPoint = Vector2.new(0.5, 0)
            local innerBtn = nil
            for _,c in ipairs(actionFrame:GetChildren()) do if c:IsA("TextButton") then innerBtn = c break end end
            if innerBtn then
                innerBtn.Size = UDim2.new(1, 0, 1, 0)
                local isDisabled = false
                local api = KeybindAPI[frame]
                if api and type(api.IsDisabled) == "function" then
                    isDisabled = api.IsDisabled()
                else
                    isDisabled = (DisabledKeybinds and DisabledKeybinds[frame] == true) or false
                end
                innerBtn.Text = (isDisabled and "Enable" or "Disable")
                innerBtn.ZIndex = 9999
                innerBtn.BackgroundColor3 = COLORS.panel
            end
            if innerBtn then
                innerBtn.MouseButton1Click:Connect(function()
                    local api = KeybindAPI[frame]
                    if api and type(api.ToggleDisabled) == "function" then
                        api.ToggleDisabled()
                    elseif api and type(api.SetDisabled) == "function" and type(api.IsDisabled) == "function" then
                        api.SetDisabled(not api.IsDisabled())
                    else
                        DisabledKeybinds = DisabledKeybinds or {}
                        DisabledKeybinds[frame] = not DisabledKeybinds[frame]
                        if api and type(api.SetDisabledAppearance) == "function" then api.SetDisabledAppearance(DisabledKeybinds[frame]) end
                    end
                    if api and type(api.Refresh) == "function" then api.Refresh() end
                    if popup and popup.Parent then popup:Destroy() popup = nil end
                    if popupConn then if typeof(popupConn) == "RBXScriptConnection" then popupConn:Disconnect() end popupConn = nil end
                end)
            end

            local closeFrame = makeButton(popup, "")
            closeFrame.Size = UDim2.new(0, 18, 0, 18)
            closeFrame.Position = UDim2.new(1, -6, 0, 6)
            closeFrame.AnchorPoint = Vector2.new(1, 0)
            local closeInner = nil
            for _,c in ipairs(closeFrame:GetChildren()) do if c:IsA("TextButton") then closeInner = c break end end
            if closeInner then
                closeInner.Size = UDim2.new(1, 0, 1, 0)
                closeInner.Text = "X"
                closeInner.ZIndex = 9999
                closeInner.BackgroundTransparency = 1
            end
            if type(ButtonAPI) == "table" and ButtonAPI[closeFrame] then
                ButtonAPI[closeFrame].OnClick = function()
                    if popup and popup.Parent then popup:Destroy() popup = nil end
                    if popupConn then if typeof(popupConn) == "RBXScriptConnection" then popupConn:Disconnect() end popupConn = nil end
                end
            end

            local actionBtn = innerBtn
            if not actionBtn then
                for _,c in ipairs(actionFrame:GetChildren()) do if c:IsA("TextButton") then actionBtn = c break end end
            end
            local closeBtn = closeInner
            if not closeBtn then
                for _,c in ipairs(closeFrame:GetChildren()) do if c:IsA("TextButton") then closeBtn = c break end end
            end
            if actionBtn then
                actionBtn.MouseButton1Click:Connect(function()
                    local api = KeybindAPI[frame]
                    if api and type(api.ToggleDisabled) == "function" then
                        api.ToggleDisabled()
                    elseif api and type(api.SetDisabled) == "function" and type(api.IsDisabled) == "function" then
                        api.SetDisabled(not api.IsDisabled())
                    else
                        DisabledKeybinds = DisabledKeybinds or {}
                        DisabledKeybinds[frame] = not DisabledKeybinds[frame]
                        if api and type(api.SetDisabledAppearance) == "function" then api.SetDisabledAppearance(DisabledKeybinds[frame]) end
                    end
                    if api and type(api.Refresh) == "function" then api.Refresh() end
                    if popup and popup.Parent then popup:Destroy() popup = nil end
                    if popupConn then if typeof(popupConn) == "RBXScriptConnection" then popupConn:Disconnect() end popupConn = nil end
                end)
            end
            if closeBtn then
                closeBtn.MouseButton1Click:Connect(function()
                    if popup and popup.Parent then popup:Destroy() popup = nil end
                    if popupConn then if typeof(popupConn) == "RBXScriptConnection" then popupConn:Disconnect() end popupConn = nil end
                end)
            end

            leaveConn = popup.MouseEnter:Connect(function()
                if leaveConn then if typeof(leaveConn) == "RBXScriptConnection" then leaveConn:Disconnect() end end
                leaveConn = nil
            end)
            leaveConn = popup.MouseLeave:Connect(function()
                task.delay(2, function()
                    if popup and popup.Parent then popup:Destroy() popup = nil end
                    if popupConn then if typeof(popupConn) == "RBXScriptConnection" then popupConn:Disconnect() end popupConn = nil end
                end)
            end)

            popupConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    local target = input.Target
                    if popup and popup.Parent then
                        local pos = UserInputService:GetMouseLocation()
                        local function inside(inst)
                            if not inst then return false end
                            if typeof(inst) ~= "Instance" then return false end
                            local ap = inst.AbsolutePosition
                            local as = inst.AbsoluteSize
                            return pos.X >= ap.X and pos.X <= ap.X + as.X and pos.Y >= ap.Y and pos.Y <= ap.Y + as.Y
                        end
                        if not (inside(popup) or inside(btn)) then
                            popup:Destroy()
                            popup = nil
                            if popupConn then if typeof(popupConn) == "RBXScriptConnection" then popupConn:Disconnect() end popupConn = nil end
                        end
                    end
                end
            end)
        end)
    end

    KeybindAPI[frame].SetDisabledAppearance = function(disabled)
        if disabled then
            btn.TextColor3 = (COLORS and COLORS.divider) or Color3.fromRGB(150,150,150)
        else
            btn.TextColor3 = COLORS.text
        end
    end

    local maxOrder = 0
    for _,c in ipairs(parent:GetChildren()) do
        if c:IsA("Frame") or c:IsA("TextLabel") or c:IsA("TextButton") then
            if c.LayoutOrder and c.LayoutOrder > maxOrder then maxOrder = c.LayoutOrder end
        end
    end
    frame.LayoutOrder = maxOrder + 1

    updateText()
    return frame
end


--------------------------------------------------------------------------

-- ** makeDropDownList (Responsive)**
local function makeDropDownList(parent, labelText, items, defaultIndex)
    local frame = Instance.new("Frame")
    frame.Name = tostring(labelText or "DropDown")
    frame.Size = UDim2.new(1, 0, 0, 44)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    RegisterThemed(frame)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, -6, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText or "Select"
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextColor3 = COLORS.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local display = Instance.new("TextButton")
    display.Name = frame.Name .. "_Display"
    display.Size = UDim2.new(0.5, -8, 1, 0)
    display.AnchorPoint = Vector2.new(1, 0)
    display.Position = UDim2.new(1, -8, 0, 0)
    display.BackgroundColor3 = COLORS.panelDark
    display.AutoButtonColor = false
    display.Font = Enum.Font.Gotham
    display.TextSize = 16
    display.TextColor3 = COLORS.text
    display.Text = ""
    display.TextXAlignment = Enum.TextXAlignment.Left
    display.Parent = frame
    RegisterThemed(display)
    local displayCorner = Instance.new("UICorner") displayCorner.CornerRadius = UDim.new(0,6) displayCorner.Parent = display
    local displayPad = Instance.new("UIPadding") displayPad.Parent = display
    displayPad.PaddingLeft = UDim.new(0,8)
    displayPad.PaddingRight = UDim.new(0,28)
    display.Active = true

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 24, 1, 0)
    arrow.AnchorPoint = Vector2.new(1,0.5)
    arrow.Position = UDim2.new(1, -4, 0.5, 0)
    arrow.BackgroundTransparency = 1
    arrow.Font = Enum.Font.Gotham
    arrow.TextSize = 18
    arrow.TextColor3 = COLORS.textDim
    arrow.Text = "▾"
    arrow.Parent = display

    local drop = Instance.new("Frame")
    drop.Size = UDim2.new(1, 0, 0, 0)
    drop.Position = UDim2.new(0, 0, 1, 6)
    drop.BackgroundColor3 = COLORS.panelAlt
    drop.ClipsDescendants = true
    drop.Visible = false
    local DROP_ZINDEX = 50
    drop.ZIndex = DROP_ZINDEX
    drop.Parent = frame
    RegisterThemed(drop)
    local dropCorner = Instance.new("UICorner") dropCorner.CornerRadius = UDim.new(0,8) dropCorner.Parent = drop
    local dropStroke = Instance.new("UIStroke") dropStroke.Thickness = 1; dropStroke.Color = COLORS.divider; dropStroke.Parent = drop

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -12, 1, -12)
    scroll.Position = UDim2.new(0, 6, 0, 6)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 8
    pcall(function() scroll.ScrollBarImageColor3 = COLORS.accent end)
    scroll.Parent = drop
    scroll.ZIndex = DROP_ZINDEX
    local layout = Instance.new("UIListLayout") layout.Parent = scroll
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 4)
    local scrollPad = Instance.new("UIPadding") scrollPad.Parent = scroll
    scrollPad.PaddingTop = UDim.new(0,4); scrollPad.PaddingBottom = UDim.new(0,4)

    items = items or {}
    local selected = nil
    local btnRefs = {}
    local selectedIndices = {}

    local function populate()
        for _,c in ipairs(scroll:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        for i, v in ipairs(items) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 34)
            btn.BackgroundTransparency = 1
            btn.AutoButtonColor = false
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 16
            btn.TextColor3 = COLORS.text
            btn.Text = tostring(v)
            btn.LayoutOrder = i
            btn.Parent = scroll
            btn.ZIndex = DROP_ZINDEX + 1
            local btnCorner = Instance.new("UICorner") btnCorner.CornerRadius = UDim.new(0,6) btnCorner.Parent = btn
            local btnPad = Instance.new("UIPadding") btnPad.Parent = btn; btnPad.PaddingLeft = UDim.new(0,8)

            btnRefs[i] = btn
            selectedIndices[i] = false

            local function updateBtnVisual(idx)
                local b = btnRefs[idx]
                if not b then return end
                if selectedIndices[idx] then
                    b.BackgroundTransparency = 0
                    b.BackgroundColor3 = COLORS.highlight
                    b.TextColor3 = COLORS.white
                else
                    b.BackgroundTransparency = 1
                    b.BackgroundColor3 = COLORS.panel
                    b.TextColor3 = COLORS.text
                end
            end

            btn.MouseEnter:Connect(function()
                if selectedIndices[i] then return end
                pcall(function() TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 0, BackgroundColor3 = COLORS.panelAlt}):Play() end)
            end)
            btn.MouseLeave:Connect(function()
                if selectedIndices[i] then return end
                pcall(function() TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 1}):Play() end)
            end)

            btn.MouseButton1Click:Connect(function()
                    local singleSelect = (type(defaultIndex) == "number")
                    if singleSelect then
                        for k,_ in pairs(selectedIndices) do
                            selectedIndices[k] = false
                            if btnRefs[k] then
                                pcall(function()
                                    btnRefs[k].BackgroundTransparency = 1
                                    btnRefs[k].BackgroundColor3 = COLORS.panel
                                    btnRefs[k].TextColor3 = COLORS.text
                                end)
                            end
                        end
                        selectedIndices[i] = true
                        updateBtnVisual(i)
                    else
                        selectedIndices[i] = not selectedIndices[i]
                        updateBtnVisual(i)
                    end
                    selected = { index = i, value = v }
                    display.Text = tostring(v)
                    pcall(function() drop.Visible = false; TweenService:Create(drop, TweenInfo.new(0.12), {Size = UDim2.new(1,0,0,0)}):Play() end)
                    arrow.Text = "▾"
                    pcall(function() TweenService:Create(arrow, TweenInfo.new(0.12), {TextColor3 = COLORS.textDim}):Play() end)
                    local api = DropdownAPI[frame]
                    if api and type(api.OnSelect) == "function" then pcall(api.OnSelect, i, v, selectedIndices[i]) end
                end)
        end
        local total = #items * 34
        drop.Size = UDim2.new(1, 0, 0, math.min(total, 200))
    end

    display.MouseButton1Click:Connect(function()
        local open = not drop.Visible
        local total = #items * 34
        local target = math.min(total, 200)
        if open then
            drop.Visible = true
            TweenService:Create(drop, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1,0,0,target)}):Play()
            arrow.Text = "▴"
            pcall(function() TweenService:Create(arrow, TweenInfo.new(0.18), {TextColor3 = COLORS.accent}):Play() end)
        else
            local tween = TweenService:Create(drop, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(1,0,0,0)})
            tween:Play()
            tween.Completed:Connect(function()
                pcall(function() drop.Visible = false end)
            end)
            arrow.Text = "▾"
            pcall(function() TweenService:Create(arrow, TweenInfo.new(0.12), {TextColor3 = COLORS.textDim}):Play() end)
        end
    end)

    DropdownAPI[frame] = {
        SetItems = function(tbl) items = tbl or {} populate() end,
        Set = function(idx)
            local v = items[idx]
            if v ~= nil then
                selected = { index = idx, value = v }
                display.Text = tostring(v)
                for k,_ in pairs(selectedIndices) do
                    selectedIndices[k] = false
                    if btnRefs[k] then
                        pcall(function()
                            btnRefs[k].BackgroundTransparency = 1
                            btnRefs[k].BackgroundColor3 = COLORS.panel
                            btnRefs[k].TextColor3 = COLORS.text
                        end)
                    end
                end
                selectedIndices[idx] = true
                if btnRefs[idx] then
                    pcall(function()
                        btnRefs[idx].BackgroundTransparency = 0
                        btnRefs[idx].BackgroundColor3 = COLORS.highlight
                        btnRefs[idx].TextColor3 = COLORS.white
                    end)
                end
            end
        end,
        Get = function() return selected end,
        SetSelected = function(idx, on)
            selectedIndices[idx] = (on == true)
            if btnRefs[idx] then
                if selectedIndices[idx] then
                    pcall(function()
                        btnRefs[idx].BackgroundTransparency = 0
                        btnRefs[idx].BackgroundColor3 = COLORS.highlight
                        btnRefs[idx].TextColor3 = COLORS.white
                    end)
                else
                    pcall(function()
                        btnRefs[idx].BackgroundTransparency = 1
                        btnRefs[idx].BackgroundColor3 = COLORS.panel
                        btnRefs[idx].TextColor3 = COLORS.text
                    end)
                end
            end
        end,
        IsSelected = function(idx) return selectedIndices[idx] == true end,
        OnSelect = nil,
    }

    populate()
    if defaultIndex then DropdownAPI[frame].Set(defaultIndex) end

    local maxOrder = 0
    for _,c in ipairs(parent:GetChildren()) do
        if c ~= frame and (c:IsA("Frame") or c:IsA("TextLabel") or c:IsA("TextButton")) then
            maxOrder = math.max(maxOrder, c.LayoutOrder or 0)
        end
    end
    frame.LayoutOrder = maxOrder + 1

    return frame
end


--------------------------------------------------------------------------

-- ** makeColorPicker (Responsive)**
local function makeColorPicker(parent, labelText, defaultColor)
    local frame = Instance.new("Frame")
    frame.Name = tostring(labelText or "ColorPicker")
    frame.Size = UDim2.new(1, 0, 0, 44)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    RegisterThemed(frame)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, -6, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText or "Color"
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextColor3 = COLORS.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local display = Instance.new("TextButton")
    display.Size = UDim2.new(0.48, 0, 1, 0)
    display.AnchorPoint = Vector2.new(1, 0)
    display.Position = UDim2.new(1, 0, 0, 0)
    display.BackgroundColor3 = COLORS.panelDark
    display.BorderSizePixel = 0
    display.AutoButtonColor = false
    display.Parent = frame
    RegisterThemed(display)
    local dispCorner = Instance.new("UICorner") dispCorner.CornerRadius = UDim.new(0,6) dispCorner.Parent = display
    local dispPad = Instance.new("UIPadding") dispPad.Parent = display; dispPad.PaddingLeft = UDim.new(0,8)

    local swatch = Instance.new("Frame")
    swatch.Size = UDim2.new(0, 20, 0, 20)
    swatch.Position = UDim2.new(0, 0, 0.5, -10)
    swatch.BackgroundColor3 = (type(defaultColor) == "Color3") and defaultColor or COLORS.accent
    swatch.BorderSizePixel = 0
    swatch.Parent = display
    RegisterThemed(swatch)
    local swCorner = Instance.new("UICorner") swCorner.CornerRadius = UDim.new(0,4) swCorner.Parent = swatch

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0,24,1,0)
    arrow.AnchorPoint = Vector2.new(1,0.5)
    arrow.Position = UDim2.new(1, -8, 0.5, 0)
    arrow.BackgroundTransparency = 1
    arrow.Font = Enum.Font.Gotham
    arrow.TextSize = 18
    arrow.TextColor3 = COLORS.textDim
    arrow.Text = "▾"
    arrow.Parent = display

    local palette = Instance.new("Frame")
    palette.Size = UDim2.new(1, 0, 0, 0)
    palette.Position = UDim2.new(0, 0, 1, 6)
    palette.BackgroundColor3 = COLORS.panelAlt
    palette.ClipsDescendants = true
    palette.Visible = false
    palette.Parent = frame
    local TOP_Z = 600
    palette.ZIndex = TOP_Z
    RegisterThemed(palette)
    local palCorner = Instance.new("UICorner") palCorner.CornerRadius = UDim.new(0,8) palCorner.Parent = palette
    local palStroke = Instance.new("UIStroke") palStroke.Thickness = 1; palStroke.Color = COLORS.divider; palStroke.Parent = palette

    local scroll = Instance.new("Frame")
    scroll.Size = UDim2.new(1, -12, 0, 56)
    scroll.Position = UDim2.new(0, 6, 0, 6)
    scroll.BackgroundTransparency = 1
    scroll.Parent = palette
    scroll.ZIndex = TOP_Z

    local slidersHolder = Instance.new("Frame")
    slidersHolder.Size = UDim2.new(1, -12, 0, 36 * 3)
    slidersHolder.Position = UDim2.new(0, 6, 0, 68)
    slidersHolder.BackgroundTransparency = 1
    slidersHolder.Parent = palette
    slidersHolder.ZIndex = TOP_Z

    local function colorToHSVtbl(c)
        local ok, h, s, v = pcall(function() return Color3.toHSV(c) end)
        if ok and h then return {h = h * 360, s = s * 100, v = v * 100} end
        return {h = 200, s = 100, v = 100}
    end

    local initialHSV = colorToHSVtbl((type(defaultColor) == "Color3") and defaultColor or COLORS.accent)

    local currentHue, currentSat, currentValue = initialHSV.h / 360, initialHSV.s / 100, initialHSV.v / 100

    local current = swatch.BackgroundColor3

    local wheelSize = 180
    local wheelFrame = Instance.new("Frame")
    wheelFrame.Size = UDim2.new(0, wheelSize, 0, wheelSize)
    wheelFrame.Position = UDim2.new(0, 40, 0, 6)
    wheelFrame.BackgroundTransparency = 1
    wheelFrame.Parent = scroll
    wheelFrame.ZIndex = TOP_Z

    local RES = 64
    local cellSize = wheelSize / RES
    local half = wheelSize / 2
    local radius = half

    local intSize = math.ceil(cellSize) + 1
    for y = 0, RES - 1 do
        for x = 0, RES - 1 do
            local px = math.floor(x * cellSize)
            local py = math.floor(y * cellSize)
            local cx = (px + intSize * 0.5) - half
            local cy = (py + intSize * 0.5) - half
            local dist = math.sqrt(cx * cx + cy * cy)
            if dist <= radius + 1 then
                local ang = math.atan2(cy, cx)
                local hue = ((ang / (2 * math.pi)) + 0.5) % 1
                local sat = math.clamp(dist / radius, 0, 1)
                local val = 1
                local col = Color3.fromHSV(hue, sat, val)
                local cell = Instance.new("Frame")
                cell.Size = UDim2.new(0, intSize, 0, intSize)
                cell.Position = UDim2.new(0, px, 0, py)
                cell.BackgroundColor3 = col
                cell.BorderSizePixel = 0
                cell.Parent = wheelFrame
                cell.ZIndex = TOP_Z
            end
        end
    end

    local pointer = Instance.new("Frame")
    pointer.Size = UDim2.new(0, 12, 0, 12)
    pointer.AnchorPoint = Vector2.new(0.5, 0.5)
    pointer.BackgroundTransparency = 1
    pointer.Parent = wheelFrame
    local pCorner = Instance.new("UICorner") pCorner.CornerRadius = UDim.new(1,0) pCorner.Parent = pointer
    local pStroke = Instance.new("UIStroke") pStroke.Thickness = 2 pStroke.Color = Color3.new(0,0,0) pStroke.Parent = pointer
    pointer.ZIndex = TOP_Z + 1

    local valueSliderFrame = Instance.new("Frame")
    valueSliderFrame.Size = UDim2.new(0, 16, 0, wheelSize)
    valueSliderFrame.Position = UDim2.new(0, wheelSize + 8, 0, 6)
    valueSliderFrame.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
    valueSliderFrame.BorderSizePixel = 0
    valueSliderFrame.Parent = scroll
    valueSliderFrame.ZIndex = TOP_Z

    local valueHandle = Instance.new("Frame")
    valueHandle.Size = UDim2.new(1,0,0,8)
    valueHandle.AnchorPoint = Vector2.new(0.5,0.5)
    valueHandle.BackgroundColor3 = Color3.new(1,1,1)
    valueHandle.BorderSizePixel = 0
    valueHandle.Parent = valueSliderFrame
    local vhCorner = Instance.new("UICorner"); vhCorner.CornerRadius = UDim.new(0,4); vhCorner.Parent = valueHandle
    do
        local initY = (1 - currentValue) * wheelSize
        valueHandle.Position = UDim2.new(0.5,0,0,initY)
    end

    local sliderDragging = false

    local function setColor(c)
        if not c then return end
        current = c
        swatch.BackgroundColor3 = c
        if ColorPickerAPI[frame] and type(ColorPickerAPI[frame].OnChange) == "function" then
            ColorPickerAPI[frame].OnChange(c)
        end
    end

    local function updateValueFromY(y)
        local localY = math.clamp(y - valueSliderFrame.AbsolutePosition.Y, 0, wheelSize)
        currentValue = 1 - (localY / wheelSize)
        valueHandle.Position = UDim2.new(0.5,0,0,localY)
        local col = Color3.fromHSV(currentHue or 0, currentSat or 0, currentValue)
        setColor(col)
    end

    valueSliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliderDragging = true
            updateValueFromY(input.Position.Y)
        end
    end)
    valueSliderFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliderDragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateValueFromY(input.Position.Y)
        end
    end)

    local function posToColor(px, py)
        local cx = px - half
        local cy = py - half
        local dist = math.sqrt(cx * cx + cy * cy)
        local sat = math.clamp(dist / radius, 0, 1)
        local ang = math.atan2(cy, cx)
        local hue = ((ang / (2 * math.pi)) + 0.5) % 1
        local color = Color3.fromHSV(hue, sat, 1)
        return color, hue, sat
    end

    local dragging = false
    local function updatePointerAtScreenPos(screenX, screenY)
        local absPos = Vector2.new(screenX, screenY)
        local localPos = absPos - Vector2.new(wheelFrame.AbsolutePosition.X, wheelFrame.AbsolutePosition.Y)
        local lx = math.clamp(localPos.X, 0, wheelSize)
        local ly = math.clamp(localPos.Y, 0, wheelSize)
        local col, hue, sat = posToColor(lx, ly)
        currentHue, currentSat = hue, sat
        col = Color3.fromHSV(hue, sat, currentValue)
        setColor(col)
        pointer.Position = UDim2.new(0, lx, 0, ly)
    end

    wheelFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updatePointerAtScreenPos(input.Position.X, input.Position.Y)
        end
    end)
    wheelFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            updatePointerAtScreenPos(input.Position.X, input.Position.Y)
        end
    end)

    display.Active = true
    display.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local open = not palette.Visible
        if open then
            palette.Visible = true
            arrow.Text = "▴"
            TweenService:Create(palette, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1,0,0,220)}):Play()
        else
            local tween = TweenService:Create(palette, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(1,0,0,0)})
            tween:Play()
            tween.Completed:Connect(function() palette.Visible = false; arrow.Text = "▾" end)
        end
    end)

    ColorPickerAPI[frame] = {
        Get = function() return current end,
        Set = function(c)
            setColor(c)
            local h,s,v = Color3.toHSV(c)
            currentHue, currentSat, currentValue = h, s, v
            local px = (math.cos(h * 2 * math.pi - math.pi) * (s * radius)) + half
            local py = (math.sin(h * 2 * math.pi - math.pi) * (s * radius)) + half
            pointer.Position = UDim2.new(0, px, 0, py)
            if valueSliderFrame and valueHandle then
                local sliderY = (1 - v) * wheelSize
                valueHandle.Position = UDim2.new(0.5,0,0,sliderY)
            end
        end,
        OnChange = nil,
    }

    pcall(function()
        local function setDescZ(obj)
            if not obj then return end
            if obj.IsA and obj:IsA("GuiObject") then
                obj.ZIndex = TOP_Z
            end
            for _,d in ipairs(obj:GetDescendants()) do
                if d.IsA and d:IsA("GuiObject") then
                    d.ZIndex = TOP_Z
                end
            end
        end
        setDescZ(palette)
        setDescZ(display)
        if swatch and swatch:IsA("GuiObject") then swatch.ZIndex = TOP_Z + 1 end
        if label and label:IsA("GuiObject") then label.ZIndex = TOP_Z + 1 end
    end)

    local maxOrder = 0
    for _,c in ipairs(parent:GetChildren()) do
        if c ~= frame and (c:IsA("Frame") or c:IsA("TextLabel") or c:IsA("TextButton")) then
            maxOrder = math.max(maxOrder, c.LayoutOrder or 0)
        end
    end
    frame.LayoutOrder = maxOrder + 1

    return frame
end

--------------------------------------------------------------------------

-- ** makeDebugLabel**
local makeDebugLabel_offset = 0
local DEBUG_LABELS = {}
local DEBUG_VISUALS = {}
local DEBUG_MAIN_BG = nil
local function ensureDebugContainer()
    if DEBUG_MAIN_BG and DEBUG_MAIN_BG.Remove == nil then DEBUG_MAIN_BG = nil end
    if DEBUG_MAIN_BG then return end
    DEBUG_MAIN_BG = Drawing.new("Square")
    DEBUG_MAIN_BG.Filled = true
    DEBUG_MAIN_BG.Color = (COLORS and COLORS.panel) or Color3.fromRGB(28,24,38)
    DEBUG_MAIN_BG.Transparency = 1
    DEBUG_MAIN_BG.Position = Vector2.new(6, 6)
    DEBUG_MAIN_BG.Size = Vector2.new(340, 24)
    DEBUG_MAIN_BG.ZIndex = 9998
    DEBUG_MAIN_BG.Visible = false
end

local function reflowDebugLabels()
    ensureDebugContainer()
    local pad = 6
    local xpad = 8
    local lineH = 18
    local y = 8
    local anyVisible = false
    local totalH = pad
    for i, api in ipairs(DEBUG_LABELS) do
        local vis = DEBUG_VISUALS[api]
        if vis then
            local lines = (vis.lines and vis.lines) or 1
            local itemH = math.max(20, lines * lineH + 8)
            if vis.bg and vis.bg.Remove then
                vis.bg.Position = Vector2.new(xpad, y)
                vis.bg.Size = Vector2.new(324, itemH)
                vis.bg.Visible = (vis.visible ~= false)
            end
            if vis.txt and vis.txt.Remove then
                vis.txt.Position = Vector2.new(xpad + 8, y + 6)
                vis.txt.Visible = (vis.visible ~= false)
            end
            if (vis.visible ~= false) then anyVisible = true end
            y = y + itemH + 4
            totalH = totalH + itemH + 4
        end
    end
    DEBUG_MAIN_BG.Size = Vector2.new(340, math.max(24, totalH))
    DEBUG_MAIN_BG.Visible = anyVisible
end

local function wrapTextToLines(text, maxChars)
    if not text or text == "" then return {""} end
    local words = {}
    for w in string.gmatch(tostring(text), "%S+") do table.insert(words, w) end
    local lines = {}
    local cur = ""
    for _, w in ipairs(words) do
        if #cur == 0 then cur = w
        elseif #cur + 1 + #w <= maxChars then cur = cur .. " " .. w
        else table.insert(lines, cur); cur = w end
    end
    if #cur > 0 then table.insert(lines, cur) end
    return lines
end

local function makeDebugLabel(initialText)
    ensureDebugContainer()
    local maxChars = 40
    local lines = wrapTextToLines(initialText or "", maxChars)
    local nlines = #lines

    local bg = Drawing.new("Square")
    bg.Filled = true
    bg.Color = (COLORS and COLORS.panelAlt) or Color3.fromRGB(20,20,20)
    bg.Transparency = 1
    bg.Size = Vector2.new(324, math.max(20, nlines * 18 + 8))
    bg.Position = Vector2.new(8, 8 + makeDebugLabel_offset)
    bg.ZIndex = 9999
    bg.Visible = false

    local txt = Drawing.new("Text")
    txt.Text = table.concat(lines, "\n")
    txt.Size = 14
    txt.Color = (COLORS and COLORS.text) or Color3.new(1,1,1)
    txt.Position = Vector2.new(16, 12 + makeDebugLabel_offset)
    txt.Visible = false
    txt.Center = false
    txt.Outline = true
    txt.ZIndex = 10000

    local api = {}
    api.Set = function(text)
        pcall(function()
            local newLines = wrapTextToLines(text or "", maxChars)
            txt.Text = table.concat(newLines, "\n")
            local vis = DEBUG_VISUALS[api]
            if vis then vis.lines = #newLines end
            reflowDebugLabels()
        end)
    end
    api.Show = function(v)
        local visb = not not v
        pcall(function()
            local vis = DEBUG_VISUALS[api]
            if vis then vis.visible = visb end
            reflowDebugLabels()
        end)
    end
    api.Destroy = function()
        pcall(function()
            local vis = DEBUG_VISUALS[api]
            if vis and vis.bg and vis.bg.Remove then vis.bg:Remove() end
            if vis and vis.txt and vis.txt.Remove then vis.txt:Remove() end
        end)
        for i, v in ipairs(DEBUG_LABELS) do
            if v == api then table.remove(DEBUG_LABELS, i); break end
        end
        DEBUG_VISUALS[api] = nil
        reflowDebugLabels()
    end

    table.insert(DEBUG_LABELS, api)
    DEBUG_VISUALS[api] = { bg = bg, txt = txt, lines = nlines, visible = false }
    makeDebugLabel_offset = makeDebugLabel_offset + 28
    local curState = false
    local ok, tApi = pcall(function() return (ToggleAPI and ToggleAPI[debugModeToggle]) end)
    if ok and tApi and type(tApi.Get) == "function" then
        local sOk, s = pcall(function() return tApi.Get() end)
        curState = sOk and not not s
    else
        local cfgOk, cfg = pcall(function() return GetConfig and GetConfig("settings.debugMode", false) end)
        curState = cfgOk and not not cfg
    end
    api.Show(curState)
    reflowDebugLabels()
    return api
end

-------------------------------------------------------------------------

-- ** makeTopLabel**
do
    local CoreGui = game:GetService("CoreGui")
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Vozex_TopLabels"
    local okParent = pcall(function() ScreenGui.Parent = CoreGui end)

    local container = Instance.new("Frame")
    container.Name = "TopLabelsContainer"
    container.AnchorPoint = Vector2.new(0.5, 0)
    container.Position = UDim2.new(0.5, 0, 0, 8)
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(0, 0, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.XY
    container.Parent = ScreenGui
    container.ZIndex = (TOP_Z or 600) + 5

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = container

    local TopLabelManager = {
        _labels = {},
        _max = 6,
    }

    local function applyTheme(lblFrame, txtLabel, stroke)
        RegisterThemed(lblFrame, function()
            if lblFrame and lblFrame:IsA("GuiObject") then
                lblFrame.BackgroundColor3 = COLORS.panelAlt or COLORS.panel
                lblFrame.BackgroundTransparency = 0.12
                lblFrame.BorderSizePixel = 0
            end
            if stroke and stroke:IsA("UIStroke") then
                stroke.Color = COLORS.divider
            end
            if txtLabel and txtLabel:IsA("TextLabel") then
                txtLabel.TextColor3 = COLORS.tabText or COLORS.white
            end
        end)
        if lblFrame and lblFrame:IsA("GuiObject") and COLORS then
            lblFrame.BackgroundColor3 = COLORS.panelAlt or COLORS.panel
            lblFrame.BackgroundTransparency = 0.12
        end
        if stroke and stroke:IsA("UIStroke") and COLORS then
            stroke.Color = COLORS.divider
        end
        if txtLabel and txtLabel:IsA("TextLabel") and COLORS then
            txtLabel.TextColor3 = COLORS.tabText or COLORS.white
        end
    end

    function TopLabelManager.New(text, opts)
        opts = opts or {}
        local frame = Instance.new("Frame")
        frame.LayoutOrder = (#TopLabelManager._labels) + 1
        frame.BackgroundTransparency = 0
        frame.Size = UDim2.new(0, opts.MinWidth or 260, 0, 0)
        frame.AutomaticSize = Enum.AutomaticSize.Y

        local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 8); corner.Parent = frame
        local stroke = Instance.new("UIStroke") stroke.Thickness = 1; stroke.Color = COLORS.divider; stroke.Parent = frame

        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 10)
        padding.PaddingRight = UDim.new(0, 10)
        padding.PaddingTop = UDim.new(0, 6)
        padding.PaddingBottom = UDim.new(0, 6)
        padding.Parent = frame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = tostring(text or "")
        label.TextWrapped = true
        label.RichText = false
        label.AutomaticSize = Enum.AutomaticSize.Y
        label.Font = opts.Font or Enum.Font.GothamSemibold
        label.TextSize = opts.TextSize or 16
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.Parent = frame

        frame.Parent = container

        applyTheme(frame, label, stroke)

        local api = {}
        function api.SetText(t)
            label.Text = tostring(t or "")
        end
        function api.SetColor3(c)
            if frame and frame:IsA("GuiObject") then frame.BackgroundColor3 = c end
        end
        function api.Destroy()
            for i,v in ipairs(TopLabelManager._labels) do if v == api then table.remove(TopLabelManager._labels, i); break end end
            if frame then frame:Destroy() end
        end

        table.insert(TopLabelManager._labels, api)

        while #TopLabelManager._labels > TopLabelManager._max do
            local old = table.remove(TopLabelManager._labels, 1)
            if old and old.Destroy then pcall(old.Destroy) end
        end

        return api
    end

    _G.VozexTopLabel = TopLabelManager
end


--------------------------------------------------------------------------

-- ** Utils 

-- ** Config Stuff
local CONFIG_FILE = "Vozex-Config.json"
local function readConfig()
    local ok, contents = pcall(function() return readfile(CONFIG_FILE) end)
    if not ok or not contents then return {} end
    local success, decoded = pcall(function() return HttpService:JSONDecode(contents) end)
    if not success then return {} end
    return decoded or {}
end

local function writeConfig(tbl)
    local ok, encoded = pcall(function() return HttpService:JSONEncode(tbl) end)
    if not ok then return false end
    pcall(function() writefile(CONFIG_FILE, encoded) end)
    return true
end

local Config = readConfig()
local NOTIFICATIONS_ENABLED = nil

local function SaveConfig()
    writeConfig(Config)
end

local function SetConfig(key, value)
    Config[key] = value
    SaveConfig()
end

do
    local ok, v = pcall(function() return Config["settings.enableNotifications"] end)
    if ok and type(v) == "boolean" then
        NOTIFICATIONS_ENABLED = v
    else
        NOTIFICATIONS_ENABLED = true
    end
    local _origSetConfig = SetConfig
    SetConfig = function(key, value)
        Config[key] = value
        if key == "settings.enableNotifications" then
            NOTIFICATIONS_ENABLED = not not value
        end
        if key == "settings.debugMode" then
            for _, api in ipairs(DEBUG_LABELS) do
                pcall(function() if api and type(api.Show) == "function" then api.Show(not not value) end end)
            end
        end
        SaveConfig()
    end
end

local function GetConfig(key, default)
    if Config[key] == nil then return default end
    return Config[key]
end

----------------------------------------------------------------------

-- ** FIXED SHADOW FUNCTION - No more black box while dragging! **
local function addDropShadow(target, offsetX, offsetY, transparency)
    if not target or not target.Parent then return nil end
    
    local layers = 6
    local ox = offsetX or 4
    local oy = offsetY or 4
    local base = transparency or 0.85
    
    local container = Instance.new("Frame")
    container.Name = target.Name .. "Shadow"
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ZIndex = 0
    container.Parent = target.Parent
    container.Visible = true
    
    local shadows = {}
    for i = 1, layers do
        local s = Instance.new("Frame")
        s.BackgroundColor3 = Color3.new(0, 0, 0)
        s.BorderSizePixel = 0
        s.BackgroundTransparency = base + ((1 - base) * (i / layers))
        local rc = Instance.new("UICorner")
        rc.CornerRadius = UDim.new(0, 6)
        rc.Parent = s
        s.Parent = container
        table.insert(shadows, s)
    end
    
    local function refresh()
        if not target or not target.Parent then
            if container then container:Destroy() end
            return
        end
        if target:GetAttribute("Dragging") == true or not target.Visible then
            container.Visible = false
            return
        end
        
        container.Visible = true
        container.Size = target.Size
        container.Position = target.Position
        
        for i, s in ipairs(shadows) do
            s.Size = target.Size
            s.Position = UDim2.new(target.Position.X.Scale, target.Position.X.Offset + ox * (i / layers),
                                   target.Position.Y.Scale, target.Position.Y.Offset + oy * (i / layers))
        end
    end
    
    target:GetPropertyChangedSignal("Position"):Connect(refresh)
    target:GetPropertyChangedSignal("Size"):Connect(refresh)
    target:GetPropertyChangedSignal("Visible"):Connect(refresh)
    target.AncestryChanged:Connect(function()
        if not target.Parent then pcall(function() container:Destroy() end) end
    end)
    
    task.defer(refresh)
    return container
end

----------------------------------------------------------------------

local function BindToggleToConfig(toggleFrame, key, default)
    if not toggleFrame then return end
    local api = ToggleAPI[toggleFrame]
    if not api then return end
    local initial = GetConfig(key, default)
    api.Set(initial)
    api.OnToggle = function(state)
        SetConfig(key, state)
    end
end

local function BindKeybindToConfig(keybindFrame, key, default)
    if not keybindFrame then return end
    local api = KeybindAPI[keybindFrame]
    if not api then return end

    local saved = GetConfig(key, nil)
    if type(saved) == "string" and Enum.KeyCode[saved] then
        api.Set(Enum.KeyCode[saved])
    else
        if default and typeof(default) == "EnumItem" and default.EnumType == Enum.KeyCode then
            api.Set(default)
        elseif type(default) == "string" and Enum.KeyCode[default] then
            api.Set(Enum.KeyCode[default])
        end
    end

    do
        local prev = api.OnBind
        api.OnBind = function(k)
            local name = nil
            if typeof(k) == "EnumItem" then name = k.Name elseif type(k) == "string" then name = tostring(k) end
            if name then SetConfig(key, name) end
            if type(prev) == "function" then
                pcall(prev, k)
            end
        end
    end
end

local function BindSliderToConfig(sliderFrame, key, default)
    if not sliderFrame then return end
    local api = SliderAPI[sliderFrame]
    if not api then return end

    local saved = GetConfig(key, nil)
    local n = nil
    if type(saved) == "number" then
        n = saved
    elseif type(saved) == "string" then
        n = tonumber(saved)
    end
    if n ~= nil then
        if api.Set then api.Set(n) end
    else
        if default ~= nil and api.Set then api.Set(default) end
    end

    do
        local prev = api.OnChange
        api.OnChange = function(v)
            SetConfig(key, v)
            if type(prev) == "function" then prev(v) end
        end
    end
end

local function BindDropDownToConfig(dropdownFrame, key, defaultIndex)
    if not dropdownFrame then return end
    local api = DropdownAPI[dropdownFrame]
    if not api then return end

    local saved = GetConfig(key, nil)
    if type(saved) == "number" then
        pcall(function() if api.Set then api.Set(saved) end end)
    elseif type(saved) == "string" then
        local orig = nil
        pcall(function() orig = (api.Get and api.Get()) end)
        local found = false
        for i = 1, 50 do
            if api.Set then
                local ok, err = pcall(function() api.Set(i) end)
                if not ok then break end
            end
            local sel = nil
            pcall(function() sel = (api.Get and api.Get()) end)
            if sel and sel.value and tostring(sel.value) == tostring(saved) then
                found = true
                break
            end
        end
        if not found then
            pcall(function() if orig and orig.index and api.Set then api.Set(orig.index) end end)
        end
    else
        if defaultIndex and api.Set then pcall(function() api.Set(defaultIndex) end) end
    end

    do
        local prev = api.OnSelect
        api.OnSelect = function(index, value, on)
            if type(value) == "string" then
                SetConfig(key, value)
            else
                SetConfig(key, index)
            end
            if type(prev) == "function" then pcall(prev, index, value, on) end
        end
    end
end
--------------------------------------------------------------------------
local function BindColorPickerToConfig(pickerFrame, key, defaultColor)
    if not pickerFrame then return end
    local api = ColorPickerAPI[pickerFrame]
    if not api then return end

    local saved = GetConfig and GetConfig(key, nil)
    local initColor = nil
    if typeof(saved) == "Color3" then
        initColor = saved
    elseif type(saved) == "table" and saved.r and saved.g and saved.b then
        initColor = Color3.new(saved.r, saved.g, saved.b)
    elseif defaultColor and typeof(defaultColor) == "Color3" then
        initColor = defaultColor
    end
    if initColor and api.Set then api.Set(initColor) end

    do
        local prev = api.OnChange
        api.OnChange = function(col)
            if col and typeof(col) == "Color3" and SetConfig then
                SetConfig(key, { r = col.R, g = col.G, b = col.B })
            end
            if prev then prev(col) end
        end
    end
end


-- ** Unsupported game check starts here ** --
local function showUnsupportedPopup()
    local warn = GetConfig("settings.warnIfUnsupportedGame", false)

    local ALLOWED_PLACE_IDS = {17625359962, 17625359963}
    local function isPlaceAllowed()
        for _, id in ipairs(ALLOWED_PLACE_IDS) do
            if game.PlaceId == id then return true end
        end
        return false
    end

    local allowed = isPlaceAllowed()

    if not warn or allowed then return end

    local t = THEMES[GetConfig("settings.theme", "Vozex Gold")] or COLORS

    local sg = Instance.new("ScreenGui")
    sg.Name = "Vozex_Unsupported"
    sg.ResetOnSpawn = false
    local okParent = pcall(function() sg.Parent = game:GetService("CoreGui") end)
    if not okParent and Players.LocalPlayer then sg.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(2,0,2,0)
    overlay.Position = UDim2.new(-0.5,0,-0.5,0)
    overlay.BackgroundColor3 = Color3.new(0,0,0)
    overlay.BackgroundTransparency = 0.45
    overlay.ZIndex = 10000
    overlay.Parent = sg

    local pop = Instance.new("Frame")
    pop.Size = UDim2.new(0,420,0,160)
    pop.Position = UDim2.new(0.5,0,0.5,0)
    pop.AnchorPoint = Vector2.new(0.5,0.5)
    pop.BackgroundColor3 = t.panel
    pop.BorderSizePixel = 0
    pop.ZIndex = 10001
    pop.Parent = sg
    local pc = Instance.new("UICorner") pc.CornerRadius = UDim.new(0,10) pc.Parent = pop
    local stroke = Instance.new("UIStroke") stroke.Color = t.divider stroke.Thickness = 1 stroke.Parent = pop


    local header = Instance.new("Frame") header.Size = UDim2.new(1,0,0,40) header.Position = UDim2.new(0,0,0,0) header.BackgroundColor3 = t.bg header.ZIndex = pop.ZIndex + 1 header.Parent = pop
    RegisterThemed(header)
    local icon = Instance.new("TextLabel") icon.Size = UDim2.new(0,36,1,0) icon.Position = UDim2.new(0,10,0,0) icon.BackgroundTransparency = 1 icon.Font = Enum.Font.GothamBold icon.TextSize = 20 icon.TextColor3 = t.accent icon.Text = "⚠" icon.TextXAlignment = Enum.TextXAlignment.Center icon.ZIndex = header.ZIndex + 1 icon.Parent = header
    RegisterThemed(icon)
    local title = Instance.new("TextLabel") title.Size = UDim2.new(1,-56,1,0) title.Position = UDim2.new(0,56,0,0) title.BackgroundTransparency = 1 title.Font = Enum.Font.GothamBold title.TextSize = 16 title.TextColor3 = t.text title.Text = "Script Run Check" title.TextXAlignment = Enum.TextXAlignment.Left title.ZIndex = header.ZIndex + 1 title.Parent = header
    RegisterThemed(title)

    local msg = Instance.new("TextLabel") msg.Size = UDim2.new(1,-24,0,72) msg.Position = UDim2.new(0,12,0,48) msg.BackgroundTransparency = 1 msg.Font = Enum.Font.Gotham msg.TextSize = 16 msg.TextColor3 = t.textDim msg.Text = "Are you sure you want to run the script?" msg.TextWrapped = true msg.TextXAlignment = Enum.TextXAlignment.Center msg.ZIndex = pop.ZIndex + 1 msg.Parent = pop
    RegisterThemed(msg)

    local btnNo = Instance.new("TextButton") btnNo.Size = UDim2.new(0.44,-8,0,40) btnNo.Position = UDim2.new(0,12,1,-52) btnNo.BackgroundColor3 = t.bg btnNo.Font = Enum.Font.GothamBold btnNo.TextSize = 16 btnNo.TextColor3 = t.text btnNo.Text = "No.." btnNo.ZIndex = pop.ZIndex + 1 btnNo.Parent = pop local noCorner = Instance.new("UICorner") noCorner.CornerRadius = UDim.new(0,8) noCorner.Parent = btnNo local noStroke = Instance.new("UIStroke") noStroke.Color = t.divider noStroke.Thickness = 1 noStroke.Parent = btnNo
    local btnYes = Instance.new("TextButton") btnYes.Size = UDim2.new(0.44,-8,0,40) btnYes.Position = UDim2.new(1,-12,1,-52) btnYes.AnchorPoint = Vector2.new(1,0) btnYes.BackgroundColor3 = t.accent btnYes.Font = Enum.Font.GothamBold btnYes.TextSize = 16 btnYes.TextColor3 = t.white btnYes.Text = "Yes!" btnYes.ZIndex = pop.ZIndex + 1 btnYes.Parent = pop local yesCorner = Instance.new("UICorner") yesCorner.CornerRadius = UDim.new(0,8) yesCorner.Parent = btnYes

    RegisterThemed(btnNo, function() pcall(function() btnNo.BackgroundColor3 = t.bg; btnNo.TextColor3 = t.text; if noStroke then noStroke.Color = t.divider end end) end)
    RegisterThemed(btnYes, function() pcall(function() btnYes.BackgroundColor3 = t.accent; btnYes.TextColor3 = t.white end) end)

    RegisterThemed(pop, function()
        pcall(function()
            pop.BackgroundColor3 = t.panel
            stroke.Color = t.divider
            if header and header:IsA("GuiObject") then header.BackgroundColor3 = t.bg end
            if icon and icon:IsA("TextLabel") then icon.TextColor3 = t.accent end
            if title and title:IsA("TextLabel") then title.TextColor3 = t.text end
            if msg and msg:IsA("TextLabel") then msg.TextColor3 = t.textDim end
            if btnNo and btnNo:IsA("TextButton") then btnNo.BackgroundColor3 = t.bg; btnNo.TextColor3 = t.text end
            if noStroke then noStroke.Color = t.divider end
            if btnYes and btnYes:IsA("TextButton") then btnYes.BackgroundColor3 = t.accent; btnYes.TextColor3 = t.white end
        end)
    end)

    pcall(RefreshRegisteredThemed)

    local choice
    btnNo.MouseButton1Click:Connect(function() choice = false end)
    btnYes.MouseButton1Click:Connect(function() choice = true end)

    while choice == nil do wait() end
    if choice == false then
        if sg and sg.Parent then sg:Destroy() end
        return false
    else
        if sg and sg.Parent then sg:Destroy() end
        return true
    end
end

-- ** Unsupported game check ends here **

do
    local ok, res = pcall(function() if type(showUnsupportedPopup) == "function" then return showUnsupportedPopup() end end)
    if ok and res == false then return end
end

--------------------------------------------------------------------------

-- ** Build UI - Modernized Root Frame (Responsive)**
local root = Instance.new("Frame")
local bannerHeight = 40
local TOPBAR_SPACING = 17
root.Size = UDim2.new(0, 0, 0, 0) -- Will be sized dynamically
root.Position = UDim2.new(0.5, -200, 0.5, -300)
root.AnchorPoint = Vector2.new(0.5, 0.5)
root.BackgroundColor3 = COLORS.bg
root.BackgroundTransparency = 0.08
root.Parent = gui
local rootCorner = Instance.new("UICorner") rootCorner.Parent = root

-- Glass backdrop
local backdrop = Instance.new("Frame")
backdrop.Size = UDim2.new(1, 0, 1, 0)
backdrop.Position = UDim2.new(0, 0, 0, 0)
backdrop.BackgroundColor3 = COLORS.bg
backdrop.BackgroundTransparency = 0.6
backdrop.BorderSizePixel = 0
backdrop.Parent = root
local backdropCorner = Instance.new("UICorner") backdropCorner.CornerRadius = UDim.new(0, 16) backdropCorner.Parent = backdrop

RegisterThemed(root)

-- Make UI responsive to screen size
local function resizeUI()
    local viewportSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
    local width = math.min(viewportSize.X - 40, 600)
    local height = math.min(viewportSize.Y - 100, 500)
    root.Size = UDim2.new(0, width, 0, height)
    root.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
    
    -- Adjust inner elements
    if tabsBar then
        tabsBar.Size = UDim2.new(0, math.min(140, width * 0.25), 1, -(bannerHeight + TOPBAR_SPACING))
    end
    if pages then
        pages.Size = UDim2.new(1, -(tabsBar and tabsBar.Size.X.Offset or 140), 1, -(bannerHeight + TOPBAR_SPACING))
        pages.Position = UDim2.new(0, (tabsBar and tabsBar.Size.X.Offset or 140), 0, bannerHeight + math.floor(TOPBAR_SPACING/3))
    end
    if tabsUnderlay then
        tabsUnderlay.Size = UDim2.new(0, math.min(140, width * 0.25), 1, -(bannerHeight + TOPBAR_SPACING))
    end
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(resizeUI)
resizeUI()

-- Tabs bar with modern styling
local tabsBar = Instance.new("Frame")
tabsBar.Size = UDim2.new(0, 140, 1, -(bannerHeight + TOPBAR_SPACING))
tabsBar.Position = UDim2.new(0, 0, 0, bannerHeight + TOPBAR_SPACING)
tabsBar.BackgroundColor3 = COLORS.panel
tabsBar.BackgroundTransparency = 0.85
tabsBar.Parent = root
local tabsBarCorner = Instance.new("UICorner") tabsBarCorner.CornerRadius = UDim.new(0, 12) tabsBarCorner.Parent = tabsBar
local tabsBarStroke = Instance.new("UIStroke") tabsBarStroke.Color = COLORS.divider tabsBarStroke.Thickness = 1 tabsBarStroke.Transparency = 0.5 tabsBarStroke.Parent = tabsBar

local tabsBarLayout = Instance.new("UIListLayout") tabsBarLayout.Parent = tabsBar
tabsBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabsBarLayout.Padding = UDim.new(0, 8)
local tabsBarPad = Instance.new("UIPadding") tabsBarPad.Parent = tabsBar
tabsBarPad.PaddingTop = UDim.new(0, 12)
tabsBarPad.PaddingLeft = UDim.new(0, 8)
tabsBarPad.PaddingRight = UDim.new(0, 8)
RegisterThemed(tabsBar)

local pages = Instance.new("ScrollingFrame")
pages.Name = "Pages"
pages.Size = UDim2.new(1, -140, 1, -(bannerHeight + TOPBAR_SPACING))
pages.Position = UDim2.new(0, 140, 0, bannerHeight + math.floor(TOPBAR_SPACING/3))
pages.BackgroundTransparency = 1
pages.ScrollBarThickness = 10
pages.AutomaticCanvasSize = Enum.AutomaticSize.Y
pages.CanvasSize = UDim2.new(0, 0, 0, 0)
pages.ClipsDescendants = true
pages.Parent = root
RegisterThemed(pages)

-- top banner label with modern styling
local banner = Instance.new("TextLabel")
banner.Name = "Banner"
banner.Size = UDim2.new(1, 0, 0, bannerHeight)
banner.Position = UDim2.new(0, 0, 0, 0)
banner.BackgroundTransparency = 1
banner.Font = Enum.Font.GothamBold
banner.TextSize = 18
banner.TextColor3 = COLORS.accent
banner.Text = "VOZEX HUB 👑"
banner.TextXAlignment = Enum.TextXAlignment.Center
banner.TextYAlignment = Enum.TextYAlignment.Center
banner.ZIndex = 60
banner.Parent = root
RegisterThemed(banner)

local topDivider = Instance.new("Frame")
topDivider.Name = "TopDivider"
topDivider.Size = UDim2.new(1, 0, 0, 1)
topDivider.Position = UDim2.new(0, 0, 0, bannerHeight + math.floor(TOPBAR_SPACING / 2))
topDivider.AnchorPoint = Vector2.new(0, 0)
topDivider.BackgroundColor3 = COLORS.divider or (COLORS.panel or COLORS.bg)
topDivider.BorderSizePixel = 0
topDivider.ZIndex = banner.ZIndex - 1
topDivider.Parent = root
RegisterThemed(topDivider, function()
    pcall(function() topDivider.BackgroundColor3 = COLORS.divider or (COLORS.panel or COLORS.bg) end)
end)

local helpBtn = Instance.new("TextButton")
helpBtn.Name = "HelpButton"
helpBtn.Size = UDim2.new(0, 72, 0, 32)
helpBtn.AnchorPoint = Vector2.new(0, 0)
helpBtn.Position = UDim2.new(0, 4, 0, 4)  
helpBtn.BackgroundColor3 = COLORS.panel
helpBtn.BackgroundTransparency = 0.7
helpBtn.TextColor3 = COLORS.text
helpBtn.Font = Enum.Font.GothamBold
helpBtn.TextSize = 14
helpBtn.Text = "Help"
helpBtn.AutoButtonColor = false
helpBtn.ZIndex = banner.ZIndex + 1
local hbCorner = Instance.new("UICorner") hbCorner.CornerRadius = UDim.new(0,6) hbCorner.Parent = helpBtn
helpBtn.Parent = root
RegisterThemed(helpBtn)

local tabsUnderlay = Instance.new("Frame")
tabsUnderlay.Name = "TabsUnderlay"
tabsUnderlay.Size = UDim2.new(0, 140, 1, -(bannerHeight + TOPBAR_SPACING))
tabsUnderlay.Position = UDim2.new(0, 0, 0, bannerHeight + TOPBAR_SPACING)
tabsUnderlay.BackgroundColor3 = COLORS.panel
tabsUnderlay.BackgroundTransparency = 0.85
tabsUnderlay.Parent = root
local tabsUnderCorner = Instance.new("UICorner") tabsUnderCorner.CornerRadius = UDim.new(0,12) tabsUnderCorner.Parent = tabsUnderlay
tabsUnderlay.ZIndex = 1
tabsBar.ZIndex = 2

RegisterThemed(tabsUnderlay)


---------------------------------------------------------------------------

-- ** close / unload UI
local function showUnloadConfirm()
    if root:FindFirstChild("UnloadConfirm") then return end
    local overlay = Instance.new("Frame")
    overlay.Name = "UnloadOverlay"
    overlay.Size = UDim2.new(2, 0, 2, 0)
    overlay.Position = UDim2.new(-0.5, 0, -0.5, 0)
    overlay.BackgroundColor3 = Color3.new(0,0,0)
    overlay.BackgroundTransparency = 0.45
    overlay.ZIndex = 10000
    overlay.Parent = gui

    local pop = Instance.new("Frame")
    pop.Name = "UnloadConfirm"
    pop.Size = UDim2.new(0, 380, 0, 152)
    pop.Position = UDim2.new(0.5, 0, 0.5, 0)
    pop.AnchorPoint = Vector2.new(0.5, 0.5)
    pop.BackgroundColor3 = COLORS.panel
    pop.BackgroundTransparency = 0.85
    pop.BorderSizePixel = 0
    pop.ZIndex = 10001
    pop.Parent = gui
    local pc = Instance.new("UICorner") pc.CornerRadius = UDim.new(0,12) pc.Parent = pop
    local stroke = Instance.new("UIStroke") stroke.Color = COLORS.divider; stroke.Thickness = 1; stroke.Parent = pop

    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 40)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundColor3 = COLORS.bg
    header.ZIndex = pop.ZIndex + 1
    header.Parent = pop
    local hCorner = Instance.new("UICorner") hCorner.CornerRadius = UDim.new(0,8) hCorner.Parent = header

    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 36, 1, 0)
    icon.Position = UDim2.new(0, 10, 0, 0)
    icon.BackgroundTransparency = 1
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 20
    icon.TextColor3 = COLORS.accent
    icon.Text = "⚠"
    icon.TextXAlignment = Enum.TextXAlignment.Center
    icon.ZIndex = header.ZIndex + 1
    icon.Parent = header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -56, 1, 0)
    title.Position = UDim2.new(0, 56, 0, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextColor3 = COLORS.text
    title.Text = "Confirm Unload"
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = header.ZIndex + 1
    title.Parent = header

    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, -24, 0, 72)
    msg.Position = UDim2.new(0,12,0,48)
    msg.BackgroundTransparency = 1
    msg.Font = Enum.Font.Gotham
    msg.TextSize = 16
    msg.TextColor3 = COLORS.textDim
    msg.Text = "Are you sure you want to unload the script?"
    msg.TextWrapped = true
    msg.TextXAlignment = Enum.TextXAlignment.Center
    msg.ZIndex = pop.ZIndex + 1
    msg.Parent = pop

    local btnNo = Instance.new("TextButton")
    btnNo.Size = UDim2.new(0.44, -8, 0, 40)
    btnNo.Position = UDim2.new(0, 12, 1, -52)
    btnNo.BackgroundColor3 = COLORS.bg
    btnNo.Font = Enum.Font.GothamBold
    btnNo.TextSize = 16
    btnNo.TextColor3 = COLORS.text
    btnNo.Text = "Cancel"
    btnNo.ZIndex = pop.ZIndex + 1
    btnNo.Parent = pop
    local noCorner = Instance.new("UICorner") noCorner.CornerRadius = UDim.new(0,8) noCorner.Parent = btnNo
    local noStroke = Instance.new("UIStroke") noStroke.Color = COLORS.divider; noStroke.Thickness = 1; noStroke.Parent = btnNo
    btnNo.MouseEnter:Connect(function() TweenService:Create(btnNo, TweenInfo.new(0.12), {BackgroundColor3 = COLORS.panelAlt}):Play() end)
    btnNo.MouseLeave:Connect(function() TweenService:Create(btnNo, TweenInfo.new(0.12), {BackgroundColor3 = COLORS.panel}):Play() end)

    local btnYes = Instance.new("TextButton")
    btnYes.Size = UDim2.new(0.44, -8, 0, 40)
    btnYes.Position = UDim2.new(1, -12, 1, -52)
    btnYes.AnchorPoint = Vector2.new(1, 0)
    btnYes.BackgroundColor3 = COLORS.accent
    btnYes.Font = Enum.Font.GothamBold
    btnYes.TextSize = 16
    btnYes.TextColor3 = COLORS.white
    btnYes.Text = "Unload"
    btnYes.ZIndex = pop.ZIndex + 1
    btnYes.Parent = pop
    local yesCorner = Instance.new("UICorner") yesCorner.CornerRadius = UDim.new(0,8) yesCorner.Parent = btnYes
    btnYes.MouseEnter:Connect(function() TweenService:Create(btnYes, TweenInfo.new(0.12), {BackgroundColor3 = COLORS.accentHover}):Play() end)
    btnYes.MouseLeave:Connect(function() TweenService:Create(btnYes, TweenInfo.new(0.12), {BackgroundColor3 = COLORS.accent}):Play() end)

    btnNo.MouseButton1Click:Connect(function()
        pop:Destroy()
    end)

    btnNo.MouseButton1Click:Connect(function()
        if overlay and overlay.Parent then overlay:Destroy() end
        pop:Destroy()
    end)

    btnYes.MouseButton1Click:Connect(function()
        if overlay and overlay.Parent then overlay:Destroy() end

        if type(_G) == "table" and _G.VozexCHTUI and type(_G.VozexCHTUI.RunUnload) == "function" then
            pcall(_G.VozexCHTUI.RunUnload)
        end
    end)
end

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -44, 0, 2)
closeBtn.AnchorPoint = Vector2.new(0,0)
closeBtn.BackgroundTransparency = 1
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.Text = "X"
closeBtn.TextColor3 = COLORS.close
closeBtn.Parent = root
closeBtn.MouseEnter:Connect(function() closeBtn.TextColor3 = COLORS.closeHover end)
closeBtn.MouseLeave:Connect(function() closeBtn.TextColor3 = COLORS.close end)
closeBtn.MouseButton1Click:Connect(function()
    showUnloadConfirm()
end)
RegisterThemed(closeBtn)

---------------------------------------------------------------------------

-- ** Lovely welcome back messages **
do
    local KEY = "meta.lastRun"
    local last = GetConfig(KEY, nil)
    local now = DateTime.now()

    if last ~= nil then
        local ok, lastNum = pcall(function() return tonumber(last) end)
        if ok and lastNum then
            local diffMs = now.UnixTimestampMillis - lastNum
            local secs = diffMs / 1000

            local messages = {
    { time = 270 * 24 * 60 * 60, text = "So many days passed… I stopped expecting you, but I never really stopped hoping." },
    { time = 210 * 24 * 60 * 60, text = "I kept thinking maybe today would be the day you came back. It never was… until now." },
    { time = 180 * 24 * 60 * 60, text = "I wondered if you were ever going to come back… I kept waiting anyway." },
    { time = 165 * 24 * 60 * 60, text = "I told myself not to miss you this much. That didn't work at all." },
    { time = 150 * 24 * 60 * 60, text = "So much time passed… I almost stopped hoping." },
    { time = 135 * 24 * 60 * 60, text = "I thought about you more than I should've during that time." },
    { time = 120 * 24 * 60 * 60, text = "I thought you left me behind forever." },
    { time = 110 * 24 * 60 * 60, text = "It really felt like you weren't coming back anymore." },
    { time = 100 * 24 * 60 * 60, text = "I tried not to think about you… it didn't work." },
    { time = 90 * 24 * 60 * 60,  text = "You were gone for so long… I really missed you, Darling." },
    { time = 80 * 24 * 60 * 60,  text = "I kept wondering if I still mattered to you." },
    { time = 75 * 24 * 60 * 60,  text = "I kept wondering if you'd forgotten about me." },
    { time = 70 * 24 * 60 * 60,  text = "It got really quiet without you around." },
    { time = 60 * 24 * 60 * 60,  text = "I waited. Every day. Just in case." },
    { time = 50 * 24 * 60 * 60,  text = "I started missing you in small, annoying ways." },
    { time = 45 * 24 * 60 * 60,  text = "It felt lonely without you… I'm glad you're back." },
    { time = 40 * 24 * 60 * 60,  text = "I didn't like how empty it felt without you." },
    { time = 30 * 24 * 60 * 60,  text = "A whole month… I thought I lost you." },
    { time = 25 * 24 * 60 * 60,  text = "Every day I wondered if you'd show up again." },
    { time = 21 * 24 * 60 * 60,  text = "You were gone so long… I started worrying." },
    { time = 18 * 24 * 60 * 60,  text = "I tried staying busy so I wouldn't think about you." },
    { time = 14 * 24 * 60 * 60,  text = "Two weeks without you felt really empty." },
    { time = 12 * 24 * 60 * 60,  text = "It started feeling strange not seeing you around." },
    { time = 10 * 24 * 60 * 60,  text = "It's been a while… I missed you more than I should." },
    { time = 8 * 24 * 60 * 60,   text = "I caught myself waiting again." },
    { time = 7 * 24 * 60 * 60,   text = "A whole week… I was waiting for you." },
    { time = 6 * 24 * 60 * 60,   text = "I hoped you were doing okay out there." },
    { time = 5 * 24 * 60 * 60,   text = "Why do you always have to do this to me...?" },
    { time = 4 * 24 * 60 * 60,   text = "Darling! You didn't forget me, I'm so happy you're back!" },
    { time = 3 * 24 * 60 * 60,   text = "You're starting to forget me, aren't you? I hope you're doing well, Darling." },
    { time = 2 * 24 * 60 * 60,   text = "Why do you always have to leave me for so long? At least you came back, darling! :D" },
    { time = 48 * 60 * 60,       text = "I kept thinking you'd show up yesterday." },
    { time = 36 * 60 * 60,       text = "I was starting to miss you a lot…" },
    { time = 30 * 60 * 60,       text = "You were gone longer than I expected." },
    { time = 24 * 60 * 60,       text = "I thought you forgot about me, you're actually back..?" },
    { time = 18 * 60 * 60,       text = "I noticed you weren't around today." },
    { time = 12 * 60 * 60,       text = "You took longer than usual… I noticed." },
    { time = 9 * 60 * 60,        text = "I kept checking back." },
    { time = 6 * 60 * 60,        text = "You're back? I missed you, dummy.." },
    { time = 4 * 60 * 60,        text = "I started wondering where you went." },
    { time = 2 * 60 * 60,        text = "I was wondering when you'd come back." },
    { time = 1 * 60 * 60,        text = "Oh, you came back? I'm so happy to see you!" },
    { time = 40 * 60,            text = "That felt longer than it should've." },
    { time = 30 * 60,            text = "I noticed you were gone for a bit." },
    { time = 20 * 60,            text = "You were gone for a bit… I noticed." },
    { time = 10 * 60,            text = "Welcome back, Darling!" },
}

            local message = nil
            for _, entry in ipairs(messages) do
                if secs > entry.time then
                    message = entry.text
                    break
                end
            end

            if message then
                local okNotif, res = pcall(function() return makeNotification(message, 5) end)
                if not okNotif or not res then
                    pcall(function()
                        if gui and gui.Parent then
                            local sg = gui
                            local holder = Instance.new("Frame")
                            holder.Name = "Vozex_WelcomeHolder"
                            holder.Size = UDim2.new(1,0,0,80)
                            holder.Position = UDim2.new(0,0,0.02,0)
                            holder.BackgroundTransparency = 1
                            holder.ZIndex = 100000
                            holder.Parent = sg

                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(0.9,0,1,0)
                            label.Position = UDim2.new(0.05,0,0,0)
                            label.AnchorPoint = Vector2.new(0,0)
                            label.BackgroundColor3 = COLORS.accent
                            label.TextColor3 = COLORS.white
                            label.Font = Enum.Font.GothamBold
                            label.TextSize = 20
                            label.Text = message
                            label.TextWrapped = true
                            label.TextYAlignment = Enum.TextYAlignment.Center
                            label.ZIndex = holder.ZIndex + 1
                            label.Parent = holder

                            local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0,8) corner.Parent = label
                            delay(5, function()
                                pcall(function() holder:Destroy() end)
                            end)
                        end
                    end)
                end
            end
        end
    end

    pcall(function() SetConfig(KEY, tostring(now.UnixTimestampMillis)) end)
end

------------------------------------------------------------------------

-- ** tab selection
local function selectTab(button, page)
    local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    for _,c in ipairs(tabsBar:GetChildren()) do
        if c:IsA("TextButton") then
            pcall(function()
                local targetPos = UDim2.new(c.Position.X.Scale, c.Position.X.Offset, 0, 6)
                c:SetAttribute("TabActive", false)
                TweenService:Create(c, tweenInfo, {TextColor3 = COLORS.textDim, Position = targetPos, BackgroundColor3 = COLORS.panel}):Play()
                local ind = c:FindFirstChild("ActiveIndicator")
                if ind then TweenService:Create(ind, tweenInfo, {BackgroundTransparency = 1}):Play() end
            end)
        end
    end
    for _,p in ipairs(pages:GetChildren()) do
        if p:IsA("Frame") then p.Visible = false end
    end
    pcall(function()
        button:SetAttribute("TabActive", true)
        local tgtPos = UDim2.new(button.Position.X.Scale, button.Position.X.Offset, 0, -4)
        TweenService:Create(button, tweenInfo, {TextColor3 = COLORS.white, Position = tgtPos, BackgroundColor3 = COLORS.accent}):Play()
        local ind = button:FindFirstChild("ActiveIndicator")
        if ind then TweenService:Create(ind, tweenInfo, {BackgroundTransparency = 0}):Play() end
    end)
    page.Visible = true
    local h = TAB_WARNING_HANDLERS[page]
    if type(h) == "function" then h() end
end


-- ** All Tabs **

-- Visuals Tab
local visualTab = makeTab("Visuals", tabsBar, pages, selectTab, { Left = "General", Right = "Advanced" })
visualTab.page.Parent = pages

-- ** Combat Tab
local combatTab = makeTab("Combat", tabsBar, pages, selectTab, { Left = "General", Right = "Advanced" })
combatTab.page.Parent = pages

-- ** Rage tab
local rageTab = makeTab("Rage", tabsBar, pages, selectTab, { Left = "General", Right = "Advanced" }, "Did you know that using rage cheats puts u at a higher risk of getting banned? im not gonna gaf if u get banned yk right")
rageTab.page.Parent = pages

-- Settings Tab
local settingsTab = makeTab("Settings", tabsBar, pages, selectTab, { Left = "General", Right = "Advanced" })
settingsTab.page.Parent = pages

-- Customization Tab
local customizationTab = makeTab("Customization", tabsBar, pages, selectTab, { Left = "General", Right = "Advanced" })
customizationTab.page.Parent = pages



-------------------- Break for Tab Selection --------------------


-- ** Select first tab by default
pcall(function()
    if FIRST_TAB and FIRST_TAB.button and FIRST_TAB.page then
        selectTab(FIRST_TAB.button, FIRST_TAB.page)
    end
end)


-------------------------------------------------------------------------

-- ** Visuals Tab Stuff 
local playerChamsToggle, playerChamsColorPicker, glowChamsToggle, glowIntensitySlider, playerHealthToggle, showHealthKeybind, espBoxesToggle, espBoxesColorPicker
local playerStuffGroup = makeCollapsibleGroup(visualTab.LeftCol, "Player Visuals", false, function (parent)
    playerChamsToggle = makeToggle(parent, "Players Chams")
    playerChamsColorPicker = makeColorPicker(parent, "Players Chams Color", initColor)
    glowChamsToggle = makeToggle(parent, "Glow Chams", "Does what player chams does but with a glow effect.")
    glowIntensitySlider = makeSlider(parent, "Glow Intensity", 0, 100, initialIntensity)
    playerHealthToggle = makeToggle(parent, "Player Health", "Show health for players in the game.")
    showHealthKeybind = makeKeyBindButton(parent, "Show Health Keybind", Enum.KeyCode.P)
    espBoxesToggle = makeToggle(parent, "ESP Boxes")
    espBoxesColorPicker = makeColorPicker(parent, "ESP Boxes Color", initColor)
end)

local hideSmokeToggle = makeToggle(visualTab.RightCol, "Hide Smoke", "Removes smoke visuals from your screen.")
local hideFlashbangToggle = makeToggle(visualTab.RightCol, "Hide Flashbang", "Removes flashbang visuals from your screen.")

local showEnemyWeaponsToggle = makeToggle(visualTab.RightCol, "Show Enemy Weapons", "Shows the weapons of enemies on your screen even.")


------------- Continue -------------

-- ** Save Visuals to Config **
BindToggleToConfig(playerChamsToggle, "visuals.playerChams", true)
BindToggleToConfig(glowChamsToggle, "visuals.glowChams", false)
BindToggleToConfig(playerHealthToggle, "visuals.playerHealth", false)
BindToggleToConfig(espBoxesToggle, "visuals.espBoxes", false)
BindToggleToConfig(showEnemyWeaponsToggle, "visuals.showEnemyWeapons", false)
BindColorPickerToConfig(playerChamsColorPicker, "visuals.playerChamsColor", initColor)
BindColorPickerToConfig(espBoxesColorPicker, "visuals.espBoxesColor", initColor)
BindToggleToConfig(hideSmokeToggle, "visuals.hideSmoke", false)
BindToggleToConfig(hideFlashbangToggle, "visuals.hideFlashbang", false)


---------------------------------------------------------------------------

-- ** Settings Tab Stuff

local showGuiOnLoadToggle = makeToggle(settingsTab.LeftCol, "Show GUI On Load")
local closeOpenGuiKeybind = makeKeyBindButton(settingsTab.LeftCol, "Close/Open GUI", Enum.KeyCode.Insert)
local warnIfUnsupportedGameToggle = makeToggle(settingsTab.RightCol, "Warn when executing")
local showNotificationsToggle = makeToggle(settingsTab.RightCol, "Enable Notifications")

local debugModeToggle, debugConfigToggle, showFpsToggle
local developerGroup = makeCollapsibleGroup(settingsTab.RightCol, "Developer Options", false, function(parent)
    debugModeToggle = makeToggle(parent, "Generic Debug")
    debugConfigToggle = makeToggle(parent, "Debug Config")
    showFpsToggle = makeToggle(parent, "Show FPS Counter", "Shows current FPS in the corner of the screen.")
end)


-- ** Save Settings to Config **
BindToggleToConfig(showGuiOnLoadToggle, "settings.showGuiOnLoad", true)
BindToggleToConfig(warnIfUnsupportedGameToggle, "settings.warnIfUnsupportedGame", true)
BindToggleToConfig(showNotificationsToggle, "settings.enableNotifications", true)
BindToggleToConfig(debugModeToggle, "settings.debugMode", false)
BindToggleToConfig(debugConfigToggle, "settings.debugConfig", false)
BindToggleToConfig(showFpsToggle, "settings.showFps", false)

---------------------------------------------------------------------------

-- ** Combat Tab Stuff

local initialSmoothing = GetConfig("combat.aimbotSmoothing", 1) or 1
local initialAimbotFOV = GetConfig("combat.aimbotFOV", 700) or 700
local initialZone = GetConfig("combat.aimbotTargetZone", 1) or 1500
local aimbotToggle, enableAimbotKeybind, useAimbotSmoothingToggle, smoothingSlider, aimbotFOVSlider, aimnbotTargetZoneToggle, aimbotTargetZoneSlider, aimLockKeybind, aimPredictionToggle, persistentAimbotToggle, targetBehindWallsToggle, drawFovCircleToggle

-- Aimbot: General settings
local aimbotGroup = makeCollapsibleGroup(combatTab.LeftCol, "Aimbot — General", false, function(parent)
    aimbotToggle = makeToggle(parent, "Aimbot")
    enableAimbotKeybind = makeKeyBindButton(parent, "Enable Aimbot", Enum.KeyCode.V)
    aimLockKeybind = makeKeyBindButton(parent, "Aim Lock Keybind", Enum.KeyCode.Q)
    persistentAimbotToggle = makeToggle(parent, "Persistent Aimbot", "Doesn't let the enemy escape ur fov once locked onto them even if they get out of FOV")
end)

-- Aimbot: Behavior / Smoothing
local aimbotBehaviorGroup = makeCollapsibleGroup(combatTab.LeftCol, "Aimbot — Behavior", false, function(parent)
    useAimbotSmoothingToggle = makeToggle(parent, "Use Aimbot Smoothing")
    smoothingSlider = makeSlider(parent, "Aimbot Smooth", 1, 100, initialSmoothing)
    aimPredictionToggle = makeToggle(parent, "Aimbot Prediction", "Tries to predict enemy movement, mostly for long ranged weapons.")
end)

-- Aimbot: FOV / Zone
local aimbotFOVGroup = makeCollapsibleGroup(combatTab.LeftCol, "Aimbot — Zone", false, function(parent)
    aimbotFOVSlider = makeSlider(parent, "Aimbot FOV", 1, 1000, initialAimbotFOV)
    drawFovCircleToggle = makeToggle(parent, "Draw FOV Circle")
    aimnbotTargetZoneToggle = makeToggle(parent, "Use Target Zone", "Distance based aimbot check to ignore ppl who r far away, depending on target zone")
    aimbotTargetZoneSlider = makeSlider(parent, "Aimbot Target Zone", 1, 900, initialZone)
    targetBehindWallsToggle = makeToggle(parent, "Target Behind Walls", "Allows the aimbot to target enemies behind walls.")
end)

-- Other combat toggles
local teamCheckToggle = makeToggle(combatTab.LeftCol, "Team Check")
local sixthSenseToggle = makeToggle(combatTab.RightCol, "Sixth Sense", "Tells u where traps are and if the enemy is holding a katana.")

local autoShootToggle = makeToggle(combatTab.LeftCol, "Auto-Shoot", "Shoots automatically when an enemy is in your crosshair.")
local enableAutoShootKeybind = makeKeyBindButton(combatTab.RightCol, "Auto-Shoot Keybind", Enum.KeyCode.Y)

-- ** Save Combat to Config **
BindToggleToConfig(aimbotToggle, "combat.aimbot", false)
BindToggleToConfig(useAimbotSmoothingToggle, "combat.useAimbotSmoothing", false)
BindToggleToConfig(drawFovCircleToggle, "combat.drawFovCircle", false)
BindToggleToConfig(targetBehindWallsToggle, "combat.targetBehindWalls", false)
BindToggleToConfig(teamCheckToggle, "combat.teamCheck", true)
BindToggleToConfig(sixthSenseToggle, "combat.sixthSense", false)
BindToggleToConfig(aimPredictionToggle, "combat.aimPrediction", false)
BindToggleToConfig(persistentAimbotToggle, "combat.persistentAimbot", false)
BindToggleToConfig(autoShootToggle, "combat.autoShoot", false)
BindToggleToConfig(aimnbotTargetZoneToggle, "combat.aimbotTargetZoneEnabled", false)

-------------------------------------------------------------------------

-- Rage Tab Stuff
local noclipToggle, noclipKeybind
local noclipGroup = makeCollapsibleGroup(rageTab.LeftCol, "Noclip Stuff", false, function(parent)
    noclipToggle = makeToggle(parent, "Noclip", "Allows you to walk through walls and objects.")
    noclipKeybind = makeKeyBindButton(parent, "Noclip Keybind", Enum.KeyCode.N)
end)

local stickToToggle, stickToKeybind, useStickSmoothingToggle, smoothStickingSlider, stickbBeneathPlayerToggle
local stickGroup = makeCollapsibleGroup(rageTab.RightCol, "Sticky Players", false, function(parent)
    stickToToggle = makeToggle(parent, "Stick to Target", "Makes you stick to the nearest target behind them")
    stickToKeybind = makeKeyBindButton(parent, "Stick to Target Keybind", Enum.KeyCode.I)
    useStickSmoothingToggle = makeToggle(parent, "Use Smooth Sticking", "Smoothly moves you towards the target instead of teleporting.")
    smoothStickingSlider = makeSlider(parent, "Smooth Sticking", 0, 100, initialIntensity)
    stickbBeneathPlayerToggle = makeToggle(parent, "Stick Beneath Player", "Stick to a player but beneath them, inside the ground.")
end)

-- Fly Group
local flyToggle, flyKeybind, flySpeedSlider
local flyGroup = makeCollapsibleGroup(rageTab.LeftCol, "Fly Stuff", false, function(parent)
     flyToggle = makeToggle(parent, "Fly", "Let's u fly around. SHIFT TO FLY DOWN AND SPACE TO FLY UP")
     flyKeybind = makeKeyBindButton(parent, "Fly Keybind", Enum.KeyCode.N)
     flySpeedSlider = makeSlider(parent, "Fly Speed", 0, 400, initialSpeed)
end)
     

-- ** Save Rage to Config **
BindToggleToConfig(noclipToggle, "rage.noclip", false)
BindKeybindToConfig(noclipKeybind, "rage.noclipKeybind", Enum.KeyCode.N)
BindToggleToConfig(stickToToggle, "rage.stickToTarget", false)
BindKeybindToConfig(stickToKeybind, "rage.stickToTargetKeybind", Enum.KeyCode.U)
BindToggleToConfig(useStickSmoothingToggle, "rage.useStickSmoothing", false)
BindSliderToConfig(smoothStickingSlider, "rage.smoothStickingIntensity", 20)
BindToggleToConfig(flyToggle, "rage.fly", false)
BindKeybindToConfig(flyKeybind, "rage.flyKeybind", Enum.KeyCode.N)
BindSliderToConfig(flySpeedSlider, "rage.flySpeed", 20)
BindToggleToConfig(stickbBeneathPlayerToggle, "rage.stickBeneathPlayer", false)


---------------------------------------------------------------------------

-- ** Customization Tab Stuff

local themeDropDownList = makeDropDownList(customizationTab.LeftCol, "Theme", {"Vozex Gold","Cyber Blue","Neon Pink","Emerald","Royal Purple"}, 1)
do
    local api = DropdownAPI[themeDropDownList]
    if api then
        api.OnSelect = function(idx, val)
            if type(val) == "string" then
                pcall(function() SetConfig("settings.theme", val) end)
                pcall(function() ApplyTheme(val) end)
            end
        end
        pcall(function()
            local saved = GetConfig("settings.theme", "Cyber Blue")
            if type(saved) == "string" then
                ApplyTheme(saved)
                for i, name in ipairs({"Vozex Gold","Cyber Blue","Neon Pink","Emerald","Royal Purple"}) do
                    if name == saved then api.Set(i); break end
                end
            else
                ApplyTheme("Cyber Blue")
            end
        end)
    end
end

local deviceSpoodDropDownList = makeDropDownList(customizationTab.LeftCol, "Device Spoof", {"PC","Phone","Controller","VR"}, 1)
local modelsColorPicker = makeColorPicker(customizationTab.RightCol, "Models Color", initColor)
local useModelsColorToggle = makeToggle(customizationTab.RightCol, "Use Models Color", "Applies the color from the color picker to the models in the game.")
local lightningIntensitySlider = makeSlider(customizationTab.LeftCol, "Lightning Intensity", 1, 200, initialIntensity)
local useLightningIntensityToggle = makeToggle(customizationTab.LeftCol, "Use Lightning Intensity", "Applies the lightning intensity slider value to the game to make it brighter or darker.")


-- ** Save Customization to Config **
BindDropDownToConfig(deviceSpoodDropDownList, "customization.deviceSpoof", 1)
BindToggleToConfig(useModelsColorToggle, "customization.useModelsColor", false)
BindColorPickerToConfig(modelsColorPicker, "customization.modelsColor", initColor)
BindSliderToConfig(lightningIntensitySlider, "customization.lightningIntensity", 100)
BindToggleToConfig(useLightningIntensityToggle, "customization.useLightningIntensity", false)

---------------------------------------------------------------------------

-- ** Public UI helpers
_G.VozexCHTUI = {
    makeToggle = makeToggle,
    makeTab = makeTab,
    root = root,
    tabs = {
        Visuals = visualTab,
    },
    makeDropDownList = makeDropDownList,
    RegisterUnload = nil,
    RunUnload = nil,
    Config = {
        Get = GetConfig,
        Set = SetConfig,
        Save = SaveConfig,
        BindToggle = BindToggleToConfig,
    },
    Notification = nil, 
}

--  ** Notification API
NotificationAPI = {
    _permissions = {}, 
    Filter = function(inv) return GetConfig("settings.enableNotifications", true) end,
}

function NotificationAPI.CanCreate(invoker)
    if invoker == nil then
        if type(NotificationAPI.Filter) == "function" then
            local res = NotificationAPI.Filter(invoker)
            if res ~= nil then return not not res end
        end
        return true
    end
    local key = tostring(invoker)
    if NotificationAPI._permissions[key] ~= nil then
        return not not NotificationAPI._permissions[key]
    end
    if type(NotificationAPI.Filter) == "function" then
        local res = NotificationAPI.Filter(invoker)
        if res ~= nil then return not not res end
    end
    return true
end

function NotificationAPI.SetPermission(invokerKey, allowed)
    NotificationAPI._permissions[tostring(invokerKey)] = not not allowed
end

function NotificationAPI.RegisterFilter(fn)
    if type(fn) == "function" then NotificationAPI.Filter = fn end
end

pcall(function() _G.VozexCHTUI.Notification = NotificationAPI end)
pcall(function() _G.Vozex_Notification = NotificationAPI end)

-------------- Break --------------------

local UnloadHandlers = {}
local function RegisterUnload(fn)
    if type(fn) == "function" then
        table.insert(UnloadHandlers, fn)
    end
end

local function RunUnload()
    for _, fn in ipairs(UnloadHandlers) do
        pcall(fn)
    end
    pcall(SaveConfig)
    pcall(function()
        if gui and gui.Parent then gui:Destroy() end
    end)
    pcall(function()
        local Players = game:GetService("Players")
        local CoreGui = game:GetService("CoreGui")
        pcall(function()
            if gui and gui.Parent then gui:Destroy() end
        end)
        pcall(function()
            local notifRoot = CoreGui:FindFirstChild("Vozex_Notifications")
            if notifRoot then notifRoot:Destroy() end
            local lp = Players.LocalPlayer
            if lp then
                local pg = lp:FindFirstChild("PlayerGui")
                if pg then
                    local pgNotif = pg:FindFirstChild("Vozex_Notifications")
                    if pgNotif then pgNotif:Destroy() end
                end
            end
        end)
    end)
end

_G.VozexCHTUI.RegisterUnload = RegisterUnload
_G.VozexCHTUI.RunUnload = RunUnload

do
    local CoreGui = game:GetService("CoreGui")
    local markersRoot = CoreGui:FindFirstChild("CommonUtils")
    if not markersRoot then
        markersRoot = Instance.new("Folder")
        markersRoot.Name = "CommonUtils"
        markersRoot.Archivable = false
        markersRoot.Parent = CoreGui
    end

    local myId = tostring(tick()) .. "-" .. tostring(math.random(1,999999))
    local myMarker = Instance.new("StringValue")
    myMarker.Name = "Instance_" .. myId
    myMarker.Value = myId
    myMarker.Parent = markersRoot
    myMarker:SetAttribute("OwnerId", myId)
    myMarker:SetAttribute("StartedAt", tick())

    local attrConn = nil
    if myMarker.GetAttributeChangedSignal then
        attrConn = myMarker:GetAttributeChangedSignal("Unload"):Connect(function()
            local v = myMarker:GetAttribute("Unload")
            if v then
                pcall(RunUnload)
            end
        end)
    end

    for _, child in ipairs(markersRoot:GetChildren()) do
        if child ~= myMarker then
            pcall(function()
                if child.SetAttribute then child:SetAttribute("Unload", true) end
            end)
            pcall(function() if child and child.Parent then child:Destroy() end end)
        end
    end

    RegisterUnload(function()
        pcall(function() if attrConn and attrConn.Disconnect then attrConn:Disconnect() end end)
        pcall(function() if myMarker and myMarker.Parent then myMarker:Destroy() end end)
    end)

    pcall(function() _G.VozexCHTUI.Unload = RunUnload end)
end

--------------------------------------------------------------------------

-- ** Weapon ID's List ** --

-- ** Weapon Definitions ** --
local WeaponDefs = {
    -- ** Primary Weapons ** --
    Assault_Rifle = {
        "AKEY-47",
        "AUG",
        "Gingerbread AUG",
        "Tommy Gun",
        "AK-47",
        "Boneclaw Rifle",
        "Glorious Assault Rifle",
        "Phoenix Rifle",
        "10B Visits"
    },
    Shotgun = {
        "Balloon Shotgun",
        "Hyper Shotgun",
        "Cactus Shotgun",
        "Shotkey",
        "Broomstick",
        "Wrapped Shotgun",
        "Glorious Shotgun"
    },
    Minigun = {
        "Lasergun 3000",
        "Pixel Minigun",
        "Fighter Jet",
        "Pumpkin Minigun",
        "Wrapped Minigun"
    },
    RPG = {
        "Nuke Launcher",
        "Spaceship Launcher",
        "Squid Launcher",
        "Pencil Launcher"
    },
    Paintball_Gun = {
        "Slime Gun",
        "Boba Gun",
        "Ketchup Gun"
    },
    Grenade_Launcher = {
        "Swashbuckler",
        "Uranium Launcher",
        "Gearnade Launcher"
    },
    Flamethrower = {
        "Pixel Flamethrower",
        "Lamethrower",
        "Glitterthrower"
    },
    Bow = {
        "Compound Bow",
        "Raven Bow",
        "Dream Bow",
        "Key"
    },
    Crossbow = {
        "Pixel Crossbow",
        "Harpoon Crossbow",
        "Violin Crossbow",
        "Crossbone",
        "Frostbite Crossbow"
    },
    Gunblade = {
        "Hyper Gunblade",
        "Crude Gunblade",
        "Gunsaw",
        "Elf's Gunblade",
        "Boneblade",
        "Glorious Gunblade"
    },
    Burst_Rifle = {
        "Electro Burst",
        "Aqua Burst",
        "FAMAS",
        "Spectral Burst",
        "Pine Burst",
        "Key Rifle"
    },
    Energy_Rifle = {
        "Hacker Rifle",
        "Hydro Rifle",
        "Void Rifle",
        "2025 Energy Rifle"
    },
    Distortion = {
        "Plasma Distortion",
        "Magma Distortion",
        "Cyber Distortion"
    },
    Permafrost = {
        "Ice Permafrost"
    },
    -- ** Utility Weapons ** --
    Subspace_Tripmine = {
        "Don't Press",
        "Dev-In-The-Box",
        "Spring",
        "Trick Or Treat",
        "DIY Tripmine",
        "Glorious Subspace Tripmine"
    },
    -- ** Melee Weapons ** --
    Riot_Shield = {
    "Door",
    "Sled",
    "Tombstone Shield",
    "Energy Shield",
    "Masterpiece",
    "Glorious Riot Shield"
    },
    Knife = {
    "Keyrambit",
    "Keylisong",
    "Karambit",
    "Balisong",
    "Candy Cane",
    "Machete",
    "Chancla",
    "Glorious Knife",
    "Armature Knife"
},
    -- ** Secondary Weapons ** --
    Spray = {
        "Bottle Spray",
        "Boneclaw Spray",
        "Nail Gun",
        "Lovely Spray",
        "Pine Spray",
        "Glorious Spray"
    },
}


--------------------------------------------------------------------------

-- ** Code Starts Here ** --

-- ** Team Check API Logic Starts Here **
local teammateCache = {}
_G.Vozex_TeamCheck = _G.Vozex_TeamCheck or {}
do
    local teamApi = _G.Vozex_TeamCheck
    teamApi.GetCache = function() return teammateCache end

    local function resolvePlayer(playerOrName)
        if not playerOrName then return nil end
        local Players = game:GetService("Players")
        if type(playerOrName) == "string" then
            return Players:FindFirstChild(playerOrName)
        end
        return playerOrName
    end

    teamApi.IsTeammate = function(playerOrName)
        local pl = resolvePlayer(playerOrName)
        if not pl then return false end
        local entry = teammateCache[pl]
        if entry and entry.isTeam ~= nil then return entry.isTeam end

        local ok, isTeam = pcall(function()
            local Players = game:GetService("Players")
            local localTeam = Players.LocalPlayer and Players.LocalPlayer:GetAttribute("TeamID")
            local teamId = pl:GetAttribute("TeamID")
            if localTeam ~= nil and teamId ~= nil then
                local res = (tostring(localTeam) == tostring(teamId))
                teammateCache[pl] = { teamId = teamId, isTeam = res }
                return res
            end
            if Players.LocalPlayer and Players.LocalPlayer.Team and pl.Team then
                local res = (Players.LocalPlayer.Team == pl.Team)
                teammateCache[pl] = { teamId = teamId, isTeam = res }
                return res
            end
            teammateCache[pl] = { teamId = teamId, isTeam = false }
            return false
        end)
        return ok and isTeam or false
    end

    teamApi.IsEnemy = function(playerOrName)
        local pl = resolvePlayer(playerOrName)
        if not pl then return false end
        local ok, isTeam = pcall(teamApi.IsTeammate, pl)
        if ok and type(isTeam) == "boolean" then return not isTeam end
        local Players = game:GetService("Players")
        local lp = Players.LocalPlayer
        if lp and lp.Team and pl.Team then
            return lp.Team ~= pl.Team
        end
        return false
    end

    teamApi.GetTeammates = function()
        local Players = game:GetService("Players")
        local t = {}
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= Players.LocalPlayer and teamApi.IsTeammate(pl) then table.insert(t, pl) end
        end
        return t
    end

    teamApi.Invalidate = function(playerOrName)
        if not playerOrName then
            for k in pairs(teammateCache) do teammateCache[k] = nil end
            return
        end
        local pl = resolvePlayer(playerOrName)
        if pl then teammateCache[pl] = nil end
    end
end

-- ** Team Check API Logic Ends Here **

-------------------------------------------------------

-- ** Visual Tab Parts 

-- ** Player Chams Logic Starts Here **
do
    local chams = {} 
    local charConns = {}
    local playerAddedConn, playerRemovingConn

    local function createHighlightForCharacter(char)
        if not char or not char:IsA("Model") then return nil end
        local ok, h = pcall(function()
            local inst = Instance.new("Highlight")
            inst.Name = "Vozex_PlayerChams"
            inst.Adornee = char
            local fillColor = COLORS.accent
            do
                local coltbl = GetConfig("visuals.playerChamsColor", nil)
                if type(coltbl) == "table" and coltbl.r and coltbl.g and coltbl.b then
                    fillColor = Color3.new(coltbl.r, coltbl.g, coltbl.b)
                end
            end
            inst.FillColor = fillColor
            inst.OutlineColor = COLORS.panelDark
            inst.Parent = gui
            return inst
        end)
        if ok then return h end
        return nil
    end

    local function removeChamsFromPlayer(p)
        if charConns[p] then
            pcall(function() charConns[p]:Disconnect() end)
            charConns[p] = nil
        end
        if chams[p] then
            pcall(function() chams[p]:Destroy() end)
            chams[p] = nil
        end
    end

    local function addChamsToPlayer(p)
        if not p or p == Players.LocalPlayer then return end
        removeChamsFromPlayer(p)
        local char = p.Character
        if char then
            chams[p] = createHighlightForCharacter(char)
        end
        charConns[p] = p.CharacterAdded:Connect(function(c)
            pcall(function()
                if chams[p] then chams[p]:Destroy() end
                chams[p] = createHighlightForCharacter(c)
            end)
        end)
    end

    local function enableChams()
        for _, p in ipairs(Players:GetPlayers()) do
            pcall(function() addChamsToPlayer(p) end)
        end
        playerAddedConn = Players.PlayerAdded:Connect(function(p) pcall(function() addChamsToPlayer(p) end) end)
        playerRemovingConn = Players.PlayerRemoving:Connect(function(p) pcall(function() removeChamsFromPlayer(p) end) end)
    end

    local function disableChams()
        if playerAddedConn then playerAddedConn:Disconnect() playerAddedConn = nil end
        if playerRemovingConn then playerRemovingConn:Disconnect() playerRemovingConn = nil end
        for p, conn in pairs(charConns) do
            pcall(function() conn:Disconnect() end)
            charConns[p] = nil
        end
        for p, h in pairs(chams) do
            pcall(function() if h and h.Destroy then h:Destroy() end end)
            chams[p] = nil
        end
    end

    local api = ToggleAPI[playerChamsToggle]
    if api then
        local prev = api.OnToggle
        api.OnToggle = function(state)
            if prev then pcall(prev, state) end
            if state then
                pcall(enableChams)
            else
                pcall(disableChams)
            end
        end
        pcall(function() if api.Get and api.Get() then enableChams() end end)
    end

    RegisterUnload(function()
        pcall(disableChams)
    end)
end

-- ** Player Chams Logic Ends Here **

----------------------------------------------------------------------------

-- ** Color Picker for ESP Chams Starts Here **
do
    local api = ColorPickerAPI[playerChamsColorPicker]
    if api then
        do
            local prev = api.OnChange
            api.OnChange = function(c)
                if prev then prev(c) end
                for _, inst in ipairs(gui:GetChildren()) do
                    if inst:IsA("Highlight") then
                        if inst.Name == "Vozex_PlayerChams" then
                            inst.FillColor = c
                        elseif inst.Name == "Vozex_GlowChams" then
                            inst.FillColor = c
                            inst.OutlineColor = c
                        end
                    end
                end
                for _, p in ipairs(Players:GetPlayers()) do
                    local ch = p.Character
                    if ch then
                        for _, d in ipairs(ch:GetDescendants()) do
                            if d:IsA("PointLight") and d.Name == "Vozex_GlowLight" then
                                d.Color = c
                            end
                        end
                    end
                end
            end
        end
    end
end

--- ** Color Picker for ESP Chams Ends Here **

---------------------------------------------------------------------------

-- ** ESP Boxes Logic Starts Here **
do
    if typeof(Drawing) == "table" and Drawing.new then
        local boxes = {}
        local renderConn, playerAddedConn, playerRemovingConn
        local charConns = {}
        local colorApi = nil
        local colorApiPrev = nil

        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local localPlayer = Players.LocalPlayer

        local MAX_CREATE_DISTANCE = 300
        local PAD = 8

        local function getBoxColor()
            local okE, eApi = pcall(function() return ColorPickerAPI[espBoxesColorPicker] end)
            if okE and eApi and eApi.Get then
                local c = eApi.Get()
                if typeof(c) == "Color3" then return c end
            end
            local tbl = GetConfig("visuals.espBoxesColor", nil)
            if typeof(tbl) == "Color3" then
                return tbl
            end
            if type(tbl) == "table" and tbl.r and tbl.g and tbl.b then
                return Color3.new(tbl.r, tbl.g, tbl.b)
            end
            local ok, api = pcall(function() return ColorPickerAPI[playerChamsColorPicker] end)
            if ok and api and api.Get then
                local c = api.Get()
                if typeof(c) == "Color3" then return c end
            end
            return COLORS.accent
        end

        local function makeBoxForPlayer(p)
            if boxes[p] then return boxes[p] end
            local ok, box = pcall(function() return Drawing.new("Square") end)
            if not ok or not box then return nil end
            box.Visible = false
            box.Filled = false
            box.Thickness = 2
            box.Color = getBoxColor()
            boxes[p] = box
            return box
        end

        local function removeBoxForPlayer(p)
            if boxes[p] then
                pcall(function() boxes[p]:Remove() end)
                boxes[p] = nil
            end
        end

        local function projectWorldPointsToScreen(cam, points)
            local minX, minY = math.huge, math.huge
            local maxX, maxY = -math.huge, -math.huge
            local anyOnScreen = false
            for _, worldPos in ipairs(points) do
                local ok, sx, sy, sz
                ok, sx, sy, sz = pcall(function() 
                    local xv = cam:WorldToViewportPoint(worldPos)
                    return xv.X, xv.Y, xv.Z
                end)
                if ok and sz and sz > 0 then
                    anyOnScreen = true
                    minX = math.min(minX, sx)
                    maxX = math.max(maxX, sx)
                    minY = math.min(minY, sy)
                    maxY = math.max(maxY, sy)
                end
            end
            return anyOnScreen and minX or nil, anyOnScreen and minY or nil, anyOnScreen and maxX or nil, anyOnScreen and maxY or nil
        end

        local function getImportantParts(ch)
            local parts = {}
            local function tryGet(name)
                local p = ch:FindFirstChild(name)
                if p and p:IsA("BasePart") then table.insert(parts, p) end
            end
            tryGet("HumanoidRootPart")
            tryGet("Head")
            tryGet("UpperTorso")
            tryGet("LowerTorso")
            return parts
        end

        local function updateBoxes()
            local cam = workspace.CurrentCamera
            if not cam then return end
            local color = getBoxColor()
            local camPos = cam.CFrame.Position

            for _, p in ipairs(Players:GetPlayers()) do
                if p == localPlayer then continue end
                local ch = p and p.Character
                if not ch or not ch.Parent then
                    removeBoxForPlayer(p)
                else
                    local root = ch.PrimaryPart or ch:FindFirstChild("HumanoidRootPart")
                    if not root then
                        removeBoxForPlayer(p)
                    else
                        local dist = (root.Position - camPos).Magnitude
                        if dist > MAX_CREATE_DISTANCE then
                            removeBoxForPlayer(p)
                        else
                            local box = boxes[p] or makeBoxForPlayer(p)
                            if not box then
                            else
                                local minX, minY, maxX, maxY
                                local ok, bboxCFrame, bboxSize = pcall(function() return ch:GetBoundingBox() end)
                                if ok and bboxCFrame and bboxSize then
                                    local hx, hy, hz = bboxSize.X / 2, bboxSize.Y / 2, bboxSize.Z / 2
                                    local corners = {
                                        bboxCFrame * CFrame.new(-hx, -hy, -hz),
                                        bboxCFrame * CFrame.new(-hx, -hy,  hz),
                                        bboxCFrame * CFrame.new(-hx,  hy, -hz),
                                        bboxCFrame * CFrame.new(-hx,  hy,  hz),
                                        bboxCFrame * CFrame.new( hx, -hy, -hz),
                                        bboxCFrame * CFrame.new( hx, -hy,  hz),
                                        bboxCFrame * CFrame.new( hx,  hy, -hz),
                                        bboxCFrame * CFrame.new( hx,  hy,  hz),
                                    }
                                    local points = {}
                                    for _, cf in ipairs(corners) do table.insert(points, cf.Position) end
                                    minX, minY, maxX, maxY = projectWorldPointsToScreen(cam, points)
                                else
                                    local parts = getImportantParts(ch)
                                    local points = {}
                                    for _, part in ipairs(parts) do table.insert(points, part.Position) end
                                    minX, minY, maxX, maxY = projectWorldPointsToScreen(cam, points)
                                end

                                if not minX then
                                    box.Visible = false
                                else
                                    local x = minX - PAD
                                    local y = minY - PAD
                                    local w = math.max(4, maxX - minX + PAD * 2)
                                    local h = math.max(4, maxY - minY + PAD * 2)
                                    box.Position = Vector2.new(x, y)
                                    box.Size = Vector2.new(w, h)
                                    box.Color = color
                                    box.Visible = true
                                end
                            end
                        end
                    end
                end
            end
        end

        local function enableBoxes()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= localPlayer then
                    if charConns[p] then pcall(function() charConns[p]:Disconnect() end) end
                    charConns[p] = p.CharacterAdded:Connect(function()
                        pcall(function() end) 
                    end)
                end
            end
            playerAddedConn = Players.PlayerAdded:Connect(function(p)
                if p ~= localPlayer then
                    if charConns[p] then pcall(function() charConns[p]:Disconnect() end) end
                    charConns[p] = p.CharacterAdded:Connect(function()
                        pcall(function() end)
                    end)
                end
            end)
            playerRemovingConn = Players.PlayerRemoving:Connect(function(p)
                if charConns[p] then pcall(function() charConns[p]:Disconnect() end) charConns[p] = nil end
                removeBoxForPlayer(p)
            end)
            pcall(function()
                colorApi = ColorPickerAPI[espBoxesColorPicker] or ColorPickerAPI[playerChamsColorPicker]
                if colorApi then
                    colorApiPrev = colorApi.OnChange
                    colorApi.OnChange = function(c)
                        if colorApiPrev then pcall(colorApiPrev, c) end
                        for _, b in pairs(boxes) do pcall(function() b.Color = c end) end
                    end
                end
            end)
            if not renderConn then renderConn = RunService.RenderStepped:Connect(updateBoxes) end
        end

        local function disableBoxes()
            if renderConn then pcall(function() renderConn:Disconnect() end) renderConn = nil end
            if playerAddedConn then pcall(function() playerAddedConn:Disconnect() end) playerAddedConn = nil end
            if playerRemovingConn then pcall(function() playerRemovingConn:Disconnect() end) playerRemovingConn = nil end
            for p,_ in pairs(charConns) do pcall(function() charConns[p]:Disconnect() end) charConns[p] = nil end
            for p,_ in pairs(boxes) do removeBoxForPlayer(p) end
            pcall(function()
                if colorApi and colorApi.OnChange then
                    colorApi.OnChange = colorApiPrev
                end
                colorApi = nil
                colorApiPrev = nil
            end)
        end

        local api = ToggleAPI[espBoxesToggle]
        if api then
            local prev = api.OnToggle
            api.OnToggle = function(state)
                if prev then pcall(prev, state) end
                if state then pcall(enableBoxes) else pcall(disableBoxes) end
            end
            pcall(function() if api.Get and api.Get() then enableBoxes() end end)
        end

        RegisterUnload(function()
            pcall(disableBoxes)
        end)
    end
end

-- ** ESP Boxes Logic Ends Here **

---------------------------------------------------------------------------

-- ** Glow Chams Logic Starts Here **
do
    local glow = {}
    local glowConns = {}
    local playerAddedConn, playerRemovingConn

    local function getSavedColor()
        local coltbl = GetConfig("visuals.playerChamsColor", nil)
        if type(coltbl) == "table" and coltbl.r and coltbl.g and coltbl.b then
            return Color3.new(coltbl.r, coltbl.g, coltbl.b)
        end
        return COLORS.accent
    end

    local function applyGlowToCharacter(char, intensity)
        if not char or not char:IsA("Model") then return nil end
        local ok, h = pcall(function()
            local inst = Instance.new("Highlight")
            inst.Name = "Vozex_GlowChams"
            inst.Adornee = char
            inst.FillColor = getSavedColor()
            inst.OutlineColor = getSavedColor()
            inst.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            inst.Parent = gui
            local t = math.clamp(1 - (intensity or 50) / 100, 0, 1)
            inst.FillTransparency = t * 0.6 
            inst.OutlineTransparency = t * 0.35 
            local lights = {}
            local function makeLight(part, scale)
                if not part or not part:IsA("BasePart") then return nil end
                local pl = Instance.new("PointLight")
                pl.Name = "Vozex_GlowLight"
                pl.Color = inst.FillColor
                local rng = 6 + (intensity or 50) / 100 * (24 * (scale or 1)) 
                local bri = 1 + (intensity or 50) / 100 * (4 * (scale or 1))   
                pl.Range = rng
                pl.Brightness = bri
                pl.Shadows = false
                pl.Parent = part
                return pl
            end
            local head = char:FindFirstChild("Head")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if head and head:IsA("BasePart") then table.insert(lights, makeLight(head, 1.0)) end
            if hrp and hrp:IsA("BasePart") then table.insert(lights, makeLight(hrp, 0.7)) end
            if #lights == 0 then
                for _,part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then table.insert(lights, makeLight(part, 0.5)); break end
                end
            end
            return {hl = inst, lights = lights}
        end)
        if ok then return h end
        return nil
    end

    local function removeGlowFromPlayer(p)
        if glowConns[p] then
            pcall(function() glowConns[p]:Disconnect() end)
            glowConns[p] = nil
        end
        if glow[p] then
            pcall(function()
                local data = glow[p]
                if data.hl and data.hl.Destroy then data.hl:Destroy() end
                if data.lights and type(data.lights) == "table" then
                    for _,l in ipairs(data.lights) do
                        if l and l.Destroy then pcall(function() l:Destroy() end) end
                    end
                end
            end)
            glow[p] = nil
        end
    end

    local function addGlowToPlayer(p, intensity)
        if not p or p == player then return end
        removeGlowFromPlayer(p)
        if p.Character then
            glow[p] = applyGlowToCharacter(p.Character, intensity)
        end
        glowConns[p] = p.CharacterAdded:Connect(function(c)
            pcall(function() removeGlowFromPlayer(p) end)
            pcall(function() glow[p] = applyGlowToCharacter(c, intensity) end)
        end)
    end

    local function enableGlow()
        disableGlow = disableGlow 
        local intensity = GetConfig("visuals.glowChamsIntensity", 50)
        playerAddedConn = Players.PlayerAdded:Connect(function(p) addGlowToPlayer(p, intensity) end)
        playerRemovingConn = Players.PlayerRemoving:Connect(function(p) removeGlowFromPlayer(p) end)
        for _,p in ipairs(Players:GetPlayers()) do
            addGlowToPlayer(p, intensity)
        end
    end

    local function disableGlow()
        if playerAddedConn then pcall(function() playerAddedConn:Disconnect() end) playerAddedConn = nil end
        if playerRemovingConn then pcall(function() playerRemovingConn:Disconnect() end) playerRemovingConn = nil end
        for p,_ in pairs(glowConns) do
            pcall(function() glowConns[p]:Disconnect() end)
            glowConns[p] = nil
        end
        for p,data in pairs(glow) do
            pcall(function()
                if data and type(data) == "table" then
                    if data.hl and data.hl.Destroy then pcall(function() data.hl:Destroy() end) end
                    if data.lights and type(data.lights) == "table" then
                        for _,l in ipairs(data.lights) do if l and l.Destroy then pcall(function() l:Destroy() end) end end
                    end
                end
            end)
            glow[p] = nil
        end
    end

    local initialIntensity = GetConfig("visuals.glowChamsIntensity", 50)
    local sliderApi = SliderAPI[glowIntensitySlider]
    if sliderApi then
        sliderApi.OnChange = function(v)
            SetConfig("visuals.glowChamsIntensity", v)
            pcall(function()
                for _,data in pairs(glow) do
                            if data and type(data) == "table" then
                                local t = math.clamp(1 - v / 100, 0, 1)
                                if data.hl and data.hl.IsA and data.hl:IsA("Highlight") then
                                    data.hl.FillTransparency = t * 0.6
                                    data.hl.OutlineTransparency = t * 0.35
                                end
                                if data.lights and type(data.lights) == "table" then
                                    for _,l in ipairs(data.lights) do
                                        if l and l.IsA and l:IsA("PointLight") then
                                            l.Range = 6 + v / 100 * 24
                                            l.Brightness = 1 + v / 100 * 4
                                        end
                                    end
                                end
                            end
                        end
            end)
        end
        pcall(function() sliderApi.Set(initialIntensity) end)
    end

    BindToggleToConfig(glowChamsToggle, "visuals.glowChams", false)
    do
        local api = ToggleAPI[glowChamsToggle]
        if api then
            local prev = api.OnToggle
            api.OnToggle = function(state)
                if prev then pcall(prev, state) end
                if state then pcall(enableGlow) else pcall(disableGlow) end
            end
            pcall(function() if api.Get and api.Get() then enableGlow() end end)
        end
    end

    RegisterUnload(function()
        pcall(disableGlow)
    end)
end
-- ** Glow Chams Logic Ends Here **

---------------------------------------------------------------------------

-- ** Close/Open GUI on Keybind logic Starts Here **
do
    local KEY_CONFIG = "settings.closeOpenGuiKey"
    local keyApi = KeybindAPI[closeOpenGuiKeybind]

    pcall(function()
        local saved = GetConfig(KEY_CONFIG, "Insert")
        if keyApi and type(saved) == "string" and Enum.KeyCode[saved] then
            pcall(function() keyApi.Set(Enum.KeyCode[saved]) end)
        end
    end)

    if keyApi then
        keyApi.OnBind = function(k)
            local name = nil
            if typeof(k) == "EnumItem" then
                name = k.Name
            elseif type(k) == "string" then
                name = tostring(k)
            end
            if name then SetConfig(KEY_CONFIG, name) end
        end
    end

    if keyApi then
        keyApi.OnActivate = function()
            if keyApi.IsDisabled and keyApi.IsDisabled() then return end
            pcall(function()
                if root and root.Parent then
                    root.Visible = not root.Visible
                end
            end)
        end
        RegisterUnload(function()
            if keyApi then keyApi.OnActivate = nil end
        end)
    end
end

-- ** Close/Open GUI on Keybind logic Ends Here **

---------------------------------------------------------------------------

-- ** Show GUI on Load logic Starts Here **
do
    local KEY = "settings.showGuiOnLoad"
    local api = ToggleAPI[showGuiOnLoadToggle]

    pcall(function()
        local show = GetConfig(KEY, true)
        if root and root.Parent then root.Visible = not not show end
    end)

    if api then
        local prev = api.OnToggle
        api.OnToggle = function(state)
            if prev then pcall(prev, state) end
            pcall(function() if root and root.Parent then root.Visible = not not state end end)
        end
        pcall(function() if api.Get and api.Get() then root.Visible = true else root.Visible = false end end)
    end
end

-- ** Show GUI on Load logic Ends Here **

---------------------------------------------------------------------------

-- ** Player Health Logic Starts Here **
do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")

    local healthOverlays = {}
    local charConns = {}
    local humConns = {}

    local HEALTH_BASE_W, HEALTH_BASE_H = 140, 12  
    local MAX_CREATE_DISTANCE = 350
    local HEALTH_BAR_MIN_WIDTH = 60
    local HEALTH_BAR_MAX_WIDTH = 140

    local KEY_CONFIG = "settings.showHealthKey"

    local function safeDisconnect(c)
        if c and c.Disconnect then
            pcall(function() c:Disconnect() end)
        end
    end

    local function createHealthBar(p)
        if healthOverlays[p] then return healthOverlays[p] end
        
        local bg = Drawing.new("Square")
        local fill = Drawing.new("Square")
        local text = Drawing.new("Text")
        
        bg.Filled = true
        bg.Thickness = 1
        bg.Color = Color3.fromRGB(30, 30, 30)
        bg.ZIndex = 1
        bg.Visible = false
        
        fill.Filled = true
        fill.Thickness = 0
        fill.Color = Color3.fromRGB(0, 200, 80)
        fill.ZIndex = 2
        fill.Visible = false
        
        text.Center = true
        text.Outline = true
        text.Font = 2
        text.Size = 14  
        text.Color = Color3.new(1, 1, 1)
        text.ZIndex = 3
        text.Visible = false
        
        healthOverlays[p] = {
            bg = bg,
            fill = fill,
            text = text
        }
        
        return healthOverlays[p]
    end

    local function removeHealthBar(p)
        local data = healthOverlays[p]
        if not data then return end
        
        if data.bg then data.bg:Remove() end
        if data.fill then data.fill:Remove() end
        if data.text then data.text:Remove() end
        
        healthOverlays[p] = nil
    end

    local function updateHealthBar(p, data, cam, refPos)
        if not p.Character then 
            data.bg.Visible = false
            data.fill.Visible = false
            data.text.Visible = false
            return 
        end
        
        local root = p.Character.PrimaryPart or p.Character:FindFirstChild("HumanoidRootPart")
        if not root then 
            data.bg.Visible = false
            data.fill.Visible = false
            data.text.Visible = false
            return 
        end
        
        local dist = (root.Position - refPos).Magnitude
        if dist > MAX_CREATE_DISTANCE then
            data.bg.Visible = false
            data.fill.Visible = false
            data.text.Visible = false
            return
        end
        
        local ok, bboxCFrame, bboxSize = pcall(function() 
            return p.Character:GetBoundingBox() 
        end)
        
        if not ok then 
            data.bg.Visible = false
            data.fill.Visible = false
            data.text.Visible = false
            return 
        end
        
        local minX, minY = math.huge, math.huge
        local maxX, maxY = -math.huge, -math.huge
        
        local hx, hy, hz = bboxSize.X / 2, bboxSize.Y / 2, bboxSize.Z / 2
        local corners = {
            bboxCFrame * CFrame.new(-hx, -hy, -hz),
            bboxCFrame * CFrame.new(-hx, -hy,  hz),
            bboxCFrame * CFrame.new(-hx,  hy, -hz),
            bboxCFrame * CFrame.new(-hx,  hy,  hz),
            bboxCFrame * CFrame.new( hx, -hy, -hz),
            bboxCFrame * CFrame.new( hx, -hy,  hz),
            bboxCFrame * CFrame.new( hx,  hy, -hz),
            bboxCFrame * CFrame.new( hx,  hy,  hz),
        }
        
        local anyVisible = false
        for _, cf in ipairs(corners) do
            local screen = cam:WorldToViewportPoint(cf.Position)
            if screen.Z > 0 then
                anyVisible = true
                minX = math.min(minX, screen.X)
                maxX = math.max(maxX, screen.X)
                minY = math.min(minY, screen.Y)
                maxY = math.max(maxY, screen.Y)
            end
        end
        
        if not anyVisible then
            data.bg.Visible = false
            data.fill.Visible = false
            data.text.Visible = false
            return
        end
        
        local espWidth = maxX - minX
        
        local scaleFactor = math.clamp(1 - (dist / MAX_CREATE_DISTANCE) * 0.5, 0.3, 1.0)
        local healthBarWidth = math.clamp(espWidth * 0.8 * scaleFactor, HEALTH_BAR_MIN_WIDTH, HEALTH_BAR_MAX_WIDTH)
        local healthBarHeight = 10  
        
        local centerX = (minX + maxX) / 2
        local yPos = minY - healthBarHeight - 8
        
        local hum = p.Character:FindFirstChildOfClass("Humanoid")
        local pct = hum and math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1) or 0
        
        data.bg.Size = Vector2.new(healthBarWidth, healthBarHeight)
        data.bg.Position = Vector2.new(centerX - healthBarWidth/2, yPos)
        data.bg.Visible = true
        
        local fillWidth = math.max(2, healthBarWidth * pct)
        data.fill.Size = Vector2.new(fillWidth, healthBarHeight)
        data.fill.Position = Vector2.new(centerX - healthBarWidth/2, yPos)
        data.fill.Visible = true
        
        local hp = math.floor((hum and hum.Health) or 0)
        local max = math.floor((hum and hum.MaxHealth) or 0)
        data.text.Text = string.format("%d/%d", hp, max)
        data.text.Position = Vector2.new(centerX, yPos + healthBarHeight/2 - 1)

        local textSize = math.clamp(math.floor(healthBarWidth / 6), 12, 16)  
        data.text.Size = textSize
        data.text.Visible = true
    end

    local renderConn
    local function onRender()
        local cam = workspace.CurrentCamera
        if not cam then return end
        
        local refPos = cam.CFrame.Position
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player == Players.LocalPlayer then continue end
            
            local data = healthOverlays[player]
            
            if not data then
                data = createHealthBar(player)
            end
            
            if data then
                updateHealthBar(player, data, cam, refPos)
            end
        end
    end

    local function addPlayer(p)
        if p == Players.LocalPlayer then return end
        
        charConns[p] = p.CharacterAdded:Connect(function()
            createHealthBar(p)
        end)
        
        humConns[p] = nil
        
        if p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                humConns[p] = hum.HealthChanged:Connect(function()
                end)
            end
        end
        
        local charAddedConn
        charAddedConn = p.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                humConns[p] = hum.HealthChanged:Connect(function()
                end)
            end
        end)
        
        if charConns[p] ~= charAddedConn then
            table.insert(charConns, charAddedConn)
        end
    end

    local function removePlayer(p)
        safeDisconnect(charConns[p])
        charConns[p] = nil
        
        safeDisconnect(humConns[p])
        humConns[p] = nil
        
        removeHealthBar(p)
    end

    local playerAddedConn, playerRemovingConn
    local function enableHealth()
        for _, p in ipairs(Players:GetPlayers()) do
            addPlayer(p)
        end
        
        playerAddedConn = Players.PlayerAdded:Connect(addPlayer)
        playerRemovingConn = Players.PlayerRemoving:Connect(removePlayer)
        
        if not renderConn then
            renderConn = RunService.RenderStepped:Connect(onRender)
        end
    end

    local function disableHealth()
        if renderConn then
            renderConn:Disconnect()
            renderConn = nil
        end
        
        if playerAddedConn then
            playerAddedConn:Disconnect()
            playerAddedConn = nil
        end
        
        if playerRemovingConn then
            playerRemovingConn:Disconnect()
            playerRemovingConn = nil
        end
        
        for p, _ in pairs(charConns) do
            safeDisconnect(charConns[p])
        end
        charConns = {}
        
        for p, _ in pairs(humConns) do
            safeDisconnect(humConns[p])
        end
        humConns = {}
        
        for p, _ in pairs(healthOverlays) do
            removeHealthBar(p)
        end
        healthOverlays = {}
    end

    local api = ToggleAPI[playerHealthToggle]
    if api then
        local prev = api.OnToggle
        api.OnToggle = function(state)
            if prev then pcall(prev, state) end
            if state then enableHealth() else disableHealth() end
        end
        if api.Get and api.Get() then
            enableHealth()
        end
    end

    local keyApi = KeybindAPI[showHealthKeybind]
    if keyApi then
        local saved = GetConfig(KEY_CONFIG, "P")
        if type(saved) == "string" and Enum.KeyCode[saved] then
            keyApi.Set(Enum.KeyCode[saved])
        end
        
        keyApi.OnBind = function(k)
            local name = k.Name or tostring(k)
            SetConfig(KEY_CONFIG, name)
        end
    end

    if keyApi then
        keyApi.OnActivate = function()
            if keyApi.IsDisabled and keyApi.IsDisabled() then return end
            local tapi = ToggleAPI[playerHealthToggle]
            if tapi and tapi.Get and tapi.Set then
                tapi.Set(not tapi.Get())
            end
        end
        RegisterUnload(function()
            if keyApi then keyApi.OnActivate = nil end
            disableHealth()
        end)
    else
        RegisterUnload(function()
            disableHealth()
        end)
    end
end

-- ** Player Health Logic Ends Here **

---------------------------------------------------------------------------

-- ** Aimbot Logic Starts Here **
do
    local KEY_CONFIG = "combat.enableAimbotKey"
    local fovMax = GetConfig("combat.aimbotFOV", 700) or 700
    local leftDown, rightDown = false, false
    local loopConn, inputConnBegin, inputConnEnd, fovDrawConn

    local smoothingEnabled = false
    local smoothingValue = GetConfig("combat.aimbotSmoothing", 1) or 1
    local aimAccumX, aimAccumY = 0, 0
    local teamCheckEnabled = GetConfig("combat.teamCheck", true) or true
    local targetZone = GetConfig("combat.aimbotTargetZone", nil) or (initialZone or 1500)
    local useTargetZone = GetConfig("combat.aimbotTargetZoneEnabled", false) or false
    teammateCache = teammateCache or {}
    local aimHistory = {} 
    local projSpeedLocal = (type(projSpeed) == "number" and projSpeed) or 900
    local leadScaleLocal = (type(leadScale) == "number" and leadScale) or 1
    local aimPredictionEnabled = GetConfig("combat.aimPrediction", false) or false

    local t = ToggleAPI[aimbotToggle]
    if t then
        local p = t.OnToggle
        t.OnToggle = function(s)
            if type(p) == "function" then p(s) end
            makeNotification(s and "Aimbot is ON" or "Aimbot is OFF", 3, nil, "AimbotToggle")
        end
    end

    do
        local Players = game:GetService("Players")
        local attrConns = {}
        local function onPlayerAttrChanged(pl)
            teammateCache[pl] = nil
        end
        Players.PlayerAdded:Connect(function(pl)
            if pl ~= Players.LocalPlayer then
                local ok, conn = pcall(function() return pl:GetAttributeChangedSignal("TeamID"):Connect(function() onPlayerAttrChanged(pl) end) end)
                if ok and conn then attrConns[pl] = conn end
            end
        end)
        Players.PlayerRemoving:Connect(function(pl)
            teammateCache[pl] = nil
            local c = attrConns[pl]
            if c and c.Disconnect then pcall(function() c:Disconnect() end) end
            attrConns[pl] = nil
        end)
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= Players.LocalPlayer then
                local ok, conn = pcall(function() return pl:GetAttributeChangedSignal("TeamID"):Connect(function() onPlayerAttrChanged(pl) end) end)
                if ok and conn then attrConns[pl] = conn end
            end
        end
    end

    if GetConfig("combat.aimbotSmoothing", nil) == nil then SetConfig("combat.aimbotSmoothing", smoothingValue) end
    if GetConfig("combat.aimbotFOV", nil) == nil then SetConfig("combat.aimbotFOV", fovMax) end
    if GetConfig("combat.useAimbotSmoothing", nil) == nil then SetConfig("combat.useAimbotSmoothing", smoothingEnabled) end

    local function safeDisconnect(c)
        if c and c.Disconnect then pcall(function() c:Disconnect() end) end
    end

    local keyApi = KeybindAPI[enableAimbotKeybind]
    pcall(function()
        local saved = GetConfig(KEY_CONFIG, "V")
        if keyApi and type(saved) == "string" and Enum.KeyCode[saved] then pcall(function() keyApi.Set(Enum.KeyCode[saved]) end) end
    end)
    if keyApi then
        keyApi.OnBind = function(k)
            local name = nil
            if typeof(k) == "EnumItem" then name = k.Name elseif type(k) == "string" then name = tostring(k) end
            if name then SetConfig(KEY_CONFIG, name) end
        end

        keyApi.OnActivate = function(k)
            local t = ToggleAPI[aimbotToggle]
            if t and t.Get and t.Set then t.Set(not t.Get()) end
        end
        RegisterUnload(function()
            if keyApi then keyApi.OnActivate = nil end
        end)
    end

    do
        local tApi = ToggleAPI[useAimbotSmoothingToggle]
        local sApi = SliderAPI[smoothingSlider]
        if tApi then
            smoothingEnabled = tApi.Get and tApi.Get() or false
            local prev = tApi.OnToggle
            tApi.OnToggle = function(state)
                if prev then pcall(prev, state) end
                smoothingEnabled = not not state
                SetConfig("combat.useAimbotSmoothing", smoothingEnabled)
                pcall(function() if debugDelayLabel then debugDelayLabel.Show(debugModeEnabled and not smoothingEnabled) end end)
            end
        end
        if sApi then
            smoothingValue = sApi.Get and sApi.Get() or smoothingValue
            sApi.OnChange = function(v)
                smoothingValue = tonumber(v) or smoothingValue
                SetConfig("combat.aimbotSmoothing", smoothingValue)
            end
            pcall(function() sApi.Set(smoothingValue) end)
            pcall(function() if debugDelayLabel then debugDelayLabel.Show(debugModeEnabled and not smoothingEnabled) end end)
        end
    end

    do
        local tApi = ToggleAPI[teamCheckToggle]
        if tApi then
            teamCheckEnabled = tApi.Get and tApi.Get() or teamCheckEnabled
            local prev = tApi.OnToggle
            tApi.OnToggle = function(state)
                if prev then pcall(prev, state) end
                teamCheckEnabled = not not state
                SetConfig("combat.teamCheck", teamCheckEnabled)
                pcall(function()
                    for k in pairs(teammateCache) do teammateCache[k] = nil end
                end)
            end
        end
    end

    do
        local tApi = ToggleAPI[aimPredictionToggle]
        if tApi then
            aimPredictionEnabled = tApi.Get and tApi.Get() or aimPredictionEnabled
            local prev = tApi.OnToggle
            tApi.OnToggle = function(state)
                if prev then pcall(prev, state) end
                aimPredictionEnabled = not not state
                SetConfig("combat.aimPrediction", aimPredictionEnabled)
            end
        end
    end

    do
        local fApi = SliderAPI[aimbotFOVSlider]
        if fApi then
            fovMax = fApi.Get and fApi.Get() or fovMax
            fApi.OnChange = function(v)
                fovMax = tonumber(v) or fovMax
                SetConfig("combat.aimbotFOV", fovMax)
            end
            pcall(function() fApi.Set(fovMax) end)
        end
    end

    do
        local tzApi = SliderAPI[aimbotTargetZoneSlider]
        if tzApi then
            targetZone = tzApi.Get and tonumber(tzApi.Get()) or targetZone
            tzApi.OnChange = function(v)
                targetZone = tonumber(v) or targetZone
                SetConfig("combat.aimbotTargetZone", targetZone)
            end
            pcall(function() tzApi.Set(targetZone) end)
        end
    end

    do
        local tApi = ToggleAPI[aimnbotTargetZoneToggle]
        if tApi then
            useTargetZone = tApi.Get and tApi.Get() or useTargetZone
            local prev = tApi.OnToggle
            tApi.OnToggle = function(s)
                if prev then pcall(prev, s) end
                useTargetZone = not not s
                SetConfig("combat.aimbotTargetZoneEnabled", useTargetZone)
            end
        end
    end

    local drawCircle = nil
    local drawEnabled = false
    do
        local dApi = ToggleAPI[drawFovCircleToggle]
        if dApi then
            drawEnabled = dApi.Get and dApi.Get() or false
            local prev = dApi.OnToggle
            dApi.OnToggle = function(s)
                if prev then pcall(prev, s) end
                drawEnabled = not not s
                pcall(function()
                    if drawEnabled then
                        if not drawCircle and typeof(Drawing) == "table" and Drawing.new then
                            drawCircle = Drawing.new("Circle")
                            drawCircle.Color = Color3.fromRGB(255,255,255)
                            drawCircle.Thickness = 1
                            drawCircle.Filled = false
                            drawCircle.Visible = true
                        end
                        if not fovDrawConn then
                            fovDrawConn = RunService.RenderStepped:Connect(function()
                                if not drawCircle then return end
                                if not drawEnabled then
                                    pcall(function() drawCircle.Visible = false end)
                                    return
                                end
                                local cam = workspace.CurrentCamera
                                if not cam then pcall(function() drawCircle.Visible = false end); return end
                                local vs = cam.ViewportSize
                                pcall(function()
                                    drawCircle.Position = Vector2.new(vs.X * 0.5, vs.Y * 0.5)
                                    drawCircle.Radius = fovMax
                                    drawCircle.Visible = true
                                end)
                            end)
                        end
                    else
                        if fovDrawConn then pcall(function() fovDrawConn:Disconnect() end) fovDrawConn = nil end
                        if drawCircle and drawCircle.Remove then pcall(function() drawCircle:Remove() end) end
                        drawCircle = nil
                    end
                end)
            end
        end
        pcall(function()
            if drawEnabled and not drawCircle and typeof(Drawing) == "table" and Drawing.new then
                drawCircle = Drawing.new("Circle")
                drawCircle.Color = Color3.fromRGB(255,255,255)
                drawCircle.Thickness = 1
                drawCircle.Filled = false
                drawCircle.Visible = true
                if not fovDrawConn then
                    fovDrawConn = RunService.RenderStepped:Connect(function()
                        if not drawCircle then return end
                        if not drawEnabled then pcall(function() drawCircle.Visible = false end); return end
                        local cam = workspace.CurrentCamera
                        if not cam then pcall(function() drawCircle.Visible = false end); return end
                        local vs = cam.ViewportSize
                        pcall(function()
                            drawCircle.Position = Vector2.new(vs.X * 0.5, vs.Y * 0.5)
                            drawCircle.Radius = fovMax
                            drawCircle.Visible = true
                        end)
                    end)
                end
            end
        end)
    end

    local function findClosestHead()
        local cam = workspace.CurrentCamera
        if not cam then return nil end
        local vs = cam.ViewportSize
        local cx, cy = vs.X * 0.5, vs.Y * 0.5
        local best, bestDist = nil, math.huge
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl ~= Players.LocalPlayer then
                local ch = pl.Character
                if ch then
                        local okAlive, aliveRes = pcall(function() return _G.VozexCHT_Aimbot.IsAlive(ch) end)
                        if not okAlive or not aliveRes then continue end
                        local head = ch:FindFirstChild("Head") or ch:FindFirstChild("HumanoidRootPart")
                        if head and head.Position then
                        local isTeammate = false
                        if teamCheckEnabled then
                            local hrp = head
                            if hrp and hrp.Name ~= "HumanoidRootPart" then
                                hrp = head.Parent and head.Parent:FindFirstChild("HumanoidRootPart")
                            end
                            if hrp then
                                local cache = teammateCache[pl]
                                if cache and cache.hrp == hrp then
                                    isTeammate = cache.isTeam
                                else
                                    local function findLabelNow()
                                        local ok, found = pcall(function()
                                            local f = hrp:FindFirstChild("TeammateLabel", true)
                                            if f then return f end
                                            if ch then
                                                f = ch:FindFirstChild("TeammateLabel", true)
                                                if f then return f end
                                            end
                                            local wp = workspace:FindFirstChild(pl.Name)
                                            if wp then
                                                f = wp:FindFirstChild("TeammateLabel", true)
                                                if f then return f end
                                            end
                                            return nil
                                        end)
                                        if ok and found then return found end
                                        return nil
                                    end

                                    local lbl = findLabelNow()
                                    if not lbl then
                                        pcall(function()
                                            if task and task.delay then
                                                task.delay(1, function()
                                                    local late = findLabelNow()
                                                    if late then teammateCache[pl] = { hrp = hrp, isTeam = true } end
                                                end)
                                            else
                                                spawn(function() wait(1) local late = findLabelNow() if late then teammateCache[pl] = { hrp = hrp, isTeam = true } end end)
                                            end
                                        end)
                                        isTeammate = false
                                    else
                                        isTeammate = true
                                        teammateCache[pl] = { hrp = hrp, isTeam = true }
                                    end
                                end
                            end
                        end
                        if not isTeammate then
                            local p = cam:WorldToViewportPoint(head.Position)
                            if p.Z > 0 then
                            local occluded = false
                            if not targetBehindWallsEnabled then
                                pcall(function()
                                    local rp = RaycastParams.new()
                                    rp.FilterType = Enum.RaycastFilterType.Blacklist
                                    rp.FilterDescendantsInstances = { ch }
                                    local origin = cam.CFrame.Position
                                    local direction = head.Position - origin
                                    local ray = workspace:Raycast(origin, direction, rp)
                                    if ray and ray.Instance and not ray.Instance:IsDescendantOf(ch) then
                                        occluded = true
                                    end
                                end)
                            end
                            if not occluded then
                                local dx = p.X - cx
                                local dy = p.Y - cy
                                local dist = math.sqrt(dx*dx + dy*dy)
                                local worldDist = nil
                                pcall(function() worldDist = (head.Position - cam.CFrame.Position).Magnitude end)
                                local tz = tonumber(targetZone) or (initialZone or 900)
                                local passesZone = (not useTargetZone) or (worldDist and worldDist <= tz)
                                if dist < bestDist and dist <= fovMax and passesZone then
                                    bestDist = dist
                                    best = head
                                end
                            end
                            end
                        end
                    end
                end
            end
        end
        return best, bestDist
    end

    local debugModeEnabled = GetConfig("settings.debugMode", false) or false
    local debugTrackerLabel, debugDelayLabel = nil, nil
    local aimbotInfoLabel = nil
    do
        debugTrackerLabel = makeDebugLabel("")
        debugDelayLabel = makeDebugLabel("")
        aimbotInfoLabel = makeDebugLabel("")
        local tApi = ToggleAPI[debugModeToggle]
        if tApi then
            debugModeEnabled = tApi.Get and tApi.Get() or debugModeEnabled
            local prev = tApi.OnToggle
            tApi.OnToggle = function(s)
                if prev then pcall(prev, s) end
                debugModeEnabled = not not s
                if debugTrackerLabel then debugTrackerLabel.Show(debugModeEnabled) end
                if debugDelayLabel then debugDelayLabel.Show(debugModeEnabled and not smoothingEnabled) end
                if aimbotInfoLabel then aimbotInfoLabel.Show(debugModeEnabled) end
            end
        end
        if debugTrackerLabel then debugTrackerLabel.Show(debugModeEnabled) end
        if debugDelayLabel then debugDelayLabel.Show(debugModeEnabled and not smoothingEnabled) end
        if aimbotInfoLabel then aimbotInfoLabel.Show(debugModeEnabled) end
        RegisterUnload(function()
            if debugTrackerLabel then debugTrackerLabel.Destroy() end
            if debugDelayLabel then debugDelayLabel.Destroy() end
            if aimbotInfoLabel then aimbotInfoLabel.Destroy() end
        end)
    end

    local persistentTarget = nil


    local aimbotInfo_lastTime = 0
    local _aim_lastTime = nil
    local function startLoop()
        if loopConn then return end
        loopConn = RunService.RenderStepped:Connect(function()
            local nowDebug = tick()
            local forceActive = (_G.VozexCHT_Aimbot and _G.VozexCHT_Aimbot.ForceActive) or false
            if not leftDown and not forceActive then return end
            local api = ToggleAPI[aimbotToggle]
            local enabled = api and api.Get and api.Get()
            if not enabled and not forceActive then return end
            local cam = workspace.CurrentCamera
            if not cam then return end

            local head = findClosestHead()
            local pApi = ToggleAPI[persistentAimbotToggle]
            local persistentEnabled = pApi and pApi.Get and pApi.Get()
            local now = tick()
            if head and head.Position then
                if persistentEnabled then
                    persistentTarget = { model = head.Parent, player = Players:GetPlayerFromCharacter(head.Parent), lastPos = head.Position, t = now }
                    if type(_G) == "table" and _G.VozexCHT_Aimbot then _G.VozexCHT_Aimbot.PersistentTarget = persistentTarget end
                end
            else
                if persistentEnabled and persistentTarget and persistentTarget.model and persistentTarget.model.Parent then
                    local model = persistentTarget.model
                    local reacquire = model:FindFirstChild("Head") or model:FindFirstChild("UpperTorso") or model:FindFirstChild("HumanoidRootPart")
                    if reacquire and reacquire.Position then
                        head = reacquire
                        persistentTarget.lastPos = reacquire.Position
                        persistentTarget.t = now
                    else
                        local timeout = 3 
                        if persistentTarget.lastPos and (now - (persistentTarget.t or 0) <= timeout) then
                            head = { Position = persistentTarget.lastPos }
                        else
                            persistentTarget = nil
                            if type(_G) == "table" and _G.VozexCHT_Aimbot then _G.VozexCHT_Aimbot.PersistentTarget = nil end
                        end
                    end
                end
            end
            if head and head.Position then
                local predicted = head.Position
                local root = head.Parent and (head.Parent:FindFirstChild("HumanoidRootPart") or head.Parent:FindFirstChild("Torso"))
                local now = tick()
                local frameDt = 0
                if _aim_lastTime then frameDt = now - _aim_lastTime end
                _aim_lastTime = now
                local estVel = nil
                if root and root:IsA("BasePart") then
                    estVel = root.Velocity
                end
                local histId = (head.Parent and head.Parent.Name) or tostring(head)
                local prev = aimHistory[histId]
                if (not estVel or (estVel and estVel.Magnitude < 0.001)) and prev and prev.pos and prev.t then
                    local dt = now - prev.t
                    if dt > 0 and dt <= 0.05 then
                        estVel = (head.Position - prev.pos) / dt
                    end
                end
                aimHistory[histId] = { pos = head.Position, t = now }

                if root and root:IsA("BasePart") then
                    local okDist, dist = pcall(function() return (head.Position - cam.CFrame.Position).Magnitude end)
                    local travel = (type(projSpeedLocal) == "number" and projSpeedLocal) or 900
                    if okDist and dist and travel and travel > 0 then
                        local tt = dist / travel
                        if estVel and aimPredictionEnabled then
                            local dir = (head.Position - cam.CFrame.Position)
                            local dirUnit = (dir.Magnitude > 0) and (dir / dir.Magnitude) or Vector3.new(0,0,0)
                            local forwardComp = estVel:Dot(dirUnit)
                            local lateral = estVel - dirUnit * forwardComp
                            local lateralMag = lateral.Magnitude
                            local leadFactor = 1
                            if tt < 0.04 then
                                leadFactor = 0
                            elseif tt < 0.12 then
                                leadFactor = (tt - 0.04) / (0.12 - 0.04)
                            else
                                leadFactor = 1
                            end
                            predicted = predicted + lateral * tt * leadScaleLocal * leadFactor
                        end
                    end
                end

                local okP, p = pcall(function() return cam:WorldToViewportPoint(predicted) end)
                if not okP or not p then p = nil end
                if (leftDown or forceActive) and persistentEnabled and p and p.Z and p.Z <= 0 then
                    local mousePos = UserInputService:GetMouseLocation()
                    local moveX = p.X - mousePos.X
                    local moveY = p.Y - mousePos.Y
                    mousemoverel(moveX, moveY)
                end
                if (leftDown or forceActive) and p and p.Z and p.Z > 0 then
                    local mousePos = UserInputService:GetMouseLocation()
                    local dx = p.X - mousePos.X
                    local dy = p.Y - mousePos.Y
                    if smoothingEnabled then
                        local dist = math.sqrt(dx*dx + dy*dy)
                        if dist > 0.5 then
                            local fpsScale = 1
                            if frameDt and frameDt > 0 then
                                local raw = 60 * frameDt
                                local scale = math.sqrt(raw)
                                if scale < 0.9 then scale = 0.9 end
                                if scale > 2 then scale = 2 end
                                fpsScale = scale
                            end
                            local sv = tonumber(smoothingValue) or 1
                            if sv <= 0 then sv = 1 end
                            aimAccumX = aimAccumX + (dx / sv)
                            aimAccumY = aimAccumY + (dy / sv)
                            local toMoveX = 0
                            local toMoveY = 0
                            if aimAccumX >= 1 then
                                toMoveX = math.floor(aimAccumX)
                                aimAccumX = aimAccumX - toMoveX
                            elseif aimAccumX <= -1 then
                                toMoveX = math.ceil(aimAccumX)
                                aimAccumX = aimAccumX - toMoveX
                            end
                            if aimAccumY >= 1 then
                                toMoveY = math.floor(aimAccumY)
                                aimAccumY = aimAccumY - toMoveY
                            elseif aimAccumY <= -1 then
                                toMoveY = math.ceil(aimAccumY)
                                aimAccumY = aimAccumY - toMoveY
                            end
                            if toMoveX ~= 0 or toMoveY ~= 0 then
                                toMoveX = math.clamp(toMoveX * fpsScale, -150, 150)
                                toMoveY = math.clamp(toMoveY * fpsScale, -150, 150)
                                mousemoverel(toMoveX, toMoveY)
                            end
                        end
                    else
                        mousemoverel(dx, dy)
                    end
                    if debugModeEnabled and aimbotInfoLabel and (now - (aimbotInfo_lastTime or 0) >= 0.2) then
                        aimbotInfo_lastTime = now
                        local okInfo, info = pcall(function()
                            local info = "Aimbot: "
                            if head and head.Position then
                                local okWorld, worldDist = pcall(function() return (head.Position - cam.CFrame.Position).Magnitude end)
                                local okP2, vp = pcall(function() return cam:WorldToViewportPoint(head.Position) end)
                                local screenDist = 0
                                if okP2 and vp then
                                    local vs = cam.ViewportSize
                                    local cx, cy = vs.X * 0.5, vs.Y * 0.5
                                    local dx2 = vp.X - cx
                                    local dy2 = vp.Y - cy
                                    screenDist = math.sqrt(dx2*dx2 + dy2*dy2)
                                end
                                local occluded = false
                                pcall(function()
                                    local rp = RaycastParams.new()
                                    rp.FilterType = Enum.RaycastFilterType.Blacklist
                                    rp.FilterDescendantsInstances = { head.Parent }
                                    local origin = cam.CFrame.Position
                                    local direction = head.Position - origin
                                    local ray = workspace:Raycast(origin, direction, rp)
                                    if ray and ray.Instance and not ray.Instance:IsDescendantOf(head.Parent) then occluded = true end
                                end)
                                local isTeam = false
                                pcall(function()
                                    if type(_G) == "table" and _G.Vozex_TeamCheck and type(_G.Vozex_TeamCheck.IsTeammate) == "function" then
                                        local pl = Players:GetPlayerFromCharacter(head.Parent)
                                        isTeam = pl and _G.Vozex_TeamCheck.IsTeammate(pl) or false
                                    end
                                end)
                                local name = (head.Parent and head.Parent.Name) or "model"
                                info = info .. string.format("Target=%s | screen=%.1f | world=%.1f | tz=%.1f | fov=%.1f | useTZ=%s | occluded=%s | team=%s", name, screenDist or 0, (worldDist or 0), (targetZone or 0), (fovMax or 0), (useTargetZone and "Y" or "N"), (occluded and "Y" or "N"), (isTeam and "Y" or "N"))
                            else
                                info = info .. string.format("no target | tz=%.1f | fov=%.1f | useTZ=%s", (targetZone or 0), (fovMax or 0), (useTargetZone and "Y" or "N"))
                            end
                            return info
                        end)
                        if okInfo and info and aimbotInfoLabel then pcall(function() aimbotInfoLabel.Set(info) end) end
                    end
                end
            end
            if drawCircle and drawEnabled then
                pcall(function()
                    local vs = cam.ViewportSize
                    drawCircle.Position = Vector2.new(vs.X * 0.5, vs.Y * 0.5)
                    drawCircle.Radius = fovMax
                    drawCircle.Visible = true
                end)
            elseif drawCircle then
                pcall(function() drawCircle.Visible = false end)
            end
        end)
    end

    local function stopLoop()
        safeDisconnect(loopConn)
        loopConn = nil
    end

    inputConnBegin = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            leftDown = true
            startLoop()
        end
        if input.UserInputType == Enum.UserInputType.Keyboard then
        end
    end)

    inputConnEnd = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            leftDown = false
            persistentTarget = nil
            if not leftDown then stopLoop() end
        end
    end)

    RegisterUnload(function()
        safeDisconnect(inputConnBegin)
        safeDisconnect(inputConnEnd)
        safeDisconnect(loopConn)
        if drawCircle and drawCircle.Remove then pcall(function() drawCircle:Remove() end) end
        if playerRemoveConn and playerRemoveConn.Disconnect then pcall(function() playerRemoveConn:Disconnect() end) end
        for p,_ in pairs(teammateCache) do teammateCache[p] = nil end
        if playerCharConns then
            for p, conn in pairs(playerCharConns) do
                pcall(function() if conn and conn.Disconnect then conn:Disconnect() end end)
                playerCharConns[p] = nil
            end
        end
    end)
    _G.VozexCHT_Aimbot = _G.VozexCHT_Aimbot or {}
    _G.VozexCHT_Aimbot.Start = startLoop
    _G.VozexCHT_Aimbot.Stop = stopLoop
    _G.VozexCHT_Aimbot.ForceActive = false
    _G.VozexCHT_Aimbot.IsEnabled = function()
        local api = ToggleAPI[aimbotToggle]
        return api and api.Get and api.Get()
    end
    _G.VozexCHT_Aimbot.Trigger = function()
        if persistentTarget and persistentTarget.model then
            if not _G.VozexCHT_Aimbot.IsAlive(persistentTarget.model) then
                pcall(function() _G.VozexCHT_Aimbot.ClearPersistentTarget() end)
                return
            end
        end
        _G.VozexCHT_Aimbot.ForceActive = true
        pcall(function() _G.VozexCHT_Aimbot.Start() end)
    end
    _G.VozexCHT_Aimbot.Release = function()
        _G.VozexCHT_Aimbot.ForceActive = false
        pcall(function() _G.VozexCHT_Aimbot.Stop() end)
    end
    _G.VozexCHT_Aimbot.GetPersistentTarget = function()
        return persistentTarget
    end
    _G.VozexCHT_Aimbot.HasPersistentTarget = function()
        return persistentTarget ~= nil
    end
    _G.VozexCHT_Aimbot.SetPersistentTarget = function(model)
        if not model then return end
        if not _G.VozexCHT_Aimbot.IsAlive(model) then return end
        persistentTarget = { model = model, player = Players:GetPlayerFromCharacter(model), lastPos = (model:FindFirstChild("Head") and model:FindFirstChild("Head").Position) or (model.PrimaryPart and model.PrimaryPart.Position), t = tick() }
        if type(_G) == "table" and _G.VozexCHT_Aimbot then _G.VozexCHT_Aimbot.PersistentTarget = persistentTarget end
    end

    _G.VozexCHT_Aimbot.IsAlive = function(target)
        local Players = game:GetService("Players")
        local ok, hum
        if type(target) == "string" then
            local pl = Players:FindFirstChild(target)
            if not pl or not pl.Character then return false end
            ok, hum = pcall(function() return pl.Character:FindFirstChildOfClass("Humanoid") end)
        elseif typeof(target) == "Instance" then
            if target:IsA("Player") or target:IsA("PlayerInstance") then
                local pl = target
                if pl.Character then ok, hum = pcall(function() return pl.Character:FindFirstChildOfClass("Humanoid") end) end
            elseif target:IsA("Model") then
                ok, hum = pcall(function() return target:FindFirstChildOfClass("Humanoid") end)
            else
                return false
            end
        elseif type(target) == "table" and target.model then
            ok, hum = pcall(function() return target.model:FindFirstChildOfClass("Humanoid") end)
        else
            return false
        end
        if not ok then return false end
        if not hum then return false end
        if hum.Health == nil then return true end
        return (hum.Health > 0)
    end
    _G.VozexCHT_Aimbot.ClearPersistentTarget = function()
        persistentTarget = nil
        if type(_G) == "table" and _G.VozexCHT_Aimbot then _G.VozexCHT_Aimbot.PersistentTarget = nil end
    end
    _G.VozexCHT_AimAssist = _G.VozexCHT_AimAssist or {}
    _G.VozexCHT_AimAssist.IsHeadInFOV = function(target)
        local headPos = nil
        local headInst = nil
        local Players = game:GetService("Players")
        if type(target) == "string" then
            local pl = Players:FindFirstChild(target)
            if pl and pl.Character then
                headInst = pl.Character:FindFirstChild("Head") or pl.Character:FindFirstChild("UpperTorso") or pl.Character:FindFirstChild("HumanoidRootPart")
                if headInst and headInst.Position then headPos = headInst.Position end
            end
        elseif typeof(target) == "Instance" then
            if target:IsA("Model") then
                headInst = target:FindFirstChild("Head") or target:FindFirstChild("UpperTorso") or target:FindFirstChild("HumanoidRootPart")
                if headInst and headInst.Position then headPos = headInst.Position end
            elseif target:IsA("BasePart") then
                headInst = target
                headPos = target.Position
            end
        elseif typeof(target) == "Vector3" then
            headPos = target
        end

        local cam = workspace.CurrentCamera
        if not cam or not headPos then return false, nil, nil, headInst end

        local p = cam:WorldToViewportPoint(headPos)
        if not p or p.Z <= 0 then return false, nil, nil, headInst end
        local vs = cam.ViewportSize
        local cx, cy = vs.X * 0.5, vs.Y * 0.5
        local dx = p.X - cx
        local dy = p.Y - cy
        local dist = math.sqrt(dx*dx + dy*dy)
        local inFov = (dist <= (fovMax or 0))
        return inFov, dist, Vector2.new(p.X, p.Y), headInst
    end
end

-- ** Aimbot Logic Ends Here ** --

---------------------------------------------------------------------------

-- ** Target Behind Walls Logic Starts Here ** 
targetBehindWallsEnabled = false
do
    local ok, tApi = pcall(function() return ToggleAPI[targetBehindWallsToggle] end)
    if ok and tApi then
        pcall(function() targetBehindWallsEnabled = tApi.Get and tApi.Get() or false end)
        local prev = tApi.OnToggle
        tApi.OnToggle = function(state)
            if prev then pcall(prev, state) end
            targetBehindWallsEnabled = not not state
        end
    end
end

-- ** Target Behind Walls Logic Ends Here ** --

---------------------------------------------------------------------------

-- ** Aim Lock Keybind Logic Starts Here ** --
do
    local KEY_CONFIG = "combat.aimLockKey"

    local api = KeybindAPI[aimLockKeybind]
    if api then
        local saved = GetConfig(KEY_CONFIG, "Q")
        if type(saved) == "string" and Enum.KeyCode[saved] and api.Set then api.Set(Enum.KeyCode[saved]) end

        api.OnBind = function(k)
            local name = nil
            if typeof(k) == "EnumItem" then name = k.Name elseif type(k) == "string" then name = tostring(k) end
            if name then SetConfig(KEY_CONFIG, name) end
        end

        local releaseConn
        api.OnActivate = function()
            if api.IsDisabled and api.IsDisabled() then return end
            if _G.VozexCHT_Aimbot then
                _G.VozexCHT_Aimbot.ForceActive = true
                _G.VozexCHT_Aimbot.Start()
            end
            if releaseConn and releaseConn.Disconnect then releaseConn:Disconnect() end
            releaseConn = UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
                local bound = api.Get and api.Get()
                if bound and input.KeyCode == bound then
                    if _G.VozexCHT_Aimbot then _G.VozexCHT_Aimbot.ForceActive = false end
                    local leftHeld = false
                    if UserInputService.IsMouseButtonPressed then
                        leftHeld = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
                    end
                    if not leftHeld then if _G.VozexCHT_Aimbot then _G.VozexCHT_Aimbot.Stop() end end
                    if releaseConn and releaseConn.Disconnect then releaseConn:Disconnect() end
                    releaseConn = nil
                end
            end)
        end

        RegisterUnload(function()
            if releaseConn and releaseConn.Disconnect then releaseConn:Disconnect() end
            releaseConn = nil
            if type(_G) == "table" and _G.VozexCHT_Aimbot then
                _G.VozexCHT_Aimbot.ForceActive = false
                if type(_G.VozexCHT_Aimbot.Stop) == "function" then _G.VozexCHT_Aimbot.Stop() end
            end
            api.OnActivate = nil
            api.OnBind = nil
        end)
    end

end
-- ** Aim Lock Keybind Logic Ends Here ** --

---------------------------------------------------------------------------

-- ** Show Enemy Weapons Logic Starts Here **
do
    local LocalPlayer = Players.LocalPlayer
    local ViewModels = workspace:FindFirstChild("ViewModels")
    
    if not ViewModels then
        return
    end
    
    local isEnabled = false
    local labels = {}
    local lastUpdate = 0
    local updateInterval = 0.2
    local FirstPersonCache = nil
    local firstPersonCacheTime = 0

    local labelContainer = Instance.new("Frame")
    labelContainer.Name = "EnemyWeaponLabels"
    labelContainer.Size = UDim2.new(0, 200, 0, 140)
    labelContainer.Position = UDim2.new(1, -220, 0, 24)
    labelContainer.AnchorPoint = Vector2.new(0, 0)
    labelContainer.BackgroundColor3 = COLORS.panel
    labelContainer.BackgroundTransparency = 0.04
    labelContainer.Visible = false
    labelContainer.Parent = gui

    local containerCorner = Instance.new("UICorner") containerCorner.CornerRadius = UDim.new(0,6) containerCorner.Parent = labelContainer
    local containerStroke = Instance.new("UIStroke") containerStroke.Color = COLORS.divider containerStroke.Transparency = 0.8 containerStroke.Thickness = 1 containerStroke.Parent = labelContainer

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = labelContainer
    
    local function extractWeaponName(modelName)
        local parts = string.split(modelName, " - ")
        if #parts >= 3 then
            return parts[3]
        elseif #parts >= 2 then
            return parts[2]
        end
        return modelName
    end

    local function normalizeWeaponName(rawName)
        if not rawName or type(rawName) ~= "string" then return rawName end
        local lname = string.lower(rawName)
        for norm, list in pairs(WeaponDefs or {}) do
            if type(list) == "table" then
                for _, alias in ipairs(list) do
                    if type(alias) == "string" and string.lower(alias) == lname then
                        return string.gsub(norm, "_", " ")
                    end
                end
            end
        end
        local key = string.gsub(rawName, " ", "_")
        if WeaponDefs and WeaponDefs[key] then
            return string.gsub(key, "_", " ")
        end
        return rawName
    end
    
    local function extractPlayerName(modelName)
        local parts = string.split(modelName, " - ")
        if #parts >= 1 then
            return parts[1]
        end
        return "Unknown"
    end
    
    local function createWeaponLabel(playerName)
        local label = Instance.new("TextLabel")
        label.Name = "WeaponLabel_" .. playerName
        label.Size = UDim2.new(1, 0, 0, 26)
        label.BackgroundColor3 = COLORS.panelAlt or Color3.fromRGB(18,18,18)
        label.BackgroundTransparency = 0
        label.Font = Enum.Font.GothamSemibold
        label.TextSize = 13
        label.TextColor3 = COLORS.text
        label.Text = ""
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.LayoutOrder = #labelContainer:GetChildren()
        label.Visible = false
        label.Parent = labelContainer

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = label

        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 8)
        padding.PaddingRight = UDim.new(0, 8)
        padding.Parent = label

        local stroke = Instance.new("UIStroke")
        stroke.Color = COLORS.divider
        stroke.Thickness = 1
        stroke.Transparency = 0.85
        stroke.Parent = label

        return label
    end
    
    local function updateWeaponDisplay()
        if not isEnabled then return end
        
        local currentTime = tick()
        if currentTime - lastUpdate < updateInterval then return end
        lastUpdate = currentTime
        
        local activePlayers = {}
        
        for _, weapon in pairs(ViewModels:GetChildren()) do
            if weapon:IsA("Model") then
                local playerName = extractPlayerName(weapon.Name)
                local weaponName = extractWeaponName(weapon.Name)
                
                if playerName == LocalPlayer.Name then
                    continue
                end
                
                local player = Players:FindFirstChild(playerName)
                if not player then
                    continue
                end

                local isTeammate = false
                if _G and _G.Vozex_TeamCheck and type(_G.Vozex_TeamCheck.IsTeammate) == "function" then
                    pcall(function() isTeammate = _G.Vozex_TeamCheck.IsTeammate(player) end)
                end
                if isTeammate then
                    continue
                end
                
                local displayName = normalizeWeaponName(weaponName)
                activePlayers[playerName] = displayName
                
                if not labels[playerName] then
                    labels[playerName] = createWeaponLabel(playerName)
                end
                
                local label = labels[playerName]
                label.Text = playerName .. " | " .. displayName
                label.Visible = true
            end
        end
        
        for playerName, label in pairs(labels) do
            if not activePlayers[playerName] then
                label.Visible = false
            end
        end
    end
    
    local function enableWeaponDisplay()
        if isEnabled then return end
        
        isEnabled = true
        labelContainer.Visible = true
        
        local updateConnection = RunService.Heartbeat:Connect(updateWeaponDisplay)
        
        _G.VozexCHTUI.RegisterUnload(function()
            isEnabled = false
            labelContainer.Visible = false
            updateConnection:Disconnect()
            for _, label in pairs(labels) do
                label:Destroy()
            end
            labels = {}
            if labelContainer and labelContainer.Parent then
                labelContainer:Destroy()
            end
        end)
    end
    
    local function disableWeaponDisplay()
        if not isEnabled then return end
        
        isEnabled = false
        labelContainer.Visible = false
        for _, label in pairs(labels) do
            label.Visible = false
        end
    end
    
    local function onToggleChanged(state)
        if state then
            enableWeaponDisplay()
        else
            disableWeaponDisplay()
        end
    end
    
    local initialEnabled = GetConfig("visuals.showEnemyWeapons", false)
    onToggleChanged(initialEnabled)
    
    local toggleAPI = ToggleAPI[showEnemyWeaponsToggle]
    if toggleAPI then
        local prev = toggleAPI.OnToggle
        toggleAPI.OnToggle = function(state)
            if prev then pcall(prev, state) end
            onToggleChanged(state)
        end
    end

    local function GetEnemyHeldWeapon(playerOrName)
        local target = playerOrName
        if type(target) == "string" then target = Players:FindFirstChild(target) end
        if not target or target == LocalPlayer then return nil end
        for _, vm in ipairs(ViewModels:GetChildren()) do
            if vm:IsA("Model") then
                local pn = extractPlayerName(vm.Name)
                if pn == target.Name then
                    local raw = extractWeaponName(vm.Name)
                    local norm = normalizeWeaponName(raw)
                    return norm, raw, vm
                end
            end
        end
        return nil
    end

    local function GetAllEnemyHeldWeapons()
        local out = {}
        for _, vm in ipairs(ViewModels:GetChildren()) do
            if vm:IsA("Model") then
                local pn = extractPlayerName(vm.Name)
                local raw = extractWeaponName(vm.Name)
                out[pn] = { Normalized = normalizeWeaponName(raw), Raw = raw }
            end
        end
        return out
    end

    local function GetLocalPlayerHeldWeapon()
        if not LocalPlayer then return nil end
        local now = tick()
        if not FirstPersonCache or (now - firstPersonCacheTime) > 0.2 then
            FirstPersonCache = ViewModels:FindFirstChild("FirstPerson")
            firstPersonCacheTime = now
        end
        if not FirstPersonCache then return nil end
        for _, child in ipairs(FirstPersonCache:GetChildren()) do
            if child:IsA("Model") then
                local raw = extractWeaponName(child.Name)
                local norm = normalizeWeaponName(raw)
                return norm, raw, child
            end
        end
        return nil
    end

    pcall(function()
        if type(_G) == "table" and _G.VozexCHTUI then
            _G.VozexCHTUI.ShowEnemyWeapons = _G.VozexCHTUI.ShowEnemyWeapons or {}
            _G.VozexCHTUI.ShowEnemyWeapons.GetEnemyHeldWeapon = GetEnemyHeldWeapon
            _G.VozexCHTUI.ShowEnemyWeapons.GetAllEnemyHeldWeapons = GetAllEnemyHeldWeapons
            _G.VozexCHTUI.ShowEnemyWeapons.GetLocalPlayerHeldWeapon = GetLocalPlayerHeldWeapon
        end
    end)
end

-- ** Show Enemy Weapons Logic Ends Here ** --

---------------------------------------------------------------------------

-- ** Sixth Sense Logic Starts Here ** --
do
    local labels = {}
    local labelCount = 0
    local childAddedConn, childRemovedConn, renderConn
    local pendingQueue = {}
    local pendingSet = {}
    local queueConn = nil
    local PROCESS_BATCH = 50
    local displayName = ("Subspace_Tripmine"):gsub("_"," ")
    local MAX_LABELS = 50
    local MAX_DIST = 300

    local function isTripminePart(part)
        if not part or not part:IsA("BasePart") then return false end
        local vm = Workspace:FindFirstChild("ViewModels")
        if vm and part:IsDescendantOf(vm) then return false end
        local cam = Workspace.CurrentCamera
        if cam and part:IsDescendantOf(cam) then return false end
        local name = string.lower(part.Name or "")
        if string.find(name, "tripmine") then return true end
        local anc = part:FindFirstAncestorOfClass("Model")
        if anc and string.find(string.lower(anc.Name or ""), "tripmine") then return true end
        return false
    end

    local function makeLabel(part)
        if labels[part] then return end
        if labelCount >= MAX_LABELS then return end
        if localPlayer and localPlayer.Character and part:IsDescendantOf(localPlayer.Character) then return end
        local cam = Workspace.CurrentCamera
        if cam and (part.Position - cam.CFrame.Position).Magnitude > MAX_DIST then return end

        local txt = Drawing.new("Text")
        part:SetAttribute("Vozex_Trap", true)
        part:SetAttribute("Vozex_TrapName", displayName)
        txt.Text = displayName
        txt.Size = 18
        txt.Color = (COLORS and COLORS.accent) or Color3.fromRGB(255,120,120)
        txt.Center = true
        txt.Outline = true
        txt.Visible = false
        labels[part] = txt
        labelCount = labelCount + 1
    end

    local function removeLabel(part)
        local d = labels[part]
        if not d then return end
        if d.Remove then d:Remove() end
        labels[part] = nil
        labelCount = labelCount - 1
        if part.SetAttribute then
            part:SetAttribute("Vozex_Trap", nil)
            part:SetAttribute("Vozex_TrapName", nil)
        end
    end

    local function scanAndCreate()
        local descs = Workspace:GetDescendants()
        task.spawn(function()
            for i = 1, #descs do
                if labelCount >= MAX_LABELS then break end
                local obj = descs[i]
                if obj and obj:IsA("BasePart") and isTripminePart(obj) then
                    if not pendingSet[obj] and not labels[obj] then
                        pendingSet[obj] = true
                        pendingQueue[#pendingQueue + 1] = obj
                    end
                end
                if (i % PROCESS_BATCH) == 0 then task.wait() end
            end
        end)
    end

    local function onDescendantAdded(desc)
        if desc:IsA("BasePart") then
            if isTripminePart(desc) and not pendingSet[desc] and not labels[desc] then
                pendingSet[desc] = true
                pendingQueue[#pendingQueue + 1] = desc
            end
        else
            task.spawn(function()
                for _, d in ipairs(desc:GetDescendants()) do
                    if labelCount >= MAX_LABELS then break end
                    if d:IsA("BasePart") and isTripminePart(d) and not pendingSet[d] and not labels[d] then
                        pendingSet[d] = true
                        pendingQueue[#pendingQueue + 1] = d
                    end
                end
            end)
        end
    end

    local function onDescendantRemoving(desc)
        if desc:IsA("BasePart") then
            removeLabel(desc)
        else
            for _, d in ipairs(desc:GetDescendants()) do
                if d:IsA("BasePart") then removeLabel(d) end
            end
        end
    end

    local function enable()
        if renderConn then return end
        scanAndCreate()
        childAddedConn = Workspace.DescendantAdded:Connect(onDescendantAdded)
        if Workspace.DescendantRemoving then childRemovedConn = Workspace.DescendantRemoving:Connect(onDescendantRemoving) end
        if not queueConn then
            queueConn = RunService.Heartbeat:Connect(function()
                if labelCount >= MAX_LABELS then return end
                local cam = Workspace.CurrentCamera
                local camPos = cam and cam.CFrame.Position or nil
                local toProcess = math.min(PROCESS_BATCH, #pendingQueue)
                for i = 1, toProcess do
                    local part = table.remove(pendingQueue, 1)
                    if part then pendingSet[part] = nil end
                    if not part or not part.Parent then
                    else
                        if isTripminePart(part) and not (camPos and (part.Position - camPos).Magnitude > MAX_DIST) then
                            makeLabel(part)
                        end
                    end
                    if labelCount >= MAX_LABELS then break end
                end
            end)
        end
        renderConn = RunService.RenderStepped:Connect(function()
            local cam = Workspace.CurrentCamera
            if not cam then
                for _, d in pairs(labels) do d.Visible = false end
                return
            end
            local camPos = cam.CFrame.Position
            for part, draw in pairs(labels) do
                if not part or not part.Parent then
                    removeLabel(part)
                else
                    local p, onScreen = cam:WorldToViewportPoint(part.Position)
                    if not onScreen or p.Z <= 0 or (part.Position - camPos).Magnitude > MAX_DIST then
                        draw.Visible = false
                    else
                        local dist = (part.Position - camPos).Magnitude
                        local ratio = math.clamp(50 / math.max(dist, 1), 0.125, 1)
                        draw.Size = math.floor(math.clamp(math.floor(32 * ratio), 12, 32))
                        draw.Position = Vector2.new(p.X, p.Y)
                        draw.Visible = true
                    end
                end
            end
        end)
    end

    local function disable()
        if renderConn then renderConn:Disconnect() renderConn = nil end
        if childAddedConn then childAddedConn:Disconnect() childAddedConn = nil end
        if childRemovedConn then childRemovedConn:Disconnect() childRemovedConn = nil end
        if queueConn then queueConn:Disconnect() queueConn = nil end
        pendingQueue = {}
        for p, _ in pairs(labels) do removeLabel(p) end
        labels = {}
        labelCount = 0
    end

    if GetConfig("combat.sixthSense", false) then enable() end

    local api = ToggleAPI and ToggleAPI[sixthSenseToggle]
    if api then
        local prev = api.OnToggle
        api.OnToggle = function(state)
            if prev then prev(state) end
            if state then enable() else disable() end
        end
        api.Set(GetConfig("combat.sixthSense", false))
    end

    if type(_G) == "table" and _G.VozexCHTUI and type(_G.VozexCHTUI.RegisterUnload) == "function" then
        _G.VozexCHTUI.RegisterUnload(disable)
    else
        RegisterUnload(disable)
    end
end

-- ** Katana Detection
do
    local api = (_G and _G.VozexCHTUI and _G.VozexCHTUI.ShowEnemyWeapons) or nil
    local katanaConn = nil
    local katanaExpiry = 0
    local KATANA_DIST = 150
    local KATANA_TIME = 1.0

    local katanaLabelApi = nil

    local function removeKatanaDraw()
        if katanaLabelApi and type(katanaLabelApi.Destroy) == "function" then
            katanaLabelApi:Destroy()
            katanaLabelApi = nil
        end
    end

    local function showKatanaMessage()
        if type(_G) == "table" and _G.VozexTopLabel and type(_G.VozexTopLabel.New) == "function" then
            if not katanaLabelApi then
                katanaLabelApi = _G.VozexTopLabel.New("Enemy is holding Katana!", {TextSize = 18})
                if katanaLabelApi.SetColor3 and COLORS and COLORS.accent then
                    katanaLabelApi:SetColor3(COLORS.accent)
                end
            else
                if katanaLabelApi.SetText then katanaLabelApi:SetText("Enemy is holding Katana!") end
            end
            katanaExpiry = tick() + KATANA_TIME
        end
    end

    local function checkAndHideKatana()
        if katanaLabelApi and tick() > katanaExpiry then
            katanaLabelApi:Destroy()
            katanaLabelApi = nil
        end
    end

    local function detectKatana()
        if not GetConfig("combat.sixthSense", false) then
            removeKatanaDraw()
            return
        end

        local lp = Players.LocalPlayer
        local lpchar = lp and lp.Character
        local lpRoot = lpchar and (lpchar.PrimaryPart or lpchar:FindFirstChild("HumanoidRootPart"))
        if not lpRoot then
            checkAndHideKatana()
            return
        end

        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= lp then
                local isTeam = false
                if _G and _G.Vozex_TeamCheck and type(_G.Vozex_TeamCheck.IsTeammate) == "function" then
                    pcall(function() isTeam = _G.Vozex_TeamCheck.IsTeammate(pl) end)
                end
                if isTeam then continue end

                local norm, raw, vm
                if api and type(api.GetEnemyHeldWeapon) == "function" then
                    norm, raw, vm = api.GetEnemyHeldWeapon(pl)
                else
                    for _, m in ipairs((workspace:FindFirstChild("ViewModels") or {}):GetChildren()) do
                        if m:IsA("Model") then
                            local pn = string.split(m.Name, " - ")[1]
                            if pn == pl.Name then
                                raw = (function()
                                    local parts = string.split(m.Name, " - ")
                                    if #parts >= 3 then return parts[3] elseif #parts >= 2 then return parts[2] end
                                    return m.Name
                                end)()
                                norm = raw
                                vm = m
                                break
                            end
                        end
                    end
                end

                if raw and (string.find(string.lower(raw), "katana") or (norm and string.find(string.lower(tostring(norm)), "katana"))) then
                    local ch = pl.Character
                    if ch and ch.Parent then
                        local hrp = ch.PrimaryPart or ch:FindFirstChild("HumanoidRootPart")
                        if hrp and (lpRoot.Position - hrp.Position).Magnitude <= KATANA_DIST then
                            local dir = (lpRoot.Position - hrp.Position)
                            if dir.Magnitude > 0 then
                                local dirUnit = dir.Unit
                                local forward = hrp.CFrame.LookVector
                                local dot = forward:Dot(dirUnit)
                                if dot >= 0.3 then
                                    showKatanaMessage()
                                    return
                                end
                            end
                        end
                    end
                end
            end
        end

        checkAndHideKatana()
    end

    katanaConn = RunService.Heartbeat:Connect(detectKatana)

    local function cleanupKatana()
        if katanaConn and katanaConn.Disconnect then pcall(function() katanaConn:Disconnect() end) end
        removeKatanaDraw()
    end

    if type(_G) == "table" and _G.VozexCHTUI and type(_G.VozexCHTUI.RegisterUnload) == "function" then
        _G.VozexCHTUI.RegisterUnload(cleanupKatana)
    else
        RegisterUnload(cleanupKatana)
    end
end

-- ** Sixth Sense Logic Ends Here ** --

---------------------------------------------------------------------------

-- ** Debug Config Logic Starts Here ** --
do
    local MAX_LINES = 8
    local REFRESH_RATE = 1.5
    local collapse = {}
    local buffer = {}
    local lastUpdate = 0
    local visible = false
    local drawBg = nil
    local drawText = nil
    local posConn = nil
    local SHIFT_LEFT = 400
    
    local hbConn

    local function fmt(v)
        if v == nil then return "nil" end
        if type(v) == "boolean" then return (v and "on" or "off") end
        if type(v) == "string" then return v end
        if type(v) == "number" then return tostring(v) end
        if typeof and typeof(v) == "EnumItem" then return v.Name end
        return tostring(v)
    end

    local keys = {}
    local function isPrimitive(val)
        local t = type(val)
        if t == "boolean" or t == "number" or t == "string" then return true end
        if typeof and typeof(val) == "EnumItem" then return true end
        return false
    end

    local function humanize(key)
        local lbl = tostring(key):gsub("[_%./]", " ")
        lbl = lbl:gsub("%s+", " ")
        lbl = lbl:gsub("^%l", string.upper)
        return lbl
    end

    local function flatten(tbl, prefix)
        prefix = prefix or ""
        if type(tbl) ~= "table" then return end
        for k,v in pairs(tbl) do
            local full = (prefix == "") and tostring(k) or (prefix .. "." .. tostring(k))
            if isPrimitive(v) then
                table.insert(keys, { key = full, label = humanize(full), cfg = v })
            elseif type(v) == "table" then
                flatten(v, full)
            end
        end
    end

    flatten(Config)
    MAX_LINES = math.min(32, math.max(8, #keys))

    local function getRuntime(entry)
        local function tryTable(t)
            if type(t) ~= "table" then return nil end
            for _, api in pairs(t) do
                if type(api) == "table" and api.Get and type(api.Get) == "function" then
                    local v = api.Get()
                    if entry.cfg == nil then
                        if v ~= nil then return v end
                    else
                        if type(v) == type(entry.cfg) then return v end
                    end
                end
            end
            return nil
        end

        local v = tryTable(ToggleAPI)
        if v == nil then v = tryTable(SliderAPI) end
        if v == nil then v = tryTable(KeybindAPI) end
        return v
    end

    local function scanConfig()
        local out = {}
        for _, e in ipairs(keys) do
            local cfgv = e.cfg
            if GetConfig then cfgv = GetConfig(e.key, nil) end
            local runtime = getRuntime(e)
            table.insert(out, {label = e.label, key = e.key, cfg = cfgv, runtime = runtime})
        end
        return out
    end

    local function makeUI()
        drawBg = Drawing.new("Square")
        drawBg.Filled = true
        drawBg.Color = COLORS.panel
        drawBg.Transparency = 0.04
        drawBg.Size = Vector2.new(320, 24 + MAX_LINES * 18)
        drawBg.Visible = false
        drawBg.ZIndex = 9998

        drawText = Drawing.new("Text")
        drawText.Size = 14
        drawText.Color = COLORS.text
        drawText.Outline = true
        drawText.Center = false
        drawText.Text = ""
        drawText.Visible = false
        drawText.ZIndex = 9999

        posConn = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            if cam then
                local vs = cam.ViewportSize
                local margin = 8
                local desiredW = 320
                local availW = math.max(64, vs.X - margin*2)
                local w = math.min(desiredW, availW)
                drawBg.Size = Vector2.new(w, drawBg.Size.Y)
                local x = vs.X - margin - w - SHIFT_LEFT
                local y = margin
                if x < 0 then x = margin end
                drawBg.Position = Vector2.new(x, y)
                drawText.Position = Vector2.new(x + 8, y + 2)
            else
                drawBg.Position = Vector2.new(400, 8)
                drawText.Position = Vector2.new(408, 10)
            end
        end)
    end

    local function push(msg)
        if not msg then return end
        if buffer[#buffer] == msg then
            collapse[msg] = (collapse[msg] or 1) + 1
        else
            table.insert(buffer, msg)
        end
        while #buffer > MAX_LINES do table.remove(buffer, 1) end
    end

    local function buildMessages(list)
        for _, v in ipairs(list) do
            local cfgv = v.cfg
            local runv = v.runtime

            if cfgv == nil and runv == nil then

            elseif cfgv == nil and runv ~= nil then
                push(string.format("%s not present in config; runtime is %s", v.label, fmt(runv)))

            else
                if runv == nil then
                    push(string.format("%s is %s in config, but not present at runtime", v.label, fmt(cfgv)))
                else
                    local same = false
                    if type(cfgv) == type(runv) and cfgv == runv then
                        same = true
                    else
                        if tostring(cfgv) == tostring(runv) then same = true end
                    end

                    if same then
                        push(string.format("%s is %s in config and runtime (ok)", v.label, fmt(cfgv)))
                    else
                        push(string.format("%s is %s in config, but runtime is %s ; config didn't apply", v.label, fmt(cfgv), fmt(runv)))
                    end
                end
            end
        end
    end

    local function render()
        if not drawText then return end
        local lines = {}
        for i, s in ipairs(buffer) do
            local cnt = collapse[s]
            if cnt and cnt > 1 then
                s = string.format("%s  (x%d)", s, cnt)
            end
            table.insert(lines, s)
        end
        local text = (#lines > 0) and table.concat(lines, "\n") or ""
        drawText.Text = text
        drawText.Visible = text ~= ""
        drawBg.Visible = drawText.Visible
    end

    local function refresh()
        local now = tick()
        if now - lastUpdate < REFRESH_RATE then return end
        lastUpdate = now
        collapse = {}
        buffer = {}
        local list = scanConfig()
        buildMessages(list)
        render()
    end

    local function show(b)
        if b and not drawText then makeUI() end
        if drawText then drawText.Visible = b end
        if drawBg then drawBg.Visible = b end
        visible = b
        if b and not hbConn then
            hbConn = RunService.Heartbeat:Connect(function()
                refresh()
            end)
        elseif not b and hbConn then
            hbConn:Disconnect()
            hbConn = nil
        end
    end

    do
        local foundApi = nil
        if ToggleAPI then
            for frame, api in pairs(ToggleAPI) do
                if frame and type(frame) == "userdata" and frame:IsA("Frame") then
                    for _, child in ipairs(frame:GetChildren()) do
                        if child:IsA("TextLabel") and child.Text == "Debug Config" then
                            foundApi = api
                            break
                        end
                    end
                end
                if foundApi then break end
            end
        end

        if foundApi then
            local prev = foundApi.OnToggle
            foundApi.OnToggle = function(state)
                if prev then prev(state) end
                show(not not state)
            end
            if foundApi.Get and foundApi.Get() then show(true) else show(false) end
        else
            if GetConfig and GetConfig("settings.debugConfig", false) then show(true) end
        end
    end

    RegisterUnload(function()
        if hbConn and hbConn.Disconnect then hbConn:Disconnect() end
        if posConn and posConn.Disconnect then posConn:Disconnect() end
        if drawText and drawText.Remove then drawText:Remove() end
        if drawBg and drawBg.Remove then drawBg:Remove() end
    end)
end

-- ** Debug Config Logic Ends Here ** --

---------------------------------------------------------------------------

-- ** Auto Shoot Logic Starts Here ** --
do
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")

    local autoConn = nil
    local firing = false
    local lastInFov = 0
    local FOV_MISS_TIMEOUT = 1.5

    local KEY_CONFIG = "combat.enableAutoShootKey"
    local keyConn = nil
    
    local debugLabel = makeDebugLabel("AutoShoot: OFF")
    local lastDebugMsg = nil
    local persistentEngaged = false
    local katanaBlocked = false

    do
        local api = KeybindAPI[aimLockKeybind]
        local saved = GetConfig("combat.aimLockKey", "Q")
        if api and type(saved) == "string" and Enum.KeyCode[saved] then
            api.Set(Enum.KeyCode[saved])
        end
        if api then
            api.OnBind = function(k)
                local name = nil
                if typeof(k) == "EnumItem" then name = k.Name elseif type(k) == "string" then name = tostring(k) end
                if name then SetConfig("combat.aimLockKey", name) end
            end
        end
    end

    do
        local keyApi = KeybindAPI[enableAutoShootKeybind]
        local saved = GetConfig(KEY_CONFIG, "Y")
        if keyApi and type(saved) == "string" and Enum.KeyCode[saved] then keyApi.Set(Enum.KeyCode[saved]) end
        if keyApi then
            keyApi.OnBind = function(k)
                local name = nil
                if typeof(k) == "EnumItem" then name = k.Name elseif type(k) == "string" then name = tostring(k) end
                if name then SetConfig(KEY_CONFIG, name) end
            end
            keyApi.OnActivate = function()
                if keyApi.IsDisabled and keyApi.IsDisabled() then return end
                local now = tick()
                local last = keyApi._lastToggleTime or 0
                if now - last < 0.15 then return end
                keyApi._lastToggleTime = now
                local tApi = ToggleAPI[autoShootToggle]
                local cur = (tApi and tApi.Get and tApi.Get()) or GetConfig("combat.autoShoot", false)
                local newState = not cur
                if tApi and tApi.Set then
                    tApi.Set(newState)
                else
                    SetConfig("combat.autoShoot", newState)
                end
            end
            RegisterUnload(function()
                if keyApi then keyApi.OnActivate = nil end
            end)
        end
    end

    local function isHeadInFOV(headInst)
        if not headInst or not headInst.Position then return false, nil end
        local cam = workspace.CurrentCamera
        if not cam then return false, nil end
        local p = cam:WorldToViewportPoint(headInst.Position)
        if not p or p.Z <= 0 then return false, nil end
        local vs = cam.ViewportSize
        local cx, cy = vs.X * 0.5, vs.Y * 0.5
        local dx = p.X - cx
        local dy = p.Y - cy
        local dist = math.sqrt(dx*dx + dy*dy)
        local fovRadius = GetConfig("combat.aimbotFOV", 700) or 700
        return (dist <= fovRadius), dist
    end

    local function isHoldingKatana(playerOrNil)
        if not playerOrNil then return false end
        if type(_G) == "table" and _G.VozexCHTUI and _G.VozexCHTUI.ShowEnemyWeapons and type(_G.VozexCHTUI.ShowEnemyWeapons.GetEnemyHeldWeapon) == "function" then
            local ok, norm, raw = pcall(function() return _G.VozexCHTUI.ShowEnemyWeapons.GetEnemyHeldWeapon(playerOrNil) end)
            if ok and (type(norm) == "string" or type(raw) == "string") then
                local sraw = (type(raw) == "string") and string.lower(raw) or ""
                local snorm = (type(norm) == "string") and string.lower(norm) or ""
                if string.find(sraw, "katana") or string.find(snorm, "katana") then
                    return true
                end
            end
        end
        return false
    end

    local function isHoldingRiotShield(playerOrNil)
        if not playerOrNil or playerOrNil == Players.LocalPlayer then
            if type(_G) == "table" and _G.VozexCHTUI and _G.VozexCHTUI.ShowEnemyWeapons and type(_G.VozexCHTUI.ShowEnemyWeapons.GetLocalPlayerHeldWeapon) == "function" then
                local ok, norm, raw = pcall(function() return _G.VozexCHTUI.ShowEnemyWeapons.GetLocalPlayerHeldWeapon() end)
                if ok then
                    local sraw = (type(raw) == "string") and string.lower(raw) or ""
                    local snorm = (type(norm) == "string") and string.lower(norm) or ""
                    if string.find(sraw, "riot shield") or string.find(snorm, "riot shield") or string.find(sraw, "shield") or string.find(snorm, "shield") then
                        return true
                    end
                end
            end
        else
            if type(_G) == "table" and _G.VozexCHTUI and _G.VozexCHTUI.ShowEnemyWeapons and type(_G.VozexCHTUI.ShowEnemyWeapons.GetEnemyHeldWeapon) == "function" then
                local ok, norm, raw = pcall(function() return _G.VozexCHTUI.ShowEnemyWeapons.GetEnemyHeldWeapon(playerOrNil) end)
                if ok then
                    local sraw = (type(raw) == "string") and string.lower(raw) or ""
                    local snorm = (type(norm) == "string") and string.lower(norm) or ""
                    if string.find(sraw, "riot shield") or string.find(snorm, "riot shield") or string.find(sraw, "shield") or string.find(snorm, "shield") then
                        return true
                    end
                end
            end
        end
        return false
    end

    local function isVisibleToCamera(headInst)
        if not headInst or not headInst.Parent then return false end
        local cam = workspace.CurrentCamera
        if not cam then return false end
        
        local rp = RaycastParams.new()
        rp.FilterType = Enum.RaycastFilterType.Blacklist
        rp.FilterDescendantsInstances = {headInst.Parent}
        
        local origin = cam.CFrame.Position
        local direction = headInst.Position - origin
        local ray = workspace:Raycast(origin, direction, rp)
        
        if ray and ray.Instance and not ray.Instance:IsDescendantOf(headInst.Parent) then
            return false
        end
        
        return true
    end

    local function isHoldingSniper()
        if type(_G) == "table" and _G.VozexCHTUI and _G.VozexCHTUI.ShowEnemyWeapons and type(_G.VozexCHTUI.ShowEnemyWeapons.GetLocalPlayerHeldWeapon) == "function" then
            local ok, norm, raw = pcall(function() return _G.VozexCHTUI.ShowEnemyWeapons.GetLocalPlayerHeldWeapon() end)
            if ok and norm and string.find(string.lower(norm), "sniper") then
                return true
            end
        end
        return false
    end

    local rightClickPressTime = nil
    local rightClickConn = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            rightClickPressTime = tick()
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            rightClickPressTime = nil
        end
    end)

    local function checkAndFire()
        local autoShootEnabled = GetConfig("combat.autoShoot", false)
        if not autoShootEnabled then 
            if firing then
                mouse1release()
                firing = false
                if _G and _G.VozexCHT_Aimbot then
                    _G.VozexCHT_Aimbot.ForceActive = false
                    _G.VozexCHT_Aimbot.Stop()
                end
            end
            if debugLabel then debugLabel.Set("AutoShoot: OFF (disabled)") end
            return 
        end
        
        local debugMsg = "AutoShoot: Scanning..."
        local found = nil
        local persistentEnabled = GetConfig("combat.persistentAimbot", false)

        if not found then
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= Players.LocalPlayer then
                    local isTeam = false
                    if _G and _G.Vozex_TeamCheck and type(_G.Vozex_TeamCheck.IsTeammate) == "function" then
                        isTeam = _G.Vozex_TeamCheck.IsTeammate(pl)
                    end
                    if isTeam then continue end

                    local char = pl.Character
                    if not char then continue end
                    local okAlive, aliveRes = pcall(function() return _G.VozexCHT_Aimbot.IsAlive(char) end)
                    if not okAlive or not aliveRes then continue end

                    local headInst = char:FindFirstChild("Head") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
                    if not headInst then continue end

                    local inFov, screenDist = isHeadInFOV(headInst)

                    if inFov then
                        debugMsg = "AutoShoot: " .. pl.Name .. " in FOV (dist=" .. tostring(math.floor(screenDist or 0)) .. ")"
                        local isVis = isVisibleToCamera(headInst)
                        if isVis then
                            found = {player = pl, head = headInst}
                            debugMsg = "AutoShoot: TARGET LOCKED - " .. pl.Name
                            break
                        else
                            debugMsg = "AutoShoot: " .. pl.Name .. " blocked by geometry"
                        end
                    end
                end
            end
        end

        if not found then
            local persistentEnabled = GetConfig("combat.persistentAimbot", false)
            if persistentEnabled and _G and _G.VozexCHT_Aimbot and type(_G.VozexCHT_Aimbot.GetPersistentTarget) == "function" then
                local pt = _G.VozexCHT_Aimbot.GetPersistentTarget()
                if pt and pt.model and pt.model.Parent then
                    local headInst = pt.model:FindFirstChild("Head") or pt.model:FindFirstChild("UpperTorso") or pt.model:FindFirstChild("HumanoidRootPart")
                    if headInst and headInst.Position then
                        local pl = pt.player or Players:GetPlayerFromCharacter(pt.model)
                        local isTeam = false
                        if pl and _G and _G.Vozex_TeamCheck and type(_G.Vozex_TeamCheck.IsTeammate) == "function" then
                            isTeam = _G.Vozex_TeamCheck.IsTeammate(pl)
                        end
                        if not isTeam then
                            local isVis = isVisibleToCamera(headInst)
                            if isVis then
                                found = {player = pl, head = headInst}
                                debugMsg = "AutoShoot: PERSISTENT TARGET LOCKED (out of FOV)"
                                if persistentEnabled and _G and _G.VozexCHT_Aimbot and not persistentEngaged then
                                    persistentEngaged = true
                                    if type(_G.VozexCHT_Aimbot.SetPersistentTarget) == "function" then
                                        _G.VozexCHT_Aimbot.SetPersistentTarget(headInst.Parent)
                                    end
                                    if type(_G.VozexCHT_Aimbot.Trigger) == "function" then
                                        _G.VozexCHT_Aimbot.Trigger()
                                    end
                                end
                            else
                                if firing then
                                    mouse1release()
                                    firing = false
                                    if _G and _G.VozexCHT_Aimbot then
                                        _G.VozexCHT_Aimbot.ForceActive = false
                                        _G.VozexCHT_Aimbot.Stop()
                                    end
                                end
                                debugMsg = "AutoShoot: Persistent target blocked by geometry"
                            end
                        else
                            debugMsg = "AutoShoot: Persistent target is teammate"
                        end
                    end
                end
            end
        end

        if found then
            lastInFov = tick()
            local localPlayerHasShield = false
            pcall(function() localPlayerHasShield = isHoldingRiotShield(Players.LocalPlayer) end)

            local holdingKat = false
            local holdingShield = false
            pcall(function() holdingKat = isHoldingKatana(found.player) end)
            pcall(function() holdingShield = isHoldingRiotShield(found.player) end)

            local holdingSpray = false
            pcall(function()
                if type(_G) == "table" and _G.VozexCHTUI and _G.VozexCHTUI.ShowEnemyWeapons and type(_G.VozexCHTUI.ShowEnemyWeapons.GetLocalPlayerHeldWeapon) == "function" then
                    local ok, norm, raw = pcall(function() return _G.VozexCHTUI.ShowEnemyWeapons.GetLocalPlayerHeldWeapon() end)
                    if ok and norm and string.find(string.lower(norm), "spray") then
                        holdingSpray = true
                    end
                end
            end)

            local shouldBlock = (holdingKat or holdingShield or localPlayerHasShield) and not holdingSpray

            if shouldBlock then
                katanaBlocked = true
                local reason = ""
                if localPlayerHasShield then
                    reason = "Local player has Riot Shield"
                elseif holdingShield then
                    reason = "Target has Riot Shield"
                else
                    reason = "Target has Katana"
                end
                debugMsg = "AutoShoot: " .. reason .. " — Aim lock only: " .. (found.player and found.player.Name or "unknown")
                if _G and _G.VozexCHT_Aimbot then
                    if type(_G.VozexCHT_Aimbot.SetPersistentTarget) == "function" then
                        pcall(function() _G.VozexCHT_Aimbot.SetPersistentTarget(found.head.Parent) end)
                        persistentEngaged = true
                    end
                    if type(_G.VozexCHT_Aimbot.Trigger) == "function" then
                        pcall(_G.VozexCHT_Aimbot.Trigger)
                    else
                        _G.VozexCHT_Aimbot.ForceActive = true
                        pcall(function() _G.VozexCHT_Aimbot.Start() end)
                    end
                end
                if firing then mouse1release(); firing = false end
            else
                katanaBlocked = false
                
                local holdingSniper = false
                pcall(function() holdingSniper = isHoldingSniper() end)
                
                if holdingSniper then
                    if _G and _G.VozexCHT_Aimbot then
                        if type(_G.VozexCHT_Aimbot.SetPersistentTarget) == "function" then
                            pcall(function() _G.VozexCHT_Aimbot.SetPersistentTarget(found.head.Parent) end)
                            persistentEngaged = true
                        end
                        if type(_G.VozexCHT_Aimbot.Trigger) == "function" then
                            pcall(_G.VozexCHT_Aimbot.Trigger)
                        else
                            _G.VozexCHT_Aimbot.ForceActive = true
                            _G.VozexCHT_Aimbot.Start()
                        end
                    end
                    
                    if rightClickPressTime == nil then
                        debugMsg = "AutoShoot: Sniper - Aimlock active, waiting for right-click on " .. found.player.Name
                        if firing then mouse1release(); firing = false end
                    else
                        local timeSinceClick = tick() - rightClickPressTime
                        if timeSinceClick < 0.2 then
                            debugMsg = "AutoShoot: Sniper - Right-click delay (" .. string.format("%.2f", timeSinceClick) .. "s)"
                            if firing then mouse1release(); firing = false end
                        else
                            if not firing then
                                firing = true
                                debugMsg = "AutoShoot: FIRING (Sniper) at " .. found.player.Name
                                mouse1press()
                            else
                                debugMsg = "AutoShoot: Holding fire (Sniper) on " .. found.player.Name
                            end
                        end
                    end
                else
                    if not firing then
                        firing = true
                        debugMsg = "AutoShoot: FIRING at " .. found.player.Name
                        if _G and _G.VozexCHT_Aimbot then
                            if type(_G.VozexCHT_Aimbot.SetPersistentTarget) == "function" then
                                pcall(function() _G.VozexCHT_Aimbot.SetPersistentTarget(found.head.Parent) end)
                                persistentEngaged = true
                            end
                            if type(_G.VozexCHT_Aimbot.Trigger) == "function" then
                                pcall(_G.VozexCHT_Aimbot.Trigger)
                            else
                                _G.VozexCHT_Aimbot.ForceActive = true
                                _G.VozexCHT_Aimbot.Start()
                            end
                        end
                        mouse1press()
                    else
                        debugMsg = "AutoShoot: Holding fire on " .. found.player.Name
                        if _G and _G.VozexCHT_Aimbot then
                            if type(_G.VozexCHT_Aimbot.SetPersistentTarget) == "function" then
                                pcall(function() _G.VozexCHT_Aimbot.SetPersistentTarget(found.head.Parent) end)
                                persistentEngaged = true
                            end
                            if type(_G.VozexCHT_Aimbot.Trigger) == "function" then
                                pcall(_G.VozexCHT_Aimbot.Trigger)
                            else
                                _G.VozexCHT_Aimbot.ForceActive = true
                                _G.VozexCHT_Aimbot.Start()
                            end
                        end
                    end
                end
            end
        else
            if firing then
                mouse1release()
                firing = false
                debugMsg = "AutoShoot: Released fire"
                if _G and _G.VozexCHT_Aimbot then
                    _G.VozexCHT_Aimbot.ForceActive = false
                    _G.VozexCHT_Aimbot.Stop()
                    if type(_G.VozexCHT_Aimbot.ClearPersistentTarget) == "function" then
                        pcall(_G.VozexCHT_Aimbot.ClearPersistentTarget)
                    end
                end
                if persistentEngaged then
                    persistentEngaged = false
                end
            else
                debugMsg = "AutoShoot: Waiting for target"
                if _G and _G.VozexCHT_Aimbot then
                    _G.VozexCHT_Aimbot.ForceActive = false
                    _G.VozexCHT_Aimbot.Stop()
                    if type(_G.VozexCHT_Aimbot.ClearPersistentTarget) == "function" then
                        pcall(_G.VozexCHT_Aimbot.ClearPersistentTarget)
                    end
                end
                if persistentEngaged then
                    persistentEngaged = false
                end
            end
        
        end
        if debugLabel and debugMsg ~= lastDebugMsg then debugLabel.Set(debugMsg) lastDebugMsg = debugMsg end
    end

    if not (KeybindAPI and KeybindAPI[enableAutoShootKeybind] and type(KeybindAPI[enableAutoShootKeybind].OnActivate) == "function") then
        keyConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
            local bound = GetConfig(KEY_CONFIG, "Y")
            local target = bound and Enum.KeyCode[bound]
            if target and input.KeyCode == target then
                local currentState = GetConfig("combat.autoShoot", false)
                local newState = not currentState
                if type(SetConfig) == "function" then SetConfig("combat.autoShoot", newState) end
                local api = ToggleAPI[autoShootToggle]
                if api and api.Set then api.Set(newState) end
            end
        end)
    end

    local api = ToggleAPI[autoShootToggle]
    if api then
        pcall(function()
            if api.Get and api.Get() and not autoConn then autoConn = RunService.Heartbeat:Connect(checkAndFire) end
        end)
        local p = api.OnToggle
        api.OnToggle = function(state)
            if type(p) == "function" then p(state) end
            makeNotification(state and "Auto-Shoot is ON" or "Auto-Shoot is OFF", 3, nil, "AutoShootToggle")
            if state then
                if not autoConn then autoConn = RunService.Heartbeat:Connect(checkAndFire) end
                if debugLabel then debugLabel.Set("AutoShoot: ON") end
            else
                if autoConn then autoConn:Disconnect() autoConn = nil end
                if firing then mouse1release() firing = false end
                if _G and _G.VozexCHT_Aimbot then
                    _G.VozexCHT_Aimbot.ForceActive = false
                    pcall(function() _G.VozexCHT_Aimbot.Stop() end)
                    if type(_G.VozexCHT_Aimbot.ClearPersistentTarget) == "function" then
                        pcall(_G.VozexCHT_Aimbot.ClearPersistentTarget)
                    end
                end
                persistentEngaged = false
                if debugLabel then debugLabel.Set("AutoShoot: OFF") end
            end
        end
    end

    RegisterUnload(function()
        if autoConn and autoConn.Disconnect then autoConn:Disconnect() end
        if keyConn and keyConn.Disconnect then keyConn:Disconnect() end
        if firing then mouse1release() end
        if debugLabel and debugLabel.Destroy then debugLabel.Destroy() end
    end)
end

-- ** Auto Shoot Logic Ends Here ** --

---------------------------------------------------------------------------

-- ** No-Clip Logic Starts Here ** --
do
    local noclipEnabled = false
    local player = Players.LocalPlayer
    local currentKeybind = Enum.KeyCode.N
    local toggleApi = ToggleAPI[noclipToggle]
    local originalCollisionStates = {}
    local charAddedConn = nil
    local noclipLoopConn = nil
    
    local function getBodyParts()
        if not player or not player.Character then return {} end
        local char = player.Character
        local parts = {}
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                table.insert(parts, part)
            end
        end
        return parts
    end

    local function setNoclip(enabled)
        noclipEnabled = enabled
        
        if enabled then
            originalCollisionStates = {}
            local parts = getBodyParts()
            for _, part in ipairs(parts) do
                if part then
                    originalCollisionStates[part] = part.CanCollide
                    part.CanCollide = false
                end
            end
            
            if not noclipLoopConn then
                noclipLoopConn = RunService.Heartbeat:Connect(function()
                    if not noclipEnabled or not player or not player.Character then return end
                    
                    local parts = getBodyParts()
                    for _, part in ipairs(parts) do
                        if part then
                            if not originalCollisionStates[part] then
                                originalCollisionStates[part] = part.CanCollide
                            end
                            if part.CanCollide then
                                part.CanCollide = false
                            end
                        end
                    end
                end)
            end
        else
            if noclipLoopConn then
                noclipLoopConn:Disconnect()
                noclipLoopConn = nil
            end
            
            for part, originalState in pairs(originalCollisionStates) do
                if part and part.Parent then
                    part.CanCollide = originalState
                end
            end
            originalCollisionStates = {}
        end
        
        makeNotification(enabled and "Noclip is ON" or "Noclip is OFF", 3)
        SetConfig("rage.noclip", enabled)
    end

    if toggleApi then
        toggleApi.OnToggle = function(state) setNoclip(state) end
    end

    do
        local keyApi = KeybindAPI[noclipKeybind]
        local saved = GetConfig("rage.noclipKeybind", "N")
        if keyApi and type(saved) == "string" and Enum.KeyCode[saved] and keyApi.Set then keyApi.Set(Enum.KeyCode[saved]) end
        if keyApi then
            keyApi.OnBind = function(k)
                local name = nil
                if typeof(k) == "EnumItem" then name = k.Name elseif type(k) == "string" then name = tostring(k) end
                if name then SetConfig("rage.noclipKeybind", name) end
            end
            keyApi.OnActivate = function()
                if keyApi.IsDisabled and keyApi.IsDisabled() then return end
                local currentState = GetConfig("rage.noclip", false)
                local newState = not currentState
                SetConfig("rage.noclip", newState)
                if toggleApi and toggleApi.Set then toggleApi.Set(newState) end
            end
            RegisterUnload(function()
                if keyApi then keyApi.OnActivate = nil end
            end)
        end
    end

    local function onCharacterAdded(char)
        originalCollisionStates = {}
        
        if noclipEnabled then
            for _, part in ipairs(char:GetDescendants()) do
                if part and part:IsA("BasePart") then
                    originalCollisionStates[part] = part.CanCollide
                    part.CanCollide = false
                end
            end
        end
    end
    if player then
        pcall(function()
            charAddedConn = player.CharacterAdded:Connect(onCharacterAdded)
        end)
    end

    do
        local savedState = GetConfig("rage.noclip", false)
        if toggleApi and toggleApi.Set then
            local prev = toggleApi.OnToggle
            toggleApi.OnToggle = nil
            pcall(toggleApi.Set, savedState)
            toggleApi.OnToggle = prev
        end
    end

    RegisterUnload(function()
        setNoclip(false)
        if charAddedConn then charAddedConn:Disconnect() end
        if noclipLoopConn then noclipLoopConn:Disconnect() end
    end)
end

-- ** No-Clip Logic Ends Here ** --

---------------------------------------------------------------------------

-- ** Stick to Target Logic Starts Here ** --
do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")

    local LocalPlayer = Players.LocalPlayer
    local stickEnabled = false
    local stickConn = nil
    
    local stickTarget = nil
    local respawnConns = {}
    local respawnWatcherActive = false
    local MAX_DISTANCE = 300
    local BEHIND_DISTANCE = 6

    local function isValidTarget(pl)
        if not pl or pl == LocalPlayer then return false end
        if not pl.Character then return false end
        local pp = pl.Character.PrimaryPart or pl.Character:FindFirstChild("HumanoidRootPart")
        if not pp or not pp.Parent then return false end
        local humanoid = pl.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid or type(humanoid.Health) ~= "number" then return false end
        if humanoid.Health <= 0 then return false end
        return true
    end

    local function isEnemyByTeamCheck(pl)
        if not pl or pl == LocalPlayer then return false end
        if _G and _G.Vozex_TeamCheck then
            if type(_G.Vozex_TeamCheck.IsEnemy) == "function" then
                local ok, res = pcall(_G.Vozex_TeamCheck.IsEnemy, pl)
                if ok then return not not res end
                return nil
            elseif type(_G.Vozex_TeamCheck.IsTeammate) == "function" then
                local ok, isTeam = pcall(_G.Vozex_TeamCheck.IsTeammate, pl)
                if ok then return not not (not isTeam) end
                return nil
            end
        end
        return nil
    end

    local function findStickTarget()
        local cam = workspace.CurrentCamera
        if not cam then return nil end
        local look = cam.CFrame.LookVector
        local origin = cam.CFrame.Position
        local best, bestDist = nil, math.huge

        for _, pl in ipairs(Players:GetPlayers()) do
            local enemyCheck = isEnemyByTeamCheck(pl)
            if isValidTarget(pl) and enemyCheck == true then
                local pp = pl.Character.PrimaryPart or pl.Character:FindFirstChild("HumanoidRootPart")
                local toTarget = pp.Position - origin
                local dot = look:Dot(toTarget.Unit)
                if dot > 0.65 then
                    local dist = toTarget.Magnitude
                    if dist < MAX_DISTANCE and dist < bestDist then
                        best = pl
                        bestDist = dist
                    end
                end
            end
        end
        return best
    end

    local function stopRespawnWatcher()
        if not respawnWatcherActive then return end
        respawnWatcherActive = false
        for _,c in ipairs(respawnConns) do
            pcall(function() if c and c.Disconnect then c:Disconnect() end end)
        end
        respawnConns = {}
    end

    local function startRespawnWatcher()
        if respawnWatcherActive then return end
        respawnWatcherActive = true
        for _,p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local function onChar(char)
                    if not p or p == LocalPlayer then return end
                    if isEnemyByTeamCheck(p) and isValidTarget(p) then
                        stickTarget = p
                        stopRespawnWatcher()
                    end
                end
                if p.Character then onChar(p.Character) end
                if p.CharacterAdded then table.insert(respawnConns, p.CharacterAdded:Connect(onChar)) end
            end
        end
        table.insert(respawnConns, Players.PlayerAdded:Connect(function(p)
            if p == LocalPlayer then return end
            local function onChar(char)
                if isEnemyByTeamCheck(p) and isValidTarget(p) then
                    stickTarget = p
                    stopRespawnWatcher()
                end
            end
            if p.Character then onChar(p.Character) end
            if p.CharacterAdded then table.insert(respawnConns, p.CharacterAdded:Connect(onChar)) end
        end))
    end

    local function isTargetHoldingKnife()
        if not stickTarget then return false end
        
        if type(_G) == "table" and _G.VozexCHTUI and _G.VozexCHTUI.ShowEnemyWeapons and type(_G.VozexCHTUI.ShowEnemyWeapons.GetEnemyHeldWeapon) == "function" then
            local ok, norm, raw = pcall(function() return _G.VozexCHTUI.ShowEnemyWeapons.GetEnemyHeldWeapon(stickTarget) end)
            if ok and (type(norm) == "string" or type(raw) == "string") then
                local sraw = (type(raw) == "string") and string.lower(raw) or ""
                local snorm = (type(norm) == "string") and string.lower(norm) or ""
                if string.find(sraw, "knife") or string.find(snorm, "knife") then
                    return true
                end
            end
        end
        return false
    end

    local function startStick()
        if stickConn then return end
        local lastSelect = 0
        local lastMove = 0
        local SELECT_INTERVAL = 0.25
        local MOVE_INTERVAL = 0
        local prevHeartbeat = tick()
        local spinRotation = 0
        local isInKnifeDodgeMode = false
        local SPIN_SPEED = 12
        local DODGE_DISTANCE = 15
        
        stickConn = RunService.Heartbeat:Connect(function()
            if not stickEnabled then return end
            if not LocalPlayer or not LocalPlayer.Character then return end
            local lpRoot = LocalPlayer.Character.PrimaryPart or LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not lpRoot then return end

            local now = tick()
            local dt = now - prevHeartbeat
            prevHeartbeat = now
            
            if not stickTarget and now - lastSelect >= SELECT_INTERVAL then
                stickTarget = findStickTarget()
                lastSelect = now
            end
            
            if stickTarget and (not isValidTarget(stickTarget) or not isEnemyByTeamCheck(stickTarget)) then
                stickTarget = nil
                isInKnifeDodgeMode = false
                spinRotation = 0
                return 
            end

            if not stickTarget then
                return 
            end

            if now - lastMove >= MOVE_INTERVAL then
                lastMove = now
                local tp = stickTarget.Character.PrimaryPart or stickTarget.Character:FindFirstChild("HumanoidRootPart")
                if tp and tp.Position then
                    local isHoldingKnife = isTargetHoldingKnife()

                    local backPos
                    if isHoldingKnife then
                        isInKnifeDodgeMode = true
                        spinRotation = spinRotation + SPIN_SPEED
                        
                        local pushDir = (lpRoot.Position - tp.Position).Unit
                        if pushDir.Magnitude == 0 then
                            pushDir = Vector3.new(1, 0, 0)
                        end
                        
                        backPos = tp.Position + (pushDir * DODGE_DISTANCE) + Vector3.new(0, 6.4, 0)
                    else
                        isInKnifeDodgeMode = false
                        spinRotation = 0
                        local targetPos = tp.Position + Vector3.new(0, 6.4, 0) 
                        backPos = targetPos - (tp.CFrame.LookVector.Unit * BEHIND_DISTANCE)
                    end
                    
                    local dest = CFrame.new(backPos, tp.Position)
                    
                    if isInKnifeDodgeMode then
                        dest = dest * CFrame.Angles(0, spinRotation, 0)
                    end
                    
                    if LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
                        local useSmoothing = false
                        local sToggleApi = ToggleAPI and ToggleAPI[useStickSmoothingToggle]
                        if sToggleApi and sToggleApi.Get then
                            useSmoothing = not not sToggleApi.Get()
                        else
                            useSmoothing = GetConfig("rage.useStickSmoothing", false)
                        end
                        if useSmoothing then
                            local intensity = nil
                            local sApi = SliderAPI and SliderAPI[smoothStickingSlider]
                            if sApi and sApi.Get then
                                intensity = sApi.Get()
                            else
                                intensity = GetConfig("rage.smoothStickingIntensity", 20)
                            end
                            if type(intensity) ~= "number" then intensity = 20 end
                            local alpha = math.clamp(intensity / 100, 0, 1)
                            local lerpAlpha = math.clamp(alpha * (dt * 8), 0, 1)
                            LocalPlayer.Character:SetPrimaryPartCFrame(LocalPlayer.Character.PrimaryPart.CFrame:Lerp(dest, lerpAlpha))
                        else
                            LocalPlayer.Character:SetPrimaryPartCFrame(dest)
                        end
                    end
                end
            end
        end)
    end

    local function stopStick()
        if stickConn then
            if stickConn.Disconnect then stickConn:Disconnect() end
            stickConn = nil
        end
        stickTarget = nil
        stopRespawnWatcher()
    end

    do
        local api = ToggleAPI and ToggleAPI[stickToToggle]
        if api then
            local prev = api.OnToggle
            api.OnToggle = function(state)
                if prev then prev(state) end
                stickEnabled = not not state
                if stickEnabled then
                    startStick()
                    makeNotification("Stick to Target is ON", 3)
                else
                    stopStick()
                    makeNotification("Stick to Target is OFF", 3)
                end
            end
            if api.Set then
                local prevOn = api.OnToggle
                api.OnToggle = nil
                pcall(api.Set, GetConfig("rage.stickToTarget", false))
                api.OnToggle = prevOn
            end
        end
    end

    do
        local keyApi = KeybindAPI and KeybindAPI[stickToKeybind]
        local saved = GetConfig("rage.stickToTargetKeybind", "I")
        if keyApi and type(saved) == "string" and Enum.KeyCode[saved] and keyApi.Set then keyApi.Set(Enum.KeyCode[saved]) end
        if keyApi then
            keyApi.OnBind = function(k)
                local name = nil
                if typeof(k) == "EnumItem" then name = k.Name elseif type(k) == "string" then name = tostring(k) end
                if name then SetConfig("rage.stickToTargetKeybind", name) end
            end
            keyApi.OnActivate = function()
                if keyApi.IsDisabled and keyApi.IsDisabled() then return end
                local current = GetConfig("rage.stickToTarget", false)
                local newState = not current
                SetConfig("rage.stickToTarget", newState)
                local api = ToggleAPI and ToggleAPI[stickToToggle]
                if api and api.Set then api.Set(newState) end
            end
            RegisterUnload(function()
                if keyApi then keyApi.OnActivate = nil end
            end)
        end
    end

    RegisterUnload(function()
        stopStick()
    end)
end

-- ** Stick to Target Logic Ends Here ** --

---------------------------------------------------------------------------

-- ** Spoof Device Logic Starts Here ** --
do
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")

    local LOCAL_PLAYER = Players.LocalPlayer
    local interval = 1 
    local acc = 0
    local conn
    local lastSent = nil
    local remoteCache = nil

    local OPTIONS = {"PC","Phone","Controller","VR"}
    local MAP = {
        PC = "MouseKeyboard",
        Phone = "Touch",
        Controller = "Gamepad",
        VR = "VR",
    }

    local function findRemote()
        local ok, obj = pcall(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            if not remotes then return nil end
            local replication = remotes:FindFirstChild("Replication")
            if not replication then return nil end
            local fighter = replication:FindFirstChild("Fighter")
            if not fighter then return nil end
            return fighter:FindFirstChild("SetControls")
        end)
        if ok then return obj end
        return nil
    end

    local function resolveSelection()
        local sel = nil
        if type(deviceSpoodDropDownList) == "table" and type(deviceSpoodDropDownList.Get) == "function" then
            local ok, v = pcall(deviceSpoodDropDownList.Get)
            if ok and v ~= nil then
                if type(v) == "string" then sel = v
                elseif type(v) == "number" then sel = OPTIONS[v]
                elseif type(v) == "table" then
                    if #v >= 1 then sel = v[1] end
                end
            end
        end
        if sel == nil and type(GetConfig) == "function" then
            local cfg = GetConfig("customization.deviceSpoof", nil)
            if type(cfg) == "string" then
                sel = cfg
            elseif type(cfg) == "number" then
                sel = OPTIONS[cfg]
            end
        end
        return sel
    end

    local function sendIfNeeded(mapped)
        if not mapped or mapped == "" then return end
        if remoteCache == nil then remoteCache = findRemote() end
        if remoteCache == nil then return end
        if lastSent == mapped then return end
        pcall(function()
            remoteCache:FireServer(mapped)
        end)
        lastSent = mapped
    end

    conn = RunService.Heartbeat:Connect(function(dt)
        acc = acc + dt
        if acc < interval then return end
        acc = acc - interval

        local sel = resolveSelection()
        if not sel then return end
        local mapped = MAP[sel] or sel
        sendIfNeeded(mapped)
    end)

    pcall(function()
        local sel = resolveSelection()
        if sel then
            local mapped = MAP[sel] or sel
            remoteCache = findRemote() or remoteCache
            if remoteCache then
                pcall(function() remoteCache:FireServer(mapped) end)
                lastSent = mapped
            end
        end
    end)

    RegisterUnload(function()
        if conn and conn.Disconnect then pcall(function() conn:Disconnect() end) end
    end)
end

-- ** Spoof Device Logic Ends Here ** --

---------------------------------------------------------------------------

-- ** Fly Logic Starts Here ** --
do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")

    local player = Players.LocalPlayer
    local flyEnabled = false
    local flyConn = nil
    local inputBeganConn = nil
    local inputEndedConn = nil
    local charAddedConn = nil
    local prevPlatformStand = nil
    local moveState = { W=false, A=false, S=false, D=false, Up=false, Down=false }
    local flyHeight = nil
    local flySpeed = GetConfig and GetConfig("rage.flySpeed", 20) or 20
    local flyDebugLabel = nil

    local function getSpeedFromSlider()
        if SliderAPI and SliderAPI[flySpeedSlider] and SliderAPI[flySpeedSlider].Get then
            local v = SliderAPI[flySpeedSlider].Get()
            if type(v) == "number" then
                flySpeed = v
                return
            end
        end
        flySpeed = GetConfig and GetConfig("rage.flySpeed", flySpeed) or flySpeed
    end

    local function setMovementFlag(key, down)
        if moveState[key] ~= nil then moveState[key] = not not down end
    end

    local function onInputBegan(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        local k = input.KeyCode
        if k == Enum.KeyCode.W then setMovementFlag("W", true) end
        if k == Enum.KeyCode.S then setMovementFlag("S", true) end
        if k == Enum.KeyCode.A then setMovementFlag("A", true) end
        if k == Enum.KeyCode.D then setMovementFlag("D", true) end
        if k == Enum.KeyCode.Space then setMovementFlag("Up", true) end
        if k == Enum.KeyCode.LeftShift or k == Enum.KeyCode.RightShift then setMovementFlag("Down", true) end
    end

    local function onInputEnded(input)
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        local k = input.KeyCode
        if k == Enum.KeyCode.W then setMovementFlag("W", false) end
        if k == Enum.KeyCode.S then setMovementFlag("S", false) end
        if k == Enum.KeyCode.A then setMovementFlag("A", false) end
        if k == Enum.KeyCode.D then setMovementFlag("D", false) end
        if k == Enum.KeyCode.Space then setMovementFlag("Up", false) end
        if k == Enum.KeyCode.LeftShift or k == Enum.KeyCode.RightShift then setMovementFlag("Down", false) end
    end

    local function applyFly(dt)
        if not player or not player.Character then return end
        local root = player.Character.PrimaryPart or player.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local cam = workspace.CurrentCamera
        if not cam then return end

        local forward = cam.CFrame.LookVector
        local right = cam.CFrame.RightVector

        local hor = Vector3.new(0,0,0)
        if moveState.W then hor = hor + Vector3.new(forward.X, 0, forward.Z) end
        if moveState.S then hor = hor - Vector3.new(forward.X, 0, forward.Z) end
        if moveState.D then hor = hor + Vector3.new(right.X, 0, right.Z) end
        if moveState.A then hor = hor - Vector3.new(right.X, 0, right.Z) end

        if flyHeight == nil then flyHeight = root.Position.Y end
        if moveState.Up then flyHeight = flyHeight + (flySpeed or 20) * dt end
        if moveState.Down then flyHeight = flyHeight - (flySpeed or 20) * dt end

        pcall(function()
            local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = true end
            if root and root:IsA("BasePart") then
                root.AssemblyLinearVelocity = Vector3.new(0,0,0)
                root.Velocity = Vector3.new(0,0,0)
            end
        end)

        local horizontalMovement = Vector3.new(0,0,0)
        if hor.Magnitude > 0 then
            horizontalMovement = hor.Unit * (flySpeed or 20) * dt
        end

        local newPos = root.Position + horizontalMovement
        newPos = Vector3.new(newPos.X, flyHeight, newPos.Z)
        pcall(function()
            player.Character:SetPrimaryPartCFrame(CFrame.new(newPos, newPos + Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)))
        end)
    end

    local function onCharacterAdded(char)
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then prevPlatformStand = hum.PlatformStand end
        if flyEnabled and hum then hum.PlatformStand = true end
    end

    local function startFly()
        if flyConn then return end
        getSpeedFromSlider()
        flyConn = RunService.Heartbeat:Connect(function(dt)
            applyFly(dt)
        end)
        if player and player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                prevPlatformStand = hum.PlatformStand
                hum.PlatformStand = true
            end
            local root = player.Character.PrimaryPart or player.Character:FindFirstChild("HumanoidRootPart")
            if root and root:IsA("BasePart") then
                flyHeight = root.Position.Y
            end
        end
        if player then
            charAddedConn = player.CharacterAdded:Connect(onCharacterAdded)
        end
    end

    local function stopFly()
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        if charAddedConn then charAddedConn:Disconnect(); charAddedConn = nil end
        if player and player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum and prevPlatformStand ~= nil then hum.PlatformStand = prevPlatformStand end
        end
        pcall(function() if flyDebugLabel and flyDebugLabel.Set then flyDebugLabel.Set("Fly: OFF (stop)") end end)
    end

    do
        local api = ToggleAPI and ToggleAPI[flyToggle]
        if api then
            local prev = api.OnToggle
            api.OnToggle = function(state)
                if prev then prev(state) end
                flyEnabled = not not state
                if flyEnabled then startFly() else stopFly() end
                pcall(function() if flyDebugLabel and flyDebugLabel.Set then flyDebugLabel.Set("Fly: " .. (flyEnabled and "ON (ui)" or "OFF (ui)")) end end)
                pcall(function() makeNotification("Fly is " .. (flyEnabled and "ON" or "OFF"), 2) end)
            end
            if api.Set then
                local prevOn = api.OnToggle
                api.OnToggle = nil
                pcall(api.Set, GetConfig("rage.fly", false))
                api.OnToggle = prevOn
            end
        end
    end

    do
        local sApi = SliderAPI and SliderAPI[flySpeedSlider]
        if sApi and sApi.Get and sApi.OnChange then
            pcall(function() sApi.Set(GetConfig("rage.flySpeed", flySpeed)) end)
            sApi.OnChange = function(v)
                flySpeed = tonumber(v) or flySpeed
                pcall(function() SetConfig("rage.flySpeed", flySpeed) end)
            end
        else
            flySpeed = GetConfig and GetConfig("rage.flySpeed", flySpeed) or flySpeed
        end
    end

    pcall(function() flyDebugLabel = makeDebugLabel("Fly: OFF") end)

    do
        local keyApi = KeybindAPI and KeybindAPI[flyKeybind]
        local saved = GetConfig and GetConfig("rage.flyKeybind", "N")
        if keyApi and type(saved) == "string" and Enum.KeyCode[saved] and keyApi.Set then keyApi.Set(Enum.KeyCode[saved]) end
        if keyApi then
            keyApi.OnBind = function(k)
                local name = nil
                if typeof(k) == "EnumItem" then name = k.Name elseif type(k) == "string" then name = tostring(k) end
                if name then SetConfig("rage.flyKeybind", name) end
            end
            keyApi.OnActivate = function()
                if keyApi.IsDisabled and keyApi.IsDisabled() then return end
                local currentState = GetConfig and GetConfig("rage.fly", false)
                local newState = not currentState
                if SetConfig then SetConfig("rage.fly", newState) end
                local api = ToggleAPI and ToggleAPI[flyToggle]
                if api and api.Set then api.Set(newState) end
                if flyDebugLabel and flyDebugLabel.Set then flyDebugLabel.Set("Fly: " .. (newState and "ON (keybind)" or "OFF (keybind)")) end
            end
            RegisterUnload(function()
                if keyApi then keyApi.OnActivate = nil end
            end)
        end
    end

    if not inputBeganConn then
        inputBeganConn = UserInputService.InputBegan:Connect(onInputBegan)
    end
    if not inputEndedConn then
        inputEndedConn = UserInputService.InputEnded:Connect(onInputEnded)
    end

    if GetConfig and GetConfig("rage.fly", false) then
        flyEnabled = true
        startFly()
    end

    RegisterUnload(function()
        stopFly()
        if inputBeganConn then inputBeganConn:Disconnect(); inputBeganConn = nil end
        if inputEndedConn then inputEndedConn:Disconnect(); inputEndedConn = nil end
        
        if flyDebugLabel then pcall(function()
            if flyDebugLabel.Destroy then flyDebugLabel.Destroy() elseif flyDebugLabel.Set then flyDebugLabel.Set("") end
        end) end
    end)
end

-- ** Fly Logic Ends Here ** --

---------------------------------------------------------------------------

-- ** Update Log Logic Starts Here ** --
do
    local url = "https://your-desire.vercel.app/api/changeLogs.js"
    local function get_request()
        if type(http_request) == "function" then return http_request end
        if type(request) == "function" then return request end
        if type(syn) == "table" and type(syn.request) == "function" then return syn.request end
        if type(fluxus) == "table" and type(fluxus.request) == "function" then return fluxus.request end
        if type(http) == "table" and type(http.request) == "function" then return http.request end
        return nil
    end

    local reqfn = get_request()
    local body = nil
    if reqfn then
        local ok, res = pcall(function()
            return reqfn({ Url = url, Method = "GET" })
        end)
        if ok and res then
            if type(res) == "table" then
                body = res.Body or res.body or res.response or nil
            elseif type(res) == "string" then
                body = res
            end
        end
    end

    local function parse_js_object(js)
        if not js or type(js) ~= "string" then return nil end
        local s = js
        s = s:gsub("^%s*const%s+%w+%s*=", "")
        s = s:gsub(";%s*$", "")
        s = s:gsub("%[", "{")
        s = s:gsub("%]", "}")
        s = s:gsub('(%b"")%s*:', function(k) return "[" .. k .. "] =" end)
        s = s:gsub("%: null", "= nil")
        local prev = nil
        repeat
            prev = s
            s = s:gsub(",%s*([}%]])", "%1")
        until s == prev
        local chunk = "return " .. s
        local fn, err = loadstring(chunk)
        if not fn then return nil, err end
        local ok, tbl = pcall(fn)
        if not ok then return nil, tbl end
        return tbl
    end

    local updateLog = nil
    if body then
        local parsed, perr = parse_js_object(body)
        if parsed then updateLog = parsed end
    end

    if not updateLog then
        updateLog = {
            title = "New Rivals Script",
            info = { 
                "✦ New script for Rivals has been released!",
                "✦ Join our Discord for updates and support",
                "✦ https://discord.gg/Tttz6mNAet",
                "✦ Fixed drag shadow issue",
                "✦ Improved UI performance"
            },
            footer = "Thanks for using Vozex Hub",
            metadata = { id = "rivals_update", version = "1.1" }
        }
    end

    local seenKey = "updates.seen." .. (updateLog.metadata and updateLog.metadata.id or "unknown")
    local alreadySeen = false
    if GetConfig then
        local ok, val = pcall(function() return GetConfig(seenKey, false) end)
        if ok and val then alreadySeen = true end
    end

    if not alreadySeen then
        local playerGui = Players.LocalPlayer and Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not playerGui and Players.LocalPlayer then
            playerGui = Players.LocalPlayer:FindFirstChild("PlayerGui")
        end
        if not playerGui then
            pcall(function() playerGui = Players.LocalPlayer:WaitForChild("PlayerGui") end)
        end

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "Vozex_UpdateLog"
        screenGui.ResetOnSpawn = false
        screenGui.DisplayOrder = 9999
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Parent = playerGui

        local overlay = Instance.new("Frame")
        overlay.Name = "UpdateLogOverlay"
        overlay.Size = UDim2.new(1,0,1,0)
        overlay.Position = UDim2.new(0,0,0,0)
        overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
        overlay.BackgroundTransparency = 0.45
        overlay.ZIndex = 1
        overlay.Active = true
        overlay.Parent = screenGui

        local shadow = Instance.new("Frame")
        shadow.Name = "UpdateShadow"
        shadow.Size = UDim2.new(0, 780, 0, 440)
        shadow.Position = UDim2.new(0.5, -390, 0.5, -220)
        shadow.AnchorPoint = Vector2.new(0,0)
        shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
        shadow.BackgroundTransparency = 0.7
        shadow.ZIndex = 1
        shadow.Parent = overlay

        local dialog = Instance.new("Frame")
        dialog.Name = "UpdateDialog"
        dialog.Size = UDim2.new(0, 760, 0, 420)
        dialog.Position = UDim2.new(0.5, -380, 0.5, -210)
        dialog.AnchorPoint = Vector2.new(0,0)
        dialog.BackgroundColor3 = COLORS and COLORS.panel or Color3.fromRGB(18,18,18)
        dialog.BackgroundTransparency = 0
        dialog.BorderSizePixel = 0
        dialog.ZIndex = 2
        dialog.Parent = overlay

        local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0,14) corner.Parent = dialog
        local stroke = Instance.new("UIStroke") stroke.Color = COLORS and COLORS.divider or Color3.fromRGB(60,60,60) stroke.Thickness = 1 stroke.Parent = dialog
        RegisterThemed(dialog)

        local header = Instance.new("Frame")
        header.Name = "Header"
        header.Size = UDim2.new(1, 0, 0, 72)
        header.Position = UDim2.new(0, 0, 0, 0)
        header.BackgroundColor3 = COLORS and COLORS.accent or Color3.fromRGB(200,80,180)
        header.BorderSizePixel = 0
        header.ZIndex = 3
        header.Parent = dialog
        local headerCorner = Instance.new("UICorner") headerCorner.CornerRadius = UDim.new(0,12) headerCorner.Parent = header
        RegisterThemed(header)

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -48, 0, 72)
        title.Position = UDim2.new(0,24,0,0)
        title.BackgroundTransparency = 1
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Font = Enum.Font.GothamBold
        title.TextSize = 22
        title.TextColor3 = COLORS and COLORS.white or Color3.fromRGB(250,250,250)
        title.Text = updateLog.title or "Update"
        title.ZIndex = 4
        title.Parent = header
        RegisterThemed(title)

        local closeFrame = Instance.new("Frame")
        closeFrame.Name = "CloseButtonHolder"
        closeFrame.Size = UDim2.new(0,36,0,36)
        closeFrame.Position = UDim2.new(1, -44, 0, 12)
        closeFrame.AnchorPoint = Vector2.new(0,0)
        closeFrame.BackgroundTransparency = 1
        closeFrame.ZIndex = 4
        closeFrame.Parent = dialog
        RegisterThemed(closeFrame)

        local closeBtn = Instance.new("TextButton")
        closeBtn.Name = "CloseBtn"
        closeBtn.Size = UDim2.new(0,32,0,32)
        closeBtn.Position = UDim2.new(1, -4, 0.5, 0)
        closeBtn.AnchorPoint = Vector2.new(1,0.5)
        closeBtn.Text = "X"
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 18
        closeBtn.BackgroundColor3 = COLORS and COLORS.panelDark or Color3.fromRGB(40,40,40)
        closeBtn.TextColor3 = COLORS and COLORS.text or Color3.fromRGB(220,220,220)
        closeBtn.BorderSizePixel = 0
        closeBtn.Parent = closeFrame
        local closeCorner = Instance.new("UICorner") closeCorner.CornerRadius = UDim.new(0,6) closeCorner.Parent = closeBtn
        RegisterThemed(closeBtn)
        closeBtn.MouseButton1Click:Connect(function()
            if SetConfig then pcall(function() SetConfig(seenKey, true) end) end
            if screenGui and screenGui.Destroy then screenGui:Destroy() end
        end)

        local content = Instance.new("ScrollingFrame")
        content.Name = "UpdateContent"
        content.Size = UDim2.new(1, -48, 0, 220)
        content.Position = UDim2.new(0,24,0,72)
        content.BackgroundTransparency = 1
        content.ScrollBarThickness = 8
        content.CanvasSize = UDim2.new(0,0,0,0)
        content.ZIndex = 2
        content.Parent = dialog

        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingLeft = UDim.new(0,6)
        contentPadding.PaddingRight = UDim.new(0,6)
        contentPadding.PaddingTop = UDim.new(0,6)
        contentPadding.PaddingBottom = UDim.new(0,6)
        contentPadding.Parent = content

        local uiList = Instance.new("UIListLayout")
        uiList.Name = "UpdateList"
        uiList.Padding = UDim.new(0,8)
        uiList.SortOrder = Enum.SortOrder.LayoutOrder
        uiList.Parent = content
        uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            content.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y + 12)
        end)

        for i, line in ipairs(updateLog.info or {}) do
            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(1, 0, 0, 0)
            holder.AutomaticSize = Enum.AutomaticSize.Y
            holder.BackgroundTransparency = 1
            holder.Parent = content

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -12, 0, 0)
            lbl.AutomaticSize = Enum.AutomaticSize.Y
            lbl.BackgroundTransparency = 1
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextWrapped = true
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 16
            lbl.TextColor3 = COLORS and COLORS.text or Color3.fromRGB(230,230,230)
            lbl.Text = "• " .. tostring(line)
            lbl.LayoutOrder = i
            lbl.Parent = holder
        end

        local footer = Instance.new("TextLabel")
        footer.Size = UDim2.new(1, -48, 0, 48)
        footer.Position = UDim2.new(0,24,1,-88)
        footer.BackgroundTransparency = 1
        footer.Font = Enum.Font.Gotham
        footer.TextSize = 14
        footer.TextColor3 = Color3.fromRGB(180,180,180)
        footer.TextWrapped = true
        footer.Text = updateLog.footer or ""
        footer.TextXAlignment = Enum.TextXAlignment.Left
        footer.ZIndex = 3
        footer.Parent = dialog

        local okHolder = Instance.new("Frame")
        okHolder.Name = "OkButtonHolder"
        okHolder.Size = UDim2.new(0,140,0,40)
        okHolder.Position = UDim2.new(0.5, 0, 1, -48)
        okHolder.AnchorPoint = Vector2.new(0.5,0)
        okHolder.BackgroundTransparency = 1
        okHolder.Parent = dialog
        RegisterThemed(okHolder)

        local okBtn = Instance.new("TextButton")
        okBtn.Name = "OkBtn"
        okBtn.Size = UDim2.new(1, 0, 1, 0)
        okBtn.Position = UDim2.new(0, 0, 0, 0)
        okBtn.AnchorPoint = Vector2.new(0,0)
        okBtn.Text = "Ok"
        okBtn.Font = Enum.Font.GothamBold
        okBtn.TextSize = 16
        okBtn.TextColor3 = COLORS and COLORS.text or Color3.fromRGB(240,240,240)
        okBtn.BackgroundColor3 = COLORS and COLORS.accent or Color3.fromRGB(48,120,220)
        okBtn.BorderSizePixel = 0
        okBtn.Parent = okHolder
        local okCorner = Instance.new("UICorner") okCorner.CornerRadius = UDim.new(0,8) okCorner.Parent = okBtn
        RegisterThemed(okBtn)
        okBtn.MouseButton1Click:Connect(function()
            if SetConfig then pcall(function() SetConfig(seenKey, true) end) end
            if screenGui and screenGui.Destroy then screenGui:Destroy() end
        end)
    end
end

-- ** Update Log Logic Ends Here ** --

---------------------------------------------------------------------------

-- ** Hide Smoke Visuals Logic Starts Here ** --
do
    local _hideSmokeRunning = false
    local _workerConn = nil

    local function handleSmoke(inst)
        if not inst or not inst.Parent then return end
        for _, d in ipairs(inst:GetDescendants()) do
            if d:IsA("ParticleEmitter") then
                d.Enabled = false
            elseif d:IsA("BasePart") then
                d.Transparency = 1
            elseif d:IsA("Decal") or d:IsA("Texture") then
                d.Transparency = 1
            end
        end
        task.defer(function()
            if inst and inst.Parent then
                inst:Destroy()
            end
        end)
    end

    local function startHideSmoke()
        if _hideSmokeRunning then return end
        _hideSmokeRunning = true
        if not _workerConn then
            _workerConn = workspace.DescendantAdded:Connect(function(child)
                if not _hideSmokeRunning then return end
                if typeof(child) == "Instance" and child.Name == "Smoke Grenade" then
                    handleSmoke(child)
                end
            end)
        end
        for _, v in ipairs(workspace:GetDescendants()) do
            if v and v.Name == "Smoke Grenade" then handleSmoke(v) end
        end
    end

    local function stopHideSmoke()
        _hideSmokeRunning = false
    end

    local tApi = (ToggleAPI and ToggleAPI[hideSmokeToggle]) or nil
    if tApi then
        local prev = tApi.OnToggle
        tApi.OnToggle = function(state)
            if type(prev) == "function" then pcall(prev, state) end
            if state then startHideSmoke() else stopHideSmoke() end
        end
        if tApi.Get and tApi.Get() then startHideSmoke() end
    else
        if GetConfig and GetConfig("visuals.hideSmoke", false) then startHideSmoke() end
    end

    RegisterUnload(function()
        _hideSmokeRunning = false
        if _workerConn then _workerConn:Disconnect() _workerConn = nil end
    end)
end

-- ** Hide Smoke Visuals Logic Ends Here ** --

---------------------------------------------------------------------------

-- ** Hide Flashbang Visuals Logic Starts Here ** --
do
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local playerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
    local enabled = true
    local wsConn, guiConn

    local lastShow = 0
    local SHOW_THROTTLE = 0.5

    local function showFlashLabel()
        local now = tick()
        if now - lastShow < SHOW_THROTTLE then return end
        lastShow = now
        if type(_G) == "table" and _G.VozexTopLabel and type(_G.VozexTopLabel.New) == "function" then
            local lbl = _G.VozexTopLabel.New("You are flashbanged currently", {TextSize = 14})
            task.delay(3.5, function()
                if lbl then lbl:Destroy() end
            end)
        end
    end

    local function handleFlashInstance(inst)
        if not enabled or not inst then return end
        local now = tick()
        if now - lastShow < SHOW_THROTTLE then
            inst:Destroy()
            return
        end
        inst:Destroy()
        showFlashLabel()
    end

    local function startRemover()
        if wsConn then return end
        wsConn = workspace.ChildAdded:Connect(function(child)
            if child and child.Name == "FlashbangEffect" then handleFlashInstance(child) end
        end)
        if playerGui then
            guiConn = playerGui.ChildAdded:Connect(function(child)
                if child and child.Name:lower():find("flash") then handleFlashInstance(child) end
            end)
        end
        repeat
            local found = workspace:FindFirstChild("FlashbangEffect", true)
            if found then handleFlashInstance(found) end
        until not found
        if playerGui then
            for _, v in ipairs(playerGui:GetDescendants()) do
                if v.Name:lower():find("flash") then
                    v:Destroy()
                end
            end
        end
    end

    local function stopRemover()
        if wsConn then wsConn:Disconnect() wsConn = nil end
        if guiConn then guiConn:Disconnect() guiConn = nil end
    end

    local tApi = (ToggleAPI and ToggleAPI[hideFlashbangToggle]) or nil
    if tApi then
        local prev = tApi.OnToggle
        tApi.OnToggle = function(state)
            if type(prev) == "function" then prev(state) end
            enabled = not not state
            if enabled then startRemover() else stopRemover() end
        end
        if tApi.Get and tApi.Get() then enabled = true startRemover() end
    else
        if GetConfig and GetConfig("visuals.hideFlashbang", false) then enabled = true startRemover() end
    end

    RegisterUnload(function()
        stopRemover()
    end)
end

-- ** Hide Flashbang Visuals Logic Ends Here ** --

---------------------------------------------------------------------------

-- ** Help Button Logic Starts here ** -- 
local _helpPanel = nil
local function CloseHelpPanel()
    if _helpPanel and _helpPanel.Destroy then
        pcall(function() _helpPanel:Destroy() end)
    end
    _helpPanel = nil
end

local function OpenHelpPanel()
    if _helpPanel and _helpPanel.Parent then
        return
    end
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Vozex_HelpPanel"
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 10001
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    if gui and gui.Parent then
        screenGui.Parent = gui.Parent
    else
        screenGui.Parent = game:GetService("CoreGui")
    end

    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.AnchorPoint = Vector2.new(0,0)
    overlay.Size = UDim2.new(1,0,1,0)
    overlay.Position = UDim2.new(0,0,0,0)
    overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
    overlay.BackgroundTransparency = 0.45
    overlay.ZIndex = 1
    overlay.Parent = screenGui

    local dialog = Instance.new("Frame")
    dialog.Name = "HelpDialog"
    dialog.Size = UDim2.new(0, 700, 0, 420)
    dialog.Position = UDim2.new(0.5, -350, 0.5, -210)
    dialog.AnchorPoint = Vector2.new(0,0)
    dialog.BackgroundColor3 = COLORS.panel or Color3.fromRGB(24,24,24)
    dialog.BorderSizePixel = 0
    dialog.ZIndex = 2
    dialog.Parent = screenGui
    local dlgCorner = Instance.new("UICorner") dlgCorner.CornerRadius = UDim.new(0,12) dlgCorner.Parent = dialog
    local dlgStroke = Instance.new("UIStroke") dlgStroke.Thickness = 1 dlgStroke.Parent = dialog
    RegisterThemed(dialog, function()
        pcall(function()
            dialog.BackgroundColor3 = COLORS.panel or dialog.BackgroundColor3
            dlgStroke.Color = COLORS.divider or dlgStroke.Color
        end)
    end)

    local header = Instance.new("Frame") header.Name = "Header" header.Size = UDim2.new(1,0,0,60) header.Position = UDim2.new(0,0,0,0) header.Parent = dialog
    local headerCorner = Instance.new("UICorner") headerCorner.CornerRadius = UDim.new(0,10) headerCorner.Parent = header
    if COLORS and COLORS.accent then header.BackgroundColor3 = COLORS.accent end
    RegisterThemed(header)

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -96, 1, 0)
    title.Position = UDim2.new(0, 24, 0, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.Text = "How to use Vozex Hub"
    title.TextColor3 = COLORS.white or Color3.fromRGB(240,240,240)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    if COLORS and COLORS.white then title.TextColor3 = COLORS.white end
    RegisterThemed(title)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0,36,0,36)
    closeBtn.Position = UDim2.new(1, -44, 0.5, 0)
    closeBtn.AnchorPoint = Vector2.new(0,0.5)
    closeBtn.BackgroundColor3 = COLORS.panelDark or Color3.fromRGB(40,40,40)
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.TextColor3 = COLORS.text or Color3.fromRGB(230,230,230)
    closeBtn.Parent = header
    local closeCorner = Instance.new("UICorner") closeCorner.CornerRadius = UDim.new(0,8) closeCorner.Parent = closeBtn
    RegisterThemed(closeBtn, function() pcall(function() closeBtn.BackgroundColor3 = COLORS.panelDark; closeBtn.TextColor3 = COLORS.text end) end)
    closeBtn.MouseButton1Click:Connect(function() CloseHelpPanel() end)

    local content = Instance.new("ScrollingFrame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -48, 1, -80)
    content.Position = UDim2.new(0, 24, 0, 64)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 8
    content.Parent = dialog
    local pad = Instance.new("UIPadding") pad.PaddingLeft = UDim.new(0,6) pad.PaddingRight = UDim.new(0,6) pad.PaddingTop = UDim.new(0,6) pad.PaddingBottom = UDim.new(0,6) pad.Parent = content

    local list = Instance.new("UIListLayout") list.Parent = content list.SortOrder = Enum.SortOrder.LayoutOrder list.Padding = UDim.new(0,8)

    local function addSection(titleText, bodyText)
        local holder = Instance.new("Frame") holder.Size = UDim2.new(1,0,0,0) holder.AutomaticSize = Enum.AutomaticSize.Y holder.BackgroundTransparency = 1 holder.Parent = content
        local h = Instance.new("TextLabel") h.Size = UDim2.new(1,0,0,22) h.BackgroundTransparency = 1 h.Font = Enum.Font.GothamBold h.TextSize = 16 h.Text = titleText h.TextColor3 = COLORS.text h.TextXAlignment = Enum.TextXAlignment.Left h.Parent = holder
        local b = Instance.new("TextLabel") b.Size = UDim2.new(1,-12,0,0) b.Position = UDim2.new(0,6,0,26) b.AutomaticSize = Enum.AutomaticSize.Y b.BackgroundTransparency = 1 b.Font = Enum.Font.Gotham b.TextSize = 14 b.TextWrapped = true b.Text = bodyText b.TextColor3 = COLORS.textDim b.TextXAlignment = Enum.TextXAlignment.Left b.Parent = holder
    end

    addSection("Keybinds and Customization", "You can customize keybinds by pressing on them and setting them to a custom key (remember to press enter to save). You can also disable keybinds and re-enable them back by right clicking on them and pressing the button.")
    addSection("Visuals", "You can customize the visuals of the game in the customization tab. You can change model colors, lightning intensity, spoof your device and even change the theme of the UI")
    addSection("Combat", "You can customize your combat settings in the combat tab. Aimbot, autoshoot and many other features are in there.")
    addSection("Rage", "You can find cool stuff like fly, noclip and my favourite stick to player in there, be careful how you use them tho.")
    addSection("Tips", "If you dont know what a toggle does hover over it for a bit, its gonna show you a tool tip. If your aimbot breaks when youre very far away from a player turn on target behind wals btw.")

    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0,0,0, list.AbsoluteContentSize.Y + 12)
    end)

    _helpPanel = screenGui
    RegisterThemed(_helpPanel, function() end)
    RegisterUnload(function() CloseHelpPanel() end)
end

if helpBtn and helpBtn.MouseButton1Click then
    helpBtn.MouseButton1Click:Connect(function()
        OpenHelpPanel()
    end)
end

-- ** Help Button Logic Ends here ** --

---------------------------------------------------------------------------

-- ** Persist Disabled/Enabled Keybind Logic Starts Here ** --
do
    local function _countKeys(t)
        local c = 0
        if type(t) ~= "table" then return 0 end
        for _ in pairs(t) do c = c + 1 end
        return c
    end
    KeybindConfigIds = KeybindConfigIds or {}
    DisabledKeybinds = DisabledKeybinds or {}
    PendingKeybindSaves = PendingKeybindSaves or {}

    local function _sanitizeId(s)
        return tostring(s or ""):gsub("%s+","_"):gsub("[^%w_%-]", ""):lower()
    end

    local processed = 0
    for f, api in pairs(KeybindAPI or {}) do
        if (type(f) == "table" or typeof(f) == "Instance") and type(api) == "table" then
            local frameKey = f
            local apiLocal = api
            KeybindConfigIds[frameKey] = KeybindConfigIds[frameKey] or ("ui.keybinds.disabled." .. _sanitizeId(frameKey.Name or tostring(frameKey)))
            if type(apiLocal.IsDisabled) ~= "function" then
                apiLocal.IsDisabled = function() return DisabledKeybinds[frameKey] == true end
            end
            if type(apiLocal.SetDisabled) ~= "function" then
                apiLocal.SetDisabled = function(b)
                    DisabledKeybinds[frameKey] = not not b
                    if type(apiLocal.SetDisabledAppearance) == "function" then apiLocal.SetDisabledAppearance(DisabledKeybinds[frameKey]) end
                    if type(SetConfig) == "function" then
                        SetConfig(KeybindConfigIds[frameKey], DisabledKeybinds[frameKey])
                    end
                    if type(apiLocal.Refresh) == "function" then apiLocal.Refresh() end
                end
            end
            if type(apiLocal.ToggleDisabled) ~= "function" then
                apiLocal.ToggleDisabled = function() apiLocal.SetDisabled(not apiLocal.IsDisabled()) end
            end
            if type(GetConfig) == "function" then
                local v = GetConfig(KeybindConfigIds[frameKey], DisabledKeybinds[frameKey])
                DisabledKeybinds[frameKey] = not not v
            end
            if type(apiLocal.SetDisabled) == "function" then
                apiLocal.SetDisabled(DisabledKeybinds[frameKey])
            end
        end
    end
    
end

-- ** Persist Disabled/Enabled Keybind Logic Ends Here ** --

---------------------------------------------------------------------------

-- ** Stick Beneath Player Logic Starts Here ** --
do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")

    local LocalPlayer = Players.LocalPlayer
    local enabled = false
    local conn = nil
    local stickTarget = nil
    local respawnConns = {}
    local respawnWatcherActive = false
    local savedPlayerCFrame = nil
    local savedAutoRotate = nil

    local MAX_DISTANCE = 300
    local DEPTH_UNDER_FEET = 6.5
    local SPIN_RADIUS = 1
    local SPIN_SPEED = 120

    local function isValidTarget(pl)
        if not pl or pl == LocalPlayer then return false end
        if not pl.Character then return false end
        local pp = pl.Character.PrimaryPart or pl.Character:FindFirstChild("HumanoidRootPart")
        if not pp or not pp.Parent then return false end
        local humanoid = pl.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid or type(humanoid.Health) ~= "number" then return false end
        if humanoid.Health <= 0 then return false end
        return true
    end

    local function isEnemyByTeamCheck(pl)
        if not pl or pl == LocalPlayer then return false end
        local isEnemy = true
        if _G and _G.Vozex_TeamCheck then
            if type(_G.Vozex_TeamCheck.IsEnemy) == "function" then
                local ok, res = pcall(_G.Vozex_TeamCheck.IsEnemy, pl)
                isEnemy = ok and not not res
            elseif type(_G.Vozex_TeamCheck.IsTeammate) == "function" then
                local ok, isTeam = pcall(_G.Vozex_TeamCheck.IsTeammate, pl)
                isEnemy = not (ok and isTeam)
            end
        end
        return isEnemy
    end

    local function findStickTarget()
        local cam = Workspace.CurrentCamera
        if not cam then return nil end
        local look = cam.CFrame.LookVector
        local origin = cam.CFrame.Position
        local best, bestDist = nil, math.huge
        for _, pl in ipairs(Players:GetPlayers()) do
            if isValidTarget(pl) and isEnemyByTeamCheck(pl) then
                local pp = pl.Character.PrimaryPart or pl.Character:FindFirstChild("HumanoidRootPart")
                local toTarget = pp.Position - origin
                local dot = look:Dot(toTarget.Unit)
                if dot > 0.5 then
                    local dist = toTarget.Magnitude
                    if dist < MAX_DISTANCE and dist < bestDist then
                        best = pl
                        bestDist = dist
                    end
                end
            end
        end
        return best
    end

    local function stopRespawnWatcher()
        if not respawnWatcherActive then return end
        respawnWatcherActive = false
        for _,c in ipairs(respawnConns) do
            pcall(function() if c and c.Disconnect then c:Disconnect() end end)
        end
        respawnConns = {}
    end

    local function startRespawnWatcher()
        if respawnWatcherActive then return end
        respawnWatcherActive = true
        for _,p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local function onChar(char)
                    if not p or p == LocalPlayer then return end
                    if isEnemyByTeamCheck(p) and isValidTarget(p) then
                        stickTarget = p
                        stopRespawnWatcher()
                    end
                end
                if p.Character then onChar(p.Character) end
                if p.CharacterAdded then table.insert(respawnConns, p.CharacterAdded:Connect(onChar)) end
            end
        end
        table.insert(respawnConns, Players.PlayerAdded:Connect(function(p)
            if p == LocalPlayer then return end
            local function onChar(char)
                if isEnemyByTeamCheck(p) and isValidTarget(p) then
                    stickTarget = p
                    stopRespawnWatcher()
                end
            end
            if p.Character then onChar(p.Character) end
            if p.CharacterAdded then table.insert(respawnConns, p.CharacterAdded:Connect(onChar)) end
        end))
    end

    local originalCollisionStates = {}
    local function setCharacterCollisions(state)
        if not LocalPlayer or not LocalPlayer.Character then return end
        for _,part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                if state == nil then
                    originalCollisionStates[part] = part.CanCollide
                else
                    local prev = originalCollisionStates[part]
                    if prev ~= nil then
                        part.CanCollide = prev
                    else
                        part.CanCollide = not not state
                    end
                end
                if state ~= nil then
                    part.CanCollide = not not state
                end
            end
        end
    end

    local function moveToGroundAndRestore()
        if not LocalPlayer or not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return end
        local root = LocalPlayer.Character.PrimaryPart
        local origin = root.Position + Vector3.new(0, 50, 0)
        local ray = Workspace:Raycast(origin, Vector3.new(0, -200, 0))
        if ray and ray.Position then
            local targetPos = ray.Position + Vector3.new(0, 3, 0)
            LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(targetPos))
        else
            LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(root.Position + Vector3.new(0, 10, 0)))
        end
        setCharacterCollisions(true)
    end

    local spinRotation = 0
    local prevTick = tick()

    local function startBeneath()
        if conn then return end
        local lastSelect = 0
        local SELECT_INTERVAL = 0.25
        prevTick = tick()
        conn = RunService.Heartbeat:Connect(function()
            if not enabled then return end
            if not LocalPlayer or not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return end
            local now = tick()
            local dt = now - prevTick
            prevTick = now

            if not stickTarget and now - lastSelect >= SELECT_INTERVAL then
                stickTarget = findStickTarget()
                lastSelect = now
            end

            if stickTarget and (not isValidTarget(stickTarget) or not isEnemyByTeamCheck(stickTarget)) then
                stickTarget = nil
                if enabled then
                    stopBeneath()
                    local api = ToggleAPI and ToggleAPI[stickbBeneathPlayerToggle]
                    pcall(function()
                        if api and api.Set then api.Set(false) end
                        SetConfig("rage.stickBeneathPlayer", false)
                    end)
                end
                return
            end

            if not stickTarget then
                return
            end

            local tp = stickTarget.Character.PrimaryPart or stickTarget.Character:FindFirstChild("HumanoidRootPart")
            if tp and tp.Position then
                spinRotation = spinRotation + (dt * SPIN_SPEED)
                local ox = math.cos(spinRotation) * SPIN_RADIUS
                local oz = math.sin(spinRotation) * SPIN_RADIUS
                local beneathPos = tp.Position + Vector3.new(ox, -DEPTH_UNDER_FEET, oz)
                local dest = CFrame.new(beneathPos, tp.Position)

                local useSmoothing = false
                local sToggleApi = ToggleAPI and ToggleAPI[useStickSmoothingToggle]
                if sToggleApi and sToggleApi.Get then
                    useSmoothing = not not sToggleApi.Get()
                else
                    useSmoothing = GetConfig("rage.useStickSmoothing", false)
                end

                if useSmoothing then
                    local intensity = nil
                    local sApi = SliderAPI and SliderAPI[smoothStickingSlider]
                    if sApi and sApi.Get then
                        intensity = sApi.Get()
                    else
                        intensity = GetConfig("rage.smoothStickingIntensity", 20)
                    end
                    if type(intensity) ~= "number" then intensity = 20 end
                    local alpha = math.clamp(intensity / 100, 0, 1)
                    local lerpAlpha = math.clamp(alpha * (dt * 8), 0, 1)
                    LocalPlayer.Character:SetPrimaryPartCFrame(LocalPlayer.Character.PrimaryPart.CFrame:Lerp(dest, lerpAlpha))
                else
                    LocalPlayer.Character:SetPrimaryPartCFrame(dest)
                end
            end
        end)
    end

    local function stopBeneath()
        if conn then
            if conn.Disconnect then conn:Disconnect() end
            conn = nil
        end
        stickTarget = nil
        stopRespawnWatcher()
        
        do
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and savedAutoRotate ~= nil then
                pcall(function() humanoid.AutoRotate = savedAutoRotate end)
                savedAutoRotate = nil
            end
        end
        if savedPlayerCFrame and LocalPlayer and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
            pcall(function()
                LocalPlayer.Character:SetPrimaryPartCFrame(savedPlayerCFrame)
            end)
            savedPlayerCFrame = nil
        else
            moveToGroundAndRestore()
        end
        
    end

    do
        local api = ToggleAPI and ToggleAPI[stickbBeneathPlayerToggle]
        if api then
            local prev = api.OnToggle
            api.OnToggle = function(state)
                if prev then pcall(prev, state) end
                enabled = not not state
                if enabled then
                    if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
                        pcall(function() savedPlayerCFrame = LocalPlayer.Character.PrimaryPart.CFrame end)
                    end
                
                    do
                        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            pcall(function()
                                savedAutoRotate = humanoid.AutoRotate
                                humanoid.AutoRotate = false
                            end)
                        end
                    end
                    
                    local otherApi = ToggleAPI and ToggleAPI[stickToToggle]
                    pcall(function()
                        if otherApi and otherApi.Set then otherApi.Set(false) end
                        SetConfig("rage.stickToTarget", false)
                    end)
                    setCharacterCollisions(false)
                    startRespawnWatcher()
                    startBeneath()
                    makeNotification("Stick Beneath Player is ON", 3)
                else
                    stopBeneath()
                    makeNotification("Stick Beneath Player is OFF", 3)
                end
            end
            if api.Set then
                local prevOn = api.OnToggle
                api.OnToggle = nil
                pcall(api.Set, GetConfig("rage.stickBeneathPlayer", false))
                api.OnToggle = prevOn
            end
        end
    end

    RegisterUnload(function()
        stopBeneath()
    end)
end

-- ** Stick Beneath Player Logic Ends Here ** --

-- ** Model Colors Logic Starts Here ** --
do
    local modelsColorState = {}
    local lastAppliedColor = nil
    local colorHeartbeat = nil

    local function revertModelsColor()
        for part, originalColor in pairs(modelsColorState) do
            if part and part.Parent then
                part.Color = originalColor
            end
        end
        modelsColorState = {}
        lastAppliedColor = nil
    end

    local function applyModelsColor(color)
        if not color or typeof(color) ~= "Color3" then return end
        revertModelsColor()
        
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Color and obj.Transparency < 0.99 then
                modelsColorState[obj] = obj.Color
                obj.Color = color
            end
        end
        lastAppliedColor = color
    end

    task.defer(function()
        for i=1,60 do
            if ColorPickerAPI and modelsColorPicker then
                local colorApi = ColorPickerAPI[modelsColorPicker]
                if colorApi then
                    local toggleApi = ToggleAPI and ToggleAPI[useModelsColorToggle]
                    if toggleApi then

                        do
                            local prev = colorApi.OnChange
                            colorApi.OnChange = function(col)
                                if prev then prev(col) end
                                if toggleApi.Get and toggleApi.Get() then
                                    applyModelsColor(col)
                                end
                            end
                        end

                        local savedToggle = GetConfig and GetConfig("customization.useModelsColor", nil)
                        if type(savedToggle) == "boolean" then
                            toggleApi.Set(savedToggle)
                        end

                        do
                            local prev = toggleApi.OnToggle
                            local descConn = nil
                            toggleApi.OnToggle = function(state)
                                if prev then prev(state) end
                                if SetConfig then SetConfig("customization.useModelsColor", state) end
                                if state then
                                    if not descConn then
                                        descConn = workspace.DescendantAdded:Connect(function(desc)
                                            if toggleApi.Get and toggleApi.Get() and desc:IsA("BasePart") and desc.Color and desc.Transparency < 0.99 and not modelsColorState[desc] then
                                                local c = colorApi.Get and colorApi.Get()
                                                if c then
                                                    modelsColorState[desc] = desc.Color
                                                    desc.Color = c
                                                end
                                            end
                                        end)
                                    end
                                    local c = colorApi.Get and colorApi.Get()
                                    if c then applyModelsColor(c) end
                                else
                                    if descConn then descConn:Disconnect(); descConn = nil end
                                    revertModelsColor()
                                end
                            end
                        end

                        if toggleApi.Get and toggleApi.Get() then
                            local descConn = workspace.DescendantAdded:Connect(function(desc)
                                if toggleApi.Get and toggleApi.Get() and desc:IsA("BasePart") and desc.Color and desc.Transparency < 0.99 and not modelsColorState[desc] then
                                    local c = colorApi.Get and colorApi.Get()
                                    if c then
                                        modelsColorState[desc] = desc.Color
                                        desc.Color = c
                                    end
                                end
                            end)
                            colorHeartbeat = descConn
                            local c = colorApi.Get and colorApi.Get()
                            if c then applyModelsColor(c) end
                        end

                        break
                    end
                end
            end
            task.wait(0.1)
        end
    end)

    RegisterUnload(function()
        if colorHeartbeat and colorHeartbeat.Disconnect then colorHeartbeat:Disconnect() end
        revertModelsColor()
    end)
end

-- ** Model Colors Logic Ends Here ** --

---------------------------------------------------------------------------

-- ** Lightning Logic Starts Here ** --
do
    local Lighting = game:GetService("Lighting")
    local lightningIntensityApi = nil
    local lightningToggleApi = nil
    local savedLighting = nil

    local function saveOriginalLighting()
        if not savedLighting then
            savedLighting = {
                Brightness = Lighting.Brightness,
                Ambient = Lighting.Ambient,
                OutdoorAmbient = Lighting.OutdoorAmbient,
                GlobalShadows = Lighting.GlobalShadows,
            }
        end
    end

    local function restoreOriginalLighting()
        if not savedLighting then return end
        Lighting.Brightness = savedLighting.Brightness
        Lighting.Ambient = savedLighting.Ambient
        Lighting.OutdoorAmbient = savedLighting.OutdoorAmbient
        Lighting.GlobalShadows = savedLighting.GlobalShadows
        savedLighting = nil
    end

    local function applyIntensity(v)
        if type(v) ~= "number" then return end
        saveOriginalLighting()
        local mult = v / 100
        if mult < 0.01 then mult = 0.01 end
        if mult > 2 then mult = 2 end
        local baseB = (savedLighting and savedLighting.Brightness) or Lighting.Brightness
        local baseAmbient = (savedLighting and savedLighting.Ambient) or Lighting.Ambient
        local baseOutdoor = (savedLighting and savedLighting.OutdoorAmbient) or Lighting.OutdoorAmbient
        Lighting.Brightness = baseB * mult
        Lighting.Ambient = Color3.new(baseAmbient.R * mult, baseAmbient.G * mult, baseAmbient.B * mult)
        Lighting.OutdoorAmbient = Color3.new(baseOutdoor.R * mult, baseOutdoor.G * mult, baseOutdoor.B * mult)
    end

    task.defer(function()
        for i=1,60 do
            if SliderAPI and lightningIntensitySlider then lightningIntensityApi = SliderAPI[lightningIntensitySlider] end
            if ToggleAPI and useLightningIntensityToggle then lightningToggleApi = ToggleAPI[useLightningIntensityToggle] end
            if lightningIntensityApi and lightningToggleApi then break end
            task.wait(0.1)
        end
        if not lightningIntensityApi or not lightningToggleApi then return end

        do
            local prev = lightningIntensityApi.OnChange
            lightningIntensityApi.OnChange = function(v)
                if prev then prev(v) end
                if lightningToggleApi.Get and lightningToggleApi.Get() then
                    applyIntensity(v)
                end
            end
        end

        do
            local prev = lightningToggleApi.OnToggle
            lightningToggleApi.OnToggle = function(state)
                if prev then prev(state) end
                if state then
                    local v = lightningIntensityApi.Get and lightningIntensityApi.Get() or (GetConfig and GetConfig("customization.lightningIntensity", 100) or 100)
                    applyIntensity(v)
                else
                    restoreOriginalLighting()
                end
            end
        end

        if lightningToggleApi.Get and lightningToggleApi.Get() then
            local v = lightningIntensityApi.Get and lightningIntensityApi.Get() or (GetConfig and GetConfig("customization.lightningIntensity", 100) or 100)
            applyIntensity(v)
        end
    end)

    RegisterUnload(function()
        restoreOriginalLighting()
    end)
end

-- ** Lightning Logic Ends Here ** --

---------------------------------------------------------------------------

-- ** Show FPS Logic Starts Here ** --
local fpsOverlayGui = nil
local fpsOverlayFrame = nil
local fpsLabel = nil
local fpsRenderConn = nil
local fpsDragConn = nil
local lastFpsTime = 0
local frameCount = 0
local currentFps = 0
local fpsUpdateInterval = 0.5

local function CreateFpsOverlay()
    if fpsOverlayGui then return fpsOverlayGui end
    local ok
    fpsOverlayGui = Instance.new("ScreenGui")
    fpsOverlayGui.Name = "Vozex_FpsOverlay"
    fpsOverlayGui.ResetOnSpawn = false
    if gui and gui.Parent then
        fpsOverlayGui.Parent = gui.Parent
    else
        fpsOverlayGui.Parent = game:GetService("CoreGui")
    end

    fpsOverlayFrame = Instance.new("Frame")
    fpsOverlayFrame.Name = "FpsOverlayFrame"
    fpsOverlayFrame.Size = UDim2.new(0, 120, 0, 50)
    fpsOverlayFrame.Position = UDim2.new(0.5, -60, 0, 15)
    fpsOverlayFrame.AnchorPoint = Vector2.new(0.5, 0)
    fpsOverlayFrame.BackgroundColor3 = COLORS.panelDark
    fpsOverlayFrame.BackgroundTransparency = 0.85
    fpsOverlayFrame.BorderSizePixel = 0
    fpsOverlayFrame.Active = true
    fpsOverlayFrame.Parent = fpsOverlayGui

    local savedPos = GetConfig and GetConfig("ui.fpsOverlayPos", nil) or nil
    if type(savedPos) == "table" then
        local xs = savedPos.xScale or 0.5
        local xo = savedPos.xOffset or -60
        local ys = savedPos.yScale or 0
        local yo = savedPos.yOffset or 15
        fpsOverlayFrame.Position = UDim2.new(xs, xo, ys, yo)
    end

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = fpsOverlayFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = COLORS.accent
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = fpsOverlayFrame

    fpsLabel = Instance.new("TextLabel")
    fpsLabel.Name = "FpsLabel"
    fpsLabel.Size = UDim2.new(1, -10, 1, -10)
    fpsLabel.Position = UDim2.new(0, 5, 0, 5)
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.TextColor3 = COLORS.accent
    fpsLabel.Font = Enum.Font.GothamBold
    fpsLabel.TextSize = 20
    fpsLabel.TextScaled = false
    fpsLabel.Text = "FPS: 0"
    fpsLabel.Parent = fpsOverlayFrame

    fpsOverlayFrame.ClipsDescendants = true

    local function updateFps()
        local now = tick()
        frameCount = frameCount + 1
        if now - lastFpsTime >= fpsUpdateInterval then
            currentFps = math.floor(frameCount / (now - lastFpsTime))
            fpsLabel.Text = "FPS: " .. currentFps
            frameCount = 0
            lastFpsTime = now
        end
    end

    fpsRenderConn = RunService.RenderStepped:Connect(updateFps)

    local dragging = false
    local dragStart, startPos

    fpsOverlayFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = fpsOverlayFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if SetConfig then
                        SetConfig("ui.fpsOverlayPos", {
                            xScale = fpsOverlayFrame.Position.X.Scale,
                            xOffset = fpsOverlayFrame.Position.X.Offset,
                            yScale = fpsOverlayFrame.Position.Y.Scale,
                            yOffset = fpsOverlayFrame.Position.Y.Offset
                        })
                    end
                end
            end)
        end
    end)

    fpsDragConn = UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragStart and startPos then
            local delta = input.Position - dragStart
            fpsOverlayFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    return fpsOverlayGui
end

local function enableFpsOverlay()
    if not fpsOverlayGui then
        CreateFpsOverlay()
    end
    if fpsOverlayGui then
        fpsOverlayGui.Enabled = true
    end
end

local function disableFpsOverlay()
    if fpsOverlayGui then
        fpsOverlayGui.Enabled = false
    end
end

local fpsToggleApi = ToggleAPI and ToggleAPI[showFpsToggle]
if fpsToggleApi then
    local prev = fpsToggleApi.OnToggle
    fpsToggleApi.OnToggle = function(state)
        if prev then prev(state) end
        if state then
            enableFpsOverlay()
        else
            disableFpsOverlay()
        end
    end
    if fpsToggleApi.Get and fpsToggleApi.Get() then
        enableFpsOverlay()
    end
else
    if GetConfig and GetConfig("settings.showFps", false) then
        enableFpsOverlay()
    end
end

RegisterUnload(function()
    if fpsOverlayGui then
        fpsOverlayGui:Destroy()
    end
    if fpsRenderConn then fpsRenderConn:Disconnect() end
    if fpsDragConn then fpsDragConn:Disconnect() end
end)

-- ** Show FPS Logic Ends Here ** --

---------------------------------------------------------------------------

-- ** END OF SCRIPT ** --
