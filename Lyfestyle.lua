local MacLib = loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local espSettings = {
    Enabled = false,
    Rainbow = false,
    CustomColor = Color3.fromRGB(255, 255, 255),
    RainbowSpeed = 0.5,
    FillOpacity = 0.5,
    ShowNames = false,
    ShowDistance = false
}

local aimSettings = {
    AimbotEnabled = false,
    SilentAimEnabled = false,
    AimPart = "Head",
    Smoothness = 0.1, 
    FovEnabled = false,
    FovRadius = 100,
    FovColor = Color3.fromRGB(255, 255, 255),
    FovThickness = 1,
    FovTransparency = 1
}

local currentHue = 0
local espObjects = {}      
local textEspObjects = {}  

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.ZIndex = 1

local function GetCurrentColor()
    return espSettings.Rainbow and Color3.fromHSV(currentHue, 1, 1) or espSettings.CustomColor
end

local function createTextESP(player)
    if player == LocalPlayer then return end
    
    local function setup(character)
        local head = character:WaitForChild("Head", 10)
        if not head then return end
        
        if textEspObjects[player] then 
            pcall(function() textEspObjects[player].Parent:Destroy() end) 
        end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "MacLib_ESP_Gui"
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head

        local label = Instance.new("TextLabel")
        label.Parent = billboard
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = GetCurrentColor()
        label.TextStrokeTransparency = 0
        label.TextSize = 14
        label.Font = Enum.Font.SourceSansBold
        label.Text = ""
        label.Visible = espSettings.Enabled
        
        textEspObjects[player] = label
    end

    player.CharacterAdded:Connect(setup)
    if player.Character then setup(player.Character) end
end

local function createHighlight(player)
    if player == LocalPlayer then return end
    
    local function setup(character)
        if espObjects[player] then espObjects[player]:Destroy() end
        
        local hl = Instance.new("Highlight")
        hl.Name = "MacLib_ESP_Highlight"
        hl.Parent = character
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.FillTransparency = espSettings.FillOpacity
        hl.FillColor = GetCurrentColor()
        hl.OutlineColor = Color3.new(1, 1, 1)
        hl.Enabled = espSettings.Enabled
        
        espObjects[player] = hl
    end

    player.CharacterAdded:Connect(setup)
    if player.Character then setup(player.Character) end
end

for _, player in ipairs(Players:GetPlayers()) do
    createHighlight(player)
    createTextESP(player)
end

Players.PlayerAdded:Connect(function(player)
    createHighlight(player)
    createTextESP(player)
end)

local function GetClosestPlayer()
    local target = nil
    local shortestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(aimSettings.AimPart) then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character[aimSettings.AimPart].Position)
            if onScreen then
                local mousePos = Vector2.new(Mouse.X, Mouse.Y)
                local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                
                if distance < shortestDistance and distance <= aimSettings.FovRadius then
                    target = player
                    shortestDistance = distance
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function(dt)
    currentHue = (currentHue + dt * espSettings.RainbowSpeed) % 1
    local activeColor = GetCurrentColor()

    FOVCircle.Visible = aimSettings.FovEnabled
    FOVCircle.Radius = aimSettings.FovRadius
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    FOVCircle.Color = aimSettings.FovColor

    if aimSettings.AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(aimSettings.AimPart) then
            local targetPos = target.Character[aimSettings.AimPart].Position
            local currentCF = Camera.CFrame
            local targetCF = CFrame.new(currentCF.Position, targetPos)
            Camera.CFrame = currentCF:Lerp(targetCF, aimSettings.Smoothness)
        end
    end

    for player, hl in pairs(espObjects) do
        if hl and hl.Parent then
            hl.Enabled = espSettings.Enabled
            hl.FillColor = activeColor
        else
            espObjects[player] = nil
        end
    end

    for player, label in pairs(textEspObjects) do
        if player.Character and player.Character:FindFirstChild("Head") and label and label.Parent then
            label.Visible = espSettings.Enabled and (espSettings.ShowNames or espSettings.ShowDistance)
            
            if label.Visible then
                local dist = math.floor((player.Character.Head.Position - Camera.CFrame.Position).Magnitude)
                local nameStr = espSettings.ShowNames and player.DisplayName or ""
                local distStr = espSettings.ShowDistance and " [" .. dist .. "m]" or ""
                
                label.Text = nameStr .. distStr
                label.TextColor3 = activeColor
            end
        else
            textEspObjects[player] = nil
        end
    end
end)

local Window = MacLib:Window({
    Title = "LYFESTYLE",
    Subtitle = "BY MON",
    Size = UDim2.fromOffset(868, 650),
    DragStyle = 1,
    Keybind = Enum.KeyCode.RightControl,
    AcrylicBlur = true,
})

local tabGroups = { Group = Window:TabGroup() }
local tabs = {
    Combat = tabGroups.Group:Tab({ Name = "Combat", Image = "rbxassetid://10734950309" }),
    Visuals = tabGroups.Group:Tab({ Name = "Visuals", Image = "rbxassetid://10734950309" }),
}

local aimSection = tabs.Combat:Section({ Side = "Left" })
aimSection:Header({ Name = "Aimbot Settings" })
aimSection:Toggle({ Name = "Aimbot (Hold RMB)", Default = false, Callback = function(v) aimSettings.AimbotEnabled = v end })
aimSection:Slider({ Name = "Smoothness", Default = 10, Minimum = 1, Maximum = 100, Callback = function(v) aimSettings.Smoothness = v / 100 end })
aimSection:Dropdown({ Name = "Aim Part", Multi = false, Required = true, Options = {"Head", "HumanoidRootPart"}, Default = "Head", Callback = function(v) aimSettings.AimPart = v end })

local fovSection = tabs.Combat:Section({ Side = "Right" })
fovSection:Header({ Name = "FOV Settings" })
fovSection:Toggle({ Name = "Show FOV Circle", Default = false, Callback = function(v) aimSettings.FovEnabled = v end })
fovSection:Slider({ Name = "FOV Radius", Default = 100, Minimum = 30, Maximum = 800, Callback = function(v) aimSettings.FovRadius = v end })
fovSection:Colorpicker({ Name = "FOV Color", Default = Color3.fromRGB(255, 255, 255), Callback = function(v) aimSettings.FovColor = v end })

local espSection = tabs.Visuals:Section({ Side = "Left" })
espSection:Header({ Name = "Main ESP" })
espSection:Toggle({ Name = "Enable ESP (Highlight)", Default = false, Callback = function(v) espSettings.Enabled = v end })
espSection:Toggle({ Name = "Show Names", Default = false, Callback = function(v) espSettings.ShowNames = v end })
espSection:Toggle({ Name = "Show Distance", Default = false, Callback = function(v) espSettings.ShowDistance = v end })

local espColorSection = tabs.Visuals:Section({ Side = "Right" })
espColorSection:Header({ Name = "Customization" })
espColorSection:Toggle({ Name = "Rainbow Mode", Default = false, Callback = function(v) espSettings.Rainbow = v end })
espColorSection:Colorpicker({ Name = "ESP Color", Default = Color3.fromRGB(255, 255, 255), Callback = function(c) espSettings.CustomColor = c end })
espColorSection:Slider({ Name = "Fill Opacity", Default = 50, Minimum = 0, Maximum = 100, Callback = function(v) espSettings.FillOpacity = v / 100 end })

tabs.Combat:Select()
