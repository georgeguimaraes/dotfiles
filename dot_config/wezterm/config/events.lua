local wezterm = require("wezterm")
local helpers = require("utils.helpers")

local M = {}

function M.setup()
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

  wezterm.on("gui-startup", function(cmd)
    local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
    window:gui_window():set_position(120, 110)
  end)
end

return M
