local button = QuestFrameVendorButton or CreateFrame('Button', "QuestFrameVendorButton", QuestFrameRewardPanel, 'UIPanelButtonTemplate')

button:SetText(MERCHANT)
button:SetWidth(120)
button:SetHeight(22)
button:ClearAllPoints()
button:SetPoint('LEFT', QuestFrameCompleteQuestButton, 'RIGHT', 1, 0)

button:SetScript('OnClick', function()
      local bestv = 0
      for i = 1, GetNumQuestChoices() do
         local newv = select(11, GetItemInfo(GetQuestItemLink('choice', i)))
         if newv > bestv then
            bestv = newv
            -- simulate user selection in case they change the inner workings
            _G['QuestInfoItem'..i]:Click()
         end
      end
      -- dont call GetQuestReward(i) direct incase there are no rewards (free error checking)
      QuestRewardCompleteButton_OnClick()
end)

button:RegisterEvent('QUEST_COMPLETE')
button:SetScript('OnEvent', function(self, event, ...)
      if GetNumQuestChoices() == 0 then
         self:Hide()
      else
         self:Show()
      end
end)
