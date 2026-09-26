# Repository guidance

- This is a Neovim Lua plugin: runtime code is under `lua/grisaille/`; tests are under `tests/` and use MiniTest.
- Before running tests, install the ignored MiniTest dependency with `make install` (clones `nvim-mini/mini.nvim` into `deps/`).
- Run all checks with `make check` (`format`, `lint`, `typecheck`, then `test`). For one test file, run `make test_file FILE=tests/test_grisaille.lua`.
- CI uses Neovim 0.12.4, LuaJIT 2.1, StyLua 2.1.0, LuaLS 3.19.0, and Luacheck; keep changes compatible with that toolchain.

## Agent skills

### Issue tracker

Issues are tracked as local Markdown files under `.scratch/<feature>/`. See `docs/agents/issue-tracker.md`.

### Triage labels

Use the default labels: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, and `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Use the single-context layout. See `docs/agents/domain.md`.
