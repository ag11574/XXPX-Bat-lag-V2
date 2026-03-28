-- [[ XXPX SECURITY CHECK ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- getgenv().XXPX_KEY が正しく設定されていない場合に認証エラーを出す
if not getgenv().XXPX_KEY or type(getgenv().XXPX_KEY) ~= "string" or getgenv().XXPX_KEY == "" then
    LocalPlayer:Kick("This key cannot be used at the moment. If you want to use it again, you will need to use a new key.")
    return
end

-- ==========================================
-- ここからメインのUIソースコード
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton") 
local Title = Instance.new("TextLabel")
local DiscordLabel = Instance.new("TextLabel")
local InnerFrame = Instance.new("Frame")
local ButtonFrame = Instance.new("Frame")
local Layout = Instance.new("UIListLayout")
local TweenService = game:GetService("TweenService")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "XXPX_V2_UI"

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Size = UDim2.new(0, 200, 0, 232)
Frame.Position = UDim2.new(0.4, 0, 0.3, 0)
Frame.Active = true
Frame.Draggable = true 
Frame.ClipsDescendants = true 

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 10)
FrameCorner.Parent = Frame

TopBar.Parent = Frame
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

Title.Parent = TopBar
Title.Size = UDim2.new(1, -40, 0, 22)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "XXPX Bat lag V2"
Title.TextColor3 = Color3.fromRGB(0, 210, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

DiscordLabel.Parent = TopBar
DiscordLabel.Size = UDim2.new(1, -40, 0, 18)
DiscordLabel.Position = UDim2.new(0, 10, 0, 27)
DiscordLabel.BackgroundTransparency = 1
DiscordLabel.Text = "discord.gg/xxpx"
DiscordLabel.TextColor3 = Color3.fromRGB(0, 160, 0)
DiscordLabel.Font = Enum.Font.GothamMedium
DiscordLabel.TextSize = 12
DiscordLabel.TextXAlignment = Enum.TextXAlignment.Left

ToggleButton.Parent = TopBar
ToggleButton.Size = UDim2.new(0, 28, 0, 28)
ToggleButton.Position = UDim2.new(1, -34, 0, 11)
ToggleButton.Text = "－"
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleButton.TextColor3 = Color3.fromRGB(0, 210, 0)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 18

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

InnerFrame.Parent = Frame
InnerFrame.Position = UDim2.new(0, 8, 0, 60)
InnerFrame.Size = UDim2.new(1, -16, 0, 162)
InnerFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 32)

local InnerCorner = Instance.new("UICorner")
InnerCorner.CornerRadius = UDim.new(0, 8)
InnerCorner.Parent = InnerFrame

local Stroke = Instance.new("UIStroke")
Stroke.Parent = InnerFrame
Stroke.Color = Color3.fromRGB(0, 210, 0)
Stroke.Thickness = 1.2
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

ButtonFrame.Parent = InnerFrame
ButtonFrame.Size = UDim2.new(1, 0, 1, 0)
ButtonFrame.BackgroundTransparency = 1

Layout.Parent = ButtonFrame
Layout.Padding = UDim.new(0, 6)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.VerticalAlignment = Enum.VerticalAlignment.Top 
Layout.SortOrder = Enum.SortOrder.LayoutOrder

local UIPadding = Instance.new("UIPadding", ButtonFrame)
UIPadding.PaddingTop = UDim.new(0, 8)

local RunService = game:GetService("RunService")

local speedOn = false
local espOn = false
local wallhackOn = false
local batLagOn = false
local speedConn = nil
local targetSpeed = 28

local function CleanAcc(char)
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("Accessory") then
            v:Destroy()
        end
    end
end

local function MonitorPlayer(p)
    p.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid")
        CleanAcc(char)
        char.ChildAdded:Connect(function(child)
            if child:IsA("Accessory") then
                task.defer(function() child:Destroy() end)
            end
        end)
    end)
    if p.Character then
        CleanAcc(p.Character)
    end
end

for _, p in pairs(Players:GetPlayers()) do
    MonitorPlayer(p)
end

Players.PlayerAdded:Connect(MonitorPlayer)

task.spawn(function()
    while true do
        task.wait(0.05)
        if batLagOn then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                local bat = (backpack and backpack:FindFirstChild("Bat")) or char:FindFirstChild("Bat")
                if bat and hum then
                    hum:EquipTool(bat)
                    task.wait(0.05)
                    hum:UnequipTools()
                end
            end
        end
    end
end)

local function updateSpeed()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    local dir = hum.MoveDirection
    if dir.Magnitude > 0.05 then
        hrp.AssemblyLinearVelocity = Vector3.new(dir.X * targetSpeed, hrp.AssemblyLinearVelocity.Y, dir.Z * targetSpeed)
    end
end

local function createESPTag(player)
    local char = player.Character
    if not char then return end
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    local bill = Instance.new("BillboardGui", char)
    bill.Name = "XXPX_Tag"
    bill.Adornee = head
    bill.Size = UDim2.new(0, 150, 0, 30)
    bill.StudsOffset = Vector3.new(0, 3, 0)
    bill.AlwaysOnTop = true 
    local label = Instance.new("TextLabel", bill)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(0, 255, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Text = player.Name 
    Instance.new("UIStroke", label).Thickness = 1.5
end

local function createToggleButton(name, order)
    local button = Instance.new("TextButton", ButtonFrame)
    button.Size = UDim2.new(0.9, 0, 0, 32)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    button.TextColor3 = Color3.fromRGB(0, 210, 0)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 13
    button.Text = name.." (OFF)"
    button.LayoutOrder = order

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = button

    button.MouseButton1Click:Connect(function()
        if name == "Bat lag" then
            batLagOn = not batLagOn
            button.Text = batLagOn and name.." (ON)" or name.." (OFF)"
        elseif name == "Speed" then
            speedOn = not speedOn
            button.Text = speedOn and name.." (ON)" or name.." (OFF)"
            if speedOn then speedConn = RunService.RenderStepped:Connect(updateSpeed)
            else if speedConn then speedConn:Disconnect(); speedConn = nil end end
        elseif name == "ESP" then
            espOn = not espOn
            button.Text = espOn and name.." (ON)" or name.." (OFF)"
        elseif name == "Wallhack" then
            wallhackOn = not wallhackOn
            button.Text = wallhackOn and name.." (ON)" or name.." (OFF)"
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and not obj:IsDescendantOf(LocalPlayer.Character) then
                    local isGround = (obj.Name:lower():find("floor") or obj.Name:lower():find("ground") or obj.Name:lower():find("road") or obj.Name == "Baseplate")
                    if not isGround and obj.Name ~= "Terrain" and obj.CanCollide then
                        if wallhackOn then
                            if not obj:GetAttribute("OldTrans") then obj:SetAttribute("OldTrans", obj.Transparency) end
                            obj.Transparency = 0.5
                        else
                            local old = obj:GetAttribute("OldTrans")
                            if old then obj.Transparency = old; obj:SetAttribute("OldTrans", nil) end
                        end
                    end
                end
            end
        end
    end)
end

createToggleButton("Bat lag", 1)
createToggleButton("Speed", 2)
createToggleButton("ESP", 3)
createToggleButton("Wallhack", 4)

local isOpened = true
local tweenInfoUI = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

ToggleButton.MouseButton1Click:Connect(function()
    isOpened = not isOpened
    local targetSize = isOpened and UDim2.new(0, 200, 0, 232) or UDim2.new(0, 200, 0, 50)
    if isOpened then
        InnerFrame.Visible = true
        TweenService:Create(Frame, tweenInfoUI, {Size = targetSize}):Play()
        ToggleButton.Text = "－"
    else
        local tween = TweenService:Create(Frame, tweenInfoUI, {Size = targetSize})
        tween:Play()
        tween.Completed:Connect(function() if not isOpened then InnerFrame.Visible = false end end)
        ToggleButton.Text = "＋"
    end
end)

RunService.Heartbeat:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = player.Character:FindFirstChild("XXPX_Highlight")
            local tag = player.Character:FindFirstChild("XXPX_Tag")
            if espOn then
                if not highlight then
                    highlight = Instance.new("Highlight", player.Character)
                    highlight.Name = "XXPX_Highlight"
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                end
                if not tag then createESPTag(player) end
            else
                if highlight then highlight:Destroy() end
                if tag then tag:Destroy() end
            end
        end
    end
end)
