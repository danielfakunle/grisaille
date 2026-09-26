# 03: Read code and state consistently

**What to build:** Code and editor state remain legible and mean the same thing in every theme: syntax roles identify code, while diagnostics and changes use a separate semantic family.

**Blocked by:** 02: Load all nine themes.

**Status:** complete

- [x] Legacy syntax, Tree-sitter, and LSP semantic tokens consistently map keywords, functions, literals, accents, and types; declared names use ordinary foreground and punctuation uses dim ink without relying on bold or italic to identify syntax.
- [x] Diagnostics, git/diff state, selection, and readable UI state use the specified semantic colors, depth-specific diff backgrounds, 12% diagnostic tints, and 18% accent selection tint with ordinary foreground selected text.
- [x] Tests measure readable roles against their actual rendered backgrounds at all nine combinations, honoring only the specified 0.01 quantization tolerance and the documented comment and decorative-gutter exceptions.
- [x] Tests pin role lightness order, stable cross-variant prominence, semantic invariance, and tint percentages.
