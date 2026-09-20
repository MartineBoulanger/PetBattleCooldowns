local _, PBC = ...

local ElvUISkin = PBC.ElvUI

local function skinAbilityButton(button)
  if not button then
    return
  end

  button.NormalTexture:SetTexture(nil)

  button:CreateBackdrop("Default")

  button.backdrop:ClearAllPoints()
  button.backdrop:SetPoint(
    "TOPLEFT", button.Icon, "TOPLEFT", -1, 1
  )
  button.backdrop:SetPoint(
    "BOTTOMRIGHT", button.Icon, "BOTTOMRIGHT", 1, -1
  )
end

local function positionBacklineAbilities(petFrame, petIcon)
  petFrame:ClearAllPoints()
  petFrame:SetPoint("TOP", petIcon, "BOTTOM", 0, -10)

  local abilities = petFrame.Abilities

  abilities.Button1:ClearAllPoints()
  abilities.Button1:SetPoint("TOP", abilities, "TOP", 0, 0)

  abilities.Button2:ClearAllPoints()
  abilities.Button2:SetPoint("TOP", abilities.Button1, "BOTTOM", 0, -2)

  abilities.Button3:ClearAllPoints()
  abilities.Button3:SetPoint("TOP", abilities.Button2, "BOTTOM", 0, -2)
end

local function positionBacklineAuras(petFrame)
  local auras = petFrame.Auras

  if not auras then
    return
  end

  local firstAura = auras.NextFrame

  if not firstAura then
    return
  end

  firstAura:ClearAllPoints()
  firstAura:SetPoint(
    "TOP", petFrame.Abilities.Button3, "BOTTOM", 0, -5
  )

  petFrame.growsVertically = true
end

local function offsetBuffFrame(buffFrame, xOffset, yOffset)
  local point, relativeTo, relativePoint, x, y =
      buffFrame:GetPoint(1)

  if not point then
    return
  end

  buffFrame:ClearAllPoints()
  buffFrame:SetPoint(
    point,
    relativeTo,
    relativePoint,
    x + xOffset,
    y + yOffset
  )
end

local function offsetStats()
  local stats = PBC.UI.Stats.GetFrames()

  local groups = {
    stats.ally,
    stats.enemy,
  }

  for _, group in ipairs(groups) do
    local healthIcon = group.healthIcon

    if healthIcon then
      local point, relativeTo, relativePoint, x, y =
          healthIcon:GetPoint(1)

      healthIcon:ClearAllPoints()
      healthIcon:SetPoint(
        point,
        relativeTo,
        relativePoint,
        x,
        y - 6
      )
    end
  end
end

function ElvUISkin.Initialize()
  if not PBCDB.useElvUISkin then
    return
  end

  if not C_AddOns.IsAddOnLoaded("ElvUI") then
    return
  end

  local E = unpack(ElvUI)

  if not E then
    return
  end

  local S = E:GetModule("Skins")

  if not S then
    return
  end

  local petFrames = {
    DeePetBattleFrame.Ally1,
    DeePetBattleFrame.Ally2,
    DeePetBattleFrame.Ally3,
    DeePetBattleFrame.Enemy1,
    DeePetBattleFrame.Enemy2,
    DeePetBattleFrame.Enemy3,
  }

  for _, petFrame in ipairs(petFrames) do
    local abilities = petFrame.Abilities

    skinAbilityButton(abilities.Button1)
    skinAbilityButton(abilities.Button2)
    skinAbilityButton(abilities.Button3)
  end

  positionBacklineAbilities(
    DeePetBattleFrame.Ally2,
    PetBattleFrame.Ally2.Icon
  )

  positionBacklineAbilities(
    DeePetBattleFrame.Ally3,
    PetBattleFrame.Ally3.Icon
  )

  positionBacklineAbilities(
    DeePetBattleFrame.Enemy2,
    PetBattleFrame.Enemy2.Icon
  )

  positionBacklineAbilities(
    DeePetBattleFrame.Enemy3,
    PetBattleFrame.Enemy3.Icon
  )

  positionBacklineAuras(DeePetBattleFrame.Ally2)
  positionBacklineAuras(DeePetBattleFrame.Ally3)
  positionBacklineAuras(DeePetBattleFrame.Enemy2)
  positionBacklineAuras(DeePetBattleFrame.Enemy3)

  offsetBuffFrame(
    PetBattleFrame.AllyBuffFrame, 30, 0
  )

  offsetBuffFrame(
    PetBattleFrame.EnemyBuffFrame, -30, 0
  )

  PBC.UI.HealthTicks.Hide()
  offsetStats()
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")

frame:SetScript("OnEvent", function()
  ElvUISkin.Initialize()
end)
