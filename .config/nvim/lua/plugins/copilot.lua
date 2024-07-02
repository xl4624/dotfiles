return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    build = ':Copilot auth',
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        ['*'] = true,
      },
    },
    config = function(_, opts)
      require('copilot').setup(opts)
      vim.cmd 'Copilot disable'
    end,
    keys = {
      {
        '<leader>cp',
        function()
          if vim.g.copilot_enabled == 0 then
            vim.cmd 'Copilot enable'
            vim.notify 'Copilot enabled'
            vim.g.copilot_enabled = 1
          else
            vim.cmd 'Copilot disable'
            vim.notify 'Copilot disabled'
            vim.g.copilot_enabled = 0
          end
        end,
      },
    },
  },
  {
    'zbirenbaum/copilot-cmp',
    dependencies = { 'zbirenbaum/copilot.lua' },
    opts = {},
  },
}
