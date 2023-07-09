local wezterm = require('wezterm')

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.font = wezterm.font 'JetBrains Mono'
config.harfbuzz_features = {"calt=0", "clig=0", "liga=0"}

-- For example, changing the color scheme:
--config.color_scheme = 'OneHalfLight'

-- and finally, return the configuration to wezterm
return config
