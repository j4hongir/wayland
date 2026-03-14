## advanced dots (arch x wayland)
![sway](https://raw.githubusercontent.com/Jahamars/wayland/refs/heads/main/photos/review.png)

> **Note** 
> Sway and Hyprland are configured identically - they use same keybindings, scripts and programs
> The repo must be cloned into the home directory (e.g. `/home/user/wayland`)


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

## keybindings

### wm (hyprland/sway)
|                                            |                                      |
| ------------------------------------------ | ------------------------------------ |
| `Super + T`                                | Terminal                             |
| `Super + B`                                | Browser                              |
| `Super + F`                                | File Manager                         |
| `Super + O`                                | App Launcher                         |
| `Super + Shift + G`                        | Obsidian (notes)                     |
| `Super + Y`                                | Dashboard                            |
| `Super + W`                                | Change wallpaper                     |
| `Super + Shift + P`                        | Color picker                         |
| `Super + Shift + V`                        | Clipboard (history)                  |
| `Super + Shift + W`                        | Screenshot                           |
| `Super + X`                                | Close window                         |
| `Super + E`                                | Float / tile                         |
| `Super + Shift + F`                        | Fullscreen                           |
| `Super + C`                                | Change split direction               |
| `Super + N`                                | Split horizontal                     |
| `Super + M`                                | Split vertical                       |
| `Super + Z`                                | Focus previous window                |
| `Super + S`                                | Show scratchpad                      |
| `Super + Shift + S`                        | Send window to scratchpad            |
| `Super + H` or `Super + ←`                 | Focus left                           |
| `Super + L` or `Super + →`                 | Focus right                          |
| `Super + K` or `Super + ↑`                 | Focus up                             |
| `Super + J` or `Super + ↓`                 | Focus down                           |
| `Super + Shift + H` or `Super + Shift + ←` | Move left                            |
| `Super + Shift + L` or `Super + Shift + →` | Move right                           |
| `Super + Shift + K` or `Super + Shift + ↑` | Move up                              |
| `Super + Shift + J` or `Super + Shift + ↓` | Move down                            |
| `Super + R`                                | Enter resize mode (border turns red) |
| `H` or `←`                                 | Shrink width                         |
| `L` or `→`                                 | Expand width                         |
| `K` or `↑`                                 | Shrink height                        |
| `J` or `↓`                                 | Expand height                        |
| `Escape` or `Enter`                        | Exit resize mode                     |
| `Alt + 1 … 6`                              | Switch to workspace 1–6              |
| `Super + Shift + 1 … 6`                    | Move window to workspace 1–6         |
| `F1` — Mute                                | Toggle mute                          |
| `F2` — Vol–                                | Volume down                          |
| `F3` — Vol+`                               | Volume up                            |
| `F4` — Mic mute                            | Toggle mic mute                      |
| `F7` — Play/Pause                          | Play / Pause                         |
| `F8` — Prev                                | Previous track                       |
| `F9` — Next                                | Next track                           |
| `F5` — Bright–                             | Brightness −10%                      |
| `F6` — Bright+`                            | Brightness +10%                      |
| `Super + Q`                                | System menu (logout, reboot, lock)   |
| `Power button`                             | System menu                          |
| `Super + Backspace`                        | Reload config (Sway only)            |


### shell (zsh)
|            |                                     |
| ---------- | ----------------------------------- |
| `Ctrl + O` | Open Yazi file manager (cd on exit) |
| `↑ / ↓`    | History search                      |
| `Home`     | Beginning of line                   |
| `End`      | End of line                         |
| `Delete`   | Delete char under cursor            |
| `Ctrl + →` | Jump word forward                   |
| `Ctrl + ←` | Jump word backward                  |
| `Esc Esc`  | Add `sudo` to previous command      |
| `Ctrl + T` | Fuzzy find files (fzf)              |
| `Alt + C`  | Fuzzy cd into directory (fzf)       |
| `Ctrl + R` | Fuzzy search command history (fzf)  |

#### aliases
|                     |                                       |
| ------------------- | ------------------------------------- |
| `..`                | `cd ..`                               |
| `...`               | `cd ../..`                            |
| `wip`               | Local ip                              |
| `gip`               | Public ip                             |
| `py`                | `python3`                             |
| `trash <file>`      | Move to `~/.local/share/Trash`        |
| `hg <query>`        | Bash history grep                     |
| `ports`             | Open ports                            |
| `path`              | PATH                                  |
| `temp`              | Proc temp                             |
| `ycc`               | Yandex cli config                     |
| `gits`              | Show edited and untracked git files   |
| `chrome-proxy`      | Chromium via proxy                    |
| `dpi`               | Proxy                                 |
| `cpp <file.cpp>`    | compile with `g++ -std=c++17` and run |

### terminal (kitty)
| | |
|---|---|
|`Ctrl + Shift + C`|Copy to clipboard|
|`Ctrl + Shift + V`|Paste from clipboard|
|`Ctrl + B`|New window (same cwd)|
|`Ctrl + H`|Launch tmux session (script)|
|`Ctrl + W`|Close window|
|`Ctrl + Shift + Left`|Previous tab / focus window left|
|`Ctrl + Shift + Right`|Next tab / focus window right|
|`Ctrl + Shift + Up`|Move tab up / focus window up|
|`Ctrl + Shift + Down`|Move tab down / focus window down|
|`Alt + Left`|Word jump left|
|`Alt + Right`|Word jump right|

#### tmux
| | |
|---|---|
|`Ctrl + A`|Prefix (replaces default `Ctrl + B`)|
|`Prefix + \|`|Split pane vertically|
|`Prefix + -`|Split pane horizontally|
|`Prefix + H/J/K/L`|Focus pane left/down/up/right|
|`Prefix + Shift + H/J/K/L`|Resize pane left/down/up/right (repeatable)|
|`Prefix + Ctrl + C`|New session|
|`Prefix + X`|Kill session (with confirmation)|
|`Prefix + R`|Reload config|
|`v`|Begin selection (copy mode)|
|`y`|Copy selection (copy mode)|

### editor [nvim](config/nvim/README.md)
