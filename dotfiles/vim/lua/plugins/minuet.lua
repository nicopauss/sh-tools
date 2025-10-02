local ai_manual_completion = true
local endpoint = 'https://api.mistral.ai/v1/fim/completions'
local qwerty = vim.g.qwerty
local api_key = os.getenv('CODESTRAL_API_KEY')

if api_key and api_key ~= '' then
    require('minuet').setup({
        throttle = 1000,
        debounce = 350,
        virtualtext = {
          show_on_completion_menu = true,
          auto_trigger_ft = ai_manual_completion and {} or { "*" },
          keymap = {
            accept_line = '<A-d>',
            accept = '<A-f>',
            -- accept n lines (prompts for number)
            -- e.g. "A-z 2 CR" will accept 2 lines
            accept_n_lines = '<A-z>',
            -- Cycle to prev completion item, or manually invoke completion
            prev = qwerty and '<A-[>' or '<A-(>',
            -- Cycle to next completion item, or manually invoke completion
            next = qwerty and '<A-]>' or '<A-)>',
            dismiss = '<A-e>',
          },
        },
        provider = 'codestral',
        n_completions = 3,
        context_window = 20000,
        provider_options = {
          codestral = {
            end_point = endpoint,
            api_key = 'CODESTRAL_API_KEY',
          },
        },
    })
end
