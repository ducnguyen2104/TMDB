//
//  MovieDetail.swift
//  TMDB
//
//  Created by LAP15284 on 20/03/2024.
//

import Foundation
import SwiftyJSON

class MovieDetail: Movie {
    
    let backdrop: String
    let overview: String
    let collection: MovieCollection?
    let budget: Int
    let revenue: Int
    let genres: [String]
    let homepage: String
    let popularity: Float
    let productionCompanies: [String]
    let productionCountries: [String]
    let duration: Int
    let languages: [String]
    let status: String
    let tagline: String
    let voteCount: Int
    
    override init(withJson json: JSON) {
        self.backdrop = json["backdrop_path"].stringValue
        if json["belongs_to_collection"].exists() && json["belongs_to_collection"] != JSON.null {
            self.collection = MovieCollection(withJson: json["belongs_to_collection"])
        } else {
            self.collection = nil
        }
        self.budget = json["budget"].intValue
        self.genres = json["genres"].arrayValue.map { $0["name"].stringValue }
        self.homepage = json["homepage"].stringValue
        self.overview = json["overview"].stringValue
        self.popularity = json["popularity"].floatValue
        self.productionCompanies = json["production_companies"].arrayValue.map { $0["name"].stringValue }
        self.productionCountries = json["production_countries"].arrayValue.map { $0["name"].stringValue }
        self.revenue = json["revenue"].intValue
        self.duration = json["runtime"].intValue
        self.languages = json["spoken_languages"].arrayValue.map { $0["english_name"].stringValue }
        self.status = json["status"].stringValue
        self.tagline = json["tagline"].stringValue
        self.voteCount = json["vote_count"].intValue
        super.init(withJson: json)
    }
    
    func makeSummaryString() -> String {
        return
"""
\(overview)
Release date: \(date)
Rating: \(voteAvg) (\(voteCount) votes)
Budget: \(budget)
Revenue: \(revenue)
Genres: \(genres.joined(separator: ", "))
Homepage: \(homepage)
Popularity: \(popularity)
Production companies: \(productionCompanies.joined(separator: ", "))
Production countries: \(productionCountries.joined(separator: ", "))
Durartion: \(duration)
Languages: \(languages.joined(separator: ", "))
Status: \(status)
Tagline: \(tagline)
"""
    }
    
    init(localObject: MovieDetailLocal) {
        self.backdrop = localObject.backdrop ?? ""
        self.overview = localObject.overview ?? ""
        if let localCollection = localObject.collection {
            self.collection = MovieCollection(localObject: localCollection)
        } else {
            self.collection = nil
        }
        self.budget = Int(localObject.budget)
        self.revenue = Int(localObject.revenue)
        self.genres = localObject.genres as? [String] ?? [ ]
        self.homepage = localObject.homepage ?? ""
        self.popularity = localObject.popularity
        self.productionCompanies = localObject.productionCompanies as? [String] ?? [ ]
        self.productionCountries = localObject.productionCountries as? [String] ?? [ ]
        self.duration = Int(localObject.duration)
        self.languages = localObject.languages as? [String] ?? [ ]
        self.status = localObject.status ?? ""
        self.tagline = localObject.tagline ?? ""
        self.voteCount = Int(localObject.voteCount)
        super.init(localObject: localObject)
    }
}
