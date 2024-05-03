-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.del({ "n", "v" }, "<A-j>")
vim.keymap.del({ "n", "v" }, "<A-k>")
vim.keymap.del("n", "<C-Up>")
vim.keymap.del("n", "<C-Down>")
vim.keymap.del("n", "<C-Left>")
vim.keymap.del("n", "<C-Right>")
vim.keymap.del("n", "<C-h>")
vim.keymap.del("n", "<C-j>")
vim.keymap.del("n", "<C-k>")
vim.keymap.del("n", "<C-l>")
vim.keymap.del("n", "<leader>`")
vim.keymap.del("n", "<leader>-")
vim.keymap.del("n", "<leader>|")

vim.keymap.del({ "i", "x", "n", "s" }, "<C-s>")

-- Windows
vim.keymap.set("n", "<leader>w-", "<C-w>s", { noremap = true, desc = "Split Window Below"})
vim.keymap.set("n", "<leader>w|", "<C-w>v", { noremap = true, desc = "Split Window Right"})
vim.keymap.set("n", "<leader>wh", "<C-w>h", { noremap = true, desc = "Go to Left Window"})
vim.keymap.set("n", "<leader>wj", "<C-w>j", { noremap = true, desc = "Go to Lower Window"})
vim.keymap.set("n", "<leader>wk", "<C-w>k", { noremap = true, desc = "Go to Upper Window"})
vim.keymap.set("n", "<leader>wl", "<C-w>l", { noremap = true, desc = "Go to Right Window"})

-- Remove some default keybinds
vim.keymap.set("n", "<C-q>", "<Nop>")
vim.keymap.set("n", "<A-Right>", "<Nop>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true, noremap = true, desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true, noremap = true, desc = "Move line up" })

vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz", { desc = "Scroll up" })
vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz", { desc = "Scroll down" })

-- stylua: ignore
vim.keymap.set("n", "<C-c>", function() vim.cmd("%y+") end, { desc = "Copy file to clipboard" })
vim.keymap.set("v", "<leader>y", [["+y]], { desc = "Copy selected to clipboard" })
vim.keymap.set("n", "<leader>y", [["+Y]], { desc = "Copy line to clipboard" })

vim.keymap.set("n", "<leader>cp", function()
  if vim.g.copilot_enabled == 0 then
    vim.cmd("Copilot enable")
    vim.notify("Copilot enabled")
    vim.g.copilot_enabled = 1
  else
    vim.cmd("Copilot disable")
    vim.notify("Copilot disabled")
    vim.g.copilot_enabled = 0
  end
end, { noremap = true, desc = "Toggle Copilot" })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, desc = "Exit terminal mode" })
vim.keymap.set("t", "<S-Space>", "<Space>")
