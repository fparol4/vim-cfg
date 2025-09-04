return {
  "Diogo-ss/42-header.nvim",
  cmd = { "Stdheader" },
  opts = {
    default_map = true,
    auto_update = false,
    user = "fparola",
    mail = "fabricio.parola@gmail.com",
  },
  config = function(_, opts)
    require("42header").setup(opts)
  end,
}
