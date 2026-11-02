return {
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
      if vim.api.nvim_buf_call(bufnr, function() return vim.fn.search("^<<<<<<< ", "nw") ~= 0 end) then return end
      return { timeout_ms = 1000, lsp_fallback = true }
    end,
  },
}
