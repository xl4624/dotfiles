return {
    "VonHeikemen/lsp-zero.nvim",
    dependencies = {
        --- Uncomment these if you want to manage LSP servers from neovim
        { "williamboman/mason.nvim" },
        { "williamboman/mason-lspconfig.nvim" },

        -- LSP Support
        { "neovim/nvim-lspconfig" },
        -- Autocompletion
        { "hrsh7th/nvim-cmp" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "saadparwaiz1/cmp_luasnip" },
        { "hrsh7th/cmp-nvim-lua" },
        { "L3MON4D3/LuaSnip" },
        { "rafamadriz/friendly-snippets" },
    },
    config = function()
        local lsp_zero = require("lsp-zero")

        lsp_zero.on_attach(function(client, bufnr)
            local opts = {buffer = bufnr, remap = false}

            vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts, { desc = "Go to definition" })
            vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts, { desc = "Go to implementation" })
            vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts, { desc = "Go to declaration" })
            vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts, { desc = "Show hover" })
            vim.keymap.set("n", "<leader>sw", function() vim.lsp.buf.workspace_symbol() end, opts, { desc = "Search workspace symbols" })
            vim.keymap.set("n", "<leader>d", function() vim.diagnostic.open_float() end, opts, { desc = "Open diagnostics" })
            vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts, { desc = "Go to next diagnostic" })
            vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts, { desc = "Go to previous diagnostic" })
            vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts, { desc = "Code action" })
            vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts, { desc = "Signature help" })
        end)

        require("mason").setup({})
        require("mason-lspconfig").setup({
            ensure_installed = {"tsserver", "pyright"},
            handlers = {
                lsp_zero.default_setup,
                lua_ls = function()
                    local lua_opts = lsp_zero.nvim_lua_ls()
                    require("lspconfig").lua_ls.setup(lua_opts)
                end,
                pyright = function()
                    require("lspconfig").pyright.setup({
                        settings = {
                            python = {
                                analysis = {
                                    typeCheckingMode = "off",
                                }
                            }
                        }
                    })
                end,
            }
        })

        local cmp = require("cmp")
        local cmp_select = {behavior = cmp.SelectBehavior.Select}

        cmp.setup({
            sources = {
                {name = "path"},
                {name = "nvim_lsp"},
                {name = "nvim_lua"},
                {name = "luasnip", keyword_length = 2},
                {name = "buffer", keyword_length = 3},
            },
            formatting = lsp_zero.cmp_format(),
            mapping = cmp.mapping.preset.insert({
                ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
        })
    end
}
