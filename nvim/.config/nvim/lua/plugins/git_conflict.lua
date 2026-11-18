return {
  "akinsho/git-conflict.nvim",
  version = "*",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    default_mappings = {
      ours = "<leader>gxo",
      theirs = "<leader>gxt",
      both = "<leader>gxb",
      none = "<leader>gx0",
      next = "<leader>gxn",
      prev = "<leader>gxp",
    },
    disable_diagnostics = false,
    highlights = { incoming = "DiffAdd", current = "DiffText" },
  },
}
