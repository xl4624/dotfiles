return {
  'christoomey/vim-tmux-navigator',
  cmd = {
    'TmuxNavigateLeft',
    'TmuxNavigateDown',
    'TmuxNavigateUp',
    'TmuxNavigateRight',
    'TmuxNavigatePrevious',
    'TmuxNavigatorProcessList',
  },
  keys = {
    { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>', desc = 'Move focus to the left window' },
    { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>', desc = 'Move focus to the lower window' },
    { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>', desc = 'Move focus to the upper window' },
    { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>', desc = 'Move focus to the right window' },
  },
}
