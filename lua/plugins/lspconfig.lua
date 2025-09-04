return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          capabilities = { offsetEncoding = { "utf-16" } },
        },
        tailwindcss = {},
        denols = {
          single_file_support = false,
          root_dir = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc"),
        },
        vtsls = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
          settings = {
            typescript = {
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
              },
            },
          },
          single_file_support = false,
          root_dir = function(fname)
            if not vim.fs.root(fname, { "deno.json", "deno.jsonc" }) then
              return vim.fs.root(fname, { "tsconfig.json", "package.json", ".git" })
            end
          end,
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    lazy = false,
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
      },
    },
  },
}
