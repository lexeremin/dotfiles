local c = {
  bg      = "#282828",
  fg      = "#ebdbb2",
  faint   = "#3c3836",
  subtle  = "#928374",
  primary = "#fabd2f",
  success = "#b8bb26",
  warning = "#fe8019",
  error   = "#fb4934",
}

return {
  normal = {
    a = { fg = c.bg, bg = c.primary, gui = "bold" },
    b = { fg = c.fg, bg = c.faint },
    c = { fg = c.subtle, bg = c.bg },
  },
  insert = {
    a = { fg = c.bg, bg = c.success, gui = "bold" },
    b = { fg = c.fg, bg = c.faint },
    c = { fg = c.subtle, bg = c.bg },
  },
  visual = {
    a = { fg = c.bg, bg = c.warning, gui = "bold" },
    b = { fg = c.fg, bg = c.faint },
    c = { fg = c.subtle, bg = c.bg },
  },
  replace = {
    a = { fg = c.bg, bg = c.error, gui = "bold" },
    b = { fg = c.fg, bg = c.faint },
    c = { fg = c.subtle, bg = c.bg },
  },
  command = {
    a = { fg = c.bg, bg = c.fg, gui = "bold" },
    b = { fg = c.fg, bg = c.faint },
    c = { fg = c.subtle, bg = c.bg },
  },
  inactive = {
    a = { fg = c.subtle, bg = c.bg },
    b = { fg = c.subtle, bg = c.bg },
    c = { fg = c.subtle, bg = c.bg },
  },
}
