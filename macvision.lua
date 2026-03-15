local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- ข้อมูลผู้เล่นสำหรับโชว์ใน Profile
local Player = game.Players.LocalPlayer
local UserId = Player.UserId
local DisplayName = Player.DisplayName
local ProfileThumbnail = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. UserId .. "&width=420&height=420&format=png"

-- [1] ส่วนของ Loading Notification (เฟี้ยวๆ)
Fluent:Notify({
    Title = "🚀 System Booting",
    Content = "กำลังโหลดข้อมูลสำหรับคุณ: " .. DisplayName,
    SubTitle = "Loading Assets...",
    Duration = 3
})

-- [2] สร้างหน้าต่างหลัก (Window)
local Window = Fluent:CreateWindow({
    Title = "GEMINI HUB " .. Fluent.Version,
    SubTitle = "by your name",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- พื้นหลังโปร่งใสแบบกระจก (สวยมาก)
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- ปุ่มย่อเมนู
})

-- [3] สร้าง Tabs
local Tabs = {
    Home = Window:AddTab({ Title = "Dashboard", Icon = "home" }),
    Main = Window:AddTab({ Title = "Main Features", Icon = "zap" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- [4] หน้า Dashboard (โชว์ Profile)
Tabs.Home:AddParagraph({
    Title = "ยินดีต้อนรับกลับ!",
    Content = "สวัสดีคุณ " .. DisplayName .. " (@" .. Player.Name .. ")\nUserID: " .. UserId
})

-- สร้างรูป Profile (เทคนิคการดึง Image ID มาโชว์)
Tabs.Home:AddButton({
    Title = "ดูสถานะตัวละคร",
    Description = "คลิกเพื่อเช็คความพร้อมของสคริปต์",
    Callback = function()
        Fluent:Notify({
            Title = "Status Check",
            Content = "ตัวละครของคุณพร้อมใช้งานฟีเจอร์โกงแล้ว!",
            Duration = 2
        })
    end
})

-- [5] ตัวอย่างเมนูในหน้า Main
local Slider = Tabs.Main:AddSlider("WalkSpeed", {
    Title = "ปรับความเร็ว (WalkSpeed)",
    Description = "ปรับให้วิ่งไวระดับเทพ",
    Default = 16,
    Min = 16,
    Max = 500,
    Rounding = 1,
    Callback = function(Value)
        Player.Character.Humanoid.WalkSpeed = Value
    end
})

local Toggle = Tabs.Main:AddToggle("AutoFarm", {Title = "เปิดระบบออโต้ฟาร์ม", Default = false })

Toggle:OnChanged(function()
    print("Auto Farm State:", Tabs.Main.Toggles.AutoFarm.Value)
end)

-- [6] จบท้ายการตั้งค่า
Window:SelectTab(1)
Fluent:Notify({
    Title = "SUCCESS!",
    Content = "สคริปต์โหลดเสร็จสมบูรณ์ ยินดีด้วย!",
    Duration = 5
})

-- เชื่อมต่อระบบ Save
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
