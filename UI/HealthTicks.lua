local _, PBC = ...

local HealthTicks = PBC.UI.HealthTicks

local allyTick75
local allyTick50
local allyTick25

local enemyTick75
local enemyTick50
local enemyTick25

local tickHeight = 6
local tickWidth = 3

local function createAllyTicks()
  if allyTick75 or not PetBattleFrame then
    return
  end

  local healthBar = PetBattleFrame.ActiveAlly.ActualHealthBar

  if not healthBar then
    return
  end

  allyTick75 = PetBattleFrame.ActiveAlly:CreateTexture(nil, "OVERLAY")
  allyTick50 = PetBattleFrame.ActiveAlly:CreateTexture(nil, "OVERLAY")
  allyTick25 = PetBattleFrame.ActiveAlly:CreateTexture(nil, "OVERLAY")

  allyTick75:SetColorTexture(1, 1, 1, 1)
  allyTick50:SetColorTexture(1, 1, 1, 1)
  allyTick25:SetColorTexture(1, 1, 1, 1)

  allyTick75:SetSize(tickWidth, tickHeight)
  allyTick50:SetSize(tickWidth, tickHeight)
  allyTick25:SetSize(tickWidth, tickHeight)

  local barWidth = healthBar:GetWidth()

  allyTick75:SetPoint(
    "BOTTOM", healthBar, "BOTTOMLEFT", barWidth * 0.75, 0
  )

  allyTick50:SetPoint(
    "BOTTOM", healthBar, "BOTTOMLEFT", barWidth * 0.50, 0
  )

  allyTick25:SetPoint(
    "BOTTOM", healthBar, "BOTTOMLEFT", barWidth * 0.25, 0
  )
end

local function createEnemyTicks()
  if enemyTick75 or not PetBattleFrame then
    return
  end

  local healthBar = PetBattleFrame.ActiveEnemy.ActualHealthBar

  if not healthBar then
    return
  end

  enemyTick75 = PetBattleFrame.ActiveEnemy:CreateTexture(nil, "OVERLAY")
  enemyTick50 = PetBattleFrame.ActiveEnemy:CreateTexture(nil, "OVERLAY")
  enemyTick25 = PetBattleFrame.ActiveEnemy:CreateTexture(nil, "OVERLAY")

  enemyTick75:SetColorTexture(1, 1, 1, 1)
  enemyTick50:SetColorTexture(1, 1, 1, 1)
  enemyTick25:SetColorTexture(1, 1, 1, 1)

  enemyTick75:SetSize(tickWidth, tickHeight)
  enemyTick50:SetSize(tickWidth, tickHeight)
  enemyTick25:SetSize(tickWidth, tickHeight)

  local barWidth = healthBar:GetWidth()

  enemyTick75:SetPoint(
    "BOTTOM", healthBar, "BOTTOMRIGHT", -(barWidth * 0.75), 0
  )

  enemyTick50:SetPoint(
    "BOTTOM", healthBar, "BOTTOMRIGHT", -(barWidth * 0.50), 0
  )

  enemyTick25:SetPoint(
    "BOTTOM", healthBar, "BOTTOMRIGHT", -(barWidth * 0.25), 0
  )
end

local function getHealthColor(healthPercent)
  if healthPercent > 75 then
    return 0, 1, 0
  elseif healthPercent > 50 then
    return 1, 1, 0
  elseif healthPercent > 25 then
    return 1, 0.5, 0
  else
    return 1, 0, 0
  end
end

local function updateTickVisibility()
  local visible = PBCDB.showHealthTicks

  if PBCDB.useElvUISkin
      and C_AddOns.IsAddOnLoaded("ElvUI")
  then
    visible = false
  end

  local ticks = {
    allyTick75,
    allyTick50,
    allyTick25,
    enemyTick75,
    enemyTick50,
    enemyTick25,
  }

  for _, tick in ipairs(ticks) do
    if tick then
      tick:SetShown(visible)
    end
  end
end

function HealthTicks.Update(frame)
  if not frame or not frame.petOwner
      or not frame.petIndex or not frame.ActualHealthBar
  then
    return
  end

  if not PBCDB.colorHealthBars then
    frame.ActualHealthBar:SetColorTexture(0, 1, 0, 1)
    return
  end

  local health = C_PetBattles.GetHealth(
    frame.petOwner, frame.petIndex
  )

  local maxHealth = C_PetBattles.GetMaxHealth(
    frame.petOwner, frame.petIndex
  )

  if maxHealth <= 0 then
    return
  end

  local healthPercent = (health / maxHealth) * 100
  local r, g, b = getHealthColor(healthPercent)

  frame.ActualHealthBar:SetColorTexture(r, g, b, 1)
end

function HealthTicks.UpdateActive(playerIndex)
  createAllyTicks()
  createEnemyTicks()
  updateTickVisibility()

  local petFrame

  if playerIndex == Enum.BattlePetOwner.Ally then
    petFrame = PetBattleFrame.ActiveAlly
  elseif playerIndex == Enum.BattlePetOwner.Enemy then
    petFrame = PetBattleFrame.ActiveEnemy
  end

  if not petFrame then
    return
  end

  HealthTicks.Update(petFrame)
end

function HealthTicks.Hide()
  local ticks = {
    allyTick75,
    allyTick50,
    allyTick25,
    enemyTick75,
    enemyTick50,
    enemyTick25,
  }

  for _, tick in ipairs(ticks) do
    if tick then
      tick:Hide()
    end
  end
end

hooksecurefunc(
  "PetBattleUnitFrame_UpdateDisplay",
  function(frame)
    HealthTicks.Update(frame)
  end
)
