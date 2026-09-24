-- These servers are distributed outside npm. Ruff handles Python linting and
-- formatting, ty provides Python type checking, and Deno handles JS/TS projects
-- containing deno.json or deno.jsonc.
local servers = { "lua_ls", "ruff", "ty", "denols", "gopls", "rust_analyzer" }

return {
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    opts = { ui = { border = "rounded" } },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", opts = { ui = { border = "rounded" } } },
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = {
      ensure_installed = servers,
      automatic_enable = true,
    },
    config = function(_, opts)
      require("mason").setup()
      require("mason-lspconfig").setup(opts)

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })
      vim.lsp.config("ruff", {
        init_options = { settings = { args = {} } },
      })
      vim.lsp.config("ty", {
        init_options = { settings = {} },
      })
      vim.lsp.config("denols", {
        root_markers = { "deno.json", "deno.jsonc" },
        init_options = { enable = true, lint = true, unstable = true },
      })

      local group = vim.api.nvim_create_augroup("user_lsp", { clear = true })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        callback = function(event)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, silent = true, desc = desc })
          end
          map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
          map("n", "gr", vim.lsp.buf.references, "References")
          map("n", "gi", vim.lsp.buf.implementation, "Implementation")
          map("n", "K", vim.lsp.buf.hover, "Hover documentation")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map("n", "<leader>ds", vim.lsp.buf.document_symbol, "Document symbols")
        end,
      })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = { "jq", "yamlfmt" },
      run_on_start = true,
      start_delay = 1000,
    },
  },
}
