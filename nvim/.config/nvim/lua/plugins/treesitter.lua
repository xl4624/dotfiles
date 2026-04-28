return {
  'neovim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  lazy = false,
  dependencies = {
    'neovim-treesitter/treesitter-parser-registry',
    { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
    'nvim-treesitter/nvim-treesitter-context',
  },
  config = function()
    require('nvim-treesitter').install {
      'bash',
      'c',
      'diff',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'vim',
      'vimdoc',
    }

    vim.filetype.add {
      filename = {
        ['.tmux.conf'] = 'bash',
        ['tmux.conf'] = 'bash',
      },
    }

    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })

    require('nvim-treesitter-textobjects').setup {
      select = { lookahead = true },
    }

    local select = require('nvim-treesitter-textobjects.select')
    local map = function(lhs, query, group, desc)
      vim.keymap.set({ 'x', 'o' }, lhs, function()
        select.select_textobject(query, group)
      end, { desc = desc })
    end
    map('af', '@function.outer', 'textobjects', 'Select outer part of a function')
    map('if', '@function.inner', 'textobjects', 'Select inner part of a function')
    map('ac', '@class.outer', 'textobjects', 'Select outer part of a class region')
    map('ic', '@class.inner', 'textobjects', 'Select inner part of a class region')
    map('as', '@local.scope', 'locals', 'Select language scope')

    require('treesitter-context').setup()
  end,
}
