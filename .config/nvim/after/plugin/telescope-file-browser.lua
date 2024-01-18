require('telescope').setup({
    extensions = {
        file_browser = {
            theme = 'ivy',
            layout_strategy = 'horizontal',
            layout_config = {
                width = 0.90,
                height = 0.95,
                preview_cutoff = 75,
                prompt_position = 'top',
            },
            initial_mode = 'normal',
        }
    }
})

require('telescope').load_extension 'file_browser'

-- open file_browser with the path of the current buffer
vim.keymap.set('n', '<leader>e', ':Telescope file_browser path=%:p:h select_buffer=true<CR>', { noremap = true })

-- open file_browser with the path of the current working directory
vim.keymap.set('n', '<leader>E', ':Telescope file_browser<CR>', { noremap = true })

