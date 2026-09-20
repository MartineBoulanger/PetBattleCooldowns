local _, PBC = ...

local Stats = PBC.UI.Stats

local allyHealthText
local allyPowerText
local allySpeedText

local allyHealthIcon
local allyPowerIcon
local allySpeedIcon

local enemyHealthText
local enemyPowerText
local enemySpeedText

local enemyHealthIcon
local enemyPowerIcon
local enemySpeedIcon

local function createStatIcons()
  if allyHealthIcon or not PetBattleFrame then
    return
  end

  allyHealthIcon = PetBattleFrame:CreateTexture(nil, "OVERLAY")
  allyHealthIcon:SetSize(12, 12)
  allyHealthIcon:SetTexture("Interface\\PetBattles\\PetBattle-StatIcons")
  allyHealthIcon:SetTexCoord(0.5, 1, 0.5, 1)

  allyPowerIcon = PetBattleFrame:CreateTexture(nil, "OVERLAY")
  allyPowerIcon:SetSize(12, 12)
  allyPowerIcon:SetTexture("Interface\\PetBattles\\PetBattle-StatIcons")
  allyPowerIcon:SetTexCoord(0, 0.5, 0, 0.5)

  allySpeedIcon = PetBattleFrame:CreateTexture(nil, "OVERLAY")
  allySpeedIcon:SetSize(12, 12)
  allySpeedIcon:SetTexture("Interface\\PetBattles\\PetBattle-StatIcons")
  allySpeedIcon:SetTexCoord(0, 0.5, 0.5, 1)

  enemyHealthIcon = PetBattleFrame:CreateTexture(nil, "OVERLAY")
  enemyHealthIcon:SetSize(12, 12)
  enemyHealthIcon:SetTexture("Interface\\PetBattles\\PetBattle-StatIcons")
  enemyHealthIcon:SetTexCoord(0.5, 1, 0.5, 1)

  enemyPowerIcon = PetBattleFrame:CreateTexture(nil, "OVERLAY")
  enemyPowerIcon:SetSize(12, 12)
  enemyPowerIcon:SetTexture("Interface\\PetBattles\\PetBattle-StatIcons")
  enemyPowerIcon:SetTexCoord(0, 0.5, 0, 0.5)

  enemySpeedIcon = PetBattleFrame:CreateTexture(nil, "OVERLAY")
  enemySpeedIcon:SetSize(12, 12)
  enemySpeedIcon:SetTexture("Interface\\PetBattles\\PetBattle-StatIcons")
  enemySpeedIcon:SetTexCoord(0, 0.5, 0.5, 1)
end

function Stats.Create()
  createStatIcons()

  if allyHealthText or not PetBattleFrame then
    return
  end

  allyHealthIcon:SetPoint("TOPLEFT", PetBattleFrame.ActiveAlly, "BOTTOMLEFT", 85, 11)
  allyHealthText = PetBattleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  allyHealthText:SetPoint("LEFT", allyHealthIcon, "RIGHT", 2, -1)
  allyHealthText:SetTextColor(1, 1, 1)

  allyPowerIcon:SetPoint("LEFT", allyHealthText, "RIGHT", 12, 1)
  allyPowerText = PetBattleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  allyPowerText:SetPoint("LEFT", allyPowerIcon, "RIGHT", 2, -1)
  allyPowerText:SetTextColor(1, 1, 1)

  allySpeedIcon:SetPoint("LEFT", allyPowerText, "RIGHT", 12, 1)
  allySpeedText = PetBattleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  allySpeedText:SetPoint("LEFT", allySpeedIcon, "RIGHT", 2, -1)
  allySpeedText:SetTextColor(1, 1, 1)

  enemyHealthIcon:SetPoint("TOPLEFT", PetBattleFrame.ActiveEnemy, "BOTTOMLEFT", 47, 11)
  enemyHealthText = PetBattleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  enemyHealthText:SetPoint("LEFT", enemyHealthIcon, "RIGHT", 2, -1)
  enemyHealthText:SetTextColor(1, 1, 1)

  enemyPowerIcon:SetPoint("LEFT", enemyHealthText, "RIGHT", 12, 1)
  enemyPowerText = PetBattleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  enemyPowerText:SetPoint("LEFT", enemyPowerIcon, "RIGHT", 2, -1)
  enemyPowerText:SetTextColor(1, 1, 1)

  enemySpeedIcon:SetPoint("LEFT", enemyPowerText, "RIGHT", 12, 1)
  enemySpeedText = PetBattleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  enemySpeedText:SetPoint("LEFT", enemySpeedIcon, "RIGHT", 2, -1)
  enemySpeedText:SetTextColor(1, 1, 1)
end

function Stats.GetFrames()
  Stats.Create()

  return {
    ally = {
      healthIcon = allyHealthIcon,
      healthText = allyHealthText,
      powerIcon = allyPowerIcon,
      powerText = allyPowerText,
      speedIcon = allySpeedIcon,
      speedText = allySpeedText,
    },
    enemy = {
      healthIcon = enemyHealthIcon,
      healthText = enemyHealthText,
      powerIcon = enemyPowerIcon,
      powerText = enemyPowerText,
      speedIcon = enemySpeedIcon,
      speedText = enemySpeedText,
    },
  }
end

local function hideAllyStats()
  allyHealthText:Hide()
  allyPowerText:Hide()
  allySpeedText:Hide()

  allyHealthIcon:Hide()
  allyPowerIcon:Hide()
  allySpeedIcon:Hide()
end

local function hideEnemyStats()
  enemyHealthText:Hide()
  enemyPowerText:Hide()
  enemySpeedText:Hide()

  enemyHealthIcon:Hide()
  enemyPowerIcon:Hide()
  enemySpeedIcon:Hide()
end

function Stats.UpdatePetNameFontSize()
  if not PetBattleFrame then
    return
  end

  local fontSize = PBCDB.petNameFontSize

  local names = {
    PetBattleFrame.ActiveAlly.Name,
    PetBattleFrame.ActiveEnemy.Name,
  }

  for _, name in ipairs(names) do
    local font, _, flags = name:GetFont()

    if font then
      name:SetFont(font, fontSize, flags)
    end
  end
end

function Stats.UpdateAlly(petIndex)
  Stats.Create()

  if not allyHealthText then
    return
  end

  if not PBCDB.showStats then
    hideAllyStats()
    return
  end

  local playerIndex = Enum.BattlePetOwner.Ally
  petIndex = petIndex or C_PetBattles.GetActivePet(playerIndex)

  if not petIndex then
    hideAllyStats()
    return
  end

  local stats = Stats.GetPetStats(playerIndex, petIndex)

  allyHealthText:SetText(stats.healthPercent .. "%")
  allyPowerText:SetText(stats.power)
  allySpeedText:SetText(stats.speed)

  allyHealthIcon:Show()
  allyHealthText:Show()

  allyPowerIcon:Show()
  allyPowerText:Show()

  allySpeedIcon:Show()
  allySpeedText:Show()
end

function Stats.UpdateEnemy(petIndex)
  Stats.Create()

  if not enemyHealthText then
    return
  end

  if not PBCDB.showStats then
    hideEnemyStats()
    return
  end

  local playerIndex = Enum.BattlePetOwner.Enemy
  petIndex = petIndex or C_PetBattles.GetActivePet(playerIndex)

  if not petIndex then
    hideEnemyStats()
    return
  end

  local stats = Stats.GetPetStats(playerIndex, petIndex)

  enemyHealthText:SetText(stats.healthPercent .. "%")
  enemyPowerText:SetText(stats.power)
  enemySpeedText:SetText(stats.speed)

  enemyHealthIcon:Show()
  enemyHealthText:Show()

  enemyPowerIcon:Show()
  enemyPowerText:Show()

  enemySpeedIcon:Show()
  enemySpeedText:Show()
end

function Stats.GetPetStats(playerIndex, petIndex)
  local health = C_PetBattles.GetHealth(playerIndex, petIndex)
  local maxHealth = C_PetBattles.GetMaxHealth(playerIndex, petIndex)
  local power = C_PetBattles.GetPower(playerIndex, petIndex)
  local speed = C_PetBattles.GetSpeed(playerIndex, petIndex)

  local healthPercent = 0

  if maxHealth > 0 then
    healthPercent = math.floor((health / maxHealth) * 100)
  end

  return {
    health = health,
    maxHealth = maxHealth,
    healthPercent = healthPercent,
    power = power,
    speed = speed,
  }
end
