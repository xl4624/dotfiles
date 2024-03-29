return {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.autopep8.with({
                    extra_args = { "--max-line-length", "100" },
                })
            }
        })
    end,
}
