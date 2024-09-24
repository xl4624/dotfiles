return {
  'kawre/leetcode.nvim',
  build = ':TSUpdate html',
  lazy = false,
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'nvim-lua/plenary.nvim', -- required by telescope
    'MunifTanjim/nui.nvim',

    -- optional
    'nvim-treesitter/nvim-treesitter',
    -- 'rcarriga/nvim-notify',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    lang = 'cpp',
    injector = {
      ['python3'] = {
        before = { 'from typing import List, Set', 'from collections import defaultdict, Counter', 'from functools import cache' },
      },
      ['cpp'] = {
        before = { '#include <bits/stdc++.h>', 'using namespace std;' },
        after = 'int main() {}',
      },
      ['java'] = {
        before = 'import java.util.*;',
      },
    },
  },
  keys = {
    { '<leader>lf', '<cmd>Leet tabs<cr>', desc = 'Opens a picker with all currently opened question tabs' },
    { '<leader>lc', '<cmd>Leet console<cr>', desc = 'Console pop-up for currently opened question' },
    { '<leader>lh', '<cmd>Leet info<cr>', desc = 'Get information about the currently opened question' },
    { '<leader>ll', '<cmd>Leet lang<cr>', desc = 'Change the language of the current question' },
    { '<leader>ld', '<cmd>Leet desc<cr>', desc = 'Toggle question description' },
    { '<leader>lr', '<cmd>Leet run<cr>', desc = 'Run currently opened question' },
    { '<leader>ls', '<cmd>Leet submit<cr>', desc = 'Submit currently opened question' },
    { '<leader>ly', '<cmd>Leet yank<cr>', desc = 'Yanks the current question solution' },
  },
}
