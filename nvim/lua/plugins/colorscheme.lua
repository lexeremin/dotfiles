return {
  {
    "catppuccin/nvim",
    --"folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
    name = "catppuccin",
    --name = "tokyonight",
    opts = {
      transparent_background = true,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
      --colorscheme = "tokyonight",
    },
  },
}
