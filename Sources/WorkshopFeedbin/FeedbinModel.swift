import Foundation

/// The unique identifier used by Feedbin for entries (RSS items).
///
/// Feedbin's API represents item identifiers as integers throughout its responses
/// — for example in the `/v2/starred_entries.json` payload, which returns a bare
/// JSON array of integers.
///
/// 📜 https://github.com/feedbin/feedbin-api/blob/master/content/starred-entries.md
public typealias FeedbinItemIdentifier = Int

/// An entry (RSS item) returned by the Feedbin API.
///
/// 📜 https://github.com/feedbin/feedbin-api/blob/master/content/entries.md
public struct FeedbinEntry: Codable, Sendable {
  /// The unique identifier of the entry within Feedbin.
  public let id: FeedbinItemIdentifier

  /// The identifier of the feed this entry belongs to.
  public let feedId: Int

  /// The canonical URL of the entry on the publisher's website.
  public let url: String

  /// The date the entry was created in Feedbin, as an ISO 8601 string.
  public let createdAt: String

  /// The entry's title.
  public let title: String

  /// A short summary of the entry's content.
  public let summary: String

  /// The full HTML content of the entry.
  public let content: String

  public init(
    id: FeedbinItemIdentifier,
    feedId: Int,
    url: String,
    createdAt: String,
    title: String,
    summary: String,
    content: String
  ) {
    self.id = id
    self.feedId = feedId
    self.url = url
    self.createdAt = createdAt
    self.title = title
    self.summary = summary
    self.content = content
  }
}
