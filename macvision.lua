-- lyfeui (Pro Edition) - Futuristic & Sleek Design
-- Toggle Key: LeftAlt

local lyfeui = {}

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- [[ CONFIGURATION ]] --
local THEME = {
    Background = Color3.fromRGB(10, 10, 15),
    Sidebar = Color3.fromRGB(5, 5, 8),
    Accent = Color3.fromRGB(0, 255, 255), -- Cyan Neon
    AccentGlow = Color3.fromRGB(0, 200, 200),
    Text = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(150, 150, 150),
    Element = Color3.fromRGB(20, 20, 30),
    ElementStroke = Color3.fromRGB(40, 40, 60)
}

-- [[ UTILS ]] --
local function CreateTween(obj, info, goals)
    local tween = TweenService:Create(obj, info, goals)
    tween:Play()
    return tween
end

local function PowerOnAnim(gui)
    gui.Size = UDim2.new(0, 0, 0, 2)
    gui.BackgroundTransparency = 1
    CreateTween(gui, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 2), BackgroundTransparency = 0})
    task.wait(0.4)
    CreateTween(gui, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 400)})
end

local function RippleEffect(obj)
    spawn(function()
        local ripple = Instance.new("Frame")
        ripple.Name = "Ripple"
        ripple.Parent = obj
        ripple.BackgroundColor3 = THEME.Accent
        ripple.BackgroundTransparency = 0.6
        ripple.ZIndex = 10
        ripple.Position = UDim2.new(0, mouse.X - obj.AbsolutePosition.X, 0, mouse.Y - obj.AbsolutePosition.Y)
        
        Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)
        
        CreateTween(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 400, 0, 400),
            Position = UDim2.new(0, (mouse.X - obj.AbsolutePosition.X) - 200, 0, (mouse.Y - obj.AbsolutePosition.Y) - 200),
            BackgroundTransparency = 1
        })
        task.wait(0.5)
        ripple:Destroy()
    end)
end

-------------------------------------------------
-- CREATE WINDOW
-------------------------------------------------
function lyfeui.new(title)
    local gui = Instance.new("ScreenGui")
    gui.Name = "lyfeui_Pro"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    -- Main Window
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 600, 0, 400)
    main.Position = UDim2.new(0.5, -300, 0.5, -200)
    main.BackgroundColor3 = THEME.Background
    main.ClipsDescendants = true
    main.Parent = gui
    
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = THEME.Accent
    mainStroke.Thickness = 1
    mainStroke.Transparency = 0.5

    -- Power On Animation
    PowerOnAnim(main)

    -- Make Draggable (Sleek)
    local dragging, dragStart, startPos
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            CreateTween(mainStroke, TweenInfo.new(0.2), {Transparency = 0, Thickness = 1.5})
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            CreateTween(mainStroke, TweenInfo.new(0.2), {Transparency = 0.5, Thickness = 1})
        end
    end)

    -- Toggle (LeftAlt) with Anim
    UIS.InputBegan:Connect(function(i, g)
        if g then return end
        if i.KeyCode == Enum.KeyCode.LeftAlt then
            if main.Visible then
                CreateTween(main, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.new(0, 600, 0, 0)}).Completed:Wait()
                main.Visible = false
            else
                main.Visible = true
                CreateTween(main, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 400)})
            end
        end
    end)

    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 170, 1, 0)
    sidebar.BackgroundColor3 = THEME.Sidebar
    sidebar.BorderSizePixel = 0
    sidebar.Parent = main
    
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)
    local sideStroke = Instance.new("UIStroke", sidebar)
    sideStroke.Color = THEME.ElementStroke
    sideStroke.Thickness = 1

    -- Title (Neon Glow)
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title or "LYFE // PRO"
    titleLabel.Size = UDim2.new(1, -20, 0, 60)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 22
    titleLabel.TextColor3 = THEME.Accent
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = sidebar
    
    local titleGlow = Instance.new("TextLabel") -- Glow Effect
    titleGlow.Text = titleLabel.Text
    titleGlow.Size = titleLabel.Size
    titleGlow.Position = UDim2.new(0, 0, 0, 2)
    titleGlow.BackgroundTransparency = 1
    titleGlow.Font = titleLabel.Font
    titleGlow.TextSize = titleLabel.TextSize
    titleGlow.TextColor3 = THEME.AccentGlow
    titleGlow.TextTransparency = 0.5
    titleGlow.TextXAlignment = titleLabel.TextXAlignment
    titleGlow.ZIndex = titleLabel.ZIndex - 1
    titleGlow.Parent = titleLabel

    -- Tab Container
    local tabScroll = Instance.new("ScrollingFrame")
    tabScroll.Size = UDim2.new(1, 0, 1, -70)
    tabScroll.Position = UDim2.new(0, 0, 0, 70)
    tabScroll.BackgroundTransparency = 1
    tabScroll.ScrollBarThickness = 0
    tabScroll.Parent = sidebar

    Instance.new("UIListLayout", tabScroll).Padding = UDim.new(0, 5)
    Instance.new("UIPadding", tabScroll).PaddingLeft = UDim.new(0, 10)

    -- Content Area
    local contentArea = Instance.new("Frame")
    contentArea.Name = "Content"
    contentArea.Size = UDim2.new(1, -180, 1, -20)
    contentArea.Position = UDim2.new(0, 180, 0, 10)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = main

-------------------------------------------------
-- TAB SYSTEM
-------------------------------------------------
    local window = {}
    local firstTab = true

    function window:Tab(name)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = name .. "_Tab"
        tabBtn.Size = UDim2.new(0, 150, 0, 40)
        tabBtn.BackgroundColor3 = THEME.Element
        tabBtn.BackgroundTransparency = 1
        tabBtn.Text = "  " .. name:upper()
        tabBtn.Font = Enum.Font.GothamMedium
        tabBtn.TextSize = 13
        tabBtn.TextColor3 = THEME.TextDark
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.AutoButtonColor = false
        tabBtn.ClipsDescendants = true
        tabBtn.Parent = tabScroll
        
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
        local tabStroke = Instance.new("UIStroke", tabBtn)
        tabStroke.Color = THEME.Accent
        tabStroke.Thickness = 1
        tabStroke.Transparency = 1 -- Hidden by default

        -- Active Indicator (Neon Line)
        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 2, 0.6, 0)
        indicator.Position = UDim2.new(0, 0, 0.2, 0)
        indicator.BackgroundColor3 = THEME.Accent
        indicator.BorderSizePixel = 0
        indicator.BackgroundTransparency = 1
        indicator.Parent = tabBtn

        local page = Instance.new("ScrollingFrame")
        page.Name = name .. "_Page"
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = THEME.Accent
        page.Parent = contentArea

        Instance.new("UIListLayout", page).Padding = UDim.new(0, 10)

        if firstTab then
            page.Visible = true
            tabBtn.BackgroundTransparency = 0.8
            tabBtn.TextColor3 = THEME.Accent
            indicator.BackgroundTransparency = 0
            tabStroke.Transparency = 0.8
            firstTab = false
        end

        tabBtn.MouseButton1Click:Connect(function()
            RippleEffect(tabBtn)
            for _, v in pairs(contentArea:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            for _, v in pairs(tabScroll:GetChildren()) do
                if v:IsA("TextButton") then
                    CreateTween(v, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextColor3 = THEME.TextDark})
                    CreateTween(v.UIStroke, TweenInfo.new(0.3), {Transparency = 1})
                    CreateTween(v.Frame, TweenInfo.new(0.3), {BackgroundTransparency = 1}) -- Indicator
                end
            end
            page.Visible = true
            CreateTween(tabBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0.8, TextColor3 = THEME.Accent})
            CreateTween(tabStroke, TweenInfo.new(0.3), {Transparency = 0.8})
            CreateTween(indicator, TweenInfo.new(0.3), {BackgroundTransparency = 0})
        end)

        local tab = {}

-------------------------------------------------
-- PRO ELEMENTS
-------------------------------------------------
        function tab:Button(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 45)
            btn.BackgroundColor3 = THEME.Element
            btn.Text = text:upper()
            btn.Font = Enum.Font.GothamBold
            btn.TextColor3 = THEME.Text
            btn.TextSize = 14
            btn.ClipsDescendants = true
            btn.AutoButtonColor = false
            btn.Parent = page
            
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            local btnStroke = Instance.new("UIStroke", btn)
            btnStroke.Color = THEME.ElementStroke
            btnStroke.Thickness = 1

            -- Hover Effect
            btn.MouseEnter:Connect(function() CreateTween(btnStroke, TweenInfo.new(0.2), {Color = THEME.Accent}) end)
            btn.MouseLeave:Connect(function() CreateTween(btnStroke, TweenInfo.new(0.2), {Color = THEME.ElementStroke}) end)

            btn.MouseButton1Click:Connect(function()
                RippleEffect(btn)
                callback()
            end)
        end

        function tab:Slider(text, min, max, default, callback)
            local sFrame = Instance.new("Frame")
            sFrame.Size = UDim2.new(1, -10, 0, 60)
            sFrame.BackgroundColor3 = THEME.Element
            sFrame.Parent = page
            Instance.new("UICorner", sFrame).CornerRadius = UDim.new(0, 6)
            Instance.new("UIStroke", sFrame).Color = THEME.ElementStroke

            local sLabel = Instance.new("TextLabel")
            sLabel.Text = text:upper() .. " [ " .. default .. " ]"
            sLabel.Size = UDim2.new(1, -20, 0, 30)
            sLabel.Position = UDim2.new(0, 10, 0, 5)
            sLabel.BackgroundTransparency = 1
            sLabel.Font = Enum.Font.GothamMedium
            sLabel.TextColor3 = THEME.TextDark
            sLabel.TextXAlignment = Enum.TextXAlignment.Left
            sLabel.Parent = sFrame

            local barBg = Instance.new("Frame")
            barBg.Size = UDim2.new(1, -20, 0, 8)
            barBg.Position = UDim2.new(0, 10, 0, 40)
            barBg.BackgroundColor3 = THEME.Sidebar
            barBg.Parent = sFrame
            Instance.new("UICorner", barBg)

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
            fill.BackgroundColor3 = THEME.Accent
            fill.Parent = barBg
            Instance.new("UICorner", fill)
            
            -- Glow on fill
            local fillGlow = Instance.new("Frame")
            fillGlow.Size = UDim2.new(1, 0, 1, 0)
            fillGlow.BackgroundColor3 = THEME.Accent
            fillGlow.BackgroundTransparency = 0.7
            fillGlow.BorderSizePixel = 0
            fillGlow.Parent = fill
            Instance.new("UICorner", fillGlow)

            local function update(input)
                local pos = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * pos)
                sLabel.Text = text:upper() .. " [ " .. val .. " ]"
                CreateTween(fill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(pos, 0, 1, 0)})
                callback(val)
            end

            local sliding = false
            barBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then 
                    sliding = true 
                    update(input) 
                    CreateTween(barBg, TweenInfo.new(0.2), {BackgroundColor3 = THEME.ElementStroke})
                end
            end)
            UIS.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
            end)
            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then 
                    sliding = false 
                    CreateTween(barBg, TweenInfo.new(0.2), {BackgroundColor3 = THEME.Sidebar})
                end
            end)
        end

        return tab
    end

    return window
end

return lyfeui
