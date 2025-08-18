local wezterm = require("wezterm")
local config = wezterm.config_builder()

local process_icons = {
  ["podman"] = {
    { Text = wezterm.nerdfonts.linux_docker },
  },
  ["docker"] = {
    { Text = wezterm.nerdfonts.linux_docker },
  },
  ["docker-compose"] = {
    { Text = wezterm.nerdfonts.linux_docker },
  },
  ["kuberlr"] = {
    { Text = wezterm.nerdfonts.linux_docker },
  },
  ["kubectl"] = {
    { Text = wezterm.nerdfonts.linux_docker },
  },
  ["nvim"] = {
    { Text = "" },
  },
  ["vim"] = {
    { Text = wezterm.nerdfonts.dev_vim },
  },
  ["node"] = {
    { Text = wezterm.nerdfonts.mdi_hexagon },
  },
  ["zsh"] = {
    { Text = wezterm.nerdfonts.cod_terminal },
  },
  ["bash"] = {
    { Text = wezterm.nerdfonts.cod_terminal_bash },
  },
  ["btm"] = {
    { Text = wezterm.nerdfonts.mdi_chart_donut_variant },
  },
  ["htop"] = {
    { Text = wezterm.nerdfonts.mdi_chart_donut_variant },
  },
  ["cargo"] = {
    { Text = wezterm.nerdfonts.dev_rust },
  },
  ["go"] = {
    { Text = wezterm.nerdfonts.mdi_language_go },
  },
  ["lazydocker"] = {
    { Text = wezterm.nerdfonts.linux_docker },
  },
  ["git"] = {
    { Text = wezterm.nerdfonts.dev_git },
  },
  ["lua"] = {
    { Text = wezterm.nerdfonts.seti_lua },
  },
  ["wget"] = {
    { Text = wezterm.nerdfonts.mdi_arrow_down_box },
  },
  ["curl"] = {
    { Text = wezterm.nerdfonts.mdi_flattr },
  },
  ["gh"] = {
    { Text = wezterm.nerdfonts.dev_github_badge },
  },
  ["python"] = {
    { Text = wezterm.nerdfonts.dev_python },
  },
  ["python3"] = {
    { Text = wezterm.nerdfonts.dev_python },
  },
  ["ruby"] = {
    { Text = wezterm.nerdfonts.dev_ruby },
  },
  ["beam.smp"] = {
    { Text = wezterm.nerdfonts.custom_elixir },
  },
  ["elixir"] = {
    { Text = wezterm.nerdfonts.custom_elixir },
  },
}

local function get_current_working_dir(tab)
  local current_dir = tab.active_pane.current_working_dir or "~"
  local file_path = current_dir.file_path

  if file_path == os.getenv("HOME") then
    return "~"
  end

  return string.gsub(file_path, "(.*[/\\])(.*)", "%2")
end

local function get_process(tab)
  local process_name = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")
  process_name = string.lower(process_name)
  if string.find(process_name, "kubectl") then
    process_name = "kubectl"
  end

  return wezterm.format(process_icons[process_name] or { { Text = string.format("%s:", process_name) } })
end

local direction_keys = {
  Left = "h",
  Down = "j",
  Up = "k",
  Right = "l",
  -- reverse lookup
  h = "Left",
  j = "Down",
  k = "Up",
  l = "Right",
}

local function is_vim(pane)
  local process_info = pane:get_foreground_process_info()
  local process_name = process_info and process_info.name

  return process_name == "nvim" or process_name == "vim"
end

local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == "resize" and "CTRL|SHIFT" or "CTRL",
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == "resize" and "CTRL|SHIFT" or "CTRL" },
        }, pane)
      else
        if resize_or_move == "resize" then
          win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
        end
      end
    end),
  }
end

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
-- config.font = wezterm.font("Iosevka", { weight = "Medium" })
-- config.font = wezterm.font("FiraCodeGG Nerd Font", { weight = "Medium" })
-- config.font = wezterm.font("Iosevka GG", { stretch = "Expanded", weight = "Medium" })
config.font = wezterm.font({ family = "VictorMono Nerd Font", weight = 500, harfbuzz_features = { "ss01=off" } })
-- config.font = wezterm.font({ family = "Victor Mono", weight = 600, harfbuzz_features = {} })
-- config.font = wezterm.font("Maple Mono", { weight = "Medium" })
-- config.font = wezterm.font({ family = "Rec Mono Duotone", weight = "Medium" })
-- config.font = wezterm.font({ family = "CaskaydiaCove Nerd Font", weight = "Medium" })
-- config.font = wezterm.font({ family = "Dank Mono" })
-- config.font = wezterm.font({ family = "Fantasque Sans Mono" })
-- config.font = wezterm.font({ family = "CommitMono-GG" })
-- config.font = wezterm.font({ family = "Mononoki" })
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

-- -- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
-- local function is_vim(pane)
--   -- this is set by the plugin, and unset on ExitPre in Neovim
--   return pane:get_user_vars().IS_NVIM == "true"
-- end

local action = wezterm.action
config.keys = {
  {
    mods = "OPT",
    key = "Enter",
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    mods = "CMD|SHIFT",
    key = "d",
    action = action.SplitPane({
      direction = "Right",
      size = { Percent = 33 },
    }),
  },
  {
    mods = "CMD",
    key = "d",
    action = action.SplitPane({
      direction = "Down",
      size = { Percent = 33 },
    }),
  },
  {
    mods = "CMD",
    key = "z",
    action = action.TogglePaneZoomState,
  },
  { key = "[", mods = "CMD", action = action.ActivateTabRelative(-1) },
  { key = "]", mods = "CMD", action = action.ActivateTabRelative(1) },
  { key = "[", mods = "CMD|SHIFT", action = action.MoveTabRelative(-1) },
  { key = "]", mods = "CMD|SHIFT", action = action.MoveTabRelative(1) },
  {
    mods = "CMD",
    key = "p",
    action = action.ActivateCommandPalette,
  },
  {
    mods = "CMD|SHIFT",
    key = "x",
    action = action.ActivateCopyMode,
  },
  {
    mods = "CMD",
    key = "w",
    action = action.CloseCurrentPane({ confirm = false }),
  },
  {
    mods = "CMD|SHIFT",
    key = "w",
    action = action.CloseCurrentTab({ confirm = false }),
  },
  {
    mods = "CMD",
    key = ",",
    action = action.SpawnCommandInNewWindow({
      label = "Open Wezterm config",
      args = { "/bin/zsh", "-c", "nvim " .. wezterm.shell_quote_arg(wezterm.config_file) },
      set_environment_variables = {
        PATH = "/Users/george/.asdf/shims:/Users/george/.asdf/bin:~/.local/bin:/Users/george/bin:/usr/local/sbin:/usr/local/bin:/Users/george/go/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/Users/george/.cargo/bin:/opt/homebrew/opt/fzf/bin"
          .. os.getenv("PATH"),
      },
    }),
  },
  { mods = "OPT", key = "LeftArrow", action = action.SendKey({ mods = "ALT", key = "b" }) },
  { mods = "OPT", key = "RightArrow", action = action.SendKey({ mods = "ALT", key = "f" }) },
  { mods = "CMD", key = "LeftArrow", action = action.SendKey({ mods = "CTRL", key = "a" }) },
  { mods = "CMD", key = "RightArrow", action = action.SendKey({ mods = "CTRL", key = "e" }) },
  { mods = "CMD", key = "Backspace", action = action.SendKey({ mods = "CTRL", key = "u" }) },
  {
    mods = "CMD",
    key = "c",
    action = wezterm.action_callback(function(window, pane)
      if is_vim(pane) then
        window:perform_action(action.SendKey({ key = "y" }), pane)
      else
        window:perform_action(action.CopyTo("Clipboard"), pane)
      end
    end),
  },
  {
    mods = "CMD",
    key = "a",
    action = wezterm.action_callback(function(window, pane)
      if is_vim(pane) then
        window:perform_action(
          action.Multiple({
            action.SendKey({ key = "Escape" }),
            action.SendKey({ key = "g" }),
            action.SendKey({ key = "g" }),
            action.SendKey({ key = "V" }),
            action.SendKey({ key = "G" }),
          }),
          pane
        )
      else
        window:perform_action(action.Nop, pane)
      end
    end),
  },
  {
    mods = "CMD",
    key = "s",
    action = wezterm.action_callback(function(window, pane)
      if is_vim(pane) then
        window:perform_action(
          action.Multiple({
            action.SendKey({ key = "Escape" }),
            action.SendKey({ key = ":" }),
            action.SendKey({ key = "w" }),
            action.SendKey({ key = "Enter" }),
          }),
          pane
        )
      else
        window:perform_action(action.Nop, pane)
      end
    end),
  },
  {
    mods = "CMD",
    key = "r",
    action = action.RotatePanes("Clockwise"),
  },
  {
    mods = "CMD|SHIFT",
    key = "r",
    action = action.RotatePanes("CounterClockwise"),
  },
  {
    mods = "CMD",
    key = "g",
    action = action.PaneSelect({ mode = "SwapWithActive" }),
  },

  -- move between split panes
  split_nav("move", "h"),
  split_nav("move", "j"),
  split_nav("move", "k"),
  split_nav("move", "l"),
  -- resize panes
  split_nav("resize", "h"),
  split_nav("resize", "j"),
  split_nav("resize", "k"),
  split_nav("resize", "l"),
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local has_unseen_output = false
  if not tab.is_active then
    for _, pane in ipairs(tab.panes) do
      if pane.has_unseen_output then
        has_unseen_output = true
        break
      end
    end
  end

  local title = string.format("%s   %s", get_process(tab), get_current_working_dir(tab))

  if tab.active_pane.is_zoomed then
    title = title .. " " .. wezterm.nerdfonts.md_alpha_z_box
  end

  if has_unseen_output then
    return {
      { Foreground = { Color = "#737aa2" } },
      { Text = title },
    }
  end

  return {
    { Text = title },
  }
end)

wezterm.on("update-status", function(window, pane)
  if window:active_key_table() == "copy_mode" then
    window:set_right_status(wezterm.format({
      { Foreground = { Color = "#bb9af7" } },
      { Background = { Color = "#222436" } },
      { Text = wezterm.nerdfonts.oct_copy .. "  COPY  " },
    }))
  else
    window:set_right_status("")
  end
end)

config.hyperlink_rules = wezterm.default_hyperlink_rules()
-- make username/project paths clickable. this implies paths like the following are for github.
-- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wez/wezterm | "wez/wezterm.git" )
-- as long as a full url hyperlink regex exists above this it should not match a full url to
-- github or gitlab / bitbucket (i.e. https://gitlab.com/user/project.git is still a whole clickable url)
table.insert(config.hyperlink_rules, {
  regex = [[["'\s]([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["'\s]] .. "]",
  format = "https://www.github.com/$1/$3",
})

wezterm.on("gui-startup", function(cmd) -- set startup Window position
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():set_position(120, 110)
end)

return config
