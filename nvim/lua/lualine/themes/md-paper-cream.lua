local c = {
  bg      = "#E0DBD3",
  fg      = "#58534C",
  faint   = "#C8C3BB",
  subtle  = "#857F78",
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
