# 07: Customize and switch themes at runtime

**What to build:** Users can customize the resolved colors and highlights, then switch temperature or depth without restarting Neovim or losing their customization.

**Blocked by:** 04: Use readable editor surfaces; 06: Match terminal buffers and lualine.

**Status:** complete

- [x] `setup()` accepts the specified behavior options and color/highlight callbacks; callbacks receive fresh resolved data in the documented order and affect highlights, terminal colors, and lualine.
- [x] `:GrisailleVariant` and `:GrisailleDepth` offer completion, change only the requested axis, rerun callbacks, and update highlights, terminal colors, lualine, and the exact active colorscheme name.
- [x] Invalid command values produce a clear Neovim error without changing configuration, colors, highlights, terminal slots, lualine, or active name.
- [x] Public-command smoke tests exercise switches from every starting pair and verify the preserved axis, callback reapplication, and failure atomicity.
