# Grisaille 0.1.0 visual acceptance

Complete this checklist on the release candidate **before merging the
release-please pull request**. Record the Neovim version(s), terminal/GUI,
font, display conditions, simulation tool and its Machado matrix settings,
reviewer, date, and candidate commit in the release PR. Link screenshots or
notes for any questionable combination. An unreviewed or failing cell blocks
acceptance until it is resolved or explicitly accepted in the release PR.

## Setup

1. Open representative **Lua, TypeScript, Rust, Markdown, and JSON** buffers
   with real syntax and (where available) Tree-sitter, LSP semantic tokens,
   diagnostics, comments, strings/numbers, functions, types, punctuation,
   selection, search, split windows, and a completion popup. Use the **same
   five buffers** for every theme, with true color enabled.
2. Load each named theme with `:colorscheme <name>`; inspect its Hard, Medium,
   and Soft depths. Keep font, terminal background, ambient light, and
   screenshot framing constant so comparisons are meaningful.
3. For **each language and each name**, review the actual editor image under
   normal vision (N), then full-severity Machado-style protanopia (P) and
   deuteranopia (D) simulations. Use a tool that identifies its matrices as
   Machado; record the tool/version and severity. Do not substitute a generic
   color-blindness filter. Mark each letter only after looking at that cell;
   use `N/P/D` to show all three passed, or record the failed/unreviewed
   letter and an issue link. This grid represents **5 × 9 × 3 = 135** views.

| Theme | Lua N/P/D | TypeScript N/P/D | Rust N/P/D | Markdown N/P/D | JSON N/P/D |
| --- | --- | --- | --- | --- | --- |
| `grisaille` (Balanced Hard) | ___ | ___ | ___ | ___ | ___ |
| `grisaille-medium` (Balanced Medium) | ___ | ___ | ___ | ___ | ___ |
| `grisaille-soft` (Balanced Soft) | ___ | ___ | ___ | ___ | ___ |
| `grisaille-warm` (Warm Hard) | ___ | ___ | ___ | ___ | ___ |
| `grisaille-warm-medium` (Warm Medium) | ___ | ___ | ___ | ___ | ___ |
| `grisaille-warm-soft` (Warm Soft) | ___ | ___ | ___ | ___ | ___ |
| `grisaille-cool` (Cool Hard) | ___ | ___ | ___ | ___ | ___ |
| `grisaille-cool-medium` (Cool Medium) | ___ | ___ | ___ | ___ | ___ |
| `grisaille-cool-soft` (Cool Soft) | ___ | ___ | ___ | ___ | ___ |

## What to check in every view

- [ ] The achromatic ground remains neutral, with clear Hard → Medium → Soft
      elevation; a split, float, gutter, selection, and completion popup remain
      readable. Check transparent and dim-inactive settings at least once per
      depth, including the intentionally painted completion menu.
- [ ] Functions are most prominent, then accent, literal, keyword, and type;
      declared variables stay ordinary ink and punctuation stays dim. Comments
      are quiet but legible. No language has an unexpectedly missing or
      distracting highlight.
- [ ] Error, warning, and other diagnostics remain separate from syntax roles
      and from each other; visual selection and tinted diagnostic text remain
      legible. Under P and D, allow some syntax hues to converge, but require
      usable contrast/hierarchy and distinguishable diagnostics.
- [ ] Compare against the approved Candidate 3 values and character recorded
      in the [project spec](../.scratch/grisaille/spec.md): **Balanced is
      canonical and neutral**, **Warm is cohesive**, **Cool is crisp without
      becoming icy**. Under normal vision confirm the approved preference
      **Balanced > Warm > Cool**, across the three depths. Simulations check
      readability and hierarchy, not the same aesthetic ranking.

## Release decision

- [ ] Every cell in the grid has N/P/D recorded or a documented issue and
      explicit resolution in the release PR; all checks above pass.
- [ ] CI passed on the release candidate on Neovim 0.10, stable, and nightly,
      including the public-load suite and help-tag verification.
- [ ] The reviewer records an acceptance decision on the release-please PR.
      Merge that PR only after both automated and manual acceptance. The
      existing release-please workflow creates the version tag and release.
