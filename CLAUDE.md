# CLAUDE.md

Guidance for agents working in this Neovim configuration.

## Overview

Neovim 0.12+ Lua config with lazy.nvim. Modular layout: core settings, keymaps, and plugins. No colorscheme plugins or local themes (Neovim default colorscheme).

## Architecture

### Entry Point
- `init.lua` → `require("configurations")`

### Core (`lua/configurations/`)
- `init.lua` — leader, `have_nerd_font`, loads set/colors/remap/lazy
- `set.lua` — options, undo under `stdpath("state")/undo`, diagnostic virtual lines
- `colors.lua` — syntax colors mapped to terminal ANSI slots (`termguicolors` off, so Neovim follows the terminal theme)
- `remap.lua` — custom keybindings
- `lazy.lua` — bootstraps lazy.nvim, `require("lazy").setup("plugins")`

### Plugins (`lua/plugins/`)
Each file returns a lazy.nvim spec. Notable:
- `lsp-config.lua` — Mason v2 + mason-lspconfig v2 (`automatic_enable` whitelist) + nvim-lspconfig
- `telescope.lua` — vertical layout, fzf-native, ui-select
- `neo-tree.lua` — toggle with `\`
- `completions.lua` — nvim-cmp + LuaSnip + cmp-buffer
- `treesitter.lua` — nvim-treesitter `main`; async `install()` + `vim.treesitter.start`
- `conform.lua` — manual format via `<leader>gf`
- `lualine.lua` — custom theme from terminal ANSI slots; mode/location pills colored per mode
- `which-key.lua` — descriptions in `opts.spec`

## Keybindings

- Leader: `<Space>`
- `<leader>pv` — Ex file explorer
- `<leader>c` — close buffer
- `<leader>v` / `<leader>s` / `<leader>h/j/k/l` — splits / navigate
- `<leader>pf` — find files
- `<leader>pg` or `<C-p>` — git files
- `<leader>fg` — live grep
- `<leader>ps` — grep string
- `<leader>gf` — format buffer (conform)
- `\` — NeoTree
- `jk` — exit insert
- `J`/`K` visual — move lines
- `gc` / `gcc` — built-in comments

## LSP

Neovim 0.12 defaults: `gra` code action, `grn` rename, `grr` references, `gO` document symbols.

Custom on attach: `gd` / `gD` / `K` / `<leader>ca`. Diagnostics: `[d` / `]d` / `U`.

TS: `ts_ls`, rooted at the nearest `package.json`.
Angular: only when `angular.json` / `nx.json` found.
SourceKit: Apple `xcrun` (not Mason), Swift only.

Diagnostic navigation (`[d` / `]d`) uses the 0.12 defaults, which wrap at buffer ends.

Mason `ensure_installed` / `automatic_enable` whitelist: lua_ls, zls, tailwindcss, angularls, svelte, ts_ls.
