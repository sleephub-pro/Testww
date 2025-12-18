-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- ผู้เล่น
local Player = Players.LocalPlayer
local PlayerId = Player.UserId

-- สร้าง ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeySystemGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = game.CoreGui

-- สร้าง Frame หลัก
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- UI Corner
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Drop Shadow
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 20, 1, 20)
Shadow.Position = UDim2.new(0, -10, 0, -10)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.Parent = MainFrame

-- Gradient Background
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 127)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255))
}
Gradient.Rotation = 45
Gradient.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SLRRP HUB v1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Subtitle
local Subtitle = Instance.new("TextLabel")
Subtitle.Name = "Subtitle"
Subtitle.Size = UDim2.new(1, 0, 0, 20)
Subtitle.Position = UDim2.new(0, 0, 0, 30)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "ระบบยืนยันคีย์และ HWID"
Subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
Subtitle.TextSize = 14
Subtitle.Font = Enum.Font.Gotham
Subtitle.Parent = MainFrame

-- HWID Display
local HWIDLabel = Instance.new("TextLabel")
HWIDLabel.Name = "HWIDLabel"
HWIDLabel.Size = UDim2.new(1, -40, 0, 30)
HWIDLabel.Position = UDim2.new(0, 20, 0, 70)
HWIDLabel.BackgroundTransparency = 1
HWIDLabel.Text = "กำลังดึง HWID..."
HWIDLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HWIDLabel.TextSize = 12
HWIDLabel.Font = Enum.Font.Code
HWIDLabel.Parent = MainFrame

-- Key Input
local KeyBox = Instance.new("TextBox")
KeyBox.Name = "KeyBox"
KeyBox.Size = UDim2.new(1, -60, 0, 40)
KeyBox.Position = UDim2.new(0, 30, 0, 120)
KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
KeyBox.BorderSizePixel = 0
KeyBox.PlaceholderText = "กรอกคีย์ของคุณที่นี่..."
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.TextSize = 16
KeyBox.Font = Enum.Font.Gotham
KeyBox.Parent = MainFrame

local KeyBoxCorner = Instance.new("UICorner")
KeyBoxCorner.CornerRadius = UDim.new(0, 8)
KeyBoxCorner.Parent = KeyBox

-- Verify Button
local VerifyButton = Instance.new("TextButton")
VerifyButton.Name = "VerifyButton"
VerifyButton.Size = UDim2.new(1, -60, 0, 45)
VerifyButton.Position = UDim2.new(0, 30, 0, 180)
VerifyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
VerifyButton.BorderSizePixel = 0
VerifyButton.Text = "VERIFY KEY"
VerifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
VerifyButton.TextSize = 18
VerifyButton.Font = Enum.Font.GothamBold
VerifyButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = VerifyButton

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, -40, 0, 30)
StatusLabel.Position = UDim2.new(0, 20, 0, 240)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "สถานะ: รอการตรวจสอบ"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = MainFrame

-- เอฟเฟกต์ Loading
local LoadingRing = Instance.new("ImageLabel")
LoadingRing.Name = "LoadingRing"
LoadingRing.Size = UDim2.new(0, 40, 0, 40)
LoadingRing.Position = UDim2.new(0.5, -20, 0.5, 50)
LoadingRing.BackgroundTransparency = 1
LoadingRing.Image = "rbxassetid://3926307971"
LoadingRing.ImageRectOffset = Vector2.new(0, 0)
LoadingRing.ImageRectSize = Vector2.new(0, 0)
LoadingRing.ImageColor3 = Color3.fromRGB(255, 255, 255)
LoadingRing.Visible = false
LoadingRing.Parent = MainFrame

-- Animation Tween
local function Tween(object, properties, duration)
    local tweenInfo = TweenInfo.new(
        duration,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- สร้าง HWID และระบบ Save
local function GetHWID()
    -- สร้าง HWID จาก PC Info ใน Roblox
    local hwid = tostring(PlayerId) .. "-" .. game.PlaceId .. "-" .. Player.AccountAge
    hwid = HttpService:GenerateGUID(false)
    return hwid
end

local function SaveKeyData(key, hwid)
    if writefile then
        local data = {
            Key = key,
            HWID = hwid,
            Timestamp = os.time()
        }
        writefile("SLRRP_HUB_key.json", HttpService:JSONEncode(data))
    end
end

local function LoadKeyData()
    if readfile then
        local success, data = pcall(function()
            return readfile("SLRRP_HUB_key.json")
        end)
        if success then
            return HttpService:JSONDecode(data)
        end
    end
    return nil
end

-- ตรวจสอบ HWID
local CurrentHWID = GetHWID()
HWIDLabel.Text = "HWID: " .. string.sub(CurrentHWID, 1, 20) .. "..."

-- ตรวจสอบ Key ที่บันทึกไว้
local SavedData = LoadKeyData()
if SavedData and SavedData.HWID == CurrentHWID then
    -- ถ้า HWID ตรงให้ผ่านเลย
    StatusLabel.Text = "สถานะ: HWID ตรง กำลังโหลด..."
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    wait(1)
    ScreenGui:Destroy()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/sleephub-pro/SLRRP-HUBV1/refs/heads/main/SLRRP-HUBV1"))()
else
    -- แสดง UI สำหรับกรอก Key
    MainFrame.Visible = true
end

-- ตรวจสอบ Key (ตัวอย่าง)
local function VerifyKey(key)
    -- คุณสามารถเพิ่มระบบเช็ค Key จากเซิร์ฟเวอร์ได้ที่นี่
    local validKeys = {
        ["SLRRP-PRO-2024"] = true,
        ["PREMIUM-ACCESS-KEY"] = true
    }
    return validKeys[key] or false
end

-- Verify Button Click
VerifyButton.MouseButton1Click:Connect(function()
    local key = KeyBox.Text
    if key == "" then
        StatusLabel.Text = "สถานะ: กรุณากรอกคีย์!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    -- แสดง Loading
    LoadingRing.Visible = true
    Tween(LoadingRing, {Rotation = 360}, 1).Completed:Connect(function()
        LoadingRing.Rotation = 0
    end)
    
    StatusLabel.Text = "สถานะ: กำลังตรวจสอบ..."
    StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    
    wait(2) -- จำลองการตรวจสอบ
    
    if VerifyKey(key) then
        StatusLabel.Text = "สถานะ: ยืนยันสำเร็จ!"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        SaveKeyData(key, CurrentHWID)
        
        -- เอฟเฟกต์สำเร็จ
        Tween(MainFrame, {Size = UDim2.new(0, 460, 0, 310)}, 0.2)
        wait(0.5)
        
        -- ปิด UI และโหลดสคริปต์
        Tween(MainFrame, {BackgroundTransparency = 1}, 0.5).Completed:Connect(function()
            Tween(Title, {TextTransparency = 1}, 0.3)
            Tween(Subtitle, {TextTransparency = 1}, 0.3)
            Tween(KeyBox, {TextTransparency = 1}, 0.3)
            Tween(VerifyButton, {TextTransparency = 1}, 0.3)
        end)
        
        wait(1)
        ScreenGui:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/sleephub-pro/SLRRP-HUBV1/refs/heads/main/SLRRP-HUBV1"))()
    else
        StatusLabel.Text = "สถานะ: คีย์ไม่ถูกต้อง!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        LoadingRing.Visible = false
        
        -- เอฟเฟกต์ผิดพลาด
        Tween(MainFrame, {Position = UDim2.new(0.5, -225, 0.5, -145)}, 0.1).Completed:Connect(function()
            Tween(MainFrame, {Position = UDim2.new(0.5, -225, 0.5, -155)}, 0.1).Completed:Connect(function()
                Tween(MainFrame, {Position = UDim2.new(0.5, -225, 0.5, -150)}, 0.1)
            end)
        end)
    end
end)

-- เอฟเฟกต์ Hover ปุ่ม
VerifyButton.MouseEnter:Connect(function()
    Tween(VerifyButton, {BackgroundColor3 = Color3.fromRGB(255, 50, 150)}, 0.3)
end)

VerifyButton.MouseLeave:Connect(function()
    Tween(VerifyButton, {BackgroundColor3 = Color3.fromRGB(0, 170, 255)}, 0.3)
end)

-- เอฟเฟกต์ Gradient เคลื่อนไหว
spawn(function()
    while true do
        for i = 0, 360, 2 do
            Gradient.Rotation = i
            wait(0.05)
        end
    end
end)

-- แอนิเมชันเริ่มต้น
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.BackgroundTransparency = 1
Tween(MainFrame, {Size = UDim2.new(0, 450, 0, 300), BackgroundTransparency = 0}, 0.7)

print("ระบบ Key & HWID โหลดสำเร็จ!")
