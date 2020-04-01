
//
//  Requestable.swift
//  GraphQL and REST API
//
//  Created by aryzae on 2020/04/01.
//  Copyright © 2020 aryzae. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
}

public struct NoResponse: Decodable {}

public protocol Requestable {
    associatedtype Response: Decodable
    var autoRetryTimes: Int { get }
    var timeoutSeconds: TimeInterval { get }
    var isSecure: Bool { get }
    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: Any] { get }
    var header: [String: String] { get }
    func buildURLRequest() -> URLRequest
    func convertParameters() -> [URLQueryItem]
    func decode(data: Data) throws -> Response
}

extension Requestable {
    /// APIServiceを使用しているModelのみ影響がある
    public var autoRetryTimes: Int {
        return 3    // default
    }

    public var timeoutSeconds: TimeInterval {
        return 30
    }

    public var isSecure: Bool {
        return true
    }

    public var baseURL: URL {
        let prefix = isSecure ? "https://" : "http://"
        guard let url = URL(string: prefix + "api.github.com") else {
            fatalError("invalid url.")
        }
        return url
    }

    public var parameters: [String: Any] {
        return [:]
    }

    public var header: [String: String] {
        return [:]
    }

    public func buildURLRequest() -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            fatalError("invalid url")
        }
        components.queryItems = convertParameters()

        var urlRequest = URLRequest(url: url)
        urlRequest.url = components.url
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = timeoutSeconds
        header.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
        return urlRequest
    }

    public func convertParameters() -> [URLQueryItem] {
        return parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
    }

    public func decode(data: Data) throws -> Response {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(Response.self, from: data)
    }
}
