-- All economy changes are validated and performed by the server.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local actions = Instance.new("RemoteEvent")
actions.Name = "SimulatorAction"
actions.Parent = ReplicatedStorage
local states = {}

local function part(name, size, position, color)
    local p = Instance.new("Part")
    p.Name, p.Size, p.Position = name, size, position
    p.Anchored = true
    p.Color = color
    p.TopSurface = Enum.SurfaceType.Smooth
    p.Parent = workspace
    return p
end

part("Island", Vector3.new(160, 4, 160), Vector3.new(0, -2, 0), Color3.fromRGB(61, 148, 101))
local spawn = Instance.new("SpawnLocation")
spawn.Size, spawn.Position = Vector3.new(12, 1, 12), Vector3.new(0, 0.5, 20)
spawn.Anchored, spawn.Neutral = true, true
spawn.Parent = workspace

local function station(name, position, color, action)
    local pad = part(name, Vector3.new(16, 1, 16), position, color)
    local gui = Instance.new("BillboardGui")
    gui.Size, gui.StudsOffset, gui.AlwaysOnTop = UDim2.fromOffset(220, 50), Vector3.new(0, 5, 0), true
    gui.Parent = pad
    local label = Instance.new("TextLabel")
    label.Size, label.BackgroundTransparency = UDim2.fromScale(1, 1), 1
    label.Text, label.TextScaled = name, true
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.GothamBold
    label.Parent = gui
    local prompt = Instance.new("ProximityPrompt")
    prompt.ActionText, prompt.ObjectText = "Använd", name
    prompt.MaxActivationDistance, prompt.HoldDuration = 12, 0
    prompt.Parent = pad
    prompt.Triggered:Connect(function(player)
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if root and (root.Position - pad.Position).Magnitude <= 16 then action(player) end
    end)
end

local function sync(player, message)
    local s = states[player]
    if not s then return end
    player.leaderstats.Mynt.Value = s.coins
    player.leaderstats.Energi.Value = s.energy
    player:SetAttribute("Capacity", s.capacity)
    player:SetAttribute("Power", s.power)
    player:SetAttribute("ToolCost", s.power * 25)
    player:SetAttribute("BagCost", s.capacity * 2)
    if message then actions:FireClient(player, message) end
end

station("SÄLJ ENERGI", Vector3.new(-28, 0.5, 0), Color3.fromRGB(255, 193, 61), function(player)
    local s = states[player]
    if not s then return end
    local earned = s.energy
    s.coins, s.energy = s.coins + earned, 0
    sync(player, "Sålde energi för " .. earned .. " mynt!")
end)
station("UPPGRADERA VERKTYG", Vector3.new(0, 0.5, -28), Color3.fromRGB(93, 123, 255), function(player)
    local s = states[player]
    if not s then return end
    local cost = s.power * 25
    if s.coins < cost then sync(player, "Verktyget kostar " .. cost .. " mynt.") return end
    s.coins, s.power = s.coins - cost, s.power + 1
    sync(player, "Verktyget har uppgraderats!")
end)
station("STÖRRE RYGGSÄCK", Vector3.new(28, 0.5, 0), Color3.fromRGB(205, 105, 255), function(player)
    local s = states[player]
    if not s then return end
    local cost = s.capacity * 2
    if s.coins < cost then sync(player, "Ryggsäcken kostar " .. cost .. " mynt.") return end
    s.coins, s.capacity = s.coins - cost, s.capacity + 25
    sync(player, "Ryggsäcken har uppgraderats!")
end)

Players.PlayerAdded:Connect(function(player)
    states[player] = {coins = 0, energy = 0, power = 1, capacity = 25, lastCollect = 0}
    local stats = Instance.new("Folder")
    stats.Name, stats.Parent = "leaderstats", player
    for _, name in ipairs({"Mynt", "Energi"}) do
        local value = Instance.new("IntValue")
        value.Name, value.Parent = name, stats
    end
    sync(player)
end)
Players.PlayerRemoving:Connect(function(player) states[player] = nil end)
actions.OnServerEvent:Connect(function(player, action)
    local s = states[player]
    if not s or action ~= "Collect" then return end
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    local now = os.clock()
    if now - s.lastCollect < 0.2 then return end
    s.lastCollect = now
    s.energy = math.min(s.capacity, s.energy + s.power)
    sync(player, s.energy == s.capacity and "Ryggsäcken är full! Gå till SÄLJ ENERGI." or nil)
end)
