-- MacVision UI Library

local MacVision = {}

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-------------------------------------------------
-- CREATE WINDOW
-------------------------------------------------

function MacVision.new(title)

    local gui = Instance.new("ScreenGui")
    gui.Name = "MacVisionUI"
    gui.Parent = player:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0,540,0,330)
    main.Position = UDim2.new(.5,-270,.5,-165)
    main.BackgroundColor3 = Color3.fromRGB(255,255,255)
    main.BackgroundTransparency = .85
    main.Active = true
    main.Draggable = true
    main.Parent = gui

    Instance.new("UICorner",main).CornerRadius = UDim.new(0,18)

-------------------------------------------------
-- ALT TOGGLE
-------------------------------------------------

    UIS.InputBegan:Connect(function(i,g)
        if g then return end
        if i.KeyCode == Enum.KeyCode.LeftAlt then
            main.Visible = not main.Visible
        end
    end)

-------------------------------------------------
-- TITLE
-------------------------------------------------

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title or "MacVision"
    titleLabel.Size = UDim2.new(1,0,0,40)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextColor3 = Color3.fromRGB(30,30,30)
    titleLabel.Parent = main

-------------------------------------------------
-- TAB BAR
-------------------------------------------------

    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(0,140,1,-40)
    tabBar.Position = UDim2.new(0,0,0,40)
    tabBar.BackgroundTransparency = 1
    tabBar.Parent = main

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0,6)
    tabLayout.Parent = tabBar

-------------------------------------------------
-- PAGES
-------------------------------------------------

    local pages = Instance.new("Frame")
    pages.Size = UDim2.new(1,-140,1,-40)
    pages.Position = UDim2.new(0,140,0,40)
    pages.BackgroundTransparency = 1
    pages.Parent = main

-------------------------------------------------
-- NOTIFY
-------------------------------------------------

    local function Notify(text)

        local n = Instance.new("TextLabel")
        n.Size = UDim2.new(0,220,0,40)
        n.Position = UDim2.new(1,-240,1,-60)
        n.BackgroundColor3 = Color3.fromRGB(255,255,255)
        n.BackgroundTransparency = .2
        n.TextColor3 = Color3.fromRGB(30,30,30)
        n.Font = Enum.Font.Gotham
        n.TextSize = 14
        n.Text = text
        n.Parent = gui

        Instance.new("UICorner",n)

        task.wait(3)
        n:Destroy()

    end

-------------------------------------------------
-- TAB SYSTEM
-------------------------------------------------

    local window = {}

    function window:Tab(name)

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,0,0,36)
        btn.Text = name
        btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
        btn.BackgroundTransparency = .4
        btn.TextColor3 = Color3.fromRGB(30,30,30)
        btn.Parent = tabBar

        Instance.new("UICorner",btn)

        local page = Instance.new("Frame")
        page.Size = UDim2.new(1,0,1,0)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.Parent = pages

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0,8)
        layout.Parent = page

        btn.MouseButton1Click:Connect(function()

            for _,v in pairs(pages:GetChildren()) do
                if v:IsA("Frame") then
                    v.Visible = false
                end
            end

            page.Visible = true

        end)

        local tab = {}

-------------------------------------------------
-- BUTTON
-------------------------------------------------

        function tab:Button(text,callback)

            local b = Instance.new("TextButton")
            b.Size = UDim2.new(0,200,0,32)
            b.Text = text
            b.BackgroundColor3 = Color3.fromRGB(255,255,255)
            b.BackgroundTransparency = .3
            b.TextColor3 = Color3.fromRGB(30,30,30)
            b.Parent = page

            Instance.new("UICorner",b)

            b.MouseButton1Click:Connect(callback)

        end

-------------------------------------------------
-- SLIDER
-------------------------------------------------

        function tab:Slider(text,min,max,callback)

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0,220,0,40)
            frame.BackgroundTransparency = 1
            frame.Parent = page

            local label = Instance.new("TextLabel")
            label.Text = text
            label.Size = UDim2.new(1,0,0,20)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.fromRGB(30,30,30)
            label.Parent = frame

            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(1,0,0,8)
            bar.Position = UDim2.new(0,0,0,25)
            bar.BackgroundColor3 = Color3.fromRGB(200,200,200)
            bar.Parent = frame

            Instance.new("UICorner",bar)

            bar.InputBegan:Connect(function(i)

                if i.UserInputType == Enum.UserInputType.MouseButton1 then

                    local pos = (UIS:GetMouseLocation().X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
                    local val = math.floor(min + (max-min)*pos)

                    callback(val)

                end

            end)

        end

-------------------------------------------------
-- DROPDOWN
-------------------------------------------------

        function tab:Dropdown(text,list,callback)

            local d = Instance.new("TextButton")
            d.Size = UDim2.new(0,200,0,30)
            d.Text = text
            d.BackgroundColor3 = Color3.fromRGB(255,255,255)
            d.BackgroundTransparency = .3
            d.TextColor3 = Color3.fromRGB(30,30,30)
            d.Parent = page

            Instance.new("UICorner",d)

            d.MouseButton1Click:Connect(function()

                local choice = list[math.random(1,#list)]
                d.Text = text.." : "..choice
                callback(choice)

            end)

        end

        return tab

    end

    window.Notify = Notify

    return window

end

return MacVision
