local _, PBC = ...

local AuraFrame = PBC.UI.AuraFrame

function AuraFrame.Update(frame, auraInfo)
  -- Store the aura information for the tooltip.
  frame.auraInfo = auraInfo

  if auraInfo.isBuff then
    frame.DebuffBorder:Hide()
  else
    frame.DebuffBorder:Show()
  end

  frame.Icon:SetTexture(auraInfo.icon)

  if auraInfo.duration < 0 then
    frame.Duration:SetText("")
  else
    frame.Duration:SetText(auraInfo.duration)
  end

  frame:Show()
end

function AuraFrame.GetFormattedDuration(auraInfo)
  if not auraInfo or auraInfo.duration < 0 then
    return ""
  end

  local colorPrefix

  if auraInfo.isBuff then
    colorPrefix = "|cFF00DD00"
  else
    colorPrefix = "|cFFFF0000"
  end

  local roundsString

  if auraInfo.duration == 1 then
    roundsString = " Round"
  else
    roundsString = " Rounds"
  end

  return colorPrefix .. auraInfo.duration
      .. roundsString .. " Remaining|h"
end

function AuraFrame.OnEnter(frame)
  local petFrame = frame:GetParent():GetParent()
  local auraInfo = frame.auraInfo

  if not auraInfo then
    PetBattlePrimaryAbilityTooltip:Hide()
    return
  end

  local bonusString = AuraFrame.GetFormattedDuration(auraInfo)

  PetBattleAbilityTooltip_SetAbilityByID(
    auraInfo.playerIndex, auraInfo.petIndex, auraInfo.id, bonusString
  )

  if petFrame.playerIndex == Enum.BattlePetOwner.Ally then
    PetBattleAbilityTooltip_Show(
      "TOPLEFT",
      frame,
      "BOTTOMRIGHT",
      0,
      0
    )
  else
    PetBattleAbilityTooltip_Show(
      "TOPRIGHT",
      frame,
      "BOTTOMLEFT",
      0,
      0
    )
  end
end

function AuraFrame.OnLeave()
  PetBattlePrimaryAbilityTooltip:Hide()
end
