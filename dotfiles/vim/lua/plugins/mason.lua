require("mason").setup()

local registry = require("mason-registry")
local packages = { 'ty' }
for i = 1, #packages do
  local installed = registry.is_installed(packages[i]);
  if installed == false then
    vim.cmd('MasonInstall ty')
  end
end
