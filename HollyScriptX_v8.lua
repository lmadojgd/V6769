-- HollyScriptX Universal v8.0 - Liquid Glass UI + Assistant (client-only)
-- LocalScript in StarterPlayer > StarterPlayerScripts
-- Tabs: MOVE / VIEW / ESP / TOOLS / USERS / AI / MISC
-- Hotkeys (PC): RightShift panel, F fly, N noclip, V esp, E/Q fly up/down
-- Everything is local: nothing here touches the server or remotes.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- ========== State ==========
local state = {
    -- movement
    walk = 16,
    jumpHeight = 7.2,
    flySpeed = 50,
    flying = false,
    noclip = false,
    infJump = false,
    up = false,
    down = false,
    -- view
    fov = 70,
    fovOn = false,
    shader = "Off",
    fullbright = false,
    noFog = false,
    clock = 14,
    clockOn = false,
    -- esp
    esp = false,
    espBox = true,
    espName = true,
    espDist = true,
    espHealth = true,
    espTeam = false, -- true = hide teammates
    espRange = 1000,
    espChams = true,
    espTracers = false,
    espNpc = false,
    espRainbow = false,
    espHealthBar = true,
    espFill = 0.75,
    -- misc
    blur = false,
    stats = false,
    gravity = 196,
    gravityOn = false,
    crosshair = false,
    crosshairSize = 30,
    clickTp = false,
    spin = false,
    spinSpeed = 6,
    antiVoid = false,
    timeFlow = false,
    timeFlowSpeed = 0.5,
    toasts = true,
    lite = false,
    themeCycle = false,
}

-- Humanoid values are written only after the user touches the slider
local custom = { walk = false, jump = false }

local C = {
    white = Color3.new(1, 1, 1),
    tint = Color3.fromRGB(16, 22, 38),
    accent = Color3.fromRGB(120, 190, 255),
    accent2 = Color3.fromRGB(190, 140, 255),
    on = Color3.fromRGB(70, 210, 160),
    text = Color3.fromRGB(245, 248, 255),
    sub = Color3.fromRGB(165, 178, 210),
    danger = Color3.fromRGB(255, 110, 110),
}

-- ========== Theme (accent colors + glass tint) ==========
local THEMES = {
    Ocean    = { accent = Color3.fromRGB(120, 190, 255), accent2 = Color3.fromRGB(190, 140, 255), on = Color3.fromRGB(70, 210, 160),  tint = Color3.fromRGB(16, 22, 38) },
    Rose     = { accent = Color3.fromRGB(255, 140, 180), accent2 = Color3.fromRGB(255, 190, 120), on = Color3.fromRGB(255, 120, 150), tint = Color3.fromRGB(36, 16, 28) },
    Mint     = { accent = Color3.fromRGB(110, 235, 190), accent2 = Color3.fromRGB(110, 190, 255), on = Color3.fromRGB(70, 210, 160),  tint = Color3.fromRGB(12, 30, 28) },
    Amber    = { accent = Color3.fromRGB(255, 190, 90),  accent2 = Color3.fromRGB(255, 120, 90),  on = Color3.fromRGB(255, 170, 60),  tint = Color3.fromRGB(34, 24, 12) },
    Violet   = { accent = Color3.fromRGB(180, 140, 255), accent2 = Color3.fromRGB(120, 160, 255), on = Color3.fromRGB(150, 110, 255), tint = Color3.fromRGB(24, 16, 40) },
    Sunset   = { accent = Color3.fromRGB(255, 120, 100), accent2 = Color3.fromRGB(255, 190, 90),  on = Color3.fromRGB(255, 150, 80),  tint = Color3.fromRGB(38, 18, 22) },
    Crimson  = { accent = Color3.fromRGB(255, 80, 100),  accent2 = Color3.fromRGB(200, 60, 140),  on = Color3.fromRGB(255, 90, 90),   tint = Color3.fromRGB(30, 10, 14) },
    Ice      = { accent = Color3.fromRGB(170, 225, 255), accent2 = Color3.fromRGB(220, 240, 255), on = Color3.fromRGB(120, 210, 255), tint = Color3.fromRGB(14, 24, 36) },
    Forest   = { accent = Color3.fromRGB(120, 220, 120), accent2 = Color3.fromRGB(200, 230, 100), on = Color3.fromRGB(90, 200, 110),  tint = Color3.fromRGB(10, 26, 16) },
    Candy    = { accent = Color3.fromRGB(255, 150, 220), accent2 = Color3.fromRGB(150, 200, 255), on = Color3.fromRGB(255, 130, 200), tint = Color3.fromRGB(30, 18, 38) },
    Gold     = { accent = Color3.fromRGB(255, 210, 100), accent2 = Color3.fromRGB(255, 240, 170), on = Color3.fromRGB(240, 190, 60),  tint = Color3.fromRGB(28, 24, 12) },
    Midnight = { accent = Color3.fromRGB(110, 130, 255), accent2 = Color3.fromRGB(80, 200, 255),  on = Color3.fromRGB(100, 140, 255), tint = Color3.fromRGB(8, 10, 26) },
    Mono     = { accent = Color3.fromRGB(230, 230, 240), accent2 = Color3.fromRGB(160, 165, 185), on = Color3.fromRGB(200, 205, 220), tint = Color3.fromRGB(18, 18, 22) },
    Neon     = { accent = Color3.fromRGB(60, 255, 190),  accent2 = Color3.fromRGB(255, 60, 220),  on = Color3.fromRGB(60, 255, 140),  tint = Color3.fromRGB(8, 8, 16) },
    Lavender = { accent = Color3.fromRGB(200, 180, 255), accent2 = Color3.fromRGB(255, 190, 230), on = Color3.fromRGB(180, 150, 255), tint = Color3.fromRGB(22, 18, 34) },
    Ember    = { accent = Color3.fromRGB(255, 150, 60),  accent2 = Color3.fromRGB(255, 90, 60),   on = Color3.fromRGB(255, 120, 40),  tint = Color3.fromRGB(30, 14, 8) },
}
local THEME_ORDER = { "Ocean", "Rose", "Mint", "Amber", "Violet", "Sunset", "Crimson", "Ice",
    "Forest", "Candy", "Gold", "Midnight", "Mono", "Neon", "Lavender", "Ember" }
local themeCallbacks = {}
local themeRings = {}
local currentTheme = "Ocean"

local function onTheme(fn)
    fn()
    table.insert(themeCallbacks, fn)
end

local function setTheme(name)
    local t = THEMES[name]
    if not t then return false end
    currentTheme = name
    C.accent, C.accent2, C.on, C.tint = t.accent, t.accent2, t.on, t.tint
    for _, fn in ipairs(themeCallbacks) do
        pcall(fn)
    end
    for other, ring in pairs(themeRings) do
        TweenService:Create(ring, TweenInfo.new(0.3),
            { Transparency = (other == name) and 0 or 1 }):Play()
    end
    return true
end

-- ========== Connection tracking (clean unload) ==========
local connections = {}
local function bind(signal, fn)
    local c = signal:Connect(fn)
    table.insert(connections, c)
    return c
end

-- ========== Animation + glass helpers ==========
local function tween(inst, time, props, style, dir)
    local t = TweenService:Create(inst,
        TweenInfo.new(time, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out),
        props)
    t:Play()
    return t
end

local function loopTween(inst, time, props)
    TweenService:Create(inst,
        TweenInfo.new(time, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        props):Play()
end

-- Roundness multiplier: lower = squarer "rounded square" look, higher = pill look
local roundness = 0.55
local cornerRegistry = {}

local function corner(inst, r)
    local c = Instance.new("UICorner")
    if r <= 60 then
        c.CornerRadius = UDim.new(0, r * roundness)
        table.insert(cornerRegistry, { c, r })
    else
        c.CornerRadius = UDim.new(0, r) -- blobs / ripples stay circular
    end
    c.Parent = inst
    return c
end

local function setRoundness(m)
    roundness = m
    for i = #cornerRegistry, 1, -1 do
        local entry = cornerRegistry[i]
        if entry[1].Parent then
            entry[1].CornerRadius = UDim.new(0, entry[2] * m)
        else
            table.remove(cornerRegistry, i)
        end
    end
end

local function stroke(inst, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.Color = C.white
    s.Transparency = transparency or 0.75
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = inst
    return s
end

-- vertical glass sheen (more opaque on top, clearer at the bottom)
local function sheen(inst, a, b)
    local g = Instance.new("UIGradient")
    g.Rotation = 90
    g.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, a),
        NumberSequenceKeypoint.new(1, b),
    })
    g.Parent = inst
    return g
end

-- glass layer: frosted translucent fill + hairline border + sheen
local function surface(parent, radius, transparency, color)
    local f = Instance.new("Frame")
    f.Size = UDim2.fromScale(1, 1)
    f.BackgroundColor3 = color or C.white
    f.BackgroundTransparency = transparency
    f.BorderSizePixel = 0
    f:SetAttribute("Base", transparency)
    f.Parent = parent
    corner(f, radius)
    stroke(f, 0.78, 1)
    sheen(f, 0, 0.45)
    return f
end

local function makeText(parent, text, size, font, color, align)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Size = UDim2.fromScale(1, 1)
    l.Font = font or Enum.Font.GothamMedium
    l.TextSize = size or 13
    l.TextColor3 = color or C.text
    l.TextXAlignment = align or Enum.TextXAlignment.Center
    l.Text = text
    l.Parent = parent
    return l
end

local function isPress(input)
    return input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1
end

local function isMove(input, active)
    if input.UserInputType == Enum.UserInputType.Touch then
        return input == active
    end
    return input.UserInputType == Enum.UserInputType.MouseMovement
end

-- press squish + hover brighten
local function pressable(btn, bg)
    local scale = Instance.new("UIScale")
    scale.Parent = btn
    bg.ClipsDescendants = true
    btn.MouseEnter:Connect(function()
        tween(bg, 0.2, { BackgroundTransparency = math.max(bg:GetAttribute("Base") - 0.08, 0) })
    end)
    btn.MouseLeave:Connect(function()
        tween(bg, 0.3, { BackgroundTransparency = bg:GetAttribute("Base") })
    end)
    btn.InputBegan:Connect(function(input)
        if isPress(input) then
            tween(scale, 0.12, { Scale = 0.95 })
            -- ripple
            local rel = Vector2.new(input.Position.X, input.Position.Y) - bg.AbsolutePosition
            local r = Instance.new("Frame")
            r.AnchorPoint = Vector2.new(0.5, 0.5)
            r.Position = UDim2.fromOffset(rel.X, rel.Y)
            r.Size = UDim2.fromOffset(0, 0)
            r.BackgroundColor3 = C.white
            r.BackgroundTransparency = 0.7
            r.BorderSizePixel = 0
            r.Parent = bg
            corner(r, 200)
            local t = tween(r, 0.55, { Size = UDim2.fromOffset(190, 190), BackgroundTransparency = 1 })
            t.Completed:Connect(function() r:Destroy() end)
        end
    end)
    bind(UIS.InputEnded, function(input)
        if isPress(input) then
            tween(scale, 0.35, { Scale = 1 }, Enum.EasingStyle.Back)
        end
    end)
end

-- ========== GUI base ==========
local gui = Instance.new("ScreenGui")
gui.Name = "HollyScriptXv3"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

-- BillboardGuis/Highlights render reliably from Workspace (they may not under a ScreenGui)
local espFolder = Instance.new("Folder")
espFolder.Name = "HSX_ESP"
espFolder.Parent = Workspace

local tracerLayer = Instance.new("Frame")
tracerLayer.Name = "Tracers"
tracerLayer.Size = UDim2.fromScale(1, 1)
tracerLayer.BackgroundTransparency = 1
tracerLayer.Active = false
tracerLayer.Parent = gui

-- Toast notifications
local toastFrame = Instance.new("CanvasGroup")
toastFrame.Size = UDim2.fromOffset(210, 36)
toastFrame.AnchorPoint = Vector2.new(0.5, 0)
toastFrame.Position = UDim2.new(0.5, 0, 0, 10)
toastFrame.BackgroundTransparency = 1
toastFrame.GroupTransparency = 1
toastFrame.ZIndex = 10
toastFrame.Parent = gui
do
    local bg = surface(toastFrame, 18, 0.35, C.tint)
    onTheme(function() bg.BackgroundColor3 = C.tint end)
end
local toastLabel = makeText(toastFrame, "", 13, Enum.Font.GothamSemibold)
local toastToken = 0

local function toast(msg)
    if not state.toasts then return end
    toastToken += 1
    local mine = toastToken
    toastLabel.Text = msg
    tween(toastFrame, 0.4, { Position = UDim2.new(0.5, 0, 0, 40), GroupTransparency = 0 },
        Enum.EasingStyle.Back)
    task.delay(1.6, function()
        if mine == toastToken and toastFrame.Parent then
            tween(toastFrame, 0.3, { Position = UDim2.new(0.5, 0, 0, 10), GroupTransparency = 1 })
        end
    end)
end

-- Panel (CanvasGroup lets the whole thing fade as one piece)
local viewport = (Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize)
    or Vector2.new(800, 450)
local PANEL_H = math.clamp(viewport.Y - 70, 260, 440)
local PANEL_W = math.clamp(math.floor(PANEL_H * 0.95), 290, math.max(290, viewport.X - 20))

local panel = Instance.new("CanvasGroup")
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Size = UDim2.fromOffset(PANEL_W, PANEL_H)
panel.Position = UDim2.new(0, 10 + PANEL_W / 2, 0, 36 + PANEL_H / 2)
panel.BackgroundColor3 = C.tint
panel.BackgroundTransparency = 0.38
panel.BorderSizePixel = 0
panel.GroupTransparency = 1
panel.Parent = gui
corner(panel, 24)
onTheme(function() tween(panel, 0.5, { BackgroundColor3 = C.tint }) end)

local panelScale = Instance.new("UIScale")
panelScale.Scale = 0.88
panelScale.Parent = panel

-- Slow drifting color blobs behind the content = "liquid" feel
local fxObjects = {}
local function blob(size, color, transparency, from, to, time)
    local b = Instance.new("Frame")
    b.Size = UDim2.fromOffset(size, size)
    b.Position = from
    onTheme(function() b.BackgroundColor3 = C[color] end)
    b.BackgroundTransparency = transparency
    b.BorderSizePixel = 0
    b.Parent = panel
    corner(b, size)
    table.insert(fxObjects, b)
    loopTween(b, time, { Position = to })
end
blob(230, "accent", 0.80, UDim2.fromOffset(-70, -50), UDim2.fromOffset(60, 110), 9)
blob(210, "accent2", 0.84, UDim2.fromOffset(150, 250), UDim2.fromOffset(40, 150), 11)
blob(170, "on", 0.88, UDim2.fromOffset(160, 40), UDim2.fromOffset(70, 290), 13)

-- Top specular highlight
do
    local hl = Instance.new("Frame")
    hl.Size = UDim2.new(1, 0, 0, 120)
    hl.BackgroundColor3 = C.white
    hl.BackgroundTransparency = 0.9
    hl.BorderSizePixel = 0
    hl.Parent = panel
    sheen(hl, 0.55, 1)
end

-- Light sweep that glides across the glass every few seconds
do
    local sweep = Instance.new("Frame")
    sweep.AnchorPoint = Vector2.new(0.5, 0.5)
    sweep.Size = UDim2.fromOffset(70, PANEL_H * 1.8)
    sweep.Rotation = 18
    sweep.Position = UDim2.fromOffset(-140, PANEL_H / 2)
    sweep.BackgroundColor3 = C.white
    sweep.BackgroundTransparency = 0.9
    sweep.BorderSizePixel = 0
    sweep.ZIndex = 5
    sweep.Parent = panel
    table.insert(fxObjects, sweep)
    local g = Instance.new("UIGradient")
    g.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1),
    })
    g.Parent = sweep
    task.spawn(function()
        while sweep.Parent do
            sweep.Position = UDim2.fromOffset(-140, PANEL_H / 2)
            local t = tween(sweep, 1.8, { Position = UDim2.fromOffset(PANEL_W + 140, PANEL_H / 2) },
                Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            t.Completed:Wait()
            task.wait(5)
        end
    end)
end

-- Soft glow that follows the finger / cursor inside the panel
do
    local glow = Instance.new("Frame")
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.Size = UDim2.fromOffset(150, 150)
    glow.BackgroundColor3 = C.white
    glow.BackgroundTransparency = 1
    glow.BorderSizePixel = 0
    glow.Parent = panel
    table.insert(fxObjects, glow)
    corner(glow, 150)

    bind(UIS.InputChanged, function(input)
        local t = input.UserInputType
        if t ~= Enum.UserInputType.MouseMovement and t ~= Enum.UserInputType.Touch then return end
        local pos = (Vector2.new(input.Position.X, input.Position.Y) - panel.AbsolutePosition)
            / math.max(panelScale.Scale, 0.01)
        if pos.X >= 0 and pos.Y >= 0 and pos.X <= PANEL_W and pos.Y <= PANEL_H then
            tween(glow, 0.25, { Position = UDim2.fromOffset(pos.X, pos.Y), BackgroundTransparency = 0.93 })
        else
            tween(glow, 0.4, { BackgroundTransparency = 1 })
        end
    end)
    bind(UIS.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            tween(glow, 0.5, { BackgroundTransparency = 1 })
        end
    end)
end

-- Border with a slowly rotating shimmer
do
    local border = Instance.new("Frame")
    border.Size = UDim2.fromScale(1, 1)
    border.BackgroundTransparency = 1
    border.Parent = panel
    corner(border, 24)
    local s = stroke(border, 0, 1.5)
    local g = Instance.new("UIGradient")
    g.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.15),
        NumberSequenceKeypoint.new(0.3, 0.85),
        NumberSequenceKeypoint.new(0.7, 0.85),
        NumberSequenceKeypoint.new(1, 0.15),
    })
    g.Parent = s
    TweenService:Create(g,
        TweenInfo.new(7, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
        { Rotation = 360 }):Play()
end

-- Reopen pill (shown when the panel is collapsed)
local reopen = Instance.new("TextButton")
reopen.AnchorPoint = Vector2.new(0.5, 0.5)
reopen.Size = UDim2.fromOffset(120, 40)
reopen.BackgroundTransparency = 1
reopen.Text = ""
reopen.AutoButtonColor = false
reopen.Visible = false
reopen.Parent = gui
local reopenScale = Instance.new("UIScale")
reopenScale.Scale = 0
reopenScale.Parent = reopen
do
    local bg = surface(reopen, 20, 0.5, C.tint)
    onTheme(function() bg.BackgroundColor3 = C.tint end)
end
makeText(reopen, "HOLLYSCRIPTX", 12, Enum.Font.GothamBold)

local panelOpen = true
local uiScale = 1
local function setPanelOpen(open)
    panelOpen = open
    if open then
        panel.Visible = true
        tween(panelScale, 0.5, { Scale = uiScale }, Enum.EasingStyle.Back)
        tween(panel, 0.35, { GroupTransparency = 0 })
        tween(reopenScale, 0.2, { Scale = 0 })
        task.delay(0.22, function()
            if panelOpen then reopen.Visible = false end
        end)
    else
        local p = panel.Position
        reopen.Position = UDim2.new(p.X.Scale, p.X.Offset - PANEL_W / 2 + 60,
            p.Y.Scale, p.Y.Offset - PANEL_H / 2 + 20)
        reopen.Visible = true
        tween(reopenScale, 0.5, { Scale = 1 }, Enum.EasingStyle.Back)
        tween(panelScale, 0.28, { Scale = uiScale * 0.88 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        tween(panel, 0.28, { GroupTransparency = 1 })
        task.delay(0.3, function()
            if not panelOpen then panel.Visible = false end
        end)
    end
end
reopen.Activated:Connect(function() setPanelOpen(true) end)

-- Hotkey (PC): RightShift shows/hides the panel
bind(UIS.InputBegan, function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        setPanelOpen(not panelOpen)
    end
end)

-- Header: draggable area, pulsing dot, title, collapse button
local header = Instance.new("TextButton")
header.Size = UDim2.new(1, -56, 0, 44)
header.BackgroundTransparency = 1
header.Text = ""
header.AutoButtonColor = false
header.Parent = panel

do
    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(8, 8)
    dot.Position = UDim2.fromOffset(18, 18)
    onTheme(function() dot.BackgroundColor3 = C.accent end)
    dot.BackgroundTransparency = 0.1
    dot.BorderSizePixel = 0
    dot.Parent = header
    corner(dot, 4)
    loopTween(dot, 1.2, { BackgroundTransparency = 0.75 })

    local title = makeText(header, 'HollyScriptX  <font size="11" color="rgb(150,170,210)">glass v8</font>',
        15, Enum.Font.GothamBold, C.text, Enum.TextXAlignment.Left)
    title.RichText = true
    title.Position = UDim2.fromOffset(34, 0)
    title.Size = UDim2.new(1, -34, 1, 0)
    do
        local tg = Instance.new("UIGradient")
        tg.Offset = Vector2.new(-1, 0)
        tg.Parent = title
        onTheme(function()
            tg.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, C.white),
                ColorSequenceKeypoint.new(0.5, C.accent),
                ColorSequenceKeypoint.new(1, C.white),
            })
        end)
        TweenService:Create(tg,
            TweenInfo.new(3.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
            { Offset = Vector2.new(1, 0) }):Play()
    end

    local active, dragStart, startPos
    header.InputBegan:Connect(function(input)
        if isPress(input) then
            active = input
            dragStart = input.Position
            startPos = panel.Position
        end
    end)
    bind(UIS.InputChanged, function(input)
        if active and isMove(input, active) then
            local d = input.Position - dragStart
            local camera = Workspace.CurrentCamera
            local vp = camera and camera.ViewportSize or Vector2.new(800, 450)
            panel.Position = UDim2.new(
                startPos.X.Scale, math.clamp(startPos.X.Offset + d.X, 40, vp.X - 40),
                startPos.Y.Scale, math.clamp(startPos.Y.Offset + d.Y, 40, vp.Y - 40))
        end
    end)
    bind(UIS.InputEnded, function(input)
        if input == active then
            active = nil
        end
    end)
end

do
    local mini = Instance.new("TextButton")
    mini.Size = UDim2.fromOffset(28, 28)
    mini.AnchorPoint = Vector2.new(0.5, 0.5)
    mini.Position = UDim2.new(1, -28, 0, 22)
    mini.BackgroundTransparency = 1
    mini.Text = ""
    mini.AutoButtonColor = false
    mini.Parent = panel
    local bg = surface(mini, 14, 0.85)
    makeText(mini, "-", 18, Enum.Font.GothamBold)
    pressable(mini, bg)
    mini.Activated:Connect(function() setPanelOpen(false) end)
end

-- ========== Tabs + pages ==========
local TAB_ORDER = { "MOVE", "VIEW", "ESP", "TOOLS", "USERS", "AI", "MISC" }
local TAB_W = 58
local HOLDER_POS = UDim2.fromOffset(10, 90)
local holders, pages, tabButtons = {}, {}, {}

local tabBar = Instance.new("Frame")
tabBar.Position = UDim2.fromOffset(10, 48)
tabBar.Size = UDim2.new(1, -20, 0, 34)
tabBar.BackgroundTransparency = 1
tabBar.Parent = panel
surface(tabBar, 17, 0.9)

local tabScroller = Instance.new("ScrollingFrame")
tabScroller.Size = UDim2.fromScale(1, 1)
tabScroller.BackgroundTransparency = 1
tabScroller.BorderSizePixel = 0
tabScroller.ScrollBarThickness = 0
tabScroller.ScrollingDirection = Enum.ScrollingDirection.X
tabScroller.CanvasSize = UDim2.fromOffset(8 + #TAB_ORDER * TAB_W, 0)
tabScroller.Parent = tabBar

local pill = Instance.new("Frame")
pill.Size = UDim2.fromOffset(TAB_W, 26)
pill.Position = UDim2.fromOffset(4, 4)
pill.BackgroundColor3 = C.white
pill.BackgroundTransparency = 0.72
pill.BorderSizePixel = 0
pill.Parent = tabScroller
corner(pill, 13)
stroke(pill, 0.6, 1)
sheen(pill, 0, 0.4)

for i, name in ipairs(TAB_ORDER) do
    local b = Instance.new("TextButton")
    b.Position = UDim2.fromOffset(4 + (i - 1) * TAB_W, 4)
    b.Size = UDim2.fromOffset(TAB_W, 26)
    b.BackgroundTransparency = 1
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.TextColor3 = C.sub
    b.Text = name
    b.AutoButtonColor = false
    b.Parent = tabScroller
    tabButtons[name] = b

    local holder = Instance.new("CanvasGroup")
    holder.Position = HOLDER_POS
    holder.Size = UDim2.new(1, -20, 1, -100)
    holder.BackgroundTransparency = 1
    holder.Visible = false
    holder.Parent = panel
    holders[name] = holder

    local sf = Instance.new("ScrollingFrame")
    sf.Size = UDim2.fromScale(1, 1)
    sf.BackgroundTransparency = 1
    sf.BorderSizePixel = 0
    sf.ScrollBarThickness = 3
    onTheme(function() sf.ScrollBarImageColor3 = C.accent end)
    sf.CanvasSize = UDim2.new()
    sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sf.Parent = holder
    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 7)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = sf
    pages[name] = sf
end

local function showPage(name, instant)
    local index = 1
    for i, n in ipairs(TAB_ORDER) do
        local active = (n == name)
        if active then index = i end
        tween(tabButtons[n], 0.25, { TextColor3 = active and C.text or C.sub })
        local holder = holders[n]
        if active then
            holder.Visible = true
            if instant then
                holder.GroupTransparency = 0
                holder.Position = HOLDER_POS
            else
                holder.GroupTransparency = 1
                holder.Position = HOLDER_POS + UDim2.fromOffset(18, 0)
                tween(holder, 0.35, { GroupTransparency = 0, Position = HOLDER_POS })
            end
        else
            holder.Visible = false
        end
    end
    tween(pill, 0.45, { Position = UDim2.fromOffset(4 + (index - 1) * TAB_W, 4) },
        Enum.EasingStyle.Back)
    tween(tabScroller, 0.4, { CanvasPosition = Vector2.new(math.max(0, 4 + (index - 1) * TAB_W - 90), 0) })
end

for _, name in ipairs(TAB_ORDER) do
    tabButtons[name].Activated:Connect(function() showPage(name) end)
end

-- ========== Widgets ==========
local toggleRefs = {}
local sliderSetters = {}
local sliderValues = {}

local function glassButton(parent, text, height, tintColor)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -6, 0, height)
    holder.BackgroundTransparency = 1
    holder.Parent = parent
    local btn = Instance.new("TextButton")
    btn.AnchorPoint = Vector2.new(0.5, 0.5)
    btn.Position = UDim2.fromScale(0.5, 0.5)
    btn.Size = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = holder
    local bg = surface(btn, 14, 0.88, tintColor)
    local lbl = makeText(btn, text)
    pressable(btn, bg)
    return btn, lbl, bg
end

local function createToggle(page, labelText, key, onChange)
    local btn, lbl, bg = glassButton(page, labelText, 40)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Position = UDim2.fromOffset(16, 0)
    lbl.Size = UDim2.new(1, -80, 1, 0)

    local pillSwitch = Instance.new("Frame")
    pillSwitch.AnchorPoint = Vector2.new(1, 0.5)
    pillSwitch.Position = UDim2.new(1, -12, 0.5, 0)
    pillSwitch.Size = UDim2.fromOffset(42, 22)
    pillSwitch.BorderSizePixel = 0
    pillSwitch.Parent = btn
    corner(pillSwitch, 11)
    stroke(pillSwitch, 0.7, 1)

    local knob = Instance.new("Frame")
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Size = UDim2.fromOffset(18, 18)
    knob.BackgroundColor3 = C.white
    knob.BorderSizePixel = 0
    knob.Parent = pillSwitch
    corner(knob, 9)

    local function paint(animate)
        local on = state[key]
        local t = animate and 0.3 or 0
        tween(pillSwitch, t, {
            BackgroundColor3 = on and C.on or C.white,
            BackgroundTransparency = on and 0.15 or 0.8,
        })
        tween(knob, t, { Position = on and UDim2.new(1, -11, 0.5, 0) or UDim2.new(0, 11, 0.5, 0) },
            Enum.EasingStyle.Back)
        local base = on and 0.78 or 0.88
        bg:SetAttribute("Base", base)
        tween(bg, t, {
            BackgroundColor3 = on and C.on or C.white,
            BackgroundTransparency = base,
        })
        tween(lbl, t, { TextColor3 = on and C.text or C.sub })
    end

    toggleRefs[key] = function() paint(true) end
    table.insert(themeCallbacks, function() paint(false) end)
    btn.Activated:Connect(function()
        state[key] = not state[key]
        paint(true)
        toast(labelText .. (state[key] and "  ON" or "  OFF"))
        if onChange then onChange(state[key]) end
    end)
    paint(false)
    return btn
end

local function createSlider(page, title, min, max, default, step, onChange)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -6, 0, 58)
    row.BackgroundTransparency = 1
    row.Parent = page
    surface(row, 14, 0.88)

    local titleLabel = makeText(row, title, 13, Enum.Font.GothamMedium, C.sub, Enum.TextXAlignment.Left)
    titleLabel.Position = UDim2.fromOffset(16, 6)
    titleLabel.Size = UDim2.new(0.6, 0, 0, 20)

    local valueLabel = makeText(row, "", 13, Enum.Font.GothamBold, C.accent, Enum.TextXAlignment.Right)
    onTheme(function() valueLabel.TextColor3 = C.accent end)
    valueLabel.Position = UDim2.new(0.6, 0, 0, 6)
    valueLabel.Size = UDim2.new(0.4, -16, 0, 20)

    local hit = Instance.new("TextButton")
    hit.Position = UDim2.fromOffset(0, 26)
    hit.Size = UDim2.new(1, 0, 1, -26)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.AutoButtonColor = false
    hit.Parent = row

    local track = Instance.new("Frame")
    track.Position = UDim2.new(0, 26, 0.5, -3)
    track.Size = UDim2.new(1, -52, 0, 6)
    track.BackgroundColor3 = C.white
    track.BackgroundTransparency = 0.8
    track.BorderSizePixel = 0
    track.Parent = hit
    corner(track, 3)

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = C.white
    fill.BorderSizePixel = 0
    fill.Parent = track
    corner(fill, 3)
    local fg = Instance.new("UIGradient")
    onTheme(function() fg.Color = ColorSequence.new(C.accent, C.accent2) end)
    fg.Parent = fill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(20, 20)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.BackgroundColor3 = C.white
    knob.BorderSizePixel = 0
    knob.Parent = track
    corner(knob, 10)
    local knobStroke = stroke(knob, 0.5, 1.5)
    onTheme(function() knobStroke.Color = C.accent end)

    local function set(value, byUser)
        value = math.clamp(math.floor(value / step + 0.5) * step, min, max)
        value = tonumber(string.format("%.2f", value))
        local alpha = (value - min) / (max - min)
        valueLabel.Text = tostring(value)
        sliderValues[title] = value
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        knob.Position = UDim2.new(alpha, 0, 0.5, 0)
        onChange(value, byUser)
    end

    local function fromX(x)
        local alpha = math.clamp(
            (x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
        set(min + alpha * (max - min), true)
    end

    local active
    hit.InputBegan:Connect(function(input)
        if isPress(input) then
            active = input
            page.ScrollingEnabled = false -- don't scroll the page while dragging
            tween(knob, 0.2, { Size = UDim2.fromOffset(27, 27) }, Enum.EasingStyle.Back)
            fromX(input.Position.X)
        end
    end)
    bind(UIS.InputChanged, function(input)
        if active and isMove(input, active) then
            fromX(input.Position.X)
        end
    end)
    bind(UIS.InputEnded, function(input)
        if input == active then
            active = nil
            page.ScrollingEnabled = true
            tween(knob, 0.3, { Size = UDim2.fromOffset(20, 20) }, Enum.EasingStyle.Back)
        end
    end)

    set(default, false)
    sliderSetters[title] = set
    return set
end

local function createHeader(page, text)
    local l = makeText(page, text, 11, Enum.Font.GothamBold, C.accent, Enum.TextXAlignment.Left)
    onTheme(function() l.TextColor3 = C.accent end)
    l.Size = UDim2.new(1, -6, 0, 18)
    l.Position = UDim2.fromOffset(6, 0)
end

-- ========== Character helpers ==========
local function getHumanoid()
    local c = player.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function getRoot()
    local c = player.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local humDefaults = nil

local function applyHumanoid()
    local hum = getHumanoid()
    if not hum then return end
    if custom.walk then
        hum.WalkSpeed = state.walk
    end
    if custom.jump then
        hum.UseJumpPower = false -- otherwise JumpHeight is ignored
        hum.JumpHeight = state.jumpHeight
    end
end

-- ========== Fly buttons (glass circles with pop animation) ==========
local flyShown = false

local function makeFlyButton(text, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(64, 64)
    btn.AnchorPoint = Vector2.new(1, 0)
    btn.Position = pos
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Visible = false
    btn.Parent = gui
    local sc = Instance.new("UIScale")
    sc.Scale = 0
    sc.Parent = btn
    do
        local bg = surface(btn, 32, 0.55, C.tint)
        onTheme(function() bg.BackgroundColor3 = C.tint end)
    end
    makeText(btn, text, 13, Enum.Font.GothamBold)
    return btn, sc
end

local upButton, upScale = makeFlyButton("UP", UDim2.new(1, -20, 0.5, -76))
local downButton, downScale = makeFlyButton("DOWN", UDim2.new(1, -20, 0.5, 4))

local function holdButton(button, scale, key)
    local active
    button.InputBegan:Connect(function(input)
        if isPress(input) then
            active = input
            state[key] = true
            tween(scale, 0.12, { Scale = 0.9 })
        end
    end)
    -- global release: finger sliding off the button still releases it
    bind(UIS.InputEnded, function(input)
        if input == active then
            active = nil
            state[key] = false
            if flyShown then
                tween(scale, 0.35, { Scale = 1 }, Enum.EasingStyle.Back)
            end
        end
    end)
end
holdButton(upButton, upScale, "up")
holdButton(downButton, downScale, "down")

local function showFlyButtons(show)
    flyShown = show
    for _, pair in ipairs({ { upButton, upScale }, { downButton, downScale } }) do
        local btn, sc = pair[1], pair[2]
        if show then
            btn.Visible = true
            tween(sc, 0.5, { Scale = 1 }, Enum.EasingStyle.Back)
        else
            tween(sc, 0.25, { Scale = 0 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            task.delay(0.27, function()
                if not flyShown then btn.Visible = false end
            end)
        end
    end
end

local function setFly(enabled)
    state.flying = enabled
    local hum, root = getHumanoid(), getRoot()
    if hum then
        hum.PlatformStand = enabled
        if not enabled and hum.Health > 0 then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
    if not enabled then
        state.up = false
        state.down = false
        if root then
            root.AssemblyLinearVelocity = Vector3.zero
        end
    end
    showFlyButtons(enabled)
    if toggleRefs.flying then toggleRefs.flying() end
end

-- ========== Noclip ==========
local partList = {}
local noclipTouched = setmetatable({}, { __mode = "k" })
local charConns = {}

local function trackCharacter(character)
    for _, c in ipairs(charConns) do c:Disconnect() end
    table.clear(charConns)
    partList = {}
    table.clear(noclipTouched)
    for _, d in ipairs(character:GetDescendants()) do
        if d:IsA("BasePart") then table.insert(partList, d) end
    end
    table.insert(charConns, character.DescendantAdded:Connect(function(d)
        if d:IsA("BasePart") then table.insert(partList, d) end
    end))
end

local function restoreNoclip()
    for part in pairs(noclipTouched) do
        if part.Parent then part.CanCollide = true end
    end
    table.clear(noclipTouched)
end

bind(RunService.Stepped, function()
    if state.noclip then
        for _, part in ipairs(partList) do
            if part.Parent and part.CanCollide then
                noclipTouched[part] = true
                part.CanCollide = false
            end
        end
    elseif next(noclipTouched) ~= nil then
        restoreNoclip()
    end
end)

-- Infinite jump
bind(UIS.JumpRequest, function()
    if not state.infJump then return end
    local hum = getHumanoid()
    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- ========== Lighting overrides (fullbright / no fog / time lock) ==========
local overrides = {}     -- feature -> { Property = value }
local origLighting = {}  -- Property -> original value

local function setOverride(feature, props)
    if props then
        for prop in pairs(props) do
            if origLighting[prop] == nil then
                origLighting[prop] = Lighting[prop]
            end
        end
        overrides[feature] = props
    else
        overrides[feature] = nil
        for prop, orig in pairs(origLighting) do
            local still = false
            for _, p in pairs(overrides) do
                if p[prop] ~= nil then still = true break end
            end
            if not still then
                Lighting[prop] = orig
                origLighting[prop] = nil
            end
        end
    end
end

local function enforceLighting()
    for _, props in pairs(overrides) do
        for prop, value in pairs(props) do
            if Lighting[prop] ~= value then
                Lighting[prop] = value
            end
        end
    end
end

local function updateFullbright()
    if state.fullbright then
        setOverride("fullbright", {
            Brightness = 2,
            GlobalShadows = false,
            Ambient = Color3.fromRGB(178, 178, 178),
            OutdoorAmbient = Color3.fromRGB(178, 178, 178),
        })
    else
        setOverride("fullbright", nil)
    end
end

local function updateNoFog()
    if state.noFog then
        setOverride("nofog", { FogEnd = 1e6, FogStart = 1e6 - 1 })
    else
        setOverride("nofog", nil)
    end
end

local function updateClock()
    if state.clockOn then
        setOverride("clock", { ClockTime = state.clock })
    else
        setOverride("clock", nil)
    end
end

-- ========== Shaders (post-processing presets) ==========
local PRESETS = {
    Vivid = {
        { "ColorCorrectionEffect", { Saturation = 0.35, Contrast = 0.15, Brightness = 0.02,
            TintColor = Color3.fromRGB(255, 248, 240) } },
        { "BloomEffect", { Intensity = 0.5, Size = 30, Threshold = 1 } },
        { "SunRaysEffect", { Intensity = 0.15, Spread = 0.8 } },
    },
    Cinematic = {
        { "ColorCorrectionEffect", { Saturation = -0.1, Contrast = 0.25, Brightness = -0.03,
            TintColor = Color3.fromRGB(255, 235, 215) } },
        { "BloomEffect", { Intensity = 0.35, Size = 40, Threshold = 0.9 } },
        { "DepthOfFieldEffect", { FarIntensity = 0.2, FocusDistance = 70,
            InFocusRadius = 50, NearIntensity = 0 } },
    },
    Sunset = {
        { "ColorCorrectionEffect", { Saturation = 0.25, Contrast = 0.1, Brightness = 0,
            TintColor = Color3.fromRGB(255, 200, 160) } },
        { "BloomEffect", { Intensity = 0.6, Size = 36, Threshold = 0.8 } },
        { "SunRaysEffect", { Intensity = 0.25, Spread = 0.9 } },
    },
    Night = {
        { "ColorCorrectionEffect", { Saturation = -0.15, Contrast = 0.1, Brightness = -0.08,
            TintColor = Color3.fromRGB(150, 175, 255) } },
        { "BloomEffect", { Intensity = 0.4, Size = 30, Threshold = 1 } },
    },
    Retro = {
        { "ColorCorrectionEffect", { Saturation = -0.55, Contrast = 0.3, Brightness = 0,
            TintColor = Color3.fromRGB(235, 225, 185) } },
        { "BloomEffect", { Intensity = 0.2, Size = 20, Threshold = 1 } },
    },
}
local SHADER_ORDER = { "Off", "Vivid", "Cinematic", "Sunset", "Night", "Retro" }

local function clearShaders()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child.Name:sub(1, 4) == "HSX_" then child:Destroy() end
    end
end

local function applyShader(name)
    clearShaders()
    local preset = PRESETS[name]
    if not preset then return end
    for _, def in ipairs(preset) do
        local inst = Instance.new(def[1])
        inst.Name = "HSX_" .. def[1]
        for prop, value in pairs(def[2]) do
            pcall(function() inst[prop] = value end)
        end
        inst.Parent = Lighting
    end
end

-- World blur (optional; the 3D scene only, UI stays sharp)
local blurEffect = nil
local function updateBlur()
    if state.blur then
        if not blurEffect then
            blurEffect = Instance.new("BlurEffect")
            blurEffect.Name = "HSXGlassBlur"
            blurEffect.Size = 0
            blurEffect.Parent = Lighting
        end
        tween(blurEffect, 0.6, { Size = 14 })
    elseif blurEffect then
        local b = blurEffect
        blurEffect = nil
        tween(b, 0.4, { Size = 0 }).Completed:Connect(function() b:Destroy() end)
    end
end

-- ========== FOV ==========
local originalFov = nil

RunService:BindToRenderStep("HSX_FOV", Enum.RenderPriority.Camera.Value + 1, function()
    local camera = Workspace.CurrentCamera
    if not camera then return end
    if state.fovOn then
        if originalFov == nil then originalFov = camera.FieldOfView end
        if camera.FieldOfView ~= state.fov then
            camera.FieldOfView = state.fov
        end
    elseif originalFov ~= nil then
        camera.FieldOfView = originalFov
        originalFov = nil
    end
end)

-- ========== ESP ==========
local espObjects = {}
local espStatusLabel = nil
local npcCache = {}
local npcLastScan = 0

local function scanNpcs()
    table.clear(npcCache)
    for _, d in ipairs(Workspace:GetDescendants()) do
        if d:IsA("Humanoid") then
            local model = d.Parent
            if model and model:IsA("Model") and model ~= player.Character
                and not Players:GetPlayerFromCharacter(model) then
                table.insert(npcCache, model)
            end
        end
    end
end

local function removeEsp(key)
    local o = espObjects[key]
    if o then
        o.highlight:Destroy()
        o.box:Destroy()
        o.info:Destroy()
        o.tracer:Destroy()
        espObjects[key] = nil
    end
end

local function createEsp(key, character, root)
    local highlight = Instance.new("Highlight")
    highlight.Name = "HSX_Highlight"
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.OutlineTransparency = 0
    highlight.Adornee = character
    highlight.Parent = espFolder

    -- rounded-square box (size is in studs because the scale part is used)
    local box = Instance.new("BillboardGui")
    box.Name = "HSX_Box"
    box.Size = UDim2.fromScale(4.6, 6.4)
    box.AlwaysOnTop = true
    box.LightInfluence = 0
    box.Adornee = root
    box.Parent = espFolder

    local boxFrame = Instance.new("Frame")
    boxFrame.Size = UDim2.fromScale(1, 1)
    boxFrame.BackgroundTransparency = 1
    boxFrame.BorderSizePixel = 0
    boxFrame.Parent = box
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0.22 * roundness, 0)
    boxCorner.Parent = boxFrame
    local boxStroke = Instance.new("UIStroke")
    boxStroke.Thickness = 2
    boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    boxStroke.Parent = boxFrame

    local barBg = Instance.new("Frame")
    barBg.AnchorPoint = Vector2.new(1, 0)
    barBg.Position = UDim2.new(0, -5, 0, 0)
    barBg.Size = UDim2.new(0, 4, 1, 0)
    barBg.BackgroundColor3 = Color3.new(0, 0, 0)
    barBg.BackgroundTransparency = 0.4
    barBg.BorderSizePixel = 0
    barBg.Parent = boxFrame
    local barFill = Instance.new("Frame")
    barFill.AnchorPoint = Vector2.new(0, 1)
    barFill.Position = UDim2.fromScale(0, 1)
    barFill.Size = UDim2.fromScale(1, 1)
    barFill.BorderSizePixel = 0
    barFill.Parent = barBg

    local info = Instance.new("BillboardGui")
    info.Name = "HSX_Info"
    info.Size = UDim2.fromOffset(180, 40)
    info.StudsOffset = Vector3.new(0, 4.4, 0)
    info.AlwaysOnTop = true
    info.LightInfluence = 0
    info.Adornee = root
    info.Parent = espFolder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 13
    label.TextColor3 = C.text
    label.TextStrokeTransparency = 0.4
    label.Parent = info

    local tracer = Instance.new("Frame")
    tracer.AnchorPoint = Vector2.new(0.5, 0.5)
    tracer.BorderSizePixel = 0
    tracer.Visible = false
    tracer.Parent = tracerLayer

    local o = {
        character = character, root = root, baseColor = C.white,
        highlight = highlight, box = box, boxCorner = boxCorner, boxStroke = boxStroke,
        barBg = barBg, barFill = barFill, info = info, label = label, tracer = tracer,
    }
    espObjects[key] = o
    return o
end

local function updateEsp()
    local camera = Workspace.CurrentCamera
    if not state.esp or not camera then
        for key in pairs(espObjects) do removeEsp(key) end
        if espStatusLabel then espStatusLabel.Text = "ESP is off" end
        return
    end

    if state.espNpc then
        if os.clock() - npcLastScan > 2 then
            npcLastScan = os.clock()
            scanNpcs()
        end
    elseif #npcCache > 0 then
        table.clear(npcCache)
    end

    local targets = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            table.insert(targets, { key = plr, character = plr.Character,
                name = plr.DisplayName, plr = plr })
        end
    end
    for _, model in ipairs(npcCache) do
        if model.Parent then
            table.insert(targets, { key = model, character = model, name = model.Name })
        end
    end

    local seen = {}
    for _, t in ipairs(targets) do
        local character = t.character
        local root = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart
        local hum = character:FindFirstChildOfClass("Humanoid")
        local skip = not (root and hum) or hum.Health <= 0

        if not skip and t.plr and state.espTeam and t.plr.Team ~= nil
            and t.plr.Team == player.Team then
            skip = true
        end

        local dist = 0
        if not skip then
            dist = (root.Position - camera.CFrame.Position).Magnitude
            if dist > state.espRange then skip = true end
        end

        if not skip then
            seen[t.key] = true
            local o = espObjects[t.key]
            if o and (o.character ~= character or o.root ~= root) then
                removeEsp(t.key)
                o = nil
            end
            if not o then o = createEsp(t.key, character, root) end

            local color
            if t.plr then
                color = t.plr.Team and t.plr.TeamColor.Color or Color3.fromRGB(255, 80, 80)
            else
                color = Color3.fromRGB(255, 200, 80) -- NPCs
            end
            o.baseColor = color

            o.highlight.Enabled = state.espChams
            o.highlight.FillTransparency = state.espFill
            o.highlight.FillColor = color
            o.highlight.OutlineColor = color

            o.box.Enabled = state.espBox
            o.boxStroke.Color = color
            o.boxCorner.CornerRadius = UDim.new(0.22 * roundness, 0)

            local ratio = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
            o.barBg.Visible = state.espHealthBar
            o.barFill.Size = UDim2.fromScale(1, ratio)
            o.barFill.BackgroundColor3 =
                Color3.fromRGB(255, 60, 60):Lerp(Color3.fromRGB(60, 255, 120), ratio)

            local lines = {}
            if state.espName then table.insert(lines, t.name) end
            local parts = {}
            if state.espDist then table.insert(parts, math.floor(dist) .. " studs") end
            if state.espHealth then
                table.insert(parts, "HP " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth))
            end
            if #parts > 0 then table.insert(lines, table.concat(parts, "  |  ")) end
            o.label.Text = table.concat(lines, "\n")
            o.info.Enabled = #lines > 0
        end
    end

    local count = 0
    for key in pairs(espObjects) do
        if seen[key] then
            count += 1
        else
            removeEsp(key)
        end
    end
    if espStatusLabel then
        espStatusLabel.Text = "Tracking: " .. count .. (count == 0 and "  (no targets - try NPCs)" or "")
    end
end

-- Per-frame part: tracers + rainbow
bind(RunService.RenderStepped, function()
    local camera = Workspace.CurrentCamera
    if not camera or next(espObjects) == nil then return end
    local vp = camera.ViewportSize
    local rainbow = Color3.fromHSV((os.clock() * 0.15) % 1, 0.75, 1)

    for _, o in pairs(espObjects) do
        local color = state.espRainbow and rainbow or o.baseColor
        if state.espRainbow then
            o.highlight.FillColor = color
            o.highlight.OutlineColor = color
            o.boxStroke.Color = color
        end

        local tracer = o.tracer
        local visible = false
        if state.espTracers and o.root.Parent then
            local p, onScreen = camera:WorldToViewportPoint(o.root.Position)
            if onScreen and p.Z > 0 then
                local from = Vector2.new(vp.X / 2, vp.Y)
                local to = Vector2.new(p.X, p.Y)
                local delta = to - from
                tracer.BackgroundColor3 = color
                tracer.Size = UDim2.fromOffset(delta.Magnitude, 2)
                tracer.Position = UDim2.fromOffset((from.X + to.X) / 2, (from.Y + to.Y) / 2)
                tracer.Rotation = math.deg(math.atan2(delta.Y, delta.X))
                visible = true
            end
        end
        tracer.Visible = visible
    end
end)

bind(Players.PlayerRemoving, removeEsp)

-- ========== Main loop ==========
local espTimer = 0

bind(RunService.Heartbeat, function(dt)
    dt = math.min(dt, 0.1)

    if next(overrides) ~= nil then
        enforceLighting()
    end

    espTimer += dt
    if espTimer >= 0.15 then
        espTimer = 0
        updateEsp()
    end

    if not state.flying then return end
    local character = player.Character
    local hum = getHumanoid()
    local root = getRoot()
    if not character or not hum or not root or hum.Health <= 0 then return end

    if not hum.PlatformStand then hum.PlatformStand = true end

    local camera = Workspace.CurrentCamera
    local dir = hum.MoveDirection
    local vertical = 0
    if dir.Magnitude > 0 and camera then
        vertical = camera.CFrame.LookVector.Y
    end
    local goUp = state.up or UIS:IsKeyDown(Enum.KeyCode.E)
    local goDown = state.down or UIS:IsKeyDown(Enum.KeyCode.Q)
    if goUp then
        vertical = 1
    elseif goDown then
        vertical = -1
    end

    if dir.Magnitude == 0 and not goUp and not goDown then
        root.AssemblyLinearVelocity = Vector3.zero -- hover
        return
    end

    root.AssemblyLinearVelocity = Vector3.new(
        dir.X * state.flySpeed,
        vertical * state.flySpeed,
        dir.Z * state.flySpeed)
end)

-- ========== Stats overlay (FPS / ping) ==========
local statsFrame = Instance.new("CanvasGroup")
statsFrame.AnchorPoint = Vector2.new(1, 0)
statsFrame.Position = UDim2.new(1, -14, 0, 10)
statsFrame.Size = UDim2.fromOffset(150, 30)
statsFrame.BackgroundTransparency = 1
statsFrame.GroupTransparency = 1
statsFrame.Visible = false
statsFrame.Parent = gui
do
    local bg = surface(statsFrame, 15, 0.45, C.tint)
    onTheme(function() bg.BackgroundColor3 = C.tint end)
end
local statsLabel = makeText(statsFrame, "", 12, Enum.Font.GothamSemibold)

local function updateStats()
    if state.stats then
        statsFrame.Visible = true
        tween(statsFrame, 0.35, { GroupTransparency = 0 })
    else
        tween(statsFrame, 0.3, { GroupTransparency = 1 })
        task.delay(0.32, function()
            if not state.stats then statsFrame.Visible = false end
        end)
    end
end

do
    local frames, acc = 0, 0
    bind(RunService.Heartbeat, function(dt)
        frames += 1
        acc += dt
        if acc >= 0.5 then
            local fps = math.floor(frames / acc + 0.5)
            local ping = math.floor(player:GetNetworkPing() * 1000)
            if state.stats then
                statsLabel.Text = fps .. " FPS   |   " .. ping .. " ms"
            end
            frames, acc = 0, 0
        end
    end)
end

-- ========== Spectate core ==========
local spectating = nil
local playerRows = {}
local resetShader = function() end -- assigned in the VIEW page
local setShader = function(name) end -- assigned in the VIEW page
local resetAll = function() end -- assigned in the MISC page
local runCommandFn = function(s) end -- assigned in the AI page
local macroStore = {}

local function refreshSpectateLabels()
    for plr, r in pairs(playerRows) do
        local on = (spectating == plr)
        r.specLabel.Text = on and "STOP" or "SPECTATE"
        r.specBg:SetAttribute("Base", on and 0.72 or 0.86)
        tween(r.specBg, 0.3, {
            BackgroundColor3 = on and C.accent or C.white,
            BackgroundTransparency = on and 0.72 or 0.86,
        })
    end
end

local function stopSpectate()
    spectating = nil
    local cam = Workspace.CurrentCamera
    local hum = getHumanoid()
    if cam and hum then cam.CameraSubject = hum end
    refreshSpectateLabels()
end

-- keep following the target even if they respawn
bind(RunService.RenderStepped, function()
    if not spectating then return end
    local cam = Workspace.CurrentCamera
    local tchar = spectating.Character
    local thum = tchar and tchar:FindFirstChildOfClass("Humanoid")
    if cam and thum and cam.CameraSubject ~= thum then
        cam.CameraSubject = thum
    end
end)

-- ========== Gravity ==========
local originalGravity = nil
local function updateGravity()
    if state.gravityOn then
        if originalGravity == nil then originalGravity = Workspace.Gravity end
        Workspace.Gravity = state.gravity
    elseif originalGravity ~= nil then
        Workspace.Gravity = originalGravity
        originalGravity = nil
    end
end

-- ========== Zoom limit ==========
local originalZoom = player.CameraMaxZoomDistance

-- ========== Crosshair ==========
local crosshair = Instance.new("CanvasGroup")
crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
crosshair.Position = UDim2.fromScale(0.5, 0.5)
crosshair.Size = UDim2.fromOffset(state.crosshairSize, state.crosshairSize)
crosshair.BackgroundTransparency = 1
crosshair.GroupTransparency = 1
crosshair.Visible = false
crosshair.Parent = gui

do
    local function bar(anchor, pos, size)
        local f = Instance.new("Frame")
        f.AnchorPoint = anchor
        f.Position = pos
        f.Size = size
        f.BackgroundColor3 = C.white
        f.BorderSizePixel = 0
        f.Parent = crosshair
        corner(f, 2)
        return f
    end
    bar(Vector2.new(0.5, 0), UDim2.fromScale(0.5, 0), UDim2.new(0, 2, 0.32, 0))
    bar(Vector2.new(0.5, 1), UDim2.fromScale(0.5, 1), UDim2.new(0, 2, 0.32, 0))
    bar(Vector2.new(0, 0.5), UDim2.fromScale(0, 0.5), UDim2.new(0.32, 0, 0, 2))
    bar(Vector2.new(1, 0.5), UDim2.fromScale(1, 0.5), UDim2.new(0.32, 0, 0, 2))
    local dot = bar(Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.5), UDim2.fromOffset(3, 3))
    dot.BackgroundColor3 = C.accent
end

local function updateCrosshair()
    crosshair.Size = UDim2.fromOffset(state.crosshairSize, state.crosshairSize)
    if state.crosshair then
        crosshair.Visible = true
        tween(crosshair, 0.3, { GroupTransparency = 0 })
    else
        tween(crosshair, 0.25, { GroupTransparency = 1 })
        task.delay(0.27, function()
            if not state.crosshair then crosshair.Visible = false end
        end)
    end
end

-- ========== Color grade (custom shader sliders) ==========
local grade = { sat = 0, con = 0, bri = 0, bloom = 0, exp = 0 }
local gradeSetters = {}
local gradeCC, gradeBloom = nil, nil

local function updateGrade()
    if grade.sat ~= 0 or grade.con ~= 0 or grade.bri ~= 0 then
        if not gradeCC then
            gradeCC = Instance.new("ColorCorrectionEffect")
            gradeCC.Name = "HSXC_Color"
            gradeCC.Parent = Lighting
        end
        gradeCC.Saturation = grade.sat
        gradeCC.Contrast = grade.con
        gradeCC.Brightness = grade.bri
    elseif gradeCC then
        gradeCC:Destroy()
        gradeCC = nil
    end

    if grade.bloom > 0 then
        if not gradeBloom then
            gradeBloom = Instance.new("BloomEffect")
            gradeBloom.Name = "HSXC_Bloom"
            gradeBloom.Size = 30
            gradeBloom.Threshold = 1
            gradeBloom.Parent = Lighting
        end
        gradeBloom.Intensity = grade.bloom
    elseif gradeBloom then
        gradeBloom:Destroy()
        gradeBloom = nil
    end

    if grade.exp ~= 0 then
        setOverride("exposure", { ExposureCompensation = grade.exp })
    else
        setOverride("exposure", nil)
    end
end

local function resetGrade()
    for _, set in pairs(gradeSetters) do set(0, false) end
end

-- ========== Spin / anti-void / time flow ==========
do
    local lastSafe, safeTimer, lastRescue = nil, 0, 0
    bind(RunService.Heartbeat, function(dt)
        dt = math.min(dt, 0.1)
        local root = getRoot()
        local hum = getHumanoid()

        if state.spin and root then
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(state.spinSpeed * 60 * dt), 0)
        end

        if state.antiVoid and root and hum and hum.Health > 0 then
            if root.Position.Y < Workspace.FallenPartsDestroyHeight + 80 and lastSafe then
                if os.clock() - lastRescue > 2 then
                    lastRescue = os.clock()
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.CFrame = lastSafe
                    toast("Anti-void: back to safe spot")
                end
            elseif hum.FloorMaterial ~= Enum.Material.Air then
                safeTimer += dt
                if safeTimer > 0.5 then
                    safeTimer = 0
                    lastSafe = root.CFrame + Vector3.new(0, 3, 0)
                end
            end
        end

        if state.timeFlow then
            state.clock = (state.clock + dt * state.timeFlowSpeed) % 24
            updateClock()
        end
    end)
end

-- ========== Unload ==========
local function unload()
    for _, c in ipairs(connections) do c:Disconnect() end
    table.clear(connections)
    for _, c in ipairs(charConns) do c:Disconnect() end
    table.clear(charConns)
    pcall(function() RunService:UnbindFromRenderStep("HSX_FOV") end)

    -- restore everything we touched
    state.noclip = false
    restoreNoclip()
    if state.flying then setFly(false) end
    for plr in pairs(espObjects) do removeEsp(plr) end
    for feature in pairs(overrides) do setOverride(feature, nil) end
    clearShaders()
    if blurEffect then blurEffect:Destroy() blurEffect = nil end

    local camera = Workspace.CurrentCamera
    if camera and originalFov ~= nil then
        camera.FieldOfView = originalFov
    end

    local hum = getHumanoid()
    if hum and humDefaults then
        hum.WalkSpeed = humDefaults.walk
        hum.UseJumpPower = humDefaults.useJump
        hum.JumpHeight = humDefaults.jump
    end

    pcall(stopSpectate)
    state.gravityOn = false
    updateGravity()
    player.CameraMaxZoomDistance = originalZoom
    if gradeCC then gradeCC:Destroy() end
    if gradeBloom then gradeBloom:Destroy() end
    espFolder:Destroy()
    gui:Destroy()
end

-- ========== Page: MOVE ==========
do
    local page = pages.MOVE
    createHeader(page, "CHARACTER")
    createSlider(page, "Walk speed", 1, 300, state.walk, 1, function(v, byUser)
        state.walk = v
        if byUser then custom.walk = true applyHumanoid() end
    end)
    createSlider(page, "Jump height", 1, 50, state.jumpHeight, 0.1, function(v, byUser)
        state.jumpHeight = v
        if byUser then custom.jump = true applyHumanoid() end
    end)
    createHeader(page, "FLIGHT")
    createSlider(page, "Fly speed", 1, 500, state.flySpeed, 1, function(v)
        state.flySpeed = v
    end)
    createToggle(page, "FLY", "flying", function(v) setFly(v) end)
    createToggle(page, "NOCLIP", "noclip")
    createToggle(page, "INFINITE JUMP", "infJump")
end

-- ========== Page: VIEW ==========
do
    local page = pages.VIEW
    createHeader(page, "CAMERA")
    createSlider(page, "FOV", 30, 120, state.fov, 1, function(v) state.fov = v end)
    createToggle(page, "FOV OVERRIDE", "fovOn")

    createHeader(page, "SHADERS")
    local shaderIndex = 1
    local shaderButton, shaderLabel, shaderBg = glassButton(page, "SHADER: Off", 40)
    shaderButton.Activated:Connect(function()
        shaderIndex = shaderIndex % #SHADER_ORDER + 1
        state.shader = SHADER_ORDER[shaderIndex]
        applyShader(state.shader)
        shaderLabel.Text = "SHADER: " .. state.shader
        local on = state.shader ~= "Off"
        local base = on and 0.75 or 0.88
        shaderBg:SetAttribute("Base", base)
        tween(shaderBg, 0.35, {
            BackgroundColor3 = on and C.accent or C.white,
            BackgroundTransparency = base,
        })
        toast("Shader: " .. state.shader)
    end)

    setShader = function(name)
        for i, n in ipairs(SHADER_ORDER) do
            if n == name then shaderIndex = i end
        end
        state.shader = name
        applyShader(name)
        shaderLabel.Text = "SHADER: " .. name
        local on = name ~= "Off"
        local base = on and 0.75 or 0.88
        shaderBg:SetAttribute("Base", base)
        tween(shaderBg, 0.35, {
            BackgroundColor3 = on and C.accent or C.white,
            BackgroundTransparency = base,
        })
    end

    resetShader = function()
        shaderIndex = 1
        state.shader = "Off"
        applyShader("Off")
        shaderLabel.Text = "SHADER: Off"
        shaderBg:SetAttribute("Base", 0.88)
        tween(shaderBg, 0.35, { BackgroundColor3 = C.white, BackgroundTransparency = 0.88 })
    end

    createToggle(page, "FULLBRIGHT", "fullbright", updateFullbright)
    createToggle(page, "NO FOG", "noFog", updateNoFog)

    createHeader(page, "TIME")
    createSlider(page, "Time of day", 0, 24, state.clock, 0.5, function(v)
        state.clock = v
        if state.clockOn then updateClock() end
    end)
    createToggle(page, "TIME LOCK", "clockOn", updateClock)
    createToggle(page, "TIME FLOW", "timeFlow", function(v)
        if v then
            state.clockOn = true
            toggleRefs.clockOn()
            updateClock()
        end
    end)
    createSlider(page, "Flow speed", 0.1, 5, state.timeFlowSpeed, 0.1, function(v)
        state.timeFlowSpeed = v
    end)

    createHeader(page, "COLOR GRADE")
    local function gradeSlider(title, key, min, max, step)
        gradeSetters[key] = createSlider(page, title, min, max, 0, step, function(v)
            grade[key] = v
            updateGrade()
        end)
    end
    gradeSlider("Saturation", "sat", -1, 1, 0.05)
    gradeSlider("Contrast", "con", -1, 1, 0.05)
    gradeSlider("Brightness", "bri", -0.5, 0.5, 0.01)
    gradeSlider("Bloom", "bloom", 0, 3, 0.1)
    gradeSlider("Exposure", "exp", -3, 3, 0.1)
end

-- ========== Page: ESP ==========
do
    local page = pages.ESP
    createToggle(page, "ESP", "esp", function() updateEsp() end)

    espStatusLabel = makeText(page, "ESP is off", 12, Enum.Font.GothamMedium, C.sub)
    espStatusLabel.Size = UDim2.new(1, -6, 0, 22)

    createHeader(page, "VISUALS")
    createToggle(page, "ROUNDED BOX", "espBox")
    createToggle(page, "CHAMS", "espChams")
    createToggle(page, "TRACERS", "espTracers")
    createToggle(page, "HEALTH BAR", "espHealthBar")
    createToggle(page, "RAINBOW", "espRainbow")

    createHeader(page, "TEXT")
    createToggle(page, "NAMES", "espName")
    createToggle(page, "DISTANCE", "espDist")
    createToggle(page, "HEALTH", "espHealth")

    createHeader(page, "TARGETS")
    createToggle(page, "INCLUDE NPCs", "espNpc")
    createToggle(page, "HIDE TEAMMATES", "espTeam")
    createSlider(page, "Max distance", 50, 3000, state.espRange, 50, function(v)
        state.espRange = v
    end)
    createSlider(page, "Chams opacity", 0, 1, 1 - state.espFill, 0.05, function(v)
        state.espFill = 1 - v
    end)
end

-- ========== Page: MISC ==========
do
    local page = pages.MISC
    createHeader(page, "THEME")
    do
        local cols = math.max(1, math.floor((PANEL_W - 46 + 10) / 40))
        local rowsN = math.ceil(#THEME_ORDER / cols)

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -6, 0, rowsN * 40 + 10)
        card.BackgroundTransparency = 1
        card.Parent = page
        surface(card, 14, 0.88)

        local grid = Instance.new("Frame")
        grid.Size = UDim2.fromScale(1, 1)
        grid.BackgroundTransparency = 1
        grid.Parent = card
        local layout = Instance.new("UIGridLayout")
        layout.CellSize = UDim2.fromOffset(30, 30)
        layout.CellPadding = UDim2.fromOffset(10, 10)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = grid

        for i, name in ipairs(THEME_ORDER) do
            local t = THEMES[name]
            local btn = Instance.new("TextButton")
            btn.LayoutOrder = i
            btn.BackgroundColor3 = C.white
            btn.BorderSizePixel = 0
            btn.Text = ""
            btn.AutoButtonColor = false
            btn.Parent = grid
            corner(btn, 10)
            local g = Instance.new("UIGradient")
            g.Rotation = 45
            g.Color = ColorSequence.new(t.accent, t.accent2)
            g.Parent = btn
            themeRings[name] = stroke(btn, 1, 2)
            btn.Activated:Connect(function()
                setTheme(name)
                toast("Theme: " .. name)
            end)
        end
        themeRings[currentTheme].Transparency = 0
    end

    createToggle(page, "AUTO-CYCLE THEMES", "themeCycle", function(v)
        if not v then return end
        task.spawn(function()
            local i = table.find(THEME_ORDER, currentTheme) or 1
            while state.themeCycle and gui.Parent do
                task.wait(6)
                if not (state.themeCycle and gui.Parent) then break end
                i = i % #THEME_ORDER + 1
                setTheme(THEME_ORDER[i])
            end
        end)
    end)

    createHeader(page, "INTERFACE")
    createSlider(page, "Glass opacity", 0.15, 0.8, 0.38, 0.01, function(v)
        panel.BackgroundTransparency = v
    end)
    createSlider(page, "Roundness", 0.1, 1.5, roundness, 0.05, function(v)
        setRoundness(v)
    end)
    createSlider(page, "UI scale", 0.7, 1.3, 1, 0.05, function(v)
        uiScale = v
        if panelOpen then panelScale.Scale = v end
    end)
    createToggle(page, "WORLD BLUR", "blur", updateBlur)
    createToggle(page, "FPS / PING", "stats", updateStats)
    createToggle(page, "TOAST MESSAGES", "toasts")
    createToggle(page, "LITE MODE (fewer effects)", "lite", function(v)
        for _, o in ipairs(fxObjects) do o.Visible = not v end
    end)

    createHeader(page, "SCENES")
    do
        local SCENES = {
            { "Cinematic", { "shader cinematic", "fov 60", "time 18", "crosshair off" } },
            { "Night", { "shader night", "time 23", "fullbright off" } },
            { "Debug", { "fps on", "esp on", "crosshair on" } },
            { "Clean", { "shader off", "fov off", "time off", "esp off", "fps off",
                "crosshair off", "fullbright off" } },
        }
        for _, scene in ipairs(SCENES) do
            local btn = glassButton(page, "Scene: " .. scene[1], 40)
            btn.Activated:Connect(function()
                for _, cmd in ipairs(scene[2]) do runCommandFn(cmd) end
                toast("Scene: " .. scene[1])
            end)
        end
    end

    createHeader(page, "CONFIG")
    do
        local HttpService = game:GetService("HttpService")
        local FLAG_KEYS = { "noclip", "infJump", "fovOn", "fullbright", "noFog", "clockOn",
            "esp", "espBox", "espChams", "espTracers", "espNpc", "espRainbow", "espHealthBar",
            "espName", "espDist", "espHealth", "espTeam", "gravityOn", "crosshair", "clickTp",
            "spin", "antiVoid", "timeFlow", "stats", "blur", "toasts", "lite" }
        local FLAG_SET = {}
        for _, k in ipairs(FLAG_KEYS) do FLAG_SET[k] = true end
        local SLIDER_TITLES = { "Fly speed", "FOV", "Time of day", "Flow speed", "Max distance",
            "Chams opacity", "Gravity", "Spin speed", "Crosshair size", "Glass opacity",
            "Roundness", "UI scale" }

        local EFFECTS = {
            esp = function() updateEsp() end,
            fullbright = updateFullbright,
            noFog = updateNoFog,
            clockOn = updateClock,
            gravityOn = updateGravity,
            crosshair = updateCrosshair,
            stats = updateStats,
            blur = updateBlur,
            lite = function(v)
                for _, o in ipairs(fxObjects) do o.Visible = not v end
            end,
        }

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -6, 0, 96)
        card.BackgroundTransparency = 1
        card.Parent = page
        surface(card, 14, 0.88)

        local configBox = Instance.new("TextBox")
        configBox.Position = UDim2.fromOffset(10, 6)
        configBox.Size = UDim2.new(1, -20, 1, -12)
        configBox.BackgroundTransparency = 1
        configBox.Font = Enum.Font.Code
        configBox.TextSize = 11
        configBox.TextColor3 = C.text
        configBox.PlaceholderText = "Export to fill this box, or paste a config here and press Import"
        configBox.PlaceholderColor3 = C.sub
        configBox.MultiLine = true
        configBox.TextWrapped = true
        configBox.ClearTextOnFocus = false
        configBox.TextXAlignment = Enum.TextXAlignment.Left
        configBox.TextYAlignment = Enum.TextYAlignment.Top
        configBox.Text = ""
        configBox.Parent = card

        local exportBtn = glassButton(page, "Export settings", 40)
        exportBtn.Activated:Connect(function()
            local data = { flags = {}, sliders = {}, macros = macroStore,
                theme = currentTheme, shader = state.shader }
            for _, k in ipairs(FLAG_KEYS) do data.flags[k] = state[k] end
            for _, title in ipairs(SLIDER_TITLES) do data.sliders[title] = sliderValues[title] end
            configBox.Text = HttpService:JSONEncode(data)
            toast("Exported - long-press the box to copy")
        end)

        local importBtn = glassButton(page, "Import settings", 40)
        importBtn.Activated:Connect(function()
            local ok, data = pcall(function() return HttpService:JSONDecode(configBox.Text) end)
            if not ok or type(data) ~= "table" then
                toast("Invalid config")
                return
            end
            for key, value in pairs(data.flags or {}) do
                if FLAG_SET[key] and type(value) == "boolean" and state[key] ~= value then
                    state[key] = value
                    if toggleRefs[key] then toggleRefs[key]() end
                    local fx = EFFECTS[key]
                    if fx then fx(value) end
                end
            end
            for title, value in pairs(data.sliders or {}) do
                if sliderSetters[title] and type(value) == "number" then
                    sliderSetters[title](value, true)
                end
            end
            if type(data.macros) == "table" then
                for name, body in pairs(data.macros) do
                    if type(name) == "string" and type(body) == "string" then
                        macroStore[name] = body
                    end
                end
            end
            if type(data.theme) == "string" and THEMES[data.theme] then
                setTheme(data.theme)
            end
            if type(data.shader) == "string" and data.shader ~= state.shader then
                for _, n in ipairs(SHADER_ORDER) do
                    if n == data.shader then setShader(n) end
                end
            end
            toast("Config imported")
        end)
    end

    createHeader(page, "PANEL")
    local collapse = glassButton(page, "Collapse panel", 40)
    collapse.Activated:Connect(function() setPanelOpen(false) end)

    local resetButton = glassButton(page, "Reset all features", 40)
    resetAll = function()
        if state.flying then setFly(false) end
        for _, key in ipairs({ "noclip", "infJump", "fovOn", "fullbright", "noFog",
            "clockOn", "esp", "blur", "stats", "gravityOn", "crosshair", "clickTp",
            "spin", "antiVoid", "timeFlow" }) do
            state[key] = false
            if toggleRefs[key] then toggleRefs[key]() end
        end
        restoreNoclip()
        updateFullbright()
        updateNoFog()
        updateClock()
        updateBlur()
        updateEsp()
        updateStats()
        updateGravity()
        updateCrosshair()
        resetGrade()
        player.CameraMaxZoomDistance = originalZoom
        resetShader()
        stopSpectate()
        custom.walk = false
        custom.jump = false
        local hum = getHumanoid()
        if hum and humDefaults then
            hum.WalkSpeed = humDefaults.walk
            hum.UseJumpPower = humDefaults.useJump
            hum.JumpHeight = humDefaults.jump
        end
        toast("All features reset")
    end
    resetButton.Activated:Connect(function() resetAll() end)

    local unloadButton, _, unloadBg = glassButton(page, "UNLOAD (restore everything)", 40, C.danger)
    unloadBg:SetAttribute("Base", 0.8)
    unloadBg.BackgroundTransparency = 0.8
    unloadButton.Activated:Connect(unload)
end

-- ========== Page: AI (assistant) ==========
-- Local command assistant: understands plain English / Russian, can chain commands
-- ("fly on and esp on"), and optionally asks a server-side AI bridge (HSX_AI) for the rest.
do
    local holder = holders.AI
    local log = pages.AI
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    log.Size = UDim2.new(1, 0, 1, -108)

    local order = 0

    local function scrollBottom()
        task.delay(0.08, function()
            if log.Parent then
                log.CanvasPosition = Vector2.new(0,
                    math.max(0, log.AbsoluteCanvasSize.Y - log.AbsoluteWindowSize.Y))
            end
        end)
    end

    local function addBubble(text, fromUser, instant)
        order += 1
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -6, 0, 0)
        row.AutomaticSize = Enum.AutomaticSize.Y
        row.BackgroundTransparency = 1
        row.LayoutOrder = order
        row.Parent = log

        local bubble = Instance.new("Frame")
        bubble.AnchorPoint = Vector2.new(fromUser and 1 or 0, 0)
        bubble.Position = UDim2.new(fromUser and 1 or 0, 0, 0, 0)
        bubble.Size = UDim2.new(0.86, 0, 0, 0)
        bubble.AutomaticSize = Enum.AutomaticSize.Y
        bubble.BackgroundTransparency = 1
        bubble.Parent = row

        local base = fromUser and 0.7 or 0.88
        local bg = surface(bubble, 14, base, fromUser and C.accent or C.white)
        if fromUser then
            onTheme(function() bg.BackgroundColor3 = C.accent end)
        end

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 0)
        label.AutomaticSize = Enum.AutomaticSize.Y
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 13
        label.TextColor3 = C.text
        label.TextWrapped = true
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Top
        label.Text = text
        label.Parent = bubble
        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 12)
        pad.PaddingRight = UDim.new(0, 12)
        pad.PaddingTop = UDim.new(0, 8)
        pad.PaddingBottom = UDim.new(0, 8)
        pad.Parent = label

        -- fade in
        label.TextTransparency = 1
        bg.BackgroundTransparency = 1
        tween(label, 0.3, { TextTransparency = 0 })
        tween(bg, 0.35, { BackgroundTransparency = base })
        scrollBottom()

        -- typewriter for assistant messages
        if not fromUser and not instant then
            task.spawn(function()
                local n = utf8.len(text) or #text
                label.MaxVisibleGraphemes = 0
                for i = 1, n do
                    if not label.Parent then return end
                    label.MaxVisibleGraphemes = i
                    if i % 2 == 0 then
                        task.wait()
                        if i % 24 == 0 then scrollBottom() end
                    end
                end
                label.MaxVisibleGraphemes = -1
                scrollBottom()
            end)
        end
        return row, label
    end

    local function showTyping()
        local row, label = addBubble(".", false, true)
        local alive = true
        task.spawn(function()
            local n = 0
            while alive and label.Parent do
                n = n % 3 + 1
                label.Text = string.rep(".", n)
                task.wait(0.3)
            end
        end)
        return function()
            alive = false
            row:Destroy()
        end
    end

    -- ---------- text helpers ----------
    local function lowerText(s)
        local ok, res = pcall(function()
            local out = {}
            for _, cp in utf8.codes(s) do
                if cp >= 0x410 and cp <= 0x42F then
                    cp += 32
                elseif cp == 0x401 then
                    cp = 0x451
                elseif cp >= 65 and cp <= 90 then
                    cp += 32
                end
                table.insert(out, utf8.char(cp))
            end
            return table.concat(out)
        end)
        return ok and res or string.lower(s)
    end

    local function hasAny(t, list)
        for _, w in ipairs(list) do
            if string.find(t, w, 1, true) then return true end
        end
        return false
    end

    local function numberIn(t)
        return tonumber(string.match(t, "%-?%d+%.?%d*"))
    end

    local function wantFlag(t)
        if hasAny(t, { " off", "disable", "stop", "выключ", "отключ", "выкл", "убери" }) then return false end
        if hasAny(t, { " on", "enable", "start", "включ", "вкл" }) then return true end
        return nil
    end

    local function flag(key, t, label, after)
        local new = wantFlag(t)
        if new == nil then new = not state[key] end
        if state[key] ~= new then
            state[key] = new
            if toggleRefs[key] then toggleRefs[key]() end
        end
        if after then after(new) end
        return label .. (new and " is ON." or " is OFF.")
    end

    local function setSlider(title, value, label)
        local set = sliderSetters[title]
        if not set then return "That slider isn't available." end
        set(value, true)
        return label .. " set to " .. tostring(value) .. "."
    end

    local function findPlayer(t)
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                local n1, n2 = lowerText(plr.Name), lowerText(plr.DisplayName)
                if (#n1 > 0 and string.find(t, n1, 1, true))
                    or (#n2 > 0 and string.find(t, n2, 1, true)) then
                    return plr
                end
            end
        end
        for word in string.gmatch(t, "%S+") do
            if #word >= 3 then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= player and (string.sub(lowerText(plr.Name), 1, #word) == word
                        or string.sub(lowerText(plr.DisplayName), 1, #word) == word) then
                        return plr
                    end
                end
            end
        end
        return nil
    end

    local HELP = "I understand plain commands, you can chain them with 'and':\n"
        .. "- fly on / noclip / infinite jump / spin / anti-void\n"
        .. "- speed 80, jump 20, fly speed 120, gravity 50, fov 90\n"
        .. "- esp on, esp npc, tracers, rainbow\n"
        .. "- shader night, fullbright, fog, blur, time 20, crosshair, fps\n"
        .. "- tp <player>, spectate <player>, players\n"
        .. "- theme rose / random, hide, status, reset\n"
        .. "- macro save night: shader night and time 22  /  macro night  /  repeat\n"
        .. "(Russian works too: лети, скорость 80, есп, сброс)"

    local STATUS_KEYS = {
        { "flying", "fly" }, { "noclip", "noclip" }, { "infJump", "inf jump" },
        { "esp", "esp" }, { "fovOn", "fov" }, { "fullbright", "fullbright" },
        { "noFog", "no fog" }, { "clockOn", "time lock" }, { "gravityOn", "gravity" },
        { "crosshair", "crosshair" }, { "clickTp", "click tp" }, { "spin", "spin" },
        { "antiVoid", "anti-void" }, { "stats", "fps/ping" }, { "blur", "blur" },
    }

    local macros = macroStore
    local lastCommand = nil
    local macroDepth = 0

    local function splitSegments(text)
        local tmp = text
        for _, sep in ipairs({ "%s+and%s+", "%s+then%s+", "%s+и%s+", "%s+потом%s+" }) do
            tmp = string.gsub(tmp, sep, ",")
        end
        local list = {}
        for seg in string.gmatch(tmp .. ",", "([^,;]+)[,;]") do
            table.insert(list, seg)
        end
        return list
    end

    local runCommand

    -- ---------- intents (first match wins) ----------
    local intents = {
        { { "help", "commands", "помощь", "помоги", "что умеешь" }, function() return HELP end },

        { { "status", "статус", "what is on", "active" }, function()
            local on = {}
            for _, pair in ipairs(STATUS_KEYS) do
                if state[pair[1]] then table.insert(on, pair[2]) end
            end
            if state.shader ~= "Off" then table.insert(on, "shader " .. state.shader) end
            if #on == 0 then return "Nothing is active right now." end
            return "Active: " .. table.concat(on, ", ") .. "."
        end },

        { { "hello", "hi ", "hey", "привет", "здравствуй" }, function()
            return "Hi! Tell me what to do, or type help."
        end },

        { { "thanks", "thank you", "спасибо" }, function() return "Anytime!" end },

        { { "macro", "макрос", " run " }, function(t)
            local name = string.match(t, "macro%s+([%w_]+)")
                or string.match(t, "макрос%s+([%w_]+)")
                or string.match(t, "run%s+([%w_]+)")
            if not name or name == "list" then
                local names = {}
                for n in pairs(macros) do table.insert(names, n) end
                table.sort(names)
                if #names == 0 then
                    return "No macros yet. Create one: macro save night: shader night and time 22"
                end
                return "Macros: " .. table.concat(names, ", ") .. "."
            end
            local body = macros[name]
            if not body then return "No macro called '" .. name .. "'." end
            if macroDepth >= 3 then return "Macro nesting is too deep." end
            macroDepth += 1
            local out = {}
            for _, seg in ipairs(splitSegments(body)) do
                local r = runCommand(seg)
                if r then table.insert(out, r) end
            end
            macroDepth -= 1
            return "Macro " .. name .. " done: " .. table.concat(out, " ")
        end },

        { { "infinite jump", "inf jump", "бесконечн" }, function(t)
            return flag("infJump", t, "Infinite jump")
        end },

        { { "fly speed", "скорость полета", "скорость полёта" }, function(t)
            local n = numberIn(t)
            if not n then return "Give me a number, e.g. fly speed 120." end
            return setSlider("Fly speed", n, "Fly speed")
        end },

        { { "fly", "лети", "полет", "полёт" }, function(t)
            return flag("flying", t, "Fly", function(v) setFly(v) end)
        end },

        { { "noclip", "ноклип" }, function(t) return flag("noclip", t, "Noclip") end },

        { { "walk speed", "walkspeed", "speed", "скорость" }, function(t)
            local n = numberIn(t)
            if not n then return "Give me a number, e.g. speed 80." end
            return setSlider("Walk speed", n, "Walk speed")
        end },

        { { "jump", "прыж" }, function(t)
            local n = numberIn(t)
            if not n then return "Give me a number, e.g. jump 20." end
            return setSlider("Jump height", n, "Jump height")
        end },

        { { "esp", "есп", "chams", "tracer", "трейсер", "rainbow", "радуг", "npc", "нпс" }, function(t)
            if hasAny(t, { "npc", "нпс" }) then
                return flag("espNpc", t, "ESP for NPCs", function() updateEsp() end)
            elseif hasAny(t, { "tracer", "трейсер" }) then
                return flag("espTracers", t, "Tracers")
            elseif hasAny(t, { "rainbow", "радуг" }) then
                return flag("espRainbow", t, "Rainbow ESP")
            elseif hasAny(t, { "chams" }) then
                return flag("espChams", t, "Chams")
            end
            return flag("esp", t, "ESP", function() updateEsp() end)
        end },

        { { "fov", "фов" }, function(t)
            local n = numberIn(t)
            if wantFlag(t) == false then
                return flag("fovOn", t, "FOV override")
            end
            if not n then return "Give me a number, e.g. fov 90." end
            setSlider("FOV", n, "FOV")
            state.fovOn = true
            toggleRefs.fovOn()
            return "FOV set to " .. tostring(math.clamp(n, 30, 120)) .. "."
        end },

        { { "gravity", "гравитац" }, function(t)
            if wantFlag(t) == false or hasAny(t, { "default", "normal", "обычн" }) then
                state.gravityOn = false
                toggleRefs.gravityOn()
                updateGravity()
                return "Gravity back to normal."
            end
            local n = numberIn(t)
            if not n then return "Give me a number, e.g. gravity 50." end
            setSlider("Gravity", n, "Gravity")
            state.gravityOn = true
            toggleRefs.gravityOn()
            updateGravity()
            return "Gravity override set to " .. tostring(math.clamp(n, 0, 400)) .. "."
        end },

        { { "shader", "шейдер", "vivid", "cinematic", "sunset", "night", "retro" }, function(t)
            if wantFlag(t) == false or hasAny(t, { "none", "no shader" }) then
                setShader("Off")
                return "Shader is off."
            end
            for _, name in ipairs(SHADER_ORDER) do
                if name ~= "Off" and string.find(t, string.lower(name), 1, true) then
                    setShader(name)
                    return "Shader: " .. name .. "."
                end
            end
            return "Pick one: vivid, cinematic, sunset, night, retro (or 'shader off')."
        end },

        { { "midnight", "noon", "полночь", "полдень", "time", "clock", "время" }, function(t)
            local n = numberIn(t)
            if hasAny(t, { "midnight", "полночь" }) then n = 0 end
            if hasAny(t, { "noon", "полдень" }) then n = 12 end
            if wantFlag(t) == false then
                state.clockOn = false
                toggleRefs.clockOn()
                updateClock()
                return "Time lock is off."
            end
            if not n then return "Give me an hour 0-24, e.g. time 20." end
            setSlider("Time of day", n, "Time")
            state.clockOn = true
            toggleRefs.clockOn()
            updateClock()
            return "Time locked at " .. tostring(math.clamp(n, 0, 24)) .. ":00."
        end },

        { { "fullbright", "светл" }, function(t)
            return flag("fullbright", t, "Fullbright", updateFullbright)
        end },
        { { "fog", "туман" }, function(t)
            return flag("noFog", t, "No fog", updateNoFog)
        end },
        { { "blur", "размыт" }, function(t)
            return flag("blur", t, "World blur", updateBlur)
        end },
        { { "fps", "ping", "пинг" }, function(t)
            return flag("stats", t, "FPS/ping overlay", updateStats)
        end },
        { { "crosshair", "прицел" }, function(t)
            return flag("crosshair", t, "Crosshair", updateCrosshair)
        end },
        { { "spin", "вращ" }, function(t) return flag("spin", t, "Spin") end },
        { { "void", "войд" }, function(t) return flag("antiVoid", t, "Anti-void") end },
        { { "click tp", "tap tp", "click teleport" }, function(t)
            return flag("clickTp", t, "Click teleport")
        end },

        { { "spectate", "наблюд", "watch" }, function(t)
            if wantFlag(t) == false then
                stopSpectate()
                return "Spectate off."
            end
            local plr = findPlayer(t)
            if not plr then return "Which player? Try 'players' to see who is here." end
            spectating = plr
            refreshSpectateLabels()
            return "Spectating " .. plr.DisplayName .. "."
        end },

        { { " tp ", "teleport", "телепорт" }, function(t)
            local plr = findPlayer(t)
            if not plr then return "Which player? Try 'players' to see who is here." end
            local root, troot = getRoot(), plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if not (root and troot) then return plr.DisplayName .. " isn't available right now." end
            root.CFrame = troot.CFrame * CFrame.new(0, 0, 3)
            return "Teleported to " .. plr.DisplayName .. "."
        end },

        { { "players", "игроки", "who is" }, function()
            local names = {}
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player then table.insert(names, plr.DisplayName) end
            end
            if #names == 0 then return "You're alone in this server." end
            return #names .. " other player(s): " .. table.concat(names, ", ") .. "."
        end },

        { { "theme", "тема" }, function(t)
            if hasAny(t, { "random", "случайн" }) then
                local pick = THEME_ORDER[math.random(#THEME_ORDER)]
                setTheme(pick)
                return "Random theme: " .. pick .. "."
            end
            for _, name in ipairs(THEME_ORDER) do
                if string.find(t, string.lower(name), 1, true) then
                    setTheme(name)
                    return "Theme: " .. name .. "."
                end
            end
            return "Themes: " .. table.concat(THEME_ORDER, ", ") .. "."
        end },

        { { "round", "скругл" }, function(t)
            local n = numberIn(t)
            if not n then return "Give me a number 0.1-1.5, e.g. roundness 0.4." end
            return setSlider("Roundness", n, "Roundness")
        end },

        { { "ui scale", "масштаб" }, function(t)
            local n = numberIn(t)
            if not n then return "Give me a number 0.7-1.3, e.g. ui scale 1.1." end
            return setSlider("UI scale", n, "UI scale")
        end },

        { { "hide", "close", "collapse", "скрой", "закрой" }, function()
            task.delay(0.6, function() setPanelOpen(false) end)
            return "Hiding the panel (tap the pill to bring it back)."
        end },

        { { "reset", "сброс" }, function()
            resetAll()
            return "Everything is reset."
        end },
    }

    runCommand = function(raw)
        local t = " " .. lowerText(raw) .. " "
        for _, intent in ipairs(intents) do
            if hasAny(t, intent[1]) then
                local ok, reply = pcall(intent[2], t, raw)
                if ok then return reply, true end
                return "Something went wrong: " .. tostring(reply), true
            end
        end
        return nil, false
    end

    runCommandFn = function(s)
        local r = runCommand(s)
        return r
    end

    -- ---------- "did you mean" ----------
    local WORDS = { "fly", "noclip", "esp", "speed", "jump", "fov", "gravity", "shader", "time",
        "fullbright", "fog", "blur", "fps", "crosshair", "spin", "teleport", "spectate", "reset",
        "theme", "status", "help", "players" }

    local function distance(a, b)
        local la, lb = #a, #b
        local prev = {}
        for j = 0, lb do prev[j] = j end
        for i = 1, la do
            local cur = { [0] = i }
            for j = 1, lb do
                local cost = (string.sub(a, i, i) == string.sub(b, j, j)) and 0 or 1
                cur[j] = math.min(prev[j] + 1, cur[j - 1] + 1, prev[j - 1] + cost)
            end
            prev = cur
        end
        return prev[lb]
    end

    local function suggest(text)
        local first = string.match(lowerText(text), "%S+")
        if not first then return nil end
        local best, bestD = nil, 3
        for _, w in ipairs(WORDS) do
            local d = distance(first, w)
            if d < bestD then best, bestD = w, d end
        end
        return best
    end

    -- ---------- optional server-side AI bridge ----------
    local function askServer(text)
        local remote = ReplicatedStorage:FindFirstChild("HSX_AI")
        if not remote or not remote:IsA("RemoteFunction") then return nil end
        local result, done = nil, false
        task.spawn(function()
            local ok, res = pcall(function() return remote:InvokeServer(text) end)
            if ok and type(res) == "string" then result = res end
            done = true
        end)
        local started = os.clock()
        while not done and os.clock() - started < 25 do task.wait(0.1) end
        return result
    end

    -- ---------- chat input ----------
    local busy = false

    local function submit(text)
        text = string.gsub(text, "^%s+", "")
        text = string.gsub(text, "%s+$", "")
        if text == "" or busy then return end
        busy = true
        addBubble(text, true, true)

        task.spawn(function()
            local stopTyping = showTyping()
            task.wait(0.4)

            local lower = lowerText(text)

            -- macro definition: "macro save <name>: <commands>"
            local mName, mBody = string.match(lower, "^%s*macro%s+save%s+([%w_]+)%s*[:=]%s*(.+)$")
            if mName then
                macros[mName] = mBody
                stopTyping()
                addBubble("Macro '" .. mName .. "' saved. Run it with: macro " .. mName, false)
                busy = false
                return
            end

            -- "repeat" / "again" re-runs the previous command
            if hasAny(" " .. lower .. " ", { "repeat", "again", "ещё раз", "еще раз" }) and lastCommand then
                text = lastCommand
            else
                lastCommand = text
            end

            local replies, unknown = {}, {}
            for _, seg in ipairs(splitSegments(text)) do
                local reply, matched = runCommand(seg)
                if matched then
                    table.insert(replies, reply)
                else
                    table.insert(unknown, seg)
                end
            end

            if #replies == 0 then
                local serverText = askServer(text)
                if serverText then
                    -- lines starting with CMD: are executed by the local parser
                    for line in string.gmatch(serverText, "[^\n]+") do
                        local cmd = string.match(line, "^%s*CMD:%s*(.+)$")
                        if cmd then
                            local r = runCommand(cmd)
                            if r then table.insert(replies, "> " .. r) end
                        else
                            table.insert(replies, line)
                        end
                    end
                else
                    local guess = suggest(text)
                    if guess then
                        table.insert(replies, "I didn't get that. Did you mean '" .. guess .. "'? Type help for the list.")
                    else
                        table.insert(replies, "I didn't get that. Type help for the list of commands.")
                    end
                end
            elseif #unknown > 0 then
                table.insert(replies, "(skipped: " .. table.concat(unknown, "; ") .. ")")
            end

            stopTyping()
            addBubble(table.concat(replies, "\n"), false)
            busy = false
        end)
    end

    -- chips (quick commands)
    local chips = Instance.new("ScrollingFrame")
    chips.AnchorPoint = Vector2.new(0, 1)
    chips.Position = UDim2.new(0, 0, 1, -46)
    chips.Size = UDim2.new(1, 0, 0, 30)
    chips.BackgroundTransparency = 1
    chips.BorderSizePixel = 0
    chips.ScrollBarThickness = 0
    chips.ScrollingDirection = Enum.ScrollingDirection.X
    chips.CanvasSize = UDim2.new()
    chips.AutomaticCanvasSize = Enum.AutomaticSize.X
    chips.Parent = holder
    local chipList = Instance.new("UIListLayout")
    chipList.FillDirection = Enum.FillDirection.Horizontal
    chipList.Padding = UDim.new(0, 6)
    chipList.Parent = chips

    for _, text in ipairs({ "help", "status", "fly on", "esp on", "shader night", "fullbright", "reset" }) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.fromOffset(#text * 7 + 26, 28)
        b.BackgroundTransparency = 1
        b.Text = ""
        b.AutoButtonColor = false
        b.Parent = chips
        local bg = surface(b, 12, 0.86)
        makeText(b, text, 11, Enum.Font.GothamSemibold, C.sub)
        pressable(b, bg)
        b.Activated:Connect(function() submit(text) end)
    end

    -- input bar
    local bar = Instance.new("Frame")
    bar.AnchorPoint = Vector2.new(0, 1)
    bar.Position = UDim2.new(0, 0, 1, 0)
    bar.Size = UDim2.new(1, 0, 0, 40)
    bar.BackgroundTransparency = 1
    bar.Parent = holder
    surface(bar, 14, 0.84)

    local box = Instance.new("TextBox")
    box.Position = UDim2.fromOffset(14, 0)
    box.Size = UDim2.new(1, -64, 1, 0)
    box.BackgroundTransparency = 1
    box.Font = Enum.Font.GothamMedium
    box.TextSize = 13
    box.TextColor3 = C.text
    box.PlaceholderText = "Ask me to do something..."
    box.PlaceholderColor3 = C.sub
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ClearTextOnFocus = false
    box.Text = ""
    box.Parent = bar

    local sendBtn = Instance.new("TextButton")
    sendBtn.AnchorPoint = Vector2.new(1, 0.5)
    sendBtn.Position = UDim2.new(1, -6, 0.5, 0)
    sendBtn.Size = UDim2.fromOffset(40, 30)
    sendBtn.BackgroundTransparency = 1
    sendBtn.Text = ""
    sendBtn.AutoButtonColor = false
    sendBtn.Parent = bar
    local sendBg = surface(sendBtn, 10, 0.7, C.accent)
    onTheme(function() sendBg.BackgroundColor3 = C.accent end)
    makeText(sendBtn, ">", 16, Enum.Font.GothamBold)
    pressable(sendBtn, sendBg)

    local function send()
        local text = box.Text
        box.Text = ""
        submit(text)
    end
    sendBtn.Activated:Connect(send)
    box.FocusLost:Connect(function(enterPressed)
        if enterPressed then send() end
    end)

    addBubble("Hi! I'm the HollyScriptX assistant. Try: \"fly on and esp on\", \"speed 80\" or \"shader night\". Type help for everything.", false)
end

-- ========== Page: TOOLS ==========
do
    local page = pages.TOOLS
    local TeleportService = game:GetService("TeleportService")
    local waypoint = nil

    createHeader(page, "PHYSICS")
    createSlider(page, "Gravity", 0, 400, state.gravity, 1, function(v)
        state.gravity = v
        if state.gravityOn then updateGravity() end
    end)
    createToggle(page, "GRAVITY OVERRIDE", "gravityOn", updateGravity)
    createToggle(page, "ANTI-VOID", "antiVoid")
    createToggle(page, "SPIN", "spin")
    createSlider(page, "Spin speed", 1, 30, state.spinSpeed, 1, function(v)
        state.spinSpeed = v
    end)

    createHeader(page, "CAMERA")
    createSlider(page, "Max zoom", 10, 1000, math.clamp(originalZoom, 10, 1000), 10, function(v, byUser)
        if byUser then player.CameraMaxZoomDistance = v end
    end)
    createToggle(page, "CROSSHAIR", "crosshair", updateCrosshair)
    createSlider(page, "Crosshair size", 10, 80, state.crosshairSize, 1, function(v)
        state.crosshairSize = v
        crosshair.Size = UDim2.fromOffset(v, v)
    end)

    createHeader(page, "TELEPORT")
    createToggle(page, "CLICK / TAP TELEPORT", "clickTp")

    local saveBtn = glassButton(page, "Save waypoint", 40)
    saveBtn.Activated:Connect(function()
        local root = getRoot()
        if root then
            waypoint = root.CFrame
            toast("Waypoint saved")
        end
    end)

    local goBtn = glassButton(page, "Go to waypoint", 40)
    goBtn.Activated:Connect(function()
        local root = getRoot()
        if root and waypoint then
            root.CFrame = waypoint
            toast("Teleported to waypoint")
        else
            toast("No waypoint saved")
        end
    end)

    local posBtn = glassButton(page, "Show my position", 40)
    posBtn.Activated:Connect(function()
        local root = getRoot()
        if root then
            local p = root.Position
            toast(string.format("%d, %d, %d", p.X, p.Y, p.Z))
        end
    end)

    createHeader(page, "SESSION")
    local resetChar = glassButton(page, "Reset character", 40)
    resetChar.Activated:Connect(function()
        local hum = getHumanoid()
        if hum then hum.Health = 0 end
    end)

    local rejoin = glassButton(page, "Rejoin server", 40)
    rejoin.Activated:Connect(function()
        toast("Rejoining...")
        local ok = pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
        end)
        if not ok then toast("Rejoin failed") end
    end)

    -- click / tap teleport
    local function clickTeleport(x, y)
        if not state.clickTp then return end
        local camera = Workspace.CurrentCamera
        local root = getRoot()
        if not camera or not root then return end
        local ray = camera:ScreenPointToRay(x, y)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = { player.Character, espFolder }
        local result = Workspace:Raycast(ray.Origin, ray.Direction * 2000, params)
        if result then
            root.CFrame = CFrame.new(result.Position + Vector3.new(0, 3.5, 0))
        end
    end
    bind(UIS.InputBegan, function(input, processed)
        if processed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            clickTeleport(input.Position.X, input.Position.Y)
        end
    end)
    bind(UIS.TouchTap, function(positions, processed)
        if processed or not positions[1] then return end
        clickTeleport(positions[1].X, positions[1].Y)
    end)

    -- PC hotkeys: F fly, N noclip, V esp
    bind(UIS.InputBegan, function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.F then
            state.flying = not state.flying
            setFly(state.flying)
            toast("FLY" .. (state.flying and "  ON" or "  OFF"))
        elseif input.KeyCode == Enum.KeyCode.N then
            state.noclip = not state.noclip
            toggleRefs.noclip()
            toast("NOCLIP" .. (state.noclip and "  ON" or "  OFF"))
        elseif input.KeyCode == Enum.KeyCode.V then
            state.esp = not state.esp
            toggleRefs.esp()
            updateEsp()
            toast("ESP" .. (state.esp and "  ON" or "  OFF"))
        end
    end)
end

-- ========== Page: USERS (spectate / teleport) ==========
do
    local page = pages.USERS
    createHeader(page, "PLAYERS IN SERVER")

    local emptyLabel = makeText(page, "No other players in the server", 12,
        Enum.Font.GothamMedium, C.sub)
    emptyLabel.Size = UDim2.new(1, -6, 0, 40)

    local function updateEmpty()
        emptyLabel.Visible = next(playerRows) == nil
    end

    local function miniButton(parent, text, pos, size)
        local holder = Instance.new("Frame")
        holder.Position = pos
        holder.Size = size
        holder.BackgroundTransparency = 1
        holder.Parent = parent
        local btn = Instance.new("TextButton")
        btn.AnchorPoint = Vector2.new(0.5, 0.5)
        btn.Position = UDim2.fromScale(0.5, 0.5)
        btn.Size = UDim2.fromScale(1, 1)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.Parent = holder
        local bg = surface(btn, 10, 0.86)
        local lbl = makeText(btn, text, 11, Enum.Font.GothamBold)
        pressable(btn, bg)
        return btn, lbl, bg
    end

    local function addRow(plr)
        if plr == player or playerRows[plr] then return end

        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -6, 0, 72)
        row.BackgroundTransparency = 1
        row.Parent = page
        surface(row, 14, 0.88)

        local nameLabel = makeText(row, plr.DisplayName .. "  (@" .. plr.Name .. ")", 13,
            Enum.Font.GothamSemibold, C.text, Enum.TextXAlignment.Left)
        nameLabel.Position = UDim2.fromOffset(14, 6)
        nameLabel.Size = UDim2.new(1, -28, 0, 20)

        local specBtn, specLabel, specBg = miniButton(row, "SPECTATE",
            UDim2.new(0, 12, 0, 34), UDim2.new(0.5, -16, 0, 28))
        local tpBtn = miniButton(row, "TELEPORT",
            UDim2.new(0.5, 4, 0, 34), UDim2.new(0.5, -16, 0, 28))

        playerRows[plr] = { row = row, specLabel = specLabel, specBg = specBg }

        specBtn.Activated:Connect(function()
            if spectating == plr then
                stopSpectate()
                toast("Spectate off")
            else
                spectating = plr
                refreshSpectateLabels()
                toast("Spectating " .. plr.DisplayName)
            end
        end)

        tpBtn.Activated:Connect(function()
            local root = getRoot()
            local tchar = plr.Character
            local troot = tchar and tchar:FindFirstChild("HumanoidRootPart")
            if root and troot then
                root.CFrame = troot.CFrame * CFrame.new(0, 0, 3)
                toast("Teleported to " .. plr.DisplayName)
            else
                toast("Target unavailable")
            end
        end)

        updateEmpty()
    end

    local function removeRow(plr)
        local r = playerRows[plr]
        if not r then return end
        if spectating == plr then stopSpectate() end
        r.row:Destroy()
        playerRows[plr] = nil
        updateEmpty()
    end

    for _, plr in ipairs(Players:GetPlayers()) do addRow(plr) end
    bind(Players.PlayerAdded, addRow)
    bind(Players.PlayerRemoving, removeRow)
    updateEmpty()
end

-- ========== Character lifecycle ==========
local function onCharacter(character)
    trackCharacter(character)
    state.up = false
    state.down = false
    if state.flying then
        state.flying = false
        if toggleRefs.flying then toggleRefs.flying() end
    end
    showFlyButtons(false)

    task.spawn(function()
        local hum = character:WaitForChild("Humanoid", 10)
        if not hum or player.Character ~= character then return end
        humDefaults = {
            walk = hum.WalkSpeed,
            useJump = hum.UseJumpPower,
            jump = hum.JumpHeight,
        }
        applyHumanoid()
    end)
end

bind(player.CharacterAdded, onCharacter)
if player.Character then
    onCharacter(player.Character)
end

showPage("MOVE", true)
setPanelOpen(true)
