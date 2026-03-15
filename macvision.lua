-- lyfeui Library
-- Rebranded from MacVision UI

local lyfeui = {}

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-------------------------------------------------
-- CREATE WINDOW
-------------------------------------------------

function lyfeui.new(title)

    local gui = Instance.new("ScreenGui")
    gui.Name = "lyfeui_Library"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 550, 0, 350)
    main.Position = UDim2.new(0.5, -275, 0.5, -175)
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    main.BackgroundTransparency = 0.15
    main.BorderSizePixel = 0
    main.Active = true
    main.Parent = gui

    -- Rounded Corners
    local corner = Instance.new("UICorner", main)
    corner.CornerRadius = UDim.new(0, 14)

    -- Drop Shadow / Border
    local stroke = Instance.new("UIStroke", main)
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.85

    -- Make Draggable
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

-------------------------------------------------
-- TOGGLE (LeftAlt)
-------------------------------------------------

    UIS.InputBegan:Connect(function(i, g)
        if g then return end
        if i.KeyCode == Enum.KeyCode.LeftAlt then
            main.Visible = not main.Visible
        end
    end)

-------------------------------------------------
-- TITLE & SIDEBAR
-------------------------------------------------

    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 150, 1, 0)
    sidebar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    sidebar.BackgroundTransparency = 0.3
    sidebar.BorderSizePixel = 0
    sidebar.Parent = main
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 14)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title or "lyfeui"
    titleLabel.Size = UDim2.new(1, 0, 0, 50)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 20
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Parent = sidebar

    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Size = UDim2.new(1, 0, 1, -60)
    tabContainer.Position = UDim2.new(0, 0, 0, 55)
    tabContainer.BackgroundTransparency = 1
    tabContainer.ScrollBarThickness = 0
    tabContainer.Parent = sidebar

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.Parent = tabContainer

-------------------------------------------------
-- PAGES AREA
-------------------------------------------------

    local pages = Instance.new("Frame")
    pages.Size = UDim2.new(1, -165, 1, -20)
    pages.Position = UDim2.new(0, 160, 0, 10)
    pages.BackgroundTransparency = 1
    pages.Parent = main

-------------------------------------------------
-- NOTIFY
-------------------------------------------------

    local function Notify(text)
        local n = Instance.new("TextLabel")
        n.Size = UDim2.new(0, 220, 0, 45)
        n.Position = UDim2.new(1, 10, 1, -55)
        n.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        n.BackgroundTransparency = 0.1
        n.TextColor3 = Color3.fromRGB(255, 255, 255)
        n.Font = Enum.Font.GothamMedium
        n.TextSize = 14
        n.Text = "  " .. text
        n.TextXAlignment = Enum.TextXAlignment.Left
        n.Parent = gui

        Instance.new("UICorner", n).CornerRadius = UDim.new(0, 10)
        Instance.new("UIStroke", n).Color = Color3.fromRGB(255, 255, 255)

        n:TweenPosition(UDim2.new(1, -230, 1, -55), "Out", "Back", 0.5)
        task.wait(3)
        n:TweenPosition(UDim2.new(1, 10, 1, -55), "In", "Quad", 0.5)
        task.wait(0.5)
        n:Destroy()
    end

-------------------------------------------------
-- TAB SYSTEM
-------------------------------------------------

    local window = {}
    local firstTab = true

    function window:Tab(name)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 130, 0, 35)
        btn.Text = name
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundTransparency = 0.9
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 13
        btn.AutoButtonColor = false
        btn.Parent = tabContainer
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
        page.Parent = pages

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.Parent = page

        if firstTab then
            page.Visible = true
            btn.BackgroundTransparency = 0.7
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            firstTab = false
        end

        btn.MouseButton1Click:Connect(function()
            for _, v in pairs(pages:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            for _, v in pairs(tabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency = 0.9, TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
                end
            end
            page.Visible = true
            TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundTransparency = 0.7, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)

        local tab = {}

-------------------------------------------------
-- BUTTON
-------------------------------------------------

        function tab:Button(text, callback)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -10, 0, 38)
            b.Text = text
            b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            b.BackgroundTransparency = 0.2
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            b.Font = Enum.Font.Gotham
            b.TextSize = 14
            b.Parent = page
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
            
            b.MouseButton1Click:Connect(callback)
        end

-------------------------------------------------
-- SLIDER
-------------------------------------------------

        function tab:Slider(text, min, max, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -10, 0, 50)
            frame.BackgroundTransparency = 1
            frame.Parent = page

            local label = Instance.new("TextLabel")
            label.Text = text
            label.Size = UDim2.new(1, 0, 0, 20)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
            label.Font = Enum.Font.Gotham
            label.TextSize = 13
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame

            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(1, 0, 0, 6)
            bar.Position = UDim2.new(0, 0, 0, 30)
            bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            bar.Parent = frame
            Instance.new("UICorner", bar)

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(0, 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            fill.Parent = bar
            Instance.new("UICorner", fill)

            local function update()
                local mousePos = UIS:GetMouseLocation().X
                local barPos = bar.AbsolutePosition.X
                local barSize = bar.AbsoluteSize.X
                local pos = math.clamp((mousePos - barPos) / barSize, 0, 1)
                local val = math.floor(min + (max - min) * pos)
                
                fill.Size = UDim2.new(pos, 0, 1, 0)
                label.Text = text .. " : " .. tostring(val)
                callback(val)
            end

            bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local moveConn
                    moveConn = UIS.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then update() end
                    end)
                    UIS.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            moveConn:Disconnect()
                        end
                    end)
                    update()
                end
            end)
        end

-------------------------------------------------
-- DROPDOWN
-------------------------------------------------

        function tab:Dropdown(text, list, callback)
            local d = Instance.new("TextButton")
            d.Size = UDim2.new(1, -10, 0, 38)
            d.Text = text .. " : ..."
            d.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            d.TextColor3 = Color3.fromRGB(255, 255, 255)
            d.Font = Enum.Font.Gotham
            d.Parent = page
            Instance.new("UICorner", d).CornerRadius = UDim.new(0, 8)

            d.MouseButton1Click:Connect(function()
                local choice = list[math.random(1, #list)]
                d.Text = text .. " : " .. choice
                callback(choice)
            end)
        end

        return tab
    end

    window.Notify = Notify
    return window
end

return lyfeui
