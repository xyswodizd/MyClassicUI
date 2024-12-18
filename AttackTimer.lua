local frame, events = CreateFrame("Frame"), {};

local AttackTimer_Eventer = events

local L = setmetatable({}, {
    __index = function(table, key)
        if key then
            table[key] = tostring(key)
        end
        return tostring(key)
    end,
})

if (GetLocale() == "zhCN") then
    L["Attack"] = "攻击"
    L["Whirlwind"] = "旋风斩"
    L["Heroic Strike"] = "英勇打击"
    L["Raptor Strike"] = "猛禽一击"
elseif (GetLocale() =="zhTW") then 
    L["Attack"] = "攻擊"; 
    L["Whirlwind"] = "旋風斬"; 
    L["Heroic Strike"] = "英勇打擊"; 
    L["Raptor Strike"] = "猛禽一擊"; 
end

local AttackTimer_Enabled = false
local AttackTimer_LastSpeed = UnitAttackSpeed("player")
local AttackTimer_TriggerSpells = {L["Whirlwind"], L["Heroic Strike"], L["Raptor Strike"]}

function AttackTimer_OnLoad(self)
    self:SetMinMaxValues(0, 1)
    self:SetValue(1)
end

local function AttackTimer_FlashBar()
    if (not AttackTimerBar:IsVisible()) then
        AttackTimerBar:Hide()
    end
    if AttackTimerBar:IsShown() then
        local min, max = AttackTimerBar:GetMinMaxValues()
        AttackTimerBar:SetValue(max)
        --AttackTimerBar:SetStatusBarColor(0.0, 1.0, 0.0)
        AttackTimerBarSpark:Hide()
        AttackTimerBarFlash:SetAlpha(0.0)
        AttackTimerBarFlash:Show()
        AttackTimerBar.casting = nil
        AttackTimerBar.flash = 1
        AttackTimerBar.fadeOut = 1
    end
end
local function AttackTimer_OnAttack(parry)
    local min, max = GetTime()
    local curTime, mainS, isHands = min, UnitAttackSpeed("player")
    if isHands then
        return
    end
    if (parry and AttackTimerBar.start and AttackTimerBar.stop) then
        if (not AttackTimerBar:IsVisible()) then
            return
        end
        min = AttackTimerBar.start
        max = AttackTimerBar.stop
        if ((curTime - min) < 0.6 * mainS) then
            max = max - 0.4 * mainS
        end
    else
        max = min + mainS
    end
    AttackTimerBar:SetStatusBarColor(1.0, 0.7, 0.0)
    AttackTimerBar:SetMinMaxValues(min, max)
    AttackTimerBar:SetValue(curTime)
    AttackTimerBar:SetAlpha(1.0)
    AttackTimerBar.start = min
    AttackTimerBar.stop = max
    AttackTimerBar.casting = 1
    AttackTimerBar.fadeOut = nil
    AttackTimerBarSpark:Show()
    AttackTimerBar:Show()
    AttackTimerBarTextLeft:SetText(L["Attack"])
end
local function isAttackSpell(spell)
    for k, v in pairs(AttackTimer_TriggerSpells) do
        if (v == spell) then
            return true
        end
    end
    return false
end
function AttackTimer_Eventer:SWING_DAMAGE(...)
    local timestamp,
        event,
        hideCaster,
        sourceGUID,
        sourceName,
        sourceFlags,
        sourceRaidFlags,
        sourceFlags2,
        destGUID,
        destName,
        destFlags,
        destFlags2,
        auraId,
        auraName = ...
    if (CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_ME)) then
        AttackTimer_OnAttack()
    end
end
function AttackTimer_Eventer:COMBAT_LOG_EVENT_UNFILTERED(...)
    local timestamp,
        event,
        hideCaster,
        sourceGUID,
        sourceName,
        sourceFlags,
        sourceFlags2,
        destGUID,
        destName,
        destFlags,
        destFlags2,
        auraId,
        auraName = CombatLogGetCurrentEventInfo()
    if event == "SWING_MISSED" then
        if (CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_ME)) then
            AttackTimer_OnAttack()
        elseif (CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_ME) and auraId == "PARRY") then
            AttackTimer_OnAttack(true)
        end
    elseif event == "SWING_DAMAGE" then
        if (CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_ME)) then
            AttackTimer_OnAttack()
        end
    elseif event == "SPELL_DAMAGE" then
        if (CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_ME) and isAttackSpell(auraName)) then
            AttackTimer_OnAttack()
        end
    elseif event == "SPELL_MISSED" then
        if (CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_ME) and isAttackSpell(auraName)) then
            AttackTimer_OnAttack()
        end
    end
end
function AttackTimer_Eventer:SPELL_DAMAGE(...)
    local timestamp,
        event,
        hideCaster,
        sourceGUID,
        sourceName,
        sourceFlags,
        sourceFlags2,
        destGUID,
        destName,
        destFlags,
        destFlags2,
        auraId,
        auraName = ...
    if (CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_ME) and isAttackSpell(auraName)) then
        AttackTimer_OnAttack()
    end
end
function AttackTimer_Eventer:SPELL_MISSED(...)
    local timestamp,
        event,
        hideCaster,
        sourceGUID,
        sourceName,
        sourceFlags,
        sourceFlags2,
        destGUID,
        destName,
        destFlags,
        destFlags2,
        auraId,
        auraName = ...
    if (CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_ME) and isAttackSpell(auraName)) then
        AttackTimer_OnAttack()
    end
end
function AttackTimer_Eventer:PLAYER_LEAVE_COMBAT()
    AttackTimer_FlashBar()
end
function AttackTimer_Eventer:UNIT_ATTACK_SPEED()
    local mainSpeed, isHands = UnitAttackSpeed("player")
    if isHands then
        return
    end
    if (mainSpeed ~= AttackTimer_LastSpeed and AttackTimerBar.start) then
        AttackTimer_LastSpeed = mainSpeed
        AttackTimerBar.stop = AttackTimerBar.start + mainSpeed
        AttackTimerBar:SetMinMaxValues(AttackTimerBar.start, AttackTimerBar.stop)
        AttackTimerBar:SetValue(GetTime())
    end
end
function AttackTimer_Eventer:PLAYER_REGEN_DISABLED()
    if (AttackTimerMove:IsVisible()) then
        AttackTimerMove:Hide()
    end
end
function AttackTimer_OnUpdate(self)
    if (not AttackTimer_Enabled) then
        return
    end
    local min, max = AttackTimerBar:GetMinMaxValues()
    if self.casting then
        local status = GetTime()
        if status > max then
            status = max
        end
        AttackTimerBarTextRight:SetText(format("%0.1f", max-status));
        AttackTimerBar:SetValue(status); 
        AttackTimerBarFlash:Hide();
        local sparkPosition = ((status - min) / (max - min)) * 195;
        if sparkPosition < 0 then
            sparkPosition = 0;
        end
        AttackTimerBarSpark:SetPoint("CENTER", AttackTimerBar, "LEFT", sparkPosition, 0)
        if max - status <= 0 then
            AttackTimer_FlashBar()
        end
    elseif self.flash then
        local alpha = AttackTimerBarFlash:GetAlpha() + CASTING_BAR_FLASH_STEP
        if alpha < 1 then
            AttackTimerBarFlash:SetAlpha(alpha)
        else
            AttackTimerBarFlash:SetAlpha(1.0)
            self.flash = nil
        end
    elseif self.fadeOut then
        local alpha = self:GetAlpha() - CASTING_BAR_ALPHA_STEP
        if alpha > 0 then
            self:SetAlpha(alpha)
        else
            self.fadeOut = nil
            self:Hide()
        end
    end
end
function AttackTimer_Toggle(switch)
    if (switch) then
        AttackTimer_Eventer:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        AttackTimer_Eventer:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        AttackTimer_Eventer:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        AttackTimer_Eventer:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        AttackTimer_Eventer:RegisterEvent("PLAYER_LEAVE_COMBAT")
        AttackTimer_Eventer:RegisterEvent("UNIT_ATTACK_SPEED")
        AttackTimer_Eventer:RegisterEvent("PLAYER_REGEN_DISABLED")
        AttackTimer_Enabled = true
    else
        AttackTimer_Eventer:UnregisterAllEvent()
        AttackTimer_FlashBar()
        AttackTimerMove:Hide()
        AttackTimer_Enabled = false
    end
end
function AttackTimer_AjustPosition()
    if (AttackTimerMove:IsVisible()) then
        AttackTimerMove:Hide()
        AttackTimerBar:Hide()
    else
        AttackTimerMove:Show()
        AttackTimerBar:Show()
        AttackTimerBar:SetAlpha(1)
    end
end

frame:SetScript("OnEvent", function(self, event, ...)
    events[event](...);
end)

function events:RegisterEvent(event)
    frame:RegisterEvent(event)
end

function events:UnregisterAllEvent(event)
    events = {}
end

AttackTimer_Toggle(true)

SlashCmdList["ATTACKTIMER"] = function(msg, editbox)
    AttackTimer_AjustPosition()
end
SLASH_ATTACKTIMER1 = "/ATTACKTIMER"