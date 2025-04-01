return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  opts = {
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4,
    },
    settings = {
      save_on_toggle = true,
    },
  },
  keys = {
    {
      '<leader>h',
      function()
        require('harpoon'):list():select(1)
      end,
      desc = 'Harpoon to File 1',
    },
    {
      '<leader>H',
      function()
        require('harpoon'):list():replace_at(1)
      end,
      desc = 'Set Harpoon File 1',
    },
    {
      '<leader>j',
      function()
        require('harpoon'):list():select(2)
      end,
      desc = 'Harpoon to File 2',
    },
    {
      '<leader>J',
      function()
        require('harpoon'):list():replace_at(2)
      end,
      desc = 'Set Harpoon File 2',
    },
    {
      '<leader>k',
      function()
        require('harpoon'):list():select(3)
      end,
      desc = 'Harpoon to File 3',
    },
    {
      '<leader>K',
      function()
        require('harpoon'):list():replace_at(3)
      end,
      desc = 'Set Harpoon File 3',
    },
    {
      '<leader>l',
      function()
        require('harpoon'):list():select(4)
      end,
      desc = 'Harpoon to File 4',
    },
    {
      '<leader>L',
      function()
        require('harpoon'):list():replace_at(4)
      end,
      desc = 'Set Harpoon File 4',
    },
    {
      '<leader>m',
      function()
        local harpoon = require 'harpoon'
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = 'Harpoon Quick Menu',
    },
  },
}
