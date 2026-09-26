# Grisaille 0.1.0

Status: ready-for-agent

## Problem Statement

Dark-theme users need a neutral editor canvas that can carry warm, balanced, or cool syntax without changing the theme's structure, readability, or role vocabulary. Cendre demonstrates a strong role model and multi-surface architecture, but its identity and hues are intentionally constrained by measurable properties of a wood fire. Changing Cendre into a neutral family would erase that identity.

Grisaille must therefore be a separate project: a dark Neovim colorscheme with one achromatic structural canvas, three temperature variants, three depths, stable syntax and semantic roles, and a small initial set of generated companion themes. Its first release must feel complete in Neovim, remain consistent across Bat, Ghostty, and OpenCode, and preserve the palette approved in Candidate 3 without depending on prototype code at runtime.

## Solution

Create the MIT-licensed `grisaille.nvim` project for Neovim 0.10 or newer. Grisaille provides Warm, Balanced, and Cool variants at Hard, Medium, and Soft depths. Balanced Hard is the canonical default loaded by `:colorscheme grisaille`; the other eight combinations have explicit colorscheme names.

All combinations share an achromatic ground and ink family, one role map, one semantic family, and one contrast contract. Temperature changes syntax and UI-accent pigments without changing their meaning. Depth changes only the ground beneath them. Users select a combination by colorscheme name, configure behavior through `setup()`, and can switch either axis at runtime.

Version 0.1.0 includes complete Neovim highlights, lualine, Bat, Ghostty, and OpenCode. Companion themes are generated from the same palette source. Cendre is available as a pinned, read-only reference submodule at `docs/reference/cendre`, but Grisaille has independent branding, palette values, terminology, and generated output.

## User Stories

1. As a Neovim user, I want a neutral dark theme, so that syntax color is not biased by a tinted editor background.
2. As a Neovim user, I want Warm, Balanced, and Cool variants, so that I can choose an overall temperature without learning a different role map.
3. As a Neovim user, I want Hard, Medium, and Soft depths, so that I can choose an appropriate background elevation for my environment.
4. As a new user, I want `:colorscheme grisaille` to load the canonical Balanced Hard theme, so that installation requires no additional decision.
5. As a user with a known preference, I want each temperature/depth combination to have an explicit colorscheme name, so that my configuration is declarative and portable.
6. As a user, I want functions to retain one role across all variants, so that temperature changes do not change how I read code.
7. As a user, I want types, literals, keywords, and properties to retain stable roles, so that switching variants does not retrain visual navigation.
8. As a user, I want declared variables and constants to remain ordinary foreground text, so that declaration frequency does not flood the buffer with color.
9. As a user, I want punctuation and operators to remain dim foreground, so that structure stays visible without competing with tokens.
10. As a user, I want diagnostics to use a separate semantic family, so that an error cannot be mistaken for a syntax role.
11. As a user, I want readable syntax and UI text at every depth, so that Soft does not silently sacrifice accessibility.
12. As a user, I want comments to be intentionally subdued but bounded, so that they remain quiet without becoming illegible.
13. As a color-vision-deficient user, I want hierarchy and contrast to remain useful when some hues converge, so that the theme remains navigable.
14. As a user, I want accepted simulation tradeoffs documented, so that accessibility claims are precise rather than absolute.
15. As a user, I want transparent mode to strip shared editor and plugin surfaces, so that my terminal background remains visible consistently.
16. As a completion-menu user, I want completion windows to remain painted in transparent mode, so that suggestions remain readable over code.
17. As a split-window user, I want inactive-window dimming to be opt-in, so that merely opening a split does not change its ground unexpectedly.
18. As a user, I want independent comment and virtual-text italic options, so that typography follows my preferences without changing semantic emphasis.
19. As an advanced user, I want color and highlight callbacks, so that I can customize the resolved theme without forking it.
20. As an advanced user, I want callbacks reapplied after runtime switches, so that customization remains authoritative.
21. As a user, I want to switch temperature at runtime, so that I can compare or adapt the theme without restarting Neovim.
22. As a user, I want to switch depth independently at runtime, so that changing background elevation preserves temperature.
23. As a user, I want invalid runtime values rejected without changing the active theme, so that typos cannot leave Neovim in a partial state.
24. As a lualine user, I want lualine to follow the active palette, so that the statusline does not drift after a runtime switch.
25. As a terminal-buffer user, I want all 16 ANSI colors exported, so that terminal programs harmonize with the editor.
26. As a Bat user, I want all nine Grisaille combinations, so that code previews can match Neovim.
27. As a Ghostty user, I want all nine Grisaille combinations, so that my terminal and editor can use the same palette.
28. As an OpenCode user, I want all nine Grisaille combinations, so that the surrounding development interface matches Neovim.
29. As a user installing multiple combinations, I want every stored theme name to be unique, so that one variant cannot overwrite another.
30. As a contributor, I want generated extras checked for drift, so that committed themes cannot become stale relative to the palette.
31. As a contributor, I want external schemas validated against tools' real implementations, so that silently ignored keys fail before release.
32. As a contributor, I want one high-level smoke suite to load every public theme, so that the behavior users invoke is the behavior tests cover.
33. As a maintainer, I want Cendre pinned as read-only reference material, so that architectural comparisons are reproducible without coupling the projects.
34. As a maintainer, I want project-level attribution rather than repeated source comments, so that legal attribution is present without implementation clutter.
35. As a release manager, I want stable and nightly Neovim CI, so that version-specific regressions are caught before release.
36. As a release manager, I want a manual visual checklist, so that a mathematically valid palette cannot ship with an obvious experiential regression.

## Implementation Decisions

### Identity And Compatibility

- The repository and plugin are named `grisaille.nvim`; the Lua namespace and colorscheme prefix are `grisaille`.
- Grisaille supports Neovim 0.10 or newer and is dark-only.
- The license is MIT.
- Grisaille is a sibling influenced by Cendre's architecture, not a Cendre variant. There is no Cendre configuration compatibility or migration layer.
- Cendre is pinned as a Git submodule at `docs/reference/cendre`. Contributor instructions mark it read-only; advancing it is a dedicated change.
- Attribution appears once in a project-level notice and includes the required Cendre MIT copyright/license notice. Source files do not repeat attribution comments.

### Public Theme Names

| Temperature | Hard | Medium | Soft |
| --- | --- | --- | --- |
| Balanced | `grisaille` | `grisaille-medium` | `grisaille-soft` |
| Warm | `grisaille-warm` | `grisaille-warm-medium` | `grisaille-warm-soft` |
| Cool | `grisaille-cool` | `grisaille-cool-medium` | `grisaille-cool-soft` |

- Balanced Hard is the default.
- `vim.g.colors_name` always equals the exact active name and changes after runtime switching.
- Each entrypoint invokes one shared loader with its temperature and depth; no entrypoint owns a separate palette.

### Configuration And Commands

- `require("grisaille").setup()` accepts `transparent`, `dim_inactive`, `italic_comments`, `italic_virtual_text`, `on_colors`, and `on_highlights`.
- Defaults are `transparent = false`, `dim_inactive = false`, `italic_comments = true`, and `italic_virtual_text = false`; callbacks default to no-ops.
- `on_colors(colors)` receives the fresh resolved color table and may mutate it in place.
- `on_highlights(highlights, colors)` receives the complete highlight table plus the callback-adjusted colors and may mutate highlights in place.
- Temperature and depth are not setup options. Named colorschemes are the persistent selection mechanism.
- `:GrisailleVariant warm|balanced|cool` preserves depth and reapplies the theme immediately.
- `:GrisailleDepth hard|medium|soft` preserves temperature and reapplies the theme immediately.
- Commands provide completion. Invalid arguments raise a clear Neovim error and leave palette, configuration, highlights, terminal colors, lualine, and `vim.g.colors_name` unchanged.
- Loading resolves the active palette into a fresh table, runs `on_colors`, builds highlights, runs `on_highlights`, applies highlights, exports ANSI colors, refreshes lualine, records active state, and sets the exact colorscheme name.
- Both callbacks rerun after every runtime switch. Runtime callback effects reach Neovim highlights, ANSI colors, and lualine; generated extras never execute user callbacks.

### Domain Vocabulary And Role Map

- **Ground** is the shared achromatic structural background family.
- **Ink** is the shared achromatic foreground family.
- **Syntax role** is one of `keyword`, `function`, `literal`, `accent`, and `type`.
- **Semantic role** is one of `error`, `warn`, `ok`, `hint`, and `info`.
- **Tint** is a low-chroma state background derived from a syntax or semantic color.
- `keyword` colors keywords, control flow, and storage.
- `function` colors functions, methods, and calls.
- `literal` colors every literal value.
- `accent` colors properties, fields, parameters, and UI accents.
- `type` colors types, classes, constructors, and modules.
- Declared variable and constant names use `fg`; only their values receive `literal`.
- Operators, commas, brackets, and punctuation use `dim`.
- Syntax roles do not depend on bold or italic. Comments and virtual text may use their independent options; semantic markup emphasis remains bold or italic where that styling carries meaning.
- Diagnostics, git state, additions, removals, changes, hints, and informational state use semantic roles rather than syntax colors.

### Approved Palette

Candidate 3 is the design source. Production records these values directly and has no runtime dependency on prototype HTML.

The hexadecimal values below are authoritative shipped colors. OKLCH values are design targets and metadata; implementations must not recompute authoritative hex values from rounded OKLCH coordinates. This is especially important for explicit Candidate 3 overrides such as Warm `function`, `ok`, `hint`, and `info`.

#### Ground And Diff Tints

| Depth | deep | bg | line | raised | border | edge | add | delete | modify |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Hard | `#0d0d0d` | `#141414` | `#1c1c1c` | `#252525` | `#313131` | `#525252` | `#202515` | `#301d1b` | `#12262e` |
| Medium | `#121212` | `#1a1a1a` | `#222222` | `#2c2c2c` | `#383838` | `#5a5a5a` | `#262c1b` | `#372321` | `#182c35` |
| Soft | `#181818` | `#202020` | `#282828` | `#323232` | `#3e3e3e` | `#616161` | `#2d3221` | `#3e2a28` | `#1f333b` |

#### Ink

| Role | Hex | Use |
| --- | --- | --- |
| `fg` | `#d8d8d8` | Ordinary readable text |
| `dim` | `#959595` | Operators, punctuation, subdued text |
| `comment` | `#696969` | Deliberately quiet comments |
| `gutter` | `#484848` | Line numbers and decorative furniture |

#### Syntax Roles

| Variant | Role | OKLCH | Hex |
| --- | --- | --- | --- |
| Warm | keyword | `0.675 0.115 8` | `#d27789` |
| Warm | function | `0.838 0.105 61.4` | `#fcba81` |
| Warm | literal | `0.705 0.090 123.4` | `#95aa6a` |
| Warm | accent | `0.770 0.105 43.8` | `#ed9e7d` |
| Warm | type | `0.620 0.072 227.4` | `#548fa8` |
| Balanced | keyword | `0.675 0.090 290` | `#968dcb` |
| Balanced | function | `0.838 0.085 82` | `#e6c58a` |
| Balanced | literal | `0.705 0.075 145` | `#83ad83` |
| Balanced | accent | `0.770 0.060 28` | `#d8a69f` |
| Balanced | type | `0.620 0.070 220` | `#5290a3` |
| Cool | keyword | `0.675 0.100 300` | `#a088cb` |
| Cool | function | `0.838 0.075 78` | `#e5c493` |
| Cool | literal | `0.705 0.080 145` | `#81ae81` |
| Cool | accent | `0.770 0.080 190` | `#74c5bf` |
| Cool | type | `0.620 0.090 250` | `#5b8abb` |

The role lightness order is always `function > accent > literal > keyword > type`. Corresponding roles keep the same target lightness across variants; chroma varies to preserve perceived prominence.

#### Semantic Roles

| Role | OKLCH | Hex |
| --- | --- | --- |
| error | `0.690 0.160 5` | `#ea6b8e` |
| warn | `0.820 0.150 85` | `#f0bb3b` |
| ok | `0.680 0.145 152.1` | `#43b16a` |
| hint | `0.780 0.125 196.2` | `#20c9cb` |
| info | `0.780 0.134 240.4` | `#58bdff` |

- Syntax roles vary by temperature; semantic roles do not.
- Visual selection is an 18% sRGB mixture of the active `accent` over the active editor `bg`. Selected text uses `fg` rather than retaining syntax foregrounds, ensuring readable contrast over the chromatic block.
- Diagnostic virtual-text and line-style backgrounds are a 12% sRGB mixture of their semantic color over the active `bg`.
- Signs, underlines, and diagnostic foregrounds use full semantic colors.
- Add, delete, and modify backgrounds are fixed by depth and do not vary with temperature.

### Contrast And Accessibility

- Ordinary text, syntax roles, diagnostics, and readable UI target at least `4.5:1` against every background on which they are rendered. Contrast tests allow a maximum `0.01` numerical tolerance for 8-bit sRGB quantization; Cool `type` on Soft is the boundary value and publishes as `4.50:1`.
- Comments are a documented exception: below `4.5:1`, but never below `2.8:1` at any depth.
- Gutters and purely decorative marks may remain near `2:1` and are documented exceptions.
- Text rendered over a tint, selection, menu, or raised block is tested against that actual block rather than only against editor `bg`.
- Protanopia and deuteranopia simulation use Machado-style matrices for review. Grisaille does not claim every syntax role remains uniquely identifiable under every color-vision deficiency.
- Accepted tradeoff: some syntax roles converge under simulation. This is acceptable because readable contrast and hierarchy remain, diagnostics remain distinguishable, and eliminating every simulated collision would weaken the approved normal-vision palette.

### Highlights And Integrations

- Version 0.1 covers built-in editor UI, legacy syntax, Tree-sitter, LSP semantic tokens, diagnostics, diff/git groups, terminal colors, and lualine.
- Plugin integrations cover gitsigns, blink.cmp, Snacks, fzf-lua, which-key, Noice, neo-tree, nvim-tree, netrw, flash, trouble, lazy.nvim, mason, nvim-dap, dap-ui, neotest, mini.nvim, hlchunk, grug-far, diffview, illuminate, treesitter-context, and rainbow-delimiters.
- Plugin windows link through `NormalFloat` and `FloatBorder` rather than copying colors. `transparent = true` strips shared surfaces.
- Completion menus remain painted in transparent mode as a documented readability exception, including plugins that do not inherit Neovim's completion groups.
- `dim_inactive` reuses the existing deep ground and is off by default.
- Lualine derives from the active resolved palette and refreshes after runtime switches.

### ANSI Colors

| ANSI slot | Grisaille source |
| --- | --- |
| black | `line` ground |
| red | keyword |
| green | literal |
| yellow | function |
| blue | info |
| magenta | terminal-only auxiliary |
| cyan | type |
| white | dim foreground |
| bright black | comment |
| bright red | error |
| bright green | ok |
| bright yellow | warn |
| bright blue | bright info |
| bright magenta | bright auxiliary |
| bright cyan | hint |
| bright white | foreground |

- ANSI names are terminal indices, not Grisaille role names.
- The terminal-only auxiliary is shared across variants at `OKLCH 0.680 0.100 305` / `#a788ca`.
- Bright auxiliary is `OKLCH 0.740 0.100 305` / `#b99bde`.
- Bright info is terminal-only `#71d5ff`, produced from `info` at target `OKLCH 0.840 0.134 240.4` and clipped to sRGB.
- Terminal-only colors never color editor syntax or UI roles.

### Extras

- Version 0.1 supports Bat, Ghostty, and OpenCode only.
- Every surface ships all nine names. File stems and internal stored names match the public colorscheme names; tool-specific extensions are added where required.
- Bat uses `.tmTheme`, OpenCode uses `.json`, and Ghostty uses extensionless theme files.
- Extras are generated from the shipped palette through a registry. Generated files are committed but never edited manually.
- Each generator targets the consuming tool's actual current schema or shipped preset. The pinned schema source/version is documented beside its test.
- Generated extras ignore user callbacks and remain deterministic.

### Architecture

- The project separates runtime setup/loading, palette resolution, highlight-family construction, lualine, generated-surface registration, generators, scripts, documentation, tests, and generated output.
- One palette resolver accepts temperature and depth and returns a fresh complete color table. Terminal aliases and tints derive there so consumers cannot drift.
- Highlight modules consume a resolved palette and return data; the loader alone mutates Neovim state.
- Generator modules return path/content mappings; one script writes them, and tests compare committed bytes with fresh renders.
- Project guidance distinguishes generated documentation/output from the read-only `docs/reference/` exception.

### Documentation And Release

- Version 0.1 includes a README and Vim help covering installation, all names, options, commands, role map, exact palette, contrast exceptions, accessibility tradeoffs, integrations, extras installation, attribution, and troubleshooting.
- Conventional Commits are used from project creation.
- GitHub Actions runs on Neovim 0.10, stable, and nightly and initializes the Cendre submodule.
- Version `0.1.0` is tagged manually after automated and manual acceptance pass. Automated release tooling is deferred.

## Testing Decisions

- Prefer one high-level smoke suite at the public loading seam. It loads the same named colorschemes and invokes the same commands users do, then observes Neovim highlights, state, terminal variables, lualine, and generated output. Lower-level tests are added only where a consuming-tool schema cannot be exercised through that seam.
- Load all nine named colorschemes and assert successful application, exact active pair, exact `vim.g.colors_name`, complete color tables, and expected representative role mappings.
- Exercise painted, transparent, and inactive-window behavior. Assert plugin windows inherit shared float surfaces and completion menus remain painted.
- Invoke both runtime commands from every starting temperature and depth. Assert the changed axis, preserved axis, callbacks, terminal colors, lualine, and active name all update atomically.
- Invoke invalid command values and assert a clear failure with no state or highlight mutation.
- Test setup defaults and each behavioral option through visible highlight behavior rather than internal tables.
- Assert declared names remain `fg`, punctuation remains `dim`, every syntax role maps consistently, semantic state never uses a syntax role, and no readable token depends on bold or italic.
- Measure WCAG contrast against the actual rendered background for every readable palette use, allowing only the documented `0.01` quantization tolerance. Assert selected text uses `fg` and clears the floor over every variant/depth selection tint. Pin documented comment and gutter exceptions explicitly so additional exceptions fail.
- Assert corresponding syntax-role lightness is stable across variants and the required lightness ordering holds.
- Assert semantic values are identical across variants, diagnostic tints use 12%, selections use 18%, and diff tints vary only by depth.
- Assert all 16 terminal slots exist and derive from the documented source roles; auxiliary colors never appear in editor highlight roles.
- Assert lualine reflects the active palette before and after each runtime switch.
- For Bat, Ghostty, and OpenCode, assert all nine files exist, internal names are unique, emitted colors belong to the resolved palette, required keys are complete, retired/unknown keys are absent, and committed bytes match a fresh render.
- Pin the actual Bat, Ghostty, and OpenCode schema sources or shipped presets used to construct schema assertions.
- Run the smoke suite on Neovim 0.10, stable, and nightly, then run `:helptags` over the help directory.
- Before tagging, manually compare representative Lua, TypeScript, Rust, Markdown, and JSON buffers across all temperatures and depths. Review normal vision plus Machado protanopia and deuteranopia simulations against Candidate 3. Confirm the approved ranking and character: Balanced is canonical, Warm remains cohesive, and Cool remains crisp without becoming icy.
- Prior art is Cendre's public-load smoke suite, palette contrast checks, role-map checks, transparent-surface checks, generated drift checks, and schema-pinning tests. Port the behavior, rename the domain, and remove fire-specific assertions.

## Out of Scope

- Light mode.
- Temperatures or depths beyond the approved three-by-three matrix.
- Extras other than Bat, Ghostty, and OpenCode.
- A standalone website or documentation site.
- Automatic OS-theme or time-of-day switching.
- User-defined palette generation.
- A GUI palette editor.
- Cendre configuration compatibility, migration tooling, or shared runtime code.
- Fire-derived hue claims or physical-source derivation.
- Guaranteeing every syntax role remains uniquely distinguishable under every color-vision deficiency.
- Automated release publishing before `0.1.0`.

## Further Notes

- The approved visual source is `theme-palette-prototype-3.html` in the design workspace. The new project must copy the recorded values from this specification, not load or ship the prototype.
- Candidate review concluded with the normal-vision ranking `Balanced > Warm > Cool`. Balanced reads as exactly neutral on a warm-to-cool scale, Warm remains cohesive, and Cool remains cool without becoming icy.
- Error and warning were deliberately separated by lightness for color-vision resilience. Their foreground values remain vivid; diagnostic backgrounds use only a 12% mixture to avoid bright full-line blocks.
- The Cendre reference submodule is architectural evidence, not a source of truth for Grisaille's product decisions.
- Apply the local tracker's `ready-for-agent` state to this specification. Ticket decomposition should happen only after the new repository exists or its tracker location is known.
