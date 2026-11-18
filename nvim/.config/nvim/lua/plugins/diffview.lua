return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = function()
    local actions = require("diffview.actions")
    local choose = {
      o = "ours",
      t = "theirs",
      v = "base",
      b = "all",
      ["0"] = "none",
    }
    local view = {
      ["[x"] = false,
      ["]x"] = false,
      ["<leader>co"] = false,
      ["<leader>ct"] = false,
      ["<leader>cb"] = false,
      ["<leader>ca"] = false,
      ["dx"] = false,
      ["<leader>cO"] = false,
      ["<leader>cT"] = false,
      ["<leader>cB"] = false,
      ["<leader>cA"] = false,
      ["dX"] = false,
      ["<leader>e"] = false,
      ["<leader>b"] = false,
      ["g<C-x>"] = false,
      { "n", "<leader>gxp", actions.prev_conflict, { desc = "Previous conflict" } },
      { "n", "<leader>gxn", actions.next_conflict, { desc = "Next conflict" } },
      { "n", "<leader>gdf", actions.focus_files, { desc = "Focus diff files" } },
      { "n", "<leader>gdt", actions.toggle_files, { desc = "Toggle diff files" } },
      { "n", "<leader>gdx", actions.cycle_layout, { desc = "Cycle diff layout" } },
    }
    local file_panel = {
      ["[x"] = false,
      ["]x"] = false,
      ["<leader>cO"] = false,
      ["<leader>cT"] = false,
      ["<leader>cB"] = false,
      ["<leader>cA"] = false,
      ["dX"] = false,
      ["-"] = false,
      s = false,
      S = false,
      U = false,
      X = false,
      L = false,
      ["<leader>e"] = false,
      ["<leader>b"] = false,
      ["g<C-x>"] = false,
      { "n", "<leader>gxp", actions.prev_conflict, { desc = "Previous conflict" } },
      { "n", "<leader>gxn", actions.next_conflict, { desc = "Next conflict" } },
      { "n", "<leader>gdf", actions.focus_files, { desc = "Focus diff files" } },
      { "n", "<leader>gdt", actions.toggle_files, { desc = "Toggle diff files" } },
      { "n", "<leader>gdx", actions.cycle_layout, { desc = "Cycle diff layout" } },
      { "n", "<leader>ghs", actions.toggle_stage_entry, { desc = "Stage or unstage file" } },
      { "n", "<leader>gsa", actions.stage_all, { desc = "Stage all files" } },
      { "n", "<leader>gua", actions.unstage_all, { desc = "Unstage all files" } },
      { "n", "<leader>gr", actions.restore_entry, { desc = "Restore file" } },
      { "n", "<leader>gcl", actions.open_commit_log, { desc = "Commit log" } },
    }
    for key, side in pairs(choose) do
      view[#view + 1] = { "n", "<leader>gx" .. key, actions.conflict_choose(side), { desc = "Choose " .. side } }
    end
    for key, side in pairs({ O = "ours", T = "theirs", B = "base", A = "all", Z = "none" }) do
      local map = { "n", "<leader>gx" .. key, actions.conflict_choose_all(side), { desc = "Choose " .. side .. " for file" } }
      view[#view + 1] = map
      file_panel[#file_panel + 1] = map
    end
    return { keymaps = { view = view, file_panel = file_panel } }
  end,
}
