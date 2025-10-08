local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Load configuration modules
require("config.appearance").apply(config)
require("config.keybindings").apply(config)
require("config.events").setup()

return config
