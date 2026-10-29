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
      format_on_save = function(bufnr)
        if vim.b[bufnr].disable_autoformat then return end
        -- Avoid rewriting a file while conflict markers are still present.
        if vim.api.nvim_buf_call(bufnr, function() return vim.fn.search("^<<<<<<< ", "nw") ~= 0 end) then return end
        return { timeout_ms = 1000, lsp_fallback = true }
      end,
    },
  },
}
