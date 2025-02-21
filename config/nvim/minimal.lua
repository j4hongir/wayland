-- Отключаем сетевые плагины и телеметрию
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.clipboard = ""

-- Интерфейс
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Поиск
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Отступы
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Клавиши
vim.api.nvim_set_keymap('n', '<A-d>', ':q!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-q>', ':q<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-s>', ':w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-space>', '<Esc>', { noremap = true, silent = true })

-- Отключение плагинов
vim.cmd("syntax on") -- Подсветка синтаксиса

-- Отключение LSP и автодополнения
vim.g.loaded_nvim_lsp = 1
vim.g.loaded_cmp = 1
vim.g.loaded_luasnip = 1

-- Минимальная строка состояния
vim.opt.laststatus = 2
vim.opt.showmode = false
