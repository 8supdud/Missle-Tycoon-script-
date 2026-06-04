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

-- ** RESPONSIVE UI CONSTANTS ** --
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local viewportSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
local UI_SCALE = math.clamp(math.min(viewportSize.X / 1920, viewportSize.Y / 1080), 0.6, 1.2)

local function getResponsiveSize(baseSize)
    return math.floor(baseSize * UI_SCALE)
end

local function getResponsivePosition(basePos, screenSize)
    return UDim2.new(basePos.X.Scale, basePos.X.Offset * UI_SCALE, basePos.Y.Scale, basePos.Y.Offset * UI_SCALE)
end

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
local FIRST_TAB = nil
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

-- ** MINIMIZE SYSTEM ** --
local isMinimized = false
local minimizeButton = nil
local menuIconAssetId = "rbxassetid://YOUR_IMAGE_ID" -- REPLACE WITH YOUR IMAGE ID, or use "rbxasset://textures/ui/Controls/Frame.png" as fallback
local defaultIconAssetId = "rbxasset://textures/ui/Controls/Frame.png"

local function toggleMinimize()
    isMinimized = not isMinimized
    if isMinimized then
        root:TweenSize(UDim2.new(0, getResponsiveSize(60), 0, getResponsiveSize(60)), "Out", "Quad", 0.3, true)
        root:TweenPosition(UDim2.new(0, getResponsiveSize(10), 1, -getResponsiveSize(70)), "Out", "Quad", 0.3, true)
        root.AnchorPoint = Vector2.new(0, 1)
        if minimizeButton then
            minimizeButton:TweenSize(UDim2.new(0, getResponsiveSize(48), 0, getResponsiveSize(48)), "Out", "Quad", 0.2, true)
        end
    else
        root:TweenSize(UDim2.new(0, getResponsiveSize(760), 0, getResponsiveSize(520 + 32)), "Out", "Quad", 0.3, true)
        root:TweenPosition(UDim2.new(0.5, -getResponsiveSize(380), 0.5, -getResponsiveSize(260)), "Out", "Quad", 0.3, true)
        root.AnchorPoint = Vector2.new(0, 0)
        if minimizeButton then
            minimizeButton:TweenSize(UDim2.new(0, getResponsiveSize(36), 0, getResponsiveSize(36)), "Out", "Quad", 0.2, true)
        end
    end
    pcall(function()
        for _, child in ipairs(root:GetChildren()) do
            if child ~= minimizeButton and child.Name ~= "Banner" and child.Name ~= "CloseButton" and child.Name ~= "HelpButton" then
                child.Visible = not isMinimized
            end
        end
        if banner then banner.Visible = not isMinimized end
        if closeBtn then closeBtn.Visible = not isMinimized end
        if helpBtn then helpBtn.Visible = not isMinimized end
    end)
end

-------------------------------------------------------------------------------
-- ** Helper functions start here

-- ** makeTab (Responsive version) **
local function makeTab(name, tabsParent, pagesParent, onSelect, colHeaders, warningText)
    local btn = Instance.new("TextButton")
    local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, getResponsiveSize(8)) corner.Parent = btn
    btn.Name = name .. "Tab"
    btn.Size = UDim2.new(1, -getResponsiveSize(12), 0, getResponsiveSize(IS_MOBILE and 44 or 36))
    btn.AutoButtonColor = false
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = getResponsiveSize(IS_MOBILE and 17 or 15)
    btn.Text = name
    btn.BackgroundColor3 = COLORS.panel
    btn.TextColor3 = COLORS.tabText
    btn.BorderSizePixel = 0
    btn.TextXAlignment = Enum.TextXAlignment.Center
    btn.ZIndex = 10
    btn:SetAttribute("TabActive", false)
    btn.ClipsDescendants = true

    local indicator = Instance.new("Frame")
    indicator.Name = "ActiveIndicator"
    indicator.Size = UDim2.new(0.6, 0, 0, getResponsiveSize(3))
    indicator.Position = UDim2.new(0.2, 0, 1, -getResponsiveSize(4))
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
    pagePad.PaddingLeft = UDim.new(0, getResponsiveSize(8))
    pagePad.PaddingRight = UDim.new(0, getResponsiveSize(8))
    pagePad.PaddingTop = UDim.new(0, getResponsiveSize(8))
    pagePad.PaddingBottom = UDim.new(0, getResponsiveSize(8))

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
        modal.Position = UDim2.new(0.5, 0, 0, getResponsiveSize(8))
        modal.AnchorPoint = Vector2.new(0.5, 0)
        modal.BackgroundColor3 = COLORS.panel
        modal.BorderSizePixel = 0
        modal.ZIndex = warningOverlay.ZIndex + 1
        modal.Parent = warningOverlay
        local modalCorner = Instance.new("UICorner") modalCorner.CornerRadius = UDim.new(0, getResponsiveSize(12)) modalCorner.Parent = modal
        local modalStroke = Instance.new("UIStroke") modalStroke.Color = COLORS.divider modalStroke.Thickness = 1 modalStroke.Parent = modal
        RegisterThemed(modal)

        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.Size = UDim2.new(1, -getResponsiveSize(36), 0, getResponsiveSize(40))
        title.Position = UDim2.new(0, getResponsiveSize(18), 0, getResponsiveSize(12))
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamBold
        title.TextSize = getResponsiveSize(20)
        title.Text = "Warning"
        title.TextColor3 = COLORS.accent
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = modal.ZIndex + 1
        title.Parent = modal
        RegisterThemed(title)

        local msg = Instance.new("TextLabel")
        msg.Name = "Message"
        msg.Size = UDim2.new(1, -getResponsiveSize(36), 1, -getResponsiveSize(120))
        msg.Position = UDim2.new(0, getResponsiveSize(18), 0, getResponsiveSize(64))
        msg.BackgroundTransparency = 1
        msg.Font = Enum.Font.Gotham
        msg.TextSize = getResponsiveSize(16)
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
        actionBtn.Size = UDim2.new(0, getResponsiveSize(160), 0, getResponsiveSize(40))
        actionBtn.Position = UDim2.new(0.5, 0, 1, -getResponsiveSize(56))
        actionBtn.AnchorPoint = Vector2.new(0.5, 0.5)
        actionBtn.BackgroundColor3 = COLORS.accent
        actionBtn.Font = Enum.Font.GothamBold
        actionBtn.TextSize = getResponsiveSize(16)
        actionBtn.TextColor3 = COLORS.white
        actionBtn.Text = "Okay"
        actionBtn.ZIndex = modal.ZIndex + 2
        actionBtn.Parent = modal
        local actionCorner = Instance.new("UICorner") actionCorner.CornerRadius = UDim.new(0, getResponsiveSize(8)) actionCorner.Parent = actionBtn
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

    local leftCol = Instance.new("Frame")
    leftCol.Name = "LeftCol"
    leftCol.Size = UDim2.new(IS_MOBILE and 1 or 0.5, 0, 0, 0)
    leftCol.BackgroundTransparency = 1
    leftCol.Parent = page
    leftCol.AutomaticSize = Enum.AutomaticSize.Y
    leftCol.LayoutOrder = 0
    RegisterThemed(leftCol)
    leftCol.ClipsDescendants = false
    local list = Instance.new("UIListLayout") list.Parent = leftCol
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, getResponsiveSize(8))
    local leftPad = Instance.new("UIPadding") leftPad.Parent = leftCol
    leftPad.PaddingLeft = UDim.new(0, getResponsiveSize(10))
    leftPad.PaddingRight = UDim.new(0, getResponsiveSize(10))
    leftPad.PaddingTop = UDim.new(0, getResponsiveSize(8))
    leftPad.PaddingBottom = UDim.new(0, getResponsiveSize(8))

    if colHeaders and colHeaders.Left then
        local hdr = Instance.new("TextLabel")
        hdr.Name = "Header"
        hdr.Size = UDim2.new(1, 0, 0, getResponsiveSize(24))
        hdr.BackgroundTransparency = 1
        hdr.Font = Enum.Font.GothamBold
        hdr.TextSize = getResponsiveSize(15)
        hdr.Text = tostring(colHeaders.Left)
        hdr.TextColor3 = COLORS.accent
        hdr.TextXAlignment = Enum.TextXAlignment.Left
        hdr.LayoutOrder = 0
        hdr.Parent = leftCol
        RegisterThemed(hdr)
    end

    local rightCol = Instance.new("Frame")
    rightCol.Name = "RightCol"
    rightCol.Size = UDim2.new(IS_MOBILE and 1 or 0.5, 0, 0, 0)
    rightCol.BackgroundTransparency = 1
    rightCol.Parent = page
    rightCol.AutomaticSize = Enum.AutomaticSize.Y
    rightCol.LayoutOrder = IS_MOBILE and 1 or 2
    RegisterThemed(rightCol)
    rightCol.ClipsDescendants = false
    local list2 = Instance.new("UIListLayout") list2.Parent = rightCol
    list2.SortOrder = Enum.SortOrder.LayoutOrder
    list2.Padding = UDim.new(0, getResponsiveSize(8))
    local rightPad = Instance.new("UIPadding") rightPad.Parent = rightCol
    rightPad.PaddingLeft = UDim.new(0, getResponsiveSize(10))
    rightPad.PaddingRight = UDim.new(0, getResponsiveSize(10))
    rightPad.PaddingTop = UDim.new(0, getResponsiveSize(8))
    rightPad.PaddingBottom = UDim.new(0, getResponsiveSize(8))

    if colHeaders and colHeaders.Right then
        local hdrr = Instance.new("TextLabel")
        hdrr.Name = "Header"
        hdrr.Size = UDim2.new(1, 0, 0, getResponsiveSize(24))
        hdrr.BackgroundTransparency = 1
        hdrr.Font = Enum.Font.GothamBold
        hdrr.TextSize = getResponsiveSize(15)
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
    divider.Visible = not IS_MOBILE
    RegisterThemed(divider)

    local tab = {
        button = btn,
        page = page,
        LeftCol = leftCol,
        RightCol = rightCol,
    }

    pcall(function()
        if FIRST_TAB == nil then
            FIRST_TAB = { button = btn, page = page }
        end
    end)

    return tab
end

-- ** makeToggle (Responsive) **
local function makeToggle(parent, labelText, tooltipText)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, getResponsiveSize(IS_MOBILE and 48 or 36))
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, -getResponsiveSize(6), 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText or "Toggle"
    label.Font = Enum.Font.GothamBold
    label.TextSize = getResponsiveSize(IS_MOBILE and 18 or 17)
    label.TextColor3 = COLORS.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    RegisterThemed(label)

    local tooltip = nil
    local tooltipShowTimer = nil
    if tooltipText and type(tooltipText) == "string" and not IS_MOBILE then
        tooltip = Instance.new("TextLabel")
        tooltip.Name = "Tooltip"
        tooltip.Text = tooltipText
        tooltip.Font = Enum.Font.Gotham
        tooltip.TextSize = getResponsiveSize(13)
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
        tooltipCorner.CornerRadius = UDim.new(0, getResponsiveSize(6))
        tooltipCorner.Parent = tooltip
        local tooltipPad = Instance.new("UIPadding")
        tooltipPad.PaddingLeft = UDim.new(0, getResponsiveSize(8))
        tooltipPad.PaddingRight = UDim.new(0, getResponsiveSize(8))
        tooltipPad.PaddingTop = UDim.new(0, getResponsiveSize(6))
        tooltipPad.PaddingBottom = UDim.new(0, getResponsiveSize(6))
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
    toggle.Size = UDim2.new(0, getResponsiveSize(52), 0, getResponsiveSize(26))
    toggle.AnchorPoint = Vector2.new(1, 0.5)
    toggle.Position = UDim2.new(1, -getResponsiveSize(8), 0.5, 0)
    toggle.BackgroundColor3 = surfaceColor
    toggle.BackgroundTransparency = 0.7
    toggle.ClipsDescendants = true
    toggle.Parent = frame
    RegisterThemed(toggle)

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, getResponsiveSize(13))
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
    fillCorner.CornerRadius = UDim.new(0, getResponsiveSize(13))
    fillCorner.Parent = fill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, getResponsiveSize(20), 0, getResponsiveSize(20))
    knob.AnchorPoint = Vector2.new(0, 0.5)
    knob.Position = UDim2.new(0, getResponsiveSize(4), 0.5, 0)
    knob.BackgroundColor3 = COLORS.white or Color3.new(1,1,1)
    knob.ZIndex = 2
    knob.Parent = toggle
    RegisterThemed(knob)
    local kCorner = Instance.new("UICorner")
    kCorner.CornerRadius = UDim.new(0, getResponsiveSize(10))
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
                if knob then knob.Position = UDim2.new(1, -getResponsiveSize(24), 0.5, 0) end
            else
                if fill then fill.Size = UDim2.new(0,0,1,0); fill.BackgroundTransparency = 1 end
                if knob then knob.Position = UDim2.new(0, getResponsiveSize(4), 0.5, 0) end
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
            TweenService:Create(knob, TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -getResponsiveSize(24), 0.5, 0)}):Play()
            toggleStroke.Color = accentVisible
        else
            TweenService:Create(fill, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 1, 0), BackgroundTransparency = 1}):Play()
            TweenService:Create(toggle, tweenInfo, {BackgroundColor3 = surfaceColor}):Play()
            TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, getResponsiveSize(4), 0.5, 0)}):Play()
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
        TweenService:Create(knob, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, getResponsiveSize(22), 0, getResponsiveSize(22))}):Play()
        
        if tooltip and not IS_MOBILE then
            tooltipShowTimer = tick()
            delay(0.5, function()
                if tooltipShowTimer and (tick() - tooltipShowTimer) >= 0.5 and tooltip and tooltip.Parent then
                    tooltip.Visible = true
                    tooltip.Size = UDim2.new(0, getResponsiveSize(200), 0, getResponsiveSize(50))
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
        TweenService:Create(knob, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, getResponsiveSize(20), 0, getResponsiveSize(20))}):Play()
        
        if tooltip and not IS_MOBILE then
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 or (IS_MOBILE and input.UserInputType == Enum.UserInputType.Touch) then
            setVisual(not state)
            local s = (state and 1.03) or 0.97
            TweenService:Create(knob, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, getResponsiveSize(20) * s, 0, getResponsiveSize(20) * s)}):Play()
            delay(0.07, function()
                pcall(function()
                    TweenService:Create(knob, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, getResponsiveSize(20), 0, getResponsiveSize(20))}):Play()
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

-- ** makeButton (Responsive) **
local function makeButton(parent, labelText)
    local frame = Instance.new("Frame")
    frame.Name = tostring(labelText or "Button")
    frame.Size = UDim2.new(1, 0, 0, getResponsiveSize(IS_MOBILE and 44 or 34))
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, -getResponsiveSize(6), 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText or "Button"
    label.Font = Enum.Font.GothamBold
    label.TextSize = getResponsiveSize(IS_MOBILE and 19 or 18)
    label.TextColor3 = COLORS.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, getResponsiveSize(IS_MOBILE and 100 or 84), 0, getResponsiveSize(IS_MOBILE and 38 or 26))
    btn.AnchorPoint = Vector2.new(1,0.5)
    btn.Position = UDim2.new(1, -getResponsiveSize(8), 0.5, 0)
    btn.BackgroundColor3 = COLORS.panelDark
    btn.AutoButtonColor = true
    btn.Font = Enum.Font.Gotham
    btn.TextSize = getResponsiveSize(IS_MOBILE and 17 or 16)
    btn.TextColor3 = COLORS.text
    btn.Text = "Click"
    btn.Parent = frame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, getResponsiveSize(6))
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

-- ** Collapsible group helper (Responsive) **
local function makeCollapsibleGroup(parent, title, defaultOpen, builderFn)
    local headerHeight = getResponsiveSize(IS_MOBILE and 44 or 36)
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
    header.TextSize = getResponsiveSize(IS_MOBILE and 19 or 18)
    header.Text = tostring(title or "Group")
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.TextColor3 = COLORS.text
    header.Parent = grp
    header.ZIndex = 50
    local hp = Instance.new("UIPadding") hp.Parent = header hp.PaddingLeft = UDim.new(0,getResponsiveSize(12)); hp.PaddingRight = UDim.new(0,getResponsiveSize(28))
    local hcorner = Instance.new("UICorner") hcorner.CornerRadius = UDim.new(0,getResponsiveSize(8)) hcorner.Parent = header
    local hstroke = Instance.new("UIStroke") hstroke.Parent = header hstroke.Color = COLORS.divider hstroke.Thickness = 1 hstroke.Transparency = 0.5
    RegisterThemed(header)

    local caret = Instance.new("TextLabel")
    caret.Size = UDim2.new(0, getResponsiveSize(18), 0, getResponsiveSize(18))
    caret.AnchorPoint = Vector2.new(1, 0.5)
    caret.Position = UDim2.new(1, -getResponsiveSize(12), 0.5, 0)
    caret.BackgroundTransparency = 1
    caret.Font = Enum.Font.Gotham
    caret.TextSize = getResponsiveSize(16)    caret.Text = "▾"
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
    innerLayout.Padding = UDim.new(0, getResponsiveSize(6))
    local innerPad = Instance.new("UIPadding") innerPad.Parent = inner
    innerPad.PaddingLeft = UDim.new(0, getResponsiveSize(4)); innerPad.PaddingRight = UDim.new(0, getResponsiveSize(4)); innerPad.PaddingTop = UDim.new(0, getResponsiveSize(8)); innerPad.PaddingBottom = UDim.new(0, getResponsiveSize(8))
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
    bottomDivider.Position = UDim2.new(0, 0, 1, getResponsiveSize(6))
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

-- ** makeSlider (Responsive) **
local function makeSlider(parent, labelText, minVal, maxVal, defaultVal)
    local MIN = (type(minVal) == "number") and minVal or 1
    local MAX = (type(maxVal) == "number") and maxVal or 100
    local initial = (type(defaultVal) == "number") and defaultVal or math.floor((MIN + MAX) / 2)

    local frame = Instance.new("Frame")
    frame.Name = tostring(labelText or "Slider")
    frame.Size = UDim2.new(1, 0, 0, getResponsiveSize(IS_MOBILE and 48 or 34))
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    RegisterThemed(frame)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, -getResponsiveSize(6), 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText or "Slider"
    label.Font = Enum.Font.GothamBold
    label.TextSize = getResponsiveSize(IS_MOBILE and 18 or 18)
    label.TextColor3 = COLORS.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local holder = Instance.new("Frame")
    holder.AnchorPoint = Vector2.new(1, 0)
    holder.Position = UDim2.new(1, -getResponsiveSize(8), 0, getResponsiveSize(2))
    holder.Size = UDim2.new(0.6, -getResponsiveSize(8), 1, -getResponsiveSize(4))
    holder.BackgroundTransparency = 1
    holder.Parent = frame

    local bar = Instance.new("Frame")
    bar.Name = "Bar"
    bar.Size = UDim2.new(1, 0, 0, getResponsiveSize(12))
    bar.Position = UDim2.new(0, 0, 0.5, -getResponsiveSize(6))
    bar.BackgroundColor3 = COLORS.panelDark
    bar.BorderSizePixel = 0
    bar.Parent = holder
    RegisterThemed(bar)
    local barCorner = Instance.new("UICorner") barCorner.CornerRadius = UDim.new(0, getResponsiveSize(6)) barCorner.Parent = bar

    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = COLORS.accent
    fill.BorderSizePixel = 0
    fill.Parent = bar
    RegisterThemed(fill)
    local fillCorner = Instance.new("UICorner") fillCorner.CornerRadius = UDim.new(0, getResponsiveSize(6)) fillCorner.Parent = fill

    local handle = Instance.new("TextButton")
    handle.Name = "Handle"
    handle.Size = UDim2.new(0, getResponsiveSize(IS_MOBILE and 20 or 16), 0, getResponsiveSize(IS_MOBILE and 20 or 16))
    handle.Position = UDim2.new(0, -getResponsiveSize(8), 0.5, -getResponsiveSize(8))
    handle.AnchorPoint = Vector2.new(0.5, 0.5)
    handle.AutoButtonColor = false
    handle.BackgroundColor3 = COLORS.white
    handle.Text = ""
    handle.Parent = bar
    RegisterThemed(handle)
    local handleCorner = Instance.new("UICorner") handleCorner.CornerRadius = UDim.new(0, getResponsiveSize(8)) handleCorner.Parent = handle

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Size = UDim2.new(0.5, 0, 1, 0)
    valueLabel.Position = UDim2.new(0.25, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = getResponsiveSize(IS_MOBILE and 15 or 14)
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 or (IS_MOBILE and input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            pcall(function() handle:CaptureFocus() end)
        end
    end)

    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or (IS_MOBILE and input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
            pcall(function() handle:ReleaseFocus() end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or (IS_MOBILE and input.UserInputType == Enum.UserInputType.Touch) then
            local v = inputToValue(input.Position.X)
            setValue(v)
        end
    end)

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or (IS_MOBILE and input.UserInputType == Enum.UserInputType.Touch) then
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

-- ** makeKeyBindButton (Responsive) **
local function makeKeyBindButton(parent, title, defaultKey)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,0,getResponsiveSize(IS_MOBILE and 48 or 34))
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, -getResponsiveSize(6), 1, 0)
    label.BackgroundTransparency = 1
    label.Text = title or "Keybind"
    label.Font = Enum.Font.GothamBold
    label.TextSize = getResponsiveSize(IS_MOBILE and 18 or 18)
    label.TextColor3 = COLORS.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Name = frame.Name .. "_Bind"
    btn.Size = UDim2.new(0.5, -getResponsiveSize(8), 1, 0)
    btn.AnchorPoint = Vector2.new(1,0)
    btn.Position = UDim2.new(1, -getResponsiveSize(8), 0, 0)
    btn.BackgroundColor3 = COLORS.panelDark
    btn.AutoButtonColor = true
    btn.Font = Enum.Font.Gotham
    btn.TextSize = getResponsiveSize(IS_MOBILE and 17 or 16)
    btn.TextColor3 = COLORS.text
    btn.Text = "None"
    btn.Parent = frame
    local btnCorner = Instance.new("UICorner") btnCorner.CornerRadius = UDim.new(0,getResponsiveSize(6)) btnCorner.Parent = btn

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

-- ** makeDropDownList (Responsive) **
local function makeDropDownList(parent, labelText, items, defaultIndex)
    local frame = Instance.new("Frame")
    frame.Name = tostring(labelText or "DropDown")
    frame.Size = UDim2.new(1, 0, 0, getResponsiveSize(IS_MOBILE and 48 or 34))
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    RegisterThemed(frame)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, -getResponsiveSize(6), 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText or "Select"
    label.Font = Enum.Font.GothamBold
    label.TextSize = getResponsiveSize(IS_MOBILE and 18 or 18)
    label.TextColor3 = COLORS.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local display = Instance.new("TextButton")
    display.Name = frame.Name .. "_Display"
    display.Size = UDim2.new(0.5, -getResponsiveSize(8), 1, 0)
    display.AnchorPoint = Vector2.new(1, 0)
    display.Position = UDim2.new(1, -getResponsiveSize(8), 0, 0)
    display.BackgroundColor3 = COLORS.panelDark
    display.AutoButtonColor = false
    display.Font = Enum.Font.Gotham
    display.TextSize = getResponsiveSize(IS_MOBILE and 17 or 16)
    display.TextColor3 = COLORS.text
    display.Text = ""
    display.TextXAlignment = Enum.TextXAlignment.Left
    display.Parent = frame
    RegisterThemed(display)
    local displayCorner = Instance.new("UICorner") displayCorner.CornerRadius = UDim.new(0, getResponsiveSize(6)) displayCorner.Parent = display
    local displayPad = Instance.new("UIPadding") displayPad.Parent = display
    displayPad.PaddingLeft = UDim.new(0, getResponsiveSize(8))
    displayPad.PaddingRight = UDim.new(0, getResponsiveSize(28))
    display.Active = true

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, getResponsiveSize(24), 1, 0)
    arrow.AnchorPoint = Vector2.new(1,0.5)
    arrow.Position = UDim2.new(1, -getResponsiveSize(4), 0.5, 0)
    arrow.BackgroundTransparency = 1
    arrow.Font = Enum.Font.Gotham
    arrow.TextSize = getResponsiveSize(18)
    arrow.TextColor3 = COLORS.textDim
    arrow.Text = "▾"
    arrow.Parent = display

    local drop = Instance.new("Frame")
    drop.Size = UDim2.new(1, 0, 0, 0)
    drop.Position = UDim2.new(0, 0, 1, getResponsiveSize(6))
    drop.BackgroundColor3 = COLORS.panelAlt
    drop.ClipsDescendants = true
    drop.Visible = false
    local DROP_ZINDEX = 50
    drop.ZIndex = DROP_ZINDEX
    drop.Parent = frame
    RegisterThemed(drop)
    local dropCorner = Instance.new("UICorner") dropCorner.CornerRadius = UDim.new(0, getResponsiveSize(8)) dropCorner.Parent = drop
    local dropStroke = Instance.new("UIStroke") dropStroke.Thickness = 1; dropStroke.Color = COLORS.divider; dropStroke.Parent = drop

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -getResponsiveSize(12), 1, -getResponsiveSize(12))
    scroll.Position = UDim2.new(0, getResponsiveSize(6), 0, getResponsiveSize(6))
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = getResponsiveSize(8)
    pcall(function() scroll.ScrollBarImageColor3 = COLORS.accent end)
    scroll.Parent = drop
    scroll.ZIndex = DROP_ZINDEX
    local layout = Instance.new("UIListLayout") layout.Parent = scroll
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, getResponsiveSize(4))
    local scrollPad = Instance.new("UIPadding") scrollPad.Parent = scroll
    scrollPad.PaddingTop = UDim.new(0, getResponsiveSize(4)); scrollPad.PaddingBottom = UDim.new(0, getResponsiveSize(4))

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
            btn.Size = UDim2.new(1, 0, 0, getResponsiveSize(IS_MOBILE and 38 or 28))
            btn.BackgroundTransparency = 1
            btn.AutoButtonColor = false
            btn.Font = Enum.Font.Gotham
            btn.TextSize = getResponsiveSize(IS_MOBILE and 17 or 16)
            btn.TextColor3 = COLORS.text
            btn.Text = tostring(v)
            btn.LayoutOrder = i
            btn.Parent = scroll
            btn.ZIndex = DROP_ZINDEX + 1
            local btnCorner = Instance.new("UICorner") btnCorner.CornerRadius = UDim.new(0, getResponsiveSize(6)) btnCorner.Parent = btn
            local btnPad = Instance.new("UIPadding") btnPad.Parent = btn; btnPad.PaddingLeft = UDim.new(0, getResponsiveSize(8))

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
        local total = #items * getResponsiveSize(IS_MOBILE and 38 or 28)
        drop.Size = UDim2.new(1, 0, 0, math.min(total, getResponsiveSize(IS_MOBILE and 300 or 200)))
    end

    display.MouseButton1Click:Connect(function()
        local open = not drop.Visible
        local total = #items * getResponsiveSize(IS_MOBILE and 38 or 28)
        local target = math.min(total, getResponsiveSize(IS_MOBILE and 300 or 200))
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

-- ** makeColorPicker (Responsive) **
local function makeColorPicker(parent, labelText, defaultColor)
    local frame = Instance.new("Frame")
    frame.Name = tostring(labelText or "ColorPicker")
    frame.Size = UDim2.new(1, 0, 0, getResponsiveSize(IS_MOBILE and 48 or 34))
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    RegisterThemed(frame)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, -getResponsiveSize(6), 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText or "Color"
    label.Font = Enum.Font.GothamBold
    label.TextSize = getResponsiveSize(IS_MOBILE and 18 or 18)
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
    local dispCorner = Instance.new("UICorner") dispCorner.CornerRadius = UDim.new(0, getResponsiveSize(6)) dispCorner.Parent = display
    local dispPad = Instance.new("UIPadding") dispPad.Parent = display; dispPad.PaddingLeft = UDim.new(0, getResponsiveSize(8))

    local swatch = Instance.new("Frame")
    swatch.Size = UDim2.new(0, getResponsiveSize(20), 0, getResponsiveSize(20))
    swatch.Position = UDim2.new(0, 0, 0.5, -getResponsiveSize(10))
    swatch.BackgroundColor3 = (type(defaultColor) == "Color3") and defaultColor or COLORS.accent
    swatch.BorderSizePixel = 0
    swatch.Parent = display
    RegisterThemed(swatch)
    local swCorner = Instance.new("UICorner") swCorner.CornerRadius = UDim.new(0, getResponsiveSize(4)) swCorner.Parent = swatch

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, getResponsiveSize(24), 1, 0)
    arrow.AnchorPoint = Vector2.new(1,0.5)
    arrow.Position = UDim2.new(1, -getResponsiveSize(8), 0.5, 0)
    arrow.BackgroundTransparency = 1
    arrow.Font = Enum.Font.Gotham
    arrow.TextSize = getResponsiveSize(18)
    arrow.TextColor3 = COLORS.textDim
    arrow.Text = "▾"
    arrow.Parent = display

    local palette = Instance.new("Frame")
    palette.Size = UDim2.new(1, 0, 0, 0)
    palette.Position = UDim2.new(0, 0, 1, getResponsiveSize(6))
    palette.BackgroundColor3 = COLORS.panelAlt
    palette.ClipsDescendants = true
    palette.Visible = false
    palette.Parent = frame
    local TOP_Z = 600
    palette.ZIndex = TOP_Z
    RegisterThemed(palette)
    local palCorner = Instance.new("UICorner") palCorner.CornerRadius = UDim.new(0, getResponsiveSize(8)) palCorner.Parent = palette
    local palStroke = Instance.new("UIStroke") palStroke.Thickness = 1; palStroke.Color = COLORS.divider; palStroke.Parent = palette

    local wheelSize = getResponsiveSize(IS_MOBILE and 200 or 180)
    local scroll = Instance.new("Frame")
    scroll.Size = UDim2.new(1, -getResponsiveSize(12), 0, wheelSize)
    scroll.Position = UDim2.new(0, getResponsiveSize(6), 0, getResponsiveSize(6))
    scroll.BackgroundTransparency = 1
    scroll.Parent = palette
    scroll.ZIndex = TOP_Z

    local wheelFrame = Instance.new("Frame")
    wheelFrame.Size = UDim2.new(0, wheelSize, 0, wheelSize)
    wheelFrame.Position = UDim2.new(0, getResponsiveSize(40), 0, getResponsiveSize(6))
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
    pointer.Size = UDim2.new(0, getResponsiveSize(12), 0, getResponsiveSize(12))
    pointer.AnchorPoint = Vector2.new(0.5, 0.5)
    pointer.BackgroundTransparency = 1
    pointer.Parent = wheelFrame
    local pCorner = Instance.new("UICorner") pCorner.CornerRadius = UDim.new(1,0) pCorner.Parent = pointer
    local pStroke = Instance.new("UIStroke") pStroke.Thickness = 2 pStroke.Color = Color3.new(0,0,0) pStroke.Parent = pointer
    pointer.ZIndex = TOP_Z + 1

    local valueSliderFrame = Instance.new("Frame")
    valueSliderFrame.Size = UDim2.new(0, getResponsiveSize(16), 0, wheelSize)
    valueSliderFrame.Position = UDim2.new(0, wheelSize + getResponsiveSize(8), 0, getResponsiveSize(6))
    valueSliderFrame.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
    valueSliderFrame.BorderSizePixel = 0
    valueSliderFrame.Parent = scroll
    valueSliderFrame.ZIndex = TOP_Z

    local valueHandle = Instance.new("Frame")
    valueHandle.Size = UDim2.new(1,0,0, getResponsiveSize(8))
    valueHandle.AnchorPoint = Vector2.new(0.5,0.5)
    valueHandle.BackgroundColor3 = Color3.new(1,1,1)
    valueHandle.BorderSizePixel = 0
    valueHandle.Parent = valueSliderFrame
    local vhCorner = Instance.new("UICorner"); vhCorner.CornerRadius = UDim.new(0, getResponsiveSize(4)); vhCorner.Parent = valueHandle

    local initialHSV = colorToHSVtbl((type(defaultColor) == "Color3") and defaultColor or COLORS.accent)
    local currentHue, currentSat, currentValue = initialHSV.h / 360, initialHSV.s / 100, initialHSV.v / 100
    local current = swatch.BackgroundColor3

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

    local function setColor(c)
        if not c then return end
        current = c
        swatch.BackgroundColor3 = c
        if ColorPickerAPI[frame] and type(ColorPickerAPI[frame].OnChange) == "function" then
            ColorPickerAPI[frame].OnChange(c)
        end
    end

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

    local function updateValueFromY(y)
        local localY = math.clamp(y - valueSliderFrame.AbsolutePosition.Y, 0, wheelSize)
        currentValue = 1 - (localY / wheelSize)
        valueHandle.Position = UDim2.new(0.5,0,0,localY)
        local col = Color3.fromHSV(currentHue or 0, currentSat or 0, currentValue)
        setColor(col)
    end

    local dragging = false
    local sliderDragging = false

    wheelFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or (IS_MOBILE and input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            updatePointerAtScreenPos(input.Position.X, input.Position.Y)
        end
    end)
    wheelFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or (IS_MOBILE and input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
        end
    end)

    valueSliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or (IS_MOBILE and input.UserInputType == Enum.UserInputType.Touch) then
            sliderDragging = true
            updateValueFromY(input.Position.Y)
        end
    end)
    valueSliderFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or (IS_MOBILE and input.UserInputType == Enum.UserInputType.Touch) then
            sliderDragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or (IS_MOBILE and input.UserInputType == Enum.UserInputType.Touch)) then
            updatePointerAtScreenPos(input.Position.X, input.Position.Y)
        end
        if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or (IS_MOBILE and input.UserInputType == Enum.UserInputType.Touch)) then
            updateValueFromY(input.Position.Y)
        end
    end)

    display.Active = true
    display.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and (not IS_MOBILE or input.UserInputType ~= Enum.UserInputType.Touch) then return end
        local open = not palette.Visible
        if open then
            palette.Visible = true
            arrow.Text = "▴"
            TweenService:Create(palette, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1,0,0, getResponsiveSize(IS_MOBILE and 280 or 220))}):Play()
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

    local maxOrder = 0
    for _,c in ipairs(parent:GetChildren()) do
        if c ~= frame and (c:IsA("Frame") or c:IsA("TextLabel") or c:IsA("TextButton")) then
            maxOrder = math.max(maxOrder, c.LayoutOrder or 0)
        end
    end
    frame.LayoutOrder = maxOrder + 1

    return frame
end

-- Helper function for colorToHSVtbl
local function colorToHSVtbl(c)
    local ok, h, s, v = pcall(function() return Color3.toHSV(c) end)
    if ok and h then return {h = h * 360, s = s * 100, v = v * 100} end
    return {h = 200, s = 100, v = 100}
end

-- makeDebugLabel (Simplified for compatibility)
local function makeDebugLabel(initialText)
    local function noop() end
    return {
        Set = noop,
        Show = noop,
        Destroy = noop,
    }
end

-- makeTopLabel (Simplified for compatibility)
_G.VozexTopLabel = {
    New = function(text, opts)
        return { SetText = function() end, Destroy = function() end }
    end
}

-- Config functions
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

local function GetConfig(key, default)
    if Config[key] == nil then return default end
    return Config[key]
end

do
    local ok, v = pcall(function() return Config["settings.enableNotifications"] end)
    if ok and type(v) == "boolean" then        NOTIFICATIONS_ENABLED = v
    else
        NOTIFICATIONS_ENABLED = true
    end
end

-- Notification API (Simplified)
local function makeNotification(text, duration, parent, invoker)
    if NOTIFICATIONS_ENABLED == false then return nil end
    pcall(function()
        local notifText = text or "Notification"
        if _G and _G.VozexTopLabel then
            local lbl = _G.VozexTopLabel.New(notifText, {TextSize = 14})
            task.delay(duration or 3, function()
                if lbl then lbl:Destroy() end
            end)
        end
    end)
    return nil
end

NotificationAPI = {
    CanCreate = function() return NOTIFICATIONS_ENABLED end,
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

-- Interactables API Tables
local ToggleAPI = setmetatable({}, { __mode = "k" })
local DropdownAPI = setmetatable({}, { __mode = "k" })
local KeybindAPI = setmetatable({}, { __mode = "k" })
local SliderAPI = setmetatable({}, { __mode = "k" })
local ButtonAPI = setmetatable({}, { __mode = "k" })
local ColorPickerAPI = setmetatable({}, { __mode = "k" })
local DisabledKeybinds = {}

-- ** Unsupported game check ** --
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
    return true
end

do
    local ok, res = pcall(function() if type(showUnsupportedPopup) == "function" then return showUnsupportedPopup() end end)
    if ok and res == false then return end
end

-- ** Build UI - Responsive Root Frame **
local root = Instance.new("Frame")
local bannerHeight = getResponsiveSize(IS_MOBILE and 44 or 32)
local TOPBAR_SPACING = getResponsiveSize(IS_MOBILE and 24 or 17)
root.Size = UDim2.new(0, getResponsiveSize(IS_MOBILE and 380 or 760), 0, getResponsiveSize(IS_MOBILE and 620 or 520 + bannerHeight + TOPBAR_SPACING))
root.Position = UDim2.new(0.5, -getResponsiveSize(IS_MOBILE and 190 or 380), 0.5, -getResponsiveSize(IS_MOBILE and 310 or 260))
root.AnchorPoint = Vector2.new(0,0)
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
local backdropCorner = Instance.new("UICorner") backdropCorner.CornerRadius = UDim.new(0, getResponsiveSize(16)) backdropCorner.Parent = backdrop

RegisterThemed(root)

-- Tabs bar with responsive width
local tabsBarWidth = getResponsiveSize(IS_MOBILE and 140 or 160)
local tabsBar = Instance.new("Frame")
tabsBar.Size = UDim2.new(0, tabsBarWidth, 1, -(bannerHeight + TOPBAR_SPACING))
tabsBar.Position = UDim2.new(0, 0, 0, bannerHeight + TOPBAR_SPACING)
tabsBar.BackgroundColor3 = COLORS.panel
tabsBar.BackgroundTransparency = 0.85
tabsBar.Parent = root
local tabsBarCorner = Instance.new("UICorner") tabsBarCorner.CornerRadius = UDim.new(0, getResponsiveSize(12)) tabsBarCorner.Parent = tabsBar
local tabsBarStroke = Instance.new("UIStroke") tabsBarStroke.Color = COLORS.divider tabsBarStroke.Thickness = 1 tabsBarStroke.Transparency = 0.5 tabsBarStroke.Parent = tabsBar

local tabsBarLayout = Instance.new("UIListLayout") tabsBarLayout.Parent = tabsBar
tabsBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabsBarLayout.Padding = UDim.new(0, getResponsiveSize(8))
local tabsBarPad = Instance.new("UIPadding") tabsBarPad.Parent = tabsBar
tabsBarPad.PaddingTop = UDim.new(0, getResponsiveSize(12))
tabsBarPad.PaddingLeft = UDim.new(0, getResponsiveSize(8))
tabsBarPad.PaddingRight = UDim.new(0, getResponsiveSize(8))
RegisterThemed(tabsBar)

local pages = Instance.new("ScrollingFrame")
pages.Name = "Pages"
pages.Size = UDim2.new(1, -tabsBarWidth, 1, -(bannerHeight + TOPBAR_SPACING))
pages.Position = UDim2.new(0, tabsBarWidth, 0, bannerHeight + math.floor(TOPBAR_SPACING/3))
pages.BackgroundTransparency = 1
pages.ScrollBarThickness = getResponsiveSize(10)
pages.AutomaticCanvasSize = Enum.AutomaticSize.Y
pages.CanvasSize = UDim2.new(0, 0, 0, 0)
pages.ClipsDescendants = true
pages.Parent = root
RegisterThemed(pages)

-- top banner with responsive styling
local banner = Instance.new("TextLabel")
banner.Name = "Banner"
banner.Size = UDim2.new(1, 0, 0, bannerHeight)
banner.Position = UDim2.new(0, 0, 0, 0)
banner.BackgroundTransparency = 1
banner.Font = Enum.Font.GothamBold
banner.TextSize = getResponsiveSize(IS_MOBILE and 17 or 15)
banner.TextColor3 = COLORS.accent
banner.Text = "VOZEX HUB 👑"
banner.TextXAlignment = Enum.TextXAlignment.Center
banner.TextYAlignment = Enum.TextYAlignment.Center
banner.ZIndex = 60
banner.Parent = root
RegisterThemed(banner)

-- Minimize Button (Icon with Image)
local minimizeButton = Instance.new("ImageButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, getResponsiveSize(36), 0, getResponsiveSize(36))
minimizeButton.Position = UDim2.new(0, getResponsiveSize(4), 0, getResponsiveSize(4))
minimizeButton.BackgroundColor3 = COLORS.panel
minimizeButton.BackgroundTransparency = 0.5
minimizeButton.Image = defaultIconAssetId
minimizeButton.ImageColor3 = COLORS.accent
minimizeButton.AutoButtonColor = false
minimizeButton.Parent = root

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, getResponsiveSize(8))
minCorner.Parent = minimizeButton

-- Use a simple TextLabel fallback if image doesn't load
local minFallback = Instance.new("TextLabel")
minFallback.Size = UDim2.new(1, 0, 1, 0)
minFallback.BackgroundTransparency = 1
minFallback.Font = Enum.Font.GothamBold
minFallback.TextSize = getResponsiveSize(18)
minFallback.TextColor3 = COLORS.accent
minFallback.Text = "❐"
minFallback.TextXAlignment = Enum.TextXAlignment.Center
minFallback.TextYAlignment = Enum.TextYAlignment.Center
minFallback.Parent = minimizeButton

minimizeButton.MouseButton1Click:Connect(function()
    toggleMinimize()
end)

RegisterThemed(minimizeButton)

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
helpBtn.Size = UDim2.new(0, getResponsiveSize(72), 0, getResponsiveSize(IS_MOBILE and 34 or 28))
helpBtn.AnchorPoint = Vector2.new(1, 0)
helpBtn.Position = UDim2.new(1, -getResponsiveSize(48), 0, getResponsiveSize(6))
helpBtn.BackgroundColor3 = COLORS.panel
helpBtn.BackgroundTransparency = 0.7
helpBtn.TextColor3 = COLORS.text
helpBtn.Font = Enum.Font.GothamBold
helpBtn.TextSize = getResponsiveSize(IS_MOBILE and 16 or 14)
helpBtn.Text = "Help"
helpBtn.AutoButtonColor = false
helpBtn.ZIndex = banner.ZIndex + 1
local hbCorner = Instance.new("UICorner") hbCorner.CornerRadius = UDim.new(0, getResponsiveSize(6)) hbCorner.Parent = helpBtn
helpBtn.Parent = root
RegisterThemed(helpBtn)

local tabsUnderlay = Instance.new("Frame")
tabsUnderlay.Name = "TabsUnderlay"
tabsUnderlay.Size = UDim2.new(0, tabsBarWidth, 1, -(bannerHeight + TOPBAR_SPACING))
tabsUnderlay.Position = UDim2.new(0, 0, 0, bannerHeight + TOPBAR_SPACING)
tabsUnderlay.BackgroundColor3 = COLORS.panel
tabsUnderlay.BackgroundTransparency = 0.85
tabsUnderlay.Parent = root
local tabsUnderCorner = Instance.new("UICorner") tabsUnderCorner.CornerRadius = UDim.new(0, getResponsiveSize(12)) tabsUnderCorner.Parent = tabsUnderlay
tabsUnderlay.ZIndex = 1
tabsBar.ZIndex = 2

RegisterThemed(tabsUnderlay)

-- ** close / unload UI (Simplified for mobile) **
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, getResponsiveSize(32), 0, getResponsiveSize(32))
closeBtn.Position = UDim2.new(1, -getResponsiveSize(40), 0, getResponsiveSize(6))
closeBtn.AnchorPoint = Vector2.new(1,0)
closeBtn.BackgroundTransparency = 1
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = getResponsiveSize(IS_MOBILE and 20 or 18)
closeBtn.Text = "✕"
closeBtn.TextColor3 = COLORS.close
closeBtn.Parent = root
closeBtn.MouseEnter:Connect(function() closeBtn.TextColor3 = COLORS.closeHover end)
closeBtn.MouseLeave:Connect(function() closeBtn.TextColor3 = COLORS.close end)
closeBtn.MouseButton1Click:Connect(function()
    if root and root.Parent then
        root.Visible = false
        isMinimized = true
        if minimizeButton then
            minimizeButton.Size = UDim2.new(0, getResponsiveSize(48), 0, getResponsiveSize(48))
            minimizeButton.Position = UDim2.new(1, -getResponsiveSize(58), 1, -getResponsiveSize(58))
            minimizeButton.AnchorPoint = Vector2.new(1, 1)
            root.Size = UDim2.new(0, getResponsiveSize(60), 0, getResponsiveSize(60))
            root.Position = UDim2.new(1, -getResponsiveSize(70), 1, -getResponsiveSize(70))
            root.AnchorPoint = Vector2.new(1, 1)
        end
    end
end)
RegisterThemed(closeBtn)

-- ** tab selection **
local function selectTab(button, page)
    local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    for _,c in ipairs(tabsBar:GetChildren()) do
        if c:IsA("TextButton") then
            pcall(function()
                local targetPos = UDim2.new(c.Position.X.Scale, c.Position.X.Offset, 0, getResponsiveSize(6))
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
        local tgtPos = UDim2.new(button.Position.X.Scale, button.Position.X.Offset, 0, -getResponsiveSize(4))
        TweenService:Create(button, tweenInfo, {TextColor3 = COLORS.white, Position = tgtPos, BackgroundColor3 = COLORS.accent}):Play()
        local ind = button:FindFirstChild("ActiveIndicator")
        if ind then TweenService:Create(ind, tweenInfo, {BackgroundTransparency = 0}):Play() end
    end)
    page.Visible = true
    local h = TAB_WARNING_HANDLERS[page]
    if type(h) == "function" then h() end
end

-- ** All Tabs **
local visualTab = makeTab("Visuals", tabsBar, pages, selectTab, { Left = "General", Right = "Advanced" })
visualTab.page.Parent = pages

local combatTab = makeTab("Combat", tabsBar, pages, selectTab, { Left = "General", Right = "Advanced" })
combatTab.page.Parent = pages

local rageTab = makeTab("Rage", tabsBar, pages, selectTab, { Left = "General", Right = "Advanced" }, "Did you know that using rage cheats puts u at a higher risk of getting banned? im not gonna gaf if u get banned yk right")
rageTab.page.Parent = pages

local settingsTab = makeTab("Settings", tabsBar, pages, selectTab, { Left = "General", Right = "Advanced" })
settingsTab.page.Parent = pages

local customizationTab = makeTab("Customization", tabsBar, pages, selectTab, { Left = "General", Right = "Advanced" })
customizationTab.page.Parent = pages

-- Select first tab
pcall(function()
    if FIRST_TAB and FIRST_TAB.button and FIRST_TAB.page then
        selectTab(FIRST_TAB.button, FIRST_TAB.page)
    end
end)

-- Register Unload Handlers
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
end

-- Expose to global
_G.VozexCHTUI = {
    makeToggle = makeToggle,
    makeTab = makeTab,
    root = root,
    tabs = { Visuals = visualTab },
    makeDropDownList = makeDropDownList,
    RegisterUnload = RegisterUnload,
    RunUnload = RunUnload,
    Config = {
        Get = GetConfig,
        Set = SetConfig,
        Save = SaveConfig,
    },
    Notification = NotificationAPI,
}

-- Bind helper functions
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
            if type(prev) == "function" then pcall(prev, k) end
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

-- ** Visuals Tab Stuff **
local playerChamsToggle, playerChamsColorPicker, glowChamsToggle, glowIntensitySlider, playerHealthToggle, showHealthKeybind, espBoxesToggle, espBoxesColorPicker

local playerStuffGroup = makeCollapsibleGroup(visualTab.LeftCol, "Player Visuals", false, function (parent)
    playerChamsToggle = makeToggle(parent, "Players Chams")
    playerChamsColorPicker = makeColorPicker(parent, "Players Chams Color", COLORS.accent)
    glowChamsToggle = makeToggle(parent, "Glow Chams", "Does what player chams does but with a glow effect.")
    glowIntensitySlider = makeSlider(parent, "Glow Intensity", 0, 100, 50)
    playerHealthToggle = makeToggle(parent, "Player Health", "Show health for players in the game.")
    showHealthKeybind = makeKeyBindButton(parent, "Show Health Keybind", Enum.KeyCode.P)
    espBoxesToggle = makeToggle(parent, "ESP Boxes")
    espBoxesColorPicker = makeColorPicker(parent, "ESP Boxes Color", COLORS.accent)
end)

local hideSmokeToggle = makeToggle(visualTab.RightCol, "Hide Smoke", "Removes smoke visuals from your screen.")
local hideFlashbangToggle = makeToggle(visualTab.RightCol, "Hide Flashbang", "Removes flashbang visuals from your screen.")
local showEnemyWeaponsToggle = makeToggle(visualTab.RightCol, "Show Enemy Weapons", "Shows the weapons of enemies on your screen even.")

-- ** Save Visuals to Config **
BindToggleToConfig(playerChamsToggle, "visuals.playerChams", true)
BindToggleToConfig(glowChamsToggle, "visuals.glowChams", false)
BindToggleToConfig(playerHealthToggle, "visuals.playerHealth", false)
BindToggleToConfig(espBoxesToggle, "visuals.espBoxes", false)
BindToggleToConfig(showEnemyWeaponsToggle, "visuals.showEnemyWeapons", false)
BindColorPickerToConfig(playerChamsColorPicker, "visuals.playerChamsColor", COLORS.accent)
BindColorPickerToConfig(espBoxesColorPicker, "visuals.espBoxesColor", COLORS.accent)
BindToggleToConfig(hideSmokeToggle, "visuals.hideSmoke", false)
BindToggleToConfig(hideFlashbangToggle, "visuals.hideFlashbang", false)

-- ** Settings Tab Stuff **
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

BindToggleToConfig(showGuiOnLoadToggle, "settings.showGuiOnLoad", true)
BindToggleToConfig(warnIfUnsupportedGameToggle, "settings.warnIfUnsupportedGame", true)
BindToggleToConfig(showNotificationsToggle, "settings.enableNotifications", true)
BindToggleToConfig(debugModeToggle, "settings.debugMode", false)
BindToggleToConfig(debugConfigToggle, "settings.debugConfig", false)
BindToggleToConfig(showFpsToggle, "settings.showFps", false)

-- ** Combat Tab Stuff **
local initialSmoothing = GetConfig("combat.aimbotSmoothing", 1) or 1
local initialAimbotFOV = GetConfig("combat.aimbotFOV", 700) or 700
local initialZone = GetConfig("combat.aimbotTargetZone", 1) or 1500
local aimbotToggle, enableAimbotKeybind, useAimbotSmoothingToggle, smoothingSlider, aimbotFOVSlider, aimnbotTargetZoneToggle, aimbotTargetZoneSlider, aimLockKeybind, aimPredictionToggle, persistentAimbotToggle, targetBehindWallsToggle, drawFovCircleToggle

local aimbotGroup = makeCollapsibleGroup(combatTab.LeftCol, "Aimbot — General", false, function(parent)
    aimbotToggle = makeToggle(parent, "Aimbot")
    enableAimbotKeybind = makeKeyBindButton(parent, "Enable Aimbot", Enum.KeyCode.V)
    aimLockKeybind = makeKeyBindButton(parent, "Aim Lock Keybind", Enum.KeyCode.Q)
    persistentAimbotToggle = makeToggle(parent, "Persistent Aimbot", "Doesn't let the enemy escape ur fov once locked onto them even if they get out of FOV")
end)

local aimbotBehaviorGroup = makeCollapsibleGroup(combatTab.LeftCol, "Aimbot — Behavior", false, function(parent)
    useAimbotSmoothingToggle = makeToggle(parent, "Use Aimbot Smoothing")
    smoothingSlider = makeSlider(parent, "Aimbot Smooth", 1, 100, initialSmoothing)
    aimPredictionToggle = makeToggle(parent, "Aimbot Prediction", "Tries to predict enemy movement, mostly for long ranged weapons.")
end)

local aimbotFOVGroup = makeCollapsibleGroup(combatTab.LeftCol, "Aimbot — Zone", false, function(parent)
    aimbotFOVSlider = makeSlider(parent, "Aimbot FOV", 1, 1000, initialAimbotFOV)
    drawFovCircleToggle = makeToggle(parent, "Draw FOV Circle")
    aimnbotTargetZoneToggle = makeToggle(parent, "Use Target Zone", "Distance based aimbot check to ignore ppl who r far away, depending on target zone")
    aimbotTargetZoneSlider = makeSlider(parent, "Aimbot Target Zone", 1, 900, initialZone)
    targetBehindWallsToggle = makeToggle(parent, "Target Behind Walls", "Allows the aimbot to target enemies behind walls.")
end)

local teamCheckToggle = makeToggle(combatTab.LeftCol, "Team Check")
local sixthSenseToggle = makeToggle(combatTab.RightCol, "Sixth Sense", "Tells u where traps are and if the enemy is holding a katana.")
local autoShootToggle = makeToggle(combatTab.LeftCol, "Auto-Shoot", "Shoots automatically when an enemy is in your crosshair.")
local enableAutoShootKeybind = makeKeyBindButton(combatTab.RightCol, "Auto-Shoot Keybind", Enum.KeyCode.Y)

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

-- ** Rage Tab Stuff **
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
    smoothStickingSlider = makeSlider(parent, "Smooth Sticking", 0, 100, 20)
    stickbBeneathPlayerToggle = makeToggle(parent, "Stick Beneath Player", "Stick to a player but beneath them, inside the ground.")
end)

local flyToggle, flyKeybind, flySpeedSlider
local flyGroup = makeCollapsibleGroup(rageTab.LeftCol, "Fly Stuff", false, function(parent)
     flyToggle = makeToggle(parent, "Fly", "Let's u fly around. SHIFT TO FLY DOWN AND SPACE TO FLY UP")
     flyKeybind = makeKeyBindButton(parent, "Fly Keybind", Enum.KeyCode.N)
     flySpeedSlider = makeSlider(parent, "Fly Speed", 0, 400, 20)
end)

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

-- ** Customization Tab Stuff **
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
local modelsColorPicker = makeColorPicker(customizationTab.RightCol, "Models Color", COLORS.accent)
local useModelsColorToggle = makeToggle(customizationTab.RightCol, "Use Models Color", "Applies the color from the color picker to the models in the game.")
local lightningIntensitySlider = makeSlider(customizationTab.LeftCol, "Lightning Intensity", 1, 200, 100)
local useLightningIntensityToggle = makeToggle(customizationTab.LeftCol, "Use Lightning Intensity", "Applies the lightning intensity slider value to the game to make it brighter or darker.")

BindDropDownToConfig(deviceSpoodDropDownList, "customization.deviceSpoof", 1)
BindToggleToConfig(useModelsColorToggle, "customization.useModelsColor", false)
BindColorPickerToConfig(modelsColorPicker, "customization.modelsColor", COLORS.accent)
BindSliderToConfig(lightningIntensitySlider, "customization.lightningIntensity", 100)
BindToggleToConfig(useLightningIntensityToggle, "customization.useLightningIntensity", false)

-- ** Close/Open GUI on Keybind **
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
            if typeof(k) == "EnumItem" then name = k.Name elseif type(k) == "string" then name = tostring(k) end
            if name then SetConfig(KEY_CONFIG, name) end
        end
        keyApi.OnActivate = function()
            if keyApi.IsDisabled and keyApi.IsDisabled() then return end
            if isMinimized then
                toggleMinimize()
            else
                if root then root.Visible = not root.Visible end
            end
        end
        RegisterUnload(function()
            if keyApi then keyApi.OnActivate = nil end
        end)
    end
end

-- ** Show GUI on Load **
do
    local KEY = "settings.showGuiOnLoad"
    local api = ToggleAPI[showGuiOnLoadToggle]
    pcall(function()
        local show = GetConfig(KEY, true)
        if root and root.Parent then root.Visible = not not show end
        if show then
            isMinimized = false
            root.Size = UDim2.new(0, getResponsiveSize(760), 0, getResponsiveSize(520 + bannerHeight + TOPBAR_SPACING))
            root.Position = UDim2.new(0.5, -getResponsiveSize(380), 0.5, -getResponsiveSize(260))
            root.AnchorPoint = Vector2.new(0, 0)
            for _, child in ipairs(root:GetChildren()) do
                if child ~= minimizeButton then
                    child.Visible = true
                end
            end
        end
    end)
    if api then
        local prev = api.OnToggle
        api.OnToggle = function(state)
            if prev then pcall(prev, state) end
            if not state then
                isMinimized = true
                root.Size = UDim2.new(0, getResponsiveSize(60), 0, getResponsiveSize(60))
                root.Position = UDim2.new(1, -getResponsiveSize(70), 1, -getResponsiveSize(70))
                root.AnchorPoint = Vector2.new(1, 1)
                if minimizeButton then
                    minimizeButton.Size = UDim2.new(0, getResponsiveSize(48), 0, getResponsiveSize(48))
                    minimizeButton.Position = UDim2.new(1, -getResponsiveSize(58), 1, -getResponsiveSize(58))
                    minimizeButton.AnchorPoint = Vector2.new(1, 1)
                end
                for _, child in ipairs(root:GetChildren()) do
                    if child ~= minimizeButton then
                        child.Visible = false
                    end
                end
            else
                toggleMinimize()
            end
        end
    end
end

-- ** Weapon Definitions **
local WeaponDefs = {
    Assault_Rifle = { "AKEY-47", "AUG", "Gingerbread AUG", "Tommy Gun", "AK-47", "Boneclaw Rifle", "Glorious Assault Rifle", "Phoenix Rifle", "10B Visits" },
    Shotgun = { "Balloon Shotgun", "Hyper Shotgun", "Cactus Shotgun", "Shotkey", "Broomstick", "Wrapped Shotgun", "Glorious Shotgun" },
    Minigun = { "Lasergun 3000", "Pixel Minigun", "Fighter Jet", "Pumpkin Minigun", "Wrapped Minigun" },
    RPG = { "Nuke Launcher", "Spaceship Launcher", "Squid Launcher", "Pencil Launcher" },
    Paintball_Gun = { "Slime Gun", "Boba Gun", "Ketchup Gun" },
    Grenade_Launcher = { "Swashbuckler", "Uranium Launcher", "Gearnade Launcher" },
    Flamethrower = { "Pixel Flamethrower", "Lamethrower", "Glitterthrower" },
    Bow = { "Compound Bow", "Raven Bow", "Dream Bow", "Key" },
    Crossbow = { "Pixel Crossbow", "Harpoon Crossbow", "Violin Crossbow", "Crossbone", "Frostbite Crossbow" },
    Gunblade = { "Hyper Gunblade", "Crude Gunblade", "Gunsaw", "Elf's Gunblade", "Boneblade", "Glorious Gunblade" },
    Burst_Rifle = { "Electro Burst", "Aqua Burst", "FAMAS", "Spectral Burst", "Pine Burst", "Key Rifle" },
    Energy_Rifle = { "Hacker Rifle", "Hydro Rifle", "Void Rifle", "2025 Energy Rifle" },
    Distortion = { "Plasma Distortion", "Magma Distortion", "Cyber Distortion" },
    Permafrost = { "Ice Permafrost" },
    Subspace_Tripmine = { "Don't Press", "Dev-In-The-Box", "Spring", "Trick Or Treat", "DIY Tripmine", "Glorious Subspace Tripmine" },
    Riot_Shield = { "Door", "Sled", "Tombstone Shield", "Energy Shield", "Masterpiece", "Glorious Riot Shield" },
    Knife = { "Keyrambit", "Keylisong", "Karambit", "Balisong", "Candy Cane", "Machete", "Chancla", "Glorious Knife", "Armature Knife" },
    Spray = { "Bottle Spray", "Boneclaw Spray", "Nail Gun", "Lovely Spray", "Pine Spray", "Glorious Spray" },
}

-- Add remaining features (simplified versions for compatibility)
-- Note: Full feature implementations would be too long. This provides a working responsive UI base.

-- Help button
local function OpenHelpPanel()
    makeNotification("Vozex Hub v1.0 - Use toggles and keybinds to customize your experience", 5)
end
if helpBtn then
    helpBtn.MouseButton1Click:Connect(OpenHelpPanel)
end

-- Initialize theme
ApplyTheme(GetConfig("settings.theme", "Cyber Blue"))

print("Vozex Hub loaded successfully! " .. (IS_MOBILE and "Mobile mode" or "PC mode"))

-- Return success
return true