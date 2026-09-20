local _, PBC = ...

local AbilityButton = PBC.UI.AbilityButton
local AuraFrame = PBC.UI.AuraFrame

local eventHandlers = {}

local function setIconsDisabled(button)
  button.Icon:SetVertexColor(0.5, 0.5, 0.5)
  button.Icon:SetDesaturated(true)

  button.Icon2:SetVertexColor(0.5, 0.5, 0.5)
  button.Icon2:SetDesaturated(true)
end

local function setIconsEnabled(button)
  button.Icon:SetVertexColor(1, 1, 1)
  button.Icon:SetDesaturated(false)

  button.Icon2:SetVertexColor(1, 1, 1)
  button.Icon2:SetDesaturated(false)
end

function AbilityButton.UpdateState(button)
  local petFrame = button:GetParent():GetParent()

  local health = C_PetBattles.GetHealth(
    petFrame.playerIndex,
    petFrame.petIndex
  )

  local _, currentCooldown, currentLockdown =
      C_PetBattles.GetAbilityState(
        petFrame.playerIndex,
        petFrame.petIndex,
        button.abilityIndex
      )

  local cooldown = math.max(
    currentCooldown or 0,
    currentLockdown or 0
  )

  if not button.abilityID then
    -- Pet is too low level to use this ability slot.
    setIconsDisabled(button)

    button:Disable()
    button.Lock:Show()
    button.CooldownShadow:Show()
    button.Cooldown:Hide()
    button.BetterIcon:Hide()
  elseif health <= 0 then
    -- Pet is dead.
    setIconsDisabled(button)

    button:Disable()
    button.Lock:Hide()
    button.CooldownShadow:Hide()
    button.Cooldown:Hide()
  elseif cooldown > 0 then
    -- Ability is on cooldown.
    setIconsDisabled(button)

    button:Disable()
    button.Lock:Hide()
    button.CooldownShadow:Show()
    button.Cooldown:SetText(cooldown)
    button.Cooldown:Show()
  else
    -- Ability is available.
    setIconsEnabled(button)

    button:Enable()
    button.Lock:Hide()
    button.CooldownShadow:Hide()
    button.Cooldown:Hide()
    button.CooldownFlashAnim:Play()
  end
end

function AbilityButton.UpdateBetterIcon(button)
  button.BetterIcon:Hide()
  button.BetterIcon2:Hide()

  local petFrame = button:GetParent():GetParent()

  local opposingTeam = Enum.BattlePetOwner.Ally
      + Enum.BattlePetOwner.Enemy - petFrame.playerIndex

  local opposingPetIndex = C_PetBattles.GetActivePet(opposingTeam)

  local opposingType =
      C_PetBattles.GetPetType(opposingTeam, opposingPetIndex)

  local abilityIDs = { button.abilityID, button.abilityID2 }
  local icons = { button.BetterIcon, button.BetterIcon2 }

  for index, abilityID in ipairs(abilityIDs) do
    if not abilityID then
      return
    end

    local icon = icons[index]

    local _, _, _, _, _, _, attackPetType, noStrongWeakHints =
        C_PetBattles.GetAbilityInfoByID(abilityID)

    if not attackPetType then
      return
    end

    local modifier =
        C_PetBattles.GetAttackModifier(attackPetType, opposingType)

    if noStrongWeakHints or modifier == 1 then
      icon:Hide()
    elseif modifier > 1 then
      icon:SetTexture(
        "Interface\\PetBattles\\BattleBar-AbilityBadge-Strong"
      )
      icon:Show()
    elseif modifier < 1 then
      icon:SetTexture(
        "Interface\\PetBattles\\BattleBar-AbilityBadge-Weak"
      )
      icon:Show()
    end
  end
end

function AbilityButton.UpdateIcons(button)
  -- If this slot has no currently available ability, find its
  -- Pet Journal ability so we can still display the locked icon.
  if not button.abilityID then
    local petFrame = button:GetParent():GetParent()

    local speciesID = C_PetBattles.GetPetSpeciesID(
      petFrame.playerIndex, petFrame.petIndex
    )

    local abilityIDs = {}
    local abilityLevels = {}

    C_PetJournal.GetPetAbilityList(
      speciesID, abilityIDs, abilityLevels
    )

    local abilityID = abilityIDs[button.abilityIndex]

    if not abilityID then
      button.Icon:SetTexture("Interface\\Icons\\INV_Misc_Key_05")
      button:Hide()
    else
      local _, icon =
          C_PetJournal.GetPetAbilityInfo(abilityID)

      button.Icon:SetTexture(icon)
      button.Lock:Show()
      button:Show()
    end

    button.Icon:SetVertexColor(1, 1, 1)
    button:Disable()

    return
  end

  -- First possible ability.
  local _, _, icon =
      C_PetBattles.GetAbilityInfoByID(button.abilityID)

  if not icon then
    icon = "Interface\\Icons\\INV_Misc_QuestionMark"
  end

  button.Icon:SetTexture(icon)
  button.Lock:Hide()
  button:Enable()
  button:Show()

  -- In PvP a slot may initially contain two possible abilities.
  if button.abilityID2 then
    local _, _, secondIcon =
        C_PetBattles.GetAbilityInfoByID(button.abilityID2)

    if not secondIcon then
      secondIcon = "Interface\\Icons\\INV_Misc_QuestionMark"
    end

    button.Icon2:SetTexture(secondIcon)
    button.Icon2:Show()

    button.topHalfBorder:Show()
    button.bottomHalfBorder:Show()
  else
    button.Icon2:Hide()

    button.topHalfBorder:Hide()
    button.bottomHalfBorder:Hide()
  end

  AbilityButton.UpdateBetterIcon(button)
end

function AbilityButton.UpdateAbilityID(button)
  local petFrame = button:GetParent():GetParent()

  if not (petFrame.playerIndex
        and petFrame.petIndex and button.abilityIndex
      ) then
    return
  end

  local teams = PBC.Teams.Ensure()

  local petData =
      teams[petFrame.playerIndex][petFrame.petIndex]

  if not petData then
    return
  end

  local abilityList = petData[button.abilityIndex]

  button.abilityID = abilityList[1]
  button.abilityID2 = abilityList[2]

  AbilityButton.UpdateIcons(button)
  AbilityButton.UpdateState(button)
end

function AbilityButton.UpdateAura(button)
  local auraInfo = button.auraInfo

  if not auraInfo then
    button.Duration:SetText("")
    button.AuraBorder:Hide()
    return
  end

  if auraInfo.duration < 0 then
    button.Duration:SetText("")
  else
    button.Duration:SetText(auraInfo.duration)
  end

  if auraInfo.isBuff then
    button.AuraBorder:SetVertexColor(0, 0.8, 0, 1)
  else
    button.AuraBorder:SetVertexColor(1, 0, 0, 1)
  end

  button.AuraBorder:Show()
end

function AbilityButton.OnEnter(button)
  local petFrame = button:GetParent():GetParent()

  if not button.abilityID then
    PetBattlePrimaryAbilityTooltip:Hide()
    return
  end

  local bonusString = AuraFrame.GetFormattedDuration(button.auraInfo)

  PetBattleAbilityTooltip_SetAbilityByID(
    petFrame.playerIndex, petFrame.petIndex, button.abilityID, bonusString
  )

  if petFrame.playerIndex == Enum.BattlePetOwner.Ally then
    PetBattleAbilityTooltip_Show(
      "TOPLEFT",
      button,
      "BOTTOMRIGHT",
      0,
      0
    )
  else
    PetBattleAbilityTooltip_Show(
      "TOPRIGHT",
      button,
      "BOTTOMLEFT",
      0,
      0
    )
  end
end

function AbilityButton.OnTopHalfEnter(topHalf)
  local button = topHalf:GetParent()
  local petFrame = button:GetParent():GetParent()

  if not button.abilityID2 then
    AbilityButton.OnEnter(button)
    return
  end

  local bonusString = AuraFrame.GetFormattedDuration(button.auraInfo)

  PetBattleAbilityTooltip_SetAbilityByID(
    petFrame.playerIndex, petFrame.petIndex, button.abilityID2, bonusString
  )

  if petFrame.playerIndex == Enum.BattlePetOwner.Ally then
    PetBattleAbilityTooltip_Show(
      "TOPLEFT",
      topHalf,
      "BOTTOMRIGHT",
      0,
      0
    )
  else
    PetBattleAbilityTooltip_Show(
      "TOPRIGHT",
      topHalf,
      "BOTTOMLEFT",
      0,
      0
    )
  end
end

function AbilityButton.OnLeave()
  PetBattlePrimaryAbilityTooltip:Hide()
end

function AbilityButton.OnRoundPlaybackComplete(button)
  button.SelectedHighlight:Hide()

  -- The enemy pet type can change without a pet swap.
  AbilityButton.UpdateBetterIcon(button)
  AbilityButton.UpdateState(button)
end

eventHandlers["PET_BATTLE_PET_CHANGED"] = AbilityButton.UpdateBetterIcon
eventHandlers["PET_BATTLE_PET_ROUND_PLAYBACK_COMPLETE"] = AbilityButton.OnRoundPlaybackComplete

function AbilityButton.OnLoad(button)
  PBC.Events.RegisterAll(button, eventHandlers)
end

AbilityButton.OnEvent = PBC.Events.CreateHandler(eventHandlers)

function AbilityButton.OnActionProcessed(playerIndex, abilityIndex, abilityChanged)
  if not abilityIndex then
    return
  end

  local abilityGroup

  if playerIndex == Enum.BattlePetOwner.Ally then
    abilityGroup = DeePetBattleFrame.Ally1.Abilities
  else
    abilityGroup = DeePetBattleFrame.Enemy1.Abilities
  end

  local button = abilityGroup["Button" .. abilityIndex]

  button.SelectedHighlight:Show()

  if abilityChanged then
    AbilityButton.UpdateAbilityID(button)
  end
end

PBC.Battle.Actions.SetActionProcessedCallback(AbilityButton.OnActionProcessed)
