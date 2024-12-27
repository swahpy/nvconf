return {

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    opts = require "configs.treesitter",
  },

  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "echasnovski/mini.splitjoin",
    version = false,
    event = "BufRead",
    config = function()
      require("mini.splitjoin").setup {
        mappings = {
          toggle = "gS",
          split = "gs",
          join = "gj",
        },
      }
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        "hrsh7th/cmp-cmdline",
        event = "CmdlineEnter",
        config = function()
          local cmp = require "cmp"

          cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = { { name = "buffer" } },
          })
        end,
      },
    },

    config = function(_, opts)
      local options = require "configs.nvim-cmp"
      local cmp = require "cmp"
      cmp.setup(vim.tbl_extend("force", opts, options))
    end,
  },

  {
    "kawre/neotab.nvim",
    event = "InsertCharPre",
    config = true,
  },
}
