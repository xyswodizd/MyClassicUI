-- 创建一个框架来监听事件
local frame = CreateFrame("Frame")

-- 用于累计所有灰色物品的总出售价格（以铜币为单位）
local totalPrice = 0

-- 定义一个函数来检查并出售灰色物品
local function SellGreyItems()
    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local itemID = C_Container.GetContainerItemID(bag, slot)
            if itemID then
                local _, _, quality = C_Item.GetItemInfo(itemID)
                if quality and quality == 0 then -- 灰色物品的质量等级是0
                    local itemLink = C_Container.GetContainerItemLink(bag, slot)
                    if itemLink then
                        -- 获取物品实际数量
                        local itemInfo = C_Container.GetContainerItemInfo(bag, slot)
                        local itemStackCount = itemInfo.stackCount
                        local _, _, _, _, _, _, _, _, _, _, sellPrice = GetItemInfo(itemLink)
                        if sellPrice then
                            -- 计算该灰色物品的总出售价格
                            local itemTotalSellPrice = sellPrice * itemStackCount
                            C_Container.UseContainerItem(bag, slot) -- 使用物品（实际上是卖给NPC）
                            -- 累计该灰色物品的总出售价格到全局总价格变量中
                            totalPrice = totalPrice + itemTotalSellPrice
                        end
                    end
                end
            end
        end
    end
end

-- 监听商人界面打开事件
frame:RegisterEvent("MERCHANT_SHOW")
frame:SetScript("OnEvent", function()
    -- 在每次商人界面打开时，先重置总价格为0，避免重复累加
    totalPrice = 0
    SellGreyItems()
    -- 只有当总价格大于0，也就是有物品出售时，才进行打印输出
    if totalPrice > 0 then
        -- 使用GetMoneyString函数将总价格转换为图标形式的金币、银币、铜币
        local moneyString = GetMoneyString(totalPrice)
        print(string.format("|cffead000本次出售获得: %s|r", moneyString))
    end
end)