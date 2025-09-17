return {
  "neovim/nvim-lspconfig",
  event = "LazyFile",
  dependencies = {
    "mason.nvim",
    "mason-lspconfig.nvim",
  },

  opts = function()
    local util = require("lspconfig.util")

    return {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        inlay_hints = false,
        virtual_text = false,
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
          },
        },
      },

      servers = {
        -- Tailwind sempre pode rodar em paralelo
        tailwindcss = {
          settings = {
            tailwindCSS = {
              includeLanguages = {
                eelixir = "html-eex",
                elixir = "phoenix-heex",
                eruby = "erb",
                heex = "phoenix-heex",
                htmlangular = "html",
                templ = "html",
              },
            },
          },
        },

        -- Deno: só se houver deno.json / deno.jsonc
        denols = {
          single_file_support = false,
          root_dir = util.root_pattern("deno.json", "deno.jsonc"),
          settings = {
            deno = {
              enable = true,
              lint = true,
              suggest = { imports = { hosts = { ["https://deno.land"] = true } } },
            },
          },
        },

        -- TypeScript/JavaScript via vtsls: só se NÃO houver deno.json
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
          root_dir = function(fname)
            if util.root_pattern("deno.json", "deno.jsonc")(fname) then
              return nil -- bloqueia vtsls quando for projeto Deno
            end
            return util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git")(fname)
          end,
          settings = {
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = { completion = { enableServerSideFuzzyMatch = true } },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = { completeFunctionCalls = true },
            },
          },
          -- atalhos úteis no padrão LazyVim
          keys = {
            {
              "gD",
              function()
                local params = vim.lsp.util.make_position_params()
                LazyVim.lsp.execute({
                  command = "typescript.goToSourceDefinition",
                  arguments = { params.textDocument.uri, params.position },
                  open = true,
                })
              end,
              desc = "Goto Source Definition",
            },
            {
              "gR",
              function()
                LazyVim.lsp.execute({
                  command = "typescript.findAllFileReferences",
                  arguments = { vim.uri_from_bufnr(0) },
                  open = true,
                })
              end,
              desc = "File References",
            },
            { "<leader>co", LazyVim.lsp.action["source.organizeImports"], desc = "Organize Imports" },
            { "<leader>cM", LazyVim.lsp.action["source.addMissingImports.ts"], desc = "Add Missing Imports" },
            { "<leader>cu", LazyVim.lsp.action["source.removeUnused.ts"], desc = "Remove Unused Imports" },
            { "<leader>cD", LazyVim.lsp.action["source.fixAll.ts"], desc = "Fix All Diagnostics" },
            {
              "<leader>cV",
              function()
                LazyVim.lsp.execute({ command = "typescript.selectTypeScriptVersion" })
              end,
              desc = "Select TS workspace version",
            },
          },
        },
      },
    }
  end,

  config = function(_, opts)
    local util = require("lspconfig.util")
    local lspconfig = require("lspconfig")

    -- Diagnósticos
    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

    -- Capabilities (autocomplete)
    local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      has_cmp and cmp_nvim_lsp.default_capabilities() or {},
      opts.capabilities or {}
    )

    -- Decide quem habilitar neste workspace (com base no buffer/cwd)
    local function project_has_deno()
      local fname = vim.api.nvim_buf_get_name(0)
      if fname == "" then
        fname = vim.loop.cwd()
      end
      return util.root_pattern("deno.json", "deno.jsonc")(fname) ~= nil
    end
    local is_deno = project_has_deno()

    -- Ajusta flags enabled dinamicamente ANTES do setup
    opts.servers.denols.enabled = is_deno
    opts.servers.vtsls.enabled = not is_deno
    -- tailwindcss fica como está (sem enabled = false)

    -- Helper para setup
    local function setup(server)
      local server_opts = vim.tbl_deep_extend("force", {
        capabilities = vim.deepcopy(capabilities),
      }, opts.servers[server] or {})
      if server_opts.enabled == false then
        return
      end
      lspconfig[server].setup(server_opts)
    end

    -- Mason (API nova)
    local have_mason, mlsp = pcall(require, "mason-lspconfig")
    if have_mason then
      local all = mlsp.get_available_servers()
      local ensure = {}
      for name, server_opts in pairs(opts.servers) do
        server_opts = server_opts == true and {} or server_opts
        if server_opts.enabled ~= false then
          if server_opts.mason == false or not vim.tbl_contains(all, name) then
            setup(name)
          else
            table.insert(ensure, name)
          end
        end
      end
      mlsp.setup({
        ensure_installed = ensure,
        handlers = { setup },
      })
    else
      for name, _ in pairs(opts.servers) do
        setup(name)
      end
    end

    -- Para-choque: se algum plugin subir os dois, derruba o indevido
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local bufnr = args.buf
        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        local has_vtsls, has_denols = false, false
        for _, c in ipairs(clients) do
          if c.name == "vtsls" then
            has_vtsls = true
          end
          if c.name == "denols" then
            has_denols = true
          end
        end
        if has_vtsls and has_denols then
          if is_deno then
            -- projeto Deno: mantém denols, encerra vtsls
            for _, c in ipairs(clients) do
              if c.name == "vtsls" then
                c.stop()
              end
            end
          else
            -- projeto TS/Node: mantém vtsls, encerra denols
            for _, c in ipairs(clients) do
              if c.name == "denols" then
                c.stop()
              end
            end
          end
        end
      end,
    })
  end,
}
