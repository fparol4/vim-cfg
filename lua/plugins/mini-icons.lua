vim.api.nvim_set_hl(0, "FolderLightBlue", { fg = "#1168E3" })

return {
  "nvim-mini/mini.icons",
  opts = {
    file = {
      [".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
      [".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
      [".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
      [".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
      ["eslint.config.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
      ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
      ["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
      ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
    },
    directory = {
      ["src"] = { glyph = "", hl = "FolderLightBlue" },
      ["lib"] = { glyph = "", hl = "FolderLightBlue" },
      ["dist"] = { glyph = "", hl = "FolderLightBlue" },
      ["node_modules"] = { glyph = "", hl = "FolderLightBlue" },
    },
  },
}
