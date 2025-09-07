return {
  "nvim-neorg/neorg",
  lazy = true,
  ft = "norg",
  version = "*", -- Pin Neorg to the latest stable release
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "/Users/devalex/Library/Mobile Documents/com~apple~CloudDocs/Notes",
            },
            default_workspace = "notes",
          },
        },
      },
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "norg",
      callback = function()
        vim.wo.foldlevel = 99
        vim.wo.conceallevel = 2
      end,
    })
  end,
}
