//
//  ImageLocal+CoreDataProperties.swift
//  
//
//  Created by LAP15284 on 21/03/2024.
//
//

import Foundation
import CoreData


extension ImageLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageLocal> {
        return NSFetchRequest<ImageLocal>(entityName: "ImageLocal")
    }

    @NSManaged public var data: Data?
    @NSManaged public var path: String?

}
