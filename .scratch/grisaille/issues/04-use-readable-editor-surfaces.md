# 04: Use readable editor surfaces

**What to build:** Editor windows, menus, and text remain readable across depths, with user-controlled transparency, inactive-window dimming, and typography.

**Blocked by:** 02: Load all nine themes; 03: Read code and state consistently.

**Status:** complete

- [x] Built-in editor surfaces inherit a coherent ground and ink hierarchy in painted mode; inactive windows use the deep ground only when opt-in dimming is enabled.
- [x] Transparent mode clears shared editor and plugin float surfaces while completion menus remain painted and readable.
- [x] Comment and virtual-text italics are independently configurable with the specified defaults; semantic markup emphasis retains meaningful styling.
- [x] Public-load tests exercise defaults and each behavior through observable Neovim highlights across representative depths.
