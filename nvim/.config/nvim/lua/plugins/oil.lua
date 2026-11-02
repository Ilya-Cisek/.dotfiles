local preview_enabled = true

local function preview_window()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.wo[win].previewwindow and vim.w[win].oil_entry_id then return win end
  end
end

return {
  "stevearc/oil.nvim",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    default_file_explorer = true,
    delete_to_trash = true,
    view_options = { show_hidden = true },
    keymaps = {
      ["<C-h>"] = false,
      ["<C-l>"] = false,
      ["<leader>oh"] = { "actions.select", opts = { horizontal = true } },
      ["<leader>or"] = "actions.refresh",
      ["<C-p>"] = {
        callback = function()
          preview_enabled = not preview_enabled
          local win = preview_window()
          if not preview_enabled and win then
            vim.api.nvim_win_close(win, true)
          elseif preview_enabled and not win and require("oil").get_cursor_entry() then
            require("oil").open_preview()
          end
        end,
        desc = "Toggle persistent Oil preview",
      },
      ["q"] = "actions.close",
    },
  },
  config = function(_, opts)
    local oil = require("oil")
    oil.setup(opts)
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("user_oil_preview", { clear = true }),
      callback = function(event)
        if vim.bo[event.buf].filetype ~= "oil" then return end
        local win = vim.api.nvim_get_current_win()
        vim.defer_fn(function()
          if not preview_enabled or not vim.api.nvim_win_is_valid(win) then return end
          if vim.api.nvim_win_get_buf(win) ~= event.buf or preview_window() then return end
          vim.api.nvim_win_call(win, function()
            if oil.get_cursor_entry() then oil.open_preview() end
          end)
        end, 80)
      end,
    })
  end,
}
