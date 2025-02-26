-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- Set defalt line numbers
vim.o.relativenumber = true
vim.wo.number = true
-- Set history search highlight
vim.o.hlsearch = true

-- Set colorscheme
--vim.cmd.colorscheme = "catppuccin-mocha"
--vim.cmd.colorscheme = "catppuccin-mocha"
vim.o.completeopt = "menuone,noselect"

vim.o.mouse = ""

vim.o.undofile = true

vim.o.breakindent = true

vim.opt.clipboard = "unnamedplus"

vim.o.ignorecase = true
vim.o.smartcase = true

-- Disable the concealing in some file formants
-- default conceallevel is 3
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "markdown" },
  callback = function()
    vim.wo.conceallevel = 0
  end,
})
