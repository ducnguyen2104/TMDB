//
//  MovieCollectionLocal+CoreDataProperties.swift
//  
//
//  Created by LAP15284 on 21/03/2024.
//
//

import Foundation
import CoreData


extension MovieCollectionLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieCollectionLocal> {
        return NSFetchRequest<MovieCollectionLocal>(entityName: "MovieCollectionLocal")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var poster: String?
    @NSManaged public var backdrop: String?

}
