return {
  -- {
  --   "catppuccin/nvim",
  --   --"folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   name = "catppuccin",
  --   --name = "tokyonight",
  --   opts = {
  --     transparent_background = true,
  --   },
  -- },
  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = "catppuccin-mocha",
  --     --colorscheme = "tokyonight",
  --   },
  -- },
  {
    "e-ink-colorscheme/e-ink.nvim",
    name = "e-ink",
    priority = 1000,
    config = function()
      require("e-ink").setup()
      vim.cmd.colorscheme("e-ink")

      -- choose light mode or dark mode
      -- vim.opt.background = "dark"
      vim.opt.background = "light"
      --
      -- or do
      -- :set background=dark
      -- :set background=light
    end,
  },
}
