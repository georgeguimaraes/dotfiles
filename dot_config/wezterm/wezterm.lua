local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.audible_bell = "Disabled"
config.visual_bell = {
	fade_in_duration_ms = 75,
	fade_out_duration_ms = 75,
	target = "BackgroundColor",
}
config.term = "wezterm"
config.color_scheme = "Tokyo Night Moon"
-- config.font = wezterm.font("FiraCodeGG Nerd Font", { weight = "Medium" })
config.font = wezterm.font("Iosevka GG", { stretch = "Expanded", weight = "Medium" })
-- config.font = wezterm.font("Victor Mono", { weight = "Medium" })
-- config.font = wezterm.font("MonoLisa", { weight = "Regular" })
config.font_size = 16
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.enable_kitty_keyboard = true
config.window_decorations = "RESIZE"
config.window_background_opacity = 1
-- config.macos_window_background_blur = 20
config.initial_cols = 140
config.initial_rows = 40
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
	font_size = 15,
	active_titlebar_bg = "#222436",
}
config.colors = {
	visual_bell = "#1e2030",
	tab_bar = {
		active_tab = {
			bg_color = "#222436",
			fg_color = "#82aaff",
		},
		inactive_tab = {
			bg_color = "#1e2030",
			fg_color = "#545c7e",
		},
		new_tab = {
			bg_color = "#191b28",
			fg_color = "#82aaff",
		},
		new_tab_hover = {
			bg_color = "#82aaff",
			fg_color = "#1e2030",
		},
		inactive_tab_hover = {
			bg_color = "#1e2030",
			fg_color = "#82aaff",
		},
	},
}

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
	-- this is set by the plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == "true"
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

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "META|CTRL" or "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "META|CTRL" or "CTRL" },
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

local action = wezterm.action
config.keys = {
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
	{
		mods = "CMD",
		key = "d",
		action = action.SplitHorizontal,
	},
	{
		mods = "CMD|SHIFT",
		key = "d",
		action = action.SplitVertical,
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
			cwd = os.getenv("WEZTERM_CONFIG_DIR"),
			args = {
				"/opt/homebrew/bin/nvim",
				os.getenv("WEZTERM_CONFIG_FILE"),
			},
		}),
	},
	{ mods = "OPT", key = "LeftArrow", action = action.SendKey({ mods = "ALT", key = "b" }) },
	{ mods = "OPT", key = "RightArrow", action = action.SendKey({ mods = "ALT", key = "f" }) },
	{ mods = "CMD", key = "LeftArrow", action = action.SendKey({ mods = "CTRL", key = "a" }) },
	{ mods = "CMD", key = "RightArrow", action = action.SendKey({ mods = "CTRL", key = "e" }) },
	{ mods = "CMD", key = "Backspace", action = action.SendKey({ mods = "CTRL", key = "u" }) },
}

local process_icons = {
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
		{ Text = wezterm.nerdfonts.custom_vim },
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
	local current_dir = tab.active_pane.current_working_dir
	local HOME_DIR = string.format("file://%s", os.getenv("HOME"))

	if current_dir == HOME_DIR then
		return "~"
	end

	return string.gsub(current_dir, "(.*[/\\])(.*)", "%2")
end

local function get_process(tab)
	local process_name = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")
	if string.find(process_name, "kubectl") then
		process_name = "kubectl"
	end

	return wezterm.format(process_icons[process_name] or { { Text = string.format("%s:", process_name) } })
end

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

	local title = string.format("%s  %s", get_process(tab), get_current_working_dir(tab))

	if tab.active_pane.is_zoomed then
		title = title .. " " .. wezterm.nerdfonts.md_alpha_z_box
	end

	if has_unseen_output then
		return {
			{ Foreground = { Color = "#bb9af7" } },
			{ Text = title },
		}
	end

	return {
		{ Text = title },
	}
end)

return config