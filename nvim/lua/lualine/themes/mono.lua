local c = {
  bg     = "#E8E8E8",
  fg     = "#1E1E1E",
  faint  = "#CDCDCD",
  subtle = "#666666",
  mid    = "#3C3C3C",
}

return {
  normal = {
    a = { fg = c.bg, bg = c.fg, gui = "bold" },
    b = { fg = c.fg, bg = c.faint },
    c = { fg = c.subtle, bg = c.bg },
  },
  insert = {
    a = { fg = c.bg, bg = c.mid, gui = "bold" },
    b = { fg = c.fg, bg = c.faint },
    c = { fg = c.subtle, bg = c.bg },
  },
  visual = {
    a = { fg = c.bg, bg = c.subtle, gui = "bold" },
    b = { fg = c.fg, bg = c.faint },
    c = { fg = c.subtle, bg = c.bg },
  },
  replace = {
    a = { fg = c.bg, bg = c.mid, gui = "bold" },
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
