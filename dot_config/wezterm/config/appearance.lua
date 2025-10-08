local wezterm = require("wezterm")

local M = {}

function M.apply(config)
  config.scrollback_lines = 100000
  config.front_end = "WebGpu"
  config.audible_bell = "Disabled"
  config.visual_bell = {
    fade_in_duration_ms = 75,
    fade_out_duration_ms = 75,
    target = "BackgroundColor",
  }
  config.term = "wezterm"
  config.max_fps = 75
  config.animation_fps = 75

  config.color_scheme = "tokyonight_moon_gg"
  config.font = wezterm.font({ family = "VictorMono Nerd Font", weight = 500, harfbuzz_features = { "ss01=off" } })
  config.font_size = 17
  config.use_fancy_tab_bar = true
  config.hide_tab_bar_if_only_one_tab = true
  config.enable_kitty_keyboard = true
  config.use_ime = false
  config.enable_kitty_graphics = true
  config.enable_csi_u_key_encoding = false
  config.window_decorations = "RESIZE"
  config.window_background_opacity = 0.97
  config.macos_window_background_blur = 30
  config.initial_cols = 254
  config.initial_rows = 51
  config.switch_to_last_active_tab_when_closing_tab = true
  config.window_close_confirmation = "NeverPrompt"
  config.pane_focus_follows_mouse = true
  config.window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
  }
  config.window_frame = {
    font_size = 16,
    active_titlebar_bg = "#222436",
  }
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
  }

  -- Hyperlink rules
  config.hyperlink_rules = wezterm.default_hyperlink_rules()
  -- make username/project paths clickable. this implies paths like the following are for github.
  -- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wez/wezterm | "wez/wezterm.git" )
  -- as long as a full url hyperlink regex exists above this it should not match a full url to
  -- github or gitlab / bitbucket (i.e. https://gitlab.com/user/project.git is still a whole clickable url)
  table.insert(config.hyperlink_rules, {
    regex = [[["'\s]([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["'\s]] .. "]",
    format = "https://www.github.com/$1/$3",
  })
end

return M
