local _, PBC = ...

local AbilityGroup = PBC.UI.AbilityGroup
local AbilityButton = PBC.UI.AbilityButton

function AbilityGroup.OnLoad(group)
  local buttons = { group.Button1, group.Button2, group.Button3 }

  for index, button in ipairs(buttons) do
    button.abilityIndex = index
  end
end

function AbilityGroup.UpdatePetIndex(group)
  -- Maps ability names to their corresponding buttons.
  group.nameTable = {}

  local buttons = {
    group.Button1, group.Button2, group.Button3,
  }

  for _, button in ipairs(buttons) do
    AbilityButton.UpdateAbilityID(button)

    local abilityIDs = { button.abilityID, button.abilityID2 }

    for _, abilityID in pairs(abilityIDs) do
      if abilityID then
        local _, name =
            C_PetBattles.GetAbilityInfoByID(abilityID)

        if name then
          group.nameTable[name] = button
        end
      end
    end
  end
end

function AbilityGroup.UpdateAuras(group, auraTable)
  -- Clear the aura information currently assigned to the buttons.
  for _, button in ipairs({ group.Button1, group.Button2, group.Button3 }) do
    button.auraInfo = nil
  end

  -- Match ability-related auras to their corresponding ability button.
  for _, auraInfo in pairs(auraTable) do
    local button = group.nameTable[auraInfo.name]

    if button then
      button.auraInfo = auraInfo
      auraInfo.isButtonAura = true
    end
  end

  -- Update the visual aura state of every ability button.
  for _, button in ipairs({ group.Button1, group.Button2, group.Button3 }) do
    AbilityButton.UpdateAura(button)
  end
end
