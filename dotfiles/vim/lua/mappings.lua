-- NOTE: first argument is the mode "n" is normal mode (the mode you get when you
-- hit escape). "i" is insert mode. Then the key combinations is shown. <leader> means space.
local map = vim.keymap.set

-- Define <leader> as a space.
-- Space is the best leader key because no native mappings uses it and it is very
-- accessible with both hands. It's accessible via thumbs, which are rarely used.
vim.cmd('let mapleader = " "')

-- <A-t> means alt+t
map("n", "<A-t>", "<cmd>Minuet virtualtext toggle<cr>")
map("i", "<A-t>", "<cmd>Minuet virtualtext toggle<cr>")

local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

-- A diagnostic are things like errors, warning etc.
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- l like LSP
map("n", "<leader>lD", vim.diagnostic.open_float)
-- More information of symbol under cursor (e.g.: variable's type)
map("n", "<leader>lh", vim.lsp.buf.hover)
map("n", "<leader>li", "<cmd>Telescope lsp_references<cr>")
map("n", "<leader>lI", vim.lsp.buf.implementation)
map("n", "<leader>ld", "<cmd>Telescope lsp_definitions<cr>")
map("n", "<leader>lb", function() require("telescope.builtin").diagnostics({ sort_by="severity" }) end)
map("n", "<leader>ls", "<cmd>Telescope lsp_workspace_symbols<cr>")
map("n", "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>")
map("n", "<leader>lr", function()
  vim.lsp.buf.rename()
  vim.cmd('silent! wa')
end)
map("n", "<leader>la", vim.lsp.buf.code_action)

-- t like Telescope
map("n", "<leader>tg", "<cmd>Telescope live_grep<cr>")
-- Grep the word under the cursor
map("n", "<leader>tG", "<cmd>Telescope grep_string<cr>")
map("n", "<leader>tr", "<cmd>Telescope resume<cr>")
-- Reopen last search (so useful)
map("n", "<leader>tz", "<cmd>Telescope buffers<cr>")
map("n", "<leader>tl", "<cmd>Telescope find_files<cr>")

-- Open a new window with same file as current buffer
map("n", "<leader>bh", "<cmd>vsplit<cr>")
map("n", "<leader>bj", "<cmd>belowright split<cr>")
map("n", "<leader>bk", "<cmd>topleft split<cr>")
map("n", "<leader>bl", "<cmd>botright vs<cr>")
map("n", "<leader>bx", "<cmd>bd<cr>")

-- Trouble is the window with the list of errors bottom of the screen
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>")
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>")
-- Control whether elements from the location list and quickfix list are shown in the panel
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>")
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>")

-- Toggle numbers
map("n", "<leader>N", function()
  vim.wo[0].statuscolumn = "%l"
  if vim.wo[0].relativenumber or vim.wo[0].number then
    vim.wo[0].number = false
    vim.wo[0].relativenumber = false
  else
    vim.wo[0].number = true
    vim.wo[0].relativenumber = true
  end
end)

-- Tabs are *collections* of windows. They are *not* a single file (like VsCode
-- and most apps). Do not use tabs if you don't need collections of windows (most
-- people might not need it).
map("n", "<leader>tn", "<cmd>tabnew<cr>")
map("n", "<leader>tx", "<cmd>tabclose<cr>")
map("n", "<leader>tl", "<cmd>tabnext<cr>")
map("n", "<leader>th", "<cmd>tabprevious<cr>")
map("n", "<leader>tL", "<cmd>+tabmove<cr>")
map("n", "<leader>tH", "<cmd>-tabmove<cr>")

-- Quickfix list
map("n", "<leader>qo", "<cmd>copen<cr>")
map("n", "<leader>qj", "<cmd>cnext<cr>")
map("n", "<leader>qk", "<cmd>cprev<cr>")

map("n", "<leader>d", "<cmd>Oil<cr>")

local hjkl = { "h", "j", "k", "l" }
for _, key in ipairs(hjkl) do
  -- Focus window (e.g: <A-l> focus right window)
  map({ "t", "n", "i" }, "<A-" .. key .. ">", "<C-\\><C-N><C-w>" .. key)

  -- Move window (A-L (uppercase) to move a window right)
  local upper = string.upper(key)
  map({ "t", "n", "i" }, "<A-" .. upper .. ">", "<C-\\><C-N><C-w>" .. upper)
end

vim.cmd([[
  " Custom env variable you need to set if you have an azerty keyboard
  if !empty($KEYBOARD_FR)
    nmap <silent> ù `
    noremap <C--> <C-^>
  endif
]])
