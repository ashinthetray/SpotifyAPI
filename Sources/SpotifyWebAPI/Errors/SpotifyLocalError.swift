import Foundation


/**
 An error that is not directly produced by the Spotify web API.
 
 For example if you try to make an API request but have not
 authorized your application yet, you will get a `.unauthorized(String)`
 error, which is thrown before any network requests are even made.
 
 Consider using the `localizedDescription` of this error for more
 a more detailed description.
 */
public enum SpotifyLocalError: LocalizedError {
    
    /// You tried to access an endpoint that requires authorization,
    /// but you have not authorized your app yet.
    case unauthorized(String)
    
    /**
     Thrown if the value provided for the state parameter when you requested
     access and refresh tokens didn't match the value returned from spotify
     in the query string of the redirect URI.
     
     - supplied: The value supplied in `AuthorizationCodeFlowManager.requestAccessAndRefreshTokens(redirectURIWithQuery:state:)`.
     - received: The value in the query string of the redirect URI.
     */
    case invalidState(supplied: String?, received: String?)
    
    
    /// A [Spotify identifier][1] (URI, ID, URL) of a specific type
    /// could not be parsed. The message will contain more information.
    ///
    /// [1]: https://developer.spotify.com/documentation/web-api/#spotify-uris-and-ids
    case identifierParsingError(String)

    /// You tried to access an endpoint that
    /// your app does not have the required scopes for.
    ///
    /// - requiredScopes: The scopes that are required for this endpoint.
    /// - authorizedScopes: The scopes that your app is authroized for.
    case insufficientScope(
        requiredScopes: Set<Scope>, authorizedScopes: Set<Scope>
    )
    
    /// The type of a URI didn't match one of the expected types.
    ///
    /// For example, if you pass a track URI to the endpoint for retrieving
    /// an artist, you will get this error.
    case invalidURIType(
        expected: [IDCategory], received: IDCategory
    )
    
    /**
     Spotify sometimes returns data wrapped in
     an extraneous top-level dictionary that
     the client doesn't need to care about.
     This error is thrown if the expected top level
     key associated with the data is not found.
     
     For example, adding a tracks to a playlist returns
     the following response:
     ```
     { "snapshot_id" : "3245kj..." }
     ```
     The value of the snapshot id is returned instead
     of the entire dictionary or this error is thrown if it
     can't be found.
     */
    case topLevelKeyNotFound(
        key: String, dict: [AnyHashable: Any]
    )
    
    /// Some other error.
    case other(String)
    
    public var errorDescription: String? {
        switch self {
             case .unauthorized(let message):
                return "\(message)"
            case .invalidState(let supplied, let received):
                return """
                    The value for the state parameter provided when \
                    requesting access and refresh tokens '\(supplied ?? "nil")'
                    did not match the value in the query string of the \
                    redirect URI:
                    '\(received ?? "nil")'
                    """
            case .identifierParsingError(_):
                return "identifier parsing error: \(self)"
            case .insufficientScope(let required, let authorized):
                return """
                    The endpoint you tried to access \
                    requires the following scopes:
                    \(required.map(\.rawValue))
                    but your app is only authorized for theses scopes:
                    \(authorized.map(\.rawValue))
                    """
            case .invalidURIType(let expected, let received):
                return """
                    expected URI to be one of the following types: \
                    \(expected.map(\.rawValue)),
                    but received \(received.rawValue)
                    """
            case .topLevelKeyNotFound(key: let key, dict: let dict):
                return """
                    The expected top level key '\(key)' \
                    was not found in the dictionary:
                    \(dict)
                    """
            case .other(let message):
                return "\(message)"
        }
    }
  
}


