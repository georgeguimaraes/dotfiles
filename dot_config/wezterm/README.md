# WezTerm Configuration

This configuration was inspired by [binbingoloo's dotfiles](https://github.com/binbingoloo/.dotfiles/blob/wezterm-bak/.config/wezterm/README-wezterm.md).

## Structure

```
~/.config/wezterm/
├── wezterm.lua              # Main config entry point
├── utils/
│   └── helpers.lua          # Process icons, utility functions, vim detection
└── config/
    ├── launch.lua           # Launch settings (default shell)
    ├── appearance.lua       # Visual settings, colors, fonts, performance
    ├── keybindings.lua      # All keybindings and key tables
    └── events.lua           # Event handlers (tab titles, status bar, copy operations)
```

## Leader Key

The leader key is `CTRL+a` with a 1.5 second timeout.

## Key Features

### Pane Management
- `CMD+d` - Split pane down (33%)
- `CMD+SHIFT+d` - Split pane right (33%)
- `CMD+z` - Toggle pane zoom
- `CTRL+hjkl` - Navigate between panes (vim-aware)
- `CMD+r` / `CMD+SHIFT+r` - Rotate panes clockwise/counter-clockwise
- `CMD+g` - Pane swap mode
- `LEADER+-` - Split pane vertically
- `LEADER+\` - Split pane horizontally

### Tab Management
- `CMD+[` / `CMD+]` - Navigate between tabs
- `CMD+SHIFT+[` / `CMD+SHIFT+]` - Move tabs
- `CMD+w` - Close current pane
- `CMD+SHIFT+w` - Close current tab

### Leader Key Bindings

- `CTRL+a o` - Open Finder in current directory
- `CTRL+a r` - Enter resize mode
- `CTRL+a y` - Enter copy mode
- `CTRL+a h` - Open command palette
- `CTRL+a v` - Activate copy mode (visual)
- `CTRL+a ,` - Rename tab
- `CTRL+a $` - Rename workspace
- `CTRL+a -` - Split pane vertically
- `CTRL+a \` - Split pane horizontally

#### Resize Mode (`CTRL+a r`)
- `hjkl` or arrow keys - Resize panes
- `Enter/Escape` - Exit mode
- Shows "RESIZE" indicator in status bar

#### Copy Mode (`CTRL+a y`)
- `b` - Copy entire buffer (scrollback)
- `p` - Copy visible pane text
- `l` - Copy line (quick select)
- `r` - Copy regex patterns (IPs, emails, URLs, git hashes, MAC addresses)
- `u` - Open URL (quick select)
- `Enter/Escape` - Exit mode
- Shows "COPY" indicator in status bar

### Utility
- `CMD+/` - Search (case insensitive)
- `CMD+p` - Command palette
- `CMD+u` - Open URL (quick select)
- `CMD+o` - Open Finder in current directory
- `CMD+,` - Open WezTerm config in nvim

### Vim-style Scrolling
- `OPT+k/j` - Scroll up/down one line
- `OPT+u/d` - Scroll up/down half page
- `OPT+b/f` - Scroll up/down full page
- `OPT+g` - Jump to top
- `OPT+SHIFT+g` - Jump to bottom

### Vim Integration
- `CMD+c` - Copy (or `y` in vim)
- `CMD+a` - Select all in vim (ggVG)
- `CMD+s` - Save in vim (:w)

### Terminal Shortcuts
- `OPT+←/→` - Move word backward/forward
- `CMD+←/→` - Move to line start/end
- `CMD+Backspace` - Clear line

## Visual Features

- **Color scheme**: Tokyo Night Moon (custom variant)
- **Font**: VictorMono Nerd Font (500 weight, size 17)
- **Pane dimming**: Inactive panes dim to 80% brightness/saturation
- **Window opacity**: 97% with macOS background blur (30)
- **Tab indicators**: Shows process icon, working directory, and zoom status
- **Mode indicators**: Status bar shows "COPY" (purple) or "RESIZE" (blue) when active
- **Quick select**: Custom colors for match highlighting
- **Unseen output**: Tabs with unseen output are highlighted

## Performance

- WebGPU renderer with high performance preference
- 120 max FPS, 60 animation FPS
- 100,000 line scrollback buffer
