local wezterm = require('wezterm')

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.font = wezterm.font 'JetBrains Mono'
config.font_size = 11.0
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.line_height = 0.9
config.window_padding = {
    left = '0cell',
    right = '0cell',
    top = '0cell',
    bottom = '0cell',
}
config.check_for_updates = false
config.show_update_window = false
return config
