return {
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- Ensure it loads first
  },
  { "Mofiqul/vscode.nvim", priority = 1000 },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vscode",
    },
  },
}
