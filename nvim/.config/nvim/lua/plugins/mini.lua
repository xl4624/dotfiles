return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  lazy = false,
  init = function()
    vim.cmd.colorscheme 'irblack'
  end,
  config = function()
    -- Better Around/Inside textobjects
    --
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup {
      custom_textobjects = {
        C = function(ai_type)
          local line_num = vim.fn.line '.'
          local first_line = 1
          local last_line = vim.fn.line '$'
          local line = vim.fn.getline(line_num)
          local cond = function(l)
            if l:len() > 3 then
              if l:sub(1, 4) == '# %%' then
                return true
              end
            end
            return false
          end
          local found_up = true

          -- Find first line in cell
          while not cond(line) do
            line_num = line_num - 1
            line = vim.fn.getline(line_num)
            if line_num == 1 then
              found_up = false
              break
            end
          end

          if not found_up then
            local cur_pos = vim.api.nvim_win_get_cursor(0)
            return {
              from = { line = cur_pos[1], col = cur_pos[2] + 1 },
            }
          end

          -- If inside, not include cell delimiter
          if ai_type == 'i' then
            first_line = line_num + 1
          else
            first_line = line_num
          end

          -- Find last line in cell
          line_num = vim.fn.line '.'
          line = vim.fn.getline(line_num)
          local found_down = true
          while not cond(line) do
            if line_num == last_line then
              found_down = false
              break
            end
            line_num = line_num + 1
            line = vim.fn.getline(line_num)
          end
          local last_col = line:len()
          if found_down then
            last_line = line_num - 1
            line = vim.fn.getline(last_line)
            last_col = math.max(line:len(), 1)
          else
            last_col = math.max(last_col, 1)
          end
          return { from = { line = first_line, col = 1 }, to = { line = last_line, col = last_col } }
        end,
      },
      n_lines = 500,
    }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()

    -- Navigate and manipulate file system
    --
    -- <leader>e - Open mini.files (current file directory)
    -- <leader>E - Open mini.files (cwd)
    require('mini.files').setup {
      use_as_default_explorer = true,
    }

    -- Git integration
    --
    -- :Git
    require('mini.git').setup()

    -- Icon provider
    require('mini.icons').setup()

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require 'mini.statusline'
    -- set use_icons to true if you have a Nerd Font
    statusline.setup { use_icons = vim.g.have_nerd_font }

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end

    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesActionRename',
      callback = function(event)
        Snacks.rename.on_rename_file(event.data.from, event.data.to)
      end,
    })
  end,
  keys = {
    -- Mini.files
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
