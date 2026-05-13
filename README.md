# swift-workshop

A Swift Package Manager workspace for exploring small libraries. The first target, `WorkshopFeedbin`, is a workshop around the [Feedbin](https://feedbin.com/) API.

## Requirements

- Swift 6.0+ (toolchain implied by `swift-tools-version: 6.3` in `Package.swift`)
- [`just`](https://github.com/casey/just) for the task runner
- Node.js + [Corepack](https://nodejs.org/api/corepack.html) (enables Yarn pinned via `packageManager` in `package.json`) for changesets tooling

## Getting started

```sh
# Install Node tooling (changesets CLI)
just install

# Build and test
just build
just test
```

Run `just` with no arguments to build, or `just --list` to see all available tasks with descriptions.

## Project layout

```
Sources/WorkshopFeedbin/   # Library sources
Tests/WorkshopFeedbinTests/# Swift Testing tests
Package.swift              # SPM manifest (Swift 6 language mode)
.changeset/                # Pending changesets and config
```

Tests use [Swift Testing](https://developer.apple.com/documentation/testing) (`import Testing`, `@Test`, `#expect`), not XCTest.

## Versioning and changelog

Versions and `CHANGELOG.md` entries are managed with [Changesets](https://github.com/changesets/changesets).

Typical flow:

1. Make changes on a branch.
2. Run `just changeset` and follow the prompts to describe the change and pick a semver bump.
3. Commit the generated file under `.changeset/` alongside your code.
4. When ready to cut a release, run `just changeset-version` to apply pending changesets — this bumps the version in `package.json` and updates `CHANGELOG.md`.
5. Commit the version bump, then `just changeset-tag` to create the matching git tag.

`just changeset-status` shows pending changesets and the version they would produce.

## Tooling notes

- Yarn runs in `node-modules` mode (configured via `.yarnrc.yml`); no Plug'n'Play.
- The Yarn version is pinned through the `packageManager` field in `package.json`; Corepack will provision the correct binary automatically.
