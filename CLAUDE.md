# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

floating-note.nvim is a Neovim plugin for creating persistent floating notes. It provides a toggle-able floating window that persists notes to disk, with support for daily diary entries.

## Architecture

The plugin follows a modular architecture with separation of concerns across the `control` module:

### Core Components

1. **init.lua** (lua/floating-note/init.lua) - Plugin entry point
   - Exports `setup()` function for initialization
   - Configures default keymapping (`<leader>o`)
   - Determines note file path based on `NVIM_FLOATING_MEMO_DIR` environment variable
   - Falls back to `/tmp/floating-note_YYYY-MM-DD.md` if env var not set
   - Checks for `diary/` subdirectory to store daily notes

2. **control.lua** (lua/floating-note/control/control.lua) - Main controller
   - Implements `toggle_note(name, opts)` - core toggle functionality
   - Coordinates between buffer and window modules
   - Handles window focus and close logic

3. **buf.lua** (lua/floating-note/control/buf.lua) - Buffer management
   - `get_or_create_buf(name)` - Creates or retrieves named buffers
   - Handles file-backed buffers if writable, otherwise creates scratch buffers
   - Sets buffer options: `bufhidden=hide`, `swapfile=false`

4. **window.lua** (lua/floating-note/control/window.lua) - Window management
   - `get_or_open_float(buf, opts)` - Returns existing floating window or creates new one
   - **Important**: Only reuses windows that are floating (`config.relative ~= ""`)
   - Creates centered floating windows with configurable borders and titles

5. **layout.lua** (lua/floating-note/control/layout.lua) - Layout calculations
   - `layout(opts)` - Calculates window dimensions and position
   - Supports both ratio (0 < x < 1) and absolute (x >= 1) sizing
   - Defaults to 80% of editor dimensions, centered

### Key Design Patterns

- **Window Reuse**: The plugin searches for existing floating windows displaying the same buffer and reuses them (window.lua:14-22)
- **File-backed buffers**: Uses real file buffers when path is writable, enabling persistence
- **Toggle behavior**: Current window == floating note window → close; otherwise → focus

## Environment Configuration

- `NVIM_FLOATING_MEMO_DIR` - Base directory for notes
  - If set and contains `diary/` subdirectory, daily notes are stored as `diary/YYYY-MM-DD.md`
  - Otherwise falls back to `/tmp/floating-note_YYYY-MM-DD.md`

## Testing

No test framework is currently configured.

## Development Workflow

This is a simple Lua plugin with no build steps. To develop:

1. Make changes to Lua files in `lua/floating-note/`
2. Source the plugin in Neovim: `:luafile lua/floating-note/init.lua`
3. Test manually with `:lua require('floating-note').setup()` then `<leader>o`
4. For file-backed persistence, set `NVIM_FLOATING_MEMO_DIR` and create a `diary/` subdirectory
