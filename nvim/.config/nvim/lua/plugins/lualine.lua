--  CREDITS: @PLAZMAMA (https://github.com/PLAZMAMA/config/blob/main/nvim/lua/plugins/lualine.lua)
--  Doesn't 'require' Harpoon itself (allowing harpoon to still be lazy-loaded)
local function update_harpoon()
    -- Get current market files
    local harpoon = require("harpoon")

    -- Update harpoon statusline (marks and files)
    local marked_files = harpoon:list():display()
    local marked_file_names = {}
    for _, file in pairs(marked_files) do
        table.insert(marked_file_names, file)
    end
    vim.g.marked_file_names = marked_file_names
end

local function harpoon_files()
    local width = vim.o.columns
    if width < 100 then return "" end

    local cwd = vim.uv.cwd()
    if not cwd then return "" end
    if vim.g.marked_file_names[1] == "" then return "" end
    local current_file = vim.api.nvim_buf_get_name(0)
    local marked_files = ""
    -- Harpoon's corresponding Keybinding number. Ex: <C-7>, <C-8>, ...
    -- Hence the base number is 6 which the index is added to get the keybind number.
    -- The first keybind number is 7 which 6(base number) + 1(index) = 7.
    -- The second keybind number is 8 which 6(base number) + 2(index) = 8.
    -- and so on...
    local key_map = {[1] = "h", [2] = "j", [3] = "k", [4] = "l"}
    for index, file_name in pairs(vim.g.marked_file_names) do
        local abs_path = file_name
        if abs_path:sub(1, 1) ~= "/" then
            abs_path = cwd .. "/" .. abs_path
        end
        local file_highlight = "%#lualine_c_inactive#"
        if abs_path == current_file then
            file_highlight = "%#lualine_c_normal#"
        else
        end
        local keymap_letter = key_map[index] or tostring(index)
        marked_files = marked_files .. file_highlight .. keymap_letter .. ":" .. vim.fs.basename(file_name) .. " "
    end
    return marked_files or ""
end

-- Updates the displayed harpoon files when writing in the harpoon window or in general.
local harpoon_autogroup = vim.api.nvim_create_augroup("HarpoonUpdate", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
    group = harpoon_autogroup,
    pattern = "*",
    callback = update_harpoon,
})

-- Updates the displayed harpoon files when adding files to harpoon.
vim.api.nvim_create_autocmd({ "User" }, {
    group = harpoon_autogroup,
    pattern = "HarpoonAdd",
    callback = update_harpoon,
})

return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "ThePrimeagen/harpoon" },
    opts = {
        options = {
            component_separators = "",
            section_separators = "",
        },
        sections = {
            lualine_b = { "branch", "diff" },
            lualine_c = {"%=", harpoon_files},
            lualine_x = { "filename" },
            lualine_y = { "diagnostics", "location" },
            lualine_z = { "progress" },
        },
    }
}
