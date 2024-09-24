return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        ['*'] = true,
      },
    },
  },
  {
    'zbirenbaum/copilot-cmp',
    dependencies = { 'zbirenbaum/copilot.lua', 'nvim-cmp' },
    opts = {},
  },
}
