local _, PBC = ...

local Actions = PBC.Battle.Actions

local lastPlayerAbilityID
local onActionProcessed

function Actions.SetActionProcessedCallback(callback)
  onActionProcessed = callback
end

local function checkMatchingStats(playerIndex, health, power, speed)
  local activePetIndex = C_PetBattles.GetActivePet(playerIndex)

  return health == C_PetBattles.GetHealth(playerIndex, activePetIndex)
      and power == C_PetBattles.GetPower(playerIndex, activePetIndex)
      and speed == C_PetBattles.GetSpeed(playerIndex, activePetIndex)
end

local function getAbilityIndex(playerIndex, abilityID)
  local teams = PBC.Teams.Ensure()
  local activePetIndex = C_PetBattles.GetActivePet(playerIndex)
  local petAbilities = teams[playerIndex][activePetIndex]

  for slot, slotAbilities in ipairs(petAbilities) do
    for _, candidateAbilityID in ipairs(slotAbilities) do
      if candidateAbilityID == abilityID then
        return slot
      end
    end
  end

  return nil
end

local function processAction(playerIndex, abilityIndex, abilityID)
  if not abilityIndex then
    return false
  end

  local teams = PBC.Teams.Ensure()
  local petIndex = C_PetBattles.GetActivePet(playerIndex)

  local abilitySlot = teams[playerIndex][petIndex][abilityIndex]

  -- In PvP we may initially have two possible abilities for a slot.
  -- Once the ability is used, we know which one is actually equipped.
  if abilitySlot[2] then
    teams[playerIndex][petIndex][abilityIndex] = { abilityID }
    return true
  end

  return false
end

local function notifyActionProcessed(playerIndex, abilityIndex, abilityChanged)
  if onActionProcessed then
    onActionProcessed(playerIndex, abilityIndex, abilityChanged)
  end
end

local function handleAction(playerIndex, abilityIndex, abilityID)
  local abilityChanged = processAction(playerIndex, abilityIndex, abilityID)
  notifyActionProcessed(playerIndex, abilityIndex, abilityChanged)
end

function Actions.OnRoundPlaybackComplete()
  if C_PetBattles.IsSkipAvailable() then
    lastPlayerAbilityID = nil
  end
end

function Actions.OnActionSelected()
  local actionType, actionIndex = C_PetBattles.GetSelectedAction()

  if actionType == LE_BATTLE_PET_ACTION_ABILITY then
    lastPlayerAbilityID = C_PetBattles.GetAbilityInfo(
      Enum.BattlePetOwner.Ally,
      C_PetBattles.GetActivePet(Enum.BattlePetOwner.Ally),
      actionIndex
    )
  else
    lastPlayerAbilityID = nil
  end
end

function Actions.OnCombatLog(message)
  for abilityID, health, power, speed in message:gmatch(
    "|HbattlePetAbil:(%d-):(%d-):(%d-):(%d-)|h"
  ) do
    abilityID = tonumber(abilityID)
    health = tonumber(health)
    power = tonumber(power)
    speed = tonumber(speed)

    local playerIndex = Enum.BattlePetOwner.Ally
    local abilityIndex = getAbilityIndex(playerIndex, abilityID)
    local isPlayerAction = abilityIndex and abilityID == lastPlayerAbilityID
        and checkMatchingStats(playerIndex, health, power, speed)

    if isPlayerAction then
      handleAction(playerIndex, abilityIndex, abilityID)
      return
    end

    local enemyIndex = Enum.BattlePetOwner.Enemy
    local enemyAbilityIndex = getAbilityIndex(enemyIndex, abilityID)
    local isEnemyAction = enemyAbilityIndex
        and checkMatchingStats(enemyIndex, health, power, speed)

    if isEnemyAction then
      handleAction(enemyIndex, enemyAbilityIndex, abilityID)
      return
    end
  end
end

function Actions.Reset()
  lastPlayerAbilityID = nil
end
