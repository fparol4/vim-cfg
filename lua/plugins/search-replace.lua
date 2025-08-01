return {
  {
    "roobert/search-replace.nvim",
    config = function()
      require("search-replace").setup({
        default_replace_single_buffer_options = "gcI",
      })
      vim.o.inccommand = "nosplit" -- or split
      vim.keymap.set("v", "zh", "<cmd>SearchReplaceSingleBufferVisualSelection<cr>")
      vim.keymap.set("v", "zd", "<cmd>")
    end,
  },
}
