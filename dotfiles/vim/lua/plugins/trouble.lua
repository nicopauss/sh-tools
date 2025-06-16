-- Looks at trouble default settings to learn more including default keymaps:
-- https://github.com/folke/trouble.nvim?tab=readme-ov-file#setup
require("trouble").setup({
    modes = {
        diagnostics = {
            auto_open = true,
            auto_close = true,
        },
    }
})
