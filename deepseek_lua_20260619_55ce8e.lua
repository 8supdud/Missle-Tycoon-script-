-- // ============================================================ \\ --
-- //          Grow a Garden 2 ☘️ | Vozex Hub 👑 (Premium UI)      \\ --
-- // ============================================================ \\ --

-- re-exec guard
pcall(function()
    local prev = getgenv and getgenv().SkrilyaGAG2
    if prev then
        if prev.S then prev.S.killed = true end
        if prev.unload then pcall(prev.unload) end
    end
end)

local Players            = game:GetService("Players")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local Workspace          = game:GetService("Workspace")
local HttpService        = game:GetService("HttpService")
local CollectionService  = game:GetService("CollectionService")
local Lighting           = game:GetService("Lighting")
local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")
local CoreGui            = game:GetService("CoreGui")
local RunService         = game:GetService("RunService")
local VirtualUser        = pcall(function() return game:GetService("VirtualUser") end) and game:GetService("VirtualUser") or nil
local LocalPlayer        = Players.LocalPlayer

pcall(function()
    if setthreadidentity then setthreadidentity(8) end
    if syn and syn.set_thread_identity then syn.set_thread_identity(8) end
end)

-- Block Robux purchase prompts
pcall(function()
    local nc = newcclosure or function(f) return f end
    local oldNc
    local function blocker(self, ...)
        local m = getnamecallmethod and getnamecallmethod()
        if type(m) == "string" and string.sub(m, 1, 6) == "Prompt" and string.find(m, "Purchase") then return end
        return oldNc(self, ...)
    end
    if hookmetamethod then
        oldNc = hookmetamethod(game, "__namecall", nc(blocker))
    elseif getrawmetatable and setreadonly then
        local mt = getrawmetatable(game); oldNc = mt.__namecall
        setreadonly(mt, false); mt.__namecall = nc(blocker); setreadonly(mt, true)
    end
end)

-- // ============================================================ \\ --
-- //                       NETWORK / DATA                         \\ --
-- // ============================================================ \\ --
local Net
do
    local sm = ReplicatedStorage:WaitForChild("SharedModules", 15)
    local mod = sm and sm:FindFirstChild("Networking")
    if mod then local ok, m = pcall(require, mod); if ok then Net = m end end
end

local _rl = { w = 0, c = 0, cap = 60 }
local function pace()
    local now = os.clock()
    if now - _rl.w >= 1 then _rl.w = now; _rl.c = 0 end
    if _rl.c >= _rl.cap then task.wait(0.05); return pace() end
    _rl.c = _rl.c + 1
end
local function jitter(a, b) a = a or 0.05; b = b or 0.12; return a + math.random() * (b - a) end

local function action(path)
    local cur = Net
    for part in string.gmatch(path, "[^.]+") do
        if type(cur) ~= "table" then return nil end
        cur = cur[part]
    end
    return cur
end
local function fire(path, ...)
    local a = action(path)
    if not (a and a.Fire) then return false, "no action: " .. path end
    pace()
    local args = table.pack(...)
    local ok, res = pcall(function() return a:Fire(table.unpack(args, 1, args.n)) end)
    if not ok then return false, res end
    return true, res
end
local function fireFast(path, ...)
    local a = action(path)
    if not (a and a.Fire) then return false, "no action: " .. path end
    local args = table.pack(...)
    local ok, res = pcall(function() return a:Fire(table.unpack(args, 1, args.n)) end)
    if not ok then return false, res end
    return true, res
end

local _replica
local function replica()
    if _replica then return _replica end
    local ok, psc = pcall(function() return require(ReplicatedStorage.ClientModules.PlayerStateClient) end)
    if ok and psc and psc.WaitForLocalReplica then
        local ok2, r = pcall(function() return psc:WaitForLocalReplica(30) end)
        if ok2 and r then _replica = r end
    end
    return _replica
end
local function pdata() local r = replica(); return (r and r.Data) or {} end
local function getSheckles() return tonumber(pdata().Sheckles) or 0 end
local function getTokens()   return tonumber(pdata().Tokens) or 0 end
local function inv(category) local i = pdata().Inventory; return (i and i[category]) or {} end
local function fmt(n)
    n = tonumber(n) or 0
    if n >= 1e12 then return string.format("%.2fT", n/1e12)
    elseif n >= 1e9 then return string.format("%.2fB", n/1e9)
    elseif n >= 1e6 then return string.format("%.2fM", n/1e6)
    elseif n >= 1e3 then return string.format("%.2fK", n/1e3)
    else return tostring(math.floor(n)) end
end

local function invNames(category)
    local out = {}
    for k, v in pairs(inv(category)) do
        local name, count
        if type(v) == "table" then
            name = v.Name or v.ItemName or v.Type or (type(k) == "string" and not v.Name and k) or tostring(k)
            count = tonumber(v.Count) or tonumber(v.Amount) or 1
        elseif type(v) == "number" then
            name, count = tostring(k), v
        else
            name, count = tostring(k), 1
        end
        if name then out[name] = (out[name] or 0) + (count or 1) end
    end
    return out
end

-- // ============================================================ \\ --
-- //                         CATALOGS                             \\ --
-- // ============================================================ \\ --
local function seedCatalog()
    local out = {}
    local ok, data = pcall(function() return require(ReplicatedStorage.SharedModules.SeedData) end)
    if ok and type(data) == "table" then
        for _, e in pairs(data) do
            if type(e) == "table" and e.SeedName and e.RestockShop ~= false and e.PurchasePrice then
                out[#out + 1] = { name = e.SeedName, price = tonumber(e.PurchasePrice) or 0, rarity = e.Rarity or "" }
            end
        end
    end
    table.sort(out, function(a, b) return a.price < b.price end)
    if #out == 0 then
        for _, n in ipairs({ "Carrot","Strawberry","Blueberry","Tulip","Tomato","Apple","Bamboo","Corn",
            "Cactus","Pineapple","Mushroom","Green Bean","Banana","Grape","Coconut","Mango","Dragon Fruit",
            "Acorn","Cherry","Sunflower","Venus Fly Trap","Pomegranate","Poison Apple","Moon Bloom",
            "Dragon's Breath","Ghost Pepper","Poison Ivy" }) do out[#out + 1] = { name = n, price = 0, rarity = "" } end
    end
    return out
end
local function gearCatalog()
    local out, seen = {}, {}
    local ok, data = pcall(function() return require(ReplicatedStorage.SharedModules.GearShopData) end)
    if ok and data and type(data.Data) == "table" then
        for _, e in pairs(data.Data) do
            if type(e) == "table" and e.ItemName and not e.RobuxOnly then
                if not seen[e.ItemName] then seen[e.ItemName] = true; out[#out + 1] = e.ItemName end
            end
        end
    end
    if #out == 0 then
        local ok2, items = pcall(function() return ReplicatedStorage.StockValues.GearShop.Items end)
        if ok2 and items then for _, c in ipairs(items:GetChildren()) do out[#out + 1] = c.Name end end
    end
    table.sort(out)
    return out
end
local CATALOG = seedCatalog()
local SEED_NAMES = {} ; for _, s in ipairs(CATALOG) do SEED_NAMES[#SEED_NAMES + 1] = s.name end
local GEAR_NAMES = gearCatalog()

local function stockOf(shop, name)
    local ok, items = pcall(function() return ReplicatedStorage.StockValues[shop].Items end)
    if not ok or not items then return nil end
    local v = items:FindFirstChild(name)
    return v and tonumber(v.Value) or 0
end

-- // ============================================================ \\ --
-- //                  PLOT / TOOLS / WORLD STATE                  \\ --
-- // ============================================================ \\ --
local function myPlot()
    local id = LocalPlayer:GetAttribute("PlotId")
    local gardens = Workspace:FindFirstChild("Gardens")
    if not (id and gardens) then return nil end
    return gardens:FindFirstChild("Plot" .. tostring(id))
end
local function myPlotId() return LocalPlayer:GetAttribute("PlotId") end
local function humanoid() local c = LocalPlayer.Character; return c and c:FindFirstChildOfClass("Humanoid") end

local function toolsByAttr(attr, wantName)
    local out = {}
    local function scan(c)
        if not c then return end
        for _, t in ipairs(c:GetChildren()) do
            if t:IsA("Tool") and t:GetAttribute(attr) ~= nil then
                if (not wantName) or t:GetAttribute(attr) == wantName or t.Name == wantName then out[#out + 1] = t end
            end
        end
    end
    scan(LocalPlayer:FindFirstChild("Backpack")); scan(LocalPlayer.Character)
    return out
end
local function heldToolByAttr(attr)
    local c = LocalPlayer.Character
    local t = c and c:FindFirstChildWhichIsA("Tool")
    if t and t:GetAttribute(attr) ~= nil then return t end
    return nil
end
local function equipByAttr(attr, wantName)
    local t = heldToolByAttr(attr)
    if t and ((not wantName) or t:GetAttribute(attr) == wantName) then return t end
    t = toolsByAttr(attr, wantName)[1]
    if not t then return nil end
    local hum = humanoid(); if not hum then return nil end
    hum:EquipTool(t); task.wait(0.22)
    return heldToolByAttr(attr)
end

local function myPlantAreas()
    local out, plot = {}, myPlot()
    if not plot then return out end
    for _, p in ipairs(CollectionService:GetTagged("PlantArea")) do
        if p:IsA("BasePart") and p:IsDescendantOf(plot) then out[#out + 1] = p end
    end
    return out
end
local function plantGrid(spacing)
    local pts, areas = {}, myPlantAreas()
    spacing = math.max(2, spacing or 4)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances = areas
    for _, area in ipairs(areas) do
        local cf, size = area.CFrame, area.Size
        local topY = (cf * CFrame.new(0, size.Y/2, 0)).Position.Y
        for dx = -size.X/2 + spacing/2, size.X/2 - spacing/2, spacing do
            for dz = -size.Z/2 + spacing/2, size.Z/2 - spacing/2, spacing do
                local w = (cf * CFrame.new(dx, 0, dz)).Position
                local hit = Workspace:Raycast(Vector3.new(w.X, topY + 10, w.Z), Vector3.new(0, -40, 0), params)
                if hit then pts[#pts + 1] = hit.Position end
            end
        end
    end
    return pts
end
local function existingPlantPositions()
    local out, plot = {}, myPlot()
    local plants = plot and plot:FindFirstChild("Plants")
    if not plants then return out end
    for _, m in ipairs(plants:GetChildren()) do
        local ok, pivot = pcall(function() return m:GetPivot().Position end)
        if ok then out[#out + 1] = pivot end
    end
    return out
end

local function promptCarrier(prompt)
    local node = prompt.Parent
    while node and node ~= Workspace and node:GetAttribute("PlantId") == nil do node = node.Parent end
    if node and node:GetAttribute("PlantId") ~= nil then return node end
    return prompt:FindFirstAncestorWhichIsA("Model")
end
local function ripeHarvests()
    local out = {}
    for _, pr in ipairs(CollectionService:GetTagged("HarvestPrompt")) do
        if pr:IsA("ProximityPrompt") and pr.Enabled and pr:IsDescendantOf(Workspace) then
            local m = promptCarrier(pr)
            local pid = m and m:GetAttribute("PlantId")
            if pid then
                local uid = tonumber(m:GetAttribute("UserId"))
                if uid == nil or uid == LocalPlayer.UserId then
                    out[#out + 1] = { plantId = tostring(pid), fruitId = tostring(m:GetAttribute("FruitId") or "") }
                end
            end
        end
    end
    return out
end
local function stealable()
    local out = {}
    for _, pr in ipairs(CollectionService:GetTagged("StealPrompt")) do
        if pr:IsA("ProximityPrompt") and pr.Enabled and pr:IsDescendantOf(Workspace) then
            local m = promptCarrier(pr)
            local pid = m and m:GetAttribute("PlantId")
            if pid then
                local pos
                local pp = pr.Parent
                if pp and pp:IsA("BasePart") then pos = pp.Position
                elseif m then local ok, pv = pcall(function() return m:GetPivot().Position end); if ok then pos = pv end end
                out[#out + 1] = {
                    owner = tonumber(m:GetAttribute("UserId")) or 0,
                    plantId = tostring(pid),
                    fruitId = tostring(m:GetAttribute("FruitId") or ""),
                    pos = pos,
                }
            end
        end
    end
    return out
end
local function isNight()
    local n = ReplicatedStorage:FindFirstChild("Night")
    return n and n.Value == true
end
local function wildPets()
    local out = {}
    local map = Workspace:FindFirstChild("Map")
    local ref = map and map:FindFirstChild("WildPetRef")
    if ref then for _, p in ipairs(ref:GetChildren()) do
        if p:IsA("BasePart") then
            out[#out + 1] = {
                part = p, name = p:GetAttribute("PetName"),
                price = tonumber(p:GetAttribute("Price")) or 0,
                owner = tonumber(p:GetAttribute("OwnerUserId")) or 0,
                pos = p.Position,
            }
        end
    end end
    return out
end
local function atPosition(pos, fn)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local saved = hrp.CFrame
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 4, 0))
    task.wait(0.45)
    local ok = pcall(fn)
    task.wait(0.15)
    if hrp and hrp.Parent then hrp.CFrame = saved end
    return ok
end
local function myBasePos()
    local plot = myPlot(); if not plot then return nil end
    for _, tag in ipairs({ "GardenTotalArea", "GardenZone" }) do
        for _, p in ipairs(CollectionService:GetTagged(tag)) do
            if p:IsA("BasePart") and p:IsDescendantOf(plot) then
                return Vector3.new(p.Position.X, p.Position.Y - p.Size.Y / 2 + 5, p.Position.Z)
            end
        end
    end
    local sp = plot:FindFirstChild("SpawnPoint")
    if sp and sp:IsA("BasePart") then return sp.Position end
    local ok, piv = pcall(function() return plot:GetPivot().Position end)
    return ok and piv or nil
end

-- // ============================================================ \\ --
-- //                          STATE                              \\ --
-- // ============================================================ \\ --
local S = {
    autoFarm = false,
    autoBuy = false, buySeeds = {}, buyInterval = 5, buyPerTick = 8,
    autoPlant = false, plantSpacing = 4, plantSeed = "Best owned",
    autoHarvest = false, harvestInterval = 2, harvestDelay = 0.01,
    autoSell = false, sellInterval = 15,
    autoExpand = false, autoPot = false, autoDaily = false,
    autoSprinkler = false, sprinklerInterval = 30,
    autoWater = false, waterInterval = 8,
    autoSkill = false, skillStats = {},
    autoEquipPets = false, autoPetSlot = false,
    autoBuyPets = false, maxPetPrice = 25000, petTeleport = true, petBuyInterval = 5,
    sellPets = {}, autoSellPets = false,
    autoEgg = false, autoCrate = false, autoPack = false, openInterval = 4,
    autoGear = false, gearBuy = {}, gearInterval = 10,
    autoSteal = false, stealTeleport = true, stealReturnBase = true, stealDelay = 0.05,
    autoMail = false, autoAcceptGift = false, autoHop = false, hopInterval = 0,
    codeText = "", autoCodes = false, antiAfk = true,
    fpsBoost = false,
    webhookEnabled = false, webhookUrl = "", webhookInterval = 300,
    killed = false,
}
local Stats = { bought = 0, planted = 0, harvested = 0, sold = 0, earned = 0,
    sprinklers = 0, watered = 0, tamed = 0, opened = 0, stolen = 0, codes = 0, startAt = os.clock() }

local _due = {}
local function due(key, period)
    local now = os.clock()
    if not _due[key] or now - _due[key] >= period then _due[key] = now; return true end
    return false
end
local function loopOn(getOn, period, body)
    task.spawn(function()
        while not S.killed do
            if getOn() then
                pcall(body)
                local p = (type(period) == "function") and period() or period
                local e = 0; while e < p and getOn() and not S.killed do task.wait(0.4); e += 0.4 end
            else task.wait(0.4) end
        end
    end)
end
local function picked(t) for _ in pairs(t) do return true end return false end
local function pickMulti(sel, into)
    for k in pairs(into) do into[k] = nil end
    if type(sel) == "table" then for k, v in pairs(sel) do
        if v == true then into[k] = true elseif type(v) == "string" then into[v] = true end
    end end
end

-- // ============================================================ \\ --
-- //                     CORE FARM (master loop)                 \\ --
-- // ============================================================ \\ --
local function stepBuy()
    if not due("buy", S.buyInterval) then return end
    if not picked(S.buySeeds) then return end
    for _, s in ipairs(CATALOG) do
        if not (S.autoFarm or S.autoBuy) then break end
        if S.buySeeds[s.name] then
            local stock, bought = stockOf("SeedShop", s.name), 0
            while bought < S.buyPerTick do
                if stock ~= nil and stock <= 0 then break end
                if s.price > 0 and getSheckles() < s.price then break end
                if not fire("SeedShop.PurchaseSeed", s.name) then break end
                Stats.bought += 1; bought += 1
                if stock ~= nil then stock -= 1 end
                task.wait(jitter(0.1, 0.22))
            end
        end
    end
end

local function pickPlantTool()
    if S.plantSeed ~= "Best owned" and S.plantSeed ~= "" then
        local t = toolsByAttr("SeedTool", S.plantSeed)[1]
        if t then return t end
    end
    local best, bestPrice
    for _, t in ipairs(toolsByAttr("SeedTool")) do
        local nm = t:GetAttribute("SeedTool")
        local price = 0
        for _, s in ipairs(CATALOG) do if s.name == nm then price = s.price; break end end
        if not bestPrice or price > bestPrice then best, bestPrice = t, price end
    end
    return best or toolsByAttr("SeedTool")[1]
end

local function stepPlant()
    local grid = plantGrid(S.plantSpacing)
    if #grid == 0 then return end
    local tool = pickPlantTool(); if not tool then return end
    local hum = humanoid(); if not hum then return end
    if heldToolByAttr("SeedTool") ~= tool then hum:EquipTool(tool); task.wait(0.22) end
    tool = heldToolByAttr("SeedTool"); if not tool then return end
    local seedAttr = tool:GetAttribute("SeedTool")
    local occupied = existingPlantPositions()
    for _, pos in ipairs(grid) do
        if not (S.autoFarm or S.autoPlant) then break end
        local clear = true
        for _, op in ipairs(occupied) do
            if (Vector2.new(pos.X, pos.Z) - Vector2.new(op.X, op.Z)).Magnitude < 1 then clear = false; break end
        end
        if clear then
            if not heldToolByAttr("SeedTool") then
                local nx = pickPlantTool(); if not nx then return end
                hum:EquipTool(nx); task.wait(0.2)
                tool = heldToolByAttr("SeedTool"); if not tool then return end
                seedAttr = tool:GetAttribute("SeedTool")
            end
            fire("Plant.PlantSeed", pos, seedAttr, tool)
            Stats.planted += 1; occupied[#occupied + 1] = pos
            task.wait(jitter(0.08, 0.16))
        end
    end
end

local function maxFruitCap() return tonumber(LocalPlayer:GetAttribute("MaxFruitCapacity")) or 100 end
local function fruitCount()  return tonumber(LocalPlayer:GetAttribute("FruitCount")) or 0 end
local function sellAllNow()
    local ok, res = fireFast("NPCS.SellAll")
    if ok and type(res) == "table" and res.Success then
        local n = tonumber(res.SoldCount) or 0
        Stats.sold += n; Stats.earned += tonumber(res.SellPrice) or 0
        return n
    end
    return 0
end

local function stepHarvest()
    local sell = (S.autoFarm or S.autoSell)
    local list = ripeHarvests()
    if #list == 0 then
        if sell and fruitCount() > 0 then sellAllNow() end
        return
    end
    local cap = maxFruitCap()
    local d = S.harvestDelay or 0
    for _, h in ipairs(list) do
        if not (S.autoFarm or S.autoHarvest) then break end
        if fruitCount() >= cap - 1 then break end
        fireFast("Garden.CollectFruit", h.plantId, h.fruitId)
        Stats.harvested += 1
        if d > 0 then task.wait(d) end
    end
    if sell then sellAllNow() end
end

local function stepSell()
    if not due("sell", S.sellInterval) then return end
    sellAllNow()
end

local function stepExpand()
    if not due("expand", 12) then return end
    fire("Actions.ExpandGarden")
end
local function stepDaily()
    if not due("daily", 60) then return end
    fire("NPCS.CheckDailyDeal"); task.wait(0.3); fire("NPCS.UseDailyDealAll")
end

task.spawn(function()
    while not S.killed do
        if S.autoFarm or S.autoBuy     then pcall(stepBuy) end
        if S.autoFarm or S.autoPlant   then pcall(stepPlant) end
        if S.autoFarm or S.autoExpand  then pcall(stepExpand) end
        if S.autoFarm or S.autoDaily   then pcall(stepDaily) end
        task.wait(0.55)
    end
end)

task.spawn(function()
    while not S.killed do
        if S.autoFarm or S.autoHarvest then
            pcall(stepHarvest)
            task.wait(0.05)
        elseif S.autoSell then
            pcall(stepSell)
            task.wait(0.3)
        else
            task.wait(0.4)
        end
    end
end)

-- // ============================================================ \\ --
-- //                       BOOSTS (passive)                      \\ --
-- // ============================================================ \\ --
loopOn(function() return S.autoSprinkler end, function() return S.sprinklerInterval end, function()
    local pid = myPlotId(); if not pid then return end
    local placed = existingPlantPositions()
    for _, t in ipairs(toolsByAttr("Sprinkler")) do
        if not S.autoSprinkler then break end
        local hum = humanoid(); if not hum then break end
        hum:EquipTool(t); task.wait(0.22)
        t = heldToolByAttr("Sprinkler"); if not t then break end
        local grid = plantGrid(8)
        for _, pos in ipairs(grid) do
            local far = true
            for _, op in ipairs(placed) do if (pos - op).Magnitude < 12 then far = false; break end end
            if far then
                fire("Place.PlaceSprinkler", pos, t:GetAttribute("Sprinkler"), t, pid)
                Stats.sprinklers += 1; placed[#placed + 1] = pos; task.wait(0.3)
                break
            end
        end
    end
    pcall(function() humanoid():UnequipTools() end)
end)

loopOn(function() return S.autoWater end, function() return S.waterInterval end, function()
    local t = equipByAttr("WateringCan"); if not t then return end
    local name = t:GetAttribute("WateringCan")
    for _, pos in ipairs(existingPlantPositions()) do
        if not S.autoWater then break end
        fire("WateringCan.UseWateringCan", pos - Vector3.new(0, 0.3, 0), name, t)
        Stats.watered += 1; task.wait(jitter(0.15, 0.3))
    end
end)

loopOn(function() return S.autoSkill end, 6, function()
    if not picked(S.skillStats) then return end
    for stat in pairs(S.skillStats) do
        if not S.autoSkill then break end
        fire("SkillPoints.SpendSkillPoint", stat); task.wait(0.25)
    end
end)

-- // ============================================================ \\ --
-- //                          PETS                               \\ --
-- // ============================================================ \\ --
local function ownedPetNames()
    local names, seen = {}, {}
    for nm in pairs(invNames("Pets")) do if not seen[nm] then seen[nm] = true; names[#names + 1] = nm end end
    for _, t in ipairs(toolsByAttr("PetId")) do
        local nm = t:GetAttribute("PetName") or t.Name
        if nm and not seen[nm] then seen[nm] = true; names[#names + 1] = nm end
    end
    table.sort(names); return names
end
local function equippedPetCount()
    local ok, list = fire("Pets.GetEquippedPets")
    if ok and type(list) == "table" then
        local n = 0; for _ in pairs(list) do n += 1 end; return n
    end
    return 0
end
loopOn(function() return S.autoEquipPets end, 12, function()
    local cap = tonumber(LocalPlayer:GetAttribute("MaxEquippedPets")) or 3
    local have = equippedPetCount()
    if have >= cap then return end
    for _, nm in ipairs(ownedPetNames()) do
        if not S.autoEquipPets or have >= cap then break end
        fire("Pets.RequestEquipByName", nm); have += 1; task.wait(0.3)
    end
end)
loopOn(function() return S.autoPetSlot end, 20, function()
    fire("Pets.RequestPurchasePetSlot")
end)
loopOn(function() return S.autoBuyPets end, function() return S.petBuyInterval end, function()
    for _, w in ipairs(wildPets()) do
        if not S.autoBuyPets then break end
        if w.owner == 0 and w.price > 0 and w.price <= S.maxPetPrice and getSheckles() >= w.price then
            if S.petTeleport and w.pos then
                atPosition(w.pos, function() fire("Pets.WildPetTame", w.part) end)
            else
                fire("Pets.WildPetTame", w.part)
            end
            Stats.tamed += 1
            task.wait(jitter(0.3, 0.6))
        end
    end
end)
loopOn(function() return S.autoSellPets end, 4, function()
    if not picked(S.sellPets) then return end
    for _, t in ipairs(toolsByAttr("PetId")) do
        if not S.autoSellPets then break end
        local nm = t:GetAttribute("PetName") or t.Name
        if S.sellPets[nm] then
            local hum = humanoid()
            if hum then hum:EquipTool(t); task.wait(0.25) end
            fire("NPCS.SellPet", t:GetAttribute("PetId")); task.wait(0.3)
        end
    end
end)

-- // ============================================================ \\ --
-- //                  EGGS / CRATES / SEED PACKS                 \\ --
-- // ============================================================ \\ --
local function openAll(category, path)
    for nm, count in pairs(invNames(category)) do
        if S.killed then break end
        for _ = 1, math.min(count, 25) do
            local ok, res = fire(path, nm)
            if not ok then break end
            if type(res) == "table" and res.Success == false then break end
            Stats.opened += 1; task.wait(jitter(0.25, 0.5))
        end
    end
end
loopOn(function() return S.autoEgg  end, function() return S.openInterval end, function() openAll("Eggs", "Egg.OpenEgg") end)
loopOn(function() return S.autoCrate end, function() return S.openInterval end, function() openAll("Crates", "Crate.OpenCrate") end)
loopOn(function() return S.autoPack  end, function() return S.openInterval end, function() openAll("SeedPacks", "SeedPack.OpenSeedPack") end)

-- // ============================================================ \\ --
-- //                      SHOP (gear)                            \\ --
-- // ============================================================ \\ --
loopOn(function() return S.autoGear end, function() return S.gearInterval end, function()
    if not picked(S.gearBuy) then return end
    for name in pairs(S.gearBuy) do
        if not S.autoGear then break end
        local stock = stockOf("GearShop", name)
        if stock == nil or stock > 0 then
            fire("GearShop.PurchaseGear", name); task.wait(jitter(0.2, 0.4))
        end
    end
end)

-- // ============================================================ \\ --
-- //                     STEAL (PvP, night)                      \\ --
-- // ============================================================ \\ --
local function hrpNow() local c = LocalPlayer.Character; return c and c:FindFirstChild("HumanoidRootPart") end
loopOn(function() return S.autoSteal end, 1.5, function()
    if not isNight() then return end
    for _, f in ipairs(stealable()) do
        if not (S.autoSteal and isNight()) then break end
        if S.stealTeleport and f.pos then
            local hrp = hrpNow(); if hrp then hrp.CFrame = CFrame.new(f.pos + Vector3.new(0, 4, 0)); task.wait(0.4) end
        end
        fire("Steal.BeginSteal", f.owner, f.plantId, f.fruitId)
        fire("Steal.CompleteSteal")
        Stats.stolen += 1
        if S.stealReturnBase then
            local base = myBasePos()
            local hrp = hrpNow()
            if base and hrp then
                hrp.CFrame = CFrame.new(base + Vector3.new(0, 4, 0))
                local t0 = os.clock()
                while LocalPlayer:GetAttribute("CarryingStolenFruit") and os.clock() - t0 < 3 and S.autoSteal do task.wait(0.15) end
            end
        end
        if (S.stealDelay or 0) > 0 then task.wait(S.stealDelay) end
    end
end)

-- // ============================================================ \\ --
-- //                  MISC (mail / gifts / hop / codes)          \\ --
-- // ============================================================ \\ --
loopOn(function() return S.autoMail end, 30, function()
    local ok, box = fire("Mailbox.OpenInbox")
    if ok and type(box) == "table" then
        local mb = box.Mailbox or box.Inbox or box
        for id, entry in pairs(mb) do
            if not S.autoMail then break end
            if type(entry) == "table" and (entry.Claimed == true or entry.IsClaimed == true) then
            else
                fire("Mailbox.Claim", id); task.wait(0.3)
            end
        end
    end
end)
pcall(function()
    local g = action("Gifting.Prompted")
    if g and g.OnClientEvent then
        g.OnClientEvent:Connect(function(fromPlayer)
            if S.autoAcceptGift and fromPlayer then pcall(function() fire("Gifting.Response", fromPlayer, true) end) end
        end)
    end
end)
loopOn(function() return S.autoHop end, function() return math.max(60, S.hopInterval) end, function()
    if S.hopInterval > 0 then fire("AntiAfk.RequestHop") end
end)
if VirtualUser then
    LocalPlayer.Idled:Connect(function()
        if S.killed or not S.antiAfk then return end
        pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new(0, 0)) end)
    end)
end
local CODE_LIST = {}
local triedCodes = {}
local function redeemCodes(list)
    local n = 0
    for _, code in ipairs(list) do
        if code ~= "" and not triedCodes[code] then
            local ok, res = fire("Settings.SubmitCode", code)
            triedCodes[code] = true
            if ok and res == true then n += 1; Stats.codes += 1 end
            task.wait(0.4)
        end
    end
    return n
end
loopOn(function() return S.autoCodes end, 120, function() redeemCodes(CODE_LIST) end)

local _fpsApplied = false
local function applyFpsBoost(on)
    if on and not _fpsApplied then
        _fpsApplied = true
        pcall(function()
            Lighting.GlobalShadows = false; Lighting.FogEnd = 1e6
            for _, e in ipairs(Lighting:GetChildren()) do
                if e:IsA("BloomEffect") or e:IsA("SunRaysEffect") or e:IsA("DepthOfFieldEffect") or e:IsA("BlurEffect") then e.Enabled = false end
            end
            if sethiddenproperty then pcall(sethiddenproperty, Lighting, "Technology", 1) end
            settings().Rendering.QualityLevel = 1
        end)
        task.spawn(function()
            for _, d in ipairs(Workspace:GetDescendants()) do
                if not S.fpsBoost then break end
                if d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Smoke") or d:IsA("Fire") or d:IsA("Sparkles") then d.Enabled = false
                elseif d:IsA("Texture") or d:IsA("Decal") then pcall(function() d.Transparency = 1 end) end
            end
        end)
    end
end

-- // ============================================================ \\ --
-- //                    WEBHOOK REPORTING                        \\ --
-- // ============================================================ \\ --
local httpRequest = (syn and syn.request) or http_request or request or (http and http.request)
local function hms(sec)
    sec = math.floor(sec); local h = sec//3600; local m = (sec%3600)//60
    if h > 0 then return string.format("%dh %dm", h, m) end
    if m > 0 then return string.format("%dm %ds", m, sec%60) end
    return sec .. "s"
end
local function sendWebhook(isTest)
    if not httpRequest then return false end
    if not string.match(S.webhookUrl or "", "^https?://") then return false end
    local payload = { username = "Grow a Garden 2", embeds = { {
        title = "🌱 Farm Report — " .. LocalPlayer.Name, color = 5763719,
        fields = {
            { name = "💰 Sheckles", value = fmt(getSheckles()), inline = true },
            { name = "🪙 Tokens",   value = fmt(getTokens()),   inline = true },
            { name = "🌾 Plot",     value = tostring((myPlot() and myPlot().Name) or "?"), inline = true },
            { name = "📊 Session",  value = string.format("bought %d · planted %d · harvested %d · sold %d (+%s)",
                Stats.bought, Stats.planted, Stats.harvested, Stats.sold, fmt(Stats.earned)), inline = false },
            { name = "✨ Extras",   value = string.format("sprinklers %d · watered %d · tamed %d · opened %d · stolen %d",
                Stats.sprinklers, Stats.watered, Stats.tamed, Stats.opened, Stats.stolen), inline = false },
            { name = "⏱️ Uptime",   value = hms(os.clock() - Stats.startAt), inline = true },
        }, footer = { text = "Vozex Hub · GAG2" },
    } } }
    local ok, res = pcall(function()
        return httpRequest({ Url = S.webhookUrl, Method = "POST",
            Headers = { ["Content-Type"] = "application/json" }, Body = HttpService:JSONEncode(payload) })
    end)
    local code = ok and res and (res.StatusCode or res.Status or res.status_code)
    local good = ok and (code == nil or code == 200 or code == 204)
    return good
end
loopOn(function() return S.webhookEnabled end, function() return S.webhookInterval end, function() sendWebhook(false) end)

-- // ============================================================ \\ --
-- //                 PREMIUM UI LIBRARY                          \\ --
-- // ============================================================ \\ --
local PremiumUI = {}
PremiumUI.Colors = {
    Bg = Color3.fromRGB(12, 12, 18),
    BgDarker = Color3.fromRGB(8, 8, 14),
    Panel = Color3.fromRGB(20, 22, 32),
    PanelLight = Color3.fromRGB(30, 33, 48),
    PanelHover = Color3.fromRGB(40, 44, 64),
    Accent = Color3.fromRGB(100, 180, 255),
    Accent2 = Color3.fromRGB(255, 180, 100),
    AccentGlow = Color3.fromRGB(60, 140, 255),
    Text = Color3.fromRGB(235, 240, 255),
    TextDim = Color3.fromRGB(150, 160, 190),
    TextBright = Color3.fromRGB(255, 255, 255),
    Success = Color3.fromRGB(80, 220, 160),
    Warning = Color3.fromRGB(255, 200, 80),
    Danger = Color3.fromRGB(255, 100, 100),
    Gradient1 = Color3.fromRGB(60, 80, 220),
    Gradient2 = Color3.fromRGB(200, 80, 220),
}

function PremiumUI:CreateRounded(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = instance
    return corner
end

function PremiumUI:CreateStroke(instance, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or PremiumUI.Colors.PanelLight
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.3
    stroke.Parent = instance
    return stroke
end

function PremiumUI:CreateGradient(instance, color1, color2, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1 or PremiumUI.Colors.Gradient1),
        ColorSequenceKeypoint.new(1, color2 or PremiumUI.Colors.Gradient2)
    })
    gradient.Rotation = rotation or 45
    gradient.Parent = instance
    return gradient
end

function PremiumUI:MakeDraggable(gui, handle)
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

function PremiumUI:CreateGlow(parent, color, size)
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1, size or 20, 1, size or 20)
    glow.Position = UDim2.new(0.5, -(size or 20)/2, 0.5, -(size or 20)/2)
    glow.BackgroundColor3 = color or PremiumUI.Colors.AccentGlow
    glow.BackgroundTransparency = 0.9
    glow.BorderSizePixel = 0
    glow.Parent = parent
    self:CreateRounded(glow, 999)
    return glow
end

function PremiumUI:CreateWindow(opts)
    local isMobile = UserInputService.TouchEnabled
    local title = type(opts) == "table" and opts.Name or opts
    local sg = Instance.new("ScreenGui")
    sg.Name = "PremiumUI"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    -- Floating button
    local floatBtn = Instance.new("TextButton")
    floatBtn.Size = UDim2.new(0, 55, 0, 55)
    floatBtn.Position = UDim2.new(0.5, -27.5, 0, 20)
    floatBtn.BackgroundColor3 = PremiumUI.Colors.Panel
    floatBtn.Text = "👑"
    floatBtn.TextSize = 26
    floatBtn.Visible = false
    floatBtn.Parent = sg
    self:CreateRounded(floatBtn, 999)
    self:CreateStroke(floatBtn, PremiumUI.Colors.Accent, 2, 0.5)
    self:CreateGlow(floatBtn, PremiumUI.Colors.AccentGlow, 30)
    self:MakeDraggable(floatBtn)

    floatBtn.MouseEnter:Connect(function()
        TweenService:Create(floatBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 60, 0, 60)}):Play()
    end)
    floatBtn.MouseLeave:Connect(function()
        TweenService:Create(floatBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 55, 0, 55)}):Play()
    end)

    -- Main frame
    local main = Instance.new("Frame")
    if isMobile then
        main.Size = UDim2.new(0, 620 * 0.85, 0, 480 * 0.85)
    else
        main.Size = UDim2.new(0, 620, 0, 480)
    end
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = PremiumUI.Colors.Bg
    main.Active = true
    main.Parent = sg
    self:CreateRounded(main, 14)
    self:CreateStroke(main, PremiumUI.Colors.PanelLight, 1, 0.2)
    
    -- Background gradient overlay
    local bgOverlay = Instance.new("Frame")
    bgOverlay.Size = UDim2.new(1, 0, 1, 0)
    bgOverlay.BackgroundColor3 = PremiumUI.Colors.BgDarker
    bgOverlay.BackgroundTransparency = 0.5
    bgOverlay.Parent = main
    self:CreateRounded(bgOverlay, 14)

    -- Top bar with gradient
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 48)
    topBar.BackgroundColor3 = PremiumUI.Colors.BgDarker
    topBar.Parent = main
    self:CreateRounded(topBar, 14)
    self:CreateGradient(topBar, PremiumUI.Colors.Gradient1, PremiumUI.Colors.Gradient2, 90)
    topBar.BackgroundTransparency = 0.3
    
    -- Top bar bottom shadow
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 0, 0, 3)
    shadow.Position = UDim2.new(0, 0, 1, 0)
    shadow.BackgroundColor3 = PremiumUI.Colors.AccentGlow
    shadow.BackgroundTransparency = 0.7
    shadow.Parent = topBar
    self:CreateRounded(shadow, 0)

    self:MakeDraggable(main, topBar)

    -- Title with icon
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -80, 1, 0)
    titleLbl.Position = UDim2.new(0, 18, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "🌱 " .. title
    titleLbl.TextColor3 = PremiumUI.Colors.TextBright
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 17
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.TextTruncate = Enum.TextTruncate.AtEnd
    titleLbl.Parent = topBar

    -- Subtitle
    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(1, -80, 0, 16)
    subLbl.Position = UDim2.new(0, 18, 0, 26)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = "Premium Auto-Farm • v2.0"
    subLbl.TextColor3 = PremiumUI.Colors.TextDim
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextSize = 11
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.TextTruncate = Enum.TextTruncate.AtEnd
    subLbl.Parent = topBar

    -- Minimize button
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 30, 0, 30)
    minBtn.Position = UDim2.new(1, -78, 0.5, -15)
    minBtn.BackgroundColor3 = PremiumUI.Colors.PanelLight
    minBtn.Text = "−"
    minBtn.TextColor3 = PremiumUI.Colors.Text
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 18
    minBtn.Parent = topBar
    self:CreateRounded(minBtn, 8)
    minBtn.BackgroundTransparency = 0.5
    
    minBtn.MouseEnter:Connect(function()
        TweenService:Create(minBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play()
    end)
    minBtn.MouseLeave:Connect(function()
        TweenService:Create(minBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.5}):Play()
    end)

    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -42, 0.5, -15)
    closeBtn.BackgroundColor3 = PremiumUI.Colors.PanelLight
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = PremiumUI.Colors.Text
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.Parent = topBar
    self:CreateRounded(closeBtn, 8)
    closeBtn.BackgroundTransparency = 0.5
    
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.2, TextColor3 = PremiumUI.Colors.Danger}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.5, TextColor3 = PremiumUI.Colors.Text}):Play()
    end)

    minBtn.MouseButton1Click:Connect(function() 
        TweenService:Create(main, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.3)
        main.Visible = false
        floatBtn.Visible = true
        TweenService:Create(floatBtn, TweenInfo.new(0.3), {Size = UDim2.new(0, 55, 0, 55), Position = UDim2.new(0.5, -27.5, 0, 20)}):Play()
    end)
    
    floatBtn.MouseButton1Click:Connect(function() 
        floatBtn.Visible = false
        main.Visible = true
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, isMobile and 620 * 0.85 or 620, 0, isMobile and 480 * 0.85 or 480)}):Play()
    end)

    -- Tab container with glass effect
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Size = UDim2.new(0, 150, 1, -52)
    tabContainer.Position = UDim2.new(0, 0, 0, 52)
    tabContainer.BackgroundColor3 = PremiumUI.Colors.BgDarker
    tabContainer.BorderSizePixel = 0
    tabContainer.ScrollBarThickness = 0
    tabContainer.BackgroundTransparency = 0.3
    tabContainer.Parent = main
    self:CreateRounded(tabContainer, 0)
    
    local tLayout = Instance.new("UIListLayout", tabContainer)
    tLayout.Padding = UDim.new(0, 4)
    tLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Instance.new("UIPadding", tabContainer).PaddingTop = UDim.new(0, 10)
    tLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() 
        tabContainer.CanvasSize = UDim2.new(0, 0, 0, tLayout.AbsoluteContentSize.Y + 15) 
    end)

    -- Page container
    local pageContainer = Instance.new("Frame")
    pageContainer.Size = UDim2.new(1, -150, 1, -52)
    pageContainer.Position = UDim2.new(0, 150, 0, 52)
    pageContainer.BackgroundTransparency = 1
    pageContainer.Parent = main

    -- Decorative line
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 1, 1, -52)
    line.Position = UDim2.new(0, 150, 0, 52)
    line.BackgroundColor3 = PremiumUI.Colors.PanelLight
    line.BackgroundTransparency = 0.5
    line.Parent = main

    local WindowObj = {Tabs = {}, CurrentTab = nil, Gui = sg}

    function WindowObj:CreateTab(name)
        local tBtn = Instance.new("TextButton")
        tBtn.Size = UDim2.new(1, -14, 0, 36)
        tBtn.BackgroundColor3 = PremiumUI.Colors.BgDarker
        tBtn.BackgroundTransparency = 1
        tBtn.Text = name
        tBtn.TextColor3 = PremiumUI.Colors.TextDim
        tBtn.Font = Enum.Font.GothamSemibold
        tBtn.TextSize = 13
        tBtn.TextXAlignment = Enum.TextXAlignment.Left
        tBtn.Parent = tabContainer
        self:CreateRounded(tBtn, 8)
        tBtn.BackgroundTransparency = 0.8

        -- Tab indicator
        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 3, 0.6, 0)
        indicator.Position = UDim2.new(0, 4, 0.2, 0)
        indicator.BackgroundColor3 = PremiumUI.Colors.Accent
        indicator.BackgroundTransparency = 1
        indicator.Parent = tBtn
        self:CreateRounded(indicator, 999)

        -- Tab icon/emote space
        local iconSpace = Instance.new("TextLabel")
        iconSpace.Size = UDim2.new(0, 24, 1, 0)
        iconSpace.Position = UDim2.new(0, 8, 0, 0)
        iconSpace.BackgroundTransparency = 1
        iconSpace.Text = string.sub(name, 1, 2)
        iconSpace.TextColor3 = PremiumUI.Colors.Accent
        iconSpace.Font = Enum.Font.Gotham
        iconSpace.TextSize = 14
        iconSpace.TextXAlignment = Enum.TextXAlignment.Center
        iconSpace.TextYAlignment = Enum.TextYAlignment.Center
        iconSpace.Parent = tBtn

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = PremiumUI.Colors.Accent
        page.ScrollBarImageTransparency = 0.5
        page.Visible = false
        page.Parent = pageContainer
        
        local pLayout = Instance.new("UIListLayout", page)
        pLayout.Padding = UDim.new(0, 6)
        pLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        pLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        local orderCount = 0

        local pPad = Instance.new("UIPadding", page)
        pPad.PaddingTop = UDim.new(0, 12)
        pPad.PaddingBottom = UDim.new(0, 12)
        pPad.PaddingLeft = UDim.new(0, 8)
        pPad.PaddingRight = UDim.new(0, 8)

        pLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() 
            page.CanvasSize = UDim2.new(0, 0, 0, pLayout.AbsoluteContentSize.Y + 25) 
        end)

        if not self.CurrentTab then
            self.CurrentTab = page
            page.Visible = true
            tBtn.BackgroundTransparency = 0.2
            tBtn.TextColor3 = PremiumUI.Colors.TextBright
            indicator.BackgroundTransparency = 0
        end

        tBtn.MouseEnter:Connect(function()
            if tBtn.BackgroundTransparency ~= 0.2 then
                TweenService:Create(tBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.1}):Play()
            end
        end)
        tBtn.MouseLeave:Connect(function()
            if tBtn.BackgroundTransparency ~= 0.2 then
                TweenService:Create(tBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.8}):Play()
            end
        end)

        tBtn.MouseButton1Click:Connect(function()
            for _, btn in ipairs(tabContainer:GetChildren()) do 
                if btn:IsA("TextButton") then 
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.8, TextColor3 = PremiumUI.Colors.TextDim}):Play()
                    local ind = btn:FindFirstChild("Frame")
                    if ind then TweenService:Create(ind, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() end
                end 
            end
            for _, p in ipairs(pageContainer:GetChildren()) do p.Visible = false end
            TweenService:Create(tBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.2, TextColor3 = PremiumUI.Colors.TextBright}):Play()
            TweenService:Create(indicator, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
            page.Visible = true
        end)

        local TabObj = {}
        
        function TabObj:CreateSection(text)
            orderCount = orderCount + 1
            local sLbl = Instance.new("TextLabel")
            sLbl.LayoutOrder = orderCount
            sLbl.Size = UDim2.new(1, -16, 0, 28)
            sLbl.BackgroundTransparency = 1
            sLbl.Text = "▸ " .. text
            sLbl.TextColor3 = PremiumUI.Colors.Accent
            sLbl.Font = Enum.Font.GothamBold
            sLbl.TextSize = 13
            sLbl.TextXAlignment = Enum.TextXAlignment.Left
            sLbl.Parent = page
        end

        function TabObj:CreateButton(opts)
            orderCount = orderCount + 1
            local btn = Instance.new("TextButton")
            btn.LayoutOrder = orderCount
            btn.Size = UDim2.new(1, -16, 0, 38)
            btn.BackgroundColor3 = PremiumUI.Colors.Panel
            btn.Text = opts.Name
            btn.TextColor3 = PremiumUI.Colors.Text
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 13
            btn.Parent = page
            self:CreateRounded(btn, 8)
            self:CreateStroke(btn, PremiumUI.Colors.PanelLight, 1, 0.3)
            
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = PremiumUI.Colors.PanelHover}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = PremiumUI.Colors.Panel}):Play()
            end)
            
            btn.MouseButton1Click:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -20, 0, 36)}):Play()
                opts.Callback()
                task.wait(0.1)
                TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -16, 0, 38)}):Play()
            end)
        end

        function TabObj:CreateToggle(opts)
            orderCount = orderCount + 1
            local state = opts.CurrentValue or false
            local tgl = Instance.new("TextButton")
            tgl.LayoutOrder = orderCount
            tgl.Size = UDim2.new(1, -16, 0, 38)
            tgl.BackgroundColor3 = PremiumUI.Colors.Panel
            tgl.Text = "   " .. opts.Name
            tgl.TextColor3 = PremiumUI.Colors.Text
            tgl.Font = Enum.Font.GothamSemibold
            tgl.TextSize = 13
            tgl.TextXAlignment = Enum.TextXAlignment.Left
            tgl.Parent = page
            self:CreateRounded(tgl, 8)
            self:CreateStroke(tgl, PremiumUI.Colors.PanelLight, 1, 0.3)

            -- Toggle switch
            local bg = Instance.new("Frame")
            bg.Size = UDim2.new(0, 40, 0, 22)
            bg.Position = UDim2.new(1, -50, 0.5, -11)
            bg.BackgroundColor3 = state and PremiumUI.Colors.Success or PremiumUI.Colors.PanelLight
            bg.Parent = tgl
            self:CreateRounded(bg, 999)
            
            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 16, 0, 16)
            knob.Position = state and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            knob.BackgroundColor3 = PremiumUI.Colors.TextBright
            knob.Parent = bg
            self:CreateRounded(knob, 999)

            tgl.MouseEnter:Connect(function()
                TweenService:Create(tgl, TweenInfo.new(0.15), {BackgroundColor3 = PremiumUI.Colors.PanelHover}):Play()
            end)
            tgl.MouseLeave:Connect(function()
                TweenService:Create(tgl, TweenInfo.new(0.15), {BackgroundColor3 = PremiumUI.Colors.Panel}):Play()
            end)

            tgl.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = state and PremiumUI.Colors.Success or PremiumUI.Colors.PanelLight}):Play()
                TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = state and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}):Play()
                opts.Callback(state)
            end)
        end

        function TabObj:CreateDropdown(opts)
            orderCount = orderCount + 1
            local dropBtn = Instance.new("TextButton")
            dropBtn.LayoutOrder = orderCount
            dropBtn.Size = UDim2.new(1, -16, 0, 38)
            local txt = opts.Multi and "[Multi-Select]" or (opts.CurrentOption or opts.Options[1] or "")
            dropBtn.BackgroundColor3 = PremiumUI.Colors.Panel
            dropBtn.Text = "   " .. opts.Name .. ": " .. txt
            dropBtn.TextColor3 = PremiumUI.Colors.Text
            dropBtn.Font = Enum.Font.GothamSemibold
            dropBtn.TextSize = 13
            dropBtn.TextXAlignment = Enum.TextXAlignment.Left
            dropBtn.Parent = page
            self:CreateRounded(dropBtn, 8)
            self:CreateStroke(dropBtn, PremiumUI.Colors.PanelLight, 1, 0.3)

            -- Dropdown arrow
            local arrow = Instance.new("TextLabel")
            arrow.Size = UDim2.new(0, 20, 1, 0)
            arrow.Position = UDim2.new(1, -25, 0, 0)
            arrow.BackgroundTransparency = 1
            arrow.Text = "▾"
            arrow.TextColor3 = PremiumUI.Colors.TextDim
            arrow.Font = Enum.Font.Gotham
            arrow.TextSize = 14
            arrow.TextXAlignment = Enum.TextXAlignment.Center
            arrow.TextYAlignment = Enum.TextYAlignment.Center
            arrow.Parent = dropBtn

            dropBtn.MouseEnter:Connect(function()
                TweenService:Create(dropBtn, TweenInfo.new(0.15), {BackgroundColor3 = PremiumUI.Colors.PanelHover}):Play()
            end)
            dropBtn.MouseLeave:Connect(function()
                TweenService:Create(dropBtn, TweenInfo.new(0.15), {BackgroundColor3 = PremiumUI.Colors.Panel}):Play()
            end)

            orderCount = orderCount + 1
            local listFrame = Instance.new("Frame")
            listFrame.LayoutOrder = orderCount
            listFrame.Size = UDim2.new(1, -16, 0, 0)
            listFrame.BackgroundColor3 = PremiumUI.Colors.BgDarker
            listFrame.ClipsDescendants = true
            listFrame.Visible = false
            listFrame.Parent = page
            self:CreateRounded(listFrame, 8)
            self:CreateStroke(listFrame, PremiumUI.Colors.PanelLight, 1, 0.2)
            
            local lLayout = Instance.new("UIListLayout", listFrame)
            lLayout.Padding = UDim.new(0, 2)

            local open = false
            local selectedMulti = {}
            local function populate(options)
                for _, c in ipairs(listFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                local h = 0
                for _, opt in ipairs(options) do
                    local b = Instance.new("TextButton")
                    b.Size = UDim2.new(1, 0, 0, 32)
                    b.BackgroundColor3 = PremiumUI.Colors.BgDarker
                    b.Text = "   " .. opt
                    b.TextColor3 = PremiumUI.Colors.TextDim
                    b.Font = Enum.Font.Gotham
                    b.TextSize = 12
                    b.TextXAlignment = Enum.TextXAlignment.Left
                    b.Parent = listFrame
                    b.BackgroundTransparency = 0.5
                    
                    b.MouseEnter:Connect(function()
                        TweenService:Create(b, TweenInfo.new(0.1), {BackgroundTransparency = 0.2, TextColor3 = PremiumUI.Colors.TextBright}):Play()
                    end)
                    b.MouseLeave:Connect(function()
                        TweenService:Create(b, TweenInfo.new(0.1), {BackgroundTransparency = 0.5, TextColor3 = PremiumUI.Colors.TextDim}):Play()
                    end)
                    
                    b.MouseButton1Click:Connect(function()
                        if opts.Multi then
                            if selectedMulti[opt] then
                                selectedMulti[opt] = nil
                                TweenService:Create(b, TweenInfo.new(0.1), {TextColor3 = PremiumUI.Colors.TextDim}):Play()
                            else
                                selectedMulti[opt] = true
                                TweenService:Create(b, TweenInfo.new(0.1), {TextColor3 = PremiumUI.Colors.Accent}):Play()
                            end
                            opts.Callback(selectedMulti)
                        else
                            dropBtn.Text = "   " .. opts.Name .. ": " .. opt
                            TweenService:Create(listFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -16, 0, 0)}):Play()
                            task.wait(0.2)
                            listFrame.Visible = false
                            open = false
                            TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                            opts.Callback({opt})
                        end
                    end)
                    h = h + 32
                end
                if open then 
                    listFrame.Size = UDim2.new(1, -16, 0, h)
                end
            end
            populate(opts.Options)

            dropBtn.MouseButton1Click:Connect(function()
                open = not open
                if open then 
                    listFrame.Visible = true 
                    TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
                    TweenService:Create(listFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -16, 0, #listFrame:GetChildren() * 32)}):Play()
                else 
                    TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                    TweenService:Create(listFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -16, 0, 0)}):Play()
                    task.wait(0.2)
                    listFrame.Visible = false 
                end
            end)
            
            return { Refresh = function(_, newOpts) populate(newOpts) end }
        end

        function TabObj:CreateSlider(opts)
            orderCount = orderCount + 1
            local val = opts.CurrentValue or opts.Range[1]
            local frm = Instance.new("Frame")
            frm.LayoutOrder = orderCount
            frm.Size = UDim2.new(1, -16, 0, 56)
            frm.BackgroundColor3 = PremiumUI.Colors.Panel
            frm.Parent = page
            self:CreateRounded(frm, 8)
            self:CreateStroke(frm, PremiumUI.Colors.PanelLight, 1, 0.3)

            local lbl = Instance.new("TextLabel", frm)
            lbl.Size = UDim2.new(1, -20, 0, 22)
            lbl.Position = UDim2.new(0, 10, 0, 4)
            lbl.BackgroundTransparency = 1
            lbl.Text = opts.Name .. ": " .. val
            lbl.TextColor3 = PremiumUI.Colors.Text
            lbl.Font = Enum.Font.GothamSemibold
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left

            local valLbl = Instance.new("TextLabel", frm)
            valLbl.Size = UDim2.new(0, 60, 0, 22)
            valLbl.Position = UDim2.new(1, -70, 0, 4)
            valLbl.BackgroundTransparency = 1
            valLbl.Text = tostring(val)
            valLbl.TextColor3 = PremiumUI.Colors.Accent
            valLbl.Font = Enum.Font.GothamBold
            valLbl.TextSize = 13
            valLbl.TextXAlignment = Enum.TextXAlignment.Right

            local bgBar = Instance.new("TextButton", frm)
            bgBar.Size = UDim2.new(1, -20, 0, 6)
            bgBar.Position = UDim2.new(0, 10, 0, 38)
            bgBar.BackgroundColor3 = PremiumUI.Colors.BgDarker
            bgBar.Text = ""
            bgBar.AutoButtonColor = false
            self:CreateRounded(bgBar, 999)
            
            local fill = Instance.new("Frame", bgBar)
            fill.BackgroundColor3 = PremiumUI.Colors.Accent
            fill.Size = UDim2.new((val - opts.Range[1])/(opts.Range[2] - opts.Range[1]), 0, 1, 0)
            self:CreateRounded(fill, 999)
            self:CreateGradient(fill, PremiumUI.Colors.Gradient1, PremiumUI.Colors.Gradient2, 90)

            local dragging = false
            local function update(input)
                local pct = math.clamp((input.Position.X - bgBar.AbsolutePosition.X) / bgBar.AbsoluteSize.X, 0, 1)
                local rawVal = opts.Range[1] + pct * (opts.Range[2] - opts.Range[1])
                local inc = opts.Increment or 1
                val = math.floor(rawVal / inc + 0.5) * inc
                TweenService:Create(fill, TweenInfo.new(0.1), {Size = UDim2.new((val - opts.Range[1])/(opts.Range[2] - opts.Range[1]), 0, 1, 0)}):Play()
                lbl.Text = opts.Name .. ": " .. val
                valLbl.Text = tostring(val)
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

        function TabObj:CreateLabel(text)
            orderCount = orderCount + 1
            local lbl = Instance.new("TextLabel")
            lbl.LayoutOrder = orderCount
            lbl.Size = UDim2.new(1, -16, 0, 30)
            lbl.BackgroundColor3 = PremiumUI.Colors.Panel
            lbl.Text = "   " .. text
            lbl.TextColor3 = PremiumUI.Colors.TextDim
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = page
            self:CreateRounded(lbl, 6)
            lbl.BackgroundTransparency = 0.5
            
            return { 
                Set = function(_, txt) 
                    lbl.Text = "   " .. txt 
                end 
            }
        end
        
        function TabObj:CreateInput(opts)
            orderCount = orderCount + 1
            local frm = Instance.new("Frame")
            frm.LayoutOrder = orderCount
            frm.Size = UDim2.new(1, -16, 0, 38)
            frm.BackgroundColor3 = PremiumUI.Colors.Panel
            frm.Parent = page
            self:CreateRounded(frm, 8)
            self:CreateStroke(frm, PremiumUI.Colors.PanelLight, 1, 0.3)

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, -20, 1, 0)
            box.Position = UDim2.new(0, 10, 0, 0)
            box.BackgroundTransparency = 1
            box.Text = ""
            box.PlaceholderText = opts.Placeholder or opts.Name
            box.TextColor3 = PremiumUI.Colors.Text
            box.Font = Enum.Font.GothamSemibold
            box.TextSize = 13
            box.TextXAlignment = Enum.TextXAlignment.Left
            box.ClearTextOnFocus = false
            box.Parent = frm

            box.Focused:Connect(function()
                TweenService:Create(frm, TweenInfo.new(0.15), {BackgroundColor3 = PremiumUI.Colors.PanelHover}):Play()
            end)
            box.FocusLost:Connect(function()
                TweenService:Create(frm, TweenInfo.new(0.15), {BackgroundColor3 = PremiumUI.Colors.Panel}):Play()
                opts.Callback(box.Text)
            end)
        end

        return TabObj
    end

    function WindowObj:Notify(opts)
        print("[VOZEX HUB] " .. tostring(opts.Title) .. " - " .. tostring(opts.Content))
        
        -- Create in-game notification
        local notif = Instance.new("Frame")
        notif.Size = UDim2.new(0, 320, 0, 48)
        notif.Position = UDim2.new(0.5, -160, 0, 20)
        notif.BackgroundColor3 = PremiumUI.Colors.Panel
        notif.BackgroundTransparency = 0.2
        notif.Parent = sg
        self:CreateRounded(notif, 10)
        self:CreateStroke(notif, PremiumUI.Colors.Accent, 1, 0.3)
        self:CreateGlow(notif, PremiumUI.Colors.AccentGlow, 40)
        notif.BackgroundTransparency = 0.1
        
        local titleLbl = Instance.new("TextLabel", notif)
        titleLbl.Size = UDim2.new(1, -20, 0.5, 0)
        titleLbl.Position = UDim2.new(0, 10, 0, 2)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = opts.Title or "Notification"
        titleLbl.TextColor3 = PremiumUI.Colors.Accent
        titleLbl.Font = Enum.Font.GothamBold
        titleLbl.TextSize = 14
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        
        local contentLbl = Instance.new("TextLabel", notif)
        contentLbl.Size = UDim2.new(1, -20, 0.5, 0)
        contentLbl.Position = UDim2.new(0, 10, 0, 24)
        contentLbl.BackgroundTransparency = 1
        contentLbl.Text = opts.Content or ""
        contentLbl.TextColor3 = PremiumUI.Colors.TextDim
        contentLbl.Font = Enum.Font.Gotham
        contentLbl.TextSize = 12
        contentLbl.TextXAlignment = Enum.TextXAlignment.Left
        
        TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -160, 0, 15)}):Play()
        
        task.delay(3.5, function()
            TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -160, 0, -80)}):Play()
            task.wait(0.3)
            notif:Destroy()
        end)
    end
    
    function WindowObj:Unload()
        if self.Gui then self.Gui:Destroy() end
    end

    return WindowObj
end

-- // ============================================================ \\ --
-- //                            UI SETUP                         \\ --
-- // ============================================================ \\ --
local Window = PremiumUI:CreateWindow({
    Name = "Grow a Garden 2 ☘️"
})

-- ---- FARM TAB ----
local TabFarm = Window:CreateTab("🌾 Farm")
TabFarm:CreateSection("📊 Status")
local plotLabel = TabFarm:CreateLabel("Plot: …")
local cashLabel = TabFarm:CreateLabel("Sheckles: …")
local statLabel = TabFarm:CreateLabel("—")

TabFarm:CreateSection("⚡ Auto-Farm (master)")
TabFarm:CreateToggle({ Name = "Auto-Farm (buy+plant+harvest+sell+expand)", CurrentValue = false, Callback = function(v) S.autoFarm = v end })
TabFarm:CreateToggle({ Name = "Auto-Expand garden", CurrentValue = false, Callback = function(v) S.autoExpand = v end })
TabFarm:CreateToggle({ Name = "Auto-Daily deals", CurrentValue = false, Callback = function(v) S.autoDaily = v end })

TabFarm:CreateSection("🌱 Buy seeds")
TabFarm:CreateDropdown({ Name = "Seeds to buy", Multi = true, Options = SEED_NAMES, CurrentOption = {}, Callback = function(sel) pickMulti(sel, S.buySeeds) end })
TabFarm:CreateToggle({ Name = "Auto-Buy selected", CurrentValue = false, Callback = function(v) S.autoBuy = v end })
TabFarm:CreateSlider({ Name = "Buy interval (s)", Range = {1, 30}, Increment = 1, CurrentValue = 5, Callback = function(v) S.buyInterval = v end })
TabFarm:CreateSlider({ Name = "Max buys / seed / pass", Range = {1, 50}, Increment = 1, CurrentValue = 8, Callback = function(v) S.buyPerTick = v end })

TabFarm:CreateSection("🌿 Plant / Harvest / Sell")
local plantOpts = { "Best owned" }; for _, n in ipairs(SEED_NAMES) do plantOpts[#plantOpts + 1] = n end
TabFarm:CreateDropdown({ Name = "Seed to plant", Options = plantOpts, CurrentOption = "Best owned", Callback = function(v) S.plantSeed = v[1] end })
TabFarm:CreateToggle({ Name = "Auto-Plant (fill plot)", CurrentValue = false, Callback = function(v) S.autoPlant = v end })
TabFarm:CreateSlider({ Name = "Plant spacing (studs)", Range = {2, 10}, Increment = 1, CurrentValue = 4, Callback = function(v) S.plantSpacing = v end })
TabFarm:CreateToggle({ Name = "Auto-Harvest ripe fruit", CurrentValue = false, Callback = function(v) S.autoHarvest = v end })
TabFarm:CreateSlider({ Name = "Harvest pace (s/fruit)", Range = {0, 0.2}, Increment = 0.01, CurrentValue = 0.01, Callback = function(v) S.harvestDelay = v end })
TabFarm:CreateToggle({ Name = "Auto-Sell (when pack full)", CurrentValue = false, Callback = function(v) S.autoSell = v end })
TabFarm:CreateSlider({ Name = "Sell interval (s, sell-only mode)", Range = {3, 120}, Increment = 1, CurrentValue = 15, Callback = function(v) S.sellInterval = v end })
TabFarm:CreateToggle({ Name = "Auto-Pot grown plants", CurrentValue = false, Callback = function(v) S.autoPot = v end })

-- ---- BOOSTS TAB ----
local TabBoosts = Window:CreateTab("✨ Boosts")
TabBoosts:CreateSection("💦 Sprinklers & Water")
TabBoosts:CreateToggle({ Name = "Auto-place Sprinklers", CurrentValue = false, Callback = function(v) S.autoSprinkler = v end })
TabBoosts:CreateSlider({ Name = "Sprinkler interval (s)", Range = {10, 120}, Increment = 1, CurrentValue = 30, Callback = function(v) S.sprinklerInterval = v end })
TabBoosts:CreateToggle({ Name = "Auto-Watering Can", CurrentValue = false, Callback = function(v) S.autoWater = v end })
TabBoosts:CreateSlider({ Name = "Water interval (s)", Range = {2, 60}, Increment = 1, CurrentValue = 8, Callback = function(v) S.waterInterval = v end })

TabBoosts:CreateSection("📈 Skill points")
TabBoosts:CreateDropdown({ Name = "Stats to level", Multi = true, Options = { "BaseSpeed", "BaseJump", "ShovelPower", "MaxBackpack" }, CurrentOption = {}, Callback = function(sel) pickMulti(sel, S.skillStats) end })
TabBoosts:CreateToggle({ Name = "Auto-Spend skill points", CurrentValue = false, Callback = function(v) S.autoSkill = v end })

-- ---- PETS TAB ----
local TabPets = Window:CreateTab("🐶 Pets")
TabPets:CreateSection("🐾 Pets")
TabPets:CreateToggle({ Name = "Auto-Equip pets (to slot cap)", CurrentValue = false, Callback = function(v) S.autoEquipPets = v end })
TabPets:CreateToggle({ Name = "Auto-Buy pet slots", CurrentValue = false, Callback = function(v) S.autoPetSlot = v end })
TabPets:CreateToggle({ Name = "Auto-Buy world pets (walk up & buy)", CurrentValue = false, Callback = function(v) S.autoBuyPets = v end })
TabPets:CreateSlider({ Name = "Max pet price (Sheckles)", Range = {1000, 1000000}, Increment = 1000, CurrentValue = 25000, Callback = function(v) S.maxPetPrice = v end })
TabPets:CreateToggle({ Name = "Teleport to pet (needed to buy)", CurrentValue = true, Callback = function(v) S.petTeleport = v end })
TabPets:CreateSlider({ Name = "Pet buy interval (s)", Range = {2, 60}, Increment = 1, CurrentValue = 5, Callback = function(v) S.petBuyInterval = v end })

TabPets:CreateSection("💰 Sell pets")
TabPets:CreateDropdown({ Name = "Pets to sell", Multi = true, Options = ownedPetNames(), CurrentOption = {}, Callback = function(sel) pickMulti(sel, S.sellPets) end })
TabPets:CreateToggle({ Name = "Auto-Sell selected pets", CurrentValue = false, Callback = function(v) S.autoSellPets = v end })

-- ---- OPEN TAB ----
local TabOpen = Window:CreateTab("📦 Eggs & Crates")
TabOpen:CreateSection("📦 Auto-Open")
TabOpen:CreateToggle({ Name = "Auto-Open Eggs", CurrentValue = false, Callback = function(v) S.autoEgg = v end })
TabOpen:CreateToggle({ Name = "Auto-Open Crates", CurrentValue = false, Callback = function(v) S.autoCrate = v end })
TabOpen:CreateToggle({ Name = "Auto-Open Seed Packs", CurrentValue = false, Callback = function(v) S.autoPack = v end })
TabOpen:CreateSlider({ Name = "Open interval (s)", Range = {1, 30}, Increment = 1, CurrentValue = 4, Callback = function(v) S.openInterval = v end })
TabOpen:CreateSection("ℹ️ Info")
TabOpen:CreateLabel("Opens everything you own in each")
TabOpen:CreateLabel("category. Confirm is automatic.")

-- ---- SHOP TAB ----
local TabShop = Window:CreateTab("🛒 Shop")
TabShop:CreateSection("🛍️ Gear shop")
TabShop:CreateDropdown({ Name = "Gear to buy", Multi = true, Options = GEAR_NAMES, CurrentOption = {}, Callback = function(sel) pickMulti(sel, S.gearBuy) end })
TabShop:CreateToggle({ Name = "Auto-Buy selected gear", CurrentValue = false, Callback = function(v) S.autoGear = v end })
TabShop:CreateSlider({ Name = "Gear buy interval (s)", Range = {2, 60}, Increment = 1, CurrentValue = 10, Callback = function(v) S.gearInterval = v end })

-- ---- STEAL TAB ----
local TabSteal = Window:CreateTab("🥷 Steal")
TabSteal:CreateSection("🌙 Auto-Steal (night only)")
TabSteal:CreateToggle({ Name = "Auto-Steal others' ripe fruit", CurrentValue = false, Callback = function(v) S.autoSteal = v end })
TabSteal:CreateToggle({ Name = "Teleport to fruit (needed to steal)", CurrentValue = true, Callback = function(v) S.stealTeleport = v end })
TabSteal:CreateToggle({ Name = "Return to base after each fruit (banks it)", CurrentValue = true, Callback = function(v) S.stealReturnBase = v end })
TabSteal:CreateSlider({ Name = "Steal speed (delay/fruit, 0=instant)", Range = {0, 1}, Increment = 0.01, CurrentValue = 0.05, Callback = function(v) S.stealDelay = v end })
TabSteal:CreateSection("ℹ️ Info")
TabSteal:CreateLabel("Night-only · TP to fruit, steal,")
TabSteal:CreateLabel("then TP home to bank each one.")

-- ---- MISC TAB ----
local TabMisc = Window:CreateTab("⚙️ Misc")
TabMisc:CreateSection("📬 Mail & Gifts")
TabMisc:CreateToggle({ Name = "Auto-Claim mailbox", CurrentValue = false, Callback = function(v) S.autoMail = v end })
TabMisc:CreateToggle({ Name = "Auto-Accept gifts", CurrentValue = false, Callback = function(v) S.autoAcceptGift = v end })

TabMisc:CreateSection("⏱️ Session")
TabMisc:CreateToggle({ Name = "Anti-AFK (never idle-kicked)", CurrentValue = true, Callback = function(v) S.antiAfk = v end })
TabMisc:CreateToggle({ Name = "Auto server-hop", CurrentValue = false, Callback = function(v) S.autoHop = v end })
TabMisc:CreateSlider({ Name = "Hop every (min, 0=off)", Range = {0, 120}, Increment = 1, CurrentValue = 0, Callback = function(v) S.hopInterval = v * 60 end })

TabMisc:CreateSection("🔑 Codes")
TabMisc:CreateInput({ Name = "Redeem a code", Placeholder = "enter code", Callback = function(text)
    if text and text ~= "" then
        local ok, res = fire("Settings.SubmitCode", text)
        Window:Notify({Title="Code", Content=(ok and res == true) and ("Redeemed: " .. text) or ("Invalid: " .. text)})
    end
end })
TabMisc:CreateToggle({ Name = "Auto-redeem code list", CurrentValue = false, Callback = function(v) S.autoCodes = v end })

-- ---- SETTINGS TAB ----
local TabSettings = Window:CreateTab("🛠️ Settings")
TabSettings:CreateSection("⚡ Performance & Interface")
TabSettings:CreateToggle({ Name = "FPS Boost (low graphics)", CurrentValue = false, Callback = function(v) S.fpsBoost = v; applyFpsBoost(v) end })
TabSettings:CreateButton({ Name = "🛑 Unload hub (stops everything)", Callback = function() S.killed = true; pcall(function() Window:Unload() end) end })

TabSettings:CreateSection("📊 Discord Webhook")
TabSettings:CreateInput({ Name = "Webhook URL", Placeholder = "https://discord.com/api/webhooks/...", Callback = function(t) S.webhookUrl = t or "" end })
TabSettings:CreateToggle({ Name = "Enable reports", CurrentValue = false, Callback = function(v) S.webhookEnabled = v end })
TabSettings:CreateSlider({ Name = "Report interval (min)", Range = {1, 60}, Increment = 1, CurrentValue = 5, Callback = function(v) S.webhookInterval = v * 60 end })
TabSettings:CreateButton({ Name = "📤 Send test report", Callback = function() task.spawn(function() sendWebhook(true) end) end })

TabSettings:CreateSection("ℹ️ Info")
TabSettings:CreateLabel("Grow a Garden 2 · Premium Vozex Hub")

-- Auto-Pot loop 
loopOn(function() return S.autoPot end, 10, function()
    local plot = myPlot(); local plants = plot and plot:FindFirstChild("Plants")
    if not plants then return end
    for _, m in ipairs(plants:GetChildren()) do
        if not S.autoPot then break end
        local pid = m:GetAttribute("PlantId") or m.Name
        if pid then fire("Garden.PotPlant", tostring(pid)); task.wait(0.3) end
    end
end)

-- live status
task.spawn(function()
    while not S.killed do
        local p = myPlot()
        pcall(function() plotLabel:Set("Plot: " .. (p and p.Name or "?")) end)
        pcall(function() cashLabel:Set(string.format("Sheckles: %s · Tokens: %s", fmt(getSheckles()), fmt(getTokens()))) end)
        pcall(function() statLabel:Set(string.format("bought %d · planted %d · harvested %d · sold %d (+%s)",
            Stats.bought, Stats.planted, Stats.harvested, Stats.sold, fmt(Stats.earned))) end)
        task.wait(2)
    end
end)

pcall(function()
    if getgenv then getgenv().SkrilyaGAG2 = {
        S = S, Stats = Stats, Net = Net, fire = fire, action = action,
        catalog = CATALOG, gearNames = GEAR_NAMES, myPlot = myPlot, replica = replica,
        ripeHarvests = ripeHarvests, stealable = stealable, wildPets = wildPets,
        toolsByAttr = toolsByAttr, plantGrid = plantGrid, ownedPetNames = ownedPetNames, myBasePos = myBasePos,
        stepHarvest = stepHarvest, fireFast = fireFast, fruitCount = fruitCount, sellAllNow = sellAllNow, maxFruitCap = maxFruitCap,
        unload = function() S.killed = true; pcall(function() Window:Unload() end) end,
    } end
end)

Window:Notify({ Title = "🌱 Vozex Hub Premium", Content = "GAG2 full-auto loaded · " .. #SEED_NAMES .. " seeds · " .. #GEAR_NAMES .. " gear"})
print("[Vozex Hub] Grow a Garden 2 Premium UI loaded.")