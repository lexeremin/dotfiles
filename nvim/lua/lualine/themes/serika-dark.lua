local c = {
  bg      = "#323437",
  fg      = "#D1D0C5",
  faint   = "#2C2E31",
  subtle  = "#646669",
  primary = "#E2B714",
  success = "#78A852",
  warning = "#D4A332",
  error   = "#CA4754",
}

return {
  normal = {
    a = { fg = c.faint, bg = c.primary, gui = "bold" },
    b = { fg = c.fg,    bg = c.faint },
    c = { fg = c.subtle, bg = c.bg },
  },
  insert = {
    a = { fg = c.faint, bg = c.success, gui = "bold" },
    b = { fg = c.fg,    bg = c.faint },
    c = { fg = c.subtle, bg = c.bg },
  },
  visual = {
    a = { fg = c.faint, bg = c.warning, gui = "bold" },
    b = { fg = c.fg,    bg = c.faint },
    c = { fg = c.subtle, bg = c.bg },
  },
  replace = {
    a = { fg = c.faint, bg = c.error, gui = "bold" },
    b = { fg = c.fg,    bg = c.faint },
    c = { fg = c.subtle, bg = c.bg },
  },
  command = {
    a = { fg = c.faint, bg = c.fg, gui = "bold" },
    b = { fg = c.fg,    bg = c.faint },
    c = { fg = c.subtle, bg = c.bg },
  },
  inactive = {
    a = { fg = c.subtle, bg = c.bg },
    b = { fg = c.subtle, bg = c.bg },
    c = { fg = c.subtle, bg = c.bg },
  },
}
