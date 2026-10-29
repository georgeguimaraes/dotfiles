-- Ported from ~/.config/wezterm/config/keybindings.lua
local TERMINAL = "com.superlogical.terminal"
local LEADER = "ctrl+\\"

local function is_vim(ctx)
  local p = rex.block.call(TERMINAL, "process", { block_id = ctx.block_id })
  local fg = p and p.foreground
  if not fg then
    return false
  end
  return fg.name == "nvim" or fg.name == "vim" or fg.argv0 == "nvim" or fg.argv0 == "vim"
end

local function write(ctx, data)
  rex.block.call(TERMINAL, "write", { block_id = ctx.block_id, data = data })
end

-- Custom actions

rex.action({
  name = "open_config",
  title = "Open Rex Config in nvim",
  run = function()
    local w, err = rex.session.new_window({
      layout = rex.layout.block({
        flavor = "com.superlogical.terminal.shell",
        options = { command = { "/bin/zsh", "-lc", "nvim ~/.config/rex/init.lua" } },
      }),
    })
    if err ~= nil then
      error(err, 0)
    end
    return { window_id = w.window_id }
  end,
})

rex.action({
  name = "open_in_finder",
  title = "Open Pane Directory in Finder",
  run = function(ctx)
    local p, err = rex.block.call(TERMINAL, "process", { block_id = ctx.block_id })
    if p == nil then
      error(err, 0)
    end
    rex.exec({ "open", (p.foreground and p.foreground.cwd) or os.getenv("HOME") })
  end,
})

-- Splits, zoom, close

rex.bind("cmd+shift+d", "pane.split", { direction = "right" })
rex.bind("cmd+d", "pane.split", { direction = "down" })
rex.bind("cmd+z", "pane.zoom")
rex.bind("cmd+w", "pane.close")
rex.bind("cmd+shift+w", "client.tab.close")
rex.bind("cmd+k", "com.superlogical.terminal.clear")

-- Tabs

rex.bind("cmd+[", "client.tab.previous")
rex.bind("cmd+]", "client.tab.next")
rex.bind("cmd+shift+[", "client.tab.move.backward")
rex.bind("cmd+shift+]", "client.tab.move.forward")

-- Palette, search, config, Finder

rex.bind("cmd+p", "client.palette.toggle")
rex.bind("cmd+/", "client.find.open")
rex.bind("cmd+,", "client.settings")
rex.bind("cmd+shift+,", "open_config")
rex.bind("cmd+o", "open_in_finder")

-- Shell line editing

rex.bind("shift+enter", function(ctx)
  write(ctx, "\27\r")
  return true
end)
rex.bind("alt+left", "pane.send_key", { key = "alt+b" })
rex.bind("alt+right", "pane.send_key", { key = "alt+f" })
rex.bind("cmd+left", "pane.send_key", { key = "ctrl+a" })
rex.bind("cmd+right", "pane.send_key", { key = "ctrl+e" })
rex.bind("cmd+backspace", "pane.send_key", { key = "ctrl+u" })

-- nvim helpers (no-op outside nvim)

rex.bind("cmd+s", function(ctx)
  if not is_vim(ctx) then
    return false
  end
  write(ctx, "\27:w\r")
  return true
end)

rex.bind("cmd+a", function(ctx)
  if not is_vim(ctx) then
    return false
  end
  write(ctx, "\27ggVG")
  return true
end)

-- ctrl+hjkl: move between panes, or let nvim handle it

for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  rex.bind("ctrl+" .. key, function(ctx)
    if is_vim(ctx) then
      return false
    end
    rex.session.focus_direction({ direction = direction })
    return true
  end)
end

-- Leader (ctrl+\) sequences

rex.bind(LEADER .. ">o", "open_in_finder")
rex.bind(LEADER .. ">h", "client.palette.toggle")
rex.bind(LEADER .. ">,", "client.tab.rename")
rex.bind(LEADER .. ">shift+4", "session.rename")
rex.bind(LEADER .. ">-", "pane.split", { direction = "down" })
rex.bind(LEADER .. ">\\", "pane.split", { direction = "right" })
rex.bind(LEADER .. ">r", "client.mode.enter", { name = "resize" })

-- Resize mode: arrows or hjkl, escape or enter to leave

rex.mode("resize", { exclusive = true })
for _, pair in ipairs({
  { "left", "left" }, { "h", "left" },
  { "down", "down" }, { "j", "down" },
  { "up", "up" }, { "k", "up" },
  { "right", "right" }, { "l", "right" },
}) do
  rex.bind("resize/" .. pair[1], "pane.resize", { direction = pair[2] })
end
rex.bind("resize/=", "pane.balance")
rex.bind("resize/enter", "client.mode.exit")
