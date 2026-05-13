# AGENTS.md

Guidance for AI coding agents working in this repository. Human-facing docs live in [README.md](README.md).

## Project

Swift Package Manager project (`swift-tools-version: 6.3`, Swift 6 language mode). Single library product `WorkshopFeedbin` — a workshop/exploration around the [Feedbin](https://feedbin.com/) API.

The project is essentially empty scaffolding right now; `Sources/WorkshopFeedbin/WorkshopFeedbin.swift` and the test file contain only placeholder comments.

## Commands

Tasks are managed with [`just`](https://github.com/casey/just). Run `just --list` to see all targets with descriptions. Common ones:

```sh
just build                       # swift build
just test                        # swift test (pass extra args: `just test --filter MyTest`)
just clean                       # swift package clean
just format                      # swift format in place
just install                     # yarn install (changesets CLI)
```

Underlying tools (use directly if `just` is not available):

```sh
swift build
swift test --filter WorkshopFeedbinTests.example   # Run a single test
open Package.swift                                  # Open in Xcode
```

## Testing

Uses the **Swift Testing** framework (`import Testing`, `@Test`, `#expect(...)`) — not XCTest. New tests should follow this pattern.

## Versioning and changelog

Versions and `CHANGELOG.md` are managed with [Changesets](https://github.com/changesets/changesets). When a change is user-facing, add a changeset:

```sh
just changeset           # add a new changeset
just changeset-status    # show pending changesets
just changeset-version   # apply pending changesets (bump version, update CHANGELOG.md)
just changeset-tag       # tag the release in git
```

Yarn runs in `node-modules` mode (configured via `.yarnrc.yml`); the Yarn version is pinned via the `packageManager` field in `package.json` and provisioned by Corepack.

## Attribution

The author/copyright holder is **Mick F** — use this name (not any expansion) in LICENSE, package author fields, and similar contexts.
