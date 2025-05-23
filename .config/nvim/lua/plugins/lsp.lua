return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    ui = {
      icons = {
        package_pending = " ",
        package_installed = " ",
        package_uninstalled = " ",
      },
    },
    max_concurrent_installers = 10,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "rust-analyzer",
        "helm-ls",
        "ruff-lsp",
        "yaml-language-server",
        "gopls",
        "nil",
        "jsonnet-language-server",
        "terraform-ls",
        "omnisharp",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("custom.lspconfig").defaults()
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff format" },
        rust = { "rustfmt", lsp_format = "fallback" },
        hcl = { "hclfmt" },
        nix = { "alejandra" },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
    ensure_installed = {
      "go",
      "lua",
      "vim",
      "vimdoc",
      "query",
      "markdown",
      "markdown_inline",
      "rust",
      "jsonnet",
      "hcl",
      "terraform",
    },

    auto_install = true,
  },
}
