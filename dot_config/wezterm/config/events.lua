local wezterm = require("wezterm")
local helpers = require("utils.helpers")

local M = {}

function M.setup()
  wezterm.on("format-tab-title", M.format_tab_title)
  wezterm.on("update-status", M.update_status)
  wezterm.on("gui-startup", M.gui_startup)

  -- Copy operations
  wezterm.on("copy-buffer-from-pane", M.copy_buffer)
  wezterm.on("copy-text-from-pane", M.copy_text)
  wezterm.on("flash-terminal", function(window)
    M.flash_screen(window)
  end)

  -- Strip ANSI codes from pasted content
  -- DISABLED: Causes 100% CPU / flashing - see https://github.com/wezterm/wezterm/discussions/4425
  -- wezterm.on("paste", M.strip_ansi_on_paste)
end

function M.flash_screen(window)
  window:toast_notification("wezterm", "Copied to clipboard!", nil, 1000)
end

function M.format_tab_title(tab, tabs, panes, config, hover, max_width)
  local has_unseen_output = false
  if not tab.is_active then
    for _, pane in ipairs(tab.panes) do
      if pane.has_unseen_output then
        has_unseen_output = true
        break
      end
    end
  end

  -- Respect custom tab titles set via `wezterm cli set-tab-title`
  local custom_title = tab.tab_title
  if custom_title and #custom_title > 0 then
    local title = custom_title
    if tab.active_pane.is_zoomed then
      title = title .. " " .. wezterm.nerdfonts.md_alpha_z_box
    end
    if has_unseen_output then
      return {
        { Foreground = { Color = "#737aa2" } },
        { Text = title },
      }
    end
    return { { Text = title } }
  end

  -- Use pane title if it's set and not a default shell/process name
  local pane_title = tab.active_pane.title
  local process_name = string.gsub(tab.active_pane.foreground_process_name or "", "(.*[/\\])(.*)", "%2"):lower()

  -- Ignore default titles (shell names, process names, empty)
  local dominated_titles = { "zsh", "bash", "sh", "fish", "" }
  local dominated_title = false
  for _, name in ipairs(dominated_titles) do
    if pane_title == name or pane_title:lower() == process_name then
      dominated_title = true
      break
    end
  end

  if pane_title and #pane_title > 0 and not dominated_title then
    local cwd = helpers.get_cwd_from_pane(tab.active_pane.pane_id) or helpers.get_current_working_dir(tab) or ""

    -- Check if Claude is in foreground to reformat title
    local pane = wezterm.mux.get_pane(tab.active_pane.pane_id)
    local is_claude = false
    if pane then
      local ok, info = pcall(function() return pane:get_foreground_process_info() end)
      if ok and info and info.executable then
        is_claude = info.executable:lower():find("claude") ~= nil
      end
    end

    local title
    if is_claude then
      -- Extract emoji prefix and move it to front: "✳ Some Title" -> "✳ cwd: Some Title"
      -- Check for ✳ specifically (3 bytes in UTF-8)
      local prefix = pane_title:sub(1, 5) -- "✳ " is 3 bytes + space + maybe more
      if prefix:sub(1, 3) == "✳" then
        local rest = pane_title:sub(4):gsub("^%s*", "") -- remove leading space
        title = "✳ " .. cwd .. ": " .. rest
      else
        title = (#cwd > 0) and (cwd .. ": " .. pane_title) or pane_title
      end
    else
      title = (#cwd > 0) and (cwd .. ": " .. pane_title) or pane_title
    end
    if tab.active_pane.is_zoomed then
      title = title .. " " .. wezterm.nerdfonts.md_alpha_z_box
    end
    if has_unseen_output then
      return {
        { Foreground = { Color = "#737aa2" } },
        { Text = title },
      }
    end
    return { { Text = title } }
  end

  local title = string.format("%s   %s", helpers.get_process(tab), helpers.get_current_working_dir(tab))

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
end

function M.update_status(window, pane)
  local key_table = window:active_key_table()
  if key_table == "copy_mode" or key_table == "copy" then
    window:set_right_status(wezterm.format({
      { Foreground = { Color = "#bb9af7" } },
      { Background = { Color = "#222436" } },
      { Text = wezterm.nerdfonts.oct_copy .. "  COPY  " },
    }))
  elseif key_table == "resize" then
    window:set_right_status(wezterm.format({
      { Foreground = { Color = "#82aaff" } },
      { Background = { Color = "#222436" } },
      { Text = wezterm.nerdfonts.md_resize .. "  RESIZE  " },
    }))
  else
    window:set_right_status("")
  end
end

function M.gui_startup(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():set_position(120, 110)
end

function M.copy_buffer(window, pane)
  local text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)
  window:copy_to_clipboard(text)
  M.flash_screen(window)
end

function M.copy_text(window, pane)
  local text = pane:get_lines_as_text(pane:get_dimensions().viewport_rows)
  window:copy_to_clipboard(text)
  M.flash_screen(window)
end

function M.strip_ansi_on_paste(window, pane)
  local clipboard = window:get_clipboard("Clipboard")
  if not clipboard or clipboard == "" then
    return clipboard
  end

  -- Strip ANSI escape codes (colors, formatting, cursor movements)
  local cleaned = clipboard:gsub("\x1b%[[0-9;]*[mGKHJABCDsuhlf]", "")
  -- Also strip carriage returns that can cause line overwrites
  cleaned = cleaned:gsub("\r", "")

  return cleaned
end

return M
