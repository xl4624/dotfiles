return {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
    },
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    config = function()
        require("noice").setup({
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                },
            },
            -- you can enable a preset for easier configuration
            presets = {
                -- bottom_search = true, -- use a classic bottom cmdline for search
                command_palette = true,       -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                lsp_doc_border = false,       -- add a border to hover docs and signature help
            },
            messages = {
                enabled = false,
            },
            -- popupmenu = {
            --     enabled = false,
            -- },
            notify = {
                enabled = false,
            },
        })
    end,
    keys = {
        vim.keymap.set("n", "<leader>nd", function() vim.cmd("Noice dismiss") end,
            { noremap = true, silent = true, desc = "Dismiss noice" }),
        vim.keymap.set("n", "<leader>nn", function() vim.cmd("Noice enable") end,
            { noremap = true, silent = true, desc = "Enable noice" }),
        vim.keymap.set("n", "<leader>nx", function() vim.cmd("Noice disable") end,
            { noremap = true, silent = true, desc = "Disable noice" }),
    }
}
