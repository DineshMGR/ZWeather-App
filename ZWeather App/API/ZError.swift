//
//  ZError.swift
//  ZWeather App
//
//  Created by Dinesh G on 06/01/24.
//

import Foundation

public class ZError : Error {
    
    /// Identifies the event kind which triggered LeadError.
    public enum ErrorType {
        case
        /// No internet, cannot communicate to the server.
        network,
        /// HTTP status code 403 was received from the server.
        unauthenticated,
        /// A non-200 HTTP status code was received from the server.
        http,
        /// All other errors
        unexpected
    }
    
    /// HTTP status code for error.
    public let statusCode: Int
    
    /// Human readable message which corresponds to the error.
    public var message: String?
    
    public var response: HTTPURLResponse?
    
    /// Identifies the event kind which triggered this error
    public var type: ErrorType
    
    public init(message: String? = nil, response: HTTPURLResponse? = nil, type: ErrorType) {
        self.statusCode = response?.statusCode ?? -1
        self.message = message
        self.response = response
        self.type = type
    }
}
