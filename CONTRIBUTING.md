# Contributing to Grisaille

Grisaille is a separate project from Cendre. Develop Grisaille's palette, runtime,
and generated themes independently; do not import Cendre as a runtime dependency.
See [NOTICE](NOTICE) for the project-level Cendre attribution.

## Reference snapshot

`docs/reference/cendre` is a tracked, read-only snapshot of Cendre for architectural
comparison. It is included in ordinary clones; no submodule initialization is
needed. Its Git tree ID is `009ea6d1287dcb83ada5ccf3b6934b959896d6c0`.
To verify the committed snapshot, run:

```sh
git rev-parse HEAD:docs/reference/cendre
```

Do not edit files there as part of Grisaille feature work. Advance the snapshot
only in a dedicated change that records the new source revision and tree ID,
updates the Cendre attribution if necessary, and explains what changed. A
different tree ID means the reference has changed and should be reviewed.

## Development and commits

Run `make install` to install the ignored MiniTest dependency, then `make check`
for formatting, linting, typechecking, and tests. For a focused run, use
`make test_file FILE=tests/test_grisaille.lua` and `make typecheck`.

Submit changes as pull requests to `main` and wait for CI and review before
merging. Do not push contribution changes directly to `main`. Use
[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/):
`feat: add palette`, `fix: correct highlight`, or `docs: clarify setup`.
Use `!` or a `BREAKING CHANGE:` footer for breaking changes. Release-please
uses these commits to prepare releases; do not change the release manifest
just to announce an unreleased version.

## Preparing 0.1.0

1. Finish the 0.1.0 scope through reviewed pull requests. Run `make check`
   locally. Confirm the CI matrix passes on Neovim 0.10, stable, and nightly,
   including the public-load smoke suite, pinned Cendre snapshot check, and
   Vim help tags. Resolve failed checks before release.
2. When release-please opens its 0.1.0 release pull request, review its
   `CHANGELOG.md`, manifest/version changes, and intended release contents
   against the current `grisaille-v0.0.2` baseline. Do not edit the manifest
   by hand to announce an unreleased version.
3. On that release candidate, complete the
   [visual and accessibility review](docs/visual-review.md) for all five
   languages, nine themes, and three viewing conditions. Record the reviewer
   and acceptance decision on the
   release-please pull request; do not merge while any review cell or CI check
   is outstanding.
4. After automated and manual acceptance, merge the release-please pull
   request. The existing [release workflow](.github/workflows/release.yml)
   runs on pushes to `main`; release-please creates the tag and GitHub release.
   Verify the resulting version and tag in its run and on GitHub.
