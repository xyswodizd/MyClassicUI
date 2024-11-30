local Step=BUFF_BUTTON_HEIGHT+5
hooksecurefunc("BuffFrame_Update",function()
    local offset=(DEBUFF_ACTUAL_DISPLAY-1)*Step/2
    for i=1,DEBUFF_ACTUAL_DISPLAY do
        local debuff=_G["DebuffButton"..i]
        if debuff and debuff:IsShown() then--   Sanity check
            debuff:ClearAllPoints()
            debuff:SetPoint("Right",PlayerFrameHealthBar,"Right",(i-1)*Step-offset,65)
        end
    end
end)