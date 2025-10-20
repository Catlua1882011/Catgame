if game.PlaceId == 2753915549 then
    World1 = true
elseif game.PlaceId == 4442272183 then
    World2 = true
elseif game.PlaceId == 7449423635 then
    World3 = true
else
    game:GetService("Players").LocalPlayer:Kick("Invalid Place ID")
end

local LocalPlayer = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

repeat task.wait() until game:IsLoaded() and LocalPlayer

getgenv().Setting = {
    ["Delay Hop"] = 1,
    ["Webhook"] = {
        ["url"] = "https://discord.com/api/webhooks/1377092717712113767/vGPO_a8cSo3gGd9KF5Ga_3hXlAEecvD3_B1d3BzD7b8XYEwBK5O63xZHns_-gFzPf1eV",
        ["Webhook Target Fruit"] = true,
        ["Webhook When Attack Factory"] = true,
        ["Webhook When Attack Raid Castle"] = true,
        ["Ping Discord"] = {
            ["Enabled"] = true, 
            ["Id Discord/Everyone"] = "272727282"
        },
        ["Enabled"] = true
    },
    ["Auto Farm Fruit"] = true,
    ["Attacking"] = {
        ["Weapon"] = "Melee",
        ["Raid Castle"] = true,
        ["Factory"] = true,
    }
}

getgenv().Team = "Marines"

if getgenv().Team == "Marines" then
    ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", "Marines")
elseif getgenv().Team == "Pirates" then
    ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
end

repeat
    task.wait(1)
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local chooseTeam = playerGui:FindFirstChild("ChooseTeam", true)
    local uiController = playerGui:FindFirstChild("UIController", true)
    
    if chooseTeam and chooseTeam.Visible and uiController then
        for _, v in pairs(getgc(true)) do
            if type(v) == "function" and getfenv(v).script == uiController then
                local constant = getconstants(v)
                pcall(function()
                    if (constant[1] == "Pirates" or constant[1] == "Marines") and #constant == 1 then
                        if constant[1] == getgenv().Team then
                            v(getgenv().Team)
                        end
                    end
                end)
            end
        end
    end
until LocalPlayer.Team

local plr = LocalPlayer
local lp = LocalPlayer
local thelocal = LocalPlayer
local replicated = ReplicatedStorage
local nonotify = true

function islive()
    local plr = game.Players.LocalPlayer
    local character = plr.Character or plr.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    return humanoid
end

if getgenv().noclipsetup ~= true then
    spawn(function()
        RunService.Stepped:Connect(function()
            if islive() then
                if getgenv().noclip then
                    for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end

                    if not islive() then
                        getgenv().noclip = false
                    end
                end
                if not LocalPlayer.Character.Head:FindFirstChild("BodyVelocity") and getgenv().noclip then
                    local ag = Instance.new("BodyVelocity")
                    ag.Velocity = Vector3.new(0, 0, 0)
                    ag.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    ag.P = 9000
                    ag.Parent = LocalPlayer.Character.Head
                    for r, v in pairs(LocalPlayer.Character:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                elseif not getgenv().noclip and LocalPlayer.Character.Head:FindFirstChild("BodyVelocity") then
                    LocalPlayer.Character.Head:FindFirstChild("BodyVelocity"):Destroy()
                end
            end
        end)
    end)
    getgenv().noclipsetup = true
end

spawn(function()
    while wait() do
        pcall(function()
            if nonotify then
                replicated.Assets.GUI.DamageCounter.Enabled = false
                plr.PlayerGui.Notifications.Enabled = false
            else
                replicated.Assets.GUI.DamageCounter.Enabled = true
                plr.PlayerGui.Notifications.Enabled = true
            end
        end)
    end
end)

local usebypassteleport = true
local farmfishv2 = false

function CheckNearestTeleporter(vcs)
    local vcspos = vcs.Position
    local min = math.huge
    local min2 = math.huge
    local placeId = game.PlaceId
    local OldWorld, NewWorld, ThreeWorld
    if placeId == 2753915549 then
        OldWorld = true
    elseif placeId == 4442272183 then
        NewWorld = true
    elseif placeId == 7449423635 then
        ThreeWorld = true
    end
    
    local TableLocations = {}
    
    if ThreeWorld then
        TableLocations = {
            ["Caslte On The Sea"] = Vector3.new(-5058.77490234375, 314.5155029296875, -3155.88330078125),
            ["Hydra"] = Vector3.new(5756.83740234375, 610.4240112304688, -253.9253692626953),
            ["Mansion"] = Vector3.new(-12463.8740234375, 374.9144592285156, -7523.77392578125),
            ["Temple of Time"] = Vector3.new(28282.5703125, 14896.8505859375, 105.1042709350586)
        }
    elseif NewWorld then
        TableLocations = {
            ["122"] = Vector3.new(923.21252441406, 126.9760055542, 32852.83203125),
            ["3032"] = Vector3.new(-6508.5581054688, 150.034996032715, -132.83953857422)
        }
    elseif OldWorld then
        TableLocations = {
            ["1"] = Vector3.new(-7894.6201171875, 5545.49169921875, -380.2467346191406),
            ["2"] = Vector3.new(-4607.82275390625, 872.5422973632812, -1667.556884765625),
            ["3"] = Vector3.new(61163.8515625, 11.759522438049316, 1819.7841796875),
            ["4"] = Vector3.new(3876.280517578125, 35.10614013671875, -1939.3201904296875)
        }
    end
    
    local TableLocations2 = {}
    if TableLocations then
        for i, v in pairs(TableLocations) do
            TableLocations2[i] = (v - vcspos).Magnitude
        end
        for i, v in pairs(TableLocations2) do
            if v < min then
                min = v
                min2 = v
            end
        end
        local choose
        for i, v in pairs(TableLocations2) do
            if v <= min then
                choose = TableLocations[i]
            end
        end
        local min3 = (vcspos - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        if min2 <= min3 then
            return choose
        end
    end
    return false
end

function requestEntrance(vector3)
    local args = {
        [1] = "requestEntrance",
        [2] = vector3
    }
    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
end

getgenv().Tweento = function(targetCFrame)
    getgenv().noclip = true
    if
        LocalPlayer and LocalPlayer.Character and
        LocalPlayer.Character:FindFirstChild("Humanoid") and
        LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and
        LocalPlayer.Character.Humanoid.Health > 0 and
        LocalPlayer.Character.HumanoidRootPart
    then
        if getgenv().TweenSpeed == nil then
            getgenv().TweenSpeed = 350
        end
        if LocalPlayer.Character.Humanoid.Sit and not getgenv().farmfishv2 then
            getgenv().noclip = false
            if LocalPlayer.Character.Humanoid.Sit then
                LocalPlayer.Character.Humanoid.Sit = false
                canceltween()
                getgenv().noclip = false
            end
        end
        local targetPos = targetCFrame.Position
        local Distance =
            (targetPos - LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude

        local Speed
        if Distance < 600 then
            Speed = getgenv().TweenSpeed
        elseif Distance >= 600 then
            Speed = getgenv().TweenSpeed
        end
        
        local bmg = CheckNearestTeleporter(targetCFrame)
        if type(bmg) ~= "boolean" and plr:DistanceFromCharacter(targetPos) >= 1000 then
            usebypassteleport = true
            pcall(function()
                tween:Cancel()
            end)
            requestEntrance(bmg)
            task.wait(1)
        end
        
        spawn(function()
            if usebypassteleport then
                task.wait(2)
                usebypassteleport = false
            end
        end)
        
        local tweenfunc = {}
        local tween_s = game:service("TweenService")
        local info =
            TweenInfo.new(
                (targetPos - LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude / 250,
                Enum.EasingStyle.Linear
            )
        local tween =
            tween_s:Create(
                LocalPlayer.Character["HumanoidRootPart"],
                info,
                { CFrame = targetCFrame }
            )
        tween:Play()
        getgenv().noclip = true
        function tweenfunc:Stop()
            tween:Cancel()
        end

        tween.Completed:Wait()
        LocalPlayer.Character.HumanoidRootPart.CFrame =
            CFrame.new(
                LocalPlayer.Character.HumanoidRootPart.CFrame.X,
                LocalPlayer.Character.HumanoidRootPart.CFrame.Y,
                LocalPlayer.Character.HumanoidRootPart.CFrame.Z
            )
    end

    if not tween then
        return tween
    end
    return tweenfunc
end

getgenv().canceltween = function()
    Tweento(plr.Character.HumanoidRootPart.CFrame)
end

local attempt = 0
spawn(function()
    while wait() do
        pcall(function()
            local starttime = tick()
            local oldpos = plr.Character.HumanoidRootPart.CFrame.p
            delay(0.1, function()
                if tick() - starttime >= 0 and (plr.Character.HumanoidRootPart.CFrame.p - oldpos).Magnitude >= 1600 and not usebypassteleport then
                    if attempt >= 2 then
                        canceltween()
                        local tickoldtp = tick()
                        repeat
                            wait()
                            canceltween()
                            task.wait(1)
                        until tick() - tickoldtp >= 1
                        attempt = 0
                    else
                        attempt = attempt + 1
                    end
                end
            end)
        end)
    end
end)

_G.AttackMobs = true
_G.FastAttack = true

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local player = LocalPlayer
local env = (getgenv or getrenv or getfenv)()
local cache = {
    lastClean = tick(),
    attackCount = 1,
    lastAttackTime = 0,
    attackCooldown = 0.01
}

local rs = ReplicatedStorage
local players = Players
local client = LocalPlayer
local Modules = ReplicatedStorage.Modules
local Net = Modules.Net
local Register_Hit, Register_Attack = Net:WaitForChild("RE/RegisterHit"), Net:WaitForChild("RE/RegisterAttack")
local modules = rs:WaitForChild("Modules")
local net = modules:WaitForChild("Net")
local charFolder = Workspace:WaitForChild("Characters")
local enemyFolder = Workspace:WaitForChild("Enemies")
local playerFolder = Players
local AttackModule = {}
local RegisterAttack = net:WaitForChild("RE/RegisterAttack")
local RegisterHit = net:WaitForChild("RE/RegisterHit")

local function FindRemotes()
    return {
        attack = RegisterAttack,
        hit = RegisterHit
    }
end

local remotes = FindRemotes()

local Funcs = {}

function GetAllBladeHits()
    bladehits = {}
    if not _G.AttackMobs then return bladehits end
    
    for _, v in pairs(Workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 
        and (v.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 65 then
            table.insert(bladehits, v)
        end
    end
    return bladehits
end

function Getplayerhit()
    bladehits = {}
    if not _G.AttackPlayer then return bladehits end
    
    for _, v in pairs(Workspace.Characters:GetChildren()) do
        if v.Name ~= LocalPlayer.Name and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 
        and (v.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 65 then
            table.insert(bladehits, v)
        end
    end
    return bladehits
end

function Funcs:Attack()
    local bladehits = {}
    for r,v in pairs(GetAllBladeHits()) do
        table.insert(bladehits, v)
    end
    for r,v in pairs(Getplayerhit()) do
        table.insert(bladehits, v)
    end
    if #bladehits == 0 then return end
    local args = {
        [1] = nil;
        [2] = {},
        [4] = "078da341"
    }
    for r, v in pairs(bladehits) do
        Register_Attack:FireServer(0)
        if not args[1] then
            args[1] = v.Head
        end
        args[2][r] = {
            [1] = v,
            [2] = v.HumanoidRootPart
        }
    end
    Register_Hit:FireServer(unpack(args))
end

local function IsEntityAlive(entity)
    if not entity then
        return false
    end
    local humanoid = entity:FindFirstChild("Humanoid")
    return humanoid and humanoid.Health > 0
end

local function GetEnemiesInRange(character, range)
    local enemies = Workspace.Enemies:GetChildren()
    local players = Players:GetPlayers()
    local targets = {}
    local playerPos = character:GetPivot().Position
    
    if _G.AttackMobs then
        for _, enemy in ipairs(enemies) do
            local rootPart = enemy:FindFirstChild("HumanoidRootPart")
            if rootPart and IsEntityAlive(enemy) then
                local distance = (rootPart.Position - playerPos).Magnitude
                if distance <= range then
                    table.insert(targets, enemy)
                end
            end
        end
    end
    
    if _G.AttackPlayer then
        for _, otherPlayer in ipairs(players) do
            if otherPlayer ~= player and otherPlayer.Character then
                local rootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                if rootPart and IsEntityAlive(otherPlayer.Character) then
                    local distance = (rootPart.Position - playerPos).Magnitude
                    if distance <= range then
                        table.insert(targets, otherPlayer.Character)
                    end
                end
            end
        end
    end
    
    return targets
end

function AttackNoCoolDown()
    local character = player.Character
    if not character then
        return
    end
    
    local equippedWeapon = nil
    for _, item in ipairs(character:GetChildren()) do
        if item:IsA("Tool") then
            equippedWeapon = item
            break
        end
    end
    
    if not equippedWeapon then
        return
    end
    
    local enemiesInRange = GetEnemiesInRange(character, 60)
    if #enemiesInRange == 0 then
        return
    end
    
    local storage = ReplicatedStorage
    local modules = storage:FindFirstChild("Modules")
    if not modules then
        return
    end
    
    local attackEvent = storage:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterAttack")
    local hitEvent = storage:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterHit")
    
    if not attackEvent or not hitEvent then
        return
    end
    
    local targets, mainTarget = {}, nil
    for _, enemy in ipairs(enemiesInRange) do
        if not enemy:GetAttribute("IsBoat") then
            local HitboxLimbs = {
                "RightLowerArm",
                "RightUpperArm",
                "LeftLowerArm",
                "LeftUpperArm",
                "RightHand",
                "LeftHand"
            }
            local head = enemy:FindFirstChild(HitboxLimbs[math.random(#HitboxLimbs)]) or enemy.PrimaryPart
            if head then
                table.insert(targets, {enemy, head})
                mainTarget = head
            end
        end
    end
    
    if not mainTarget then
        return
    end
    
    attackEvent:FireServer(0)
    
    local playerScripts = player:FindFirstChild("PlayerScripts")
    if not playerScripts then
        return
    end
    
    local localScript = playerScripts:FindFirstChildOfClass("LocalScript")
    while not localScript do
        playerScripts.ChildAdded:Wait()
        localScript = playerScripts:FindFirstChildOfClass("LocalScript")
    end
    
    local hitFunction
    if getsenv then
        local success, scriptEnv = pcall(getsenv, localScript)
        if success and scriptEnv then
            hitFunction = scriptEnv._G.SendHitsToServer
        end
    end
    
    local successFlags, combatRemoteThread = pcall(function()
        return require(modules.Flags).COMBAT_REMOTE_THREAD or false
    end)
    
    if successFlags and combatRemoteThread and hitFunction then
        hitFunction(mainTarget, targets)
    elseif successFlags and not combatRemoteThread then
        hitEvent:FireServer(mainTarget, targets)
    end
end

function AttackModule:AttackEnemy(EnemyHead, Table)
    if EnemyHead then
        for i = 1, 3 do
            RegisterAttack:FireServer(0)
            RegisterAttack:FireServer(1)
            RegisterAttack:FireServer(2)
            RegisterAttack:FireServer(3)
            RegisterHit:FireServer(EnemyHead, Table or {})
        end
    end
end

function AttackModule:AttackNearest()
    local mon = {
        nil,
        {}
    }
    
    if _G.AttackMobs then
        local nearestEnemies = {}
        for _, Enemy in enemyFolder:GetChildren() do
            if Enemy:FindFirstChild("HumanoidRootPart", true) and client:DistanceFromCharacter(Enemy.HumanoidRootPart.Position) < 145 then
                table.insert(nearestEnemies, {
                    enemy = Enemy,
                    root = Enemy:FindFirstChild("HumanoidRootPart"),
                    distance = client:DistanceFromCharacter(Enemy.HumanoidRootPart.Position)
                })
            end
        end
        
        table.sort(nearestEnemies, function(a, b)
            return a.distance < b.distance
        end)
        
        if #nearestEnemies > 0 then
            mon[1] = nearestEnemies[1].root
            
            for i = 2, math.min(4, #nearestEnemies) do
                table.insert(mon[2], {
                    [1] = nearestEnemies[i].enemy,
                    [2] = nearestEnemies[i].root
                })
            end
            
            self:AttackEnemy(unpack(mon))
        end
    end
    
    if _G.AttackPlayer then
        local nearestPlayers = {}
        for _, Player in playerFolder:GetChildren() do
            if Player ~= client and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart", true) then
                local distance = client:DistanceFromCharacter(Player.Character.HumanoidRootPart.Position)
                if distance < 145 then
                    table.insert(nearestPlayers, {
                        player = Player,
                        root = Player.Character:FindFirstChild("HumanoidRootPart"),
                        distance = distance
                    })
                end
            end
        end
        
        table.sort(nearestPlayers, function(a, b)
            return a.distance < b.distance
        end)
        
        if #nearestPlayers > 0 then
            local player = {
                nearestPlayers[1].root,
                {}
            }
            
            for i = 2, math.min(4, #nearestPlayers) do
                table.insert(player[2], {
                    [1] = nearestPlayers[i].player,
                    [2] = nearestPlayers[i].root
                })
            end
            
            self:AttackEnemy(unpack(player))
        end
    end
end

function AttackModule:BladeHits()
    self:AttackNearest()
end

getgenv().GetDistance = function(position)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return math.huge
    end
    return (position - character.HumanoidRootPart.Position).Magnitude
end

getgenv().GetBladeHits = function()
    local targets = {}
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return targets
    end

    local containers = {}
    
    if _G.AttackMobs then
        if Workspace:FindFirstChild("Enemies") then
            containers[#containers + 1] = Workspace.Enemies
        end
        if Workspace:FindFirstChild("Mobs") then
            containers[#containers + 1] = Workspace.Mobs
        end
    end
    
    if _G.AttackPlayer then
        if Workspace:FindFirstChild("Characters") then
            containers[#containers + 1] = Workspace.Characters
        end
        if Workspace:FindFirstChild("Players") then
            containers[#containers + 1] = Workspace.Players
        end
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                if player.Character:FindFirstChild("HumanoidRootPart") and IsEntityAlive(player.Character) then
                    local distance = getgenv().GetDistance(player.Character.HumanoidRootPart.Position)
                    if distance < 145 then
                        targets[#targets + 1] = {Entity = player.Character, Distance = distance}
                    end
                end
            end
        end
    end

    for _, container in ipairs(containers) do
        if container then
            for _, entity in pairs(container:GetChildren()) do
                if entity:IsA("Model") and entity.Name ~= LocalPlayer.Name then
                    if entity:FindFirstChild("HumanoidRootPart") and IsEntityAlive(entity) and not entity:GetAttribute("IsBoat") then
                        local distance = getgenv().GetDistance(entity.HumanoidRootPart.Position)
                        if distance < 145 then
                            targets[#targets + 1] = {Entity = entity, Distance = distance}
                        end
                    end
                end
            end
        end
    end

    table.sort(targets, function(a, b)
        return a.Distance < b.Distance
    end)
    
    local result = {}
    for i = 1, math.min(#targets, 4) do
        result[#result + 1] = targets[i].Entity
    end
    return result
end

local function CleanEffects()
    if tick() - cache.lastClean < 0.2 then
        return
    end
    cache.lastClean = tick()

    pcall(function()
        local worldOrigin = Workspace:FindFirstChild("_WorldOrigin")
        if worldOrigin then
            for _, v in pairs(worldOrigin:GetChildren()) do
                if v.Name:match("CurvedRing") or v.Name:match("SlashHit") or 
                   v.Name:match("SwordSlash") or v.Name:match("SlashTail") or 
                   v.Name:match("Sounds") then
                    v:Destroy()
                end
            end
        end
        
        for _, v in pairs(Workspace:GetChildren()) do
            if v:IsA("ParticleEmitter") or v:IsA("Sound") then
                v:Destroy()
            end
        end
    end)
end

getgenv().EnhancedAttack = function()
    if not _G.FastAttack then
        return
    end

    local currentTime = tick()
    if currentTime - cache.lastAttackTime < cache.attackCooldown then
        return
    end
    cache.lastAttackTime = currentTime

    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end

    local equippedWeapon = nil
    for _, item in ipairs(character:GetChildren()) do
        if item:IsA("Tool") then
            equippedWeapon = item
            break
        end
    end

    local enemies = getgenv().GetBladeHits()
    if #enemies == 0 then
        return
    end

    if equippedWeapon and equippedWeapon:FindFirstChild("LeftClickRemote") then
        for _, enemy in ipairs(enemies) do
            if enemy:FindFirstChild("HumanoidRootPart") then
                local direction = (enemy.HumanoidRootPart.Position - character:GetPivot().Position).Unit
                for i = 1, 2 do
                    pcall(function()
                        equippedWeapon.LeftClickRemote:FireServer(direction, cache.attackCount)
                    end)
                    cache.attackCount = (cache.attackCount % 500) + 1
                end
            end
        end
    elseif remotes.attack and remotes.hit then
        local targets = {}
        local mainTarget = nil
        local playerPos = character:GetPivot().Position

        for _, enemy in ipairs(enemies) do
            local head = enemy:FindFirstChild("Head") or enemy:FindFirstChild("HumanoidRootPart")
            if head and (playerPos - head.Position).Magnitude <= 145 then
                if mainTarget == nil then
                    mainTarget = head
                end
                table.insert(targets, {enemy, head})
            end
        end

        if mainTarget and #targets > 0 then
            for j = 1, 2 do
                for i = 0, 3 do
                    pcall(function()
                        remotes.attack:FireServer(i)
                    end)
                end
                
                pcall(function()
                    remotes.hit:FireServer(mainTarget, targets)
                end)
            end
        end
    end
    
    CleanEffects()
end

function NormalAttack()
    AttackModule:BladeHits()
end

getgenv().Attack = function()
    if _G.FastAttack then
        getgenv().EnhancedAttack()
        pcall(function()
            Funcs:Attack()
        end)
    else
        AttackModule:BladeHits()
    end
end

CameraShakerR = require(ReplicatedStorage.Util.CameraShaker)
CameraShakerR:Stop()

get_Monster = function()
    for a, b in pairs(Workspace.Enemies:GetChildren()) do
        local c = b:FindFirstChild("UpperTorso") or b:FindFirstChild("Head")
        if b:FindFirstChild("HumanoidRootPart", true) and c then
            if (b.Head.Position - player.Character.HumanoidRootPart.Position).Magnitude <= 50 then
                return true, c.Position
            end
        end
    end
    
    for a, d in pairs(Workspace.SeaBeasts:GetChildren()) do
        if d:FindFirstChild("HumanoidRootPart") and d:FindFirstChild("Health") and d.Health.c > 0 then
            return true, d.HumanoidRootPart.Position
        end
    end
    
    for a, d in pairs(Workspace.Enemies:GetChildren()) do
        if d:FindFirstChild("Health") and d.Health.c > 0 and d:FindFirstChild("VehicleSeat") then
            return true, d.Engine.Position
        end
    end
end

Actived = function()
    local a = player.Character:FindFirstChildOfClass("Tool")
    if not a then return end
    
    for b, c in next, getconnections(a.Activated) do
        if typeof(c.Function) == 'function' then
            getupcs(c.Function)
        end
    end
end

local function AutoAttackLoop()
    if _G.FastAttack then
        pcall(getgenv().Attack)
    end
end

local attackConnection
local cleanConnection

local function StartFastAttack()
    if attackConnection then
        pcall(function()
            attackConnection:Disconnect()
        end)
    end
    if cleanConnection then
        pcall(function()
            cleanConnection:Disconnect()
        end)
    end

    if _G.FastAttack then
        attackConnection = RunService.Heartbeat:Connect(function()
            pcall(AutoAttackLoop)
            pcall(AttackNoCoolDown)
            pcall(function()
                Funcs:Attack()
            end)
        end)
        
        cleanConnection = RunService.RenderStepped:Connect(function()
            pcall(CleanEffects)
        end)
    end
end

getgenv().FastattackNormal = AttackModule.BladeHits
getgenv().FastattackBladeHits = AttackModule.BladeHits

pcall(function()
    Debris:AddItem(script, 0)
end)

task.spawn(function()
    RunService.Heartbeat:Connect(function()
        pcall(function()
            if not _G.FastAttack then
                return
            end
            
            AttackNoCoolDown()
            Funcs:Attack()
            
            local Pretool = player.Character:FindFirstChildOfClass("Tool")
            if not Pretool then return end
            
            local ToolTip = Pretool.ToolTip
            local MobAura, Mon = get_Monster()
            
            if ToolTip == "Blox Fruit" then
                if MobAura then
                    local LeftClickRemote = Pretool:FindFirstChild('LeftClickRemote')
                    if LeftClickRemote then
                        Actived()
                        LeftClickRemote:FireServer(Vector3.new(0.01, -500, 0.01), 1, true)
                        LeftClickRemote:FireServer(false)
                    end
                end
            end
        end)
    end)
end)

pcall(function()
    StartFastAttack()
end)

local cg = game:GetService("CoreGui")
local player = game:GetService("Players").LocalPlayer

if cg:FindFirstChild('Crystal hub') then
    cg:FindFirstChild('Crystal hub'):Destroy()
end

local C = {
    UI = {},
    Data = {},
    Func = {},
    Webhook = {},
    Fruit = {}
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Crystal hub"
ScreenGui.Parent = cg
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local function createGrad(colors)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(colors)
    return gradient
end

local defGrad = {
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 127)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 191, 255))
}

C.UI.DSH = Instance.new("Frame")
C.UI.DSH.AnchorPoint = Vector2.new(0.5, 0)
C.UI.DSH.BackgroundTransparency = 1
C.UI.DSH.BorderSizePixel = 0
C.UI.DSH.Position = UDim2.new(0.5, 0, 0.05, 0)
C.UI.DSH.Size = UDim2.new(0, 350, 0, 70)
C.UI.DSH.ZIndex = 1000
C.UI.DSH.Parent = ScreenGui

C.UI.DS = Instance.new("ImageLabel")
C.UI.DS.Image = "rbxassetid://6015897843"
C.UI.DS.ImageColor3 = Color3.fromRGB(0, 0, 0)
C.UI.DS.ImageTransparency = 0.5
C.UI.DS.ScaleType = Enum.ScaleType.Slice
C.UI.DS.SliceCenter = Rect.new(49, 49, 450, 450)
C.UI.DS.AnchorPoint = Vector2.new(0.5, 0.5)
C.UI.DS.BackgroundTransparency = 1
C.UI.DS.BorderSizePixel = 0
C.UI.DS.Position = UDim2.new(0.5, 0, 0.5, 0)
C.UI.DS.Size = UDim2.new(1, 40, 1, 40)
C.UI.DS.ZIndex = 1000
C.UI.DS.Parent = C.UI.DSH

C.UI.M = Instance.new("Frame")
C.UI.M.AnchorPoint = Vector2.new(0.5, 0.5)
C.UI.M.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
C.UI.M.BackgroundTransparency = 0.5
C.UI.M.BorderColor3 = Color3.fromRGB(0, 0, 0)
C.UI.M.BorderSizePixel = 0
C.UI.M.Position = UDim2.new(0.5, 0, 0.5, 0)
C.UI.M.Size = UDim2.new(1, -47, 1, -47)
C.UI.M.ZIndex = 1001
C.UI.M.Parent = C.UI.DS

local mCorner = Instance.new("UICorner")
mCorner.CornerRadius = UDim.new(0, 5)
mCorner.Parent = C.UI.M

local mStroke = Instance.new("UIStroke")
mStroke.Color = Color3.fromRGB(255, 255, 255)
mStroke.Thickness = 2
mStroke.Parent = C.UI.M
createGrad(defGrad).Parent = mStroke

C.UI.T = Instance.new("ImageLabel")
C.UI.T.Size = UDim2.new(0, 24, 0, 24)
C.UI.T.Position = UDim2.new(0.5, 0, 0, -12)
C.UI.T.AnchorPoint = Vector2.new(0.5, 0)
C.UI.T.BackgroundTransparency = 1
C.UI.T.Image = "rbxassetid://129781592728096"
C.UI.T.Rotation = 15
C.UI.T.ZIndex = 2
C.UI.T.Parent = C.UI.M

C.UI.S1 = Instance.new("TextLabel")
C.UI.S1.Font = Enum.Font.Code
C.UI.S1.Text = "Crystal Hub"
C.UI.S1.TextColor3 = Color3.fromRGB(255, 255, 255)
C.UI.S1.TextSize = 16
C.UI.S1.TextYAlignment = Enum.TextYAlignment.Center
C.UI.S1.AnchorPoint = Vector2.new(0.5, 0)
C.UI.S1.BackgroundTransparency = 1
C.UI.S1.BorderSizePixel = 0
C.UI.S1.Position = UDim2.new(0.5, 0, 0, 8)
C.UI.S1.Size = UDim2.new(1, -20, 0, 22)
C.UI.S1.ZIndex = 1002
C.UI.S1.Parent = C.UI.M
createGrad(defGrad).Parent = C.UI.S1

C.UI.S2 = Instance.new("TextLabel")
C.UI.S2.Font = Enum.Font.Code
C.UI.S2.Text = "Fruit: ... | Collect: ..."
C.UI.S2.TextColor3 = Color3.fromRGB(255, 255, 255)
C.UI.S2.TextSize = 14
C.UI.S2.TextYAlignment = Enum.TextYAlignment.Center
C.UI.S2.AnchorPoint = Vector2.new(0.5, 0)
C.UI.S2.BackgroundTransparency = 1
C.UI.S2.BorderSizePixel = 0
C.UI.S2.Position = UDim2.new(0.5, 0, 0, 30.7)
C.UI.S2.Size = UDim2.new(1, -20, 0, 22)
C.UI.S2.ZIndex = 1002
C.UI.S2.Parent = C.UI.M
createGrad(defGrad).Parent = C.UI.S2

C.Data.StartTime = tick()

C.UI.MC = Instance.new("Frame")
C.UI.MC.Position = UDim2.new(0.5, 0, 0.24, 0)
C.UI.MC.Size = UDim2.new(0.9, 0, 0.7, 0)
C.UI.MC.AnchorPoint = Vector2.new(0.5, 0)
C.UI.MC.BackgroundTransparency = 1
C.UI.MC.ZIndex = 999
C.UI.MC.Parent = ScreenGui

C.UI.IP = Instance.new("Frame")
C.UI.IP.Position = UDim2.new(0, 0, 0, 0)
C.UI.IP.Size = UDim2.new(0.3, -10, 1, 0)
C.UI.IP.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
C.UI.IP.BackgroundTransparency = 0.25
C.UI.IP.BorderSizePixel = 0
C.UI.IP.ZIndex = 1000
C.UI.IP.Parent = C.UI.MC

local ipCorner = Instance.new("UICorner")
ipCorner.CornerRadius = UDim.new(0, 8)
ipCorner.Parent = C.UI.IP

local ipStroke = Instance.new("UIStroke")
ipStroke.Color = Color3.fromRGB(255, 255, 255)
ipStroke.Thickness = 1.5
ipStroke.Parent = C.UI.IP
createGrad(defGrad).Parent = ipStroke

C.UI.TC = Instance.new("Frame")
C.UI.TC.Position = UDim2.new(0.3, 5, 0, 0)
C.UI.TC.Size = UDim2.new(0.7, -5, 1, 0)
C.UI.TC.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
C.UI.TC.BackgroundTransparency = 0.25
C.UI.TC.BorderSizePixel = 0
C.UI.TC.ZIndex = 1000
C.UI.TC.Parent = C.UI.MC

local tcCorner = Instance.new("UICorner")
tcCorner.CornerRadius = UDim.new(0, 8)
tcCorner.Parent = C.UI.TC

local tcStroke = Instance.new("UIStroke")
tcStroke.Color = Color3.fromRGB(255, 255, 255)
tcStroke.Thickness = 1.5
tcStroke.Parent = C.UI.TC
createGrad(defGrad).Parent = tcStroke

C.UI.ContentScroll = Instance.new("ScrollingFrame")
C.UI.ContentScroll.Position = UDim2.new(0, 0, 0, 0)
C.UI.ContentScroll.Size = UDim2.new(1, 0, 1, 0)
C.UI.ContentScroll.BackgroundTransparency = 1
C.UI.ContentScroll.BorderSizePixel = 0
C.UI.ContentScroll.ScrollBarThickness = 4
C.UI.ContentScroll.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
C.UI.ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
C.UI.ContentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
C.UI.ContentScroll.ZIndex = 1001
C.UI.ContentScroll.Parent = C.UI.TC

C.UI.ContentText = Instance.new("TextLabel")
C.UI.ContentText.Position = UDim2.new(0, 10, 0, 10)
C.UI.ContentText.Size = UDim2.new(1, -20, 0, 50)
C.UI.ContentText.BackgroundTransparency = 1
C.UI.ContentText.Text = "Loading..."
C.UI.ContentText.RichText = true
C.UI.ContentText.TextColor3 = Color3.fromRGB(255, 255, 255)
C.UI.ContentText.TextSize = 17
C.UI.ContentText.Font = Enum.Font.Code
C.UI.ContentText.TextXAlignment = Enum.TextXAlignment.Left
C.UI.ContentText.TextYAlignment = Enum.TextYAlignment.Top
C.UI.ContentText.TextWrapped = true
C.UI.ContentText.TextStrokeTransparency = 0.5
C.UI.ContentText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
C.UI.ContentText.ZIndex = 1002
C.UI.ContentText.AutomaticSize = Enum.AutomaticSize.Y
C.UI.ContentText.Parent = C.UI.ContentScroll

C.UI.DB = Instance.new("TextButton")
C.UI.DB.Position = UDim2.new(1, -130, 0, 10)
C.UI.DB.Size = UDim2.new(0, 120, 0, 28)
C.UI.DB.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
C.UI.DB.BackgroundTransparency = 0.3
C.UI.DB.BorderSizePixel = 0
C.UI.DB.Text = "Discord"
C.UI.DB.TextColor3 = Color3.fromRGB(255, 255, 255)
C.UI.DB.TextSize = 15
C.UI.DB.Font = Enum.Font.Code
C.UI.DB.ZIndex = 1003
C.UI.DB.Parent = ScreenGui

local dbCorner = Instance.new("UICorner")
dbCorner.CornerRadius = UDim.new(0, 5)
dbCorner.Parent = C.UI.DB

local dbStroke = Instance.new("UIStroke")
dbStroke.Color = Color3.fromRGB(255, 255, 255)
dbStroke.Thickness = 1
dbStroke.Parent = C.UI.DB
createGrad(defGrad).Parent = dbStroke

C.UI.DB.MouseButton1Click:Connect(function()
    setclipboard("discord.gg/brkdnrfyFT")
    C.UI.DB.Text = "Copied!"
    task.wait(1)
    C.UI.DB.Text = "Discord"
end)

C.UI.TL = Instance.new("TextLabel")
C.UI.TL.Position = UDim2.new(0, 10, 0, 10)
C.UI.TL.Size = UDim2.new(0, 100, 0, 28)
C.UI.TL.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
C.UI.TL.BackgroundTransparency = 0.3
C.UI.TL.BorderSizePixel = 0
C.UI.TL.Text = "00:00:00"
C.UI.TL.TextColor3 = Color3.fromRGB(255, 255, 255)
C.UI.TL.TextSize = 15
C.UI.TL.Font = Enum.Font.Code
C.UI.TL.ZIndex = 1003
C.UI.TL.Parent = ScreenGui

local tlCorner = Instance.new("UICorner")
tlCorner.CornerRadius = UDim.new(0, 5)
tlCorner.Parent = C.UI.TL

local tlStroke = Instance.new("UIStroke")
tlStroke.Color = Color3.fromRGB(255, 255, 255)
tlStroke.Thickness = 1
tlStroke.Parent = C.UI.TL
createGrad(defGrad).Parent = tlStroke

local infoLbls = {
    {name = "HD", yPos = 8, fmt = "Crystal Hub Checker", size = 19, bold = true},
    {name = "PN", yPos = 35, fmt = "User: <font color='rgb(138,43,226)'>%s</font>", size = 16},
    {name = "LV", yPos = 57, fmt = "Level: <font color='rgb(255,0,127)'>%s</font>", size = 16},
    {name = "BL", yPos = 79, fmt = "Beli: <font color='rgb(255,0,127)'>%s</font>", size = 16},
    {name = "FR", yPos = 101, fmt = "Fragments: <font color='rgb(138,43,226)'>%s</font>", size = 16},
    {name = "RC", yPos = 123, fmt = "Race: <font color='rgb(0,191,255)'>%s</font>", size = 16},
    {name = "DF", yPos = 145, fmt = "Devil Fruit: <font color='rgb(255,0,127)'>%s</font>", size = 16},
    {name = "AW", yPos = 167, fmt = "Awakened: %s", h = 52, size = 16}
}

C.UI.IL = {}

for _, info in ipairs(infoLbls) do
    local lbl = Instance.new("TextLabel")
    lbl.Position = UDim2.new(0, 10, 0, info.yPos)
    lbl.Size = UDim2.new(1, -20, 0, info.h or 22)
    lbl.BackgroundTransparency = 1
    lbl.Text = info.name == "HD" and info.fmt or "Loading..."
    lbl.RichText = true
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = info.size or 16
    lbl.Font = Enum.Font.Code
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = info.h and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
    lbl.TextWrapped = true
    lbl.TextStrokeTransparency = 0.5
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lbl.ZIndex = 1002
    lbl.Parent = C.UI.IP
    
    if info.name ~= "HD" then
        C.UI.IL[info.name] = lbl
    end
    
    if info.name == "HD" then
        createGrad(defGrad).Parent = lbl
    end
end

C.Data.Inv = {
    Over1M = "",
    Under1M = ""
}

C.Fruit.PendingFruits = {}
C.Fruit.CollectedFruits = {}
C.Fruit.IsCollecting = false

C.Webhook.SentFruits = {}

C.Func.FmtFruit = function(name)
    local fmt = string.gsub(name, "%-", " ")
    fmt = string.gsub(fmt, "(%a)(%a*)", function(first, rest)
        return string.upper(first) .. string.lower(rest)
    end)
    return "<font size='18' color='rgb(255,255,255)'><b>" .. fmt .. "</b></font>"
end

C.Func.ChkFruits = function()
    local success, inv = pcall(function()
        return ReplicatedStorage.Remotes.CommF_:InvokeServer("getInventory")
    end)
    
    if not success or not inv then
        return "Error", "Error"
    end
    
    local over, under = {}, {}
    
    for _, v in pairs(inv) do
        if v.Type == "Blox Fruit" then
            local price = v.Price or v.Value
            local name = type(v.Name) == "table" and table.concat(v.Name, ", ") or v.Name
            local fmt = C.Func.FmtFruit(name)
            local pText = "<font size='15' color='rgb(144,238,144)'> (" .. tostring(price) .. " Beli)</font>"
            
            if price >= 1000000 then
                table.insert(over, fmt .. pText)
            else
                table.insert(under, fmt .. pText)
            end
        end
    end
    
    local o = #over == 0 and "<font size='17' color='rgb(255,100,100)'><b>No fruits over 1M</b></font>" or table.concat(over, "\n")
    local u = #under == 0 and "<font size='17' color='rgb(255,100,100)'><b>No fruits under 1M</b></font>" or table.concat(under, "\n")
    
    return o, u
end

C.Func.UpdInv = function()
    C.Data.Inv.Over1M, C.Data.Inv.Under1M = C.Func.ChkFruits()
    
    if C.UI.ContentText then
        C.UI.ContentText.Text = "<font size='19' color='rgb(255,215,0)'><b>Fruits Over 1M Beli:</b></font>\n" .. 
                    (C.Data.Inv.Over1M or "None") .. 
                    "\n\n<font size='19' color='rgb(144,238,144)'><b>Fruits Under 1M Beli:</b></font>\n" .. 
                    (C.Data.Inv.Under1M or "None")
    end
end

C.Func.ChkRace = function()
    local s1, bf = pcall(function()
        return ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
    end)
    local s2, c4 = pcall(function()
        return ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "1")
    end)
    
    if player.Character and player.Character:FindFirstChild("RaceTransformed") then
        return player.Data.Race.Value .. " V4"
    end
    if s1 and bf == -2 then
        return player.Data.Race.Value .. " V3"
    end
    if s2 and c4 == -2 then
        return player.Data.Race.Value .. " V2"
    end
    return player.Data.Race.Value .. " V1"
end

C.Func.GetAw = function()
    local success, result = pcall(function()
        return ReplicatedStorage.Remotes.CommF_:InvokeServer("getAwakenedAbilities")
    end)
    
    if not success or not result or result == '' then
        return "<font color='rgb(255,100,100)'>None</font>"
    end
    
    local df = player.Data and player.Data.DevilFruit and player.Data.DevilFruit.Value
    local moves = {}
    
    if df == "Dough-Dough" then
        local ord = {'Z', 'F', 'X', 'C', 'TAP', 'V'}
        for _, key in ipairs(ord) do
            if result[key] and result[key]['Awakened'] == true then
                table.insert(moves, key)
            end
        end
    else
        local ord = result['F'] and {'Z', 'F', 'X', 'C', 'V'} or {'Z', 'X', 'C', 'V'}
        for _, key in ipairs(ord) do
            if result[key] and result[key]['Awakened'] == true then
                table.insert(moves, key)
            end
        end
    end
    
    return #moves > 0 and "<font color='rgb(0,255,0)'>" .. table.concat(moves, ", ") .. "</font>" or "<font color='rgb(255,100,100)'>None</font>"
end

C.Func.FmtNum = function(num)
    return tostring(num):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

C.Func.UpdStats = function()
    if player.Data and player.Data.Level then
        C.UI.IL.LV.Text = string.format(infoLbls[3].fmt, player.Data.Level.Value)
    end
    
    if player.DisplayName then
        C.UI.IL.PN.Text = string.format(infoLbls[2].fmt, player.DisplayName)
    end
    
    if player.Data and player.Data.Beli then
        C.UI.IL.BL.Text = string.format(infoLbls[4].fmt, C.Func.FmtNum(player.Data.Beli.Value))
    end
    
    if player.Data and player.Data.Fragments then
        C.UI.IL.FR.Text = string.format(infoLbls[5].fmt, C.Func.FmtNum(player.Data.Fragments.Value))
    end
    
    if player.Data and player.Data.Race then
        C.UI.IL.RC.Text = string.format(infoLbls[6].fmt, C.Func.ChkRace())
    end
    
    if player.Data and player.Data.DevilFruit then
        local fruitValue = player.Data.DevilFruit.Value
        if fruitValue and fruitValue ~= "" then
            C.UI.IL.DF.Text = string.format(infoLbls[7].fmt, fruitValue)
        else
            C.UI.IL.DF.Text = "Devil Fruit: <font color='rgb(255,100,100)'>None</font>"
        end
    else
        C.UI.IL.DF.Text = "Devil Fruit: <font color='rgb(255,100,100)'>None</font>"
    end
    
    C.UI.IL.AW.Text = string.format(infoLbls[8].fmt, C.Func.GetAw())
    
    local t = tick() - C.Data.StartTime
    local h = math.floor(t / 3600)
    local m = math.floor((t % 3600) / 60)
    local s = math.floor(t % 60)
    C.UI.TL.Text = string.format("%02d:%02d:%02d", h, m, s)
end

C.Data.Min = false

C.Func.Tog = function()
    C.Data.Min = not C.Data.Min
    C.UI.MC.Visible = not C.Data.Min
    C.UI.DB.Visible = not C.Data.Min
    C.UI.TL.Visible = not C.Data.Min
end

game:GetService("UserInputService").InputBegan:Connect(function(inp, proc)
    if not proc and inp.KeyCode == Enum.KeyCode.P then
        C.Func.Tog()
    end
end)

local BlurEff = Instance.new("BlurEffect")
BlurEff.Size = 12.5
BlurEff.Enabled = true
BlurEff.Parent = game:GetService("Lighting")

task.spawn(function()
    task.wait(2)
    pcall(C.Func.UpdInv)
end)

task.spawn(function()
    while task.wait(1) do
        pcall(C.Func.UpdStats)
    end
end)

local Crystal = {}

function Crystal:Notify(NotifyConfig)
    local NotifyConfig = NotifyConfig or {}
    NotifyConfig.Title = NotifyConfig.Title or "Alert"
    NotifyConfig.Content = NotifyConfig.Content or "Content"
    NotifyConfig.Logo = NotifyConfig.Logo or "rbxassetid://18289959127"
    NotifyConfig.Time = NotifyConfig.Time or 0.5
    NotifyConfig.Delay = NotifyConfig.Delay or 5
    local NotifyFunc = {}
    spawn(function()
        if not CoreGui:FindFirstChild("NotifyGui") then
            local NotifyGui = Instance.new("ScreenGui");
            NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            NotifyGui.Name = "NotifyGui"
            NotifyGui.Parent = CoreGui
        end
        if not CoreGui.NotifyGui:FindFirstChild("NotifyLayout") then
            local NotifyLayout = Instance.new("Frame");
            NotifyLayout.AnchorPoint = Vector2.new(1, 0)
            NotifyLayout.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            NotifyLayout.BackgroundTransparency = 0.9998999834060669
            NotifyLayout.BorderColor3 = Color3.fromRGB(0, 0, 0)
            NotifyLayout.BorderSizePixel = 0
            NotifyLayout.Position = UDim2.new(1, -10, 0, 10)
            NotifyLayout.Size = UDim2.new(0, 260, 1, -20)
            NotifyLayout.Name = "NotifyLayout"
            NotifyLayout.Parent = CoreGui.NotifyGui    
            local Count = 0
            local Count2 = 0
            CoreGui.NotifyGui.NotifyLayout.ChildRemoved:Connect(function()
                Count = 0
                for i, v in CoreGui.NotifyGui.NotifyLayout:GetChildren() do
                    TweenService:Create(
                        v,
                        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                        {Position = UDim2.new(0, 0, 0, (v.Size.Y.Offset + 12)*Count)}
                    ):Play()
                    Count = Count + 1
                end
            end)
            CoreGui.NotifyGui.NotifyLayout.ChildAdded:Connect(function(child)
                Count2 = 1
                for i, v in CoreGui.NotifyGui.NotifyLayout:GetChildren() do
                    if v ~= child then
                        TweenService:Create(
                            v,
                            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                            {Position = UDim2.new(0, 0, 0, (v.Size.Y.Offset + 12)*Count2)}
                        ):Play()
                        Count2 = Count2 + 1
                    end
                end
            end)
        end
        local NotifyFrame = Instance.new("Frame");
        local NotifyFrameReal = Instance.new("Frame");
        local UICorner = Instance.new("UICorner");
        local DropShadowHolder = Instance.new("Frame");
        local DropShadow = Instance.new("ImageLabel");
        local NotifyLogo = Instance.new("ImageLabel");
        local UICorner1 = Instance.new("UICorner");
        local NotifyTitle = Instance.new("TextLabel");
        local NotifyContent = Instance.new("TextLabel");
        local UIStroke = Instance.new("UIStroke");
        local AlertImage = Instance.new("ImageLabel");
    
        NotifyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        NotifyFrame.BackgroundTransparency = 0.999
        NotifyFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        NotifyFrame.BorderSizePixel = 0
        NotifyFrame.Size = UDim2.new(1, 0, 0, 70)
        NotifyFrame.Name = "NotifyFrame"
        NotifyFrame.Parent = CoreGui.NotifyGui.NotifyLayout
        NotifyFrame.Position = UDim2.new(0, 0, 0, 0)

        NotifyFrameReal.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        NotifyFrameReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
        NotifyFrameReal.BorderSizePixel = 0
        NotifyFrameReal.Position = UDim2.new(0, 270, 0, 0)
        NotifyFrameReal.Size = UDim2.new(1, 0, 1, 0)
        NotifyFrameReal.Name = "NotifyFrameReal"
        NotifyFrameReal.Parent = NotifyFrame

        UICorner.CornerRadius = UDim.new(0, 5)
        UICorner.Parent = NotifyFrameReal
    
        DropShadowHolder.BackgroundTransparency = 1
        DropShadowHolder.BorderSizePixel = 0
        DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
        DropShadowHolder.ZIndex = 0
        DropShadowHolder.Name = "DropShadowHolder"
        DropShadowHolder.Parent = NotifyFrameReal
    
        DropShadow.Image = "rbxassetid://6015897843"
        DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        DropShadow.ImageTransparency = 0.5
        DropShadow.ScaleType = Enum.ScaleType.Slice
        DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
        DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
        DropShadow.BackgroundTransparency = 1
        DropShadow.BorderSizePixel = 0
        DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
        DropShadow.Size = UDim2.new(1, 47, 1, 47)
        DropShadow.ZIndex = 0
        DropShadow.Name = "DropShadow"
        DropShadow.Parent = DropShadowHolder
    
        NotifyLogo.Image = NotifyConfig.Logo
        NotifyLogo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NotifyLogo.BackgroundTransparency = 0.999
        NotifyLogo.BorderColor3 = Color3.fromRGB(0, 0, 0)
        NotifyLogo.BorderSizePixel = 0
        NotifyLogo.AnchorPoint = Vector2.new(0, 0.5)
        NotifyLogo.Position = UDim2.new(0, 12, 0.5, 0)
        NotifyLogo.Size = UDim2.new(0, 45, 0, 45)
        NotifyLogo.Name = "NotifyLogo"
        NotifyLogo.Parent = NotifyFrameReal
    
        UICorner1.CornerRadius = UDim.new(0, 5)
        UICorner1.Parent = NotifyLogo
    
        NotifyTitle.Font = Enum.Font.GothamBold
        NotifyTitle.Text = NotifyConfig.Title
        NotifyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        NotifyTitle.TextSize = 12
        NotifyTitle.TextXAlignment = Enum.TextXAlignment.Left
        NotifyTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NotifyTitle.BackgroundTransparency = 0.999
        NotifyTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
        NotifyTitle.BorderSizePixel = 0
        NotifyTitle.Position = UDim2.new(0, 69, 0, 15)
        NotifyTitle.Size = UDim2.new(1, -140, 0, 14)
        NotifyTitle.Name = "NotifyTitle"
        NotifyTitle.Parent = NotifyFrameReal
    
        NotifyContent.Font = Enum.Font.Gotham
        NotifyContent.Text = NotifyConfig.Content
        NotifyContent.TextColor3 = Color3.fromRGB(80, 80, 80)
        NotifyContent.TextSize = 12
        NotifyContent.TextTransparency = 0.3
        NotifyContent.TextXAlignment = Enum.TextXAlignment.Left
        NotifyContent.TextYAlignment = Enum.TextYAlignment.Top
        NotifyContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NotifyContent.BackgroundTransparency = 0.999
        NotifyContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
        NotifyContent.BorderSizePixel = 0
        NotifyContent.Position = UDim2.new(0, 69, 0, 29)
        NotifyContent.Size = UDim2.new(1, -140, 0, 24)
        NotifyContent.Name = "NotifyContent"
        NotifyContent.Parent = NotifyFrameReal
    
        UIStroke.Color = Color3.fromRGB(80, 80, 80)
        UIStroke.Thickness = 0.3
        UIStroke.Parent = NotifyContent
    
        AlertImage.Image = "rbxassetid://18289906180"
        AlertImage.AnchorPoint = Vector2.new(1, 0.5)
        AlertImage.ImageColor3 = Color3.fromRGB(28, 12, 143)
        AlertImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        AlertImage.BackgroundTransparency = 0.999
        AlertImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
        AlertImage.BorderSizePixel = 0
        AlertImage.Position = UDim2.new(1, -12, 0.5, 0)
        AlertImage.Size = UDim2.new(0, 45, 0, 45)
        AlertImage.Parent = NotifyFrameReal
        
        NotifyContent.Size = UDim2.new(1, -140, 0, 12 + (12 * (NotifyContent.TextBounds.X // NotifyContent.AbsoluteSize.X)))
        NotifyContent.TextWrapped = true
        if NotifyContent.AbsoluteSize.Y < 25 then
            NotifyFrame.Size = UDim2.new(1, 0, 0, 70)
        else
            NotifyFrame.Size = UDim2.new(1, 0, 0, NotifyFrame.AbsoluteSize.Y + 17)
        end
        local waitclose = false
        function NotifyFunc:Close()
            if waitclose then
                return false
            end
            waitclose = true
            TweenService:Create(
                NotifyFrameReal,
                TweenInfo.new(tonumber(NotifyConfig.Time), Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                {Position = UDim2.new(0, 270, 0, 0)}
            ):Play()
            task.wait(tonumber(NotifyConfig.Time) / 1.2)
            NotifyFrame:Destroy()
        end
        TweenService:Create(
            NotifyFrameReal,
            TweenInfo.new(tonumber(NotifyConfig.Time), Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            {Position = UDim2.new(0, 0, 0, 0)}
        ):Play()
        task.wait(tonumber(NotifyConfig.Delay))
        NotifyFunc:Close()
    end)
    return NotifyFunc
end

World1 = game.PlaceId == 2753915549
World2 = game.PlaceId == 4442272183
World3 = game.PlaceId == 7449423635
Sea = World1 or World2 or World3 or plr:Kick("Games Not Supported ")

local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local isHopping = false
local lastFruitCheckTime = 0
local isTeleporting = false
local TweenSpeed = 350
local tween

local isAttackingFactory = false
local isAttackingRaidCastle = false

function AutoHaki()
    if not LocalPlayer.Character:FindFirstChild("HasBuso") then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
    end
end

function EquipWeapon(ToolSe)
    if LocalPlayer.Backpack:FindFirstChild(ToolSe) then
        local tool = LocalPlayer.Backpack:FindFirstChild(ToolSe)
        wait(0.4)
        LocalPlayer.Character.Humanoid:EquipTool(tool)
    end
end

function StoreFruit()
    for i,v in pairs(thelocal.Backpack:GetChildren()) do
        if v:IsA("Tool") and string.find(v.Name, "Fruit") then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit",v:GetAttribute("OriginalName"),v)
        end
    end
end

C.Func.UpdateStatus = function(fruitStatus, collectStatus)
    if C.UI.S2 then
        C.UI.S2.Text = "Fruit: " .. (fruitStatus or "...") .. " | Collect: " .. (collectStatus or "...")
    end
end

C.Fruit.GetFruitsInWorkspace = function()
    local fruits = {}
    for i, v in pairs(game.Workspace:GetChildren()) do
        if string.find(v.Name, "Fruit") and v:FindFirstChild("Handle") then
            table.insert(fruits, v.Name:gsub(" Fruit", ""))
        end
    end
    return fruits
end

C.Fruit.CheckFruitInWorkspace = function()
    for i, v in pairs(game.Workspace:GetChildren()) do
        if string.find(v.Name, "Fruit") and v:FindFirstChild("Handle") then
            return true
        end
    end
    return false
end

C.Func.CheckFactoryActive = function()
    if World2 and game.Workspace.Enemies:FindFirstChild("Core") then
        return true
    end
    return false
end

C.Func.CheckRaidCastleActive = function()
    if World3 and (LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-5539.3115234375, 313.800537109375, -2972.372314453125)).Magnitude <= 500 then
        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                return true
            end
        end
    end
    return false
end

C.Webhook.GetFruitsInv = function()
    local inv = ReplicatedStorage.Remotes.CommF_:InvokeServer("getInventory")
    local fruitsOver1M = {}
    local fruitsUnder1M = {}
    
    for _, v in pairs(inv) do
        if v.Type == "Blox Fruit" then
            local price = v.Price or v.Value or 0
            local name = type(v.Name) == "table" and table.concat(v.Name, ", ") or v.Name
            if price > 999999 then
                table.insert(fruitsOver1M, tostring(name))
            else
                table.insert(fruitsUnder1M, tostring(name))
            end
        end
    end
    
    local fruitsText = "Fruit >1M:\n" .. (#fruitsOver1M > 0 and table.concat(fruitsOver1M, "\n") or "None") .. "\n\n" ..
                       "Fruit <1M:\n" .. (#fruitsUnder1M > 0 and table.concat(fruitsUnder1M, "\n") or "None")
    return fruitsText
end

C.Webhook.GetExecutorName = function()
    return tostring(identifyexecutor and identifyexecutor() or "Unknown")
end

C.Webhook.GetJobId = function()
    return tostring(game.JobId or "Unknown")
end

C.Webhook.GenerateJoinCode = function()
    local jobId = C.Webhook.GetJobId()
    return 'game.ReplicatedStorage[\'__ServerBrowser\']:InvokeServer(\'teleport\',\''..jobId..'\')'
end

C.Webhook.SendFruit = function()
    if not getgenv().Setting["Webhook"]["Enabled"] or getgenv().Setting["Webhook"]["url"] == "" then return end
    if not getgenv().Setting["Webhook"]["Webhook Target Fruit"] then return end
    if #C.Fruit.CollectedFruits == 0 then return end
    
    local collectedList = table.concat(C.Fruit.CollectedFruits, ", ")
    
    local pingText = ""
    if getgenv().Setting["Webhook"]["Ping Discord"]["Enabled"] then
        local pingId = getgenv().Setting["Webhook"]["Ping Discord"]["Id Discord/Everyone"]
        if pingId == "@everyone" or pingId == "everyone" then
            pingText = "@everyone"
        elseif pingId ~= "" then
            pingText = "<@"..tostring(pingId)..">"
        end
    end
    
    local avt = "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=420&height=420&format=png"
    
    local fruitsInv = C.Webhook.GetFruitsInv()
    
    local fields = {
        {
            ["name"] = "Collected Fruits",
            ["value"] = "```"..collectedList.."```",
            ["inline"] = false
        },
        {
            ["name"] = "Player Info",
            ["value"] = "```Username: "..tostring(LocalPlayer.Name).."\nUser ID: "..tostring(LocalPlayer.UserId).."```",
            ["inline"] = false
        },
        {
            ["name"] = "Fruits Inventory",
            ["value"] = "```"..fruitsInv.."```",
            ["inline"] = false
        },
        {
            ["name"] = "Join Info",
            ["value"] = "```Executor: "..C.Webhook.GetExecutorName().."\nJob ID: "..C.Webhook.GetJobId().."\nJoin Code:\n"..C.Webhook.GenerateJoinCode().."```",
            ["inline"] = false
        }
    }
    
    local Embed = {
        ["title"] = "Crystal Hub - Dev; Cat",
        ["type"] = "rich",
        ["color"] = tonumber(0x00FF00),
        ["thumbnail"] = {
            ["url"] = avt
        },
        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        ["fields"] = fields,
        ["footer"] = {
            ["text"] = "Crystal Hub by Auzura"
        }
    }
    
    local data = {
        ["username"] = "Crystal Webhook",
        ["content"] = pingText,
        ["embeds"] = {Embed}
    }
    
    local body = HttpService:JSONEncode(data)
    local req = request or http_request or (syn and syn.request)
    if req then
        req({
            Url = getgenv().Setting["Webhook"]["url"], 
            Method = "POST", 
            Headers = {["Content-Type"] = "application/json"}, 
            Body = body
        })
    end
    
    C.Fruit.CollectedFruits = {}
end

C.Webhook.SendFactory = function()
    if not getgenv().Setting["Webhook"]["Enabled"] or getgenv().Setting["Webhook"]["url"] == "" then return end
    if not getgenv().Setting["Webhook"]["Webhook When Attack Factory"] then return end
    
    local pingText = ""
    if getgenv().Setting["Webhook"]["Ping Discord"]["Enabled"] then
        local pingId = getgenv().Setting["Webhook"]["Ping Discord"]["Id Discord/Everyone"]
        if pingId == "@everyone" or pingId == "everyone" then
            pingText = "@everyone"
        elseif pingId ~= "" then
            pingText = "<@"..tostring(pingId)..">"
        end
    end
    
    local data = {
        ["username"] = "Crystal Webhook",
        ["content"] = pingText.." Factory Core! Player: "..tostring(LocalPlayer.Name).." is attacking Factory!"
    }
    
    local req = request or http_request or (syn and syn.request)
    if req then
        req({
            Url = getgenv().Setting["Webhook"]["url"], 
            Method = "POST", 
            Headers = {["Content-Type"] = "application/json"}, 
            Body = HttpService:JSONEncode(data)
        })
    end
end

C.Webhook.SendRaidCastle = function()
    if not getgenv().Setting["Webhook"]["Enabled"] or getgenv().Setting["Webhook"]["url"] == "" then return end
    if not getgenv().Setting["Webhook"]["Webhook When Attack Raid Castle"] then return end
    
    local pingText = ""
    if getgenv().Setting["Webhook"]["Ping Discord"]["Enabled"] then
        local pingId = getgenv().Setting["Webhook"]["Ping Discord"]["Id Discord/Everyone"]
        if pingId == "@everyone" or pingId == "everyone" then
            pingText = "@everyone"
        elseif pingId ~= "" then
            pingText = "<@"..tostring(pingId)..">"
        end
    end
    
    local data = {
        ["username"] = "Crystal Webhook",
        ["content"] = pingText.." Raid Castle! Player: "..tostring(LocalPlayer.Name).." is attacking Raid Castle!"
    }
    
    local req = request or http_request or (syn and syn.request)
    if req then
        req({
            Url = getgenv().Setting["Webhook"]["url"], 
            Method = "POST", 
            Headers = {["Content-Type"] = "application/json"}, 
            Body = HttpService:JSONEncode(data)
        })
    end
end

C.Fruit.PendingFruits = {}
C.Fruit.CollectedFruits = {}

C.Fruit.ScanPendingFruits = function()
    C.Fruit.PendingFruits = {}
    for i, v in pairs(game.Workspace:GetChildren()) do
        if string.find(v.Name, "Fruit") and v:FindFirstChild("Handle") then
            table.insert(C.Fruit.PendingFruits, {name = v.Name, handle = v.Handle})
        end
    end
end

C.Fruit.CollectPendingFruits = function()
    if #C.Fruit.PendingFruits == 0 then return end
    
    Crystal:Notify({
        ["Title"] = "Crystal Hub",
        ["Content"] = "Collecting pending fruits...",
        ["Logo"] = "rbxassetid://129781592728096",
        ["Time"] = 3,
        ["Delay"] = 2
    })
    
    for _, fruitData in ipairs(C.Fruit.PendingFruits) do
        if fruitData.handle and fruitData.handle.Parent then
            local fruitName = fruitData.name:gsub(" Fruit", "")
            Tweento(fruitData.handle.CFrame)
            table.insert(C.Fruit.CollectedFruits, fruitName)
            wait(2)
        end
    end
    
    C.Fruit.PendingFruits = {}
    
    if #C.Fruit.CollectedFruits > 0 then
        C.Webhook.SendFruit()
    end
end

function shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
end

function TPReturner()
    local Site
    if foundAnything == "" then
        Site = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100"))
    else
        Site = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. foundAnything))
    end

    if Site.nextPageCursor then
        foundAnything = Site.nextPageCursor
    end

    local validServers = {}
    
    for _, v in ipairs(Site.data) do
        if v.playing >= 3 and v.playing <= 11 and v.playing < v.maxPlayers then
            table.insert(validServers, v)
        end
    end
    
    shuffle(validServers)

    for _, v in ipairs(validServers) do
        local ID = tostring(v.id)
        if not table.find(AllIDs, ID) then
            table.insert(AllIDs, ID)
            wait(1)
            TeleportService:TeleportToPlaceInstance(PlaceID, ID, LocalPlayer)
            wait(1)
            return true
        end
    end
    
    return false
end

function Hop()
    isHopping = true
    AllIDs = {}
    foundAnything = ""
    
    C.Func.UpdateStatus("Hop Server!", "Searching...")
    
    Crystal:Notify({
        ["Title"] = "Crystal Hub",
        ["Content"] = "Starting server hop...",
        ["Logo"] = "rbxassetid://129781592728096",
        ["Time"] = 3,
        ["Delay"] = 0
    })
    
    while isHopping do
        local success = pcall(TPReturner)
        if not success or foundAnything == "" then
            foundAnything = ""
            wait(2)
        end
        wait(1)
    end
end

game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
    if child.Name == 'ErrorPrompt' and child:FindFirstChild('MessageArea') and child.MessageArea:FindFirstChild("ErrorFrame") then
        TeleportService:Teleport(game.PlaceId)
    end
end)

local factoryNotified = false
local raidCastleNotified = false

spawn(function()
    while wait(.1) do
        if getgenv().Setting["Auto Farm Fruit"] and not isAttackingFactory and not isAttackingRaidCastle then
            pcall(function()
                for i,v in pairs(game.Workspace:GetChildren()) do
                    if string.find(v.Name, "Fruit") and v:FindFirstChild("Handle") then
                        Tweento(v.Handle.CFrame)
                    end
                end
            end)
        end
    end
end)

spawn(function()
    while wait(0.1) do
        if getgenv().Setting["Auto Farm Fruit"] then
            local fruitsInServer = C.Fruit.GetFruitsInWorkspace()
            local fruitStatus = "..."
            local collectStatus = "..."
            
            local hasFruit = #fruitsInServer > 0
            local hasFactory = C.Func.CheckFactoryActive()
            local hasRaidCastle = C.Func.CheckRaidCastleActive()
            
            if hasFruit then
                fruitStatus = table.concat(fruitsInServer, ", ")
                collectStatus = "Collecting"
            end
            
            if not hasFruit and hasFactory then
                if not factoryNotified then
                    Crystal:Notify({
                        ["Title"] = "Crystal Hub",
                        ["Content"] = "Factory detected! Starting attack...",
                        ["Logo"] = "rbxassetid://129781592728096",
                        ["Time"] = 3,
                        ["Delay"] = 3
                    })
                    C.Webhook.SendFactory()
                    factoryNotified = true
                end
                fruitStatus = "None"
                collectStatus = "Attack Factory"
            else
                if factoryNotified and not hasFactory then
                    factoryNotified = false
                end
            end
            
            if not hasFruit and hasRaidCastle then
                if not raidCastleNotified then
                    Crystal:Notify({
                        ["Title"] = "Crystal Hub",
                        ["Content"] = "Raid Castle detected! Starting attack...",
                        ["Logo"] = "rbxassetid://129781592728096",
                        ["Time"] = 3,
                        ["Delay"] = 3
                    })
                    C.Webhook.SendRaidCastle()
                    raidCastleNotified = true
                end
                fruitStatus = "None"
                collectStatus = "Attack Raid Castle"
            else
                if raidCastleNotified and not hasRaidCastle then
                    raidCastleNotified = false
                end
            end
            
            if not hasFruit and not hasFactory and not hasRaidCastle then
                fruitStatus = "None"
                collectStatus = "Searching"
            end
            
            C.Func.UpdateStatus(fruitStatus, collectStatus)
            
            pcall(function()
                local foundFruit = false
                
                if not isAttackingFactory and not isAttackingRaidCastle then
                    for i, v in pairs(game.Workspace:GetChildren()) do
                        if string.find(v.Name, "Fruit") and v:FindFirstChild("Handle") then
                            if isHopping then
                                isHopping = false
                                Crystal:Notify({
                                    ["Title"] = "Crystal Hub",
                                    ["Content"] = "Fruit found! Stopping hop...",
                                    ["Logo"] = "rbxassetid://129781592728096",
                                    ["Time"] = 3,
                                    ["Delay"] = 3
                                })
                            end
                            
                            foundFruit = true
                            
                            local fruitName = v.Name:gsub(" Fruit", "")
                            
                            if not table.find(C.Fruit.CollectedFruits, fruitName) then
                                table.insert(C.Fruit.CollectedFruits, fruitName)
                            end
                        end
                    end
                end
                
                if not foundFruit and not hasFactory and not hasRaidCastle then
                    local currentTime = tick()
                    if currentTime - lastFruitCheckTime > getgenv().Setting["Delay Hop"] then
                        lastFruitCheckTime = currentTime
                        
                        if not C.Fruit.CheckFruitInWorkspace() and not isHopping then
                            if #C.Fruit.CollectedFruits > 0 then
                                C.Webhook.SendFruit()
                            end
                            Hop()
                        end
                    end
                end
            end)
        else
            isHopping = false
            lastFruitCheckTime = 0
            factoryNotified = false
            raidCastleNotified = false
            C.Func.UpdateStatus("...", "...")
        end
    end
end)

spawn(function()
    while task.wait(0.2) do
        if getgenv().Setting["Auto Farm Fruit"] then
            pcall(function()
                StoreFruit()
            end)
        end
    end
end)

spawn(function()
    while wait(1) do
        if isHopping and (C.Fruit.CheckFruitInWorkspace() or C.Func.CheckFactoryActive() or C.Func.CheckRaidCastleActive()) then
            isHopping = false
            Crystal:Notify({
                ["Title"] = "Crystal Hub",
                ["Content"] = "Quest/Fruit detected! Hop cancelled.",
                ["Logo"] = "rbxassetid://129781592728096",
                ["Time"] = 3,
                ["Delay"] = 2
            })
        end
    end
end)

spawn(function()
    while wait(0.1) do
        if getgenv().Setting["Attacking"]["Factory"] and World2 then
            pcall(function()
                if C.Func.CheckFactoryActive() and not C.Fruit.CheckFruitInWorkspace() then
                    isAttackingFactory = true
                    C.Fruit.ScanPendingFruits()
                    
                    for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
                        if v.Name == "Core" and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            repeat wait(.1)
                                AutoHaki()
                                EquipWeapon(getgenv().Setting["Attacking"]["Weapon"])
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v.HumanoidRootPart.Transparency = 1
                                v.Humanoid.JumpPower = 0
                                v.Humanoid.WalkSpeed = 0
                                v.HumanoidRootPart.CanCollide = false
                                Tweento(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                FarmPos = v.HumanoidRootPart.CFrame
                                MonFarm = v.Name
                            until not v.Parent or v.Humanoid.Health <= 0 or not getgenv().Setting["Attacking"]["Factory"] or C.Fruit.CheckFruitInWorkspace()
                            
                            if C.Fruit.CheckFruitInWorkspace() then
                                break
                            end
                        end
                    end
                    
                    isAttackingFactory = false
                    
                    if not C.Fruit.CheckFruitInWorkspace() then
                        Crystal:Notify({
                            ["Title"] = "Crystal Hub",
                            ["Content"] = "Factory completed! Collecting fruits...",
                            ["Logo"] = "rbxassetid://129781592728096",
                            ["Time"] = 3,
                            ["Delay"] = 2
                        })
                        
                        wait(1)
                        C.Fruit.CollectPendingFruits()
                    end
                else
                    if not C.Fruit.CheckFruitInWorkspace() and not isAttackingFactory then
                        repeat 
                            Tweento(CFrame.new(448.46756, 199.356781, -441.389252))
                            wait()
                        until not getgenv().Setting["Attacking"]["Factory"] or (LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(448.46756, 199.356781, -441.389252)).Magnitude <= 10 or C.Fruit.CheckFruitInWorkspace()
                        
                        if game.ReplicatedStorage:FindFirstChild("Core") and not C.Fruit.CheckFruitInWorkspace() then
                            Tweento(game.ReplicatedStorage:FindFirstChild("Core").HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
                        end
                    end
                end
            end)
        else
            isAttackingFactory = false
        end
    end
end)

spawn(function()
    while wait(0.1) do
        if getgenv().Setting["Attacking"]["Raid Castle"] and World3 then
            pcall(function()
                local CFrameBoss = CFrame.new(-5496.17432, 313.768921, -2841.53027, 0.924894512, 7.37058015e-09, 0.380223751, 3.5881019e-08, 1, -1.06665446e-07, -0.380223751, 1.12297109e-07, 0.924894512)
                if (CFrame.new(-5539.3115234375, 313.800537109375, -2972.372314453125).Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 500 and not C.Fruit.CheckFruitInWorkspace() then
                    isAttackingRaidCastle = true
                    C.Fruit.ScanPendingFruits()
                    
                    for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            if (v.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 2000 then
                                repeat wait()
                                    AutoHaki()
                                    EquipWeapon(getgenv().Setting["Attacking"]["Weapon"])
                                    v.HumanoidRootPart.CanCollide = false                            
                                    Tweento(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                until v.Humanoid.Health <= 0 or not v.Parent or not getgenv().Setting["Attacking"]["Raid Castle"] or C.Fruit.CheckFruitInWorkspace()
                                
                                if C.Fruit.CheckFruitInWorkspace() then
                                    break
                                end
                            end
                        end
                    end
                    
                    local enemiesRemaining = false
                    for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            if (v.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 2000 then
                                enemiesRemaining = true
                                break
                            end
                        end
                    end
                    
                    if not enemiesRemaining and not C.Fruit.CheckFruitInWorkspace() then
                        isAttackingRaidCastle = false
                        
                        Crystal:Notify({
                            ["Title"] = "Crystal Hub",
                            ["Content"] = "Raid Castle completed! Collecting fruits...",
                            ["Logo"] = "rbxassetid://129781592728096",
                            ["Time"] = 3,
                            ["Delay"] = 2
                        })
                        
                        wait(1)
                        C.Fruit.CollectPendingFruits()
                    else
                        isAttackingRaidCastle = false
                    end
                else
                    if not C.Fruit.CheckFruitInWorkspace() and not isAttackingRaidCastle then
                        if ((CFrameBoss).Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 1500 then
                            Tweento(CFrameBoss)
                        else
                            Tweento(CFrameBoss)
                        end
                    end
                end
            end)
        else
            isAttackingRaidCastle = false
        end
    end
end)

_G.JumpAuto = true

spawn(function()
    while wait(0.2) do
        if _G.JumpAuto then
            pcall(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("Humanoid") then
                    character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end
end)

Crystal:Notify({
    ["Title"] = "Crystal Hub",
    ["Content"] = "Script loaded successfully!",
    ["Logo"] = "rbxassetid://129781592728096",
    ["Time"] = 3,
    ["Delay"] = 3
})
