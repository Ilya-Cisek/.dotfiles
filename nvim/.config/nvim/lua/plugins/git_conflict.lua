return {
  "akinsho/git-conflict.nvim",
  version = "*",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    default_mappings = true,
    disable_diagnostics = false,
    highlights = { incoming = "DiffAdd", current = "DiffText" },
  },
}
