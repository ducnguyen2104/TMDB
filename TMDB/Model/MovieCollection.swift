//
//  MovieCollection.swift
//  TMDB
//
//  Created by LAP15284 on 20/03/2024.
//

import Foundation
import SwiftyJSON

class MovieCollection: NSObject {
    let id: Int
    let name: String
    let poster: String
    let backdrop: String
    
    init(withJson json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.poster = json["poster_path"].stringValue
        self.backdrop = json["backdrop_path"].stringValue
    }
    
    init(localObject: MovieCollectionLocal) {
        self.id = Int(localObject.id)
        self.name = localObject.name ?? ""
        self.poster = localObject.poster ?? ""
        self.backdrop = localObject.backdrop ?? ""
    }
}
