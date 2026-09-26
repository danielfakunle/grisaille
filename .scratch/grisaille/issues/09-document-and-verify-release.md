# 09: Document and verify the release

**What to build:** A user can install and understand the complete 0.1.0 theme, while maintainers can verify its behavior across supported Neovim versions and carry out a documented visual review before manually tagging.

**Blocked by:** 01: Align the project foundation; 05: Theme supported plugins; 07: Customize and switch themes at runtime; 08: Generate companion themes.

**Status:** ready-for-agent

- [ ] README and Vim help explain installation, all theme names, role map, exact palette, options, commands, integrations, extras, attribution, troubleshooting, contrast exceptions, and accepted color-vision simulation tradeoffs.
- [ ] CI runs the public-load smoke suite and checks on Neovim 0.10, stable, and nightly, initializes the Cendre reference, and verifies help tags.
- [ ] A manual checklist covers representative Lua, TypeScript, Rust, Markdown, and JSON buffers at all nine combinations under normal vision and Machado protanopia/deuteranopia simulations, including the approved Balanced/Warm/Cool character and ranking.
- [ ] Release instructions require automated and manual acceptance before manually tagging 0.1.0.
