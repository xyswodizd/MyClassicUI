-----------------------头像坐标及缩放-----------------------
local pFrameX = -255-- 玩家头像的X坐标
local pFrameY = -120-- 玩家头像的Y坐标
local tFrameX = 255-- 目标头像的X坐标
local tFrameY = -120-- 目标头像的Y坐标
local frameScale = 1-- 玩家/目标/队友头像的缩放比例
local function newPosition()
  PlayerFrame:ClearAllPoints()
  PlayerFrame:SetPoint("CENTER", pFrameX, pFrameY)
  PlayerFrame:SetUserPlaced(true)
  PlayerFrame:SetScale(frameScale)

  TargetFrame:ClearAllPoints()
  TargetFrame:SetPoint("CENTER", tFrameX, tFrameY)
  TargetFrame:SetUserPlaced(true)
  TargetFrame:SetScale(frameScale)
end
local iLayout = CreateFrame("Frame")
iLayout:RegisterEvent("PLAYER_ENTERING_WORLD")
iLayout:SetScript("OnEvent", function(self, event, ...)
  if event == "PLAYER_ENTERING_WORLD" and not InCombatLockdown() then
    newPosition()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
  end
end)
CastingBarFrame:ClearAllPoints()
CastingBarFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
---------------------------------------------------------------------
-----------------------其余头像功能调整-----------------------
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event)
	PlayerName:SetPoint("CENTER", PlayerFrameHealthBar, "CENTER", 0, 24)---玩家头像名字位置
	PlayerFrameHealthBarTextLeft:SetPoint("left", PlayerFrameHealthBar, "left", 4, -3)---在生命值和百分比同时显示时，玩家生命值百分比位置
	PlayerFrameHealthBarTextRight:SetPoint("Right", PlayerFrameHealthBar, "Right", -1, -3)---在生命值和百分比同时显示时，玩家生命值位置
	TargetFrameTextureFrameName:SetPoint("CENTER", TargetFrameHealthBar, "CENTER", 0, 25)---目标头像名字位置
	TargetFrameHealthBarTextLeft:SetPoint("left", TargetFrameHealthBar, "left", 1, -1)---在生命值和百分比同时显示时，目标生命值百分比位置
	TargetFrameHealthBarTextRight:SetPoint("Right", TargetFrameHealthBar, "Right", -5, -1)---在生命值和百分比同时显示时，目标生命值位置
	TargetFrame.deadText:SetPoint("CENTER", TargetFrameHealthBar, "CENTER", 0, 0)---目标死亡文字显示位置
end)
PlayerLevelText:ClearAllPoints()---玩家等级文字位置
PlayerLevelText:SetPoint("left", PlayerFrameHealthBar, "left", -61, -30)
TargetFrameTextureFrameLevelText:ClearAllPoints()---目标等级文字位置
TargetFrameTextureFrameLevelText:SetPoint("top", TargetFrameHealthBar, "Right", 53, -23)
PlayerFrame:UnregisterEvent("UNIT_COMBAT")-- 隐藏玩家头像伤害治疗数字
PetFrame:UnregisterEvent("UNIT_COMBAT")--隐藏宠物头像伤害治疗数字
TargetFrameToT:ClearAllPoints()--清除锚点
TargetFrameToT:SetScale(1.2)--目标的目标缩放
TargetFrameToT:SetPoint("BOTTOMRIGHT", TargetFrame, "BOTTOMRIGHT", -17, -25)--目标的目标位置