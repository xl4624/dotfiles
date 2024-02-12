return {
    -- "rose-pine/nvim",    -- solid theme
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd.colorscheme("catppuccin-mocha")
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end
}

