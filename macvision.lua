-- [[ LYFE UI PREMIUM - FULL SCRIPT ]] --
-- Base: MacVision (Fluent)
-- Features: Custom Loading, Profile System, Smooth Animations

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local PlayerImage = "rbxthumb://type=AvatarHeadShot&id=" .. Player.UserId .. "&w=150&h=150"

-- =========================================================
-- [PART 1] LOADING SCREEN (INTRO)
-- =========================================================
local LoaderGui = Instance.new("ScreenGui")
LoaderGui.Name = "LyfeLoader"
LoaderGui.IgnoreGuiInset = true
LoaderGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10) -- ดำมินิมอล
MainFrame.BorderSizePixel = 0
MainFrame.Parent = LoaderGui

-- รูปโปรไฟล์ผู้เล่น
local ProfileFrame = Instance.new("ImageLabel")
ProfileFrame.Size = UDim2.new(0, 0, 0, 0) -- เริ่มต้นจากศูนย์เพื่อทำ Pop-up
ProfileFrame.Position = UDim2.new(0.5, 0, 0.45, 0)
ProfileFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ProfileFrame.Image = PlayerImage
ProfileFrame.BackgroundTransparency = 1
ProfileFrame.ZIndex = 2
ProfileFrame.Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ProfileFrame

-- ขอบเรืองแสงสำหรับรูปโปรไฟล์
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 200) -- สี Cyan
UIStroke.Thickness = 2
UIStroke.Transparency = 1
UIStroke.Parent = ProfileFrame

local LoadingText = Instance.new("TextLabel")
LoadingText.Size = UDim2.new(0, 200, 0, 50)
LoadingText.Position = UDim2.new(0.5, 0, 0.6, 0)
LoadingText.AnchorPoint = Vector2.new(0.5, 0.5)
LoadingText.BackgroundTransparency = 1
LoadingText.Text = "PREPARING SYSTEM..."
LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingText.Font = Enum.Font.GothamBold
LoadingText.TextSize = 14
LoadingText.TextTransparency = 1
LoadingText.Parent = MainFrame

-- [ANIMATION START]
task.spawn(function()
    -- รูปเด้ง Pop-up
    TweenService:Create(ProfileFrame, TweenInfo.new(0.8, Enum.EasingStyle.Back), {Size = UDim2.new(0, 120, 0, 120)}):Play()
    TweenService:Create(UIStroke, TweenInfo.new(0.8), {Transparency = 0}):Play()
    task.wait(0.5)
    
    -- ข้อความค่อยๆ ขึ้น
    TweenService:Create(LoadingText, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    task.wait(2) -- ระยะเวลาหน้าโหลด
    
    -- จางหาย (Fade Out)
    TweenService:Create(LoadingText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(ProfileFrame, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
    TweenService:Create(UIStroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
    
    local FinalTween = TweenService:Create(MainFrame, TweenInfo.new(0.8), {BackgroundTransparency = 1})
    FinalTween:Play()
    FinalTween.Completed:Connect(function()
        LoaderGui:Destroy()
    end)
end)

-- =========================================================
-- [PART 2] MAIN UI SYSTEM (MACVISION / FLUENT)
-- =========================================================
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/lyfeoffical/macvision-ui/refs/heads/main/macvision.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Lyfe UI Premium",
    SubTitle = "Vision Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- พื้นหลังเบลอจางๆ (สวยมาก)
    Theme = "Dark", -- สีดำมินิมอล
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- สร้าง Tabs
local Tabs = {
    Home = Window:AddTab({ Title = "Dashboard", Icon = "home" }),
    Main = Window:AddTab({ Title = "Features", Icon = "zap" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- [หน้า DASHBOARD]
Tabs.Home:AddParagraph({
    Title = "WELCOME, " .. Player.DisplayName:upper(),
    Content = "Username: " .. Player.Name .. "\nUserID: " .. Player.UserId .. "\nStatus: Premium Active"
})

Tabs.Home:AddButton({
    Title = "Sync Profile",
    Description = "กดเพื่อรีเฟรชข้อมูลตัวละคร",
    Callback = function()
        Fluent:Notify({
            Title = "System",
            Content = "Data synchronized with server.",
            Duration = 3
        })
    end
})

-- [หน้า FEATURES]
Tabs.Main:AddSection("Movement")

Tabs.Main:AddSlider("WalkSpeed", {
    Title = "Speed Hack",
    Description = "ปรับความเร็วการวิ่ง",
    Default = 16,
    Min = 16,
    Max = 500,
    Rounding = 1,
    Callback = function(Value)
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = Value
        end
    end
})

Tabs.Main:AddToggle("InfJump", {
    Title = "Infinite Jump",
    Description = "กระโดดได้รัวๆ ไม่ตกดิน",
    Default = false,
    Callback = function(Value)
        _G.InfJump = Value
    end
})

-- ฟังก์ชันกระโดดไม่จำกัด
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
        Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- [จบการตั้งค่า]
Window:SelectTab(1)

-- แจ้งเตือนเมื่อ UI พร้อม
Fluent:Notify({
    Title = "Lyfe UI",
    Content = "Script has been loaded successfully!",
    Duration = 5
})
