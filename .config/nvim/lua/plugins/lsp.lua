return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.mapping["<CR>"] = nil
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    keys = function()
      return {
        {
          "<leader>cP",
          ft = "markdown",
          "<cmd>MarkdownPreviewToggle<cr>",
          desc = "Markdown Preview",
        },
      }
    end,
  },

  -- PYTHON
  -- For formatting, use fmt: off and fmt: on or fmt: skip
  -- To ignore certain lsp errors, use type: ignore
}
