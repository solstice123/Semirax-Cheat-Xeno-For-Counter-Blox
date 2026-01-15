local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

if _G.ZOA_Circle then pcall(function() _G.ZOA_Circle:Destroy() end) _G.ZOA_Circle = nil end
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name:find("Semirax") or v.Name:find("ZOA") then v:Destroy() end
end

local function FullyRemoveESP(data)
    if not data then return end
    pcall(function()
        if data.Box then data.Box:Remove() end
        if data.BarBack then data.BarBack:Remove() end
        if data.Bar then data.Bar:Remove() end
        if data.Tag then data.Tag:Remove() end
        if data.Highlight then data.Highlight:Destroy() end
    end)
end

if _G.Old_ESP then
    for _, p_esp in pairs(_G.Old_ESP) do FullyRemoveESP(p_esp) end
end

local Flags = {
    Aimbot = true, TriggerBot = true, WH = true, TeamCheck = true, BHOP = true, StopShot = true,
    ThirdPerson = false, Radius = 80, ZOA_Visible = true, MenuOpen = true, CustomFOV = 70, NetOptimize = true
}
local Binds = {}
local ESP_Data = {}
_G.Old_ESP = ESP_Data

local CurrentSpeed = 16
local LastSpeedUpdate = tick()
local LastMousePos = UserInputService:GetMouseLocation()

local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "Semirax_Final_Code"
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 240, 0, 480); Main.Position = UDim2.new(0.5, -120, 0.4, -240); Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15); Main.BorderSizePixel = 0; Main.ClipsDescendants = true; Main.BackgroundTransparency = 1
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Gradient = Instance.new("UIGradient", Main)
Gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 20)), ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 50, 130))})
Gradient.Rotation = 45

local IntroText = Instance.new("TextLabel", Main)
IntroText.Size = UDim2.new(1, 0, 1, 0); IntroText.BackgroundTransparency = 1; IntroText.Text = "SEMIRAX"; IntroText.TextColor3 = Color3.new(1,1,1); IntroText.Font = Enum.Font.GothamBold; IntroText.TextSize = 35; IntroText.TextTransparency = 1

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, 0, 1, 0); Content.BackgroundTransparency = 1; Content.Visible = false
local Header = Instance.new("TextLabel", Content)
Header.Size = UDim2.new(1, 0, 0, 45); Header.BackgroundTransparency = 1; Header.Text = "SEMIRAX CHEAT"; Header.TextColor3 = Color3.new(1, 1, 1); Header.Font = Enum.Font.GothamBold; Header.TextSize = 16

task.spawn(function()
    TweenService:Create(Main, TweenInfo.new(0.6), {BackgroundTransparency = 0}):Play()
    task.wait(0.2); TweenService:Create(IntroText, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
    task.wait(1.2); TweenService:Create(IntroText, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    task.wait(0.4); IntroText:Destroy(); Content.Visible = true
end)

local dragging, dragStart, startPos, lastClick = false, nil, nil, 0
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if tick() - lastClick < 0.35 then
            Flags.MenuOpen = not Flags.MenuOpen
            local targetSize = Flags.MenuOpen and UDim2.new(0, 240, 0, 480) or UDim2.new(0, 240, 0, 45)
            TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Size = targetSize}):Play()
        else dragging = true; dragStart = input.Position; startPos = Main.Position end
        lastClick = tick()
    end
end)
UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart; Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

local TabContainer = Instance.new("Frame", Content); TabContainer.Size = UDim2.new(1, -20, 0, 30); TabContainer.Position = UDim2.new(0, 10, 0, 50); TabContainer.BackgroundTransparency = 1
local FuncBtn = Instance.new("TextButton", TabContainer); FuncBtn.Size = UDim2.new(0.5, -5, 1, 0); FuncBtn.Text = "FUNCTIONS"; FuncBtn.BackgroundColor3 = Color3.fromRGB(40, 60, 140); FuncBtn.TextColor3 = Color3.new(1,1,1); FuncBtn.Font = Enum.Font.GothamBold; FuncBtn.TextSize = 11; Instance.new("UICorner", FuncBtn)
local BindBtn = Instance.new("TextButton", TabContainer); BindBtn.Position = UDim2.new(0.5, 5, 0, 0); BindBtn.Size = UDim2.new(0.5, -5, 1, 0); BindBtn.Text = "BINDS"; BindBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30); BindBtn.TextColor3 = Color3.new(0.6,0.6,0.6); BindBtn.Font = Enum.Font.GothamBold; BindBtn.TextSize = 11; Instance.new("UICorner", BindBtn)

local FuncPage = Instance.new("ScrollingFrame", Content); FuncPage.Size = UDim2.new(1, -20, 1, -100); FuncPage.Position = UDim2.new(0, 10, 0, 90); FuncPage.BackgroundTransparency = 1; FuncPage.ScrollBarThickness = 0
local BindPage = Instance.new("ScrollingFrame", Content); BindPage.Size = UDim2.new(1, -20, 1, -100); BindPage.Position = UDim2.new(0, 10, 0, 90); BindPage.BackgroundTransparency = 1; BindPage.ScrollBarThickness = 0; BindPage.Visible = false

local function SetupPage(p) Instance.new("UIListLayout", p).Padding = UDim.new(0, 8); Instance.new("UIPadding", p).PaddingTop = UDim.new(0, 5) end
SetupPage(FuncPage); SetupPage(BindPage)

FuncBtn.MouseButton1Click:Connect(function() FuncPage.Visible = true; BindPage.Visible = false; TweenService:Create(FuncBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40, 60, 140)}):Play(); TweenService:Create(BindBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(20, 20, 30)}):Play() end)
BindBtn.MouseButton1Click:Connect(function() FuncPage.Visible = false; BindPage.Visible = true; TweenService:Create(BindBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40, 60, 140)}):Play(); TweenService:Create(FuncBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(20, 20, 30)}):Play() end)

local function CreateElement(name, flag)
    local btn = Instance.new("TextButton", FuncPage); btn.Size = UDim2.new(1, 0, 0, 35); btn.BackgroundColor3 = Flags[flag] and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(30, 30, 45); btn.Text = name; btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.GothamMedium; btn.TextSize = 13; Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() Flags[flag] = not Flags[flag]; local col = Flags[flag] and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(30, 30, 45); TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = col}):Play() end)
    local bBtn = Instance.new("TextButton", BindPage); bBtn.Size = UDim2.new(1, 0, 0, 35); bBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 40); bBtn.TextColor3 = Color3.new(1,1,1); bBtn.Text = name .. ": NONE"; bBtn.Font = Enum.Font.GothamMedium; bBtn.TextSize = 13; Instance.new("UICorner", bBtn)
    bBtn.MouseButton1Click:Connect(function() bBtn.Text = "..."; local conn; conn = UserInputService.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Keyboard then Binds[i.KeyCode] = {Flag = flag, Button = btn}; bBtn.Text = name .. ": " .. i.KeyCode.Name; conn:Disconnect() end end) end)
end

for _, v in pairs({"Aimbot", "TriggerBot", "WH", "BHOP", "NetOptimize", "StopShot", "ThirdPerson"}) do
    local displayName = (v == "StopShot") and "Stop-Shot" or (v == "ThirdPerson" and "Third Person" or v)
    CreateElement(displayName, v) 
end

local function CreateSlider(label, flag, min, max, step)
    local sF = Instance.new("Frame", FuncPage); sF.Size = UDim2.new(1, 0, 0, 55); sF.BackgroundTransparency = 1
    local sL = Instance.new("TextLabel", sF); sL.Size = UDim2.new(1, 0, 0, 20); sL.Text = label .. ": " .. Flags[flag]; sL.TextColor3 = Color3.new(1,1,1); sL.Font = Enum.Font.GothamSemibold; sL.TextSize = 12; sL.BackgroundTransparency = 1
    local mBtn = Instance.new("TextButton", sF); mBtn.Size = UDim2.new(0.48, 0, 0, 28); mBtn.Position = UDim2.new(0, 0, 0, 22); mBtn.Text = "-"; mBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60); mBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", mBtn)
    local pBtn = Instance.new("TextButton", sF); pBtn.Size = UDim2.new(0.48, 0, 0, 28); pBtn.Position = UDim2.new(0.52, 0, 0, 22); pBtn.Text = "+"; pBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60); pBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", pBtn)
    mBtn.MouseButton1Click:Connect(function() Flags[flag] = math.clamp(Flags[flag] - step, min, max); sL.Text = label .. ": " .. Flags[flag] end)
    pBtn.MouseButton1Click:Connect(function() Flags[flag] = math.clamp(Flags[flag] + step, min, max); sL.Text = label .. ": " .. Flags[flag] end)
end
CreateSlider("ZOA RADIUS", "Radius", 10, 600, 10); CreateSlider("FIELD OF VIEW", "CustomFOV", 30, 120, 5)

UserInputService.InputBegan:Connect(function(i, g) if not g and Binds[i.KeyCode] then local d = Binds[i.KeyCode]; Flags[d.Flag] = not Flags[d.Flag]; local col = Flags[d.Flag] and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(30, 30, 45); TweenService:Create(d.Button, TweenInfo.new(0.3), {BackgroundColor3 = col}):Play() end end)

local FOVCircle = Drawing.new("Circle"); FOVCircle.Thickness = 2; FOVCircle.Color = Color3.new(1, 1, 1); FOVCircle.Transparency = 1; _G.ZOA_Circle = FOVCircle

local function AddESP(p)
    if p == LocalPlayer then return end
    if ESP_Data[p] then return end
    
    ESP_Data[p] = { 
        Box = Drawing.new("Square"), 
        BarBack = Drawing.new("Square"), 
        Bar = Drawing.new("Square"), 
        Tag = Drawing.new("Text"), 
        Highlight = Instance.new("Highlight") 
    }
    local d = ESP_Data[p]
    d.Box.Thickness = 1.5; d.Box.Color = Color3.new(1,1,1)
    d.Tag.Size = 14; d.Tag.Color = Color3.new(1,1,1); d.Tag.Outline = true; d.Tag.Center = true
    d.BarBack.Filled, d.BarBack.Color, d.BarBack.Transparency = true, Color3.new(0,0,0), 0.5
    d.Bar.Filled = true
end

for _, p in pairs(Players:GetPlayers()) do AddESP(p) end
Players.PlayerAdded:Connect(AddESP)
Players.PlayerRemoving:Connect(function(p) if ESP_Data[p] then FullyRemoveESP(ESP_Data[p]); ESP_Data[p] = nil end end)

RunService.RenderStepped:Connect(function()
    local MouseLocation = UserInputService:GetMouseLocation()
    local MouseDelta = (MouseLocation - LastMousePos).Magnitude
    local IsSwiping = MouseDelta > 15 
    LastMousePos = MouseLocation

    FOVCircle.Position = MouseLocation
    FOVCircle.Radius = Flags.Radius
    FOVCircle.Visible = Flags.ZOA_Visible
    
    -- ПРИНУДИТЕЛЬНЫЙ FOV (Работает всегда для точности ESP)
    Camera.FieldOfView = Flags.CustomFOV
    
    local Char = LocalPlayer.Character
    local Hum = Char and Char:FindFirstChildOfClass("Humanoid")
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    
    local IsAlive = (Char and Hum and Root and Hum.Health > 0)

    if IsAlive then
        if Flags.StopShot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            Root.Velocity = Vector3.new(0, 0, 0); Hum.WalkSpeed = 0
        else
            if Flags.BHOP and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                Hum.Jump = true
                if tick() - LastSpeedUpdate >= 1 then 
                    CurrentSpeed = math.clamp(CurrentSpeed + 3, 16, 120); LastSpeedUpdate = tick() 
                end
                Hum.WalkSpeed = CurrentSpeed
            else CurrentSpeed = 16; Hum.WalkSpeed = 16 end
        end
    end

    -- ESP & Aimbot Loop
    local Target, MinDist = nil, Flags.Radius
    
    for p, d in pairs(ESP_Data) do
        local c = p.Character
        local h = c and c:FindFirstChildOfClass("Humanoid")
        local r = c and c:FindFirstChild("HumanoidRootPart")
        
        if c and h and r and h.Health > 0 then
            local isEnemy = (p.Team ~= LocalPlayer.Team)
            local pos, onScreen = Camera:WorldToViewportPoint(r.Position)
            local distance = (Camera.CFrame.Position - r.Position).Magnitude
            
            if d.Highlight then
                d.Highlight.Parent = c; d.Highlight.Enabled = Flags.WH; d.Highlight.FillColor = isEnemy and Color3.new(1,0,0) or Color3.new(0,0.5,1)
            end
            
            if onScreen and Flags.WH and (not Flags.TeamCheck or isEnemy) then
                local head = c:FindFirstChild("Head")
                if head then
                    local headPos = Camera:WorldToViewportPoint(head.Position)
                    local legWorldPos = r.Position - Vector3.new(0, 3, 0)
                    local legPos = Camera:WorldToViewportPoint(legWorldPos)
                    
                    local height = math.abs(headPos.Y - legPos.Y)
                    local width = height / 2
                    
                    d.Box.Visible = true; d.Box.Size = Vector2.new(width, height); d.Box.Position = Vector2.new(pos.X - width/2, pos.Y - height/2)
                    d.BarBack.Visible, d.Bar.Visible = true, true
                    d.BarBack.Size = Vector2.new(4, height); d.BarBack.Position = Vector2.new(pos.X - width/2 - 6, pos.Y - height/2)
                    d.Bar.Size = Vector2.new(2, height * (h.Health/h.MaxHealth)); d.Bar.Position = Vector2.new(pos.X - width/2 - 5, pos.Y + height/2 - d.Bar.Size.Y)
                    d.Bar.Color = Color3.new(1 - (h.Health/100), h.Health/100, 0)
                    d.Tag.Visible = true; d.Tag.Text = p.Name .. " [" .. math.floor(distance) .. "]"; d.Tag.Position = Vector2.new(pos.X, pos.Y - height/2 - 20)

                    if IsAlive and Flags.Aimbot and isEnemy and not IsSwiping then
                        local screenHeadPos = Vector2.new(headPos.X, headPos.Y)
                        local mouseDist = (screenHeadPos - MouseLocation).Magnitude
                        if mouseDist < Flags.Radius and mouseDist < MinDist then
                            MinDist = mouseDist; Target = head
                        end
                    end
                end
            else
                d.Box.Visible, d.Tag.Visible, d.Bar.Visible, d.BarBack.Visible = false, false, false, false
            end
        else 
            d.Box.Visible, d.Tag.Visible, d.Bar.Visible, d.BarBack.Visible = false, false, false, false
            if d.Highlight then d.Highlight.Enabled = false end
        end
    end

    if IsAlive and Flags.TriggerBot and Mouse.Target then
        local char = Mouse.Target.Parent:FindFirstChild("Humanoid") and Mouse.Target.Parent or (Mouse.Target.Parent.Parent and Mouse.Target.Parent.Parent:FindFirstChild("Humanoid") and Mouse.Target.Parent.Parent)
        if char then
            local p = Players:GetPlayerFromCharacter(char)
            if p and p ~= LocalPlayer and (not Flags.TeamCheck or p.Team ~= LocalPlayer.Team) and char.Humanoid.Health > 0 then
                mouse1press(); task.wait(0.01); mouse1release()
            end
        end
    end

    -- Кастомные режимы камеры (Только когда жив)
    if IsAlive then
        if Flags.ThirdPerson and Root then
            Camera.CameraType = Enum.CameraType.Scriptable
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Root.Position) * Camera.CFrame.Rotation * CFrame.new(0, 2, 12), 0.5)
        else 
            Camera.CameraType = Enum.CameraType.Custom 
        end

        if Target and Flags.Aimbot and not IsSwiping then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Position)
        end
    end
end)