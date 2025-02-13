## sway and hypr workstation for advanced users

![sway](https://raw.githubusercontent.com/Jahamars/wayland/refs/heads/main/photos/review.png)

---

⚠️ Warning!
I have a script for automatic installation and configuration of everything you need. However, I do not recommend using it unless you are absolutely sure what it does. Automated setup can lead to unexpected results, especially if you already have a customized system or are using non-standard configurations.

Advice:
I strongly recommend setting everything up manually, step by step. This is not only safer but will also help you better understand how the system works and what changes are being made. If you still decide to use the script, do so at your own risk and make sure to back up your important data before running it.

---

## tree 
```bash

wayland
├── config
│   ├── cava
│   │   ├── config
│   │   └── shaders
│   │       ├── bar_spectrum.frag
│   │       ├── northern_lights.frag
│   │       └── pass_through.vert
│   ├── gtk-3.0
│   │   └── settings.ini
│   ├── gtk-4.0
│   │   └── settings.ini
│   ├── helix
│   │   └── config.toml
│   ├── hypr
│   │   ├── env.conf
│   │   ├── hypridle.conf
│   │   ├── hyprland.conf
│   │   └── hyprlock.conf
│   ├── kitty
│   │   └── kitty.conf
│   ├── macchina
│   │   ├── ascii.txt
│   │   ├── macchina.toml
│   │   └── themes
│   │       └── Carbon.toml
│   ├── nvim
│   │   ├── init.lua
│   │   ├── init.lua.back
│   │   └── init.vim.back
│   ├── starship.toml
│   ├── sway
│   │   └── config
│   ├── swaync
│   │   ├── config.json
│   │   └── style.css
│   ├── waybar
│   │   ├── block
│   │   │   ├── config.jsonc
│   │   │   └── style.css
│   │   ├── config.jsonc
│   │   ├── scripts
│   │   │   ├── bluetooth.sh
│   │   │   ├── brightness.sh
│   │   │   └── music.sh
│   │   └── style.css
│   └── wofi
│       └── style.css
├── draft.sh
├── Gruvbox-Dark
│   ├── gtk-2.0
│   ├── gtk-3.0
│   ├── gtk-4.0
│   ├── index.theme
│   └── plank
│       └── dock.theme
├── install.sh
├── old
│   ├── appfinder.sh
│   ├── brightness.sh
│   ├── idle_hypr.sh
│   ├── idle_sway.sh
│   └── stat.sh
├── package.list
├── photos
│   ├── forneofetch.png
│   └── review.png
├── README.md
├── scripts
│   ├── clip.sh
│   ├── hyprsys.sh
│   ├── idle_sway.sh
│   ├── pipes.sh
│   ├── rain.sh
│   ├── screen.sh
│   ├── swaygg.sh
│   ├── swaysys.sh
│   ├── swaywall.sh
│   ├── tmux.sh
│   ├── wall.sh
│   ├── xdg.sh
│   └── xdg_sway.sh
└── walls
    ├── 83a598.png
    ├── dragon.png
    ├── error.jpg
    ├── gruvwall.png
    ├── kanagawa.png
    └── trees.jpg

```
---

sway and hyprland are configured almost the same way (and run the same scripts and programs) 
I may miss or change something, but here are my main hotkeys


## sway
| Keybinding | Action |
|------------|--------|
| `super + t` | Open Kitty terminal |
| `super + w` | Run wallpaper change script (`swaywall.sh`) |
| `super + p` | Lock screen with `swaylock` |
| `super + b` | Open Chromium |
| `super + f` | Open Thunar file manager |
| `super + Shift + h` | Open Obsidian |
| `super + Shift + p` | Launch `hyprpicker` (color picker) |
| `super + m` | Open YouTube Music in Chromium (PWA mode) |
| `super + Shift + t` | Open Telegram Web in Chromium (PWA mode) |
| `XF86MonBrightnessUp` | Increase brightness by 5% |
| `XF86MonBrightnessDown` | Decrease brightness by 5% |
| `super + x` | Kill focused window |
| `super + z` | Focus previous marked container |
| `super + Left / j` | Focus left window |
| `super + Down / k` | Focus downward window |
| `super + Up / i` | Focus upward window |
| `super + Right / l` | Focus right window |
| `super + Shift + Left / j` | Move window left |
| `super + Shift + Down / k` | Move window down |
| `super + Shift + Up / i` | Move window up |
| `super + Shift + Right / l` | Move window right |
| `super + h` | Split container horizontally |
| `super + v` | Split container vertically |
| `super + c` | Toggle split layout |
| `super + Shift + f` | Toggle fullscreen mode |
| `super + e` | Toggle floating mode |
| `super + Control + Right` | Switch to next workspace |
| `super + Control + Left` | Switch to previous workspace |
| `alt + 1-6` | Switch to workspace 1-6 |
| `super + Shift + 1-6` | Move focused window to workspace 1-6 |
| `super + BackSpace` | Reload Sway configuration |
| `super + Shift + q` | Run system script (`swaysys.sh`) |
| `super + r` | Enter resize mode |
| `super + Shift + v` | Run clipboard script (`clip.sh`) |
| `super + o` | Open Wofi application launcher |
| `super + y` | Run Python dashboard script |
| `super + Shift + w` | Run screen capture script (`screen.sh`) |
| `XF86AudioRaiseVolume` | Increase volume by 5% |
| `XF86AudioLowerVolume` | Decrease volume by 5% |
| `XF86AudioMute` | Toggle mute for speakers |
| `XF86AudioMicMute` | Toggle mute for microphone |
| `XF86AudioPlay` | Play/Pause media |
| `XF86AudioNext` | Next media track |
| `XF86AudioPrev` | Previous media track |


## Shell (ZSH)
| Shortcut | Description |
|----------|-------------|
| `ctrl + O` | Open ranger file manager |
| `alt + Left/Right` | Move between words |
| `Home` (`^[[H`) | Go to beginning of line |
| `End` (`^[[F`) | Go to end of line |
| `Delete` (`^[[3~`) | Delete character |
| `Up Arrow` (`^[[A`) | Search history up |
| `Down Arrow` (`^[[B`) | Search history down |


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


## Neovi
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


## Hyprland
| **Shortcut**                     | **Description**                                                                 |
|----------------------------------|---------------------------------------------------------------------------------|
| `super + Y`                      | Open the dashboard (`$dashboard`).                                              |
| `super + W`                      | Change the wallpaper (`$wall`).                                                 |
| `super + T`                      | Open the terminal (`$terminal`).                                                |
| `super + B`                      | Open the browser (`$browser`).                                                  |
| `super + SHIFT + H`              | Open Obsidian notes (`$notes`).                                                 |
| `super + SHIFT + V`              | Open the clipboard manager (`$clipman`).                                         |
| `super + SHIFT + Q`              | Open the system script (`$sys`).                                                |
| `super + SHIFT + T`              | Open Telegram (`$telegram`).                                                    |
| `super + M`                      | Open YouTube Music (`$music`).                                                  |
| `super + Z`                      | Move focus upwards.                                                             |
| `super + SHIFT + W`              | Take a screenshot (`$screen`).                                                  |
| `super + SHIFT + F`              | Toggle fullscreen mode.                                                         |
| `super + X`                      | Close the active window.                                                        |
| `super + F`                      | Open the file manager (`$fileManager`).                                          |
| `super + E`                      | Toggle floating mode for the active window.                                      |
| `super + O`                      | Open the application launcher (`$menu`).                                         |
| `super + P`                      | Toggle pseudotiling (dwindle layout).                                            |
| `super + C`                      | Toggle split layout (dwindle layout).                                            |
| `super + LEFT`                   | Move focus to the left window.                                                  |
| `super + RIGHT`                  | Move focus to the right window.                                                 |
| `super + UP`                     | Move focus to the window above.                                                 |
| `super + DOWN`                   | Move focus to the window below.                                                 |
| `super + SHIFT + LEFT`           | Move the active window to the left.                                             |
| `super + SHIFT + RIGHT`          | Move the active window to the right.                                            |
| `super + SHIFT + UP`             | Move the active window upwards.                                                 |
| `super + SHIFT + DOWN`           | Move the active window downwards.                                               |
| `super + Q`                      | Move all windows to workspace 4.                                                |
| `super + L`                      | Resize the active window to the right.                                          |
| `super + H`                      | Resize the active window to the left.                                           |
| `super + K`                      | Resize the active window upwards.                                               |
| `super + J`                      | Resize the active window downwards.                                             |
| `ALT + [1-9, 0]`                 | Switch to workspace [1-10].                                                     |
| `super + SHIFT + [1-9, 0]`       | Move the active window to workspace [1-10].                                     |
| `super + S`                      | Toggle special workspace (`magic`).                                             |
| `super + SHIFT + S`              | Move the active window to the special workspace (`magic`).                      |
| `super + MOUSE_DOWN`             | Switch to the next workspace.                                                   |
| `super + MOUSE_UP`               | Switch to the previous workspace.                                               |
| `super + MOUSE_LEFT_CLICK`       | Move the active window (click and drag).                                        |
| `super + MOUSE_RIGHT_CLICK`      | Resize the active window (click and drag).                                      |
| `XF86AudioRaiseVolume`           | Increase volume by 5%.                                                          |
| `XF86AudioLowerVolume`           | Decrease volume by 5%.                                                          |
| `XF86AudioMute`                  | Toggle mute for audio.                                                          |
| `XF86AudioMicMute`               | Toggle mute for the microphone.                                                 |
| `XF86MonBrightnessUp`            | Increase screen brightness by 10%.                                              |
| `XF86MonBrightnessDown`          | Decrease screen brightness by 10%.                                              |
| `XF86AudioNext`                  | Play the next track (requires `playerctl`).                                     |
| `XF86AudioPause`                 | Toggle play/pause (requires `playerctl`).                                       |
| `XF86AudioPlay`                  | Toggle play/pause (requires `playerctl`).                                       |
| `XF86AudioPrev`                  | Play the previous track (requires `playerctl`).                                 |
| `XF86PowerOff`                   | Execute the system script (`$sys`).                                             |



![arch](https://upload.wikimedia.org/wikipedia/commons/7/73/Archlinux-logo-inverted-version.png)
