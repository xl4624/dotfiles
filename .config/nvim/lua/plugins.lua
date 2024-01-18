-- This file can be loaded by calling `lua require('plugins')` from your init.vim
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use({
        'nvim-telescope/telescope.nvim',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    })

    use({
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            vim.g.rose_pine_variant = 'dawn'
            vim.cmd.colorscheme('rose-pine')
            vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
        end
    })

    use({
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate'
    })

    use({
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            --- Uncomment these if you want to manage LSP servers from neovim
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lua' },
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    })

    use('mbbill/undotree')

    use({
        "nvim-telescope/telescope-file-browser.nvim",
        requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    })

    use('numToStr/Comment.nvim')

    use('github/copilot.vim')

    use('windwp/nvim-autopairs')
    use('windwp/nvim-ts-autotag')

    use('gelguy/wilder.nvim')

    use({
        'tris203/hawtkeys.nvim',
        config = function()
            require('hawtkeys').setup {
                leader = " ",              -- Default is space
                homerow = 2,               -- Default is 2
                powerFingers = { 2, 3, 6, 7 }, -- Default is {2,3,6,7}
                keyboardLayout = "qwerty", -- Default is qwerty
                customMaps = {
                    -- Add your custom maps here
                },
                highlights = {
                    HawtkeysMatchGreat = { fg = "green", bold = true },
                    HawtkeysMatchGood = { fg = "green" },
                    HawtkeysMatchOk = { fg = "yellow" },
                    HawtkeysMatchBad = { fg = "red" },
                },
            }
        end,
    })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
