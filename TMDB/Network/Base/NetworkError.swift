//
//  NetworkError.swift
//  TMDB
//
//  Created by LAP15284 on 20/03/2024.
//

import Foundation

public enum NetworkError: Error {
    case badInput
    case noData
    case noConnection
    case timeOut
    case serverError(statusCode: Int)
}
