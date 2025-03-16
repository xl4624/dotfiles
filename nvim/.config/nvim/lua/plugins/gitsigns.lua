return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },

      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']g', function()
          if vim.wo.diff then
            vim.cmd.normal { ']g', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git change' })

        map('n', '[g', function()
          if vim.wo.diff then
            vim.cmd.normal { '[g', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git change' })

        -- Actions
        -- visual mode
        map('v', '<leader>gs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Git stage hunk' })
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Git reset hunk' })
        -- normal mode
        map('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'Git stage hunk' })
        map('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'Git stage buffer' })
        map('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'Git reset hunk' })
        map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'Git reset buffer' })
        map('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'Git preview hunk' })
        map('n', '<leader>gu', gitsigns.stage_hunk, { desc = 'Git undo stage hunk' })
        map('n', '<leader>gd', gitsigns.diffthis, { desc = 'Git diff against index' })
        map('n', '<leader>gD', function()
          gitsigns.diffthis '@'
        end, { desc = 'Git Diff against last commit' })
        map('n', '<leader>gB', gitsigns.toggle_current_line_blame, { desc = 'Git toggle show blame line' })
        map('n', '<leader>gx', gitsigns.preview_hunk_inline, { desc = 'Git toggle show deleted' })
      end,
    },
  },
}
