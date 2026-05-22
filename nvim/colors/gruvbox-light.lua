-- Thin wrapper around ellisonleao/gruvbox.nvim
vim.opt.background = "light"
local ok, gruvbox = pcall(require, "gruvbox")
if ok then
  gruvbox.setup({ contrast = "", italic = { strings = false, comments = true } })
end
vim.cmd.colorscheme("gruvbox")
vim.g.colors_name = "gruvbox-light"
