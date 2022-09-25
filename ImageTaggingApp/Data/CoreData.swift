//
//  CoreData.swift
//  Freeform Exercise
//
//  Created by Michael Irimus on 24.01.22.
//

import Foundation
import UIKit
import CoreData

class CoreData {
    static let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    static var context: NSManagedObjectContext = persistentContainer.viewContext
    
    static func saveImage(data: Data, keywords: [Keyword]) -> Bool {
        let keywordDatas = fetchKeywordsFromCoreData()
        
        guard let keywordDatas = keywordDatas else {
            print("Could not retrieve Keywords while saving Image")
            return false
        }
        
        let newImage = Image(context: context)
        newImage.storedImage = data
        
        for keyword in keywords {
            let existingKeywordData = keywordExists(keywordDatas: keywordDatas, keyword: keyword)
            if let existingKeywordData = existingKeywordData {
                newImage.addToImageKeywords(existingKeywordData)
            } else {
                let newKeyword = KeywordData(context: context)
                newKeyword.name = keyword.keyword
                newKeyword.percentage = keyword.score
                
                newImage.addToImageKeywords(newKeyword)
            }
        }
        
        do {
            try context.save()
            print("saved image with keywords!")
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    static func fetchKeywordsFromCoreData() -> [KeywordData]? {
        do {
            return try context.fetch(KeywordData.fetchRequest())
        } catch {
            print("error fetching keywords from CoreData")
            return nil
        }
    }
    
    // MARK: for testing
    static func resetAllCoreData() {
        let entityNames = persistentContainer.managedObjectModel.entities.map({ $0.name!})
        entityNames.forEach { entityName in
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            
            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print("error deleting all objects form coredata")
            }
        }
    }
    
    static func keywordExists(keywordDatas: [KeywordData], keyword: Keyword) -> KeywordData? {
        var existingKeywordData: KeywordData? = nil
        
        keywordDatas.forEach { keywordData in
            if (keyword.keyword == keywordData.name) {
                existingKeywordData = keywordData
            }
        }
        
        return existingKeywordData
    }
    
    static func getKeywordsByName(name: String) -> [KeywordData]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "KeywordData")
        fetchRequest.predicate = NSPredicate(format: "name = \(name)")
        
        do {
            return try context.fetch(fetchRequest) as? [KeywordData]
        } catch let error as NSError {
            print("error fetching keyworddata with specific name: \(name)")
            print("error: \(error)")
            return nil
        }
    }
}
