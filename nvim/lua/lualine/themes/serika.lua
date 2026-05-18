local c = {
  bg      = "#E1E1E3",
  fg      = "#323437",
  faint   = "#D1D3D8",
  subtle  = "#AAAEB3",
  primary = "#E2B714",
  success = "#6B9AB8",
  warning = "#C08030",
  error   = "#DA3333",
}

return {
  normal = {
    a = { fg = c.fg, bg = c.primary, gui = "bold" },
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
    a = { fg = c.fg, bg = c.fg, gui = "bold" },
    b = { fg = c.fg, bg = c.faint },
    c = { fg = c.subtle, bg = c.bg },
  },
  inactive = {
    a = { fg = c.subtle, bg = c.bg },
    b = { fg = c.subtle, bg = c.bg },
    c = { fg = c.subtle, bg = c.bg },
  },
}
