return {
  "nvimdev/dashboard-nvim",
  lazy = false, 
  opts = function()
    local logo = [[
██████╗ ██╗  ██╗
██╔═████╗╚██╗██╔╝
██║██╔██║ ╚███╔╝ 
████╔╝██║ ██╔██╗ 
╚██████╔╝██╔╝ ██╗
╚═════╝ ╚═╝  ╚═╝
    ]]
    logo = string.rep("\n", 2) .. logo .. "\n\n"
    local opts = {
      theme = "doom",
      hide = {
        statusline = false,
      },
      config = {
        header = vim.split(logo, "\n"),
        center = {
          { action = 'lua LazyVim.pick()()',                           desc = " Find File",       icon = " ", key = "f" },
          { action = 'lua LazyVim.pick("oldfiles")()',                 desc = " Recent Files",    icon = " ", key = "r" },
          { action = 'lua LazyVim.pick("live_grep")()',                desc = " Find Text",       icon = " ", key = "g" },
          { action = 'lua require("persistence").load()',              desc = " Restore Session", icon = " ", key = "s" },
        },
        footer = function()
          return { "working with ♥" }
        end,
      },
    }
    return opts
  end,
}
