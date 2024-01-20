local status, nvim_lsp = pcall(require, "lspconfig")
if (not status) then return end

local protocol = require('vim.lsp.protocol')
local util = require "lspconfig/util"

local on_attach = function(client, bufnr)
  -- format on save
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("Format", { clear = true }),
      buffer = bufnr,
      callback = function() vim.lsp.buf.formatting_seq_sync() end
    })
  end
end

-- TypeScript
nvim_lsp.tsserver.setup {
  on_attach = on_attach,
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  cmd = { "typescript-language-server", "--stdio" },
  single_file_support = true,
}

-- Python 
nvim_lsp.pyright.setup{
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

nvim_lsp.ruff_lsp.setup{
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

-- Rust 
nvim_lsp.rust_analyzer.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"rust"},
  root_dir = util.root_pattern("Cargo.toml"),
  cmd = {
    "rustup", "run", "stable", "rust-analyzer",
  },
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        allFeatures = true;
      }
    }
  }
}

-- Markdown setup
nvim_lsp.marksman.setup{
  on_attach = on_attach,
  cmd = {"marksman", "server"},
  filetypes = {"markdown", "markdown.mdx", "markdown.md"},
  root_dir = util.root_pattern(".git", ".markdown.mdx"),
  single_file_support = true
}


