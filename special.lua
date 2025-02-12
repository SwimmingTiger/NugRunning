local _, helpers = ...

local NugRunning = NugRunning
local class = select(2,UnitClass("player"))


local active = NugRunning.active
local free = NugRunning.free
local UnitGUID = UnitGUID

local function Rampage()
    local rampageID = 184367
    local rampage_opts = NugRunningConfig.spells[rampageID]
    if not rampage_opts then return end
    local rampageCost = 85
    NugRunningConfig.spells[rampageID] = nil

    local timer = NugRunning:CreateTimer()
    free[timer] = nil
    -- table.remove()
    timer.stacktext:Hide()
    timer:SetScript("OnUpdate",nil)
    timer.dstGUID = UnitGUID("player")
    timer.srcGUID = UnitGUID("player")
    timer.dontfree = true
    timer.priority = rampage_opts.priority
    timer.opts = rampage_opts

    -- local timer = f
    timer:ToInfinite()
    timer:UpdateMark()
    timer:SetCount(1)
    local texture = GetSpellTexture(rampageID)
    timer:SetIcon(texture)
    timer:SetColor(unpack(rampage_opts.color))
    timer:EnableSpark(true)


    local lastPositiveUpdate = 0
    local lastRageValue = UnitPower("player")


    local rampage_frame = CreateFrame("Frame")
    rampage_frame.timer = timer
    rampage_frame.CheckFury = function(self)
        if GetSpecialization() == 2 and IsPlayerSpell(184367) then
            rampageCost = IsPlayerSpell(215571) and 95 or 85 -- Frothing Berserker
            if IsPlayerSpell(202922) then -- Carnage
                rampageCost = rampageCost - 10
            end
            timer.bar:SetMinMaxValues(0, rampageCost)
            self:RegisterEvent("UNIT_POWER_FREQUENT")
            self:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE")
        else
            self:UnregisterEvent("UNIT_POWER_FREQUENT")
            self:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE")
            if timer then
                active[timer] = nil
                timer:Hide()
                NugRunning:ArrangeTimers()
            end
        end
    end

    rampage_frame:SetScript("OnUpdate", function(self, time)
        self._elapsed = (self._elapsed or 0) + time
        if self._elapsed < 0.2 then return end
        self._elapsed = 0

        if lastPositiveUpdate + 5 < GetTime() and UnitPower("player") ~= UnitPowerMax("player") then
            NugRunning.active[timer] = nil
            timer:Hide()
            NugRunning:ArrangeTimers()
            self:Hide()
        end
    end)

    rampage_frame:SetScript("OnEvent",function(self, event, unit)
        if event == "SPELLS_CHANGED" then
            return self:CheckFury()
        end

        if event == "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" and unit == rampageID then
            -- if timer.shine:IsPlaying() then timer.shine:Stop() end
            if timer.glow:IsPlaying() then timer.glow:Stop() end
            -- timer:VScale(0.6)
            timer.bar:SetValue(100)
            timer:SetColor(unpack(rampage_opts.color))
        end

        if unit ~= "player" then return end

        local rage = UnitPower("player")

        if lastRageValue < rage then
            lastPositiveUpdate = GetTime()
            self:Show() -- show rampage_frame and start it's on update loop

            local p = rampageCost-UnitPower("player")

            -- if p > 20 then
            --     timer:VScale(0.6)
            -- else
            --     timer:VScale(1)
            -- end

            if p <= 0 then
                -- if not timer.shine:IsPlaying() then timer.shine:Play() end
                if not timer.glow:IsPlaying() then timer.glow:Play() end
                if rampage_opts.effect then
                    timer.effect:SetEffect(rampage_opts.effect)
                    timer.effect:Show()
                end
                timer.bar:SetValue(100)
                timer:SetColor(unpack(rampage_opts.color2))
            else
                -- if timer.shine:IsPlaying() then timer.shine:Stop() end
                if timer.glow:IsPlaying() then timer.glow:Stop() end
                timer.effect:Hide()
                timer.bar:SetValue(p)
                timer:SetColor(helpers.GetGradientColor(rampage_opts.color2, rampage_opts.color, (p/rampageCost)^0.7 ))
            end

            if not NugRunning.active[timer] then
                timer:Show()
                NugRunning.active[timer] = true
                NugRunning:ArrangeTimers()
            end
        end
        lastRageValue = rage
    end)

    rampage_frame:RegisterEvent("SPELLS_CHANGED")
    rampage_frame:CheckFury()
end

local function Warlock()
    local PurgeCorruption = function()
        for timer in pairs(NugRunning.active) do
            if timer.spellID == 146739 and timer.timeless then
                timer.isGhost = true
                timer.expiredGhost = true
                -- timer.timeless = false
                free[timer] = true
            end
        end
    end

    local corhide = CreateFrame"Frame"
    local ticker

    corhide:RegisterEvent("SPELLS_CHANGED")
    corhide:SetScript("OnEvent", function(self, event)
        if event == "SPELLS_CHANGED" then
            if IsPlayerSpell(196103) then -- Absolute Corruption
                corhide:RegisterEvent("PLAYER_REGEN_ENABLED")
                corhide:RegisterEvent("PLAYER_REGEN_DISABLED")
            else
                corhide:UnregisterEvent("PLAYER_REGEN_ENABLED")
                corhide:UnregisterEvent("PLAYER_REGEN_DISABLED")
                if ticker then ticker:Cancel() end
            end
        elseif event == "PLAYER_REGEN_ENABLED" then
            PurgeCorruption()
            ticker = C_Timer.NewTicker(30, PurgeCorruption)
        elseif ticker then
            ticker:Cancel()
            ticker = nil
        end
    end)


    -- local cf = CreateFrame"Frame"
    --
    -- local corruptionID = 146739
    -- local corruptionName = GetSpellInfo(corruptionID)
    -- local corruption_opts = NugRunningConfig.spells[corruptionID]
    -- if not corruption_opts then return end
    -- NugRunningConfig.spells[corruptionID] = nil
    --
    -- local timer = NugRunning:CreateTimer()
    -- table.remove(NugRunning.timers)
    -- timer.stacktext:Hide()
    -- timer.bar:SetValue(100)
    -- timer:SetScript("OnUpdate",nil)
    -- timer.dstGUID = UnitGUID("player")
    -- timer.srcGUID = UnitGUID("player")
    -- timer.startTime = 0
    -- timer.endTime = 1
    -- timer.dontfree = true
    -- timer.priority = corruption_opts.priority
    -- timer:VScale(0.5)
    -- timer.opts = { name = corruption_opts.name, color = corruption_opts.color }
    --
    -- timer:UpdateMark()
    -- timer:SetCount(1)
    -- local texture = GetSpellTexture(corruptionID)
    -- timer:SetIcon(texture)
    -- timer:SetColor(unpack(corruption_opts.color))
    --
    --
    -- cf:RegisterEvent("SPELLS_CHANGED")
    -- -- cf:RegisterEvent("PLAYER_REGEN_DISABLED")
    --
    --
    -- local function IsAbsolutelyCorrupted(unit)
    --     if not UnitExists(unit) then return false end
    --     local name = UnitAura(unit, corruptionName, nil, "HARMFUL|PLAYER")
    --     if name then return true end
    -- end
    --
    -- cf:SetScript("OnEvent", function(self, event)
    --     if event == "SPELLS_CHANGED" then
    --         if IsPlayerSpell(196103) then
    --             NugRunningConfig.spells[corruptionID] = nil
    --             cf:RegisterUnitEvent("UNIT_AURA", "target")
    --             cf:RegisterEvent("PLAYER_TARGET_CHANGED")
    --         else
    --             NugRunning.active[timer] = nil
    --             timer:Hide()
    --             cf:UnregisterEvent("UNIT_AURA")
    --             cf:UnregisterEvent("PLAYER_TARGET_CHANGED")
    --
    --             NugRunningConfig.spells[corruptionID] = corruption_opts
    --         end
    --     elseif event == "PLAYER_TARGET_CHANGED" or event == "UNIT_AURA" then
    --         if IsAbsolutelyCorrupted("target") then
    --             timer.dstGUID = UnitGUID("target")
    --             if not NugRunning.active[timer] then
    --                 timer:Show()
    --                 NugRunning.active[timer] = true
    --             end
    --         else
    --             NugRunning.active[timer] = nil
    --             timer:Hide()
    --         end
    --         NugRunning:ArrangeTimers()
    --     end
    -- end)

    -- do
    --     local imps = CreateFrame"Frame"

    --     -- 105174 -- hog spell
    --     -- 104317 -- imp SPELL_SUMMON
    --     local hogID = 104317
    --     local hogName = GetSpellInfo(hogID)
    --     local hog_opts = NugRunningConfig.spells[hogID]
    --     if not hog_opts then return end
    --     NugRunningConfig.spells[hogID] = nil

    --     local timer = NugRunning:CreateTimer()
    --     free[timer] = nil
    --     -- timer.stacktext:Hide()
    --     timer.bar:SetValue(100)
    --     -- timer:SetScript("OnUpdate",nil)
    --     timer.dstGUID = UnitGUID("player")
    --     timer.srcGUID = UnitGUID("player")
    --     timer.startTime = 0
    --     timer.endTime = 1
    --     timer.isExternal = true
    --     timer.priority = hog_opts.priority
    --     timer.opts = { name = hog_opts.name, color = hog_opts.color }
    --     -- if hog_opts.scale then
    --         -- timer:VScale(hog_opts.scale)
    --     -- end

    --     local nameText = NugRunning:MakeName(hog_opts, hogName)
    --     timer:SetName(nameText)

    --     timer:UpdateMark()
    --     timer:SetCount(1)

    --     local texture = GetSpellTexture(205146) -- some Imps Texture
    --     timer:SetIcon(texture)
    --     timer:SetColor(unpack(hog_opts.color))

    --     imps:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    --     imps:RegisterEvent("SPELLS_CHANGED")

    --     local bit_band = bit.band
    --     local AFFILIATION_MINE = COMBATLOG_OBJECT_AFFILIATION_MINE

    --     local ImpHistory = {}
    --     local duration = hog_opts.duration
    --     local math_floor = math.floor
    --     local round = function(v) return math_floor(v*10+.1)/10 end

    --     local UpdateCounter = function(t)
    --         local nowInt = round(GetTime())
    --         local numImps = 0
    --         for timestamp, count in pairs(ImpHistory) do
    --             if timestamp < nowInt then
    --                 ImpHistory[timestamp] = nil
    --             else
    --                 numImps = numImps + count
    --             end
    --         end
    --         t:SetCount(numImps)
    --     end

    --     timer.onupdate = function(self)
    --         UpdateCounter(self)
    --     end

    --     imps:SetScript("OnEvent",
    --     function( self, event, timestamp, eventType, hideCaster,
    --         srcGUID, srcName, srcFlags, srcFlags2,
    --         dstGUID, dstName, dstFlags, dstFlags2,
    --         spellID, spellName, spellSchool, auraType, amount)

    --         if (spellID == 104317 or spellID == 196271) and eventType == "SPELL_SUMMON" and
    --             (bit_band(srcFlags, AFFILIATION_MINE) == AFFILIATION_MINE) then

    --             local now = GetTime()
    --             local ts = round(now) + duration
    --             if not ImpHistory[ts] then
    --                 ImpHistory[ts] = 1
    --             else
    --                 ImpHistory[ts] = ImpHistory[ts] + 1
    --             end

    --             UpdateCounter(timer)

    --             local maxts = 0
    --             for k in pairs(ImpHistory) do
    --                 if k ~= ts and k > maxts then
    --                     maxts = k
    --                 end
    --             end

    --             timer.startTime = now
    --             timer.endTime = timer.startTime + hog_opts.duration
    --             timer.bar:SetMinMaxValues(timer.startTime, timer.endTime)

    --             if now < maxts then
    --                 timer.opts.recast_mark = timer.endTime - maxts
    --             else
    --                 timer.opts.recast_mark = nil
    --             end
    --             timer:UpdateMark()

    --             timer:Show()
    --             NugRunning.active[timer] = true
    --             NugRunning:ArrangeTimers()

    --         elseif event == "SPELLS_CHANGED" then
    --             if GetSpecialization() == 2 then
    --                 self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    --             else
    --                 self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    --             end
    --         end

    --     end)
    -- end
end


function NugRunning.SetupSpecialTimers()
    if class  == "WARRIOR" then
        Rampage()
    end

    if class == "WARLOCK" then
        Warlock()
    end
end
