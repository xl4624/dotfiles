-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.api.nvim_create_autocmd("FileType", { -- Change the default tab width for certain filetypes
  pattern = { "markdown", "lua" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

vim.opt.guicursor = ""
vim.g.autoformat = false -- Disable file autoformatting (use <leader>uf to re-enable and <leader>cf to format the current file)
vim.g.copilot_enabled = 0 -- Disable Copilot at startup (enable using <leader>cp)

vim.opt.foldenable = false
vim.opt.foldmethod = "manual"
vim.opt.clipboard = "" -- Separate clipboard between vim and system

vim.opt.colorcolumn = "80" -- Highlight for long lines
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    vim.opt.colorcolumn = "100"
  end,
})

vim.g.python3_host_prog = "/Users/xiaomin/.pyenv/versions/3.11.5/envs/neovim/bin/python"
