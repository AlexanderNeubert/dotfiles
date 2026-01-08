local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

local config = wezterm.config_builder()

config.term = "xterm-256color"

config.color_scheme = "Tokyo Night Storm (Gogh)"

config.font = wezterm.font("CaskaydiaMono Nerd Font")
config.font_size = 12
config.window_background_opacity = 0.9
config.macos_window_background_blur = 10
config.window_decorations = "RESIZE"
config.enable_tab_bar = true

config.window_padding = {
	top = 10,
	bottom = 10,
	left = 10,
	right = 10,
}

-- Plugin: bar.wezterm
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
bar.apply_to_config(config)

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }

local action = wezterm.action

config.keys = {
	{
		key = "\\",
		mods = "LEADER",
		action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "-",
		mods = "LEADER",
		action = action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "h",
		mods = "CMD",
		action = action.ActivatePaneDirection("Left"),
	},
	{
		key = "j",
		mods = "CMD",
		action = action.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "CMD",
		action = action.ActivatePaneDirection("Up"),
	},
	{
		key = "l",
		mods = "CMD",
		action = action.ActivatePaneDirection("Right"),
	},
	{
		key = "h",
		mods = "CMD|SHIFT",
		action = action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "l",
		mods = "CMD|SHIFT",
		action = action.AdjustPaneSize({ "Right", 5 }),
	},
	{
		key = "j",
		mods = "CMD|SHIFT",
		action = action.AdjustPaneSize({ "Down", 5 }),
	},
	{
		key = "k",
		mods = "CMD|SHIFT",
		action = action.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "m",
		mods = "LEADER",
		action = action.TogglePaneZoomState,
	},
	{
		key = "[",
		mods = "LEADER",
		action = action.ActivateCopyMode,
	},
	{
		key = "c",
		mods = "LEADER",
		action = action.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "p",
		mods = "LEADER",
		action = action.ActivateTabRelative(-1),
	},
	{
		key = "n",
		mods = "LEADER",
		action = action.ActivateTabRelative(1),
	},
	{
		key = "b",
		mods = "LEADER",
		action = action.RotatePanes("CounterClockwise"),
	},
	{ key = "n", mods = "LEADER", action = action.RotatePanes("Clockwise") },
	{
		key = "s",
		mods = "CMD",
		action = action.PaneSelect({
			mode = "SwapWithActive",
		}),
	},
}

for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = action.ActivateTab(i - 1),
	})
end

return config
