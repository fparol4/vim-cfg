return {
  "Diogo-ss/42-header.nvim",
  cmd = { "Header" },
  opts = {
    default_map = true,
    auto_update = true,
    user = "fparola",
    mail = "fabricio.parola@gmail.com",
  },
  config = function(_, opts)
    require("42header").setup(opts)
  end,
}
