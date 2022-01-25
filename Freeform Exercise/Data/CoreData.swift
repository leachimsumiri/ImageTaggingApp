//
//  CoreData.swift
//  Freeform Exercise
//
//  Created by Michael Irimus on 24.01.22.
//

import Foundation
import UIKit

class CoreData {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveImage(data: Data, keywords: [Keyword]) {
        //let entityName =  NSEntityDescription.entity(forEntityName: "Image", in: context)!
        //let image = NSManagedObject(entity: entityName, insertInto: context)
        //image.setValue(data, forKeyPath: "storedImage")
        
        let newImage = Image(context: self.context)
        newImage.storedImage = data
        
        keywords.forEach { keyword in
            let newKeyword = KeywordData(context: self.context)
            newKeyword.name = keyword.keyword
            newKeyword.percentage = keyword.score
            
            newImage.addToImageKeywords(newKeyword)
        }
        
        do {
            try context.save()
            print("saved image with keywords!")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    func fetchImagesFromCoreData() -> [Image]? {
        do {
            return try context.fetch(Image.fetchRequest())
        } catch {
            print("error fetching images from CoreData")
            return nil // questionable
        }
    }
    
    func fetchKeywordsFromCoreData() -> [KeywordData]? {
        do {
            return try context.fetch(KeywordData.fetchRequest())
        } catch {
            print("error fetching keywords from CoreData")
            return nil // questionable
        }
    }
}
