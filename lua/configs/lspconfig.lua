-- load defaults i.e lua_lsp
local nvlsp = require "nvchad.configs.lspconfig"
nvlsp.defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = {
  "basedpyright",
  "biome",
  "emmet_language_server",
  "html",
  "markdown-oxide",
  "ruff",
}

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- markdown-oxide
lspconfig.markdown_oxide.setup {
  -- Ensure that dynamicRegistration is enabled! This allows the LS to take into account actions like the
  -- Create Unresolved File code action, resolving completions for unindexed code blocks, ...
  capabilities = vim.tbl_deep_extend(
    "force",
    require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    {
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true,
        },
      },
    }
  ),
  on_attach = function(client, bufnr)
    -- setup Markdown Oxide daily note commands
    if client.name == "markdown_oxide" then
      vim.api.nvim_create_user_command("Daily", function(args)
        local input = args.args
        vim.lsp.buf.execute_command { command = "jump", arguments = { input } }
      end, { desc = "Open daily note", nargs = "*" })
    end
    -- enable code lens
    local function check_codelens_support()
      local clients
      if vim.lsp.get_clients then
        clients = vim.lsp.get_clients {
          bufnr = bufnr,
        }
      else
        ---@diagnostic disable-next-line: deprecated
        clients = vim.lsp.get_active_clients {
          bufnr = bufnr,
        }
      end
      for _, c in ipairs(clients) do
        if c.server_capabilities.codeLensProvider then
          return true
        end
      end
      return false
    end

    vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "CursorHold", "LspAttach", "BufEnter" }, {
      buffer = bufnr,
      callback = function()
        if check_codelens_support() then
          vim.lsp.codelens.refresh { bufnr = 0 }
        end
      end,
    })
    -- trigger codelens refresh
    vim.api.nvim_exec_autocmds("User", { pattern = "LspAttached" })
  end,
  on_init = nvlsp.on_init,
}

-- biome
local lsputil = require "lspconfig.util"
lspconfig.biome.setup {
  root_dir = function(fname)
    return lsputil.root_pattern("biome.json", "biome.jsonc")(fname)
      or lsputil.find_package_json_ancestor(fname)
      or lsputil.find_node_modules_ancestor(fname)
      or lsputil.find_git_ancestor(fname)
  end,
  single_file_support = true,
}

-- basedpyright
lspconfig.basedpyright.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticsMode = "openFilesOnly", -- workspace, openFilesOnly
        typeCheckingMode = "standard", -- off, basic, standard, strict, all
        diagnosticSeverityOverrides = {
          reportUnknownMemberType = false,
          reportUnknownArgumentType = false,
          reportUnusedVariable = false, -- ruff handles this with F841
          reportUnusedImport = false, -- ruff handles this with F401
          reportAttributeAccessIssue = false,
        },
      },
    },
    python = {
      pythonPath = "./venv/bin/python",
    },
  },
}

-- ruff
lspconfig.ruff.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  trace = "messages",
  init_options = {
    settings = {
      logLevel = "debug",
    },
  },
}
