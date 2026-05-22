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

  /// The URL of Feedbin's content extraction service for this entry. It points
  /// to a Mercury Parser-formatted JSON payload with the full article content.
  public let extractedContentUrl: String

  /// The date the entry was published by the source feed, as an ISO 8601 string.
  public let published: String

  /// The date the entry was created in Feedbin, as an ISO 8601 string.
  public let createdAt: String

  /// The entry's title. May be `nil` — Feedbin documents that `title` can be null.
  public let title: String?

  /// The entry's author. May be `nil` — Feedbin documents that `author` can be null.
  public let author: String?

  /// A short summary of the entry's content. May be empty, but is never null.
  public let summary: String

  /// The full HTML content of the entry. May be `nil` — Feedbin documents that
  /// `content` can be null.
  public let content: String?

  public init(
    id: FeedbinItemIdentifier,
    feedId: Int,
    url: String,
    extractedContentUrl: String,
    published: String,
    createdAt: String,
    title: String?,
    author: String?,
    summary: String,
    content: String?
  ) {
    self.id = id
    self.feedId = feedId
    self.url = url
    self.extractedContentUrl = extractedContentUrl
    self.published = published
    self.createdAt = createdAt
    self.title = title
    self.author = author
    self.summary = summary
    self.content = content
  }
}
