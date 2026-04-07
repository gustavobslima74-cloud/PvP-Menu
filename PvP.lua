--// LOAD RAYFIELD
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

--// WINDOW
local Window = Rayfield:CreateWindow({
    Name = "PvP Menu",
    LoadingTitle = "PvP Menu",
    LoadingSubtitle = "by Luiz",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "PvPMenu"
    }
})

--// TAB
local CombatTab = Window:CreateTab("Combat", 4483362458)

--// VARIABLES
local hitboxEnabled = false
local hitboxSize = 4

local autoFire = false
local targetPart = "Head"

local teamCheck = false
local wallCheck = false

local highlightEnabled = true

--// HITBOX EXPANDER
CombatTab:CreateToggle({
    Name = "Hitbox Expander",
    CurrentValue = false,
    Flag = "HitboxToggle",
    Callback = function(Value)
        hitboxEnabled = Value
    end,
})

CombatTab:CreateSlider({
    Name = "Hitbox Size",
    Range = {4, 50},
    Increment = 1,
    Suffix = "Size",
    CurrentValue = 4,
    Flag = "HitboxSize",
    Callback = function(Value)
        hitboxSize = Value
    end,
})

--// AUTO FIRE
CombatTab:CreateToggle({
    Name = "Auto Fire",
    CurrentValue = false,
    Flag = "AutoFire",
    Callback = function(Value)
        autoFire = Value
    end,
})

CombatTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "HumanoidRootPart"},
    CurrentOption = "Head",
    Flag = "TargetPart",
    Callback = function(Value)
        targetPart = Value
    end,
})

--// CHECKS
CombatTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Flag = "TeamCheck",
    Callback = function(Value)
        teamCheck = Value
    end,
})

CombatTab:CreateToggle({
    Name = "Wall Check",
    CurrentValue = false,
    Flag = "WallCheck",
    Callback = function(Value)
        wallCheck = Value
    end,
})

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// FUNCTION: GET TARGET
local function getTarget()
    local closest = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild(targetPart) then
            
            if teamCheck and player.Team == LP.Team then
                continue
            end

            local part = player.Character[targetPart]
            local pos, visible = Camera:WorldToViewportPoint(part.Position)

            if visible then
                local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude

                if distance < shortestDistance then
                    if wallCheck then
                        local ray = Ray.new(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * 500)
                        local hit = workspace:FindPartOnRay(ray, LP.Character)

                        if hit and not hit:IsDescendantOf(player.Character) then
                            continue
                        end
                    end

                    shortestDistance = distance
                    closest = player
                end
            end
        end
    end

    return closest
end

--// HITBOX LOOP
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart

            if hitboxEnabled then
                hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                hrp.Transparency = 0.5
                hrp.CanCollide = false
            else
                hrp.Size = Vector3.new(2,2,1)
                hrp.Transparency = 1
            end
        end
    end
end)

--// HIGHLIGHT
local highlights = {}

local function updateHighlight(player, canShoot)
    if not player.Character then return end

    if not highlights[player] then
        local hl = Instance.new("Highlight")
        hl.Parent = player.Character
        highlights[player] = hl
    end

    highlights[player].FillColor = canShoot and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
end

--// AUTO FIRE LOOP
RunService.RenderStepped:Connect(function()
    if not autoFire then return end

    local target = getTarget()

    if target and target.Character and target.Character:FindFirstChild(targetPart) then
        local part = target.Character[targetPart]

        -- AIM
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)

        -- CHECK SHOOT POSSIBILITY
        local canShoot = true

        if wallCheck then
            local ray = Ray.new(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * 500)
            local hit = workspace:FindPartOnRay(ray, LP.Character)

            if hit and not hit:IsDescendantOf(target.Character) then
                canShoot = false
            end
        end

        updateHighlight(target, canShoot)

        -- FIRE (simula clique)
        if canShoot then
            mouse1press()
            task.wait()
            mouse1release()
        end
    end
end)
