return {
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts.presets.lsp_doc_border = true
    end,
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    main = "bufferline",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function(_, opts)
      local ok, bufferline = pcall(require, "bufferline")
      if not ok then
        return
      end
      local success = pcall(bufferline.setup, opts)
      if not success and opts and opts.options then
        local cloned = vim.tbl_deep_extend("force", {}, opts)
        cloned.options.mode = nil
        pcall(bufferline.setup, cloned)
      end
    end,
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = {
      options = {
        mode = "tabs",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },
  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "serika",
      },
    },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("refactoring").setup()
    end,
  },
  {
    "folke/twilight.nvim",
    cmd = "Twilight",
    keys = {
      { "tw", "<cmd>Twilight<cr>", desc = "Twilight toggle" },
    },
  },
}
