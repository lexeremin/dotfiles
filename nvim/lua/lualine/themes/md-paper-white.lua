local c = {
  bg      = "#CCCCCC",
  fg      = "#474747",
  faint   = "#B8B8B8",
  subtle  = "#868686",
  primary = "#6B9AB8",
  success = "#8BAD79",
  warning = "#B89868",
  error   = "#C4607A",
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
