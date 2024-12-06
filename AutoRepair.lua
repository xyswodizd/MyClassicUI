local AutoRepair = true
local g = CreateFrame("Frame")
g:RegisterEvent("MERCHANT_SHOW")
g:SetScript("OnEvent", function()
    if (AutoRepair == true and CanMerchantRepair()) then
        local cost = GetRepairAllCost()
        if cost > 0 then
            local money = GetMoney()
            if IsInGuild() then
                local guildMoney = GetGuildBankWithdrawMoney()
                if guildMoney > GetGuildBankMoney() then
                    guildMoney = GetGuildBankMoney()
                end
                if guildMoney > cost and CanGuildBankRepair() then
                    RepairAllItems(1)
                    -- 使用GetMoneyString函数将修理费用转换为图标形式的金币、银币、铜币
                    local moneyString = GetMoneyString(cost)
                    print(string.format("|cfff07100工会修理花费: %s|r", moneyString))
                    return
                end
            end
            if money > cost then
                RepairAllItems()
                -- 使用GetMoneyString函数将修理费用转换为图标形式的金币、银币、铜币
                local moneyString = GetMoneyString(cost)
                print(string.format("|cffead000本次修理花费: %s|r", moneyString))
            else
                print("Go farm newbie.")
            end
        end
    end
end)