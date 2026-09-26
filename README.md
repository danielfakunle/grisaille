# Grisaille

Grisaille is an independent, MIT-licensed dark colorscheme for Neovim 0.10+.
It pairs an achromatic editor canvas with three syntax temperatures and three
background depths. Balanced Hard is the default. A true-color terminal and
`vim.opt.termguicolors = true` are recommended for the intended colors.

## Install and select a theme

With lazy.nvim:

```lua
{
  'danielfakunle/grisaille',
  lazy = false,
  priority = 1000,
  config = function()
    require('grisaille').setup() -- optional; defaults work without setup()
    vim.cmd.colorscheme('grisaille')
  end
}
```

Or add this repository to Neovim's `runtimepath` with your plugin manager and
run `:colorscheme grisaille`. Select any other combination by its exact name:

| Temperature | Hard | Medium | Soft |
| --- | --- | --- | --- |
| Balanced | `grisaille` | `grisaille-medium` | `grisaille-soft` |
| Warm | `grisaille-warm` | `grisaille-warm-medium` | `grisaille-warm-soft` |
| Cool | `grisaille-cool` | `grisaille-cool-medium` | `grisaille-cool-soft` |

Hard, Medium, and Soft change the background elevation, not the role colors.
All themes are dark-only. For the full reference, run `:help grisaille`.

## Configure and switch

Call `setup()` before loading the colorscheme:

```lua
require('grisaille').setup({
  transparent = false,
  dim_inactive = false,
  italic_comments = true,
  italic_virtual_text = false,
  on_colors = function(colors) colors.accent = '#beaee1' end,
  on_highlights = function(highlights, colors)
    highlights.CursorLineNr = { fg = colors.accent, bold = true }
  end,
})
vim.cmd.colorscheme('grisaille')
```

All keys are optional. `transparent` clears shared editor, float, and status
surfaces; completion menus (including blink.cmp) remain painted for readability.
`dim_inactive` paints inactive windows with the deeper ground and is ignored
when transparent. The two italic options are independent. `on_colors(colors)`
mutates a fresh resolved palette before highlights are built;
`on_highlights(highlights, colors)` mutates the full highlight table before it
is applied. Callbacks rerun on every load and switch; generated companion
themes never use them. Use a named colorscheme for a persistent temperature
and depth choice, not setup options.

`:GrisailleVariant warm|balanced|cool` switches temperature without changing
depth. `:GrisailleDepth hard|medium|soft` switches depth without changing
temperature. Both commands complete values and reject invalid arguments without
changing the active theme. `vim.g.colors_name` always reflects the active name.
Lualine's `grisaille` theme follows the active palette; configure lualine after
loading Grisaille for an initially correct statusline. All 16 terminal ANSI
colors follow the active palette as well.

## Roles and palette

Ground and ink are achromatic and shared by every temperature. Syntax roles
keep their meaning when temperature changes:

| Role | Use | Warm | Balanced | Cool |
| --- | --- | --- | --- | --- |
| `keyword` | Keywords, control flow, storage | `#d27789` | `#968dcb` | `#a088cb` |
| `function` | Functions, methods, calls | `#fcba81` | `#e6c58a` | `#e5c493` |
| `literal` | Literal values | `#95aa6a` | `#83ad83` | `#81ae81` |
| `accent` | Properties, fields, parameters, UI accents | `#ed9e7d` | `#d8a69f` | `#74c5bf` |
| `type` | Types, classes, constructors, modules | `#548fa8` | `#5290a3` | `#5b8abb` |

Declared variable and constant names use `fg`, while operators and punctuation
use `dim`. Diagnostics and git state use separate, temperature-independent
semantic roles: `error` `#ea6b8e`, `warn` `#f0bb3b`, `ok` `#43b16a`,
`hint` `#20c9cb`, and `info` `#58bdff`.

| Depth | `deep` | `bg` | `line` | `raised` | `border` | `edge` | `add` | `delete` | `modify` |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Hard | `#0d0d0d` | `#141414` | `#1c1c1c` | `#252525` | `#313131` | `#525252` | `#202515` | `#301d1b` | `#12262e` |
| Medium | `#121212` | `#1a1a1a` | `#222222` | `#2c2c2c` | `#383838` | `#5a5a5a` | `#262c1b` | `#372321` | `#182c35` |
| Soft | `#181818` | `#202020` | `#282828` | `#323232` | `#3e3e3e` | `#616161` | `#2d3221` | `#3e2a28` | `#1f333b` |

Ink is `fg` `#d8d8d8`, `dim` `#959595`, `comment` `#696969`, and
`gutter` `#484848`. Terminal-only auxiliary colors are `#a788ca`,
`#b99bde`, and bright info `#71d5ff`. Selection is an 18% sRGB blend of
`accent` over `bg`; diagnostic tints are 12% blends of semantic colors over
`bg`. These derived values change with the active combination.

Readable text, syntax, diagnostics, and UI target at least 4.5:1 contrast on
their rendered backgrounds (with up to 0.01 tolerance for 8-bit rounding).
Comments are intentionally quieter, but at least 2.8:1; gutters and decorative
marks can be near 2:1. These are the documented exceptions. In Machado-style
protanopia and deuteranopia simulations, some syntax hues converge; Grisaille
preserves legible contrast, hierarchy, and diagnostic distinction rather than
claiming every hue is uniquely identifiable for every viewer.

## Integrations

Grisaille covers built-in UI and syntax, Tree-sitter, LSP semantic tokens and
diagnostics, diff/git, terminal buffers, and lualine. Included plugin groups:
gitsigns, blink.cmp, Snacks, fzf-lua, which-key, Noice, neo-tree, nvim-tree,
netrw, flash, trouble, lazy.nvim, mason, nvim-dap, dap-ui, neotest, mini.nvim,
hlchunk, grug-far, diffview, illuminate, treesitter-context, and
rainbow-delimiters. Plugin floats share `NormalFloat` and `FloatBorder` where
appropriate; completion menus remain painted in transparent mode.

## Companion themes

The same nine names are available for Bat (`extras/bat/*.tmTheme`), Ghostty
(`extras/ghostty/*`, extensionless), and OpenCode (`extras/opencode/*.json`):

- **Bat:** Copy the nine `.tmTheme` files into `$(bat --config-dir)/themes/`,
  run `bat cache --build`, then select one with `bat --theme=grisaille-warm` or
  `BAT_THEME=grisaille-warm`.
- **Ghostty:** Copy the nine extensionless files into
  `~/.config/ghostty/themes/` (or `$XDG_CONFIG_HOME/ghostty/themes/`), then
  set `theme = grisaille-warm` in your Ghostty configuration.
- **OpenCode:** Copy the nine `.json` files into `~/.config/opencode/themes/`
  (or `$XDG_CONFIG_HOME/opencode/themes/`), then set
  `"theme": "grisaille-warm"` in `opencode.json`.

Each file's stem is the exact name to select. Bat also stores the name in its
plist; Ghostty and OpenCode identify custom themes by filename. Companion
colors are generated from the shipped palette without user callbacks. To
regenerate after changing the palette, run
`nvim --headless --clean -l scripts/extras.lua`; `make test_file
FILE=tests/test_extras.lua` checks committed files against fresh renders.

## Troubleshooting

- `E185: Cannot find color scheme`: ensure the plugin is installed and on
  `runtimepath` before calling `:colorscheme`; use one of the exact names above.
- Colors look wrong in a terminal: enable `termguicolors` and a true-color
  terminal; `transparent = true` deliberately exposes the terminal background.
- A callback change does not appear: call `setup()` before `:colorscheme` or
  reload the scheme after changing options. Configure lualine after the first
  Grisaille load.
- Companion theme missing: copy the file with its original name into the
  consuming tool's theme directory; Bat also needs `bat cache --build`.

## Contributing, license, and attribution

See [CONTRIBUTING.md](CONTRIBUTING.md) for pull requests, checks, and release
guidance. Grisaille is licensed under the [MIT License](LICENSE). Cendre is an
architectural reference with its own MIT copyright and license notice in
[NOTICE](NOTICE); it is not a Grisaille runtime dependency.
