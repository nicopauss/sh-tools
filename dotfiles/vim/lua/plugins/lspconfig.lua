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

vim.lsp.config('pyrefly', {
    on_attach = restore_gq,
    handlers = {
        -- Hide HINT messages
        ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
            if result and result.diagnostics then
                result.diagnostics = vim.tbl_filter(function(diag)
                    return diag.severity and diag.severity <= vim.diagnostic.severity.INFO
                end, result.diagnostics)
            end
            vim.lsp.handlers["textDocument/publishDiagnostics"](err, result, ctx, config)
        end,
    },
})
vim.lsp.enable('pyrefly')

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

-- Run ruff fix and format on save via LSP
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.py",
  callback = function(args)
    local clients = vim.lsp.get_clients({ bufnr = args.buf, name = "ruff" })
    if #clients == 0 then
      return
    end
    vim.lsp.buf.code_action({
      context = { only = { "source.fixAll.ruff" }, diagnostics = {} },
      apply = true,
    })
    vim.lsp.buf.format({ name = "ruff", async = false })
  end,
})

-- Clangd
vim.lsp.config.clangd = {
    cmd = {
        'clangd',
        '--header-insertion=never',
    },
}
