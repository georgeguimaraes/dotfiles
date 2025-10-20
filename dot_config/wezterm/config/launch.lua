local wezterm = require("wezterm")

local M = {}

function M.apply(config)
  -- Shell and window size
  config.default_prog = { "/bin/zsh", "-l" }
  config.initial_cols = 254
  config.initial_rows = 51

  -- Terminal behavior
  config.scrollback_lines = 100000
  config.term = "wezterm"

  -- Keyboard and input protocols
  config.enable_kitty_keyboard = true
  config.use_ime = true
  config.enable_kitty_graphics = true
  config.enable_csi_u_key_encoding = false

  -- Tab and window behavior
  config.switch_to_last_active_tab_when_closing_tab = true
  config.window_close_confirmation = "NeverPrompt"
  config.pane_focus_follows_mouse = true

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
