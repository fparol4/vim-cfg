local groups = require("bufferline.groups")

return {
  "akinsho/bufferline.nvim",
  options = {
    tab_size = 18,
    max_name_length = 18,
    truncate_names = true,
    enforce_regular_tabs = false,
    show_buffer_icons = true,
    color_icons = true,
    show_buffer_close_icons = true,
    groups = {
      items = {
        groups.builtin.pinned,
      },
    },
    name_formatter = function(buf)
      if groups.builtin.pinned.matcher(buf) then
        return buf.icon
      else
        return buf.name
      end
    end,
  },
}