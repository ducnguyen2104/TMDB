//
//  MovieLocal+CoreDataProperties.swift
//  
//
//  Created by LAP15284 on 21/03/2024.
//
//

import Foundation
import CoreData


extension MovieLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieLocal> {
        return NSFetchRequest<MovieLocal>(entityName: "MovieLocal")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var poster: String?
    @NSManaged public var date: String?
    @NSManaged public var voteAvg: Float

}
