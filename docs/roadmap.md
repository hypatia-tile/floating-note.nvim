# Roadmap

Rework floating-note.nvim from a single hardcoded diary float into a small,
configurable plugin for multiple named notes. The implementation and its tests
are written by hand; each step ends with the plugin in a working state.

## Design decisions

These were settled before the roadmap was written. A step that needs to depart
from one of them should say so and update this section.

- **Notes are named.** `setup({ notes = { <name> = { path, title, key, window } } })`.
  The name is the identity used by the API, the command and the default title.
- **`path` is a string or a function returning a string.** It is resolved on
  every toggle, `~` is expanded, and the result is made absolute.
- **No defaults.** The plugin ships no notes and no keymaps. A bare `setup()`
  opens nothing. `presets.diary` is exported for users to opt into.
- **One shared float.** The plugin owns a single floating window and remembers
  its window id. Toggling a different note swaps the buffer in place.
- **Notes are always real file buffers**, looked up by exact absolute path.
  Parent directories are created on first write. An unwritable path is
  reported with `vim.notify` at error level; there is no scratch fallback.
- **Autosave on leave**, on by default, disabled with `autosave = false`.
  Only modified buffers are written.
- **The plugin owns layout; the user owns appearance.** Size is a ratio
  (0 < x < 1) or an absolute value (x >= 1), the float is always centred and
  follows `VimResized`. `border`, `title_pos`, `style` and `wo` are
  configurable; a per-note `window` merges over the top-level `window`.
- **Public surface:** `setup(opts)`, `toggle(name)`, `close()`, `presets`,
  and `:FloatingNote [name]`. `toggle_note(path, opts)` is removed. There is
  no `plugin/` directory and no keymaps inside the float.
- **Modules** live flat under `lua/floating-note/`: `init`, `config`,
  `buffer`, `float`, `layout`, `presets`. Only `config` and `float` hold state.
- **Tests** use plenary.nvim's busted runner in headless Neovim.
- **Neovim 0.10 or later.**

### Toggle behaviour

| Situation when a note is toggled | Result |
|---|---|
| No float open | Open the float with that note and focus it |
| Float shows this note and is focused | Close it |
| Float shows this note, focus is elsewhere | Focus it |
| Float shows a different note | Swap the buffer in place; update title and size |

A dynamic `path` that now resolves to a different file (the diary after
midnight) counts as "a different note".

## Steps

### Step 1: Test harness

- [x] Step 1 done

Get one trivial test running before any behaviour changes.

Done when:

- `make test` runs the busted specs under `tests/` in headless Neovim and
  exits non-zero when a spec fails.
- `tests/minimal_init.lua` fetches plenary.nvim into `.tests/` and does not
  read the user's own Neovim configuration.
- `.tests/` is ignored by git.
- One spec exists and passes (for example, that the module can be required).

### Step 2: `config` module and `setup(opts)`

- [ ] Step 2 done

Introduce the data model without touching window or buffer behaviour yet.

Done when:

- `setup(opts)` validates and stores the configuration; invalid input (a
  `path` that is neither string nor function, a non-table `notes`, an unknown
  type for `key`) is reported at `setup()` time, naming the offending note.
- A note's effective window options are the top-level `window` with the
  note's own `window` merged over it, over the built-in defaults.
- Path resolution handles a string, a function, `~`, and relative paths, and
  always yields an absolute path.
- Calling `setup()` again replaces the previous configuration completely.
- `setup()` with no arguments succeeds and defines no notes.
- Specs cover merging, validation failures and path resolution.

### Step 3: `buffer` module

- [ ] Step 3 done

Replace the two-branch buffer creation with one path.

Done when:

- A note buffer is obtained from an absolute path and is always a normal file
  buffer, whether or not the file exists yet.
- Lookup is by exact path: a buffer whose name merely contains or resembles
  the path is never returned.
- Asking twice for the same path returns the same buffer.
- Buffer options are applied identically for new and existing files.
- Saving creates missing parent directories and writes only when the buffer
  is modified.
- A path that cannot be written produces an error notification and no crash.
- Specs cover: new file, existing file, lookalike buffer names, missing
  parent directory, unmodified buffer not written.

### Step 4: `float` module and `toggle(name)`

- [ ] Step 4 done

The core behaviour change: one owned float instead of scanning windows.

Done when:

- `toggle(name)` implements all four rows of the toggle behaviour table.
- The plugin tracks its float by window id and never adopts a floating
  window it did not create.
- If the float is closed by other means (`:q`, `:only`), the next toggle
  opens a fresh one without error.
- A note whose dynamic `path` now resolves elsewhere is swapped in place
  rather than opened as a second float.
- `toggle()` with an unknown name notifies an error listing the defined names.
- `close()` closes the float and is a no-op when none is open.
- At no point is more than one plugin float open.
- `lua/floating-note/control/` and `toggle_note` are gone.
- Specs cover each row of the table, external close, and the path-change swap.

### Step 5: Autosave

- [ ] Step 5 done

Done when:

- A modified note is written when the float closes, when the float swaps to
  another note, when focus leaves the float, and when Neovim exits.
- An unmodified note is not written, and an untouched new note does not
  create an empty file.
- `autosave = false` disables all of the above and leaves `:w` as the only
  way to write.
- All autocmds live in one augroup that `setup()` recreates, so repeated
  `setup()` calls leave no stale handlers.
- Specs cover each trigger, the unmodified case and the opt-out.

### Step 6: Layout and appearance

- [ ] Step 6 done

Done when:

- `layout` is a pure function of the requested size and the editor
  dimensions; it calls no `vim.api` functions and is tested with plain numbers.
- Ratio and absolute sizes both work, and the result is clamped so the float
  including its border always fits on screen.
- Centring accounts for the border and for the command line and status line.
- An open float is resized and recentred on `VimResized`.
- `border`, `title_pos`, `style` and `wo` from the effective window options
  are applied; `wo` defaults to `wrap` and `linebreak` on.
- The title defaults to the note's name and is updated on swap.
- Window options set through `wo` do not leak to other windows.
- Specs cover the layout arithmetic (including tiny editors) and that a swap
  applies the new note's size and title.

### Step 7: Keymaps, command and `presets.diary`

- [ ] Step 7 done

Done when:

- Each note with a `key` gets a normal-mode mapping to its toggle, with a
  description; notes without `key` get none.
- Calling `setup()` again removes mappings created by the previous call.
- `:FloatingNote {name}` toggles that note and completes note names.
- `:FloatingNote` with no argument offers the notes through `vim.ui.select`.
- `presets.diary` resolves to `$NVIM_FLOATING_MEMO_DIR/diary/YYYY-MM-DD.md`
  and is the only place that reads the environment variable or the date. Its
  behaviour when the variable is unset is decided and documented in this step.
- Specs cover mapping creation and cleanup, command dispatch and completion,
  and the preset's path for a fixed date.

### Step 8: Documentation

- [ ] Step 8 done

Done when:

- `README.md` has the correct plugin name, installation, a full `setup()`
  example using `presets.diary` on `<Leader>od` plus a second note, the
  option reference and the toggle behaviour table.
- `CLAUDE.md` describes the new modules, where state lives, the design
  decisions that still hold, and how to run the tests.
- No document mentions `control/`, `toggle_note` or "no test framework".

### Step 9: Continuous integration

- [ ] Step 9 done

Done when:

- A GitHub Actions workflow runs `make test` on push and pull request against
  the minimum supported Neovim and nightly.
