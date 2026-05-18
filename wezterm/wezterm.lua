-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
-- use_fancy_tab_bar = true
-- For example, changing the color scheme:
-- config.color_scheme = 'Tokyo Night Storm'
config.colors = {
  foreground    = "#58534C",
  background    = "#E0DBD3",
  cursor_bg     = "#58534C",
  cursor_border = "#58534C",
  cursor_fg     = "#E0DBD3",
  selection_bg  = "#C8C3BB",
  selection_fg  = "#58534C",
  ansi    = { "#E0DBD3", "#C4607A", "#8BAD79", "#B89868", "#6B9AB8", "#58534C", "#4E4A45", "#615C56" },
  brights = { "#615C56", "#C4607A", "#8BAD79", "#B89868", "#6B9AB8", "#58534C", "#4E4A45", "#7A756E" },
}
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 16
config.window_background_opacity = 0.9
config.macos_window_background_blur = 30
-- config.text_background_opacity = 0.9
-- UI changes
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.keys = {
	{
		key = "f",
		mods = "CTRL",
		action = wezterm.action.ToggleFullScreen,
	},
	{
		key = "'",
		mods = "CTRL",
		action = wezterm.action.ClearScrollback("ScrollbackAndViewport"),
	},
}
config.mouse_bindings = {
	-- Ctrl-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}
-- and finally, return the configuration to wezterm
return config
