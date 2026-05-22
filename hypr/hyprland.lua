-- hyprland.lua — entrypoint for the new Hyprland Lua config system (>= 0.55).
-- See: https://hypr.land/news/26_lua/
--
-- This file loads modular config under ./lua/. Each module sets keywords, binds,
-- and rules using the Hyprland-provided global helpers (hypr.keyword, hypr.bind,
-- hypr.exec_once, hypr.windowrule, hypr.monitor). API may shift across Hyprland
-- releases; if a helper name changes, patch ./lua/_compat.lua only.

package.path = (os.getenv("HOME") or "~") .. "/.config/hypr/lua/?.lua;" .. package.path

require("_compat")        -- shim any helper renames
require("env")            -- session env vars
require("monitors")
require("input")
require("decoration")
require("theme")          -- reads current-theme.lua, sets colors
require("windowrules")
require("keybinds")
require("autostart")
