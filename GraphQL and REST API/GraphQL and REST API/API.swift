//
//  API.swift
//  GraphQL and REST API
//
//  Created by aryzae on 2020/04/02.
//  Copyright © 2020 aryzae. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(T)
    case failure(Error)
}

public final class API: NSObject {
    public typealias RequestCount = Int
    public typealias Completion<T: Requestable> = ((Result<T.Response>, RequestCount) -> Void)

    public static let shared = API()

    private var configuration: URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.urlCache = nil
        return config
    }

    private override init() {}
}

extension API {
    @discardableResult
    public func request<T: Requestable>(_ request: T, requestCount: RequestCount = 1, completion: @escaping Completion<T>) -> URLSessionDataTask {
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request.buildURLRequest()) { (data, response, error) in
            defer { session.finishTasksAndInvalidate() }

            let result: Result<T.Response>
            switch (response.statusCode, data, error) {
            case (200, let data?, _),
                 (400...503, let data?, _):
                do {
                    let decode = try request.decode(data: data)
                    result = .success(decode)
                } catch {
                    result = .failure(error)
                }
            case (400...503, _, let error?):
                result = .failure(error)
            default:
                guard let error = error else {
                    fatalError("unknown")
                }
                result = .failure(error)
            }
            completion(result, requestCount)
        }
        defer { task.resume() }
        return task
    }
}

private extension Optional where Wrapped == URLResponse {
    var statusCode: Int {
        return (self as? HTTPURLResponse)?.statusCode ?? -99999
    }
}
