# 08: Generate companion themes

**What to build:** Bat, Ghostty, and OpenCode users can install any of the nine Grisaille combinations and get colors consistent with Neovim.

**Blocked by:** 02: Load all nine themes; 03: Read code and state consistently; 06: Match terminal buffers and lualine.

**Status:** ready-for-agent

- [ ] Each consuming tool receives all nine uniquely named themes in its supported format, with matching stored names and colors derived from the shipped palette rather than user callbacks.
- [ ] A shared surface registry drives deterministic generation; generated themes are committed and fresh renders byte-match the committed output.
- [ ] Tests check required keys, palette provenance, unique names, and absence of retired or unknown keys against documented, pinned Bat, Ghostty, and OpenCode schemas or shipped presets.
- [ ] User-facing installation guidance identifies each format and its nine public names.
