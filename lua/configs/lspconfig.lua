-- load defaults i.e lua_lsp
local nvlsp = require "nvchad.configs.lspconfig"
nvlsp.defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = {
  "cssls",
  "basedpyright",
  "biome",
  "emmet_language_server",
  "html",
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
