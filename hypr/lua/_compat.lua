-- _compat.lua — defensive shim around the Hyprland Lua API.
-- Exposes a single global `hl` table; modules use it instead of touching the
-- raw API. If Hyprland renames helpers, only this file needs to change.

local M = {}

-- Try the conventional global helpers first (per hypr.land/news/26_lua/).
-- Fall back to a `hyprland` module if Hyprland exposes one.
local hypr = rawget(_G, "hypr") or rawget(_G, "hyprland")
if not hypr then
  local ok, mod = pcall(require, "hyprland")
  if ok then hypr = mod end
end

local function call(name, ...)
  if type(hypr) == "table" and type(hypr[name]) == "function" then
    return hypr[name](...)
  end
  -- Fall back to top-level globals (some bindings expose them flat).
  local fn = rawget(_G, name)
  if type(fn) == "function" then return fn(...) end
  io.stderr:write(("[hypr-lua] missing helper: %s\n"):format(name))
end

function M.keyword(k, v)        call("keyword", k, v) end
function M.exec_once(cmd)       call("exec_once", cmd) end
function M.exec(cmd)            call("exec", cmd) end
function M.bind(mods, key, dispatcher, arg)
  if arg == nil then call("bind", mods, key, dispatcher)
  else call("bind", mods, key, dispatcher, arg) end
end
function M.bindl(mods, key, dispatcher, arg)
  if arg == nil then call("bindl", mods, key, dispatcher)
  else call("bindl", mods, key, dispatcher, arg) end
end
function M.bindle(mods, key, dispatcher, arg)
  if arg == nil then call("bindle", mods, key, dispatcher)
  else call("bindle", mods, key, dispatcher, arg) end
end
function M.windowrule(rule, match) call("windowrule", rule, match) end
function M.monitor(spec)        call("monitor", spec) end

_G.hl = M
return M
