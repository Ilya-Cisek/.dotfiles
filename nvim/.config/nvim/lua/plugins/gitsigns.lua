return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  opts = {
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end
      map("n", "]h", function() gs.nav_hunk("next") end, "Next changed hunk")
      map("n", "[h", function() gs.nav_hunk("prev") end, "Previous changed hunk")
      map("n", "<leader>ghp", gs.preview_hunk, "Preview changed hunk")
      map("n", "<leader>ghs", gs.stage_hunk, "Stage changed hunk")
      map("x", "<leader>ghs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Stage selected changes")
    end,
  },
}
