// ----------------------------------------------------------------------------
//
//  HTTPRequestExecutorError.swift
//
//  @author Denis Kolyasev <kolyasev@gmail.com>
//
// ----------------------------------------------------------------------------

import Foundation

public struct HTTPRequestExecutorError: RequestExecutorError {
// MARK: - Construction

    public init(error: HTTPClientError, request: HTTPRequest, response: HTTPResponse?) {
        self.init(reason: .httpClientError(error: error), request: request, response: response)
    }

    public init(error: HTTPRequestError, request: HTTPRequest, response: HTTPResponse?) {
        self.init(reason: .httpRequestError(error: error), request: request, response: response)
    }

    public init(error: HTTPResponseError, request: HTTPRequest, response: HTTPResponse?) {
        self.init(reason: .httpResponseError(error: error), request: request, response: response)
    }

    init(reason: Reason, request: HTTPRequest, response: HTTPResponse?) {
        self.reason = reason
        self.request = request
        self.response = response
    }

// MARK: - Properties

    public let reason: Reason

    public let request: HTTPRequest

    public let response: HTTPResponse?

// MARK: - Inner Types

    public enum Reason {
        case httpClientError(error: HTTPClientError)
        case httpRequestError(error: HTTPRequestError)
        case httpResponseError(error: HTTPResponseError)
    }

}

// ----------------------------------------------------------------------------

open class NestedError<T: Error>: LocalizedError {
// MARK: - Construction

    public init(cause: T?) {
        self.cause = cause
    }

// MARK: - Properties

    public let cause: T?
    
    public var errorDescription: String? {
        cause?.localizedDescription
    }
}

// ----------------------------------------------------------------------------

extension NestedError: CustomStringConvertible, CustomDebugStringConvertible {
// MARK: - Properties

    public var description: String {
        let cause = (self.cause != nil) ? String(describing: self.cause!) : "nil"
        return "\(type(of: self))(cause: \(cause))"
    }

    public var debugDescription: String {
        return self.description
    }

}

// ----------------------------------------------------------------------------

public protocol HTTPClientError: Error { }

// ----------------------------------------------------------------------------

public protocol HTTPRequestError: Error { }

open class HTTPRequestSerializationError: NestedError<Error>, HTTPRequestError { }

// ----------------------------------------------------------------------------

public protocol HTTPResponseError: Error { }

open class HTTPResponseSerializationError: NestedError<Error>, HTTPResponseError { }
open class HTTPResponseStatusCodeError: NestedError<Error>, HTTPResponseError { }

// ----------------------------------------------------------------------------
