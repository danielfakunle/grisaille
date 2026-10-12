# Syntax-preserving selection preview

Type: prototype
Status: resolved

## Question

Is a darker, depth-adaptive cool selection sufficiently visible while retaining
syntax foregrounds and existing contrast targets across all nine variants?

## Agreed direction

- Preserve syntax colors in Visual and VisualNOS; leave menus/pickers unchanged.
- Original proposal: 6% fixed cool blue `#5b8abb` blended over `deep`.
  Rejected by user as barely visible; retained only for comparison.
- New contrast-first candidate: saturated blue/teal backgrounds Hard `#001e29`,
  Medium `#00212c`, Soft `#00232f`.
- New visibility-first candidate: 28% fixed cool blue `#5b8abb` over `bg`.
  Explicitly trades selected-type/comment contrast for a more visible background.
- Keep extras consistent: shared selection background, no forced selection ink
  where supported. Ghostty supports `selection-foreground = cell-foreground`
  since 1.2.0; Bat already exports a background-only selection. The current
  OpenCode export has no selection field, so there is no mapped selection to change.
- Preview before changing shipped defaults, spec, tests, or generated extras.

## Preview

- `make prototype_selection`, then http://127.0.0.1:8765
- `make prototype_selection_nvim` for actual Neovim rendering.
- Browser views: Comparison, Full editor, Nine-variant matrix, Candidates.
  The Proposal selector switches the candidate in the first three views;
  Candidates shows all three together and lists their individual contrast ratios.
- Neovim keys: `p` toggles before/after, `s` cycles proposals, `t` cycles
  temperature, `d` cycles depth. Starts with the stronger blue/teal proposal.
  `Esc` leaves selection; `v`, `V`, and `Ctrl-V` exercise selection shapes.
- Browser syntax roles are hand-labeled. Neovim uses built-in Lua syntax, not
  the user's Tree-sitter configuration. Both are visual previews, not screenshots
  of Ghostty/Bat/OpenCode behavior. Terminal minimum-contrast settings can alter ink.

## Sources

- `lua/grisaille/palette.lua`, `lua/grisaille/highlights.lua`, `lua/grisaille/extras.lua`
- https://ghostty.org/docs/config/reference#selection-foreground

## Answer

User rejected the initial proposal as barely visible and selected **Brighter blue**
after comparing the stronger tint and brighter background. Implementation approved.
Use a 28% fixed `#5b8abb` sRGB blend over active `bg`, preserving syntax foregrounds
in Neovim, Ghostty, and Bat wherever the consuming format supports selection.
Keep menus/pickers unchanged; OpenCode has no mapped selection surface.

The approved candidate prioritizes selection visibility over universal selected-ink
contrast. Selected punctuation, keywords, types, and Soft literals fall below 4.5:1;
comments fall below 2.8:1. Across all nine combinations, non-comment syntax stays
at least 3:1 and selected comments at least 2:1 (with 0.01 quantization tolerance).
The normal-background contrast contract remains unchanged.

Primary-source prototype: branch `prototype/selection-preview`, files under
`.scratch/selection/prototype/`, runnable with the Make targets above. The final
implementation retains this verdict and removes the throwaway artifacts/targets.
Archive commit: `9341667b0fa63327eba9ccedf914346f370571bf`.

## Implementation and validation

- Shipped Visual/VisualNOS are background-only; shared selection uses the approved blend.
- Regenerated all nine Bat and Ghostty themes. Ghostty preserves cell foregrounds;
  Bat remains background-only. OpenCode output and menus/pickers are unchanged.
- Updated the project spec, README, help, and visual-review checklist with the
  selection-only contrast tradeoffs and Ghostty 1.2+ requirement.
- `make check` passed: formatting, lint, typecheck, and all 34 test cases.
  Tests cover all nine selections, per-role contrast floors, callback derivation
  and overrides, unchanged menu/picker backgrounds, and generated export drift.
