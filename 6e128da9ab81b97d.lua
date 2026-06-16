-- ts file was generated at discord.gg/25ms

local genv = getgenv()
local _call3 = game:GetService('TweenService')

game:GetService('UserInputService')

local _call9 = game:GetService('Lighting')

game:GetService('HttpService')

local _call13 = game:GetService('ReplicatedStorage')

game:GetService('Workspace')
game:GetService('GuiService')
game:GetService('MarketplaceService')
game:GetService('VirtualInputManager')

local _LocalPlayer24 = game:GetService('Players').LocalPlayer
local _call26 = _LocalPlayer24:WaitForChild('PlayerGui')

require(_call13:WaitForChild('SharedModules'):WaitForChild('Networking'))

local _ = genv.LeewalkyHubSession

genv.LeewalkyHubSession = 1

local _ = genv.LeewalkyHubSession

Color3.fromRGB(9, 11, 16)
Color3.fromRGB(18, 21, 29)
Color3.fromRGB(25, 29, 39)
Color3.fromRGB(34, 39, 52)
Color3.fromRGB(245, 248, 252)
Color3.fromRGB(145, 154, 170)
Color3.fromRGB(145, 160, 255)
Color3.fromRGB(95, 105, 255)
Color3.fromRGB(255, 75, 95)
Color3.fromRGB(57, 65, 82)
Color3.fromRGB(5, 10, 13)
Color3.fromRGB(0, 0, 0)

local _call59 = Color3.fromRGB(8, 9, 13)
local _call61 = Color3.fromRGB(17, 19, 26)
local _call63 = Color3.fromRGB(24, 27, 36)

Color3.fromRGB(34, 38, 50)

local _call69 = Color3.fromRGB(145, 153, 166)
local _call71 = Color3.fromRGB(145, 160, 255)

Color3.fromRGB(255, 75, 95)
Color3.fromRGB(5, 7, 10)
Color3.fromRGB(18, 10, 18)
Color3.fromRGB(29, 17, 31)
Color3.fromRGB(42, 24, 45)
Color3.fromRGB(57, 31, 61)
Color3.fromRGB(255, 244, 252)
Color3.fromRGB(211, 162, 199)
Color3.fromRGB(255, 95, 190)
Color3.fromRGB(195, 80, 255)
Color3.fromRGB(255, 77, 119)
Color3.fromRGB(90, 52, 91)
Color3.fromRGB(24, 5, 18)
Color3.fromRGB(0, 0, 0)
Color3.fromRGB(18, 9, 10)
Color3.fromRGB(31, 17, 18)
Color3.fromRGB(43, 23, 25)
Color3.fromRGB(61, 31, 34)
Color3.fromRGB(255, 245, 245)
Color3.fromRGB(216, 157, 159)
Color3.fromRGB(255, 70, 82)
Color3.fromRGB(255, 135, 68)
Color3.fromRGB(255, 58, 72)
Color3.fromRGB(93, 50, 53)
Color3.fromRGB(25, 4, 6)
Color3.fromRGB(0, 0, 0)
Color3.fromRGB(242, 244, 248)
Color3.fromRGB(255, 255, 255)
Color3.fromRGB(232, 236, 244)
Color3.fromRGB(216, 222, 234)
Color3.fromRGB(22, 26, 34)
Color3.fromRGB(94, 105, 123)
Color3.fromRGB(75, 95, 245)
Color3.fromRGB(150, 85, 255)
Color3.fromRGB(230, 55, 73)
Color3.fromRGB(190, 198, 214)
Color3.fromRGB(255, 255, 255)
Color3.fromRGB(0, 0, 0)

local _ = genv.LeewalkyHubSession

game:GetService('RunService').Heartbeat:Connect(function()
    local _Character159 = _LocalPlayer24.Character

    _Character159:FindFirstChild('HumanoidRootPart')

    local _ = _Character159:FindFirstChild('Humanoid').MoveDirection.Magnitude
end)

local _ = Enum.KeyCode.LeftShift

_call26:FindFirstChild('KrassUI_Local'):Destroy()
_call9:FindFirstChild('KrassUI_Local_Blur'):Destroy()

local _call179 = Instance.new('ScreenGui')

_call179.Name = 'KrassUI_Local'
_call179.DisplayOrder = 999
_call179.Parent = _call26
_call179.IgnoreGuiInset = true
_call179.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
_call179.ResetOnSpawn = false

_call9:FindFirstChild('KrassUI_Local_Blur')

local _call189 = Instance.new('Frame')

_call189.AnchorPoint = Vector2.new(0.5, 0.5)
_call189.BackgroundTransparency = 1
_call189.Position = UDim2.fromScale(0.5, 0.5)
_call189.Parent = _call179
_call189.Size = UDim2.fromOffset(690, 450)

local _call191 = Instance.new('UIScale')

_call191.Parent = _call189
_call191.Scale = 0.84

local _call201 = Instance.new('ImageLabel')

_call201.ImageColor3 = Color3.fromRGB(0, 0, 0)
_call201.ScaleType = Enum.ScaleType.Slice
_call201.ImageTransparency = 1
_call201.Parent = _call189
_call201.Image = 'rbxassetid://1316045217'
_call201.BackgroundTransparency = 1
_call201.Position = UDim2.fromOffset(-48, -48)
_call201.Visible = false
_call201.ZIndex = 0
_call201.SliceCenter = Rect.new(10, 10, 118, 118)
_call201.Size = UDim2.new(1, 96, 1, 96)

local _call205 = Instance.new('Frame')

_call205.Size = UDim2.fromScale(1, 1)
_call205.ClipsDescendants = true
_call205.Parent = _call189
_call205.ZIndex = 2
_call205.BorderSizePixel = 0
_call205.BackgroundColor3 = _call59

local _call209 = Instance.new('UICorner')

_call209.CornerRadius = UDim.new(0, 12)
_call209.Parent = _call205

local _call213 = Instance.new('UIStroke')

_call213.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
_call213.Transparency = 0.12
_call213.Thickness = 1
_call213.Color = Color3.fromRGB(58, 64, 80)
_call213.Parent = _call205

local _call217 = Instance.new('Frame')

_call217.Size = UDim2.new(1, 0, 0, 3)
_call217.Parent = _call205
_call217.ZIndex = 4
_call217.BorderSizePixel = 0
_call217.BackgroundColor3 = _call71

local _call223 = ColorSequence.new({
    [1] = ColorSequenceKeypoint.new(0, _call71),
    [2] = ColorSequenceKeypoint.new(1, Color3.fromRGB(95, 105, 255)),
})
local _call225 = Instance.new('UIGradient')

_call225.Color = _call223
_call225.Parent = _call217
_call225.Rotation = 0

task.spawn(function(_228, _228_2, _228_3)
    local _ = _call225.Parent

    _call225.Rotation = 0

    local _call237 = _call3:Create(_call225, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Rotation = 360})

    _call237:Play()
    task.wait(4)

    local _ = _call225.Parent

    _call225.Rotation = 0

    local _call248 = _call3:Create(_call225, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Rotation = 360})

    _call248:Play()
    task.wait(4)

    local _ = _call225.Parent

    _call225.Rotation = 0

    local _call259 = _call3:Create(_call225, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Rotation = 360})

    _call259:Play()
    task.wait(4)

    local _ = _call225.Parent

    _call225.Rotation = 0

    local _call270 = _call3:Create(_call225, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Rotation = 360})

    _call270:Play()
    task.wait(4)

    local _ = _call225.Parent

    _call225.Rotation = 0

    local _call281 = _call3:Create(_call225, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Rotation = 360})

    _call281:Play()
    task.wait(4)

    local _ = _call225.Parent

    _call225.Rotation = 0

    local _call292 = _call3:Create(_call225, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Rotation = 360})

    _call292:Play()
    task.wait(4)

    local _ = _call225.Parent

    _call225.Rotation = 0

    local _call303 = _call3:Create(_call225, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Rotation = 360})

    _call303:Play()
    task.wait(4)

    local _ = _call225.Parent

    _call225.Rotation = 0

    local _call314 = _call3:Create(_call225, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Rotation = 360})

    _call314:Play()
    task.wait(4)

    local _ = _call225.Parent

    _call225.Rotation = 0

    local _ = Enum.EasingStyle.Linear

    error('internal 583: <25ms: infinitelooperror>')
end)

local _call328 = Instance.new('Frame')

_call328.Rotation = 16
_call328.Size = UDim2.new(0.18, 0, 1.35, 0)
_call328.BackgroundTransparency = 0.88
_call328.Position = UDim2.new(-0.35, 0, 0, 0)
_call328.Parent = _call205
_call328.ZIndex = 6
_call328.BorderSizePixel = 0
_call328.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

local _call336 = ColorSequence.new({
    [1] = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    [2] = ColorSequenceKeypoint.new(1, _call71),
})
local _call338 = Instance.new('UIGradient')

_call338.Color = _call336
_call338.Parent = _call328
_call338.Rotation = 90

task.spawn(function()
    local _ = _call328.Parent

    _call328.Position = UDim2.new(-0.35, 0, -0.18, 0)
    _call328.BackgroundTransparency = 0.92

    local _call354 = _call3:Create(_call328, TweenInfo.new(1.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1,
        Position = UDim2.new(1.18, 0, -0.18, 0),
    })

    _call354:Play()
    task.wait(4.4)

    local _ = _call328.Parent

    _call328.Position = UDim2.new(-0.35, 0, -0.18, 0)
    _call328.BackgroundTransparency = 0.92

    UDim2.new(1.18, 0, -0.18, 0)

    local _ = Enum.EasingStyle.Quint

    error('internal 583: <25ms: infinitelooperror>')
end)

local _call370 = Instance.new('Frame')

_call370.Size = UDim2.new(1, 0, 0, 54)
_call370.Position = UDim2.fromOffset(0, 3)
_call370.Parent = _call205
_call370.ZIndex = 3
_call370.BorderSizePixel = 0
_call370.BackgroundColor3 = _call61

local _call380 = Instance.new('TextLabel')

_call380.TextColor3 = Color3.fromRGB(244, 246, 250)
_call380.Parent = _call370
_call380.Text = 'WalkyHub'
_call380.Font = Enum.Font.GothamBold
_call380.BackgroundTransparency = 1
_call380.TextTruncate = Enum.TextTruncate.AtEnd
_call380.TextYAlignment = Enum.TextYAlignment.Center
_call380.TextSize = 17
_call380.TextXAlignment = Enum.TextXAlignment.Left
_call380.Position = UDim2.fromOffset(18, 7)
_call380.Size = UDim2.new(1, -160, 0, 24)
_call380.ZIndex = 4

local _call394 = Instance.new('TextLabel')

_call394.TextColor3 = _call69
_call394.Parent = _call370
_call394.Text = 'Made By Leewalky \u{2764}\u{fe0f}'
_call394.Font = Enum.Font.Gotham
_call394.BackgroundTransparency = 1
_call394.TextTruncate = Enum.TextTruncate.AtEnd
_call394.TextYAlignment = Enum.TextYAlignment.Center
_call394.TextSize = 11
_call394.TextXAlignment = Enum.TextXAlignment.Left
_call394.Position = UDim2.fromOffset(18, 29)
_call394.Size = UDim2.new(1, -160, 0, 18)
_call394.ZIndex = 4

local _call404 = Instance.new('TextButton')

_call404.ClipsDescendants = true
_call404.Parent = _call370
_call404.Text = 'X'
_call404.AutoButtonColor = false
_call404.Font = Enum.Font.GothamSemibold
_call404.TextXAlignment = Enum.TextXAlignment.Center
_call404.TextSize = 13
_call404.TextColor3 = _call69
_call404.BorderSizePixel = 0
_call404.BackgroundColor3 = _call63
_call404.Position = UDim2.new(1, -44, 0, 11)
_call404.Size = UDim2.fromOffset(32, 32)
_call404.ZIndex = 5

local _call412 = Instance.new('UICorner')

_call412.CornerRadius = UDim.new(0, 8)
_call412.Parent = _call404

local _call418 = Instance.new('TextButton')

_call418.ClipsDescendants = true
_call418.Parent = _call370
_call418.Text = '-'
_call418.AutoButtonColor = false
_call418.Font = Enum.Font.GothamSemibold
_call418.TextXAlignment = Enum.TextXAlignment.Center
_call418.TextSize = 13
_call418.TextColor3 = _call69
_call418.BorderSizePixel = 0
_call418.BackgroundColor3 = _call63
_call418.Position = UDim2.new(1, -82, 0, 11)
_call418.Size = UDim2.fromOffset(32, 32)
_call418.ZIndex = 5

local _call426 = Instance.new('UICorner')

_call426.CornerRadius = UDim.new(0, 8)
_call426.Parent = _call418

local _call432 = Instance.new('Frame')

_call432.Size = UDim2.new(0, 166, 1, -57)
_call432.Position = UDim2.fromOffset(0, 57)
_call432.Parent = _call205
_call432.ZIndex = 3
_call432.BorderSizePixel = 0
_call432.BackgroundColor3 = _call61

local _call442 = Instance.new('UIPadding')

_call442.PaddingBottom = UDim.new(0, 12)
_call442.PaddingTop = UDim.new(0, 12)
_call442.PaddingLeft = UDim.new(0, 12)
_call442.PaddingRight = UDim.new(0, 12)
_call442.Parent = _call432

local _call448 = Instance.new('UIListLayout')

_call448.SortOrder = Enum.SortOrder.LayoutOrder
_call448.Padding = UDim.new(0, 8)
_call448.Parent = _call432

local _call454 = Instance.new('Frame')

_call454.BackgroundTransparency = 1
_call454.ClipsDescendants = true
_call454.Parent = _call205
_call454.ZIndex = 3
_call454.Position = UDim2.fromOffset(166, 57)
_call454.Size = UDim2.new(1, -166, 1, -57)

local _call458 = Instance.new('Frame')

_call458.Size = UDim2.fromScale(1, 1)
_call458.ClipsDescendants = true
_call458.Parent = _call205
_call458.ZIndex = 30
_call458.BorderSizePixel = 0
_call458.BackgroundColor3 = _call59

local _call462 = Instance.new('UICorner')

_call462.CornerRadius = UDim.new(0, 12)
_call462.Parent = _call458

local _call470 = Instance.new('Frame')

_call470.AnchorPoint = Vector2.new(0.5, 0.5)
_call470.Size = UDim2.fromOffset(116, 116)
_call470.BackgroundTransparency = 0.78
_call470.Position = UDim2.fromScale(0.5, 0.42)
_call470.Parent = _call458
_call470.ZIndex = 31
_call470.BorderSizePixel = 0
_call470.BackgroundColor3 = _call71

UDim.new(0, 58)
error('internal 583: <25ms: infinitelooperror>')
