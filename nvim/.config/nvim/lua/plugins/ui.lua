return {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local alpha = require("alpha")
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
        dashboard.button("q", "󰅚  Quit", ":qa<CR>"),
      }
      dashboard.section.footer.val = ""
      return dashboard.config
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = { style = "night", transparent = false },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = { options = { globalstatus = true, section_separators = "", component_separators = "" } },
  },
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      default_file_explorer = true,
      delete_to_trash = true,
      view_options = { show_hidden = true },
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["q"] = "actions.close",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "]h", function() gs.nav_hunk("next") end, "Next changed hunk")
        map("n", "[h", function() gs.nav_hunk("prev") end, "Previous changed hunk")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview changed hunk")
        map("n", "<leader>ghs", gs.stage_hunk, "Stage changed hunk")
        map("x", "<leader>ghs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage selected changes")
      end,
    },
  },
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },
}
