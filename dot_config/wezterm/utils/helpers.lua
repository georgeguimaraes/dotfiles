local wezterm = require("wezterm")

local M = {}

M.process_icons = {
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
    { Text = "" },
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

M.direction_keys = {
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

function M.extract_dir_name(file_path)
  if not file_path then return nil end
  local home = os.getenv("HOME")
  if file_path == home or file_path == home .. "/" then
    return "~"
  end
  return file_path:gsub("/$", ""):match("([^/]+)$")
end

function M.get_cwd_from_pane(pane_id)
  local pane = wezterm.mux.get_pane(pane_id)
  if not pane then return nil end

  local ok, pane_cwd = pcall(function() return pane:get_current_working_dir() end)
  if not ok or not pane_cwd then return nil end

  local file_path = type(pane_cwd) == "string" and pane_cwd:gsub("^file://", "") or pane_cwd.file_path
  return M.extract_dir_name(file_path)
end

function M.get_current_working_dir(tab)
  local current_dir = tab.active_pane.current_working_dir
  if not current_dir or not current_dir.file_path then
    return "~"
  end
  return M.extract_dir_name(current_dir.file_path) or "~"
end

function M.get_process(tab)
  local process_name = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")
  process_name = string.lower(process_name)
  if string.find(process_name, "kubectl") then
    process_name = "kubectl"
  end

  return wezterm.format(M.process_icons[process_name] or { { Text = string.format("%s:", process_name) } })
end

function M.is_vim(pane)
  local process_info = pane:get_foreground_process_info()
  local process_name = process_info and process_info.name

  return process_name == "nvim" or process_name == "vim"
end

return M
