return {
    -- "rose-pine/nvim",       -- solid theme
    -- name = "rose-pine",
    -- "catppuccin/nvim",      -- decent w/ mocha (similar to rose-pine)
    -- name = "catppuccin",
    "morhetz/gruvbox",
    name = "gruvbox",
    lazy = false,
    priority = 1000,
    config = function()
        -- vim.cmd.colorscheme("rose-pine")
        -- vim.cmd.colorscheme("catppuccin-mocha")
        vim.cmd.colorscheme("gruvbox")
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end
}
