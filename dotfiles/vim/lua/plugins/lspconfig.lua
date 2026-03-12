-- Some LSP servers don't play well with gq, they ignore the textwidth for some
-- reasons. For those, we need to remove the formatexpr they set. Others such
-- as bashls, clangd work fine anyway.
local restore_gq = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "formatexpr", "")
end

vim.lsp.enable('clangd')
vim.lsp.config('eslint', { on_attach = restore_gq })
vim.lsp.enable('eslint')
vim.lsp.config('ts_ls', { on_attach = restore_gq })
vim.lsp.enable('ts_ls')
vim.lsp.config('ruff', { on_attach = restore_gq })
vim.lsp.enable('ruff')
vim.lsp.enable('ast_grep')
vim.lsp.enable('bashls')

vim.lsp.config('ty', {
    settings = {
        ty = {
            diagnosticMode = 'off',
        },
    }
})
vim.lsp.enable('ty')

-- Rust
vim.lsp.config.rust_analyzer = {
  settings = {
    ['rust-analyzer'] = {
      cargo = {
          allFeatures = true,
      },
      checkOnSave = true,
      check = {
          command = "clippy",
          features = "all",
      },
    },
  },
}
vim.lsp.enable("rust_analyzer")

-- Format Rust files on save using rust-analyzer
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Clangd
vim.lsp.config.clangd = {
    cmd = {
        'clangd',
        '--header-insertion=never',
    },
}
