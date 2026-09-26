# 06: Match terminal buffers and lualine

**What to build:** Terminal programs and lualine match whichever Grisaille combination the user has loaded.

**Blocked by:** 02: Load all nine themes; 03: Read code and state consistently.

**Status:** ready-for-agent

- [ ] Every named theme exports all 16 ANSI slots from the documented ground, ink, syntax, semantic, and terminal-only sources.
- [ ] Terminal-only auxiliary and bright colors do not appear in editor syntax or UI highlights.
- [ ] Lualine renders from the active resolved palette for every temperature and depth.
- [ ] Public-load tests observe all terminal slots and representative lualine colors across the theme matrix.
