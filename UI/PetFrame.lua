local _, PBC = ...

local PetFrame = PBC.UI.PetFrame
local AbilityGroup = PBC.UI.AbilityGroup
local AuraFrame = PBC.UI.AuraFrame
local Auras = PBC.Battle.Auras

local eventHandlers = {}

function PetFrame.OnLoad(frame, playerIndex, frameIndex)
  -- Remember which pet frame this is.
  frame.playerIndex = playerIndex
  frame.frameIndex = frameIndex

  local groupFrame = frame.Abilities

  if frame.Auras == nil then
    -- Active pets have larger cooldowns and no separate aura frames.
    groupFrame:SetScale(0.7)

    for _, button in pairs({
      groupFrame.Button1, groupFrame.Button2, groupFrame.Button3,
    }) do
      button.Duration:SetPoint(
        "TOP",
        button,
        "BOTTOM",
        0,
        -10
      )
    end
  else
    -- Benched pets have smaller cooldowns and separate aura frames.
    frame:SetWidth(99)

    groupFrame:SetScale(0.6)
    frame.Auras:SetScale(0.7)

    local auraFrame = frame.Auras.NextFrame

    frame.auraWidth = auraFrame:GetWidth()
    frame.totalAuraWidth = frame.auraWidth
    frame.growsFromDirection = auraFrame:GetPoint(1)

    if frame.growsFromDirection == "LEFT" then
      frame.growsToDirection = "RIGHT"
    else
      frame.growsToDirection = "LEFT"
    end
  end

  -- Keep this frame in sync with the visibility of its anchor.
  local _, anchorFrame = frame:GetPoint(1)

  if anchorFrame then
    anchorFrame:HookScript(
      "OnShow",
      function()
        frame:Show()
      end
    )

    anchorFrame:HookScript(
      "OnHide",
      function()
        frame:Hide()
      end
    )

    if not anchorFrame:IsShown() then
      frame:Hide()
    end
  end

  PBC.Events.RegisterAll(frame, eventHandlers)
end

function PetFrame.UpdateAuras(frame)
  local auraTable =
      Auras.GetPetAuras(frame.playerIndex, frame.petIndex)

  -- Let the ability buttons display their matching auras first.
  AbilityGroup.UpdateAuras(frame.Abilities, auraTable)

  -- Active pet frames do not have separate aura frames.
  if not frame.Auras then
    return
  end

  -- Display all remaining auras that were not assigned
  -- to an ability button.
  local prevAuraFrame = frame.Auras

  for _, auraInfo in ipairs(auraTable) do
    if not auraInfo.isButtonAura then
      local auraFrame = prevAuraFrame.NextFrame

      -- Create another aura frame if necessary and if there
      -- is enough room to display at least part of it.
      if auraFrame == nil and frame.totalAuraWidth
          + PBC.Constants.AURA_FRAME_DISTANCE
          < frame.Auras:GetWidth() then
        auraFrame = CreateFrame(
          "Frame",
          nil,
          frame.Auras,
          "DeePetBattleAuraTemplate"
        )

        if frame.growsVertically then
          auraFrame:SetPoint(
            "TOP", prevAuraFrame, "BOTTOM", 0, -2
          )
        else
          auraFrame:SetPoint(
            frame.growsFromDirection,
            prevAuraFrame,
            frame.growsToDirection
          )
        end

        frame.totalAuraWidth = frame.totalAuraWidth
            + PBC.Constants.AURA_FRAME_DISTANCE + frame.auraWidth

        prevAuraFrame.NextFrame = auraFrame
      end

      if not auraFrame then
        return
      end

      AuraFrame.Update(auraFrame, auraInfo)
      prevAuraFrame = auraFrame
    end
  end

  -- Hide existing aura frames that were not needed this time.
  while prevAuraFrame do
    local auraFrame = prevAuraFrame.NextFrame

    if auraFrame then
      auraFrame:Hide()
    end

    prevAuraFrame = auraFrame
  end
end

function PetFrame.UpdatePetIndex(frame)
  local activePetIndex =
      C_PetBattles.GetActivePet(frame.playerIndex)

  -- No need to update outside of a pet battle.
  if not activePetIndex then
    return
  end

  local frameIndex = frame.frameIndex
  local petIndex

  -- Frame 1 always watches the active pet.
  if frameIndex == 1 then
    petIndex = activePetIndex

    -- Track our own index if the active pet comes before us.
  elseif activePetIndex < frameIndex then
    petIndex = frameIndex

    -- Otherwise track one pet above us.
  else
    petIndex = frameIndex - 1
  end

  -- Only update the children when this frame starts
  -- watching a different pet.
  if petIndex ~= frame.petIndex then
    frame.petIndex = petIndex

    AbilityGroup.UpdatePetIndex(frame.Abilities)
    PetFrame.UpdateAuras(frame)
  end
end

function PetFrame.OnBattleClose(frame)
  frame.petIndex = nil
end

function PetFrame.OnPetChanged(frame, playerIndex)
  if frame.playerIndex ~= playerIndex then
    return
  end

  PetFrame.UpdatePetIndex(frame)
end

function PetFrame.OnAuraChanged(frame, playerIndex, petIndex)
  if frame.playerIndex ~= playerIndex
      or frame.petIndex ~= petIndex then
    return
  end

  PetFrame.UpdateAuras(frame)
end

function PetFrame.OnHealthChanged(frame, playerIndex, petIndex, amount)
  if frame.playerIndex ~= playerIndex
      or frame.petIndex ~= petIndex then
    return
  end

  local health =
      C_PetBattles.GetHealth(playerIndex, petIndex)

  -- Refresh auras when the pet dies or is resurrected.
  local died = amount < 0 and health == 0
  local resurrected = amount > 0 and health == amount

  if died or resurrected then
    PetFrame.UpdateAuras(frame)
  end
end

eventHandlers["PET_BATTLE_CLOSE"] = PetFrame.OnBattleClose
eventHandlers["PET_BATTLE_PET_CHANGED"] = PetFrame.OnPetChanged
eventHandlers["PET_BATTLE_AURA_APPLIED"] = PetFrame.OnAuraChanged
eventHandlers["PET_BATTLE_AURA_CANCELED"] = PetFrame.OnAuraChanged
eventHandlers["PET_BATTLE_AURA_CHANGED"] = PetFrame.OnAuraChanged
eventHandlers["PET_BATTLE_HEALTH_CHANGED"] = PetFrame.OnHealthChanged

PetFrame.OnEvent = PBC.Events.CreateHandler(eventHandlers)
