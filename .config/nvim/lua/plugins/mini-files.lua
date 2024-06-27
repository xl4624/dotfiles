return {
  'echasnovski/mini.files',
  lazy = false, -- otherwise won't open as default_explorer
  opts = {
    options = {
      use_as_default_explorer = true,
    },
  },
  config = function(_, opts)
    require('mini.files').setup(opts)
    vim.g.colors_name = 'minischeme'
  end,
  keys = {
    {
      '<leader>e',
      function()
        require('mini.files').open(vim.api.nvim_buf_get_name(0), true)
      end,
      desc = 'Open mini.files (Directory of Current File)',
    },
    {
      '<leader>E',
      function()
        require('mini.files').open(vim.uv.cwd(), true)
      end,
      desc = 'Open mini.files (cwd)',
    },
  },
}
