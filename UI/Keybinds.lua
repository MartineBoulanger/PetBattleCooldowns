local _, PBC = ...

local Keybinds = PBC.UI.Keybinds

local bindingFrame = CreateFrame("Frame")

bindingFrame:SetScript("OnShow", function(self)
  SetOverrideBindingClick(
    self, true, "6", "PBCForfeitBindingButton"
  )
  local hotKey = PetBattleFrame.BottomFrame.ForfeitButton.HotKey
  hotKey:SetText("6")
  hotKey:Show()

  SetOverrideBindingClick(
    self, true, "7", "PBCPassBindingButton"
  )
  local passHotKey = PetBattleFrame.BottomFrame.TurnTimer.SkipButton:CreateFontString(
    nil, "OVERLAY", "NumberFontNormalSmallGray"
  )

  passHotKey:SetPoint("TOPRIGHT", -1, -3)
  passHotKey:SetText("7")
end)

bindingFrame:SetScript("OnHide", function(self)
  ClearOverrideBindings(self)
end)

local forfeitButton = CreateFrame(
  "Button", "PBCForfeitBindingButton", UIParent
)

forfeitButton:SetScript("OnClick", function()
  PetBattleFrame.BottomFrame.ForfeitButton:Click()
end)

local passButton = CreateFrame(
  "Button", "PBCPassBindingButton", UIParent
)

passButton:SetScript("OnClick", function()
  PetBattleFrame.BottomFrame.TurnTimer.SkipButton:Click()
end)

bindingFrame:SetParent(PetBattleFrame)
