--// LOAD
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

--// WINDOW
local Window = Rayfield:CreateWindow({
    Name = "PvP Menu",
    LoadingTitle = "PvP Menu",
    LoadingSubtitle = "Hitbox Fixed",
    ConfigurationSaving = {
        Enabled = false
    }
})

--// TAB
local Tab = Window:CreateTab("Hitbox", 4483362458)

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

--// VARIABLES
local hitboxEnabled = false
local hitboxSize = 4
local hitboxTransparency = 0.5

--// UI
Tab:CreateToggle({
    Name = "Hitbox Expander",
    CurrentValue = false,
    Callback = function(v)
        hitboxEnabled = v
    end
})

Tab:CreateSlider({
    Name = "Size",
    Range = {4, 50},
    Increment = 1,
    CurrentValue = 4,
    Callback = function(v)
        hitboxSize = v
    end
})

Tab:CreateSlider({
    Name = "Transparency",
    Range = {5, 10},
    Increment = 1,
    CurrentValue = 5,
    Callback = function(v)
        hitboxTransparency = v / 10
    end
})

--// LOOP ESTÁVEL
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = p.Character:FindFirstChild("Humanoid")

            if hrp and humanoid and humanoid.Health > 0 then
                if hitboxEnabled then
                    hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                    hrp.Transparency = hitboxTransparency
                    hrp.CanCollide = false
                else
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                end
            end
        end
    end
end)              (part.Position - Camera.CFrame.Position).Unit * 500
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
