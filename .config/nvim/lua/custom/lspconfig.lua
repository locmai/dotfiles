local M = {}
local map = vim.keymap.set
local lspconfig = require("lspconfig")

-- export on_attach & capabilities
M.on_attach = function(_, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
  map("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
  map("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
  map("n", "<leader>sh", vim.lsp.buf.signature_help, opts("Show signature help"))
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Add workspace folder"))
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Remove workspace folder"))

  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts("List workspace folders"))

  map("n", "<leader>D", vim.lsp.buf.type_definition, opts("Go to type definition"))

  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
  map("n", "gr", vim.lsp.buf.references, opts("Show references"))
end

-- disable semanticTokens
M.on_init = function(client, _)
  if client.supports_method("textDocument/semanticTokens") then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

M.defaults = function()
  lspconfig.lua_ls.setup({
    on_attach = M.on_attach,
    capabilities = M.capabilities,
    on_init = M.on_init,

    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
      },
    },
  })

  local servers = {
    "html",
    "cssls",
    "rust_analyzer",
    "nil_ls",
    "jsonnet_ls",
    "gopls",
    "dagger",
    "terraformls",
    "omnisharp",
    "ruff",
  }

  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
      on_attach = M.on_attach,
      on_init = M.on_init,
      capabilities = M.capabilities,
    })
  end

  -- helm_ls with yamlls integration for Kubernetes schemas
  lspconfig.helm_ls.setup({
    on_attach = M.on_attach,
    on_init = M.on_init,
    capabilities = M.capabilities,
    settings = {
      ["helm-ls"] = {
        yamlls = {
          enabled = true,
          path = "yaml-language-server",
          config = {
            schemas = {
              kubernetes = "*",
            },
            completion = true,
            hover = true,
          },
        },
      },
    },
  })

  -- yamlls with Kubernetes schemas, excluding Helm templates
  lspconfig.yamlls.setup({
    on_attach = M.on_attach,
    on_init = M.on_init,
    capabilities = M.capabilities,
    filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
    settings = {
      yaml = {
        schemas = {
          kubernetes = "/*.k8s.yaml",
          ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
          ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
          ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
          ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
          ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
          ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "*.gitlab-ci.{yml,yaml}",
          ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
          ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "**/argo-workflows/*.{yml,yaml}",
        },
        validate = true,
        completion = true,
        hover = true,
      },
    },
  })
end

return M
