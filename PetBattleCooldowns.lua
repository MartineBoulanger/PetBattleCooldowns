local _, PBC = ...

--------------------------------
-- Main Battle Frame
--------------------------------
DeePetBattleFrame_OnLoad = PBC.Battle.BattleFrame.OnLoad
DeePetBattleFrame_OnEvent = PBC.Battle.BattleFrame.OnEvent
DeePetBattleFrame_OnShow = PBC.Battle.BattleFrame.OnShow

--------------------------------
-- Ability Buttons
--------------------------------
DeePetBattleAbilityButton_OnLoad = PBC.UI.AbilityButton.OnLoad
DeePetBattleAbilityButton_OnEvent = PBC.UI.AbilityButton.OnEvent
DeePetBattleAbilityButton_OnShow = PBC.UI.AbilityButton.UpdateBetterIcon
DeePetBattleAbilityButton_OnEnter = PBC.UI.AbilityButton.OnEnter
DeePetBattleAbilityButton_topHalf_OnEnter = PBC.UI.AbilityButton.OnTopHalfEnter
DeePetBattleAbilityButton_OnLeave = PBC.UI.AbilityButton.OnLeave

--------------------------------
-- Pet Frames
--------------------------------
DeePetBattlePet_OnLoad = PBC.UI.PetFrame.OnLoad
DeePetBattlePet_OnEvent = PBC.UI.PetFrame.OnEvent
DeePetBattlePet_OnShow = PBC.UI.PetFrame.UpdatePetIndex

--------------------------------
-- Ability Groups
--------------------------------
DeePetBattleAbilityGroup_OnLoad = PBC.UI.AbilityGroup.OnLoad

--------------------------------
-- Aura Frames
--------------------------------
DeePetBattleAura_OnEnter = PBC.UI.AuraFrame.OnEnter
DeePetBattleAura_OnLeave = PBC.UI.AuraFrame.OnLeave
