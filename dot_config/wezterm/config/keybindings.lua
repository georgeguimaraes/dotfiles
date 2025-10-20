local wezterm = require("wezterm")
local helpers = require("utils.helpers")

local M = {}

local TIMEOUT = { key = 3000, leader = 3000 }

-- Public interface
function M.apply(config)
  config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = TIMEOUT.leader }
  config.keys = M.get_keys()
  config.key_tables = M.get_key_tables()
end

-- Public module functions
function M.get_keys()
  local action = wezterm.action
  return {
    { key = "Enter", mods = "SHIFT", action = action({ SendString = "\x1b\r" }) },
    {
      key = " ",
      mods = "CTRL",
      action = action.SendKey({
        key = " ",
        mods = "CTRL",
      }),
    },
    {
      key = "Enter",
      mods = "",
      action = action.SendKey({
        key = "Enter",
        mods = "",
      }),
    },
    {
      mods = "OPT",
      key = "Enter",
      action = action.DisableDefaultAssignment,
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
    { key = "k", mods = "CMD", action = action.ClearScrollback("ScrollbackAndViewport") },
    { key = "k", mods = "CMD|SHIFT", action = action.ClearScrollback("ScrollbackOnly") },
    {
      mods = "CMD",
      key = "p",
      action = action.ActivateCommandPalette,
    },
    {
      key = "/",
      mods = "CMD",
      action = action.Search({ CaseInSensitiveString = "" }),
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
        args = { "/bin/zsh", "-lc", "nvim " .. wezterm.shell_quote_arg(wezterm.config_file) },
      }),
    },
    { mods = "OPT", key = "LeftArrow", action = action.SendKey({ mods = "ALT", key = "b" }) },
    { mods = "OPT", key = "RightArrow", action = action.SendKey({ mods = "ALT", key = "f" }) },
    { mods = "CMD", key = "LeftArrow", action = action.SendKey({ mods = "CTRL", key = "a" }) },
    { mods = "CMD", key = "RightArrow", action = action.SendKey({ mods = "CTRL", key = "e" }) },
    { mods = "CMD", key = "Backspace", action = action.SendKey({ mods = "CTRL", key = "u" }) },

    -- Vim-style scrolling (disabled when inside nvim)
    {
      key = "h",
      mods = "OPT",
      action = wezterm.action_callback(function(window, pane)
        if helpers.is_vim(pane) then
          window:perform_action(action.SendKey({ mods = "ALT", key = "h" }), pane)
        else
          window:perform_action(action.SendKey({ mods = "ALT", key = "h" }), pane)
        end
      end),
    },
    {
      key = "j",
      mods = "OPT",
      action = wezterm.action_callback(function(window, pane)
        if helpers.is_vim(pane) then
          window:perform_action(action.SendKey({ mods = "ALT", key = "j" }), pane)
        else
          window:perform_action(action.ScrollByLine(1), pane)
        end
      end),
    },
    {
      key = "k",
      mods = "OPT",
      action = wezterm.action_callback(function(window, pane)
        if helpers.is_vim(pane) then
          window:perform_action(action.SendKey({ mods = "ALT", key = "k" }), pane)
        else
          window:perform_action(action.ScrollByLine(-1), pane)
        end
      end),
    },
    {
      key = "l",
      mods = "OPT",
      action = wezterm.action_callback(function(window, pane)
        if helpers.is_vim(pane) then
          window:perform_action(action.SendKey({ mods = "ALT", key = "l" }), pane)
        else
          window:perform_action(action.SendKey({ mods = "ALT", key = "l" }), pane)
        end
      end),
    },
    { key = "u", mods = "OPT", action = action.ScrollByPage(-0.5) },
    { key = "d", mods = "OPT", action = action.ScrollByPage(0.5) },
    { key = "b", mods = "OPT", action = action.ScrollByPage(-1) },
    { key = "f", mods = "OPT", action = action.ScrollByPage(1) },
    { key = "g", mods = "OPT", action = action.ScrollToTop },
    { key = "g", mods = "OPT|SHIFT", action = action.ScrollToBottom },
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
    {
      mods = "CMD",
      key = "u",
      action = M.open_url_action(),
    },
    {
      mods = "CMD",
      key = "o",
      action = action.SpawnCommandInNewTab({ args = { "open", "." } }),
    },

    -- move between split panes
    M.split_nav("move", "h"),
    M.split_nav("move", "j"),
    M.split_nav("move", "k"),
    M.split_nav("move", "l"),

    -- Leader key tables
    { key = "o", mods = "LEADER", action = action.SpawnCommandInNewTab({ args = { "open", "." } }) },
    { key = "r", mods = "LEADER", action = M.activate_table("resize") },
    { key = "y", mods = "LEADER", action = M.activate_table("copy") },
    { key = "h", mods = "LEADER", action = action.ActivateCommandPalette },
    { key = "v", mods = "LEADER", action = action.ActivateCopyMode },
    { key = ",", mods = "LEADER", action = M.rename_tab_prompt() },
    { key = "$", mods = "LEADER|SHIFT", action = M.rename_workspace_prompt() },
    { key = "-", mods = "LEADER", action = action.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "\\", mods = "LEADER", action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  }
end

function M.get_key_tables()
  local action = wezterm.action
  return {
    resize = {
      { key = "DownArrow", action = action.AdjustPaneSize({ "Down", 1 }) },
      { key = "LeftArrow", action = action.AdjustPaneSize({ "Left", 1 }) },
      { key = "RightArrow", action = action.AdjustPaneSize({ "Right", 1 }) },
      { key = "UpArrow", action = action.AdjustPaneSize({ "Up", 1 }) },
      { key = "j", action = action.AdjustPaneSize({ "Down", 1 }) },
      { key = "h", action = action.AdjustPaneSize({ "Left", 1 }) },
      { key = "l", action = action.AdjustPaneSize({ "Right", 1 }) },
      { key = "k", action = action.AdjustPaneSize({ "Up", 1 }) },
      { key = "Escape", action = "PopKeyTable" },
      { key = "Enter", action = "PopKeyTable" },
    },
    copy = {
      { key = "b", action = action.EmitEvent("copy-buffer-from-pane") },
      { key = "p", action = action.EmitEvent("copy-text-from-pane") },
      { key = "l", action = M.copy_line_action() },
      { key = "r", action = M.copy_regex_action() },
      { key = "u", action = M.open_url_action() },
      { key = "Escape", action = "PopKeyTable" },
      { key = "Enter", action = "PopKeyTable" },
    },
  }
end

function M.copy_line_action()
  local action = wezterm.action
  return action.QuickSelectArgs({
    label = "COPY LINE",
    patterns = { "^.*\\S+.*$" },
    scope_lines = 1,
    action = action.Multiple({
      action.CopyTo("ClipboardAndPrimarySelection"),
      action.ClearSelection,
    }),
  })
end

function M.copy_regex_action()
  local action = wezterm.action
  return action.QuickSelectArgs({
    label = "COPY REGEX",
    patterns = {
      "(\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}(?:/\\d{1,2})?)", -- IP addresses
      "([0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2})", -- MAC
      "([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\\.[a-zA-Z0-9_-]+)", -- Email
      "([0-9a-f]{7,40})", -- Git hashes
      "((?:https?://|git@|git://|ssh://|ftp://|file://)[\\w\\d\\.\\_\\-@:/~]+(?:\\?[\\w\\d\\-\\.%&=]*)?)", -- URLs
    },
    action = action.Multiple({
      action.CopyTo("ClipboardAndPrimarySelection"),
      action.ClearSelection,
    }),
  })
end

function M.open_url_action()
  local action = wezterm.action
  return action.QuickSelectArgs({
    label = "OPEN URL",
    patterns = {
      "((?:https?://|git@|git://|ssh://|ftp://|file://)[\\w\\d\\.\\_\\-@:/~]+(?:\\?[\\w\\d\\-\\.%&=]*)?)",
    },
    action = wezterm.action_callback(function(window, pane)
      local url = window:get_selection_text_for_pane(pane)
      wezterm.open_with(url)
    end),
  })
end

function M.activate_table(name)
  local action = wezterm.action
  return action.ActivateKeyTable({
    name = name,
    one_shot = false,
    until_unknown = name ~= "move",
    timeout_milliseconds = TIMEOUT.key,
  })
end

function M.rename_tab_prompt()
  local action = wezterm.action
  return action.PromptInputLine({
    description = "Rename tab:",
    action = wezterm.action_callback(function(window, _, line)
      if line then
        window:active_tab():set_title(line)
      end
    end),
  })
end

function M.rename_workspace_prompt()
  local action = wezterm.action
  return action.PromptInputLine({
    description = "Rename workspace:",
    action = wezterm.action_callback(function(_, _, line)
      if line then
        local mux = wezterm.mux
        mux.rename_workspace(mux.get_active_workspace(), line)
      end
    end),
  })
end

function M.split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == "resize" and "CTRL|SHIFT" or "CTRL",
    action = wezterm.action_callback(function(win, pane)
      if helpers.is_vim(pane) then
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

return M
