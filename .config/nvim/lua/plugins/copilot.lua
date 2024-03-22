return {
    'github/copilot.vim',
    config = function()
        vim.g.copilot_enabled = 0

        vim.g.copilot_filetypes = { ["*"] = true }

        local function toggleCopilot()
            if vim.g.copilot_enabled == 1 then
                vim.g.copilot_enabled = 0
                vim.notify("Copilot disable")
            else
                vim.g.copilot_enabled = 1
                vim.notify("Copilot enable")
            end
        end
        -- Not in keys because it uses the toggleCopilot function
        vim.keymap.set({ 'n', 'v' }, '<leader>cp', toggleCopilot,
            { noremap = true, silent = true, desc = "Toggle Copilot" })
    end,
}
