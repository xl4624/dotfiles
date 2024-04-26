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
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "lunaperche",
    },
  },
}
