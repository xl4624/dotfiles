return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { icon = '', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
          { icon = '', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          { icon = '', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = '', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = '', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = '', key = 's', desc = 'Restore Session', section = 'session' },
          { icon = '󰒲', key = 'l', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
          { icon = '', key = 'q', desc = 'Quit', action = ':qa' },
        },
        header = [[

. 　　　。　　　　•　 　ﾟ　　。 　　.

　　　.　　　 　　.　　　　　。　　 。　. 　

.　　 。　　　• . 　　 • 　　　　•

　　ﾟ　　 Red was not An Impostor.　 ඞ。　.

　　'　　　 1 Impostor remains 　 　　。

　　ﾟ　　　.　　　. 　　　　.　]],
      },
    },
    dim = { enabled = false },
    indent = { enabled = true },
    picker = {
      enabled = true,
      layout = {
        cycle = true,
        --- Use the default layout or vertical if the window is too narrow
        preset = function()
          return vim.o.columns >= 120 and 'fullscreen' or 'vertical'
        end,
      },
      sources = {
        files = {
          hidden = true,
        },
      },
      layouts = {
        fullscreen = {
          layout = {
            box = 'horizontal',
            width = 0.999,
            min_width = 120,
            height = 0.999,
            {
              box = 'vertical',
              border = 'none',
              title = '{title} {live} {flags}',
              {
                win = 'input',
                height = 1,
                border = 'none',
              },
              { win = 'list', border = 'none' },
            },
            {
              win = 'preview',
              title = '{preview}',
              border = 'none',
              width = 0.5,
            },
          },
        },
      },
    },
    quickfile = { enabled = true },
  },
  -- stylua: ignore
  keys = {
    -- Git
    { '<leader>gb', function() Snacks.git.blame_line() end, desc = 'Git blame line' },

    -- Picker
    { '<leader>fd', function() Snacks.picker.diagnostics() end, desc = 'Find Diagnostics' },
    { '<leader>ff', function() Snacks.picker.files() end, desc = 'Find Files' },
    { '<leader>fg', function() Snacks.picker.grep() end, desc = 'Find Grep' },
    { '<leader>fh', function() Snacks.picker.help() end, desc = 'Find Help' },
    { '<leader>fk', function() Snacks.picker.keymaps() end, desc = 'Find Keymaps' },
    { "<leader>fn", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Neovim Files" },
    { '<leader>fp', function() Snacks.picker() end, desc = 'Find Picker' },
    { '<leader>fq', function() Snacks.picker.qflist() end, desc = 'Find quickfix list' },
    { '<leader>fr', function() Snacks.picker.resume() end, desc = 'Find Resume' },
    { '<leader>fu', function() Snacks.picker.undo() end, desc = 'Find Undo History' },
    { '<leader>fw', function() Snacks.picker.grep_word() end, desc = 'Find current selection or word', mode = { 'n', 'x' } },
    { '<leader>f.', function() Snacks.picker.recent() end, desc = 'Find Recent Files ("." for repeat)' },
    { '<leader>f/', function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { '<leader>/', function() Snacks.picker.lines() end, desc = 'Fuzzily search in current buffer' },
    { '<leader><space>', function() Snacks.picker.smart() end, desc = 'Smart Find Files' },
  },
}
