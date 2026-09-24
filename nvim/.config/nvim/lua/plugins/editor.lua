return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { defaults = { layout_strategy = "horizontal", sorting_strategy = "ascending" } },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = { "lua", "vim", "vimdoc", "bash", "json", "yaml", "markdown", "python", "javascript", "typescript", "html", "css", "rust", "go" },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format", "black" },
        javascript = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        json = { "jq" },
        yaml = { "yamlfmt" },
        rust = { "rustfmt" },
        go = { "gofmt" },
      },
      format_on_save = { timeout_ms = 1000, lsp_fallback = true },
    },
  },
}
