return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    ensure_installed = { "lua", "vim", "vimdoc", "bash", "json", "yaml", "markdown", "python", "javascript", "typescript", "html", "css", "rust", "go" },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
  },
}
