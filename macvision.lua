local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local LyfeUI = {}
LyfeUI.__index = LyfeUI

function LyfeUI.new(title)
    local self = setmetatable({}, LyfeUI)
    
    -- สร้าง Window หลัก
    self.Window = Fluent:CreateWindow({
        Title = title or "Lyfe UI Premium",
        SubTitle = "by Lyfe Developer",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })
    
    return self
end

-- ฟังก์ชันสร้าง Tab
function LyfeUI:Tab(name, icon)
    local tabObj = {}
    tabObj.Tab = self.Window:AddTab({ Title = name, Icon = icon or "rbxassetid://4483345998" })
    
    -- ฟังก์ชันสร้าง Button ใน Tab
    function tabObj:Button(name, callback)
        return self.Tab:AddButton({
            Title = name,
            Description = "คลิกเพื่อใช้งาน",
            Callback = callback
        })
    end
    
    -- ฟังก์ชันสร้าง Slider ใน Tab
    function tabObj:Slider(name, min, max, callback)
        return self.Tab:AddSlider(name, {
            Title = name,
            Default = min,
            Min = min,
            Max = max,
            Rounding = 1,
            Callback = callback
        })
    end

    -- ฟังก์ชันสร้าง Dropdown ใน Tab
    function tabObj:Dropdown(name, options, callback)
        return self.Tab:AddDropdown(name, {
            Title = name,
            Values = options,
            Multi = false,
            Default = options[1],
            Callback = callback
        })
    end
    
    return tabObj
end

-- ฟังก์ชันแจ้งเตือน (Global)
function LyfeUI.Notify(text)
    Fluent:Notify({
        Title = "Notification",
        Content = text,
        Duration = 3
    })
end

return LyfeUI
