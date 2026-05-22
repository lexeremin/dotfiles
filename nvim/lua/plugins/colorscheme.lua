return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {},
    init = function() vim.o.background = "light" end,
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "serika" },
  },
}
