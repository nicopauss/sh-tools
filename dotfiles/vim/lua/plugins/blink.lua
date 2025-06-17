-- https://cmp.saghen.dev/configuration/keymap.html
local keymap = {
    preset = "enter",
}

require("blink.compat").setup({})
require("cmp_nvim_ultisnips").setup({})

keymap['<C-y>'] = { 'select_and_accept' }

require('blink.cmp').setup({
    completion = {
        trigger = {
            show_in_snippet = false,
        },
        list = {
            selection = {
                preselect = true,
                auto_insert = true
            },
        },
        menu = {
            auto_show = true,
            -- Reduce max height as it is what is considered for the direction priority
            -- below. So between line 1-7 menu is south (which is annoying as it hides
            -- AI suggestions). Default was higher (10).
            -- Always update preferences.vim "scrolloff" value, as scrolloff allows to
            -- always keep a minimum of X lines between cursor and top/bottom of screen
            -- when possible.
            max_height = 6,
            scrolloff = 0,
            -- Put the menu above, when possible to not cover AI suggestions
            direction_priority = {
                'n',
                's'
            },
        },
    },
    keymap = keymap,
    sources = {
        default = { 'lsp', 'ultisnips', 'buffer' },
        providers = {
            ['ultisnips'] = {
                name = 'ultisnips',
                module = 'blink.compat.source',
            },
        },
    },
    cmdline = {
        keymap = { preset = 'inherit' },
        completion = { menu = { auto_show = false } },
    },
})
