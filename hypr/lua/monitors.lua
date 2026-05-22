-- Override per-machine by dropping a ~/.config/hypr/lua/monitors.local.lua
-- (gitignored) that calls hl.monitor(...) for your specific outputs.
hl.monitor(",preferred,auto,1")

local ok = pcall(require, "monitors.local")
if not ok then end -- silent fallback
