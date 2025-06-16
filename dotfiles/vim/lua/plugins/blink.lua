-- Documentation: https://cmp.saghen.dev/installation.html
local legacy_tab = vim.g.tab_to_complete

-- https://cmp.saghen.dev/configuration/keymap.html
local keymap = {
    preset = legacy_tab and "super-tab" or "default",
}

require("blink.compat").setup({})
require("cmp_nvim_ultisnips").setup({})
local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
if legacy_tab then
    keymap['<Tab>'] = {
        function(cmp)
            if cmp.is_visible() then
                return false
            end

            local ultisnip_triggered = true
            cmp_ultisnips_mappings.compose({ 'expand', "jump_forwards" })(function()
                -- if the fallback function is used, ultisnip was not used
                ultisnip_triggered = false
            end)

            -- If we return false we go to the next element (show), if it returns
            -- false it goes to the next etc.
            return ultisnip_triggered
        end,
        'show_and_insert',
        'snippet_forward',
        'select_next',
    }
    keymap['<S-Tab>'] = {
        'select_prev',
    }
end

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
            auto_show = not legacy_tab,
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
