# Grisaille

Grisaille is an independent, MIT-licensed dark Neovim colorscheme with nine
combinations of temperature and depth. See the
[project specification](.scratch/grisaille/spec.md) for its palette and design.

## Companion themes

The same nine public names are available for Bat (`extras/bat/*.tmTheme`),
Ghostty (`extras/ghostty/*`, extensionless), and OpenCode
(`extras/opencode/*.json`):

| Temperature | Hard | Medium | Soft |
| --- | --- | --- | --- |
| Balanced | `grisaille` | `grisaille-medium` | `grisaille-soft` |
| Warm | `grisaille-warm` | `grisaille-warm-medium` | `grisaille-warm-soft` |
| Cool | `grisaille-cool` | `grisaille-cool-medium` | `grisaille-cool-soft` |

- **Bat:** Copy the nine `.tmTheme` files into `$(bat --config-dir)/themes/`,
  run `bat cache --build`, then select one with `bat --theme=grisaille-warm` or
  `BAT_THEME=grisaille-warm`.
- **Ghostty:** Copy the nine extensionless files into
  `~/.config/ghostty/themes/` (or `$XDG_CONFIG_HOME/ghostty/themes/`), then
  set `theme = grisaille-warm` in your Ghostty configuration.
- **OpenCode:** Copy the nine `.json` files into `~/.config/opencode/themes/`
  (or `$XDG_CONFIG_HOME/opencode/themes/`), then set
  `"theme": "grisaille-warm"` in `opencode.json`.

Each file's stem is the exact name to select. The Bat plist also stores that
name internally; Ghostty and OpenCode identify custom themes by filename.
Companion colors are generated from the shipped palette without user callbacks.
To regenerate after changing the palette, run
`nvim --headless --clean -l scripts/extras.lua`; `make test_file
FILE=tests/test_extras.lua` checks the committed files against fresh renders.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development, reference, commit, and
release guidance.

## License and attribution

Grisaille is licensed under the [MIT License](LICENSE). The Cendre architectural
reference has its own MIT license; its copyright and license notice are included
in [NOTICE](NOTICE).
