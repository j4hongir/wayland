# gruvbox dark, lsp for python and c, vim-plug.

## keymaps
```
alt+s       save
alt+q       quit
alt+k       save and quit
alt+d       force quit

alt+o       new line below, stay in normal mode
alt+O       new line above, stay in normal mode
alt+l       jump to last edit
alt+up/down move line up or down
alt+space   exit insert mode

alt+w s         horizontal split
alt+w v         vertical split
alt+w h/j/k/l   navigate
alt+w c         close
alt+w =         equalize sizes
alt+w o         close all others
alt+w +/-       resize

tab         indent
shift+tab   unindent
alt+up/down move selected block
```

`d`, `dd`, `x` are remapped to delete without yanking. clipboard stays clean, only gets what you yank with `y`.
auto-pairs in insert mode - `{`, `(`, `[`, `'`, `"` close themselves and put cursor inside.

## plugins

### telescope
`:Telescope find_files` - file search  
`:Telescope oldfiles` - recent files  
`:Tabbi` - open recent file in a horizontal split

### lsp + completion
python (`pylsp`) and c/c++ (`clangd`). pycodestyle on, pylint off, max line 100.
```
ctrl+n/p        next/prev item
enter           confirm
ctrl+space      open manually
ctrl+e          close
ctrl+b/f        scroll docs
```

install the servers:
```bash
pip install python-lsp-server
# clangd from your package manager
```

### comment.nvim
`gcc` - toggle line comment  
`gc` + motion - comment block

### vim-visual-multi
`ctrl+n` - select word under cursor, keep pressing for next occurrences  
`\\A` - select all at once  
then just type

### vim-surround
```
ysiw"   surround word with quotes
ds(     remove surrounding parens
cs'"    change ' to "
```

### zen-mode
`alt+z` - 70 chars wide, no numbers, no signs, tmux bar hides too

### diffview
```
:DiffviewOpen               repo diff
:DiffviewFileHistory %      current file history
:DiffviewClose
```

### misc
indent-blankline - rainbow indent guides  
colorizer - renders hex colors like `#fb4934` inline  
smear-cursor - animated cursor movement


## ui
lualine - mode, branch, diagnostics, filename, position  
noice - replaces cmdline, search bar at bottom, lsp hover has border  
nvim-notify - small popups, gone after 1 sec  
color column at 88 (matches black formatter)


## start screen
open nvim without a file:
```
e   new file
f   find files
r   recent files
q   quit
```


## plugin manager
```
:PlugInstall
:PlugUpdate
```

plugins go to `~/.vim/plugged`
