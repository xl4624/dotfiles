return { -- Disable certain features like LSP and treesitter on big files.
  'LunarVim/bigfile.nvim',
  opts = {
    -- Features to disable.
    features = {
      -- 'indent_blankline',
      -- 'illuminate',
      'lsp',
      'treesitter',
      'syntax',
      -- 'vimopts',
      -- 'filetype',
    },
  },
}
