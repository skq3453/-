loadstring(game:HttpGet('https://raw.githubusercontent.com/drillygzzly/Roblox-UI-Libs/main/Yun%20V2%20Lib/Yun%20V2%20Lib%20Source.lua'))()

local Library = initLibrary()
local Window = Library:Load({name = "Shadow.cc", sizeX = 425, sizeY = 512, color = Color3.fromRGB(86, 0, 255)})

local tab1 = Window:Tab("Main")

local sec1 = tab1:Section{name = "Magnets", column = 1}

local plr = game:GetService("Players").LocalPlayer
local char = plr.Character
local ws = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local hitbox = Instance.new("Part")
hitbox.Size = Vector3.new(0, 0, 0)
hitbox.Transparency = 1
hitbox.Anchored = true
hitbox.CanCollide = false
hitbox.Parent = ws
hitbox.Shape = Enum.PartType.Ball
hitbox.Material = Enum.Material.ForceField

local magsToggle = false
local hitboxSize = 0
local restoreHitboxSize = 0
local MagsUpdate = 0
local magnetMode = "Custom"

function followBall()
    for i, v in pairs(Workspace:GetChildren()) do
        if v.Name == "Football" and v:IsA("BasePart") then
            local closestDistance = math.huge
            local distance = (char.Torso.Position - v.Position).magnitude
            if distance <= closestDistance then
                hitbox.CFrame = v.CFrame
            end
        end
    end
end

function fixHitbox()
    hitbox.Rotation = Vector3.new(0, 0, 0)
end

RunService.Heartbeat:Connect(function()
    followBall()
    fixHitbox()
end)

sec1:Toggle {
    Name = "Show Football Hitbox",
    flag = "ooolol", 
    callback = function(bool)
        if bool then
            hitbox.Transparency = 0.01
        else
            hitbox.Transparency = 1
        end
    end
}

sec1:dropdown {
    name = "Hitbox Color",
    content = {"Dark Red", "Electric Dark Blue", "Green", "Purple", "Orange", "Violet Red", "Black"},
    multichoice = false,
    callback = function(selectedOption)
        if selectedOption == "Dark Red" then
            hitbox.Color = Color3.fromRGB(139, 0, 0)  -- dark red
        elseif selectedOption == "Electric Dark Blue" then
            hitbox.Color = Color3.fromRGB(0, 0, 255)  -- electric dark blue (a vaibrant blue)
        elseif selectedOption == "Green" then
            hitbox.Color = Color3.fromRGB(0, 255, 0)  -- bright green
        elseif selectedOption == "Purple" then
            hitbox.Color = Color3.fromRGB(75, 0, 130)  -- dark purple
        elseif selectedOption == "Orange" then
            hitbox.Color = Color3.fromRGB(255, 165, 0)  -- orange
        elseif selectedOption == "Violet Red" then
            hitbox.Color = Color3.fromRGB(174, 50, 174)  -- violet red (idea from gojo and kashimo and sukuna)
        elseif selectedOption == "Black" then
            hitbox.Color = Color3.fromRGB(0, 0, 0)  -- black
        end
    end
}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

hitboxSize = 0
local hitboxDelay = 0
local tableHitboxDelay = 0

local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getClosestFootball(character)
    local closestFootball = nil
    local closestDistance = hitboxSize

    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("BasePart") and obj.Name == "Football" then
            local distance = (obj.Position - character.HumanoidRootPart.Position).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestFootball = obj
            end
        end
    end

    return closestFootball
end

local function catchFootball(football, catchRight)
    if football then
        local tweenInfo = TweenInfo.new(hitboxDelay, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(catchRight, tweenInfo, {Position = football.Position})
        tween:Play()
    end
end

RunService.Heartbeat:Connect(function()
    local character = getCharacter()
    local catchRight = character:FindFirstChild("CatchRight")
    
    if catchRight then
        local closestFootball = getClosestFootball(character)
        if closestFootball then
            catchFootball(closestFootball, catchRight)
        end
    end
end)

sec1:Toggle {
    Name = "Enable Magnets",
    flag = "ooolol", 
    callback = function(bool)
        magsToggle = bool
        if magsToggle then
            hitbox.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
            hitboxDelay = tableHitboxDelay
        else
            restoreHitboxSize = hitboxSize
            hitboxSize = 0
            hitbox.Size = Vector3.new(0, 0, 0)
            tableHitboxDelay = hitboxDelay
            hitboxDelay = 0
        end
    end
}

sec1:dropdown {
    name = "Magnet Mode",
    content = {"Custom", "Blatant", "League", "Legit"},
    multichoice = false,
    callback = function(mode)
        magnetMode = mode
        if magnetMode == "Blatant" then
            hitboxSize = hitboxSize + 16
        elseif magnetMode == "League" then
            hitboxSize = hitboxSize - 14
        elseif magnetMode == "Legit" then
            hitboxSize = hitboxSize - 16
        elseif magnetMode == "Custom" then
            hitboxSize = hitboxSize + 0
        end
        hitbox.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
    end
}

sec1:Slider {
    Name = "Magnet Distance",
    Default = 0,
    Min = 0,
    Max = 25,
    Decimals = 1,
    Flag = "moooooo",
    callback = function(value)
        if magsToggle then
            hitboxSize = value
            restoreHitboxSize = value
            if magnetMode == "Blatant" then
                hitboxSize = hitboxSize + 16
            elseif magnetMode == "League" then
                hitboxSize = hitboxSize - 14
            elseif magnetMode == "Legit" then
                hitboxSize = hitboxSize - 16
            elseif magnetMode == "Custom" then
                hitboxSize = hitboxSize + 0
            end
            hitbox.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
        end
    end
}

sec1:Slider {
    Name = "Magnet Delay",
    Default = 0,
    Min = 0,
    Max = 1,
    Decimals = 1,
    Flag = "moooooo",
    callback = function(bool)
        if magsToggle then
            hitboxDelay = bool
            tableHitboxDelay = bool
        end
    end
}

local sec2 = tab1:Section{name = "JumpPower", column = 2}

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local jumpToggle = false
local jumpBoostAmount = 0
local tableJP = 0
local character, humanoid, humanoidRootPart

local function checkCharacterExists()
    character = player.Character or player.CharacterAdded:Wait()

    humanoid = character:WaitForChild("Humanoid")
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    humanoid.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Jumping then
            task.wait(0.01)
            humanoidRootPart.Velocity = Vector3.new(humanoidRootPart.Velocity.X, humanoidRootPart.Velocity.Y + jumpBoostAmount)
        end
    end)
end

checkCharacterExists()

player.CharacterAdded:Connect(checkCharacterExists)

sec2:Toggle {
    Name = "Enable JP",
    flag = "ooolol", 
    callback = function(bool)
        jumpToggle = bool
        if jumpToggle then
            jumpBoostAmount = tableJP
        else
            tableJP = jumpBoostAmount
            jumpBoostAmount = 0
        end
    end
}

sec2:Slider {
    Name = "JP Value",
    Default = 0,
    Min = 0,
    Max = 20,
    Decimals = 1,
    Flag = "moooooo",
    callback = function(bool)
        if jumpToggle then
            jumpBoostAmount = bool
            tableJP = bool
        end
    end
}

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local angleToggle = false
local BoostedJumpPower = 0
local TableAngleJP = 0

local boostActive = false

local function isShiftPressed()
    return UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
end

local function onCharacterMovement(character)
    local humanoid = character:WaitForChild("Humanoid")
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    humanoid.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Jumping then
            task.wait(0.05)
            local currentVelocity = humanoidRootPart.AssemblyLinearVelocity
            local jumpPower = boostActive and BoostedJumpPower
            humanoidRootPart.AssemblyLinearVelocity = Vector3.new(currentVelocity.X, jumpPower, currentVelocity.Z)
        end
    end)
end

local function applyJumpBoost()
    if not boostActive then
        boostActive = true
        local character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
        onCharacterMovement(character)
        task.delay(1, function()
            boostActive = BoostedJumpPower
        end)
    end
end

RunService.RenderStepped:Connect(function()
    if isShiftPressed() then
        applyJumpBoost()
    end
end)

sec2:Toggle {
    Name = "Enable Angle Enhancer",
    flag = "ooolol", 
    callback = function(bool)
        angleToggle = bool
        if angleToggle then
            BoostedJumpPower = TableAngleJP
        else
            TableAngleJP = BoostedJumpPower
            BoostedJumpPower = 0
        end
    end
}

sec2:Slider {
    Name = "Angle JP Value",
    Default = 50,
    Min = 50,
    Max = 70,
    Decimals = 1,
    Flag = "moooooo",
    callback = function(bool)
        if angleToggle then
            BoostedJumpPower = bool
            TableAngleJP = bool
        end
    end
}

local sec3 = tab1:Section{name = "QuickTP", column = 2}

local userInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local quickTPBind = Enum.KeyCode.F
local quickTPEnabled = false
local quickTPSpeed = 0
local tableTPSpeed = 0
local cooldownTime = 0.2

local quickTPCooldown = os.clock()
local player = Players.LocalPlayer

local function moveCharacterForward()
    local character = player.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChild("Humanoid")

    if not quickTPEnabled then return end
    if not character or not humanoidRootPart or not humanoid then return end
    if (os.clock() - quickTPCooldown) < cooldownTime then return end

    local speed = quickTPSpeed
    local forwardVector = humanoidRootPart.CFrame.LookVector

    humanoidRootPart.CFrame = humanoidRootPart.CFrame + (forwardVector * speed)

    quickTPCooldown = os.clock()
end

userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == quickTPBind then
        moveCharacterForward()
    end
end)

sec3:Toggle {
    Name = "Enable QuickTP",
    flag = "ooolol", 
    callback = function(bool)
        quickTPEnabled = bool
        if quickTPEnabled then
            quickTPSpeed = tableTPSpeed
        else
            tableTPSpeed = quickTPSpeed
            quickTPSpeed = 0
        end
    end
}

sec3:Slider {
    Name = "QuickTP Value",
    Default = 0,
    Min = 0,
    Max = 5,
    Decimals = 1,
    Flag = "moooooo",
    callback = function(bool)
        if quickTPEnabled then
            quickTPSpeed = bool
            tableTPSpeed = bool
        end
    end
}
