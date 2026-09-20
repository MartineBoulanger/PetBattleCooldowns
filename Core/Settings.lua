local _, PBC = ...

local Settings = PBC.Settings

local defaults = {
  roundDisplay = "ROUND",
  showHealthTicks = true,
  colorHealthBars = true,
  showStats = true,
  petNameFontSize = 16,
  useElvUISkin = false,
}

-- local function isElvUILoaded()
--   return C_AddOns.IsAddOnLoaded("ElvUI")
-- end

function Settings.Initialize()
  -- print("PBC ElvUI loaded:", isElvUILoaded())
  PBCDB = PBCDB or {}

  for key, value in pairs(defaults) do
    if PBCDB[key] == nil then
      PBCDB[key] = value
    end
  end
end

Settings.Initialize()
