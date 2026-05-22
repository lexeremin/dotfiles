local c = {
  bg    = "#F2EDE8",
  faint = "#D4D0CA",
  ink5  = "#B8B4AE",
  ink4  = "#9C9892",
  ink3  = "#7A7672",
  ink2  = "#5A5652",
  ink1  = "#3E3B36",
  ink0  = "#2C2926",
}

return {
  normal = {
    a = { fg = c.bg,   bg = c.ink0,  gui = "bold" },
    b = { fg = c.ink0, bg = c.faint },
    c = { fg = c.ink4, bg = c.bg },
  },
  insert = {
    a = { fg = c.bg,   bg = c.ink1,  gui = "bold" },
    b = { fg = c.ink0, bg = c.faint },
    c = { fg = c.ink4, bg = c.bg },
  },
  visual = {
    a = { fg = c.bg,   bg = c.ink2,  gui = "bold" },
    b = { fg = c.ink0, bg = c.faint },
    c = { fg = c.ink4, bg = c.bg },
  },
  replace = {
    a = { fg = c.bg,   bg = c.ink3,  gui = "bold" },
    b = { fg = c.ink0, bg = c.faint },
    c = { fg = c.ink4, bg = c.bg },
  },
  command = {
    a = { fg = c.bg,   bg = c.ink0,  gui = "bold" },
    b = { fg = c.ink0, bg = c.faint },
    c = { fg = c.ink4, bg = c.bg },
  },
  inactive = {
    a = { fg = c.ink5, bg = c.bg },
    b = { fg = c.ink5, bg = c.bg },
    c = { fg = c.ink5, bg = c.bg },
  },
}
