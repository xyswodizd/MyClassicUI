ActionButton1:ClearAllPoints()--主动作条
ActionButton1:SetPoint("CENTER", UIParent, "CENTER", -231, -390)
ActionButton7:ClearAllPoints()
ActionButton7:SetPoint("BOTTOM",ActionButton1,"TOP",252,-36)
MultiBarBottomLeftButton1:ClearAllPoints()--左下动作条
MultiBarBottomLeftButton1:SetPoint("BOTTOM",ActionButton1,"TOP",0, 10)

ActionBarUpButton:Hide()-- 主动作栏上翻页箭头图标
ActionBarDownButton:Hide()-- 主动作栏上翻页箭头图标

CharacterMicroButton:ClearAllPoints()--系统菜单位置
CharacterMicroButton:SetPoint("CENTER", UIParent, "CENTER", 565, -400)

MainMenuBarBackpackButton:ClearAllPoints()--背包位置
MainMenuBarBackpackButton:SetScale(0.8)
CharacterBag0Slot:SetScale(0.8)
CharacterBag1Slot:SetScale(0.8)
CharacterBag2Slot:SetScale(0.8)
CharacterBag3Slot:SetScale(0.8)
MainMenuBarBackpackButton:SetPoint("CENTER", UIParent, "CENTER", 930, -470)

StanceButton1:ClearAllPoints()--姿态1
StanceButton1:SetPoint("BOTTOMLEFT",UIparent,"BOTTOMLEFT",635,135)
StanceBarFrame:SetScale(0.8)
StanceButton1.SetPoint = function() end

StanceButton2:ClearAllPoints()--姿态2
StanceButton2:SetPoint("BOTTOMLEFT",UIparent,"BOTTOMLEFT",730,135)
StanceBarFrame:SetScale(0.8)
StanceButton2.SetPoint = function() end

StanceButton3:ClearAllPoints()--姿态3
StanceButton3:SetPoint("BOTTOMLEFT",UIparent,"BOTTOMLEFT",1305,135)
StanceBarFrame:SetScale(0.8)
StanceButton3.SetPoint = function() end

StanceButton4:ClearAllPoints()--姿态4
StanceButton4:SetPoint("BOTTOMLEFT",UIparent,"BOTTOMLEFT",1339,135)
StanceBarFrame:SetScale(0.8)
StanceButton4.SetPoint = function() end

MainMenuExpBar:ClearAllPoints()--经验条位置
MainMenuExpBar:SetScale(0.8)
MainMenuExpBar:SetPoint("BOTTOM",ActionButton1,"TOP",286, -65)

ReputationWatchBar.StatusBar:ClearAllPoints()--声望条位置
ReputationWatchBar.StatusBar:SetScale(0.8)
ReputationWatchBar.StatusBar:SetPoint("BOTTOM",ActionButton1,"TOP",286, -65)

local function showhidebar(alpha)--经验条渐隐
    if MainMenuExpBar:IsShown() then
        MainMenuExpBar:SetAlpha(alpha)
    end
end
MainMenuExpBar:SetAlpha(0)
MainMenuExpBar:HookScript("OnEnter", function(self) showhidebar(1) end)
MainMenuExpBar:HookScript("OnLeave", function(self) showhidebar(0) end)


--隐藏
MainMenuBarLeftEndCap:Hide()--主动作栏左侧老鹰
MainMenuBarRightEndCap:Hide()--主动作栏右侧老鹰
MainMenuBarPageNumber:Hide()-- 主动作栏上下翻页数字
MainMenuBarTexture0:Hide()-- 主动作栏背景边框
MainMenuBarTexture1:Hide()-- 主动作栏背景边框
MainMenuBarTexture2:Hide()-- 主动作栏背景边框
MainMenuBarTexture3:Hide()-- 主动作栏背景边框
MainMenuBarPerformanceBarFrame:Hide()-- 微型菜单右下绿色延迟线
ActionBarUpButton:Hide()-- 主动作栏上翻页箭头图标
ActionBarDownButton:Hide()-- 主动作栏上翻页箭头图标