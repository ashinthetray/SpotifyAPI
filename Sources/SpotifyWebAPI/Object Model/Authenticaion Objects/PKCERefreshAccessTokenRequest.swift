import Foundation

/**
 Used during the [Authorization Code Flow with Proof Key for Code Exchange][1]
 to retrieve a new access token and refresh token using the refresh token.

 Unlike the Authorization Code Flow, a refresh token that has been obtained using
 the Authorization Code Flow with Proof Key for Code Exchange can be exchanged
 for an access token only once, after which it becomes invalid. This implies that
 Spotify should always return a new refresh token in addition to an access token.
 
 [1]: https://developer.spotify.com/documentation/general/guides/authorization-guide/#authorization-code-flow-with-proof-key-for-code-exchange-pkce
 */
public struct PKCERefreshAccessTokenRequest: Hashable {
    
    public let grantType = "refresh_token"
    public let refreshToken: String
    public let clientId: String
    
    public init(refreshToken: String, clientId: String) {
        self.refreshToken = refreshToken
        self.clientId = clientId
    }
    
    public func formURLEncoded() -> Data {
        
        guard let data = [
            CodingKeys.grantType.rawValue: self.grantType,
            CodingKeys.refreshToken.rawValue: self.refreshToken,
            CodingKeys.clientId.rawValue: self.clientId
        ].formURLEncoded()
        else {
            fatalError(
                "could not form-url-encode refresh tokens request"
            )
        }
        return data
    }
    
}

extension PKCERefreshAccessTokenRequest: Codable {

    public enum CodingKeys: String, CodingKey {
        case grantType = "grant_type"
        case refreshToken = "refresh_token"
        case clientId = "client_id"
    }
    
}
