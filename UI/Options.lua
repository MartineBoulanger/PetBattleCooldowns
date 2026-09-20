local _, PBC = ...

local Options = PBC.UI.Options

local function getRoundDisplay()
  return PBCDB.roundDisplay
end

local function setRoundDisplay(value)
  PBCDB.roundDisplay = value
end

function Options.Initialize()
  local category = Settings.RegisterVerticalLayoutCategory("Pet Battle Cooldowns")

  local setting = Settings.RegisterProxySetting(
    category,
    "PBC_ROUND_DISPLAY",
    Settings.VarType.String,
    "Round display",
    "ROUND",
    getRoundDisplay,
    setRoundDisplay
  )

  -- Show Round X in the top center or just the default VS
  local function getRoundDisplayOptions()
    local container = Settings.CreateControlTextContainer()

    container:Add("ROUND", "Round")
    container:Add("VS", "VS")

    return container:GetData()
  end

  Settings.CreateDropdown(
    category, setting, getRoundDisplayOptions
  )

  -- Show the health ticks at the bottom of the health bar or not
  local showHealthTicksSetting = Settings.RegisterProxySetting(
    category,
    "PBC_SHOW_HEALTH_TICKS",
    Settings.VarType.Boolean,
    "Show health ticks",
    true,
    function()
      return PBCDB.showHealthTicks
    end,
    function(value)
      PBCDB.showHealthTicks = value
    end
  )

  Settings.CreateCheckbox(
    category,
    showHealthTicksSetting
  )

  -- Show the colors depending on the % of the health or not
  local colorHealthBarsSetting = Settings.RegisterProxySetting(
    category,
    "PBC_COLOR_HEALTH_BARS",
    Settings.VarType.Boolean,
    "Color health bars by health",
    true,
    function()
      return PBCDB.colorHealthBars
    end,
    function(value)
      PBCDB.colorHealthBars = value
    end
  )

  Settings.CreateCheckbox(
    category,
    colorHealthBarsSetting
  )

  -- Show the stats below the health bars or not
  local showStatsSetting = Settings.RegisterProxySetting(
    category,
    "PBC_SHOW_STATS",
    Settings.VarType.Boolean,
    "Show pet stats",
    true,
    function()
      return PBCDB.showStats
    end,
    function(value)
      PBCDB.showStats = value
    end
  )

  Settings.CreateCheckbox(
    category,
    showStatsSetting
  )

  -- Change font size of the pet names
  local petNameFontSizeSetting = Settings.RegisterProxySetting(
    category,
    "PBC_PET_NAME_FONT_SIZE",
    Settings.VarType.Number,
    "Pet name font size",
    16,
    function()
      return PBCDB.petNameFontSize
    end,
    function(value)
      PBCDB.petNameFontSize = value
    end
  )

  local petNameFontSizeOptions = Settings.CreateSliderOptions(
    8, 20, 1
  )

  petNameFontSizeOptions:SetLabelFormatter(
    MinimalSliderWithSteppersMixin.Label.Right,
    function(value)
      return value
    end
  )

  Settings.CreateSlider(
    category,
    petNameFontSizeSetting,
    petNameFontSizeOptions
  )

  -- Show ElvUI skin option only when ElvUI is loaded
  if C_AddOns.IsAddOnLoaded("ElvUI") then
    local useElvUISkinSetting = Settings.RegisterProxySetting(
      category,
      "PBC_USE_ELVUI_SKIN",
      Settings.VarType.Boolean,
      "Use ElvUI skin",
      false,
      function()
        return PBCDB.useElvUISkin
      end,
      function(value)
        PBCDB.useElvUISkin = value
      end
    )

    Settings.CreateCheckbox(
      category,
      useElvUISkinSetting
    )
  end

  Settings.RegisterAddOnCategory(category)
end

Options.Initialize()
