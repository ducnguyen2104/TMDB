//
//  Movie.swift
//  TMDB
//
//  Created by LAP15284 on 20/03/2024.
//

import Foundation
import SwiftyJSON

class Movie: NSObject {
    let id: Int
    let title: String
    let poster: String
    let date: String
    let voteAvg: Float

    init(withJson json: JSON) {
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.poster = json["poster_path"].stringValue
        self.date = json["release_date"].stringValue
        self.voteAvg = json["vote_average"].floatValue
    }
    
    init(localObject: MovieLocal) {
        self.id = Int(localObject.id)
        self.title = localObject.title ?? ""
        self.poster = localObject.poster ?? ""
        self.date = localObject.date ?? ""
        self.voteAvg = localObject.voteAvg
    }
}
