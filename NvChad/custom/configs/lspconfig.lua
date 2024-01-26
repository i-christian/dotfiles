local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local lsp_config = require("lspconfig")
local util = require("lspconfig/util")


--C/C++ setup
lsp_config.clangd.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.signatureHelpProvider = false
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
}

-- TypeScript
lsp_config.tsserver.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  cmd = { "typescript-language-server", "--stdio" },
  single_file_support = true,
  settings = {
    completions = {
      completeFunctionCalls = true
    }
  }

}

--tailwindCss
lsp_config.tailwindcss.setup{}

-- Python 
lsp_config.pyright.setup{
  on_attach = on_attach,
  filetypes = {"python"},
  single_file_support = true,
  settings = {
    pyright = {
      autoImportCompletion = true,
    },
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = 'openFilesOnly',
        useLibraryCodeForTypes = true,
        typeCheckingMode = 'off'
      }
    }
  }
}

lsp_config.ruff_lsp.setup{
  on_attach = on_attach,
  cmd = {"ruff-lsp"},
  filetypes = {"python"},
  --root_dir = see source file,
  single_file_support = true,
  init_options = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      args = {},
    }
  }
}

-- Markdown setup
lsp_config.marksman.setup{
  on_attach = on_attach,
  cmd = {"marksman", "server"},
  filetypes = {"markdown", "markdown.mdx", "markdown.md"},
  root_dir = util.root_pattern(".git", ".markdown.mdx"),
  single_file_support = true
}

