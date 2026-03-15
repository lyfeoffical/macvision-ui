-- lyfeui Library (Modern Glassmorphism Edition)
-- Toggle Key: LeftAlt

local lyfeui = {}

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-------------------------------------------------
-- UTILS (Animation Helpers)
-------------------------------------------------
local function CircleClick(gui, color)
    spawn(function()
        local circle = Instance.new("Frame")
        circle.Name = "Circle"
        circle.Parent = gui
        circle.BackgroundColor3 = color or Color3.fromRGB(255, 255, 255)
        circle.BackgroundTransparency = 0.7
        circle.ZIndex = 10
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = circle
        
        circle.Position = UDim2.new(0, mouse.X - gui.AbsolutePosition.X, 0, mouse.Y - gui.AbsolutePosition.Y)
        
        local tween = TweenService:Create(circle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 500, 0, 500),
            Position = UDim2.new(0, (mouse.X - gui.AbsolutePosition.X) - 250, 0, (mouse.Y - gui.AbsolutePosition.Y) - 250),
            BackgroundTransparency = 1
        })
        tween:Play()
        tween.Completed:Wait()
        circle:Destroy()
    end)
end

-------------------------------------------------
-- CREATE WINDOW
-------------------------------------------------
function lyfeui.new(title)
    local gui = Instance.new("ScreenGui")
    gui.Name = "lyfeui_Framework"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 580, 0, 380)
    main.Position = UDim2.new(0.5, -290, 0.5, -190)
    main.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Dark Theme Base
    main.BackgroundTransparency = 0.1
    main.ClipsDescendants = true
    main.Parent = gui

    -- Rounded Corners & Stroke
    local mainCorner = Instance.new("UICorner", main)
    mainCorner.CornerRadius = UDim.new(0, 12)
    
    local stroke = Instance.new("UIStroke", main)
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.8
    stroke.Thickness = 1.2

    -- Make Draggable (Improved)
    local dragging, dragInput, dragStart, startPos
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    -- Toggle visibility with Alt
    UIS.InputBegan:Connect(function(i, g)
        if g then return end
        if i.KeyCode == Enum.KeyCode.LeftAlt then
            main.Visible = not main.Visible
        end
    end)

    -- Sidebar Area
    local sideBar = Instance.new("Frame")
    sideBar.Size = UDim2.new(0, 160, 1, 0)
    sideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    sideBar.BackgroundTransparency = 0.2
    sideBar.Parent = main
    
    Instance.new("UICorner", sideBar).CornerRadius = UDim.new(0, 12)

    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title or "lyfeui"
    titleLabel.Size = UDim2.new(1, -20, 0, 50)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 20
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = sideBar

    -- Tab Container
    local tabScroll = Instance.new("ScrollingFrame")
    tabScroll.Size = UDim2.new(1, 0, 1, -60)
    tabScroll.Position = UDim2.new(0, 0, 0, 60)
    tabScroll.BackgroundTransparency = 1
    tabScroll.ScrollBarThickness = 0
    tabScroll.Parent = sideBar

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.Parent = tabScroll

    -- Content Area
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -170, 1, -20)
    contentArea.Position = UDim2.new(0, 170, 0, 10)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = main

-------------------------------------------------
-- TAB SYSTEM
-------------------------------------------------
    local window = {}
    local firstTab = true

    function window:Tab(name)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(0, 140, 0, 35)
        tabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tabBtn.BackgroundTransparency = 0.95
        tabBtn.Text = name
        tabBtn.Font = Enum.Font.GothamMedium
        tabBtn.TextSize = 13
        tabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        tabBtn.AutoButtonColor = false
        tabBtn.Parent = tabScroll
        
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 8)

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
        page.Parent = contentArea

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Padding = UDim.new(0, 10)
        pageLayout.Parent = page

        if firstTab then
            page.Visible = true
            tabBtn.BackgroundTransparency = 0.8
            tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            firstTab = false
        end

        tabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(contentArea:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            for _, v in pairs(tabScroll:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency = 0.95, TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
                end
            end
            page.Visible = true
            TweenService:Create(tabBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0.8, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            CircleClick(tabBtn, Color3.fromRGB(255, 255, 255))
        end)

        local tab = {}

-------------------------------------------------
-- ELEMENTS (Button, Slider, etc.)
-------------------------------------------------
        function tab:Button(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 40)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            btn.Text = text
            btn.Font = Enum.Font.Gotham
            btn.TextColor3 = Color3.fromRGB(230, 230, 230)
            btn.TextSize = 14
            btn.ClipsDescendants = true
            btn.AutoButtonColor = false
            btn.Parent = page
            
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
            Instance.new("UIStroke", btn).Transparency = 0.8

            btn.MouseButton1Click:Connect(function()
                CircleClick(btn, Color3.fromRGB(255, 255, 255))
                callback()
            end)
        end

        function tab:Slider(text, min, max, default, callback)
            local sFrame = Instance.new("Frame")
            sFrame.Size = UDim2.new(1, -10, 0, 50)
            sFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            sFrame.Parent = page
            Instance.new("UICorner", sFrame).CornerRadius = UDim.new(0, 8)

            local sLabel = Instance.new("TextLabel")
            sLabel.Text = text .. " : " .. default
            sLabel.Size = UDim2.new(1, -20, 0, 25)
            sLabel.Position = UDim2.new(0, 10, 0, 5)
            sLabel.BackgroundTransparency = 1
            sLabel.Font = Enum.Font.Gotham
            sLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            sLabel.TextXAlignment = Enum.TextXAlignment.Left
            sLabel.Parent = sFrame

            local barBg = Instance.new("Frame")
            barBg.Size = UDim2.new(1, -20, 0, 6)
            barBg.Position = UDim2.new(0, 10, 0, 35)
            barBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            barBg.Parent = sFrame
            Instance.new("UICorner", barBg)

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            fill.Parent = barBg
            Instance.new("UICorner", fill)

            local function update(input)
                local pos = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * pos)
                sLabel.Text = text .. " : " .. val
                TweenService:Create(fill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
                callback(val)
            end

            local sliding = false
            barBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true update(input) end
            end)
            UIS.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
            end)
            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
            end)
        end

        return tab
    end

    return window
end

return lyfeui
