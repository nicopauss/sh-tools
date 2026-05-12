local lint = require("lint")
lint.linters.pylint.stdin = false
lint.linters.pylint.args = {
  "-f",
  "json",
  function()
    -- Return relative path. If you give full path instead
    -- pylint will not respect the excluded paths of pylintrc.
    return vim.fn.expand("%:.")
  end,
}
lint.linters.pylint.append_fname = false

lint.linters_by_ft = {
--  python = { "pylint" },
  bash = { "shellcheck" },
  shell = { "shellcheck" },
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
  callback = function()
    local root = vim.fs.root(0, { ".git" })

    if not root then
      return
    end

    local mypy = vim.fn.filereadable(root .. "/mypy.ini") == 1

    -- If you open a file outside the root, mypy will fail.
    local file_in_root = not vim.fn.expand("%:."):match("^" .. root)

    if root and mypy and vim.bo.filetype == "python"
      and file_in_root then
      lint.try_lint("mypy", { cwd = root })
    end

    -- When we have `nil` as an argument
    -- we use lint.linters_by_ft (see above)
    lint.try_lint(nil, { cwd = root })
  end,
})
