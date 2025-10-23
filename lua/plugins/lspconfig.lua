return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  dependencies = {
    "mason.nvim",
    "mason-lspconfig.nvim",
  },
  config = function()
    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")

    -- Ensure vtsls is installed via mason
    require("mason-lspconfig").setup({
      ensure_installed = { "vtsls" },
    })

    -- Capabilities (autocomplete, snippets, etc.)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if has_cmp then
      capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end

    -- Setup vtsls (TypeScript/JavaScript LSP)
    lspconfig.vtsls.setup({
      capabilities = capabilities,
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      },
      root_dir = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"),
      settings = {
        vtsls = {
          autoUseWorkspaceTsdk = true,
        },
        typescript = {
          updateImportsOnFileMove = { enabled = "always" },
          suggest = { completeFunctionCalls = true },
        },
      },
      on_attach = function(_, bufnr)
        local map = function(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
        end
        map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
        map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
        map("n", "gr", vim.lsp.buf.references, "Goto References")
        map("n", "gi", vim.lsp.buf.implementation, "Goto Implementation")
        map("n", "gt", vim.lsp.buf.type_definition, "Goto Type Definition")
        map("n", "K", vim.lsp.buf.hover, "Hover Docs")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
        map("n", "<leader>ff", function()
          vim.lsp.buf.format({ async = true })
        end, "Format File")
      end,
    })
  end,
}
