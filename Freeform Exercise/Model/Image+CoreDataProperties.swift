//
//  Image+CoreDataProperties.swift
//  Freeform Exercise
//
//  Created by Michael Irimus on 11.01.22.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var storedImage: Data?

}

extension Image : Identifiable {

}
