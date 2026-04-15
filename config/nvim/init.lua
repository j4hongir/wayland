local opt = vim.opt

opt.cursorline = true
opt.cursorcolumn = true
opt.number = true
opt.relativenumber = true
opt.clipboard:append("unnamedplus")
opt.numberwidth = 4
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.termguicolors = true
opt.cmdheight = 1
opt.pumheight = 10
opt.pumwidth = 50
opt.pumblend = 10

opt.hlsearch = true
opt.incsearch = true

opt.autoindent = true
opt.smartindent = true
opt.cindent = true
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4

vim.cmd("syntax enable")
vim.cmd("set background=dark")
vim.cmd("set colorcolumn=88")
vim.cmd("highlight Normal ctermbg=none guibg=none")

vim.cmd([[
call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'              " color theme
Plug 'hrsh7th/nvim-cmp'             " autocompletion engine
Plug 'hrsh7th/cmp-buffer'           " completion: words from open buffers
Plug 'hrsh7th/cmp-path'             " completion: file paths
Plug 'hrsh7th/cmp-nvim-lsp'         " completion: LSP suggestions
Plug 'neovim/nvim-lspconfig'        " LSP configs (pylsp, clangd)
Plug 'numToStr/Comment.nvim'        " gcc to comment line, gc + motion for block
Plug 'nvim-telescope/telescope.nvim'" fuzzy finder: files, oldfiles, grep
Plug 'nvim-lua/plenary.nvim'        " utility library, required by telescope
Plug 'mg979/vim-visual-multi'       " multiple cursors, ctrl+n to select next
Plug 'nvim-lualine/lualine.nvim'    " statusline: mode, branch, filename, position
Plug 'folke/noice.nvim'             " replaces cmdline and messages UI
Plug 'MunifTanjim/nui.nvim'         " UI library, required by noice
Plug 'rcarriga/nvim-notify'         " popup notifications, used by noice
Plug 'lukas-reineke/indent-blankline.nvim' " rainbow indent guides
Plug 'sphamba/smear-cursor.nvim'    " animated cursor movement
Plug 'tpope/vim-surround'           " ysiw( to surround, ds( to delete, cs' to change
Plug 'folke/zen-mode.nvim'          " distraction-free mode, alt+z
Plug 'sindrets/diffview.nvim'       " git diff viewer, :DiffviewOpen
call plug#end()
]])

vim.cmd("colorscheme gruvbox")

require('diffview').setup({
  hg_cmd = nil
})

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map('n', '<A-d>', ':q!<CR>', opts)
map('n', '<A-q>', ':q<CR>', opts)
map('n', '<A-s>', ':w<CR>', opts)
map('n', '<A-k>', ':wq<CR>', opts)
map('n', '<A-o>', 'o<Esc>', opts)
map('n', '<A-O>', 'O<Esc>', opts)
map('n', '<A-l>', '`.', opts)
map('n', '<A-z>', ':ZenMode<CR>', opts)
map('n', '<A-Up>', ':m .-2<CR>==', opts)
map('n', '<A-Down>', ':m .+1<CR>==', opts)

for _, v in ipairs({ 'h', 'j', 'k', 'l', 'c', '+', '-', '=', '_', 'o' }) do
  map('n', '<A-w>' .. v, '<C-w>' .. v, opts)
end
map('n', '<A-w>s', ':split<CR>', opts)
map('n', '<A-w>v', ':vsplit<CR>', opts)

map('i', '<A-space>', '<Esc>', opts)
map('i', '{', '{}<Left>', { noremap = true })
map('i', '(', '()<Left>', { noremap = true })
map('i', '[', '[]<Left>', { noremap = true })
map('i', "'", "''<Left>", { noremap = true })
map('i', '"', '""<Left>', { noremap = true })

map('v', '<Tab>', '>gv', opts)
map('v', '<S-Tab>', '<gv', opts)
map('x', '<A-Up>', ":m '<-2<CR>gv=gv", opts)
map('x', '<A-Down>', ":m '>+1<CR>gv=gv", opts)

map({ 'n', 'x' }, 'd', '"_d', opts)
map('n', 'dd', '"_dd', opts)
map('n', 'x', '"_x', opts)


require('notify').setup({
  stages = "slide",
  timeout = 1000,
  render = "minimal",
  max_width = 30,
  max_height = 10,
})
vim.notify = require('notify')

require('smear_cursor').setup({
  opts = {
    smear_between_buffers = true,
    smear_between_neighbor_lines = true,
    scroll_buffer_space = true,
    legacy_computing_symbols_support = false,
    stiffness = 0.8,
    trailing_stiffness = 0.5,
    distance_stop_animating = 0.5,
    hide_target_hack = false,
  },
  cursor_color = '#928374',
})

require("zen-mode").setup {
  window = {
    backdrop = 1,
    width = 70,
    height = 0.9,
    options = {
      signcolumn = "no",
      number = false,
      relativenumber = false,
      cursorline = false,
      cursorcolumn = false,
      foldcolumn = "0",
      list = false,
    },
  },
  plugins = {
    gitsigns = { enabled = false },
    tmux = { enabled = true },
  },
}

local cmp_status, cmp = pcall(require, 'cmp')
local lsp_status, lspconfig = pcall(require, 'lspconfig')

if cmp_status and lsp_status then
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  cmp.setup({
    mapping = {
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'path' },
      { name = 'buffer' },
    }),
  })

  if vim.lsp.config then
      vim.lsp.config('clangd', { capabilities = capabilities })
      vim.lsp.config('pylsp', {
        capabilities = capabilities,
        settings = {
          pylsp = {
            plugins = {
              pycodestyle = { enabled = true, ignore = { 'W391' }, maxLineLength = 100 },
              pyflakes = { enabled = true },
              pylint = { enabled = false },
              yapf = { enabled = false },
            },
          },
        },
      })
  else
      lspconfig.clangd.setup { capabilities = capabilities }
      lspconfig.pylsp.setup {
        capabilities = capabilities,
        settings = {
          pylsp = {
            plugins = {
              pycodestyle = { enabled = true, ignore = { 'W391' }, maxLineLength = 100 },
              pyflakes = { enabled = true },
              pylint = { enabled = false },
              yapf = { enabled = false },
            },
          },
        },
      }
  end
end

require('lualine').setup {
  options = {
    theme = 'gruvbox',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    globalstatus = true,
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

require("noice").setup({
  cmdline = {
    enabled = true,
    view = "cmdline",
    format = {
      cmdline = { pattern = "^:", icon = "", lang = "vim" },
      search_down = { pattern = "^/", icon = " ", lang = "regex" },
      search_up = { pattern = "^%?", icon = " ", lang = "regex" },
    },
  },
  messages = { enabled = true, },
  popupmenu = { enabled = true },
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = true,
  },
})

local highlight = {
  "RainbowRed", "RainbowYellow", "RainbowBlue", "RainbowOrange",
  "RainbowGreen", "RainbowViolet", "RainbowCyan",
}

local hooks = require("ibl.hooks")
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "RainbowRed",    { fg = "#fb4934" })
  vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#fabd2f" })
  vim.api.nvim_set_hl(0, "RainbowBlue",   { fg = "#83a598" })
  vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#fe8019" })
  vim.api.nvim_set_hl(0, "RainbowGreen",  { fg = "#b8bb26" })
  vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#d3869b" })
  vim.api.nvim_set_hl(0, "RainbowCyan",   { fg = "#8ec07c" })
end)

require("ibl").setup { indent = { highlight = highlight } }


vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if #vim.fn.argv() == 0 then
      vim.cmd([[
        enew
        setlocal buftype=nofile bufhidden=hide nobuflisted
        setlocal nonumber norelativenumber noswapfile
      ]])
      local lines = {
        "", "", "", "", "", "", "",
        "                •  •     ┓•    ",
        "                ┏┳┓┓┏┓┓┏┳┓┏┓┃┓┏┏┳┓",
        "                ┛┗┗┗┛┗┗┛┗┗┗┻┗┗┛┛┗┗",
        "",
        "                [e] New File",
        "                [f] Search",
        "                [r] Recent files",
        "                [q] Quit",
      }
      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
      local bmap = vim.api.nvim_buf_set_keymap
      bmap(0, "n", "e", ":ene <BAR> startinsert<CR>", opts)
      bmap(0, "n", "f", ":Telescope find_files<CR>", opts)
      bmap(0, "n", "r", ":Telescope oldfiles<CR>", opts)
      bmap(0, "n", "q", ":qa<CR>", opts)
    end
  end,
})

local telescope = require('telescope.builtin')
vim.api.nvim_create_user_command('Tabbi', function()
  telescope.oldfiles({
    prompt_title = "Recent Files (Split)",
    attach_mappings = function(_, tmap)
      tmap('i', '<CR>', function(prompt_bufnr)
        local state = require('telescope.actions.state')
        local actions = require('telescope.actions')
        local entry = state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd('split ' .. entry.value)
      end)
      return true
    end,
  })
end, { desc = "Open recent file in split" })


vim.schedule(function()
  vim.notify = require("notify")
end)
