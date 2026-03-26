return {
  'zbirenbaum/copilot.lua',
  requires = {
    "copilotlsp-nvim/copilot-lsp",
  },
  cmd = 'Copilot',
  opts = {
    suggestion = { enabled = false },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = true,
      gitcommit = true,
    },
  },
}
