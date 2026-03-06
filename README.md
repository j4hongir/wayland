## Advanced dots based on arch
![sway](https://raw.githubusercontent.com/Jahamars/wayland/refs/heads/main/photos/review.png)

---

## tree 
```bash

wayland
.
├── config
│   ├── btop
│   │   ├── btop.conf
│   │   └── themes
│   │       └── gruv.theme
│   ├── cava
│   │   ├── config
│   │   └── shaders
│   ├── gtk-3.0
│   │   └── settings.ini
│   ├── gtk-4.0
│   │   └── settings.ini
│   ├── helix
│   │   └── config.toml
│   ├── hypr
│   │   ├── env.conf
│   │   ├── hypridle.conf
│   │   ├── hyprland.conf
│   │   ├── hyprlock.conf
│   │   └── wallpaper.conf
│   ├── kitty
│   │   └── kitty.conf
│   ├── macchina
│   │   ├── ascii.txt
│   │   ├── macchina.toml
│   │   └── themes
│   │       └── Carbon.toml
│   ├── mimeapps.list
│   ├── nvim
│   │   ├── init.lua
│   │   ├── init.vim.back
│   │   └── minimal.lua
│   ├── pacman.conf
│   ├── starship.toml
│   ├── sway
│   │   └── config
│   ├── swaylock
│   │   └── config
│   ├── swaync
│   │   ├── config.json
│   │   └── style.css
│   ├── tlp.conf
│   ├── tofi
│   │   └── config
│   ├── waybar
│   │   ├── config.jsonc
│   │   ├── style.css
│   │   └── themes
│   │       ├── 0.5
│   │       ├── block
│   │       └── cpc
│   └── wofi
│       └── style.css
├── draft.sh
├── install.sh
├── LICENSE
├── package.list
├── pacmanq.log
├── photos
├── README.md
├── scripts
│   ├── clip.sh
│   ├── hyprsys.sh
│   ├── idle_sway.sh
│   ├── screen.sh
│   ├── swaygg.sh
│   ├── swaysys.sh
│   ├── swaywall.sh
│   ├── tmux.sh
│   ├── tofi
│   │   └── wall.sh
│   ├── wall.sh
│   ├── xdg.sh
│   └── xdg_sway.sh
├── smth
│   ├── fetch.sh
│   ├── pipes.sh
│   └── rain.sh
├── themes
│   ├── gruvbox-cursor
│   │   ├── cursors
│   │   └── index.theme
│   └── gruvbox-dark
│       ├── gtk-2.0
│       ├── gtk-3.0
│       ├── gtk-4.0
│       ├── index.theme
│       └── plank
└── walls
    ├── black.jpg
    ├── nasa.png
    ├── this-wallpaper-is-not-available.png
    └── trees.jpg

43 directories, 437 files

```
---

sway and hyprland are configured almost the same way (and run the same scripts and programs) 
I may miss or change something, but here are my main hotkeys


## sway/hyprland
| | |
|---|---|
|`Super + T`|Terminal|
|`Super + B`|Browser|
|`Super + F`|File Manager|
|`Super + O`|App Launcher|
|`Super + Shift + G`|Obsidian (notes)|
|`Super + Y`|Dashboard|
|`Super + W`|Change wallpaper|
|`Super + Shift + P`|Color picker|
|`Super + Shift + V`|Clipboard (history)|
|`Super + Shift + W`|Screenshot|
|`Super + X`|Close window|
|`Super + E`|Float / tile|
|`Super + Shift + F`|Fullscreen|
|`Super + C`|Change split direction|
|`Super + N`|Split horizontal|
|`Super + M`|Split vertical|
|`Super + Z`|Focus previous window|
|`Super + S`|Show scratchpad|
|`Super + Shift + S`|Send window to scratchpad|
|`Super + H` or `Super + ←`|Focus left|
|`Super + L` or `Super + →`|Focus right|
|`Super + K` or `Super + ↑`|Focus up|
|`Super + J` or `Super + ↓`|Focus down|
|`Super + Shift + H` or `Super + Shift + ←`|Move left|
|`Super + Shift + L` or `Super + Shift + →`|Move right|
|`Super + Shift + K` or `Super + Shift + ↑`|Move up|
|`Super + Shift + J` or `Super + Shift + ↓`|Move down|
|`Super + R`|Enter resize mode (border turns red)|
|`H` or `←`|Shrink width|
|`L` or `→`|Expand width|
|`K` or `↑`|Shrink height|
|`J` or `↓`|Expand height|
|`Escape` or `Enter`|Exit resize mode|
|`Alt + 1 … 6`|Switch to workspace 1–6|
|`Super + Shift + 1 … 6`|Move window to workspace 1–6|
|`F1` — Mute|Toggle mute|
|`F2` — Vol–|Volume down|
|`F3` — Vol+`|Volume up|
|`F4` — Mic mute|Toggle mic mute|
|`F7` — Play/Pause|Play / Pause|
|`F8` — Prev|Previous track|
|`F9` — Next|Next track|
|`F5` — Bright–|Brightness −10%|
|`F6` — Bright+`|Brightness +10%|
|`Super + Shift + Q`|System menu (logout, reboot, lock)|
|`Power button`|System menu|
|`Super + Backspace`|Reload config (Sway only)|


## Shell (ZSH)
| Shortcut           | Description               |
| ------------------ | ------------------------- |
| `ctrl + O`         | Open\|cd (yazi)           |
| `alt + Left/Right` | Move between words        |
| `Home`             | Go to beginning of line   |
| `End`              | Go to end of line         |
| `Up Arrow`         | Search history up         |
| `Down Arrow`       | Search history down       |
| `alt+c`            | fzf folders               |
| `ctrl+r`           | fzf comands               |
| `ctrl+t`           | fzf all files and folders |
| `comand ** + tab`  | fzf all                   |

## Aliases
| Alias | Command/Function |
|-------|-----------------|
| `..` | Move up one directory |
| `...` | Move up two directories |
| `sys` | `systemctl` |
| `pac` | `sudo pacman` |
| `sshr` | Restart SSH service |
| `sshs` | Stop SSH service |
| `sshh` | Check SSH status |
| `ls` | List files with colors |
| `ll` | List files in long format (with hidden) |
| `trash` | Move files to trash |
| `note` | Open notes in micro editor |
| `cpp` | Compile and run C++ files |
| `mkcpp` | Create new C++ file with template |
| `py` | Run Python3 |
| `wip` | Show WiFi IP address |
| `ports` | Show open ports |
| `path` | Display PATH in readable format |
| `hg` | Search through history with grep |


## Kitty Terminal 
| Shortcut | Description |
|----------|-------------|
| `ctrl + B` | Launch new window in current directory |
| `ctrl + H` | Launch tmux script |
| `ctrl + W` | Close window |
| `ctrl + Shift + C` | Copy to clipboard |
| `ctrl + Shift + V` | Paste from clipboard |
| `ctrl + Shift + Left` | Previous tab / Navigate to left window |
| `ctrl + Shift + Right` | Next tab / Navigate to right window |
| `ctrl + Shift + Up` | Move tab up / Navigate to upper window |
| `ctrl + Shift + Down` | Move tab down / Navigate to lower window |


## Tmux  
| Keybinding | Action |
|------------|--------|
| `ctrl-a` | Prefix key (replaces default `ctrl-b`) |
| `ctrl-a ctrl-a` | Send prefix (useful for nested Tmux sessions) |
| `|` | Split window horizontally, keeping the current directory |
| `-` | Split window vertically, keeping the current directory |
| `h` | Move focus to the left pane |
| `j` | Move focus to the lower pane |
| `k` | Move focus to the upper pane |
| `l` | Move focus to the right pane |
| `H` | Resize pane left by 5 units |
| `J` | Resize pane down by 5 units |
| `K` | Resize pane up by 5 units |
| `L` | Resize pane right by 5 units |
| `v` (in copy mode) | Start selection (Vim style) |
| `y` (in copy mode) | Copy selected text (Vim style) |
| `ctrl-c` | Create a new session |
| `X` | Kill session (with confirmation) |
| `r` | Reload Tmux config (`~/.tmux.conf`) and display a message |


## Neovim
| **Shortcut**                     | **Description**                                                                 |
|----------------------------------|---------------------------------------------------------------------------------|
| `i + {`                          | Insert `{}` and place the cursor inside.                                        |
| `i + (`                          | Insert `()` and place the cursor inside.                                        |
| `i + [`                          | Insert `[]` and place the cursor inside.                                        |
| `i + '`                          | Insert `''` and place the cursor inside.                                        |
| `i + "`                          | Insert `""` and place the cursor inside.                                        |
| `alt + d`                        | Force quit the current window (`:q!`).                                          |
| `alt + q`                        | Quit the current window (`:q`).                                                 |
| `alt + s`                        | Save the current file (`:w`).                                                   |
| `alt + k`                        | Save and quit the current file (`:wq`).                                         |
| `alt + SPACE`                    | Exit insert mode (`Esc`).                                                       |
| `TAB`                        | Indent the selected text to the right.                                          |
| `SHIFT + TAB`                | Indent the selected text to the left.                                           |
| `d`                          | Delete without copying to the clipboard.                                        |
| `dd`                         | Delete the current line without copying to the clipboard.                       |
| `x`                              | Delete a single character without copying to the clipboard.                     |
| `alt + o`                        | Add a new line below and stay in normal mode.                                   |
| `alt + SHIFT + O`                | Add a new line above and stay in normal mode.                                   |
| `alt + l`                        | Go to the last changed line.                                                    |
| `alt + UP`                       | Move the current line or selection up.                                          |
| `alt + DOWN`                     | Move the current line or selection down.                                        |
| `alt + UP`                   | Move the selected lines up.                                                     |
| `alt + DOWN`                 | Move the selected lines down.                                                   |
| `alt + w + h`                    | Move focus to the left window.                                                  |
| `alt + w + j`                    | Move focus to the window below.                                                 |
| `alt + w + k`                    | Move focus to the window above.                                                 |
| `alt + w + l`                    | Move focus to the right window.                                                 |
| `alt + w + c`                    | Close the current window.                                                       |
| `alt + w + +`                    | Increase the height of the current window.                                      |
| `alt + w + -`                    | Decrease the height of the current window.                                      |
| `alt + w + s`                    | Split the window horizontally.                                                  |
| `alt + w + v`                    | Split the window vertically.                                                    |
| `alt + w + =`                    | Equalize the size of all windows.                                               |
| `alt + w + _`                    | Maximize the height of the current window.                                      |
| `alt + w + o`                    | Close all other windows except the current one.                                 |
| `alt + z`                        | Toggle Zen Mode.                                                                |
| `e` (on start page)              | Create a new file.                                                              |
| `f` (on start page)              | Open the file search with Telescope.                                            |
| `r` (on start page)              | Open recent files with Telescope.                                               |
| `q` (on start page)              | Quit Neovim.                                                                    |
| `ctrl + n` (in autocompletion)   | Move to the next suggestion.                                                    |
| `ctrl + p` (in autocompletion)   | Move to the previous suggestion.                                                |
| `ctrl + SPACE` (in autocompletion)| Trigger autocompletion.                                                         |
| `ctrl + e` (in autocompletion)   | Close the autocompletion menu.                                                  |
| `ctrl + b` (in autocompletion)   | Scroll documentation up.                                                        |
| `ctrl + f` (in autocompletion)   | Scroll documentation down.                                                      |
| `CR` (in autocompletion)         | Confirm the selected suggestion.                                                |
| `:Tabbi`                         | Open recent files in a horizontal split using Telescope.                        |
