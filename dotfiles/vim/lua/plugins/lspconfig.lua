function get_pylint_exec()
    local venv = os.getenv("VIRTUAL_ENV")
    local pylint_executable = "pylint"
    if venv ~= nil then
        if vim.fn.executable(venv .. "/bin/pylint") == 1 then
            pylint_executable = venv .. "/bin/pylint"
        else
            vim.notify(
                "pylint not found in virtual environment: " .. venv
                .. ". It may not resolve depencies correctly. `pip install pylint` in your venv",
                vim.log.levels.WARN
            )
        end
    end
    return pylint_executable
end

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
                    executable = get_pylint_exec(),
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
