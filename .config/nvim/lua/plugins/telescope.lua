return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
            },
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    layout_strategy = "horizontal",
                    layout_config = {
                        horizontal = {
                            preview_width = 0.55,
                            results_width = 0.8,
                            mirror = false,
                        },
                        vertical = {
                            mirror = false,
                        },
                        width = 0.87,
                        height = 0.80,
                        preview_cutoff = 75,
                    },
                    file_ignore_patterns = { 
                        ".git",
                        "node_modules",
                        "pyrightconfig.json",
                    },
                },
            })
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
            vim.keymap.set("n", "<leader>fs", function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") })
            end, { desc = "Grep string" })
            vim.keymap.set("n", "<leader>pf", builtin.git_files, { desc = "Git files" })
        end
    },
}
