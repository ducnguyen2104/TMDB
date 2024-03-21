//
//  MovieDetailLocal+CoreDataProperties.swift
//  
//
//  Created by LAP15284 on 21/03/2024.
//
//

import Foundation
import CoreData


extension MovieDetailLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieDetailLocal> {
        return NSFetchRequest<MovieDetailLocal>(entityName: "MovieDetailLocal")
    }

    @NSManaged public var backdrop: String?
    @NSManaged public var overview: String?
    @NSManaged public var budget: Int64
    @NSManaged public var revenue: Int64
    @NSManaged public var genres: NSObject?
    @NSManaged public var homepage: String?
    @NSManaged public var popularity: Float
    @NSManaged public var productionCompanies: NSObject?
    @NSManaged public var productionCountries: NSObject?
    @NSManaged public var duration: Int64
    @NSManaged public var languages: NSObject?
    @NSManaged public var status: String?
    @NSManaged public var tagline: String?
    @NSManaged public var voteCount: Int64
    @NSManaged public var collection: MovieCollectionLocal?

}
