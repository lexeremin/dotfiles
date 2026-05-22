-- Mac-style keybinds. Super = Cmd, Super+Alt = Cmd+Option, Super+Ctrl = Cmd+Ctrl.
-- Screenshots saved to ~/Pictures/Screenshots/.

local MOD       = "SUPER"
local MOD_SHIFT = "SUPER SHIFT"
local MOD_CTRL  = "SUPER CTRL"
local MOD_ALT   = "SUPER ALT"

local TERM    = "ghostty"
local LAUNCH  = "fuzzel"
local BROWSER = "firefox"
local FILES   = "thunar"

local SHOT_DIR = "~/Pictures/Screenshots"
local SHOT_NAME = "$(date +%Y-%m-%d_%H-%M-%S).png"

-- ── Apps ─────────────────────────────────────────────────────────────────────
hl.bind(MOD,       "Return", "exec", TERM)
hl.bind(MOD,       "Space",  "exec", LAUNCH)
hl.bind(MOD,       "B",      "exec", BROWSER)
hl.bind(MOD,       "E",      "exec", FILES)
hl.bind(MOD_SHIFT, "V",      "exec", "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy")

-- ── Window management ────────────────────────────────────────────────────────
hl.bind(MOD,       "Q",     "killactive")
hl.bind(MOD,       "W",     "killactive")
hl.bind(MOD,       "F",     "fullscreen")
hl.bind(MOD,       "T",     "togglefloating")
hl.bind(MOD,       "P",     "pseudo")
hl.bind(MOD,       "J",     "togglesplit")
hl.bind(MOD,       "Tab",   "cyclenext")
hl.bind(MOD_SHIFT, "Tab",   "cyclenext", "prev")
hl.bind(MOD,       "grave", "cyclenext", "same_class")
hl.bind(MOD,       "M",     "togglespecialworkspace", "magic")
hl.bind(MOD_SHIFT, "M",     "movetoworkspace", "special:magic")
hl.bind(MOD,       "H",     "togglespecialworkspace", "magic")

-- ── Focus (vim arrows) ───────────────────────────────────────────────────────
hl.bind(MOD, "left",  "movefocus", "l")
hl.bind(MOD, "right", "movefocus", "r")
hl.bind(MOD, "up",    "movefocus", "u")
hl.bind(MOD, "down",  "movefocus", "d")

-- ── Move ─────────────────────────────────────────────────────────────────────
hl.bind(MOD_SHIFT, "left",  "movewindow", "l")
hl.bind(MOD_SHIFT, "right", "movewindow", "r")
hl.bind(MOD_SHIFT, "up",    "movewindow", "u")
hl.bind(MOD_SHIFT, "down",  "movewindow", "d")

-- ── Workspaces (Cmd+1..9) ────────────────────────────────────────────────────
for i = 1, 9 do
  hl.bind(MOD,       tostring(i), "workspace",       tostring(i))
  hl.bind(MOD_SHIFT, tostring(i), "movetoworkspace", tostring(i))
end
hl.bind(MOD, "0", "workspace", "10")
hl.bind(MOD_SHIFT, "0", "movetoworkspace", "10")

-- Cmd+Ctrl+left/right — adjacent workspace (mac mission control)
hl.bind(MOD_CTRL, "right", "workspace", "e+1")
hl.bind(MOD_CTRL, "left",  "workspace", "e-1")

-- ── Screenshots (Cmd+Shift+3/4/5) ────────────────────────────────────────────
hl.bind(MOD_SHIFT, "3", "exec",
  ("mkdir -p %s && grim %s/%s"):format(SHOT_DIR, SHOT_DIR, SHOT_NAME))
hl.bind(MOD_SHIFT, "4", "exec",
  ("mkdir -p %s && grim -g \"$(slurp)\" %s/%s"):format(SHOT_DIR, SHOT_DIR, SHOT_NAME))
hl.bind(MOD_SHIFT, "5", "exec",
  ("mkdir -p %s && grim -g \"$(slurp)\" - | swappy -f -"):format(SHOT_DIR))

-- ── Lock + session ───────────────────────────────────────────────────────────
hl.bind(MOD_CTRL,  "Q", "exec", "hyprlock")
hl.bind(MOD_ALT,   "Q", "exit")

-- ── Media / brightness / volume (Fn keys) ────────────────────────────────────
hl.bindel("", "XF86AudioRaiseVolume",  "exec", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")
hl.bindel("", "XF86AudioLowerVolume",  "exec", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
hl.bindl("",  "XF86AudioMute",         "exec", "wpctl set-mute   @DEFAULT_AUDIO_SINK@ toggle")
hl.bindl("",  "XF86AudioMicMute",      "exec", "wpctl set-mute   @DEFAULT_AUDIO_SOURCE@ toggle")
hl.bindl("",  "XF86AudioPlay",         "exec", "playerctl play-pause")
hl.bindl("",  "XF86AudioNext",         "exec", "playerctl next")
hl.bindl("",  "XF86AudioPrev",         "exec", "playerctl previous")
hl.bindel("", "XF86MonBrightnessUp",   "exec", "brightnessctl set 5%+")
hl.bindel("", "XF86MonBrightnessDown", "exec", "brightnessctl set 5%-")

-- ── Mouse ────────────────────────────────────────────────────────────────────
hl.bind(MOD, "mouse:272", "movewindow")
hl.bind(MOD, "mouse:273", "resizewindow")
