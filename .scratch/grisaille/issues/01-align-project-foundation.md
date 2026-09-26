# 01: Align the project foundation

**What to build:** Maintainers can develop Grisaille as an independent MIT-licensed project, consult a reproducible read-only Cendre reference, and prepare a manual 0.1.0 release alongside the existing release workflow.

**Blocked by:** None (can start immediately).

**Status:** complete

- [x] Cendre remains a tracked snapshot pinned by its Git tree ID; contributor guidance treats it as read-only and requires a dedicated change to advance it.
- [x] Project-level attribution includes the required Cendre MIT copyright and license notice without repeating attribution in source files.
- [x] The existing release workflow and current release remain in place; project guidance describes coordination with manual tagging for 0.1.0 and Conventional Commits.
- [x] Existing checks still pass after the foundation changes (`make check`).

The tracked snapshot and active release workflow supersede the original submodule and deferred-automation requirements at the maintainer's direction.
