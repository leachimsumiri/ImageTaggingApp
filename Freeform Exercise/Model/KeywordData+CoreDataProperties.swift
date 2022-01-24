//
//  KeywordData+CoreDataProperties.swift
//  Freeform Exercise
//
//  Created by Michael Irimus on 24.01.22.
//
//

import Foundation
import CoreData


extension KeywordData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<KeywordData> {
        return NSFetchRequest<KeywordData>(entityName: "KeywordData")
    }

    @NSManaged public var name: String?
    @NSManaged public var percentage: Double
    @NSManaged public var keywordImages: NSSet?

}

// MARK: Generated accessors for keywordImages
extension KeywordData {

    @objc(addKeywordImagesObject:)
    @NSManaged public func addToKeywordImages(_ value: Image)

    @objc(removeKeywordImagesObject:)
    @NSManaged public func removeFromKeywordImages(_ value: Image)

    @objc(addKeywordImages:)
    @NSManaged public func addToKeywordImages(_ values: NSSet)

    @objc(removeKeywordImages:)
    @NSManaged public func removeFromKeywordImages(_ values: NSSet)

}

extension KeywordData : Identifiable {

}
