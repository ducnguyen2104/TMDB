//
//  MovieRequest.swift
//  TMDB
//
//  Created by LAP15284 on 20/03/2024.
//

import Foundation

enum MovieRequest: Request {
    case get_list_trending(page: Int)
    case get_detail(movId: Int)
    case search(kw: String, page: Int)
    
    var path: String {
        switch self {
        case .get_list_trending:
            return "/3/trending/movie/day"
        case .get_detail(let movId):
            return "/3/movie/\(movId)"
        case .search:
            return "/3/search/movie"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .get_list_trending(let page):
            return .url(["page" : page])
        case .get_detail:
            return .url([:])
        case .search(let kw, let page):
            return .url(["query" : kw,
                         "page" : page])
        }
    }
}
