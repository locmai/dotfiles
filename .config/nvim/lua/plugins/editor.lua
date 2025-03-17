return {
  {
    "dinhhuy258/git.nvim",
    event = "BufReadPre",
    opts = {
      keymaps = {
        -- Open blame window
        blame = "<leader>gb",
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        position = "left",
      },
    },
  },
  { "github/copilot.vim" },
  { "MeanderingProgrammer/render-markdown.nvim" },
}
