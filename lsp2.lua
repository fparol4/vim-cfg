return {
  "neovim/nvim-lspconfig",
  event = "LazyFile",
  dependencies = {
    "mason.nvim",
    "mason-org/mason-lspconfig.nvim",
  },
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
          "--style=file",
          "--fallback-style=Google",
        },
        capabilities = { offsetEncoding = { "utf-16" } },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
      },
      denols = {
        single_file_support = false,
        root_dir = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc"),
      },
      vtsls = {
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
        single_file_support = false,
        root_dir = function()
          return not vim.fs.root(0, { "deno.json", "deno.jsonc" })
            and vim.fs.root(0, { "tsconfig.json", "package.json", "jsconfig.json", "bun.lockb", ".git" })
        end,
        settings = {
          complete_function_calls = true,
          diagnostics = {
            enable = false,
          },
          vtsls = {
            inlayHints = { enabled = false },
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
            experimental = { maxInlayHintLength = 30 },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = { completeFunctionCalls = true },
            inlayHints = {
              enumMemberValues = { enabled = false },
              functionLikeReturnTypes = { enabled = false },
              parameterNames = { enabled = "none" },
              parameterTypes = { enabled = false },
              propertyDeclarationTypes = { enabled = false },
              variableTypes = { enabled = false },
            },
          },
          javascript = {
            inlayHints = {
              enumMemberValues = { enabled = false },
              functionLikeReturnTypes = { enabled = false },
              parameterNames = { enabled = "none" },
              parameterTypes = { enabled = false },
              propertyDeclarationTypes = { enabled = false },
              variableTypes = { enabled = false },
            },
          },
        },
      },
    },
  },
}
