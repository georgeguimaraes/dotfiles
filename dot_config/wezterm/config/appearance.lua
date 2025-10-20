local wezterm = require("wezterm")

local M = {}

function M.apply(config)
  -- Alerts
  config.audible_bell = "Disabled"
  config.visual_bell = {
    fade_in_duration_ms = 75,
    fade_out_duration_ms = 75,
    target = "BackgroundColor",
  }

  -- Performance
  config.animation_fps = 60
  config.front_end = "WebGpu"
  config.max_fps = 120
  config.webgpu_power_preference = "HighPerformance"

  -- Color scheme and fonts
  config.color_scheme = "tokyonight_moon_gg"
  config.font = wezterm.font({ family = "VictorMono Nerd Font", weight = 500, harfbuzz_features = { "ss01=off" } })
  config.font_size = 18

  -- Tab bar
  config.use_fancy_tab_bar = true
  config.hide_tab_bar_if_only_one_tab = false

  -- Window appearance
  config.window_decorations = "RESIZE"
  config.window_background_opacity = 0.97
  config.macos_window_background_blur = 30
  config.window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
  }
  config.window_frame = {
    font_size = 18,
    active_titlebar_bg = "#222436",
  }

  -- Pane dimming
  config.inactive_pane_hsb = { brightness = 0.8, hue = 1.0, saturation = 0.8 }

  -- Colors
  config.colors = {
    visual_bell = "#1e2030",
    tab_bar = {
      active_tab = {
        bg_color = "#222436",
        fg_color = "#c099ff",
      },
      inactive_tab = {
        bg_color = "#1e2030",
        fg_color = "#444a73",
      },
      new_tab = {
        bg_color = "#191b28",
        fg_color = "#c8d3f5",
      },
      new_tab_hover = {
        bg_color = "#191b28",
        fg_color = "#c099ff",
      },
      inactive_tab_hover = {
        fg_color = "#444a73",
        bg_color = "#1e2030",
      },
    },
    quick_select_match_bg = { Color = "#222436" },
    quick_select_match_fg = { Color = "#828bb8" },
  }
end

return M
