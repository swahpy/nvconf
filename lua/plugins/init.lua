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
      table.insert(conf.sources, 1, {
        name = "nvim_lsp",
        option = {
          markdown_oxide = {
            keyword_pattern = [[\(\k\| \|\/\|#\)\+]],
          },
        },
      })
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
    "OXY2DEV/markview.nvim",
    ft = "markdown",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = require "configs.markview",
    config = function(_, opts)
      require("markview").setup(opts)
      require("markview.extras.editor").setup {
        --- The minimum & maximum window width
        --- If the value is smaller than 1 then
        --- it is used as a % value.
        ---@type [ number, number ]
        width = { 10, 0.75 },

        --- The minimum & maximum window height
        ---@type [ number, number ]
        height = { 3, 0.75 },

        --- Delay(in ms) for window resizing
        --- when typing.
        ---@type integer
        debounce = 50,

        --- Callback function to run on
        --- the floating window.
        ---@type fun(buf:integer, win:integer): nil
        callback = function(buf, win) end,
      }
    end,
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

  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      require("lspsaga").setup {}
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons", -- optional
    },
    keys = {
      { "<leader>ic", [[<cmd> Lspsaga incoming_calls <cr>]], desc = "Lspsaga incoming calls" },
      { "<leader>oc", [[<cmd> Lspsaga outgoing_calls <cr>]], desc = "Lspsaga outgoing calls" },
      { "<leader>lc", [[<cmd> Lspsaga code_action <cr>]], desc = "Lspsaga code actions" },
      { "<leader>dn", [[<cmd> Lspsaga peek_definition <cr>]], desc = "Lspsaga peek definition" },
      { "<leader>td", [[<cmd> Lspsaga peek_type_definition <cr>]], desc = "Lspsaga peek type definition" },
      { "<leader>dn", [[<cmd> Lspsaga diagnostic_jump_next <cr>]], desc = "Lspsaga jump to next diagnostic" },
      { "<leader>dp", [[<cmd> Lspsaga diagnostic_jump_prev <cr>]], desc = "Lspsaga jump to prev diagnostic" },
      { "<leader>fi", [[<cmd> Lspsaga finder implementation <cr>]], desc = "Lspsaga finder implementation" },
      { "<leader>fr", [[<cmd> Lspsaga finder references <cr>]], desc = "Lspsaga finder references" },
      { "<leader>fd", [[<cmd> Lspsaga finder definition <cr>]], desc = "Lspsaga finder definition" },
      { "<leader>lt", [[<cmd> Lspsaga term_toggle <cr>]], desc = "Lspsaga toggle terminal" },
      { "<leader>k", [[<cmd> Lspsaga hover_doc <cr>]], desc = "Lspsaga hover documentation" },
      { "<leader>ol", [[<cmd> Lspsaga outline <cr>]], desc = "Lspsaga show outline of current buffer" },
      { "<leader>rn", [[<cmd> Lspsaga rename <cr>]], desc = "Lspsaga rename" },
    },
  },

  {
    "otavioschwanck/arrow.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      -- or if using `mini.icons`
      -- { "echasnovski/mini.icons" },
    },
    opts = {
      show_icons = true,
      leader_key = "-", -- Recommended to be a single key
      buffer_leader_key = "m", -- Per Buffer Mappings
    },
    keys = {
      { "-" },
    },
  },
}
