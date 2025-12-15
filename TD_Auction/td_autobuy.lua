SLASH_TD_AUCTION1 = "/tdah"

SlashCmdList["TD_AUCTION"] = function(msg)
    print(msg);
	if (msg == "buy") then
        print("buy");
    end
end

local tdAhFrame = CreateFrame("Frame", "TD_AH_FRAME")

tdAhFrame:SetScript("OnEvent", function(self, event, ...)
end)

tdAhFrame:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
