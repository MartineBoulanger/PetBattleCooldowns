local addonName, PBC = ...

PBC.Name = addonName

PBC.Settings = PBC.Settings or {}
PBC.Constants = PBC.Constants or {}
PBC.Events = PBC.Events or {}
PBC.Teams = PBC.Teams or {}
PBC.Battle = PBC.Battle or {}
PBC.UI = PBC.UI or {}
PBC.ElvUI = PBC.ElvUI or {}

PBC.Battle.Actions = PBC.Battle.Actions or {}
PBC.Battle.Auras = PBC.Battle.Auras or {}
PBC.Battle.BattleFrame = PBC.Battle.BattleFrame or {}

PBC.UI.AbilityButton = PBC.UI.AbilityButton or {}
PBC.UI.AbilityGroup = PBC.UI.AbilityGroup or {}
PBC.UI.PetFrame = PBC.UI.PetFrame or {}
PBC.UI.AuraFrame = PBC.UI.AuraFrame or {}
PBC.UI.RoundCounter = PBC.UI.RoundCounter or {}
PBC.UI.Stats = PBC.UI.Stats or {}
PBC.UI.HealthTicks = PBC.UI.HealthTicks or {}
PBC.UI.Keybinds = PBC.UI.Keybinds or {}
PBC.UI.Options = PBC.UI.Options or {}

-- Distance between adjacent aura frames.
PBC.Constants.AURA_FRAME_DISTANCE = 4
