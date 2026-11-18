local M = {}
local highlights = vim.api.nvim_create_namespace("git_review_unified")

local function git(root, args)
  local command = { "git" }
  vim.list_extend(command, args)
  return vim.system(command, { cwd = root }):wait()
end

local function diff_args(staged, extra)
  local args = staged and { "diff", "--cached" } or { "diff" }
  return vim.list_extend(args, extra)
end

function M.open(staged)
  local scope = staged and "staged" or "unstaged"
  local cwd = vim.fn.getcwd()
  local root_result = vim.system({ "git", "rev-parse", "--show-toplevel" }, { cwd = cwd, text = true }):wait()
  if root_result.code ~= 0 then
    vim.notify("Not inside a Git project", vim.log.levels.WARN)
    return
  end

  local root = vim.trim(root_result.stdout)
  local files_result = git(root, diff_args(staged, { "--name-only", "-z" }))
  if files_result.code ~= 0 then
    vim.notify("Could not list " .. scope .. " changes: " .. (files_result.stderr or ""), vim.log.levels.ERROR)
    return
  end

  local files = vim.split(files_result.stdout or "", "\0", { plain = true, trimempty = true })
  if #files == 0 then
    vim.notify("No " .. scope .. " changes", vim.log.levels.INFO)
    return
  end

  local file_buf = vim.api.nvim_create_buf(false, true)
  local diff_buf = vim.api.nvim_create_buf(false, true)
  for _, buf in ipairs({ file_buf, diff_buf }) do
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
  end
  vim.bo[file_buf].filetype = "gitreviewfiles"
  vim.bo[diff_buf].filetype = "diff"
  vim.api.nvim_buf_set_lines(file_buf, 0, -1, false, files)
  vim.bo[file_buf].modifiable = false

  vim.cmd("tabnew")
  local diff_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(diff_win, diff_buf)
  vim.cmd("topleft 36vsplit")
  local file_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(file_win, file_buf)
  vim.wo[file_win].number = false
  vim.wo[file_win].relativenumber = false
  vim.wo[file_win].signcolumn = "no"
  vim.wo[file_win].wrap = false
  vim.wo[file_win].winfixwidth = true
  vim.wo[file_win].cursorline = true
  vim.wo[file_win].winbar = staged and " Staged changes " or " Unstaged changes "
  vim.wo[diff_win].wrap = false

  local selected
  local function show(index)
    if index < 1 or index > #files or not vim.api.nvim_buf_is_valid(diff_buf) then return end
    if selected == index then return end
    selected = index
    vim.api.nvim_win_set_cursor(file_win, { index, 0 })
    local result = git(root, diff_args(staged, { "--no-ext-diff", "--no-color", "--", files[index] }))
    local lines
    if result.code == 0 then
      lines = vim.split(result.stdout or "", "\n", { plain = true, trimempty = true })
      if #lines == 0 then lines = { "No " .. scope .. " diff for " .. files[index] } end
    else
      lines = { "Could not load diff for " .. files[index], result.stderr or "" }
    end
    vim.bo[diff_buf].modifiable = true
    vim.api.nvim_buf_set_lines(diff_buf, 0, -1, false, lines)
    vim.bo[diff_buf].modifiable = false
    vim.api.nvim_buf_clear_namespace(diff_buf, highlights, 0, -1)
    for row, line in ipairs(lines) do
      local group
      if line:match("^%+") and not line:match("^%+%+%+") then
        group = "DiffAdd"
      elseif line:match("^%-") and not line:match("^%-%-%-") then
        group = "DiffDelete"
      elseif line:match("^@@") then
        group = "DiffChange"
      end
      if group then
        vim.api.nvim_buf_set_extmark(diff_buf, highlights, row - 1, 0, { line_hl_group = group })
      end
    end
    vim.api.nvim_win_set_cursor(diff_win, { 1, 0 })
  end

  local function move(step)
    show((selected or 1) + step)
  end
  local function close()
    vim.cmd("tabclose")
  end
  for _, buf in ipairs({ file_buf, diff_buf }) do
    local opts = { buffer = buf, silent = true }
    vim.keymap.set("n", "]q", function() move(1) end, opts)
    vim.keymap.set("n", "[q", function() move(-1) end, opts)
    vim.keymap.set("n", "<Tab>", function() move(1) end, opts)
    vim.keymap.set("n", "<S-Tab>", function() move(-1) end, opts)
    vim.keymap.set("n", "<leader>gdf", function() vim.api.nvim_set_current_win(file_win) end, opts)
    vim.keymap.set("n", "<leader>gdc", close, opts)
    vim.keymap.set("n", "q", close, opts)
  end
  vim.keymap.set("n", "<CR>", function()
    show(vim.api.nvim_win_get_cursor(file_win)[1])
    vim.api.nvim_set_current_win(diff_win)
  end, { buffer = file_buf, silent = true })
  vim.api.nvim_create_autocmd("CursorMoved", {
    buffer = file_buf,
    callback = function()
      if vim.api.nvim_get_current_win() == file_win then
        show(vim.api.nvim_win_get_cursor(file_win)[1])
      end
    end,
  })
  local function jump_hunk(direction)
    local pattern = "^@@"
    if vim.fn.search(pattern, direction == "next" and "W" or "bW") == 0 then
      vim.notify("No more changed blocks", vim.log.levels.INFO)
    end
  end
  vim.keymap.set("n", "<leader>g]", function() jump_hunk("next") end, { buffer = diff_buf })
  vim.keymap.set("n", "<leader>g[", function() jump_hunk("prev") end, { buffer = diff_buf })
  show(1)
  vim.api.nvim_set_current_win(diff_win)
end

function M.open_unstaged()
  M.open(false)
end

function M.open_staged()
  M.open(true)
end

return M
