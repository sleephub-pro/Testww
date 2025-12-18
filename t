--[[
    🔐 KEY + HWID SYSTEM (CLIENT SIDE)
    Theme: Blue / Purple Neon
    Features:
    - Key GUI
    - HWID Lock (binds after first success)
    - Save Key + HWID using writefile
    - Fancy tween / glow
    - Auto login if HWID + Key match
]]

--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

--// CONFIG
local VALID_KEYS = {
    ["11"] = true, -- <<== ใส่คีย์ที่ต้องการ
}

local SAVE_FILE = "SleepHub_KeySystem.json"
local SCRIPT_URL = "https://raw.githubusercontent.com/sleephub-pro/SLRRP-HUBV1/refs/heads/main/SLRRP-HUBV1"

--// HWID FUNCTION (Executor based)
local function getHWID()
    if syn and syn.gethwid then
        return syn.gethwid()
    elseif gethwid then
        return gethwid()
    else
        return tostring(game:GetService("RbxAnalyticsService"):GetClientId())
    end
end

local HWID = getHWID()

--// LOAD SAVE
local SavedData
if isfile(SAVE_FILE) then
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(SAVE_FILE))
    end)
    if success then
        SavedData = data
    end
end

--// AUTO LOGIN
if SavedData and SavedData.Key and SavedData.HWID then
    if VALID_KEYS[SavedData.Key] and SavedData.HWID == HWID then
        loadstring(game:HttpGet(SCRIPT_URL))()
        return
    end
end

--// GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SleepHubKeySystem"

gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.35, 0.4)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(20,20,30)
main.BorderSizePixel = 0
main.ClipsDescendants = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0,18)

--// GLOW
local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(120,80,255)

--// TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0.2,0)
title.BackgroundTransparency = 1
title.Text = "🔑 SLEEP HUB KEY SYSTEM"
title.TextColor3 = Color3.fromRGB(180,140,255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

--// INPUT
local box = Instance.new("TextBox", main)
box.Size = UDim2.fromScale(0.8,0.2)
box.Position = UDim2.fromScale(0.1,0.35)
box.PlaceholderText = "Enter Key"
box.Text = ""
box.Font = Enum.Font.Gotham
box.TextScaled = true
box.BackgroundColor3 = Color3.fromRGB(30,30,45)
box.TextColor3 = Color3.fromRGB(220,220,255)
Instance.new("UICorner", box).CornerRadius = UDim.new(0,12)

--// BUTTON
local btn = Instance.new("TextButton", main)
btn.Size = UDim2.fromScale(0.6,0.18)
btn.Position = UDim2.fromScale(0.2,0.65)
btn.Text = "VERIFY"
btn.Font = Enum.Font.GothamBold
btn.TextScaled = true
btn.BackgroundColor3 = Color3.fromRGB(80,60,200)
btn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btn).CornerRadius = UDim.new(0,14)

--// STATUS
local status = Instance.new("TextLabel", main)
status.Size = UDim2.fromScale(1,0.15)
status.Position = UDim2.fromScale(0,0.85)
status.BackgroundTransparency = 1
status.Text = ""
status.Font = Enum.Font.Gotham
status.TextScaled = true
status.TextColor3 = Color3.fromRGB(255,100,100)

--// TWEEN
local function notify(text,color)
    status.Text = text
    status.TextColor3 = color
    status.TextTransparency = 1
    TweenService:Create(status, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
end

--// VERIFY
btn.MouseButton1Click:Connect(function()
    local key = box.Text

    if not VALID_KEYS[key] then
        notify("❌ INVALID KEY", Color3.fromRGB(255,90,90))
        return
    end

    -- SAVE
    writefile(SAVE_FILE, HttpService:JSONEncode({
        Key = key,
        HWID = HWID
    }))

    notify("✅ VERIFIED", Color3.fromRGB(120,255,120))

    TweenService:Create(main, TweenInfo.new(0.4), {Size = UDim2.fromScale(0,0)}):Play()
    task.wait(0.4)
    gui:Destroy()

    loadstring(game:HttpGet(SCRIPT_URL))()
end)

--// INTRO ANIM
main.Size = UDim2.fromScale(0,0)
TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.fromScale(0.35,0.4)}):Play()
