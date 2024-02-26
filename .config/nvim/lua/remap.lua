vim.keymap.set("n", "<leader>e", vim.cmd.Explore, { desc = "Explore" })

vim.keymap.set("", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Move to the next search match" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Move to the previous search match" })

vim.keymap.set("n", "<C-c>", function() vim.cmd("%y+") end, { desc = "Copy file to clipboard" })
vim.keymap.set("v", "<leader>y", [["+y]], { desc = "Copy selected to clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Copy line to clipboard" })

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, noremap = true, desc = "Grant file execution permission" })
vim.keymap.set("n", "<leader><leader>", vim.cmd.source, { noremap = true, desc = "Source file" })

vim.keymap.set("n", "<leader>rw", ":%s/<C-r><C-w>/g", { desc = "Replace word under cursor" })

vim.keymap.set("n", "<leader>w", "<C-w>", { silent = true, noremap = true, desc = "Window management" })

vim.keymap.set("n", "<leader>t", ":botright 10split | terminal<CR>", { desc = "Split terminal on bottom" })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, desc = "Exit terminal mode" })
