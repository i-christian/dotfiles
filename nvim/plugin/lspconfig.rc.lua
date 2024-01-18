local status, nvim_lsp = pcall(require, "lspconfig")
if (not status) then return end

local protocol = require('vim.lsp.protocol')


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
  capabilities = capabilities,
  filetypes = {"python"},
  single_file_support = true,
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
  single_file_support = true,
  filetypes = {"rust"},
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = false;
      }
    }
  }
}
