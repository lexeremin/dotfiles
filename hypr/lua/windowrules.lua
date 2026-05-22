-- Float dialogs, picker, auth prompts.
hl.windowrule("float", "class:^(pavucontrol|blueman-manager|nm-connection-editor)$")
hl.windowrule("float", "class:^(xdg-desktop-portal-gtk)$")
hl.windowrule("float", "class:^(org.gnome.Calculator)$")
hl.windowrule("float", "title:^(Picture-in-Picture)$")
hl.windowrule("pin",   "title:^(Picture-in-Picture)$")
hl.windowrule("size 800 600", "class:^(pavucontrol)$")

-- Suppress maximize anim for fullscreen apps.
hl.windowrule("immediate", "class:^(steam_app_).*")
