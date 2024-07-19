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
    keys = {
      {
        '<leader>cp',
        function()
          if vim.g.copilot_enabled == 0 then
            vim.notify 'Copilot enabled'
            vim.g.copilot_enabled = 1
            vim.cmd 'Copilot enable'
          else
            vim.notify 'Copilot disabled'
            vim.g.copilot_enabled = 0
            vim.cmd 'Copilot disable'
          end
        end,
      },
    },
  },
  {
    'zbirenbaum/copilot-cmp',
    dependencies = { 'zbirenbaum/copilot.lua', 'nvim-cmp' },
    opts = {}
  },
}
