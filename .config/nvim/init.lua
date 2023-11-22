-- Options

vim.o.mouse  = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.shiftwidth = 0
vim.o.tabstop = 4
vim.o.swapfile = false
vim.o.writebackup = false
vim.o.undofile = true

vim.g.mapleader = " "

-- Theme

vim.cmd("colorscheme habamax")

-- Plugins

require("plugins")
