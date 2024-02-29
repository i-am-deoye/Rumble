// The Swift Programming Language
// https://docs.swift.org/swift-book



public class Rumble {
    public static let sdk = Rumble()
    
    public var configuration: Configuration?
    
    private init() {}
    
    
    public struct Configuration {
        public var authenticatedKey: String
        public var sslResource: String
        public var coredataResource: String
        public var headers: HTTPClient.HTTPHeaders
        
        
        public init(authenticatedKey: String = "",
                    sslResource: String = "",
                    coredataResource: String = "",
                    headers: HTTPClient.HTTPHeaders = HTTPClient.HTTPHeaders.init()) {
            self.sslResource = sslResource
            self.coredataResource = coredataResource
            self.headers = headers
            self.authenticatedKey = authenticatedKey
        }
    }
}
