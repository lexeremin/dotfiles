-- Reads ~/.config/hypr/current-theme.lua (written by setup-rice.sh) and applies
-- border colors. The theme file is expected to return a table:
--   { active = "0xff......", inactive = "0xff......", primary = "0xff......" }
local theme = { active = "0xff888888", inactive = "0xff444444", primary = "0xffaaaaaa" }
local ok, t = pcall(dofile, (os.getenv("HOME") or "~") .. "/.config/hypr/current-theme.lua")
if ok and type(t) == "table" then
  for k, v in pairs(t) do theme[k] = v end
end

hl.keyword("general:col.active_border",   theme.active)
hl.keyword("general:col.inactive_border", theme.inactive)
hl.keyword("group:col.border_active",     theme.primary)
hl.keyword("group:col.border_inactive",   theme.inactive)
