local _, PBC = ...

local Teams = PBC.Teams

local teams

-- Reusable tables used by C_PetJournal.GetPetAbilityList.
local abilityIDs = {}
local abilityLevels = {}

local function getPetAbilities(playerIndex, petIndex, speciesID, level)
  local abilities = {}
  local foundInfo = false

  -- Try to get the currently slotted abilities directly.
  for abilityIndex = 1, 3 do
    local abilityID = C_PetBattles.GetAbilityInfo(
      playerIndex, petIndex, abilityIndex
    )

    if abilityID then
      abilities[abilityIndex] = { abilityID }
      foundInfo = true
    else
      abilities[abilityIndex] = {}
    end
  end

  -- In PvP the opponent's slotted abilities may be hidden.
  -- In that case, determine the possible abilities from the Pet Journal.
  if not foundInfo then
    wipe(abilityIDs)
    wipe(abilityLevels)

    C_PetJournal.GetPetAbilityList(
      speciesID,
      abilityIDs,
      abilityLevels
    )

    for abilityIndex, requiredLevel in ipairs(abilityLevels) do
      if requiredLevel <= level then
        local slot = ((abilityIndex - 1) % 3) + 1

        table.insert(
          abilities[slot],
          abilityIDs[abilityIndex]
        )
      end
    end
  end

  return abilities
end

function Teams.Populate()
  teams = {}

  for playerIndex = Enum.BattlePetOwner.Ally, Enum.BattlePetOwner.Enemy do
    teams[playerIndex] = {}

    local numPets = C_PetBattles.GetNumPets(playerIndex)

    for petIndex = 1, numPets do
      local speciesID = C_PetBattles.GetPetSpeciesID(playerIndex, petIndex)

      local level = C_PetBattles.GetLevel(playerIndex, petIndex)

      teams[playerIndex][petIndex] = getPetAbilities(
        playerIndex, petIndex, speciesID, level
      )
    end
  end
end

function Teams.Ensure()
  if not teams then
    Teams.Populate()
  end

  return teams
end

function Teams.Clear()
  teams = nil
end
