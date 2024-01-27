local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local lsp_config = require("lspconfig")
local util = require("lspconfig/util")

-- Define the on_attach function outside of the setup calls
local on_attach_custom = function(client, bufnr)
  -- Disable hover in favor of Pyright
  client.server_capabilities.hoverProvider = false
  -- Call the general on_attach function
  on_attach(client, bufnr)
end

-- C/C++ setup
lsp_config.clangd.setup {
  on_attach = function(client, bufnr)
    --clangd clangd_extensions
    require("clangd_extensions.inlay_hints").setup_autocmd()
    require("clangd_extensions.inlay_hints").set_inlay_hints()
    --lsp-status
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

-- TailwindCss
lsp_config.tailwindcss.setup {}

-- Python
lsp_config.pyright.setup {
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

-- Ruff LSP
lsp_config.ruff_lsp.setup {
  on_attach = on_attach_custom,  -- Use the custom on_attach function
  cmd = {"ruff-lsp"},
  filetypes = {"python"},
  single_file_support = true,
  init_options = {
    settings = {
      args = {}, -- Any extra CLI arguments for `ruff` go here.
    }
  }
}

-- Markdown setup
lsp_config.marksman.setup {
  on_attach = on_attach,
  cmd = {"marksman", "server"},
  filetypes = {"markdown", "markdown.mdx", "markdown.md"},
  root_dir = util.root_pattern(".git", ".markdown.mdx"),
  single_file_support = true
}

