//
//  ConfigRequest.swift
//  TMDB
//
//  Created by LAP15284 on 20/03/2024.
//

import Foundation

enum ConfigRequest: Request {
    case get_config
    
    var path: String {
        switch self {
        case .get_config:
            return "/3/configuration"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .get_config:
            return .url([:])
        }
    }
}
