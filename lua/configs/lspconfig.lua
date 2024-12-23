-- load defaults i.e lua_lsp
local nvlsp = require "nvchad.configs.lspconfig"
nvlsp.defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "cssls", "basedpyright", "ruff" }

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

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
