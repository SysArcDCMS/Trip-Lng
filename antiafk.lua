local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local VirtualUser = game:GetService("VirtualUser")

-- Create GUI
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "Auto AFK"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 120, 0, 85)
frame.Position = UDim2.new(0.5, -160, 0.5, -135)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

-- Header
local header = Instance.new("Frame", frame)
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 20)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", header)
title.Text = "⚡Auto AFK"
title.Font = Enum.Font.GothamBold
title.TextSize = 10
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1

local function newBtn(parent, text, size, pos, bg, radius, textSize)
    local b = Instance.new("TextButton", parent)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = textSize or 14
    b.Size = size
    b.Position = pos
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.BackgroundColor3 = bg
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = radius
    return b
end

local closeBtn = newBtn(header, "X", UDim2.new(0, 15, 0, 15), UDim2.new(0, 100, 0, 2), Color3.fromRGB(180, 50, 50), UDim.new(1, 0))
local minimizeBtn = newBtn(header, "-", UDim2.new(0, 15, 0, 15), UDim2.new(0, 82, 0, 2), Color3.fromRGB(70, 70, 70), UDim.new(1, 0), 18)

-- Content
local content = Instance.new("Frame", frame)
content.Name = "Content"
content.Position = UDim2.new(0, 0, 0, 30)
content.Size = UDim2.new(1, 0, 1, -30)
content.BackgroundTransparency = 1

-- AFK Button
local AntiAfkButton = newBtn(content, "Auto AFK: OFF", UDim2.new(0, 100, 0, 20), UDim2.new(0, 10, 0, 20), Color3.fromRGB(180, 50, 50), UDim.new(0, 6))

-- AFK Timer Label
local AfkTimeLabel = Instance.new("TextLabel", content)
AfkTimeLabel.Name = "AfkTimeLabel"
AfkTimeLabel.Text = "AFK: 0:0:0"
AfkTimeLabel.Size = UDim2.new(0, 100, 0, 20)
AfkTimeLabel.Position = UDim2.new(0, 10, 0, -5)
AfkTimeLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AfkTimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AfkTimeLabel.BorderSizePixel = 0
Instance.new("UICorner", AfkTimeLabel).CornerRadius = UDim.new(0, 6)

-- Anti-AFK Logic
local afkEnabled = false
local seconds, minutes, hours = 0, 0, 0

local function updateAFKButton()
    if afkEnabled then
        AntiAfkButton.Text = "Auto AFK: ON"
        AntiAfkButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    else
        AntiAfkButton.Text = "Auto AFK: OFF"
        AntiAfkButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        seconds, minutes, hours = 0, 0, 0
        AfkTimeLabel.Text = "AFK: 0:0:0"
    end
end

AntiAfkButton.MouseButton1Click:Connect(function()
    afkEnabled = not afkEnabled
    updateAFKButton()
end)

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    if afkEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- AFK Timer
task.spawn(function()
    while true do
        task.wait(1)
        if afkEnabled then
            seconds += 1
            if seconds >= 60 then seconds = 0 minutes += 1 end
            if minutes >= 60 then minutes = 0 hours += 1 end
            AfkTimeLabel.Text = string.format("AFK: %d:%d:%d", hours, minutes, seconds)
        end
    end
end)

-- Minimize
local isMinimized = false
local originalSize = frame.Size
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        content.Visible = false
        frame.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, header.Size.Y.Offset)
        minimizeBtn.Text = "+"
    else
        content.Visible = true
        frame.Size = originalSize
        minimizeBtn.Text = "-"
    end
end)

-- Close
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
