--  Plug 'zbirenbaum/copilot.lua'

require('copilot').setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,      
    debounce = 75,          
    keymap = {
      accept = '<Tab>',    
      accept_word = '<C-l>',
      accept_line = '<C-j>',
      next = '<A-]>',      
      prev = '<A-[>',     
      dismiss = '<C-e>', 
    },
  },
  panel = { enabled = false },
  filetypes = {
    python = true,
    lua = true,
    c = true,
    cpp = true,
    ['*'] = true,
  },
})
