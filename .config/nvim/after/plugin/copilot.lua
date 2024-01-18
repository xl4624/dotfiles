-- Disable Copilot on startup (manually enable with `:Copilot enable`)
vim.g.copilot_enabled = 0

vim.g.copilot_filetypes = { ["*"] = true }

local function toggle_copilot()
    if vim.g.copilot_enabled == 1 then
        vim.g.copilot_enabled = 0
        vim.notify("Copilot disable")
    else
        vim.g.copilot_enabled = 1
        vim.notify("Copilot enable")
    end
end

-- Set <leader>cp to toggle Copilot
vim.keymap.set({'n', 'v'}, '<leader>cp', toggle_copilot, { noremap = true, silent = true})

