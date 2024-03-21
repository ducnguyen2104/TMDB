//
//  ConfigResponse.swift
//  TMDB
//
//  Created by LAP15284 on 20/03/2024.
//

import Foundation
import SwiftyJSON

class ConfigResponse: NSObject {
    let imageBaseUrl: String
    let posterSizes: [String]
    
    init(withJson json: JSON) {
        self.imageBaseUrl = json["images"]["secure_base_url"].stringValue
        self.posterSizes = json["images"]["poster_sizes"].arrayValue.map { $0.stringValue }
    }
}
