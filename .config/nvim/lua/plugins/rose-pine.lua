return {
    "rose-pine/nvim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd.colorscheme("rose-pine-main")
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        vim.api.nvim_set_hl(0, "Directory", { fg = "#9ccfd8" })
    end
}

