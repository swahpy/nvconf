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
    "echasnovski/mini.nvim",
    version = false,
    lazy = false,
    config = function()
      require "configs.mini"
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
    opts = function(_, conf)
      conf.mapping = require "configs.nvim-cmp"
      table.insert(
        conf.sources,
        1,
        {
          name = "nvim_lsp",
          option = {
            markdown_oxide = {
              keyword_pattern = [[\(\k\| \|\/\|#\)\+]],
            },
          },
        }
      )
    end,
  },

  {
    "kawre/neotab.nvim",
    event = "InsertCharPre",
    config = true,
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      search = {
        multi_window = true,
      },
      modes = {
        -- f, t, F, T with labels
        char = {
          jump_labels = true,
        },
        search = {
          -- when `true`, flash will be activated during regular search by default.
          -- You can always toggle when searching with `require("flash").toggle()`
          enabled = true,
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  {
    "brenton-leighton/multiple-cursors.nvim",
    version = "*", -- Use the latest tagged version
    opts = {}, -- This causes the plugin setup function to be called
    keys = {
      { "<C-Down>", "<Cmd>MultipleCursorsAddDown<CR>", mode = { "n", "i", "x" }, desc = "Add cursor and move down" },
      { "<C-Up>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { "n", "i", "x" }, desc = "Add cursor and move up" },
      {
        "<C-LeftMouse>",
        "<Cmd>MultipleCursorsMouseAddDelete<CR>",
        mode = { "n", "i" },
        desc = "Add or remove cursor",
      },
      {
        "mcA",
        function()
          require("multiple-cursors").align()
        end,
        mode = { "n", "x" },
        desc = "Align cursors vertically",
      },
    },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    opts = {
      file_types = { "markdown" },
      render_modes = { "n", "c", "t" },
      heading = {
        border = true,
        icons = { " ", " ", " ", " ", " ", " " },
        signs = { "󰫎 " },
        width = "block",
        above = "",
        below = "",
      },
      code = {
        width = "block",
        above = "~",
        below = "~",
      },
      link = {
        custom = {
          web = { pattern = "^http[s]?://", icon = " ", highlight = "Blue" },
          python = { pattern = "%.py$", icon = "󰌠 ", highlight = "Green" },
          local_file = { pattern = "%.md$", icon = "󱅷 ", highlight = "Aqua" },
        },
      },
    },
    keys = {
      { "<leader>rm", [[ <cmd> RenderMarkdown <cr> ]], desc = "Render Markdown file" },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    opts = function(_, conf)
      conf.defaults.mappings.i = {
        ["<A-j>"] = "move_selection_next",
        ["<A-k>"] = "move_selection_previous",
      }
      return conf
    end,
  },

  {
    "mbbill/undotree",
    init = function()
      vim.g.undotree_ShortIndicators = 1
      vim.g.undotree_DiffAutoOpen = 0
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
    keys = {
      { "<leader>ut", "<cmd>UndotreeToggle<cr>", desc = "Toggle undo tree" },
    },
  },
}
