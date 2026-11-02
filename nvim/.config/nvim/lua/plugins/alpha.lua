return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    local dashboard = require("alpha.themes.dashboard")
    dashboard.section.header.val = {
      "  ███╗   ██╗██╗   ██╗██╗███╗   ███╗",
      "  ████╗  ██║██║   ██║██║████╗ ████║",
      "  ██╔██╗ ██║██║   ██║██║██╔████╔██║",
      "  ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
      "  ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
      "  ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
    }
    dashboard.section.buttons.val = {
      dashboard.button("f", "󰱼  Find file", ":Telescope find_files<CR>"),
      dashboard.button("g", "󰈬  Search text", ":Telescope live_grep<CR>"),
      dashboard.button("e", "  File explorer", ":Oil<CR>"),
      dashboard.button("r", "󰈙  Read README", ":view " .. vim.fn.fnameescape(vim.fn.stdpath("config") .. "/README.md") .. "<CR>"),
      dashboard.button("q", "󰅚  Quit", ":qa<CR>"),
    }
    dashboard.section.footer.val = ""
    return dashboard.config
  end,
}
