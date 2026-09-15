return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function()
      require("lint").linters["markdownlint-cli2"].args = {
        "--config",
        vim.fn.stdpath("config") .. "/markdownlint-cli2.yaml",
        "--",
      }
    end,
  },
}