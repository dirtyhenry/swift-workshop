import Foundation
import InlineSnapshotTesting
import Testing

@testable import WorkshopFeedbin

@Suite("FeedbinAPI")
struct FeedbinAPITests {
    static let api = try! FeedbinAPI(username: "foo@bar.tld", password: "dummy-password")

    // MARK: - Request snapshots

    @Test func fetchStarredEntriesRequest() throws {
        let endpoint = try Self.api.fetchStarredEntries()
        assertInlineSnapshot(of: endpoint.request, as: .raw(pretty: true)) {
            """
            GET https://api.feedbin.com/v2/starred_entries.json
            Accept: application/json
            Authorization: Basic Zm9vQGJhci50bGQ6ZHVtbXktcGFzc3dvcmQ=
            """
        }
    }

    @Test func fetchEntryRequest() throws {
        let endpoint = try Self.api.fetchEntry(itemIdentifier: 123)
        assertInlineSnapshot(of: endpoint.request, as: .raw(pretty: true)) {
            """
            GET https://api.feedbin.com/v2/entries.json?ids=123
            Accept: application/json
            Authorization: Basic Zm9vQGJhci50bGQ6ZHVtbXktcGFzc3dvcmQ=
            """
        }
    }

    @Test func unstarEntryRequest() throws {
        let endpoint = try Self.api.unstarEntry(itemIdentifier: 456)
        assertInlineSnapshot(of: endpoint.request, as: .raw(pretty: true)) {
            """
            DELETE https://api.feedbin.com/v2/starred_entries.json
            Accept: application/json
            Authorization: Basic Zm9vQGJhci50bGQ6ZHVtbXktcGFzc3dvcmQ=
            Content-Type: application/json

            {
              "starred_entries" : [
                456
              ]
            }
            """
        }
    }

    // MARK: - Response decoding

    @Test func decodesStarredEntriesResponse() throws {
        let json = Data("[1, 42, 2080]".utf8)
        let decoded = try JSONDecoder().decode(FeedbinStarredEntriesEndpoint.Response.self, from: json)
        #expect(decoded == [1, 42, 2080])
    }

    @Test func decodesEmptyStarredEntriesResponse() throws {
        let json = Data("[]".utf8)
        let decoded = try JSONDecoder().decode(FeedbinStarredEntriesEndpoint.Response.self, from: json)
        #expect(decoded.isEmpty)
    }

    @Test func decodesFeedbinEntry() throws {
        let json = Data(
            """
            [
              {
                "id": 2080,
                "feed_id": 42,
                "url": "https://example.com/post",
                "created_at": "2026-05-21T08:00:00.000000Z",
                "title": "Hello, World",
                "summary": "A short summary.",
                "content": "<p>Hi there.</p>"
              }
            ]
            """.utf8
        )

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decoded = try decoder.decode(FeedbinEntriesEndpoint.Response.self, from: json)

        try #require(decoded.count == 1)
        let entry = decoded[0]
        #expect(entry.id == 2080)
        #expect(entry.feedId == 42)
        #expect(entry.url == "https://example.com/post")
        #expect(entry.createdAt == "2026-05-21T08:00:00.000000Z")
        #expect(entry.title == "Hello, World")
        #expect(entry.summary == "A short summary.")
        #expect(entry.content == "<p>Hi there.</p>")
    }

    // MARK: - Request body encoding round-trip

    @Test func unstarRequestBodyEncodesToSnakeCase() throws {
        let body = FeedbinUnstarEntryEndpoint.RequestBody(starredEntries: [456])

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = [.sortedKeys]
        let data = try encoder.encode(body)

        let json = try #require(String(data: data, encoding: .utf8))
        #expect(json == #"{"starred_entries":[456]}"#)
    }

    @Test func unstarRequestBodyRoundTripsThroughSnakeCase() throws {
        let original = FeedbinUnstarEntryEndpoint.RequestBody(starredEntries: [1, 2, 3])

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let data = try encoder.encode(original)
        let roundTripped = try decoder.decode(FeedbinUnstarEntryEndpoint.RequestBody.self, from: data)

        #expect(roundTripped.starredEntries == original.starredEntries)
    }
}
