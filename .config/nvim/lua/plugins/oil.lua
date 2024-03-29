return {
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  {
    "stevearc/oil.nvim",
    priority = 1000,
    opts = function()
     -- Map y to o in oil_preview buffer
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "oil_preview",
        callback = function(params)
          vim.keymap.set("n", "y", "o", { buffer = params.buf, remap = true, nowait = true })
        end,
      })
    end,
  },
}
