--// LOAD
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

--// WINDOW
local Window = Rayfield:CreateWindow({
    Name = "PvP Menu",
    LoadingTitle = "PvP Menu",
    LoadingSubtitle = "v3 Silent Aim",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "PvPMenu"
    }
})

--// TABS
local CombatTab = Window:CreateTab("Combat", 4483362458)
local HitboxTab = Window:CreateTab("Hitbox", 4483362458)

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// VARIABLES
local silentAimPlayer = false
local silentAimNPC = false
local targetPart = "Head"
local teamCheck = false
local wallCheck = false

local hitboxEnabled = false
local hitboxSize = 4
local hitboxTransparency = 0.5

--// HITBOX
HitboxTab:CreateToggle({
    Name = "Hitbox Expander",
    CurrentValue = false,
    Callback = function(v) hitboxEnabled = v end
})

HitboxTab:CreateSlider({
    Name = "Size",
    Range = {4, 50},
    Increment = 1,
    CurrentValue = 4,
    Callback = function(v) hitboxSize = v end
})

HitboxTab:CreateSlider({
    Name = "Transparency",
    Range = {5, 10},
    Increment = 1,
    CurrentValue = 5,
    Callback = function(v) hitboxTransparency = v/10 end
})

--// COMBAT
CombatTab:CreateToggle({
    Name = "Silent Aim (Player)",
    CurrentValue = false,
    Callback = function(v) silentAimPlayer = v end
})

CombatTab:CreateToggle({
    Name = "Silent Aim (NPC)",
    CurrentValue = false,
    Callback = function(v) silentAimNPC = v end
})

CombatTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "HumanoidRootPart"},
    CurrentOption = "Head",
    Callback = function(v) targetPart = v end
})

CombatTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Callback = function(v) teamCheck = v end
})

CombatTab:CreateToggle({
    Name = "Wall Check",
    CurrentValue = false,
    Callback = function(v) wallCheck = v end
})

--// TARGET SYSTEM
local function isVisible(part, character)
    if not wallCheck then return true end

    local ray = workspace:Raycast(
        Camera.CFrame.Position,
        (part.Position - Camera.CFrame.Position).Unit * 500
    )

    if ray and not ray.Instance:IsDescendantOf(character) then
        return false
    end

    return true
end

local function getClosestTarget()
    local closest = nil
    local dist = math.huge

    -- PLAYERS
    if silentAimPlayer then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild(targetPart) then
                
                if teamCheck and p.Team == LP.Team then
                    continue
                end

                local
--// HITBOX ABA
HitboxTab:CreateToggle({
    Name = "Hitbox Expander",
    CurrentValue = false,
    Callback = function(v)
        hitboxEnabled = v
    end
})

HitboxTab:CreateSlider({
    Name = "Size",
    Range = {4, 50},
    Increment = 1,
    CurrentValue = 4,
    Callback = function(v)
        hitboxSize = v
    end
})

HitboxTab:CreateSlider({
    Name = "Transparency",
    Range = {5, 10}, -- 0.5 até 1.0
    Increment = 1,
    CurrentValue = 5,
    Callback = function(v)
        hitboxTransparency = v / 10
    end
})

--// COMBAT ABA
CombatTab:CreateToggle({
    Name = "Auto Fire",
    CurrentValue = false,
    Callback = function(v)
        autoFire = v
    end
})

CombatTab:CreateDropdown({
    Name = "Target",
    Options = {"Head", "HumanoidRootPart"},
    CurrentOption = "Head",
    Callback = function(v)
        targetPart = v
    end
})

CombatTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Callback = function(v)
        teamCheck = v
    end
})

CombatTab:CreateToggle({
    Name = "Wall Check",
    CurrentValue = false,
    Callback = function(v)
        wallCheck = v
    end
})

--// TARGET SYSTEM (IA simples)
local function getTarget()
    local closest = nil
    local dist = math.huge

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild(targetPart) then
            
            if teamCheck and p.Team == LP.Team then
                continue
            end

            local part = p.Character[targetPart]
            local screenPos, visible = Camera:WorldToViewportPoint(part.Position)

            if visible then
                local magnitude = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude

                if magnitude < dist then
                    if wallCheck then
                        local ray = workspace:Raycast(
                            Camera.CFrame.Position,
                            (part.Position - Camera.CFrame.Position).Unit * 500
                        )

                        if ray and not ray.Instance:IsDescendantOf(p.Character) then
                            continue
                        end
                    end

                    dist = magnitude
                    closest = p
                end
            end
        end
    end

    return closest
end

--// HITBOX LOOP
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart

            if hitboxEnabled then
                hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                hrp.Transparency = hitboxTransparency
                hrp.CanCollide = false
            else
                hrp.Size = Vector3.new(2,2,1)
                hrp.Transparency = 1
            end
        end
    end
end)

--// AUTO FIRE MELHORADO
RunService.RenderStepped:Connect(function()
    if not autoFire then return end

    local target = getTarget()
    if not target or not target.Character then return end

    local part = target.Character:FindFirstChild(targetPart)
    if not part then return end

    -- AIM
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)

    -- DISPARO COMPATÍVEL (FUNCIONA MELHOR)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    task.wait()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end)
