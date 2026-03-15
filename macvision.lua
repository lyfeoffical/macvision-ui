--[[
    Lyfe UI Library - Premium Edition
    Based on Fluent UI for Animations & Acrylic Effects
    
    [SETTINGS]
    - Theme: Dark (Minimal Black)
    - Background: Acrylic (Blur effect)
    - Animations: Enabled by default
]]

-- ดึง Fluent UI Library ต้นฉบับมาเป็นฐาน (เพื่อให้ได้ Animation/Acrylic)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local LyfeUI = {}
LyfeUI.__index = LyfeUI

-- ข้อมูลเบื้องต้นของผู้เล่น (สำหรับโชว์ Profile)
local Player = game.Players.LocalPlayer
local UserId = Player.UserId
local DisplayName = Player.DisplayName
local ProfileThumbnail = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. UserId .. "&width=420&height=420&format=png"

-- ==========================================
-- [MAIN] ฟังก์ชันสร้าง Window หลัก
-- ==========================================
function LyfeUI.new(config)
    local self = setmetatable({}, LyfeUI)
    
    -- ตั้งค่าเริ่มต้นหากไม่มีการส่งค่ามา
    local title = config.Title or "Lyfe UI Premium"
    local subtitle = config.SubTitle or "by Lyfe Developer"
    
    -- แจ้งเตือนตอนเริ่ม (Loading Notification)
    Fluent:Notify({
        Title = "🚀 " .. title,
        Content = "กำลังโหลดข้อมูลสำหรับ: " .. DisplayName,
        Duration = 3
    })
    
    -- สร้าง Window หลัก (Fluent Settings)
    self.Window = Fluent:CreateWindow({
        Title = title,
        SubTitle = subtitle,
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = true, -- [FEATURE] พื้นหลังจางๆ/เบลอ (สวยมินิมอล)
        Theme = "Dark", -- [FEATURE] สีดำมินิมอล
        MinimizeKey = Enum.KeyCode.LeftControl -- ปุ่มย่อเมนู
    })
    
    -- สร้าง Tab อัตโนมัติ: หน้า Home/Profile
    self.HomeTab = self.Window:AddTab({ Title = "Dashboard", Icon = "home" })
    
    -- แสดง Profile ผู้เล่นในหน้า Home
    self.HomeTab:AddParagraph({
        Title = "ยินดีต้อนรับ,",
        Content = DisplayName .. " (@" .. Player.Name .. ")\nUserID: " .. UserId
    })
    
    -- เพิ่มระบบ Save Config พื้นฐานในหน้า Home
    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({})
    
    return self
end

-- ==========================================
-- [TAB] ฟังก์ชันสร้าง Tab ใหม่
-- ==========================================
function LyfeUI:Tab(name, icon)
    local tabObj = {}
    tabObj.Tab = self.Window:AddTab({ Title = name, Icon = icon or "zap" }) -- Default Icon คือสายฟ้า
    
    -- ------------------------------------------
    -- [ELEMENT] ฟังก์ชันสร้าง Button ใน Tab
    -- ------------------------------------------
    function tabObj:Button(name, description, callback)
        return self.Tab:AddButton({
            Title = name,
            Description = description or "คลิกเพื่อใช้งาน", -- มินิมอลมักจะมีคำอธิบายสั้นๆ
            Callback = callback
        })
    end
    
    -- ------------------------------------------
    -- [ELEMENT] ฟังก์ชันสร้าง Toggle (เปิด/ปิด)
    -- ------------------------------------------
    function tabObj:Toggle(name, default, callback)
        return self.Tab:AddToggle(name, {
            Title = name,
            Default = default or false,
            Callback = callback
        })
    end

    -- ------------------------------------------
    -- [ELEMENT] ฟังก์ชันสร้าง Slider
    -- ------------------------------------------
    function tabObj:Slider(name, min, max, default, callback)
        return self.Tab:AddSlider(name, {
            Title = name,
            Default = default or min,
            Min = min,
            Max = max,
            Rounding = 1, -- ปรับให้เป็นเลขจำนวนเต็ม
            Callback = callback
        })
    end

    -- ------------------------------------------
    -- [ELEMENT] ฟังก์ชันสร้าง Dropdown
    -- ------------------------------------------
    function tabObj:Dropdown(name, options, default, callback)
        return self.Tab:AddDropdown(name, {
            Title = name,
            Values = options,
            Multi = false, -- เลือกได้ทีละอัน (มินิมอล)
            Default = default or options[1],
            Callback = callback
        })
    end
    
    -- ------------------------------------------
    -- [ELEMENT] ฟังก์ชันสร้าง Input (ช่องกรอก)
    -- ------------------------------------------
    function tabObj:Input(name, placeholder, callback)
        return self.Tab:AddInput(name, {
            Title = name,
            Placeholder = placeholder or "กรอกข้อมูลที่นี่...",
            Callback = callback
        })
    end

    return tabObj
end

-- ==========================================
-- [UTILS] ฟังก์ชันเสริม (Global Utility)
-- ==========================================

-- ฟังก์ชันแจ้งเตือน (Notification)
function LyfeUI:Notify(title, text, duration)
    Fluent:Notify({
        Title = title or "Notification",
        Content = text or "No Message",
        Duration = duration or 3
    })
end

-- ฟังก์ชันปิด UI ทั้งหมด
function LyfeUI:Destroy()
    Fluent:Destroy()
end

-- สั่งให้ Window แสดงผล TAB แรกสุดเสมอเมื่อโหลดเสร็จ
function LyfeUI:Init()
    self.Window:SelectTab(1)
end

return LyfeUI
