//
//  Dispatcher.swift
//  TMDB
//
//  Created by LAP15284 on 20/03/2024.
//

import Foundation

public struct Target {
    var host: String
    var header: [String: String] = [:]
    var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringCacheData
    
    init(host: String) {
        self.host = host
    }
}

public protocol Dispatcher {
    init(target: Target)
    func execute(request: Request,
                 response: @escaping ((_ response: Response)->Void)) throws
    func cancel()
}
