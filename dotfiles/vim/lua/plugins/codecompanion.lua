local cortex = {
    schema = {
        model = {
            default = "qwen2.5-coder:32b",
        },
    },
    env = {
        url = 'http://cortex.corp:11434',
        api_key = "NONE",
    },
    headers = {
        ["Content-Type"] = "application/json",
        ["Authorization"] = "Bearer ${api_key}",
    },
    parameters = {
        sync = true,
    },
}

local mistral = {
    env = {
        url = "https://api.mistral.ai",
        api_key = "CODESTRAL_API_KEY"
    },

}

local adapter = "mistral"

require('codecompanion').setup({
    strategies = {
        chat = {
            adapter = adapter,
        },
        inline = {
            adapter = adapter,
        },
        cmd = {
            adapter = adapter,
        },
    },
    adapters = {
        cortex = function()
            return require("codecompanion.adapters").extend("ollama", cortex)
        end,
        mistral = function()
            return require("codecompanion.adapters").extend("mistral", mistral)
        end,
    },
    opts = {
      -- Set debug logging
      log_level = "DEBUG",
    },
})
