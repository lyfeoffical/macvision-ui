local LyfeUI = {}
LyfeUI.__index = LyfeUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function LyfeUI.new(title)
    local self = setmetatable({}, LyfeUI)
    
    -- สร้าง ScreenGui
    self.Gui = Instance.new("ScreenGui")
    self.Gui.Name = "LyfeUI"
    self.Gui.Parent = game.CoreGui
    
    -- หน้าต่างหลัก (Main Window)
    self.Main = Instance.new("Frame")
    self.Main.Name = "Main"
    self.Main.Parent = self.Gui
    self.Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- สีดำมินิมอล
    self.Main.BorderSizePixel = 0
    self.Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    self.Main.Size = UDim2.new(0, 500, 0, 350)
    self.Main.ClipsDescendants = true
    
    -- ขอบเรืองแสง (Stroke)
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(0, 255, 200) -- สี Cyan แบบในรูป
    Stroke.Thickness = 1.5
    Stroke.Parent = self.Main

    -- มุมโค้ง
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = self.Main

    -- แถบเมนูด้านซ้าย (Sidebar)
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Name = "Sidebar"
    self.Sidebar.Parent = self.Main
    self.Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    self.Sidebar.Size = UDim2.new(0, 130, 1, 0)
    self.Sidebar.BorderSizePixel = 0

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 10)
    SidebarCorner.Parent = self.Sidebar

    -- พื้นที่แสดงเนื้อหาด้านขวา (Container)
    self.Container = Instance.new("Frame")
    self.Container.Name = "Container"
    self.Container.Parent = self.Main
    self.Container.BackgroundTransparency = 1
    self.Container.Position = UDim2.new(0, 140, 0, 10)
    self.Container.Size = UDim2.new(1, -150, 1, -20)

    -- ใส่ชื่อโปรเจกต์
    local Title = Instance.new("TextLabel")
    Title.Parent = self.Sidebar
    Title.Text = title
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14

    -- Animation ตอนเปิด
    self.Main.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(self.Main, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 500, 0, 350)}):Play()

    return self
end

-- ฟังก์ชันสร้าง Tab (ทำให้ปุ่มไปโผล่ด้านซ้าย)
function LyfeUI:Tab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Parent = self.Sidebar
    -- (ในนี้ต้องมีโค้ดจัดการ Layout และการสลับหน้าจอ ซึ่งจะยาวมาก)
    -- ผมใส่ตัวอย่างปุ่มไว้ให้ดูว่ามันจะไม่โล่ง
    TabButton.Size = UDim2.new(0.9, 0, 0, 30)
    TabButton.Position = UDim2.new(0.05, 0, 0, 50)
    TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.Font = Enum.Font.Gotham
    
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 5)
    bCorner.Parent = TabButton

    return {
        Button = function(_, text, callback)
            -- โค้ดสร้างปุ่มด้านขวา
        end
    }
end

return LyfeUI
