//
//  ListMovieResponse.swift
//  TMDB
//
//  Created by LAP15284 on 20/03/2024.
//

import Foundation
import SwiftyJSON

class ListMovieResponse: NSObject {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results: [Movie]
    
    init(withJson json: JSON) {
        self.page = json["page"].intValue
        self.totalPages = json["total_pages"].intValue
        self.totalResults = json["total_results"].intValue
        self.results = json["results"].arrayValue.map { Movie(withJson: $0) }
    }
}
