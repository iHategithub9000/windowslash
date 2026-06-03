-- WindowSlashLibrary.lua
-- made by painscreen (yourhardworkgone) on discord

local WindowSlash = {}
local slashshakesidelast = 0
local shakedistance = 40
local slash = false;
local frames = 0;
local soundchannel = nil;
local bigslash = nil;
local bigslashdone = false;
local ninesrendered = false;
local windowshakestoptimer = 10;
local shakedistdecrease = 1;
local killcyf = true;
local nineshakeintensity = 5;
local almightglob = false;
local slashsize = 5;

function WindowSlash.SetParam(param, value)
    if slash then error("SetParam: cannot set params after StartSlash") end
    if type(param) ~= "string" then error("SetParam: parameter name must be a string") end
    if type(value) ~= "number" and type(value) ~= "boolean" and type(value) ~= "string" then error("SetParam: parameter value must be a number, boolean or string, got " .. type(value)) end
    if param == "WindowShakeDistance" then
        if type(value) ~= "number" then error("SetParam: WindowShakeDistance must be a number, got " .. type(value)) end
        shakedistance = value
    elseif param == "Permanence" then
        if type(value) ~= "boolean" and type(value) ~= "string" then error("SetParam: Permanence must be a boolean or string, got " .. type(value)) end
        almightglob = value
    elseif param == "KillCYF" then
        if type(value) ~= "boolean" then error("SetParam: KillCYF must be a boolean, got " .. type(value)) end
        killcyf = value
    elseif param == "WindowShakeStopSleepTimer" then
        if type(value) ~= "number" then error("SetParam: WindowShakeStopSleepTimer must be a number, got " .. type(value)) end
        windowshakestoptimer = value
    elseif param == "CameraShakeIntensity" then
        if type(value) ~= "number" then error("SetParam: CameraShakeIntensity must be a number, got " .. type(value)) end
        nineshakeintensity = value
    elseif param == "SliceScale" then
        if type(value) ~= "number" then error("SetParam: SliceScale must be a number, got " .. type(value)) end
        slashsize = value
    elseif param == "WindowShakeDistanceDecrease" then
        if type(value) ~= "number" then error("SetParam: WindowShakeDistanceDecrease must be a number, got " .. type(value)) end
        shakedistdecrease = value
    else
        error("SetParam: got unknown parameter " .. param .. ", check documentation for a list of valid parameters")
    end
end

function WindowSlash.GetSlashStarted()
    return slash
end

function WindowSlash._WindowsCheck()
    if not windows then
        error("_WindowsCheck: This library is only compatible with the Windows version of CYF, and will not work on other platforms. If you are seeing this message, you are likely trying to use this library on an unsupported platform.")
    end
end

function WindowSlash.StartSlash()
    WindowSlash._WindowsCheck()
    Misc.WindowName=""
    math.randomseed(os.time())
    if not slash then 
        Time.timeScale = 1
        soundchannel = "_windowslash_sfx_" .. WindowSlash._randomString(64)
        slash = true
        NewAudio.CreateChannel(soundchannel)
        NewAudio.PlaySound(soundchannel, "slice")
        WindowSlash._bigSlashCreate()
    else
        error("StartSlash: Slash has already been started")
    end
end

function WindowSlash._randomString(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local result = ""
    for i = 1, length do
        local index = math.random(1, #chars)
        result = result .. chars:sub(index, index)
    end

    return result
end

function WindowSlash._bigSlashCreate()
    bigslash = CreateSprite("UI/Battle/spr_slice_o_0", "Top")
    bigslashdone = false;
    bigslash.xscale = slashsize
    bigslash.yscale = slashsize
    bigslash.absx = Misc.WindowWidth / 2
    bigslash.absy = Misc.WindowHeight / 2
end

function WindowSlash._bigSlashTick()
    if bigslash == nil then return end
    local frame = bigslash.spritename:match("_(%d+)$")
    if frame == "5" then
        bigslash.Remove()
        bigslash = nil;
        bigslashdone = true;
    else
        bigslash.Set("UI/Battle/spr_slice_o_" .. (tonumber(frame) + 1))
    end
end

function WindowSlash._renderNines()
    if bigslashdone == false then return end
    if ninesrendered == true then return end
    local ninestext = {"[font:uidamagetext][noskip][instant]999999999999999999999999999999999999\n999999999999999999999999999999999999\n999999999999999999999999999999999999\n999999999999999999999999999999999999\n999999999999999999999999999999999999\n999999999999999999999999999999999999\n999999999999999999999999999999999999\n999999999999999999999999999999999999\n999999999999999999999999999999999999\n999999999999999999999999999999999999\n999999999999999999999999999999999999\n999999999999999999999999999999999999\n999999999999999999999999999999999999\n999999999999999999999999999999999999\n999999999999999999999999999999999999\n999999999999999999999999999999999999\n999999999999999999999999999999999999\n999999999999999999999999999999999999\n999999999999999999999999999999999999\n999999999999999999999999999999999999\n999999999999999999999999999999999999\n999999999999999999999999999999999999\n999999999999999999999999999999999999\n999999999999999999999999999999999999\n999999999999999999999999999999999999\n"}
    local nines = CreateText(ninestext, {-16,-16}, 100000000, "Top")
    nines.progressmode = "none"
    nines.absx = 0
    nines.absy = Misc.WindowHeight
    nines.HideBubble()
    nines.color32 = {255,0,0}
    NewAudio.PlaySound(soundchannel, "hitsound")
    Misc.ShakeScreen( 99999999999, nineshakeintensity, false )
    ninesrendered = true
end

function WindowSlash.Update()
    frames = frames + (1*Time.timeScale)
    WindowSlash._renderNines()
    if frames % 6 == 0 then
        WindowSlash._bigSlashTick()
    end
    if slash then
        WindowSlash._RemoveCYFTraditionalBehaviour()
    end
    if slash and bigslashdone then
        
        if frames % 5 == 0 then
            WindowSlash._SlashShake()
        end
    end
end

function WindowSlash._RemoveCYFTraditionalBehaviour()
    local BIG = 10000000
    UI.background.x = BIG
    UI.background.y = BIG
    UI.Hide(true)
    Arena.Hide(true)
    Arena.ResizeImmediate(0, 0)
    Misc.MoveDebuggerToAbs(BIG, BIG) 
    Player.ForceHP(BIG)
    Player.SetControlOverride(true)
    Player.Move(BIG, BIG, true)
    if Encounter ~= nil then
        for i=1, #Encounter.GetVar("enemies") do
            Encounter.GetVar("enemies")[i].Call("Move", {BIG,BIG})
        end
    else
        for i=1, #enemies do
            enemies[i].Call("Move", {BIG,BIG})
        end
    end
end

function WindowSlash._SlashShake()
    if slashshakesidelast == 0 then
        Misc.MoveWindow(-shakedistance, 0)
        slashshakesidelast = 1
    else
        Misc.MoveWindow(shakedistance, 0)
        slashshakesidelast = 0
    end
    if shakedistance > 0 then
        shakedistance = shakedistance - shakedistdecrease
    end
    if  1 > shakedistance then
        windowshakestoptimer = windowshakestoptimer - 1
    end
    if windowshakestoptimer <= 0 then
        if almightglob ~= false then
            SetAlMightyGlobal(almightglob, true);
        end
        if killcyf then
            Misc.DestroyWindow()
        else 
            State("DONE")
        end
    end
end

return WindowSlash
