---
"swift-workshop": minor
---

Add an initial `FeedbinAPI` client for a subset of the [Feedbin REST API](https://github.com/feedbin/feedbin-api).

`FeedbinAPI` builds `Blocks.Endpoint` values (no networking of its own) and authenticates with HTTP Basic. Three endpoints are covered:

- `fetchStarredEntries()` — list the authenticated user's starred entry IDs.
- `fetchEntry(itemIdentifier:)` — fetch a single entry by its identifier.
- `unstarEntry(itemIdentifier:)` — remove the starred status from an entry.

Also adds the `FeedbinEntry` model, the `FeedbinItemIdentifier` typealias, and pins minimum platforms (macOS 12, iOS 15, tvOS 15, watchOS 8). Depends on `swift-blocks` for the transport abstraction; tests use `swift-snapshot-testing` for request snapshots.
