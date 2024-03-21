//
//  Request.swift
//  TMDB
//
//  Created by LAP15284 on 20/03/2024.
//

import Foundation

public enum ResponseDataType {
    case JSON
    case Data
}

public enum HTTPMethod: String {
    case get, post, put, patch, delete
}

public enum RequestParams {
    case body(_ : [String: Any]?)
    case url(_ : [String: Any]?)
}

public protocol Request {
    var path            : String            { get }
    var method          : HTTPMethod        { get }
    var parameters      : RequestParams        { get }
    var headers         : [String: String]? { get }
    var responseType    : ResponseDataType    { get }
}

extension Request {
    var method          : HTTPMethod        { return .get }
    var parameters      : RequestParams        { return .url(nil) }
    var headers         : [String: String]? { return nil }
    var responseType    : ResponseDataType  { return .JSON }
}
