# 05: Theme supported plugins

**What to build:** Users of the specified Neovim plugins see windows, navigation, completion, diagnostics, and development state that agree with the active Grisaille theme, including transparent mode.

**Blocked by:** 03: Read code and state consistently; 04: Use readable editor surfaces.

**Status:** complete

- [x] Cover gitsigns, blink.cmp, Snacks, fzf-lua, which-key, Noice, neo-tree, nvim-tree, netrw, flash, trouble, lazy.nvim, mason, nvim-dap, dap-ui, neotest, mini.nvim, hlchunk, grug-far, diffview, illuminate, treesitter-context, and rainbow-delimiters.
- [x] Plugin windows inherit shared float surfaces rather than copying colors; completion windows remain painted in transparent mode even when they do not inherit native completion groups.
- [x] Plugin diagnostic, git, and state indicators use semantic roles; observable highlight tests cover representative integrations and transparent surfaces.
