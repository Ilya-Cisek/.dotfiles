return {
  "catgoose/nvim-colorizer.lua",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    options = {
      parsers = {
        names = { enable = false },
        hex = { default = false, rgb = true, rgba = true, rrggbb = true, rrggbbaa = true },
      },
    },
  },
}
