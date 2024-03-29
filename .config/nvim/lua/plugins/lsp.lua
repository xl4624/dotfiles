return {
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
}
