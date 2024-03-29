return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      file_ignore_patterns = {
        ".git/",
        "node_modules/",
        "target/",
      },
    },
  },
  keys = {
    {
      "<leader>ff",
      function()
        require("telescope.builtin").find_files()
      end,
      desc = "Find files",
    },
    {
      "<leader>fF",
      function()
        require("telescope.builtin").find_files({ hidden = true, no_ignore = true, no_ignore_parent = true })
      end,
      desc = "Find files (hidden)",
    },
    {
      "<leader><space>",
      false,
    },
  },
}
