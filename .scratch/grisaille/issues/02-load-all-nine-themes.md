# 02: Load all nine themes

**What to build:** A Neovim 0.10+ user can load the canonical Balanced Hard theme with `:colorscheme grisaille` or choose any of the other eight temperature/depth combinations by their specified names. Each loads the authoritative Candidate 3 palette without a prototype runtime dependency.

**Blocked by:** None (can start immediately).

**Status:** ready-for-agent

- [ ] All nine public names load successfully through one shared theme loader, and `vim.g.colors_name` equals the exact active name.
- [ ] Warm, Balanced, and Cool change syntax pigments while Hard, Medium, and Soft change the achromatic ground; shared ink and semantic values remain constant.
- [ ] Palette resolution returns a fresh complete color table with authoritative shipped hex values, including documented terminal aliases and derived tints; rounded OKLCH metadata does not recompute or replace those values.
- [ ] Public-load smoke coverage verifies each active pair and representative palette values on a supported Neovim version.
