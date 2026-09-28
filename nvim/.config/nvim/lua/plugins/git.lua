return {
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      default_mappings = true,
      disable_diagnostics = false,
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
}
