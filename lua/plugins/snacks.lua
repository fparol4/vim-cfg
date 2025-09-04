local nvim_root = vim.fn.getcwd()

return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      ui = { position = "right" },
    },
    picker = {
      hidden = true,
      sources = {
        explorer = {
          layout = { layout = { position = "right" } },
          auto_close = false,
          follow_file = false,
          focus = "list",
          follow = false,
          cwd = nvim_root,
          follow_cwd = false,
        },
      },
    },
    dashboard = { enabled = false },
  },
  config = function(_, opts)
    require("snacks").setup(opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = "SnacksPickerOpen",
      callback = function(event)
        if event.data == "explorer" then
          require("snacks.picker").open("explorer", {
            cwd = nvim_root,
            follow_cwd = false,
          })
        end
      end,
    })
  end,
}
