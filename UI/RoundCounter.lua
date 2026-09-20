local _, PBC = ...

local RoundCounter = PBC.UI.RoundCounter

local currentRound = 0

local roundLabel
local originalFont
local originalFontSize
local originalFontFlags
local originalPoint
local originalRelativeTo
local originalRelativePoint
local originalX
local originalY

local function ensureRoundLabel()
  if roundLabel or not PetBattleFrame then
    return
  end

  roundLabel = PetBattleFrame:CreateFontString(
    nil, "OVERLAY", "GameFontNormal"
  )

  local font, _, flags = roundLabel:GetFont()

  roundLabel:SetFont(font, 14, flags)
  roundLabel:SetText("Round")
  roundLabel:SetPoint(
    "BOTTOM", PetBattleFrame.TopVersusText, "TOP", -1, 1
  )
end

function RoundCounter.Reset()
  currentRound = 0

  if roundLabel then
    roundLabel:Hide()
  end

  if PetBattleFrame and PetBattleFrame.TopVersusText then
    if originalFont then
      PetBattleFrame.TopVersusText:SetFont(
        originalFont, originalFontSize, originalFontFlags
      )
    end

    PetBattleFrame.TopVersusText:SetText("VS")
  end
end

function RoundCounter.NextRound()
  currentRound = currentRound + 1
end

function RoundCounter.OnRoundResults()
  RoundCounter.NextRound()

  if not PetBattleFrame or not PetBattleFrame.TopVersusText then
    return
  end

  if not originalFont then
    originalFont, originalFontSize, originalFontFlags =
        PetBattleFrame.TopVersusText:GetFont()

    originalPoint, originalRelativeTo, originalRelativePoint,
    originalX, originalY = PetBattleFrame.TopVersusText:GetPoint()
  end

  if PBCDB.roundDisplay == "VS" then
    if roundLabel then
      roundLabel:Hide()
    end

    PetBattleFrame.TopVersusText:SetFont(
      originalFont, originalFontSize, originalFontFlags
    )

    PetBattleFrame.TopVersusText:ClearAllPoints()
    PetBattleFrame.TopVersusText:SetPoint(
      originalPoint, originalRelativeTo, originalRelativePoint,
      originalX, originalY
    )

    PetBattleFrame.TopVersusText:SetText("VS")

    return
  end

  ensureRoundLabel()

  if roundLabel then
    roundLabel:Show()
  end

  PetBattleFrame.TopVersusText:SetFont(
    originalFont, 24, originalFontFlags
  )

  PetBattleFrame.TopVersusText:SetText(currentRound)
  PetBattleFrame.TopVersusText:ClearAllPoints()

  if PBCDB.useElvUISkin
      and C_AddOns.IsAddOnLoaded("ElvUI")
  then
    PetBattleFrame.TopVersusText:SetPoint(
      "CENTER", PetBattleFrame, "TOP", 2, -60
    )
  else
    PetBattleFrame.TopVersusText:SetPoint(
      "CENTER", PetBattleFrame, "TOP", -1, -30
    )
  end
end

function RoundCounter.GetCurrentRound()
  return currentRound
end
