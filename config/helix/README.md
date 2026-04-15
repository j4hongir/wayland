# no plugins needed.

## keymaps
```
alt+s       save
alt+q       quit
alt+d       force quit
alt+space   exit insert/select mode
```
```
x           select whole line
%           select entire file
d           delete selection (yanks by default)
c           change selection (delete and enter insert mode)
u           undo
U           redo
```

### file picker
```
space f     file search
space b     open buffers (recent files / tabs)
space s     document symbol search
space '     global jump list
```

### lsp + completion

```
ctrl+n/p    next/prev item in popup
enter       confirm
ctrl+x      open manually in insert mode
gd          go to definition
gr          go to references
K           hover documentation
space a     code actions
space f     format document
```

check language server status:
```bash
hx --health
```

### comments
`ctrl+c` - toggle line comment (works on multiple cursors/selections too)

### multicursor
```
C           copy cursor to the line below
alt+C       copy cursor to the line above
s           split selection by regex (e.g., select all, press 's', type 'let', hit enter -> cursors on every 'let')
,           remove all cursors except the primary one
space ,     remove only the primary cursor
```

### surround
```
ms"         surround selection with quotes
mr"'        replace surrounding ' with "
md(         delete surrounding ()
mi"         select everything inside quotes
ma(         select everything around (and including) parens
```

### git integration
```
space g     opens git menu
]d          jump to next git change
[d          jump to prev git change
```
