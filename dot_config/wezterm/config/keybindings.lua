local wezterm = require("wezterm")
local helpers = require("utils.helpers")

local M = {}

local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == "resize" and "CTRL|SHIFT" or "CTRL",
    action = wezterm.action_callback(function(win, pane)
      if helpers.is_vim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == "resize" and "CTRL|SHIFT" or "CTRL" },
        }, pane)
      else
        if resize_or_move == "resize" then
          win:perform_action({ AdjustPaneSize = { helpers.direction_keys[key], 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = helpers.direction_keys[key] }, pane)
        end
      end
    end),
  }
end

function M.apply(config)
  local action = wezterm.action
  config.keys = {
    { key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b\r" }) },
    {
      key = " ",
      mods = "CTRL",
      action = wezterm.action.SendKey({
        key = " ",
        mods = "CTRL",
      }),
    },
    {
      key = "Enter",
      mods = "",
      action = wezterm.action.SendKey({
        key = "Enter",
        mods = "",
      }),
    },
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
        if helpers.is_vim(pane) then
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
        if helpers.is_vim(pane) then
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
        if helpers.is_vim(pane) then
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
end

return M
