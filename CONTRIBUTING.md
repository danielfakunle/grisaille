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

Use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/):
`feat: add palette`, `fix: correct highlight`, or `docs: clarify setup`.
Use `!` or a `BREAKING CHANGE:` footer for breaking changes. Release-please
uses these commits to prepare releases; do not change the release manifest
just to announce an unreleased version.

## Preparing 0.1.0

1. Finish the 0.1.0 scope, run `make check`, and confirm the applicable CI
   checks pass. Perform the manual visual and accessibility review specified
   in [the release ticket](.scratch/grisaille/issues/09-document-and-verify-release.md).
2. Review `CHANGELOG.md`, the intended release commit, and existing tags and
   releases. The existing `grisaille-v0.0.2` release and its manifest entry are
   the current baseline; do not rewrite them to prepare 0.1.0.
3. Coordinate the manual tag with the release-please workflow in
   `.github/workflows/release.yml`. It remains active on pushes to `main` and
   can create tags and GitHub releases automatically. Check its latest run and
   confirm `grisaille-v0.1.0` has not already been published before tagging.
4. Once acceptance is complete and the target commit is on `main`, tag that
   commit manually with `git tag grisaille-v0.1.0 <commit>` and push it with
   `git push origin grisaille-v0.1.0`. If release-please has already published
   that version, do not retag or overwrite it. After a manual tag, reconcile
   `.release-manifest.json` with the published version in a follow-up change
   so release-please does not treat 0.1.0 as still unreleased.

The release-please configuration and workflow remain in place; manual tagging
does not stop automated releases on later pushes to `main`.
