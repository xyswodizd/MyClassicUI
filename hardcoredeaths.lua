--屏蔽死亡等级通知
local minLevel = 30

-- 固定颜色代码
local LV_COLOR = "|cff3e66ff" -- 玩家等级颜色
local NAME_COLOR = "|cffffff00" -- 玩家名字颜色
local LOCATION_COLOR = "|cffff9900" -- 死亡地点颜色
local ENEMY_COLOR = "|cff00ffff" -- 敌人颜色
local WHITE_COLOR = "|cffffffff" -- 白色
local RED_COLOR = "|cffff0000" -- 红色

local level_icon = "|TInterface\\AddOns\\MyClassicUI\\Textures\\等级:12:12|t" -- 等级图标
local grave_icon = "|TInterface\\AddOns\\MyClassicUI\\Textures\\墓碑:12:12|t" -- 墓碑图标

-- 确保 Accidentals 表中的值是正确的
local Accidentals = {
    ["失足摔死"] = grave_icon,
    ["被岩浆烤得外焦里嫩"] = grave_icon,
    ["意外溺毙"] = grave_icon,
}

local function formatNameAndLevel(name, level)
    return string.format("%s%s|r%s%s[Lv:%s]|r", NAME_COLOR, name, LV_COLOR, level_icon, level)
end

local function highlightDeath(name, location, level, isKilled, killer)
    if tonumber(level) < minLevel then return "" end
    local baseFormat = formatNameAndLevel(name, level) .. "%s在%s|r%s<%s>|r%s" -- 在这里添加了墓碑图标
    local additional = isKilled and string.format("%s被%s<%s>|r%s斩杀！|r", WHITE_COLOR, ENEMY_COLOR, killer, RED_COLOR) or "！"
    return string.format(baseFormat .. additional, WHITE_COLOR, grave_icon, LOCATION_COLOR, location, grave_icon) -- 在这里添加了墓碑图标
end

local function highlightKilled(name, killer, location, level)
    return highlightDeath(name, location, level, true, killer)
end

local function highlightAccidental(name, location_acc, level)
    return highlightDeath(name, location_acc, level, false)
end

local highlightDeathFilter = function(msg)
    if strfind(msg, "消灭了") then
        local s, c = gsub(msg, "(.+)被一个(.+)消灭了，地点位于(.+)！该玩家的等级为(%d+)级", highlightKilled)
        if c > 0 then return s end
    else
        local s, c = gsub(msg, "(.+)在(.+)！该玩家的等级为(%d+)级", highlightAccidental)
        if c > 0 then return s end
    end
    return msg
end

-- 通告修改
local __RaidWarningFrame_OnEvent = RaidWarningFrame:GetScript("OnEvent")
RaidWarningFrameSlot1:SetSpacing(1)
RaidWarningFrameSlot1:SetShadowOffset(3, -3)
RaidWarningFrameSlot1:SetShadowColor(0, 0, 0, 1)
RaidWarningFrameSlot2:SetSpacing(1)
RaidWarningFrameSlot2:SetShadowOffset(3, -3)
RaidWarningFrameSlot2:SetShadowColor(0, 0, 0, 1)
RaidWarningFrame:SetScript("OnEvent", function(self, event, message)
    if event == "HARDCORE_DEATHS" then
        message = highlightDeathFilter(message)
        if message ~= "" then
            RaidNotice_AddMessage(self, message, { r = 255, g = 255, b = 0 })
        end
        return
    end
    __RaidWarningFrame_OnEvent(self, event, message)
end)

-- 新的AddMessage函数，用于检查并可能屏蔽消息以及高亮关键字
local function newAddMessage(self, text, ...)
    text = highlightDeathFilter(text)
    if text ~= "" then
        RaidWarningFrame.AddMessage(self, text, ...)
    end
end