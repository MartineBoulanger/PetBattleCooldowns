local _, PBC = ...

local Auras = PBC.Battle.Auras

function Auras.GetPetAuras(playerIndex, petIndex)
  local auras = {}

  local numAuras = C_PetBattles.GetNumAuras(playerIndex, petIndex)

  for auraIndex = 1, numAuras do
    local auraID,
    instanceID,
    turnsRemaining,
    isBuff =
        C_PetBattles.GetAuraInfo(playerIndex, petIndex, auraIndex)

    if auraID then
      local _, name, icon = C_PetBattles.GetAbilityInfoByID(auraID)
      table.insert(auras, {
        id = auraID,
        instanceID = instanceID,
        name = name,
        icon = icon,
        duration = turnsRemaining,
        isBuff = isBuff,
        playerIndex = playerIndex,
        petIndex = petIndex,
      })
    end
  end

  return auras
end
