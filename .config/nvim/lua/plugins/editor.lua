return {
  {
    "folke/snacks.nvim",
    opts = {
      terminal = {
        win = {
          style = "float",
          width = math.floor(vim.o.columns * 0.5),
          height = math.floor(vim.o.lines * 0.5),
        },
      },
    },
  },
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
        position = "float",
      },
    },
    keys = {
      { "<leader>e", "<cmd>Neotree reveal float toggle<cr>" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
  },
  { "github/copilot.vim" },
  { "MeanderingProgrammer/render-markdown.nvim" },
}
