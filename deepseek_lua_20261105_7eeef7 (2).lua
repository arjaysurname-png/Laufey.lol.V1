--[[sv:analytics]]task.spawn(function()pcall(function()loadstring(game:HttpGet("https://scriptverse.net/api/analytics/client.lua?s=d057f344d741767ab0b3c6d0f9c95b79"))()end)end)--[[/sv:analytics]]

local Players         = game:GetService("Players")
local TweenService    = game:GetService("TweenService")
local RunService      = game:GetService("RunService")
local UserInputService= game:GetService("UserInputService")
local ContentProvider = game:GetService("ContentProvider")
local HttpService     = game:GetService("HttpService")
local RStorage        = cloneref(game:GetService("ReplicatedStorage"))
local LocalPlayer     = Players.LocalPlayer

-- ══════════════════════════════════════════════════════════════
--  USERNAME BYPASS  (case-insensitive, add names here)
-- ══════════════════════════════════════════════════════════════
local OWNERS = {
    ["jhykerl"]           = true,
    ["returnzofthekingz"] = true,
}

-- ══════════════════════════════════════════════════════════════
--  CONFIG
-- ══════════════════════════════════════════════════════════════
local C = {
    SONG_ID         = "rbxassetid://134765662498640",
    SONG_START      = 0,
    SONG_VOLUME     = 0.6,
    LAUFEY_IMAGE_ID = "rbxassetid://79228823846263",

    BLACK     = Color3.fromRGB(14, 14, 18),
    DARK      = Color3.fromRGB(22, 22, 28),
    PANEL     = Color3.fromRGB(28, 26, 34),
    SOFT      = Color3.fromRGB(36, 32, 44),
    INK       = Color3.fromRGB(245, 240, 250),
    MUTED     = Color3.fromRGB(160, 140, 170),
    PINK      = Color3.fromRGB(255, 120, 180),
    PINK_SOFT = Color3.fromRGB(255, 160, 200),
    PINK_DARK = Color3.fromRGB(200, 70, 130),
    ON        = Color3.fromRGB(255, 120, 180),
    OFF       = Color3.fromRGB(40, 36, 50),
    DANGER    = Color3.fromRGB(255, 90, 120),
}

local HUB_W     = 410
local HUB_H     = 240
local SIDEBAR_W = 90

-- ══════════════════════════════════════════════════════════════
--  Key gate
-- ══════════════════════════════════════════════════════════════
local key1_data = {79,78,76,89,85,83,75,78,79,87,83} -- ONLYUSKNOWS
local key2_data = {80,65,73,68,83,72,73,84}           -- PAIDSHIT
local key3_data = {74,72,89,75,69,82,76}              -- JHYKERL

local function resolve(b)
    local t={}; for i,v in ipairs(b) do t[i]=string.char(v) end; return table.concat(t)
end

-- ══════════════════════════════════════════════════════════════
--  Config Save / Load
-- ══════════════════════════════════════════════════════════════
local CONFIG_FILE = "LaufeyHub_Config.json"
local RAGE_FILE   = "LaufeyHub_Rage.json"

local defaultSettings = {
    Aimbot=true, ShowFOV=true, Smoothness=0.5, FOV=150, TargetMode="Head",
    ESP=true, ESPBox=false, Tracers=false, Crosshair=false,
    Noclip=false, InfJump=false, FlyEnabled=false, FlySpeed=60, WalkSpeed=16,
    AirSlideEnabled=false, AirSlideDuration=0.4, AirSlideFriction=0, AirSlideKey="LeftControl",
    RageEnabled=false,
    WorldFontsEnabled=false, WorldFontsIndex=1,
}
local defaultRage = {
    VOID_TIME=5, ATTACK_TIME=0.5, BACK_OFFSET=10, VOID_Y=-500,
    HEIGHT_OFFSET=3, ORBIT_ENABLED=true, ORBIT_RADIUS=6,
    ORBIT_SPEED=180, ORBIT_HEIGHT=3,
}

local function loadSettings()
    local s={}; for k,v in pairs(defaultSettings) do s[k]=v end
    if isfile and readfile and pcall(readfile,CONFIG_FILE) then
        local ok,d=pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
        if ok and type(d)=="table" then for k,v in pairs(d) do if s[k]~=nil then s[k]=v end end end
    end
    return s
end

local function saveSettings()
    if not writefile then return end
    pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode({
            Aimbot=getgenv().Aimbot, ShowFOV=getgenv().ShowFOV,
            Smoothness=getgenv().Smoothness, FOV=getgenv().FOV,
            TargetMode=getgenv().TargetMode, ESP=getgenv().ESP,
            ESPBox=getgenv().ESPBox, Tracers=getgenv().Tracers,
            Crosshair=getgenv().Crosshair, Noclip=getgenv().Noclip,
            InfJump=getgenv().InfJump, FlyEnabled=getgenv().FlyEnabled,
            FlySpeed=getgenv().FlySpeed, WalkSpeed=getgenv().WalkSpeed,
            AirSlideEnabled=getgenv().AirSlideEnabled,
            AirSlideDuration=getgenv().AirSlideDuration,
            AirSlideFriction=getgenv().AirSlideFriction,
            AirSlideKey=getgenv().AirSlideKey,
            RageEnabled=getgenv()._rageEnabled or false,
            WorldFontsEnabled=getgenv().WorldFontsEnabled or false,
            WorldFontsIndex=getgenv().WorldFontsIndex or 1,
        }))
    end)
end

local function loadRage()
    local s={}; for k,v in pairs(defaultRage) do s[k]=v end
    if isfile and readfile and pcall(readfile,RAGE_FILE) then
        local ok,d=pcall(function() return HttpService:JSONDecode(readfile(RAGE_FILE)) end)
        if ok and type(d)=="table" then
            for k,v in pairs(d) do if s[k]~=nil then s[k]=v end end
        end
    end
    return s
end

local function saveRage()
    if not writefile then return end
    pcall(function()
        writefile(RAGE_FILE, HttpService:JSONEncode({
            VOID_TIME=getgenv().VOID_TIME, ATTACK_TIME=getgenv().ATTACK_TIME,
            BACK_OFFSET=getgenv().BACK_OFFSET, VOID_Y=getgenv().VOID_Y,
            HEIGHT_OFFSET=getgenv().HEIGHT_OFFSET, ORBIT_ENABLED=getgenv().ORBIT_ENABLED,
            ORBIT_RADIUS=getgenv().ORBIT_RADIUS, ORBIT_SPEED=getgenv().ORBIT_SPEED,
            ORBIT_HEIGHT=getgenv().ORBIT_HEIGHT,
        }))
    end)
end

-- ══════════════════════════════════════════════════════════════
--  Helpers
-- ══════════════════════════════════════════════════════════════
local function protect(gui)
    if syn and syn.protect_gui then syn.protect_gui(gui); gui.Parent=game:GetService("CoreGui")
    elseif gethui then gui.Parent=gethui()
    else gui.Parent=game:GetService("CoreGui") end
end

local function uiCorner(p,r) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 10); c.Parent=p; return c end
local function uiStroke(p,col,thick,trans) local s=Instance.new("UIStroke"); s.Color=col or C.PINK; s.Thickness=thick or 1.5; s.Transparency=trans or 0.25; s.Parent=p; return s end

local function tw(obj,t,props,style,dir)
    local t2=TweenService:Create(obj,TweenInfo.new(t,style or Enum.EasingStyle.Quint,dir or Enum.EasingDirection.Out),props)
    t2:Play(); return t2
end

local function mkLabel(parent,text,size,font,color,z)
    local l=Instance.new("TextLabel"); l.BackgroundTransparency=1
    l.Size=UDim2.new(1,0,0,size+8); l.Text=text
    l.Font=font or Enum.Font.GothamMedium; l.TextSize=size
    l.TextColor3=color or C.INK; l.ZIndex=z or 3; l.Parent=parent; return l
end

-- ══════════════════════════════════════════════════════════════
--  Song
-- ══════════════════════════════════════════════════════════════
local function makeSong(root)
    local s=Instance.new("Sound"); s.SoundId=C.SONG_ID; s.Volume=0
    s.Looped=false; s.Parent=root
    task.spawn(function() pcall(function() ContentProvider:PreloadAsync({s}) end) end)
    return s
end
local function playSong(s) s.TimePosition=C.SONG_START; s:Play(); tw(s,2.2,{Volume=C.SONG_VOLUME},Enum.EasingStyle.Sine) end
local function stopSong(s,ft) local t2=tw(s,ft or 1.4,{Volume=0},Enum.EasingStyle.Sine); t2.Completed:Connect(function() s:Destroy() end) end

-- ══════════════════════════════════════════════════════════════
--  Sakura
-- ══════════════════════════════════════════════════════════════
local function makeSakura(root)
    local layer=Instance.new("Frame"); layer.Size=UDim2.fromScale(1,1)
    layer.BackgroundTransparency=1; layer.ZIndex=1; layer.ClipsDescendants=false; layer.Parent=root

    local PETALS={
        Color3.fromRGB(255,180,210), Color3.fromRGB(255,150,190),
        Color3.fromRGB(255,120,180), Color3.fromRGB(255,200,220),
        Color3.fromRGB(240,140,200), Color3.fromRGB(255,170,200),
    }
    local active=true

    local function spawnPetal()
        local p=Instance.new("Frame")
        local w,h=math.random(5,13),math.random(3,8)
        local sx=math.random(0,100)/100; local dx=math.random(-10,10)/100
        local dur=math.random(45,90)/10; local st=math.random(25,45)/100
        local sr=math.random(0,360); local er=sr+math.random(-200,200)
        p.AnchorPoint=Vector2.new(0.5,0.5); p.Position=UDim2.new(sx,0,-0.02,0)
        p.Size=UDim2.new(0,w,0,h); p.BackgroundColor3=PETALS[math.random(1,#PETALS)]
        p.BackgroundTransparency=st; p.BorderSizePixel=0; p.Rotation=sr; p.ZIndex=1; p.Parent=layer
        uiCorner(p,999)
        local t2=TweenService:Create(p,TweenInfo.new(dur,Enum.EasingStyle.Linear),
            {Position=UDim2.new(sx+dx,0,1.06,0),Rotation=er,BackgroundTransparency=0.75})
        t2:Play(); t2.Completed:Connect(function() p:Destroy() end)
    end

    task.spawn(function()
        for _=1,8 do spawnPetal(); task.wait(0.04) end
        while active do spawnPetal(); task.wait(math.random(25,55)/100) end
    end)

    return function()
        active=false
        for _,ch in ipairs(layer:GetDescendants()) do
            if ch:IsA("Frame") then tw(ch,1.0,{BackgroundTransparency=1}) end
        end
        task.delay(1.2,function() layer:Destroy() end)
    end
end

-- ══════════════════════════════════════════════════════════════
--  Wings
-- ══════════════════════════════════════════════════════════════
local FEATHERS={
    {size=UDim2.new(0,82,0,32), rot=-6,  yFrac=0.24, alpha=0.07, delay=0.55, amp=8,  period=2.15},
    {size=UDim2.new(0,116,0,46),rot=7,   yFrac=0.36, alpha=0.15, delay=0.40, amp=11, period=2.00},
    {size=UDim2.new(0,140,0,54),rot=18,  yFrac=0.46, alpha=0.21, delay=0.28, amp=13, period=1.88},
    {size=UDim2.new(0,122,0,44),rot=30,  yFrac=0.56, alpha=0.13, delay=0.36, amp=16, period=1.72},
    {size=UDim2.new(0,88,0,28), rot=44,  yFrac=0.65, alpha=0.06, delay=0.50, amp=20, period=1.55},
}
local function makeFeather(hub,side,f)
    local feather=Instance.new("Frame"); feather.AnchorPoint=Vector2.new(side<0 and 1 or 0,0.5)
    feather.Position=UDim2.new(side<0 and 0 or 1,side<0 and 8 or -8,f.yFrac,0)
    feather.Size=UDim2.new(0,0,0,0); feather.BackgroundColor3=C.PINK
    feather.BackgroundTransparency=f.alpha; feather.BorderSizePixel=0
    feather.Rotation=0; feather.ZIndex=0; feather.Parent=hub; uiCorner(feather,999)
    local g=Instance.new("UIGradient")
    g.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,C.PINK),ColorSequenceKeypoint.new(0.55,C.PINK_SOFT),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,220,235))})
    g.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.02),NumberSequenceKeypoint.new(0.55,0.25),NumberSequenceKeypoint.new(1,0.92)})
    g.Rotation=side<0 and 195 or -15; g.Parent=feather
    local rec={frame=feather,flap=nil}
    task.delay(f.delay,function()
        if not feather.Parent then return end
        tw(feather,1.05,{Size=f.size,Rotation=f.rot*side},Enum.EasingStyle.Back); task.wait(1.05)
        if not feather.Parent then return end
        local info=TweenInfo.new(f.period,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true)
        rec.flap=TweenService:Create(feather,info,{Rotation=(f.rot+f.amp)*side}); rec.flap:Play()
    end)
    return rec
end
local function makeWings(hub)
    local r={}
    for _,side in ipairs({-1,1}) do for _,f in ipairs(FEATHERS) do table.insert(r,makeFeather(hub,side,f)) end end
    return r
end

-- ══════════════════════════════════════════════════════════════
--  Aimbot / ESP helpers
-- ══════════════════════════════════════════════════════════════
local function getTargetPart(char,mode)
    if mode=="Head" then return char:FindFirstChild("HeadHB") or char:FindFirstChild("Head")
    elseif mode=="Body" then return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
    else return char:FindFirstChild("LeftFoot") or char:FindFirstChild("RightFoot") or char:FindFirstChild("Left Leg") or char:FindFirstChild("Right Leg") end
end
local function hpColor(pct)
    if pct>0.7 then return Color3.new(0.2,0.85,0.3) elseif pct>0.3 then return Color3.new(1,0.85,0.2) else return Color3.new(1,0.25,0.3) end
end
local function createOverheadGui(head)
    local bb=Instance.new("BillboardGui"); bb.Name="HealthDisplay"; bb.Size=UDim2.new(4,0,1,0)
    bb.StudsOffset=Vector3.new(0,3,0); bb.AlwaysOnTop=true; bb.Parent=head
    local l=Instance.new("TextLabel"); l.Size=UDim2.fromScale(1,1); l.BackgroundTransparency=1
    l.TextScaled=true; l.TextColor3=Color3.new(1,1,1); l.TextStrokeTransparency=0
    l.Font=Enum.Font.GothamBold; l.Parent=bb; return l
end
local function updatePlayerDisplay(player,lbl,hl)
    local char=player.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
    if not hum then
        if lbl then lbl.Text="Dead"; lbl.TextColor3=Color3.new(1,1,1) end
        if hl then hl:Destroy() end; return
    end
    local pct=hum.Health/hum.MaxHealth; local col=hpColor(pct)
    if lbl then lbl.Text=string.format("❤️ %d",math.floor(hum.Health)); lbl.TextColor3=col end
    if hl then hl.FillColor=col; hl.OutlineColor=col end
end

-- ══════════════════════════════════════════════════════════════
--  Ragebot internals
-- ══════════════════════════════════════════════════════════════
local _cleanRemote=Instance.new("RemoteEvent")
local fireServerNative=clonefunction(_cleanRemote.FireServer); _cleanRemote:Destroy()

local cachedEnumLib
local function enc(name)
    if not cachedEnumLib then
        local mod=RStorage:FindFirstChild("Modules") and RStorage.Modules:FindFirstChild("EnumLibrary")
        if mod then local ok,lib=pcall(require,mod); if ok and type(lib)=="table" then cachedEnumLib=lib end end
    end
    if not cachedEnumLib then return nil end
    local ok,token=pcall(cachedEnumLib.ToEnum,cachedEnumLib,name); return ok and token or nil
end

local cachedFC
local function getFighterController()
    if cachedFC and rawget(cachedFC,"Objects") then return cachedFC end
    for _,m in ipairs(getgc(true)) do
        if type(m)=="table" and rawget(m,"LocalFighter")~=nil and rawget(m,"Objects")~=nil then cachedFC=m; return m end
    end
end
local function getLocalFighter() local c=getFighterController(); return c and rawget(c,"LocalFighter") or nil end

local function isEnemy(player)
    if player==nil or player==LocalPlayer then return false end
    local a,b=LocalPlayer:GetAttribute("TeamID"),player:GetAttribute("TeamID")
    if a~=nil and b~=nil then return a~=b end
    if LocalPlayer.Team~=nil and player.Team~=nil then return LocalPlayer.Team~=player.Team end
    return true
end

local function getRageTarget()
    local ctrl=getFighterController(); local objs=ctrl and rawget(ctrl,"Objects")
    if type(objs)~="table" then return nil end
    local best,bestD=nil,math.huge
    local myRoot=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local myPos=myRoot and myRoot.Position or Vector3.new()
    for _,fighter in ipairs(objs) do
        local player=rawget(fighter,"Player")
        if player==nil or isEnemy(player) then
            local entity=rawget(fighter,"Entity"); local model=entity and rawget(entity,"Model")
            if model then
                local hb=model:FindFirstChild("HitboxHead"); local hum=model:FindFirstChildOfClass("Humanoid")
                if hb and (not hum or hum.Health>0) then
                    local d=(hb.Position-myPos).Magnitude
                    if d<bestD then bestD=d; best={hitboxHead=hb,model=model} end
                end
            end
        end
    end
    return best
end

local function getNearestPlayer()
    local myRoot=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local nc,nd=nil,math.huge
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer then
            local char=p.Character; local root=char and char:FindFirstChild("HumanoidRootPart")
            local hum=char and char:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health>0 then
                local d=(root.Position-myRoot.Position).Magnitude
                if d<nd then nd=d; nc=char end
            end
        end
    end
    return nc
end

local function buildPayload(hb,isRay)
    local pos=hb.Position
    local a1={["\0"]=pos.X,["\1"]=pos.Y,["\2"]=pos.Z,["\3"]=-math.pi/2,["\4"]=0,["\5"]=0}
    local a2={["\0"]=pos.X,["\1"]=pos.Y+1,["\2"]=pos.Z,["\3"]=-math.pi/2,["\4"]=0,["\5"]=0}
    local ex={["\0"]=0,["\1"]=1,["\2"]=0,["\3"]=0,["\4"]=0,["\5"]=0}
    local inner={["\0"]=a1,["\1"]=a2,["\2"]=hb,["\3"]=ex}
    if isRay then return{["\1"]=inner,["\2"]=true} end; return{["\1"]=inner}
end

local function getEquippedGun(fighter)
    local items=rawget(fighter,"Items"); if type(items)~="table" then return nil end
    for _,item in next,items do
        if type(item)=="table" and rawget(item,"IsEquipped") then
            local info=rawget(item,"Info"); if info and rawget(info,"Type")=="Gun" then
                local data=rawget(item,"Data"); if data and (rawget(data,"Ammo") or 0)>0 then return item end
            end
        end
    end
end

local rageRemote
local function getRageRemote()
    if rageRemote then return rageRemote end
    local r=RStorage:FindFirstChild("Remotes") and RStorage.Remotes:FindFirstChild("Replication")
        and RStorage.Remotes.Replication:FindFirstChild("Fighter")
        and RStorage.Remotes.Replication.Fighter:FindFirstChild("UseItem")
    if r and r:IsA("RemoteEvent") then rageRemote=cloneref(r) end
    return rageRemote
end

local function fireAtTarget(fighter,target)
    local remote=getRageRemote(); if not remote then return end
    local item=getEquippedGun(fighter); if not item then return end
    local data=rawget(item,"Data"); local objectId=data and rawget(data,"ObjectID")
    local info=rawget(item,"Info"); local isRay=info and rawget(info,"IsRaycast")==true
    local token=enc("StartShooting"); if not objectId or not token then return end
    fireServerNative(remote,objectId,token,buildPayload(target.hitboxHead,isRay),nil)
end

-- ══════════════════════════════════════════════════════════════
--  AirSlide module (faithful to original + configurable)
-- ══════════════════════════════════════════════════════════════
local AirSlide = (function()
    local RS  = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    local LP  = Players.LocalPlayer

    local floorPart = nil
    local slamming  = false
    local inputConn = nil
    local duration  = 0.4
    local friction  = 0
    local keyCode   = Enum.KeyCode.LeftControl

    local function placeFloor(hrp)
        if floorPart then floorPart:Destroy() end
        local p = Instance.new("Part")
        p.Name = "RivalsAntiStuckAirFloor"
        p.Size = Vector3.new(8, 0.2, 8)
        p.Anchored = true
        p.CanCollide = true
        p.Transparency = 1
        p.Material = Enum.Material.SmoothPlastic
        p.Friction = friction
        p.Parent = workspace
        floorPart = p

        local conn
        conn = RS.PreRender:Connect(function()
            if hrp and hrp.Parent then
                if Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z).Magnitude < 5 then
                    slamming = false
                end
            end
            if not slamming or not hrp or not hrp.Parent or floorPart ~= p then
                if conn then conn:Disconnect() end
                p:Destroy()
                return
            end
            p.CFrame = hrp.CFrame * CFrame.new(0, -3, 0)
        end)
    end

    local function doSlide()
        local char = LP.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or slamming then return end
        if hum.FloorMaterial ~= Enum.Material.Air then return end
        slamming = true
        placeFloor(hrp)
        local total = 0
        while slamming and total < duration do
            task.wait(0.01); total += 0.01
        end
        slamming = false
        if floorPart then floorPart:Destroy(); floorPart = nil end
    end

    local M = {}

    function M.Enable()
        if inputConn then return end
        inputConn = UIS.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode == keyCode
               or input.KeyCode == Enum.KeyCode.C
               or input.UserInputType == Enum.UserInputType.Touch then
                task.defer(function()
                    local char = LP.Character
                    local hum  = char and char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.FloorMaterial == Enum.Material.Air then doSlide() end
                end)
            end
        end)
    end

    function M.Disable()
        if inputConn then inputConn:Disconnect(); inputConn = nil end
        slamming = false
        if floorPart then floorPart:Destroy(); floorPart = nil end
    end

    function M.Active() return inputConn ~= nil end
    function M.SetDuration(d) duration = d end
    function M.SetFriction(f) friction = f end
    function M.SetKey(k) keyCode = k end
    function M.GetDuration() return duration end
    function M.GetFriction() return friction end
    function M.GetKeyName() return keyCode.Name end

    return M
end)()

-- ══════════════════════════════════════════════════════════════
--  World Fonts module (client-side only, auto-rescan)
-- ══════════════════════════════════════════════════════════════
local WorldFonts = (function()
    local FONTS = {
        {name="Gotham",       font=Enum.Font.Gotham},
        {name="Sci-Fi",       font=Enum.Font.SciFi},
        {name="Fantasy",      font=Enum.Font.Fantasy},
        {name="Arcade",       font=Enum.Font.Arcade},
        {name="Antique",      font=Enum.Font.Antique},
        {name="Code",         font=Enum.Font.Code},
        {name="Cartoon",      font=Enum.Font.Cartoon},
        {name="Bodoni",       font=Enum.Font.Bodoni},
        {name="Creepster",    font=Enum.Font.Creepster},
        {name="Indie Flower", font=Enum.Font.IndieFlower},
    }

    local originals = {}
    local active = false
    local currentIdx = 1
    local scanConn = nil

    local function collectRoots()
        local roots = {workspace}
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if pg then table.insert(roots, pg) end
        return roots
    end

    local function applyToInstance(d, fontEnum)
        if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
            if originals[d] == nil then
                originals[d] = d.Font
                d.Destroying:Connect(function() originals[d] = nil end)
            end
            pcall(function() d.Font = fontEnum end)
        end
    end

    local function fullScan(fontEnum)
        for _, root in ipairs(collectRoots()) do
            for _, d in ipairs(root:GetDescendants()) do
                applyToInstance(d, fontEnum)
            end
        end
    end

    local function startAutoScan()
        if scanConn then return end
        scanConn = RunService.Heartbeat:Connect(function()
            if not active then return end
            local fontEnum = FONTS[currentIdx].font
            for _, root in ipairs(collectRoots()) do
                for _, d in ipairs(root:GetDescendants()) do
                    if (d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox")) then
                        if originals[d] == nil or d.Font ~= fontEnum then
                            applyToInstance(d, fontEnum)
                        end
                    end
                end
            end
        end)
    end

    local function stopAutoScan()
        if scanConn then scanConn:Disconnect(); scanConn = nil end
    end

    local M = {}

    function M.Enable(idx)
        if active then return end
        active = true
        currentIdx = idx or 1
        fullScan(FONTS[currentIdx].font)
        startAutoScan()
    end

    function M.Disable()
        active = false
        stopAutoScan()
        for inst, orig in pairs(originals) do
            if inst and inst.Parent then pcall(function() inst.Font = orig end) end
        end
        originals = {}
    end

    function M.Active() return active end
    function M.Cycle()
        if not active then return nil end
        currentIdx = (currentIdx % #FONTS) + 1
        fullScan(FONTS[currentIdx].font)
        return FONTS[currentIdx].name
    end
    function M.Set(idx)
        if idx < 1 or idx > #FONTS then return end
        currentIdx = idx
        if active then fullScan(FONTS[idx].font) end
    end
    function M.CurrentName() return FONTS[currentIdx].name end
    function M.FontList() return FONTS end

    return M
end)()

-- ══════════════════════════════════════════════════════════════
--  Hub builder
-- ══════════════════════════════════════════════════════════════
local function buildHub(root,song,sakuraCleanup)
    local lp=LocalPlayer; local cam=workspace.CurrentCamera; local running=true

    local saved=loadSettings(); local savedRage=loadRage()
    for k,v in pairs(saved) do getgenv()[k]=v end
    for k,v in pairs(savedRage) do getgenv()[k]=v end
    getgenv()._rageEnabled = saved.RageEnabled or false

    if getgenv().AirSlideDuration then AirSlide.SetDuration(getgenv().AirSlideDuration) end
    if getgenv().AirSlideFriction then AirSlide.SetFriction(getgenv().AirSlideFriction) end
    if getgenv().AirSlideKey and Enum.KeyCode[getgenv().AirSlideKey] then
        AirSlide.SetKey(Enum.KeyCode[getgenv().AirSlideKey])
    end

    if getgenv().WorldFontsEnabled then
        WorldFonts.Enable(getgenv().WorldFontsIndex or 1)
    end

    local hub=Instance.new("Frame"); hub.Name="Hub"
    hub.AnchorPoint=Vector2.new(0.5,0.5); hub.Position=UDim2.fromScale(0.5,0.5)
    hub.Size=UDim2.new(0,0,0,0); hub.BackgroundColor3=C.BLACK
    hub.BorderSizePixel=0; hub.ZIndex=2; hub.Parent=root
    uiCorner(hub,10); uiStroke(hub,C.PINK,1.5,0.2)

    local hubGrad=Instance.new("UIGradient")
    hubGrad.Color=ColorSequence.new(C.BLACK,C.DARK); hubGrad.Rotation=90; hubGrad.Parent=hub

    for _,anchor in ipairs({Vector2.new(0,0),Vector2.new(0,1)}) do
        local bar=Instance.new("Frame"); bar.AnchorPoint=anchor
        bar.Position=UDim2.new(0,0,anchor.Y,0); bar.Size=UDim2.new(1,0,0,2)
        bar.BackgroundColor3=C.PINK; bar.BorderSizePixel=0; bar.ZIndex=3; bar.Parent=hub
    end

    tw(hub,0.4,{Size=UDim2.new(0,HUB_W,0,HUB_H)},Enum.EasingStyle.Back)

    do
        local dragging,dragStart,startPos=false,nil,nil
        hub.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true; dragStart=input.Position; startPos=hub.Position end
        end)
        hub.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
                local d=input.Position-dragStart
                hub.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
            end
        end)
    end

    task.delay(1.0,function()
        if not running then return end
        TweenService:Create(hub,TweenInfo.new(2.6,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),
            {Position=UDim2.new(hub.Position.X.Scale,hub.Position.X.Offset,hub.Position.Y.Scale,hub.Position.Y.Offset-6)}):Play()
    end)

    local wings=makeWings(hub)

    local sidebar=Instance.new("Frame"); sidebar.Size=UDim2.new(0,SIDEBAR_W,1,0)
    sidebar.BackgroundColor3=C.DARK; sidebar.BorderSizePixel=0; sidebar.ZIndex=3; sidebar.Parent=hub
    uiCorner(sidebar,10)
    local sideSquare=Instance.new("Frame"); sideSquare.AnchorPoint=Vector2.new(1,0)
    sideSquare.Position=UDim2.fromScale(1,0); sideSquare.Size=UDim2.new(0,12,1,0)
    sideSquare.BackgroundColor3=C.DARK; sideSquare.BorderSizePixel=0; sideSquare.ZIndex=3; sideSquare.Parent=sidebar

    local ring=Instance.new("Frame"); ring.AnchorPoint=Vector2.new(0.5,0)
    ring.Position=UDim2.new(0.5,0,0,10); ring.Size=UDim2.new(0,56,0,56)
    ring.BackgroundColor3=C.PINK; ring.BorderSizePixel=0; ring.ZIndex=4; ring.Parent=sidebar; uiCorner(ring,28)

    local portrait=Instance.new("ImageLabel"); portrait.AnchorPoint=Vector2.new(0.5,0.5)
    portrait.Position=UDim2.fromScale(0.5,0.5); portrait.Size=UDim2.new(1,-3,1,-3)
    portrait.BackgroundColor3=C.BLACK; portrait.Image=C.LAUFEY_IMAGE_ID
    portrait.ScaleType=Enum.ScaleType.Crop; portrait.ZIndex=5; portrait.Parent=ring; uiCorner(portrait,26)

    local hubTitle=mkLabel(sidebar,"Laufey.lol",11,Enum.Font.GothamBold,C.PINK,4)
    hubTitle.AnchorPoint=Vector2.new(0.5,0); hubTitle.Position=UDim2.new(0.5,0,0,72)
    hubTitle.Size=UDim2.new(1,-8,0,14); hubTitle.TextXAlignment=Enum.TextXAlignment.Center

    local subTit=mkLabel(sidebar,"♪ laufey",8,Enum.Font.Ubuntu,C.MUTED,4)
    subTit.AnchorPoint=Vector2.new(0.5,0); subTit.Position=UDim2.new(0.5,0,0,86)
    subTit.Size=UDim2.new(1,-8,0,12); subTit.TextXAlignment=Enum.TextXAlignment.Center

    local ver=mkLabel(sidebar,"v2.1 — compact",7,Enum.Font.Gotham,C.MUTED,4)
    ver.AnchorPoint=Vector2.new(0.5,1); ver.Position=UDim2.new(0.5,0,1,-6)
    ver.Size=UDim2.new(1,-8,0,10); ver.TextXAlignment=Enum.TextXAlignment.Center

    local rightArea=Instance.new("Frame"); rightArea.AnchorPoint=Vector2.new(1,0)
    rightArea.Position=UDim2.fromScale(1,0); rightArea.Size=UDim2.new(1,-SIDEBAR_W,1,0)
    rightArea.BackgroundTransparency=1; rightArea.ZIndex=3; rightArea.Parent=hub

    local TAB_NAMES={"Combat","Player","Visual","Ragebot","AirSlide","Misc"}
    local tabBar=Instance.new("Frame"); tabBar.AnchorPoint=Vector2.new(0,0)
    tabBar.Position=UDim2.new(0,5,0,5); tabBar.Size=UDim2.new(1,-10,0,22)
    tabBar.BackgroundColor3=C.PANEL; tabBar.BorderSizePixel=0; tabBar.ZIndex=4; tabBar.Parent=rightArea
    uiCorner(tabBar,6); uiStroke(tabBar,C.PINK,1,0.5)

    local tabBtns={}; local tabPages={}

    local contentArea=Instance.new("Frame"); contentArea.AnchorPoint=Vector2.new(0,0)
    contentArea.Position=UDim2.new(0,5,0,31); contentArea.Size=UDim2.new(1,-10,1,-36)
    contentArea.BackgroundTransparency=1; contentArea.ZIndex=3; contentArea.ClipsDescendants=true
    contentArea.Parent=rightArea

    local function makeTab(name,idx)
        local btn=Instance.new("TextButton")
        btn.Size=UDim2.new(1/#TAB_NAMES,0,1,0); btn.Position=UDim2.new((idx-1)/#TAB_NAMES,0,0,0)
        btn.BackgroundColor3=C.PANEL; btn.AutoButtonColor=false; btn.Text=name
        btn.Font=Enum.Font.GothamMedium; btn.TextSize=9; btn.TextColor3=C.MUTED
        btn.BorderSizePixel=0; btn.ZIndex=5; btn.Parent=tabBar; tabBtns[name]=btn

        local page=Instance.new("Frame"); page.Size=UDim2.fromScale(1,1)
        page.BackgroundTransparency=1; page.Visible=false; page.ZIndex=3; page.Parent=contentArea
        tabPages[name]=page; return page
    end

    local function switchTab(name)
        for n,p in pairs(tabPages) do
            p.Visible=n==name
            tw(tabBtns[n],0.15,{BackgroundColor3=n==name and C.PINK or C.PANEL,TextColor3=n==name and C.BLACK or C.MUTED})
        end
    end

    for i,name in ipairs(TAB_NAMES) do makeTab(name,i); tabBtns[name].MouseButton1Click:Connect(function() switchTab(name) end) end

    local COL_W = (HUB_W - SIDEBAR_W - 20) / 2
    local ROW_H = 26
    local GAP   = 4
    local function cell(col,row)
        return col*(COL_W+GAP)+4, row*(ROW_H+GAP)+4
    end

    local function gridBtn(page,text,col,row,state)
        local b=Instance.new("TextButton"); b.AnchorPoint=Vector2.new(0,0)
        b.Position=UDim2.fromOffset(cell(col,row)); b.Size=UDim2.fromOffset(COL_W,ROW_H)
        b.BackgroundColor3=state and C.ON or C.OFF; b.AutoButtonColor=false
        b.Text=text; b.Font=Enum.Font.GothamMedium; b.TextSize=10; b.TextColor3=C.INK
        b.ZIndex=4; b.Parent=page; uiCorner(b,6); uiStroke(b,C.PINK,1,0.4)
        b.MouseEnter:Connect(function() tw(b,0.12,{BackgroundColor3=C.PINK_SOFT}) end)
        b.MouseLeave:Connect(function() tw(b,0.12,{BackgroundColor3=b.BackgroundColor3}) end)
        return b
    end

    local function gridInput(page,labelText,col,row,default)
        local x,y=cell(col,row)
        local row2=Instance.new("Frame"); row2.Position=UDim2.fromOffset(x,y)
        row2.Size=UDim2.fromOffset(COL_W,ROW_H); row2.BackgroundColor3=C.PANEL; row2.ZIndex=4; row2.Parent=page
        uiCorner(row2,6); uiStroke(row2,C.PINK,1,0.5)
        local lbl=Instance.new("TextLabel"); lbl.BackgroundTransparency=1
        lbl.Position=UDim2.new(0,6,0,0); lbl.Size=UDim2.new(0.55,0,1,0)
        lbl.Text=labelText; lbl.Font=Enum.Font.Gotham; lbl.TextSize=9
        lbl.TextColor3=C.MUTED; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=5; lbl.Parent=row2
        local box=Instance.new("TextBox"); box.AnchorPoint=Vector2.new(1,0.5)
        box.Position=UDim2.new(1,-4,0.5,0); box.Size=UDim2.new(0,40,0,16)
        box.BackgroundColor3=C.DARK; box.Text=tostring(default); box.Font=Enum.Font.GothamMedium
        box.TextSize=9; box.TextColor3=C.INK; box.ClearTextOnFocus=false; box.ZIndex=5; box.Parent=row2
        uiCorner(box,4); uiStroke(box,C.PINK,1,0.6)
        return box
    end

    local function tog(btn,key,onT,offT)
        btn.MouseButton1Click:Connect(function()
            getgenv()[key]=not getgenv()[key]
            btn.Text=getgenv()[key] and onT or offT
            tw(btn,0.2,{BackgroundColor3=getgenv()[key] and C.ON or C.DANGER})
            saveSettings()
        end)
    end

    -- COMBAT
    local cp=tabPages["Combat"]
    local aimBtn    =gridBtn(cp, getgenv().Aimbot and "Aimbot: ON" or "Aimbot: OFF",       0,0,getgenv().Aimbot)
    local fovBtn    =gridBtn(cp, getgenv().ShowFOV and "Show FOV: ON" or "Show FOV: OFF",  1,0,getgenv().ShowFOV)
    local espBtn    =gridBtn(cp, getgenv().ESP and "ESP: ON" or "ESP: OFF",                 0,1,getgenv().ESP)
    local espBoxBtn =gridBtn(cp, getgenv().ESPBox and "ESP Box: ON" or "ESP Box: OFF",      1,1,getgenv().ESPBox)
    local tracerBtn =gridBtn(cp, getgenv().Tracers and "Tracers: ON" or "Tracers: OFF",     0,2,getgenv().Tracers)
    local crossBtn  =gridBtn(cp, getgenv().Crosshair and "Crosshair: ON" or "Crosshair: OFF",1,2,getgenv().Crosshair)

    local smoothBox =gridInput(cp,"Smooth",0,3,getgenv().Smoothness)
    local fovBox    =gridInput(cp,"FOV",1,3,getgenv().FOV)

    local tgtRow=Instance.new("Frame"); local tx,ty=cell(0,4)
    tgtRow.Position=UDim2.fromOffset(tx,ty); tgtRow.Size=UDim2.fromOffset(COL_W*2+GAP,ROW_H)
    tgtRow.BackgroundTransparency=1; tgtRow.ZIndex=4; tgtRow.Parent=cp
    local targetBtns={}
    local tgtW=(COL_W*2+GAP)/3
    for i,mode in ipairs({"Head","Body","Foot"}) do
        local b=Instance.new("TextButton"); b.Size=UDim2.fromOffset(tgtW-2,ROW_H)
        b.Position=UDim2.fromOffset((i-1)*tgtW,0); b.AutoButtonColor=false; b.Text=mode
        b.Font=Enum.Font.GothamMedium; b.TextSize=9; b.TextColor3=C.INK; b.BackgroundColor3=C.OFF
        b.ZIndex=5; b.Parent=tgtRow; uiCorner(b,6); uiStroke(b,C.PINK,1,0.4); targetBtns[mode]=b
    end

    local FOV_COLORS={Color3.fromRGB(255,120,180),Color3.fromRGB(100,220,255),Color3.fromRGB(255,200,100),Color3.fromRGB(100,255,150),Color3.fromRGB(255,100,130)}
    local fovColorIdx=1
    local fovColorBtn=gridBtn(cp,"FOV: Pink",0,5,true)

    local ESP_COLORS={{name="Health",r=nil},{name="White",r=Color3.new(1,1,1)},{name="Pink",r=C.PINK},{name="Cyan",r=Color3.fromRGB(100,220,255)},{name="Yellow",r=Color3.fromRGB(255,200,50)}}
    local espColorIdx=1
    local espColorBtn=gridBtn(cp,"ESP: Health",1,5,true)

    -- PLAYER
    local pp=tabPages["Player"]
    local noclipBtn  =gridBtn(pp,getgenv().Noclip and "Noclip: ON" or "Noclip: OFF",      0,0,getgenv().Noclip)
    local infJumpBtn =gridBtn(pp,getgenv().InfJump and "Inf Jump: ON" or "Inf Jump: OFF",  1,0,getgenv().InfJump)
    local flyBtn     =gridBtn(pp,getgenv().FlyEnabled and "Fly: ON" or "Fly: OFF",         0,1,getgenv().FlyEnabled)
    local flySpBox   =gridInput(pp,"Fly Spd",1,1,getgenv().FlySpeed)

    -- VISUAL
    local vp=tabPages["Visual"]
    local fullbrightBtn=gridBtn(vp,"Fullbright: OFF",0,0,false)
    local chatSpyBtn   =gridBtn(vp,"Chat Spy: OFF",  1,0,false)

    local fontsToggleBtn=gridBtn(vp,
        getgenv().WorldFontsEnabled and "World Fonts: ON" or "World Fonts: OFF",
        0,1,getgenv().WorldFontsEnabled)
    local fontsCycleBtn=gridBtn(vp,
        "Font: "..WorldFonts.CurrentName(),1,1,true)

    fontsToggleBtn.MouseButton1Click:Connect(function()
        getgenv().WorldFontsEnabled = not getgenv().WorldFontsEnabled
        if getgenv().WorldFontsEnabled then
            WorldFonts.Enable(getgenv().WorldFontsIndex or 1)
            fontsToggleBtn.Text="World Fonts: ON"
            tw(fontsToggleBtn,0.2,{BackgroundColor3=C.ON})
        else
            WorldFonts.Disable()
            fontsToggleBtn.Text="World Fonts: OFF"
            tw(fontsToggleBtn,0.2,{BackgroundColor3=C.DANGER})
        end
        saveSettings()
    end)

    fontsCycleBtn.MouseButton1Click:Connect(function()
        getgenv().WorldFontsIndex = ((getgenv().WorldFontsIndex or 1) % #WorldFonts.FontList()) + 1
        if getgenv().WorldFontsEnabled then WorldFonts.Set(getgenv().WorldFontsIndex) end
        fontsCycleBtn.Text="Font: "..WorldFonts.CurrentName()
        saveSettings()
    end)

    -- RAGEBOT
    local rp=tabPages["Ragebot"]

    local rageToggleBtn=gridBtn(rp,
        getgenv()._rageEnabled and "Ragebot: ON" or "Ragebot: OFF",
        0,0,getgenv()._rageEnabled)
    rageToggleBtn.MouseButton1Click:Connect(function()
        getgenv()._rageEnabled=not getgenv()._rageEnabled
        rageToggleBtn.Text=getgenv()._rageEnabled and "Ragebot: ON" or "Ragebot: OFF"
        tw(rageToggleBtn,0.2,{BackgroundColor3=getgenv()._rageEnabled and C.ON or C.DANGER})
        saveSettings()
    end)

    local orbitBtn=gridBtn(rp,"Orbit: ON",1,0,true)
    orbitBtn.MouseButton1Click:Connect(function()
        getgenv().ORBIT_ENABLED=not getgenv().ORBIT_ENABLED
        orbitBtn.Text=getgenv().ORBIT_ENABLED and "Orbit: ON" or "Orbit: OFF"
        tw(orbitBtn,0.2,{BackgroundColor3=getgenv().ORBIT_ENABLED and C.ON or C.DANGER})
        saveRage()
    end)

    local voidTBox   =gridInput(rp,"Void T",    0,1,getgenv().VOID_TIME)
    local atkTBox    =gridInput(rp,"Atk T",     1,1,getgenv().ATTACK_TIME)
    local backBox    =gridInput(rp,"Back",      0,2,getgenv().BACK_OFFSET)
    local heightBox  =gridInput(rp,"Height",    1,2,getgenv().HEIGHT_OFFSET)
    local voidYBox   =gridInput(rp,"Void Y",    0,3,getgenv().VOID_Y)
    local radiusBox  =gridInput(rp,"Rad",       1,3,getgenv().ORBIT_RADIUS)
    local speedBox   =gridInput(rp,"Speed",     0,4,getgenv().ORBIT_SPEED)
    local oHeightBox =gridInput(rp,"Orb H",     1,4,getgenv().ORBIT_HEIGHT)

    local function wireRageInput(box,key)
        box.FocusLost:Connect(function()
            local num=tonumber(box.Text)
            if num then getgenv()[key]=num; saveRage() else box.Text=tostring(getgenv()[key]) end
        end)
    end
    wireRageInput(voidTBox,"VOID_TIME")
    wireRageInput(atkTBox,"ATTACK_TIME")
    wireRageInput(backBox,"BACK_OFFSET")
    wireRageInput(heightBox,"HEIGHT_OFFSET")
    wireRageInput(voidYBox,"VOID_Y")
    wireRageInput(radiusBox,"ORBIT_RADIUS")
    wireRageInput(speedBox,"ORBIT_SPEED")
    wireRageInput(oHeightBox,"ORBIT_HEIGHT")

    local rageStatus=mkLabel(rp,"idle",9,Enum.Font.GothamMedium,C.MUTED,4)
    rageStatus.Position=UDim2.fromOffset(cell(0,5)); rageStatus.Size=UDim2.fromOffset(COL_W*2+GAP,ROW_H)

    -- AIRSLIDE
    local asp=tabPages["AirSlide"]
    local asToggleBtn =gridBtn(asp,
        getgenv().AirSlideEnabled and "AirSlide: ON" or "AirSlide: OFF",
        0,0,getgenv().AirSlideEnabled)
    local asStatusLbl =mkLabel(asp,
        AirSlide.Active() and "armed — press key while airborne" or "disabled",
        9,Enum.Font.GothamMedium,AirSlide.Active() and C.PINK or C.MUTED,4)
    asStatusLbl.Position=UDim2.fromOffset(cell(0,1)); asStatusLbl.Size=UDim2.fromOffset(COL_W*2+GAP,ROW_H)
    asStatusLbl.TextXAlignment=Enum.TextXAlignment.Left
    asStatusLbl.TextSize=9

    local asKeyBox   =gridInput(asp,"Key",     0,2,AirSlide.GetKeyName())
    local asDurBox   =gridInput(asp,"Dur",     1,2,AirSlide.GetDuration())
    local asFricBox  =gridInput(asp,"Friction",0,3,AirSlide.GetFriction())

    local asInfo=mkLabel(asp,
        "Jump, hold movement, then press key while airborne.\nCancels if horizontal velocity < 5.",
        9,Enum.Font.Gotham,C.MUTED,4)
    asInfo.Position=UDim2.fromOffset(cell(0,4))
    asInfo.Size=UDim2.fromOffset(COL_W*2+GAP, ROW_H*2+GAP)
    asInfo.TextWrapped=true; asInfo.TextYAlignment=Enum.TextYAlignment.Top
    asInfo.TextXAlignment=Enum.TextXAlignment.Left

    asToggleBtn.MouseButton1Click:Connect(function()
        if AirSlide.Active() then
            AirSlide.Disable()
            getgenv().AirSlideEnabled=false
            asToggleBtn.Text="AirSlide: OFF"
            tw(asToggleBtn,0.2,{BackgroundColor3=C.DANGER})
            asStatusLbl.Text="disabled"; asStatusLbl.TextColor3=C.MUTED
        else
            AirSlide.Enable()
            getgenv().AirSlideEnabled=true
            asToggleBtn.Text="AirSlide: ON"
            tw(asToggleBtn,0.2,{BackgroundColor3=C.ON})
            asStatusLbl.Text="armed — press key while airborne"; asStatusLbl.TextColor3=C.PINK
        end
        saveSettings()
    end)

    asDurBox.FocusLost:Connect(function()
        local n=tonumber(asDurBox.Text)
        if n and n>0 and n<=5 then
            AirSlide.SetDuration(n); getgenv().AirSlideDuration=n; asDurBox.Text=tostring(n)
        else asDurBox.Text=tostring(AirSlide.GetDuration()) end
        saveSettings()
    end)
    asFricBox.FocusLost:Connect(function()
        local n=tonumber(asFricBox.Text)
        if n and n>=0 then
            AirSlide.SetFriction(n); getgenv().AirSlideFriction=n; asFricBox.Text=tostring(n)
        else asFricBox.Text=tostring(AirSlide.GetFriction()) end
        saveSettings()
    end)
    asKeyBox.FocusLost:Connect(function()
        local k=asKeyBox.Text:upper()
        if Enum.KeyCode[k] then
            AirSlide.SetKey(Enum.KeyCode[k]); getgenv().AirSlideKey=k; asKeyBox.Text=k
        else asKeyBox.Text=AirSlide.GetKeyName() end
        saveSettings()
    end)

    -- MISC
    local mp=tabPages["Misc"]
    local valHandsBtn  =gridBtn(mp,"Val Hands",     0,0,false)
    local killSndBtn   =gridBtn(mp,"Kill Sound",    1,0,false)
    local spoofBtn     =gridBtn(mp,"Rivals Spoof",  0,1,false)
    local alyaBtn      =gridBtn(mp,"Alya Texture",  1,1,false)
    local dracoBtn     =gridBtn(mp,"Draco",         0,2,false)
    local stretchBtn   =gridBtn(mp,"Stretched FOV", 1,2,false)
    local rickBtn      =gridBtn(mp,"Rick",          0,3,false)
    local listFeatBtn  =gridBtn(mp,"List Features", 1,3,true)
    local saveBtn      =gridBtn(mp,"Save Config",   0,4,true)
    local closeBtn     =gridBtn(mp,"Close Hub",     1,4,false)
    tw(closeBtn,0,{BackgroundColor3=C.DANGER})

    dracoBtn.MouseButton1Click:Connect(function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/mrbeanissohot/DraconicWildcat/refs/heads/main/Draco.lua",true))()
        end)
    end)
    stretchBtn.MouseButton1Click:Connect(function()
        pcall(function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Stretched-Resolution-Higher-FOV-48170"))()
        end)
    end)
    rickBtn.MouseButton1Click:Connect(function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/betterthanbefore0207767837-cyber/Rick/refs/heads/main/Ricyyy"))()
        end)
    end)

    listFeatBtn.MouseButton1Click:Connect(function()
        local lines = {
            "═══ LAUFEY.LOL v2.1 — FEATURES ═══",
            "[COMBAT] Aimbot / ShowFOV / ESP / ESPBox / Tracers / Crosshair",
            "         FOV color / ESP color / Target modes (Head/Body/Foot)",
            "[PLAYER] Noclip / InfJump / Fly",
            "[VISUAL] Fullbright / Chat Spy / World Fonts (10 fonts, client-side)",
            "[RAGEBOT] Auto-fire Ragebot / Orbit + configurable timings",
            "[AIRSLIDE] Configurable key / duration / friction",
            "[MISC]   Draco / Stretched FOV / Rick / Val Hands",
            "         Kill Sound / Rivals Spoof / Alya Texture",
            "         Save Config / Load on start",
            "[KEYS]   RightShift = hide/show hub",
            "═══════════════════════════════════",
        }
        for _, l in ipairs(lines) do print(l) end
        print("[Laufey.lol] Feature list printed to console (".. #lines .." lines)")
    end)

    valHandsBtn.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/mrbeanissohot/Bean-sValorant/refs/heads/main/Valorant.lua",true))() end) end)
    killSndBtn.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/betterthanbefore0207767837-cyber/Xgivfc/refs/heads/main/Ffvhhvxd",true))() end) end)
    spoofBtn.MouseButton1Click:Connect(function()
        pcall(function()
            getgenv().Config={victim=11480709640,helper="",level=45648,streak=15765,elo=0,keys=67,premium=false,verified=false,unlockall=false,platform="VR",join="discord.gg/rivalscomp"}
            loadstring(game:HttpGet("https://raw.githubusercontent.com/WEFGQERQEGWGE/a/refs/heads/main/UDRCRFRAMESCRIPT.lua"))()
        end)
    end)
    alyaBtn.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/betterthanbefore0207767837-cyber/Fggb/refs/heads/main/Fgnn"))() end) end)
    saveBtn.MouseButton1Click:Connect(function()
        saveSettings(); saveRage(); saveBtn.Text="Saved ✓"
        task.delay(1.2,function() if saveBtn and saveBtn.Parent then saveBtn.Text="Save Config" end end)
    end)

    local toggleBtn=Instance.new("TextButton"); toggleBtn.AnchorPoint=Vector2.new(0,0)
    toggleBtn.Position=UDim2.new(0,10,0,10); toggleBtn.Size=UDim2.new(0,80,0,22)
    toggleBtn.BackgroundColor3=C.BLACK; toggleBtn.AutoButtonColor=false
    toggleBtn.Text="Hide GUI"; toggleBtn.Font=Enum.Font.GothamMedium; toggleBtn.TextSize=9
    toggleBtn.TextColor3=C.INK; toggleBtn.ZIndex=10; toggleBtn.Parent=root
    uiCorner(toggleBtn,7); uiStroke(toggleBtn,C.PINK,1.5,0.25)

    do
        local dragging,dragStart,startPos,moved=false,nil,nil,false
        toggleBtn.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true; moved=false; dragStart=input.Position; startPos=toggleBtn.Position end
        end)
        toggleBtn.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
                local d=input.Position-dragStart
                if d.Magnitude>4 then moved=true end
                toggleBtn.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
            end
        end)
    end

    local guiVisible=true
    toggleBtn.MouseButton1Click:Connect(function()
        guiVisible=not guiVisible; hub.Visible=guiVisible
        toggleBtn.Text=guiVisible and "Hide GUI" or "Show GUI"
    end)

    switchTab("Combat")

    local function refreshTargets()
        for mode,b in pairs(targetBtns) do tw(b,0.2,{BackgroundColor3=getgenv().TargetMode==mode and C.ON or C.OFF}) end
    end
    for mode,b in pairs(targetBtns) do
        b.MouseButton1Click:Connect(function() getgenv().TargetMode=mode; refreshTargets(); saveSettings() end)
    end
    refreshTargets()

    tog(aimBtn,"Aimbot","Aimbot: ON","Aimbot: OFF")
    tog(fovBtn,"ShowFOV","Show FOV: ON","Show FOV: OFF")
    tog(espBtn,"ESP","ESP: ON","ESP: OFF")
    tog(espBoxBtn,"ESPBox","ESP Box: ON","ESP Box: OFF")
    tog(tracerBtn,"Tracers","Tracers: ON","Tracers: OFF")

    smoothBox.FocusLost:Connect(function() getgenv().Smoothness=tonumber(smoothBox.Text) or getgenv().Smoothness; smoothBox.Text=tostring(getgenv().Smoothness); saveSettings() end)
    fovBox.FocusLost:Connect(function() getgenv().FOV=tonumber(fovBox.Text) or getgenv().FOV; fovBox.Text=tostring(getgenv().FOV); saveSettings() end)

    fovColorBtn.MouseButton1Click:Connect(function()
        fovColorIdx=(fovColorIdx%#FOV_COLORS)+1; cir.Color=FOV_COLORS[fovColorIdx]
        local names={"Pink","Cyan","Orange","Green","Red"}; fovColorBtn.Text="FOV: "..names[fovColorIdx]
    end)
    espColorBtn.MouseButton1Click:Connect(function()
        espColorIdx=(espColorIdx%#ESP_COLORS)+1; espColorBtn.Text="ESP: "..ESP_COLORS[espColorIdx].name
    end)

    crossBtn.MouseButton1Click:Connect(function()
        getgenv().Crosshair=not (getgenv().Crosshair or false)
        crossBtn.Text=getgenv().Crosshair and "Crosshair: ON" or "Crosshair: OFF"
        tw(crossBtn,0.2,{BackgroundColor3=getgenv().Crosshair and C.ON or C.DANGER})
        for _,l in ipairs(chexLines) do l.Visible=getgenv().Crosshair end
        saveSettings()
    end)

    tog(noclipBtn,"Noclip","Noclip: ON","Noclip: OFF")
    RunService.Stepped:Connect(function()
        if not running or not getgenv().Noclip then return end
        local char=lp.Character; if not char then return end
        for _,p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
    end)

    tog(infJumpBtn,"InfJump","Inf Jump: ON","Inf Jump: OFF")
    UserInputService.JumpRequest:Connect(function()
        if not running or not getgenv().InfJump then return end
        local char=lp.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)

    tog(flyBtn,"FlyEnabled","Fly: ON","Fly: OFF")
    flySpBox.FocusLost:Connect(function() getgenv().FlySpeed=tonumber(flySpBox.Text) or 60; flySpBox.Text=tostring(getgenv().FlySpeed); saveSettings() end)

    local flyBV,flyBG,flyConn
    flyBtn.MouseButton1Click:Connect(function()
        if getgenv().FlyEnabled then
            local char=lp.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
            flyBV=Instance.new("BodyVelocity"); flyBV.Velocity=Vector3.zero; flyBV.MaxForce=Vector3.new(1e5,1e5,1e5); flyBV.Parent=hrp
            flyBG=Instance.new("BodyGyro"); flyBG.MaxTorque=Vector3.new(1e5,1e5,1e5); flyBG.P=1e4; flyBG.Parent=hrp
            flyConn=RunService.Heartbeat:Connect(function()
                if not running or not getgenv().FlyEnabled then
                    if flyBV then flyBV:Destroy(); flyBV=nil end
                    if flyBG then flyBG:Destroy(); flyBG=nil end
                    if flyConn then flyConn:Disconnect(); flyConn=nil end; return
                end
                local cf=cam.CFrame; local vel=Vector3.zero; local spd=getgenv().FlySpeed
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel=vel+cf.LookVector*spd end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel=vel-cf.LookVector*spd end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel=vel-cf.RightVector*spd end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel=vel+cf.RightVector*spd end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel=vel+Vector3.new(0,spd,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then vel=vel-Vector3.new(0,spd,0) end
                flyBV.Velocity=vel; flyBG.CFrame=cf
            end)
        else
            if flyBV then flyBV:Destroy(); flyBV=nil end
            if flyBG then flyBG:Destroy(); flyBG=nil end
            if flyConn then flyConn:Disconnect(); flyConn=nil end
        end; saveSettings()
    end)

    local origAmb,origOut
    tog(fullbrightBtn,"Fullbright","Fullbright: ON","Fullbright: OFF")
    fullbrightBtn.MouseButton1Click:Connect(function()
        if getgenv().Fullbright then
            origAmb=game:GetService("Lighting").Ambient; origOut=game:GetService("Lighting").OutdoorAmbient
            game:GetService("Lighting").Ambient=Color3.new(1,1,1); game:GetService("Lighting").OutdoorAmbient=Color3.new(1,1,1); game:GetService("Lighting").Brightness=2
        else
            if origAmb then game:GetService("Lighting").Ambient=origAmb end
            if origOut then game:GetService("Lighting").OutdoorAmbient=origOut end
            game:GetService("Lighting").Brightness=1
        end
    end)
    tog(chatSpyBtn,"ChatSpy","Chat Spy: ON","Chat Spy: OFF")

    local espBoxD={}; local tracerD={}
    local function getBox(player)
        if not espBoxD[player] then
            local lines={}; for i=1,4 do local l=Drawing.new("Line"); l.Thickness=1.5; l.Transparency=0; l.Visible=false; lines[i]=l end
            espBoxD[player]=lines
        end; return espBoxD[player]
    end
    local function getTracer(player)
        if not tracerD[player] then local l=Drawing.new("Line"); l.Thickness=1.2; l.Transparency=0.15; l.Visible=false; tracerD[player]=l end
        return tracerD[player]
    end
    local function removeDrawings(player)
        if espBoxD[player] then for _,l in ipairs(espBoxD[player]) do pcall(function() l:Remove() end) end; espBoxD[player]=nil end
        if tracerD[player] then pcall(function() tracerD[player]:Remove() end); tracerD[player]=nil end
    end

    local CHEX_COLOR=Color3.fromRGB(255,140,190); local CHEX_R=14; local chexAngle=0
    local chexLines={}
    for i=1,6 do local l=Drawing.new("Line"); l.Thickness=1.4; l.Color=CHEX_COLOR; l.Transparency=0.05; l.Visible=false; chexLines[i]=l end
    local function triVerts(cx,cy,r,ba)
        local v={}; for i=0,2 do local a=math.rad(ba+i*120); v[i+1]=Vector2.new(cx+r*math.cos(a),cy+r*math.sin(a)) end; return v
    end

    local cir=Drawing.new("Circle"); cir.Thickness=1.5; cir.Color=C.PINK; cir.Transparency=0.6; cir.Visible=true
    local VP=workspace.CurrentCamera.ViewportSize

    local rageState={phase="void",t0=os.clock(),attackTarget=nil}
    local rageOrbitAngle=0; local rageLastHB=os.clock()
    local rageCachedTarget,rageLastScan=nil,0

    local function scanRageTarget()
        local now=os.clock()
        if now-rageLastScan>0.2 then rageCachedTarget=getRageTarget(); rageLastScan=now end
        return rageCachedTarget
    end
    local function resetRage()
        rageState.phase="void"; rageState.t0=os.clock(); rageState.attackTarget=nil
        rageCachedTarget=nil; rageLastScan=0; rageOrbitAngle=0
    end

    pcall(function()
        local ok,gun=pcall(function() return require(lp.PlayerScripts.Modules.ItemTypes.Gun) end)
        if ok and gun and gun.IsFullyAiming then
            local old=gun.IsFullyAiming
            gun.IsFullyAiming=function(self,...) if getgenv()._rageEnabled then return true end return old(self,...) end
        end
    end)

    local rsConn=RunService.RenderStepped:Connect(function()
        if not running then return end
        VP=workspace.CurrentCamera.ViewportSize
        cir.Visible=getgenv().ShowFOV and guiVisible; cir.Radius=getgenv().FOV; cir.Position=UserInputService:GetMouseLocation()

        if getgenv().Crosshair then
            chexAngle=chexAngle+1.2
            local mp=UserInputService:GetMouseLocation(); local cx,cy=mp.X,mp.Y
            local v1=triVerts(cx,cy,CHEX_R,chexAngle); local v2=triVerts(cx,cy,CHEX_R,chexAngle+180)
            chexLines[1].From=v1[1];chexLines[1].To=v1[2]; chexLines[2].From=v1[2];chexLines[2].To=v1[3]; chexLines[3].From=v1[3];chexLines[3].To=v1[1]
            chexLines[4].From=v2[1];chexLines[4].To=v2[2]; chexLines[5].From=v2[2];chexLines[5].To=v2[3]; chexLines[6].From=v2[3];chexLines[6].To=v2[1]
        end

        for _,v in ipairs(Players:GetPlayers()) do
            if v==lp or not v.Character then
                if espBoxD[v] then for _,l in ipairs(espBoxD[v]) do l.Visible=false end end
                if tracerD[v] then tracerD[v].Visible=false end
            else
                local char=v.Character; local hrp=char:FindFirstChild("HumanoidRootPart")
                local head=char:FindFirstChild("Head"); local hum=char:FindFirstChild("Humanoid")
                local alive=hum and hum.Health>0
                local ec=ESP_COLORS[espColorIdx]; local col
                if ec.r then col=ec.r
                elseif hum then local t=hum.Health/math.max(hum.MaxHealth,1); col=Color3.fromRGB(math.floor((1-t)*255),math.floor(t*200),60)
                else col=Color3.new(1,1,1) end

                if getgenv().ESPBox and hrp and head then
                    local lines=getBox(v)
                    local rsp,ron=cam:WorldToViewportPoint(hrp.Position); local hsp,hon=cam:WorldToViewportPoint(head.Position+Vector3.new(0,0.7,0))
                    if ron and hon and alive then
                        local h=math.abs(rsp.Y-hsp.Y)*1.2; local w=h*0.5; local cx=hsp.X
                        local top=hsp.Y-(h*0.1); local bot=top+h; local lft=cx-w*0.5; local rgt=cx+w*0.5
                        lines[1].From=Vector2.new(lft,top);lines[1].To=Vector2.new(rgt,top)
                        lines[2].From=Vector2.new(lft,bot);lines[2].To=Vector2.new(rgt,bot)
                        lines[3].From=Vector2.new(lft,top);lines[3].To=Vector2.new(lft,bot)
                        lines[4].From=Vector2.new(rgt,top);lines[4].To=Vector2.new(rgt,bot)
                        for _,l in ipairs(lines) do l.Color=col; l.Visible=true end
                    else for _,l in ipairs(lines) do l.Visible=false end end
                elseif espBoxD[v] then for _,l in ipairs(espBoxD[v]) do l.Visible=false end end

                if getgenv().Tracers and hrp then
                    local tracer=getTracer(v); local sp,onS=cam:WorldToViewportPoint(hrp.Position)
                    if onS and alive then tracer.From=Vector2.new(VP.X*0.5,VP.Y); tracer.To=Vector2.new(sp.X,sp.Y); tracer.Color=col; tracer.Visible=true
                    else tracer.Visible=false end
                elseif tracerD[v] then tracerD[v].Visible=false end
            end
        end

        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) and getgenv().Aimbot then
            local tg,d=nil,getgenv().FOV; local m=UserInputService:GetMouseLocation()
            for _,v in pairs(Players:GetPlayers()) do
                if v~=lp and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health>0 then
                    local pt=getTargetPart(v.Character,getgenv().TargetMode)
                    if pt then local pos,os=cam:WorldToViewportPoint(pt.Position)
                        if os then local mag=(Vector2.new(pos.X,pos.Y)-m).Magnitude; if mag<d then d=mag; tg=pt end end
                    end
                end
            end
            if tg and mousemoverel then
                local pos=cam:WorldToViewportPoint(tg.Position); local ml=UserInputService:GetMouseLocation()
                mousemoverel((pos.X-ml.X)*getgenv().Smoothness,(pos.Y-ml.Y)*getgenv().Smoothness)
            end
        end
    end)

    local rageHBConn=RunService.Heartbeat:Connect(function()
        if not running or not getgenv()._rageEnabled then
            if rageState.phase~="void" then resetRage() end; return
        end
        local now=os.clock(); local dt=math.max(now-rageLastHB,0); rageLastHB=now
        local char=lp.Character; local root=char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local elapsed=now-rageState.t0
        if rageState.phase=="void" and elapsed>=getgenv().VOID_TIME then
            rageState.phase="attack"; rageState.t0=now; rageState.attackTarget=scanRageTarget(); rageOrbitAngle=0
        elseif rageState.phase=="attack" and elapsed>=getgenv().ATTACK_TIME then
            rageState.phase="void"; rageState.t0=now; rageState.attackTarget=nil; rageOrbitAngle=0
        end

        if rageState.phase=="attack" then
            local fighter=getLocalFighter()
            if fighter then
                local target=rageState.attackTarget or scanRageTarget()
                if target then pcall(fireAtTarget,fighter,target) end
            end
            local nc=getNearestPlayer(); local er=nc and nc:FindFirstChild("HumanoidRootPart")
            if er then
                if getgenv().ORBIT_ENABLED then
                    rageOrbitAngle=(rageOrbitAngle+math.rad(getgenv().ORBIT_SPEED)*dt)%(math.pi*2)
                    local center=er.Position+Vector3.new(0,getgenv().ORBIT_HEIGHT,0)
                    local offset=Vector3.new(math.cos(rageOrbitAngle)*getgenv().ORBIT_RADIUS,0,math.sin(rageOrbitAngle)*getgenv().ORBIT_RADIUS)
                    root.CFrame=CFrame.new(center+offset,center)
                else
                    local bp=er.Position-(er.CFrame.LookVector*getgenv().BACK_OFFSET)+Vector3.new(0,getgenv().HEIGHT_OFFSET,0)
                    root.CFrame=CFrame.new(bp,er.Position)
                end
                local d=math.floor((root.Position-er.Position).Magnitude*10+0.5)/10
                if rageStatus and rageStatus.Parent then
                    rageStatus.Text=string.format("ATTACK %.1f | Orbit: %s",d,getgenv().ORBIT_ENABLED and "ON" or "OFF")
                    rageStatus.TextColor3=C.PINK
                end
            else resetRage() end
        else
            local t=scanRageTarget(); local base=t and t.hitboxHead.Position or root.Position
            root.CFrame=CFrame.new(Vector3.new(base.X,getgenv().VOID_Y,base.Z))
            if rageStatus and rageStatus.Parent then rageStatus.Text="VOID phase"; rageStatus.TextColor3=C.MUTED end
        end
    end)

    local function trackPlayer(player)
        if player==lp then return end
        local lbl,hl,hpConn,diedConn
        local function cleanup()
            if hpConn then hpConn:Disconnect(); hpConn=nil end
            if diedConn then diedConn:Disconnect(); diedConn=nil end
            if lbl and lbl.Parent then lbl.Parent:Destroy(); lbl=nil end
            if hl then hl:Destroy(); hl=nil end
        end
        local function setup(character)
            cleanup(); local head
            repeat task.wait(0.1); if not character or not character.Parent then return end; head=character:FindFirstChild("Head") until head or not running
            if not running or not head then return end
            lbl=createOverheadGui(head)
            hl=Instance.new("Highlight"); hl.Name="HealthHighlight"; hl.FillTransparency=0.8
            hl.OutlineTransparency=0; hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent=character
            local humanoid=character:WaitForChild("Humanoid",5); if not humanoid then return end
            hpConn=humanoid.HealthChanged:Connect(function() updatePlayerDisplay(player,lbl,hl) end)
            diedConn=humanoid.Died:Connect(function() updatePlayerDisplay(player,lbl,hl) end)
            updatePlayerDisplay(player,lbl,hl)
        end
        player.CharacterAdded:Connect(function(c) if running then setup(c) end end)
        if player.Character then task.spawn(setup,player.Character) end
        task.spawn(function()
            while running and player.Parent do
                if getgenv().ESP then updatePlayerDisplay(player,lbl,hl)
                elseif lbl or hl then cleanup() end
                task.wait(1)
            end; cleanup()
        end)
    end
    for _,p in ipairs(Players:GetPlayers()) do task.spawn(trackPlayer,p) end
    Players.PlayerAdded:Connect(function(p) if running then task.spawn(trackPlayer,p) end end)
    Players.PlayerRemoving:Connect(function(p) removeDrawings(p) end)

    local function outro()
        if not running then return end; running=false
        rsConn:Disconnect(); rageHBConn:Disconnect()
        AirSlide.Disable()
        WorldFonts.Disable()
        cir:Remove(); for _,l in ipairs(chexLines) do pcall(function() l:Remove() end) end
        for _,p in ipairs(Players:GetPlayers()) do removeDrawings(p) end
        toggleBtn:Destroy()
        for _,plr in ipairs(Players:GetPlayers()) do
            local ch=plr.Character; if ch then
                local hh=ch:FindFirstChild("HealthHighlight"); if hh then hh:Destroy() end
                local hd=ch:FindFirstChild("Head"); local bb=hd and hd:FindFirstChild("HealthDisplay"); if bb then bb:Destroy() end
            end
        end
        for _,w in ipairs(wings) do if w.flap then w.flap:Cancel() end; tw(w.frame,0.7,{Size=UDim2.new(0,0,0,0),Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.In) end
        if sakuraCleanup then sakuraCleanup() end
        task.delay(0.5,function() tw(hub,0.6,{Size=UDim2.new(0,0,0,0),Rotation=8},Enum.EasingStyle.Back,Enum.EasingDirection.In) end)
        stopSong(song,1.8)
        local cT=Instance.new("Frame"); cT.Size=UDim2.new(1,0,0.5,0); cT.Position=UDim2.new(0,0,-0.5,0); cT.BackgroundColor3=C.BLACK; cT.BorderSizePixel=0; cT.ZIndex=60; cT.Parent=root
        local cB=Instance.new("Frame"); cB.Size=UDim2.new(1,0,0.5,0); cB.Position=UDim2.new(0,0,1,0); cB.BackgroundColor3=C.BLACK; cB.BorderSizePixel=0; cB.ZIndex=60; cB.Parent=root
        task.delay(0.9,function()
            tw(cT,0.9,{Position=UDim2.new(0,0,0,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut)
            tw(cB,0.9,{Position=UDim2.new(0,0,0.5,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut)
        end)
        local bye=mkLabel(cT,"until next time",16,Enum.Font.GothamMedium,C.PINK,61)
        bye.AnchorPoint=Vector2.new(0.5,0.5); bye.Position=UDim2.new(0.5,0,1,0); bye.Size=UDim2.new(0,400,0,24)
        bye.TextXAlignment=Enum.TextXAlignment.Center; bye.TextTransparency=1
        task.delay(1.6,function() tw(bye,0.8,{TextTransparency=0}) end)
        task.delay(3.4,function() root:Destroy() end)
    end
    closeBtn.MouseButton1Click:Connect(outro)
    UserInputService.InputBegan:Connect(function(input,gp)
        if not gp and input.KeyCode==Enum.KeyCode.RightShift and running then toggleBtn.MouseButton1Click:Fire() end
    end)
end

-- ══════════════════════════════════════════════════════════════
--  Start
-- ══════════════════════════════════════════════════════════════
local function Start()
    local root=Instance.new("ScreenGui"); root.Name="LaufeyHub"
    root.ResetOnSpawn=false; root.IgnoreGuiInset=true; root.DisplayOrder=999; protect(root)
    local song=makeSong(root)
    local preloadImg=Instance.new("ImageLabel"); preloadImg.Size=UDim2.new(0,0,0,0)
    preloadImg.BackgroundTransparency=1; preloadImg.Image=C.LAUFEY_IMAGE_ID; preloadImg.Parent=root
    task.spawn(function() pcall(function() ContentProvider:PreloadAsync({preloadImg}) end) end)
    local sakuraCleanup=makeSakura(root)
    playSong(song)
    buildHub(root,song,sakuraCleanup)
end

-- ══════════════════════════════════════════════════════════════
--  Username bypass (case-insensitive)
-- ══════════════════════════════════════════════════════════════
if not LocalPlayer then
    repeat task.wait(0.1) until Players.LocalPlayer
    LocalPlayer = Players.LocalPlayer
end

do
    local name    = string.lower(LocalPlayer.Name)
    local display = string.lower(LocalPlayer.DisplayName)
    if OWNERS[name] or OWNERS[display] then
        local ok, err = pcall(Start)
        if not ok then warn("[Laufey] Start failed: "..tostring(err)) end
        return
    end
end

-- ══════════════════════════════════════════════════════════════
--  Key gate
-- ══════════════════════════════════════════════════════════════
local kg=Instance.new("ScreenGui"); kg.Name="KeyGate"; protect(kg)

local mf=Instance.new("Frame"); mf.Parent=kg; mf.BackgroundColor3=C.BLACK
mf.Position=UDim2.new(0.4,0,0.4,0); mf.Size=UDim2.new(0,220,0,140)
mf.Active=true; mf.Draggable=true; mf.BorderSizePixel=0
uiCorner(mf,12); uiStroke(mf,C.PINK,1.5,0.25)

local kt=Instance.new("TextLabel"); kt.Parent=mf; kt.Size=UDim2.new(1,0,0,30)
kt.BackgroundTransparency=1; kt.Text="SYSTEM ACCESS"; kt.Font=Enum.Font.GothamBold
kt.TextSize=14; kt.TextColor3=C.PINK

local ki=Instance.new("TextBox"); ki.Parent=mf; ki.Position=UDim2.new(0,15,0,42)
ki.Size=UDim2.new(1,-30,0,32); ki.Text=""; ki.PlaceholderText="Input passcode..."
ki.Font=Enum.Font.Gotham; ki.TextSize=13; ki.TextColor3=C.INK; ki.BackgroundColor3=C.PANEL
uiCorner(ki,8); uiStroke(ki,C.PINK,1,0.4)

local vb=Instance.new("TextButton"); vb.Parent=mf; vb.Position=UDim2.new(0,15,0,88)
vb.Size=UDim2.new(1,-30,0,32); vb.BackgroundColor3=C.PINK; vb.AutoButtonColor=false
vb.Text="SUBMIT"; vb.Font=Enum.Font.GothamMedium; vb.TextSize=13; vb.TextColor3=C.BLACK
uiCorner(vb,8)

local rt=""
ki:GetPropertyChangedSignal("Text"):Connect(function()
    local cur=ki.Text
    if cur=="Invalid Token." or cur=="" then if cur=="" then rt="" end; return end
    if #cur>#rt then rt=rt..string.sub(cur,#rt) elseif #cur<#rt then rt=string.sub(rt,1,#cur) end
    ki.Text=string.rep("*",#rt)
end)

vb.MouseButton1Click:Connect(function()
    if rt==resolve(key1_data) then
        kt.Text="too gay too use this blud fuck yourself"; rt=""; ki.Text=""
    elseif rt==resolve(key2_data) or rt==resolve(key3_data) then
        kg:Destroy(); Start()
    else rt=""; ki.Text=""; ki.PlaceholderText="Invalid Token." end
end)