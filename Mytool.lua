hooksecurefunc("GameTooltip_SetDefaultAnchor", function (t,p)t:SetOwner(p, "ANCHOR_CURSOR_RIGHT", 40, -120)end)--鼠标提示信息跟随鼠标锚点
function GameTooltip_UnitColor(unit)-- 鼠标提示名字染色
	local r, g, b
	local reaction = UnitReaction(unit, "player")
	if reaction then
		r = FACTION_BAR_COLORS[reaction].r
		g = FACTION_BAR_COLORS[reaction].g
		b = FACTION_BAR_COLORS[reaction].b
	else
		r = 1.0
		g = 1.0
		b = 1.0
	end

	if UnitIsPlayer(unit) then
		local class = select(2, UnitClass(unit))
		r = RAID_CLASS_COLORS[class].r
		g = RAID_CLASS_COLORS[class].g
		b = RAID_CLASS_COLORS[class].b
	end
	return r, g, b
end
