local _, PBC = ...

local BattleFrame = PBC.Battle.BattleFrame

local eventHandlers = {}

function BattleFrame.OnShow()
  PBC.Teams.Populate()
  PBC.Battle.Actions.Reset()
  PBC.UI.RoundCounter.Reset()
  PBC.UI.Stats.UpdateAlly()
  PBC.UI.Stats.UpdateEnemy()
  PBC.UI.Stats.UpdatePetNameFontSize()
  PBC.UI.HealthTicks.UpdateActive(Enum.BattlePetOwner.Ally)
  PBC.UI.HealthTicks.UpdateActive(Enum.BattlePetOwner.Enemy)
end

function BattleFrame.OnBattleClose()
  PBC.Teams.Clear()
  PBC.Battle.Actions.Reset()
  PBC.UI.RoundCounter.Reset()
end

function BattleFrame.OnCombatLog(_, message)
  PBC.Battle.Actions.OnCombatLog(message)
end

function BattleFrame.OnRoundPlaybackComplete()
  PBC.Battle.Actions.OnRoundPlaybackComplete()
  PBC.UI.RoundCounter.OnRoundResults()
end

function BattleFrame.OnHealthChanged(_, playerIndex)
  if playerIndex == Enum.BattlePetOwner.Ally then
    PBC.UI.Stats.UpdateAlly()
  elseif playerIndex == Enum.BattlePetOwner.Enemy then
    PBC.UI.Stats.UpdateEnemy()
  end
  PBC.UI.HealthTicks.UpdateActive(playerIndex)
end

function BattleFrame.OnPetChanged(_, playerIndex)
  if playerIndex == Enum.BattlePetOwner.Ally then
    PBC.UI.Stats.UpdateAlly()
  elseif playerIndex == Enum.BattlePetOwner.Enemy then
    PBC.UI.Stats.UpdateEnemy()
  end
  PBC.UI.HealthTicks.UpdateActive(playerIndex)
end

eventHandlers["PET_BATTLE_PET_ROUND_PLAYBACK_COMPLETE"] = BattleFrame.OnRoundPlaybackComplete
eventHandlers["PET_BATTLE_ACTION_SELECTED"] = PBC.Battle.Actions.OnActionSelected
eventHandlers["CHAT_MSG_PET_BATTLE_COMBAT_LOG"] = BattleFrame.OnCombatLog
eventHandlers["PET_BATTLE_CLOSE"] = BattleFrame.OnBattleClose
eventHandlers["PET_BATTLE_HEALTH_CHANGED"] = BattleFrame.OnHealthChanged
eventHandlers["PET_BATTLE_PET_CHANGED"] = BattleFrame.OnPetChanged

function BattleFrame.OnLoad(frame)
  PBC.Events.RegisterAll(frame, eventHandlers)
end

BattleFrame.OnEvent = PBC.Events.CreateHandler(eventHandlers)
