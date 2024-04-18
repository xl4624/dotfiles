return {
  "echasnovski/mini.files",
  lazy = false, -- otherwise won't open as default_explorer
  keys = {
    {
      "<leader>e",
      function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
      end,
      desc = "Open mini.files (Directory of Current File)",
    },
    {
      "<leader>E",
      function()
        require("mini.files").open(vim.uv.cwd(), true)
      end,
      desc = "Open mini.files (cwd)",
    },
    { "<leader>fe", false },
    { "<leader>fE", false },
  },
}
