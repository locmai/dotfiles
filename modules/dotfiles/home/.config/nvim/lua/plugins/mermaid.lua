return {
  {
    "kevalin/mermaid.nvim",
    ft = { "mermaid", "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
    config = function(_, opts)
      require("mermaid").setup(opts)

      local function set_keys(buf)
          vim.keymap.set("n", "<leader>mp", "<cmd>MermaidPreview<CR>", { buffer = buf, desc = "Mermaid Preview" })
          vim.keymap.set("n", "<leader>mf", "<cmd>MermaidFormat<CR>", { buffer = buf, desc = "Mermaid Format" })
          vim.keymap.set("n", "<leader>mr", "<cmd>MermaidRender<CR>", { buffer = buf, desc = "Mermaid Render" })
          vim.keymap.set("n", "<leader>mc", "<cmd>MermaidCopyURL<CR>", { buffer = buf, desc = "Mermaid Copy URL" })
          vim.keymap.set("n", "<leader>mx", "<cmd>MermaidPreviewStop<CR>", { buffer = buf, desc = "Mermaid Stop Preview" })
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "mermaid",
        callback = function(args)
          set_keys(args.buf)
        end,
      })

      -- The plugin lazy-loads on FileType, so the event has already fired for
      -- the buffer that triggered it; apply the maps to it directly.
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == "mermaid" then
          set_keys(buf)
        end
      end
    end,
  },
}
