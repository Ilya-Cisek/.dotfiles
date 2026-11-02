return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  event = "VeryLazy",
  dependencies = { "mason-org/mason.nvim" },
  opts = {
    ensure_installed = { "jq", "yamlfmt" },
    run_on_start = true,
    start_delay = 1000,
  },
}
