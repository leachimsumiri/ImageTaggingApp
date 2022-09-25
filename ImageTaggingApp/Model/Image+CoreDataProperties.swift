//
//  Image+CoreDataProperties.swift
//  Freeform Exercise
//
//  Created by Michael Irimus on 24.01.22.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var storedImage: Data?
    @NSManaged public var imageKeywords: NSSet?

}

// MARK: Generated accessors for imageKeywords
extension Image {

    @objc(addImageKeywordsObject:)
    @NSManaged public func addToImageKeywords(_ value: KeywordData)

    @objc(removeImageKeywordsObject:)
    @NSManaged public func removeFromImageKeywords(_ value: KeywordData)

    @objc(addImageKeywords:)
    @NSManaged public func addToImageKeywords(_ values: NSSet)

    @objc(removeImageKeywords:)
    @NSManaged public func removeFromImageKeywords(_ values: NSSet)

}

extension Image : Identifiable {

}
