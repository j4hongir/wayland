-- Настройки интерфейса
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard:append("unnamedplus")



vim.opt.numberwidth = 4         -- Устанавливаем корректное значение ширины

-- Синтаксис и скроллинг
vim.cmd("syntax on")
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Поиск
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Маппинги для вставки скобок и кавычек
vim.api.nvim_set_keymap('i', '{', '{}<Left>', { noremap = true })
vim.api.nvim_set_keymap('i', '(', '()<Left>', { noremap = true })
vim.api.nvim_set_keymap('i', '[', '[]<Left>', { noremap = true })
vim.api.nvim_set_keymap('i', "'", "''<Left>", { noremap = true })
vim.api.nvim_set_keymap('i', '"', '""<Left>', { noremap = true })


-- Умные отступы
vim.opt.autoindent = true -- Автоматическое копирование отступов с предыдущей строки
vim.opt.smartindent = true -- Смарт-отступы для структурированного кода
vim.opt.expandtab = true -- Преобразование табов в пробелы
vim.opt.shiftwidth = 4 -- Количество пробелов для уровня отступа
vim.opt.tabstop = 4 -- Количество пробелов, которое представляет таб
vim.opt.softtabstop = 4 -- Количество пробелов при нажатии Tab
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.cindent = true -- Специфичные отступы для C/C++ и подобных языко


-- Маппинги для нормального режима
vim.api.nvim_set_keymap('n', '<A-d>', ':q!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-q>', ':q<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-s>', ':w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-k>', ':wq<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-space>', '<Esc>', { noremap = true, silent = true })


-- Цветовая схема и поддержка 24-битных цветов
vim.cmd("highlight Normal ctermbg=none guibg=none")
vim.opt.termguicolors = true

-- Настройка плагинов с использованием packer.nvim (рекомендуется для Lua)
-- или для совместимости с vim-plug
vim.cmd([[
call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'                    " тема 
Plug 'hrsh7th/nvim-cmp'                   " для автодоп 
Plug 'hrsh7th/cmp-buffer'                 " для автодоп 
Plug 'numToStr/Comment.nvim'              " для коментариев 
Plug 'nvim-telescope/telescope.nvim'      " telescope
Plug 'nvim-lua/plenary.nvim'              " зависисмость для telescope 
Plug 'mg979/vim-visual-multi'             " мултикурсор 
Plug 'neovim/nvim-lspconfig'              " LSP для настройки clangd
Plug 'hrsh7th/cmp-nvim-lsp'               " Источник для LSP
Plug 'hrsh7th/cmp-path'                   " Источник для путей
Plug 'nvim-lualine/lualine.nvim'          " строка состояние 
Plug 'norcalli/nvim-colorizer.lua'        " цвета 
Plug 'folke/noice.nvim'                   " сообшение подсказки для командной строки 
Plug 'MunifTanjim/nui.nvim'               " зависимость для noice 
Plug 'rcarriga/nvim-notify'               " уведомлние 
Plug 'lukas-reineke/indent-blankline.nvim'" линии отступов 
Plug 'sphamba/smear-cursor.nvim'          " for cursor efect 
Plug 'tpope/vim-surround'
Plug 'folke/zen-mode.nvim'                " minimal zen mode 

" Treesitter
"Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
"Plug 'nvim-treesitter/nvim-treesitter-textobjects' " Текстовые объекты
"Plug 'nvim-treesitter/playground'                  " Интерактивное дерево синтаксиса
"Plug 'nvim-treesitter/nvim-treesitter-context'     " Индикация текущего контекста

"Plug 'bash-lsp/bash-language-server', { 'do': 'npm install -g bash-language-server' }
"Plug 'Pocco81/TrueZen.nvim'               " zen mode 
"Plug 'sindrets/diffview.nvim'            " сравнение для гит 
"Plug 'L3MON4D3/LuaSnip'                  " сниппеты 
call plug#end()
]])



require("zen-mode").setup {
  window = {
    backdrop = 1, -- затемнение фона (0 = полностью прозрачно, 1 = полностью черный фон)
    width = 70, -- ширина окна (в процентах от ширины экрана или в числах)
    height = 0.9, -- высота окна (в процентах от высоты экрана)
    options = {
      signcolumn = "no", -- скрыть колонку знаков
      number = false, -- отключить номера строк
      relativenumber = false, -- отключить относительные номера строк
      cursorline = false, -- отключить выделение строки курсора
      cursorcolumn = false, -- отключить выделение столбца курсора
      foldcolumn = "0", -- отключить колонку сворачивания
      list = false, -- отключить отображение спецсимволов (например, табуляций)
    },
  },
  plugins = {
    gitsigns = { enabled = false }, -- отключить gitsigns в Zen Mode
    tmux = { enabled = true }, -- отключить tmux (если есть)
  },
  on_open = function() end, -- Функция, которая будет вызвана при открытии Zen Mode
  on_close = function() end, -- Функция, которая будет вызвана при выходе из Zen Mode
}

vim.api.nvim_set_keymap("n", "<M-z>", ":ZenMode<CR>", { noremap = true, silent = true })







-- notify
require('notify').setup({
    stages = "slide", 
    timeout = 1000, 
    render = "minimal", 
    max_widht = 30, 
    mah_height = 10,
})
vim.notify = require('notify')


-- -- treesitter 
-- require'nvim-treesitter.configs'.setup {
--   ensure_installed = { "c", "cpp", "python", "lua", "rust", "bash", "javascript" }, -- Укажите ваши языки
--   sync_install = false, -- Установка синхронно (true для медленных систем)
--   auto_install = true,  -- Автоматическая установка языков при открытии файла
--   highlight = {
--     enable = true,              -- Включить подсветку
--     additional_vim_regex_highlighting = false, -- Отключить стандартную подсветку
--   },
--   indent = {
--     enable = true,              -- Включить авто-отступы
--   },
--   textobjects = {                -- Настройка текстовых объектов
--     select = {
--       enable = true,
--       lookahead = true,          -- Подсказка ближайшего объекта
--       keymaps = {
--         ["af"] = "@function.outer", -- Выбрать всю функцию
--         ["if"] = "@function.inner", -- Внутри функции
--         ["ac"] = "@class.outer",    -- Весь класс
--         ["ic"] = "@class.inner",    -- Внутри класса
--       },
--     },
--     move = {
--       enable = true,
--       set_jumps = true, -- Добавить перемещения в историю `jump`
--       goto_next_start = {
--         ["]f"] = "@function.outer",
--         ["]c"] = "@class.outer",
--       },
--       goto_previous_start = {
--         ["[f"] = "@function.outer",
--         ["[c"] = "@class.outer",
--       },
--     },
--   },
--   playground = {
--     enable = true,
--     updatetime = 25,            -- Время обновления в миллисекундах
--     persist_queries = false,    -- Не сохранять запросы между сессиями
--   },
-- }
--
--
-- -- Настройка индикации текущего контекста
-- require'treesitter-context'.setup{
--   enable = true,                -- Включить
--   throttle = true,              -- Обновлять при прокрутке
--   max_lines = 0,                -- Показать весь контекст (0 - без ограничений)
-- }
--
--
-- -- Ключи для Playground
-- vim.api.nvim_set_keymap('n', '<leader>tp', ':TSPlaygroundToggle<CR>', { noremap = true, silent = true })
--
-- -- Ключи для навигации по текстовым объектам
-- vim.api.nvim_set_keymap('n', '[f', '<cmd>lua vim.treesitter.goto_prev_start("@function.outer")<CR>', { silent = true })
-- vim.api.nvim_set_keymap('n', ']f', '<cmd>lua vim.treesitter.goto_next_start("@function.outer")<CR>', { silent = true })
-- vim.api.nvim_set_keymap('n', '[c', '<cmd>lua vim.treesitter.goto_prev_start("@class.outer")<CR>', { silent = true })
-- vim.api.nvim_set_keymap('n', ']c', '<cmd>lua vim.treesitter.goto_next_start("@class.outer")<CR>', { silent = true })



--cursor efect
require('smear_cursor').setup({
    opts =
    {
        -- Smear cursor when switching buffers or windows.
        smear_between_buffers = true,

        -- Smear cursor when moving within line or to neighbor lines.
        smear_between_neighbor_lines = true,

        -- Draw the smear in buffer space instead of screen space when scrolling
        scroll_buffer_space = true,

        -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
        -- Smears will blend better on all backgrounds.
        legacy_computing_symbols_support = false,
        stiffness = 0.8,               -- 0.6      [0, 1]
        trailing_stiffness = 0.5,      -- 0.3      [0, 1]
        distance_stop_animating = 0.5, -- 0.1      > 0
        hide_target_hack = false, 
    },
    cursor_color = '#928374',
})



vim.cmd("syntax enable")        -- Включение подсветки синтаксиса
vim.cmd("set background=dark") -- Или 'light', если нужно
vim.cmd("colorscheme gruvbox") -- Применить Gruvbox
vim.cmd("set colorcolumn=88") -- линия на 88 строке 




-- Визуальный режим: Tab для сдвига вправо
vim.api.nvim_set_keymap('v', '<Tab>', '>gv', { noremap = true, silent = true })
-- Визуальный режим: Shift-Tab для сдвига влево
vim.api.nvim_set_keymap('v', '<S-Tab>', '<gv', { noremap = true, silent = true })


-- удаление без копирование 
vim.keymap.set('n', 'd', '"_d', { noremap = true })
vim.keymap.set('n', 'dd', '"_dd', { noremap = true })
vim.keymap.set('x', 'd', '"_d', { noremap = true })
vim.keymap.set('n', 'x', '"_x', { noremap = true })

-- custom start page 
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if #vim.fn.argv() == 0 then -- Проверка, что Neovim открыт без аргументов
      vim.cmd([[
        enew
        setlocal buftype=nofile
        setlocal bufhidden=hide
        setlocal nobuflisted
        setlocal nonumber norelativenumber
        setlocal noswapfile
      ]])

      -- Добавляем текст на стартовую страницу
      local lines = {
      	"", 
      	"", 
      	"", 
      	"", 
      	"", 
      	"", 
      	"", 
        "				   •  •     ┓•    ",
        "				┏┳┓┓┏┓┓┏┳┓┏┓┃┓┏┏┳┓",
        "				┛┗┗┗┛┗┗┛┗┗┗┻┗┗┛┛┗┗",
        "",
	    "				[e] New File ",
        "  				[f] Search ",
        "  				[r] Recent files",
        "  				[q] Quit ",
      }
      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

      vim.api.nvim_buf_set_keymap(0, "n", "e", ":ene <BAR> startinsert<CR>", { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, "n", "f", ":Telescope find_files<CR>", { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, "n", "q", ":qa<CR>", { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, "n", "r", ":Telescope oldfiles<CR>", { noremap = true, silent = true })
    end
  end,
})


--  lsp config
local cmp = require'cmp'

cmp.setup({
  sources = {
    { name = 'buffer' }, -- Предлагает завершение из текущего буфера
  },
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item(), -- Перебор вниз
    ['<C-p>'] = cmp.mapping.select_prev_item(), -- Перебор вверх
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Выбор завершения
  },
})

local cmp = require'cmp'
cmp.setup({
  mapping = {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'buffer' },
  })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig').clangd.setup {
  capabilities = capabilities,
}

vim.opt.pumheight = 10  -- Установить максимальную высоту всплывающего меню
vim.opt.pumwidth = 50  -- Установить максимальную ширину всплывающего меню
vim.opt.pumblend = 10  -- Сделать меню полупрозрачным для лучшего восприятия

local nvim_lsp = require('lspconfig')

nvim_lsp.pylsp.setup({
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = { enabled = true, ignore = {'W391'}, maxLineLength = 88 },
        pyflakes = { enabled = true },
        pylint = { enabled = false },
        yapf = { enabled = false },
      },
    },
  },
})


-- Настройка rust-analyzer
require('lspconfig').rust_analyzer.setup({
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    on_attach = function(client, bufnr)
        local buf_map = vim.api.nvim_buf_set_keymap
        local opts = { noremap = true, silent = true }
        buf_map(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_map(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_map(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_map(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    end,
})



-- -- go to last change line at the start 
-- vim.api.nvim_create_autocmd("BufReadPost", {
--   pattern = "*",
--   callback = function()
--     if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
--       vim.cmd("normal! g`\"")
--     end
--   end,
-- })



-- manping to with mowing
vim.api.nvim_set_keymap('n', '<A-Up>', ':m .-2<CR>==', { noremap = true })
vim.api.nvim_set_keymap('n', '<A-Down>', ':m .+1<CR>==', { noremap = true })
vim.api.nvim_set_keymap('x', '<A-Up>', ":m '<-2<CR>gv=gv", { noremap = true })
vim.api.nvim_set_keymap('x', '<A-Down>', ":m '>+1<CR>gv=gv", { noremap = true })

-- Визуальный режим: Tab для сдвига вправо
vim.api.nvim_set_keymap('v', '<Tab>', '>gv', { noremap = true, silent = true })
-- Визуальный режим: Shift-Tab для сдвига влево
vim.api.nvim_set_keymap('v', '<S-Tab>', '<gv', { noremap = true, silent = true })


-- colorizer 
require'colorizer'.setup({
  '*', -- Подключить для всех файлов
  css = { rgb_fn = true }, -- Включить поддержку rgb() в CSS
}, { mode = 'background' })


-- Добавить новую строку ниже при Alt+O
vim.api.nvim_set_keymap('n', '<A-o>', 'o<Esc>', { noremap = true, silent = true })
-- Добавить новую строку выше при Alt+Shift+O
vim.api.nvim_set_keymap('n', '<A-O>', 'O<Esc>', { noremap = true, silent = true })

-- go to last change with A-l
vim.api.nvim_set_keymap('n', '<A-l>', '`.', { noremap = true, silent = true })


-- rounded lualine 
require('lualine').setup {
  options = {
    theme = 'gruvbox', -- Выбор темы
    component_separators = { left = '', right = '' }, -- Мягкие округлённые разделители компонентов
    section_separators = { left = '', right = '' },
    globalstatus = true, -- Для единой строки состояния в Neovim
  },
  sections = {
    lualine_a = { { 'mode', separator = { left = '', right = '' }, right_padding = 2 } },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { { 'location', separator = { left = '', right = '' }, left_padding = 2 } },
  },
}


-- noice notyfy settings 
require("noice").setup({
  cmdline = {
    enabled = true, -- Включить кастомную командную строку
    view = "cmdline", -- Вид для строки команд
    format = {
      cmdline = { pattern = "^:", icon = "", lang = "vim" },
      search_down = { pattern = "^/", icon = " ", lang = "regex" },
      search_up = { pattern = "^%?", icon = " ", lang = "regex" },
    },
  },
  messages = {
    enabled = true, -- Показывать всплывающие уведомления
  },
    -- size = {
    --     width = 40, -- Ширина окна
    --     height = "auto", -- Автоматическая высота
    --   },
    --   border = {
    --     style = "rounded", -- Закруглённые границы
    --     padding = { 0, 1 }, -- Внутренний отступ
    --   },
    --   win_options = {
    --     winblend = 10, -- Прозрачность окна
    --     winhighlight = "Normal:Normal,FloatBorder:FloatBorder", -- Подсветка
    --   },
  popupmenu = {
    enabled = true, -- Включить всплывающие меню для автодополнения
  },
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  presets = {
    bottom_search = true, -- Перенос строки поиска вниз
    command_palette = true, -- Командная палитра
    long_message_to_split = true, -- Длинные сообщения в окно сплита
    inc_rename = false, -- Инкрементальное переименование (опционально)
    lsp_doc_border = true, -- Границы для документации LSP
  },
})




-- hiding comandline
vim.opt.cmdheight = 0



-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
require("ibl").setup()

local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

local hooks = require "ibl.hooks"

hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#fb4934" })     -- Красный
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#fabd2f" })  -- Жёлтый
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#83a598" })    -- Голубой
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#fe8019" })  -- Оранжевый
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#b8bb26" })   -- Зелёный
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#d3869b" })  -- Фиолетовый
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#8ec07c" })    -- Циан
end)

require("ibl").setup { indent = { highlight = highlight } }


-- -- zen mode 
-- require("true-zen").setup {
--   modes = {
--     ataraxis = { -- Режим "Zen"
--       left_padding = 30,  -- Отступ слева
--       right_padding = 30, -- Отступ справа
--       top_padding = 2,    -- Отступ сверху
--       bottom_padding = 2, -- Отступ снизу
--       ideal_writing_area_width = { 0.85 }, -- Ширина текста (в процентах от экрана)
--     },
--   },
-- }
--




-- -- Подключаем LSP
-- local lspconfig = require('lspconfig')
--
-- -- Настройка Bash LSP
-- lspconfig.bashls.setup{}
--
-- -- Подключаем nvim-cmp
-- local cmp = require('cmp')
--
-- cmp.setup({
--   snippet = {
--     expand = function(args)
--       vim.fn["vsnip#anonymous"](args.body) -- Можно заменить на другой сникет-движок
--     end,
--   },
--   mapping = {
--     ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--     ['<C-f>'] = cmp.mapping.scroll_docs(4),
--     ['<C-Space>'] = cmp.mapping.complete(),
--     ['<C-e>'] = cmp.mapping.abort(),
--     ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Подтвердить выбор
--   },
--   sources = cmp.config.sources({
--     { name = 'nvim_lsp' },
--     { name = 'buffer' },
--     { name = 'path' },
--   })
-- })
--
-- -- Подключаем LSP к nvim-cmp
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- lspconfig.bashls.setup{
--   capabilities = capabilities,
-- }
--





local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Переключение между окнами с Alt + w
map('n', '<A-w>h', '<C-w>h', opts)
map('n', '<A-w>j', '<C-w>j', opts)
map('n', '<A-w>k', '<C-w>k', opts)
map('n', '<A-w>l', '<C-w>l', opts)

-- Закрыть текущее окно
map('n', '<A-w>c', '<C-w>c', opts)

-- Увеличить/уменьшить размер окна
map('n', '<A-w>+', '<C-w>+', opts)
map('n', '<A-w>-', '<C-w>-', opts)

-- Разделение окна (сплиты)
map('n', '<A-w>s', ':split<CR>', opts)
map('n', '<A-w>v', ':vsplit<CR>', opts)

-- Переключение размера окон (максимизировать/уменьшить)
map('n', '<A-w>=', '<C-w>=', opts)
map('n', '<A-w>_', '<C-w>_', opts)

-- Закрыть все окна кроме текущего
map('n', '<A-w>o', '<C-w>o', opts)




local telescope = require('telescope.builtin')

-- Создаём пользовательскую команду Tabbi
vim.api.nvim_create_user_command('Tabbi', function()
  telescope.oldfiles({
    prompt_title = "Recent Files (Split Mode)",
    attach_mappings = function(_, map)
      map('i', '<CR>', function(prompt_bufnr)
        local action_state = require('telescope.actions.state')
        local actions = require('telescope.actions')
        local selected_entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        -- Открытие файла в горизонтальном сплите
        vim.cmd('split ' .. selected_entry.value)
      end)
      return true
    end,
  })
end, { desc = "Open recent files in horizontal split" })




