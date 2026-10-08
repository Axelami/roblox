local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local actions = ReplicatedStorage:WaitForChild("SimulatorAction")
local stats = player:WaitForChild("leaderstats")
local coins, energy = stats:WaitForChild("Mynt"), stats:WaitForChild("Energi")
local gui = Instance.new("ScreenGui")
gui.Name, gui.ResetOnSpawn = "SimulatorHUD", false
gui.Parent = player:WaitForChild("PlayerGui")
local panel = Instance.new("Frame")
panel.Size, panel.Position = UDim2.new(0.9, 0, 0, 190), UDim2.new(0.05, 0, 0, 12)
panel.BackgroundColor3 = Color3.fromRGB(22, 29, 48)
panel.Parent = gui
local constraint = Instance.new("UISizeConstraint")
constraint.MaxSize = Vector2.new(440, 190)
constraint.Parent = panel
local corner = Instance.new("UICorner")
corner.CornerRadius, corner.Parent = UDim.new(0, 14), panel
local function label(y, height, size)
    local l = Instance.new("TextLabel")
    l.Size, l.Position = UDim2.new(1, -24, 0, height), UDim2.fromOffset(12, y)
    l.BackgroundTransparency, l.TextColor3 = 1, Color3.new(1, 1, 1)
    l.Font, l.TextSize, l.TextWrapped = Enum.Font.GothamBold, size, true
    l.Parent = panel
    return l
end
label(8, 30, 24).Text = "⚡ ENERGY SIMULATOR"
local info = label(42, 52, 18)
local prices = label(96, 35, 14)
label(136, 44, 13).Text = "Samla energi → sälj vid den gula plattan → uppgradera! Använd E eller tryck på stationens prompt."
local button = Instance.new("TextButton")
button.Size, button.Position = UDim2.fromOffset(240, 64), UDim2.new(0.5, -120, 1, -90)
button.BackgroundColor3 = Color3.fromRGB(76, 113, 246)
button.TextColor3, button.TextSize = Color3.new(1, 1, 1), 23
button.Font, button.Text = Enum.Font.GothamBold, "⚡ SAMLA ENERGI"
button.Parent = gui
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 16)
button.Activated:Connect(function() actions:FireServer("Collect") end)
local message = Instance.new("TextLabel")
message.Size, message.Position = UDim2.new(0.9, 0, 0, 55), UDim2.new(0.05, 0, 1, -150)
message.BackgroundTransparency, message.TextColor3 = 1, Color3.new(1, 1, 1)
message.TextSize, message.TextWrapped, message.Text = 18, true, ""
message.Parent = gui
local function update()
    info.Text = string.format("Mynt: %d   |   Energi: %d / %d\nEnergi per klick: %d", coins.Value, energy.Value, player:GetAttribute("Capacity") or 25, player:GetAttribute("Power") or 1)
    prices.Text = string.format("Verktyg: %d mynt   •   Ryggsäck: %d mynt", player:GetAttribute("ToolCost") or 25, player:GetAttribute("BagCost") or 50)
end
coins.Changed:Connect(update)
energy.Changed:Connect(update)
player.AttributeChanged:Connect(update)
local messageId = 0
actions.OnClientEvent:Connect(function(text)
    messageId = messageId + 1
    local id = messageId
    message.Text = text
    task.delay(4, function() if id == messageId then message.Text = "" end end)
end)
update()
