return {
  {
    "ellisonleao/gruvbox.nvim",
    opts = {
      contrast = "hard",
    },
  },
  {
    "tanvirtin/monokai.nvim",
  },
  {
    "danilo-augusto/vim-afterglow",
    config = function()
      vim.g.afterglow_blackout = 0
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
}
