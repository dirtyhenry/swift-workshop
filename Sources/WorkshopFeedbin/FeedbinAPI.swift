import Blocks
import Foundation

/// A client describing a subset of the [Feedbin REST API](https://github.com/feedbin/feedbin-api).
///
/// `FeedbinAPI` does not perform any networking on its own — it builds
/// `Endpoint` values that callers send through a `Blocks.Transport`
/// (e.g. `URLSession`), keeping the type fully testable.
///
/// All endpoints authenticate with HTTP Basic Authentication, as required by
/// the [Feedbin authentication docs](https://github.com/feedbin/feedbin-api/blob/master/content/authentication.md).
///
/// ## Usage
///
/// ```swift
/// let feedbinAPI = try FeedbinAPI(username: "yourUsername", password: "yourPassword")
/// let starredItems = try await URLSession.shared.load(feedbinAPI.fetchStarredEntries())
/// ```
public struct FeedbinAPI: Sendable {
  let credentials: URLRequestHeaderItem

  /// Creates a Feedbin API client authenticated with HTTP Basic credentials.
  ///
  /// - Parameters:
  ///   - username: The Feedbin account username (typically an email address).
  ///   - password: The password associated with the provided username.
  ///
  /// - Throws: ``FeedbinAPIError/invalidCredentialsEncoding`` if the
  ///   credentials cannot be encoded as UTF-8 for the Basic auth header.
  public init(username: String, password: String) throws {
    credentials = URLRequestHeaderItem.basicAuthentication(
      username: username,
      password: password
    )
  }

  /// Builds an endpoint that fetches the identifiers of all starred entries
  /// for the authenticated user.
  ///
  /// The response is a JSON array of entry identifiers (integers). Use
  /// ``fetchEntry(itemIdentifier:)`` to retrieve the full entry payload for
  /// any of these identifiers.
  ///
  /// 📜 https://github.com/feedbin/feedbin-api/blob/master/content/starred-entries.md
  ///
  /// - Returns: An endpoint resolving to `[FeedbinItemIdentifier]`.
  public func fetchStarredEntries() throws -> Endpoint<FeedbinStarredEntriesEndpoint.Response> {
    let url = try URL.feedbinURLComponents(path: "/v2/starred_entries.json")
    let headers: [URLRequestHeaderItem] = [credentials]

    return Endpoint<FeedbinStarredEntriesEndpoint.Response>(json: .get, url: url, headers: headers)
  }

  /// Builds an endpoint that fetches a single entry by its identifier.
  ///
  /// Internally this calls the `GET /v2/entries.json?ids={id}` endpoint,
  /// which returns an array (always containing at most one element when a
  /// single identifier is requested).
  ///
  /// 📜 https://github.com/feedbin/feedbin-api/blob/master/content/entries.md
  ///
  /// - Parameter itemIdentifier: The identifier of the entry to fetch.
  /// - Returns: An endpoint resolving to `[FeedbinEntry]`.
  public func fetchEntry(
    itemIdentifier: FeedbinItemIdentifier
  ) throws -> Endpoint<FeedbinEntriesEndpoint.Response> {
    let url = try URL.feedbinURLComponents(path: "/v2/entries.json")
    let headers: [URLRequestHeaderItem] = [credentials]
    let query: [URLQueryItem] = [
      .init(name: "ids", value: itemIdentifier.description)
    ]

    return Endpoint<FeedbinEntriesEndpoint.Response>(
      json: .get,
      url: url,
      headers: headers,
      query: query,
      decoder: Self.decoder()
    )
  }

  /// Builds an endpoint that removes the "starred" status from a single entry.
  ///
  /// Sends `DELETE /v2/starred_entries.json` with a JSON body of the form
  /// `{ "starred_entries": [<id>] }`, as documented by Feedbin.
  ///
  /// 📜 https://github.com/feedbin/feedbin-api/blob/master/content/starred-entries.md
  ///
  /// - Parameter itemIdentifier: The identifier of the entry to unstar.
  /// - Returns: An endpoint resolving to `Void` once the request succeeds.
  public func unstarEntry(
    itemIdentifier: FeedbinItemIdentifier
  ) throws -> Endpoint<FeedbinUnstarEntryEndpoint.Response> {
    let url = try URL.feedbinURLComponents(path: "/v2/starred_entries.json")
    let headers: [URLRequestHeaderItem] = [credentials]

    return Endpoint<FeedbinUnstarEntryEndpoint.Response>(
      json: .delete,
      url: url,
      body: FeedbinUnstarEntryEndpoint.RequestBody(
        starredEntries: [itemIdentifier]
      ),
      headers: headers,
      encoder: Self.encoder()
    )
  }

  private static func encoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    return encoder
  }

  private static func decoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }
}

/// Errors thrown by ``FeedbinAPI`` when constructing endpoints.
public enum FeedbinAPIError: Error, Sendable {
  /// The supplied username and password could not be encoded as UTF-8 for
  /// inclusion in the HTTP Basic authentication header.
  case invalidCredentialsEncoding
}

extension URL {
  static func feedbinURLComponents(path: String) throws -> URL {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.feedbin.com"
    urlComponents.path = path

    guard let url = urlComponents.url else {
      throw TransportError.unmetURLComponentsRequirements
    }

    return url
  }
}

/// Namespace describing the `GET /v2/starred_entries.json` endpoint.
///
/// 📜 https://github.com/feedbin/feedbin-api/blob/master/content/starred-entries.md
public enum FeedbinStarredEntriesEndpoint {
  /// The response is a JSON array of entry identifiers.
  public typealias Response = [FeedbinItemIdentifier]
}

/// Namespace describing the `GET /v2/entries.json` endpoint.
///
/// 📜 https://github.com/feedbin/feedbin-api/blob/master/content/entries.md
public enum FeedbinEntriesEndpoint {
  /// The response is a JSON array of entries.
  public typealias Response = [FeedbinEntry]
}

/// Namespace describing the `DELETE /v2/starred_entries.json` endpoint, which
/// removes the "starred" status from one or more entries.
///
/// 📜 https://github.com/feedbin/feedbin-api/blob/master/content/starred-entries.md
public enum FeedbinUnstarEntryEndpoint {
  /// The request body sent to the unstar endpoint.
  ///
  /// Serialized as `{ "starred_entries": [<id>, ...] }` once the snake_case
  /// key strategy is applied.
  public struct RequestBody: Codable, Sendable {
    public let starredEntries: [FeedbinItemIdentifier]

    public init(starredEntries: [FeedbinItemIdentifier]) {
      self.starredEntries = starredEntries
    }
  }

  /// The endpoint returns no body; success is signaled by the HTTP status code.
  public typealias Response = Void
}
