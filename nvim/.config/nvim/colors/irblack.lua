require('mini.base16').setup {
  palette = {
    base00 = '#000000',
    base01 = '#242422',
    base02 = '#484844',
    base03 = '#6c6c66',
    base04 = '#918f88',
    base05 = '#b5b3aa',
    base06 = '#d9d7cc',
    base07 = '#fdfbee',
    base08 = '#ff6c60',
    base09 = '#e9c062',
    base0A = '#ffffb6',
    base0B = '#a8ff60',
    base0C = '#c6c5fe',
    base0D = '#96cbfe',
    base0E = '#ff73fd',
    base0F = '#b18a3d',
  },

  use_cterm = {
    base00 = 0,
    base03 = 8,
    base05 = 7,
    base07 = 15,
    base08 = 1,
    base0A = 3,
    base0B = 2,
    base0C = 6,
    base0D = 4,
    base0E = 5,
    base01 = 10,
    base02 = 11,
    base04 = 12,
    base06 = 13,
    base09 = 9,
    base0F = 14,
  },
}
vim.api.nvim_set_hl(0, "MiniFilesNormal", { link = "Normal" })
vim.g.colors_name = 'irblack'
