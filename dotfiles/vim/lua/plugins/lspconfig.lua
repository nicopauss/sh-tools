-- Every server used here must be added in the install script nvim_install.sh
require("mason").setup()
vim.lsp.enable('clangd')
vim.lsp.enable('eslint')
vim.lsp.enable('ts_ls')
vim.lsp.enable('ruff')

-- https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
-- We only use it for pylint and for jedi (enabled by default)
vim.lsp.config('pylsp', {
    -- higher than default debounce time because pylint is slow to answer so
    -- it's important not to flood it
    flags = {
        debounce_text_changes = 600,
    },
    settings = {
        pylsp = {
            plugins = {
                -- Basic things (autocompletion, renaming etc.)
                jedi = {
                    enabled = true,
                },
                pylint = {
                    enabled = true,
                },
                -- Disable all other linters
                pyflakes = {
                    enabled = false,
                },
                autopep8 = {
                    enabled = false,
                },
                flake8 = {
                    enabled = false,
                },
                pycodestyle = {
                    enabled = false,
                },
                mccabe = {
                    enabled = false,
                },
                yapf = {
                    enabled = false,
                },
            },
        }
    },
})
vim.lsp.enable('pylsp')
vim.lsp.enable('bashls')

-- Rust
require('lspconfig').rust_analyzer.setup({
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
    }
  },
})
-- Format Rust files on save using rust-analyzer
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
