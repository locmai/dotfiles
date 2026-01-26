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
    "NickvanDyke/opencode.nvim",
    event = "VeryLazy",
    dependencies = {
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      vim.o.autoread = true
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        provider = {
          enabled = "snacks",
        },
      }

      vim.keymap.set({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode" })
      vim.keymap.set({ "n", "x" }, "<leader>os", function() require("opencode").select() end, { desc = "Select opencode action" })
      vim.keymap.set({ "n", "t" }, "<leader>oo", function() require("opencode").toggle() end, { desc = "Toggle opencode" })
      vim.keymap.set({ "n", "x" }, "<leader>or", function() return require("opencode").operator("@this ") end, { desc = "Add range to opencode", expr = true })
      vim.keymap.set("n", "<leader>ou", function() require("opencode").command("session.half.page.up") end, { desc = "Scroll opencode up" })
      vim.keymap.set("n", "<leader>od", function() require("opencode").command("session.half.page.down") end, { desc = "Scroll opencode down" })
    end,
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
